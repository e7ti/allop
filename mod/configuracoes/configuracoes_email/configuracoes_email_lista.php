<?php
/*
    Autor: Claudio Barto
    Data : 02/06/2026
*/
$aplicacao_nome = "configuracoes_email_lista.php";
$aplicacao_descricao = "Lista configuracoes de e-mail.";

require_once __DIR__ . '/../../../includes/layout.php';
require_login();
render_header('Configuracoes de E-mail', [
    ['label' => 'Voltar', 'href' => '../../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter">
            <div class="filter-inline">
                <select id="filtro-email" class="form-select"><option value="">Pesquisar configuracao de e-mail</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar-email" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="configuracoes_email_form.php">Nova</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead>
                <tr>
                    <th>Conta</th>
                    <th>Servidor</th>
                    <th>Porta</th>
                    <th>E-mail</th>
                    <th>Habilitado</th>
                    <th>Status</th>
                    <th class="text-end">Acoes</th>
                </tr>
            </thead>
            <tbody id="configuracoes-email-grid"></tbody>
        </table>
    </div>
</section>
<script>
window.configuracoesEmailListaConfig = {
    api: '../../../api/configuracoes/configuracoes_email.php',
    form: 'configuracoes_email_form.php'
};
</script>
<?php render_footer(); ?>
