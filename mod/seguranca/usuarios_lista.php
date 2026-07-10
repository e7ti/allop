<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "usuarios_lista.php";
$aplicacao_descricao = "Lista usuários do sistema.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Usuários', [
    ['label' => 'Voltar', 'href' => '../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter">
            <div class="filter-inline">
                <select id="filtro" class="form-select js-select2" data-entity="usuarios"><option value="">Pesquisar usuário</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="usuarios_form.php">Novo</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead><tr><th>Nome</th><th>Login</th><th>Perfil</th><th>Ativo</th><th class="text-end">Ações</th></tr></thead>
            <tbody id="grid"></tbody>
        </table>
    </div>
</section>
<script>
window.gridConfig = { entity: 'usuarios', form: 'usuarios_form.php', columns: ['nome', 'login', 'perfil_id', 'ativo'], labels: ['Nome', 'Login', 'Perfil', 'Ativo'] };
</script>
<?php render_footer(); ?>

