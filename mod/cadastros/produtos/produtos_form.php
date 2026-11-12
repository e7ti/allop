<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'produtos_form.php';
$aplicacao_descricao = 'Consulta e manutenção dos cadastros auxiliares de produtos.';
require_once __DIR__ . '/../../../includes/layout.php';
require_once __DIR__ . '/../../../includes/produtos.php';
require_login();
$entity = (string) ($_GET['cadastro'] ?? 'produtos');
$config = produtos_config($entity);
if (!$config) {
    http_response_code(404);
    exit('Cadastro inválido.');
}
if (produtos_associacao_config($entity)) {
    header('Location: ' . app_url(produtos_rota($entity)));
    exit;
}
$id = (string) ($_GET['id'] ?? '');
$permissions = produtos_permissoes($entity);
$readonly = !$config['editable'] || !empty($_GET['consulta']) || empty($permissions[$id !== '' ? 'editar' : 'inserir']);
if ($id === '' && !$config['can_create']) {
    $readonly = true;
}
if (empty($permissions['visualizar']) || ($id === '' && $readonly)) {
    http_response_code(403);
    render_header('Acesso não permitido');
    echo '<div class="alert alert-warning">Operação não permitida para este cadastro.</div>';
    render_footer();
    exit;
}
render_header($config['title'], [
    ['label' => 'Voltar', 'href' => app_url(produtos_rota($entity)), 'class' => 'btn btn-outline-secondary btn-back'],
]);
$aviso = produtos_aviso($entity);
?>
<?php if ($aviso !== ''): ?><div class="alert alert-info"><?= h($aviso) ?></div><?php endif; ?>
<section class="card card-slim" id="produtos-page">
    <div class="card-body">
        <form id="produtos-form">
            <fieldset id="produtos-fields" <?= $id !== '' || $readonly ? 'disabled' : '' ?>>
                <div class="row g-3">
                    <?php foreach (($readonly ? $config['fields'] : produtos_campos_form($config)) as $name => $field): ?>
                        <?php
                        $numeric = in_array($field['type'], ['int', 'bigint', 'tinyint', 'smallint', 'double', 'decimal', 'float'], true);
                        $decimal = in_array($field['type'], ['double', 'decimal', 'float'], true);
                        $options = in_array($name, ['Status', 'Sts'], true) ? ['Ativo' => 'Ativo', 'Inativo' => 'Inativo'] : [];
                        if (in_array($name, ['ProducaoProria', 'UpperCase', 'PrecoAtacadoMetadeVarejo'], true)) {
                            $options = ['N' => 'Não', 'S' => 'Sim'];
                        } elseif ($name === 'Externo') {
                            $options = ['0' => 'Não', '1' => 'Sim'];
                        }
                        $relation = isset($config['relations'][$name]);
                        $multiple = !empty($config['relations'][$name]['multiple']);
                        $derived = $entity === 'produtos' && $name === 'Referencia';
                        if (in_array($name, ['PrecoCheio', 'SetorLaranja', 'Encomenda'], true)) {
                            $options = ['N' => 'Não', 'S' => 'Sim'];
                        }
                        ?>
                        <div class="col-md-6 col-xl-4">
                            <label for="produto-<?= h($name) ?>" class="form-label"><?= h(produtos_label($name)) ?></label>
                            <?php if (($options || $relation) && !$readonly): ?>
                                <select class="form-select <?= $relation ? 'produtos-select' : '' ?>" id="produto-<?= h($name) ?>" name="<?= h($name) ?><?= $multiple ? '[]' : '' ?>" <?= $multiple ? 'multiple' : '' ?>
                                    data-field="<?= h($name) ?>" <?= !$field['nullable'] && $field['default'] !== '' ? 'required' : '' ?> <?= $id !== '' && $name === $config['key'] ? 'disabled' : '' ?>>
                                    <option value=""></option>
                                    <?php foreach ($options as $value => $label): ?>
                                        <option value="<?= h((string) $value) ?>" <?= (string) $field['default'] === (string) $value ? 'selected' : '' ?>><?= h($label) ?></option>
                                    <?php endforeach; ?>
                                </select>
                            <?php else: ?>
                                <input class="form-control<?= $decimal ? ' allop-decimal' : '' ?>" id="produto-<?= h($name) ?>" name="<?= h($name) ?>"
                                    type="<?= $readonly || $decimal ? 'text' : ($numeric ? 'number' : ($field['type'] === 'date' ? 'date' : 'text')) ?>" <?= $decimal ? 'inputmode="numeric" data-decimal-places="' . (int) (explode(',', (string) $field['size'])[1] ?? 2) . '"' : ($numeric ? 'step="1" min="0"' : '') ?>
                                    <?= !$numeric && $field['size'] ? 'maxlength="' . (int) $field['size'] . '"' : '' ?>
                                    value="<?= h((string) ($field['default'] ?? '')) ?>" <?= !$readonly && !$derived && !($entity === 'produtos' && in_array($name, ['Descricao', 'DescricaoComplementar', 'CFOP_ProducaoProria'], true)) && !$field['nullable'] && $field['default'] !== '' ? 'required' : '' ?>
                                    <?= $readonly || $derived || ($id !== '' && $name === $config['key']) ? 'readonly' : '' ?>>
                            <?php endif; ?>
                        </div>
                    <?php endforeach; ?>
                </div>
            </fieldset>
            <?php if (!$readonly): ?>
                <div class="mt-4 border-top pt-3">
                    <button class="btn btn-orange btn-save" id="produtos-salvar" type="submit" <?= $id !== '' ? 'disabled' : '' ?>>Salvar</button>
                </div>
            <?php endif; ?>
        </form>
    </div>
</section>
<section class="card card-slim mt-3 d-none" id="produtos-details">
    <div class="card-header"><?= $entity === 'precos_lote' ? 'Itens do lote' : 'Grade do produto' ?></div>
    <div class="card-body table-responsive" id="produtos-details-grid"></div>
</section>
<?php if ($entity === 'fotos'): ?>
    <section class="card card-slim mt-3"><div class="card-header">Fotos (até 5 por produto)</div><div class="card-body">
        <div class="d-flex flex-wrap gap-3" id="produtos-fotos"></div>
        <?php if (!empty($permissions['inserir'])): ?>
            <form id="produtos-upload" class="d-flex flex-wrap gap-2 mt-3"><input type="file" name="foto" accept="image/jpeg,image/png,image/webp,image/gif,image/bmp" class="form-control" required><button class="btn btn-orange" type="submit">Enviar foto</button></form>
        <?php endif; ?>
    </div></section>
<?php endif; ?>
<?php if ($entity === 'precos_lote' && !empty($permissions['editar'])): ?>
    <section class="card card-slim mt-3" id="produtos-lote-acoes"><div class="card-header">Itens e aplicação do lote</div><div class="card-body">
        <p class="text-muted">Salve o lote para incluir itens. Uma referência master inclui todos os tamanhos e cores consolidados.</p>
        <form id="produtos-lote-item" class="row g-3 align-items-end">
            <input type="hidden" name="item_id">
            <div class="col-md-4"><label class="form-label" for="lote-referencia">Referência master ou completa</label><input class="form-control" id="lote-referencia" name="referencia" minlength="8" maxlength="12" required></div>
            <div class="col-md-3"><label class="form-label" for="lote-varejo">Varejo novo</label><input class="form-control allop-decimal" id="lote-varejo" name="varejo" type="text" inputmode="numeric" data-decimal-places="2" required></div>
            <div class="col-md-3"><label class="form-label" for="lote-atacado">Atacado novo</label><input class="form-control allop-decimal" id="lote-atacado" name="atacado" type="text" inputmode="numeric" data-decimal-places="2"><small class="text-muted">Vazio aplica o parâmetro de metade do varejo.</small></div>
            <div class="col-md-2"><button class="btn btn-orange" type="submit">Salvar item</button></div>
        </form>
        <?php if (!empty($permissions['processar'])): ?>
            <div class="d-flex flex-wrap gap-2 mt-3"><button class="btn btn-orange" id="produtos-lote-aplicar" type="button" disabled>Aplicar lote</button><button class="btn btn-outline-secondary" id="produtos-lote-retornar" type="button" disabled>Restaurar preços anteriores</button></div>
        <?php endif; ?>
    </div></section>
<?php endif; ?>
<script>
window.produtosConfig = <?= json_encode([
    'entity' => $entity, 'api' => app_url('api/cadastros/produtos.php'), 'key' => $config['key'], 'id' => $id,
    'readonly' => $readonly, 'csrf' => produtos_csrf(),
    'canDeletePhoto' => !empty($permissions['excluir']), 'canProcess' => !empty($permissions['processar']),
    'processApi' => app_url('api/cadastros/produtos_processos.php'),
], JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT) ?>;
</script>
<?php render_footer(); ?>
