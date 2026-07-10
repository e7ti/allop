<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "usuarios_form.php";
$aplicacao_descricao = "Insere e edita usuários do sistema.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Usuário', [
    ['label' => 'Voltar', 'href' => 'usuarios_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$id = (int) ($_GET['id'] ?? 0);
?>
<form id="entity-form" class="card card-slim form-section" data-entity="usuarios" data-id="<?= $id ?>">
    <div class="card-body row g-3">
        <input type="hidden" name="id" value="<?= $id ?>">
        <div class="col-12 col-md-6"><label class="form-label">Nome</label><input class="form-control" name="nome" required></div>
        <div class="col-12 col-md-6"><label class="form-label">Login</label><input class="form-control" name="login" required></div>
        <div class="col-12 col-md-6"><label class="form-label">Senha</label><input class="form-control" name="senha" type="password" autocomplete="new-password"></div>
        <div class="col-12 col-md-6"><label class="form-label">Perfil</label><select class="form-select js-remote-select" name="perfil_id" data-type="perfis" required></select></div>
        <div class="col-12 col-md-6"><label class="form-label">Ativo</label><select class="form-select" name="ativo"><option value="1">Sim</option><option value="0">Não</option></select></div>
    </div>
    <div class="card-footer bg-white d-flex gap-2 justify-content-end">
        <button class="btn btn-orange btn-save" type="submit">Salvar</button>
    </div>
</form>
<?php render_footer(); ?>
