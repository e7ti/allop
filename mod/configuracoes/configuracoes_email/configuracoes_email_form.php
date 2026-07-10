<?php
/*
    Autor: Claudio Barto
    Data : 02/06/2026
*/
$aplicacao_nome = "configuracoes_email_form.php";
$aplicacao_descricao = "Insere e edita configurações de e-mail.";

require_once __DIR__ . '/../../../includes/layout.php';
require_login();
render_header('Configuração de E-mail', [
    ['label' => 'Voltar', 'href' => 'configuracoes_email_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$id = (int) ($_GET['id'] ?? 0);
?>
<form id="configuracoes-email-form" class="card card-slim form-section" data-id="<?= $id ?>">
    <div class="card-body row g-3">
        <input type="hidden" name="id" value="<?= $id ?>">
        <div class="col-12 col-md-3"><label class="form-label">CD</label><select class="form-select js-config-email-select" name="cd_id" data-type="empresas_cd" required></select></div>
        <div class="col-12 col-md-3"><label class="form-label">Empresa</label><select class="form-select js-config-email-select" name="empresa_id" data-type="empresas" required></select></div>
        <div class="col-12 col-md-6"><label class="form-label">Nome da Conta</label><input class="form-control" name="NomeConta" maxlength="40" required></div>
        <div class="col-12 col-md-6"><label class="form-label">Servidor</label><input class="form-control" name="Servidor" maxlength="120" required></div>
        <div class="col-12 col-md-3"><label class="form-label">Porta</label><input class="form-control" name="Porta" maxlength="10" required></div>
        <div class="col-12 col-md-3"><label class="form-label">Habilitado</label><select class="form-select" name="Habilitado"><option value="1">Sim</option><option value="0">Não</option></select></div>
        <div class="col-12 col-md-3"><label class="form-label">Autenticado</label><select class="form-select" name="ModoAutenticado"><option value="S">Sim</option><option value="N">Não</option></select></div>
        <div class="col-12 col-md-3"><label class="form-label">SSL</label><select class="form-select" name="ModoSSL"><option value="S">Sim</option><option value="N">Não</option></select></div>
        <div class="col-12 col-md-6"><label class="form-label">E-mail</label><input class="form-control" name="Email" type="email" maxlength="120" required></div>
        <div class="col-12 col-md-6"><label class="form-label">Senha</label><input class="form-control" name="Senha" type="password" maxlength="120" required></div>
        <div class="col-12 col-md-3"><label class="form-label">Status</label><select class="form-select" name="Status" required><option value="Ativo">Ativo</option><option value="Inativo">Inativo</option></select></div>
    </div>
    <div class="card-footer bg-white d-flex gap-2 justify-content-end">
        <button class="btn btn-orange btn-save" type="submit">Salvar</button>
    </div>
</form>
<script>
window.configuracoesEmailFormConfig = {
    api: '../../../api/configuracoes/configuracoes_email.php',
    optionsApi: '../../../api/seguranca/options.php'
};
</script>
<?php render_footer(); ?>
