<?php
/*
    Autor: Claudio Barto
    Data : 16/09/2026
*/
$aplicacao_nome = "pre_cadastro_produtos.php";
$aplicacao_descricao = "API para gerar pre-cadastro de produtos a partir de pedidos de compra.";

require_once __DIR__ . '/../bootstrap.php';
api_require_login();

$action = (string) ($_GET['action'] ?? $_POST['action'] ?? 'list');
$data = request_data();

function pc_trim($value): string
{
    return trim((string) ($value ?? ''));
}

function pc_decimal($value): float
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

function pc_null_if_empty($value)
{
    $value = pc_trim($value);
    return $value === '' ? null : $value;
}

function pc_table_exists(string $table): bool
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

function pc_column_exists(string $table, string $column): bool
{
    $stmt = db()->prepare(
        'SELECT COUNT(*)
           FROM INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = :table_name
            AND COLUMN_NAME = :column_name'
    );
    $stmt->execute(['table_name' => $table, 'column_name' => $column]);
    return (int) $stmt->fetchColumn() > 0;
}

function pc_column_sql_definition(array $column): string
{
    $sql = $column['COLUMN_TYPE'];
    $sql .= ($column['IS_NULLABLE'] ?? 'YES') === 'NO' ? ' NOT NULL' : ' NULL';
    if ($column['COLUMN_DEFAULT'] !== null) {
        $sql .= ' DEFAULT ' . db()->quote((string) $column['COLUMN_DEFAULT']);
    }
    if (pc_trim($column['EXTRA'] ?? '') !== '') {
        $sql .= ' ' . $column['EXTRA'];
    }
    if (pc_trim($column['COLUMN_COMMENT'] ?? '') !== '') {
        $sql .= ' COMMENT ' . db()->quote((string) $column['COLUMN_COMMENT']);
    }
    return $sql;
}

function pc_table_columns(string $table): array
{
    $stmt = db()->prepare(
        'SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, EXTRA, COLUMN_COMMENT
           FROM INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = :table_name
          ORDER BY ORDINAL_POSITION'
    );
    $stmt->execute(['table_name' => $table]);
    return $stmt->fetchAll();
}

function pc_ensure_history_table(string $sourceTable, string $historyTable): void
{
    if (!pc_table_exists($sourceTable)) {
        api_response(false, ['message' => "Tabela $sourceTable nao encontrada."], 500);
    }
    if (!pc_table_exists($historyTable)) {
        db()->exec("CREATE TABLE `$historyTable` LIKE `$sourceTable`");
    }

    $historyColumns = array_flip(array_map(static fn(array $column): string => $column['COLUMN_NAME'], pc_table_columns($historyTable)));
    foreach (pc_table_columns($sourceTable) as $column) {
        $columnName = $column['COLUMN_NAME'];
        if (isset($historyColumns[$columnName])) {
            continue;
        }
        db()->exec("ALTER TABLE `$historyTable` ADD COLUMN `$columnName` " . pc_column_sql_definition($column));
    }
}

function pc_common_columns(string $sourceTable, string $historyTable): array
{
    $historyColumns = array_flip(array_map(static fn(array $column): string => $column['COLUMN_NAME'], pc_table_columns($historyTable)));
    $common = [];
    foreach (pc_table_columns($sourceTable) as $column) {
        $columnName = $column['COLUMN_NAME'];
        if (isset($historyColumns[$columnName])) {
            $common[] = $columnName;
        }
    }
    return $common;
}

function pc_column_list(array $columns): string
{
    return implode(', ', array_map(static fn(string $column): string => "`$column`", $columns));
}

function pc_exists(string $table, string $column, $value): bool
{
    if ($value === null || $value === '') {
        return false;
    }
    $stmt = db()->prepare("SELECT COUNT(*) FROM `$table` WHERE `$column` = :value");
    $stmt->execute(['value' => $value]);
    return (int) $stmt->fetchColumn() > 0;
}

function pc_reference_exists(string $referencia, int $excludePreCadastroId = 0): bool
{
    $sql = "SELECT COUNT(*)
              FROM pre_cadastro_item_pro pro
              INNER JOIN pre_cadastro_item item ON item.id = pro.pre_cadastro_item_id
             WHERE pro.referencia = :referencia";
    $params = ['referencia' => $referencia];
    if ($excludePreCadastroId > 0) {
        $sql .= " AND item.pre_cadastro_id <> :pre_cadastro_id";
        $params['pre_cadastro_id'] = $excludePreCadastroId;
    }
    $stmt = db()->prepare($sql);
    $stmt->execute($params);
    return (int) $stmt->fetchColumn() > 0;
}

function pc_product_master_exists(string $referenciaMaster): bool
{
    if ($referenciaMaster === '' || !pc_table_exists('produtos_cab')) {
        return false;
    }

    $stmt = db()->prepare("SELECT COUNT(*) FROM produtos_cab WHERE Referencia = :referencia");
    $stmt->execute(['referencia' => $referenciaMaster]);
    return (int) $stmt->fetchColumn() > 0;
}

function pc_pre_cadastro_consolidado(int $preCadastroId): bool
{
    if ($preCadastroId <= 0) {
        return false;
    }

    $stmt = db()->prepare("SELECT consolidado FROM pre_cadastro WHERE id = :id LIMIT 1");
    $stmt->execute(['id' => $preCadastroId]);
    $value = $stmt->fetchColumn();
    return $value !== false && (int) $value === 1;
}

function pc_fix_text_encoding($value): string
{
    $text = (string) ($value ?? '');
    if ($text === '' || (strpos($text, 'Ãƒ') === false && strpos($text, 'Ã‚') === false)) {
        return $text;
    }
    if (function_exists('mb_convert_encoding')) {
        return mb_convert_encoding(mb_convert_encoding($text, 'ISO-8859-1', 'UTF-8'), 'UTF-8', 'ISO-8859-1');
    }
    return $text;
}

function pc_cut(string $text, int $start, int $length): string
{
    if (function_exists('mb_substr')) {
        return mb_substr($text, $start, $length, 'UTF-8');
    }
    return substr($text, $start, $length);
}

function pc_text_len(string $text): int
{
    return function_exists('mb_strlen') ? mb_strlen($text, 'UTF-8') : strlen($text);
}

function pc_option_text(array $row, array $columns): string
{
    $parts = [];
    foreach ($columns as $column) {
        if (isset($row[$column]) && pc_trim($row[$column]) !== '') {
            $parts[] = pc_trim($row[$column]);
        }
    }
    return implode(' - ', array_unique($parts));
}

function pc_domain_options(string $type, string $q, string $grupo = '', string $categoria = ''): void
{
    $term = '%' . $q . '%';
    $map = [
        'pedidos' => [
            'sql' => "SELECT c.id, CONCAT('Pedido ', c.id, ' - ', COALESCE(NULLIF(f.NomeFornecedor, ''), c.Fornecedor_id)) AS text
                       FROM cp_compras c
                        LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor_id
                       WHERE c.status_id = 2
                         AND NOT EXISTS (
                             SELECT 1
                               FROM pre_cadastro pc
                              WHERE pc.cp_compras_id = c.id
                         )
                         AND (
                              CAST(c.id AS CHAR) LIKE :q_id
                              OR c.Fornecedor_id LIKE :q_fornecedor
                              OR f.NomeFornecedor LIKE :q_nome
                         )
                       ORDER BY c.id DESC
                       LIMIT 30",
            'params' => ['q_id', 'q_fornecedor', 'q_nome'],
        ],
        'categorias' => ['table' => 'produtos_categorias', 'id' => 'Codigo', 'text' => ['TipoProduto', 'Codigo']],
        'colecoes' => ['table' => 'produtos_colecao', 'id' => 'Codigo', 'text' => ['Colecao', 'Codigo']],
        'linhas' => ['table' => 'produtos_linhas', 'id' => 'Codigo', 'text' => ['Linha', 'Codigo']],
        'medidas' => ['table' => 'produtos_medidas', 'id' => 'Sigla', 'text' => ['Sigla', 'Unidade']],
        'grupos' => [
            'sql' => "SELECT DISTINCT Grupo AS id, Grupo AS text
                       FROM produtos_grupos
                      WHERE Grupo LIKE :q
                      ORDER BY Grupo
                      LIMIT 30",
        ],
        'subgrupos' => ['table' => 'produtos_grupos', 'id' => 'SubGrupo', 'text' => ['SubGrupo', 'Grupo']],
        'generos' => ['table' => 'produtos_generos', 'id' => 'Codigo', 'text' => ['Genero', 'Codigo']],
        'composicoes' => ['table' => 'produtos_composicoes', 'id' => 'Codigo', 'text' => ['Composicao', 'Codigo']],
        'caracteristicas' => ['table' => 'produtos_caracteristicas', 'id' => 'Codigo', 'text' => ['Caracteristica', 'Codigo']],
        'estilos' => ['table' => 'produtos_estilos', 'id' => 'Codigo', 'text' => ['Descricao', 'Codigo']],
        'ncm' => ['table' => 'cests_ncm', 'id' => 'ncm', 'text' => ['ncm', 'descricao']],
        'origens' => ['table' => 'st_origem', 'id' => 'Codigo', 'text' => ['Codigo', 'Descricao']],
        'st_icms' => ['table' => 'st_icms', 'id' => 'Codigo', 'text' => ['Codigo', 'Descricao']],
        'st_pis' => ['table' => 'st_pis', 'id' => 'Codigo', 'text' => ['Codigo', 'Descricao']],
        'st_cofins' => ['table' => 'st_cofins', 'id' => 'Codigo', 'text' => ['Codigo', 'Descricao']],
        'st_ipi' => ['table' => 'st_ipi', 'id' => 'Codigo', 'text' => ['Codigo', 'Descricao']],
        'cfops' => ['table' => 'cfops', 'id' => 'CFOP', 'text' => ['CFOP', 'Descricao']],
        'tamanhos' => ['table' => 'produtos_tamanho', 'id' => 'Codigo', 'text' => ['Codigo', 'Nome']],
        'cores' => ['table' => 'produtos_cor', 'id' => 'Codigo', 'text' => ['Codigo', 'Nome']],
    ];
    if (!isset($map[$type])) {
        api_response(false, ['message' => 'Tipo invalido.'], 404);
    }
    if ($type === 'subgrupos' && $grupo === '') {
        api_response(true, ['results' => []]);
    }
    if (($type === 'composicoes' || $type === 'caracteristicas') && $categoria === '') {
        api_response(true, ['results' => []]);
    }
    if ($type === 'composicoes') {
        $stmt = db()->prepare(
            "SELECT c.Codigo AS id,
                    CONCAT(c.Composicao, ' - ', c.Codigo) AS text
               FROM produtos_categoria_composicao cc
               INNER JOIN produtos_categorias_livre cl ON cl.Codigo = cc.Categoria
               INNER JOIN produtos_composicoes c ON c.Codigo = cc.Composicao
              WHERE cl.CategoriaLivre = :categoria
                AND (CAST(c.Codigo AS CHAR) LIKE :q_codigo OR c.Composicao LIKE :q_nome)
              ORDER BY c.Composicao
              LIMIT 30"
        );
        $stmt->execute(['categoria' => $categoria, 'q_codigo' => $term, 'q_nome' => $term]);
        api_response(true, ['results' => array_map(static function (array $row): array {
            return ['id' => (string) $row['id'], 'text' => (string) $row['text']];
        }, $stmt->fetchAll())]);
    }
    if ($type === 'caracteristicas') {
        $stmt = db()->prepare(
            "SELECT c.Codigo AS id,
                    CONCAT(c.Caracteristica, ' - ', c.Codigo) AS text
               FROM produtos_categoria_caracteristicas cc
               INNER JOIN produtos_categorias_livre cl ON cl.Codigo = cc.Categoria
               INNER JOIN produtos_caracteristicas c ON c.Codigo = cc.Caracteristica
              WHERE cl.CategoriaLivre = :categoria
                AND (CAST(c.Codigo AS CHAR) LIKE :q_codigo OR c.Caracteristica LIKE :q_nome)
              ORDER BY c.Caracteristica
              LIMIT 30"
        );
        $stmt->execute(['categoria' => $categoria, 'q_codigo' => $term, 'q_nome' => $term]);
        api_response(true, ['results' => array_map(static function (array $row): array {
            return ['id' => (string) $row['id'], 'text' => (string) $row['text']];
        }, $stmt->fetchAll())]);
    }
    if (isset($map[$type]['sql'])) {
        $stmt = db()->prepare($map[$type]['sql']);
        $params = ['q' => $term];
        if (!empty($map[$type]['params'])) {
            $params = [];
            foreach ($map[$type]['params'] as $param) {
                $params[$param] = $term;
            }
        }
        $stmt->execute($params);
        api_response(true, ['results' => $stmt->fetchAll()]);
    }

    $cfg = $map[$type];
    if (!pc_table_exists($cfg['table'])) {
        api_response(true, ['results' => []]);
    }
    $where = [];
    $params = [];
    foreach (array_unique(array_merge([$cfg['id']], $cfg['text'])) as $column) {
        $param = 'q_' . count($params);
        $where[] = "CAST(`$column` AS CHAR) LIKE :$param";
        $params[$param] = $term;
    }
    $whereSql = implode(' OR ', $where);
    if ($type === 'subgrupos') {
        $whereSql = '`Grupo` = :grupo AND (' . $whereSql . ')';
        $params['grupo'] = $grupo;
    }
    $stmt = db()->prepare(
        "SELECT *
           FROM `{$cfg['table']}`
          WHERE $whereSql
          ORDER BY `{$cfg['id']}`
          LIMIT 30"
    );
    $stmt->execute($params);
    $results = array_map(static function (array $row) use ($cfg): array {
        return [
            'id' => (string) $row[$cfg['id']],
            'text' => pc_option_text($row, $cfg['text']) ?: (string) $row[$cfg['id']],
        ];
    }, $stmt->fetchAll());
    api_response(true, ['results' => $results]);
}

function pc_load_pedido_rows(int $pedidoId): array
{
    $deparaSelect = pc_table_exists('cp_depara_cor') ? ', dc.codigo_ks AS cor_codigo_ks' : ", NULL AS cor_codigo_ks";
    $deparaJoin = pc_table_exists('cp_depara_cor') ? 'LEFT JOIN cp_depara_cor dc ON dc.cor_fornecedor = co.cor' : '';
    $colecaoSelect = pc_table_exists('pf_colecao') ? ', pfc.colecao_id AS pf_colecao_id' : ', NULL AS pf_colecao_id';
    $colecaoJoin = pc_table_exists('pf_colecao') ? 'LEFT JOIN pf_colecao pfc ON pfc.id_fornecedor = c.Fornecedor_id AND pfc.sku = co.sku' : '';
    $stmt = db()->prepare(
        "SELECT c.id AS pedido_id, c.cd_id, c.empresa_id, c.Fornecedor_id, c.MarkupFranqueadora,
                c.MarkupFranquia, c.MarkupTotal, c.ValorTotalPedido, c.status_id,
                cd.NomeCD AS cd_nome,
                COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_nome,
                COALESCE(NULLIF(f.NomeFornecedor, ''), c.Fornecedor_id) AS fornecedor_nome
           FROM cp_compras c
           LEFT JOIN empresas_cd cd ON cd.Codigo = c.cd_id
           LEFT JOIN empresas e ON e.Codigo = c.empresa_id
           LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor_id
          WHERE c.id = :id"
    );
    $stmt->execute(['id' => $pedidoId]);
    $pedido = $stmt->fetch();
    if (!$pedido) {
        api_response(false, ['message' => 'Pedido nao encontrado.'], 404);
    }
    if ((int) ($pedido['status_id'] ?? 0) !== 2) {
        api_response(false, ['message' => 'Somente pedidos aprovados podem gerar pre-cadastro.'], 422);
    }

    $stmt = db()->prepare(
        "SELECT i.id AS item_id, i.referencia_fornecedor, i.descricao, i.composicao, i.ncm,
                i.Categoria, i.entrega AS item_entrega, i.Sts AS item_sts,
                t.id AS tamanho_id, t.tamanho, t.entrega AS tamanho_entrega, t.Sts AS tamanho_sts,
                co.id AS cor_id, co.sku, co.cor, co.Qtde, co.preco_fornecedor, co.preco_proposta,
                co.preco_franqueado, co.preco_loja, co.valor_total_produto, co.Sts AS cor_sts
                $colecaoSelect
                $deparaSelect
           FROM cp_compras_itens i
           INNER JOIN cp_compras c ON c.id = i.cp_compras_id
           INNER JOIN cp_compras_itens_tamanhos t ON t.compras_itens_id = i.id
           INNER JOIN cp_compras_itens_cores co ON co.compras_itens_tamanho_id = t.id
           $colecaoJoin
           $deparaJoin
          WHERE i.cp_compras_id = :id
            AND i.Sts = 1
            AND t.Sts = 1
            AND co.Sts = 1
          ORDER BY i.id, t.id, co.id"
    );
    $stmt->execute(['id' => $pedidoId]);
    return ['pedido' => $pedido, 'rows' => $stmt->fetchAll()];
}

function pc_domain_value(string $table, string $idColumn, array $textColumns, $value): ?array
{
    if ($value === null || $value === '' || !pc_exists($table, $idColumn, $value)) {
        return null;
    }
    $stmt = db()->prepare("SELECT * FROM `$table` WHERE `$idColumn` = :id LIMIT 1");
    $stmt->execute(['id' => $value]);
    $row = $stmt->fetch();
    if (!$row) {
        return null;
    }
    return ['id' => (string) $value, 'text' => pc_option_text($row, $textColumns) ?: (string) $value];
}

function pc_build_preview(int $pedidoId): array
{
    $loaded = pc_load_pedido_rows($pedidoId);
    $pedido = $loaded['pedido'];
    $rows = $loaded['rows'];
    if (!$rows) {
        api_response(false, ['message' => 'Pedido sem itens, tamanhos e cores ativos para gerar pre-cadastro.'], 422);
    }

    $groups = [];
    $warnings = [];
    foreach ($rows as $row) {
        $categoria = pc_trim($row['Categoria'] ?? '');
        $dataEntrega = pc_trim($row['tamanho_entrega'] ?? '') ?: pc_trim($row['item_entrega'] ?? '');
        if ($categoria === '') {
            $warnings[] = 'Item ' . $row['referencia_fornecedor'] . ' sem categoria.';
        }
        $key = $categoria . '|' . $dataEntrega;
        if (!isset($groups[$key])) {
            $groups[$key] = [
                'cp_compras_id' => (int) $pedido['pedido_id'],
                'cd_id' => (int) $pedido['cd_id'],
                'empresa_id' => (int) $pedido['empresa_id'],
                'fornecedor_id' => (string) $pedido['Fornecedor_id'],
                'Categoria' => $categoria,
                'data_entrega' => $dataEntrega,
                'markup_franqueadora' => (float) $pedido['MarkupFranqueadora'],
                'markup_franquia' => (float) $pedido['MarkupFranquia'],
                'markup_total' => (float) $pedido['MarkupTotal'],
                'items' => [],
            ];
        }
        $itemKey = (string) $row['item_id'];
        $colecaoId = pc_trim($row['pf_colecao_id'] ?? '');
        $colecaoOption = $colecaoId !== '' ? pc_domain_value('produtos_colecao', 'Codigo', ['Colecao', 'Codigo'], $colecaoId) : null;
        if (!isset($groups[$key]['items'][$itemKey])) {
            $descricao = pc_fix_text_encoding($row['descricao'] ?? '');
            $ncmOption = pc_domain_value('cests_ncm', 'ncm', ['ncm', 'descricao'], pc_trim($row['ncm'] ?? ''));
            $groups[$key]['items'][$itemKey] = [
                'cp_compras_itens_id' => (int) $row['item_id'],
                'referencia_fornecedor' => (string) $row['referencia_fornecedor'],
                'r1' => (string) $pedido['Fornecedor_id'],
                'r2' => $categoria,
                'r3' => '',
                'referencia_master' => '',
                'codigo_fornecdor' => (string) $row['referencia_fornecedor'],
                'composicao' => pc_fix_text_encoding($row['composicao'] ?? ''),
                'colecao_id' => $colecaoOption['id'] ?? '',
                'colecao_id_text' => $colecaoOption['text'] ?? '',
                'descricao' => pc_cut($descricao, 0, 50),
                'descricao_complementar' => pc_text_len($descricao) > 50 ? pc_cut($descricao, 50, 70) : '',
                'Unidade' => 'PC',
                'Unidade_text' => 'PC - Peça',
                'ncm' => $ncmOption['id'] ?? '',
                'ncm_text' => $ncmOption['text'] ?? '',
                'cfop' => '5102',
                'cfop_text' => '5102',
                'cfop_propria' => '',
                'setor_laranja' => 'N',
                'preco_cheio' => 'N',
                'sts' => (int) $row['item_sts'],
                'fields' => [],
                'products' => [],
            ];
        }
        if ($colecaoOption && pc_trim($groups[$key]['items'][$itemKey]['colecao_id'] ?? '') === '') {
            $groups[$key]['items'][$itemKey]['colecao_id'] = $colecaoOption['id'];
            $groups[$key]['items'][$itemKey]['colecao_id_text'] = $colecaoOption['text'];
        }
        $tamanhoOrigem = pc_trim($row['tamanho'] ?? '');
        $tamanhoOption = pc_domain_value('produtos_tamanho', 'Codigo', ['Codigo', 'Nome'], $tamanhoOrigem);
        $corCodigoKs = pc_trim($row['cor_codigo_ks'] ?? '');
        $corOption = pc_domain_value('produtos_cor', 'Codigo', ['Codigo', 'Nome'], $corCodigoKs);
        $groups[$key]['items'][$itemKey]['products'][] = [
            'compras_itens_tamanho_id' => (int) $row['tamanho_id'],
            'compras_itens_cor_id' => (int) $row['cor_id'],
            'referencia_master' => '',
            'tamanho' => $tamanhoOption['id'] ?? $tamanhoOrigem,
            'tamanho_text' => $tamanhoOption['text'] ?? '',
            'tamanho_origem' => $tamanhoOrigem,
            'cor' => $corOption['id'] ?? '',
            'cor_text' => $corOption['text'] ?? '',
            'cor_origem' => pc_fix_text_encoding($row['cor'] ?? ''),
            'referencia' => '',
            'sku' => (string) ($row['sku'] ?? ''),
            'qtde' => (float) $row['Qtde'],
            'preco_fornecedor' => (float) $row['preco_fornecedor'],
            'preco_compra' => (float) $row['preco_proposta'],
            'preco_atacado' => (float) $row['preco_franqueado'],
            'preco_varejo' => (float) $row['preco_loja'],
            'setor_laranja' => 'N',
            'preco_cheio' => 'N',
            'valor_total_produto' => (float) $row['valor_total_produto'],
        ];
    }

    foreach ($groups as &$group) {
        $group['items'] = array_values($group['items']);
        pc_recalc_group($group);
    }
    unset($group);

    return [
        'pedido' => [
            'id' => (int) $pedido['pedido_id'],
            'cd' => $pedido['cd_nome'],
            'empresa' => $pedido['empresa_nome'],
            'fornecedor' => $pedido['fornecedor_nome'],
            'valor_total' => (float) $pedido['ValorTotalPedido'],
        ],
        'groups' => array_values($groups),
        'warnings' => array_values(array_unique($warnings)),
    ];
}

function pc_load_pre_cadastro(int $preCadastroId): array
{
    $stmt = db()->prepare(
        "SELECT pc.*,
                cd.NomeCD AS cd_nome,
                COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_nome,
                COALESCE(NULLIF(f.NomeFornecedor, ''), pc.fornecedor_id) AS fornecedor_nome,
                c.ValorTotalPedido
           FROM pre_cadastro pc
           LEFT JOIN cp_compras c ON c.id = pc.cp_compras_id
           LEFT JOIN empresas_cd cd ON cd.Codigo = pc.cd_id
           LEFT JOIN empresas e ON e.Codigo = pc.empresa_id
           LEFT JOIN produtos_fornecedor f ON f.Codigo = pc.fornecedor_id
          WHERE pc.id = :id
          LIMIT 1"
    );
    $stmt->execute(['id' => $preCadastroId]);
    $header = $stmt->fetch();
    if (!$header) {
        api_response(false, ['message' => 'Pre-cadastro nao encontrado.'], 404);
    }

    $stmt = db()->prepare(
        "SELECT *
           FROM pre_cadastro_item
          WHERE pre_cadastro_id = :id
          ORDER BY id"
    );
    $stmt->execute(['id' => $preCadastroId]);
    $itemsRows = $stmt->fetchAll();

    $productsByItem = [];
    if ($itemsRows) {
        $itemIds = array_map(static fn(array $row): int => (int) $row['id'], $itemsRows);
        $placeholders = implode(',', array_fill(0, count($itemIds), '?'));
        $stmt = db()->prepare(
            "SELECT *
               FROM pre_cadastro_item_pro
              WHERE pre_cadastro_item_id IN ($placeholders)
              ORDER BY id"
        );
        $stmt->execute($itemIds);
        foreach ($stmt->fetchAll() as $product) {
            $productsByItem[(int) $product['pre_cadastro_item_id']][] = $product;
        }
    }

    $group = [
        'id' => (int) $header['id'],
        'cp_compras_id' => (int) $header['cp_compras_id'],
        'cd_id' => (int) $header['cd_id'],
        'empresa_id' => (int) $header['empresa_id'],
        'fornecedor_id' => (string) $header['fornecedor_id'],
        'Categoria' => (string) $header['Categoria'],
        'data_entrega' => (string) ($header['data_entrega'] ?? ''),
        'markup_franqueadora' => (float) $header['markup_franqueadora'],
        'markup_franquia' => (float) $header['markup_franquia'],
        'markup_total' => (float) $header['markup_total'],
        'valor_total' => (float) $header['valor_total'],
        'Itens' => (int) $header['Itens'],
        'QtdeItens' => (int) $header['QtdeItens'],
        'Tamanhos' => (int) $header['Tamanhos'],
        'QtdeTamanhos' => (int) $header['QtdeTamanhos'],
        'Cores' => (int) $header['Cores'],
        'QtdeCores' => (int) $header['QtdeCores'],
        'consolidado' => (int) ($header['consolidado'] ?? 0),
        'items' => [],
    ];

    foreach ($itemsRows as $itemRow) {
        $unidadeOption = pc_domain_value('produtos_medidas', 'Sigla', ['Sigla', 'Unidade'], $itemRow['Unidade'] ?? '');
        $ncmOption = pc_domain_value('cests_ncm', 'ncm', ['ncm', 'descricao'], $itemRow['ncm'] ?? '');
        $cfopOption = pc_domain_value('cfops', 'CFOP', ['CFOP', 'Descricao'], $itemRow['cfop'] ?? '');
        $cfopPropriaOption = pc_domain_value('cfops', 'CFOP', ['CFOP', 'Descricao'], $itemRow['cfop_propria'] ?? '');
        $origemOption = pc_domain_value('st_origem', 'Codigo', ['Codigo', 'Descricao'], $itemRow['origem'] ?? '');
        $icmsOption = pc_domain_value('st_icms', 'Codigo', ['Codigo', 'Descricao'], $itemRow['cst_icms'] ?? '');
        $pisOption = pc_domain_value('st_pis', 'Codigo', ['Codigo', 'Descricao'], $itemRow['cst_pis'] ?? '');
        $cofinsOption = pc_domain_value('st_cofins', 'Codigo', ['Codigo', 'Descricao'], $itemRow['cst_cofins'] ?? '');
        $ipiOption = pc_domain_value('st_ipi', 'Codigo', ['Codigo', 'Descricao'], $itemRow['cst_ipi'] ?? '');
        $colecaoOption = pc_domain_value('produtos_colecao', 'Codigo', ['Colecao', 'Codigo'], $itemRow['colecao_id'] ?? '');
        $linhaOption = pc_domain_value('produtos_linhas', 'Codigo', ['Linha', 'Codigo'], $itemRow['linha'] ?? '');
        $generoOption = pc_domain_value('produtos_generos', 'Codigo', ['Genero', 'Codigo'], $itemRow['genero_id'] ?? '');
        $composicaoOption = pc_domain_value('produtos_composicoes', 'Codigo', ['Composicao', 'Codigo'], $itemRow['composicao_id'] ?? '');
        $caracteristicaOption = pc_domain_value('produtos_caracteristicas', 'Codigo', ['Caracteristica', 'Codigo'], $itemRow['caracteristica_id'] ?? '');
        $estiloOption = pc_domain_value('produtos_estilos', 'Codigo', ['Descricao', 'Codigo'], $itemRow['estilo'] ?? '');

        $item = [
            'pre_cadastro_item_id' => (int) $itemRow['id'],
            'cp_compras_itens_id' => (int) $itemRow['cp_compras_itens_id'],
            'referencia_fornecedor' => (string) $itemRow['referencia_fornecedor'],
            'r1' => (string) ($itemRow['r1'] ?? ''),
            'r2' => (string) ($itemRow['r2'] ?? ''),
            'r3' => (string) ($itemRow['r3'] ?? ''),
            'referencia_master' => (string) ($itemRow['referencia_master'] ?? ''),
            'codigo_fornecdor' => (string) $itemRow['codigo_fornecdor'],
            'composicao' => (string) $itemRow['composicao'],
            'colecao_id' => (string) ($itemRow['colecao_id'] ?? ''),
            'colecao_id_text' => $colecaoOption['text'] ?? '',
            'linha' => (string) ($itemRow['linha'] ?? ''),
            'linha_text' => $linhaOption['text'] ?? '',
            'peso' => (float) $itemRow['peso'],
            'descricao' => (string) $itemRow['descricao'],
            'descricao_complementar' => (string) $itemRow['descricao_complementar'],
            'Unidade' => (string) $itemRow['Unidade'],
            'Unidade_text' => $unidadeOption['text'] ?? (string) $itemRow['Unidade'],
            'Grupo' => (string) ($itemRow['Grupo'] ?? ''),
            'Grupo_text' => (string) ($itemRow['Grupo'] ?? ''),
            'grupo_categoria' => (string) ($itemRow['grupo_categoria'] ?? ''),
            'grupo_categoria_text' => (string) ($itemRow['grupo_categoria'] ?? ''),
            'genero_id' => (string) ($itemRow['genero_id'] ?? ''),
            'genero_id_text' => $generoOption['text'] ?? '',
            'composicao_id' => (string) ($itemRow['composicao_id'] ?? ''),
            'composicao_id_text' => $composicaoOption['text'] ?? '',
            'caracteristica_id' => (string) ($itemRow['caracteristica_id'] ?? ''),
            'caracteristica_id_text' => $caracteristicaOption['text'] ?? '',
            'setor_laranja' => (string) $itemRow['setor_laranja'],
            'preco_cheio' => (string) $itemRow['preco_cheio'],
            'encomenda' => (string) $itemRow['encomenda'],
            'estilo' => (string) ($itemRow['estilo'] ?? ''),
            'estilo_text' => $estiloOption['text'] ?? '',
            'preco_compra' => (float) $itemRow['preco_compra'],
            'preco_compra_tabela' => (float) $itemRow['preco_compra_tabela'],
            'preco_venda_tabela' => (float) $itemRow['preco_venda_tabela'],
            'ncm' => (string) ($itemRow['ncm'] ?? ''),
            'ncm_text' => $ncmOption['text'] ?? '',
            'origem' => (string) ($itemRow['origem'] ?? ''),
            'origem_text' => $origemOption['text'] ?? '',
            'cst_icms' => (string) $itemRow['cst_icms'],
            'cst_icms_text' => $icmsOption['text'] ?? '',
            'aliquota_icms' => (float) $itemRow['aliquota_icms'],
            'reducao_icms' => (float) $itemRow['reducao_icms'],
            'cst_pis' => (string) $itemRow['cst_pis'],
            'cst_pis_text' => $pisOption['text'] ?? '',
            'aliquota_pis' => (float) $itemRow['aliquota_pis'],
            'aliquota_cofins' => (float) $itemRow['aliquota_cofins'],
            'cst_cofins' => (string) $itemRow['cst_cofins'],
            'cst_cofins_text' => $cofinsOption['text'] ?? '',
            'cst_ipi' => (string) $itemRow['cst_ipi'],
            'cst_ipi_text' => $ipiOption['text'] ?? '',
            'aliquota_ipi' => (float) $itemRow['aliquota_ipi'],
            'cfop' => (string) $itemRow['cfop'],
            'cfop_text' => $cfopOption['text'] ?? (string) $itemRow['cfop'],
            'cfop_propria' => (string) $itemRow['cfop_propria'],
            'cfop_propria_text' => $cfopPropriaOption['text'] ?? '',
            'sts' => (int) $itemRow['sts'],
            'products' => [],
        ];

        foreach ($productsByItem[(int) $itemRow['id']] ?? [] as $productRow) {
            $tamanhoOption = pc_domain_value('produtos_tamanho', 'Codigo', ['Codigo', 'Nome'], $productRow['tamanho'] ?? '');
            $corOption = pc_domain_value('produtos_cor', 'Codigo', ['Codigo', 'Nome'], $productRow['cor'] ?? '');
            $item['products'][] = [
                'pre_cadastro_item_pro_id' => (int) $productRow['id'],
                'compras_itens_tamanho_id' => (string) $productRow['tamanho'],
                'compras_itens_cor_id' => (string) $productRow['cor'],
                'referencia_master' => (string) $productRow['referencia_master'],
                'tamanho' => (string) $productRow['tamanho'],
                'tamanho_text' => $tamanhoOption['text'] ?? (string) $productRow['tamanho'],
                'tamanho_origem' => (string) $productRow['tamanho'],
                'cor' => (string) $productRow['cor'],
                'cor_text' => $corOption['text'] ?? (string) $productRow['cor'],
                'cor_origem' => (string) $productRow['cor'],
                'referencia' => (string) $productRow['referencia'],
                'sku' => (string) $productRow['sku'],
                'qtde' => (float) $productRow['qtde'],
                'preco_fornecedor' => (float) $productRow['preco_fornecedor'],
                'preco_compra' => (float) $productRow['preco_compra'],
                'preco_atacado' => (float) $productRow['preco_atacado'],
                'preco_varejo' => (float) $productRow['preco_varejo'],
                'setor_laranja' => (string) $itemRow['setor_laranja'],
                'preco_cheio' => (string) $itemRow['preco_cheio'],
                'valor_total_produto' => (float) $productRow['qtde'] * (float) $productRow['preco_compra'],
            ];
        }

        $group['items'][] = $item;
    }

    pc_recalc_group($group);

    return [
        'pedido' => [
            'id' => (int) $header['cp_compras_id'],
            'cd' => $header['cd_nome'],
            'empresa' => $header['empresa_nome'],
            'fornecedor' => $header['fornecedor_nome'],
            'valor_total' => (float) ($header['ValorTotalPedido'] ?? $header['valor_total']),
        ],
        'groups' => [$group],
        'warnings' => [],
    ];
}

function pc_recalc_group(array &$group): void
{
    $itemIds = [];
    $tamanhoIds = [];
    $cores = 0;
    $qtde = 0.0;
    $valor = 0.0;
    foreach ($group['items'] as &$item) {
        $itemIds[$item['cp_compras_itens_id']] = true;
        $totalQtde = 0.0;
        $sumCompra = 0.0;
        $sumFranqueado = 0.0;
        $sumLoja = 0.0;
        foreach ($item['products'] as $product) {
            $tamanhoIds[$product['compras_itens_tamanho_id']] = true;
            $cores++;
            $q = (float) $product['qtde'];
            $qtde += $q;
            $totalQtde += $q;
            $valor += (float) $product['valor_total_produto'];
            $sumCompra += $q * (float) $product['preco_compra'];
            $sumFranqueado += $q * (float) $product['preco_atacado'];
            $sumLoja += $q * (float) $product['preco_varejo'];
        }
        $item['preco_compra'] = $totalQtde > 0 ? round($sumCompra / $totalQtde, 2) : 0;
        $item['preco_compra_tabela'] = $totalQtde > 0 ? round($sumFranqueado / $totalQtde, 2) : 0;
        $item['preco_venda_tabela'] = $totalQtde > 0 ? round($sumLoja / $totalQtde, 2) : 0;
    }
    unset($item);
    $group['Itens'] = count($itemIds);
    $group['QtdeItens'] = (int) $qtde;
    $group['Tamanhos'] = count($tamanhoIds);
    $group['QtdeTamanhos'] = (int) $qtde;
    $group['Cores'] = $cores;
    $group['QtdeCores'] = (int) $qtde;
    $group['valor_total'] = round($valor, 2);
}

function pc_validate_payload(array $groups, int $excludePreCadastroId = 0): array
{
    $errors = [];
    $pedidoStmt = db()->prepare("SELECT status_id FROM cp_compras WHERE id = :id LIMIT 1");
    foreach ($groups as $gIndex => $group) {
        $label = 'Grupo ' . ($gIndex + 1);
        foreach (['cp_compras_id', 'cd_id', 'empresa_id', 'fornecedor_id', 'Categoria'] as $field) {
            if (pc_trim($group[$field] ?? '') === '') {
                $errors[] = "$label: informe $field.";
            }
        }
        if (pc_trim($group['cp_compras_id'] ?? '') !== '') {
            $pedidoStmt->execute(['id' => $group['cp_compras_id']]);
            $statusId = $pedidoStmt->fetchColumn();
            if ($statusId === false) {
                $errors[] = "$label: pedido nao encontrado.";
            } elseif ((int) $statusId !== 2) {
                $errors[] = "$label: pedido nao esta aprovado.";
            }
        }
        if (!pc_exists('produtos_categorias', 'Codigo', $group['Categoria'] ?? '')) {
            $errors[] = "$label: categoria invalida.";
        }
        foreach (($group['items'] ?? []) as $iIndex => $item) {
            $itemLabel = $label . ', item ' . ($iIndex + 1) . ' (' . pc_trim($item['referencia_fornecedor'] ?? '') . ')';
            foreach (['r2', 'r3', 'descricao', 'Unidade', 'cfop', 'cfop_propria', 'cst_icms', 'cst_pis', 'cst_cofins', 'cst_ipi'] as $field) {
                if (pc_trim($item[$field] ?? '') === '') {
                    $errors[] = "$itemLabel: informe $field.";
                }
            }
            if (pc_trim($item['r2'] ?? '') !== '' && !pc_exists('produtos_categorias', 'Codigo', $item['r2'])) {
                $errors[] = "$itemLabel: categoria R2 invalida.";
            }
            if (pc_trim($item['r3'] ?? '') !== '' && !preg_match('/^\d{4}$/', pc_trim($item['r3']))) {
                $errors[] = "$itemLabel: R3 deve conter exatamente 4 numeros.";
            }
            $refMaster = pc_trim($item['r1'] ?? '') . pc_trim($item['r2'] ?? '') . pc_trim($item['r3'] ?? '');
            if (strlen($refMaster) > 8) {
                $errors[] = "$itemLabel: referencia master maior que 8 caracteres.";
            }
            if (pc_trim($item['r1'] ?? '') !== '' && pc_trim($item['r2'] ?? '') !== '' && pc_trim($item['r3'] ?? '') !== '' && pc_product_master_exists($refMaster)) {
                $errors[] = "$itemLabel: referencia master $refMaster ja existe no cadastro de produtos.";
            }
            if (pc_trim($item['ncm'] ?? '') !== '' && !pc_exists('cests_ncm', 'ncm', $item['ncm'])) {
                $errors[] = "$itemLabel: NCM invalido.";
            }
            foreach (($item['products'] ?? []) as $pIndex => $product) {
                $produtoLabel = $itemLabel . ', produto ' . ($pIndex + 1);
                foreach (['tamanho', 'cor'] as $field) {
                    if (pc_trim($product[$field] ?? '') === '') {
                        $errors[] = "$produtoLabel: informe $field.";
                    }
                }
                $referencia = $refMaster . pc_trim($product['tamanho'] ?? '') . pc_trim($product['cor'] ?? '');
                if (strlen($referencia) > 15) {
                    $errors[] = "$produtoLabel: referencia maior que 15 caracteres.";
                }
                if (pc_reference_exists($referencia, $excludePreCadastroId)) {
                    $errors[] = "$produtoLabel: referencia $referencia ja existe.";
                }
            }
        }
    }
    return $errors;
}

function pc_normalize_groups_categories(array &$groups): void
{
    foreach ($groups as &$group) {
        if (pc_trim($group['Categoria'] ?? '') !== '') {
            continue;
        }
        foreach (($group['items'] ?? []) as $item) {
            $r2 = pc_trim($item['r2'] ?? '');
            if ($r2 !== '') {
                $group['Categoria'] = $r2;
                break;
            }
        }
    }
    unset($group);
}

function pc_insert_all(array $groups): array
{
    pc_normalize_groups_categories($groups);
    $errors = pc_validate_payload($groups);
    if ($errors) {
        api_response(false, ['message' => 'Corrija as inconsistencias antes de gravar.', 'errors' => $errors], 422);
    }

    $created = ['pre_cadastro_ids' => [], 'items' => 0, 'products' => 0];
    db()->beginTransaction();
    try {
        $headerStmt = db()->prepare(
            "INSERT INTO pre_cadastro
                (cp_compras_id, cd_id, empresa_id, fornecedor_id, Categoria, data_entrega,
                 markup_franqueadora, markup_franquia, markup_total, valor_total,
                 Itens, QtdeItens, Tamanhos, QtdeTamanhos, Cores, QtdeCores, consolidado)
             VALUES
                (:cp_compras_id, :cd_id, :empresa_id, :fornecedor_id, :Categoria, :data_entrega,
                 :markup_franqueadora, :markup_franquia, :markup_total, :valor_total,
                 :Itens, :QtdeItens, :Tamanhos, :QtdeTamanhos, :Cores, :QtdeCores, 0)"
        );
        $itemStmt = db()->prepare(
            "INSERT INTO pre_cadastro_item
                (pre_cadastro_id, cp_compras_itens_id, referencia_fornecedor, r1, r2, r3, referencia_master,
                 codigo_fornecdor, composicao, colecao_id, linha, peso, descricao, descricao_complementar,
                 Unidade, Grupo, grupo_categoria, genero_id, composicao_id, caracteristica_id, setor_laranja,
                 preco_cheio, encomenda, estilo, preco_compra, preco_compra_tabela, preco_venda_tabela,
                 ncm, origem, cst_icms, aliquota_icms, reducao_icms, cst_pis, aliquota_pis,
                 aliquota_cofins, cst_cofins, cst_ipi, aliquota_ipi, cfop, cfop_propria, sts)
             VALUES
                (:pre_cadastro_id, :cp_compras_itens_id, :referencia_fornecedor, :r1, :r2, :r3, :referencia_master,
                 :codigo_fornecdor, :composicao, :colecao_id, :linha, :peso, :descricao, :descricao_complementar,
                 :Unidade, :Grupo, :grupo_categoria, :genero_id, :composicao_id, :caracteristica_id, :setor_laranja,
                 :preco_cheio, :encomenda, :estilo, :preco_compra, :preco_compra_tabela, :preco_venda_tabela,
                 :ncm, :origem, :cst_icms, :aliquota_icms, :reducao_icms, :cst_pis, :aliquota_pis,
                 :aliquota_cofins, :cst_cofins, :cst_ipi, :aliquota_ipi, :cfop, :cfop_propria, :sts)"
        );
        $proStmt = db()->prepare(
            "INSERT INTO pre_cadastro_item_pro
                (pre_cadastro_item_id, referencia_master, tamanho, cor, referencia, sku, qtde, preco_fornecedor,
                 preco_compra, preco_atacado, preco_varejo)
             VALUES
                (:pre_cadastro_item_id, :referencia_master, :tamanho, :cor, :referencia, :sku, :qtde, :preco_fornecedor,
                 :preco_compra, :preco_atacado, :preco_varejo)"
        );

        foreach ($groups as $group) {
            pc_recalc_group($group);
            $headerStmt->execute([
                'cp_compras_id' => (int) $group['cp_compras_id'],
                'cd_id' => (int) $group['cd_id'],
                'empresa_id' => (int) $group['empresa_id'],
                'fornecedor_id' => pc_trim($group['fornecedor_id']),
                'Categoria' => pc_trim($group['Categoria']),
                'data_entrega' => pc_trim($group['data_entrega'] ?? '') ?: null,
                'markup_franqueadora' => pc_decimal($group['markup_franqueadora'] ?? 0),
                'markup_franquia' => pc_decimal($group['markup_franquia'] ?? 0),
                'markup_total' => pc_decimal($group['markup_total'] ?? 0),
                'valor_total' => pc_decimal($group['valor_total'] ?? 0),
                'Itens' => (int) $group['Itens'],
                'QtdeItens' => (int) $group['QtdeItens'],
                'Tamanhos' => (int) $group['Tamanhos'],
                'QtdeTamanhos' => (int) $group['QtdeTamanhos'],
                'Cores' => (int) $group['Cores'],
                'QtdeCores' => (int) $group['QtdeCores'],
            ]);
            $preCadastroId = (int) db()->lastInsertId();
            $created['pre_cadastro_ids'][] = $preCadastroId;

            foreach ($group['items'] as $item) {
                $refMaster = pc_trim($item['r1']) . pc_trim($item['r2']) . pc_trim($item['r3']);
                $itemStmt->execute([
                    'pre_cadastro_id' => $preCadastroId,
                    'cp_compras_itens_id' => (int) $item['cp_compras_itens_id'],
                    'referencia_fornecedor' => pc_trim($item['referencia_fornecedor']),
                    'r1' => pc_trim($item['r1']) ?: null,
                    'r2' => pc_trim($item['r2']) ?: null,
                    'r3' => pc_trim($item['r3']) ?: null,
                    'referencia_master' => $refMaster,
                    'codigo_fornecdor' => pc_trim($item['codigo_fornecdor'] ?? $item['referencia_fornecedor']),
                    'composicao' => pc_trim($item['composicao'] ?? ''),
                    'colecao_id' => pc_trim($item['colecao_id'] ?? '') ?: null,
                    'linha' => pc_trim($item['linha'] ?? '') ?: null,
                    'peso' => pc_decimal($item['peso'] ?? 0),
                    'descricao' => pc_trim($item['descricao']),
                    'descricao_complementar' => pc_trim($item['descricao_complementar'] ?? ''),
                    'Unidade' => pc_trim($item['Unidade'] ?? 'PC'),
                    'Grupo' => pc_trim($item['Grupo'] ?? '') ?: null,
                    'grupo_categoria' => pc_trim($item['grupo_categoria'] ?? '') ?: null,
                    'genero_id' => pc_trim($item['genero_id'] ?? '') ?: null,
                    'composicao_id' => pc_trim($item['composicao_id'] ?? '') ?: null,
                    'caracteristica_id' => pc_trim($item['caracteristica_id'] ?? '') ?: null,
                    'setor_laranja' => pc_trim($item['setor_laranja'] ?? 'N') ?: 'N',
                    'preco_cheio' => pc_trim($item['preco_cheio'] ?? 'N') ?: 'N',
                    'encomenda' => pc_trim($item['encomenda'] ?? 'N') ?: 'N',
                    'estilo' => pc_null_if_empty($item['estilo'] ?? ''),
                    'preco_compra' => pc_decimal($item['preco_compra'] ?? 0),
                    'preco_compra_tabela' => pc_decimal($item['preco_compra_tabela'] ?? 0),
                    'preco_venda_tabela' => pc_decimal($item['preco_venda_tabela'] ?? 0),
                    'ncm' => pc_trim($item['ncm'] ?? '') ?: null,
                    'origem' => pc_null_if_empty($item['origem'] ?? ''),
                    'cst_icms' => pc_trim($item['cst_icms']),
                    'aliquota_icms' => pc_decimal($item['aliquota_icms'] ?? 0),
                    'reducao_icms' => pc_decimal($item['reducao_icms'] ?? 0),
                    'cst_pis' => pc_trim($item['cst_pis']),
                    'aliquota_pis' => pc_decimal($item['aliquota_pis'] ?? 0),
                    'aliquota_cofins' => pc_decimal($item['aliquota_cofins'] ?? 0),
                    'cst_cofins' => pc_trim($item['cst_cofins']),
                    'cst_ipi' => pc_trim($item['cst_ipi']),
                    'aliquota_ipi' => pc_decimal($item['aliquota_ipi'] ?? 0),
                    'cfop' => pc_trim($item['cfop']),
                    'cfop_propria' => pc_trim($item['cfop_propria']),
                    'sts' => (int) ($item['sts'] ?? 1),
                ]);
                $preCadastroItemId = (int) db()->lastInsertId();
                $created['items']++;

                foreach ($item['products'] as $product) {
                    $referencia = $refMaster . pc_trim($product['tamanho']) . pc_trim($product['cor']);
                    $proStmt->execute([
                        'pre_cadastro_item_id' => $preCadastroItemId,
                        'referencia_master' => $refMaster,
                        'tamanho' => pc_trim($product['tamanho']),
                        'cor' => pc_trim($product['cor']),
                        'referencia' => $referencia,
                        'sku' => pc_trim($product['sku'] ?? ''),
                        'qtde' => pc_decimal($product['qtde'] ?? 0),
                        'preco_fornecedor' => pc_decimal($product['preco_fornecedor'] ?? 0),
                        'preco_compra' => pc_decimal($product['preco_compra'] ?? 0),
                        'preco_atacado' => pc_decimal($product['preco_atacado'] ?? 0),
                        'preco_varejo' => pc_decimal($product['preco_varejo'] ?? 0),
                    ]);
                    $created['products']++;
                }
            }
        }
        db()->commit();
    } catch (Throwable $e) {
        if (db()->inTransaction()) {
            db()->rollBack();
        }
        api_response(false, ['message' => 'Nao foi possivel gravar o pre-cadastro: ' . $e->getMessage()], 500);
    }

    return $created;
}

function pc_update_all(int $preCadastroId, array $groups): array
{
    if (pc_pre_cadastro_consolidado($preCadastroId)) {
        api_response(false, ['message' => 'Pre-cadastro consolidado nao pode ser editado.'], 422);
    }

    pc_normalize_groups_categories($groups);
    $errors = pc_validate_payload($groups, $preCadastroId);
    if ($errors) {
        api_response(false, ['message' => 'Corrija as inconsistencias antes de gravar.', 'errors' => $errors], 422);
    }
    if (!$groups) {
        api_response(false, ['message' => 'Nenhum dado de pre-cadastro informado.'], 422);
    }

    $group = $groups[0];
    $created = ['pre_cadastro_ids' => [$preCadastroId], 'items' => 0, 'products' => 0];

    db()->beginTransaction();
    try {
        $stmt = db()->prepare("SELECT id FROM pre_cadastro WHERE id = :id LIMIT 1");
        $stmt->execute(['id' => $preCadastroId]);
        if (!$stmt->fetchColumn()) {
            db()->rollBack();
            api_response(false, ['message' => 'Pre-cadastro nao encontrado.'], 404);
        }

        pc_recalc_group($group);

        $headerStmt = db()->prepare(
            "UPDATE pre_cadastro
                SET cp_compras_id = :cp_compras_id,
                    cd_id = :cd_id,
                    empresa_id = :empresa_id,
                    fornecedor_id = :fornecedor_id,
                    Categoria = :Categoria,
                    data_entrega = :data_entrega,
                    markup_franqueadora = :markup_franqueadora,
                    markup_franquia = :markup_franquia,
                    markup_total = :markup_total,
                    valor_total = :valor_total,
                    Itens = :Itens,
                    QtdeItens = :QtdeItens,
                    Tamanhos = :Tamanhos,
                    QtdeTamanhos = :QtdeTamanhos,
                    Cores = :Cores,
                    QtdeCores = :QtdeCores
              WHERE id = :id"
        );
        $headerStmt->execute([
            'id' => $preCadastroId,
            'cp_compras_id' => (int) $group['cp_compras_id'],
            'cd_id' => (int) $group['cd_id'],
            'empresa_id' => (int) $group['empresa_id'],
            'fornecedor_id' => pc_trim($group['fornecedor_id']),
            'Categoria' => pc_trim($group['Categoria']),
            'data_entrega' => pc_trim($group['data_entrega'] ?? '') ?: null,
            'markup_franqueadora' => pc_decimal($group['markup_franqueadora'] ?? 0),
            'markup_franquia' => pc_decimal($group['markup_franquia'] ?? 0),
            'markup_total' => pc_decimal($group['markup_total'] ?? 0),
            'valor_total' => pc_decimal($group['valor_total'] ?? 0),
            'Itens' => (int) $group['Itens'],
            'QtdeItens' => (int) $group['QtdeItens'],
            'Tamanhos' => (int) $group['Tamanhos'],
            'QtdeTamanhos' => (int) $group['QtdeTamanhos'],
            'Cores' => (int) $group['Cores'],
            'QtdeCores' => (int) $group['QtdeCores'],
        ]);

        $stmt = db()->prepare("DELETE FROM pre_cadastro_item WHERE pre_cadastro_id = :id");
        $stmt->execute(['id' => $preCadastroId]);

        $itemStmt = db()->prepare(
            "INSERT INTO pre_cadastro_item
                (pre_cadastro_id, cp_compras_itens_id, referencia_fornecedor, r1, r2, r3, referencia_master,
                 codigo_fornecdor, composicao, colecao_id, linha, peso, descricao, descricao_complementar,
                 Unidade, Grupo, grupo_categoria, genero_id, composicao_id, caracteristica_id, setor_laranja,
                 preco_cheio, encomenda, estilo, preco_compra, preco_compra_tabela, preco_venda_tabela,
                 ncm, origem, cst_icms, aliquota_icms, reducao_icms, cst_pis, aliquota_pis,
                 aliquota_cofins, cst_cofins, cst_ipi, aliquota_ipi, cfop, cfop_propria, sts)
             VALUES
                (:pre_cadastro_id, :cp_compras_itens_id, :referencia_fornecedor, :r1, :r2, :r3, :referencia_master,
                 :codigo_fornecdor, :composicao, :colecao_id, :linha, :peso, :descricao, :descricao_complementar,
                 :Unidade, :Grupo, :grupo_categoria, :genero_id, :composicao_id, :caracteristica_id, :setor_laranja,
                 :preco_cheio, :encomenda, :estilo, :preco_compra, :preco_compra_tabela, :preco_venda_tabela,
                 :ncm, :origem, :cst_icms, :aliquota_icms, :reducao_icms, :cst_pis, :aliquota_pis,
                 :aliquota_cofins, :cst_cofins, :cst_ipi, :aliquota_ipi, :cfop, :cfop_propria, :sts)"
        );
        $proStmt = db()->prepare(
            "INSERT INTO pre_cadastro_item_pro
                (pre_cadastro_item_id, referencia_master, tamanho, cor, referencia, sku, qtde, preco_fornecedor,
                 preco_compra, preco_atacado, preco_varejo)
             VALUES
                (:pre_cadastro_item_id, :referencia_master, :tamanho, :cor, :referencia, :sku, :qtde, :preco_fornecedor,
                 :preco_compra, :preco_atacado, :preco_varejo)"
        );

        foreach ($group['items'] as $item) {
            $refMaster = pc_trim($item['r1']) . pc_trim($item['r2']) . pc_trim($item['r3']);
            $itemStmt->execute([
                'pre_cadastro_id' => $preCadastroId,
                'cp_compras_itens_id' => (int) $item['cp_compras_itens_id'],
                'referencia_fornecedor' => pc_trim($item['referencia_fornecedor']),
                'r1' => pc_trim($item['r1']) ?: null,
                'r2' => pc_trim($item['r2']) ?: null,
                'r3' => pc_trim($item['r3']) ?: null,
                'referencia_master' => $refMaster,
                'codigo_fornecdor' => pc_trim($item['codigo_fornecdor'] ?? $item['referencia_fornecedor']),
                'composicao' => pc_trim($item['composicao'] ?? ''),
                'colecao_id' => pc_trim($item['colecao_id'] ?? '') ?: null,
                'linha' => pc_trim($item['linha'] ?? '') ?: null,
                'peso' => pc_decimal($item['peso'] ?? 0),
                'descricao' => pc_trim($item['descricao']),
                'descricao_complementar' => pc_trim($item['descricao_complementar'] ?? ''),
                'Unidade' => pc_trim($item['Unidade'] ?? 'PC'),
                'Grupo' => pc_trim($item['Grupo'] ?? '') ?: null,
                'grupo_categoria' => pc_trim($item['grupo_categoria'] ?? '') ?: null,
                'genero_id' => pc_trim($item['genero_id'] ?? '') ?: null,
                'composicao_id' => pc_trim($item['composicao_id'] ?? '') ?: null,
                'caracteristica_id' => pc_trim($item['caracteristica_id'] ?? '') ?: null,
                'setor_laranja' => pc_trim($item['setor_laranja'] ?? 'N') ?: 'N',
                'preco_cheio' => pc_trim($item['preco_cheio'] ?? 'N') ?: 'N',
                'encomenda' => pc_trim($item['encomenda'] ?? 'N') ?: 'N',
                'estilo' => pc_null_if_empty($item['estilo'] ?? ''),
                'preco_compra' => pc_decimal($item['preco_compra'] ?? 0),
                'preco_compra_tabela' => pc_decimal($item['preco_compra_tabela'] ?? 0),
                'preco_venda_tabela' => pc_decimal($item['preco_venda_tabela'] ?? 0),
                'ncm' => pc_trim($item['ncm'] ?? '') ?: null,
                'origem' => pc_null_if_empty($item['origem'] ?? ''),
                'cst_icms' => pc_trim($item['cst_icms']),
                'aliquota_icms' => pc_decimal($item['aliquota_icms'] ?? 0),
                'reducao_icms' => pc_decimal($item['reducao_icms'] ?? 0),
                'cst_pis' => pc_trim($item['cst_pis']),
                'aliquota_pis' => pc_decimal($item['aliquota_pis'] ?? 0),
                'aliquota_cofins' => pc_decimal($item['aliquota_cofins'] ?? 0),
                'cst_cofins' => pc_trim($item['cst_cofins']),
                'cst_ipi' => pc_trim($item['cst_ipi']),
                'aliquota_ipi' => pc_decimal($item['aliquota_ipi'] ?? 0),
                'cfop' => pc_trim($item['cfop']),
                'cfop_propria' => pc_trim($item['cfop_propria']),
                'sts' => (int) ($item['sts'] ?? 1),
            ]);
            $preCadastroItemId = (int) db()->lastInsertId();
            $created['items']++;

            foreach ($item['products'] as $product) {
                $referencia = $refMaster . pc_trim($product['tamanho']) . pc_trim($product['cor']);
                $proStmt->execute([
                    'pre_cadastro_item_id' => $preCadastroItemId,
                    'referencia_master' => $refMaster,
                    'tamanho' => pc_trim($product['tamanho']),
                    'cor' => pc_trim($product['cor']),
                    'referencia' => $referencia,
                    'sku' => pc_trim($product['sku'] ?? ''),
                    'qtde' => pc_decimal($product['qtde'] ?? 0),
                    'preco_fornecedor' => pc_decimal($product['preco_fornecedor'] ?? 0),
                    'preco_compra' => pc_decimal($product['preco_compra'] ?? 0),
                    'preco_atacado' => pc_decimal($product['preco_atacado'] ?? 0),
                    'preco_varejo' => pc_decimal($product['preco_varejo'] ?? 0),
                ]);
                $created['products']++;
            }
        }

        db()->commit();
    } catch (Throwable $e) {
        if (db()->inTransaction()) {
            db()->rollBack();
        }
        api_response(false, ['message' => 'Nao foi possivel atualizar o pre-cadastro: ' . $e->getMessage()], 500);
    }

    return $created;
}

function pc_required_value(array $row, string $field, string $label, array &$errors, string $prefix): void
{
    if (pc_trim($row[$field] ?? '') === '') {
        $errors[] = "$prefix: informe $label.";
    }
}

function pc_validate_consolidacao(array $header, array $items, array $productsByItem): array
{
    $errors = [];
    if ((int) ($header['consolidado'] ?? 0) === 1) {
        $errors[] = 'Pre-cadastro ja esta consolidado.';
    }
    if (!$items) {
        $errors[] = 'Pre-cadastro sem itens para consolidar.';
    }

    $gradeRefs = [];
    foreach ($items as $index => $item) {
        $prefix = 'Item ' . ($index + 1) . ' (' . pc_trim($item['referencia_fornecedor'] ?? '') . ')';
        foreach ([
            'referencia_master' => 'referencia master',
            'r1' => 'fornecedor',
            'r2' => 'categoria',
            'r3' => 'R3',
            'codigo_fornecdor' => 'codigo fornecedor',
            'colecao_id' => 'colecao',
            'linha' => 'linha',
            'Grupo' => 'grupo',
            'grupo_categoria' => 'grupo/categoria',
            'composicao_id' => 'composicao',
            'caracteristica_id' => 'caracteristica',
            'genero_id' => 'genero',
            'descricao' => 'descricao',
            'Unidade' => 'unidade',
            'ncm' => 'NCM',
            'origem' => 'origem',
            'cst_icms' => 'CST ICMS',
            'cst_pis' => 'CST PIS',
            'cst_cofins' => 'CST COFINS',
            'cst_ipi' => 'CST IPI',
            'cfop' => 'CFOP',
        ] as $field => $label) {
            pc_required_value($item, $field, $label, $errors, $prefix);
        }

        $refMaster = pc_trim($item['referencia_master'] ?? '');
        if ($refMaster !== '' && pc_product_master_exists($refMaster)) {
            $errors[] = "$prefix: referencia master $refMaster ja existe no cadastro de produtos.";
        }

        $products = $productsByItem[(int) $item['id']] ?? [];
        if (!$products) {
            $errors[] = "$prefix: nao possui grade para consolidar.";
        }
        foreach ($products as $productIndex => $product) {
            $gradePrefix = $prefix . ', grade ' . ($productIndex + 1);
            foreach ([
                'referencia' => 'referencia',
                'tamanho' => 'tamanho',
                'cor' => 'cor',
            ] as $field => $label) {
                pc_required_value($product, $field, $label, $errors, $gradePrefix);
            }
            $referencia = pc_trim($product['referencia'] ?? '');
            if ($referencia !== '') {
                if (isset($gradeRefs[$referencia])) {
                    $errors[] = "$gradePrefix: referencia $referencia duplicada no pre-cadastro.";
                }
                $gradeRefs[$referencia] = true;
                if (pc_exists('produtos_cab_grade', 'Distribuidora', $referencia)) {
                    $errors[] = "$gradePrefix: referencia $referencia ja existe na grade de produtos.";
                }
            }
        }
    }

    return $errors;
}

function pc_load_consolidacao_data(int $preCadastroId): array
{
    $stmt = db()->prepare("SELECT * FROM pre_cadastro WHERE id = :id LIMIT 1 FOR UPDATE");
    $stmt->execute(['id' => $preCadastroId]);
    $header = $stmt->fetch();
    if (!$header) {
        api_response(false, ['message' => 'Pre-cadastro nao encontrado.'], 404);
    }

    $stmt = db()->prepare(
        "SELECT *
           FROM pre_cadastro_item
          WHERE pre_cadastro_id = :id
          ORDER BY id"
    );
    $stmt->execute(['id' => $preCadastroId]);
    $items = $stmt->fetchAll();

    $productsByItem = [];
    if ($items) {
        $itemIds = array_map(static fn(array $item): int => (int) $item['id'], $items);
        $placeholders = implode(',', array_fill(0, count($itemIds), '?'));
        $stmt = db()->prepare(
            "SELECT *
               FROM pre_cadastro_item_pro
              WHERE pre_cadastro_item_id IN ($placeholders)
              ORDER BY id"
        );
        $stmt->execute($itemIds);
        foreach ($stmt->fetchAll() as $product) {
            $productsByItem[(int) $product['pre_cadastro_item_id']][] = $product;
        }
    }

    return ['header' => $header, 'items' => $items, 'products_by_item' => $productsByItem];
}

function pc_consolidar_pre_cadastro(int $preCadastroId): array
{
    if ($preCadastroId <= 0) {
        api_response(false, ['message' => 'Informe o pre-cadastro.'], 422);
    }

    $created = ['produtos_cab' => 0, 'produtos_cab_grade' => 0];
    db()->beginTransaction();
    try {
        $loaded = pc_load_consolidacao_data($preCadastroId);
        $header = $loaded['header'];
        $items = $loaded['items'];
        $productsByItem = $loaded['products_by_item'];
        $errors = pc_validate_consolidacao($header, $items, $productsByItem);
        if ($errors) {
            db()->rollBack();
            api_response(false, ['message' => 'Corrija as inconsistencias antes de consolidar.', 'errors' => $errors], 422);
        }

        $user = current_user();
        $usuario = pc_cut((string) ($user['login'] ?? $user['nome'] ?? 'sistema'), 0, 30);
        $now = date('Y-m-d H:i:s');

        $cabStmt = db()->prepare(
            "INSERT INTO produtos_cab
                (Referencia, Fornecedor, CodFornecedor, CodFornecedorR3, Categoria, Grupo, GrupoCategoria,
                 Colecao, Linha, Composicao, Caracteristica, Genero, Descricao, DescricaoComplementar,
                 Unidade, Cor, Tamanho, NCM, CST_ICMS, Origem, AliquotaICMS, ReducaoICMS, CST_PIS,
                 AliquotaPIS, CST_COFINS, AliquotaCOFINS, CST_IPI, AliquotaIPI, CFOP, CFOP_ProducaoProria,
                 Peso, PrecoCompra, PrecoCompraTabela, PrecoVendaTabela, SetorLaranja, Encomenda,
                 PrecoCheio, Status, Inclusao, Alteracao, Usuario, Consolidado, Estilo, Foto)
             VALUES
                (:Referencia, :Fornecedor, :CodFornecedor, :CodFornecedorR3, :Categoria, :Grupo, :GrupoCategoria,
                 :Colecao, :Linha, :Composicao, :Caracteristica, :Genero, :Descricao, :DescricaoComplementar,
                 :Unidade, :Cor, :Tamanho, :NCM, :CST_ICMS, :Origem, :AliquotaICMS, :ReducaoICMS, :CST_PIS,
                 :AliquotaPIS, :CST_COFINS, :AliquotaCOFINS, :CST_IPI, :AliquotaIPI, :CFOP, :CFOP_ProducaoProria,
                 :Peso, :PrecoCompra, :PrecoCompraTabela, :PrecoVendaTabela, :SetorLaranja, :Encomenda,
                 :PrecoCheio, :Status, :Inclusao, :Alteracao, :Usuario, :Consolidado, :Estilo, :Foto)"
        );
        $gradeStmt = db()->prepare(
            "INSERT INTO produtos_cab_grade
                (Referencia, Distribuidora, GTIN, Linha, Colecao, Grupo, GrupoCategoria, Composicao,
                 Caracteristica, Descricao, DescricaoComplementar, Unidade, Cor, Genero, Fornecedor,
                 CodFornecedor, CodFornecedorR3, Categoria, Tamanho, NCM, CST_ICMS, Origem,
                 AliquotaICMS, ReducaoICMS, CST_PIS, AliquotaPIS, CST_COFINS, AliquotaCOFINS,
                 CST_IPI, AliquotaIPI, CFOP, CFOP_ProducaoProria, Peso, PrecoVendaTabela,
                 PrecoCompraTabela, PrecoCompra, SetorLaranja, Encomenda, PrecoCheio, LocalFisico,
                 Status, Inclusao, Alteracao, Usuario, Consolidado, CodigoAlternativo, Estilo, Foto)
             VALUES
                (:Referencia, :Distribuidora, :GTIN, :Linha, :Colecao, :Grupo, :GrupoCategoria, :Composicao,
                 :Caracteristica, :Descricao, :DescricaoComplementar, :Unidade, :Cor, :Genero, :Fornecedor,
                 :CodFornecedor, :CodFornecedorR3, :Categoria, :Tamanho, :NCM, :CST_ICMS, :Origem,
                 :AliquotaICMS, :ReducaoICMS, :CST_PIS, :AliquotaPIS, :CST_COFINS, :AliquotaCOFINS,
                 :CST_IPI, :AliquotaIPI, :CFOP, :CFOP_ProducaoProria, :Peso, :PrecoVendaTabela,
                 :PrecoCompraTabela, :PrecoCompra, :SetorLaranja, :Encomenda, :PrecoCheio, :LocalFisico,
                 :Status, :Inclusao, :Alteracao, :Usuario, :Consolidado, :CodigoAlternativo, :Estilo, :Foto)"
        );

        foreach ($items as $item) {
            $products = $productsByItem[(int) $item['id']] ?? [];
            $cores = array_values(array_unique(array_map(static fn(array $product): string => pc_trim($product['cor'] ?? ''), $products)));
            $tamanhos = array_values(array_unique(array_map(static fn(array $product): string => pc_trim($product['tamanho'] ?? ''), $products)));
            $base = [
                'Referencia' => pc_trim($item['referencia_master']),
                'Fornecedor' => pc_trim($item['r1']),
                'CodFornecedor' => pc_trim($item['codigo_fornecdor']),
                'CodFornecedorR3' => pc_trim($item['r3']),
                'Categoria' => pc_trim($item['r2']),
                'Grupo' => pc_trim($item['Grupo']),
                'GrupoCategoria' => pc_trim($item['grupo_categoria']),
                'Colecao' => (int) $item['colecao_id'],
                'Linha' => (int) $item['linha'],
                'Composicao' => (int) $item['composicao_id'],
                'Caracteristica' => (int) $item['caracteristica_id'],
                'Genero' => (int) $item['genero_id'],
                'Descricao' => pc_trim($item['descricao']),
                'DescricaoComplementar' => pc_trim($item['descricao_complementar'] ?? ''),
                'Unidade' => pc_trim($item['Unidade']),
                'NCM' => pc_trim($item['ncm']),
                'CST_ICMS' => pc_trim($item['cst_icms']),
                'Origem' => pc_trim($item['origem']),
                'AliquotaICMS' => pc_decimal($item['aliquota_icms'] ?? 0),
                'ReducaoICMS' => pc_decimal($item['reducao_icms'] ?? 0),
                'CST_PIS' => pc_trim($item['cst_pis']),
                'AliquotaPIS' => pc_decimal($item['aliquota_pis'] ?? 0),
                'CST_COFINS' => pc_trim($item['cst_cofins']),
                'AliquotaCOFINS' => pc_decimal($item['aliquota_cofins'] ?? 0),
                'CST_IPI' => pc_trim($item['cst_ipi']),
                'AliquotaIPI' => pc_decimal($item['aliquota_ipi'] ?? 0),
                'CFOP' => pc_trim($item['cfop']),
                'CFOP_ProducaoProria' => pc_trim($item['cfop_propria'] ?? ''),
                'Peso' => pc_decimal($item['peso'] ?? 0),
                'SetorLaranja' => pc_trim($item['setor_laranja'] ?? 'N') ?: 'N',
                'Encomenda' => pc_trim($item['encomenda'] ?? 'N') ?: 'N',
                'PrecoCheio' => pc_trim($item['preco_cheio'] ?? 'N') ?: 'N',
                'Status' => 'Ativo',
                'Inclusao' => $now,
                'Alteracao' => $now,
                'Usuario' => $usuario,
                'Consolidado' => 'N',
                'Estilo' => (int) ($item['estilo'] ?? 0),
                'Foto' => 0,
            ];

            $cabStmt->execute($base + [
                'Cor' => implode(',', array_filter($cores, static fn(string $value): bool => $value !== '')),
                'Tamanho' => implode(',', array_filter($tamanhos, static fn(string $value): bool => $value !== '')),
                'PrecoCompra' => pc_decimal($item['preco_compra'] ?? 0),
                'PrecoCompraTabela' => pc_decimal($item['preco_compra_tabela'] ?? 0),
                'PrecoVendaTabela' => pc_decimal($item['preco_venda_tabela'] ?? 0),
            ]);
            $created['produtos_cab']++;

            foreach ($products as $product) {
                $gradeStmt->execute($base + [
                    'Distribuidora' => pc_trim($product['referencia']),
                    'GTIN' => '',
                    'Cor' => pc_trim($product['cor']),
                    'Tamanho' => pc_trim($product['tamanho']),
                    'PrecoVendaTabela' => pc_decimal($product['preco_varejo'] ?? 0),
                    'PrecoCompraTabela' => pc_decimal($product['preco_atacado'] ?? 0),
                    'PrecoCompra' => pc_decimal($product['preco_compra'] ?? 0),
                    'LocalFisico' => null,
                    'CodigoAlternativo' => pc_cut(pc_trim($product['sku'] ?? ''), 0, 20),
                ]);
                $created['produtos_cab_grade']++;
            }
        }

        $stmt = db()->prepare("UPDATE pre_cadastro SET consolidado = 1 WHERE id = :id");
        $stmt->execute(['id' => $preCadastroId]);
        db()->commit();
    } catch (Throwable $e) {
        if (db()->inTransaction()) {
            db()->rollBack();
        }
        api_response(false, ['message' => 'Nao foi possivel consolidar o pre-cadastro: ' . $e->getMessage()], 500);
    }

    return $created;
}

function pc_prepare_pre_cadastro_history_tables(): void
{
    pc_ensure_history_table('pre_cadastro', 'pre_cadastro_hst');
    pc_ensure_history_table('pre_cadastro_item', 'pre_cadastro_item_hst');
    pc_ensure_history_table('pre_cadastro_item_pro', 'pre_cadastro_item_pro_hst');
}

function pc_insert_history_header(int $preCadastroId): int
{
    $columns = pc_common_columns('pre_cadastro', 'pre_cadastro_hst');
    $columnList = pc_column_list($columns);
    $stmt = db()->prepare(
        "INSERT INTO pre_cadastro_hst ($columnList)
         SELECT $columnList
           FROM pre_cadastro
          WHERE id = :id"
    );
    $stmt->execute(['id' => $preCadastroId]);
    return $stmt->rowCount();
}

function pc_insert_history_items(int $preCadastroId): int
{
    $columns = pc_common_columns('pre_cadastro_item', 'pre_cadastro_item_hst');
    $columnList = pc_column_list($columns);
    $stmt = db()->prepare(
        "INSERT INTO pre_cadastro_item_hst ($columnList)
         SELECT $columnList
           FROM pre_cadastro_item
          WHERE pre_cadastro_id = :id"
    );
    $stmt->execute(['id' => $preCadastroId]);
    return $stmt->rowCount();
}

function pc_insert_history_products(int $preCadastroId): int
{
    $columns = pc_common_columns('pre_cadastro_item_pro', 'pre_cadastro_item_pro_hst');
    $selectColumns = implode(', ', array_map(static fn(string $column): string => "pro.`$column`", $columns));
    $stmt = db()->prepare(
        "INSERT INTO pre_cadastro_item_pro_hst (" . pc_column_list($columns) . ")
         SELECT $selectColumns
           FROM pre_cadastro_item_pro pro
           INNER JOIN pre_cadastro_item item ON item.id = pro.pre_cadastro_item_id
          WHERE item.pre_cadastro_id = :id"
    );
    $stmt->execute(['id' => $preCadastroId]);
    return $stmt->rowCount();
}

function pc_mover_pre_cadastro_historico(int $preCadastroId): array
{
    if ($preCadastroId <= 0) {
        api_response(false, ['message' => 'Informe o pre-cadastro.'], 422);
    }

    pc_prepare_pre_cadastro_history_tables();

    $moved = ['pre_cadastro' => 0, 'items' => 0, 'products' => 0];
    db()->beginTransaction();
    try {
        $stmt = db()->prepare("SELECT id FROM pre_cadastro WHERE id = :id LIMIT 1 FOR UPDATE");
        $stmt->execute(['id' => $preCadastroId]);
        if (!$stmt->fetchColumn()) {
            db()->rollBack();
            api_response(false, ['message' => 'Pre-cadastro nao encontrado.'], 404);
        }

        $moved['products'] = pc_insert_history_products($preCadastroId);
        $moved['items'] = pc_insert_history_items($preCadastroId);
        $moved['pre_cadastro'] = pc_insert_history_header($preCadastroId);

        if ($moved['pre_cadastro'] !== 1) {
            db()->rollBack();
            api_response(false, ['message' => 'Nao foi possivel mover o cabecalho para o historico.'], 500);
        }

        $stmt = db()->prepare("DELETE FROM pre_cadastro WHERE id = :id");
        $stmt->execute(['id' => $preCadastroId]);
        db()->commit();
    } catch (Throwable $e) {
        if (db()->inTransaction()) {
            db()->rollBack();
        }
        api_response(false, ['message' => 'Nao foi possivel mover para o historico: ' . $e->getMessage()], 500);
    }

    return $moved;
}

try {
    if ($action === 'options') {
        pc_domain_options(
            (string) ($_GET['type'] ?? ''),
            pc_trim($_GET['q'] ?? ''),
            pc_trim($_GET['grupo'] ?? ''),
            pc_trim($_GET['categoria'] ?? '')
        );
    }
    if ($action === 'preview') {
        api_response(true, pc_build_preview((int) ($data['pedido_id'] ?? 0)));
    }
    if ($action === 'get') {
        api_response(true, pc_load_pre_cadastro((int) ($data['id'] ?? $_GET['id'] ?? 0)));
    }
    if ($action === 'save') {
        $groups = json_decode((string) ($data['groups_json'] ?? '[]'), true);
        if (!is_array($groups) || !$groups) {
            api_response(false, ['message' => 'Nenhum dado de pre-cadastro informado.'], 422);
        }
        $created = pc_insert_all($groups);
        api_response(true, ['message' => 'Pre-cadastro gerado com sucesso.', 'created' => $created]);
    }
    if ($action === 'update') {
        $groups = json_decode((string) ($data['groups_json'] ?? '[]'), true);
        if (!is_array($groups) || !$groups) {
            api_response(false, ['message' => 'Nenhum dado de pre-cadastro informado.'], 422);
        }
        $created = pc_update_all((int) ($data['id'] ?? 0), $groups);
        api_response(true, ['message' => 'Pre-cadastro atualizado com sucesso.', 'created' => $created]);
    }
    if ($action === 'consolidate') {
        $created = pc_consolidar_pre_cadastro((int) ($data['id'] ?? 0));
        api_response(true, ['message' => 'Pre-cadastro consolidado com sucesso.', 'created' => $created]);
    }
    if ($action === 'history') {
        $moved = pc_mover_pre_cadastro_historico((int) ($data['id'] ?? 0));
        api_response(true, ['message' => 'Pre-cadastro movido para o historico.', 'moved' => $moved]);
    }
    api_response(false, ['message' => 'Acao invalida.'], 404);
} catch (Throwable $e) {
    if (db()->inTransaction()) {
        db()->rollBack();
    }
    api_response(false, ['message' => $e->getMessage()], 500);
}
