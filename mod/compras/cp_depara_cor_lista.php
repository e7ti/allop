<?php
/*
    Autor: Claudio Barto
    Data : 23/09/2026
*/
$aplicacao_nome = "cp_depara_cor_lista.php";
$aplicacao_descricao = "Lista o de/para de cores do fornecedor com cores KidStok.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('De/Para de Cores', [
    ['label' => 'Voltar', 'href' => '../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter">
            <div class="filter-inline">
                <select id="filtro" class="form-select js-select2" data-entity="cp_depara_cor"><option value="">Pesquisar cor</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="cp_depara_cor_form.php">Novo</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead><tr><th>Cor Fornecedor</th><th>Cor KidStok</th><th class="text-end">Ações</th></tr></thead>
            <tbody id="grid"></tbody>
        </table>
    </div>
</section>
<script>
window.gridConfig = { entity: 'cp_depara_cor', form: 'cp_depara_cor_form.php', idField: 'cor_fornecedor', columns: ['cor_fornecedor', 'codigo_ks_text'], labels: ['Cor Fornecedor', 'Cor KidStok'] };
</script>
<?php render_footer(); ?>
