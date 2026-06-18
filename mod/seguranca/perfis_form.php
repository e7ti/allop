<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "perfis_form.php";
$aplicacao_descricao = "Insere e edita perfis de usuario.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
$id = (int) ($_GET['id'] ?? 0);
$return = (string) ($_GET['return'] ?? '');
$voltarUrl = $return === 'perfil_aplicacoes' ? 'perfil_aplicacoes_lista.php' : 'perfis_lista.php';
render_header('Perfil', [
    ['label' => 'Voltar', 'href' => $voltarUrl, 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<form id="entity-form" class="card card-slim form-section" data-entity="perfis" data-id="<?= $id ?>">
    <div class="card-body row g-3">
        <input type="hidden" name="id" value="<?= $id ?>">
        <div class="col-12 col-md-6"><label class="form-label">Nome</label><input class="form-control" name="nome" required></div>
    </div>
    <div class="card-footer bg-white d-flex gap-2 justify-content-end">
        <button class="btn btn-orange btn-save" type="submit">Salvar</button>
    </div>
</form>
<?php render_footer(); ?>

