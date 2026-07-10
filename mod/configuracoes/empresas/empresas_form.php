<?php
/*
    Autor: Claudio Barto
    Data : 02/06/2026
*/
$aplicacao_nome = "empresas_form.php";
$aplicacao_descricao = "Insere e edita empresas.";

require_once __DIR__ . '/../../../includes/layout.php';
require_login();
render_header('Empresa', [
    ['label' => 'Voltar', 'href' => 'empresas_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
$id = (int) ($_GET['id'] ?? 0);
$ufs = ['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'];
?>
<form id="empresas-form" class="form-section empresas-form" data-id="<?= $id ?>" novalidate>
    <input type="hidden" name="id" value="<?= $id ?>">

    <section class="card card-slim mb-3">
        <div class="card-header"><strong>Identificação</strong></div>
        <div class="card-body row g-3">
            <div class="col-12 col-md-3"><label class="form-label">Código</label><input class="form-control" name="Codigo" type="number"></div>
            <div class="col-12 col-md-5"><label class="form-label">CD</label><select class="form-select js-empresa-select" name="EmpresaCD" data-type="empresas_cd" required></select></div>
            <div class="col-12 col-md-4"><label class="form-label">CNPJ</label><input class="form-control js-only-digits js-cnpj" name="CNPJ" maxlength="14" required></div>
            <div class="col-12 col-md-6"><label class="form-label">Nome</label><input class="form-control" name="Nome" maxlength="50" required></div>
            <div class="col-12 col-md-6"><label class="form-label">Fantasia</label><input class="form-control" name="Fantasia" maxlength="50" required></div>
            <div class="col-12 col-md-3"><label class="form-label">IE</label><input class="form-control js-only-digits" name="IE" maxlength="15"></div>
            <div class="col-12 col-md-3"><label class="form-label">CRT</label><select class="form-select" name="CRT"><option value="1">1</option><option value="2">2</option><option value="3" selected>3</option></select></div>
            <div class="col-12 col-md-3"><label class="form-label">Status</label><select class="form-select" name="Status" required><option value="Ativo">Ativo</option><option value="Inativo">Inativo</option></select></div>
        </div>
    </section>

    <section class="card card-slim mb-3">
        <div class="card-header"><strong>Endereço</strong></div>
        <div class="card-body row g-3">
            <div class="col-12 col-md-3"><label class="form-label">CEP</label><input class="form-control js-only-digits js-cep" name="CEP" maxlength="8"></div>
            <div class="col-12 col-md-3"><label class="form-label">Tipo Endereço</label><input class="form-control" name="TipoEndereco" maxlength="25"></div>
            <div class="col-12 col-md-6"><label class="form-label">Endereço</label><input class="form-control" name="Endereco" maxlength="60"></div>
            <div class="col-12 col-md-2"><label class="form-label">Número</label><input class="form-control" name="Numero" maxlength="10"></div>
            <div class="col-12 col-md-4"><label class="form-label">Complemento</label><input class="form-control" name="Complemento" maxlength="40"></div>
            <div class="col-12 col-md-4"><label class="form-label">Bairro</label><input class="form-control" name="Bairro" maxlength="50"></div>
            <div class="col-12 col-md-4"><label class="form-label">Cidade</label><input class="form-control" name="Cidade" maxlength="60"></div>
            <div class="col-12 col-md-2"><label class="form-label">UF</label><select class="form-select" name="UF"><option value="">Selecione</option><?php foreach ($ufs as $uf): ?><option value="<?= $uf ?>"><?= $uf ?></option><?php endforeach; ?></select></div>
            <div class="col-12 col-md-2"><label class="form-label">Código IBGE</label><input class="form-control js-only-digits" name="ibge" maxlength="7"></div>
        </div>
    </section>

    <section class="card card-slim mb-3">
        <div class="card-header"><strong>Contatos</strong></div>
        <div class="card-body row g-3">
            <div class="col-12 col-md-2"><label class="form-label">DDD Fone</label><input class="form-control js-only-digits js-ddd" name="FoneDDD" maxlength="2"></div>
            <div class="col-12 col-md-4"><label class="form-label">Telefone</label><input class="form-control js-only-digits" name="FoneNro" maxlength="10"></div>
            <div class="col-12 col-md-2"><label class="form-label">DDD Celular</label><input class="form-control js-only-digits js-ddd" name="CelularDDD" maxlength="2"></div>
            <div class="col-12 col-md-4"><label class="form-label">Celular</label><input class="form-control js-only-digits" name="CelularNro" maxlength="10"></div>
            <div class="col-12 col-md-5"><label class="form-label">Responsável</label><input class="form-control" name="Responsavel" maxlength="60"></div>
            <div class="col-12 col-md-7"><label class="form-label">Observações</label><input class="form-control" name="Observacoes" maxlength="250"></div>
        </div>
    </section>

    <section class="card card-slim mb-3">
        <div class="card-footer bg-white d-flex gap-2 justify-content-end">
            <button class="btn btn-orange btn-save" type="submit">Salvar</button>
        </div>
    </section>
</form>
<script>
window.empresasFormConfig = {
    api: '../../../api/configuracoes/empresas.php',
    optionsApi: '../../../api/seguranca/options.php'
};
</script>
<?php render_footer(); ?>
