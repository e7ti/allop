<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'processar_precos_produtos.php';
$aplicacao_descricao = 'Executa lotes de preços e retornos vencidos, para uso pelo agendador do servidor.';
if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit('Disponível somente por linha de comando.');
}
require_once __DIR__ . '/../includes/produtos.php';
require_once __DIR__ . '/../includes/produtos_workflow.php';
date_default_timezone_set('America/Sao_Paulo');
$execute = array_key_exists('execute', getopt('', ['execute']));
$pdo = db();
$today = date('Y-m-d');
$stmt = $pdo->prepare('SELECT ID, Atualizado FROM produtos_precos_cab
    WHERE (Atualizado = 0 AND DataAtualizacao <= ?) OR (Atualizado = 1 AND DataVoltaAtualizacao <= ?) ORDER BY ID');
$stmt->execute([$today, $today]);
$batches = $stmt->fetchAll();
$workflow = new ProdutosWorkflow($pdo, 'Agendador');
$failed = false;
foreach ($batches as $batch) {
    $id = (string) $batch['ID'];
    if (!$execute) {
        echo 'Lote ' . $id . ': ' . ((int) $batch['Atualizado'] === 0 ? 'aplicação' : 'retorno') . " pendente.\n";
        continue;
    }
    $lock = $pdo->prepare('SELECT GET_LOCK(?, 10)');
    $lock->execute(['allop_produtos_' . DB_NAME]);
    if ((int) $lock->fetchColumn() !== 1) {
        fwrite(STDERR, "Outro processamento de produtos está em andamento.\n");
        exit(1);
    }
    try {
        $pdo->beginTransaction();
        $workflow->applyBatch($id, (int) $batch['Atualizado'] === 1);
        $current = $workflow->row('produtos_precos_cab', 'ID', $id);
        if ((int) $current['Atualizado'] === 1 && $current['DataVoltaAtualizacao'] <= $today) {
            $workflow->applyBatch($id, true);
        }
        $pdo->commit();
        echo "Lote $id processado.\n";
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        error_log('Lote ' . $id . ': ' . $e->getMessage());
        fwrite(STDERR, "Lote $id não processado; confira o log e revise os conflitos.\n");
        $failed = true;
    } finally {
        $stmt = $pdo->prepare('SELECT RELEASE_LOCK(?)');
        $stmt->execute(['allop_produtos_' . DB_NAME]);
    }
}
if (!$execute) {
    echo "Consulta concluída. Para processar, use --execute.\n";
}
exit($failed ? 1 : 0);
