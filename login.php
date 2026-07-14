<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "login.php";
$aplicacao_descricao = "Tela de acesso ao sistema.";



require_once __DIR__ . '/config/app.php';
?>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login | <?= h(APP_NAME) ?></title>
    <link rel="stylesheet" href="<?= app_url('assets/vendor/bootstrap/css/bootstrap.min.css') ?>">
    <link rel="stylesheet" href="<?= app_url('assets/css/style.css') ?>">
</head>
<body class="login-page">
<main class="login-wrap">
    <section class="login-shell">
        <div class="login-showcase">
            <img src="<?= app_url('assets/img/Allop.png') ?>" alt="Allop" class="login-logo-allop">
            <div>
                <h1>Allop</h1>
                <p>Gestao integrada para operacoes mais simples, rapidas e seguras.</p>
            </div>
        </div>
        <div class="login-card">
            <div class="login-brand-stacked">
                <img src="<?= app_url('assets/img/logo_kidstok.png') ?>" alt="Kidstok" class="login-logo">
                <p>Acesse o painel do sistema</p>
            </div>
            <div id="login-alert" class="alert alert-danger d-none"></div>
            <form id="login-form">
                <div class="mb-3">
                    <label class="form-label" for="login">Usuario</label>
                    <input class="form-control" id="login" name="login" autocomplete="username" required>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="senha">Senha</label>
                    <div class="login-password-wrap">
                        <input class="form-control" id="senha" name="senha" type="password" autocomplete="current-password" required>
                        <button type="button" class="login-toggle-password" id="toggle-senha" aria-label="Mostrar senha" aria-pressed="false"></button>
                    </div>
                </div>
                <button class="btn btn-orange btn-login w-100" type="submit">Entrar</button>
            </form>
        </div>
    </section>
</main>
<script src="<?= app_url('assets/vendor/jquery/jquery.min.js') ?>"></script>
<script>
$('#toggle-senha').on('click', function () {
    var $senha = $('#senha');
    var showing = $senha.attr('type') === 'text';
    $senha.attr('type', showing ? 'password' : 'text');
    $(this)
        .toggleClass('is-visible', !showing)
        .attr('aria-pressed', String(!showing))
        .attr('aria-label', showing ? 'Mostrar senha' : 'Ocultar senha');
});

$('#login-form').on('submit', function (event) {
    event.preventDefault();
    $.post('<?= app_url('api/seguranca/auth.php') ?>', $(this).serialize(), function (response) {
        window.location.href = response.redirect;
    }, 'json').fail(function (xhr) {
        $('#login-alert').removeClass('d-none').text(xhr.responseJSON?.message || 'Falha ao acessar.');
    });
});
</script>
</body>
</html>
