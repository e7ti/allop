<?php
/*
    Autor: Claudio Barto
    Data : 06/08/2026
*/
$aplicacao_nome = "cp_compras_emails_lista.php";
$aplicacao_descricao = "Lista e-mails de compras.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('E-mails de Compras', [
    ['label' => 'Voltar', 'href' => '../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter">
            <div class="filter-inline">
                <select id="filtro" class="form-select js-select2" data-entity="cp_compras_emails"><option value="">Pesquisar e-mail</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="cp_compras_emails_form.php">Novo</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead><tr><th>Conta</th><th>Nome</th><th>E-mail</th><th>Status</th><th class="text-end">Ações</th></tr></thead>
            <tbody id="grid"></tbody>
        </table>
    </div>
</section>
<script>
window.gridConfig = { entity: 'cp_compras_emails', form: 'cp_compras_emails_form.php', columns: ['config_email_id_text', 'Nome', 'email', 'status_text'], labels: ['Conta', 'Nome', 'E-mail', 'Status'] };
</script>
<?php render_footer(); ?>
