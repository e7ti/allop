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
];

if (!isset($map[$type])) {
    api_response(false, ['message' => 'Tipo invalido.'], 404);
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

