<?php
/*
    Autor: Claudio Barto
    Data : 18/06/2026
*/
$aplicacao_nome = "cp_compras.php";
$aplicacao_descricao = "API para listar, inserir, editar e excluir pedidos de compra.";

require_once __DIR__ . '/../bootstrap.php';
require_once __DIR__ . '/../../includes/smtp_mailer.php';
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

function cp_html($value): string
{
    return htmlspecialchars((string) ($value ?? ''), ENT_QUOTES, 'UTF-8');
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

    api_response(false, ['message' => 'Tipo inválido.'], 404);
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
        api_response(false, ['message' => 'Itens inválidos.'], 422);
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
            api_response(false, ['message' => "A referência $referencia já foi incluída neste pedido."], 422);
        }
        $used[$referencia] = true;
    }
}

function cp_validate_item_percentuais(array $items): void
{
    foreach ($items as $item) {
        $referencia = cp_trim($item['referencia_fornecedor'] ?? '');
        $tamanhos = is_array($item['tamanhos'] ?? null) ? $item['tamanhos'] : [];
        $itemAtivo = (int) ($item['Sts'] ?? 1) !== 0;
        if (!$itemAtivo) {
            continue;
        }
        if (!$tamanhos) {
            api_response(false, ['message' => "Informe ao menos um tamanho para a referência $referencia."], 422);
        }

        $tamanhosAtivos = 0;
        $tamanhosUsados = [];
        $coresReferencia = null;
        $rateioItem = [];
        foreach ($tamanhos as $tamanho) {
            $tamanhoAtivo = (int) ($tamanho['Sts'] ?? 1) !== 0;
            if (!$tamanhoAtivo) {
                continue;
            }
            $nomeTamanho = cp_trim($tamanho['tamanho'] ?? '');
            if ($nomeTamanho === '') {
                api_response(false, ['message' => "Informe todos os tamanhos da referência $referencia."], 422);
            }
            if (isset($tamanhosUsados[$nomeTamanho])) {
                api_response(false, ['message' => "O tamanho $nomeTamanho está duplicado na referência $referencia."], 422);
            }
            $tamanhosUsados[$nomeTamanho] = true;

            $tamanhosAtivos += 1;

            $cores = is_array($tamanho['cores'] ?? null) ? $tamanho['cores'] : [];
            $coresAtivas = array_values(array_filter($cores, static function (array $cor): bool {
                return (int) ($cor['Sts'] ?? 1) !== 0;
            }));
            if (!$coresAtivas) {
                api_response(false, ['message' => "Informe ao menos uma cor ativa para o tamanho $nomeTamanho."], 422);
            }
            $qtdeTotalTamanho = max(0, (int) ($tamanho['qtde_total'] ?? 0));
            if ($qtdeTotalTamanho <= 0) {
                api_response(false, ['message' => "Item $referencia, tamanho $nomeTamanho: informe a quantidade total no rateio."], 422);
            }

            $coresUsadas = [];
            $coresTamanho = [];
            $totalQtdeCores = 0;
            foreach ($coresAtivas as $cor) {
                $nomeCor = cp_trim($cor['cor'] ?? '');
                if ($nomeCor === '') {
                    api_response(false, ['message' => "Informe todas as cores do tamanho $nomeTamanho."], 422);
                }
                if (isset($coresUsadas[$nomeCor])) {
                    api_response(false, ['message' => "A cor $nomeCor está duplicada no tamanho $nomeTamanho."], 422);
                }
                $coresUsadas[$nomeCor] = true;
                $coresTamanho[] = $nomeCor;

                $percentual = cp_decimal($cor['percentual'] ?? 0);
                if ($percentual < 0 || $percentual > 100) {
                    api_response(false, ['message' => "Item $referencia, cor $nomeCor: o percentual do rateio deve estar entre 0% e 100%."], 422);
                }
                if (!isset($rateioItem[$nomeCor])) {
                    $rateioItem[$nomeCor] = $percentual;
                } elseif (round($rateioItem[$nomeCor], 4) !== round($percentual, 4)) {
                    api_response(false, ['message' => "Item $referencia, cor $nomeCor: o percentual do rateio deve ser igual em todos os tamanhos do item."], 422);
                }
                $totalQtdeCores += max(0, (int) ($cor['Qtde'] ?? 0));
            }
            sort($coresTamanho, SORT_STRING);
            if ($coresReferencia === null) {
                $coresReferencia = $coresTamanho;
            } elseif ($coresReferencia !== $coresTamanho) {
                api_response(false, ['message' => "Item $referencia: todos os tamanhos ativos devem ter a mesma quantidade e o mesmo conjunto de cores para permitir rateio. Verifique o tamanho $nomeTamanho."], 422);
            }
            if ($totalQtdeCores !== $qtdeTotalTamanho) {
                api_response(false, ['message' => "Item $referencia, tamanho $nomeTamanho: a soma das quantidades das cores deve bater com a quantidade total. Total informado: $qtdeTotalTamanho. Soma das cores: $totalQtdeCores."], 422);
            }
        }
        if ($itemAtivo && $tamanhosAtivos > 0) {
            $totalRateioItem = array_sum($rateioItem);
            if (round($totalRateioItem, 4) > 0 && round($totalRateioItem, 4) !== 100.0000) {
                api_response(false, ['message' => "Item $referencia: o rateio das cores do item deve totalizar 100%. Total atual: " . number_format($totalRateioItem, 2, ',', '.') . "%."], 422);
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

const CP_STATUS_ABERTO = 0;
const CP_STATUS_APROVADO_AGUARDANDO_FOTO = 1;
const CP_STATUS_APROVADO = 2;
const CP_STATUS_RECUSADO = 3;

function cp_status_catalog_seed(): array
{
    return [
        CP_STATUS_ABERTO => ['descricao_compras' => 'Aberto', 'descricao_portal' => 'Aberto'],
        CP_STATUS_APROVADO_AGUARDANDO_FOTO => ['descricao_compras' => 'Aprovado Aguardando Foto Fornecedor', 'descricao_portal' => 'Aprovado Aguardando Foto Fornecedor'],
        CP_STATUS_APROVADO => ['descricao_compras' => 'Aprovado', 'descricao_portal' => 'Aprovado'],
        CP_STATUS_RECUSADO => ['descricao_compras' => 'Recusado', 'descricao_portal' => 'Recusado'],
    ];
}

function cp_ensure_status_catalog(): void
{
    static $checked = false;
    if ($checked || !cp_table_exists('cp_compras_status')) {
        return;
    }
    $checked = true;

    // Upsert (não só "se vazia") para autocorrigir IDs canônicos que já
    // existam com texto diferente do esperado, sem apagar linhas extras.
    $stmt = db()->prepare(
        'INSERT INTO cp_compras_status (id, descricao_compras, descricao_portal)
         VALUES (:id, :descricao_compras, :descricao_portal)
         ON DUPLICATE KEY UPDATE
            descricao_compras = VALUES(descricao_compras),
            descricao_portal = VALUES(descricao_portal)'
    );
    foreach (cp_status_catalog_seed() as $id => $row) {
        $stmt->execute(['id' => $id] + $row);
    }
}

function cp_status_id(string $label): int
{
    static $cache = [];

    cp_ensure_status_catalog();
    $label = cp_trim($label) ?: 'Aberto';
    if (array_key_exists($label, $cache)) {
        return $cache[$label];
    }

    $stmt = db()->prepare('SELECT id FROM cp_compras_status WHERE descricao_compras = :label LIMIT 1');
    $stmt->execute(['label' => $label]);
    $id = $stmt->fetchColumn();
    if ($id === false) {
        return $label === 'Aberto' ? CP_STATUS_ABERTO : ($cache[$label] = cp_status_id('Aberto'));
    }

    return $cache[$label] = (int) $id;
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
                c.id,
                c.id AS ID,
                cd.NomeCD AS cd_id_text,
                COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_id_text,
                $fornecedorText AS Fornecedor_id_text,
                COALESCE(cst.descricao_compras, '') AS descricao_compras,
                COALESCE(cst.descricao_compras, '') AS Sts
           FROM cp_compras c
           LEFT JOIN empresas_cd cd ON cd.Codigo = c.cd_id
           LEFT JOIN empresas e ON e.Codigo = c.empresa_id
           LEFT JOIN cp_compras_status cst ON cst.id = c.status_id
           $fornecedorJoin
          WHERE c.id = :id"
    );
    $stmt->execute(['id' => $id]);
    $pedido = $stmt->fetch();
    if (!$pedido) {
        return null;
    }

    $stmt = db()->prepare("SELECT *, id AS ID FROM cp_compras_itens WHERE cp_compras_id = :id ORDER BY id");
    $stmt->execute(['id' => $id]);
    $items = $stmt->fetchAll();

    $tamanhoStmt = db()->prepare(
        "SELECT *
           FROM cp_compras_itens_tamanhos
          WHERE compras_itens_id = :item_id
          ORDER BY tamanho ASC, id ASC"
    );
    $corStmt = db()->prepare(
        "SELECT c.*,
                COALESCE(r.Percentual, 0) AS percentual,
                EXISTS (
                    SELECT 1
                     FROM cp_compras_itens_cores_log l
                     WHERE l.compras_itens_cores_id = c.id
                       AND l.Iteracao = :iteracao_preco
                       AND (
                            l.preco_fornecedor <> c.preco_fornecedor
                         OR l.preco_proposta <> c.preco_proposta
                         OR l.preco_franqueado <> c.preco_franqueado
                         OR l.preco_loja <> c.preco_loja
                         OR l.valor_total_produto <> c.valor_total_produto
                       )
                     LIMIT 1
                ) AS tem_log_preco_iteracao,
                EXISTS (
                    SELECT 1
                     FROM cp_compras_itens_cores_log l
                     WHERE l.compras_itens_cores_id = c.id
                       AND l.Iteracao = :iteracao_qtde
                       AND NOT (l.Qtde <=> c.Qtde)
                     LIMIT 1
                ) AS tem_log_qtde_iteracao
           FROM cp_compras_itens_cores c
           LEFT JOIN cp_compras_itens_rateios r
             ON r.compras_itens_id = :item_id
            AND r.cor = c.cor
          WHERE c.compras_itens_tamanho_id = :tamanho_id
          ORDER BY c.cor ASC, c.id ASC"
    );

    foreach ($items as &$item) {
        $tamanhoStmt->execute(['item_id' => $item['id']]);
        $tamanhos = $tamanhoStmt->fetchAll();
        foreach ($tamanhos as &$tamanho) {
            $corStmt->execute([
                'tamanho_id' => $tamanho['id'],
                'item_id' => $item['id'],
                'iteracao_preco' => (int) ($pedido['Iteracao'] ?? 0),
                'iteracao_qtde' => (int) ($pedido['Iteracao'] ?? 0),
            ]);
            $tamanho['cores'] = $corStmt->fetchAll();
            $tamanho['tem_log_preco_iteracao'] = array_reduce(
                $tamanho['cores'],
                static fn(bool $carry, array $cor): bool => $carry || (int) ($cor['tem_log_preco_iteracao'] ?? 0) === 1,
                false
            ) ? 1 : 0;
            $tamanho['tem_log_qtde_iteracao'] = array_reduce(
                $tamanho['cores'],
                static fn(bool $carry, array $cor): bool => $carry || (int) ($cor['tem_log_qtde_iteracao'] ?? 0) === 1,
                false
            ) ? 1 : 0;
        }
        unset($tamanho);
        $item['tamanhos'] = $tamanhos;
        $item['FotoFornecedor'] = cp_has_fotos_fornecedor(
            (int) $pedido['id'],
            (string) ($item['referencia_fornecedor'] ?? ''),
            (string) ($pedido['Fornecedor_id'] ?? '')
        ) ? 1 : 0;
    }
    unset($item);

    $pedido['TemFotosFornecedor'] = cp_pedido_tem_fotos_fornecedor((int) $pedido['id']) ? 1 : 0;
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
    $tamanhos = [];
    foreach ($rows as $row) {
        $nomeTamanho = (string) ($row['tamanho'] ?? '');
        if (!isset($tamanhos[$nomeTamanho])) {
            $tamanhos[$nomeTamanho] = [
                'tamanho' => $nomeTamanho,
                'entrega' => '',
                'entrega_anterior' => '',
                'markup_franquia' => 0,
                'markup_loja' => 0,
                'qtde_total' => 0,
                'valor_total' => 0,
                'Itens' => 0,
                'Sts' => 1,
                'cores' => [],
            ];
        }
        $tamanhos[$nomeTamanho]['cores'][] = [
            'sku' => (string) ($row['sku'] ?? ''),
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
            'percentual' => 0,
            'Sts' => 1,
        ];
    }
    foreach ($tamanhos as &$tamanho) {
        $tamanho['Itens'] = count($tamanho['cores']);
    }
    unset($tamanho);

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
        'tamanhos' => array_values($tamanhos),
    ];
}

function cp_pedido_localizacao(int $id): ?string
{
    $stmt = db()->prepare("SELECT Localizacao FROM cp_compras WHERE id = :id");
    $stmt->execute(['id' => $id]);
    $localizacao = $stmt->fetchColumn();
    return $localizacao === false ? null : (string) $localizacao;
}

function cp_pedido_estado(int $id): ?array
{
    $stmt = db()->prepare(
        "SELECT c.Localizacao, c.status_id, COALESCE(cst.descricao_compras, '') AS descricao_compras
           FROM cp_compras c
           LEFT JOIN cp_compras_status cst ON cst.id = c.status_id
          WHERE c.id = :id"
    );
    $stmt->execute(['id' => $id]);
    $row = $stmt->fetch();
    return $row ?: null;
}

function cp_localizacao_fornecedor(?string $localizacao): bool
{
    return strcasecmp(trim((string) $localizacao), 'Fornecedor') === 0;
}

function cp_status_aprovado_aguardando_foto(array $pedido): bool
{
    $descricao = strtolower(trim((string) ($pedido['descricao_compras'] ?? '')));
    return (int) ($pedido['status_id'] ?? 0) === CP_STATUS_APROVADO_AGUARDANDO_FOTO
        || $descricao === 'aprovado aguardando foto fornecedor'
        || $descricao === 'aprovado aguardando foto'
        || $descricao === 'aprovado sem fotos';
}

function cp_status_final_bloqueado(array $pedido): bool
{
    return in_array((int) ($pedido['status_id'] ?? 0), [CP_STATUS_APROVADO, CP_STATUS_RECUSADO], true);
}

function cp_require_kidstok(int $id, string $operation): void
{
    $localizacao = cp_pedido_localizacao($id);
    if ($localizacao === null) {
        api_response(false, ['message' => 'Pedido não encontrado.'], 404);
    }
    if (cp_localizacao_fornecedor($localizacao)) {
        api_response(false, ['message' => "Pedido com localização $localizacao não permite $operation. Apenas visualização e impressão."], 403);
    }
}

function cp_require_pedido_editavel(int $id, string $operation): void
{
    $pedido = cp_pedido_estado($id);
    if (!$pedido) {
        api_response(false, ['message' => 'Pedido nÃ£o encontrado.'], 404);
    }
    if (cp_localizacao_fornecedor((string) $pedido['Localizacao']) || cp_status_final_bloqueado($pedido) || cp_status_aprovado_aguardando_foto($pedido)) {
        api_response(false, ['message' => "Pedido nÃ£o permite $operation. Apenas visualizaÃ§Ã£o."], 403);
    }
}

function cp_require_foto_mutavel(int $id, string $table, string $operation): void
{
    $pedido = cp_pedido_estado($id);
    if (!$pedido) {
        api_response(false, ['message' => 'Pedido nÃ£o encontrado.'], 404);
    }
    if ($table === 'cp_compras_fotos') {
        api_response(false, ['message' => 'Fotos do fornecedor podem ser apenas visualizadas no Pedido.'], 403);
    }
    if (cp_status_final_bloqueado($pedido)) {
        api_response(false, ['message' => "Pedido aprovado ou recusado nÃ£o permite $operation fotos. Apenas visualizaÃ§Ã£o."], 403);
    }
    if (cp_localizacao_fornecedor((string) $pedido['Localizacao']) && !cp_status_aprovado_aguardando_foto($pedido)) {
        api_response(false, ['message' => "Pedido com localizaÃ§Ã£o {$pedido['Localizacao']} nÃ£o permite $operation fotos. Apenas visualizaÃ§Ã£o."], 403);
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
        api_response(false, ['message' => 'Informe pedido, referência e fornecedor para as fotos.'], 422);
    }
    if (!in_array($table, ['cp_compras_fotos_ks', 'cp_compras_fotos'], true)) {
        api_response(false, ['message' => 'Tabela de fotos inválida.'], 422);
    }
    if (!cp_fotos_table_exists($table)) {
        api_response(false, ['message' => "Tabela $table não encontrada."], 500);
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

function cp_pedido_tem_fotos_fornecedor(int $pedidoId): bool
{
    if ($pedidoId <= 0 || !cp_fotos_table_exists('cp_compras_fotos')) {
        return false;
    }
    $stmt = db_fotos()->prepare(
        "SELECT COUNT(*)
           FROM cp_compras_fotos
          WHERE cp_compras_id = :pedido_id"
    );
    $stmt->execute(['pedido_id' => $pedidoId]);
    return (int) $stmt->fetchColumn() > 0;
}

function cp_ultimo_log_cor(int $pedidoId, int $corId): ?array
{
    if ($pedidoId <= 0 || $corId <= 0) {
        api_response(false, ['message' => 'Informe pedido e cor.'], 422);
    }
    if (!cp_table_exists('cp_compras_itens_cores_log')) {
        api_response(false, ['message' => 'Tabela de log de cores não encontrada.'], 500);
    }

    $stmt = db()->prepare(
        "SELECT l.*
           FROM cp_compras_itens_cores_log l
           INNER JOIN cp_compras_itens_cores c ON c.id = l.compras_itens_cores_id
           INNER JOIN cp_compras_itens_tamanhos t ON t.id = c.compras_itens_tamanho_id
           INNER JOIN cp_compras_itens i ON i.id = t.compras_itens_id
          WHERE i.cp_compras_id = :pedido_id
            AND l.compras_itens_cores_id = :cor_id
            AND (
                 l.preco_fornecedor <> c.preco_fornecedor
              OR l.preco_proposta <> c.preco_proposta
              OR l.preco_franqueado <> c.preco_franqueado
              OR l.preco_loja <> c.preco_loja
              OR l.valor_total_produto <> c.valor_total_produto
            )
          ORDER BY l.id DESC
          LIMIT 1"
    );
    $stmt->execute([
        'pedido_id' => $pedidoId,
        'cor_id' => $corId,
    ]);
    $log = $stmt->fetch();

    return $log ?: null;
}

function cp_next_foto_sequencia_table(int $pedidoId, string $referencia, string $fornecedorId, string $table): int
{
    cp_validate_foto_context($pedidoId, $referencia, $fornecedorId, $table);
    $stmt = db_fotos()->prepare(
        "SELECT COALESCE(MAX(Sequencia), 0) + 1
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

function cp_next_foto_sequencia(int $pedidoId, string $referencia, string $fornecedorId): int
{
    return cp_next_foto_sequencia_table($pedidoId, $referencia, $fornecedorId, 'cp_compras_fotos_ks');
}

function cp_upload_fotos_table(int $pedidoId, string $referencia, string $fornecedorId, string $table): void
{
    cp_validate_foto_context($pedidoId, $referencia, $fornecedorId, $table);
    cp_require_foto_mutavel($pedidoId, $table, $table === 'cp_compras_fotos' ? 'inserir fotos do fornecedor' : 'inserir');

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
        "INSERT INTO `$table`
            (cp_compras_id, ref_fornecedor, fornecedor_id, Sequencia, foto)
         VALUES
            (:pedido_id, :referencia, :fornecedor_id, :sequencia, :foto)"
    );

    $inserted = 0;
    $sequencia = cp_next_foto_sequencia_table($pedidoId, $referencia, $fornecedorId, $table);
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
            api_response(false, ['message' => 'Nenhuma imagem válida foi enviada.'], 422);
        }

        if ($table === 'cp_compras_fotos_ks') {
            cp_sync_foto_flag_ks($pedidoId, $referencia, $fornecedorId);
        }

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
        'count' => count(cp_list_fotos_table($pedidoId, $referencia, $fornecedorId, $table)),
    ]);
}

function cp_upload_fotos_ks(int $pedidoId, string $referencia, string $fornecedorId): void
{
    cp_upload_fotos_table($pedidoId, $referencia, $fornecedorId, 'cp_compras_fotos_ks');
}

function cp_upload_fotos_fornecedor(int $pedidoId, string $referencia, string $fornecedorId): void
{
    cp_upload_fotos_table($pedidoId, $referencia, $fornecedorId, 'cp_compras_fotos');
}

function cp_delete_foto_table(int $pedidoId, string $referencia, string $fornecedorId, int $fotoId, string $table): void
{
    cp_validate_foto_context($pedidoId, $referencia, $fornecedorId, $table);
    cp_require_foto_mutavel($pedidoId, $table, $table === 'cp_compras_fotos' ? 'excluir fotos do fornecedor' : 'excluir');
    if ($fotoId <= 0) {
        api_response(false, ['message' => 'Informe a foto para excluir.'], 422);
    }

    $stmt = db_fotos()->prepare(
        "DELETE FROM `$table`
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
        api_response(false, ['message' => 'Foto não encontrada.'], 404);
    }

    $count = $table === 'cp_compras_fotos_ks'
        ? cp_sync_foto_flag_ks($pedidoId, $referencia, $fornecedorId)
        : cp_count_fotos_table($pedidoId, $referencia, $fornecedorId, $table);
    api_response(true, ['message' => 'Foto excluída.', 'count' => $count]);
}

function cp_delete_foto_ks(int $pedidoId, string $referencia, string $fornecedorId, int $fotoId): void
{
    cp_delete_foto_table($pedidoId, $referencia, $fornecedorId, $fotoId, 'cp_compras_fotos_ks');
}

function cp_delete_foto_fornecedor(int $pedidoId, string $referencia, string $fornecedorId, int $fotoId): void
{
    cp_delete_foto_table($pedidoId, $referencia, $fornecedorId, $fotoId, 'cp_compras_fotos');
}

function cp_required_date(?string $primary, ?string ...$fallbacks): string
{
    $values = array_merge([$primary], $fallbacks);
    foreach ($values as $value) {
        $date = cp_trim($value ?? '');
        if ($date !== '' && $date !== '0000-00-00') {
            return substr($date, 0, 10);
        }
    }

    return date('Y-m-d');
}

function cp_id($value): int
{
    return max(0, (int) ($value ?? 0));
}

function cp_delete_missing_ids(string $table, string $parentColumn, int $parentId, array $keepIds): void
{
    $keepIds = array_values(array_filter(array_unique(array_map('intval', $keepIds)), static function (int $id): bool {
        return $id > 0;
    }));

    $sql = "DELETE FROM `$table` WHERE `$parentColumn` = :parent_id";
    $params = ['parent_id' => $parentId];
    if ($keepIds) {
        $placeholders = [];
        foreach ($keepIds as $index => $id) {
            $key = 'id_' . $index;
            $placeholders[] = ':' . $key;
            $params[$key] = $id;
        }
        $sql .= ' AND id NOT IN (' . implode(',', $placeholders) . ')';
    }

    $stmt = db()->prepare($sql);
    $stmt->execute($params);
}

function cp_keep_ids_where_not_in(string $column, array $keepIds, array &$params): string
{
    $keepIds = array_values(array_filter(array_unique(array_map('intval', $keepIds)), static function (int $id): bool {
        return $id > 0;
    }));
    if (!$keepIds) {
        return '';
    }

    $placeholders = [];
    $paramPrefix = preg_replace('/\W+/', '_', $column);
    foreach ($keepIds as $index => $id) {
        $key = $paramPrefix . '_keep_' . $index;
        $placeholders[] = ':' . $key;
        $params[$key] = $id;
    }
    return " AND $column NOT IN (" . implode(',', $placeholders) . ")";
}

function cp_delete_missing_cores(int $tamanhoId, array $keepCorIds): void
{
    cp_delete_missing_ids('cp_compras_itens_cores', 'compras_itens_tamanho_id', $tamanhoId, $keepCorIds);
}

function cp_delete_missing_item_rateios(int $itemId, array $keepCores): void
{
    $keepCores = array_values(array_filter(array_unique(array_map('strval', $keepCores)), static function (string $cor): bool {
        return trim($cor) !== '';
    }));
    $params = ['item_id' => $itemId];
    $sql = 'DELETE FROM cp_compras_itens_rateios WHERE compras_itens_id = :item_id';
    if ($keepCores) {
        $placeholders = [];
        foreach ($keepCores as $index => $cor) {
            $key = 'cor_keep_' . $index;
            $placeholders[] = ':' . $key;
            $params[$key] = $cor;
        }
        $sql .= ' AND cor NOT IN (' . implode(',', $placeholders) . ')';
    }
    $stmt = db()->prepare($sql);
    $stmt->execute($params);
}

function cp_delete_missing_tamanhos(int $itemId, array $keepTamanhoIds): void
{
    $params = ['item_id' => $itemId];
    $notIn = cp_keep_ids_where_not_in('t.id', $keepTamanhoIds, $params);

    $stmt = db()->prepare(
        "DELETE c
           FROM cp_compras_itens_cores c
           JOIN cp_compras_itens_tamanhos t ON t.id = c.compras_itens_tamanho_id
          WHERE t.compras_itens_id = :item_id$notIn"
    );
    $stmt->execute($params);

    cp_delete_missing_ids('cp_compras_itens_tamanhos', 'compras_itens_id', $itemId, $keepTamanhoIds);
}

function cp_delete_missing_items(int $pedidoId, array $keepItemIds): void
{
    $params = ['pedido_id' => $pedidoId];
    $notIn = cp_keep_ids_where_not_in('i.id', $keepItemIds, $params);

    $stmt = db()->prepare(
        "DELETE r
           FROM cp_compras_itens_rateios r
           JOIN cp_compras_itens i ON i.id = r.compras_itens_id
          WHERE i.cp_compras_id = :pedido_id$notIn"
    );
    $stmt->execute($params);

    $stmt = db()->prepare(
        "DELETE c
           FROM cp_compras_itens_cores c
           JOIN cp_compras_itens_tamanhos t ON t.id = c.compras_itens_tamanho_id
           JOIN cp_compras_itens i ON i.id = t.compras_itens_id
          WHERE i.cp_compras_id = :pedido_id$notIn"
    );
    $stmt->execute($params);

    $stmt = db()->prepare(
        "DELETE t
           FROM cp_compras_itens_tamanhos t
           JOIN cp_compras_itens i ON i.id = t.compras_itens_id
          WHERE i.cp_compras_id = :pedido_id$notIn"
    );
    $stmt->execute($params);

    cp_delete_missing_ids('cp_compras_itens', 'cp_compras_id', $pedidoId, $keepItemIds);
}

function cp_delete_children(int $pedidoId): void
{
    cp_delete_missing_items($pedidoId, []);
}

function cp_item_belongs_to_pedido(int $itemId, int $pedidoId): bool
{
    if ($itemId <= 0) {
        return false;
    }
    $stmt = db()->prepare("SELECT COUNT(*) FROM cp_compras_itens WHERE id = :id AND cp_compras_id = :pedido_id");
    $stmt->execute(['id' => $itemId, 'pedido_id' => $pedidoId]);
    return (int) $stmt->fetchColumn() > 0;
}

function cp_tamanho_belongs_to_item(int $tamanhoId, int $itemId): bool
{
    if ($tamanhoId <= 0) {
        return false;
    }
    $stmt = db()->prepare("SELECT COUNT(*) FROM cp_compras_itens_tamanhos WHERE id = :id AND compras_itens_id = :item_id");
    $stmt->execute(['id' => $tamanhoId, 'item_id' => $itemId]);
    return (int) $stmt->fetchColumn() > 0;
}

function cp_cor_belongs_to_tamanho(int $corId, int $tamanhoId): bool
{
    if ($corId <= 0) {
        return false;
    }
    $stmt = db()->prepare("SELECT COUNT(*) FROM cp_compras_itens_cores WHERE id = :id AND compras_itens_tamanho_id = :tamanho_id");
    $stmt->execute(['id' => $corId, 'tamanho_id' => $tamanhoId]);
    return (int) $stmt->fetchColumn() > 0;
}

function cp_find_item_id(int $pedidoId, string $referencia): int
{
    if ($pedidoId <= 0 || $referencia === '') {
        return 0;
    }
    $stmt = db()->prepare(
        "SELECT id
           FROM cp_compras_itens
          WHERE cp_compras_id = :pedido_id
            AND referencia_fornecedor = :referencia
          LIMIT 1"
    );
    $stmt->execute(['pedido_id' => $pedidoId, 'referencia' => $referencia]);
    return (int) ($stmt->fetchColumn() ?: 0);
}

function cp_find_tamanho_id(int $itemId, string $tamanho): int
{
    if ($itemId <= 0 || $tamanho === '') {
        return 0;
    }
    $stmt = db()->prepare(
        "SELECT id
           FROM cp_compras_itens_tamanhos
          WHERE compras_itens_id = :item_id
            AND tamanho = :tamanho
          LIMIT 1"
    );
    $stmt->execute(['item_id' => $itemId, 'tamanho' => $tamanho]);
    return (int) ($stmt->fetchColumn() ?: 0);
}

function cp_find_cor_id(int $tamanhoId, string $sku, string $cor): int
{
    if ($tamanhoId <= 0) {
        return 0;
    }

    if ($sku !== '') {
        $stmt = db()->prepare(
            "SELECT id
               FROM cp_compras_itens_cores
              WHERE compras_itens_tamanho_id = :tamanho_id
                AND sku = :sku
              LIMIT 1"
        );
        $stmt->execute(['tamanho_id' => $tamanhoId, 'sku' => $sku]);
        $id = (int) ($stmt->fetchColumn() ?: 0);
        if ($id > 0) {
            return $id;
        }
    }

    if ($cor === '') {
        return 0;
    }
    $stmt = db()->prepare(
        "SELECT id
           FROM cp_compras_itens_cores
          WHERE compras_itens_tamanho_id = :tamanho_id
            AND cor = :cor
          LIMIT 1"
    );
    $stmt->execute(['tamanho_id' => $tamanhoId, 'cor' => $cor]);
    return (int) ($stmt->fetchColumn() ?: 0);
}

function cp_save_items(int $pedidoId, array $items, string $fornecedorId, string $dataPedido): void
{
    $itemInsertStmt = db()->prepare(
        "INSERT INTO cp_compras_itens
            (cp_compras_id, referencia_fornecedor, descricao, composicao, ncm, entrega, entrega_anterior, total_qtde, total_produto, Foto, Sts)
         VALUES
            (:cp_compras_id, :referencia_fornecedor, :descricao, :composicao, :ncm, :entrega, :entrega_anterior, :total_qtde, :total_produto, :Foto, :Sts)"
    );
    $itemUpdateStmt = db()->prepare(
        "UPDATE cp_compras_itens
            SET referencia_fornecedor = :referencia_fornecedor,
                descricao = :descricao,
                composicao = :composicao,
                ncm = :ncm,
                entrega = :entrega,
                entrega_anterior = :entrega_anterior,
                total_qtde = :total_qtde,
                total_produto = :total_produto,
                Foto = :Foto,
                Sts = :Sts
          WHERE id = :id
            AND cp_compras_id = :cp_compras_id"
    );
    $tamanhoInsertStmt = db()->prepare(
        "INSERT INTO cp_compras_itens_tamanhos
            (compras_itens_id, tamanho, entrega, entrega_anterior, markup_franquia, markup_loja,
             qtde_total, valor_total, Itens, Sts)
         VALUES
            (:compras_itens_id, :tamanho, :entrega, :entrega_anterior, :markup_franquia, :markup_loja,
             :qtde_total, :valor_total, :Itens, :Sts)"
    );
    $tamanhoUpdateStmt = db()->prepare(
        "UPDATE cp_compras_itens_tamanhos
            SET tamanho = :tamanho,
                entrega = :entrega,
                entrega_anterior = :entrega_anterior,
                markup_franquia = :markup_franquia,
                markup_loja = :markup_loja,
                qtde_total = :qtde_total,
                valor_total = :valor_total,
                Itens = :Itens,
                Sts = :Sts
          WHERE id = :id
            AND compras_itens_id = :compras_itens_id"
    );
    $corInsertStmt = db()->prepare(
        "INSERT INTO cp_compras_itens_cores
            (compras_itens_tamanho_id, sku, cor, Qtde, preco_fornecedor, preco_proposta,
             valor_total_produto, preco_franqueado, markup_franquia, preco_loja, markup_loja, markup_total, Sts)
         VALUES
            (:compras_itens_tamanho_id, :sku, :cor, :Qtde, :preco_fornecedor, :preco_proposta,
             :valor_total_produto, :preco_franqueado, :markup_franquia, :preco_loja, :markup_loja, :markup_total, :Sts)"
    );
    $corUpdateStmt = db()->prepare(
        "UPDATE cp_compras_itens_cores
            SET sku = :sku,
                cor = :cor,
                Qtde = :Qtde,
                preco_fornecedor = :preco_fornecedor,
                preco_proposta = :preco_proposta,
                valor_total_produto = :valor_total_produto,
                preco_franqueado = :preco_franqueado,
                markup_franquia = :markup_franquia,
                preco_loja = :preco_loja,
                markup_loja = :markup_loja,
                markup_total = :markup_total,
                Sts = :Sts
          WHERE id = :id
            AND compras_itens_tamanho_id = :compras_itens_tamanho_id"
    );
    $rateioStmt = db()->prepare(
        "INSERT INTO cp_compras_itens_rateios
            (compras_itens_id, cor, Percentual)
         VALUES
            (:compras_itens_id, :cor, :percentual)"
        . " ON DUPLICATE KEY UPDATE Percentual = VALUES(Percentual)"
    );

    $keptItemIds = [];
    foreach ($items as $item) {
        $tamanhos = is_array($item['tamanhos'] ?? null) ? $item['tamanhos'] : [];
        if (cp_trim($item['referencia_fornecedor'] ?? '') === '' && cp_trim($item['descricao'] ?? '') === '' && !$tamanhos) {
            continue;
        }

        $referencia = cp_trim($item['referencia_fornecedor'] ?? '');
        $itemId = cp_id($item['id'] ?? 0) ?: cp_find_item_id($pedidoId, $referencia);
        $itemEntrega = cp_trim($item['entrega'] ?? '');
        $itemEntregaAnterior = cp_trim($item['entrega_anterior'] ?? '');
        $itemAtivo = (int) ($item['Sts'] ?? 1) !== 0;
        $itemPayload = [
            'cp_compras_id' => $pedidoId,
            'referencia_fornecedor' => $referencia,
            'descricao' => cp_trim($item['descricao'] ?? ''),
            'composicao' => cp_trim($item['composicao'] ?? ''),
            'ncm' => cp_trim($item['ncm'] ?? ''),
            'entrega' => $itemEntrega ?: null,
            'entrega_anterior' => $itemEntregaAnterior ?: null,
            'total_qtde' => $itemAtivo ? cp_decimal($item['total_qtde'] ?? 0) : 0,
            'total_produto' => $itemAtivo ? cp_decimal($item['total_produto'] ?? 0) : 0,
            'Foto' => cp_has_fotos_ks($pedidoId, $referencia, $fornecedorId) ? 1 : (int) ($item['Foto'] ?? 0),
            'Sts' => (int) ($item['Sts'] ?? 1),
        ];
        if ($itemId > 0) {
            if (!cp_item_belongs_to_pedido($itemId, $pedidoId)) {
                api_response(false, ['message' => 'Item inválido para este pedido.'], 422);
            }
            $itemUpdateStmt->execute($itemPayload + ['id' => $itemId]);
        } else {
            $itemInsertStmt->execute($itemPayload);
            $itemId = (int) db()->lastInsertId();
        }
        $keptItemIds[] = $itemId;

        $keptTamanhoIds = [];
        $rateiosItem = [];
        foreach ($tamanhos as $tamanho) {
            $cores = is_array($tamanho['cores'] ?? null) ? $tamanho['cores'] : [];
            $tamanhoSolicitadoAtivo = (int) ($tamanho['Sts'] ?? 1) !== 0;
            $itensAtivos = (!$itemAtivo || !$tamanhoSolicitadoAtivo) ? 0 : count(array_filter($cores, static function (array $cor): bool {
                return (int) ($cor['Sts'] ?? 1) !== 0;
            }));
            $tamanhoSts = $itemAtivo && $tamanhoSolicitadoAtivo && $itensAtivos > 0 ? 1 : 0;
            $nomeTamanho = cp_trim($tamanho['tamanho'] ?? '');
            $tamanhoId = cp_id($tamanho['id'] ?? 0) ?: cp_find_tamanho_id($itemId, $nomeTamanho);
            $tamanhoPayload = [
                'compras_itens_id' => $itemId,
                'tamanho' => $nomeTamanho,
                'entrega' => cp_required_date($tamanho['entrega'] ?? '', $itemEntrega, $dataPedido),
                'entrega_anterior' => cp_required_date($tamanho['entrega_anterior'] ?? '', $itemEntregaAnterior, $tamanho['entrega'] ?? '', $itemEntrega, $dataPedido),
                'markup_franquia' => cp_decimal($tamanho['markup_franquia'] ?? 0),
                'markup_loja' => cp_decimal($tamanho['markup_loja'] ?? 0),
                'qtde_total' => $tamanhoSts === 1 ? cp_decimal($tamanho['qtde_total'] ?? 0) : 0,
                'valor_total' => $tamanhoSts === 1 ? cp_decimal($tamanho['valor_total'] ?? 0) : 0,
                'Itens' => $itensAtivos,
                'Sts' => $tamanhoSts,
            ];
            if ($tamanhoId > 0) {
                if (!cp_tamanho_belongs_to_item($tamanhoId, $itemId)) {
                    api_response(false, ['message' => 'Tamanho inválido para este item.'], 422);
                }
                $tamanhoUpdateStmt->execute($tamanhoPayload + ['id' => $tamanhoId]);
            } else {
                $tamanhoInsertStmt->execute($tamanhoPayload);
                $tamanhoId = (int) db()->lastInsertId();
            }
            $keptTamanhoIds[] = $tamanhoId;

            $keptCorIds = [];
            foreach ($cores as $cor) {
                $corSts = $tamanhoSts === 1 ? (int) ($cor['Sts'] ?? 1) : 0;
                $sku = cp_trim($cor['sku'] ?? '');
                $nomeCor = cp_trim($cor['cor'] ?? '');
                $corId = cp_id($cor['id'] ?? 0) ?: cp_find_cor_id($tamanhoId, $sku, $nomeCor);
                $qtde = $corSts === 1 ? cp_decimal($cor['Qtde'] ?? 0) : 0;
                $precoProposta = cp_decimal($cor['preco_proposta'] ?? 0);
                $corPayload = [
                    'compras_itens_tamanho_id' => $tamanhoId,
                    'sku' => $sku,
                    'cor' => $nomeCor,
                    'Qtde' => $qtde,
                    'preco_fornecedor' => cp_decimal($cor['preco_fornecedor'] ?? 0),
                    'preco_proposta' => $precoProposta,
                    'valor_total_produto' => $corSts === 1 ? cp_decimal($cor['valor_total_produto'] ?? ($qtde * $precoProposta)) : 0,
                    'preco_franqueado' => cp_decimal($cor['preco_franqueado'] ?? 0),
                    'markup_franquia' => cp_decimal($cor['markup_franquia'] ?? 0),
                    'preco_loja' => cp_decimal($cor['preco_loja'] ?? 0),
                    'markup_loja' => cp_decimal($cor['markup_loja'] ?? 0),
                    'markup_total' => cp_decimal($cor['markup_total'] ?? 0),
                    'Sts' => $corSts,
                ];
                if ($corId > 0) {
                    if (!cp_cor_belongs_to_tamanho($corId, $tamanhoId)) {
                        api_response(false, ['message' => 'Cor inválida para este tamanho.'], 422);
                    }
                    $corUpdateStmt->execute($corPayload + ['id' => $corId]);
                } else {
                    $corInsertStmt->execute($corPayload);
                    $corId = (int) db()->lastInsertId();
                }
                $keptCorIds[] = $corId;
                if ($corSts === 1 && $nomeCor !== '' && !isset($rateiosItem[$nomeCor])) {
                    $rateiosItem[$nomeCor] = cp_decimal($cor['percentual'] ?? 0);
                }
            }
            cp_delete_missing_cores($tamanhoId, $keptCorIds);
        }
        foreach ($rateiosItem as $nomeCor => $percentual) {
            $rateioStmt->execute([
                'compras_itens_id' => $itemId,
                'cor' => $nomeCor,
                'percentual' => $percentual,
            ]);
        }
        cp_delete_missing_item_rateios($itemId, array_keys($rateiosItem));
        cp_delete_missing_tamanhos($itemId, $keptTamanhoIds);
    }
    cp_delete_missing_items($pedidoId, $keptItemIds);
}

function cp_current_user_name(): string
{
    $user = current_user();
    return (string) ($user['login'] ?? $user['nome'] ?? '');
}

function cp_portal_fornecedor_url(int $cdId, int $empresaId): string
{
    $stmt = db()->prepare(
        "SELECT url
           FROM urls_allop
          WHERE cd_id = :cd_id
            AND empresa_id = :empresa_id
            AND modulo = :modulo
            AND url <> ''
          ORDER BY id
          LIMIT 1"
    );
    $stmt->execute([
        'cd_id' => $cdId,
        'empresa_id' => $empresaId,
        'modulo' => 'apPF',
    ]);
    $url = trim((string) $stmt->fetchColumn());
    if ($url === '') {
        throw new RuntimeException('Não existe URL do portal do fornecedor cadastrada em urls_allop para o módulo apPF, CD e empresa do pedido.');
    }

    return $url;
}

function cp_send_proposta_email(int $id, bool $aprovadoAguardandoFoto = false): int
{
    $stmt = db()->prepare(
        "SELECT c.id,
                c.id AS ID,
                c.cd_id,
                c.empresa_id,
                c.Fornecedor_id,
                c.DataPedido,
                c.ValorTotalPedido,
                COALESCE(NULLIF(f.NomeFornecedor, ''), c.Fornecedor_id) AS fornecedor_nome
           FROM cp_compras c
           LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor_id
          WHERE c.id = :id"
    );
    $stmt->execute(['id' => $id]);
    $pedido = $stmt->fetch();
    if (!$pedido) {
        throw new RuntimeException('Pedido não encontrado.');
    }

    $stmt = db()->prepare(
        "SELECT Codigo,
                NomeConta,
                Servidor,
                Porta,
                ModoAutenticado,
                ModoSSL,
                Email,
                Senha
           FROM config_email
          WHERE cd_id = :cd_id
            AND empresa_id = :empresa_id
            AND Habilitado = 1
            AND Status = 'Ativo'
          ORDER BY Codigo
          LIMIT 1"
    );
    $stmt->execute([
        'cd_id' => $pedido['cd_id'],
        'empresa_id' => $pedido['empresa_id'],
    ]);
    $config = $stmt->fetch();
    if (!$config) {
        throw new RuntimeException('Não existe uma configuração de e-mail ativa para o CD e a empresa do pedido.');
    }

    $stmt = db()->prepare(
        "SELECT DISTINCT u.nome, u.email
           FROM pf_usuarios u
           INNER JOIN pf_usuario_fornecedor uf ON uf.id_usuario = u.id
          WHERE uf.id_fornecedor = :fornecedor_id
            AND u.status = 1
            AND u.email <> ''
          ORDER BY u.nome"
    );
    $stmt->execute(['fornecedor_id' => $pedido['Fornecedor_id']]);
    $recipients = $stmt->fetchAll();
    if (!$recipients) {
        throw new RuntimeException('O fornecedor não possui usuários ativos cadastrados para receber a proposta.');
    }

    $dataPedido = DateTime::createFromFormat('Y-m-d', (string) $pedido['DataPedido']);
    $dataPedidoText = $dataPedido ? $dataPedido->format('d/m/Y') : (string) $pedido['DataPedido'];
    $fornecedorNome = cp_fix_text_encoding($pedido['fornecedor_nome']);
    $portalUrl = cp_portal_fornecedor_url((int) $pedido['cd_id'], (int) $pedido['empresa_id']);
    $subject = 'Portal Fornecedor Kidstok - Pedido #' . $pedido['ID'] . ' ' . $fornecedorNome;
    $tituloEmail = $aprovadoAguardandoFoto ? 'Pedido aprovado aguardando fotos' : 'Novo Pedido no Portal do Fornecedor';
    $mensagemEmail = $aprovadoAguardandoFoto
        ? 'A Kidstok aprovou o pedido e aguarda o envio das fotos do fornecedor.'
        : 'A Kidstok enviou uma proposta comercial e aguarda a sua resposta.';
    $body = $tituloEmail . "\n"
        . $mensagemEmail . "\n\n"
        . "Detalhes do Pedido:\n"
        . "Fornecedor: " . $fornecedorNome . "\n"
        . "Data Pedido: " . $dataPedidoText . "\n"
        . "Valor Total: R$ " . number_format((float) $pedido['ValorTotalPedido'], 2, ',', '.') . "\n\n"
        . "Acesse o Portal do Fornecedor: " . $portalUrl;

    $htmlBody = '<!doctype html>'
        . '<html lang="pt-BR"><head><meta charset="UTF-8"><title>' . cp_html($subject) . '</title></head>'
        . '<body style="margin:0;padding:0;background:#f6f7f9;font-family:Arial,Helvetica,sans-serif;color:#222;">'
        . '<div style="max-width:640px;margin:0 auto;padding:28px 18px;">'
        . '<div style="background:#ffffff;border:1px solid #e4e7ec;border-radius:8px;padding:28px;">'
        . '<h2 style="margin:0 0 12px;font-size:22px;color:#222;">' . cp_html($tituloEmail) . '</h2>'
        . '<p style="margin:0 0 22px;font-size:15px;line-height:1.5;color:#444;">' . cp_html($mensagemEmail) . '</p>'
        . '<table role="presentation" cellpadding="0" cellspacing="0" style="width:100%;border-collapse:collapse;margin:0 0 24px;font-size:14px;">'
        . '<tr><td style="padding:8px 0;color:#667085;width:140px;">Fornecedor</td><td style="padding:8px 0;font-weight:bold;">' . cp_html($fornecedorNome) . '</td></tr>'
        . '<tr><td style="padding:8px 0;color:#667085;">Data Pedido</td><td style="padding:8px 0;">' . cp_html($dataPedidoText) . '</td></tr>'
        . '<tr><td style="padding:8px 0;color:#667085;">Valor Total</td><td style="padding:8px 0;">R$ ' . cp_html(number_format((float) $pedido['ValorTotalPedido'], 2, ',', '.')) . '</td></tr>'
        . '</table>'
        . '<a href="' . cp_html($portalUrl) . '" style="display:inline-block;background:#f58220;color:#ffffff;text-decoration:none;font-weight:bold;border-radius:6px;padding:12px 18px;">Acessar Portal do Fornecedor</a>'
        . '</div></div></body></html>';

    smtp_send($config, $recipients, $subject, $body, $htmlBody);
    return count($recipients);
}

function cp_workflow_update(int $id, string $workflowAction): void
{
    if ($id <= 0) {
        api_response(false, ['message' => 'Informe o pedido.'], 422);
    }

    $stmt = db()->prepare(
        "SELECT c.id, c.id AS ID, c.Localizacao, c.Publicado, c.status_id, c.Iteracao
           FROM cp_compras c
          WHERE c.id = :id"
    );
    $stmt->execute(['id' => $id]);
    $pedido = $stmt->fetch();
    if (!$pedido) {
        api_response(false, ['message' => 'Pedido não encontrado.'], 404);
    }

    $operation = [
        'enviar_proposta' => 'enviar proposta',
        'aprovar' => 'aprovar',
        'recusar' => 'recusar',
    ][$workflowAction] ?? 'alterar';
    if (cp_localizacao_fornecedor((string) $pedido['Localizacao'])) {
        api_response(false, [
            'message' => "Pedido com localização {$pedido['Localizacao']} não permite $operation. Apenas visualização e impressão.",
        ], 403);
    }

    $usuario = cp_current_user_name();
    if ($workflowAction === 'enviar_proposta') {
        $recipientCount = cp_send_proposta_email($id);
        $stmt = db()->prepare(
            "UPDATE cp_compras
                SET Publicado = 1,
                    Localizacao = 'Fornecedor',
                    Iteracao = COALESCE(Iteracao, 0) + 1,
                    Alteracao = :alteracao,
                    Usuario = :usuario
              WHERE id = :id"
        );
        $stmt->execute(['alteracao' => date('Y-m-d'), 'usuario' => $usuario, 'id' => $id]);
        api_response(true, [
            'message' => 'Proposta enviada ao fornecedor por e-mail.',
            'destinatarios' => $recipientCount,
        ]);
    }

    if ($workflowAction === 'aprovar') {
        if ((int) ($pedido['Publicado'] ?? 0) !== 1) {
            api_response(false, ['message' => 'Pedido não publicado não pode ser aprovado.'], 422);
        }
        $temFotosFornecedor = cp_pedido_tem_fotos_fornecedor($id);
        if ((int) ($pedido['status_id'] ?? 0) === CP_STATUS_APROVADO_AGUARDANDO_FOTO && !$temFotosFornecedor) {
            api_response(false, ['message' => 'Insira fotos do fornecedor antes de aprovar este pedido.'], 422);
        }
        if (!$temFotosFornecedor) {
            $recipientCount = cp_send_proposta_email($id, true);
            $stmt = db()->prepare(
                "UPDATE cp_compras
                    SET status_id = :status_id,
                        Localizacao = 'Fornecedor',
                        Publicado = 1,
                        Iteracao = COALESCE(Iteracao, 0) + 1,
                        DataAprovacao = :data_aprovacao,
                        UsuarioAprovacao = :usuario_aprovacao,
                        Alteracao = :alteracao,
                        Usuario = :usuario
                  WHERE id = :id"
            );
            $stmt->execute([
                'status_id' => CP_STATUS_APROVADO_AGUARDANDO_FOTO,
                'data_aprovacao' => date('Y-m-d'),
                'alteracao' => date('Y-m-d'),
                'usuario_aprovacao' => $usuario,
                'usuario' => $usuario,
                'id' => $id,
            ]);
            api_response(true, [
                'message' => 'Pedido aprovado aguardando foto fornecedor e enviado ao fornecedor por e-mail.',
                'destinatarios' => $recipientCount,
            ]);
        }
        $statusIdAprovacao = $temFotosFornecedor ? CP_STATUS_APROVADO : CP_STATUS_APROVADO_AGUARDANDO_FOTO;
        $stmt = db()->prepare(
            "UPDATE cp_compras
                SET status_id = :status_id,
                    Localizacao = 'KidStok',
                    DataAprovacao = :data_aprovacao,
                    UsuarioAprovacao = :usuario_aprovacao,
                    Alteracao = :alteracao,
                    Usuario = :usuario
              WHERE id = :id"
        );
        $stmt->execute([
            'status_id' => $statusIdAprovacao,
            'data_aprovacao' => date('Y-m-d'),
            'alteracao' => date('Y-m-d'),
            'usuario_aprovacao' => $usuario,
            'usuario' => $usuario,
            'id' => $id,
        ]);
        api_response(true, ['message' => $statusIdAprovacao === CP_STATUS_APROVADO ? 'Pedido aprovado.' : 'Pedido aprovado aguardando foto fornecedor.']);
    }

    if ($workflowAction === 'recusar') {
        if ((int) ($pedido['Publicado'] ?? 0) !== 1 || (int) ($pedido['Iteracao'] ?? 0) <= 0) {
            api_response(false, ['message' => 'Pedido só pode ser recusado após publicação e interação com o fornecedor.'], 422);
        }
        $motivo = cp_trim($_POST['motivo'] ?? $_GET['motivo'] ?? '');
        if ($motivo === '') {
            api_response(false, ['message' => 'Informe o motivo da recusa.'], 422);
        }
        $stmt = db()->prepare(
            "UPDATE cp_compras
                SET status_id = :status_id,
                    StsMotivo = :motivo,
                    Localizacao = 'KidStok',
                    DataRecusa = :data_recusa,
                    UsuarioRecusa = :usuario_recusa,
                    Alteracao = :alteracao,
                    Usuario = :usuario
              WHERE id = :id"
        );
        $stmt->execute([
            'status_id' => CP_STATUS_RECUSADO,
            'motivo' => $motivo,
            'data_recusa' => date('Y-m-d'),
            'alteracao' => date('Y-m-d'),
            'usuario_recusa' => $usuario,
            'usuario' => $usuario,
            'id' => $id,
        ]);
        api_response(true, ['message' => 'Pedido recusado.']);
    }

    api_response(false, ['message' => 'Ação de workflow inválida.'], 404);
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
            $where = "WHERE CAST(c.id AS CHAR) LIKE :q_id
                         OR cst.descricao_compras LIKE :q_sts
                         OR c.Localizacao LIKE :q_localizacao
                         OR c.Fornecedor_id LIKE :q_fornecedor_codigo
                         OR COALESCE(NULLIF(e.Fantasia, ''), e.Nome) LIKE :q_empresa
                         OR cd.NomeCD LIKE :q_cd";
            $params = [
                'q_id' => '%' . $term . '%',
                'q_sts' => '%' . $term . '%',
                'q_localizacao' => '%' . $term . '%',
                'q_fornecedor_codigo' => '%' . $term . '%',
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
            "SELECT c.id,
                    c.id AS ID,
                    c.DataPedido,
                    c.ValorTotalPedido,
                    c.status_id,
                    COALESCE(cst.descricao_compras, '') AS descricao_compras,
                    COALESCE(cst.descricao_compras, '') AS Sts,
                    c.Localizacao,
                    c.Publicado,
                    c.Fornecedor_id AS fornecedor_codigo,
                    cd.NomeCD AS cd_nome,
                    COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_nome,
                    $fornecedorLabel AS fornecedor_nome
               FROM cp_compras c
               LEFT JOIN empresas_cd cd ON cd.Codigo = c.cd_id
               LEFT JOIN empresas e ON e.Codigo = c.empresa_id
               LEFT JOIN cp_compras_status cst ON cst.id = c.status_id
               $fornecedorJoin
               $where
              ORDER BY c.id DESC
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
            api_response(false, ['message' => 'Informe fornecedor e referência.'], 422);
        }
        $item = cp_load_referencia_item($fornecedorId, $codigoReferencia);
        if (!$item) {
            api_response(false, ['message' => 'Referência não encontrada para este fornecedor.'], 404);
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

    if ($action === 'cor_log_ultimo') {
        $pedidoId = (int) ($data['pedido_id'] ?? 0);
        $corId = (int) ($data['cor_id'] ?? 0);
        api_response(true, ['data' => cp_ultimo_log_cor($pedidoId, $corId)]);
    }

    if ($action === 'fotos_upload') {
        $pedidoId = (int) ($data['pedido_id'] ?? 0);
        $referencia = cp_trim($data['referencia'] ?? '');
        $fornecedorId = cp_trim($data['fornecedor_id'] ?? '');
        $origem = cp_trim($data['origem'] ?? 'kidstok');
        if ($origem === 'fornecedor') {
            cp_upload_fotos_fornecedor($pedidoId, $referencia, $fornecedorId);
        }
        cp_upload_fotos_ks($pedidoId, $referencia, $fornecedorId);
    }

    if ($action === 'fotos_delete') {
        $pedidoId = (int) ($data['pedido_id'] ?? 0);
        $referencia = cp_trim($data['referencia'] ?? '');
        $fornecedorId = cp_trim($data['fornecedor_id'] ?? '');
        $fotoId = (int) ($data['foto_id'] ?? 0);
        $origem = cp_trim($data['origem'] ?? 'kidstok');
        if ($origem === 'fornecedor') {
            cp_delete_foto_fornecedor($pedidoId, $referencia, $fornecedorId, $fotoId);
        }
        cp_delete_foto_ks($pedidoId, $referencia, $fornecedorId, $fotoId);
    }

    if ($action === 'delete') {
        $id = (int) ($data['id'] ?? 0);
        cp_require_pedido_editavel($id, 'excluir');
        db()->beginTransaction();
        cp_delete_children($id);
        $stmt = db()->prepare("DELETE FROM cp_compras WHERE id = :id");
        $stmt->execute(['id' => $id]);
        db()->commit();
        api_response(true, ['message' => 'Pedido excluído.']);
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
            if ((int) ($item['Sts'] ?? 1) === 0) {
                continue;
            }
            foreach (($item['tamanhos'] ?? []) as $tamanho) {
                if ((int) ($tamanho['Sts'] ?? 1) === 0) {
                    continue;
                }
                foreach (($tamanho['cores'] ?? []) as $cor) {
                    if ((int) ($cor['Sts'] ?? 1) === 0) {
                        continue;
                    }
                    $total += cp_decimal($cor['valor_total_produto'] ?? (cp_decimal($cor['Qtde'] ?? 0) * cp_decimal($cor['preco_proposta'] ?? 0)));
                }
            }
        }
        $payload['ValorTotalPedido'] = $total;

        $user = current_user();
        $payload['Usuario'] = (string) ($user['login'] ?? $user['nome'] ?? '');
        if ($payload['Sts'] !== 'Recusado') {
            $payload['StsMotivo'] = '';
        }

        if ($id > 0) {
            cp_require_pedido_editavel($id, 'editar');
        } else {
            $payload['Sts'] = 'Aberto';
            $payload['Publicado'] = 0;
            $payload['StsMotivo'] = '';
            $payload['Localizacao'] = 'KidStok';
        }

        $payload['status_id'] = cp_status_id($payload['Sts']);
        unset($payload['Sts']);

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
                        status_id = :status_id,
                        TemFotos = :TemFotos,
                        Publicado = :Publicado,
                        StsMotivo = :StsMotivo,
                        Localizacao = :Localizacao,
                        Alteracao = :Alteracao,
                        Usuario = :Usuario
                  WHERE id = :id"
            );
            $stmt->execute($payload);
            cp_save_items($id, $items, $payload['Fornecedor_id'], $payload['DataPedido']);
            db()->commit();
            api_response(true, ['message' => 'Pedido atualizado.', 'id' => $id]);
        }

        $payload['Inclusao'] = date('Y-m-d');
        $payload['Alteracao'] = null;
        $stmt = db()->prepare(
            "INSERT INTO cp_compras
                (cd_id, empresa_id, Fornecedor_id, DataPedido, MarkupFranqueadora, MarkupFranquia, MarkupTotal,
                 ValorTotalPedido, status_id, TemFotos, Publicado, StsMotivo, Localizacao, Inclusao, Alteracao, Usuario)
             VALUES
                (:cd_id, :empresa_id, :Fornecedor_id, :DataPedido, :MarkupFranqueadora, :MarkupFranquia, :MarkupTotal,
                 :ValorTotalPedido, :status_id, :TemFotos, :Publicado, :StsMotivo, :Localizacao, :Inclusao, :Alteracao, :Usuario)"
        );
        $stmt->execute($payload);
        $newId = (int) db()->lastInsertId();
        cp_save_items($newId, $items, $payload['Fornecedor_id'], $payload['DataPedido']);
        db()->commit();
        api_response(true, ['message' => 'Pedido inserido.', 'id' => $newId]);
    }

    api_response(false, ['message' => 'Ação inválida.'], 404);
} catch (Throwable $e) {
    if (db()->inTransaction()) {
        db()->rollBack();
    }
    api_response(false, ['message' => $e->getMessage()], 500);
}
