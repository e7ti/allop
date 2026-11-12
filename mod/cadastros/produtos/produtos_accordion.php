<?php
$aplicacao_descricao = 'Cadastro de produtos, tributos, referências, fotos e histórico de preços.';
render_header('Produtos', [
    ['label' => 'Voltar', 'href' => app_url('dashboard.php'), 'class' => 'btn btn-outline-secondary btn-back'],
]);
$photoPermissions = produtos_permissoes('fotos');
$taxFields = ['NCM', 'CST_ICMS', 'Origem', 'AliquotaICMS', 'ReducaoICMS', 'CST_PIS', 'AliquotaPIS', 'CST_COFINS', 'AliquotaCOFINS', 'CST_IPI', 'AliquotaIPI', 'CFOP', 'CFOP_ProducaoProria'];
$gradeFields = ['Cor', 'Tamanho', 'PrecoCompra', 'PrecoCompraTabela', 'PrecoVendaTabela', 'SetorLaranja', 'Encomenda', 'PrecoCheio'];
$fieldGroups = ['dados' => [], 'tributos' => [], 'grade' => []];
foreach (produtos_campos_form($config) as $name => $field) {
    $tab = in_array($name, $taxFields, true) ? 'tributos' : (in_array($name, $gradeFields, true) ? 'grade' : 'dados');
    $fieldGroups[$tab][$name] = $field;
}
$identityFields = ['Referencia', 'Fornecedor', 'Categoria', 'CodFornecedorR3'];
$identityGroup = [];
foreach ($identityFields as $field) {
    $identityGroup[$field] = $fieldGroups['dados'][$field];
}
$fieldGroups['dados'] = $identityGroup + $fieldGroups['dados'];
$tabs = ['dados' => 'Dados do produto', 'tributos' => 'Tributos', 'grade' => 'Grade de referências', 'fotos' => 'Fotos', 'historico' => 'Histórico de preços'];
?>
<section id="pc-page">
    <section class="card card-slim mb-4">
        <div class="card-body">
            <form id="pc-filter">
                <div class="pc-filter-main">
                    <div class="pc-search"><label class="form-label small" for="pc-search">Referência</label><select class="form-select" id="pc-search" name="product_reference" aria-label="Pesquisar referência ou descrição"><option value=""></option></select></div>
                    <?php foreach (['Fornecedor' => 'Fornecedor (R1)', 'Categoria' => 'Categoria (R2)'] as $field => $label): ?>
                        <div><label class="form-label small" for="pc-filter-<?= h($field) ?>"><?= h($label) ?></label><select class="form-select pc-filter-select" id="pc-filter-<?= h($field) ?>" name="<?= h($field) ?>[]" data-field="<?= h($field) ?>" multiple></select></div>
                    <?php endforeach; ?>
                    <div><label class="form-label small" for="pc-filter-CodFornecedorR3">Código (R3)</label><input class="form-control" id="pc-filter-CodFornecedorR3" name="CodFornecedorR3" type="text" maxlength="4" placeholder="R3"></div>
                </div>
                <div class="d-flex gap-2 flex-wrap mt-3">
                    <button class="btn btn-orange btn-filter" type="submit">Filtrar</button>
                    <button class="btn btn-outline-secondary" id="pc-clear" type="button">Limpar</button>
                    <?php if (!empty($permissions['inserir'])): ?><button class="btn btn-orange btn-new ms-auto" id="pc-new" type="button">Novo produto</button><?php endif; ?>
                </div>
                <details class="mt-3"><summary>Mais filtros</summary><div class="row g-3 mt-1">
                    <?php foreach (['Colecao', 'Linha', 'Grupo', 'GrupoCategoria', 'Genero', 'Composicao', 'Caracteristica', 'Estilo', 'Tamanho', 'Cor'] as $field): ?>
                        <div class="col-sm-6 col-lg-3">
                            <label class="form-label small" for="pc-filter-<?= h($field) ?>"><?= h(produtos_label($field)) ?></label>
                            <select class="form-select pc-filter-select" id="pc-filter-<?= h($field) ?>" name="<?= h($field) ?>" data-field="<?= h($field) ?>"><option value=""></option></select>
                        </div>
                    <?php endforeach; ?>
                    <?php foreach (['Status' => ['Ativo' => 'Ativo', 'Inativo' => 'Inativo'], 'Consolidado' => ['S' => 'Sim', 'N' => 'Pendente']] as $field => $options): ?>
                        <div class="col-sm-6 col-lg-3"><label class="form-label small" for="pc-filter-<?= h($field) ?>"><?= h(produtos_label($field)) ?></label><select class="form-select" name="<?= h($field) ?>" id="pc-filter-<?= h($field) ?>"><option value="">Todos</option><?php foreach ($options as $value => $label): ?><option value="<?= h($value) ?>"><?= h($label) ?></option><?php endforeach; ?></select></div>
                    <?php endforeach; ?>
                </div></details>
            </form>
        </div>
    </section>
    <div id="pc-notice" role="status" aria-live="polite"></div>
    <div class="pc-list-labels"><span>Referência / Produto</span><span>Fornecedor / Categoria</span><span>Situação</span></div>
    <div id="pc-list" aria-busy="true">Carregando produtos...</div>
    <div class="d-flex justify-content-between align-items-center gap-3 mt-3">
        <button class="btn btn-outline-secondary" id="pc-prev" type="button" disabled>Anterior</button><span id="pc-page-label" class="small text-muted" aria-live="polite"></span><button class="btn btn-outline-secondary" id="pc-next" type="button" disabled>Próxima</button>
    </div>
</section>
<template id="pc-editor-template">
    <form class="pc-editor" novalidate>
        <div class="pc-tabs" role="tablist" aria-label="Informações do produto">
            <?php foreach ($tabs as $tab => $label): ?><button type="button" class="pc-tab" id="pc-tab-<?= h($tab) ?>" role="tab" data-tab="<?= h($tab) ?>" aria-controls="pc-pane-<?= h($tab) ?>" aria-selected="<?= $tab === 'dados' ? 'true' : 'false' ?>" tabindex="<?= $tab === 'dados' ? '0' : '-1' ?>"><?= h($label) ?></button><?php endforeach; ?>
        </div>
        <div class="pc-editor-feedback" role="status" aria-live="polite"></div>
        <?php foreach ($tabs as $tab => $title): ?>
            <section id="pc-pane-<?= h($tab) ?>" class="pc-tab-pane" role="tabpanel" aria-labelledby="pc-tab-<?= h($tab) ?>" data-pane="<?= h($tab) ?>" <?= $tab === 'dados' ? '' : 'hidden' ?>>
                <?php if (isset($fieldGroups[$tab])): ?>
                    <?php if ($tab === 'grade'): ?><p class="small text-muted">Tamanhos, cores e valores abaixo são usados para criar novas combinações. As referências e os valores individuais existentes são preservados.</p><?php endif; ?>
                    <fieldset class="pc-fields" disabled><div class="row g-3">
                        <?php foreach ($fieldGroups[$tab] as $name => $field): ?>
                            <?php
                            $numeric = in_array($field['type'], ['int', 'bigint', 'tinyint', 'smallint', 'double', 'decimal', 'float'], true);
                            $decimal = in_array($field['type'], ['double', 'decimal', 'float'], true);
                            $relation = isset($config['relations'][$name]);
                            $multiple = !empty($config['relations'][$name]['multiple']);
                            $options = $name === 'Status' ? ['Ativo' => 'Ativo', 'Inativo' => 'Inativo'] : (in_array($name, ['SetorLaranja', 'Encomenda', 'PrecoCheio'], true) ? ['N' => 'Não', 'S' => 'Sim'] : []);
                            $label = ['CFOP_ProducaoProria' => 'CFOP de produção própria', 'AliquotaICMS' => 'Alíquota ICMS (%)', 'ReducaoICMS' => 'Redução ICMS (%)', 'AliquotaPIS' => 'Alíquota PIS (%)', 'AliquotaCOFINS' => 'Alíquota COFINS (%)', 'AliquotaIPI' => 'Alíquota IPI (%)'][$name] ?? produtos_label($name);
                            $required = !$field['nullable'] && !in_array($name, ['Referencia', 'Descricao', 'DescricaoComplementar', 'CFOP_ProducaoProria'], true);
                            ?>
                            <div class="<?= $tab === 'dados' && in_array($name, $identityFields, true) ? 'col-12 col-md-6 col-lg-3' : 'col-12 col-md-6 col-xl-4' ?>">
                                <label class="form-label" for="pc-field-<?= h($name) ?>"><?= h($label) ?></label>
                                <?php if ($relation || $options): ?>
                                    <select class="form-select pc-editor-control <?= $relation ? 'pc-editor-select' : '' ?>" id="pc-field-<?= h($name) ?>" name="<?= h($name) ?><?= $multiple ? '[]' : '' ?>" data-field="<?= h($name) ?>" <?= $multiple ? 'multiple' : '' ?> <?= $required ? 'required' : '' ?>>
                                        <?php if (!$multiple): ?><option value=""></option><?php endif; ?>
                                        <?php foreach ($options as $value => $text): ?><option value="<?= h($value) ?>" <?= (string) $field['default'] === $value ? 'selected' : '' ?>><?= h($text) ?></option><?php endforeach; ?>
                                    </select>
                                <?php else: ?>
                                    <input class="form-control pc-editor-control<?= $decimal ? ' allop-decimal' : '' ?>" id="pc-field-<?= h($name) ?>" name="<?= h($name) ?>" data-field="<?= h($name) ?>" type="<?= $numeric && !$decimal ? 'number' : 'text' ?>" <?= $decimal ? 'inputmode="numeric" data-decimal-places="' . (int) (explode(',', (string) $field['size'])[1] ?? 2) . '" data-decimal-max-digits="' . (int) (explode(',', (string) ($field['size'] ?: '15'))[0]) . '"' : ($numeric ? 'min="0" step="1"' : '') ?> <?= !$numeric && $field['size'] ? 'maxlength="' . (int) $field['size'] . '"' : '' ?> value="<?= h((string) ($field['default'] ?? '')) ?>" <?= $name === 'Referencia' ? 'readonly' : '' ?> <?= $required ? 'required' : '' ?>>
                                <?php endif; ?>
                            </div>
                        <?php endforeach; ?>
                    </div></fieldset>
                    <?php if ($tab === 'grade'): ?><div class="pc-grade-area mt-4"></div><?php endif; ?>
                <?php elseif ($tab === 'fotos'): ?>
                    <p class="small text-muted">Até cinco imagens por produto, com até 10 MB por arquivo.</p>
                    <div class="pc-photos"></div>
                    <?php if (!empty($photoPermissions['visualizar']) && !empty($photoPermissions['inserir'])): ?>
                        <div class="pc-photo-upload d-flex gap-2 flex-wrap mt-3"><label class="flex-grow-1">Nova foto<input class="form-control mt-1" type="file" accept="image/jpeg,image/png,image/webp,image/gif,image/bmp" aria-label="Nova foto do produto"></label><button type="button" class="btn btn-orange pc-photo-send align-self-end">Enviar foto</button></div>
                    <?php endif; ?>
                <?php else: ?>
                    <div class="pc-history-filter d-flex gap-2 flex-wrap mb-3"><input class="form-control" type="search" placeholder="Referência completa (opcional)" aria-label="Filtrar histórico por referência"><button type="button" class="btn btn-outline-secondary pc-history-search">Filtrar histórico</button></div>
                    <div class="pc-history-area"></div>
                <?php endif; ?>
            </section>
        <?php endforeach; ?>
        <div class="pc-editor-footer">
            <span class="pc-editor-summary small text-muted" aria-live="polite"></span>
            <div class="d-flex flex-wrap gap-2">
                <button class="btn btn-outline-secondary pc-close" type="button">Fechar</button>
                <?php if (!empty($permissions['excluir'])): ?><button class="btn btn-outline-danger pc-delete" type="button">Excluir produto</button><?php endif; ?>
                <?php if (!empty($permissions['editar']) || !empty($permissions['inserir'])): ?><button class="btn btn-orange btn-save pc-save" type="submit" disabled>Salvar alterações</button><?php endif; ?>
            </div>
        </div>
    </form>
</template>
<script>
window.produtosAccordionConfig = <?= json_encode([
    'api' => app_url('api/cadastros/produtos.php'), 'processApi' => app_url('api/cadastros/produtos_processos.php'),
    'canEdit' => !empty($permissions['editar']), 'canCreate' => !empty($permissions['inserir']),
    'canDelete' => !empty($permissions['excluir']), 'csrf' => produtos_csrf(),
    'canViewPhotos' => !empty($photoPermissions['visualizar']),
    'canInsertPhotos' => !empty($photoPermissions['visualizar']) && !empty($photoPermissions['inserir']),
    'canDeletePhotos' => !empty($photoPermissions['visualizar']) && !empty($photoPermissions['excluir']),
], JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT) ?>;
</script>
<script defer src="<?= app_url('assets/js/produtos_accordion.js') ?>"></script>
<?php render_footer(); ?>
