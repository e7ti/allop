<?php
/*
    Autor: Claudio Barto
    Data : 18/06/2026
*/
$aplicacao_nome = "cp_compras_form.php";
$aplicacao_descricao = "Insere e edita pedidos de compra, itens, tamanhos, cores e rateios.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();
render_header('Pedido de Compra', [
    ['label' => 'Voltar', 'href' => 'cp_compras_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$id = (int) ($_GET['id'] ?? 0);
?>
<form id="cp-compras-form" class="form-section cp-compras-form-wide" data-id="<?= $id ?>" novalidate>
    <input type="hidden" name="id" value="<?= $id ?>">

    <div class="cp-compras-workflow-actions d-flex flex-wrap gap-2 justify-content-center mb-3">
        <?php if ($id > 0): ?>
            <a class="btn btn-outline-secondary btn-print" href="../../api/compras/cp_compras_pdf.php?id=<?= $id ?>" target="_blank" rel="noopener">Imprimir PDF</a>
        <?php endif; ?>
        <button class="btn btn-outline-secondary btn-send-proposal" id="btn-cp-enviar-proposta" type="button">Enviar Proposta</button>
        <button class="btn btn-outline-success btn-approve d-none" id="btn-cp-aprovar" type="button">Aprovar</button>
        <button class="btn btn-outline-danger btn-reject d-none" id="btn-cp-recusar" type="button">Recusar</button>
    </div>

    <section class="card card-slim mb-3">
        <div class="card-header"><strong>Pedido</strong></div>
        <div class="card-body row g-3">
            <div class="col-12 col-md-2"><label class="form-label">Código</label><input class="form-control" name="ID" type="number" readonly></div>
            <div class="col-12 col-md-3"><label class="form-label">CD</label><select class="form-select js-cp-compra-select" name="cd_id" data-type="empresas_cd" required></select></div>
            <div class="col-12 col-md-3"><label class="form-label">Empresa</label><select class="form-select js-cp-compra-select" name="empresa_id" data-type="empresas" required></select></div>
            <div class="col-12 col-md-4"><label class="form-label">Fornecedor</label><select class="form-select js-cp-compra-select" name="Fornecedor_id" data-type="fornecedores" required></select></div>
            <div class="col-12 col-md-2"><label class="form-label">Data Pedido</label><input class="form-control" name="DataPedido" type="date" required></div>
            <div class="col-12 col-md-2"><label class="form-label">Markup Franqueadora</label><div class="input-group cp-money-input-group"><span class="input-group-text">R$</span><input class="form-control js-money cp-header-money-field text-end" name="MarkupFranqueadora" type="text" inputmode="numeric" autocomplete="off" value="0,00"></div></div>
            <div class="col-12 col-md-2"><label class="form-label">Markup Franquia</label><input class="form-control js-money cp-header-money-field text-end" name="MarkupFranquia" type="text" inputmode="numeric" autocomplete="off" value="0,00"></div>
            <div class="col-12 col-md-2"><label class="form-label">Markup Total</label><input class="form-control js-money cp-header-money-field text-end" name="MarkupTotal" type="text" inputmode="numeric" autocomplete="off" value="0,00" readonly></div>
            <div class="col-12 col-md-2"><label class="form-label">Valor Total</label><div class="input-group cp-money-input-group"><span class="input-group-text">R$</span><input class="form-control js-money cp-header-money-field text-end" name="ValorTotalPedido" type="text" inputmode="numeric" autocomplete="off" value="0,00" readonly></div></div>
            <input type="hidden" name="Sts" value="Aberto">
            <input type="hidden" name="Publicado" value="0">
            <input type="hidden" name="Localizacao" value="KidStok">
            <div class="col-12 col-md-2"><label class="form-label">Status</label><input class="form-control" name="Sts_display" value="Aberto" readonly></div>
            <div class="col-12 col-md-2"><label class="form-label">Publicado</label><input class="form-control" name="Publicado_display" value="Não Publicado" readonly></div>
            <div class="col-12 col-md-2"><label class="form-label">Localização</label><input class="form-control" name="Localizacao_display" value="KidStok" readonly></div>
            <div class="col-12 col-md-8 d-none" id="cp-sts-motivo-group"><label class="form-label">Motivo/Observação</label><input class="form-control" name="StsMotivo" maxlength="500"></div>
        </div>
    </section>
    <section class="card card-slim mb-3">
        <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
            <strong>Itens</strong>
            <button class="btn btn-orange btn-new" id="btn-add-cp-item" type="button">Novo item</button>
        </div>
        <div class="card-body">
            <div class="accordion cp-compras-itens-accordion" id="cp-compras-itens"></div>
        </div>
    </section>

    <section class="card card-slim mb-3">
        <div class="card-footer bg-white d-flex flex-wrap gap-2 justify-content-end">
            <button class="btn btn-orange btn-save btn-save-main" type="submit">Salvar</button>
        </div>
    </section>
</form>

<div class="modal fade" id="cp-rateio-modal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h5 class="modal-title">Rateio de Quantidades</h5>
                    <div class="text-muted small">Informe a quantidade do tamanho e o percentual de cada cor.</div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
            </div>
            <div class="modal-body">
                <div id="cp-rateio-alert" class="alert alert-warning d-none"></div>
                <div class="row g-3 mb-3">
                    <div class="col-12 col-md-4">
                        <label class="form-label">Tamanho</label>
                        <input class="form-control" id="cp-rateio-tamanho" readonly>
                    </div>
                    <div class="col-12 col-md-4">
                        <label class="form-label">Quantidade total</label>
                        <input class="form-control text-end" id="cp-rateio-qtde-total" type="number" min="0" step="1" inputmode="numeric">
                    </div>
                    <div class="col-12 col-md-4">
                        <label class="form-label">Total dos percentuais</label>
                        <input class="form-control fw-bold text-end" id="cp-rateio-total-percentual" readonly>
                    </div>
                </div>
                <div id="cp-rateio-content"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary btn-back" data-bs-dismiss="modal">Voltar</button>
                <button type="button" class="btn btn-orange btn-save" id="btn-aplicar-cp-rateio">Aplicar rateio</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="cp-fotos-modal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h5 class="modal-title">Fotos do Item</h5>
                    <div class="text-muted small">Referência <span id="cp-foto-referencia"></span> - <span id="cp-foto-count">0 fotos</span></div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
            </div>
            <div class="modal-body">
                <div id="cp-foto-upload-block" class="mb-3">
                    <label class="form-label">Inserir fotos</label>
                    <input class="form-control" id="cp-foto-input" type="file" accept="image/*" multiple>
                </div>
                <div id="cp-fotos-list" class="cp-fotos-grid"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary btn-back" data-bs-dismiss="modal">Voltar</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="cp-foto-preview-modal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content cp-foto-preview-modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="cp-foto-preview-title">Foto</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
            </div>
            <div class="modal-body">
                <img id="cp-foto-preview-img" class="cp-foto-preview-img" src="" alt="Foto ampliada">
            </div>
        </div>
    </div>
</div>

<script>
window.cpComprasFormConfig = {
    api: '../../api/compras/cp_compras.php'
};
</script>
<?php render_footer(); ?>
