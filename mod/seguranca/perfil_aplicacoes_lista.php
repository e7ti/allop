<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "perfil_aplicacoes_lista.php";
$aplicacao_descricao = "Lista permissões de aplicações por perfil.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Perfil x Aplicações', [
    ['label' => 'Voltar', 'href' => '../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter">
            <div class="filter-inline">
                <select id="filtro-perfil-aplicacoes" class="form-select"><option value="">Pesquisar perfil</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar-perfil-aplicacoes" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="perfil_aplicacoes_form.php">Novo</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead>
                <tr>
                    <th>Perfil</th>
                    <th>Total Permissões</th>
                    <th class="text-end">Ações</th>
                </tr>
            </thead>
            <tbody id="perfil-aplicacoes-grid"></tbody>
        </table>
    </div>
</section>
<script>
window.perfilAplicacoesListaConfig = {
    api: '../../api/seguranca/perfil_aplicacoes.php'
};
</script>
<?php render_footer(); ?>
