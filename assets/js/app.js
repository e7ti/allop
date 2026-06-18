$(function () {
    $('.js-select2').select2({
        width: '100%',
        placeholder: 'Digite para pesquisar',
        allowClear: true,
        ajax: {
            url: function () {
                return '../../api/seguranca/crud.php?entity=' + encodeURIComponent($(this).data('entity')) + '&action=list';
            },
            dataType: 'json',
            delay: 250,
            data: params => ({ q: params.term || '' }),
            processResults: response => ({
                results: (response.data || []).map(row => ({
                    id: row.id,
                    text: row.nome || row.login || row.descricao || row.usuario_nome || row.aplicacao_nome || row.perfil_nome || ('Registro ' + row.id)
                }))
            })
        }
    });

    $('.js-remote-select').each(function () {
        const $select = $(this);
        $select.select2({
            width: '100%',
            ajax: {
                url: '../../api/seguranca/options.php',
                dataType: 'json',
                delay: 250,
                data: params => ({ type: $select.data('type'), q: params.term || '' }),
                processResults: response => ({ results: response.results || [] })
            }
        });
    });

    if (window.gridConfig) {
        loadGrid();
        $('#btn-filtrar').on('click', loadGrid);
    }

    if (window.perfilAplicacoesConfig) {
        initPerfilAplicacoes();
    }

    if (window.perfilAplicacoesListaConfig) {
        initPerfilAplicacoesLista();
    }

    if (window.configuracoesEmailListaConfig) {
        initConfiguracoesEmailLista();
    }

    if (window.configuracoesEmailFormConfig) {
        initConfiguracoesEmailForm();
    }

    if (window.empresasCdListaConfig) {
        initEmpresasCdLista();
    }

    if (window.empresasCdFormConfig) {
        initEmpresasCdForm();
    }

    if (window.empresasListaConfig) {
        initEmpresasLista();
    }

    if (window.empresasFormConfig) {
        initEmpresasForm();
    }

    const $form = $('#entity-form');
    if ($form.length) {
        const id = Number($form.data('id'));
        if (id > 0) {
            loadForm($form, id);
        }
        $form.on('submit', function (event) {
            event.preventDefault();
            saveForm($form);
        });
    }
});

function appAlert(message, type) {
    const $alert = $('#app-alert');
    $alert.removeClass('d-none alert-success alert-danger alert-warning alert-info');
    $alert.addClass('alert-' + (type || 'info')).text(message);
}

function apiPost(url, data) {
    return $.ajax({
        url: url,
        method: 'POST',
        data: data,
        dataType: 'json'
    });
}

function crudUrl(entity, action) {
    return '../../api/seguranca/crud.php?entity=' + encodeURIComponent(entity) + '&action=' + encodeURIComponent(action);
}

function loadGrid() {
    const cfg = window.gridConfig;
    const $filtro = $('#filtro');
    const selected = $filtro.length ? ($filtro.select2('data')[0] || null) : null;
    const q = selected && selected.id ? selected.text : '';
    apiPost(crudUrl(cfg.entity, 'list'), { q: q }).done(function (response) {
        const rows = response.data || [];
        const html = rows.map(row => {
            const cells = cfg.columns.map((column, index) => '<td data-label="' + cfg.labels[index] + '">' + formatValue(row[column], column) + '</td>').join('');
            return '<tr>' + cells + '<td data-label="Acoes" class="text-end">' +
                '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteRow(' + row.id + ')"></button>' +
                '</td></tr>';
        }).join('');
        $('#grid').html(html || '<tr><td colspan="8" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar os dados.', 'danger');
    });
}

function formatValue(value, column) {
    if (value === null || value === undefined || value === '') {
        return '-';
    }
    const booleanColumns = ['ativo', 'visualizar', 'inserir', 'editar', 'edtiar', 'excluir', 'imprimir', 'imprirmir', 'exportar', 'processar'];
    if (booleanColumns.includes(column) && (value === 1 || value === '1')) {
        return '<span class="badge bg-success-subtle">Sim</span>';
    }
    if (booleanColumns.includes(column) && (value === 0 || value === '0')) {
        return '<span class="badge bg-danger-subtle">Nao</span>';
    }
    return $('<div>').text(value).html();
}

function deleteRow(id) {
    if (!confirm('Excluir este registro?')) {
        return;
    }
    apiPost(crudUrl(window.gridConfig.entity, 'delete'), { id: id }).done(function (response) {
        appAlert(response.message || 'Registro excluido.', 'success');
        loadGrid();
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel excluir.', 'danger');
    });
}

function loadForm($form, id) {
    apiPost(crudUrl($form.data('entity'), 'get'), { id: id }).done(function (response) {
        const row = response.data || {};
        Object.keys(row).forEach(function (name) {
            const $field = $form.find('[name="' + name + '"]');
            if (!$field.length || name === 'senha') {
                return;
            }
            if ($field.attr('type') === 'checkbox') {
                $field.prop('checked', row[name] === 1 || row[name] === '1');
                return;
            }
            if ($field.hasClass('js-remote-select') && row[name]) {
                const text = row[name + '_text'] || row[name];
                const option = new Option(text, row[name], true, true);
                $field.append(option).trigger('change');
                return;
            }
            $field.val(row[name]).trigger('change');
        });
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar o registro.', 'danger');
    });
}

function saveForm($form) {
    const data = $form.serializeArray();
    $form.find('input[type="checkbox"]').each(function () {
        if (!this.checked) {
            data.push({ name: this.name, value: 0 });
        }
    });
    apiPost(crudUrl($form.data('entity'), 'save'), $.param(data)).done(function (response) {
        appAlert(response.message || 'Registro salvo.', 'success');
        if (response.id && Number($form.data('id')) === 0) {
            $form.find('[name="id"]').val(response.id);
            $form.data('id', response.id);
        }
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel salvar.', 'danger');
    });
}

function initPerfilAplicacoes() {
    $('#perfil_id').on('change', loadPerfilAplicacoes);
    $('#btn-salvar-perfil-apps').on('click', savePerfilAplicacoes);

    if (Number(window.perfilAplicacoesConfig.perfilId || 0) > 0) {
        const perfilId = Number(window.perfilAplicacoesConfig.perfilId);
        $.getJSON('../../api/seguranca/options.php', { type: 'perfis', q: '' })
            .done(function (response) {
                const perfil = (response.results || []).find(item => Number(item.id) === perfilId);
                const option = new Option(perfil ? perfil.text : ('Perfil ' + perfilId), perfilId, true, true);
                $('#perfil_id').append(option).trigger('change');
            });
    }
}

function loadPerfilAplicacoesLista() {
    const selected = $('#filtro-perfil-aplicacoes').length ? ($('#filtro-perfil-aplicacoes').select2('data')[0] || null) : null;
    const data = { action: 'profiles' };
    if (selected && selected.id) {
        data.perfil_id = selected.id;
    }

    $.getJSON(window.perfilAplicacoesListaConfig.api, data)
        .done(function (response) {
            const rows = response.data || [];
            const html = rows.map(function (row) {
                return '<tr>' +
                    '<td data-label="Perfil">' + escapeHtml(row.perfil_nome || '') + '</td>' +
                    '<td data-label="Total Permissoes">' + escapeHtml(row.total_permissoes || '0') + '</td>' +
                    '<td data-label="Acoes" class="text-end">' +
                    '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="perfil_aplicacoes_form.php?perfil_id=' + row.perfil_id + '"></a>' +
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deletePerfilAplicacoes(' + row.perfil_id + ')"></button>' +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#perfil-aplicacoes-grid').html(html || '<tr><td colspan="3" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar os dados.', 'danger');
        });
}

function initPerfilAplicacoesLista() {
    $('#filtro-perfil-aplicacoes').select2({
        width: '100%',
        placeholder: 'Digite para pesquisar',
        allowClear: true,
        ajax: {
            url: '../../api/seguranca/options.php',
            dataType: 'json',
            delay: 250,
            data: params => ({ type: 'perfis', q: params.term || '' }),
            processResults: response => ({ results: response.results || [] })
        }
    });

    loadPerfilAplicacoesLista();
    $('#btn-filtrar-perfil-aplicacoes').on('click', loadPerfilAplicacoesLista);
}

function deletePerfilAplicacoes(perfilId) {
    if (!confirm('Excluir as permissoes deste perfil?')) {
        return;
    }

    $.post(window.perfilAplicacoesListaConfig.api + '?action=delete_profile', { perfil_id: perfilId }, function (response) {
        appAlert(response.message || 'Permissoes excluidas.', 'success');
        loadPerfilAplicacoesLista();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel excluir.', 'danger');
    });
}

function loadPerfilAplicacoes() {
    const perfilId = $('#perfil_id').val();
    const $empty = $('#perfil-apps-empty');
    const $accordion = $('#perfil-apps-accordion');
    const $save = $('#btn-salvar-perfil-apps');

    if (!perfilId) {
        $accordion.addClass('d-none').empty();
        $empty.removeClass('d-none').text('Selecione um perfil para carregar as aplicacoes e suas permissoes.');
        $save.prop('disabled', true);
        return;
    }

    $accordion.addClass('d-none').empty();
    $empty.removeClass('d-none').text('Carregando permissoes...');
    $save.prop('disabled', true);

    $.getJSON(window.perfilAplicacoesConfig.api, { action: 'list', perfil_id: perfilId })
        .done(function (response) {
            const rows = response.data || [];
            if (!rows.length) {
                $empty.removeClass('d-none').text('Nenhuma aplicacao cadastrada.');
                return;
            }

            $accordion.html(renderPerfilAplicacoesAccordion(rows)).removeClass('d-none');
            $empty.addClass('d-none').text('');
            $save.prop('disabled', false);
        })
        .fail(function (xhr) {
            $empty.removeClass('d-none').text(xhr.responseJSON?.message || 'Nao foi possivel carregar as permissoes.');
        });
}

function renderPerfilAplicacoesAccordion(rows) {
    const grouped = {};
    rows.forEach(function (row) {
        const menu = row.menu || 'Sem menu';
        grouped[menu] = grouped[menu] || [];
        grouped[menu].push(row);
    });

    return Object.keys(grouped).map(function (menu, index) {
        const id = 'perm-menu-' + index;
        const show = index === 0 ? ' show' : '';
        const collapsed = index === 0 ? '' : ' collapsed';
        const apps = grouped[menu];

        return '<div class="accordion-item permission-accordion-item">' +
            '<h2 class="accordion-header">' +
            '<button class="accordion-button' + collapsed + '" type="button" data-bs-toggle="collapse" data-bs-target="#' + id + '">' +
            '<span class="fw-bold">' + escapeHtml(menu) + '</span>' +
            '<span class="badge bg-secondary ms-2">' + apps.length + '</span>' +
            '</button>' +
            '</h2>' +
            '<div id="' + id + '" class="accordion-collapse collapse' + show + '" data-bs-parent="#perfil-apps-accordion">' +
            '<div class="accordion-body p-0">' +
            '<div class="table-responsive">' +
            '<table class="table table-custom align-middle permission-table mb-0">' +
            '<thead><tr>' +
            '<th>Aplicacao / Modulo</th>' +
            '<th>Ver</th>' +
            '<th>Inserir</th>' +
            '<th>Editar</th>' +
            '<th>Excluir</th>' +
            '<th>Imprimir</th>' +
            '<th>Exportar</th>' +
            '<th>Processar</th>' +
            '</tr></thead>' +
            '<tbody>' + apps.map(permissionRow).join('') + '</tbody>' +
            '</table>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
    }).join('');
}

function permissionRow(row) {
    const columns = ['visualizar', 'inserir', 'editar', 'excluir', 'imprimir', 'exportar', 'processar'];
    const checks = columns.map(function (column) {
        const checked = Number(row[column]) === 1 ? ' checked' : '';
        return '<td data-label="' + columnLabel(column) + '">' +
            '<input class="form-check-input permission-check" type="checkbox" data-field="' + column + '"' + checked + '>' +
            '</td>';
    }).join('');

    return '<tr data-aplicacao-id="' + row.aplicacao_id + '">' +
        '<td data-label="Aplicacao"><strong>' + escapeHtml(row.aplicacao_nome || '') + '</strong><span class="permission-route">' + escapeHtml(row.rota || '') + '</span></td>' +
        checks +
        '</tr>';
}

function columnLabel(column) {
    const labels = {
        visualizar: 'Ver',
        inserir: 'Inserir',
        editar: 'Editar',
        excluir: 'Excluir',
        imprimir: 'Imprimir',
        exportar: 'Exportar',
        processar: 'Processar'
    };
    return labels[column] || column;
}

function savePerfilAplicacoes() {
    const perfilId = $('#perfil_id').val();
    const permissions = [];

    $('#perfil-apps-accordion tr[data-aplicacao-id]').each(function () {
        const $row = $(this);
        const item = { aplicacao_id: Number($row.data('aplicacao-id')) };
        ['visualizar', 'inserir', 'editar', 'excluir', 'imprimir', 'exportar', 'processar'].forEach(function (column) {
            item[column] = $row.find('[data-field="' + column + '"]').is(':checked') ? 1 : 0;
        });
        permissions.push(item);
    });

    $('#btn-salvar-perfil-apps').prop('disabled', true);
    $.post(window.perfilAplicacoesConfig.api + '?action=save', {
        perfil_id: perfilId,
        permissions: JSON.stringify(permissions)
    }, function (response) {
        appAlert(response.message || 'Permissoes salvas.', 'success');
        $('#btn-salvar-perfil-apps').prop('disabled', false);
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel salvar as permissoes.', 'danger');
        $('#btn-salvar-perfil-apps').prop('disabled', false);
    });
}

function escapeHtml(value) {
    return $('<div>').text(value).html();
}

function initConfiguracoesEmailLista() {
    $('#filtro-email').select2({
        width: '100%',
        placeholder: 'Digite para pesquisar',
        allowClear: true,
        ajax: {
            url: window.configuracoesEmailListaConfig.api,
            dataType: 'json',
            delay: 250,
            data: params => ({ action: 'list', q: params.term || '' }),
            processResults: response => ({
                results: (response.data || []).map(row => ({
                    id: row.id,
                    text: row.NomeConta || row.Email || row.Servidor || ('Registro ' + row.id)
                }))
            })
        }
    });
    loadConfiguracoesEmailGrid();
    $('#btn-filtrar-email').on('click', loadConfiguracoesEmailGrid);
}

function loadConfiguracoesEmailGrid() {
    const cfg = window.configuracoesEmailListaConfig;
    const selected = $('#filtro-email').select2('data')[0] || null;
    $.getJSON(cfg.api, { action: 'list', q: selected && selected.id ? selected.text : '' })
        .done(function (response) {
            const rows = response.data || [];
            const html = rows.map(function (row) {
                return '<tr>' +
                    '<td data-label="Conta">' + escapeHtml(row.NomeConta || '') + '</td>' +
                    '<td data-label="Servidor">' + escapeHtml(row.Servidor || '') + '</td>' +
                    '<td data-label="Porta">' + escapeHtml(row.Porta || '') + '</td>' +
                    '<td data-label="E-mail">' + escapeHtml(row.Email || '') + '</td>' +
                    '<td data-label="Habilitado">' + formatValue(row.Habilitado, 'ativo') + '</td>' +
                    '<td data-label="Status">' + escapeHtml(row.Status || '') + '</td>' +
                    '<td data-label="Acoes" class="text-end">' +
                    '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteConfiguracoesEmail(' + row.id + ')"></button>' +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#configuracoes-email-grid').html(html || '<tr><td colspan="7" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar os dados.', 'danger');
        });
}

function deleteConfiguracoesEmail(id) {
    if (!confirm('Excluir este registro?')) {
        return;
    }

    $.post(window.configuracoesEmailListaConfig.api + '?action=delete', { id: id }, function (response) {
        appAlert(response.message || 'Registro excluido.', 'success');
        loadConfiguracoesEmailGrid();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel excluir.', 'danger');
    });
}

function initConfiguracoesEmailForm() {
    const $form = $('#configuracoes-email-form');
    const id = Number($form.data('id'));

    $form.find('.js-config-email-select').each(function () {
        const $select = $(this);
        $select.select2({
            width: '100%',
            ajax: {
                url: window.configuracoesEmailFormConfig.optionsApi,
                dataType: 'json',
                delay: 250,
                data: params => ({ type: $select.data('type'), q: params.term || '' }),
                processResults: response => ({ results: response.results || [] })
            }
        });
    });

    if (id > 0) {
        $.getJSON(window.configuracoesEmailFormConfig.api, { action: 'get', id: id })
            .done(function (response) {
                const row = response.data || {};
                Object.keys(row).forEach(function (name) {
                    const $field = $form.find('[name="' + name + '"]');
                    if ($field.length) {
                        if ($field.hasClass('js-config-email-select') && row[name]) {
                            const text = row[name + '_text'] || row[name];
                            const option = new Option(text, row[name], true, true);
                            $field.append(option).trigger('change');
                            return;
                        }
                        $field.val(row[name]).trigger('change');
                    }
                });
            })
            .fail(function (xhr) {
                appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar o registro.', 'danger');
            });
    }

    $form.on('submit', function (event) {
        event.preventDefault();
        $.post(window.configuracoesEmailFormConfig.api + '?action=save', $form.serialize(), function (response) {
            appAlert(response.message || 'Registro salvo.', 'success');
            if (response.id && Number($form.data('id')) === 0) {
                $form.find('[name="id"]').val(response.id);
                $form.data('id', response.id);
            }
        }, 'json').fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel salvar.', 'danger');
        });
    });
}

function debounce(callback, wait) {
    let timeout = null;
    return function () {
        clearTimeout(timeout);
        timeout = setTimeout(callback, wait);
    };
}

function initEmpresasCdLista() {
    $('#filtro-empresas-cd').select2({
        width: '100%',
        placeholder: 'Digite para pesquisar',
        allowClear: true,
        ajax: {
            url: window.empresasCdListaConfig.api,
            dataType: 'json',
            delay: 250,
            data: params => ({ action: 'list', q: params.term || '' }),
            processResults: response => ({
                results: (response.data || []).map(row => ({
                    id: row.id,
                    text: row.NomeCD || ('Registro ' + row.id)
                }))
            })
        }
    });
    loadEmpresasCdGrid();
    $('#btn-filtrar-empresas-cd').on('click', loadEmpresasCdGrid);
}

function loadEmpresasCdGrid() {
    const cfg = window.empresasCdListaConfig;
    const selected = $('#filtro-empresas-cd').select2('data')[0] || null;
    $.getJSON(cfg.api, { action: 'list', q: selected && selected.id ? selected.text : '' })
        .done(function (response) {
            const rows = response.data || [];
            const html = rows.map(function (row) {
                return '<tr>' +
                    '<td data-label="Codigo">' + escapeHtml(row.Codigo || '') + '</td>' +
                    '<td data-label="Nome CD">' + escapeHtml(row.NomeCD || '') + '</td>' +
                    '<td data-label="Status">' + escapeHtml(row.Status || '') + '</td>' +
                    '<td data-label="Acoes" class="text-end">' +
                    '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteEmpresasCd(' + row.id + ')"></button>' +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#empresas-cd-grid').html(html || '<tr><td colspan="4" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar os dados.', 'danger');
        });
}

function deleteEmpresasCd(id) {
    if (!confirm('Excluir este registro?')) {
        return;
    }

    $.post(window.empresasCdListaConfig.api + '?action=delete', { id: id }, function (response) {
        appAlert(response.message || 'Registro excluido.', 'success');
        loadEmpresasCdGrid();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel excluir.', 'danger');
    });
}

function initEmpresasCdForm() {
    const $form = $('#empresas-cd-form');
    const id = Number($form.data('id'));

    if (id > 0) {
        $.getJSON(window.empresasCdFormConfig.api, { action: 'get', id: id })
            .done(function (response) {
                const row = response.data || {};
                Object.keys(row).forEach(function (name) {
                    const $field = $form.find('[name="' + name + '"]');
                    if ($field.length) {
                        $field.val(row[name]).trigger('change');
                    }
                });
            })
            .fail(function (xhr) {
                appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar o registro.', 'danger');
            });
    }

    $form.on('submit', function (event) {
        event.preventDefault();
        $.post(window.empresasCdFormConfig.api + '?action=save', $form.serialize(), function (response) {
            appAlert(response.message || 'Registro salvo.', 'success');
            if (response.id && Number($form.data('id')) === 0) {
                $form.find('[name="id"]').val(response.id);
                $form.find('[name="Codigo"]').val(response.id);
                $form.data('id', response.id);
            }
        }, 'json').fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel salvar.', 'danger');
        });
    });
}

function initEmpresasLista() {
    $('#filtro-empresas').select2({
        width: '100%',
        placeholder: 'Digite para pesquisar',
        allowClear: true,
        ajax: {
            url: window.empresasListaConfig.api,
            dataType: 'json',
            delay: 250,
            data: params => ({ action: 'list', q: params.term || '' }),
            processResults: response => ({
                results: (response.data || []).map(row => ({
                    id: row.id,
                    text: row.Fantasia || row.Nome || row.CNPJ || ('Registro ' + row.id)
                }))
            })
        }
    });
    loadEmpresasGrid();
    $('#btn-filtrar-empresas').on('click', loadEmpresasGrid);
}

function loadEmpresasGrid() {
    const cfg = window.empresasListaConfig;
    const selected = $('#filtro-empresas').select2('data')[0] || null;
    $.getJSON(cfg.api, { action: 'list', q: selected && selected.id ? selected.text : '' })
        .done(function (response) {
            const rows = response.data || [];
            const html = rows.map(function (row) {
                return '<tr>' +
                    '<td data-label="Codigo">' + escapeHtml(row.Codigo || '') + '</td>' +
                    '<td data-label="Fantasia">' + escapeHtml(row.Fantasia || '') + '</td>' +
                    '<td data-label="CNPJ">' + escapeHtml(formatCnpj(row.CNPJ || '')) + '</td>' +
                    '<td data-label="Cidade/UF">' + escapeHtml([row.Cidade, row.UF].filter(Boolean).join('/')) + '</td>' +
                    '<td data-label="Codigo IBGE">' + escapeHtml(row.ibge || '') + '</td>' +
                    '<td data-label="Status">' + escapeHtml(row.Status || '') + '</td>' +
                    '<td data-label="Acoes" class="text-end">' +
                    '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteEmpresa(' + row.id + ')"></button>' +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#empresas-grid').html(html || '<tr><td colspan="7" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar os dados.', 'danger');
        });
}

function deleteEmpresa(id) {
    if (!confirm('Excluir este registro?')) {
        return;
    }

    $.post(window.empresasListaConfig.api + '?action=delete', { id: id }, function (response) {
        appAlert(response.message || 'Registro excluido.', 'success');
        loadEmpresasGrid();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel excluir.', 'danger');
    });
}

function initEmpresasForm() {
    const $form = $('#empresas-form');
    const id = Number($form.data('id'));

    $form.find('.js-empresa-select').each(function () {
        const $select = $(this);
        $select.select2({
            width: '100%',
            ajax: {
                url: window.empresasFormConfig.optionsApi,
                dataType: 'json',
                delay: 250,
                data: params => ({ type: $select.data('type'), q: params.term || '' }),
                processResults: response => ({ results: response.results || [] })
            }
        });
    });

    $form.on('input', '.js-only-digits', function () {
        this.value = onlyDigits(this.value);
    });

    $form.find('.js-cep').on('blur', function () {
        buscarCepEmpresa($form, this.value);
    });

    if (id > 0) {
        $.getJSON(window.empresasFormConfig.api, { action: 'get', id: id })
            .done(function (response) {
                const row = response.data || {};
                Object.keys(row).forEach(function (name) {
                    const $field = $form.find('[name="' + name + '"]');
                    if (!$field.length) {
                        return;
                    }
                    if ($field.hasClass('js-empresa-select') && row[name]) {
                        const text = row[name + '_text'] || row[name];
                        const option = new Option(text, row[name], true, true);
                        $field.append(option).trigger('change');
                        return;
                    }
                    $field.val(row[name]).trigger('change');
                });
            })
            .fail(function (xhr) {
                appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar o registro.', 'danger');
            });
    }

    $form.on('submit', function (event) {
        event.preventDefault();
        const message = validarEmpresaForm($form);
        if (message) {
            appAlert(message, 'danger');
            return;
        }

        $.post(window.empresasFormConfig.api + '?action=save', $form.serialize(), function (response) {
            appAlert(response.message || 'Registro salvo.', 'success');
            if (response.id && Number($form.data('id')) === 0) {
                $form.find('[name="id"]').val(response.id);
                $form.find('[name="Codigo"]').val(response.id);
                $form.data('id', response.id);
            }
        }, 'json').fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel salvar.', 'danger');
        });
    });
}

function validarEmpresaForm($form) {
    const cnpj = onlyDigits($form.find('[name="CNPJ"]').val());
    const cep = onlyDigits($form.find('[name="CEP"]').val());
    const ibge = onlyDigits($form.find('[name="ibge"]').val());
    const ddds = [$form.find('[name="FoneDDD"]').val(), $form.find('[name="CelularDDD"]').val()];

    if (!$form.find('[name="EmpresaCD"]').val()) {
        return 'Informe o CD.';
    }
    if (!$form.find('[name="Nome"]').val() || !$form.find('[name="Fantasia"]').val()) {
        return 'Informe nome e fantasia.';
    }
    if (!validarCnpj(cnpj)) {
        return 'Informe um CNPJ valido.';
    }
    if (cep && cep.length !== 8) {
        return 'CEP deve conter 8 digitos.';
    }
    if (ibge && ibge.length !== 7) {
        return 'Codigo IBGE deve conter 7 digitos.';
    }
    if (ddds.some(ddd => ddd && onlyDigits(ddd).length !== 2)) {
        return 'DDD deve conter 2 digitos.';
    }
    return '';
}

function buscarCepEmpresa($form, value) {
    const cep = onlyDigits(value);
    if (cep.length !== 8) {
        return;
    }

    fetch('https://viacep.com.br/ws/' + cep + '/json/')
        .then(response => response.json())
        .then(data => {
            if (data.erro) {
                appAlert('CEP nao encontrado.', 'warning');
                return;
            }
            $form.find('[name="TipoEndereco"]').val((data.logradouro || '').split(' ')[0] || '');
            $form.find('[name="Endereco"]').val(data.logradouro || '');
            $form.find('[name="Bairro"]').val(data.bairro || '');
            $form.find('[name="Cidade"]').val(data.localidade || '');
            $form.find('[name="UF"]').val(data.uf || '').trigger('change');
            $form.find('[name="ibge"]').val(data.ibge || '');
        })
        .catch(() => appAlert('Nao foi possivel consultar o CEP.', 'warning'));
}

function onlyDigits(value) {
    return String(value || '').replace(/\D+/g, '');
}

function validarCnpj(cnpj) {
    cnpj = onlyDigits(cnpj);
    if (cnpj.length !== 14 || /^(\d)\1+$/.test(cnpj)) {
        return false;
    }

    let length = 12;
    let numbers = cnpj.substring(0, length);
    let digits = cnpj.substring(length);
    let sum = 0;
    let pos = length - 7;
    for (let i = length; i >= 1; i--) {
        sum += Number(numbers.charAt(length - i)) * pos--;
        if (pos < 2) {
            pos = 9;
        }
    }
    let result = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    if (result !== Number(digits.charAt(0))) {
        return false;
    }

    length = 13;
    numbers = cnpj.substring(0, length);
    sum = 0;
    pos = length - 7;
    for (let i = length; i >= 1; i--) {
        sum += Number(numbers.charAt(length - i)) * pos--;
        if (pos < 2) {
            pos = 9;
        }
    }
    result = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    return result === Number(digits.charAt(1));
}

function formatCnpj(value) {
    const cnpj = onlyDigits(value);
    if (cnpj.length !== 14) {
        return value;
    }
    return cnpj.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, '$1.$2.$3/$4-$5');
}
