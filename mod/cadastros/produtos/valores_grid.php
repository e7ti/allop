<?php
render_header('Produtos — Valores', [
    ['label' => 'Voltar', 'href' => app_url('dashboard.php'), 'class' => 'btn btn-outline-secondary btn-back'],
]);
$filterFields = ['CodFornecedorR3', 'CodFornecedor', 'Descricao', 'DescricaoComplementar', 'Linha', 'Grupo', 'GrupoCategoria', 'Genero', 'Composicao', 'Caracteristica', 'Estilo', 'Tamanho', 'Cor'];
$filterLabel = ['Referencia' => 'Referência', 'Fornecedor' => 'Fornecedor (R1)', 'Categoria' => 'Categoria (R2)', 'CodFornecedorR3' => 'Código (R3)', 'CodFornecedor' => 'Referência do fornecedor', 'DescricaoComplementar' => 'Descrição complementar', 'GrupoCategoria' => 'Categoria do grupo'];
$renderFilter = static function (string $field) use ($config, $filterLabel): void {
    $label = $filterLabel[$field] ?? produtos_label($field);
    ?>
    <div class="col-12 col-sm-6 col-xl-3">
        <label class="form-label" for="pv-filter-<?= h($field) ?>"><?= h($label) ?></label>
        <?php if (isset($config['relations'][$field])): ?>
            <select class="form-select pv-select" id="pv-filter-<?= h($field) ?>" name="<?= h($field) ?>" data-field="<?= h($field) ?>"><option value=""></option></select>
        <?php else: ?>
            <input class="form-control" id="pv-filter-<?= h($field) ?>" name="<?= h($field) ?>" type="text">
        <?php endif; ?>
    </div>
    <?php
};
?>
<section id="produtos-valores-page">
    <div class="alert alert-info">Edite os valores na grade ou aplique valores aos itens selecionados. Após salvar, os itens ficam pendentes de consolidação.</div>
    <form class="card card-slim mb-3" id="pv-filtros">
        <div class="card-body">
            <div class="row g-3"><?php foreach (['Referencia', 'Fornecedor', 'Categoria', 'Colecao'] as $field) $renderFilter($field); ?></div>
            <details class="mt-3"><summary class="pv-more-filters">Mais filtros</summary>
                <div class="row g-3 mt-1">
                    <?php foreach ($filterFields as $field) $renderFilter($field); ?>
                    <?php foreach (['SetorLaranja' => 'Setor Laranja', 'PrecoCheio' => 'Preço Cheio', 'Encomenda' => 'Encomenda', 'Status' => 'Status', 'Consolidado' => 'Consolidado'] as $field => $label): ?>
                        <div class="col-12 col-sm-6 col-xl-3">
                            <label class="form-label" for="pv-filter-<?= h($field) ?>"><?= h($label) ?></label>
                            <select class="form-select" id="pv-filter-<?= h($field) ?>" name="<?= h($field) ?>">
                                <option value="">Todos</option>
                                <?php foreach ($field === 'Status' ? ['Ativo' => 'Ativo', 'Inativo' => 'Inativo'] : ['S' => 'Sim', 'N' => 'Não'] as $value => $text): ?>
                                    <option value="<?= h($value) ?>"><?= h($text) ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    <?php endforeach; ?>
                </div>
            </details>
        </div>
        <div class="card-footer d-flex align-items-center gap-2 flex-wrap">
            <button type="submit" class="btn btn-orange btn-filter">Filtrar</button>
            <button type="button" id="pv-limpar" class="btn btn-outline-secondary">Limpar filtros</button>
            <span id="pv-filtros-resumo" class="small text-muted" aria-live="polite"></span>
        </div>
    </form>
    <div id="pv-aviso" role="status" aria-live="polite"></div>
    <section class="card card-slim">
        <div class="pv-list-heading"><span>Referência / Descrição</span><span>Fornecedor / Categoria</span><span>Itens</span><span>Consolidação</span></div>
        <div id="pv-produtos" class="p-2">Carregando produtos...</div>
        <div class="card-footer d-flex justify-content-between align-items-center gap-2">
            <button type="button" id="pv-anterior" class="btn btn-outline-secondary" disabled>Anterior</button>
            <span id="pv-pagina" aria-live="polite"></span>
            <button type="button" id="pv-proxima" class="btn btn-outline-secondary" disabled>Próxima</button>
        </div>
    </section>
</section>
<script>
window.produtosValoresConfig = <?= json_encode([
    'api' => app_url('api/cadastros/produtos_valores.php'),
    'optionsApi' => app_url('api/cadastros/produtos.php'),
    'csrf' => produtos_csrf(), 'canEdit' => !empty($permissions['editar']),
], JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT) ?>;
</script>
<script defer src="<?= app_url('assets/js/produtos_valores.js') ?>"></script>
<?php render_footer(); ?>
