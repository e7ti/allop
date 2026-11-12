<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'produtos.php';
$aplicacao_descricao = 'API de cadastros auxiliares e consultas de produtos.';
require_once __DIR__ . '/../bootstrap.php';
require_once __DIR__ . '/../../includes/produtos.php';
require_once __DIR__ . '/../../includes/produtos_workflow.php';
api_require_login();
$data = request_data();
$entity = (string) ($_GET['cadastro'] ?? $data['cadastro'] ?? '');
$config = produtos_config($entity);
if (!$config) {
    api_response(false, ['message' => 'Cadastro inválido.'], 404);
}
$action = (string) ($_GET['action'] ?? 'list');

try {
    $connection = db();
    $permissions = produtos_permissoes($entity);
    if (empty($permissions['visualizar'])) {
        api_response(false, ['message' => 'Acesso não permitido.'], 403);
    }
    $table = $config['table'];
    $key = $config['key'];
    $workflow = new ProdutosWorkflow($connection, (string) current_user()['login']);
    if ($action === 'product_search' && $entity === 'produtos') {
        $q = trim((string) ($data['q'] ?? ''));
        $page = min(1000000, max(1, (int) ($data['page'] ?? 1)));
        $offset = ($page - 1) * 25;
        $stmt = db()->prepare("SELECT Referencia, Descricao FROM produtos_cab
            WHERE Referencia LIKE ? OR Descricao LIKE ? ORDER BY Referencia LIMIT 26 OFFSET $offset");
        $stmt->execute(['%' . $q . '%', '%' . $q . '%']);
        $rows = $stmt->fetchAll();
        $results = array_map(static fn($row) => ['id' => (string) $row['Referencia'],
            'text' => $row['Referencia'] . ' - ' . $row['Descricao']], array_slice($rows, 0, 25));
        api_response(true, ['results' => $results, 'pagination' => ['more' => count($rows) > 25]]);
    }
    if ($action === 'price_history' && $entity === 'produtos') {
        $id = (string) ($data['id'] ?? '');
        if (!$workflow->row('produtos_cab', 'Referencia', $id)) {
            api_response(false, ['message' => 'Produto não encontrado.'], 404);
        }
        $reference = trim((string) ($data['reference'] ?? ''));
        $params = [];
        if ($reference !== '') {
            if (strpos($reference, $id) !== 0 || !preg_match('/^[A-Za-z0-9]{8,20}$/D', $reference)) {
                throw new InvalidArgumentException('Informe uma referência deste produto.');
            }
            $where = 'Referencia = ?';
            $params[] = $reference;
        } else {
            $where = '(Referencia = ? OR Referencia LIKE ?)';
            $params = [$id, $id . '%'];
        }
        $page = min(1000000, max(1, (int) ($data['page'] ?? 1)));
        $offset = ($page - 1) * 50;
        $stmt = db()->prepare("SELECT Id, DataHora, Produto, Referencia, Acao, VarejoOLD, VarejoNEW,
            AtacadoOLD, AtacadoNEW, CompraOLD, CompraNEW, Usuario FROM produtos_log_preco
            WHERE $where ORDER BY DataHora DESC, Id DESC LIMIT 51 OFFSET $offset");
        $stmt->execute($params);
        $rows = $stmt->fetchAll();
        api_response(true, ['data' => array_slice($rows, 0, 50), 'more' => count($rows) > 50, 'page' => $page]);
    }
    if ($action === 'defaults') {
        $defaults = $workflow->defaults();
        $defaults['ReducaoICMS'] = $defaults['ReducaoBaseICMS'] ?? 0;
        $related = [];
        foreach ($config['relations'] as $field => $relation) {
            if (!isset($defaults[$field]) || $defaults[$field] === '') {
                continue;
            }
            $stmt = db()->prepare("SELECT `{$relation['label']}` FROM `{$relation['table']}` WHERE `{$relation['key']}` = ? LIMIT 1");
            $stmt->execute([$defaults[$field]]);
            $label = $stmt->fetchColumn();
            if ($label !== false) {
                $related[$field] = $defaults[$field] . ' - ' . $label;
            }
        }
        api_response(true, ['data' => $defaults, 'related' => $related]);
    }
    if ($action === 'sizes' && $entity === 'ordenar_tamanho') {
        $stmt = db()->query('SELECT t.Codigo, t.Nome, o.Ordem FROM produtos_tamanho t
            LEFT JOIN produtos_tamanho_ordem o ON o.Codigo = t.Codigo ORDER BY COALESCE(o.Ordem, 999999), t.Codigo');
        api_response(true, ['data' => $stmt->fetchAll()]);
    }
    if ($action === 'options') {
        $field = (string) ($_GET['field'] ?? '');
        $relation = $config['relations'][$field] ?? null;
        if (!$relation) {
            api_response(false, ['message' => 'Relacionamento inválido.'], 400);
        }
        $q = trim((string) ($_GET['q'] ?? ''));
        $relationFilter = '';
        $optionParams = ['id' => '%' . $q . '%', 'label' => '%' . $q . '%'];
        $statusField = in_array($relation['table'], ['produtos_grupos_livre', 'produtos_categorias_livre'], true) ? 'Sts' : 'Status';
        $relationFilter .= " AND `$statusField` = 'Ativo'";
        if ($entity === 'produtos' && $field === 'GrupoCategoria' && !empty($_GET['Grupo'])) {
            $relationFilter .= ' AND CategoriaLivre IN (SELECT SubGrupo FROM produtos_grupos WHERE Grupo = :grupo)';
            $optionParams['grupo'] = (string) $_GET['Grupo'];
        }
        if ($entity === 'produtos' && $field === 'Tamanho' && !empty($_GET['Grupo'])) {
            $relationFilter .= ' AND Codigo IN (SELECT t.Tamanho FROM produtos_grupos_tamanho t JOIN produtos_grupos_livre g ON g.Codigo = t.GrupoLivre WHERE g.GrupoLivre = :grupo)';
            $optionParams['grupo'] = (string) $_GET['Grupo'];
        }
        $stmt = db()->prepare("SELECT DISTINCT `{$relation['key']}` AS id, `{$relation['label']}` AS label
            FROM `{$relation['table']}` WHERE (`{$relation['key']}` LIKE :id OR `{$relation['label']}` LIKE :label) $relationFilter
            ORDER BY `{$relation['label']}` LIMIT 50");
        $stmt->execute($optionParams);
        $rows = array_map(static fn($r) => ['id' => (string) $r['id'], 'text' => $r['id'] . ' - ' . $r['label']], $stmt->fetchAll());
        api_response(true, ['results' => $rows]);
    }
    if ($action === 'photo' || $action === 'photos') {
        if ($entity !== 'fotos') {
            api_response(false, ['message' => 'Ação inválida para este cadastro.'], 400);
        }
        // Produtos_fotos pertence ao banco principal; o banco de fotos separado contém fotos de compras.
        $id = (string) ($data['id'] ?? '');
        if ($action === 'photos') {
            $stmt = db()->prepare('SELECT Sequencia FROM produtos_fotos WHERE Referencia = ? ORDER BY Sequencia');
            $stmt->execute([$id]);
            api_response(true, ['data' => $stmt->fetchAll()]);
        }
        $stmt = db()->prepare('SELECT Foto FROM produtos_fotos WHERE Referencia = ? AND Sequencia = ?');
        $stmt->execute([$id, (int) ($data['sequencia'] ?? 0)]);
        $bytes = $stmt->fetchColumn();
        $type = $bytes === false ? false : (new finfo(FILEINFO_MIME_TYPE))->buffer($bytes);
        if (!in_array($type, ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/bmp', 'image/x-ms-bmp'], true)) {
            api_response(false, ['message' => 'Foto não disponível.'], 404);
        }
        header('Content-Type: ' . $type);
        header('X-Content-Type-Options: nosniff');
        header('Cache-Control: private, no-store');
        echo $bytes;
        exit;
    }
    if ($action === 'list') {
        [$where, $params] = produtos_pesquisa($config, $data);
        $page = min(1000000, max(1, (int) ($data['page'] ?? 1)));
        $offset = ($page - 1) * 50;
        $columns = array_unique(array_merge([$key], produtos_colunas($config, true)));
        $select = implode(', ', array_map(static fn($c) => isset($config['fields'][$c]) ? "`$c`" : "NULL AS `$c`", $columns));
        $order = $entity === 'ordenar_tamanho' ? '`Ordem`, `Codigo`' : "`$key`";
        $stmt = db()->prepare("SELECT $select FROM `$table` $where ORDER BY $order LIMIT 51 OFFSET $offset");
        $stmt->execute($params);
        $rows = $stmt->fetchAll();
        $more = count($rows) > 50;
        $rows = array_slice($rows, 0, 50);
        foreach ($config['relations'] as $field => $relation) {
            if (!in_array($field, $columns, true) || !$rows) {
                continue;
            }
            $ids = array_values(array_unique(array_column($rows, $field)));
            $placeholders = implode(', ', array_fill(0, count($ids), '?'));
            $stmt = db()->prepare("SELECT `{$relation['key']}` AS id, `{$relation['label']}` AS label
                FROM `{$relation['table']}` WHERE `{$relation['key']}` IN ($placeholders)");
            $stmt->execute($ids);
            $labels = [];
            foreach ($stmt->fetchAll() as $label) {
                $labels[(string) $label['id']] = $label['label'];
            }
            foreach ($rows as &$row) {
                $value = (string) $row[$field];
                $row[$field . '_text'] = isset($labels[$value]) ? $value . ' - ' . $labels[$value] : $value;
            }
            unset($row);
        }
        api_response(true, ['data' => $rows, 'page' => $page, 'more' => $more]);
    }
    if ($action === 'get') {
        $id = (string) ($data['id'] ?? '');
        $stmt = db()->prepare("SELECT * FROM `$table` WHERE `$key` = :id LIMIT 1");
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        if (!$row) {
            api_response(false, ['message' => 'Registro não encontrado.'], 404);
        }
        $related = [];
        foreach ($config['relations'] as $field => $r) {
            $relatedIds = !empty($r['multiple']) ? array_filter(explode(';', (string) $row[$field])) : [$row[$field]];
            foreach ($relatedIds as $relatedId) {
                $stmt = db()->prepare("SELECT `{$r['label']}` FROM `{$r['table']}` WHERE `{$r['key']}` = ? LIMIT 1");
                $stmt->execute([$relatedId]);
                $label = $stmt->fetchColumn();
                $text = $relatedId . ' - ' . ($label === false ? '' : $label);
                if (!empty($r['multiple'])) {
                    $related[$field][(string) $relatedId] = $text;
                } else {
                    $related[$field] = $text;
                }
            }
        }
        $details = [];
        $detailsPage = min(1000000, max(1, (int) ($data['details_page'] ?? 1)));
        $detailsOffset = ($detailsPage - 1) * 500;
        if ($table === 'produtos_cab') {
            $stmt = db()->prepare('SELECT Distribuidora, Descricao, Tamanho, Cor, PrecoCompra, PrecoCompraTabela, PrecoVendaTabela, Status, Consolidado, Inclusao, Alteracao, Usuario
                FROM produtos_cab_grade WHERE Referencia = ? ORDER BY Distribuidora LIMIT 501 OFFSET ' . $detailsOffset);
            $stmt->execute([$id]);
            $details = $stmt->fetchAll();
        } elseif ($table === 'produtos_precos_cab') {
            $stmt = db()->prepare('SELECT * FROM produtos_precos_itens WHERE IDCab = ? ORDER BY Sequencia, IDItens LIMIT 501 OFFSET ' . $detailsOffset);
            $stmt->execute([$id]);
            $details = $stmt->fetchAll();
        }
        api_response(true, ['data' => $row, 'version' => hash('sha256', json_encode($row, JSON_UNESCAPED_UNICODE)), 'related' => $related, 'details' => array_slice($details, 0, 500), 'details_more' => count($details) > 500, 'details_page' => $detailsPage]);
    }
    if (!in_array($action, ['save', 'delete'], true)) {
        api_response(false, ['message' => 'Ação inválida.'], 400);
    }
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Allow: POST');
        api_response(false, ['message' => 'Use POST para gravar.'], 405);
    }
    if (!$config['editable']) {
        api_response(false, ['message' => 'Este fluxo está disponível somente para consulta.'], 403);
    }
    if (!hash_equals(produtos_csrf(), (string) ($data['csrf'] ?? ''))) {
        api_response(false, ['message' => 'Formulário expirado. Recarregue a página.'], 403);
    }
    $id = (string) ($data['id'] ?? '');
    $editing = $id !== '';
    $permission = $action === 'delete' ? 'excluir' : ($editing ? 'editar' : 'inserir');
    if (empty($permissions[$permission])) {
        api_response(false, ['message' => 'Você não tem permissão para esta operação.'], 403);
    }
    if (!$editing && !$config['can_create']) {
        api_response(false, ['message' => 'Selecione uma referência existente para editar.'], 422);
    }
    if ($action === 'delete' && !$config['can_delete']) {
        api_response(false, ['message' => 'Exclusão não permitida neste cadastro.'], 403);
    }
    db()->beginTransaction();
    if ($editing) {
        $stmt = db()->prepare("SELECT `$key` FROM `$table` WHERE `$key` = ? FOR UPDATE");
        $stmt->execute([$id]);
        if ($stmt->fetchColumn() === false) {
            db()->rollBack();
            api_response(false, ['message' => 'Registro não encontrado.'], 404);
        }
    }
    $result = null;
    if ($entity === 'produtos') {
        if ($editing && $action === 'save' && array_key_exists('version', $data)) {
            $current = $workflow->row('produtos_cab', 'Referencia', $id, true);
            if (!is_string($data['version']) || !hash_equals(hash('sha256', json_encode($current, JSON_UNESCAPED_UNICODE)), $data['version'])) {
                db()->rollBack();
                api_response(false, ['message' => 'Este produto foi alterado por outra sessão. Reabra o produto para carregar os dados atuais. Nenhuma alteração foi salva.'], 409);
            }
        }
        if ($action === 'delete') {
            $workflow->deleteProduct($id);
            $result = ['id' => $id];
        } else {
            $result = $workflow->saveProduct($data, $editing ? $id : null);
        }
    } elseif (in_array($entity, ['valores', 'outras_informacoes'], true)) {
        $result = $workflow->saveGrade($entity, $id, $data);
    } elseif ($entity === 'precos_lote') {
        if ($action === 'delete') {
            $workflow->deleteBatch($id);
            $result = ['id' => $id];
        } else {
            $result = $workflow->saveBatch($data, $editing ? $id : null);
        }
    }
    if ($result !== null) {
        db()->commit();
        api_response(true, $result + ['message' => $action === 'delete' ? 'Registro excluído. Referências já consolidadas foram preservadas.' : 'Registro salvo.']);
    }
    if ($action === 'delete') {
        if (!$editing || $entity === 'parametros') {
            throw new InvalidArgumentException('Exclusão não permitida.');
        }
        // Os vínculos com ON DELETE CASCADE também precisam bloquear exclusões acidentais.
        $stmt = db()->prepare('SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE
            WHERE REFERENCED_TABLE_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME = :table');
        $stmt->execute(['table' => $table]);
        foreach ($stmt->fetchAll() as $reference) {
            $check = db()->prepare("SELECT 1 FROM `{$reference['TABLE_NAME']}`
                WHERE `{$reference['COLUMN_NAME']}` = (SELECT `{$reference['REFERENCED_COLUMN_NAME']}` FROM `$table` WHERE `$key` = ?) LIMIT 1");
            $check->execute([$id]);
            if ($check->fetchColumn()) {
                throw new InvalidArgumentException('Este cadastro possui vínculos. Remova os vínculos antes de excluir.');
            }
        }
        $stmt = db()->prepare("DELETE FROM `$table` WHERE `$key` = ?");
        $stmt->execute([$id]);
    } else {
        $values = produtos_validar($config, $data, $editing);
        if ($editing) {
            $set = implode(', ', array_map(static fn($f) => "`$f` = ?", array_keys($values)));
            $stmt = db()->prepare("UPDATE `$table` SET $set WHERE `$key` = ?");
            $stmt->execute(array_merge(array_values($values), [$id]));
        } else {
            $columns = implode(', ', array_map(static fn($f) => "`$f`", array_keys($values)));
            $placeholders = implode(', ', array_fill(0, count($values), '?'));
            $stmt = db()->prepare("INSERT INTO `$table` ($columns) VALUES ($placeholders)");
            $stmt->execute(array_values($values));
            $id = $config['fields'][$key]['auto'] ? db()->lastInsertId() : (string) $values[$key];
        }
    }
    db()->commit();
    api_response(true, ['id' => $id, 'message' => $action === 'delete' ? 'Registro excluído.' : 'Registro salvo.']);
} catch (Throwable $e) {
    if (isset($connection) && $connection->inTransaction()) {
        $connection->rollBack();
    }
    if ($e instanceof InvalidArgumentException) {
        api_response(false, ['message' => $e->getMessage()], 422);
    }
    if ($e instanceof PDOException && ($e->errorInfo[1] ?? null) === 1062) {
        api_response(false, ['message' => 'Já existe um cadastro com este código ou combinação de valores.'], 409);
    }
    if ($e instanceof PDOException && in_array($e->errorInfo[1] ?? null, [1451, 1452], true)) {
        api_response(false, ['message' => 'Existem vínculos ou relacionamentos inválidos para esta operação.'], 409);
    }
    error_log('Produtos: ' . $e->getMessage());
    api_response(false, ['message' => 'Não foi possível concluir a operação. Verifique a configuração e a disponibilidade do banco.'], 500);
}
