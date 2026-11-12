<?php
require_once __DIR__ . '/../bootstrap.php';
require_once __DIR__ . '/../../includes/produtos_valores.php';
require_once __DIR__ . '/../../includes/produtos_workflow.php';
api_require_login();
$data = request_data();
$action = (string) ($_GET['action'] ?? 'list');
try {
    $pdo = db();
    $permissions = produtos_permissoes('valores');
    if (empty($permissions['visualizar'])) {
        api_response(false, ['message' => 'Acesso não permitido.'], 403);
    }
    $workflow = new ProdutosWorkflow($pdo, (string) current_user()['login']);
    if ($action === 'list') {
        [$where, $params] = produtos_valores_filtro($data);
        $page = min(1000000, max(1, (int) ($data['page'] ?? 1)));
        $offset = ($page - 1) * 30;
        $stmt = $pdo->prepare("SELECT c.Referencia, c.Descricao, c.Fornecedor, c.Categoria, c.Consolidado, c.Inclusao, c.Alteracao, c.Usuario,
            f.NomeFornecedor, r.TipoProduto, x.Quantidade,
            (SELECT COUNT(*) FROM produtos_cab_grade t WHERE t.Referencia = c.Referencia) AS Total
            FROM produtos_cab c
            JOIN (SELECT Referencia, COUNT(*) AS Quantidade FROM produtos_cab_grade $where GROUP BY Referencia) x ON x.Referencia = c.Referencia
            LEFT JOIN produtos_fornecedor f ON f.Codigo = c.Fornecedor
            LEFT JOIN produtos_categorias r ON r.Codigo = c.Categoria
            ORDER BY c.Referencia LIMIT 31 OFFSET $offset");
        $stmt->execute($params);
        $rows = $stmt->fetchAll();
        api_response(true, ['data' => array_slice($rows, 0, 30), 'more' => count($rows) > 30, 'page' => $page]);
    }
    if ($action === 'get') {
        $id = (string) ($data['id'] ?? '');
        $product = $workflow->row('produtos_cab', 'Referencia', $id);
        if (!$product) {
            api_response(false, ['message' => 'Produto não encontrado.'], 404);
        }
        [$where, $params] = produtos_valores_filtro($data);
        $where .= $where === '' ? ' WHERE Referencia = ?' : ' AND Referencia = ?';
        $params[] = $id;
        $page = min(1000000, max(1, (int) ($data['details_page'] ?? 1)));
        $offset = ($page - 1) * 500;
        $stmt = $pdo->prepare("SELECT * FROM produtos_cab_grade $where ORDER BY Distribuidora LIMIT 501 OFFSET $offset");
        $stmt->execute($params);
        $rows = $stmt->fetchAll();
        $more = count($rows) > 500;
        $rows = array_slice($rows, 0, 500);
        foreach ($rows as &$row) {
            $row['_version'] = produtos_valores_versao($row);
        }
        unset($row);
        $labels = [];
        foreach (['Tamanho' => ['produtos_tamanho', 'Nome'], 'Cor' => ['produtos_cor', 'Nome']] as $field => [$table, $label]) {
            $ids = array_values(array_unique(array_column($rows, $field)));
            if ($ids) {
                $marks = implode(',', array_fill(0, count($ids), '?'));
                $stmt = $pdo->prepare("SELECT Codigo, `$label` AS Nome FROM `$table` WHERE Codigo IN ($marks)");
                $stmt->execute($ids);
                $labels[$field] = array_column($stmt->fetchAll(), 'Nome', 'Codigo');
            }
        }
        $styles = $pdo->query("SELECT Codigo, Descricao, Status FROM produtos_estilos ORDER BY Descricao")->fetchAll();
        $defaults = $workflow->defaults();
        api_response(true, ['data' => $product, 'rows' => $rows, 'labels' => $labels, 'styles' => $styles,
            'halfWholesale' => ($defaults['PrecoAtacadoMetadeVarejo'] ?? 'N') === 'S', 'page' => $page, 'more' => $more]);
    }
    if ($action !== 'save') {
        api_response(false, ['message' => 'Ação inválida.'], 404);
    }
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Allow: POST');
        api_response(false, ['message' => 'Use POST para salvar.'], 405);
    }
    if (empty($permissions['editar'])) {
        api_response(false, ['message' => 'Sem permissão para editar valores.'], 403);
    }
    if (!is_string($data['csrf'] ?? null) || !hash_equals(produtos_csrf(), $data['csrf'])) {
        api_response(false, ['message' => 'Formulário expirado. Recarregue a página.'], 403);
    }
    $id = $data['id'] ?? null;
    $changes = $data['rows'] ?? null;
    if (!is_string($id) || !is_array($changes) || !$changes || count($changes) > 500) {
        throw new InvalidArgumentException('Selecione de 1 a 500 itens alterados do produto.');
    }
    $pdo->beginTransaction();
    if (!$workflow->row('produtos_cab', 'Referencia', $id, true)) {
        throw new InvalidArgumentException('Produto não encontrado.');
    }
    $seen = [];
    $defaults = $workflow->defaults();
    $allowed = ['PrecoVendaTabela', 'PrecoCompraTabela', 'PrecoCompra', 'SetorLaranja', 'PrecoCheio', 'Encomenda', 'Estilo'];
    foreach ($changes as $change) {
        if (!is_array($change) || !is_string($change['id'] ?? null) || isset($seen[$change['id']])) {
            throw new InvalidArgumentException('Item duplicado ou inválido.');
        }
        $seen[$change['id']] = true;
        $row = $workflow->row('produtos_cab_grade', 'Distribuidora', $change['id'], true);
        if (!$row || $row['Referencia'] !== $id) {
            throw new InvalidArgumentException('O item não pertence ao produto selecionado.');
        }
        if (!is_string($change['version'] ?? null) || !hash_equals(produtos_valores_versao($row), $change['version'])) {
            $pdo->rollBack();
            api_response(false, ['message' => 'Os valores de ' . $change['id'] . ' mudaram. Reabra o produto para carregar os dados atuais. Nenhuma alteração foi salva.'], 409);
        }
        $patch = $change['values'] ?? null;
        if (!is_array($patch) || !$patch || array_diff(array_keys($patch), $allowed)) {
            throw new InvalidArgumentException('Campos de valores inválidos.');
        }
        foreach ($patch as $field => $value) {
            if (strpos($field, 'Preco') === 0 && $field !== 'PrecoCheio') {
                $patch[$field] = produtos_valores_dinheiro($value);
            } elseif (!is_scalar($value)) {
                throw new InvalidArgumentException('Valor inválido em ' . $field);
            }
        }
        $next = array_replace($row, $patch);
        if (isset($patch['PrecoVendaTabela']) && ($defaults['PrecoAtacadoMetadeVarejo'] ?? 'N') === 'S' && $next['PrecoCheio'] !== 'S') {
            $next['PrecoCompraTabela'] = number_format(round((float) $next['PrecoVendaTabela'] / 2, 2), 2, '.', '');
        }
        $workflow->saveGrade('valores', $change['id'], $next);
    }
    $pdo->commit();
    api_response(true, ['message' => 'Valores salvos. Itens pendentes de consolidação.', 'processed' => count($seen)]);
} catch (Throwable $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
    }
    if ($e instanceof InvalidArgumentException) {
        api_response(false, ['message' => $e->getMessage()], 422);
    }
    error_log('Produtos Valores: ' . $e->getMessage());
    api_response(false, ['message' => 'Não foi possível concluir a operação. Nenhuma alteração foi salva.'], 500);
}
