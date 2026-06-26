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

    $value = trim((string) $value);
    if (strpos($value, ',') !== false) {
        $value = str_replace('.', '', $value);
        $value = str_replace(',', '.', $value);
    }

    return (float) $value;
}

function cp_trim($value): string
{
    return trim((string) ($value ?? ''));
}

function cp_fix_text_encoding($value): string
{
    $text = (string) ($value ?? '');
    if ($text === '' || (strpos($text, 'Ã') === false && strpos($text, 'Â') === false)) {
        return $text;
    }

    if (function_exists('mb_convert_encoding')) {
        return mb_convert_encoding(mb_convert_encoding($text, 'ISO-8859-1', 'UTF-8'), 'UTF-8', 'ISO-8859-1');
    }

    if (function_exists('iconv')) {
        $decoded = iconv('UTF-8', 'ISO-8859-1//IGNORE', $text);
        if ($decoded !== false) {
            $encoded = iconv('ISO-8859-1', 'UTF-8//IGNORE', $decoded);
            if ($encoded !== false) {
                return $encoded;
            }
        }
    }

    return $text;
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

function cp_fotos_table_exists(string $table): bool
{
    $stmt = db_fotos()->prepare(
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
    foreach (['NomeFornecedor', 'Nome', 'Fantasia', 'RazaoSocial', 'Descricao', 'descricao', 'Fornecedor'] as $column) {
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
        $fornecedorColumns = cp_columns('produtos_fornecedor');
        $markupFranqueadoraSelect = in_array('MarkupFranqueadora', $fornecedorColumns, true)
            ? 'f.MarkupFranqueadora'
            : '0';
        $stmt = db()->prepare(
            "SELECT f.Codigo AS id,
                    CONCAT(f.Codigo, ' - ', f.NomeFornecedor) AS text,
                    f.MarkUpCompra AS markup_compra,
                    $markupFranqueadoraSelect AS markup_franqueadora
               FROM produtos_fornecedor f
              WHERE CAST(f.Codigo AS CHAR) LIKE :q_codigo
                 OR f.NomeFornecedor LIKE :q_nome
              ORDER BY f.NomeFornecedor
              LIMIT 30"
        );
        $stmt->execute(['q_codigo' => $term, 'q_nome' => $term]);
        api_response(true, ['results' => $stmt->fetchAll()]);
    }

    if ($type === 'referencias') {
        $fornecedorId = cp_trim($_GET['fornecedor_id'] ?? $_POST['fornecedor_id'] ?? '');
        if ($fornecedorId === '') {
            api_response(true, ['results' => []]);
        }
        if (!cp_table_exists('pf_colecao')) {
            api_response(true, ['results' => []]);
        }
        $stmt = db()->prepare(
            "SELECT pc.codigo_referencia AS id,
                    COALESCE(NULLIF(MIN(pc.descricao), ''), 'Sem descricao') AS descricao
               FROM pf_colecao pc
              WHERE pc.id_fornecedor = :fornecedor_id
                AND pc.codigo_referencia IS NOT NULL
                AND pc.codigo_referencia <> ''
                AND (
                    pc.codigo_referencia LIKE :q_codigo
                    OR pc.descricao LIKE :q_descricao
                    OR pc.tamanho LIKE :q_tamanho
                    OR pc.cor_produto LIKE :q_cor
                )
              GROUP BY pc.codigo_referencia
              ORDER BY pc.codigo_referencia
              LIMIT 30"
        );
        $stmt->execute([
            'fornecedor_id' => $fornecedorId,
            'q_codigo' => $term,
            'q_descricao' => $term,
            'q_tamanho' => $term,
            'q_cor' => $term,
        ]);
        $results = array_map(static function (array $row): array {
            $descricao = cp_fix_text_encoding($row['descricao'] ?? 'Sem descricao');
            return [
                'id' => $row['id'],
                'text' => $row['id'] . ' - ' . $descricao,
            ];
        }, $stmt->fetchAll());
        api_response(true, ['results' => $results]);
    }

    api_response(false, ['message' => 'Tipo invalido.'], 404);
}

function cp_single_option(string $table, string $idColumn, string $textColumn): ?array
{
    $stmt = db()->query("SELECT COUNT(*) FROM `$table`");
    if ((int) $stmt->fetchColumn() !== 1) {
        return null;
    }

    $stmt = db()->query("SELECT `$idColumn` AS id, $textColumn AS text FROM `$table` LIMIT 1");
    $row = $stmt->fetch();
    return $row ?: null;
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
    cp_validate_unique_item_references($items);
    return $items;
}

function cp_validate_unique_item_references(array $items): void
{
    $used = [];
    foreach ($items as $item) {
        $referencia = cp_trim($item['referencia_fornecedor'] ?? '');
        if ($referencia === '') {
            continue;
        }
        if (isset($used[$referencia])) {
            api_response(false, ['message' => "A referencia $referencia ja foi incluida neste pedido."], 422);
        }
        $used[$referencia] = true;
    }
}

function cp_validate_item_percentuais(array $items): void
{
    foreach ($items as $item) {
        $detalhes = is_array($item['detalhes'] ?? null) ? $item['detalhes'] : [];
        $percentuais = [];
        foreach ($detalhes as $detail) {
            $percentual = cp_decimal($detail['percentual'] ?? 0);
            if ($percentual < 0 || $percentual > 100) {
                api_response(false, ['message' => 'Cada percentual de rateio deve estar entre 0% e 100%.'], 422);
            }
            if ($percentual <= 0) {
                continue;
            }
            $key = cp_trim($detail['tamanho'] ?? '') . "\n" . cp_trim($detail['cor'] ?? '');
            $percentuais[$key] = $percentual;
        }
        if ($percentuais) {
            $total = array_sum($percentuais);
            if (round($total, 2) !== 100.00) {
                $referencia = cp_trim($item['referencia_fornecedor'] ?? '');
                api_response(false, ['message' => "O rateio da referencia $referencia deve totalizar 100%."], 422);
            }
        }
    }
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
        'Publicado' => (int) ($data['Publicado'] ?? 0),
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
    $fornecedorText = cp_table_exists('produtos_fornecedor')
        ? "CONCAT(c.Fornecedor_id, ' - ', $fornecedorLabel)"
        : 'c.Fornecedor_id';

    $stmt = db()->prepare(
        "SELECT c.*,
                c.ID AS id,
                cd.NomeCD AS cd_id_text,
                COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_id_text,
                $fornecedorText AS Fornecedor_id_text
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
        $item['FotoFornecedor'] = cp_has_fotos_fornecedor(
            (int) $pedido['ID'],
            (string) ($item['referencia_fornecedor'] ?? ''),
            (string) ($pedido['Fornecedor_id'] ?? '')
        ) ? 1 : 0;
    }
    unset($item);

    $pedido['items'] = $items;
    return $pedido;
}

function cp_load_referencia_item(string $fornecedorId, string $codigoReferencia): ?array
{
    if (!cp_table_exists('pf_colecao')) {
        return null;
    }

    $stmt = db()->prepare(
        "SELECT *
           FROM pf_colecao
          WHERE id_fornecedor = :fornecedor_id
            AND codigo_referencia = :codigo_referencia
          ORDER BY tamanho ASC, cor_produto ASC, id_item ASC"
    );
    $stmt->execute([
        'fornecedor_id' => $fornecedorId,
        'codigo_referencia' => $codigoReferencia,
    ]);
    $rows = $stmt->fetchAll();
    if (!$rows) {
        return null;
    }

    $first = $rows[0];
    $detalhes = [];
    foreach ($rows as $row) {
        $detalhes[] = [
            'sku' => (string) ($row['sku'] ?? ''),
            'tamanho' => (string) ($row['tamanho'] ?? ''),
            'cor' => cp_fix_text_encoding($row['cor_produto'] ?? ''),
            'Qtde' => 0,
            'preco_fornecedor' => cp_decimal($row['valor_unitario'] ?? 0),
            'preco_proposta' => cp_decimal($row['valor_unitario'] ?? 0),
            'valor_total_produto' => 0,
            'preco_franqueado' => 0,
            'markup_franquia' => 0,
            'preco_loja' => 0,
            'markup_loja' => 0,
            'markup_total' => 0,
            'Sts' => 1,
        ];
    }

    return [
        'referencia_fornecedor' => (string) ($first['codigo_referencia'] ?? ''),
        'descricao' => cp_fix_text_encoding($first['descricao'] ?? ''),
        'composicao' => cp_fix_text_encoding($first['composicao'] ?? ''),
        'ncm' => (string) ($first['ncm'] ?? ''),
        'entrega' => '',
        'total_qtde' => 0,
        'total_produto' => 0,
        'Foto' => 0,
        'Sts' => 1,
        'detalhes' => $detalhes,
    ];
}

function cp_pedido_localizacao(int $id): ?string
{
    $stmt = db()->prepare("SELECT Localizacao FROM cp_compras WHERE ID = :id");
    $stmt->execute(['id' => $id]);
    $localizacao = $stmt->fetchColumn();
    return $localizacao === false ? null : (string) $localizacao;
}

function cp_require_kidstok(int $id, string $operation): void
{
    $localizacao = cp_pedido_localizacao($id);
    if ($localizacao === null) {
        api_response(false, ['message' => 'Pedido nao encontrado.'], 404);
    }
    if ($localizacao === 'Fornecedor') {
        api_response(false, ['message' => "Pedido com localizacao $localizacao nao permite $operation. Apenas visualizacao."], 403);
    }
}

function cp_image_mime_from_base64(string $base64): string
{
    $prefix = substr($base64, 0, 12);
    if (substr($prefix, 0, 3) === '/9j') {
        return 'image/jpeg';
    }
    if (substr($prefix, 0, 5) === 'iVBOR') {
        return 'image/png';
    }
    if (substr($prefix, 0, 6) === 'R0lGOD') {
        return 'image/gif';
    }
    if (substr($prefix, 0, 5) === 'UklGR') {
        return 'image/webp';
    }
    return 'image/jpeg';
}

function cp_validate_foto_context(int $pedidoId, string $referencia, string $fornecedorId, string $table = 'cp_compras_fotos_ks'): void
{
    if ($pedidoId <= 0 || $referencia === '' || $fornecedorId === '') {
        api_response(false, ['message' => 'Informe pedido, referencia e fornecedor para as fotos.'], 422);
    }
    if (!in_array($table, ['cp_compras_fotos_ks', 'cp_compras_fotos'], true)) {
        api_response(false, ['message' => 'Tabela de fotos invalida.'], 422);
    }
    if (!cp_fotos_table_exists($table)) {
        api_response(false, ['message' => "Tabela $table nao encontrada."], 500);
    }
}

function cp_list_fotos_table(int $pedidoId, string $referencia, string $fornecedorId, string $table): array
{
    cp_validate_foto_context($pedidoId, $referencia, $fornecedorId, $table);
    $stmt = db_fotos()->prepare(
        "SELECT id, Sequencia, foto
           FROM `$table`
          WHERE cp_compras_id = :pedido_id
            AND ref_fornecedor = :referencia
            AND fornecedor_id = :fornecedor_id
          ORDER BY Sequencia ASC, id ASC"
    );
    $stmt->execute([
        'pedido_id' => $pedidoId,
        'referencia' => $referencia,
        'fornecedor_id' => $fornecedorId,
    ]);

    return array_map(static function (array $row): array {
        $base64 = trim((string) ($row['foto'] ?? ''));
        if (substr($base64, 0, 11) === 'data:image/') {
            $src = $base64;
        } else {
            $src = 'data:' . cp_image_mime_from_base64($base64) . ';base64,' . $base64;
        }
        return [
            'id' => (int) $row['id'],
            'Sequencia' => (int) $row['Sequencia'],
            'src' => $src,
        ];
    }, $stmt->fetchAll());
}

function cp_list_fotos_ks(int $pedidoId, string $referencia, string $fornecedorId): array
{
    return cp_list_fotos_table($pedidoId, $referencia, $fornecedorId, 'cp_compras_fotos_ks');
}

function cp_list_fotos_fornecedor(int $pedidoId, string $referencia, string $fornecedorId): array
{
    return cp_list_fotos_table($pedidoId, $referencia, $fornecedorId, 'cp_compras_fotos');
}

function cp_count_fotos_table(int $pedidoId, string $referencia, string $fornecedorId, string $table): int
{
    cp_validate_foto_context($pedidoId, $referencia, $fornecedorId, $table);
    $stmt = db_fotos()->prepare(
        "SELECT COUNT(*)
           FROM `$table`
          WHERE cp_compras_id = :pedido_id
            AND ref_fornecedor = :referencia
            AND fornecedor_id = :fornecedor_id"
    );
    $stmt->execute([
        'pedido_id' => $pedidoId,
        'referencia' => $referencia,
        'fornecedor_id' => $fornecedorId,
    ]);
    return (int) $stmt->fetchColumn();
}

function cp_count_fotos_ks(int $pedidoId, string $referencia, string $fornecedorId): int
{
    return cp_count_fotos_table($pedidoId, $referencia, $fornecedorId, 'cp_compras_fotos_ks');
}

function cp_sync_foto_flag_ks(int $pedidoId, string $referencia, string $fornecedorId): int
{
    $count = cp_count_fotos_ks($pedidoId, $referencia, $fornecedorId);
    $stmt = db()->prepare(
        "UPDATE cp_compras_itens
            SET Foto = :foto
          WHERE cp_compras_id = :pedido_id
            AND referencia_fornecedor = :referencia"
    );
    $stmt->execute([
        'foto' => $count > 0 ? 1 : 0,
        'pedido_id' => $pedidoId,
        'referencia' => $referencia,
    ]);
    return $count;
}

function cp_has_fotos_ks(int $pedidoId, string $referencia, string $fornecedorId): bool
{
    if ($pedidoId <= 0 || $referencia === '' || $fornecedorId === '' || !cp_fotos_table_exists('cp_compras_fotos_ks')) {
        return false;
    }
    return cp_count_fotos_ks($pedidoId, $referencia, $fornecedorId) > 0;
}

function cp_has_fotos_fornecedor(int $pedidoId, string $referencia, string $fornecedorId): bool
{
    if ($pedidoId <= 0 || $referencia === '' || $fornecedorId === '' || !cp_fotos_table_exists('cp_compras_fotos')) {
        return false;
    }
    return cp_count_fotos_table($pedidoId, $referencia, $fornecedorId, 'cp_compras_fotos') > 0;
}

function cp_next_foto_sequencia(int $pedidoId, string $referencia, string $fornecedorId): int
{
    $stmt = db_fotos()->prepare(
        "SELECT COALESCE(MAX(Sequencia), 0) + 1
           FROM cp_compras_fotos_ks
          WHERE cp_compras_id = :pedido_id
            AND ref_fornecedor = :referencia
            AND fornecedor_id = :fornecedor_id"
    );
    $stmt->execute([
        'pedido_id' => $pedidoId,
        'referencia' => $referencia,
        'fornecedor_id' => $fornecedorId,
    ]);
    return (int) $stmt->fetchColumn();
}

function cp_upload_fotos_ks(int $pedidoId, string $referencia, string $fornecedorId): void
{
    cp_validate_foto_context($pedidoId, $referencia, $fornecedorId);
    cp_require_kidstok($pedidoId, 'inserir fotos');

    $files = $_FILES['fotos'] ?? null;
    if (!$files || empty($files['name'])) {
        api_response(false, ['message' => 'Selecione ao menos uma foto.'], 422);
    }

    $names = is_array($files['name']) ? $files['name'] : [$files['name']];
    $tmpNames = is_array($files['tmp_name']) ? $files['tmp_name'] : [$files['tmp_name']];
    $errors = is_array($files['error']) ? $files['error'] : [$files['error']];

    $fotosDb = db_fotos();
    $mainDb = db();

    $stmt = $fotosDb->prepare(
        "INSERT INTO cp_compras_fotos_ks
            (cp_compras_id, ref_fornecedor, fornecedor_id, Sequencia, foto)
         VALUES
            (:pedido_id, :referencia, :fornecedor_id, :sequencia, :foto)"
    );

    $inserted = 0;
    $sequencia = cp_next_foto_sequencia($pedidoId, $referencia, $fornecedorId);
    $fotosDb->beginTransaction();
    $mainDb->beginTransaction();
    try {
        foreach ($names as $index => $name) {
            if (($errors[$index] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
                continue;
            }
            $tmpName = (string) ($tmpNames[$index] ?? '');
            if ($tmpName === '' || !is_uploaded_file($tmpName) || !getimagesize($tmpName)) {
                continue;
            }
            $contents = file_get_contents($tmpName);
            if ($contents === false || $contents === '') {
                continue;
            }
            $stmt->execute([
                'pedido_id' => $pedidoId,
                'referencia' => $referencia,
                'fornecedor_id' => $fornecedorId,
                'sequencia' => $sequencia++,
                'foto' => base64_encode($contents),
            ]);
            $inserted++;
        }

        if ($inserted === 0) {
            $fotosDb->rollBack();
            $mainDb->rollBack();
            api_response(false, ['message' => 'Nenhuma imagem valida foi enviada.'], 422);
        }

        cp_sync_foto_flag_ks($pedidoId, $referencia, $fornecedorId);

        $fotosDb->commit();
        $mainDb->commit();
    } catch (Throwable $e) {
        if ($fotosDb->inTransaction()) {
            $fotosDb->rollBack();
        }
        if ($mainDb->inTransaction()) {
            $mainDb->rollBack();
        }
        throw $e;
    }

    api_response(true, [
        'message' => $inserted === 1 ? 'Foto inserida.' : 'Fotos inseridas.',
        'count' => count(cp_list_fotos_ks($pedidoId, $referencia, $fornecedorId)),
    ]);
}

function cp_delete_foto_ks(int $pedidoId, string $referencia, string $fornecedorId, int $fotoId): void
{
    cp_validate_foto_context($pedidoId, $referencia, $fornecedorId);
    cp_require_kidstok($pedidoId, 'excluir fotos');
    if ($fotoId <= 0) {
        api_response(false, ['message' => 'Informe a foto para excluir.'], 422);
    }

    $stmt = db_fotos()->prepare(
        "DELETE FROM cp_compras_fotos_ks
          WHERE id = :id
            AND cp_compras_id = :pedido_id
            AND ref_fornecedor = :referencia
            AND fornecedor_id = :fornecedor_id"
    );
    $stmt->execute([
        'id' => $fotoId,
        'pedido_id' => $pedidoId,
        'referencia' => $referencia,
        'fornecedor_id' => $fornecedorId,
    ]);

    if ($stmt->rowCount() === 0) {
        api_response(false, ['message' => 'Foto nao encontrada.'], 404);
    }

    $count = cp_sync_foto_flag_ks($pedidoId, $referencia, $fornecedorId);
    api_response(true, ['message' => 'Foto excluida.', 'count' => $count]);
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

function cp_save_items(int $pedidoId, array $items, string $fornecedorId): void
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

        $referencia = cp_trim($item['referencia_fornecedor'] ?? '');
        $itemPayload = [
            'cp_compras_id' => $pedidoId,
            'referencia_fornecedor' => $referencia,
            'descricao' => cp_trim($item['descricao'] ?? ''),
            'composicao' => cp_trim($item['composicao'] ?? ''),
            'ncm' => cp_trim($item['ncm'] ?? ''),
            'entrega' => cp_trim($item['entrega'] ?? '') ?: null,
            'total_qtde' => cp_decimal($item['total_qtde'] ?? 0),
            'total_produto' => cp_decimal($item['total_produto'] ?? 0),
            'Foto' => cp_has_fotos_ks($pedidoId, $referencia, $fornecedorId) ? 1 : (int) ($item['Foto'] ?? 0),
            'Sts' => (int) ($item['Sts'] ?? 1),
        ];
        $itemStmt->execute($itemPayload);
        $itemId = (int) db()->lastInsertId();
        $percentuaisSalvos = [];

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

            $percentualKey = $tamanho . "\n" . $cor;
            $percentual = cp_decimal($detail['percentual'] ?? 0);
            if (!isset($percentuaisSalvos[$percentualKey]) && ($percentual > 0 || $tamanho !== '' || $cor !== '')) {
                $percentStmt->execute([
                    'compras_itens_id' => $itemId,
                    'tamanho' => $tamanho,
                    'cor' => $cor,
                    'percentual' => $percentual,
                ]);
                $percentuaisSalvos[$percentualKey] = true;
            }
        }
    }
}

function cp_current_user_name(): string
{
    $user = current_user();
    return (string) ($user['login'] ?? $user['nome'] ?? '');
}

function cp_workflow_update(int $id, string $workflowAction): void
{
    if ($id <= 0) {
        api_response(false, ['message' => 'Informe o pedido.'], 422);
    }

    $stmt = db()->prepare("SELECT ID, Localizacao FROM cp_compras WHERE ID = :id");
    $stmt->execute(['id' => $id]);
    $pedido = $stmt->fetch();
    if (!$pedido) {
        api_response(false, ['message' => 'Pedido nao encontrado.'], 404);
    }

    $usuario = cp_current_user_name();
    if ($workflowAction === 'enviar_proposta') {
        cp_require_kidstok($id, 'enviar proposta');
        $stmt = db()->prepare(
            "UPDATE cp_compras
                SET Publicado = 1,
                    Localizacao = 'Fornecedor',
                    Iteracao = COALESCE(Iteracao, 0) + 1,
                    Alteracao = :alteracao,
                    Usuario = :usuario
              WHERE ID = :id"
        );
        $stmt->execute(['alteracao' => date('Y-m-d'), 'usuario' => $usuario, 'id' => $id]);
        api_response(true, ['message' => 'Proposta enviada ao fornecedor.']);
    }

    if ($workflowAction === 'aprovar') {
        $stmt = db()->prepare(
            "UPDATE cp_compras
                SET Sts = 'Aprovado',
                    Localizacao = 'KidStok',
                    DataAprovacao = :data_aprovacao,
                    UsuarioAprovacao = :usuario_aprovacao,
                    Alteracao = :alteracao,
                    Usuario = :usuario
              WHERE ID = :id"
        );
        $stmt->execute([
            'data_aprovacao' => date('Y-m-d'),
            'alteracao' => date('Y-m-d'),
            'usuario_aprovacao' => $usuario,
            'usuario' => $usuario,
            'id' => $id,
        ]);
        api_response(true, ['message' => 'Pedido aprovado.']);
    }

    if ($workflowAction === 'recusar') {
        $motivo = cp_trim($_POST['motivo'] ?? $_GET['motivo'] ?? '');
        $stmt = db()->prepare(
            "UPDATE cp_compras
                SET Sts = 'Recusado',
                    StsMotivo = :motivo,
                    Localizacao = 'KidStok',
                    DataRecusa = :data_recusa,
                    UsuarioRecusa = :usuario_recusa,
                    Alteracao = :alteracao,
                    Usuario = :usuario
              WHERE ID = :id"
        );
        $stmt->execute([
            'motivo' => $motivo,
            'data_recusa' => date('Y-m-d'),
            'alteracao' => date('Y-m-d'),
            'usuario_recusa' => $usuario,
            'usuario' => $usuario,
            'id' => $id,
        ]);
        api_response(true, ['message' => 'Pedido recusado.']);
    }

    api_response(false, ['message' => 'Acao de workflow invalida.'], 404);
}

try {
    if ($action === 'options') {
        cp_option_select((string) ($_GET['type'] ?? ''), trim((string) ($_GET['q'] ?? '')));
    }

    if ($action === 'defaults') {
        api_response(true, [
            'cd' => cp_single_option('empresas_cd', 'Codigo', '`NomeCD`'),
            'empresa' => cp_single_option('empresas', 'Codigo', "COALESCE(NULLIF(`Fantasia`, ''), `Nome`)"),
        ]);
    }

    if ($action === 'list') {
        $term = trim((string) ($data['q'] ?? ''));
        $where = '';
        $params = [];
        if ($term !== '') {
            $where = "WHERE CAST(c.ID AS CHAR) LIKE :q_id
                         OR c.Sts LIKE :q_sts
                         OR c.Localizacao LIKE :q_localizacao
                         OR COALESCE(NULLIF(e.Fantasia, ''), e.Nome) LIKE :q_empresa
                         OR cd.NomeCD LIKE :q_cd";
            $params = [
                'q_id' => '%' . $term . '%',
                'q_sts' => '%' . $term . '%',
                'q_localizacao' => '%' . $term . '%',
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
                    c.Localizacao,
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

    if ($action === 'referencia') {
        $fornecedorId = cp_trim($data['fornecedor_id'] ?? '');
        $codigoReferencia = cp_trim($data['codigo_referencia'] ?? '');
        if ($fornecedorId === '' || $codigoReferencia === '') {
            api_response(false, ['message' => 'Informe fornecedor e referencia.'], 422);
        }
        $item = cp_load_referencia_item($fornecedorId, $codigoReferencia);
        if (!$item) {
            api_response(false, ['message' => 'Referencia nao encontrada para este fornecedor.'], 404);
        }
        api_response(true, ['data' => $item]);
    }

    if ($action === 'fotos_list') {
        $pedidoId = (int) ($data['pedido_id'] ?? 0);
        $referencia = cp_trim($data['referencia'] ?? '');
        $fornecedorId = cp_trim($data['fornecedor_id'] ?? '');
        $fotos = cp_list_fotos_ks($pedidoId, $referencia, $fornecedorId);
        api_response(true, ['data' => $fotos, 'count' => count($fotos)]);
    }

    if ($action === 'fotos_fornecedor_list') {
        $pedidoId = (int) ($data['pedido_id'] ?? 0);
        $referencia = cp_trim($data['referencia'] ?? '');
        $fornecedorId = cp_trim($data['fornecedor_id'] ?? '');
        $fotos = cp_list_fotos_fornecedor($pedidoId, $referencia, $fornecedorId);
        api_response(true, ['data' => $fotos, 'count' => count($fotos)]);
    }

    if ($action === 'fotos_upload') {
        $pedidoId = (int) ($data['pedido_id'] ?? 0);
        $referencia = cp_trim($data['referencia'] ?? '');
        $fornecedorId = cp_trim($data['fornecedor_id'] ?? '');
        cp_upload_fotos_ks($pedidoId, $referencia, $fornecedorId);
    }

    if ($action === 'fotos_delete') {
        $pedidoId = (int) ($data['pedido_id'] ?? 0);
        $referencia = cp_trim($data['referencia'] ?? '');
        $fornecedorId = cp_trim($data['fornecedor_id'] ?? '');
        $fotoId = (int) ($data['foto_id'] ?? 0);
        cp_delete_foto_ks($pedidoId, $referencia, $fornecedorId, $fotoId);
    }

    if ($action === 'delete') {
        $id = (int) ($data['id'] ?? 0);
        cp_require_kidstok($id, 'excluir');
        $stmt = db()->prepare("DELETE FROM cp_compras WHERE ID = :id");
        $stmt->execute(['id' => $id]);
        api_response(true, ['message' => 'Pedido excluido.']);
    }

    if (in_array($action, ['enviar_proposta', 'aprovar', 'recusar'], true)) {
        cp_workflow_update((int) ($data['id'] ?? 0), $action);
    }

    if ($action === 'save') {
        $id = (int) ($data['id'] ?? 0);
        $payload = cp_header_payload($data);
        $items = cp_items_from_request($data);
        cp_validate_item_percentuais($items);
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
        if ($payload['Sts'] !== 'Recusado') {
            $payload['StsMotivo'] = '';
        }

        if ($id > 0) {
            cp_require_kidstok($id, 'editar');
        } else {
            $payload['Sts'] = 'Aberto';
            $payload['Publicado'] = 0;
            $payload['StsMotivo'] = '';
            $payload['Localizacao'] = 'KidStok';
        }

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
                        Publicado = :Publicado,
                        StsMotivo = :StsMotivo,
                        Localizacao = :Localizacao,
                        Alteracao = :Alteracao,
                        Usuario = :Usuario
                  WHERE ID = :id"
            );
            $stmt->execute($payload);
            cp_delete_children($id);
            cp_save_items($id, $items, $payload['Fornecedor_id']);
            db()->commit();
            api_response(true, ['message' => 'Pedido atualizado.', 'id' => $id]);
        }

        $payload['Inclusao'] = date('Y-m-d');
        $payload['Alteracao'] = null;
        $stmt = db()->prepare(
            "INSERT INTO cp_compras
                (cd_id, empresa_id, Fornecedor_id, DataPedido, MarkupFranqueadora, MarkupFranquia, MarkupTotal,
                 ValorTotalPedido, Sts, TemFotos, Publicado, StsMotivo, Localizacao, Inclusao, Alteracao, Usuario)
             VALUES
                (:cd_id, :empresa_id, :Fornecedor_id, :DataPedido, :MarkupFranqueadora, :MarkupFranquia, :MarkupTotal,
                 :ValorTotalPedido, :Sts, :TemFotos, :Publicado, :StsMotivo, :Localizacao, :Inclusao, :Alteracao, :Usuario)"
        );
        $stmt->execute($payload);
        $newId = (int) db()->lastInsertId();
        cp_save_items($newId, $items, $payload['Fornecedor_id']);
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
