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

    if (window.cpComprasListaConfig) {
        initCpComprasLista();
    }

    if (window.cpComprasFormConfig) {
        initCpComprasForm();
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

function escapeAttr(value) {
    return escapeHtml(value).replace(/"/g, '&quot;');
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

let cpCompraItens = [];
let cpCompraItensOpen = {};
let cpCompraReadonly = false;
let cpCompraReadonlyLocalizacao = '';
let cpCompraFotoItemIndex = null;

function initCpComprasLista() {
    $('#filtro-cp-compras').select2({
        width: '100%',
        placeholder: 'Digite para pesquisar',
        allowClear: true,
        ajax: {
            url: window.cpComprasListaConfig.api,
            dataType: 'json',
            delay: 250,
            data: params => ({ action: 'list', q: params.term || '' }),
            processResults: response => ({
                results: (response.data || []).map(row => ({
                    id: row.id,
                    text: 'Pedido ' + row.ID + ' - ' + (row.empresa_nome || row.fornecedor_nome || row.Sts || '') + ' - ' + (row.Localizacao || '')
                }))
            })
        }
    });

    loadCpComprasGrid();
    $('#btn-filtrar-cp-compras').on('click', loadCpComprasGrid);
}

function loadCpComprasGrid() {
    const cfg = window.cpComprasListaConfig;
    const selected = $('#filtro-cp-compras').select2('data')[0] || null;
    $.getJSON(cfg.api, { action: 'list', q: selected && selected.id ? selected.text : '' })
        .done(function (response) {
            const rows = response.data || [];
            const html = rows.map(function (row) {
                const localizacao = row.Localizacao || 'KidStok';
                const canEdit = localizacao === 'KidStok';
                const actions = canEdit
                    ? '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                        '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteCpCompra(' + row.id + ')"></button>'
                    : '<a class="btn btn-sm btn-outline-secondary btn-view btn-icon-only" title="Visualizar" aria-label="Visualizar" href="' + cfg.form + '?id=' + row.id + '"></a>';
                return '<tr>' +
                    '<td data-label="Pedido">' + escapeHtml(row.ID || '') + '</td>' +
                    '<td data-label="Data">' + escapeHtml(formatDateBr(row.DataPedido || '')) + '</td>' +
                    '<td data-label="CD">' + escapeHtml(row.cd_nome || '') + '</td>' +
                    '<td data-label="Empresa">' + escapeHtml(row.empresa_nome || '') + '</td>' +
                    '<td data-label="Fornecedor">' + escapeHtml(row.fornecedor_nome || '') + '</td>' +
                    '<td data-label="Localizacao">' + cpLocalizacaoBadge(localizacao) + '</td>' +
                    '<td data-label="Total">' + escapeHtml(formatMoneyBr(row.ValorTotalPedido || 0)) + '</td>' +
                    '<td data-label="Status">' + escapeHtml(row.Sts || '') + '</td>' +
                    '<td data-label="Acoes" class="text-end">' +
                    actions +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#cp-compras-grid').html(html || '<tr><td colspan="9" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar os pedidos.', 'danger');
        });
}

function deleteCpCompra(id) {
    if (!confirm('Excluir este pedido?')) {
        return;
    }

    $.post(window.cpComprasListaConfig.api + '?action=delete', { id: id }, function (response) {
        appAlert(response.message || 'Pedido excluido.', 'success');
        loadCpComprasGrid();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel excluir.', 'danger');
    });
}

function initCpComprasForm() {
    const $form = $('#cp-compras-form');
    const id = Number($form.data('id'));
    cpCompraReadonly = false;
    cpCompraReadonlyLocalizacao = '';

    $form.find('.js-cp-compra-select').each(function () {
        const $select = $(this);
        $select.select2({
            width: '100%',
            ajax: {
                url: window.cpComprasFormConfig.api,
                dataType: 'json',
                delay: 250,
                data: params => ({ action: 'options', type: $select.data('type'), q: params.term || '' }),
                processResults: response => ({ results: response.results || [] })
            }
        });
    });

    $form.find('[name="Fornecedor_id"]').on('select2:select', function (event) {
        const markup = event.params.data.markup_compra;
        if (markup !== undefined && markup !== null && markup !== '') {
            $form.find('[name="MarkupFranqueadora"]').val(formatMoneyInput(markup || 0));
            recalcCpCompraMarkupTotal($form);
        }
    });

    initCpCompraHeaderMoney($form);

    $('#btn-add-cp-item').on('click', function () {
        if (!$form.find('[name="Fornecedor_id"]').val()) {
            appAlert('Informe o fornecedor antes de adicionar itens.', 'warning');
            return;
        }
        syncCpCompraItensFromDom();
        cpCompraItens.push(emptyCpCompraItem(false));
        cpCompraItensOpen[cpCompraItens.length - 1] = true;
        renderCpCompraItens();
    });

    $('#cp-foto-input').on('change', uploadCpCompraFotos);

    $form.on('shown.bs.collapse hidden.bs.collapse', '.cp-compra-item-collapse', function (event) {
        cpCompraItensOpen[$(this).data('item-index')] = event.type === 'shown';
    });

    if (id > 0) {
        $.getJSON(window.cpComprasFormConfig.api, { action: 'get', id: id })
            .done(function (response) {
                const row = response.data || {};
                fillCpCompraHeader($form, row);
                cpCompraReadonlyLocalizacao = row.Localizacao || 'KidStok';
                cpCompraReadonly = cpCompraReadonlyLocalizacao === 'Fornecedor';
                cpCompraItens = (row.items || []).map(mapCpCompraItemFromApi);
                cpCompraItensOpen = {};
                applyCpCompraReadonly($form);
                renderCpCompraItens();
                recalcCpCompraTotal();
            })
            .fail(function (xhr) {
                appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar o pedido.', 'danger');
            });
    } else {
        $form.find('[name="DataPedido"]').val(new Date().toISOString().slice(0, 10));
        $form.find('[name="Sts"]').val('Aberto');
        $form.find('[name="Sts_display"]').val('Aberto');
        $form.find('[name="Publicado"]').val('0');
        $form.find('[name="Publicado_display"]').val('0 - Nao publicado');
        $form.find('[name="Localizacao"]').val('KidStok');
        $form.find('[name="Localizacao_display"]').val('KidStok');
        toggleCpCompraMotivo($form);
        loadCpCompraDefaults($form);
        cpCompraItens = [];
        cpCompraItensOpen = {};
        renderCpCompraItens();
        focusCpCompraFornecedor($form);
    }

    $form.on('submit', function (event) {
        event.preventDefault();
        if (cpCompraReadonly) {
            appAlert('Pedido com localizacao ' + cpCompraReadonlyLocalizacao + ' permite apenas visualizacao.', 'warning');
            return;
        }
        syncCpCompraItensFromDom();
        const message = validarCpCompraForm($form);
        if (message) {
            appAlert(message, 'danger');
            return;
        }
        recalcCpCompraTotal();
        const data = $form.serializeArray();
        data.push({ name: 'items_json', value: JSON.stringify(cpCompraItens) });
        $.post(window.cpComprasFormConfig.api + '?action=save', $.param(data), function (response) {
            appAlert(response.message || 'Pedido salvo.', 'success');
            if (response.id && Number($form.data('id')) === 0) {
                $form.find('[name="id"]').val(response.id);
                $form.find('[name="ID"]').val(response.id);
                $form.data('id', response.id);
            }
            collapseCpCompraItens();
        }, 'json').fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Nao foi possivel salvar o pedido.', 'danger');
        });
    });
}

function loadCpCompraDefaults($form) {
    $.getJSON(window.cpComprasFormConfig.api, { action: 'defaults' })
        .done(function (response) {
            if (response.cd) {
                setSelect2Option($form.find('[name="cd_id"]'), response.cd.id, response.cd.text);
            }
            if (response.empresa) {
                setSelect2Option($form.find('[name="empresa_id"]'), response.empresa.id, response.empresa.text);
            }
        });
}

function setSelect2Option($field, id, text) {
    if (!$field.length || !id) {
        return;
    }
    const option = new Option(text || id, id, true, true);
    $field.append(option).trigger('change');
}

function focusCpCompraFornecedor($form) {
    setTimeout(function () {
        const $fornecedor = $form.find('[name="Fornecedor_id"]');
        if ($fornecedor.length && $fornecedor.data('select2')) {
            $fornecedor.select2('open');
        }
    }, 150);
}

function applyCpCompraReadonly($form) {
    if (!cpCompraReadonly) {
        return;
    }
    $form.addClass('cp-compra-readonly');
    $form.find('input, select, textarea, button[type="submit"]').prop('disabled', true);
    $form.find('[name="ID"], [name="ValorTotalPedido"]').prop('disabled', false).prop('readonly', true);
    $form.find('.js-cp-compra-select').prop('disabled', true).trigger('change.select2');
    $('#btn-add-cp-item, #btn-aplicar-percentuais').prop('disabled', true);
    appAlert('Pedido com localizacao ' + cpCompraReadonlyLocalizacao + ' esta disponivel apenas para visualizacao.', 'warning');
}

function fillCpCompraHeader($form, row) {
    Object.keys(row).forEach(function (name) {
        if (name === 'items') {
            return;
        }
        const $field = $form.find('[name="' + name + '"]');
        if (!$field.length) {
            return;
        }
        if ($field.hasClass('js-cp-compra-select') && row[name]) {
            const option = new Option(row[name + '_text'] || row[name], row[name], true, true);
            $field.append(option).trigger('change');
            return;
        }
        if ($field.hasClass('cp-header-money-field')) {
            $field.val(formatMoneyInput(row[name] || 0)).trigger('change');
        } else {
            $field.val(row[name]).trigger('change');
        }
        if (name === 'Sts') {
            $form.find('[name="Sts_display"]').val(row[name] || 'Aberto');
        }
        if (name === 'Publicado') {
            $form.find('[name="Publicado_display"]').val(formatPublicadoCpCompra(row[name]));
        }
        if (name === 'Localizacao') {
            $form.find('[name="Localizacao_display"]').val(row[name] || 'KidStok');
        }
    });
    toggleCpCompraMotivo($form);
    recalcCpCompraMarkupTotal($form);
}

function toggleCpCompraMotivo($form) {
    const status = $form.find('[name="Sts"]').val() || $form.find('[name="Sts_display"]').val() || 'Aberto';
    const showMotivo = status === 'Recusado';
    $('#cp-sts-motivo-group').toggleClass('d-none', !showMotivo);
    if (!showMotivo) {
        $form.find('[name="StsMotivo"]').val('');
    }
}

function formatPublicadoCpCompra(value) {
    return Number(value || 0) === 1 ? '1 - Publicado' : '0 - Nao publicado';
}

function initCpCompraHeaderMoney($form) {
    $form.find('.cp-header-money-field').each(function () {
        this.value = formatMoneyInput(this.value || 0);
    });

    $form.find('[name="MarkupFranqueadora"], [name="MarkupFranquia"]')
        .off('input.cpHeaderMoney focus.cpHeaderMoney')
        .on('input.cpHeaderMoney', function () {
            this.value = formatMoneyInput(this.value);
            recalcCpCompraMarkupTotal($form);
        })
        .on('focus.cpHeaderMoney', function () {
            this.select();
        });

    recalcCpCompraMarkupTotal($form);
}

function recalcCpCompraMarkupTotal($form) {
    const total = parseMoneyInput($form.find('[name="MarkupFranqueadora"]').val()) +
        parseMoneyInput($form.find('[name="MarkupFranquia"]').val());
    $form.find('[name="MarkupTotal"]').val(formatMoneyInput(roundCpMoney(total)));
}

function collapseCpCompraItens() {
    cpCompraItens.forEach(function (_item, index) {
        cpCompraItensOpen[index] = false;
    });
    renderCpCompraItens();
}

function emptyCpCompraItem(confirmado) {
    return {
        referencia_fornecedor: '',
        descricao: '',
        composicao: '',
        ncm: '',
        entrega: '',
        total_qtde: 0,
        total_produto: 0,
        Foto: 0,
        Sts: 1,
        item_confirmado: confirmado === undefined ? false : Boolean(confirmado),
        _pendingDetalhes: [],
        detalhes: []
    };
}

function emptyCpCompraDetalhe() {
    return {
        sku: '',
        tamanho: '',
        cor: '',
        Qtde: 0,
        preco_fornecedor: 0,
        preco_proposta: 0,
        valor_total_produto: 0,
        preco_franqueado: 0,
        markup_franquia: 0,
        preco_loja: 0,
        markup_loja: 0,
        markup_total: 0,
        Sts: 1
    };
}

function mapCpCompraItemFromApi(row) {
    return {
        referencia_fornecedor: row.referencia_fornecedor || '',
        descricao: row.descricao || '',
        composicao: row.composicao || '',
        ncm: row.ncm || '',
        entrega: row.entrega || '',
        total_qtde: Number(row.total_qtde || 0),
        total_produto: Number(row.total_produto || 0),
        Foto: Number(row.Foto || 0),
        Sts: Number(row.Sts || 1),
        item_confirmado: true,
        _pendingDetalhes: [],
        detalhes: (row.detalhes || []).map(function (detail) {
            return Object.assign(emptyCpCompraDetalhe(), {
                sku: detail.sku || '',
                tamanho: detail.tamanho || '',
                cor: detail.cor || '',
                Qtde: Number(detail.Qtde || 0),
                preco_fornecedor: Number(detail.preco_fornecedor || 0),
                preco_proposta: Number(detail.preco_proposta || 0),
                valor_total_produto: Number(detail.valor_total_produto || 0),
                preco_franqueado: Number(detail.preco_franqueado || 0),
                markup_franquia: Number(detail.markup_franquia || 0),
                preco_loja: Number(detail.preco_loja || 0),
                markup_loja: Number(detail.markup_loja || 0),
                markup_total: Number(detail.markup_total || 0),
                Sts: Number(detail.Sts || 1)
            });
        })
    };
}

function renderCpCompraItens() {
    const html = cpCompraItens.map(function (item, index) {
        const collapseId = 'cp-compra-item-collapse-' + index;
        const isOpen = cpCompraItensOpen[index] !== false;
        const collapseClass = isOpen ? ' show' : '';
        const collapsedClass = isOpen ? '' : ' collapsed';
        const referencia = item.referencia_fornecedor || 'Item ' + (index + 1);
        const descricao = item.descricao || 'Sem descricao';
        const composicao = item.composicao || 'N/A';
        const entrega = item.entrega ? formatDateBr(item.entrega) : 'Nao definida';
        return '<section class="card card-slim mb-3 cp-compra-item" data-item-index="' + index + '">' +
            '<div class="card-header bg-table-header cp-compra-item-header cursor-pointer' + collapsedClass + '" data-bs-toggle="collapse" data-bs-target="#' + collapseId + '" aria-expanded="' + (isOpen ? 'true' : 'false') + '" aria-controls="' + collapseId + '">' +
            '<div class="d-flex align-items-center cp-compra-item-title">' +
            '<span class="cp-compra-chevron transition-icon" aria-hidden="true"></span>' +
            '<div>' +
            '<span class="fw-bold text-dark">' + escapeHtml(referencia) + '</span>' +
            '<div class="extra-small text-muted">' + escapeHtml(descricao) + '</div>' +
            '<div class="extra-small text-muted">Composicao: ' + escapeHtml(composicao) + '</div>' +
            '</div>' +
            '</div>' +
            '<div class="d-flex align-items-center gap-4 cp-compra-item-summary">' +
            '<div class="text-end d-none d-md-block">' +
            '<small class="text-muted d-block extra-small text-uppercase">Entrega do Item</small>' +
            '<span>' + escapeHtml(entrega) + '</span>' +
            '</div>' +
            '<div class="text-end d-none d-md-block">' +
            '<small class="text-muted d-block extra-small text-uppercase">Total do Item</small>' +
            '<span class="fw-bold text-success cp-compra-item-total">R$ ' + escapeHtml(formatMoneyBr(item.total_produto || 0)) + '</span>' +
            '</div>' +
            photoButtonHtml(index, item) +
            (cpCompraReadonly ? '' : '<div class="d-flex flex-wrap gap-2 cp-compra-item-actions" onclick="event.stopPropagation();">' +
                (item.item_confirmado ? '<button class="btn btn-sm btn-orange btn-new" type="button" onclick="addCpCompraDetalhe(' + index + ')">Subitem</button>' : '<button class="btn btn-sm btn-orange btn-save" type="button" onclick="confirmCpCompraItem(' + index + ')">Confirmar</button>') +
                '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" type="button" onclick="removeCpCompraItem(' + index + ')"></button>' +
                '</div>') +
            '</div>' +
            '</div>' +
            '<div id="' + collapseId + '" class="collapse cp-compra-item-collapse' + collapseClass + '" data-item-index="' + index + '">' +
            '<div class="card-body border-top table-responsive">' +
            '<div class="row g-3 mb-3">' +
            referenceSelectHtml(index, item.referencia_fornecedor, 'col-12 col-lg-5', item.item_confirmado) +
            fieldHtml(index, null, 'descricao', 'Descricao', item.descricao, 'col-12 col-lg-5', 'text', null, true) +
            fieldHtml(index, null, 'entrega', 'Entrega', item.entrega, 'col-12 col-lg-2', 'date', null, true) +
            fieldHtml(index, null, 'composicao', 'Composicao', item.composicao, 'col-12 col-md-3', 'text', null, true) +
            fieldHtml(index, null, 'ncm', 'NCM', item.ncm, 'col-12 col-md-2', 'text', null, true) +
            fieldHtml(index, null, 'total_qtde', 'Qtde Rateio', item.total_qtde, 'col-12 col-md-2', 'number', '0.01', true) +
            fieldHtml(index, null, 'total_produto', 'Total Item', item.total_produto, 'col-12 col-md-2', 'number', '0.01', true) +
            itemStatusReadonlyHtml(index, item.Sts, 'col-12 col-md-2') +
            '</div>' +
            (item.item_confirmado ? '<div class="table-responsive">' +
            '<table class="table table-custom align-middle mb-0 cp-compra-detalhes-table">' +
            '<thead><tr><th>Tamanho</th><th>Cor</th><th>Qtde</th><th>Preco Prop.</th><th>Preco Forn.</th><th>Preco Franq.</th><th>Preco Loja</th><th>Total</th><th>Status</th>' + (cpCompraReadonly ? '' : '<th class="text-end">Acoes</th>') + '</tr></thead>' +
            '<tbody>' + renderCpCompraDetalhes(index, item.detalhes || []) + '</tbody>' +
            '</table>' +
            '</div>' : '<div class="text-center text-muted py-3">Confirme o item para inserir os subitens.</div>') +
            '</div>' +
            '</div>' +
            '</section>';
    }).join('');
    $('#cp-compras-itens').html(html || '<div class="text-center text-muted py-3">Nenhum item informado.</div>');
    initCpCompraReferenciaSelects();
    initCpCompraDetalheFields();
}

function renderCpCompraDetalhes(itemIndex, detalhes) {
    return detalhes.map(function (detail, detailIndex) {
        return '<tr data-item-index="' + itemIndex + '" data-detail-index="' + detailIndex + '">' +
            '<td data-label="Tamanho">' + detailInput(itemIndex, detailIndex, 'tamanho', detail.tamanho, 'text', null, true) + '</td>' +
            '<td data-label="Cor">' + detailInput(itemIndex, detailIndex, 'cor', detail.cor, 'text', null, true) + '</td>' +
            '<td data-label="Qtde">' + detailInput(itemIndex, detailIndex, 'Qtde', parseInt(detail.Qtde || 0, 10), 'number', '1') + '</td>' +
            '<td data-label="Preco Prop.">' + detailInput(itemIndex, detailIndex, 'preco_proposta', detail.preco_proposta, 'money') + '</td>' +
            '<td data-label="Preco Forn.">' + detailInput(itemIndex, detailIndex, 'preco_fornecedor', detail.preco_fornecedor, 'money', null, true) + '</td>' +
            '<td data-label="Preco Franq.">' + detailInput(itemIndex, detailIndex, 'preco_franqueado', detail.preco_franqueado, 'money', null, true) + '</td>' +
            '<td data-label="Preco Loja">' + detailInput(itemIndex, detailIndex, 'preco_loja', detail.preco_loja, 'money', null, true) + '</td>' +
            '<td data-label="Total">' + detailInput(itemIndex, detailIndex, 'valor_total_produto', detail.valor_total_produto, 'money', null, true) + '</td>' +
            '<td data-label="Status">' + detailStatusSelect(itemIndex, detailIndex, detail.Sts) + '</td>' +
            (cpCompraReadonly ? '' : '<td data-label="Acoes" class="text-end"><button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" type="button" onclick="removeCpCompraDetalhe(' + itemIndex + ', ' + detailIndex + ')"></button></td>') +
            '</tr>';
    }).join('');
}

function fieldHtml(itemIndex, detailIndex, name, label, value, colClass, type, step, readonly) {
    const attr = cpDataAttrs(itemIndex, detailIndex, name);
    const inputType = type || 'text';
    const stepAttr = step ? ' step="' + step + '"' : '';
    const readonlyAttr = (readonly || cpCompraReadonly) ? ' readonly' : '';
    return '<div class="' + colClass + '"><label class="form-label">' + label + '</label><input class="form-control cp-compra-field" type="' + inputType + '"' + stepAttr + readonlyAttr + ' value="' + escapeAttr(value || '') + '" ' + attr + '></div>';
}

function referenceSelectHtml(itemIndex, value, colClass, readonly) {
    const selected = value ? '<option value="' + escapeAttr(value) + '" selected>' + escapeHtml(value) + '</option>' : '';
    const disabledAttr = (readonly || cpCompraReadonly) ? ' disabled' : '';
    return '<div class="' + colClass + '">' +
        '<label class="form-label">Referencia</label>' +
        '<select class="form-select cp-compra-field cp-compra-referencia-select" data-item-index="' + itemIndex + '" data-field="referencia_fornecedor"' + disabledAttr + '>' +
        selected +
        '</select>' +
        '</div>';
}

function initCpCompraReferenciaSelects() {
    if (cpCompraReadonly) {
        return;
    }

    $('.cp-compra-referencia-select').each(function () {
        const $select = $(this);
        if ($select.data('select2')) {
            return;
        }
        $select.select2({
            width: '100%',
            placeholder: 'Digite a referencia',
            allowClear: true,
            ajax: {
                url: window.cpComprasFormConfig.api,
                dataType: 'json',
                delay: 250,
                data: params => ({
                    action: 'options',
                    type: 'referencias',
                    fornecedor_id: $('#cp-compras-form [name="Fornecedor_id"]').val() || '',
                    q: params.term || ''
                }),
                processResults: response => ({ results: response.results || [] })
            }
        });
    });

    $('.cp-compra-referencia-select').off('select2:opening.cpReferencia').on('select2:opening.cpReferencia', function (event) {
        if (!$('#cp-compras-form [name="Fornecedor_id"]').val()) {
            event.preventDefault();
            appAlert('Informe o fornecedor antes de pesquisar referencias.', 'warning');
        }
    });

    $('.cp-compra-referencia-select').off('select2:select.cpReferencia').on('select2:select.cpReferencia', function (event) {
        const itemIndex = Number($(this).data('item-index'));
        const codigoReferencia = event.params.data.id;
        loadCpCompraReferenciaItem(itemIndex, codigoReferencia);
    });
}

function loadCpCompraReferenciaItem(itemIndex, codigoReferencia) {
    const fornecedorId = $('#cp-compras-form [name="Fornecedor_id"]').val();
    if (!fornecedorId) {
        appAlert('Informe o fornecedor antes de selecionar referencias.', 'warning');
        return;
    }

    syncCpCompraItensFromDom();
    $.getJSON(window.cpComprasFormConfig.api, {
        action: 'referencia',
        fornecedor_id: fornecedorId,
        codigo_referencia: codigoReferencia
    }).done(function (response) {
        const itemData = Object.assign(emptyCpCompraItem(false), response.data || {});
        itemData.item_confirmado = false;
        itemData._pendingDetalhes = itemData.detalhes || [];
        itemData.detalhes = [];
        cpCompraItens[itemIndex] = itemData;
        cpCompraItensOpen[itemIndex] = true;
        renderCpCompraItens();
        recalcCpCompraTotal();
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel carregar a referencia.', 'danger');
    });
}

function selectHtml(itemIndex, detailIndex, name, label, value, colClass, options) {
    const attr = cpDataAttrs(itemIndex, detailIndex, name);
    const opts = options.map(function (option) {
        const selected = String(option.id) === String(value) ? ' selected' : '';
        return '<option value="' + escapeHtml(option.id) + '"' + selected + '>' + escapeHtml(option.text) + '</option>';
    }).join('');
    const disabledAttr = cpCompraReadonly ? ' disabled' : '';
    return '<div class="' + colClass + '"><label class="form-label">' + label + '</label><select class="form-select cp-compra-field" ' + attr + disabledAttr + '>' + opts + '</select></div>';
}

function photoButtonHtml(itemIndex, item) {
    const hasPhoto = Number(item.Foto || 0) === 1;
    const isConfirmed = Boolean(item.item_confirmado);
    const label = isConfirmed ? (hasPhoto ? 'Ver fotos' : 'Inserir fotos') : 'Confirmar item';
    const badge = hasPhoto ? '<span class="badge text-bg-light ms-2">Sim</span>' : '<span class="badge text-bg-secondary ms-2">Nao</span>';
    const disabledAttr = isConfirmed ? '' : ' disabled';
    return '<div class="text-end cp-compra-item-photo" onclick="event.stopPropagation();">' +
        '<small class="text-muted d-block extra-small text-uppercase">Fotos</small>' +
        '<input type="hidden" class="cp-compra-field" value="' + (hasPhoto ? 1 : 0) + '" ' + cpDataAttrs(itemIndex, null, 'Foto') + '>' +
        '<button class="btn btn-sm btn-photo" type="button" onclick="openCpCompraFotos(' + itemIndex + ')"' + disabledAttr + '>' +
        label + badge +
        '</button>' +
        '</div>';
}

function openCpCompraFotos(itemIndex) {
    syncCpCompraItensFromDom();
    const $form = $('#cp-compras-form');
    const pedidoId = Number($form.data('id') || $form.find('[name="id"]').val() || 0);
    const fornecedorId = $form.find('[name="Fornecedor_id"]').val() || '';
    const item = cpCompraItens[itemIndex] || null;
    const referencia = item ? (item.referencia_fornecedor || '') : '';

    if (!pedidoId) {
        appAlert('Salve o pedido antes de inserir ou visualizar fotos.', 'warning');
        return;
    }
    if (!fornecedorId || !referencia) {
        appAlert('Informe fornecedor e referencia antes de acessar fotos.', 'warning');
        return;
    }

    cpCompraFotoItemIndex = itemIndex;
    $('#cp-foto-referencia').text(referencia);
    $('#cp-foto-input').val('').prop('disabled', cpCompraReadonly);
    $('#cp-foto-upload-block').toggleClass('d-none', cpCompraReadonly);
    $('#cp-fotos-list').html('<div class="text-center text-muted py-4">Carregando fotos...</div>');

    const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('cp-fotos-modal'));
    modal.show();
    loadCpCompraFotos();
}

function loadCpCompraFotos() {
    const context = cpCompraFotoContext();
    if (!context) {
        return;
    }

    $.getJSON(window.cpComprasFormConfig.api, {
        action: 'fotos_list',
        pedido_id: context.pedidoId,
        referencia: context.referencia,
        fornecedor_id: context.fornecedorId
    }).done(function (response) {
        renderCpCompraFotos(response.data || []);
        updateCpCompraFotoFlag(context.itemIndex, Number(response.count || 0) > 0 ? 1 : 0);
    }).fail(function (xhr) {
        $('#cp-fotos-list').html('<div class="alert alert-danger mb-0">' + escapeHtml(xhr.responseJSON?.message || 'Nao foi possivel carregar as fotos.') + '</div>');
    });
}

function uploadCpCompraFotos() {
    const context = cpCompraFotoContext();
    if (!context || cpCompraReadonly) {
        return;
    }

    const files = this.files || [];
    if (!files.length) {
        return;
    }

    const formData = new FormData();
    formData.append('pedido_id', context.pedidoId);
    formData.append('referencia', context.referencia);
    formData.append('fornecedor_id', context.fornecedorId);
    Array.from(files).forEach(function (file) {
        formData.append('fotos[]', file);
    });

    $('#cp-fotos-list').html('<div class="text-center text-muted py-4">Enviando fotos...</div>');
    $.ajax({
        url: window.cpComprasFormConfig.api + '?action=fotos_upload',
        method: 'POST',
        data: formData,
        dataType: 'json',
        processData: false,
        contentType: false
    }).done(function (response) {
        appAlert(response.message || 'Fotos inseridas.', 'success');
        updateCpCompraFotoFlag(context.itemIndex, 1);
        $('#cp-foto-input').val('');
        loadCpCompraFotos();
    }).fail(function (xhr) {
        $('#cp-fotos-list').html('<div class="alert alert-danger mb-0">' + escapeHtml(xhr.responseJSON?.message || 'Nao foi possivel inserir as fotos.') + '</div>');
    });
}

function deleteCpCompraFoto(fotoId) {
    const context = cpCompraFotoContext();
    if (!context || cpCompraReadonly) {
        return;
    }
    if (!confirm('Excluir esta foto?')) {
        return;
    }

    $.post(window.cpComprasFormConfig.api + '?action=fotos_delete', {
        pedido_id: context.pedidoId,
        referencia: context.referencia,
        fornecedor_id: context.fornecedorId,
        foto_id: fotoId
    }, function (response) {
        appAlert(response.message || 'Foto excluida.', 'success');
        updateCpCompraFotoFlag(context.itemIndex, Number(response.count || 0) > 0 ? 1 : 0);
        loadCpCompraFotos();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Nao foi possivel excluir a foto.', 'danger');
    });
}

function cpCompraFotoContext() {
    const $form = $('#cp-compras-form');
    const itemIndex = cpCompraFotoItemIndex;
    const item = cpCompraItens[itemIndex] || null;
    if (!item) {
        return null;
    }
    return {
        itemIndex: itemIndex,
        pedidoId: Number($form.data('id') || $form.find('[name="id"]').val() || 0),
        fornecedorId: $form.find('[name="Fornecedor_id"]').val() || '',
        referencia: item.referencia_fornecedor || ''
    };
}

function renderCpCompraFotos(fotos) {
    const $list = $('#cp-fotos-list');
    $('#cp-foto-count').text(fotos.length + (fotos.length === 1 ? ' foto' : ' fotos'));
    if (!fotos.length) {
        $list.html('<div class="text-center text-muted py-4">Nenhuma foto inserida para esta referencia.</div>');
        return;
    }

    $list.html(fotos.map(function (foto) {
        const deleteButton = cpCompraReadonly ? '' :
            '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only cp-foto-delete" title="Excluir" aria-label="Excluir" type="button" onclick="deleteCpCompraFoto(' + Number(foto.id || 0) + ')"></button>';
        return '<figure class="cp-foto-card">' +
            '<img src="' + escapeAttr(foto.src || '') + '" alt="Foto ' + escapeAttr(foto.Sequencia || '') + '">' +
            '<figcaption><span>Foto ' + escapeHtml(foto.Sequencia || '') + '</span>' + deleteButton + '</figcaption>' +
            '</figure>';
    }).join(''));
}

function updateCpCompraFotoFlag(itemIndex, value) {
    if (!cpCompraItens[itemIndex]) {
        return;
    }
    cpCompraItens[itemIndex].Foto = value;
    $('.cp-compra-field[data-item-index="' + itemIndex + '"][data-field="Foto"]').val(value);
    const $button = $('.cp-compra-item[data-item-index="' + itemIndex + '"] .btn-photo');
    if ($button.length) {
        $button.html((value ? 'Ver fotos' : 'Inserir fotos') + (value ? '<span class="badge text-bg-light ms-2">Sim</span>' : '<span class="badge text-bg-secondary ms-2">Nao</span>'));
    }
}

function itemStatusReadonlyHtml(itemIndex, value, colClass) {
    const statusValue = String(value) === '0' ? 0 : 1;
    const statusText = statusValue === 1 ? 'Ativo' : 'Inativo';
    return '<div class="' + colClass + '">' +
        '<label class="form-label">Status</label>' +
        '<input class="form-control" value="' + statusText + '" readonly>' +
        '<input type="hidden" class="cp-compra-field" value="' + statusValue + '" ' + cpDataAttrs(itemIndex, null, 'Sts') + '>' +
        '</div>';
}

function detailInput(itemIndex, detailIndex, name, value, type, step, readonly) {
    const isMoney = type === 'money';
    const inputType = isMoney ? 'text' : (type || 'text');
    const stepAttr = step ? ' step="' + step + '"' : '';
    const readonlyAttr = (readonly || cpCompraReadonly) ? ' readonly' : '';
    const inputModeAttr = inputType === 'number' ? ' inputmode="numeric"' : (isMoney ? ' inputmode="numeric"' : '');
    const className = 'form-control form-control-sm cp-compra-field' + (isMoney ? ' cp-money-field text-end' : '');
    const displayValue = isMoney ? formatMoneyInput(value || 0) : escapeAttr(value || '');
    return '<input class="' + className + '" type="' + inputType + '"' + stepAttr + inputModeAttr + readonlyAttr + ' value="' + displayValue + '" ' + cpDataAttrs(itemIndex, detailIndex, name) + '>';
}

function detailStatusSelect(itemIndex, detailIndex, value) {
    const activeSelected = String(value) !== '0' ? ' selected' : '';
    const inactiveSelected = String(value) === '0' ? ' selected' : '';
    return '<select class="form-select form-select-sm cp-compra-field" ' + cpDataAttrs(itemIndex, detailIndex, 'Sts') + ' disabled>' +
        '<option value="1"' + activeSelected + '>Ativo</option>' +
        '<option value="0"' + inactiveSelected + '>Inativo</option>' +
        '</select>';
}

function initCpCompraDetalheFields() {
    $('.cp-compra-detalhes-table input.cp-compra-field').off('focus.cpDetalhe').on('focus.cpDetalhe', function () {
        this.select();
    });

    $('.cp-money-field').off('input.cpMoney').on('input.cpMoney', function () {
        this.value = formatMoneyInput(this.value);
        updateCpCompraDetalheFromField($(this));
    });

    $('.cp-compra-detalhes-table [data-field="Qtde"], .cp-compra-detalhes-table [data-field="preco_proposta"]')
        .off('input.cpRecalc change.cpRecalc')
        .on('input.cpRecalc change.cpRecalc', function () {
            updateCpCompraDetalheFromField($(this));
        });

    $('.cp-compra-detalhes-table [data-field="Sts"]')
        .off('change.cpStatus')
        .on('change.cpStatus', function () {
            updateCpCompraDetalheFromField($(this));
        });
}

function updateCpCompraDetalheFromField($field) {
    const itemIndex = Number($field.data('item-index'));
    const detailIndex = Number($field.attr('data-detail-index'));
    const name = $field.data('field');
    if (!cpCompraItens[itemIndex] || !cpCompraItens[itemIndex].detalhes[detailIndex]) {
        return;
    }

    cpCompraItens[itemIndex].detalhes[detailIndex][name] = normalizeCpCompraValue(name, $field.val());
    recalcCpCompraItem(cpCompraItens[itemIndex]);

    const detail = cpCompraItens[itemIndex].detalhes[detailIndex];
    const $row = $field.closest('tr');
    $row.find('[data-field="valor_total_produto"]').val(formatMoneyInput(detail.valor_total_produto || 0));
    updateCpCompraItemTotalDisplay(itemIndex);
    $('#cp-compras-form [name="ValorTotalPedido"]').val(roundCpMoney(sumCpCompraTotal()).toFixed(2));
}

function updateCpCompraItemTotalDisplay(itemIndex) {
    const item = cpCompraItens[itemIndex] || null;
    if (!item) {
        return;
    }
    const total = roundCpMoney(item.total_produto || 0);
    const $item = $('.cp-compra-item[data-item-index="' + itemIndex + '"]');
    $item.find('[data-field="total_produto"]').val(total.toFixed(2));
    $item.find('.cp-compra-item-total').text('R$ ' + formatMoneyBr(total));
}

function cpLocalizacaoBadge(localizacao) {
    const value = localizacao || 'KidStok';
    const className = value === 'KidStok' ? 'badge-localizacao-kidstok' :
        value === 'Fornecedor' ? 'badge-localizacao-fornecedor' : 'badge-localizacao-allop';
    return '<span class="badge cp-localizacao-badge ' + className + '">' + escapeHtml(value) + '</span>';
}

function cpDataAttrs(itemIndex, detailIndex, name) {
    const detail = detailIndex === null ? '' : ' data-detail-index="' + detailIndex + '"';
    return 'data-item-index="' + itemIndex + '"' + detail + ' data-field="' + name + '"';
}

function addCpCompraDetalhe(itemIndex) {
    syncCpCompraItensFromDom();
    if (!cpCompraItens[itemIndex] || !cpCompraItens[itemIndex].item_confirmado) {
        appAlert('Confirme o item antes de inserir subitens.', 'warning');
        return;
    }
    cpCompraItensOpen[itemIndex] = true;
    cpCompraItens[itemIndex].detalhes.push(emptyCpCompraDetalhe());
    renderCpCompraItens();
}

function confirmCpCompraItem(itemIndex) {
    syncCpCompraItensFromDom();
    const item = cpCompraItens[itemIndex] || null;
    if (!item) {
        return;
    }
    if (!item.referencia_fornecedor) {
        appAlert('Selecione a referencia antes de confirmar o item.', 'warning');
        return;
    }

    item.item_confirmado = true;
    item.detalhes = (item._pendingDetalhes && item._pendingDetalhes.length) ? item._pendingDetalhes : item.detalhes;
    item._pendingDetalhes = [];
    cpCompraItensOpen[itemIndex] = true;
    recalcCpCompraItem(item);
    renderCpCompraItens();
    recalcCpCompraTotal();
}

function removeCpCompraItem(itemIndex) {
    syncCpCompraItensFromDom();
    cpCompraItens.splice(itemIndex, 1);
    cpCompraItensOpen = {};
    renderCpCompraItens();
    recalcCpCompraTotal();
}

function removeCpCompraDetalhe(itemIndex, detailIndex) {
    syncCpCompraItensFromDom();
    cpCompraItens[itemIndex].detalhes.splice(detailIndex, 1);
    renderCpCompraItens();
    recalcCpCompraTotal();
}

function syncCpCompraItensFromDom() {
    $('.cp-compra-field').each(function () {
        const $field = $(this);
        const itemIndex = Number($field.data('item-index'));
        const detailIndexRaw = $field.attr('data-detail-index');
        const name = $field.data('field');
        const value = $field.val();
        if (!cpCompraItens[itemIndex]) {
            return;
        }
        if (detailIndexRaw !== undefined) {
            const detailIndex = Number(detailIndexRaw);
            cpCompraItens[itemIndex].detalhes[detailIndex][name] = normalizeCpCompraValue(name, value);
            return;
        }
        cpCompraItens[itemIndex][name] = normalizeCpCompraValue(name, value);
    });

    cpCompraItens.forEach(function (item) {
        item.detalhes.sort(function (a, b) {
            return String(a.tamanho || '').localeCompare(String(b.tamanho || ''), 'pt-BR', { numeric: true }) ||
                String(a.cor || '').localeCompare(String(b.cor || ''), 'pt-BR');
        });
        recalcCpCompraItem(item);
    });
}

function normalizeCpCompraValue(name, value) {
    if (name === 'Qtde') {
        return parseInt(String(value || '0').replace(/\D/g, ''), 10) || 0;
    }
    const moneyColumns = ['preco_fornecedor', 'preco_proposta', 'valor_total_produto', 'preco_franqueado', 'preco_loja'];
    if (moneyColumns.includes(name)) {
        return parseMoneyInput(value);
    }
    const numeric = ['total_qtde', 'total_produto', 'Foto', 'Sts', 'markup_franquia', 'markup_loja', 'markup_total'];
    if (numeric.includes(name)) {
        return Number(String(value || '0').replace(',', '.')) || 0;
    }
    return value || '';
}

function recalcCpCompraItem(item) {
    let total = 0;
    (item.detalhes || []).forEach(function (detail) {
        detail.valor_total_produto = roundCpMoney(Number(detail.Qtde || 0) * Number(detail.preco_proposta || 0));
        total += Number(detail.valor_total_produto || 0);
    });
    item.total_produto = roundCpMoney(total);
}

function recalcCpCompraTotal() {
    syncCpCompraItensFromDom();
    $('#cp-compras-form [name="ValorTotalPedido"]').val(roundCpMoney(sumCpCompraTotal()).toFixed(2));
}

function sumCpCompraTotal() {
    let total = 0;
    cpCompraItens.forEach(function (item) {
        total += Number(item.total_produto || 0);
    });
    return total;
}

function parseMoneyInput(value) {
    if (typeof value === 'number') {
        return value;
    }
    const raw = String(value || '').replace(/\D/g, '');
    if (raw === '') {
        return 0;
    }
    return Number(raw) / 100;
}

function formatMoneyInput(value) {
    return parseMoneyInput(value).toLocaleString('pt-BR', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

function validarCpCompraForm($form) {
    if (!$form.find('[name="cd_id"]').val()) {
        return 'Informe o CD.';
    }
    if (!$form.find('[name="empresa_id"]').val()) {
        return 'Informe a empresa.';
    }
    if (!$form.find('[name="Fornecedor_id"]').val()) {
        return 'Informe o fornecedor.';
    }
    if (!$form.find('[name="DataPedido"]').val()) {
        return 'Informe a data do pedido.';
    }
    if (!cpCompraItens.length) {
        return 'Informe ao menos um item.';
    }
    const unconfirmedIndex = cpCompraItens.findIndex(function (item) {
        return !item.item_confirmado;
    });
    if (unconfirmedIndex >= 0) {
        return 'Confirme ou exclua o item ' + (unconfirmedIndex + 1) + ' antes de salvar.';
    }
    return '';
}

function roundCpMoney(value) {
    return Math.round((Number(value) || 0) * 100) / 100;
}

function formatDateBr(value) {
    if (!value) {
        return '';
    }
    const parts = String(value).split('-');
    if (parts.length !== 3) {
        return value;
    }
    return parts[2] + '/' + parts[1] + '/' + parts[0];
}

function formatMoneyBr(value) {
    return Number(value || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}
