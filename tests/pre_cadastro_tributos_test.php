<?php
// php tests/pre_cadastro_tributos_test.php
// Usa apenas SQLite em memoria, sem carregar config/database.php.
require_once __DIR__ . '/../includes/pre_cadastro_tributos.php';

$pdo = new PDO('sqlite::memory:', null, null, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
$schema = json_decode(file_get_contents(__DIR__ . '/../config/produtos_schema.json'), true, 512, JSON_THROW_ON_ERROR);
foreach (['produtos_prm', 'cfops', 'st_origem', 'st_icms', 'st_pis', 'st_cofins', 'st_ipi'] as $table) {
    $columns = [];
    foreach ($schema[$table]['fields'] as $name => $field) {
        $type = in_array($field['type'], ['double', 'decimal', 'float', 'int', 'bigint', 'tinyint'], true) ? 'REAL' : 'TEXT';
        $columns[] = '"' . $name . '" ' . $type;
    }
    $pdo->exec('CREATE TABLE "' . $table . '" (' . implode(', ', $columns) . ')');
}
$checks = 0;
function check_value($expected, $actual, string $message): void
{
    global $checks;
    if ($expected !== $actual) {
        throw new RuntimeException($message . ': ' . json_encode(['expected' => $expected, 'actual' => $actual]));
    }
    $checks++;
}

check_value([], pc_tributos_padrao($pdo), 'Tabela sem parametros');
foreach (['cfops' => '6102', 'st_origem' => '0', 'st_icms' => '000', 'st_pis' => '01', 'st_cofins' => '02', 'st_ipi' => '53'] as $table => $code) {
    $key = $table === 'cfops' ? 'CFOP' : 'Codigo';
    $stmt = $pdo->prepare("INSERT INTO `$table` (`$key`, Descricao) VALUES (?, ?)");
    $stmt->execute([$code, 'Descricao ' . $code]);
}
$insert = $pdo->prepare('INSERT INTO produtos_prm (Codigo, CFOP, Origem, CST_ICMS, AliquotaICMS, ReducaoBaseICMS,
    CST_PIS, AliquotaPIS, CST_COFINS, AliquotaCOFINS, CST_IPI, AliquotaIPI) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
$insert->execute([9, '5102', '1', '500', 99, 99, '99', 99, '99', 99, '99', 99]);
$insert->execute([2, '6102', '0', '000', 18.75, 12.5, '01', 1.65, '02', 7.6, '53', 0]);
$defaults = pc_tributos_padrao($pdo);
foreach (['cfop' => '6102', 'origem' => '0', 'cst_icms' => '000', 'cst_pis' => '01', 'cst_cofins' => '02', 'cst_ipi' => '53'] as $field => $expected) {
    check_value($expected, $defaults[$field], 'Codigo e escolha do menor Codigo: ' . $field);
    check_value($expected . ' - Descricao ' . $expected, $defaults[$field . '_text'], 'Descricao do seletor: ' . $field);
}
foreach (['aliquota_icms' => 18.75, 'reducao_icms' => 12.5, 'aliquota_pis' => 1.65, 'aliquota_cofins' => 7.6, 'aliquota_ipi' => 0.0] as $field => $expected) {
    check_value($expected, $defaults[$field], 'Aliquota/reducao: ' . $field);
}
check_value(false, array_key_exists('cfop_propria', $defaults), 'Nao inventar CFOP propria');
check_value(false, array_key_exists('ncm', $defaults), 'Preservar NCM do pedido');
$existing = ['cfop' => '5101', 'origem' => '0', 'cst_icms' => '', 'cst_pis' => null, 'aliquota_icms' => 0,
    'aliquota_cofins' => '0', 'reducao_icms' => 3.5, 'cfop_propria' => '5103', 'ncm' => '12345678'];
$merged = pc_tributos_com_padrao($existing, $defaults);
foreach ($existing as $field => $value) {
    if ($value !== '' && $value !== null) check_value($value, $merged[$field], 'Preservar valor salvo: ' . $field);
}
check_value('000', $merged['cst_icms'], 'Completar campo vazio');
check_value('01', $merged['cst_pis'], 'Completar campo nulo');
check_value(1.65, $merged['aliquota_pis'], 'Completar campo ausente');
$pdo->exec('DELETE FROM st_icms');
check_value('000', pc_tributos_padrao($pdo)['cst_icms_text'], 'Codigo continua visivel sem descricao');
$pdo->exec('DELETE FROM produtos_prm');
check_value($existing, pc_tributos_com_padrao($existing, pc_tributos_padrao($pdo)), 'Sem parametros preserva item existente');
echo "PASS: $checks verificacoes de parametros tributarios em SQLite isolado.\n";
