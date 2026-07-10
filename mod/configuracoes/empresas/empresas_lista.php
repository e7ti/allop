<?php
/*
    Autor: Claudio Barto
    Data : 02/06/2026
*/
$aplicacao_nome = "empresas_lista.php";
$aplicacao_descricao = "Lista empresas cadastradas.";

require_once __DIR__ . '/../../../includes/layout.php';
require_login();
render_header('Empresas', [
    ['label' => 'Voltar', 'href' => '../../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter">
            <div class="filter-inline">
                <select id="filtro-empresas" class="form-select"><option value="">Pesquisar empresa</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar-empresas" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="empresas_form.php">Nova</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead>
                <tr>
                    <th>Código</th>
                    <th>Fantasia</th>
                    <th>CNPJ</th>
                    <th>Cidade/UF</th>
                    <th>Código IBGE</th>
                    <th>Status</th>
                    <th class="text-end">Ações</th>
                </tr>
            </thead>
            <tbody id="empresas-grid"></tbody>
        </table>
    </div>
</section>
<script>
window.empresasListaConfig = {
    api: '../../../api/configuracoes/empresas.php',
    form: 'empresas_form.php'
};
</script>
<?php render_footer(); ?>
