<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "options.php";
$aplicacao_descricao = "API de opcoes para campos Select2.";



require_once __DIR__ . '/../bootstrap.php';
api_require_login();

$type = (string) ($_GET['type'] ?? '');
$q = '%' . trim((string) ($_GET['q'] ?? '')) . '%';

$map = [
    'perfis' => ['table' => 'seg_perfil', 'id' => 'id', 'label' => 'nome'],
    'aplicacoes' => ['table' => 'seg_aplicacoes', 'id' => 'id', 'label' => 'nome'],
    'menus' => ['table' => 'seg_menu', 'id' => 'id', 'label' => 'menu'],
    'usuarios' => ['table' => 'seg_usuarios', 'id' => 'id', 'label' => 'nome'],
    'empresas_cd' => ['table' => 'empresas_cd', 'id' => 'Codigo', 'label' => 'NomeCD'],
    'empresas' => ['table' => 'empresas', 'id' => 'Codigo', 'label' => 'Fantasia', 'fallback' => 'Nome'],
    'config_email' => ['table' => 'config_email', 'id' => 'Codigo', 'label' => 'NomeConta', 'fallback' => 'Email'],
    'produtos_cor' => ['table' => 'produtos_cor', 'id' => 'Codigo', 'label' => 'Nome', 'fallback' => 'Codigo'],
];

if ($type !== 'pf_colecao_cores' && !isset($map[$type])) {
    api_response(false, ['message' => 'Tipo inválido.'], 404);
}

if ($type === 'pf_colecao_cores') {
    $stmt = db()->prepare(
        "SELECT DISTINCT pfc.cor_produto AS id,
                pfc.cor_produto AS text
           FROM pf_colecao pfc
          WHERE pfc.cor_produto IS NOT NULL
            AND TRIM(pfc.cor_produto) <> ''
            AND pfc.cor_produto LIKE :q
            AND NOT EXISTS (
                SELECT 1
                  FROM cp_depara_cor d
                 WHERE CONVERT(d.cor_fornecedor USING utf8mb4) COLLATE utf8mb4_unicode_ci = pfc.cor_produto
            )
          ORDER BY pfc.cor_produto
          LIMIT 30"
    );
    $stmt->execute(['q' => $q]);
    api_response(true, ['results' => $stmt->fetchAll()]);
}

if ($type === 'produtos_cor') {
    $stmt = db()->prepare(
        "SELECT Codigo AS id,
                CONCAT(Codigo, ' - ', Nome) AS text
           FROM produtos_cor
          WHERE Codigo LIKE :q_codigo
             OR Nome LIKE :q_nome
          ORDER BY Nome
          LIMIT 30"
    );
    $stmt->execute([
        'q_codigo' => $q,
        'q_nome' => $q,
    ]);
    api_response(true, ['results' => $stmt->fetchAll()]);
}

$table = $map[$type]['table'];
$id = $map[$type]['id'];
$label = $map[$type]['label'];
$fallback = $map[$type]['fallback'] ?? null;
$text = $fallback ? "COALESCE(NULLIF($label, ''), $fallback)" : $label;
$where = $fallback ? "$label LIKE :q_label OR $fallback LIKE :q_fallback" : "$label LIKE :q_label";
$stmt = db()->prepare("SELECT $id AS id, $text AS text FROM $table WHERE $where ORDER BY $text LIMIT 30");
$params = ['q_label' => $q];
if ($fallback) {
    $params['q_fallback'] = $q;
}
$stmt->execute($params);
api_response(true, ['results' => $stmt->fetchAll()]);

