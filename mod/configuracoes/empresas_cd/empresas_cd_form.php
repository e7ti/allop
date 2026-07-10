<?php
/*
    Autor: Claudio Barto
    Data : 02/06/2026
*/
$aplicacao_nome = "empresas_cd_form.php";
$aplicacao_descricao = "Insere e edita empresas CD.";

require_once __DIR__ . '/../../../includes/layout.php';
require_login();
render_header('Empresa CD', [
    ['label' => 'Voltar', 'href' => 'empresas_cd_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$id = (int) ($_GET['id'] ?? 0);
?>
<form id="empresas-cd-form" class="card card-slim form-section" data-id="<?= $id ?>">
    <div class="card-body row g-3">
        <input type="hidden" name="id" value="<?= $id ?>">
        <div class="col-12 col-md-3"><label class="form-label">Código</label><input class="form-control" name="Codigo" type="number"></div>
        <div class="col-12 col-md-6"><label class="form-label">Nome CD</label><input class="form-control" name="NomeCD" maxlength="50" required></div>
        <div class="col-12 col-md-3"><label class="form-label">Status</label><select class="form-select" name="Status" required><option value="Ativo">Ativo</option><option value="Inativo">Inativo</option></select></div>
    </div>
    <div class="card-footer bg-white d-flex gap-2 justify-content-end">
        <button class="btn btn-orange btn-save" type="submit">Salvar</button>
    </div>
</form>
<script>
window.empresasCdFormConfig = {
    api: '../../../api/configuracoes/empresas_cd.php'
};
</script>
<?php render_footer(); ?>
