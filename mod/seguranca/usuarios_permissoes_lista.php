<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "usuarios_permissoes_lista.php";
$aplicacao_descricao = "Lista permissoes de aplicacoes por usuario.";



require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Usuario x Aplicacoes', [
    ['label' => 'Voltar', 'href' => '../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div class="grid-filter">
            <div class="filter-inline">
                <select id="filtro" class="form-select js-select2" data-entity="usuarios_permissoes"><option value="">Pesquisar permissao</option></select>
                <button class="btn btn-orange btn-filter" id="btn-filtrar" type="button">Filtrar</button>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-orange btn-new" href="usuarios_permissoes_form.php">Nova</a>
        </div>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-custom align-middle">
            <thead>
                <tr>
                    <th>Usuario</th>
                    <th>Aplicacao</th>
                    <th>Visualizar</th>
                    <th>Inserir</th>
                    <th>Editar</th>
                    <th>Excluir</th>
                    <th>Imprimir</th>
                    <th>Exportar</th>
                    <th>Processar</th>
                    <th class="text-end">Acoes</th>
                </tr>
            </thead>
            <tbody id="grid"></tbody>
        </table>
    </div>
</section>
<script>
window.gridConfig = {
    entity: 'usuarios_permissoes',
    form: 'usuarios_permissoes_form.php',
    columns: ['usuario_nome', 'aplicacao_nome', 'visualizar', 'inserir', 'edtiar', 'excluir', 'imprirmir', 'exportar', 'processar'],
    labels: ['Usuario', 'Aplicacao', 'Visualizar', 'Inserir', 'Editar', 'Excluir', 'Imprimir', 'Exportar', 'Processar']
};
</script>
<?php render_footer(); ?>
