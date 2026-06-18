<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "usuarios_permissoes_form.php";
$aplicacao_descricao = "Insere e edita permissoes de aplicacoes por usuario.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Usuario x Aplicacoes', [
    ['label' => 'Voltar', 'href' => 'usuarios_permissoes_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$id = (int) ($_GET['id'] ?? 0);
$checks = [
    'visualizar' => 'Visualizar',
    'inserir' => 'Inserir',
    'edtiar' => 'Editar',
    'excluir' => 'Excluir',
    'imprirmir' => 'Imprimir',
    'exportar' => 'Exportar',
    'processar' => 'Processar',
];
?>
<form id="entity-form" class="form-section" data-entity="usuarios_permissoes" data-id="<?= $id ?>">
    <input type="hidden" name="id" value="<?= $id ?>">
    <div class="row g-3">
        <div class="col-12 col-lg-6">
            <section class="card card-slim h-100">
                <div class="card-header bg-white fw-bold">Usuario e aplicacao</div>
                <div class="card-body row g-3">
                    <div class="col-12">
                        <label class="form-label">Usuario</label>
                        <select class="form-select js-remote-select" name="usuario_id" data-type="usuarios" required></select>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Aplicacao</label>
                        <select class="form-select js-remote-select" name="aplicacao_id" data-type="aplicacoes" required></select>
                    </div>
                </div>
            </section>
        </div>
        <div class="col-12 col-lg-6">
            <section class="card card-slim h-100">
                <div class="card-header bg-white fw-bold">Permissoes</div>
                <div class="card-body row g-3">
                    <?php foreach ($checks as $name => $label): ?>
                        <div class="col-6 col-md-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="<?= h($name) ?>" value="1" id="<?= h($name) ?>">
                                <label class="form-check-label" for="<?= h($name) ?>"><?= h($label) ?></label>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </section>
        </div>
    </div>
    <div class="card-footer bg-white d-flex gap-2 justify-content-end">
        <button class="btn btn-orange btn-save" type="submit">Salvar</button>
    </div>
</form>
<?php render_footer(); ?>
