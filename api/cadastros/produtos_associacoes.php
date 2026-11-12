<?php
require_once __DIR__ . '/../bootstrap.php';
require_once __DIR__ . '/../../includes/grupo_categoria.php';
api_require_login();
$data = request_data();
$action = (string) ($_GET['action'] ?? 'list');
$entity = (string) ($_GET['cadastro'] ?? 'grupo_categoria');
$config = produtos_associacao_config($entity);
if (!$config) {
    api_response(false, ['message' => 'Associação inválida.'], 404);
}
try {
    $pdo = db();
    $permissions = produtos_permissoes($entity);
    if (empty($permissions['visualizar'])) {
        api_response(false, ['message' => 'Acesso não permitido.'], 403);
    }
    $table = $config['table'];
    $parent = $config['parent'];
    $child = $config['child'];
    $source = $config['source'];
    $target = $config['target'];
    $parentStatus = $config['parent_status'];
    $targetStatus = $config['target_status'];
    if ($action === 'list') {
        $stmt = $pdo->query("SELECT g.`{$source['key']}` AS Grupo, g.`{$source['label']}` AS Nome,
            g.`$parentStatus` AS Status, g.Inclusao, g.Alteracao, g.Usuario,
            (SELECT COUNT(*) FROM `$table` v WHERE v.`$parent` = g.`{$source['key']}`) AS Quantidade
            FROM `{$source['table']}` g ORDER BY g.`{$source['label']}`, g.`{$source['key']}`");
        api_response(true, ['data' => $stmt->fetchAll()]);
    }
    if (!in_array($action, ['get', 'save'], true)) {
        api_response(false, ['message' => 'Ação inválida.'], 404);
    }
    if ($action === 'save' && $_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Allow: POST');
        api_response(false, ['message' => 'Use POST para salvar.'], 405);
    }
    if (!is_string($data['grupo'] ?? null) || trim($data['grupo']) === '') {
        throw new InvalidArgumentException('Selecione um registro válido.');
    }
    $grupo = trim($data['grupo']);
    if ($action === 'get') {
        $stmt = $pdo->prepare("SELECT 1 FROM `{$source['table']}` WHERE `{$source['key']}` = ?");
        $stmt->execute([$grupo]);
        if (!$stmt->fetchColumn()) {
            api_response(false, ['message' => 'Registro não encontrado.'], 404);
        }
        $rows = grupo_categoria_vinculos($pdo, $grupo, $config);
        $links = array_map(static fn($row) => ['SubGrupo' => (string) $row[$child],
            'Inclusao' => $row['Inclusao'] ?? null, 'Alteracao' => $row['Alteracao'] ?? null, 'Usuario' => $row['Usuario'] ?? null], $rows);
        $stmt = $pdo->prepare("SELECT `{$target['key']}` AS Valor, `{$target['label']}` AS Nome, `$targetStatus` AS Status
            FROM `{$target['table']}` WHERE `$targetStatus` = 'Ativo'
            OR `{$target['key']}` IN (SELECT `$child` FROM `$table` WHERE `$parent` = ?)
            ORDER BY `{$target['label']}`, `{$target['key']}`");
        $stmt->execute([$grupo]);
        api_response(true, ['data' => $stmt->fetchAll(), 'vinculos' => $links, 'version' => grupo_categoria_versao($rows)]);
    }
    if (!is_string($data['csrf'] ?? null) || !hash_equals(produtos_csrf(), $data['csrf'])) {
        api_response(false, ['message' => 'Formulário expirado. Recarregue a página.'], 403);
    }
    $selected = $data['categorias'] ?? null;
    if (!is_array($selected) || count($selected) > 10000 || array_filter($selected, static fn($v) => !is_string($v) || $v === '')) {
        throw new InvalidArgumentException('Seleção inválida.');
    }
    $selected = array_values(array_unique($selected));
    $pdo->beginTransaction();
    $stmt = $pdo->prepare("SELECT `$parentStatus` FROM `{$source['table']}` WHERE `{$source['key']}` = ? FOR UPDATE");
    $stmt->execute([$grupo]);
    $status = $stmt->fetchColumn();
    if ($status === false) {
        throw new InvalidArgumentException('Registro não encontrado.');
    }
    $rows = grupo_categoria_vinculos($pdo, $grupo, $config);
    if (!is_string($data['version'] ?? null) || !hash_equals(grupo_categoria_versao($rows), $data['version'])) {
        $pdo->rollBack();
        api_response(false, ['message' => 'Os vínculos deste registro mudaram. Cancele e abra novamente para carregar a versão atual.'], 409);
    }
    $current = array_map('strval', array_column($rows, $child));
    $added = array_values(array_diff($selected, $current));
    $removed = array_values(array_diff($current, $selected));
    if (($added && empty($permissions['inserir'])) || ($removed && (empty($permissions['editar']) || empty($permissions['excluir'])))) {
        $pdo->rollBack();
        api_response(false, ['message' => 'Sem permissão para incluir ou remover os vínculos selecionados.'], 403);
    }
    if ($status !== 'Ativo' && $added) {
        throw new InvalidArgumentException('Ative o registro antes de incluir associações.');
    }
    $stmt = $pdo->prepare("SELECT 1 FROM `{$target['table']}` WHERE `{$target['key']}` = ? AND `$targetStatus` = 'Ativo'");
    foreach ($added as $id) {
        $stmt->execute([$id]);
        if (!$stmt->fetchColumn()) {
            throw new InvalidArgumentException('Seleção inexistente ou inativa: ' . $id);
        }
    }
    foreach ($rows as $row) {
        if (in_array((string) $row[$child], $removed, true) && grupo_categoria_em_uso($pdo, $row, $table)) {
            throw new InvalidArgumentException('O vínculo ' . $row[$child] . ' está em uso em outro cadastro e não pode ser removido. Nenhuma alteração foi salva.');
        }
    }
    $delete = $pdo->prepare("DELETE FROM `$table` WHERE Codigo = ?");
    foreach ($rows as $row) {
        if (in_array((string) $row[$child], $removed, true)) {
            $delete->execute([$row['Codigo']]);
        }
    }
    foreach ($added as $id) {
        $values = [$parent => $grupo, $child => $id];
        foreach (['Status', 'Inclusao', 'Alteracao', 'Usuario'] as $field) {
            if (isset($config['fields'][$field])) {
                $values[$field] = $field === 'Status' ? 'Ativo' : ($field === 'Usuario'
                    ? mb_substr((string) current_user()['login'], 0, 30, 'UTF-8') : date('Y-m-d'));
            }
        }
        if (isset($config['fields']['Ordem'])) {
            // Mantem as ordens existentes; novos tamanhos seguem a ordenacao geral cadastrada.
            $stmt = $pdo->prepare('SELECT Ordem FROM produtos_tamanho_ordem WHERE Codigo = ?');
            $stmt->execute([$id]);
            $order = $stmt->fetchColumn();
            $values['Ordem'] = $order === false ? 0 : (int) $order;
        }
        $columns = '`' . implode('`, `', array_keys($values)) . '`';
        $marks = implode(', ', array_fill(0, count($values), '?'));
        $stmt = $pdo->prepare("INSERT INTO `$table` ($columns) VALUES ($marks)");
        $stmt->execute(array_values($values));
    }
    $pdo->commit();
    api_response(true, ['message' => 'Vínculos salvos.', 'added' => count($added), 'removed' => count($removed)]);
} catch (Throwable $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
    }
    if ($e instanceof InvalidArgumentException) {
        api_response(false, ['message' => $e->getMessage()], 422);
    }
    error_log('Associações de produtos: ' . $e->getMessage());
    api_response(false, ['message' => 'Não foi possível concluir a operação. Nenhuma alteração foi aplicada.'], 500);
}
