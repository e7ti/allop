<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "aplicacoes_form.php";
$aplicacao_descricao = "Insere e edita aplicações do sistema.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Aplicação', [
    ['label' => 'Voltar', 'href' => 'aplicacoes_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$id = (int) ($_GET['id'] ?? 0);
?>
<form id="entity-form" class="card card-slim form-section" data-entity="aplicacoes" data-id="<?= $id ?>">
    <div class="card-body row g-3">
        <input type="hidden" name="id" value="<?= $id ?>">
        <div class="col-12 col-md-6"><label class="form-label">Nome</label><input class="form-control" name="nome" required></div>
        <div class="col-12 col-md-6"><label class="form-label">Rota</label><input class="form-control" name="rota" required></div>
        <div class="col-12 col-md-6"><label class="form-label">Menu</label><select class="form-select js-remote-select" name="menu_id" data-type="menus" required></select></div>
        <div class="col-12 col-md-3"><label class="form-label">Ordem</label><input class="form-control" name="ordem" type="number" value="10"></div>
    </div>
    <div class="card-footer bg-white d-flex gap-2 justify-content-end">
        <button class="btn btn-orange btn-save" type="submit">Salvar</button>
    </div>
</form>
<?php render_footer(); ?>

