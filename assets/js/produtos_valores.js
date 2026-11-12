document.addEventListener('DOMContentLoaded', () => {
    const config = window.produtosValoresConfig;
    if (!config) return;
    const root = document.getElementById('pv-produtos');
    const notice = document.getElementById('pv-aviso');
    const form = document.getElementById('pv-filtros');
    const prices = ['PrecoVendaTabela', 'PrecoCompraTabela', 'PrecoCompra'];
    const fields = [...prices, 'SetorLaranja', 'PrecoCheio', 'Encomenda', 'Estilo'];
    const labels = { PrecoVendaTabela: 'Varejo', PrecoCompraTabela: 'Atacado', PrecoCompra: 'Compra', SetorLaranja: 'Setor Laranja', PrecoCheio: 'Preço Cheio', Encomenda: 'Encomenda', Estilo: 'Estilo' };
    const auditDate = value => !value || String(value).startsWith('0000-00-00') ? '—' : String(value).replace(/^(\d{4})-(\d{2})-(\d{2})/, '$3/$2/$1');
    const auditText = row => 'Inclusão: ' + auditDate(row.Inclusao) + ' · Alteração: ' + auditDate(row.Alteracao) + ' · Usuário: ' + (row.Usuario || '—');
    let filters = {}, page = 1, active = null, loading = false;
    function el(tag, cls = '', text) {
        const node = document.createElement(tag); node.className = cls;
        if (text !== undefined) node.textContent = text;
        return node;
    }
    function button(text, cls = 'btn btn-outline-secondary') { const node = el('button', cls, text); node.type = 'button'; return node; }
    function message(node, text, error = false) { node.className = 'alert ' + (error ? 'alert-danger' : 'alert-success'); node.textContent = text; }
    async function request(action, data = {}) {
        const response = await fetch(config.api + '?action=' + action, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) });
        let result;
        try { result = await response.json(); } catch (_) { throw new Error('Resposta inválida. Confira sua sessão e tente novamente.'); }
        if (!response.ok || !result.success) throw new Error(result.message || 'Não foi possível concluir a operação.');
        return result;
    }
    function money(raw) {
        let value = String(raw).trim();
        if (value.includes(',')) {
            if (!/^(?:\d+|\d{1,3}(?:\.\d{3})+),\d{1,2}$/.test(value)) throw new Error('Informe valores positivos com até duas casas decimais.');
            value = value.replace(/\./g, '').replace(',', '.');
        }
        if (!/^\d+(?:\.\d{1,2})?$/.test(value) || !Number.isFinite(Number(value)) || Number(value) > 99999999.99) throw new Error('Informe um valor entre 0 e 99.999.999,99.');
        return Number(value).toFixed(2);
    }
    function canonical(row) {
        return Object.fromEntries(fields.map(field => [field, prices.includes(field) ? Number(row[field] || 0).toFixed(2) : String(row[field] ?? '')]));
    }
    function patch(item) { return Object.fromEntries(fields.filter(field => item.values[field] !== item.original[field]).map(field => [field, item.values[field]])); }
    function dirty(state) { return state.items.some(item => Object.keys(patch(item)).length || item.invalid); }
    function canLeave() {
        if (!active) return true;
        if (active.busy) return false;
        return !dirty(active) || window.confirm('Descartar as alterações pendentes deste produto?');
    }
    function close() {
        if (!canLeave()) return false;
        if (active) { active.panel.hidden = true; active.toggle.setAttribute('aria-expanded', 'false'); active = null; }
        return true;
    }
    function choose(options, current, aria) {
        const select = el('select', 'form-select form-select-sm'); select.setAttribute('aria-label', aria);
        options.forEach(([value, label]) => { const option = el('option', '', label); option.value = String(value); select.append(option); });
        select.value = current; return select;
    }
    function rules(values, changed, half) {
        if (values.PrecoCheio === 'S') values.PrecoCompraTabela = values.PrecoVendaTabela;
        else if (changed.includes('PrecoVendaTabela') && half) values.PrecoCompraTabela = (Math.round(Number(values.PrecoVendaTabela.replace('.', '')) / 2) / 100).toFixed(2);
        if (Number(values.PrecoCompra) > Number(values.PrecoCompraTabela) || Number(values.PrecoCompraTabela) > Number(values.PrecoVendaTabela)) throw new Error('Os valores devem respeitar: compra ≤ atacado ≤ varejo.');
        return values;
    }
    function update(state) {
        let changed = 0, selected = 0, invalid = false;
        state.items.forEach(item => {
            const modified = Object.keys(patch(item)).length > 0;
            if (modified) changed++;
            if (item.checkbox.checked) selected++;
            invalid ||= item.invalid;
            item.tr.classList.toggle('pv-row-changed', modified);
            fields.forEach(field => item.controls[field].classList.toggle('pv-cell-changed', item.values[field] !== item.original[field]));
        });
        state.summary.textContent = selected + ' itens selecionados · ' + changed + ' itens alterados' + (invalid ? ' · Revise os campos destacados' : '');
        state.save.disabled = state.busy || invalid || changed === 0;
        state.apply.disabled = state.busy || selected === 0;
        state.all.checked = selected > 0 && selected === state.items.length;
        state.all.indeterminate = selected > 0 && selected < state.items.length;
    }
    async function open(product, toggle, panel, detailPage = 1) {
        if (loading) return;
        const same = active && active.toggle === toggle;
        if (!close()) return;
        if (same && detailPage === 0) return;
        loading = true; toggle.disabled = true; panel.hidden = false; toggle.setAttribute('aria-expanded', 'true');
        panel.textContent = 'Carregando tamanhos, cores e valores...';
        try {
            const result = await request('get', { ...filters, id: product.Referencia, details_page: detailPage || 1 });
            toggle.querySelector('.pv-audit').textContent = auditText(result.data);
            panel.replaceChildren();
            const state = { toggle, panel, items: [], busy: false };
            active = state;
            const info = el('p', 'small text-muted', result.halfWholesale
                ? 'Ao alterar o varejo, o atacado será calculado como metade do varejo. Com Preço Cheio = Sim, atacado e varejo serão iguais.'
                : 'Com Preço Cheio = Sim, atacado e varejo serão iguais.');
            const feedback = el('div'); feedback.setAttribute('role', 'status'); feedback.setAttribute('aria-live', 'polite');
            const bulk = el('div', 'pv-bulk');
            const bulkInputs = {};
            const styleOptions = result.styles.map(style => [String(style.Codigo), style.Descricao + (style.Status !== 'Ativo' ? ' (inativo)' : '')]);
            fields.forEach(field => {
                const label = el('label', 'pv-bulk-field'); label.append(el('span', 'form-label small', labels[field]));
                let input;
                if (prices.includes(field)) { input = el('input', 'form-control form-control-sm'); window.AllopDecimal.attach(input, 2); input.placeholder = 'Manter valor'; }
                else input = choose([['', 'Não alterar'], ...(field === 'Estilo' ? styleOptions : [['N', 'Não'], ['S', 'Sim']])], '', labels[field] + ' em lote');
                label.append(input); bulk.append(label); bulkInputs[field] = input;
            });
            const apply = button('Aplicar na grade', 'btn btn-outline-secondary'); state.apply = apply;
            const applyBox = el('div', 'pv-bulk-action'); applyBox.append(apply, el('small', 'text-muted', 'Aplica somente aos itens selecionados nesta página. Campos vazios mantêm o valor.'));
            const tableWrap = el('div', 'table-responsive pv-table-scroll');
            const table = el('table', 'table table-bordered align-middle pv-values-table');
            const head = el('thead'); const headRow = el('tr'); const checkHead = el('th');
            const all = el('input', 'form-check-input'); all.type = 'checkbox'; all.setAttribute('aria-label', 'Selecionar todos os itens desta página');
            state.all = all; checkHead.append(all); headRow.append(checkHead);
            ['Referência', 'Tamanho', 'Cor', ...fields.map(field => labels[field]), 'Consolidado', 'Inclusão', 'Alteração', 'Usuário'].forEach(label => headRow.append(el('th', '', label)));
            head.append(headRow); table.append(head); const body = el('tbody'); table.append(body); tableWrap.append(table);
            const footer = el('div', 'pv-editor-footer');
            const summary = el('span', 'small text-muted'); summary.setAttribute('aria-live', 'polite'); state.summary = summary;
            const actions = el('div', 'd-flex gap-2 flex-wrap'); const cancel = button('Cancelar'); const save = button('Salvar alterações', 'btn btn-orange btn-save'); state.save = save;
            actions.append(cancel, save); footer.append(summary, actions);
            function renderValues(item) {
                fields.forEach(field => {
                    if (prices.includes(field)) window.AllopDecimal.set(item.controls[field], item.values[field]);
                    else item.controls[field].value = item.values[field];
                    item.controls[field].classList.remove('is-invalid');
                });
                item.invalid = false;
            }
            result.rows.forEach(row => {
                const tr = el('tr'); const checkbox = el('input', 'form-check-input'); checkbox.type = 'checkbox'; checkbox.setAttribute('aria-label', 'Selecionar ' + row.Distribuidora);
                const checkCell = el('td'); checkCell.append(checkbox); tr.append(checkCell);
                tr.append(el('td', 'text-nowrap', row.Distribuidora));
                ['Tamanho', 'Cor'].forEach(field => tr.append(el('td', 'text-nowrap', result.labels[field]?.[row[field]] || String(row[field]))));
                const original = canonical(row);
                const item = { row, original, values: { ...original }, tr, checkbox, controls: {}, invalid: false }; state.items.push(item);
                fields.forEach(field => {
                    const td = el('td'); let input;
                    if (prices.includes(field)) { input = el('input', 'form-control form-control-sm pv-money'); window.AllopDecimal.attach(input, 2); }
                    else input = choose(field === 'Estilo' ? styleOptions : [['N', 'Não'], ['S', 'Sim']], original[field], labels[field]);
                    input.setAttribute('aria-label', labels[field] + ' de ' + row.Distribuidora); input.disabled = !config.canEdit;
                    td.append(input); tr.append(td); item.controls[field] = input;
                    input.addEventListener('input', () => {
                        item.invalid = true; input.classList.add('is-invalid'); update(state);
                    });
                    input.addEventListener('change', () => {
                        try {
                            const next = { ...item.values };
                            fields.forEach(key => { next[key] = prices.includes(key) ? money(item.controls[key].value) : item.controls[key].value; });
                            item.values = rules(next, [field], result.halfWholesale); renderValues(item); feedback.className = ''; feedback.textContent = '';
                        } catch (error) { item.invalid = true; input.classList.add('is-invalid'); message(feedback, row.Distribuidora + ': ' + error.message, true); }
                        update(state);
                    });
                });
                tr.append(el('td', '', row.Consolidado === 'S' ? 'Sim' : 'Pendente'));
                tr.append(el('td', 'text-nowrap', auditDate(row.Inclusao)), el('td', 'text-nowrap', auditDate(row.Alteracao)), el('td', 'text-nowrap', row.Usuario || '—'));
                checkbox.addEventListener('change', () => update(state)); checkbox.disabled = !config.canEdit;
                body.append(tr); renderValues(item);
            });
            all.disabled = !config.canEdit;
            all.addEventListener('change', () => { state.items.forEach(item => { item.checkbox.checked = all.checked; }); update(state); });
            apply.addEventListener('click', () => {
                try {
                    if (state.items.some(item => item.invalid)) throw new Error('Revise os campos inválidos da grade antes de aplicar em lote.');
                    const values = {};
                    fields.forEach(field => { if (bulkInputs[field].value !== '') values[field] = prices.includes(field) ? money(bulkInputs[field].value) : bulkInputs[field].value; });
                    if (!Object.keys(values).length) throw new Error('Informe ao menos um campo para aplicar.');
                    const proposals = state.items.filter(item => item.checkbox.checked).map(item => [item, rules({ ...item.values, ...values }, Object.keys(values), result.halfWholesale)]);
                    proposals.forEach(([item, next]) => { item.values = next; renderValues(item); });
                    message(feedback, 'Prévia aplicada na grade. Confira os valores destacados e clique em Salvar alterações.'); update(state);
                } catch (error) { message(feedback, error.message, true); }
            });
            cancel.addEventListener('click', close);
            save.addEventListener('click', async () => {
                const changes = state.items.filter(item => Object.keys(patch(item)).length).map(item => ({ id: item.row.Distribuidora, version: item.row._version, values: patch(item) }));
                if (!changes.length || state.items.some(item => item.invalid)) return;
                state.busy = true; update(state);
                const controls = [...panel.querySelectorAll('input, select, button')]; const disabled = controls.map(input => input.disabled); controls.forEach(input => { input.disabled = true; });
                try {
                    const response = await request('save', { id: product.Referencia, csrf: config.csrf, rows: changes });
                    state.items.forEach(item => { item.original = { ...item.values }; });
                    state.busy = false; active = null; panel.hidden = true; toggle.setAttribute('aria-expanded', 'false');
                    product.Consolidado = 'N'; toggle.querySelector('.pv-product-status').textContent = 'Pendente';
                    message(notice, product.Referencia + ': ' + response.message + ' ' + response.processed + ' itens atualizados.');
                } catch (error) { message(feedback, error.message, true); }
                finally { state.busy = false; controls.forEach((input, i) => { input.disabled = disabled[i]; }); update(state); }
            });
            const detailNav = el('div', 'd-flex justify-content-between align-items-center gap-2 mt-3');
            const previous = button('Itens anteriores'); const next = button('Próximos itens');
            previous.disabled = result.page <= 1; next.disabled = !result.more;
            previous.addEventListener('click', () => open(product, toggle, panel, result.page - 1)); next.addEventListener('click', () => open(product, toggle, panel, result.page + 1));
            detailNav.append(previous, el('span', 'small text-muted', 'Página de itens ' + result.page + ' · ' + result.rows.length + ' itens exibidos'), next);
            panel.append(info);
            if (config.canEdit) panel.append(bulk, applyBox);
            else panel.append(el('div', 'alert alert-info', 'Seu perfil permite consultar os valores. A edição está desabilitada.'));
            panel.append(feedback, tableWrap);
            if (!result.rows.length) panel.append(el('p', 'text-muted', 'Nenhum item corresponde aos filtros.'));
            panel.append(detailNav, footer);
            if (!config.canEdit) save.hidden = true;
            update(state);
        } catch (error) { panel.hidden = true; toggle.setAttribute('aria-expanded', 'false'); active = null; message(notice, error.message, true); }
        finally { loading = false; toggle.disabled = false; }
    }
    async function loadList(nextPage = 1, nextFilters = filters) {
        if (loading || !close()) return;
        loading = true;
        const nav = [document.getElementById('pv-anterior'), document.getElementById('pv-proxima')]; nav.forEach(input => { input.disabled = true; });
        try {
            const result = await request('list', { ...nextFilters, page: nextPage });
            page = result.page; filters = { ...nextFilters }; root.replaceChildren();
            document.getElementById('pv-filtros-resumo').textContent = Object.values(filters).filter(value => value !== '').length + ' filtros ativos';
            result.data.forEach((product, index) => {
                const section = el('div', 'pv-product'); const toggle = button('', 'pv-product-toggle');
                toggle.id = 'pv-toggle-' + index; toggle.setAttribute('aria-expanded', 'false'); toggle.setAttribute('aria-controls', 'pv-panel-' + index);
                const title = el('span'); title.append(el('strong', 'd-block', product.Referencia), el('span', 'small', product.Descricao));
                title.append(el('small', 'pv-audit d-block text-muted mt-1', auditText(product)));
                const supplier = el('span', 'small'); supplier.append(el('span', 'd-block', product.NomeFornecedor || product.Fornecedor), el('span', 'text-muted', product.TipoProduto || product.Categoria));
                toggle.append(title, supplier, el('span', 'small', product.Quantidade + ' de ' + product.Total), el('span', 'badge bg-secondary pv-product-status', product.Consolidado === 'S' ? 'Consolidado' : 'Pendente'));
                const panel = el('div', 'pv-panel'); panel.id = 'pv-panel-' + index; panel.hidden = true; panel.setAttribute('role', 'region'); panel.setAttribute('aria-labelledby', toggle.id);
                toggle.addEventListener('click', () => open(product, toggle, panel, 0)); section.append(toggle, panel); root.append(section);
            });
            if (!result.data.length) root.append(el('p', 'text-muted p-3', 'Nenhum produto encontrado. Ajuste os filtros e tente novamente.'));
            document.getElementById('pv-pagina').textContent = 'Página ' + page + ' · ' + result.data.length + ' produtos';
            nav[0].disabled = page <= 1; nav[1].disabled = !result.more;
        } catch (error) { message(notice, error.message, true); nav[0].disabled = page <= 1; nav[1].disabled = false; }
        finally { loading = false; }
    }
    if (window.jQuery && window.jQuery.fn.select2) {
        window.jQuery('.pv-select').each(function () {
            const field = this.dataset.field;
            window.jQuery(this).select2({ width: '100%', placeholder: 'Todos', allowClear: true, language: { noResults: () => 'Nenhum resultado', searching: () => 'Pesquisando...' }, ajax: {
                url: config.optionsApi, dataType: 'json', delay: 200,
                data: params => ({ cadastro: 'valores', action: 'options', field, q: params.term || '' }),
                processResults: response => ({ results: response.results || [] }),
            } });
        });
    }
    form.addEventListener('submit', event => { event.preventDefault(); loadList(1, Object.fromEntries(new FormData(form))); });
    document.getElementById('pv-limpar').addEventListener('click', () => {
        if (loading || !close()) return;
        form.reset(); if (window.jQuery) window.jQuery('.pv-select').val(null).trigger('change'); loadList(1, {});
    });
    document.getElementById('pv-anterior').addEventListener('click', () => loadList(page - 1));
    document.getElementById('pv-proxima').addEventListener('click', () => loadList(page + 1));
    window.addEventListener('beforeunload', event => { if (active && (active.busy || dirty(active))) { event.preventDefault(); event.returnValue = ''; } });
    loadList();
});
