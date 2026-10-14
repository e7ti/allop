<?php
/*
    Autor: Claudio Barto
    Data : 23/09/2026
*/
$aplicacao_nome = "cp_depara_cor_form.php";
$aplicacao_descricao = "Mapeia cores da colecao do fornecedor com cores KidStok.";

require_once __DIR__ . '/../../includes/layout.php';
require_login();

$rows = [];
$erro = '';

try {
    $stmt = db()->query(
        "SELECT cores.cor_produto,
                d.codigo_ks,
                pc.Nome AS cor_ks_nome,
                COUNT(*) AS itens
           FROM (
                SELECT TRIM(cor_produto) AS cor_produto
                  FROM pf_colecao
                 WHERE cor_produto IS NOT NULL
                   AND TRIM(cor_produto) <> ''
           ) cores
           LEFT JOIN cp_depara_cor d
             ON CONVERT(d.cor_fornecedor USING utf8mb4) COLLATE utf8mb4_unicode_ci = cores.cor_produto
           LEFT JOIN produtos_cor pc ON pc.Codigo = d.codigo_ks
          GROUP BY cores.cor_produto, d.codigo_ks, pc.Nome
          ORDER BY cores.cor_produto
          LIMIT 500"
    );
    $rows = $stmt->fetchAll();
} catch (Throwable $e) {
    $erro = 'Nao foi possivel carregar as cores da colecao.';
}

$pendentes = 0;
foreach ($rows as $row) {
    if (trim((string) ($row['codigo_ks'] ?? '')) === '') {
        $pendentes++;
    }
}

render_header('De/Para de Cores', [
    ['label' => 'Voltar', 'href' => 'cp_depara_cor_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
?>
<section class="card card-slim grid-shell">
    <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
        <div>
            <strong>Cores da Colecao</strong>
            <span class="text-muted small ms-2"><?= count($rows) ?> cor(es), <?= h($pendentes) ?> pendente(s)</span>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-orange btn-save" id="btn-salvar-depara-cores" type="button">Salvar selecionadas</button>
        </div>
    </div>
    <div class="card-body table-responsive">
        <?php if ($erro !== ''): ?>
            <div class="alert alert-danger mb-0"><?= h($erro) ?></div>
        <?php elseif (!$rows): ?>
            <div class="text-center text-muted py-3">Nenhuma cor encontrada na colecao.</div>
        <?php else: ?>
            <table class="table table-custom align-middle">
                <thead>
                    <tr>
                        <th>Cor Colecao</th>
                        <th class="text-end">Itens</th>
                        <th>Cor KidStok</th>
                        <th>Status</th>
                        <th class="text-end">Acoes</th>
                    </tr>
                </thead>
                <tbody id="cp-depara-cor-grid">
                    <?php foreach ($rows as $row): ?>
                        <?php
                            $corFornecedor = (string) ($row['cor_produto'] ?? '');
                            $codigoKs = (string) ($row['codigo_ks'] ?? '');
                            $corKsTexto = trim($codigoKs . ' - ' . (string) ($row['cor_ks_nome'] ?? ''), ' -');
                        ?>
                        <tr data-cor-fornecedor="<?= h($corFornecedor) ?>" data-mapped="<?= $codigoKs !== '' ? '1' : '0' ?>">
                            <td data-label="Cor Colecao"><?= h($corFornecedor) ?></td>
                            <td data-label="Itens" class="text-end"><?= h($row['itens'] ?? 0) ?></td>
                            <td data-label="Cor KidStok">
                                <select class="form-select cp-depara-cor-select" data-type="produtos_cor">
                                    <?php if ($codigoKs !== ''): ?>
                                        <option value="<?= h($codigoKs) ?>" selected><?= h($corKsTexto) ?></option>
                                    <?php endif; ?>
                                </select>
                            </td>
                            <td data-label="Status">
                                <?php if ($codigoKs !== ''): ?>
                                    <span class="badge bg-success cp-depara-cor-status">Mapeada</span>
                                <?php else: ?>
                                    <span class="badge bg-warning text-dark cp-depara-cor-status">Pendente</span>
                                <?php endif; ?>
                            </td>
                            <td data-label="Acoes" class="text-end">
                                <button class="btn btn-sm btn-orange cp-depara-cor-save-row" type="button">Salvar</button>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php endif; ?>
    </div>
</section>
<script>
document.addEventListener('DOMContentLoaded', function () {
    if (!window.jQuery) {
        return;
    }

    const $grid = $('#cp-depara-cor-grid');

    function initSelects() {
        $grid.find('.cp-depara-cor-select').each(function () {
            const $select = $(this);
            if ($select.data('select2')) {
                return;
            }
            $select.select2({
                width: '100%',
                placeholder: 'Selecione a cor KidStok',
                allowClear: true,
                ajax: {
                    url: '../../api/seguranca/options.php',
                    dataType: 'json',
                    delay: 250,
                    data: params => ({ type: 'produtos_cor', q: params.term || '' }),
                    processResults: response => ({ results: response.results || [] })
                }
            });
        });
    }

    function setRowSaving($row, saving) {
        const $button = $row.find('.cp-depara-cor-save-row');
        if ($button.data('original-text') === undefined) {
            $button.data('original-text', $button.text());
        }
        $button.prop('disabled', saving).text(saving ? 'Salvando...' : $button.data('original-text'));
    }

    function saveRow($row, quiet) {
        const corFornecedor = String($row.data('cor-fornecedor') || '');
        const codigoKs = String($row.find('.cp-depara-cor-select').val() || '');

        if (!corFornecedor || !codigoKs) {
            if (!quiet) {
                appAlert('Selecione a cor KidStok para salvar o de/para.', 'warning');
            }
            return $.Deferred().reject().promise();
        }

        setRowSaving($row, true);
        return $.post('../../api/seguranca/crud.php?entity=cp_depara_cor&action=save', {
            id: $row.data('mapped') === 1 || String($row.data('mapped')) === '1' ? corFornecedor : '',
            cor_fornecedor: corFornecedor,
            codigo_ks: codigoKs
        }, null, 'json').done(function () {
            $row.data('mapped', 1).attr('data-mapped', '1');
            $row.find('.cp-depara-cor-status')
                .removeClass('bg-warning text-dark')
                .addClass('bg-success')
                .text('Mapeada');
            if (!quiet) {
                appAlert('De/para salvo.', 'success');
            }
        }).fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel salvar o de/para.', 'danger');
        }).always(function () {
            setRowSaving($row, false);
        });
    }

    initSelects();

    $grid.on('click', '.cp-depara-cor-save-row', function () {
        saveRow($(this).closest('tr'), false);
    });

    $('#btn-salvar-depara-cores').on('click', function () {
        const $button = $(this);
        const $rows = $grid.find('tr').filter(function () {
            return String($(this).find('.cp-depara-cor-select').val() || '') !== '';
        });

        if (!$rows.length) {
            appAlert('Selecione ao menos uma cor KidStok para salvar.', 'warning');
            return;
        }

        if ($button.data('saving') === true) {
            return;
        }

        if ($button.data('original-text') === undefined) {
            $button.data('original-text', $button.text());
        }
        $button.data('saving', true).prop('disabled', true).text('Salvando...');

        let saved = 0;
        let chain = $.Deferred().resolve().promise();
        $rows.each(function () {
            const $row = $(this);
            chain = chain.then(function () {
                return saveRow($row, true).done(function () {
                    saved++;
                });
            });
        });
        chain.always(function () {
            $button.data('saving', false).prop('disabled', false).text($button.data('original-text'));
            if (saved > 0) {
                appAlert(saved + ' de/para(s) salvo(s).', 'success');
            }
        });
    });
});
</script>
<?php render_footer(); ?>
