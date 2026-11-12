document.addEventListener('DOMContentLoaded', () => {
    const config = window.produtosAccordionConfig;
    if (!config) return;
    const list = document.getElementById('pc-list');
    const filterForm = document.getElementById('pc-filter');
    const notice = document.getElementById('pc-notice');
    const $ = window.jQuery;
    let active = null, loading = false, page = 1, filters = {}, more = false;
    const cash = value => Number(value || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    const auditDate = value => !value || String(value).startsWith('0000-00-00') ? '—' : String(value).replace(/^(\d{4})-(\d{2})-(\d{2})/, '$3/$2/$1');
    const auditText = row => 'Inclusão: ' + auditDate(row.Inclusao) + ' · Alteração: ' + auditDate(row.Alteracao) + ' · Usuário: ' + (row.Usuario || '—');
    function el(tag, cls = '', text) { const node = document.createElement(tag); node.className = cls; if (text !== undefined) node.textContent = text; return node; }
    function button(text, cls = 'btn btn-outline-secondary btn-sm') { const node = el('button', cls, text); node.type = 'button'; return node; }
    function message(node, text, error = false) { node.classList.remove('alert-danger', 'alert-success'); node.classList.add('alert', error ? 'alert-danger' : 'alert-success'); node.textContent = text; }
    async function api(action, data = {}, entity = 'produtos', method = 'GET') {
        const query = new URLSearchParams({ cadastro: entity, action });
        const options = method === 'GET' ? {} : { method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) };
        if (method === 'GET') Object.entries(data).forEach(([key, value]) => {
            if (Array.isArray(value)) value.forEach(item => query.append(key + '[]', String(item)));
            else query.set(key, String(value));
        });
        return read(await fetch(config.api + '?' + query, options));
    }
    async function read(response) {
        let result;
        try { result = await response.json(); } catch (_) { throw new Error('Resposta inválida. Confira a sessão e tente novamente.'); }
        if (!response.ok || !result.success) throw new Error(result.message || 'Não foi possível concluir a operação.');
        return result;
    }
    function values(state) {
        return Object.fromEntries([...state.form.querySelectorAll('.pc-editor-control')].map(input => [input.dataset.field,
            input.multiple ? [...input.selectedOptions].map(option => option.value) : (input.hasAttribute('data-decimal-places') ? window.AllopDecimal.canonical(input) : input.value)]));
    }
    function filterValues() {
        const result = Object.fromEntries(new FormData(filterForm));
        filterForm.querySelectorAll('select[multiple][name]').forEach(input => {
            delete result[input.name];
            result[input.name.replace(/\[\]$/, '')] = [...input.selectedOptions].map(option => option.value);
        });
        return result;
    }
    function fingerprint(state) { return JSON.stringify(values(state)); }
    function dirty(state) { return state.ready && fingerprint(state) !== state.original; }
    function summary(state) {
        state.form.querySelector('.pc-editor-summary').textContent = dirty(state) ? 'Alterações pendentes' : (state.readonly ? 'Modo de consulta' : 'Nenhuma alteração pendente');
        const save = state.form.querySelector('.pc-save'); if (save) save.disabled = state.busy || !state.ready || state.readonly || (state.id !== '' && !dirty(state));
    }
    function canLeave() {
        return !active || (!active.busy && (!dirty(active) || window.confirm('Descartar as alterações pendentes deste produto?')));
    }
    function close() {
        if (!canLeave()) return false;
        if (active) {
            $(active.form).find('.pc-editor-select').each(function () { if ($(this).data('select2')) $(this).select2('destroy'); });
            active.panel.replaceChildren(); active.panel.hidden = true; active.toggle.setAttribute('aria-expanded', 'false');
            if (!active.id) active.section.remove();
            active = null;
        }
        return true;
    }
    function select2(node, parent) {
        $(node).select2({ width: '100%', placeholder: parent ? 'Selecione' : 'Todos', allowClear: true, closeOnSelect: !node.multiple,
            ajax: { url: config.api, dataType: 'json', delay: 200,
                data: params => ({ cadastro: 'produtos', action: 'options', field: node.dataset.field, q: params.term || '',
                    Grupo: parent ? parent.form.querySelector('[data-field="Grupo"]').value : (filterForm.elements.Grupo?.value || '') }),
                processResults: response => ({ results: response.results || [] }) }
        });
    }
    document.querySelectorAll('.pc-filter-select').forEach(node => select2(node));
    const search = $('#pc-search');
    search.select2({ width: '100%', placeholder: 'Pesquisar referência ou descrição', allowClear: true,
        language: { noResults: () => 'Nenhum produto encontrado', searching: () => 'Pesquisando...', loadingMore: () => 'Carregando mais produtos...' },
        ajax: { url: config.api, dataType: 'json', delay: 250,
            data: params => ({ cadastro: 'produtos', action: 'product_search', q: params.term || '', page: params.page || 1 }),
            processResults: response => ({ results: response.results || [], pagination: response.pagination }) }
    });
    search.on('select2:selecting select2:clearing', event => { if (loading || !close()) event.preventDefault(); });
    search.on('change.pcSearch', () => loadList(1, filterValues()));
    function paintHeader(state, row, related = {}) {
        Object.assign(state.product, row);
        if (row.Referencia && state.toggle.id === 'pc-row-new') {
            state.toggle.id = 'pc-row-' + row.Referencia;
            state.panel.id = state.toggle.id + '-panel';
            state.toggle.setAttribute('aria-controls', state.panel.id);
            state.panel.setAttribute('aria-labelledby', state.toggle.id);
        }
        state.toggle.querySelector('.pc-reference').textContent = row.Referencia || 'Novo produto';
        state.toggle.querySelector('.pc-description').textContent = row.Descricao || 'Preencha os dados do produto';
        state.toggle.querySelector('.pc-audit').textContent = auditText(row);
        state.toggle.querySelector('.pc-supplier').textContent = related.Fornecedor || state.product.Fornecedor_text || row.Fornecedor || '';
        state.toggle.querySelector('.pc-category').textContent = related.Categoria || state.product.Categoria_text || row.Categoria || '';
        state.toggle.querySelector('.pc-state').textContent = row.Status || '';
        const status = state.toggle.querySelector('.pc-consolidated');
        status.textContent = row.Consolidado === 'S' ? 'Consolidado' : 'Pendente';
        status.classList.toggle('pc-pending', row.Consolidado !== 'S');
    }
    function applyRecord(state, result) {
        state.ready = false;
        const row = result.data;
        state.record = { ...row };
        state.related = result.related || {};
        state.version = result.version;
        state.form.querySelectorAll('.pc-editor-control').forEach(input => {
            const field = input.dataset.field;
            const value = row[field];
            if (input.classList.contains('pc-editor-select')) {
                input.replaceChildren();
                if (!input.multiple) input.append(new Option('', ''));
                if (input.multiple) {
                    String(value || '').split(';').filter(Boolean).forEach(id => input.append(new Option(state.related[field]?.[id] || id, id, true, true)));
                } else if (value !== undefined && value !== null && value !== '') input.append(new Option(state.related[field] || String(value), String(value), true, true));
                $(input).trigger('change.select2');
            } else if (value !== undefined) {
                if (input.hasAttribute('data-decimal-places')) window.AllopDecimal.set(input, value);
                else input.value = value === null ? '' : String(value);
            }
        });
        state.form.querySelectorAll('.pc-fields').forEach(fieldset => { fieldset.disabled = state.readonly; });
        ['Fornecedor', 'Categoria', 'CodFornecedorR3'].forEach(field => { state.form.querySelector('[data-field="' + field + '"]').disabled = state.readonly || state.id !== ''; });
        state.form.querySelectorAll('.pc-tab').forEach(tab => { tab.disabled = state.id === '' && ['fotos', 'historico'].includes(tab.dataset.tab); });
        const remove = state.form.querySelector('.pc-delete'); if (remove) remove.hidden = !state.id;
        state.original = fingerprint(state); state.ready = true;
        paintHeader(state, row, state.related); renderGrade(state, result);
        summary(state);
    }
    function tab(state, name, focus = false) {
        state.form.querySelectorAll('.pc-tab').forEach(node => { const selected = node.dataset.tab === name; node.setAttribute('aria-selected', String(selected)); node.tabIndex = selected ? 0 : -1; if (selected && focus) node.focus(); });
        state.form.querySelectorAll('.pc-tab-pane').forEach(node => { node.hidden = node.dataset.pane !== name; });
        if (name === 'fotos' && !state.photosLoaded) loadPhotos(state);
        if (name === 'historico' && !state.historyLoaded) loadHistory(state, 1);
    }
    function pager(area, current, hasMore, load) {
        const nav = el('div', 'd-flex justify-content-between align-items-center gap-2 mt-3');
        const prev = button('Anterior'), next = button('Próxima'); prev.disabled = current <= 1; next.disabled = !hasMore;
        prev.addEventListener('click', () => load(current - 1)); next.addEventListener('click', () => load(current + 1));
        nav.append(prev, el('span', 'small text-muted', 'Página ' + current), next); area.append(nav);
    }
    function table(area, headers, rows) {
        const wrap = el('div', 'pc-table-scroll'); const grid = el('table', 'table table-bordered align-middle pc-detail-table');
        const head = el('thead'); const tr = el('tr'); headers.forEach(text => tr.append(el('th', '', text))); head.append(tr); grid.append(head);
        const body = el('tbody'); rows.forEach(cells => { const line = el('tr'); cells.forEach(cell => line.append(el('td', '', cell))); body.append(line); });
        grid.append(body); wrap.append(grid); area.append(wrap);
    }
    function renderGrade(state, result) {
        const area = state.form.querySelector('.pc-grade-area'); area.replaceChildren();
        area.append(el('h3', 'h6', 'Referências cadastradas'));
        if (!state.id) { area.append(el('p', 'text-muted', 'Salve o produto para gerar as referências de tamanho e cor.')); return; }
        if (!result.details?.length) area.append(el('p', 'text-muted', 'Nenhuma referência cadastrada.'));
        else table(area, ['Referência', 'Tamanho', 'Cor', 'Compra', 'Atacado', 'Varejo', 'Status', 'Consolidado', 'Inclusão', 'Alteração', 'Usuário'], result.details.map(row => [row.Distribuidora, state.related.Tamanho?.[row.Tamanho] || row.Tamanho, state.related.Cor?.[row.Cor] || row.Cor, cash(row.PrecoCompra), cash(row.PrecoCompraTabela), cash(row.PrecoVendaTabela), row.Status, row.Consolidado === 'S' ? 'Sim' : 'Pendente', auditDate(row.Inclusao), auditDate(row.Alteracao), row.Usuario || '—']));
        pager(area, result.details_page || 1, result.details_more, async target => {
            if (state.busy) return; state.busy = true; summary(state);
            try { const response = await api('get', { id: state.id, details_page: target }); if (active === state) renderGrade(state, response); }
            catch (error) { message(state.feedback, error.message, true); }
            finally { state.busy = false; summary(state); }
        });
    }
    async function loadHistory(state, target) {
        if (!state.id || state.historyBusy) return;
        const area = state.form.querySelector('.pc-history-area'); area.textContent = 'Carregando histórico...'; state.historyBusy = true;
        try {
            const reference = state.form.querySelector('.pc-history-filter input').value.trim();
            const response = await api('price_history', { id: state.id, reference, page: target });
            if (active !== state) return;
            area.replaceChildren();
            if (!response.data.length) area.append(el('p', 'text-muted', 'Nenhuma alteração de preço registrada para esta seleção.'));
            else table(area, ['Data / Hora', 'Referência', 'Código', 'Ação', 'Compra anterior', 'Compra nova', 'Atacado anterior', 'Atacado novo', 'Varejo anterior', 'Varejo novo', 'Usuário'], response.data.map(row => [row.DataHora ? String(row.DataHora).replace(/^(\d{4})-(\d{2})-(\d{2})/, '$3/$2/$1') : '', row.Referencia, row.Produto, row.Acao, cash(row.CompraOLD), cash(row.CompraNEW), cash(row.AtacadoOLD), cash(row.AtacadoNEW), cash(row.VarejoOLD), cash(row.VarejoNEW), row.Usuario || '']));
            pager(area, response.page, response.more, next => loadHistory(state, next)); state.historyLoaded = true;
        } catch (error) { if (active === state) message(area, error.message, true); }
        finally { state.historyBusy = false; }
    }
    async function loadPhotos(state) {
        const area = state.form.querySelector('.pc-photos');
        if (!config.canViewPhotos) { area.textContent = 'Seu perfil não tem permissão para consultar fotos.'; state.photosLoaded = true; return; }
        area.textContent = 'Carregando fotos...';
        try {
            const result = await api('photos', { id: state.id }, 'fotos'); if (active !== state) return;
            area.replaceChildren();
            result.data.forEach(row => {
                const figure = el('figure', 'pc-photo'); const image = el('img'); image.loading = 'lazy'; image.alt = 'Foto ' + row.Sequencia + ' do produto ' + state.id;
                image.src = config.api + '?' + new URLSearchParams({ cadastro: 'fotos', action: 'photo', id: state.id, sequencia: row.Sequencia, version: Date.now() });
                figure.append(image);
                if (config.canDeletePhotos) {
                    const remove = button('Excluir foto', 'btn btn-sm btn-outline-danger');
                    remove.addEventListener('click', async () => {
                        if (state.busy || !window.confirm('Excluir esta foto do produto ' + state.id + '?')) return;
                        await photoProcess(state, 'photo_delete', { sequencia: row.Sequencia });
                    }); figure.append(remove);
                }
                area.append(figure);
            });
            if (!result.data.length) area.textContent = 'Nenhuma foto cadastrada.';
            state.photosLoaded = true;
        } catch (error) { if (active === state) message(area, error.message, true); }
    }
    async function photoProcess(state, action, extra = {}) {
        state.busy = true; summary(state);
        const controls = [...state.form.querySelectorAll('.pc-photo-send, .pc-photo button')]; controls.forEach(node => { node.disabled = true; });
        try {
            let options;
            if (action === 'photo_upload') {
                const input = state.form.querySelector('.pc-photo-upload input'); const file = input.files[0];
                if (!file) throw new Error('Selecione uma imagem.');
                if (file.size > 10 * 1024 * 1024) throw new Error('A imagem deve ter até 10 MB.');
                const data = new FormData(); data.append('foto', file); data.append('action', action); data.append('id', state.id); data.append('csrf', config.csrf);
                options = { method: 'POST', body: data };
            } else options = { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ ...extra, action, id: state.id, csrf: config.csrf }) };
            const result = await read(await fetch(config.processApi, options)); message(state.feedback, result.message);
            if (action === 'photo_upload') state.form.querySelector('.pc-photo-upload input').value = '';
            // Fotos atualizam a auditoria do cabecalho. Atualizar somente a versao, preservando a edicao local.
            const refreshed = await api('get', { id: state.id });
            const sameHeader = Object.entries(state.record).every(([key, value]) => ['Foto', 'Alteracao'].includes(key) || String(value ?? '') === String(refreshed.data[key] ?? ''));
            if (sameHeader) { state.version = refreshed.version; state.record = { ...refreshed.data }; }
            await loadPhotos(state);
        } catch (error) { message(state.feedback, error.message, true); }
        finally { state.busy = false; controls.forEach(node => { node.disabled = false; }); summary(state); }
    }
    async function open(product, section, toggle, panel, isNew = false) {
        if (loading) return;
        const same = active?.toggle === toggle; if (!close() || same) return;
        loading = true; toggle.disabled = true; panel.hidden = false; toggle.setAttribute('aria-expanded', 'true');
        const form = document.getElementById('pc-editor-template').content.firstElementChild.cloneNode(true); panel.append(form);
        const state = { id: isNew ? '' : product.Referencia, product, section, toggle, panel, form, feedback: form.querySelector('.pc-editor-feedback'), ready: false, readonly: isNew ? !config.canCreate : !config.canEdit, busy: false };
        active = state;
        form.querySelectorAll('[data-decimal-places]').forEach(node => window.AllopDecimal.attach(node, Number(node.dataset.decimalPlaces)));
        form.querySelectorAll('.pc-editor-select').forEach(node => select2(node, state));
        form.querySelectorAll('.pc-tab').forEach(node => {
            node.addEventListener('click', () => tab(state, node.dataset.tab));
            node.addEventListener('keydown', event => {
                if (!['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return; event.preventDefault();
                const nodes = [...form.querySelectorAll('.pc-tab:not(:disabled)')]; const current = nodes.indexOf(node);
                const index = event.key === 'Home' ? 0 : event.key === 'End' ? nodes.length - 1 : (current + (event.key === 'ArrowRight' ? 1 : -1) + nodes.length) % nodes.length;
                tab(state, nodes[index].dataset.tab, true);
            });
        });
        $(form).on('input change', '.pc-editor-control', () => { if (state.ready) summary(state); });
        $(form).on('change', '[data-field="Grupo"]', () => { if (state.ready) $(form.querySelector('[data-field="GrupoCategoria"]')).val(null).trigger('change'); });
        $(form).on('change', '[data-field="Fornecedor"], [data-field="Categoria"], [data-field="CodFornecedorR3"]', () => {
            if (!state.id) form.querySelector('[data-field="Referencia"]').value = ['Fornecedor', 'Categoria', 'CodFornecedorR3'].map(field => form.querySelector('[data-field="' + field + '"]').value).join('');
        });
        form.querySelector('.pc-close').addEventListener('click', close);
        form.querySelector('.pc-history-search').addEventListener('click', () => loadHistory(state, 1));
        form.querySelector('.pc-history-filter input').addEventListener('keydown', event => { if (event.key === 'Enter') { event.preventDefault(); loadHistory(state, 1); } });
        form.querySelector('.pc-photo-send')?.addEventListener('click', () => { if (!state.busy) photoProcess(state, 'photo_upload'); });
        form.querySelector('.pc-delete')?.addEventListener('click', async () => {
            if (state.busy || !canLeave() || !window.confirm('Excluir o produto ' + state.id + '? Referências já consolidadas serão preservadas.')) return;
            state.busy = true; summary(state);
            try { const result = await api('delete', { id: state.id, csrf: config.csrf }, 'produtos', 'POST'); state.original = fingerprint(state); state.busy = false; close(); message(notice, result.message); await loadList(page); }
            catch (error) { message(state.feedback, error.message, true); }
            finally { state.busy = false; summary(state); }
        });
        form.addEventListener('submit', async event => {
            event.preventDefault(); if (!state.ready || state.readonly || state.busy) return;
            if (!form.checkValidity()) {
                const invalid = form.querySelector(':invalid:not(fieldset)');
                if (invalid) {
                    const pane = invalid.closest('[data-pane]'); if (pane) tab(state, pane.dataset.pane);
                    if (invalid.classList.contains('pc-editor-select')) { message(state.feedback, 'Preencha o campo ' + form.querySelector('label[for="' + invalid.id + '"]').textContent + '.', true); $(invalid).select2('open'); }
                    else invalid.reportValidity();
                }
                return;
            }
            state.busy = true; summary(state);
            const editable = [...form.querySelectorAll('.pc-editor-control')]; const disabled = editable.map(node => node.disabled); editable.forEach(node => { node.disabled = true; });
            try {
                const data = { ...values(state), id: state.id, csrf: config.csrf }; if (state.id) data.version = state.version;
                const response = await api('save', data, 'produtos', 'POST');
                state.id = String(response.id); state.product.Referencia = state.id; state.readonly = !config.canEdit;
                const refreshed = await api('get', { id: state.id }); applyRecord(state, refreshed);
                state.historyLoaded = false;
                message(state.feedback, response.message + (response.skipped?.length ? ' Referências existentes preservadas: ' + response.skipped.join(', ') : ''));
            } catch (error) { message(state.feedback, error.message, true); }
            finally {
                if (!state.readonly) editable.forEach((node, i) => { node.disabled = disabled[i] || (state.id !== '' && ['Fornecedor', 'Categoria', 'CodFornecedorR3'].includes(node.dataset.field)); });
                state.busy = false; summary(state);
            }
        });
        try {
            const response = await api(isNew ? 'defaults' : 'get', isNew ? {} : { id: state.id });
            if (isNew) { delete response.data.Codigo; response.data.Referencia = ''; }
            applyRecord(state, response);
        } catch (error) { message(state.feedback, error.message, true); }
        finally { loading = false; toggle.disabled = false; }
    }
    function row(product, isNew = false) {
        const section = el('article', 'pc-product-row'); const toggle = button('', 'pc-product-toggle');
        const id = 'pc-row-' + (isNew ? 'new' : product.Referencia); toggle.id = id;
        toggle.setAttribute('aria-expanded', 'false'); toggle.setAttribute('aria-controls', id + '-panel');
        const title = el('span', 'pc-product-title'); title.append(el('strong', 'pc-reference', product.Referencia || 'Novo produto'), el('span', 'pc-description', product.Descricao || 'Preencha os dados do produto'));
        title.append(el('small', 'pc-audit d-block text-muted mt-1', auditText(product)));
        const supplier = el('span', 'pc-product-supplier'); supplier.append(el('span', 'pc-supplier', product.Fornecedor_text || product.Fornecedor || ''), el('span', 'pc-category', product.Categoria_text || product.Categoria || ''));
        const status = el('span', 'pc-product-badges'); status.append(el('span', 'pc-state', product.Status || ''), el('span', 'pc-consolidated' + (product.Consolidado === 'S' ? '' : ' pc-pending'), product.Consolidado === 'S' ? 'Consolidado' : 'Pendente'));
        toggle.append(title, supplier, status);
        const panel = el('div', 'pc-product-panel'); panel.id = id + '-panel'; panel.hidden = true; panel.setAttribute('role', 'region'); panel.setAttribute('aria-labelledby', id);
        toggle.addEventListener('click', () => open(product, section, toggle, panel, isNew && !product.Referencia));
        section.append(toggle, panel); return { section, toggle, panel };
    }
    async function loadList(target = 1, nextFilters = filters) {
        if (loading || !close()) return; loading = true; list.setAttribute('aria-busy', 'true');
        document.getElementById('pc-prev').disabled = true; document.getElementById('pc-next').disabled = true;
        try {
            const result = await api('list', { ...nextFilters, page: target }); page = result.page; more = result.more; filters = { ...nextFilters }; list.replaceChildren();
            result.data.forEach(product => list.append(row(product).section));
            if (!result.data.length) list.append(el('p', 'text-muted p-4', 'Nenhum produto encontrado.'));
            document.getElementById('pc-page-label').textContent = 'Página ' + page + ' · ' + result.data.length + ' produtos';
        } catch (error) { message(notice, error.message, true); }
        finally { loading = false; list.setAttribute('aria-busy', 'false'); document.getElementById('pc-prev').disabled = page <= 1; document.getElementById('pc-next').disabled = !more; }
    }
    filterForm.addEventListener('submit', event => { event.preventDefault(); loadList(1, filterValues()); });
    document.getElementById('pc-clear').addEventListener('click', () => { if (loading || !close()) return; filterForm.reset(); search.val(null).trigger('change.select2'); $(filterForm).find('.pc-filter-select').val(null).trigger('change'); loadList(1, {}); });
    document.getElementById('pc-prev').addEventListener('click', () => loadList(page - 1)); document.getElementById('pc-next').addEventListener('click', () => loadList(page + 1));
    document.getElementById('pc-new')?.addEventListener('click', () => {
        if (loading || !close()) return;
        const product = {}; const item = row(product, true); list.prepend(item.section); open(product, item.section, item.toggle, item.panel, true);
    });
    window.addEventListener('beforeunload', event => { if (active && (active.busy || dirty(active))) { event.preventDefault(); event.returnValue = ''; } });
    loadList();
});
