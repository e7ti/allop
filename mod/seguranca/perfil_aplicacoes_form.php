<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "perfil_aplicacoes_form.php";
$aplicacao_descricao = "Formulario de permissoes de aplicacoes por perfil.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Perfil x Aplicacoes', [
    ['label' => 'Voltar', 'href' => 'perfil_aplicacoes_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$perfilId = (int) ($_GET['perfil_id'] ?? 0);
?>
<section class="card card-slim grid-shell permission-manager">
    <div class="card-header permission-toolbar">
        <div class="permission-filter">
            <label class="form-label mb-1" for="perfil_id">Perfil</label>
            <select class="form-select js-remote-select" id="perfil_id" data-type="perfis"></select>
        </div>
    </div>
    <div class="card-body">
        <div id="perfil-apps-empty" class="permission-empty">
            Informe o perfil para carregar as aplicacoes.
        </div>
        <div id="perfil-apps-accordion" class="accordion permission-accordion d-none"></div>
    </div>
    <div class="card-footer bg-white d-flex justify-content-end">
        <button class="btn btn-orange btn-save" id="btn-salvar-perfil-apps" type="button" disabled>Salvar permissoes</button>
    </div>
</section>
<script>
window.perfilAplicacoesConfig = {
    api: '../../api/seguranca/perfil_aplicacoes.php',
    perfilId: <?= $perfilId ?>
};
</script>
<?php render_footer(); ?>
