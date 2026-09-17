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

function pc_exists(string $table, string $column, $value): bool
{
    if ($value === null || $value === '') {
        return false;
    }
    $stmt = db()->prepare("SELECT COUNT(*) FROM `$table` WHERE `$column` = :value");
    $stmt->execute(['value' => $value]);
    return (int) $stmt->fetchColumn() > 0;
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

function pc_domain_options(string $type, string $q): void
{
    $term = '%' . $q . '%';
    $map = [
        'pedidos' => [
            'sql' => "SELECT c.id, CONCAT('Pedido ', c.id, ' - ', COALESCE(NULLIF(f.NomeFornecedor, ''), c.Fornecedor_id)) AS text
                       FROM cp_compras c
                        LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor_id
                       WHERE c.status_id = 2
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
        'grupos' => ['table' => 'produtos_grupos', 'id' => 'Grupo', 'text' => ['Grupo']],
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
    $stmt = db()->prepare(
        "SELECT *
           FROM `{$cfg['table']}`
          WHERE " . implode(' OR ', $where) . "
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
                $deparaSelect
           FROM cp_compras_itens i
           INNER JOIN cp_compras_itens_tamanhos t ON t.compras_itens_id = i.id
           INNER JOIN cp_compras_itens_cores co ON co.compras_itens_tamanho_id = t.id
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

function pc_validate_payload(array $groups): array
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
                if (pc_exists('pre_cadastro_item_pro', 'referencia', $referencia)) {
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
                 Itens, QtdeItens, Tamanhos, QtdeTamanhos, Cores, QtdeCores)
             VALUES
                (:cp_compras_id, :cd_id, :empresa_id, :fornecedor_id, :Categoria, :data_entrega,
                 :markup_franqueadora, :markup_franquia, :markup_total, :valor_total,
                 :Itens, :QtdeItens, :Tamanhos, :QtdeTamanhos, :Cores, :QtdeCores)"
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
                    'estilo' => pc_trim($item['estilo'] ?? '') ?: null,
                    'preco_compra' => pc_decimal($item['preco_compra'] ?? 0),
                    'preco_compra_tabela' => pc_decimal($item['preco_compra_tabela'] ?? 0),
                    'preco_venda_tabela' => pc_decimal($item['preco_venda_tabela'] ?? 0),
                    'ncm' => pc_trim($item['ncm'] ?? '') ?: null,
                    'origem' => pc_trim($item['origem'] ?? '') ?: null,
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

try {
    if ($action === 'options') {
        pc_domain_options((string) ($_GET['type'] ?? ''), pc_trim($_GET['q'] ?? ''));
    }
    if ($action === 'preview') {
        api_response(true, pc_build_preview((int) ($data['pedido_id'] ?? 0)));
    }
    if ($action === 'save') {
        $groups = json_decode((string) ($data['groups_json'] ?? '[]'), true);
        if (!is_array($groups) || !$groups) {
            api_response(false, ['message' => 'Nenhum dado de pre-cadastro informado.'], 422);
        }
        $created = pc_insert_all($groups);
        api_response(true, ['message' => 'Pre-cadastro gerado com sucesso.', 'created' => $created]);
    }
    api_response(false, ['message' => 'Acao invalida.'], 404);
} catch (Throwable $e) {
    if (db()->inTransaction()) {
        db()->rollBack();
    }
    api_response(false, ['message' => $e->getMessage()], 500);
}
