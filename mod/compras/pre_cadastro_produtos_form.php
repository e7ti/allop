<?php
/*
    Autor: Claudio Barto
    Data : 16/09/2026
*/
$aplicacao_nome = "pre_cadastro_produtos_form.php";
$aplicacao_descricao = "Cria e grava pre-cadastro de produtos a partir de pedidos de compra.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();
$preCadastroId = (int) ($_GET['id'] ?? 0);
render_header($preCadastroId > 0 ? 'Editar Pre Cadastro Produtos' : 'Gerar Pre Cadastro Produtos', [
    ['label' => 'Voltar', 'href' => 'pre_cadastro_produtos_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim mb-3<?= $preCadastroId > 0 ? ' d-none' : '' ?>">
    <div class="card-header"><strong>Pedido de compra</strong></div>
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <div class="col-12 col-lg-8">
                <label class="form-label">Pedido</label>
                <select id="pre-cadastro-pedido" class="form-select"></select>
            </div>
            <div class="col-12 col-lg-4 d-flex gap-2">
                <button class="btn btn-orange btn-sync" id="btn-pre-cadastro-preview" type="button">Gerar dados</button>
            </div>
        </div>
    </div>
</section>

<section class="card card-slim mb-3 d-none" id="pre-cadastro-resumo-card">
    <div class="card-header"><strong>Resumo</strong></div>
    <div class="card-body">
        <div id="pre-cadastro-pedido-resumo" class="row g-3"></div>
        <div id="pre-cadastro-warnings" class="alert alert-warning mt-3 d-none"></div>
    </div>
</section>

<div id="pre-cadastro-groups"></div>
<div class="d-flex justify-content-end mt-3 mb-3">
    <button class="btn btn-save-main btn-save" id="btn-pre-cadastro-save" type="button" disabled>
        <?= $preCadastroId > 0 ? 'Salvar alteracoes' : 'Gravar pre-cadastro' ?>
    </button>
</div>

<script>
window.preCadastroProdutosConfig = {
    api: '../../api/compras/pre_cadastro_produtos.php',
    preCadastroId: <?= $preCadastroId ?>
};
</script>
<?php render_footer(); ?>
