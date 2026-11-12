<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'ajustar_triggers_fotos_produtos.php';
$aplicacao_descricao = 'Corrige gatilhos de fotos que referenciam outro banco, preservando cópia das definições.';
if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit('Disponível somente por linha de comando.');
}
require_once __DIR__ . '/../config/database.php';
$execute = array_key_exists('execute', getopt('', ['execute']));
$pdo = db();
if ($pdo->query('SELECT DATABASE()')->fetchColumn() !== 'allop_devel') {
    fwrite(STDERR, "Este ajuste é específico de allop_devel.\n");
    exit(1);
}
$definitions = [];
$changes = [];
foreach ($pdo->query('SHOW TRIGGERS') as $trigger) {
    if ($trigger['Table'] !== 'produtos_fotos' || !in_array($trigger['Trigger'], ['produtos_fotos_before_insert', 'produtos_fotos_before_update', 'produtos_fotos_before_delete'], true)) {
        continue;
    }
    if (!preg_match('/^BEGIN\s+CALL allop_kidstok\.sp_atualiza_data_alteracao_produtos_cab\((NEW|OLD)\.Referencia\);\s+END$/i', $trigger['Statement'], $match)) {
        continue;
    }
    $name = $trigger['Trigger'];
    $create = $pdo->query("SHOW CREATE TRIGGER `$name`")->fetch();
    $definitions[$name] = $create['SQL Original Statement'];
    $changes[$name] = 'CREATE TRIGGER `' . $name . '` BEFORE ' . $trigger['Event'] . ' ON `produtos_fotos` FOR EACH ROW BEGIN CALL sp_atualiza_data_alteracao_produtos_cab(' . strtoupper($match[1]) . '.Referencia); END';
}
if (!$changes) {
    echo "Nenhum gatilho legado precisa de ajuste.\n";
    exit;
}
foreach (array_keys($changes) as $name) {
    echo ($execute ? 'Ajustar: ' : 'Pendente: ') . $name . "\n";
}
if (!$execute) {
    echo "Consulta concluída. Use --execute para aplicar.\n";
    exit;
}
$backup = sys_get_temp_dir() . '/allop_devel_fotos_triggers_' . date('Ymd_His') . '.sql';
$sql = "DELIMITER ;;\n";
foreach ($definitions as $name => $definition) {
    $sql .= "DROP TRIGGER IF EXISTS `$name`;;\n" . $definition . ";;\n";
}
$sql .= "DELIMITER ;\n";
if (file_put_contents($backup, $sql) === false) {
    throw new RuntimeException('Não foi possível salvar a cópia dos gatilhos; ajuste cancelado.');
}
foreach ($changes as $name => $definition) {
    $pdo->exec("DROP TRIGGER `$name`");
    try {
        $pdo->exec($definition);
    } catch (Throwable $e) {
        $pdo->exec($definitions[$name]);
        throw $e;
    }
}
echo "Gatilhos de fotos ajustados para o banco atual. Cópia anterior: $backup\n";
