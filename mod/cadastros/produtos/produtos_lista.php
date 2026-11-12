<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'produtos_lista.php';
$aplicacao_descricao = 'Cadastros auxiliares e consultas de produtos.';
require_once __DIR__ . '/../../../includes/layout.php';
require_once __DIR__ . '/../../../includes/produtos.php';
require_login();
$entity = (string) ($_GET['cadastro'] ?? 'produtos');
$config = produtos_config($entity);
if (!$config) {
    http_response_code(404);
    exit('Cadastro inválido.');
}
$permissions = produtos_permissoes($entity);
if (empty($permissions['visualizar'])) {
    http_response_code(403);
    render_header('Acesso não permitido');
    echo '<div class="alert alert-warning">Seu perfil não tem acesso a este cadastro.</div>';
    render_footer();
    exit;
}
if ($entity === 'produtos') {
    require __DIR__ . '/produtos_accordion.php';
    exit;
}
if ($entity === 'valores') {
    require __DIR__ . '/valores_grid.php';
    exit;
}
if (produtos_associacao_config($entity)) {
    require __DIR__ . '/grupo_categoria_grid.php';
    exit;
}
$columns = produtos_colunas($config, true);
$labels = array_map('produtos_label', $columns);
$selectable = (in_array($entity, ['valores', 'outras_informacoes'], true) && !empty($permissions['editar'])) || ($entity === 'consolidar' && !empty($permissions['processar']));
render_header($config['title'], [
    ['label' => 'Voltar', 'href' => app_url('dashboard.php'), 'class' => 'btn btn-outline-secondary btn-back'],
]);
$aviso = produtos_aviso($entity);
?>
<?php if ($aviso !== ''): ?>
    <div class="alert alert-info"><?= h($aviso) ?></div>
<?php endif; ?>
<?php if ($entity === 'importar_antigos' && !empty($permissions['processar'])): ?>
    <section class="card card-slim mb-3"><div class="card-body">
        <form id="produtos-importar" class="d-flex flex-wrap align-items-end gap-3">
            <div><label class="form-label" for="importar-referencia">Referência master ou completa</label><input class="form-control" id="importar-referencia" name="referencia" minlength="8" maxlength="12" required></div>
            <label class="form-check"><input class="form-check-input" type="checkbox" name="faltantes" value="S" checked> Importar apenas referências faltantes</label>
            <button class="btn btn-orange" type="submit">Importar</button>
        </form>
        <div id="produtos-importar-resumo" class="mt-2" aria-live="polite"></div>
    </div></section>
<?php endif; ?>
<?php if ($entity === 'ordenar_tamanho' && !empty($permissions['editar'])): ?>
    <section class="card card-slim mb-3"><div class="card-header">Ordenação dos tamanhos</div><div class="card-body">
        <p class="text-muted">Use as setas para organizar a apresentação dos tamanhos.</p>
        <ol id="produtos-ordem" class="list-group list-group-numbered"></ol>
        <button class="btn btn-orange btn-save mt-3" id="produtos-salvar-ordem" type="button" disabled>Salvar ordem</button>
    </div></section>
<?php endif; ?>
<section class="card card-slim grid-shell" id="produtos-page">
    <?php if ($selectable): ?>
        <div class="card-header">
            <?php if ($entity === 'consolidar'): ?>
                <button class="btn btn-orange" id="produtos-consolidar-selecao" type="button">Consolidar selecionados</button>
            <?php else: ?>
                <form id="produtos-bulk" class="d-flex flex-wrap align-items-end gap-2">
                    <div><label class="form-label" for="produtos-bulk-campo">Alterar nos selecionados</label><select class="form-select" id="produtos-bulk-campo" name="campo">
                        <?php foreach ($config['form_fields'] as $field): ?><?php if ($field === $config['key']) continue; ?>
                            <option value="<?= h($field) ?>"><?= h(produtos_label($field)) ?></option>
                        <?php endforeach; ?>
                    </select></div>
                    <div><label class="form-label" for="produtos-bulk-valor">Novo valor</label><input class="form-control" id="produtos-bulk-valor" name="valor"><small class="text-muted">Use S/N nos indicadores e Ativo/Inativo no status.</small></div>
                    <button class="btn btn-orange" type="submit">Aplicar aos selecionados</button>
                </form>
            <?php endif; ?>
        </div>
    <?php endif; ?>
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <form id="produtos-filtro" class="grid-filter">
            <div class="filter-inline">
                <input type="search" name="q" class="form-control" placeholder="Pesquisar código, referência ou descrição" aria-label="Pesquisar cadastro">
                <button class="btn btn-orange btn-filter" type="submit">Filtrar</button>
            </div>
            <details class="produtos-filtros-avancados mt-2"><summary>Filtros avançados</summary>
            <div class="d-flex flex-wrap gap-2 mt-2">
                <?php foreach (['Fornecedor', 'Categoria', 'Colecao', 'Linha', 'Grupo', 'GrupoCategoria', 'Genero', 'Composicao', 'Caracteristica', 'Estilo', 'Tamanho', 'Cor'] as $field): ?>
                    <?php if (isset($config['relations'][$field])): ?>
                        <div class="produtos-filtro-select">
                            <select name="<?= h($field) ?>" class="form-select produtos-select" data-field="<?= h($field) ?>" data-placeholder="<?= h(produtos_label($field)) ?>">
                                <option value=""></option>
                            </select>
                        </div>
                    <?php endif; ?>
                <?php endforeach; ?>
                <?php if (isset($config['fields']['Status'])): ?>
                    <select name="Status" class="form-select produtos-filtro-select" aria-label="Status">
                        <option value="">Todos os status</option><option>Ativo</option><option>Inativo</option>
                    </select>
                <?php endif; ?>
            </div>
            </details>
        </form>
        <?php if ($config['editable'] && $config['can_create'] && !empty($permissions['inserir'])): ?>
            <a class="btn btn-orange btn-new" href="produtos_form.php?cadastro=<?= h($entity) ?>">Novo</a>
        <?php endif; ?>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead><tr><?php if ($selectable): ?><th><input type="checkbox" id="produtos-selecionar-todos" aria-label="Selecionar esta página"></th><?php endif; ?><?php foreach ($labels as $label): ?><th><?= h($label) ?></th><?php endforeach; ?><th class="text-end">Ações</th></tr></thead>
            <tbody id="produtos-grid"><tr><td colspan="<?= count($columns) + 1 ?>">Carregando...</td></tr></tbody>
        </table>
    </div>
    <div class="card-footer d-flex justify-content-between align-items-center">
        <button type="button" class="btn btn-outline-secondary" id="produtos-anterior" disabled>Anterior</button>
        <span id="produtos-pagina" aria-live="polite"></span>
        <button type="button" class="btn btn-outline-secondary" id="produtos-proxima" disabled>Próxima</button>
    </div>
</section>
<script>
window.produtosConfig = <?= json_encode([
    'entity' => $entity, 'api' => app_url('api/cadastros/produtos.php'), 'columns' => $columns, 'labels' => $labels,
    'key' => $config['key'], 'editable' => $config['editable'], 'canEdit' => !empty($permissions['editar']),
    'canDelete' => $config['can_delete'] && !empty($permissions['excluir']), 'csrf' => produtos_csrf(),
    'canProcess' => !empty($permissions['processar']), 'processApi' => app_url('api/cadastros/produtos_processos.php'),
    'selectable' => $selectable,
], JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT) ?>;
</script>
<?php render_footer(); ?>
