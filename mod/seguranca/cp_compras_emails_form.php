<?php
/*
    Autor: Claudio Barto
    Data : 06/08/2026
*/
$aplicacao_nome = "cp_compras_emails_form.php";
$aplicacao_descricao = "Insere e edita e-mails de compras.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('E-mail de Compras', [
    ['label' => 'Voltar', 'href' => 'cp_compras_emails_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$id = (int) ($_GET['id'] ?? 0);
?>
<form id="entity-form" class="card card-slim form-section" data-entity="cp_compras_emails" data-id="<?= $id ?>">
    <div class="card-body row g-3">
        <input type="hidden" name="id" value="<?= $id ?>">
        <div class="col-12 col-md-6"><label class="form-label">Conta de E-mail</label><select class="form-select js-remote-select" name="config_email_id" data-type="config_email" required></select></div>
        <div class="col-12 col-md-6"><label class="form-label">Nome</label><input class="form-control" name="Nome" maxlength="60" required></div>
        <div class="col-12 col-md-6"><label class="form-label">E-mail</label><input class="form-control" name="email" type="email" maxlength="120" required></div>
        <div class="col-12 col-md-3"><label class="form-label">Status</label><select class="form-select" name="status" required><option value="1">Ativo</option><option value="0">Inativo</option></select></div>
    </div>
    <div class="card-footer bg-white d-flex gap-2 justify-content-end">
        <button class="btn btn-orange btn-save" type="submit">Salvar</button>
    </div>
</form>
<?php render_footer(); ?>
