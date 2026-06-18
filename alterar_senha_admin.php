<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "alterar_senha_admin.php";
$aplicacao_descricao = "Aplicacao raiz para alterar a senha do usuario admin.";

require_once __DIR__ . '/config/app.php';
?>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Alterar senha do admin | <?= h(APP_NAME) ?></title>
    <link rel="stylesheet" href="<?= app_url('assets/vendor/bootstrap/css/bootstrap.min.css') ?>">
    <link rel="stylesheet" href="<?= app_url('assets/css/style.css') ?>">
</head>
<body class="login-page">
<div class="login-wrap">
    <div class="login-card card-slim">
        <div class="login-brand">
            <span class="brand-mark">A</span>
            <div>
                <h1>Senha admin</h1>
                <p>Atualize a senha do usuario administrador</p>
            </div>
        </div>

        <div id="senha-alert" class="alert d-none"></div>

        <form id="senha-form">
            <div class="mb-3">
                <label class="form-label" for="nova_senha">Nova senha</label>
                <input class="form-control" id="nova_senha" name="nova_senha" type="password" autocomplete="new-password" required minlength="6">
            </div>
            <div class="mb-3">
                <label class="form-label" for="confirmar_senha">Confirmar senha</label>
                <input class="form-control" id="confirmar_senha" name="confirmar_senha" type="password" autocomplete="new-password" required minlength="6">
            </div>
            <button class="btn btn-orange btn-key w-100" type="submit">Alterar senha</button>
            <a class="btn btn-link btn-back w-100 mt-2" href="<?= app_url('login.php') ?>">Voltar para login</a>
        </form>
    </div>
</div>
<script src="<?= app_url('assets/vendor/jquery/jquery.min.js') ?>"></script>
<script>
$('#senha-form').on('submit', function (event) {
    event.preventDefault();
    const $alert = $('#senha-alert');
    $alert.addClass('d-none').removeClass('alert-success alert-danger');

    $.post('<?= app_url('api/seguranca/admin_senha.php') ?>', $(this).serialize(), function (response) {
        $alert.removeClass('d-none').addClass('alert-success').text(response.message || 'Senha alterada com sucesso.');
        $('#senha-form')[0].reset();
    }, 'json').fail(function (xhr) {
        $alert.removeClass('d-none').addClass('alert-danger').text(xhr.responseJSON?.message || 'Nao foi possivel alterar a senha.');
    });
});
</script>
</body>
</html>
