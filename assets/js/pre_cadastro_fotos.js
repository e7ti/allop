/* Imagens do pedido por item do pre-cadastro; selecao local para analise. */
window.AllopPreCadastroFotos = (function () {
    'use strict';
    const states = new Map();
    let generation = 0;

    function key(groupIndex, itemIndex) {
        return groupIndex + '-' + itemIndex;
    }

    function panel(groupIndex, itemIndex) {
        return '<section class="pre-cadastro-fotos" data-photo-group="' + groupIndex + '" data-photo-item="' + itemIndex + '" aria-label="Imagens do item">' +
            '<p class="text-muted">Veja as fotos do fornecedor e da KidStok. Marque a imagem que deseja analisar com IA.</p>' +
            '<div class="pre-cadastro-fotos-content" aria-live="polite">As imagens serão carregadas ao abrir esta aba.</div>' +
            '</section>';
    }

    function context($panel) {
        const groupIndex = Number($panel.attr('data-photo-group'));
        const itemIndex = Number($panel.attr('data-photo-item'));
        return { groupIndex, itemIndex, id: key(groupIndex, itemIndex) };
    }

    function label(photo) {
        return (photo.origin === 'fornecedor' ? 'Fornecedor' : 'KidStok') + ' — Foto ' + photo.Sequencia;
    }

    function render($panel, state) {
        const selected = state.photos.find(photo => photo.key === state.selected);
        const { id } = context($panel);
        const errors = state.errors.map(message => '<div class="alert alert-warning">' + escapeHtml(message) + '</div>').join('');
        let html = errors + '<div class="d-flex flex-wrap gap-2 align-items-center mb-3">' +
            '<span>' + state.photos.length + (state.photos.length === 1 ? ' imagem disponível' : ' imagens disponíveis') + '</span>' +
            '<button type="button" class="btn btn-sm btn-outline-secondary pre-cadastro-fotos-reload">Atualizar imagens</button></div>';
        if (!state.photos.length) {
            html += '<p class="text-muted">Nenhuma imagem disponível para esta referência no pedido.</p>';
        } else {
            html += '<div class="pre-cadastro-fotos-grid">' + state.photos.map(photo =>
                '<label class="pre-cadastro-foto-card' + (photo.key === state.selected ? ' is-selected' : '') + '">' +
                '<img loading="lazy" src="' + escapeAttr(photo.src) + '" alt="' + escapeAttr(label(photo)) + '">' +
                '<span><input type="radio" class="form-check-input pre-cadastro-foto-select" name="pre-cadastro-foto-' + id + '" value="' + escapeAttr(photo.key) + '"' +
                (photo.key === state.selected ? ' checked' : '') + '> ' + escapeHtml(label(photo)) + '</span></label>'
            ).join('') + '</div>';
        }
        html += '<div class="pre-cadastro-foto-selected mt-3">';
        if (selected) {
            html += '<div class="d-flex flex-wrap align-items-center gap-2 mb-2"><strong>Selecionada para IA: ' + escapeHtml(label(selected)) + '</strong>' +
                '<button type="button" class="btn btn-sm btn-outline-secondary pre-cadastro-foto-zoom">Ampliar imagem</button></div>' +
                '<img class="pre-cadastro-foto-large" src="' + escapeAttr(selected.src) + '" alt="' + escapeAttr(label(selected)) + '">';
        } else if (state.photos.length) {
            html += '<p class="text-muted">Selecione uma imagem acima para preparar a análise.</p>';
        }
        html += '</div>';
        $panel.find('.pre-cadastro-fotos-content').html(html);
    }

    async function load($panel, reload) {
        const { groupIndex, itemIndex, id } = context($panel);
        if (states.has(id) && !reload) return;
        const group = preCadastroGroups[groupIndex];
        const item = group?.items?.[itemIndex];
        if (!item) return;
        const previous = states.get(id);
        if (previous?.loading) return;
        const state = { photos: [], selected: previous?.selected || '', errors: [], loading: true };
        states.set(id, state);
        const currentGeneration = generation;
        $panel.find('.pre-cadastro-fotos-content').html('<p role="status">Carregando imagens...</p>');
        const results = await Promise.allSettled(['fornecedor', 'kidstok'].map(origin =>
            $.getJSON(window.preCadastroProdutosConfig.photosApi, {
                action: origin === 'fornecedor' ? 'fotos_fornecedor_list' : 'fotos_list',
                pedido_id: group.cp_compras_id,
                referencia: item.referencia_fornecedor,
                fornecedor_id: group.fornecedor_id
            }).then(response => {
                if (!response.success) throw new Error(response.message || 'Não foi possível carregar as imagens.');
                return (response.data || []).filter(photo => /^data:image\/(png|jpeg|webp|gif);base64,/i.test(photo.src || '')).map(photo =>
                    Object.assign({}, photo, { origin, key: origin + ':' + photo.id }));
            })
        ));
        if (currentGeneration !== generation) return;
        results.forEach((result, index) => {
            if (result.status === 'fulfilled') state.photos.push(...result.value);
            else state.errors.push('Não foi possível carregar as fotos ' + (index === 0 ? 'do fornecedor.' : 'da KidStok.'));
        });
        state.loading = false;
        if (!state.photos.some(photo => photo.key === state.selected)) state.selected = '';
        render($panel, state);
    }

    function init() {
        const $root = $('#pre-cadastro-groups');
        $root.on('shown.bs.tab', '.pre-cadastro-fotos-tab', function () {
            load($($(this).attr('data-bs-target')).find('.pre-cadastro-fotos'), false);
        });
        $root.on('click', '.pre-cadastro-fotos-reload', function () {
            load($(this).closest('.pre-cadastro-fotos'), true);
        });
        $root.on('change', '.pre-cadastro-foto-select', function () {
            const $panel = $(this).closest('.pre-cadastro-fotos');
            const state = states.get(context($panel).id);
            state.selected = this.value;
            render($panel, state);
            $panel.find('.pre-cadastro-foto-select:checked').trigger('focus');
        });
        $root.on('click', '.pre-cadastro-foto-zoom', function () {
            const state = states.get(context($(this).closest('.pre-cadastro-fotos')).id);
            const photo = state.photos.find(photo => photo.key === state.selected);
            if (!photo) return;
            $('#pre-cadastro-foto-preview-title').text(label(photo));
            $('#pre-cadastro-foto-preview-img').attr({ src: photo.src, alt: label(photo) });
            bootstrap.Modal.getOrCreateInstance(document.getElementById('pre-cadastro-foto-preview-modal')).show();
        });
    }

    function reset() {
        generation++;
        states.clear();
    }

    return { init, panel, reset };
}());
