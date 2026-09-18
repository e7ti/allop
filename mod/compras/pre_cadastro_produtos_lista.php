<?php
/*
    Autor: Claudio Barto
    Data : 17/09/2026
*/
$aplicacao_nome = "pre_cadastro_produtos_lista.php";
$aplicacao_descricao = "Lista os pre-cadastros de produtos gerados.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();

function pc_lista_column_exists(string $table, string $column): bool
{
    $stmt = db()->prepare(
        "SELECT COUNT(*)
           FROM INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = :table
            AND COLUMN_NAME = :column"
    );
    $stmt->execute(['table' => $table, 'column' => $column]);
    return (int) $stmt->fetchColumn() > 0;
}

$rows = [];
$erro = '';

try {
    $consolidadoSelect = pc_lista_column_exists('pre_cadastro', 'consolidado') ? 'pc.consolidado' : '0 AS consolidado';
    $compraSelect = pc_lista_column_exists('pre_cadastro', 'compra') ? 'pc.compra' : '0 AS compra';
    $stmt = db()->query(
        "SELECT pc.id,
                pc.cp_compras_id,
                pc.data_entrega,
                pc.Categoria,
                pc.Itens,
                pc.QtdeItens,
                pc.Tamanhos,
                pc.Cores,
                pc.valor_total,
                pc.fornecedor_id,
                $consolidadoSelect,
                $compraSelect,
                cd.NomeCD AS cd_nome,
                COALESCE(NULLIF(e.Fantasia, ''), e.Nome) AS empresa_nome,
                COALESCE(NULLIF(f.NomeFornecedor, ''), pc.fornecedor_id) AS fornecedor_nome,
                COALESCE(NULLIF(cat.TipoProduto, ''), pc.Categoria) AS categoria_nome
           FROM pre_cadastro pc
           LEFT JOIN empresas_cd cd ON cd.Codigo = pc.cd_id
           LEFT JOIN empresas e ON e.Codigo = pc.empresa_id
           LEFT JOIN produtos_fornecedor f ON f.Codigo = pc.fornecedor_id
           LEFT JOIN produtos_categorias cat ON cat.Codigo = pc.Categoria
          ORDER BY pc.id DESC
          LIMIT 200"
    );
    $rows = $stmt->fetchAll();
} catch (Throwable $e) {
    $erro = 'Nao foi possivel carregar os pre-cadastros.';
}

render_header('Pre Cadastro Produtos', [
    ['label' => 'Novo', 'href' => 'pre_cadastro_produtos_form.php', 'class' => 'btn btn-orange btn-new'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex justify-content-between align-items-center gap-2">
        <strong>Pre-cadastros gerados</strong>
        <span class="text-muted small"><?= count($rows) ?> registro(s)</span>
    </div>
    <div class="card-body">
        <?php if ($erro !== ''): ?>
            <div class="alert alert-danger mb-0"><?= h($erro) ?></div>
        <?php elseif (!$rows): ?>
            <div class="text-center text-muted py-3">Nenhum pre-cadastro encontrado.</div>
        <?php else: ?>
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Pedido</th>
                            <th>CD</th>
                            <th>Empresa</th>
                            <th>Fornecedor</th>
                            <th>Categoria</th>
                            <th>Entrega</th>
                            <th class="text-end">Itens</th>
                            <th class="text-end">Tamanhos</th>
                            <th class="text-end">Cores</th>
                            <th class="text-end">Qtde</th>
                            <th class="text-end">Valor</th>
                            <th>Status</th>
                            <th class="text-end">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($rows as $row): ?>
                            <tr>
                                <td data-label="ID"><?= h($row['id']) ?></td>
                                <td data-label="Pedido"><?= h($row['cp_compras_id']) ?></td>
                                <td data-label="CD"><?= h($row['cd_nome'] ?? '') ?></td>
                                <td data-label="Empresa"><?= h($row['empresa_nome'] ?? '') ?></td>
                                <td data-label="Fornecedor"><?= h(trim((string) ($row['fornecedor_id'] ?? '') . ' - ' . (string) ($row['fornecedor_nome'] ?? ''), ' -')) ?></td>
                                <td data-label="Categoria"><?= h(trim((string) ($row['Categoria'] ?? '') . ' - ' . (string) ($row['categoria_nome'] ?? ''), ' -')) ?></td>
                                <td data-label="Entrega"><?= h($row['data_entrega'] ? date('d/m/Y', strtotime((string) $row['data_entrega'])) : '') ?></td>
                                <td data-label="Itens" class="text-end"><?= h($row['Itens']) ?></td>
                                <td data-label="Tamanhos" class="text-end"><?= h($row['Tamanhos']) ?></td>
                                <td data-label="Cores" class="text-end"><?= h($row['Cores']) ?></td>
                                <td data-label="Qtde" class="text-end"><?= h($row['QtdeItens']) ?></td>
                                <td data-label="Valor" class="text-end">R$ <?= h(number_format((float) $row['valor_total'], 2, ',', '.')) ?></td>
                                <td data-label="Status">
                                    <?php if ((int) ($row['consolidado'] ?? 0) === 1): ?>
                                        <span class="badge bg-success">Consolidado</span>
                                    <?php else: ?>
                                        <span class="badge bg-warning text-dark">Nao consolidado</span>
                                    <?php endif; ?>
                                </td>
                                <td data-label="Ações" class="text-end">
                                    <?php if ((int) ($row['consolidado'] ?? 0) === 0): ?>
                                        <button class="btn btn-sm btn-warning text-dark btn-consolidate btn-pre-cadastro-consolidar" type="button" data-id="<?= h($row['id']) ?>">Consolidar</button>
                                        <a class="btn btn-sm btn-edit" href="pre_cadastro_produtos_form.php?id=<?= h($row['id']) ?>">Editar</a>
                                    <?php elseif ((int) ($row['compra'] ?? 0) === 0): ?>
                                        <button class="btn btn-sm btn-orange btn-generate-purchase" type="button" data-id="<?= h($row['id']) ?>" data-bs-toggle="tooltip" title="Gera Pedido de Compra">Gerar compra</button>
                                    <?php else: ?>
                                        <span class="text-muted small">Compra gerada</span>
                                    <?php endif; ?>
                                    <?php if ((int) ($row['consolidado'] ?? 0) === 1): ?>
                                        <button class="btn btn-sm btn-outline-secondary btn-history btn-pre-cadastro-historico" type="button" data-id="<?= h($row['id']) ?>" data-bs-toggle="tooltip" title="Move pre cadastro para historico">Histórico</button>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </div>
</section>
<script>
window.preCadastroProdutosListaConfig = {
    api: '../../api/compras/pre_cadastro_produtos.php'
};
</script>
<?php render_footer(); ?>
