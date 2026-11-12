<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'produtos_processos.php';
$aplicacao_descricao = 'Consolidação, importação, fotos, ordenação e processamento de lotes de preço.';
require_once __DIR__ . '/../bootstrap.php';
require_once __DIR__ . '/../../includes/produtos.php';
require_once __DIR__ . '/../../includes/produtos_workflow.php';
api_require_login();
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Allow: POST');
    api_response(false, ['message' => 'Use POST para processar.'], 405);
}
$data = request_data();
$action = (string) ($data['action'] ?? '');
$actions = [
    'consolidate' => ['consolidar', 'processar'], 'import' => ['importar_antigos', 'processar'],
    'photo_upload' => ['fotos', 'inserir'], 'photo_delete' => ['fotos', 'excluir'],
    'batch_item' => ['precos_lote', 'editar'], 'batch_item_delete' => ['precos_lote', 'editar'],
    'batch_apply' => ['precos_lote', 'processar'], 'batch_restore' => ['precos_lote', 'processar'],
    'order_sizes' => ['ordenar_tamanho', 'editar'],
    'grade_bulk_valores' => ['valores', 'editar'], 'grade_bulk_informacoes' => ['outras_informacoes', 'editar'],
];
if (!isset($actions[$action])) {
    api_response(false, ['message' => 'Ação inválida.'], 404);
}
if (!hash_equals(produtos_csrf(), (string) ($data['csrf'] ?? ''))) {
    api_response(false, ['message' => 'Formulário expirado. Recarregue a página.'], 403);
}
$locked = false;
try {
    $pdo = db();
    [$entity, $permission] = $actions[$action];
    $permissions = produtos_permissoes($entity);
    if (empty($permissions['visualizar']) || empty($permissions[$permission])) {
        api_response(false, ['message' => 'Você não tem permissão para esta operação.'], 403);
    }
    // O código sequencial de produtos é compartilhado por todas as referências e importações.
    $lockName = 'allop_produtos_' . DB_NAME;
    if ($pdo->getAttribute(PDO::ATTR_DRIVER_NAME) === 'mysql') {
        $stmt = $pdo->prepare('SELECT GET_LOCK(?, 10)');
        $stmt->execute([$lockName]);
        if ((int) $stmt->fetchColumn() !== 1) {
            throw new InvalidArgumentException('Outro processamento de produtos está em andamento. Tente novamente.');
        }
        $locked = true;
    }
    $workflow = new ProdutosWorkflow($pdo, (string) current_user()['login']);
    $pdo->beginTransaction();
    $id = trim((string) ($data['id'] ?? ''));
    switch ($action) {
        case 'consolidate':
            $ids = $data['ids'] ?? [$id];
            if (!is_array($ids) || !$ids || count($ids) > 200) {
                throw new InvalidArgumentException('Selecione até 200 referências.');
            }
            $result = ['processed' => 0];
            foreach (array_unique($ids) as $reference) {
                if (!is_string($reference)) {
                    throw new InvalidArgumentException('Referência inválida.');
                }
                $result['processed'] += $workflow->consolidate($reference)['processed'];
            }
            break;
        case 'grade_bulk_valores':
        case 'grade_bulk_informacoes':
            if (!is_array($data['ids'] ?? null)) {
                throw new InvalidArgumentException('Seleção inválida.');
            }
            $result = $workflow->bulkGrade($entity, $data['ids'], (string) ($data['campo'] ?? ''), $data['valor'] ?? '');
            break;
        case 'import':
            $result = $workflow->importLegacy(trim((string) ($data['referencia'] ?? '')), ($data['faltantes'] ?? '') === 'S');
            break;
        case 'batch_item':
        case 'batch_item_delete':
            $result = $workflow->batchItem($id, $data, $action === 'batch_item_delete');
            break;
        case 'batch_apply':
        case 'batch_restore':
            $result = $workflow->applyBatch($id, $action === 'batch_restore');
            break;
        case 'order_sizes':
            $ids = $data['ordem'] ?? [];
            if (!is_array($ids) || array_filter($ids, static fn($v) => !is_string($v))) {
                throw new InvalidArgumentException('Ordem inválida.');
            }
            $result = $workflow->orderSizes($ids);
            break;
        case 'photo_upload':
            $file = $_FILES['foto'] ?? [];
            if (($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK || !is_uploaded_file($file['tmp_name'] ?? '')) {
                throw new InvalidArgumentException('Selecione uma imagem válida para enviar.');
            }
            if (($file['size'] ?? 0) > 10 * 1024 * 1024) {
                throw new InvalidArgumentException('A imagem deve ter até 10 MB.');
            }
            $result = $workflow->photo($id, file_get_contents($file['tmp_name']));
            break;
        case 'photo_delete':
            $result = $workflow->photo($id, null, (int) ($data['sequencia'] ?? -1));
            break;
    }
    $pdo->commit();
    if ($locked) {
        $stmt = $pdo->prepare('SELECT RELEASE_LOCK(?)');
        $stmt->execute([$lockName]);
        $locked = false;
    }
    api_response(true, ['message' => 'Operação concluída.', 'data' => $result]);
} catch (Throwable $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
    }
    if ($locked) {
        $stmt = $pdo->prepare('SELECT RELEASE_LOCK(?)');
        $stmt->execute([$lockName]);
    }
    if ($e instanceof InvalidArgumentException) {
        api_response(false, ['message' => $e->getMessage()], 422);
    }
    if ($e instanceof PDOException && in_array($e->errorInfo[1] ?? null, [1062, 1451, 1452], true)) {
        api_response(false, ['message' => 'Há códigos duplicados ou relacionamentos ausentes. Nenhuma alteração foi aplicada.'], 409);
    }
    error_log('Processamento de produtos: ' . $e->getMessage());
    api_response(false, ['message' => 'Não foi possível concluir o processamento. Nenhuma alteração foi aplicada.'], 500);
}
