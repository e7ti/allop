<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "aplicacoes_lista.php";
$aplicacao_descricao = "Lista aplicacoes cadastradas para menu e permissoes.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Aplicacoes', [
    ['label' => 'Voltar', 'href' => '../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter">
            <div class="filter-inline">
                <select id="filtro" class="form-select js-select2" data-entity="aplicacoes"><option value="">Pesquisar aplicacao</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="aplicacoes_form.php">Nova</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead><tr><th>Nome</th><th>Rota</th><th>Menu</th><th>Ordem</th><th class="text-end">Acoes</th></tr></thead>
            <tbody id="grid"></tbody>
        </table>
    </div>
</section>
<script>
window.gridConfig = { entity: 'aplicacoes', form: 'aplicacoes_form.php', columns: ['nome', 'rota', 'menu_id', 'ordem'], labels: ['Nome', 'Rota', 'Menu', 'Ordem'] };
</script>
<?php render_footer(); ?>

