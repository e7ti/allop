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
    if (window.cpComprasFormConfig && $('#cp-compras-form').length) {
        appOkAlert(message, appAlertTitle(type));
        return;
    }

    const $alert = $('#app-alert');
    $alert.removeClass('d-none alert-success alert-danger alert-warning alert-info');
    $alert.addClass('alert-' + (type || 'info')).text(message);
}

function appAlertTitle(type) {
    const titles = {
        success: 'Sucesso',
        danger: 'Atenção',
        warning: 'Aviso',
        info: 'Informação'
    };
    return titles[type || 'info'] || 'Aviso';
}

function appOkAlert(message, title, onClose) {
    if (typeof bootstrap === 'undefined' || !bootstrap.Modal) {
        alert(message);
        if (typeof onClose === 'function') {
            onClose();
        }
        return;
    }

    let $modal = $('#app-ok-alert-modal');
    if (!$modal.length) {
        $('body').append(
            '<div class="modal fade" id="app-ok-alert-modal" tabindex="-1" aria-hidden="true">' +
            '<div class="modal-dialog modal-dialog-centered">' +
            '<div class="modal-content">' +
            '<div class="modal-header">' +
            '<h5 class="modal-title"></h5>' +
            '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>' +
            '</div>' +
            '<div class="modal-body"></div>' +
            '<div class="modal-footer">' +
            '<button type="button" class="btn btn-orange" data-bs-dismiss="modal">OK</button>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>'
        );
        $modal = $('#app-ok-alert-modal');
    }

    $modal.find('.modal-title').text(title || 'Aviso');
    $modal.find('.modal-body').text(message);
    $modal.off('hidden.bs.modal.appOkAlert');
    if (typeof onClose === 'function') {
        $modal.one('hidden.bs.modal.appOkAlert', onClose);
    }
    bootstrap.Modal.getOrCreateInstance($modal[0]).show();
}

function apiPost(url, data) {
    return $.ajax({
        url: url,
        method: 'POST',
        data: data,
        dataType: 'json'
    });
}

function setFormSaving($form, saving, buttonSelector) {
    const $button = buttonSelector ? $(buttonSelector) : $form.find('.btn-save[type="submit"], .btn-save-main[type="submit"]').first();
    $form.data('saving', saving === true);

    if (!$button.length) {
        return;
    }

    if ($button.data('original-html') === undefined) {
        $button.data('original-html', $button.html());
    }

    $button.prop('disabled', saving === true);
    $button.toggleClass('app-saving cp-saving', saving === true);

    if (saving === true) {
        $button.html('<span class="spinner-border spinner-border-sm me-2" aria-hidden="true"></span>Salvando...');
    } else {
        $button.html($button.data('original-html'));
    }
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
            return '<tr>' + cells + '<td data-label="Ações" class="text-end">' +
                '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteRow(' + row.id + ')"></button>' +
                '</td></tr>';
        }).join('');
        $('#grid').html(html || '<tr><td colspan="8" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível carregar os dados.', 'danger');
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
        return '<span class="badge bg-danger-subtle">Não</span>';
    }
    return $('<div>').text(value).html();
}

function deleteRow(id) {
    if (!confirm('Excluir este registro?')) {
        return;
    }
    apiPost(crudUrl(window.gridConfig.entity, 'delete'), { id: id }).done(function (response) {
        appAlert(response.message || 'Registro excluído.', 'success');
        loadGrid();
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível excluir.', 'danger');
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
        appAlert(xhr.responseJSON?.message || 'Não foi possível carregar o registro.', 'danger');
    });
}

function saveForm($form) {
    if ($form.data('saving') === true) {
        return;
    }

    const data = $form.serializeArray();
    $form.find('input[type="checkbox"]').each(function () {
        if (!this.checked) {
            data.push({ name: this.name, value: 0 });
        }
    });
    setFormSaving($form, true);
    apiPost(crudUrl($form.data('entity'), 'save'), $.param(data)).done(function (response) {
        appAlert(response.message || 'Registro salvo.', 'success');
        if (response.id && Number($form.data('id')) === 0) {
            $form.find('[name="id"]').val(response.id);
            $form.data('id', response.id);
        }
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível salvar.', 'danger');
    }).always(function () {
        setFormSaving($form, false);
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
                    '<td data-label="Total Permissões">' + escapeHtml(row.total_permissoes || '0') + '</td>' +
                    '<td data-label="Ações" class="text-end">' +
                    '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="perfil_aplicacoes_form.php?perfil_id=' + row.perfil_id + '"></a>' +
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deletePerfilAplicacoes(' + row.perfil_id + ')"></button>' +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#perfil-aplicacoes-grid').html(html || '<tr><td colspan="3" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Não foi possível carregar os dados.', 'danger');
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
    if (!confirm('Excluir as permissões deste perfil?')) {
        return;
    }

    $.post(window.perfilAplicacoesListaConfig.api + '?action=delete_profile', { perfil_id: perfilId }, function (response) {
        appAlert(response.message || 'Permissões excluídas.', 'success');
        loadPerfilAplicacoesLista();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível excluir.', 'danger');
    });
}

function loadPerfilAplicacoes() {
    const perfilId = $('#perfil_id').val();
    const $empty = $('#perfil-apps-empty');
    const $accordion = $('#perfil-apps-accordion');
    const $save = $('#btn-salvar-perfil-apps');

    if (!perfilId) {
        $accordion.addClass('d-none').empty();
    $empty.removeClass('d-none').text('Selecione um perfil para carregar as aplicações e suas permissões.');
        $save.prop('disabled', true);
        return;
    }

    $accordion.addClass('d-none').empty();
    $empty.removeClass('d-none').text('Carregando permissões...');
    $save.prop('disabled', true);

    $.getJSON(window.perfilAplicacoesConfig.api, { action: 'list', perfil_id: perfilId })
        .done(function (response) {
            const rows = response.data || [];
            if (!rows.length) {
                $empty.removeClass('d-none').text('Nenhuma aplicação cadastrada.');
                return;
            }

            $accordion.html(renderPerfilAplicacoesAccordion(rows)).removeClass('d-none');
            $empty.addClass('d-none').text('');
            $save.prop('disabled', false);
        })
        .fail(function (xhr) {
            $empty.removeClass('d-none').text(xhr.responseJSON?.message || 'Não foi possível carregar as permissões.');
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
            '<th>Aplicação / Modulo</th>' +
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
        '<td data-label="Aplicação"><strong>' + escapeHtml(row.aplicacao_nome || '') + '</strong><span class="permission-route">' + escapeHtml(row.rota || '') + '</span></td>' +
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
    const $button = $('#btn-salvar-perfil-apps');
    if ($button.data('saving') === true) {
        return;
    }

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

    const $state = $('<div></div>');
    $button.data('saving', true);
    setFormSaving($state, true, $button);

    $.post(window.perfilAplicacoesConfig.api + '?action=save', {
        perfil_id: perfilId,
        permissions: JSON.stringify(permissions)
    }, function (response) {
        appAlert(response.message || 'Permissões salvas.', 'success');
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível salvar as permissões.', 'danger');
    }).always(function () {
        $button.data('saving', false);
        setFormSaving($state, false, $button);
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
                    '<td data-label="Ações" class="text-end">' +
                    '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteConfiguracoesEmail(' + row.id + ')"></button>' +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#configuracoes-email-grid').html(html || '<tr><td colspan="7" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Não foi possível carregar os dados.', 'danger');
        });
}

function deleteConfiguracoesEmail(id) {
    if (!confirm('Excluir este registro?')) {
        return;
    }

    $.post(window.configuracoesEmailListaConfig.api + '?action=delete', { id: id }, function (response) {
        appAlert(response.message || 'Registro excluído.', 'success');
        loadConfiguracoesEmailGrid();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível excluir.', 'danger');
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
                appAlert(xhr.responseJSON?.message || 'Não foi possível carregar o registro.', 'danger');
            });
    }

    $form.on('submit', function (event) {
        event.preventDefault();
        if ($form.data('saving') === true) {
            return;
        }
        setFormSaving($form, true);
        $.post(window.configuracoesEmailFormConfig.api + '?action=save', $form.serialize(), function (response) {
            appAlert(response.message || 'Registro salvo.', 'success');
            if (response.id && Number($form.data('id')) === 0) {
                $form.find('[name="id"]').val(response.id);
                $form.data('id', response.id);
            }
        }, 'json').fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Não foi possível salvar.', 'danger');
        }).always(function () {
            setFormSaving($form, false);
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
                    '<td data-label="Código">' + escapeHtml(row.Codigo || '') + '</td>' +
                    '<td data-label="Nome CD">' + escapeHtml(row.NomeCD || '') + '</td>' +
                    '<td data-label="Status">' + escapeHtml(row.Status || '') + '</td>' +
                    '<td data-label="Ações" class="text-end">' +
                    '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteEmpresasCd(' + row.id + ')"></button>' +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#empresas-cd-grid').html(html || '<tr><td colspan="4" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Não foi possível carregar os dados.', 'danger');
        });
}

function deleteEmpresasCd(id) {
    if (!confirm('Excluir este registro?')) {
        return;
    }

    $.post(window.empresasCdListaConfig.api + '?action=delete', { id: id }, function (response) {
        appAlert(response.message || 'Registro excluído.', 'success');
        loadEmpresasCdGrid();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível excluir.', 'danger');
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
                appAlert(xhr.responseJSON?.message || 'Não foi possível carregar o registro.', 'danger');
            });
    }

    $form.on('submit', function (event) {
        event.preventDefault();
        if ($form.data('saving') === true) {
            return;
        }
        setFormSaving($form, true);
        $.post(window.empresasCdFormConfig.api + '?action=save', $form.serialize(), function (response) {
            appAlert(response.message || 'Registro salvo.', 'success');
            if (response.id && Number($form.data('id')) === 0) {
                $form.find('[name="id"]').val(response.id);
                $form.find('[name="Codigo"]').val(response.id);
                $form.data('id', response.id);
            }
        }, 'json').fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Não foi possível salvar.', 'danger');
        }).always(function () {
            setFormSaving($form, false);
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
                    '<td data-label="Código">' + escapeHtml(row.Codigo || '') + '</td>' +
                    '<td data-label="Fantasia">' + escapeHtml(row.Fantasia || '') + '</td>' +
                    '<td data-label="CNPJ">' + escapeHtml(formatCnpj(row.CNPJ || '')) + '</td>' +
                    '<td data-label="Cidade/UF">' + escapeHtml([row.Cidade, row.UF].filter(Boolean).join('/')) + '</td>' +
                    '<td data-label="Código IBGE">' + escapeHtml(row.ibge || '') + '</td>' +
                    '<td data-label="Status">' + escapeHtml(row.Status || '') + '</td>' +
                    '<td data-label="Ações" class="text-end">' +
                    '<a class="btn btn-sm btn-outline-secondary btn-edit btn-icon-only me-1" title="Editar" aria-label="Editar" href="' + cfg.form + '?id=' + row.id + '"></a>' +
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" onclick="deleteEmpresa(' + row.id + ')"></button>' +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#empresas-grid').html(html || '<tr><td colspan="7" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Não foi possível carregar os dados.', 'danger');
        });
}

function deleteEmpresa(id) {
    if (!confirm('Excluir este registro?')) {
        return;
    }

    $.post(window.empresasListaConfig.api + '?action=delete', { id: id }, function (response) {
        appAlert(response.message || 'Registro excluído.', 'success');
        loadEmpresasGrid();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível excluir.', 'danger');
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
                appAlert(xhr.responseJSON?.message || 'Não foi possível carregar o registro.', 'danger');
            });
    }

    $form.on('submit', function (event) {
        event.preventDefault();
        if ($form.data('saving') === true) {
            return;
        }
        const message = validarEmpresaForm($form);
        if (message) {
            appAlert(message, 'danger');
            return;
        }

        setFormSaving($form, true);
        $.post(window.empresasFormConfig.api + '?action=save', $form.serialize(), function (response) {
            appAlert(response.message || 'Registro salvo.', 'success');
            if (response.id && Number($form.data('id')) === 0) {
                $form.find('[name="id"]').val(response.id);
                $form.find('[name="Codigo"]').val(response.id);
                $form.data('id', response.id);
            }
        }, 'json').fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Não foi possível salvar.', 'danger');
        }).always(function () {
            setFormSaving($form, false);
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
        return 'Informe um CNPJ válido.';
    }
    if (cep && cep.length !== 8) {
        return 'CEP deve conter 8 dígitos.';
    }
    if (ibge && ibge.length !== 7) {
        return 'Código IBGE deve conter 7 dígitos.';
    }
    if (ddds.some(ddd => ddd && onlyDigits(ddd).length !== 2)) {
        return 'DDD deve conter 2 dígitos.';
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
                appAlert('CEP não encontrado.', 'warning');
                return;
            }
            $form.find('[name="TipoEndereco"]').val((data.logradouro || '').split(' ')[0] || '');
            $form.find('[name="Endereco"]').val(data.logradouro || '');
            $form.find('[name="Bairro"]').val(data.bairro || '');
            $form.find('[name="Cidade"]').val(data.localidade || '');
            $form.find('[name="UF"]').val(data.uf || '').trigger('change');
            $form.find('[name="ibge"]').val(data.ibge || '');
        })
        .catch(() => appAlert('Não foi possível consultar o CEP.', 'warning'));
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
let cpCompraStatusIdAtual = 0;
let cpCompraStatusDescricaoAtual = 'Aberto';
let cpCompraFotoItemIndex = null;
let cpCompraFotoOrigem = 'kidstok';
let cpCompraRateioContext = null;

function cpLocalizacaoEhFornecedor(localizacao) {
    return String(localizacao || '').trim().toLocaleLowerCase() === 'fornecedor';
}

function cpCompraStatusKey(value) {
    return String(value || '').trim().toLocaleLowerCase();
}

function cpCompraStatusAguardandoFoto(statusId, statusDescricao) {
    const key = cpCompraStatusKey(statusDescricao);
    return Number(statusId || 0) === 1 ||
        key === 'aprovado aguardando foto fornecedor' ||
        key === 'aprovado aguardando foto' ||
        key === 'aprovado sem fotos';
}

function cpCompraStatusFinalBloqueado(statusId, statusDescricao) {
    const key = cpCompraStatusKey(statusDescricao);
    return Number(statusId || 0) === 2 ||
        Number(statusId || 0) === 3 ||
        key === 'aprovado' ||
        key === 'recusado';
}

function cpCompraPedidoSomenteVisualizacao(row) {
    const statusId = Number(row.status_id || 0);
    const statusDescricao = row.descricao_compras || row.Sts || '';
    return cpLocalizacaoEhFornecedor(row.Localizacao) ||
        cpCompraStatusFinalBloqueado(statusId, statusDescricao) ||
        cpCompraStatusAguardandoFoto(statusId, statusDescricao);
}

function cpCompraPodeAlterarFoto(origem) {
    origem = origem === 'fornecedor' ? 'fornecedor' : 'kidstok';
    if (origem === 'fornecedor') {
        return false;
    }
    if (cpCompraStatusFinalBloqueado(cpCompraStatusIdAtual, cpCompraStatusDescricaoAtual)) {
        return false;
    }
    if (cpCompraStatusAguardandoFoto(cpCompraStatusIdAtual, cpCompraStatusDescricaoAtual)) {
        return !cpLocalizacaoEhFornecedor(cpCompraReadonlyLocalizacao);
    }
    return !cpCompraReadonly;
}

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
                    text: cpCompraListaOptionText(row)
                }))
            })
        }
    });

    loadCpComprasGrid();
    $('#btn-filtrar-cp-compras').on('click', loadCpComprasGrid);
}

function cpCompraListaOptionText(row) {
    const fornecedorCodigo = row.fornecedor_codigo || '';
    const fornecedorNome = row.fornecedor_nome || '';
    const fornecedor = fornecedorCodigo && fornecedorNome && fornecedorCodigo !== fornecedorNome
        ? fornecedorCodigo + ' - ' + fornecedorNome
        : (fornecedorNome || fornecedorCodigo || 'Não informado');
    const statusDescricao = row.descricao_compras || row.Sts || '';
    const status = statusDescricao ? ' - Status: ' + statusDescricao : '';
    return 'Pedido ' + (row.ID || row.id || '') + ' - Fornecedor: ' + fornecedor + status;
}

function loadCpComprasGrid() {
    const cfg = window.cpComprasListaConfig;
    const selected = $('#filtro-cp-compras').select2('data')[0] || null;
    $.getJSON(cfg.api, { action: 'list', q: selected && selected.id ? selected.text : '' })
        .done(function (response) {
            const rows = response.data || [];
            const html = rows.map(function (row) {
                const localizacao = row.Localizacao || 'KidStok';
                const canEdit = localizacao === 'KidStok' &&
                    !cpCompraStatusFinalBloqueado(row.status_id, row.descricao_compras || row.Sts) &&
                    !cpCompraStatusAguardandoFoto(row.status_id, row.descricao_compras || row.Sts);
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
                    '<td data-label="Localização">' + cpLocalizacaoBadge(localizacao) + '</td>' +
                    '<td data-label="Publicado">' + cpPublicadoBadge(row.Publicado) + '</td>' +
                    '<td data-label="Total">' + escapeHtml(formatMoneyBr(row.ValorTotalPedido || 0)) + '</td>' +
                    '<td data-label="Status">' + cpPedidoStatusBadge(row.descricao_compras || row.Sts, localizacao) + '</td>' +
                    '<td data-label="Ações" class="text-end">' +
                    actions +
                    '</td>' +
                    '</tr>';
            }).join('');
            $('#cp-compras-grid').html(html || '<tr><td colspan="10" class="text-center text-muted">Nenhum registro encontrado.</td></tr>');
        })
        .fail(function (xhr) {
            appAlert(xhr.responseJSON?.message || 'Não foi possível carregar os pedidos.', 'danger');
        });
}

function deleteCpCompra(id) {
    if (!confirm('Excluir este pedido?')) {
        return;
    }

    $.post(window.cpComprasListaConfig.api + '?action=delete', { id: id }, function (response) {
        appAlert(response.message || 'Pedido excluído.', 'success');
        loadCpComprasGrid();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível excluir.', 'danger');
    });
}

function initCpComprasForm() {
    const $form = $('#cp-compras-form');
    const id = Number($form.data('id'));
    cpCompraReadonly = false;
    cpCompraReadonlyLocalizacao = '';
    cpCompraStatusIdAtual = 0;
    cpCompraStatusDescricaoAtual = 'Aberto';

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
        const markupFranquia = event.params.data.markup_compra;
        const markupFranqueadora = event.params.data.markup_franqueadora;
        if (markupFranquia !== undefined && markupFranquia !== null && markupFranquia !== '') {
            $form.find('[name="MarkupFranquia"]').val(formatMoneyInput(markupFranquia || 0));
        }
        if (markupFranqueadora !== undefined && markupFranqueadora !== null && markupFranqueadora !== '') {
            $form.find('[name="MarkupFranqueadora"]').val(formatMoneyInput(markupFranqueadora || 0));
        }
        if ((markupFranquia !== undefined && markupFranquia !== null && markupFranquia !== '') ||
            (markupFranqueadora !== undefined && markupFranqueadora !== null && markupFranqueadora !== '')) {
            recalcCpCompraMarkupTotal($form);
            applyCpCompraHeaderMarkupsToItens();
        }
    });

    initCpCompraHeaderMoney($form);

    $('#btn-add-cp-item').on('click', function () {
        if (!$form.find('[name="Fornecedor_id"]').val()) {
            appAlert('Informe o fornecedor antes de adicionar itens.', 'warning');
            return;
        }
        syncCpCompraItensFromDom();
        cpCompraItens.forEach(function (_item, index) {
            cpCompraItensOpen[index] = false;
        });
        cpCompraItens.push(emptyCpCompraItem(false));
        const itemIndex = cpCompraItens.length - 1;
        cpCompraItensOpen[itemIndex] = true;
        renderCpCompraItens();
        focusCpCompraItemEditor(itemIndex, true);
    });

    $('#btn-cp-enviar-proposta').on('click', function () {
        enviarCpCompraProposta($form);
    });

    $('#btn-cp-aprovar').on('click', function () {
        executarCpCompraWorkflow($form, 'aprovar', 'Aprovar este pedido?');
    });

    $('#btn-cp-recusar').on('click', function () {
        mostrarPainelRecusa($form);
    });

    $('#btn-cp-cancelar-recusa').on('click', function () {
        ocultarPainelRecusa($form, true);
    });

    $('#btn-cp-confirmar-recusa').on('click', function () {
        confirmarRecusa($form);
    });

    $('#cp-foto-input').on('change', uploadCpCompraFotos);
    $('#btn-aplicar-cp-rateio').on('click', aplicarCpCompraRateio);
    $('#cp-rateio-modal').on('input', '.cp-rateio-percentual, .cp-rateio-qtde, #cp-rateio-qtde-total', updateCpCompraRateioModalTotal);
    $form.on('focusin', 'input', function () {
        selectCpCompraInputContent(this);
    });
    $('#cp-rateio-modal').on('focusin', 'input', function () {
        selectCpCompraInputContent(this);
    });
    $form.on('keydown', 'input, select', function (event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            moveCpCompraFocusToNextField(this);
        }
    });
    $form.on('click', '.cp-compra-item-header button, .cp-compra-tamanho-header button, .cp-compra-cor-header button', function (event) {
        event.stopPropagation();
    });

    $form.on('shown.bs.collapse hidden.bs.collapse', '.cp-compra-item-collapse', function (event) {
        cpCompraItensOpen[$(this).data('item-index')] = event.type === 'shown';
    });
    $form.on('shown.bs.collapse hidden.bs.collapse', '.cp-compra-tamanho-collapse', function (event) {
        const item = cpCompraItens[Number($(this).data('item-index'))];
        const tamanho = item?.tamanhos?.[Number($(this).data('size-index'))];
        if (tamanho) {
            tamanho._aberto = event.type === 'shown';
        }
    });
    $form.on('shown.bs.collapse hidden.bs.collapse', '.cp-compra-cor-collapse', function (event) {
        const item = cpCompraItens[Number($(this).data('item-index'))];
        const tamanho = item?.tamanhos?.[Number($(this).data('size-index'))];
        const cor = tamanho?.cores?.[Number($(this).data('color-index'))];
        if (cor) {
            cor._aberto = event.type === 'shown';
        }
    });

    if (id > 0) {
        $.getJSON(window.cpComprasFormConfig.api, { action: 'get', id: id })
            .done(function (response) {
                const row = response.data || {};
                fillCpCompraHeader($form, row);
                cpCompraReadonlyLocalizacao = row.Localizacao || 'KidStok';
                cpCompraStatusIdAtual = Number(row.status_id || 0);
                cpCompraStatusDescricaoAtual = row.descricao_compras || row.Sts || 'Aberto';
                cpCompraReadonly = cpCompraPedidoSomenteVisualizacao(row);
                cpCompraItens = (row.items || []).map(mapCpCompraItemFromApi);
                cpCompraItensOpen = {};
                applyCpCompraReadonly($form);
                updateCpCompraWorkflowButtons(row);
                renderCpCompraItens();
                recalcCpCompraTotal();
            })
            .fail(function (xhr) {
                appAlert(xhr.responseJSON?.message || 'Não foi possível carregar o pedido.', 'danger');
            });
    } else {
        $form.find('[name="DataPedido"]').val(new Date().toISOString().slice(0, 10));
        $form.find('[name="Sts"]').val('Aberto');
        $form.find('[name="Sts_display"]').val('Aberto');
        cpCompraStatusIdAtual = 0;
        cpCompraStatusDescricaoAtual = 'Aberto';
        $form.find('[name="Publicado"]').val('0');
        $form.find('[name="Publicado_display"]').val(formatPublicadoCpCompra(0));
        $form.find('[name="Localizacao"]').val('KidStok');
        $form.find('[name="Localizacao_display"]').val('KidStok');
        toggleCpCompraMotivo($form);
        loadCpCompraDefaults($form);
        cpCompraItens = [];
        cpCompraItensOpen = {};
        updateCpCompraWorkflowButtons({ Localizacao: 'KidStok', Sts: 'Aberto' });
        renderCpCompraItens();
        focusCpCompraFornecedor($form);
    }

    $form.on('submit', function (event) {
        event.preventDefault();
        if (cpCompraReadonly) {
            appAlert('Pedido disponível apenas para visualização conforme status/localização atual.', 'warning');
            return;
        }
        salvarCpCompraForm($form, function (response) {
            appOkAlert(response.message || 'Pedido salvo.', 'Pedido de Compra');
            collapseCpCompraItens();
        });
    });
}

function salvarCpCompraForm($form, done) {
    if ($form.data('saving') === true) {
        return;
    }
    syncCpCompraItensFromDom();
    const message = validarCpCompraForm($form);
    if (message) {
        appAlert(message, 'danger');
        return;
    }
    recalcCpCompraTotal();
    setCpCompraSaving($form, true);
    const data = $form.serializeArray();
    data.push({ name: 'items_json', value: JSON.stringify(cpCompraItens) });
    $.post(window.cpComprasFormConfig.api + '?action=save', $.param(data), function (response) {
        if (response.id && Number($form.data('id')) === 0) {
            $form.find('[name="id"]').val(response.id);
            $form.find('[name="ID"]').val(response.id);
            $form.data('id', response.id);
            updateCpCompraWorkflowButtons({ Localizacao: 'KidStok', Sts: 'Aberto' });
        }
        if (typeof done === 'function') {
            done(response);
        }
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível salvar o pedido.', 'danger');
    }).always(function () {
        setCpCompraSaving($form, false);
    });
}

function selectCpCompraInputContent(input) {
    const type = String(input.type || '').toLowerCase();
    if (['hidden', 'file', 'checkbox', 'radio', 'button', 'submit'].includes(type)) {
        return;
    }
    setTimeout(function () {
        try {
            input.select();
        } catch (error) {
            // Alguns tipos nativos, como date em certos navegadores, nao aceitam select().
        }
    }, 0);
}

function setCpCompraSaving($form, saving) {
    setFormSaving($form, saving, $form.find('.btn-save-main[type="submit"]'));
}

function enviarCpCompraProposta($form) {
    if (cpCompraReadonly) {
        appAlert('Pedido disponível apenas para visualização conforme status/localização atual.', 'warning');
        return;
    }
    salvarCpCompraForm($form, function () {
        executarCpCompraWorkflow($form, 'enviar_proposta', 'Enviar proposta ao fornecedor?');
    });
}

function mostrarPainelRecusa($form) {
    const $grupo = $('#cp-sts-motivo-group');
    $grupo.removeClass('d-none');
    $('#btn-cp-recusar').prop('disabled', true);
    setTimeout(function () {
        $form.find('[name="StsMotivo"]').trigger('focus');
    }, 50);
}

function ocultarPainelRecusa($form, limpar) {
    $('#cp-sts-motivo-group').addClass('d-none');
    $('#btn-cp-recusar').prop('disabled', false);
    if (limpar) {
        $form.find('[name="StsMotivo"]').val('');
    }
}

function confirmarRecusa($form) {
    const motivo = String($form.find('[name="StsMotivo"]').val() || '').trim();
    if (motivo === '') {
        appAlert('O motivo da recusa é obrigatório.', 'warning');
        $form.find('[name="StsMotivo"]').trigger('focus');
        return;
    }
    executarCpCompraWorkflow($form, 'recusar', '', { motivo: motivo });
}

function executarCpCompraWorkflow($form, action, confirmMessage, extraData) {
    const id = Number($form.data('id') || $form.find('[name="id"]').val() || 0);
    if (!id) {
        appAlert('Salve o pedido antes de executar esta ação.', 'warning');
        return;
    }
    if (cpCompraReadonly) {
        appAlert('Pedido disponível apenas para visualização conforme status/localização atual.', 'warning');
        return;
    }
    if (action === 'aprovar' && Number($form.find('[name="Publicado"]').val() || 0) !== 1) {
        appAlert('Pedido não publicado não pode ser aprovado.', 'warning');
        return;
    }
    if (confirmMessage && !confirm(confirmMessage)) {
        return;
    }
    const data = Object.assign({ id: id }, extraData || {});
    const $workflowButtons = $('#btn-cp-enviar-proposta, #btn-cp-aprovar, #btn-cp-recusar, #btn-cp-confirmar-recusa, #btn-cp-cancelar-recusa');
    $workflowButtons.prop('disabled', true);
    $.post(window.cpComprasFormConfig.api + '?action=' + action, data, function (response) {
        appOkAlert(response.message || 'Pedido atualizado.', 'Sucesso', function () {
            window.location.href = 'cp_compras_lista.php';
        });
    }, 'json').fail(function (xhr) {
        $workflowButtons.prop('disabled', false);
        if (action === 'recusar' && !$('#cp-sts-motivo-group').hasClass('d-none')) {
            $('#btn-cp-recusar').prop('disabled', true);
        }
        appAlert(xhr.responseJSON?.message || 'Não foi possível atualizar o pedido.', 'danger');
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

function focusCpCompraItemEditor(itemIndex, openSelect) {
    setTimeout(function () {
        const item = document.querySelector('.cp-compra-item[data-item-index="' + itemIndex + '"]');
        if (!item) {
            return;
        }
        item.scrollIntoView({ behavior: 'smooth', block: 'start' });

        const $referencia = $(item).find('.cp-compra-referencia-select');
        if (openSelect !== false && $referencia.length && $referencia.data('select2') && !$referencia.prop('disabled')) {
            $referencia.select2('open');
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
    $('#btn-add-cp-item').prop('disabled', true);
    appAlert('Pedido disponível apenas para visualização conforme status/localização atual.', 'warning');
}

function updateCpCompraWorkflowButtons(row) {
    const localizacao = row.Localizacao || 'KidStok';
    const status = row.descricao_compras || row.Sts || 'Aberto';
    const publicado = Number(row.Publicado || 0) === 1;
    const teveInteracaoFornecedor = Number(row.Iteracao || 0) > 0;
    const temFotosFornecedor = Number(row.TemFotosFornecedor || 0) === 1;
    const pedidoId = Number($('#cp-compras-form').data('id') || $('#cp-compras-form [name="id"]').val() || 0);
    const isClosed = status === 'Aprovado' || status === 'Aprovado sem fotos' || status === 'Aprovado aguardando foto' || status === 'Aprovado Aguardando Foto Fornecedor' || status === 'Recusado';
    const podeAprovarAguardandoFoto = (status === 'Aprovado aguardando foto' || status === 'Aprovado Aguardando Foto Fornecedor') && temFotosFornecedor;
    $('#btn-cp-enviar-proposta').toggleClass('d-none', !pedidoId || localizacao !== 'KidStok' || isClosed);
    $('#btn-cp-aprovar').toggleClass(
        'd-none',
        !pedidoId || !publicado || cpLocalizacaoEhFornecedor(localizacao) || (isClosed && !podeAprovarAguardandoFoto)
    );
    $('#btn-cp-recusar').toggleClass(
        'd-none',
        !pedidoId || !publicado || !teveInteracaoFornecedor || cpLocalizacaoEhFornecedor(localizacao) || isClosed
    );
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
            $form.find('[name="Sts_display"]').val(row.descricao_compras || row[name] || 'Aberto');
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
    ocultarPainelRecusa($form, false);
}

function formatPublicadoCpCompra(value) {
    return Number(value || 0) === 1 ? 'Publicado' : 'Não Publicado';
}

function cpPublicadoBadge(value) {
    const publicado = Number(value || 0) === 1;
    const className = publicado ? 'dashboard-publicado-sim' : 'dashboard-publicado-nao';
    return '<span class="badge dashboard-grid-badge ' + className + '">' +
        escapeHtml(formatPublicadoCpCompra(value)) +
        '</span>';
}

function cpPedidoStatusBadge(value, localizacao) {
    const status = String(value || 'Aberto').trim() || 'Aberto';
    const statusKey = status.toLocaleLowerCase();
    let label = status;
    let className = 'badge-status-open';
    if (statusKey === 'aprovado sem fotos' || statusKey === 'aprovado aguardando foto' || statusKey === 'aprovado aguardando foto fornecedor') {
        className = 'badge-status-awaiting-photo';
    } else if (statusKey === 'aprovado') {
        className = 'badge-status-approved';
    } else if (statusKey === 'recusado') {
        className = 'badge-status-rejected';
    }
    return '<span class="badge dashboard-grid-badge ' + className + '">' +
        escapeHtml(label) +
        '</span>';
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
            applyCpCompraHeaderMarkupsToItens();
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

function cpCompraHeaderMarkups() {
    const $form = $('#cp-compras-form');
    return {
        franqueadora: parseMoneyInput($form.find('[name="MarkupFranqueadora"]').val()),
        franquia: parseMoneyInput($form.find('[name="MarkupFranquia"]').val()),
        total: parseMoneyInput($form.find('[name="MarkupTotal"]').val())
    };
}

function applyCpCompraHeaderMarkupsToItens() {
    cpCompraItens.forEach(function (item, itemIndex) {
        recalcCpCompraItem(item);
        updateCpCompraNestedDisplays(itemIndex);
    });
    $('#cp-compras-form [name="ValorTotalPedido"]').val(formatMoneyInput(sumCpCompraTotal()));
}

function collapseCpCompraItens() {
    cpCompraItens.forEach(function (_item, index) {
        cpCompraItensOpen[index] = false;
    });
    renderCpCompraItens();
}

function emptyCpCompraItem(confirmado) {
    return {
        id: 0,
        referencia_fornecedor: '',
        descricao: '',
        composicao: '',
        ncm: '',
        entrega: '',
        entrega_anterior: '',
        total_qtde: 0,
        total_produto: 0,
        Foto: 0,
        FotoFornecedor: 0,
        Sts: 1,
        item_confirmado: confirmado === undefined ? false : Boolean(confirmado),
        _pendingTamanhos: [],
        tamanhos: []
    };
}

function emptyCpCompraTamanho() {
    return {
        id: 0,
        tamanho: '',
        entrega: '',
        entrega_anterior: '',
        markup_franquia: 0,
        markup_loja: 0,
        qtde_total: 0,
        valor_total: 0,
        Itens: 0,
        Sts: 1,
        tem_log_preco_iteracao: 0,
        tem_log_qtde_iteracao: 0,
        _aberto: false,
        cores: []
    };
}

function emptyCpCompraCor() {
    return {
        id: 0,
        sku: '',
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
        percentual: 0,
        Sts: 1,
        tem_log_preco_iteracao: 0,
        tem_log_qtde_iteracao: 0,
        _aberto: false
    };
}

function cpCompraStatusValue(value) {
    return String(value) === '0' ? 0 : 1;
}

function cpCompraStatusBadge(value) {
    const active = cpCompraStatusValue(value) === 1;
    return '<span class="badge cp-status-badge ' + (active ? 'cp-status-badge-active' : 'cp-status-badge-inactive') + '">' +
        (active ? 'Ativo' : 'Inativo') +
        '</span>';
}

function renderCpCompraAlteracaoBadges(temLogPreco, temLogQtde) {
    let html = '';
    if (temLogPreco) {
        html += '<span class="badge cp-preco-alterado-badge">Preço alterado</span>';
    }
    if (temLogQtde) {
        html += '<span class="badge cp-preco-alterado-badge">Qtde alterada</span>';
    }
    return html;
}

function mapCpCompraItemFromApi(row) {
    const tamanhos = Array.isArray(row.tamanhos) ? row.tamanhos : [];
    return {
        id: Number(row.id || row.ID || 0),
        referencia_fornecedor: row.referencia_fornecedor || '',
        descricao: row.descricao || '',
        composicao: row.composicao || '',
        ncm: row.ncm || '',
        entrega: row.entrega || '',
        entrega_anterior: row.entrega_anterior || '',
        total_qtde: Number(row.total_qtde || 0),
        total_produto: Number(row.total_produto || 0),
        Foto: Number(row.Foto || 0),
        FotoFornecedor: Number(row.FotoFornecedor || 0),
        Sts: cpCompraStatusValue(row.Sts),
        item_confirmado: true,
        _pendingTamanhos: [],
        tamanhos: tamanhos.map(mapCpCompraTamanhoFromApi)
    };
}

function mapCpCompraTamanhoFromApi(row) {
    return Object.assign(emptyCpCompraTamanho(), {
        id: Number(row.id || row.ID || 0),
        tamanho: row.tamanho || '',
        entrega: row.entrega || '',
        entrega_anterior: row.entrega_anterior || '',
        markup_franquia: Number(row.markup_franquia || 0),
        markup_loja: Number(row.markup_loja || 0),
        qtde_total: Number(row.qtde_total || 0),
        valor_total: Number(row.valor_total || 0),
        Itens: Number(row.Itens || 0),
        Sts: cpCompraStatusValue(row.Sts),
        tem_log_preco_iteracao: Number(row.tem_log_preco_iteracao || 0),
        tem_log_qtde_iteracao: Number(row.tem_log_qtde_iteracao || 0),
        cores: (row.cores || []).map(function (cor) {
            return Object.assign(emptyCpCompraCor(), {
                id: Number(cor.id || cor.ID || 0),
                sku: cor.sku || '',
                cor: cor.cor || '',
                Qtde: Number(cor.Qtde || 0),
                preco_fornecedor: Number(cor.preco_fornecedor || 0),
                preco_proposta: Number(cor.preco_proposta || 0),
                valor_total_produto: Number(cor.valor_total_produto || 0),
                preco_franqueado: Number(cor.preco_franqueado || 0),
                markup_franquia: Number(cor.markup_franquia || 0),
                preco_loja: Number(cor.preco_loja || 0),
                markup_loja: Number(cor.markup_loja || 0),
                markup_total: Number(cor.markup_total || 0),
                percentual: Number(cor.percentual || 0),
                Sts: cpCompraStatusValue(cor.Sts),
                tem_log_preco_iteracao: Number(cor.tem_log_preco_iteracao || 0),
                tem_log_qtde_iteracao: Number(cor.tem_log_qtde_iteracao || 0),
                _qtde_manual: true,
                _loaded_from_api: true
            });
        })
    });
}

function renderCpCompraItens() {
    const html = cpCompraItens.map(function (item, index) {
        const collapseId = 'cp-compra-item-collapse-' + index;
        const isOpen = cpCompraItensOpen[index] === true;
        const collapseClass = isOpen ? ' show' : '';
        const collapsedClass = isOpen ? '' : ' collapsed';
        const referencia = item.referencia_fornecedor || 'Item ' + (index + 1);
        const descricao = item.descricao || 'Sem descricao';
        const composicao = item.composicao || 'N/A';
        const entrega = item.entrega ? formatDateBr(item.entrega) : 'Não definida';
        return '<section class="accordion-item card card-slim mb-3 cp-compra-item" data-item-index="' + index + '">' +
            '<div class="accordion-header card-header bg-table-header cp-compra-item-header cursor-pointer' + collapsedClass + '" data-bs-toggle="collapse" data-bs-target="#' + collapseId + '" aria-expanded="' + (isOpen ? 'true' : 'false') + '" aria-controls="' + collapseId + '">' +
            '<div class="d-flex align-items-center cp-compra-item-title">' +
            '<span class="cp-compra-chevron transition-icon" aria-hidden="true"></span>' +
            '<div>' +
            '<span class="fw-bold text-dark">' + escapeHtml(referencia) + '</span>' +
            '<div class="extra-small text-muted">' + escapeHtml(descricao) + '</div>' +
            '<div class="extra-small text-muted">Composição: ' + escapeHtml(composicao) + '</div>' +
            '</div>' +
            '</div>' +
            '<div class="d-flex align-items-center gap-4 cp-compra-item-summary">' +
            cpCompraStatusBadge(item.Sts) +
            photoButtonHtml(index, item) +
            '<div class="text-end d-none d-md-block">' +
            '<small class="text-muted d-block extra-small text-uppercase">Tamanhos</small>' +
            '<span>' + Number((item.tamanhos || []).length) + '</span>' +
            '</div>' +
            '<div class="text-end d-none d-md-block">' +
            '<small class="text-muted d-block extra-small text-uppercase">Rateio</small>' +
            '<span class="' + (roundCpPercent(cpCompraItemPercentualTotal(item)) === 100 ? 'text-success' : 'text-danger') + '">' + escapeHtml(formatPercentInput(cpCompraItemPercentualTotal(item))) + '%</span>' +
            '</div>' +
            '<div class="text-end d-none d-md-block">' +
            '<small class="text-muted d-block extra-small text-uppercase">Total do Item</small>' +
            '<span class="fw-bold text-success cp-compra-item-total">R$ ' + escapeHtml(formatMoneyBr(item.total_produto || 0)) + '</span>' +
            '</div>' +
            (cpCompraReadonly ? '' : '<div class="d-flex flex-wrap gap-2 cp-compra-item-actions" onclick="event.stopPropagation();">' +
                '<button class="btn btn-sm btn-outline-primary btn-rateio-item" type="button" onclick="ratearCpCompraItem(' + index + ')">Ratear</button>' +
                '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" title="Excluir" aria-label="Excluir" type="button" onclick="removeCpCompraItem(' + index + ')"></button>' +
                '</div>') +
            '</div>' +
            '</div>' +
            '<div id="' + collapseId + '" class="collapse cp-compra-item-collapse' + collapseClass + '" data-item-index="' + index + '">' +
            '<div class="card-body border-top table-responsive">' +
            '<div class="row g-3 mb-3">' +
            referenceSelectHtml(index, item.referencia_fornecedor, 'col-12 col-lg-5', item.item_confirmado) +
            fieldHtml(index, null, 'descricao', 'Descrição', item.descricao, 'col-12 col-lg-5', 'text', null, true) +
            fieldHtml(index, null, 'entrega', 'Entrega', item.entrega, 'col-12 col-lg-2', 'date') +
            fieldHtml(index, null, 'composicao', 'Composição', item.composicao, 'col-12 col-md-3', 'text', null, true) +
            fieldHtml(index, null, 'ncm', 'NCM', item.ncm, 'col-12 col-md-2', 'text', null, true) +
            fieldHtml(index, null, 'total_qtde', 'Quantidade total', item.total_qtde, 'col-12 col-md-2', 'number', '1', true) +
            fieldHtml(index, null, 'total_produto', 'Total Item', item.total_produto, 'col-12 col-md-2', 'money', null, true) +
            itemStatusSelectHtml(index, item.Sts, 'col-12 col-md-2') +
            confirmCpCompraItemButtonHtml(index, item, 'col-12 col-md-2') +
            '</div>' +
            (item.item_confirmado
                ? renderCpCompraTamanhos(index, item.tamanhos || [])
                : '<div class="text-center text-muted py-3">Confirme o item para inserir os tamanhos.</div>') +
            '</div>' +
            '</div>' +
            '</section>';
    }).join('');
    $('#cp-compras-itens').html(html || '<div class="text-center text-muted py-3">Nenhum item informado.</div>');
    initCpCompraReferenciaSelects();
    initCpCompraNestedFields();
}

function renderCpCompraTamanhos(itemIndex, tamanhos) {
    if (!tamanhos.length) {
        return '<div class="cp-compra-empty-nested">Nenhum tamanho informado.</div>';
    }
    return '<div class="accordion cp-compra-tamanhos-accordion" id="cp-tamanhos-' + itemIndex + '">' +
        tamanhos.map(function (tamanho, tamanhoIndex) {
            const collapseId = 'cp-tamanho-collapse-' + itemIndex + '-' + tamanhoIndex;
            const aberto = tamanho._aberto !== false;
            const rateio = cpCompraTamanhoPercentualTotal(tamanho);
            const tamanhoInativo = String(tamanho.Sts) === '0';
            const rateioClass = tamanhoInativo ? 'text-muted' : (roundCpPercent(rateio) === 100 ? 'text-success' : 'text-danger');
            const entregaResumo = tamanho.entrega ? formatDateBr(tamanho.entrega) : 'Não definida';
            const totalCores = Number((tamanho.cores || []).length);
            const temLogPreco = Number(tamanho.tem_log_preco_iteracao || 0) === 1 ||
                (tamanho.cores || []).some(function (cor) { return Number(cor.tem_log_preco_iteracao || 0) === 1; });
            const temLogQtde = Number(tamanho.tem_log_qtde_iteracao || 0) === 1 ||
                (tamanho.cores || []).some(function (cor) { return Number(cor.tem_log_qtde_iteracao || 0) === 1; });
            return '<section class="accordion-item cp-compra-tamanho" data-item-index="' + itemIndex + '" data-size-index="' + tamanhoIndex + '">' +
                '<div class="accordion-header cp-compra-tamanho-header' + ((temLogPreco || temLogQtde) ? ' cp-preco-alterado-header' : '') + (aberto ? '' : ' collapsed') + '" data-bs-toggle="collapse" data-bs-target="#' + collapseId + '" aria-expanded="' + (aberto ? 'true' : 'false') + '">' +
                '<div class="cp-compra-tamanho-title"><strong>Tamanho ' + escapeHtml(tamanho.tamanho || (tamanhoIndex + 1)) + '</strong>' + renderCpCompraAlteracaoBadges(temLogPreco, temLogQtde) + '</div>' +
                '<div class="cp-compra-tamanho-summary">' +
                '<div class="cp-compra-summary-metric"><small>Entrega</small><span class="cp-tamanho-summary-entrega">' + escapeHtml(entregaResumo) + '</span></div>' +
                '<div class="cp-compra-summary-metric"><small>Quantidade</small><span class="cp-tamanho-summary-qtde">' + escapeHtml(tamanho.qtde_total || 0) + '</span></div>' +
                '<div class="cp-compra-summary-metric"><small>Cores</small><span class="cp-tamanho-summary-cores">' + totalCores + '</span></div>' +
                '<div class="cp-compra-summary-metric"><small>Rateio</small><span class="cp-tamanho-summary-rateio ' + rateioClass + '">' + escapeHtml(formatPercentInput(rateio)) + '%</span></div>' +
                '<div class="cp-compra-summary-metric"><small>Total</small><span class="fw-bold text-success cp-tamanho-summary-total">R$ ' + escapeHtml(formatMoneyBr(tamanho.valor_total || 0)) + '</span></div>' +
                '</div>' +
                '<div class="d-flex gap-2 align-items-center cp-compra-tamanho-actions" onclick="event.stopPropagation();">' +
                cpCompraStatusBadge(tamanho.Sts) +
                (cpCompraReadonly ? '' :
                    '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" type="button" title="Excluir tamanho" aria-label="Excluir tamanho" onclick="removeCpCompraTamanho(' + itemIndex + ', ' + tamanhoIndex + ')"></button>') +
                '</div></div>' +
                '<div id="' + collapseId + '" class="accordion-collapse collapse cp-compra-tamanho-collapse' + (aberto ? ' show' : '') + '" data-item-index="' + itemIndex + '" data-size-index="' + tamanhoIndex + '">' +
                '<div class="accordion-body">' +
                '<div class="row g-3 mb-3">' +
                cpCompraTamanhoInput(itemIndex, tamanhoIndex, 'tamanho', 'Tamanho', tamanho.tamanho, 'col-12 col-md-2', 'text', true) +
                cpCompraTamanhoInput(itemIndex, tamanhoIndex, 'entrega', 'Entrega', tamanho.entrega, 'col-12 col-md-2', 'date') +
                cpCompraTamanhoInput(itemIndex, tamanhoIndex, 'qtde_total', 'Quantidade do tamanho', tamanho.qtde_total, 'col-12 col-md-2', 'number') +
                cpCompraTamanhoInput(itemIndex, tamanhoIndex, 'valor_total', 'Total do tamanho', tamanho.valor_total, 'col-12 col-md-2', 'money', true) +
                cpCompraTamanhoStatus(itemIndex, tamanhoIndex, tamanho.Sts, 'col-12 col-md-2') +
                '<div class="col-12 col-md-2"><label class="form-label">Total do rateio</label><input class="form-control ' + rateioClass + ' fw-bold cp-tamanho-rateio-total" value="' + escapeAttr(formatPercentInput(rateio)) + '%" readonly></div>' +
                '</div>' +
                renderCpCompraCores(itemIndex, tamanhoIndex, tamanho.cores || []) +
                '</div></div></section>';
        }).join('') + '</div>';
}

function renderCpCompraCores(itemIndex, tamanhoIndex, cores) {
    if (!cores.length) {
        return '<div class="cp-compra-empty-nested">Nenhuma cor informada para este tamanho.</div>';
    }
    return '<div class="accordion cp-compra-cores-accordion">' + cores.map(function (cor, corIndex) {
        const collapseId = 'cp-cor-collapse-' + itemIndex + '-' + tamanhoIndex + '-' + corIndex;
        const aberto = cor._aberto !== false;
        const temLogPreco = Number(cor.tem_log_preco_iteracao || 0) === 1;
        const temLogQtde = Number(cor.tem_log_qtde_iteracao || 0) === 1;
        return '<section class="accordion-item cp-compra-cor" data-item-index="' + itemIndex + '" data-size-index="' + tamanhoIndex + '" data-color-index="' + corIndex + '">' +
            '<div class="accordion-header cp-compra-cor-header' + ((temLogPreco || temLogQtde) ? ' cp-preco-alterado-header' : '') + (aberto ? '' : ' collapsed') + '" data-bs-toggle="collapse" data-bs-target="#' + collapseId + '" aria-expanded="' + (aberto ? 'true' : 'false') + '">' +
            '<div class="cp-compra-cor-title"><strong>Cor ' + escapeHtml(cor.cor || (corIndex + 1)) + '</strong>' +
            '<small class="d-block text-muted">Rateio: <span class="cp-cor-summary-percentual">' + escapeHtml(formatPercentInput(cor.percentual || 0)) + '%</span></small>' +
            renderCpCompraAlteracaoBadges(temLogPreco, temLogQtde) + '</div>' +
            '<div class="cp-compra-cor-summary">' +
            '<div class="cp-compra-summary-metric"><small>Quantidade</small><span class="cp-cor-summary-qtde">' + escapeHtml(cor.Qtde || 0) + '</span></div>' +
            '<div class="cp-compra-summary-metric"><small>Status</small>' + cpCompraStatusBadge(cor.Sts) + '</div>' +
            '<div class="cp-compra-summary-metric"><small>Preço proposto</small><span class="cp-cor-summary-preco-proposta">R$ ' + escapeHtml(formatMoneyBr(cor.preco_proposta || 0)) + '</span></div>' +
            '<div class="cp-compra-summary-metric"><small>Preço fornecedor</small><span class="cp-cor-summary-preco-fornecedor">R$ ' + escapeHtml(formatMoneyBr(cor.preco_fornecedor || 0)) + '</span></div>' +
            '<div class="cp-compra-summary-metric"><small>Preço franqueado</small><span class="cp-cor-summary-preco-franqueado">R$ ' + escapeHtml(formatMoneyBr(cor.preco_franqueado || 0)) + '</span></div>' +
            '<div class="cp-compra-summary-metric"><small>Preço loja</small><span class="cp-cor-summary-preco-loja">R$ ' + escapeHtml(formatMoneyBr(cor.preco_loja || 0)) + '</span></div>' +
            '<div class="cp-compra-summary-metric"><small>Total da cor</small><span class="fw-bold text-success cp-cor-summary-total">R$ ' + escapeHtml(formatMoneyBr(cor.valor_total_produto || 0)) + '</span></div>' +
            '</div>' +
            '<div class="d-flex gap-2 align-items-center cp-compra-cor-actions" onclick="event.stopPropagation();">' +
            '<button class="btn btn-sm btn-outline-secondary btn-price-log" type="button" title="Visualizar última alteração de preços" onclick="openCpCompraCorLog(' + itemIndex + ', ' + tamanhoIndex + ', ' + corIndex + ')">Preços</button>' +
            (cpCompraReadonly ? '' : '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only" type="button" title="Excluir cor" aria-label="Excluir cor" onclick="removeCpCompraCor(' + itemIndex + ', ' + tamanhoIndex + ', ' + corIndex + ')"></button>') +
            '</div></div>' +
            '<div id="' + collapseId + '" class="accordion-collapse collapse cp-compra-cor-collapse' + (aberto ? ' show' : '') + '" data-item-index="' + itemIndex + '" data-size-index="' + tamanhoIndex + '" data-color-index="' + corIndex + '">' +
            '<div class="accordion-body"><div class="row g-2">' +
            cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, 'sku', 'SKU', cor.sku, 'col-12 col-md-3', 'text', true) +
            cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, 'cor', 'Cor', cor.cor, 'col-12 col-md-3', 'text', true) +
            cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, 'Qtde', 'Quantidade', cor.Qtde, 'col-12 col-md-2', 'number') +
            cpCompraCorStatus(itemIndex, tamanhoIndex, corIndex, cor.Sts, 'col-12 col-md-2') +
            cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, 'preco_proposta', 'Preço proposto', cor.preco_proposta, 'col-12 col-md-3', 'money') +
            cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, 'preco_fornecedor', 'Preço fornecedor', cor.preco_fornecedor, 'col-12 col-md-3', 'money', true) +
            cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, 'preco_franqueado', 'Preço franqueado', cor.preco_franqueado, 'col-12 col-md-3', 'money', true) +
            cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, 'preco_loja', 'Preço loja', cor.preco_loja, 'col-12 col-md-3', 'money', true) +
            cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, 'valor_total_produto', 'Total da cor', cor.valor_total_produto, 'col-12 col-md-3', 'money', true) +
            '</div></div></div></section>';
    }).join('');
}

function cpCompraTamanhoInput(itemIndex, tamanhoIndex, name, label, value, colClass, type, readonly) {
    return cpCompraNestedInput('tamanho', itemIndex, tamanhoIndex, null, name, label, value, colClass, type, readonly);
}

function cpCompraCorInput(itemIndex, tamanhoIndex, corIndex, name, label, value, colClass, type, readonly) {
    return cpCompraNestedInput('cor', itemIndex, tamanhoIndex, corIndex, name, label, value, colClass, type, readonly);
}

function cpCompraNestedInput(level, itemIndex, tamanhoIndex, corIndex, name, label, value, colClass, type, readonly) {
    const isMoney = type === 'money';
    const isPercent = type === 'percent';
    const inputType = isMoney || isPercent ? 'text' : (type || 'text');
    const displayValue = isMoney ? formatMoneyInput(value || 0) : (isPercent ? formatPercentInput(value || 0) : escapeAttr(value || ''));
    const readonlyAttr = (readonly || cpCompraReadonly) ? ' readonly' : '';
    const inputMode = (isMoney || isPercent || inputType === 'number') ? ' inputmode="decimal"' : '';
    const destaqueClass = level === 'cor' && (name === 'Qtde' || name === 'preco_proposta') ? ' cp-compra-campo-destaque' : '';
    const className = 'form-control cp-compra-' + level + '-field' + (isMoney ? ' cp-money-field text-end' : '') + (isPercent ? ' cp-percentual-field text-end' : '') + destaqueClass;
    const attrs = cpNestedDataAttrs(itemIndex, tamanhoIndex, corIndex, name);
    const input = '<input class="' + className + '" type="' + inputType + '"' + inputMode + readonlyAttr + ' value="' + displayValue + '" ' + attrs + '>';
    return '<div class="' + colClass + '"><label class="form-label">' + label + '</label>' + (isMoney ? moneyInputGroup(input, false) : input) + '</div>';
}

function cpCompraTamanhoStatus(itemIndex, tamanhoIndex, value, colClass) {
    const disabled = cpCompraReadonly ? ' disabled' : '';
    return '<div class="' + colClass + '"><label class="form-label">Status</label><select class="form-select cp-compra-tamanho-field" ' +
        cpNestedDataAttrs(itemIndex, tamanhoIndex, null, 'Sts') + disabled + '>' +
        '<option value="1"' + (String(value) !== '0' ? ' selected' : '') + '>Ativo</option>' +
        '<option value="0"' + (String(value) === '0' ? ' selected' : '') + '>Inativo</option></select></div>';
}

function cpCompraCorStatus(itemIndex, tamanhoIndex, corIndex, value, colClass) {
    const disabled = cpCompraReadonly ? ' disabled' : '';
    return '<div class="' + colClass + '"><label class="form-label">Status</label><select class="form-select cp-compra-cor-field" ' +
        cpNestedDataAttrs(itemIndex, tamanhoIndex, corIndex, 'Sts') + disabled + '>' +
        '<option value="1"' + (String(value) !== '0' ? ' selected' : '') + '>Ativo</option>' +
        '<option value="0"' + (String(value) === '0' ? ' selected' : '') + '>Inativo</option></select></div>';
}

function cpNestedDataAttrs(itemIndex, tamanhoIndex, corIndex, name) {
    return 'data-item-index="' + itemIndex + '" data-size-index="' + tamanhoIndex + '"' +
        (corIndex === null ? '' : ' data-color-index="' + corIndex + '"') +
        ' data-field="' + name + '"';
}

function fieldHtml(itemIndex, detailIndex, name, label, value, colClass, type, step, readonly) {
    const isMoney = type === 'money';
    const attr = cpDataAttrs(itemIndex, detailIndex, name);
    const inputType = isMoney ? 'text' : (type || 'text');
    const stepAttr = step ? ' step="' + step + '"' : '';
    const readonlyAttr = (readonly || cpCompraReadonly) ? ' readonly' : '';
    const inputModeAttr = inputType === 'number' || isMoney ? ' inputmode="numeric"' : '';
    const className = 'form-control cp-compra-field' + (isMoney ? ' cp-money-field text-end' : '');
    const displayValue = isMoney ? formatMoneyInput(value || 0) : escapeAttr(value || '');
    const input = '<input class="' + className + '" type="' + inputType + '"' + stepAttr + inputModeAttr + readonlyAttr + ' value="' + displayValue + '" ' + attr + '>';
    return '<div class="' + colClass + '"><label class="form-label">' + label + '</label>' + (isMoney ? moneyInputGroup(input, false) : input) + '</div>';
}

function referenceSelectHtml(itemIndex, value, colClass, readonly) {
    const selected = value ? '<option value="' + escapeAttr(value) + '" selected>' + escapeHtml(value) + '</option>' : '';
    const disabledAttr = (readonly || cpCompraReadonly) ? ' disabled' : '';
    return '<div class="' + colClass + '">' +
        '<label class="form-label">Referência</label>' +
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
            placeholder: 'Digite a referência',
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
                processResults: function (response) {
                    const itemIndex = Number($select.data('item-index'));
                    const used = cpCompraReferenciasUsadas(itemIndex);
                    return {
                        results: (response.results || []).filter(function (row) {
                            return !used.includes(String(row.id || ''));
                        })
                    };
                }
            }
        });
    });

    $('.cp-compra-referencia-select').off('select2:opening.cpReferencia').on('select2:opening.cpReferencia', function (event) {
        if (!$('#cp-compras-form [name="Fornecedor_id"]').val()) {
            event.preventDefault();
            appAlert('Informe o fornecedor antes de pesquisar referências.', 'warning');
        }
    });

    $('.cp-compra-referencia-select').off('select2:select.cpReferencia').on('select2:select.cpReferencia', function (event) {
        const itemIndex = Number($(this).data('item-index'));
        const codigoReferencia = event.params.data.id;
        if (cpCompraReferenciaDuplicada(codigoReferencia, itemIndex)) {
            $(this).val(null).trigger('change');
            appAlert('A referência ' + codigoReferencia + ' já foi incluída neste pedido.', 'warning');
            return;
        }
        loadCpCompraReferenciaItem(itemIndex, codigoReferencia);
    });
}

function cpCompraReferenciasUsadas(ignoreIndex) {
    return cpCompraItens
        .map(function (item, index) {
            return Number(ignoreIndex) === index ? '' : String(item.referencia_fornecedor || '').trim();
        })
        .filter(Boolean);
}

function cpCompraReferenciaDuplicada(referencia, ignoreIndex) {
    return cpCompraReferenciasUsadas(ignoreIndex).includes(String(referencia || '').trim());
}

function initCpCompraNestedFields() {
    $('.cp-compra-field[data-field="entrega"]')
        .off('change.cpItemEntrega input.cpItemEntrega')
        .on('change.cpItemEntrega input.cpItemEntrega', function () {
            updateCpCompraItemEntrega($(this));
        });

    $('.cp-compra-field[data-field="Sts"]')
        .off('change.cpItemStatus')
        .on('change.cpItemStatus', function () {
            updateCpCompraItemStatus($(this));
        });

    $('.cp-compra-tamanho-field, .cp-compra-cor-field')
        .off('input.cpNested change.cpNested')
        .on('input.cpNested change.cpNested', function () {
            const $field = $(this);
            updateCpCompraNestedField($field);
        })
        .off('focus.cpNested')
        .on('focus.cpNested', function () {
            if (this.type !== 'date') {
                this.select();
            }
        });

    $('.cp-percentual-field')
        .off('input.cpPercentual')
        .on('input.cpPercentual', function () {
            updateCpCompraNestedField($(this));
        })
        .off('blur.cpPercentual')
        .on('blur.cpPercentual', function () {
            this.value = formatPercentInput(parsePercentInput(this.value));
        });

    $('.cp-money-field')
        .off('input.cpMoney')
        .on('input.cpMoney', function () {
            this.value = formatMoneyInput(this.value);
            if ($(this).hasClass('cp-compra-cor-field')) {
                updateCpCompraNestedField($(this));
            }
        });
}

function updateCpCompraItemStatus($field) {
    const itemIndex = Number($field.data('item-index'));
    const item = cpCompraItens[itemIndex];
    if (!item) {
        return;
    }
    const status = normalizeCpCompraValue('Sts', $field.val()) === 0 ? 0 : 1;
    item.Sts = status;
    if (status === 0) {
        item.total_qtde = 0;
    }
    (item.tamanhos || []).forEach(function (tamanho) {
        tamanho.Sts = status;
        if (status === 0) {
            tamanho.qtde_total = 0;
        }
        (tamanho.cores || []).forEach(function (cor) {
            cor.Sts = status;
            if (status === 0) {
                cor.percentual = 0;
            }
        });
    });
    recalcCpCompraItem(item);
    cpCompraItensOpen[itemIndex] = true;
    renderCpCompraItens();
    recalcCpCompraTotal();
}

function updateCpCompraItemEntrega($field) {
    const itemIndex = Number($field.data('item-index'));
    const item = cpCompraItens[itemIndex];
    if (!item) {
        return;
    }

    const entrega = String($field.val() || '');
    item.entrega = entrega;
    (item.tamanhos || []).forEach(function (tamanho) {
        tamanho.entrega = entrega;
    });
    $('.cp-compra-tamanho-field[data-item-index="' + itemIndex + '"][data-field="entrega"]').val(entrega);
    updateCpCompraNestedDisplays(itemIndex);
}

function updateCpCompraNestedField($field) {
    const itemIndex = Number($field.data('item-index'));
    const tamanhoIndex = Number($field.data('size-index'));
    const corIndexRaw = $field.attr('data-color-index');
    const name = $field.data('field');
    const item = cpCompraItens[itemIndex];
    const tamanho = item?.tamanhos?.[tamanhoIndex];
    if (!tamanho) {
        return;
    }
    if (corIndexRaw === undefined) {
        tamanho[name] = normalizeCpCompraValue(name, $field.val());
        if (name === 'qtde_total') {
            (tamanho.cores || []).forEach(function (cor) {
                if (cor._loaded_from_api !== true) {
                    delete cor._qtde_manual;
                }
            });
        }
        if (name === 'Sts') {
            cascadeCpCompraTamanhoStatus(tamanho, tamanho[name]);
            cpCompraItensOpen[itemIndex] = true;
            tamanho._aberto = true;
            recalcCpCompraItem(item);
            renderCpCompraItens();
            recalcCpCompraTotal();
            return;
        }
    } else {
        const cor = tamanho.cores[Number(corIndexRaw)];
        if (!cor) {
            return;
        }
        cor[name] = normalizeCpCompraValue(name, $field.val());
        if (name === 'Qtde') {
            cor._qtde_manual = true;
            limitarCpCompraQuantidadeCor(tamanho, cor, $field);
        }
        if (name === 'Sts') {
            updateCpCompraTamanhoStatusFromCores(tamanho);
            $('.cp-compra-tamanho-field[data-item-index="' + itemIndex + '"][data-size-index="' + tamanhoIndex + '"][data-field="Sts"]').val(String(tamanho.Sts));
        }
    }
    recalcCpCompraItem(item);
    updateCpCompraNestedDisplays(itemIndex);
    $('#cp-compras-form [name="ValorTotalPedido"]').val(formatMoneyInput(sumCpCompraTotal()));
}

function moveCpCompraFocusToNextField(field) {
    const fields = $('#cp-compras-form')
        .find('input:not([type="hidden"]):not([readonly]):not(:disabled), select:not(:disabled), textarea:not([readonly]):not(:disabled), button:not(:disabled)')
        .filter(':visible')
        .toArray();
    const index = fields.indexOf(field);
    if (index >= 0 && fields[index + 1]) {
        fields[index + 1].focus();
    }
}

function limitarCpCompraQuantidadeCor(tamanho, corAtual, $field) {
    const qtdeTotal = Math.max(0, parseInt(Number(tamanho.qtde_total || 0), 10) || 0);
    const totalOutrasCores = (tamanho.cores || []).reduce(function (total, cor) {
        if (cor === corAtual || String(cor.Sts) === '0') {
            return total;
        }
        return total + Math.max(0, parseInt(Number(cor.Qtde || 0), 10) || 0);
    }, 0);
    const limite = Math.max(0, qtdeTotal - totalOutrasCores);
    if (Number(corAtual.Qtde || 0) > limite) {
        corAtual.Qtde = limite;
        $field.val(limite);
        appAlert('A soma das quantidades das cores não pode passar da quantidade total do tamanho. Quantidade ajustada para ' + limite + '.', 'warning');
    }
}

function cascadeCpCompraTamanhoStatus(tamanho, status) {
    const statusValue = Number(status) === 0 ? 0 : 1;
    tamanho.Sts = statusValue;
    if (statusValue === 0) {
        tamanho.qtde_total = 0;
    }
    (tamanho.cores || []).forEach(function (cor) {
        cor.Sts = statusValue;
        if (statusValue === 0) {
            cor.percentual = 0;
        }
    });
}

function updateCpCompraTamanhoStatusFromCores(tamanho) {
    tamanho.Sts = (tamanho.cores || []).some(function (cor) {
        return String(cor.Sts) !== '0';
    }) ? 1 : 0;
}

function cpCompraTamanhoPercentualTotal(tamanho) {
    if (String(tamanho.Sts) === '0') {
        return 0;
    }
    return (tamanho.cores || []).reduce(function (total, cor) {
        return String(cor.Sts) === '0' ? total : total + Number(cor.percentual || 0);
    }, 0);
}

function roundCpPercent(value) {
    return Math.round((Number(value) || 0) * 10000) / 10000;
}

function roundCpPercentDisplay(value) {
    return Math.round((Number(value) || 0) * 100) / 100;
}

function parsePercentInput(value) {
    return Number(String(value || '0').replace(/\./g, '').replace(',', '.')) || 0;
}

function formatPercentInput(value) {
    return Number(value || 0).toLocaleString('pt-BR', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

function loadCpCompraReferenciaItem(itemIndex, codigoReferencia) {
    const fornecedorId = $('#cp-compras-form [name="Fornecedor_id"]').val();
    if (!fornecedorId) {
        appAlert('Informe o fornecedor antes de selecionar referências.', 'warning');
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
        itemData._pendingTamanhos = (itemData.tamanhos || []).map(mapCpCompraTamanhoFromApi);
        itemData.tamanhos = [];
        cpCompraItens[itemIndex] = itemData;
        cpCompraItensOpen[itemIndex] = true;
        renderCpCompraItens();
        recalcCpCompraTotal();
    }).fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível carregar a referência.', 'danger');
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
    const hasKidStokPhoto = Number(item.Foto || 0) === 1;
    const hasFornecedorPhoto = Number(item.FotoFornecedor || 0) === 1;
    const isConfirmed = Boolean(item.item_confirmado);
    const podeAlterarKidStok = cpCompraPodeAlterarFoto('kidstok');
    const kidStokLabel = isConfirmed ? (hasKidStokPhoto || !podeAlterarKidStok ? 'Ver Fotos' : 'Inserir Fotos') : 'Confirmar item';
    const fornecedorLabel = isConfirmed ? 'Ver Fotos' : 'Confirmar item';
    const kidStokBadge = fotoBadgeHtml(hasKidStokPhoto);
    const fornecedorBadge = fotoBadgeHtml(hasFornecedorPhoto);
    const disabledAttr = isConfirmed ? '' : ' disabled';
    const kidStokStateClass = fotoStateClass(hasKidStokPhoto);
    const fornecedorStateClass = fotoStateClass(hasFornecedorPhoto);
    return '<div class="text-start cp-compra-item-photo" onclick="event.stopPropagation();">' +
        '<input type="hidden" class="cp-compra-field" value="' + (hasKidStokPhoto ? 1 : 0) + '" ' + cpDataAttrs(itemIndex, null, 'Foto') + '>' +
        '<div class="cp-fotos-actions">' +
        '<div class="cp-fotos-action"><small class="text-muted d-block extra-small text-uppercase">Fotos KidStok</small>' +
        '<button class="btn btn-sm btn-photo cp-foto-kidstok ' + kidStokStateClass + '" type="button" onclick="openCpCompraFotos(' + itemIndex + ', \'kidstok\')"' + disabledAttr + '>' + kidStokLabel + kidStokBadge + '</button></div>' +
        '<div class="cp-fotos-action"><small class="text-muted d-block extra-small text-uppercase">Fotos Fornecedor</small>' +
        '<button class="btn btn-sm btn-photo cp-foto-fornecedor ' + fornecedorStateClass + '" type="button" onclick="openCpCompraFotos(' + itemIndex + ', \'fornecedor\')"' + disabledAttr + '>' + fornecedorLabel + fornecedorBadge + '</button></div>' +
        '</div>' +
        '</div>';
}

function fotoBadgeHtml(hasPhoto) {
    return hasPhoto ? '<span class="badge cp-foto-badge cp-foto-badge-sim ms-2">Sim</span>' : '<span class="badge cp-foto-badge cp-foto-badge-nao ms-2">Não</span>';
}

function fotoStateClass(hasPhoto) {
    return hasPhoto ? 'btn-photo-sim' : 'btn-photo-nao';
}

function openCpCompraCorLog(itemIndex, tamanhoIndex, corIndex) {
    const item = cpCompraItens[itemIndex];
    const tamanho = item?.tamanhos?.[tamanhoIndex];
    const cor = tamanho?.cores?.[corIndex];
    const pedidoId = Number($('#cp-compras-form').data('id') || $('#cp-compras-form [name="id"]').val() || 0);
    const corId = Number(cor?.id || 0);
    if (!pedidoId || !corId) {
        appAlert('Salve o pedido antes de consultar o log da cor.', 'warning');
        return;
    }

    const $modal = ensureCpCompraCorLogModal();
    $modal.find('.modal-body').html('<div class="text-center text-muted py-4">Carregando log...</div>');
    bootstrap.Modal.getOrCreateInstance($modal[0]).show();

    $.getJSON(window.cpComprasFormConfig.api, {
        action: 'cor_log_ultimo',
        pedido_id: pedidoId,
        cor_id: corId
    }).done(function (response) {
        $modal.find('.modal-body').html(renderCpCompraCorLog(response.data || null, cor));
    }).fail(function (xhr) {
        $modal.find('.modal-body').html('<div class="alert alert-danger mb-0">' + escapeHtml(xhr.responseJSON?.message || 'Não foi possível carregar o log da cor.') + '</div>');
    });
}

function ensureCpCompraCorLogModal() {
    let $modal = $('#cp-cor-log-modal');
    if (!$modal.length) {
        $('body').append(
            '<div class="modal fade" id="cp-cor-log-modal" tabindex="-1" aria-hidden="true">' +
            '<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">' +
            '<div class="modal-content">' +
            '<div class="modal-header">' +
            '<h5 class="modal-title">Última alteração de preços</h5>' +
            '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>' +
            '</div>' +
            '<div class="modal-body"></div>' +
            '<div class="modal-footer">' +
            '<button type="button" class="btn btn-orange" data-bs-dismiss="modal">OK</button>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>'
        );
        $modal = $('#cp-cor-log-modal');
    }
    return $modal;
}

function renderCpCompraCorLog(log, corAtual) {
    if (!log) {
        return '<div class="alert alert-info mb-0">Nenhum registro de alteração encontrado para esta cor.</div>';
    }

    const rows = [
        ['Quantidade', formatNumberBr(log.Qtde), formatNumberBr(corAtual?.Qtde || 0)],
        ['Preço fornecedor', 'R$ ' + formatMoneyBr(log.preco_fornecedor || 0), 'R$ ' + formatMoneyBr(corAtual?.preco_fornecedor || 0)],
        ['Preço proposto', 'R$ ' + formatMoneyBr(log.preco_proposta || 0), 'R$ ' + formatMoneyBr(corAtual?.preco_proposta || 0)],
        ['Preço franqueado', 'R$ ' + formatMoneyBr(log.preco_franqueado || 0), 'R$ ' + formatMoneyBr(corAtual?.preco_franqueado || 0)],
        ['Preço loja', 'R$ ' + formatMoneyBr(log.preco_loja || 0), 'R$ ' + formatMoneyBr(corAtual?.preco_loja || 0)],
        ['Total da cor', 'R$ ' + formatMoneyBr(log.valor_total_produto || 0), 'R$ ' + formatMoneyBr(corAtual?.valor_total_produto || 0)]
    ];

    return '<div class="mb-3">' +
        '<div class="fw-bold">' + escapeHtml(corAtual?.cor || log.cor || 'Cor') + '</div>' +
        '<div class="text-muted small">Comparativo entre o último log e os valores atuais da cor.</div>' +
        '</div>' +
        '<div class="table-responsive">' +
        '<table class="table table-custom align-middle mb-0">' +
        '<thead><tr><th>Campo</th><th>Anterior</th><th>Atual</th></tr></thead>' +
        '<tbody>' +
        rows.map(function (row) {
            const changedClass = String(row[1]) !== String(row[2]) ? ' class="cp-log-preco-atualizado"' : '';
            return '<tr><td class="fw-bold">' + escapeHtml(row[0]) + '</td><td>' + escapeHtml(row[1] ?? '-') + '</td><td' + changedClass + '>' + escapeHtml(row[2] ?? '-') + '</td></tr>';
        }).join('') +
        '</tbody></table></div>';
}

function formatNumberBr(value) {
    return Number(value || 0).toLocaleString('pt-BR', { maximumFractionDigits: 2 });
}

function openCpCompraFotos(itemIndex, origem) {
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
        appAlert('Informe fornecedor e referência antes de acessar fotos.', 'warning');
        return;
    }

    cpCompraFotoItemIndex = itemIndex;
    cpCompraFotoOrigem = origem === 'fornecedor' ? 'fornecedor' : 'kidstok';
    $('#cp-foto-referencia').text(referencia);
    $('#cp-fotos-modal .modal-title').text(cpCompraFotoOrigem === 'fornecedor' ? 'Fotos Fornecedor' : 'Fotos KidStok');
    const podeAlterarFoto = cpCompraPodeAlterarFoto(cpCompraFotoOrigem);
    $('#cp-foto-input').val('').prop('disabled', !podeAlterarFoto);
    $('#cp-foto-upload-block').toggleClass('d-none', !podeAlterarFoto);
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
        action: context.origem === 'fornecedor' ? 'fotos_fornecedor_list' : 'fotos_list',
        pedido_id: context.pedidoId,
        referencia: context.referencia,
        fornecedor_id: context.fornecedorId
    }).done(function (response) {
        renderCpCompraFotos(response.data || []);
        if (context.origem === 'kidstok') {
            updateCpCompraFotoFlag(context.itemIndex, Number(response.count || 0) > 0 ? 1 : 0);
        } else {
            updateCpCompraFotoFornecedorFlag(context.itemIndex, Number(response.count || 0) > 0 ? 1 : 0);
        }
    }).fail(function (xhr) {
        $('#cp-fotos-list').html('<div class="alert alert-danger mb-0">' + escapeHtml(xhr.responseJSON?.message || 'Não foi possível carregar as fotos.') + '</div>');
    });
}

function uploadCpCompraFotos() {
    const context = cpCompraFotoContext();
    if (!context || !cpCompraPodeAlterarFoto(context.origem)) {
        $('#cp-foto-input').val('');
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
    formData.append('origem', context.origem);
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
        if (context.origem === 'kidstok') {
            updateCpCompraFotoFlag(context.itemIndex, 1);
        } else {
            updateCpCompraFotoFornecedorFlag(context.itemIndex, 1);
        }
        $('#cp-foto-input').val('');
        loadCpCompraFotos();
    }).fail(function (xhr) {
        $('#cp-fotos-list').html('<div class="alert alert-danger mb-0">' + escapeHtml(xhr.responseJSON?.message || 'Não foi possível inserir as fotos.') + '</div>');
    });
}

function deleteCpCompraFoto(fotoId) {
    const context = cpCompraFotoContext();
    if (!context || !cpCompraPodeAlterarFoto(context.origem)) {
        return;
    }
    if (!confirm('Excluir esta foto?')) {
        return;
    }

    $.post(window.cpComprasFormConfig.api + '?action=fotos_delete', {
        pedido_id: context.pedidoId,
        referencia: context.referencia,
        fornecedor_id: context.fornecedorId,
        origem: context.origem,
        foto_id: fotoId
    }, function (response) {
        appAlert(response.message || 'Foto excluída.', 'success');
        if (context.origem === 'kidstok') {
            updateCpCompraFotoFlag(context.itemIndex, Number(response.count || 0) > 0 ? 1 : 0);
        } else {
            updateCpCompraFotoFornecedorFlag(context.itemIndex, Number(response.count || 0) > 0 ? 1 : 0);
        }
        loadCpCompraFotos();
    }, 'json').fail(function (xhr) {
        appAlert(xhr.responseJSON?.message || 'Não foi possível excluir a foto.', 'danger');
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
        origem: cpCompraFotoOrigem,
        pedidoId: Number($form.data('id') || $form.find('[name="id"]').val() || 0),
        fornecedorId: $form.find('[name="Fornecedor_id"]').val() || '',
        referencia: item.referencia_fornecedor || ''
    };
}

function renderCpCompraFotos(fotos) {
    const $list = $('#cp-fotos-list');
    $('#cp-foto-count').text(fotos.length + (fotos.length === 1 ? ' foto' : ' fotos'));
    if (!fotos.length) {
        $list.html('<div class="text-center text-muted py-4">Nenhuma foto inserida para esta referência.</div>');
        return;
    }

    $list.html(fotos.map(function (foto) {
        const deleteButton = cpCompraPodeAlterarFoto(cpCompraFotoOrigem)
            ? '<button class="btn btn-sm btn-outline-danger btn-delete btn-icon-only cp-foto-delete" title="Excluir" aria-label="Excluir" type="button" onclick="deleteCpCompraFoto(' + Number(foto.id || 0) + ')"></button>'
            : '';
        return '<figure class="cp-foto-card">' +
            '<img src="' + escapeAttr(foto.src || '') + '" alt="Foto ' + escapeAttr(foto.Sequencia || '') + '" title="Ampliar foto" onclick="openCpCompraFotoPreview(this)">' +
            '<figcaption><span>Foto ' + escapeHtml(foto.Sequencia || '') + '</span>' + deleteButton + '</figcaption>' +
            '</figure>';
    }).join(''));
}

function openCpCompraFotoPreview(image) {
    const src = image ? image.getAttribute('src') : '';
    if (!src) {
        return;
    }
    const title = image.getAttribute('alt') || 'Foto';
    $('#cp-foto-preview-title').text(title);
    $('#cp-foto-preview-img').attr('src', src).attr('alt', title + ' ampliada');
    bootstrap.Modal.getOrCreateInstance(document.getElementById('cp-foto-preview-modal')).show();
}

function updateCpCompraFotoFlag(itemIndex, value) {
    if (!cpCompraItens[itemIndex]) {
        return;
    }
    cpCompraItens[itemIndex].Foto = value;
    $('.cp-compra-field[data-item-index="' + itemIndex + '"][data-field="Foto"]').val(value);
    const $button = $('.cp-compra-item[data-item-index="' + itemIndex + '"] .cp-foto-kidstok');
    if ($button.length) {
        $button.toggleClass('btn-photo-sim', Boolean(value)).toggleClass('btn-photo-nao', !Boolean(value));
        $button.html((value || !cpCompraPodeAlterarFoto('kidstok') ? 'Ver Fotos' : 'Inserir Fotos') + fotoBadgeHtml(Boolean(value)));
    }
}

function updateCpCompraFotoFornecedorFlag(itemIndex, value) {
    if (!cpCompraItens[itemIndex]) {
        return;
    }
    cpCompraItens[itemIndex].FotoFornecedor = value;
    const $button = $('.cp-compra-item[data-item-index="' + itemIndex + '"] .cp-foto-fornecedor');
    if ($button.length) {
        $button.toggleClass('btn-photo-sim', Boolean(value)).toggleClass('btn-photo-nao', !Boolean(value));
        $button.html('Ver Fotos' + fotoBadgeHtml(Boolean(value)));
    }
    updateCpCompraWorkflowButtons({
        Localizacao: $('#cp-compras-form [name="Localizacao"]').val() || 'KidStok',
        Sts: $('#cp-compras-form [name="Sts_display"]').val() || $('#cp-compras-form [name="Sts"]').val() || 'Aberto',
        Publicado: $('#cp-compras-form [name="Publicado"]').val() || 0,
        TemFotosFornecedor: value
    });
}

function itemStatusSelectHtml(itemIndex, value, colClass) {
    const statusValue = String(value) === '0' ? 0 : 1;
    const disabled = cpCompraReadonly ? ' disabled' : '';
    return '<div class="' + colClass + '">' +
        '<label class="form-label">Status</label>' +
        '<select class="form-select cp-compra-field cp-compra-item-status" ' + cpDataAttrs(itemIndex, null, 'Sts') + disabled + '>' +
        '<option value="1"' + (statusValue === 1 ? ' selected' : '') + '>Ativo</option>' +
        '<option value="0"' + (statusValue === 0 ? ' selected' : '') + '>Inativo</option>' +
        '</select>' +
        '</div>';
}

function confirmCpCompraItemButtonHtml(itemIndex, item, colClass) {
    if (cpCompraReadonly || item.item_confirmado) {
        return '';
    }
    return '<div class="' + colClass + ' cp-compra-confirm-wrapper">' +
        '<button class="btn btn-sm btn-confirm-item" type="button" onclick="confirmCpCompraItem(' + itemIndex + ')">Confirmar</button>' +
        '</div>';
}

function moneyInputGroup(inputHtml, small) {
    return '<div class="input-group' + (small ? ' input-group-sm' : '') + ' cp-money-input-group"><span class="input-group-text">R$</span>' + inputHtml + '</div>';
}

function updateCpCompraItemTotalDisplay(itemIndex) {
    const item = cpCompraItens[itemIndex] || null;
    if (!item) {
        return;
    }
    const total = roundCpMoney(item.total_produto || 0);
    const $item = $('.cp-compra-item[data-item-index="' + itemIndex + '"]');
    $item.find('[data-field="total_qtde"]').val(parseInt(item.total_qtde || 0, 10));
    $item.find('[data-field="total_produto"]').val(formatMoneyInput(total));
    $item.find('.cp-compra-item-total').text('R$ ' + formatMoneyBr(total));
}

function cpLocalizacaoBadge(localizacao, label) {
    const value = localizacao || 'KidStok';
    const className = value === 'KidStok' ? 'badge-localizacao-kidstok' :
        cpLocalizacaoEhFornecedor(value) ? 'badge-localizacao-fornecedor' : 'badge-localizacao-allop';
    return '<span class="badge cp-localizacao-badge ' + className + '">' + escapeHtml(label || value) + '</span>';
}

function cpDataAttrs(itemIndex, detailIndex, name) {
    const detail = detailIndex === null ? '' : ' data-detail-index="' + detailIndex + '"';
    return 'data-item-index="' + itemIndex + '"' + detail + ' data-field="' + name + '"';
}

function addCpCompraTamanho(itemIndex) {
    syncCpCompraItensFromDom();
    if (!cpCompraItens[itemIndex] || !cpCompraItens[itemIndex].item_confirmado) {
        appAlert('Confirme o item antes de inserir tamanhos.', 'warning');
        return;
    }
    const tamanho = emptyCpCompraTamanho();
    tamanho.entrega = cpCompraItens[itemIndex].entrega || '';
    tamanho.entrega_anterior = cpCompraItens[itemIndex].entrega_anterior || cpCompraItens[itemIndex].entrega || '';
    cpCompraItensOpen[itemIndex] = true;
    cpCompraItens[itemIndex].tamanhos.push(tamanho);
    renderCpCompraItens();
}

function addCpCompraCor(itemIndex, tamanhoIndex) {
    syncCpCompraItensFromDom();
    const tamanho = cpCompraItens[itemIndex]?.tamanhos?.[tamanhoIndex];
    if (!tamanho) {
        return;
    }
    cpCompraItensOpen[itemIndex] = true;
    tamanho._aberto = true;
    tamanho.cores.push(emptyCpCompraCor());
    renderCpCompraItens();
}

function cpCompraItemCoresAtivas(item) {
    const map = {};
    (item.tamanhos || []).forEach(function (tamanho) {
        if (String(tamanho.Sts) === '0') {
            return;
        }
        (tamanho.cores || []).forEach(function (cor) {
            const nome = String(cor.cor || '').trim();
            if (nome && String(cor.Sts) !== '0') {
                map[nome] = true;
            }
        });
    });
    return Object.keys(map).sort();
}

function cpCompraItemRateioStatus(item) {
    const tamanhosAtivos = (item.tamanhos || []).filter(function (tamanho) {
        return String(tamanho.Sts) !== '0';
    });
    if (!tamanhosAtivos.length) {
        return { ok: false, message: 'Informe ao menos um tamanho ativo para ratear o item.' };
    }
    let referencia = null;
    for (let index = 0; index < tamanhosAtivos.length; index++) {
        const tamanho = tamanhosAtivos[index];
        const cores = (tamanho.cores || [])
            .filter(function (cor) { return String(cor.Sts) !== '0' && String(cor.cor || '').trim() !== ''; })
            .map(function (cor) { return String(cor.cor || '').trim(); })
            .sort();
        if (!cores.length) {
            return { ok: false, message: 'O tamanho ' + (tamanho.tamanho || index + 1) + ' não possui cores ativas para rateio.' };
        }
        if (referencia === null) {
            referencia = cores;
        } else if (referencia.length !== cores.length || referencia.join('|') !== cores.join('|')) {
            return { ok: false, message: 'Todos os tamanhos do item devem ter a mesma quantidade e o mesmo conjunto de cores para permitir rateio.' };
        }
    }
    return { ok: true, cores: referencia || [] };
}

function cpCompraItemPercentualTotal(item) {
    const rateios = {};
    (item.tamanhos || []).some(function (tamanho) {
        if (String(tamanho.Sts) === '0') {
            return false;
        }
        (tamanho.cores || []).forEach(function (cor) {
            const nome = String(cor.cor || '').trim();
            if (nome && String(cor.Sts) !== '0' && rateios[nome] === undefined) {
                rateios[nome] = Number(cor.percentual || 0);
            }
        });
        return Object.keys(rateios).length > 0;
    });
    return Object.keys(rateios).reduce(function (total, cor) {
        return roundCpPercent(total + Number(rateios[cor] || 0));
    }, 0);
}

function cpCompraItemPercentualCor(item, corNome) {
    corNome = String(corNome || '').trim();
    for (let tamanhoIndex = 0; tamanhoIndex < (item.tamanhos || []).length; tamanhoIndex++) {
        const tamanho = item.tamanhos[tamanhoIndex];
        for (let corIndex = 0; corIndex < (tamanho.cores || []).length; corIndex++) {
            const cor = tamanho.cores[corIndex];
            if (String(cor.cor || '').trim() === corNome) {
                return Number(cor.percentual || 0);
            }
        }
    }
    return 0;
}

function applyCpCompraItemRateio(item, rateios) {
    (item.tamanhos || []).forEach(function (tamanho) {
        (tamanho.cores || []).forEach(function (cor) {
            const nome = String(cor.cor || '').trim();
            cor.percentual = String(cor.Sts) === '0' ? 0 : Number(rateios[nome] || 0);
            delete cor._qtde_manual;
        });
    });
}

function ratearCpCompraItem(itemIndex) {
    syncCpCompraItensFromDom();
    const item = cpCompraItens[itemIndex];
    if (!item) {
        return;
    }
    const status = cpCompraItemRateioStatus(item);
    if (!status.ok) {
        appAlert(status.message, 'warning');
        return;
    }
    cpCompraRateioContext = {
        itemIndex: itemIndex,
        tamanhoIndex: null
    };
    renderCpCompraRateioItemModal(item, status.cores);
    bootstrap.Modal.getOrCreateInstance(document.getElementById('cp-rateio-modal')).show();
}

function ratearCpCompraTamanho(itemIndex, tamanhoIndex) {
    syncCpCompraItensFromDom();
    const tamanho = cpCompraItens[itemIndex]?.tamanhos?.[tamanhoIndex];
    if (!tamanho) {
        return;
    }

    const coresAtivas = (tamanho.cores || []).filter(function (cor) {
        return String(cor.Sts) !== '0';
    });
    if (!coresAtivas.length) {
        appAlert('Informe ao menos uma cor ativa para ratear este tamanho.', 'warning');
        return;
    }

    cpCompraRateioContext = {
        itemIndex: itemIndex,
        tamanhoIndex: tamanhoIndex
    };
    renderCpCompraRateioModal(tamanho, coresAtivas);
    bootstrap.Modal.getOrCreateInstance(document.getElementById('cp-rateio-modal')).show();
}

function renderCpCompraRateioItemModal(item, cores) {
    $('#cp-rateio-modal .modal-title').text('Rateio das Cores');
    $('#cp-rateio-modal .modal-header .text-muted.small').text('Informe o percentual de rateio das cores do item.');
    $('#cp-rateio-alert').addClass('d-none').text('');
    $('#cp-rateio-tamanho').closest('.col-12').find('label').text('Item');
    $('#cp-rateio-tamanho').val(item.referencia_fornecedor || '');
    $('#cp-rateio-qtde-total').closest('.col-12').addClass('d-none');
    $('#cp-rateio-total-percentual').closest('.col-12').removeClass('d-none');

    const rows = cores.map(function (corNome, index) {
        return '<tr data-cor="' + escapeAttr(corNome) + '">' +
            '<td>' + escapeHtml(corNome || 'Cor ' + (index + 1)) + '</td>' +
            '<td><input class="form-control form-control-sm text-end cp-rateio-percentual" inputmode="decimal" value="' + escapeAttr(formatPercentInput(cpCompraItemPercentualCor(item, corNome))) + '"></td>' +
            '</tr>';
    }).join('');

    $('#cp-rateio-content').html(
        '<div class="d-flex flex-wrap gap-2 justify-content-between align-items-center mb-2">' +
        '<span class="text-muted small">A soma dos percentuais das cores deve totalizar 100%.</span>' +
        '<button class="btn btn-sm btn-outline-primary" type="button" onclick="distribuirCpCompraRateioIgual()">Dividir igualmente</button>' +
        '</div>' +
        '<div class="table-responsive"><table class="table table-sm table-striped align-middle mb-0">' +
        '<thead><tr><th>Cor</th><th class="text-end" style="width: 180px;">Percentual</th></tr></thead>' +
        '<tbody>' + rows + '</tbody></table></div>'
    );
    updateCpCompraRateioModalTotal();
}

function renderCpCompraRateioModal(tamanho, coresAtivas) {
    $('#cp-rateio-modal .modal-title').text('Rateio de Quantidades');
    $('#cp-rateio-modal .modal-header .text-muted.small').text('Informe a quantidade total do tamanho e a quantidade de cada cor.');
    $('#cp-rateio-alert').addClass('d-none').text('');
    $('#cp-rateio-tamanho').closest('.col-12').find('label').text('Tamanho');
    $('#cp-rateio-qtde-total').closest('.col-12').removeClass('d-none');
    $('#cp-rateio-tamanho').val(tamanho.tamanho || '');
    $('#cp-rateio-qtde-total').val(parseInt(tamanho.qtde_total || 0, 10) || 0);

    const rows = coresAtivas.map(function (cor) {
        const originalIndex = (tamanho.cores || []).indexOf(cor);
        return '<tr data-color-index="' + originalIndex + '">' +
            '<td>' + escapeHtml(cor.cor || 'Cor ' + (originalIndex + 1)) + '</td>' +
            '<td><input class="form-control form-control-sm text-end cp-rateio-qtde" type="number" min="0" step="1" inputmode="numeric" value="' + escapeAttr(parseInt(cor.Qtde || 0, 10) || 0) + '"></td>' +
            '<td><input class="form-control form-control-sm text-end cp-rateio-percentual" inputmode="decimal" value="' + escapeAttr(formatPercentInput(cor.percentual || 0)) + '"></td>' +
            '</tr>';
    }).join('');

    $('#cp-rateio-content').html(
        '<div class="d-flex flex-wrap gap-2 justify-content-between align-items-center mb-2">' +
        '<span class="text-muted small">Informe percentual ou quantidade por cor. O sistema recalcula o outro campo automaticamente.</span>' +
        '<button class="btn btn-sm btn-outline-primary" type="button" onclick="distribuirCpCompraRateioIgual()">Dividir igualmente</button>' +
        '</div>' +
        '<div class="table-responsive"><table class="table table-sm table-striped align-middle mb-0">' +
        '<thead><tr><th>Cor</th><th class="text-end" style="width: 140px;">Qtde</th><th class="text-end" style="width: 180px;">Percentual</th></tr></thead>' +
        '<tbody>' + rows + '</tbody></table></div>'
    );
    updateCpCompraRateioModalTotal();
}

function updateCpCompraRateioModalTotal(event) {
    $('#cp-rateio-alert').addClass('d-none').text('');
    if (cpCompraRateioContext && cpCompraRateioContext.tamanhoIndex === null) {
        let totalItemPercentual = 0;
        $('#cp-rateio-content tbody tr').each(function () {
            totalItemPercentual = roundCpPercent(totalItemPercentual + parsePercentInput($(this).find('.cp-rateio-percentual').val()));
        });
        const validoItem = roundCpPercent(totalItemPercentual) === 100;
        $('#cp-rateio-total-percentual')
            .val(formatPercentInput(totalItemPercentual) + '%')
            .toggleClass('text-success', validoItem)
            .toggleClass('text-danger', !validoItem);
        return;
    }
    const qtdeTotal = Math.max(0, parseInt(String($('#cp-rateio-qtde-total').val() || '0').replace(/\D/g, ''), 10) || 0);
    const $rows = $('#cp-rateio-content tbody tr');
    const forcarQuantidade = event === 'quantidade';
    const $source = event && event.target ? $(event.target) : $();
    const percentuaisDigitados = [];
    let totalPercentual = 0;

    $rows.each(function () {
        const percentual = parsePercentInput($(this).find('.cp-rateio-percentual').val());
        percentuaisDigitados.push(percentual);
        totalPercentual = roundCpPercent(totalPercentual + percentual);
    });

    const atualizarPorPercentual = !forcarQuantidade && (!$source.length ||
        $source.hasClass('cp-rateio-percentual') ||
        ($source.is('#cp-rateio-qtde-total') && totalPercentual > 0));
    let qtdeAplicada = 0;

    if (atualizarPorPercentual) {
        $rows.each(function (index) {
            const percentual = percentuaisDigitados[index] || 0;
            let qtde = qtdeTotal > 0 ? Math.floor(qtdeTotal * percentual / 100) : 0;
            $(this).find('.cp-rateio-qtde').val(qtde);
            qtdeAplicada += qtde;
        });
        if ($rows.length && qtdeTotal > 0 && roundCpPercent(totalPercentual) === 100) {
            let sobra = qtdeTotal - qtdeAplicada;
            let rowIndex = 0;
            while (sobra > 0) {
                const $input = $rows.eq(rowIndex % $rows.length).find('.cp-rateio-qtde');
                $input.val((parseInt($input.val() || '0', 10) || 0) + 1);
                sobra -= 1;
                rowIndex += 1;
            }
            qtdeAplicada = qtdeTotal;
        }
    } else {
        const qties = [];
        $rows.each(function () {
            const qtde = Math.max(0, parseInt(String($(this).find('.cp-rateio-qtde').val() || '0').replace(/\D/g, ''), 10) || 0);
            qties.push(qtde);
            qtdeAplicada += qtde;
        });

        totalPercentual = 0;
        $rows.each(function (index) {
            const $row = $(this);
            const qtde = qties[index] || 0;
            const percentual = qtdeTotal > 0
                ? (qtdeAplicada === qtdeTotal && index === $rows.length - 1
                    ? roundCpPercentDisplay(100 - totalPercentual)
                    : roundCpPercentDisplay((qtde / qtdeTotal) * 100))
                : 0;
            totalPercentual = roundCpPercentDisplay(totalPercentual + percentual);
            $row.find('.cp-rateio-percentual').val(formatPercentInput(percentual));
        });

        if (qtdeAplicada !== qtdeTotal) {
            totalPercentual = qtdeTotal > 0 ? roundCpPercentDisplay((qtdeAplicada / qtdeTotal) * 100) : 0;
        }
    }

    const valido = qtdeTotal > 0 && qtdeAplicada === qtdeTotal && roundCpPercent(totalPercentual) === 100;
    $('#cp-rateio-total-percentual')
        .val(formatPercentInput(totalPercentual) + '%')
        .toggleClass('text-success', valido)
        .toggleClass('text-danger', !valido);
}

function distribuirCpCompraRateioIgual() {
    const $rows = $('#cp-rateio-content tbody tr');
    if (!$rows.length) {
        return;
    }
    if (cpCompraRateioContext && cpCompraRateioContext.tamanhoIndex === null) {
        $('#cp-rateio-alert').addClass('d-none').text('');
        const basePercentual = roundCpPercentDisplay(100 / $rows.length);
        let totalPercentualItem = 0;
        $rows.each(function (index) {
            const percentual = index === $rows.length - 1
                ? roundCpPercentDisplay(100 - totalPercentualItem)
                : basePercentual;
            totalPercentualItem = roundCpPercentDisplay(totalPercentualItem + percentual);
            $(this).find('.cp-rateio-percentual').val(formatPercentInput(percentual));
        });
        updateCpCompraRateioModalTotal();
        return;
    }
    const qtdeTotal = Math.max(0, parseInt(String($('#cp-rateio-qtde-total').val() || '0').replace(/\D/g, ''), 10) || 0);
    if (qtdeTotal <= 0) {
        $('#cp-rateio-alert').removeClass('d-none').text('Informe a quantidade total antes de dividir.');
        return;
    }
    $('#cp-rateio-alert').addClass('d-none').text('');
    const base = Math.floor(qtdeTotal / $rows.length);
    let restante = qtdeTotal - (base * $rows.length);
    let totalPercentual = 0;
    $rows.each(function (index) {
        const qtde = base + (restante > 0 ? 1 : 0);
        const percentual = index === $rows.length - 1
            ? roundCpPercentDisplay(100 - totalPercentual)
            : roundCpPercentDisplay((qtde / qtdeTotal) * 100);
        totalPercentual = roundCpPercentDisplay(totalPercentual + percentual);
        $(this).find('.cp-rateio-qtde').val(qtde);
        $(this).find('.cp-rateio-percentual').val(formatPercentInput(percentual));
        restante -= 1;
    });
    $('#cp-rateio-total-percentual')
        .val(formatPercentInput(totalPercentual) + '%')
        .toggleClass('text-success', roundCpPercentDisplay(totalPercentual) === 100)
        .toggleClass('text-danger', roundCpPercentDisplay(totalPercentual) !== 100);
}

function aplicarCpCompraRateio() {
    const context = cpCompraRateioContext;
    if (context && context.tamanhoIndex === null) {
        const item = cpCompraItens[context.itemIndex] || null;
        if (!item) {
            return;
        }
        const rateiosItem = {};
        let totalPercentualItem = 0;
        let invalidoItem = false;
        $('#cp-rateio-content tbody tr').each(function () {
            const corNome = String($(this).data('cor') || '').trim();
            const percentual = parsePercentInput($(this).find('.cp-rateio-percentual').val());
            if (percentual < 0 || percentual > 100) {
                invalidoItem = true;
            }
            rateiosItem[corNome] = percentual;
            totalPercentualItem = roundCpPercent(totalPercentualItem + percentual);
        });
        if (invalidoItem) {
            $('#cp-rateio-alert').removeClass('d-none').text('Cada percentual deve estar entre 0% e 100%.');
            return;
        }
        if (roundCpPercent(totalPercentualItem) !== 100) {
            $('#cp-rateio-alert').removeClass('d-none').text('O rateio das cores do item deve totalizar 100%. Total atual: ' + formatPercentInput(totalPercentualItem) + '%.');
            return;
        }
        applyCpCompraItemRateio(item, rateiosItem);
        cpCompraItensOpen[context.itemIndex] = true;
        (item.tamanhos || []).forEach(function (tamanho) {
            tamanho._aberto = true;
        });
        recalcCpCompraItem(item);
        renderCpCompraItens();
        recalcCpCompraTotal();
        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('cp-rateio-modal'));
        $('#cp-rateio-modal').one('hidden.bs.modal', function () {
            focusCpCompraQuantidadeTamanho(context.itemIndex);
        });
        modal.hide();
        return;
    }
    const tamanho = context ? cpCompraItens[context.itemIndex]?.tamanhos?.[context.tamanhoIndex] : null;
    if (!tamanho) {
        return;
    }

    const qtdeTotal = Math.max(0, parseInt(String($('#cp-rateio-qtde-total').val() || '0').replace(/\D/g, ''), 10) || 0);
    let totalPercentual = 0;
    let totalQtdeCores = 0;
    const rateios = [];

    $('#cp-rateio-content tbody tr').each(function () {
        const corIndex = Number($(this).data('color-index'));
        const qtde = Math.max(0, parseInt(String($(this).find('.cp-rateio-qtde').val() || '0').replace(/\D/g, ''), 10) || 0);
        const percentual = parsePercentInput($(this).find('.cp-rateio-percentual').val());
        totalQtdeCores += qtde;
        totalPercentual = roundCpPercent(totalPercentual + percentual);
        rateios.push({
            corIndex: corIndex,
            qtde: qtde,
            percentual: percentual,
            invalido: percentual < 0 || percentual > 100
        });
    });

    if (qtdeTotal <= 0) {
        $('#cp-rateio-alert').removeClass('d-none').text('Informe a quantidade total do tamanho.');
        return;
    }
    if (totalQtdeCores !== qtdeTotal) {
        $('#cp-rateio-alert').removeClass('d-none').text('A soma das quantidades das cores deve bater com a quantidade total. Total informado: ' + qtdeTotal + '. Soma das cores: ' + totalQtdeCores + '.');
        return;
    }

    if (rateios.some(function (row) { return row.invalido; })) {
        $('#cp-rateio-alert').removeClass('d-none').text('Cada percentual deve estar entre 0% e 100%.');
        return;
    }
    if (roundCpPercent(totalPercentual) !== 100) {
        $('#cp-rateio-alert').removeClass('d-none').text('O rateio do tamanho deve totalizar 100%. Total atual: ' + formatPercentInput(totalPercentual) + '%.');
        return;
    }

    (tamanho.cores || []).forEach(function (cor) {
        if (String(cor.Sts) === '0') {
            cor.percentual = 0;
        }
    });
    rateios.forEach(function (row) {
        if (tamanho.cores[row.corIndex]) {
            tamanho.cores[row.corIndex].Qtde = row.qtde;
            tamanho.cores[row.corIndex].percentual = row.percentual;
            delete tamanho.cores[row.corIndex]._qtde_manual;
        }
    });

    tamanho.qtde_total = qtdeTotal;
    cpCompraItensOpen[context.itemIndex] = true;
    tamanho._aberto = true;
    recalcCpCompraItem(cpCompraItens[context.itemIndex]);
    renderCpCompraItens();
    recalcCpCompraTotal();
    bootstrap.Modal.getOrCreateInstance(document.getElementById('cp-rateio-modal')).hide();
}

function confirmCpCompraItem(itemIndex) {
    syncCpCompraItensFromDom();
    const item = cpCompraItens[itemIndex] || null;
    if (!item) {
        return;
    }
    if (!item.referencia_fornecedor) {
        appAlert('Selecione a referência antes de confirmar o item.', 'warning');
        return;
    }

    item.item_confirmado = true;
    item.tamanhos = (item._pendingTamanhos && item._pendingTamanhos.length) ? item._pendingTamanhos : item.tamanhos;
    (item.tamanhos || []).forEach(function (tamanho) {
        tamanho.entrega = tamanho.entrega || item.entrega || '';
        tamanho.entrega_anterior = tamanho.entrega_anterior || item.entrega_anterior || tamanho.entrega || item.entrega || '';
    });
    const rateioStatus = cpCompraItemRateioStatus(item);
    if (!rateioStatus.ok) {
        appAlert(rateioStatus.message + ' Não será possível informar rateio para este item enquanto houver divergência.', 'warning');
    }
    item._pendingTamanhos = [];
    cpCompraItensOpen[itemIndex] = false;
    recalcCpCompraItem(item);
    renderCpCompraItens();
    recalcCpCompraTotal();
}

function focusCpCompraQuantidadeTamanho(itemIndex) {
    setTimeout(function () {
        const $field = $('.cp-compra-tamanho-field[data-item-index="' + itemIndex + '"][data-field="qtde_total"]').first();
        if ($field.length) {
            $field.trigger('focus').select();
        }
    }, 80);
}

function removeCpCompraItem(itemIndex) {
    syncCpCompraItensFromDom();
    if (!confirm('Excluir este item?')) {
        return;
    }
    const openBefore = Object.assign({}, cpCompraItensOpen);
    cpCompraItens.splice(itemIndex, 1);
    cpCompraItensOpen = {};
    cpCompraItens.forEach(function (_item, index) {
        const previousIndex = index >= itemIndex ? index + 1 : index;
        cpCompraItensOpen[index] = openBefore[previousIndex] === true;
    });
    renderCpCompraItens();
    recalcCpCompraTotal();
}

function removeCpCompraTamanho(itemIndex, tamanhoIndex) {
    syncCpCompraItensFromDom();
    if (!confirm('Excluir este tamanho?')) {
        return;
    }
    cpCompraItens[itemIndex]?.tamanhos?.splice(tamanhoIndex, 1);
    cpCompraItensOpen[itemIndex] = true;
    renderCpCompraItens();
    recalcCpCompraTotal();
}

function removeCpCompraCor(itemIndex, tamanhoIndex, corIndex) {
    syncCpCompraItensFromDom();
    if (!confirm('Excluir esta cor?')) {
        return;
    }
    cpCompraItens[itemIndex]?.tamanhos?.[tamanhoIndex]?.cores?.splice(corIndex, 1);
    cpCompraItensOpen[itemIndex] = true;
    if (cpCompraItens[itemIndex]?.tamanhos?.[tamanhoIndex]) {
        cpCompraItens[itemIndex].tamanhos[tamanhoIndex]._aberto = true;
    }
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
            return;
        }
        cpCompraItens[itemIndex][name] = normalizeCpCompraValue(name, value);
    });

    $('.cp-compra-tamanho-field, .cp-compra-cor-field').each(function () {
        const $field = $(this);
        const item = cpCompraItens[Number($field.data('item-index'))];
        const tamanho = item?.tamanhos?.[Number($field.data('size-index'))];
        if (!tamanho) {
            return;
        }
        const corIndexRaw = $field.attr('data-color-index');
        const target = corIndexRaw === undefined ? tamanho : tamanho.cores[Number(corIndexRaw)];
        if (target) {
            target[$field.data('field')] = normalizeCpCompraValue($field.data('field'), $field.val());
        }
    });

    cpCompraItens.forEach(function (item) {
        recalcCpCompraItem(item);
    });
}

function normalizeCpCompraValue(name, value) {
    if (name === 'Qtde' || name === 'qtde_total' || name === 'total_qtde' || name === 'Itens') {
        return parseInt(String(value || '0').replace(/\D/g, ''), 10) || 0;
    }
    if (name === 'percentual') {
        return parsePercentInput(value);
    }
    const moneyColumns = ['total_produto', 'preco_fornecedor', 'preco_proposta', 'valor_total_produto', 'preco_franqueado', 'preco_loja'];
    if (moneyColumns.includes(name)) {
        return parseMoneyInput(value);
    }
    const numeric = ['Foto', 'Sts', 'markup_franquia', 'markup_loja', 'markup_total', 'valor_total'];
    if (numeric.includes(name)) {
        return Number(String(value || '0').replace(',', '.')) || 0;
    }
    return value || '';
}

function recalcCpCompraItem(item) {
    let totalItem = 0;
    let totalQtdeItem = 0;
    const markups = cpCompraHeaderMarkups();
    (item.tamanhos || []).forEach(function (tamanho) {
        if (String(item.Sts) === '0') {
            tamanho.Sts = 0;
            tamanho.qtde_total = 0;
        } else if ((tamanho.cores || []).length) {
            updateCpCompraTamanhoStatusFromCores(tamanho);
        }
        const tamanhoAtivo = String(tamanho.Sts) !== '0';
        if (!tamanhoAtivo) {
            tamanho.qtde_total = 0;
        }
        const coresAtivas = (tamanho.cores || []).filter(function (cor) {
            return tamanhoAtivo && String(cor.Sts) !== '0';
        });
        const totalPercentual = cpCompraTamanhoPercentualTotal(tamanho);
        const temRateioItem = roundCpPercent(totalPercentual) > 0;
        const totalQtde = Math.max(0, parseInt(Number(tamanho.qtde_total || 0), 10) || 0);
        const temQtdeManual = coresAtivas.some(function (cor) {
            return cor._qtde_manual === true;
        });
        let qtdeAplicada = 0;

        (tamanho.cores || []).forEach(function (cor) {
            if (!tamanhoAtivo || String(cor.Sts) === '0') {
                cor.Qtde = 0;
            } else if (temQtdeManual) {
                cor.Qtde = Math.max(0, parseInt(Number(cor.Qtde || 0), 10) || 0);
            } else if (!temRateioItem && coresAtivas.length) {
                cor.Qtde = Math.floor(totalQtde / coresAtivas.length);
            } else {
                cor.Qtde = roundCpPercent(totalPercentual) === 100
                    ? Math.floor(totalQtde * Number(cor.percentual || 0) / 100)
                    : 0;
            }
            qtdeAplicada += Number(cor.Qtde || 0);
        });
        if (!temQtdeManual && coresAtivas.length && (!temRateioItem || roundCpPercent(totalPercentual) === 100)) {
            let sobra = totalQtde - qtdeAplicada;
            let corSobraIndex = 0;
            while (sobra > 0) {
                coresAtivas[corSobraIndex % coresAtivas.length].Qtde += 1;
                sobra -= 1;
                corSobraIndex += 1;
            }
        }
        let totalTamanho = 0;
        (tamanho.cores || []).forEach(function (cor) {
            applyCpCompraDetailMarkups(cor, markups);
            cor.valor_total_produto = (!tamanhoAtivo || String(cor.Sts) === '0')
                ? 0
                : roundCpMoney(Number(cor.Qtde || 0) * Number(cor.preco_proposta || 0));
            totalTamanho += Number(cor.valor_total_produto || 0);
        });
        tamanho.valor_total = roundCpMoney(totalTamanho);
        tamanho.Itens = coresAtivas.length;
        tamanho.markup_franquia = roundCpMoney(markups.franquia || 0);
        tamanho.markup_loja = roundCpMoney(markups.franqueadora || 0);
        totalQtdeItem += tamanhoAtivo ? (temQtdeManual ? qtdeAplicada : totalQtde) : 0;
        totalItem += totalTamanho;
    });
    item.total_qtde = totalQtdeItem;
    item.total_produto = roundCpMoney(totalItem);
}

function applyCpCompraDetailMarkups(detail, markups) {
    const precoProposta = Number(detail.preco_proposta || 0);
    detail.markup_franquia = roundCpMoney(markups.franquia || 0);
    detail.markup_loja = roundCpMoney(markups.franqueadora || 0);
    detail.markup_total = roundCpMoney(markups.total || 0);
    detail.preco_loja = roundCpMoney(precoProposta * Number(detail.markup_total || 0));
    detail.preco_franqueado = Number(detail.markup_franquia || 0) > 0
        ? roundCpMoney(Number(detail.preco_loja || 0) / Number(detail.markup_franquia || 0))
        : 0;
}

function updateCpCompraNestedDisplays(itemIndex) {
    const item = cpCompraItens[itemIndex] || null;
    if (!item) {
        return;
    }
    (item.tamanhos || []).forEach(function (tamanho, tamanhoIndex) {
        const $tamanho = $('.cp-compra-tamanho[data-item-index="' + itemIndex + '"][data-size-index="' + tamanhoIndex + '"]');
        const rateio = cpCompraTamanhoPercentualTotal(tamanho);
        const tamanhoInativo = String(tamanho.Sts) === '0';
        const rateioValido = !tamanhoInativo && roundCpPercent(rateio) === 100;
        $tamanho.find('.cp-tamanho-rateio-total')
            .val(formatPercentInput(rateio) + '%')
            .toggleClass('text-muted', tamanhoInativo)
            .toggleClass('text-success', rateioValido)
            .toggleClass('text-danger', !tamanhoInativo && !rateioValido);
        $tamanho.find('.cp-compra-tamanho-field[data-field="Sts"]').val(String(tamanho.Sts));
        $tamanho.find('.cp-tamanho-summary-qtde').text(tamanho.qtde_total || 0);
        $tamanho.find('.cp-tamanho-summary-entrega').text(tamanho.entrega ? formatDateBr(tamanho.entrega) : 'Não definida');
        $tamanho.find('.cp-tamanho-summary-rateio')
            .text(formatPercentInput(rateio) + '%')
            .toggleClass('text-muted', tamanhoInativo)
            .toggleClass('text-success', rateioValido)
            .toggleClass('text-danger', !tamanhoInativo && !rateioValido);
        $tamanho.find('.cp-tamanho-summary-total').text('R$ ' + formatMoneyBr(tamanho.valor_total || 0));
        $tamanho.find('.cp-compra-tamanho-field[data-field="valor_total"]').val(formatMoneyInput(tamanho.valor_total || 0));
        (tamanho.cores || []).forEach(function (cor, corIndex) {
            const $cor = $('.cp-compra-cor[data-item-index="' + itemIndex + '"][data-size-index="' + tamanhoIndex + '"][data-color-index="' + corIndex + '"]');
            $cor.find('.cp-compra-cor-field[data-field="Qtde"]').val(parseInt(cor.Qtde || 0, 10));
            $cor.find('.cp-compra-cor-field[data-field="preco_franqueado"]').val(formatMoneyInput(cor.preco_franqueado || 0));
            $cor.find('.cp-compra-cor-field[data-field="preco_loja"]').val(formatMoneyInput(cor.preco_loja || 0));
            $cor.find('.cp-compra-cor-field[data-field="valor_total_produto"]').val(formatMoneyInput(cor.valor_total_produto || 0));
            $cor.find('.cp-cor-summary-percentual').text(formatPercentInput(cor.percentual || 0) + '%');
            $cor.find('.cp-cor-summary-qtde').text(parseInt(cor.Qtde || 0, 10));
            $cor.find('.cp-cor-summary-preco-proposta').text('R$ ' + formatMoneyBr(cor.preco_proposta || 0));
            $cor.find('.cp-cor-summary-preco-fornecedor').text('R$ ' + formatMoneyBr(cor.preco_fornecedor || 0));
            $cor.find('.cp-cor-summary-preco-franqueado').text('R$ ' + formatMoneyBr(cor.preco_franqueado || 0));
            $cor.find('.cp-cor-summary-preco-loja').text('R$ ' + formatMoneyBr(cor.preco_loja || 0));
            $cor.find('.cp-cor-summary-total').text('R$ ' + formatMoneyBr(cor.valor_total_produto || 0));
        });
    });
    updateCpCompraItemTotalDisplay(itemIndex);
}

function recalcCpCompraTotal() {
    syncCpCompraItensFromDom();
    cpCompraItens.forEach(function (_item, itemIndex) {
        updateCpCompraNestedDisplays(itemIndex);
    });
    $('#cp-compras-form [name="ValorTotalPedido"]').val(formatMoneyInput(sumCpCompraTotal()));
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
    const referencias = {};
    for (let index = 0; index < cpCompraItens.length; index++) {
        const item = cpCompraItens[index];
        const referencia = String(item.referencia_fornecedor || '').trim();
        if (!referencia) {
            continue;
        }
        if (referencias[referencia]) {
            return 'A referência ' + referencia + ' já foi incluída neste pedido. Remova o item duplicado antes de salvar.';
        }
        referencias[referencia] = true;

        const itemAtivo = String(item.Sts) !== '0';
        if (!itemAtivo) {
            continue;
        }
        if (!(item.tamanhos || []).length) {
            return 'Informe ao menos um tamanho para a referência ' + referencia + '.';
        }
        let tamanhosAtivos = 0;
        const tamanhosUsados = {};
        let coresReferencia = null;
        const rateioItem = {};
        for (let tamanhoIndex = 0; tamanhoIndex < item.tamanhos.length; tamanhoIndex++) {
            const tamanho = item.tamanhos[tamanhoIndex];
            const tamanhoAtivo = String(tamanho.Sts) !== '0';
            if (!tamanhoAtivo) {
                continue;
            }
            const nomeTamanho = String(tamanho.tamanho || '').trim();
            if (!nomeTamanho) {
                return 'Informe o tamanho ' + (tamanhoIndex + 1) + ' da referência ' + referencia + '.';
            }
            if (tamanhosUsados[nomeTamanho]) {
                return 'O tamanho ' + nomeTamanho + ' está duplicado na referência ' + referencia + '.';
            }
            tamanhosUsados[nomeTamanho] = true;
            tamanhosAtivos += 1;
            const coresAtivas = (tamanho.cores || []).filter(function (cor) {
                return String(cor.Sts) !== '0';
            });
            if (!coresAtivas.length) {
                return 'Item ' + referencia + ', tamanho ' + nomeTamanho + ': informe ao menos uma cor ativa.';
            }
            const qtdeTotalTamanho = Math.max(0, parseInt(Number(tamanho.qtde_total || 0), 10) || 0);
            if (qtdeTotalTamanho <= 0) {
                return 'Item ' + referencia + ', tamanho ' + nomeTamanho + ': informe a quantidade total no rateio.';
            }
            const coresUsadas = {};
            const coresTamanho = [];
            let totalQtdeCores = 0;
            for (let corIndex = 0; corIndex < coresAtivas.length; corIndex++) {
                const nomeCor = String(coresAtivas[corIndex].cor || '').trim();
                if (!nomeCor) {
                    return 'Item ' + referencia + ', tamanho ' + nomeTamanho + ': informe todas as cores.';
                }
                if (coresUsadas[nomeCor]) {
                    return 'Item ' + referencia + ', tamanho ' + nomeTamanho + ', cor ' + nomeCor + ': cor duplicada.';
                }
                coresUsadas[nomeCor] = true;
                coresTamanho.push(nomeCor);
                const percentual = Number(coresAtivas[corIndex].percentual || 0);
                if (percentual < 0 || percentual > 100) {
                    return 'Item ' + referencia + ', cor ' + nomeCor + ': o percentual do rateio deve estar entre 0% e 100%.';
                }
                if (rateioItem[nomeCor] === undefined) {
                    rateioItem[nomeCor] = percentual;
                } else if (roundCpPercent(rateioItem[nomeCor]) !== roundCpPercent(percentual)) {
                    return 'Item ' + referencia + ', cor ' + nomeCor + ': o percentual do rateio deve ser igual em todos os tamanhos do item.';
                }
                totalQtdeCores += Math.max(0, parseInt(Number(coresAtivas[corIndex].Qtde || 0), 10) || 0);
            }
            coresTamanho.sort();
            if (coresReferencia === null) {
                coresReferencia = coresTamanho;
            } else if (coresReferencia.length !== coresTamanho.length || coresReferencia.join('|') !== coresTamanho.join('|')) {
                return 'Item ' + referencia + ': todos os tamanhos ativos devem ter a mesma quantidade e o mesmo conjunto de cores para permitir rateio. Verifique o tamanho ' + nomeTamanho + '.';
            }
            if (totalQtdeCores !== qtdeTotalTamanho) {
                return 'Item ' + referencia + ', tamanho ' + nomeTamanho + ': a soma das quantidades das cores deve bater com a quantidade total. Total informado: ' + qtdeTotalTamanho + '. Soma das cores: ' + totalQtdeCores + '.';
            }
        }
        if (itemAtivo && tamanhosAtivos > 0) {
            const totalRateioItem = Object.keys(rateioItem).reduce(function (total, cor) {
                return roundCpPercent(total + Number(rateioItem[cor] || 0));
            }, 0);
            if (roundCpPercent(totalRateioItem) > 0 && roundCpPercent(totalRateioItem) !== 100) {
                return 'Item ' + referencia + ': o rateio das cores do item deve totalizar 100%. Total atual: ' + formatPercentInput(totalRateioItem) + '%.';
            }
        }
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


