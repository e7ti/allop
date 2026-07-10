<?php
/*
    Autor: Claudio Barto
    Data : 18/06/2026
*/
$aplicacao_nome = "cp_compras_lista.php";
$aplicacao_descricao = "Lista pedidos de compra cadastrados.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Pedidos de Compra', [
    ['label' => 'Voltar', 'href' => '../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter cp-compras-filter">
            <div class="filter-inline">
                <select id="filtro-cp-compras" class="form-select"><option value="">Pesquisar pedido</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar-cp-compras" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="cp_compras_form.php">Novo</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead>
                <tr>
                    <th>Pedido</th>
                    <th>Data</th>
                    <th>CD</th>
                    <th>Empresa</th>
                    <th>Fornecedor</th>
                    <th>Localização</th>
                    <th>Publicado</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th class="text-end">Ações</th>
                </tr>
            </thead>
            <tbody id="cp-compras-grid"></tbody>
        </table>
    </div>
</section>
<script>
window.cpComprasListaConfig = {
    api: '../../api/compras/cp_compras.php',
    form: 'cp_compras_form.php'
};
</script>
<?php render_footer(); ?>
