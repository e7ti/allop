<?php
$association = produtos_associacao_config($entity);
$parentLabel = $association['parent_label'];
$childrenLabel = $association['children_label'];
render_header($config['title'], [
    ['label' => 'Voltar', 'href' => app_url('dashboard.php'), 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim" id="grupo-categoria-page">
    <div class="card-header">
        <label class="form-label" for="gc-grupos-busca">Pesquisar <?= h($parentLabel) ?></label>
        <input type="search" class="form-control" id="gc-grupos-busca" placeholder="Pesquisar por nome">
        <p class="text-muted small mt-2 mb-0">Expanda a linha para consultar <?= h($childrenLabel) ?>. Marque ou desmarque e salve as alterações.</p>
    </div>
    <div class="card-body">
        <div id="gc-aviso" role="status" aria-live="polite"></div>
        <div class="gc-grid-heading"><span><?= h(ucfirst($parentLabel)) ?></span><span>Vínculos</span></div>
        <div id="gc-grupos">Carregando registros...</div>
        <p id="gc-vazio" class="text-muted py-3" hidden>Nenhum registro encontrado.</p>
    </div>
</section>
<script>
window.grupoCategoriaConfig = <?= json_encode([
    'api' => app_url('api/cadastros/produtos_associacoes.php') . '?cadastro=' . rawurlencode($entity), 'csrf' => produtos_csrf(),
    'childLabel' => $association['child_label'], 'childrenLabel' => $childrenLabel,
    'canInsert' => !empty($permissions['inserir']),
    'canRemove' => !empty($permissions['editar']) && !empty($permissions['excluir']),
], JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT) ?>;
</script>
<script defer src="<?= app_url('assets/js/grupo_categoria.js') ?>"></script>
<?php render_footer(); ?>
