document.addEventListener('DOMContentLoaded', () => {
    const config = window.grupoCategoriaConfig;
    if (!config) return;
    const root = document.getElementById('gc-grupos');
    const notice = document.getElementById('gc-aviso');
    let active = null;
    let loading = false;
    const normalize = value => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
    const auditDate = value => !value || String(value).startsWith('0000-00-00') ? '—' : String(value).replace(/^(\d{4})-(\d{2})-(\d{2})/, '$3/$2/$1');
    const auditText = row => 'Inclusão: ' + auditDate(row.Inclusao) + ' · Alteração: ' + auditDate(row.Alteracao) + ' · Usuário: ' + (row.Usuario || '—');
    function element(tag, className, text) {
        const node = document.createElement(tag);
        node.className = className || '';
        if (text !== undefined) node.textContent = text;
        return node;
    }
    function message(target, text, error = false) {
        target.className = 'alert ' + (error ? 'alert-danger' : 'alert-success');
        target.textContent = text;
    }
    async function request(action, data = null) {
        const response = await fetch(config.api + (config.api.includes('?') ? '&' : '?') + 'action=' + action, data === null ? {} : {
            method: 'POST', headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
        });
        let result;
        try { result = await response.json(); } catch (_) { throw new Error('Resposta inválida. Confira sua sessão e tente novamente.'); }
        if (!response.ok || !result.success) throw new Error(result.message || 'Não foi possível concluir a operação.');
        return result;
    }
    function changes(state) {
        let added = 0, removed = 0;
        state.inputs.forEach(input => {
            if (input.checked && !state.original.has(input.value)) added++;
            if (!input.checked && state.original.has(input.value)) removed++;
        });
        return { added, removed, dirty: added + removed > 0 };
    }
    function closeCurrent() {
        if (!active) return true;
        if (active.busy) return false;
        if (changes(active).dirty && !window.confirm('Descartar as alterações pendentes deste registro?')) return false;
        active.panel.hidden = true;
        active.button.setAttribute('aria-expanded', 'false');
        active = null;
        return true;
    }
    function filterGroups() {
        const query = normalize(document.getElementById('gc-grupos-busca').value);
        let count = 0;
        root.querySelectorAll('.gc-group').forEach(row => {
            row.hidden = !normalize(row.dataset.name).includes(query) && !(active && active.row === row);
            if (!row.hidden) count++;
        });
        document.getElementById('gc-vazio').hidden = count !== 0;
    }
    async function openGroup(row, button, panel, group, counter) {
        if (loading) return;
        const same = active && active.row === row;
        if (!closeCurrent()) return;
        filterGroups();
        if (same) return;
        loading = true;
        button.disabled = true;
        panel.hidden = false;
        panel.textContent = 'Carregando ' + config.childrenLabel + '...';
        button.setAttribute('aria-expanded', 'true');
        try {
            const result = await request('get', { grupo: String(group.Grupo) });
            panel.replaceChildren();
            const state = { row, panel, button, inputs: [], original: new Set(result.vinculos.map(v => String(v.SubGrupo))), busy: false };
            active = state;
            const toolbar = element('div', 'gc-toolbar');
            const search = element('input', 'form-control');
            search.type = 'search'; search.placeholder = 'Buscar ' + config.childLabel; search.setAttribute('aria-label', 'Buscar ' + config.childLabel + ' em ' + group.Nome);
            const filter = element('select', 'form-select');
            filter.setAttribute('aria-label', 'Filtrar vínculos');
            const total = result.data.length, linked = state.original.size;
            [['all', 'Todos os itens (' + total + ')'], ['linked', 'Vinculados (' + linked + ')'], ['unlinked', 'Não vinculados (' + (total - linked) + ')']].forEach(([value, text]) => {
                const option = element('option', '', text); option.value = value; filter.append(option);
            });
            toolbar.append(search, filter);
            const list = element('div', 'gc-categories');
            const empty = element('p', 'text-muted', 'Nenhum item encontrado.'); empty.hidden = true;
            const feedback = element('div'); feedback.setAttribute('role', 'status');
            const footer = element('div', 'gc-footer');
            const summary = element('span', 'small text-muted'); summary.setAttribute('aria-live', 'polite');
            const actions = element('div', 'd-flex gap-2');
            const cancel = element('button', 'btn btn-outline-secondary', 'Cancelar'); cancel.type = 'button';
            const save = element('button', 'btn btn-orange btn-save', 'Salvar alterações'); save.type = 'button'; save.disabled = true;
            if (!config.canInsert && !config.canRemove) save.hidden = true;
            actions.append(cancel, save); footer.append(summary, actions);
            result.data.sort((a, b) => a.Nome.localeCompare(b.Nome, 'pt-BR', { sensitivity: 'base' })).forEach(category => {
                const label = element('label', 'gc-category');
                const input = element('input', 'form-check-input'); input.type = 'checkbox'; input.value = String(category.Valor);
                input.dataset.name = category.Nome;
                input.checked = state.original.has(input.value);
                input.disabled = input.checked ? !config.canRemove : (!config.canInsert || group.Status !== 'Ativo' || category.Status !== 'Ativo');
                const text = element('span', '', category.Nome + (category.Status !== 'Ativo' ? ' (inativa)' : ''));
                const link = result.vinculos.find(row => String(row.SubGrupo) === input.value);
                if (link) text.append(element('small', 'd-block text-muted mt-1', auditText(link)));
                label.append(input, text); list.append(label); state.inputs.push(input);
                input.addEventListener('change', update);
            });
            function update() {
                const diff = changes(state);
                const selectedCount = state.inputs.filter(input => input.checked).length;
                filter.options[1].textContent = 'Vinculados (' + selectedCount + ')';
                filter.options[2].textContent = 'Não vinculados (' + (total - selectedCount) + ')';
                summary.textContent = diff.dirty ? diff.added + ' inclusões e ' + diff.removed + ' remoções pendentes' : 'Nenhuma alteração pendente';
                save.disabled = !diff.dirty || state.busy;
                let visible = 0;
                state.inputs.forEach(input => {
                    const show = normalize(input.dataset.name).includes(normalize(search.value)) &&
                        (filter.value === 'all' || (filter.value === 'linked' ? input.checked : !input.checked));
                    input.parentElement.hidden = !show;
                    if (show) visible++;
                });
                list.style.setProperty('--gc-rows', String(Math.max(1, Math.ceil(visible / 2))));
                empty.hidden = visible > 0;
            }
            search.addEventListener('input', update); filter.addEventListener('change', update);
            cancel.addEventListener('click', () => { if (closeCurrent()) filterGroups(); });
            save.addEventListener('click', async () => {
                state.busy = true; update(); cancel.disabled = true;
                const disabled = state.inputs.map(input => input.disabled);
                state.inputs.forEach(input => { input.disabled = true; });
                try {
                    const selected = state.inputs.filter(input => input.checked).map(input => input.value);
                    const response = await request('save', { grupo: String(group.Grupo), categorias: selected, version: result.version, csrf: config.csrf });
                    state.original = new Set(selected); counter.textContent = String(selected.length);
                    panel.hidden = true; button.setAttribute('aria-expanded', 'false'); active = null;
                    message(notice, group.Nome + ': ' + response.message + ' ' + response.added + ' inclusões e ' + response.removed + ' remoções.');
                    filterGroups();
                } catch (error) {
                    message(feedback, error.message, true);
                } finally {
                    state.busy = false; cancel.disabled = false;
                    state.inputs.forEach((input, i) => { input.disabled = disabled[i]; }); update();
                }
            });
            panel.append(toolbar, list, empty, feedback, footer); update(); search.focus();
        } catch (error) {
            panel.hidden = true; button.setAttribute('aria-expanded', 'false');
            message(notice, error.message, true);
        } finally { loading = false; button.disabled = false; }
    }
    document.getElementById('gc-grupos-busca').addEventListener('input', filterGroups);
    window.addEventListener('beforeunload', event => {
        if (active && (active.busy || changes(active).dirty)) { event.preventDefault(); event.returnValue = ''; }
    });
    request('list').then(result => {
        root.replaceChildren();
        result.data.forEach((group, index) => {
            const row = element('div', 'gc-group'); row.dataset.name = group.Nome;
            const button = element('button', 'gc-group-toggle'); button.type = 'button';
            button.id = 'gc-toggle-' + index;
            button.setAttribute('aria-expanded', 'false'); button.setAttribute('aria-controls', 'gc-panel-' + index);
            const title = element('span', '', group.Nome + (group.Status !== 'Ativo' ? ' (inativo)' : ''));
            title.append(element('small', 'd-block text-muted fw-normal mt-1', auditText(group)));
            const count = element('span', 'badge bg-secondary', String(group.Quantidade));
            button.append(title, count);
            const panel = element('div', 'gc-panel'); panel.id = 'gc-panel-' + index; panel.hidden = true;
            panel.setAttribute('role', 'region'); panel.setAttribute('aria-labelledby', button.id);
            button.addEventListener('click', () => openGroup(row, button, panel, group, count));
            row.append(button, panel); root.append(row);
        });
        filterGroups();
    }).catch(error => { root.textContent = ''; message(notice, error.message, true); });
});
