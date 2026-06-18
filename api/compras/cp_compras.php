<?php
/*
    Autor: Claudio Barto
    Data : 18/06/2026
*/
$aplicacao_nome = "cp_compras.php";
$aplicacao_descricao = "API para listar, inserir, editar e excluir pedidos de compra.";

require_once __DIR__ . '/../bootstrap.php';
api_require_login();

$action = (string) ($_GET['action'] ?? $_POST['action'] ?? 'list');
$data = request_data();

function cp_decimal($value): float
{
    if ($value === null || $value === '') {
        return 0.0;
    }
    return (float) str_replace(',', '.', (string) $value);
}

function cp_trim($value): string
{
    return trim((string) ($value ?? ''));
}

function cp_table_exists(string $table): bool
{
    $stmt = db()->prepare(
        'SELECT COUNT(*)
           FROM information_schema.TABLES
          WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = :table_name'
    );
    $stmt->execute(['table_name' => $table]);
    return (int) $stmt->fetchColumn() > 0;
}

function cp_columns(string $table): array
{
    if (!cp_table_exists($table)) {
        return [];
    }
    $stmt = db()->prepare(
        'SELECT COLUMN_NAME
           FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = :table_name
          ORDER BY ORDINAL_POSITION'
    );
    $stmt->execute(['table_name' => $table]);
    return array_map(static fn($row) => $row['COLUMN_NAME'], $stmt->fetchAll());
}

function cp_fornecedor_label_expression(string $alias): string
{
    $columns = cp_columns('produtos_fornecedor');
    $parts = [];
    foreach (['Nome', 'Fantasia', 'RazaoSocial', 'Descricao', 'descricao', 'Fornecedor'] as $column) {
        if (in_array($column, $columns, true)) {
            $parts[] = "NULLIF($alias.`$column`, '')";
        }
    }
    $parts[] = "CAST($alias.`Codigo` AS CHAR)";
    return 'COALESCE(' . implode(', ', $parts) . ')';
}

function cp_option_select(string $type, string $q): void
{
    $term = '%' . $q . '%';
    if ($type === 'empresas_cd') {
        $stmt = db()->prepare("SELECT Codigo AS id, NomeCD AS text FROM empresas_cd WHERE NomeCD LIKE :q ORDER BY NomeCD LIMIT 30");
        $stmt->execute(['q' => $term]);
        api_response(true, ['results' => $stmt->fetchAll()]);
    }

    if ($type === 'empresas') {
        $stmt = db()->prepare("SELECT Codigo AS id, COALESCE(NULLIF(Fantasia, ''), Nome) AS text FROM empresas WHERE Fantasia LIKE :q1 OR Nome LIKE :q2 ORDER BY text LIMIT 30");
        $stmt->execute(['q1' => $term, 'q2' => $term]);
        api_response(true, ['results' => $stmt->fetchAll()]);
    }

    if ($type === 'fornecedores') {
        if (!cp_table_exists('produtos_fornecedor')) {
            api_response(true, ['results' => []]);
        }
        $label = cp_fornecedor_label_expression('f');
        $stmt = db()->prepare("SELECT f.Codigo AS id, $label AS text FROM produtos_fornecedor f WHERE CAST(f.Codigo AS CHAR) LIKE :q_codigo OR $label LIKE :q_label ORDER BY text LIMIT 30");
        $stmt->execute(['q_codigo' => $term, 'q_label' => $term]);
        api_response(true, ['results' => $stmt->fetchAll()]);
    }

    api_response(false, ['message' => 'Tipo invalido.'], 404);
}

function cp_validate_header(array $payload): void
{
    foreach ([
        'cd_id' => 'CD',
        'empresa_id' => 'Empresa',
        'Fornecedor_id' => 'Fornecedor',
        'DataPedido' => 'Data Pedido',
    ] as $field => $label) {
        if (cp_trim($payload[$field] ?? '') === '') {
            api_response(false, ['message' => "Informe $label."], 422);
        }
    }
}

function cp_items_from_request(array $data): array
{
    $items = json_decode((string) ($data['items_json'] ?? '[]'), true);
    if (!is_array($items)) {
        api_response(false, ['message' => 'Itens invalidos.'], 422);
    }
    return $items;
}

function cp_header_payload(array $data): array
{
    return [
        'cd_id' => (int) ($data['cd_id'] ?? 0),
        'empresa_id' => (int) ($data['empresa_id'] ?? 0),
        'Fornecedor_id' => cp_trim($data['Fornecedor_id'] ?? ''),
        'DataPedido' => cp_trim($data['DataPedido'] ?? ''),
        'MarkupFranqueadora' => cp_decimal($data['MarkupFranqueadora'] ?? 0),
        'MarkupFranquia' => cp_decimal($data['MarkupFranquia'] ?? 0),
        'MarkupTotal' => cp_decimal($data['MarkupTotal'] ?? 0),
        'ValorTotalPedido' => cp_decimal($data['ValorTotalPedido'] ?? 0),
        'Sts' => cp_trim($data['Sts'] ?? 'Aberto') ?: 'Aberto',
        'TemFotos' => (int) ($data['TemFotos'] ?? 0),
        'StsMotivo' => cp_trim($data['StsMotivo'] ?? ''),
        'Localizacao' => cp_trim($data['Localizacao'] ?? 'KidStok') ?: 'KidStok',
    ];
}

function cp_load_pedido(int $id): ?array
{
    $fornecedorJoin = cp_table_exists('produtos_fornecedor')
        ? 'LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor_id'
        : '';
    $fornecedorLabel = cp_table_exists('produtos_fornecedor')
        ? cp_fornecedor_label_expression('f')
        : 'c.Fornecedor_id';

    $stmt = db()->prepare(
        "SELECT c.*,
                c.ID AS id,
                cd.NomeCD AS cd_id_text,
                COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_id_text,
                $fornecedorLabel AS Fornecedor_id_text
           FROM cp_compras c
           LEFT JOIN empresas_cd cd ON cd.Codigo = c.cd_id
           LEFT JOIN empresas e ON e.Codigo = c.empresa_id
           $fornecedorJoin
          WHERE c.ID = :id"
    );
    $stmt->execute(['id' => $id]);
    $pedido = $stmt->fetch();
    if (!$pedido) {
        return null;
    }

    $stmt = db()->prepare("SELECT * FROM cp_compras_itens WHERE cp_compras_id = :id ORDER BY ID");
    $stmt->execute(['id' => $id]);
    $items = $stmt->fetchAll();

    $detailStmt = db()->prepare(
        "SELECT d.*, COALESCE(p.percentual, 0) AS percentual
           FROM cp_compras_itens_detalhe d
           LEFT JOIN cp_compras_itens_percentuais p
             ON p.compras_itens_id = d.compras_itens_id
            AND p.tamanho = d.tamanho
            AND p.cor = d.cor
          WHERE d.compras_itens_id = :item_id
          ORDER BY d.tamanho ASC, d.cor ASC, d.ID ASC"
    );

    foreach ($items as &$item) {
        $detailStmt->execute(['item_id' => $item['ID']]);
        $item['detalhes'] = $detailStmt->fetchAll();
    }
    unset($item);

    $pedido['items'] = $items;
    return $pedido;
}

function cp_delete_children(int $pedidoId): void
{
    $stmt = db()->prepare(
        "DELETE p
           FROM cp_compras_itens_percentuais p
           JOIN cp_compras_itens i ON i.ID = p.compras_itens_id
          WHERE i.cp_compras_id = :pedido_id"
    );
    $stmt->execute(['pedido_id' => $pedidoId]);

    $stmt = db()->prepare("DELETE FROM cp_compras_itens WHERE cp_compras_id = :pedido_id");
    $stmt->execute(['pedido_id' => $pedidoId]);
}

function cp_save_items(int $pedidoId, array $items): void
{
    $itemStmt = db()->prepare(
        "INSERT INTO cp_compras_itens
            (cp_compras_id, referencia_fornecedor, descricao, composicao, ncm, entrega, total_qtde, total_produto, Foto, Sts)
         VALUES
            (:cp_compras_id, :referencia_fornecedor, :descricao, :composicao, :ncm, :entrega, :total_qtde, :total_produto, :Foto, :Sts)"
    );
    $detailStmt = db()->prepare(
        "INSERT INTO cp_compras_itens_detalhe
            (cp_compras_id, compras_itens_id, sku, tamanho, cor, Qtde, preco_fornecedor, preco_proposta,
             valor_total_produto, preco_franqueado, markup_franquia, preco_loja, markup_loja, markup_total, Sts)
         VALUES
            (:cp_compras_id, :compras_itens_id, :sku, :tamanho, :cor, :Qtde, :preco_fornecedor, :preco_proposta,
             :valor_total_produto, :preco_franqueado, :markup_franquia, :preco_loja, :markup_loja, :markup_total, :Sts)"
    );
    $percentStmt = db()->prepare(
        "INSERT INTO cp_compras_itens_percentuais
            (compras_itens_id, tamanho, cor, percentual)
         VALUES
            (:compras_itens_id, :tamanho, :cor, :percentual)
         ON DUPLICATE KEY UPDATE percentual = VALUES(percentual)"
    );

    foreach ($items as $item) {
        $detalhes = is_array($item['detalhes'] ?? null) ? $item['detalhes'] : [];
        if (cp_trim($item['referencia_fornecedor'] ?? '') === '' && cp_trim($item['descricao'] ?? '') === '' && !$detalhes) {
            continue;
        }

        $itemPayload = [
            'cp_compras_id' => $pedidoId,
            'referencia_fornecedor' => cp_trim($item['referencia_fornecedor'] ?? ''),
            'descricao' => cp_trim($item['descricao'] ?? ''),
            'composicao' => cp_trim($item['composicao'] ?? ''),
            'ncm' => cp_trim($item['ncm'] ?? ''),
            'entrega' => cp_trim($item['entrega'] ?? '') ?: null,
            'total_qtde' => cp_decimal($item['total_qtde'] ?? 0),
            'total_produto' => cp_decimal($item['total_produto'] ?? 0),
            'Foto' => (int) ($item['Foto'] ?? 0),
            'Sts' => (int) ($item['Sts'] ?? 1),
        ];
        $itemStmt->execute($itemPayload);
        $itemId = (int) db()->lastInsertId();

        foreach ($detalhes as $detail) {
            $tamanho = cp_trim($detail['tamanho'] ?? '');
            $cor = cp_trim($detail['cor'] ?? '');
            if ($tamanho === '' && $cor === '' && cp_trim($detail['sku'] ?? '') === '') {
                continue;
            }
            $qtde = cp_decimal($detail['Qtde'] ?? 0);
            $precoProposta = cp_decimal($detail['preco_proposta'] ?? 0);
            $detailPayload = [
                'cp_compras_id' => $pedidoId,
                'compras_itens_id' => $itemId,
                'sku' => cp_trim($detail['sku'] ?? ''),
                'tamanho' => $tamanho,
                'cor' => $cor,
                'Qtde' => $qtde,
                'preco_fornecedor' => cp_decimal($detail['preco_fornecedor'] ?? 0),
                'preco_proposta' => $precoProposta,
                'valor_total_produto' => cp_decimal($detail['valor_total_produto'] ?? ($qtde * $precoProposta)),
                'preco_franqueado' => cp_decimal($detail['preco_franqueado'] ?? 0),
                'markup_franquia' => cp_decimal($detail['markup_franquia'] ?? 0),
                'preco_loja' => cp_decimal($detail['preco_loja'] ?? 0),
                'markup_loja' => cp_decimal($detail['markup_loja'] ?? 0),
                'markup_total' => cp_decimal($detail['markup_total'] ?? 0),
                'Sts' => (int) ($detail['Sts'] ?? 1),
            ];
            $detailStmt->execute($detailPayload);

            $percentual = cp_decimal($detail['percentual'] ?? 0);
            if ($percentual > 0 || $tamanho !== '' || $cor !== '') {
                $percentStmt->execute([
                    'compras_itens_id' => $itemId,
                    'tamanho' => $tamanho,
                    'cor' => $cor,
                    'percentual' => $percentual,
                ]);
            }
        }
    }
}

try {
    if ($action === 'options') {
        cp_option_select((string) ($_GET['type'] ?? ''), trim((string) ($_GET['q'] ?? '')));
    }

    if ($action === 'list') {
        $term = trim((string) ($data['q'] ?? ''));
        $where = '';
        $params = [];
        if ($term !== '') {
            $where = "WHERE CAST(c.ID AS CHAR) LIKE :q_id
                         OR c.Sts LIKE :q_sts
                         OR COALESCE(NULLIF(e.Fantasia, ''), e.Nome) LIKE :q_empresa
                         OR cd.NomeCD LIKE :q_cd";
            $params = [
                'q_id' => '%' . $term . '%',
                'q_sts' => '%' . $term . '%',
                'q_empresa' => '%' . $term . '%',
                'q_cd' => '%' . $term . '%',
            ];
        }

        $fornecedorJoin = cp_table_exists('produtos_fornecedor')
            ? 'LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor_id'
            : '';
        $fornecedorLabel = cp_table_exists('produtos_fornecedor')
            ? cp_fornecedor_label_expression('f')
            : 'c.Fornecedor_id';
        if ($term !== '' && cp_table_exists('produtos_fornecedor')) {
            $where .= " OR $fornecedorLabel LIKE :q_fornecedor";
            $params['q_fornecedor'] = '%' . $term . '%';
        }

        $stmt = db()->prepare(
            "SELECT c.ID AS id,
                    c.ID,
                    c.DataPedido,
                    c.ValorTotalPedido,
                    c.Sts,
                    cd.NomeCD AS cd_nome,
                    COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_nome,
                    $fornecedorLabel AS fornecedor_nome
               FROM cp_compras c
               LEFT JOIN empresas_cd cd ON cd.Codigo = c.cd_id
               LEFT JOIN empresas e ON e.Codigo = c.empresa_id
               $fornecedorJoin
               $where
              ORDER BY c.ID DESC
              LIMIT 200"
        );
        $stmt->execute($params);
        api_response(true, ['data' => $stmt->fetchAll()]);
    }

    if ($action === 'get') {
        $id = (int) ($data['id'] ?? 0);
        api_response(true, ['data' => cp_load_pedido($id)]);
    }

    if ($action === 'delete') {
        $id = (int) ($data['id'] ?? 0);
        $stmt = db()->prepare("DELETE FROM cp_compras WHERE ID = :id");
        $stmt->execute(['id' => $id]);
        api_response(true, ['message' => 'Pedido excluido.']);
    }

    if ($action === 'save') {
        $id = (int) ($data['id'] ?? 0);
        $payload = cp_header_payload($data);
        $items = cp_items_from_request($data);
        cp_validate_header($payload);

        $total = 0.0;
        foreach ($items as $item) {
            foreach (($item['detalhes'] ?? []) as $detail) {
                $total += cp_decimal($detail['valor_total_produto'] ?? (cp_decimal($detail['Qtde'] ?? 0) * cp_decimal($detail['preco_proposta'] ?? 0)));
            }
        }
        $payload['ValorTotalPedido'] = $total;

        $user = current_user();
        $payload['Usuario'] = (string) ($user['login'] ?? $user['nome'] ?? '');

        db()->beginTransaction();

        if ($id > 0) {
            $payload['Alteracao'] = date('Y-m-d');
            $payload['id'] = $id;
            $stmt = db()->prepare(
                "UPDATE cp_compras
                    SET cd_id = :cd_id,
                        empresa_id = :empresa_id,
                        Fornecedor_id = :Fornecedor_id,
                        DataPedido = :DataPedido,
                        MarkupFranqueadora = :MarkupFranqueadora,
                        MarkupFranquia = :MarkupFranquia,
                        MarkupTotal = :MarkupTotal,
                        ValorTotalPedido = :ValorTotalPedido,
                        Sts = :Sts,
                        TemFotos = :TemFotos,
                        StsMotivo = :StsMotivo,
                        Localizacao = :Localizacao,
                        Alteracao = :Alteracao,
                        Usuario = :Usuario
                  WHERE ID = :id"
            );
            $stmt->execute($payload);
            cp_delete_children($id);
            cp_save_items($id, $items);
            db()->commit();
            api_response(true, ['message' => 'Pedido atualizado.', 'id' => $id]);
        }

        $payload['Inclusao'] = date('Y-m-d');
        $payload['Alteracao'] = null;
        $stmt = db()->prepare(
            "INSERT INTO cp_compras
                (cd_id, empresa_id, Fornecedor_id, DataPedido, MarkupFranqueadora, MarkupFranquia, MarkupTotal,
                 ValorTotalPedido, Sts, TemFotos, StsMotivo, Localizacao, Inclusao, Alteracao, Usuario)
             VALUES
                (:cd_id, :empresa_id, :Fornecedor_id, :DataPedido, :MarkupFranqueadora, :MarkupFranquia, :MarkupTotal,
                 :ValorTotalPedido, :Sts, :TemFotos, :StsMotivo, :Localizacao, :Inclusao, :Alteracao, :Usuario)"
        );
        $stmt->execute($payload);
        $newId = (int) db()->lastInsertId();
        cp_save_items($newId, $items);
        db()->commit();
        api_response(true, ['message' => 'Pedido inserido.', 'id' => $newId]);
    }

    api_response(false, ['message' => 'Acao invalida.'], 404);
} catch (Throwable $e) {
    if (db()->inTransaction()) {
        db()->rollBack();
    }
    api_response(false, ['message' => $e->getMessage()], 500);
}
