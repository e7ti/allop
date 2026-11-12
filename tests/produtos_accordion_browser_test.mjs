// Teste de Produtos com accordion no Chrome local, exclusivamente sobre a fixture SQLite.
// node tests/produtos_accordion_browser_test.mjs <diretorio-da-fixture>
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import net from 'node:net';
import { spawn } from 'node:child_process';
import assert from 'node:assert/strict';
import { fileURLToPath } from 'node:url';

const fixture = path.resolve(process.argv[2] || '');
const database = await fs.readFile(path.join(fixture, 'config/database.php'), 'utf8');
assert(database.includes("const DB_NAME = 'fixture'") && database.includes('sqlite:'), 'Informe a fixture SQLite isolada.');
const repo = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
await fs.cp(path.join(repo, 'assets'), path.join(fixture, 'assets'), { recursive: true });
const chromeProfile = await fs.mkdtemp(path.join(os.tmpdir(), 'allop-values-chrome-'));
const socket = net.createServer(); await new Promise(resolve => socket.listen(0, '127.0.0.1', resolve));
const port = socket.address().port; await new Promise(resolve => socket.close(resolve));
const server = spawn('php', ['-S', '127.0.0.1:' + port, '-t', fixture], { windowsHide: true, stdio: 'ignore' });
const chrome = spawn('C:/Program Files/Google/Chrome/Application/chrome.exe', [
    '--headless=new', '--remote-debugging-port=0', '--user-data-dir=' + chromeProfile,
    '--no-first-run', '--no-default-browser-check', '--disable-background-networking', 'about:blank',
], { windowsHide: true, stdio: 'ignore' });
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));
let ws;
try {
    let debugPort;
    for (let n = 0; n < 100; n++) {
        try { debugPort = Number((await fs.readFile(path.join(chromeProfile, 'DevToolsActivePort'), 'utf8')).split('\n')[0]); break; } catch (_) { await delay(100); }
    }
    assert(debugPort, 'Chrome não iniciou.');
    const targets = await (await fetch('http://127.0.0.1:' + debugPort + '/json/list')).json();
    ws = new WebSocket(targets.find(target => target.type === 'page').webSocketDebuggerUrl);
    await new Promise((resolve, reject) => { ws.onopen = resolve; ws.onerror = reject; });
    let sequence = 0; const pending = new Map(); const errors = []; let dialogs = 0;
    function command(method, params = {}) {
        const id = ++sequence;
        return new Promise((resolve, reject) => {
            const timer = setTimeout(() => { pending.delete(id); reject(new Error('Timeout: ' + method)); }, 15000);
            pending.set(id, { resolve, reject, timer }); ws.send(JSON.stringify({ id, method, params }));
        });
    }
    ws.onmessage = event => {
        const data = JSON.parse(event.data);
        if (data.id && pending.has(data.id)) {
            const result = pending.get(data.id); pending.delete(data.id); clearTimeout(result.timer);
            if (data.error) result.reject(new Error(data.error.message)); else result.resolve(data.result);
        } else if (data.method === 'Runtime.exceptionThrown') errors.push(data.params.exceptionDetails.text);
        else if (data.method === 'Page.javascriptDialogOpening') { dialogs++; command('Page.handleJavaScriptDialog', { accept: true }).catch(() => {}); }
    };
    async function evaluate(expression) {
        const result = await command('Runtime.evaluate', { expression, awaitPromise: true, returnByValue: true });
        if (result.exceptionDetails) {
            console.error('Estado da pagina:', await command('Runtime.evaluate', {expression:"JSON.stringify({url:location.href,text:document.body?.innerText.slice(0,1600)})",returnByValue:true}));
            console.error('Erros:',errors);
            throw new Error(JSON.stringify(result.exceptionDetails));
        }
        return result.result.value;
    }
    async function waitFor(expression) {
        for (let n = 0; n < 100; n++) { if (await evaluate(expression)) return; await delay(100); }
        throw new Error('Condição não atendida: ' + expression);
    }
    await command('Page.enable'); await command('Runtime.enable');
    await command('Network.enable');
    await command('Network.setBlockedURLs', { urls: ['*fonts.googleapis.com*', '*fonts.gstatic.com*'] });
    await command('Emulation.setDeviceMetricsOverride', { width: 1440, height: 1000, deviceScaleFactor: 1, mobile: false });
    const base = 'http://127.0.0.1:' + port;
    await command('Page.navigate', { url: base + '/session.php' });
    await waitFor("document.body && document.body.textContent.trim() === 'ok'");
    await command('Page.navigate', { url: base + '/mod/cadastros/produtos/produtos_lista.php?cadastro=produtos' });
    await waitFor("document.querySelectorAll('.pc-product-toggle').length > 0");
    const overview = await evaluate("[...document.querySelectorAll('.pc-product-toggle')].map(node=>node.textContent)");
    assert(overview.some(text => text.includes('AABB1234')), 'Produto de teste ausente.');
    assert(await evaluate("[...document.querySelectorAll('.pc-audit')].every(node=>node.textContent.includes('Inclusão:') && node.textContent.includes('Alteração:') && node.textContent.includes('Usuário:'))"));
    assert(await evaluate("!!window.jQuery('#pc-search').data('select2')"));
    await evaluate("void window.jQuery('#pc-search').select2('open')");
    await waitFor("!!document.querySelector('.select2-container--open .select2-search__field')");
    await evaluate("(()=>{const input=document.querySelector('.select2-container--open .select2-search__field');input.value='AABB1234';input.dispatchEvent(new Event('input',{bubbles:true}));})()");
    await waitFor("[...document.querySelectorAll('.select2-results__option[role=option]')].some(node=>node.textContent.includes('AABB1234'))");
    await evaluate("[...document.querySelectorAll('.select2-results__option[role=option]')].find(node=>node.textContent.includes('AABB1234')).dispatchEvent(new MouseEvent('mouseup',{bubbles:true}))");
    await waitFor("document.querySelectorAll('.pc-product-toggle').length === 1 && document.querySelector('#pc-list').getAttribute('aria-busy') === 'false'");
    assert((await evaluate("document.querySelector('.pc-product-toggle').textContent")).includes('AABB1234'));
    await evaluate("document.querySelector('#pc-clear').click()");
    await waitFor(`document.querySelectorAll('.pc-product-toggle').length === ${overview.length} && document.querySelector('#pc-list').getAttribute('aria-busy') === 'false'`);
    assert(await evaluate("document.querySelector('#pc-filter-Fornecedor').multiple && document.querySelector('#pc-filter-Categoria').multiple"));
    await evaluate(`(()=>{
        for(const [field,ids] of [['Fornecedor',['AA','CC']],['Categoria',['BB','DD']]]){
            const select=document.querySelector('#pc-filter-'+field);
            select.replaceChildren();ids.forEach(id=>select.append(new Option(id,id,true,true)));
            window.jQuery(select).trigger('change');
        }
        document.querySelector('#pc-filter button[type=submit]').click();
    })()`);
    await waitFor("document.querySelectorAll('.pc-product-toggle').length > 0 && document.querySelector('#pc-list').getAttribute('aria-busy') === 'false'");
    assert.equal(await evaluate("document.querySelector('#pc-filter-Fornecedor').selectedOptions.length"),2);
    assert.equal(await evaluate("document.querySelector('#pc-filter-Categoria').selectedOptions.length"),2);
    await evaluate("document.querySelector('#pc-clear').click()");
    await waitFor(`document.querySelectorAll('.pc-product-toggle').length === ${overview.length} && document.querySelector('#pc-list').getAttribute('aria-busy') === 'false'`);
    assert.equal(await evaluate("document.querySelector('#pc-filter-Fornecedor').selectedOptions.length"),0);
    assert.equal(await evaluate("document.querySelector('#pc-filter-Categoria').selectedOptions.length"),0);
    await evaluate("[...document.querySelectorAll('.pc-product-toggle')].find(node=>node.textContent.includes('AABB1234')).click()");
    await waitFor("document.querySelector('.pc-editor-summary')?.textContent === 'Nenhuma alteração pendente'");
    assert.equal(await evaluate("document.querySelectorAll('.pc-tab').length"), 5);
    assert.equal(await evaluate("document.querySelector('#pc-field-CodFornecedorR3').disabled"), true);
    assert.equal(await evaluate("document.querySelector('#pc-field-Cor').selectedOptions.length"), 2);
    assert(await evaluate("!!window.jQuery('#pc-field-Categoria').data('select2')"));
    await evaluate("document.querySelector('#pc-tab-tributos').click()");
    assert.equal(await evaluate("document.querySelector('#pc-pane-tributos').hidden"), false);
    const taxBefore = await evaluate("window.AllopDecimal.canonical(document.querySelector('#pc-field-AliquotaICMS'))");
    const typedTax = Number(taxBefore) === 12.34 ? '2345' : '1234';
    const newTax = (Number(typedTax)/100).toFixed(2);
    await evaluate("document.querySelector('#pc-field-AliquotaICMS').focus();document.querySelector('#pc-field-AliquotaICMS').select()");
    for (let index=0; index<typedTax.length; index++) {
        await command('Input.insertText',{text:typedTax[index]});
        assert.equal(await evaluate("document.querySelector('#pc-field-AliquotaICMS').value"),(Number(typedTax.slice(0,index+1))/100).toFixed(2).replace('.',','));
    }
    await evaluate("document.querySelector('#pc-tab-dados').click();document.querySelector('#pc-field-Peso').focus();document.querySelector('#pc-field-Peso').select()");
    await command('Input.insertText',{text:'1234'});
    assert.equal(await evaluate("document.querySelector('#pc-field-Peso').value"),'1,234');
    await command('Input.dispatchKeyEvent',{type:'keyDown',key:'Backspace',code:'Backspace',windowsVirtualKeyCode:8});
    await command('Input.dispatchKeyEvent',{type:'keyUp',key:'Backspace',code:'Backspace',windowsVirtualKeyCode:8});
    assert.equal(await evaluate("document.querySelector('#pc-field-Peso').value"),'0,123');
    await command('Input.insertText',{text:'4'});
    await evaluate("document.querySelector('#pc-tab-tributos').click()");
    assert.equal(await evaluate("document.querySelector('.pc-save').disabled"), false);
    await evaluate("document.querySelector('.pc-save').click()");
    await waitFor("document.querySelector('.pc-editor-feedback').textContent.includes('Registro salvo')");
    assert.equal(Number(await evaluate("window.AllopDecimal.canonical(document.querySelector('#pc-field-AliquotaICMS'))")), Number(newTax));
    assert.equal(await evaluate("document.querySelector('#pc-field-Peso').value"),'1,234');
    assert.equal(await evaluate("document.querySelector('#pc-pane-tributos').hidden"), false);
    const desktop = await command('Page.captureScreenshot', {format:'png',captureBeyondViewport:true});
    await fs.writeFile(path.join(fixture,'produtos-desktop.png'), Buffer.from(desktop.data,'base64'));
    await evaluate("document.querySelector('#pc-tab-grade').click()");
    assert.equal(await evaluate("document.querySelectorAll('.pc-grade-area tbody tr').length"),4);
    assert(await evaluate("['Inclusão','Alteração','Usuário'].every(label=>[...document.querySelectorAll('.pc-grade-area th')].some(node=>node.textContent===label))"));
    await evaluate("document.querySelector('#pc-tab-historico').click()");
    await waitFor("document.querySelectorAll('.pc-history-area tbody tr').length > 0");
    assert((await evaluate("document.querySelector('.pc-history-area').textContent")).includes('Varejo anterior'));
    await evaluate("document.querySelector('#pc-tab-fotos').click()");
    await waitFor("document.querySelectorAll('.pc-photo img').length > 0");
    assert.equal(await evaluate("document.querySelectorAll('.pc-photo img').length"),4);
    // Alteracoes locais sobrevivem a troca de aba e pedem confirmacao ao fechar.
    await evaluate("document.querySelector('#pc-tab-dados').click()");
    const description = await evaluate("document.querySelector('#pc-field-Descricao').value");
    await evaluate("(()=>{const n=document.querySelector('#pc-field-Descricao');n.value='ALTERACAO LOCAL';n.dispatchEvent(new Event('input',{bubbles:true}));})()");
    await evaluate("document.querySelector('#pc-tab-tributos').click();document.querySelector('#pc-tab-dados').click()");
    assert.equal(await evaluate("document.querySelector('#pc-field-Descricao').value"),'ALTERACAO LOCAL');
    await evaluate("document.querySelector('.pc-close').click()");
    assert.equal(dialogs,1);
    await evaluate("[...document.querySelectorAll('.pc-product-toggle')].find(node=>node.textContent.includes('AABB1234')).click()");
    await waitFor("document.querySelector('.pc-editor-summary')?.textContent === 'Nenhuma alteração pendente'");
    assert.equal(await evaluate("document.querySelector('#pc-field-Descricao').value"),description);
    // Navegacao das abas por teclado.
    await evaluate("document.querySelector('#pc-tab-dados').dispatchEvent(new KeyboardEvent('keydown',{key:'ArrowRight',bubbles:true}))");
    assert.equal(await evaluate("document.querySelector('#pc-tab-tributos').getAttribute('aria-selected')"),'true');
    // Layout mobile: abas rolam horizontalmente e as tabelas permanecem dentro do painel.
    await command('Emulation.setDeviceMetricsOverride',{width:390,height:844,deviceScaleFactor:1,mobile:true});
    await evaluate("document.querySelector('#pc-tab-grade').click()");
    await delay(100);
    assert(await evaluate("document.documentElement.scrollWidth <= window.innerWidth+1"),'Overflow horizontal no celular.');
    assert(await evaluate("document.querySelector('.pc-tabs').scrollWidth > document.querySelector('.pc-tabs').clientWidth"));
    assert.equal(await evaluate("getComputedStyle(document.querySelector('.pc-detail-table')).display"),'table');
    const mobile=await command('Page.captureScreenshot',{format:'png',captureBeyondViewport:true});
    await fs.writeFile(path.join(fixture,'produtos-mobile.png'),Buffer.from(mobile.data,'base64'));
    // Novo produto carrega o mesmo editor e as abas dependentes ficam desabilitadas.
    await evaluate("document.querySelector('.pc-close').click();document.querySelector('#pc-new').click()");
    await waitFor("document.querySelector('.pc-save') && !document.querySelector('.pc-save').disabled");
    assert.equal(await evaluate("document.querySelector('#pc-field-CodFornecedorR3').disabled"),false);
    assert.equal(await evaluate("document.querySelector('#pc-tab-fotos').disabled"),true);
    const r3 = '7' + String(Date.now()).slice(-3);
    const newProduct = {Fornecedor:'AA',Categoria:'BB',CodFornecedorR3:r3,CodFornecedor:'UI TESTE',Grupo:'INFANTIL',GrupoCategoria:'CAMISETA',Colecao:'1',Linha:'1',Composicao:'1',Caracteristica:'1',Genero:'1',Descricao:'NOVO PRODUTO UI',DescricaoComplementar:'',Unidade:'UN',Tamanho:['04'],Cor:['01'],NCM:'12345678',CST_ICMS:'000',Origem:'0',CST_PIS:'01',CST_COFINS:'01',CST_IPI:'01',CFOP:'5102',CFOP_ProducaoProria:'',PrecoCompra:'10',PrecoCompraTabela:'20',PrecoVendaTabela:'1234.56',Status:'Ativo',Estilo:'0',SetorLaranja:'N',PrecoCheio:'N',Encomenda:'N'};
    await evaluate(`(()=>{
        for(const [field,value] of Object.entries(${JSON.stringify(newProduct)})){
            const node=document.querySelector('#pc-field-'+field);
            if(node.classList.contains('pc-editor-select')){
                node.replaceChildren();
                for(const id of (Array.isArray(value)?value:[value])) if(id!=='')node.append(new Option(id,id,true,true));
                window.jQuery(node).trigger('change');
            } else {if(node.hasAttribute('data-decimal-places'))window.AllopDecimal.set(node,value);else node.value=value;node.dispatchEvent(new Event('input',{bubbles:true}));}
        }
        document.querySelector('.pc-save').click();
    })()`);
    await waitFor("document.querySelector('.pc-editor-feedback')?.textContent.includes('Registro salvo')");
    assert.equal(await evaluate("document.querySelector('#pc-field-Referencia').value"),'AABB'+r3);
    assert.equal(await evaluate("document.querySelector('#pc-field-PrecoVendaTabela').value"),'1.234,56');
    assert.equal(await evaluate("document.querySelector('#pc-tab-fotos').disabled"),false);
    await evaluate("document.querySelector('#pc-tab-grade').click()");
    assert.equal(await evaluate("document.querySelectorAll('.pc-grade-area tbody tr').length"),1);
    await evaluate("document.querySelector('.pc-close').click()");
    await evaluate(`[...document.querySelectorAll('.pc-product-toggle')].find(node=>node.textContent.includes(${JSON.stringify('AABB'+r3)})).click()`);
    await waitFor("document.querySelector('.pc-editor-summary')?.textContent === 'Nenhuma alteração pendente'");
    assert.equal(await evaluate("document.querySelector('#pc-field-CodFornecedorR3').disabled"),true);
    assert.equal(await evaluate("document.querySelector('#pc-field-Descricao').value"),'NOVO PRODUTO UI');
    // Upload na aba de fotos preserva os campos pendentes e permite salvar em seguida.
    await evaluate("(()=>{const n=document.querySelector('#pc-field-Descricao');n.value='DESCRICAO COM FOTO';n.dispatchEvent(new Event('input',{bubbles:true}));document.querySelector('#pc-tab-fotos').click();})()");
    await waitFor("document.querySelector('.pc-photos')?.textContent === 'Nenhuma foto cadastrada.'");
    const photoPath=path.join(fixture,'accordion-foto.png');
    await fs.writeFile(photoPath,Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jNn0AAAAASUVORK5CYII=','base64'));
    const documentNode=await command('DOM.getDocument');
    const fileNode=await command('DOM.querySelector',{nodeId:documentNode.root.nodeId,selector:'.pc-photo-upload input'});
    await command('DOM.setFileInputFiles',{nodeId:fileNode.nodeId,files:[photoPath]});
    await evaluate("document.querySelector('.pc-photo-send').click()");
    await waitFor("document.querySelectorAll('.pc-photo img').length === 1 && !document.querySelector('.pc-save').disabled");
    assert.equal(await evaluate("document.querySelector('#pc-field-Descricao').value"),'DESCRICAO COM FOTO');
    await evaluate("document.querySelector('.pc-save').click()");
    await waitFor("document.querySelector('.pc-editor-summary')?.textContent === 'Nenhuma alteração pendente'");
    assert.equal(await evaluate("document.querySelector('#pc-field-Descricao').value"),'DESCRICAO COM FOTO');
    // O formulario compartilhado tambem deve exibir e enviar peso com tres casas.
    await command('Page.navigate',{url:base+'/mod/cadastros/produtos/produtos_form.php?cadastro=outras_informacoes&id=AABB12340401'});
    await waitFor("document.querySelector('#produto-Peso') && !document.querySelector('#produtos-salvar').disabled");
    await evaluate("document.querySelector('#produto-Peso').focus();document.querySelector('#produto-Peso').select()");
    await command('Input.insertText',{text:'2345'});
    assert.equal(await evaluate("document.querySelector('#produto-Peso').value"),'2,345');
    await evaluate("document.querySelector('#produtos-salvar').click()");
    await waitFor("fetch(window.produtosConfig.api+'?cadastro=outras_informacoes&action=get&id=AABB12340401').then(r=>r.json()).then(r=>Number(r.data?.Peso)===2.345)");
    assert.deepEqual(errors,[],'Erros JavaScript.');
    console.log('PASS: Chrome desktop/mobile, cinco abas, edicao de tributo, grade, fotos, historico, cancelamento e novo produto.');
    console.log('Capturas:',path.join(fixture,'produtos-desktop.png'),path.join(fixture,'produtos-mobile.png'));
} finally {
    if(ws) ws.close(); chrome.kill(); server.kill();
}
