<?php
/*
    Autor: Claudio Barto
    Data : 16/09/2026
*/
$aplicacao_nome = "pre_cadastro_produtos_lista.php";
$aplicacao_descricao = "Gera pre-cadastro de produtos a partir de pedidos de compra.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Pré Cadastro Produtos', [
    ['label' => 'Voltar', 'href' => '../../dashboard.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim mb-3">
    <div class="card-header"><strong>Pedido de compra</strong></div>
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <div class="col-12 col-lg-8">
                <label class="form-label">Pedido</label>
                <select id="pre-cadastro-pedido" class="form-select"></select>
            </div>
            <div class="col-12 col-lg-4 d-flex gap-2">
                <button class="btn btn-orange btn-sync" id="btn-pre-cadastro-preview" type="button">Gerar dados</button>
                <button class="btn btn-success btn-save" id="btn-pre-cadastro-save" type="button" disabled>Gravar pré-cadastro</button>
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

<script>
window.preCadastroProdutosConfig = {
    api: '../../api/compras/pre_cadastro_produtos.php'
};
</script>
<?php render_footer(); ?>
