// Teste opcional no Chrome local, exclusivamente sobre a fixture criada pelo teste HTTP.
// node tests/produtos_valores_browser_test.mjs <diretorio-da-fixture>
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
        if (result.exceptionDetails) throw new Error(JSON.stringify(result.exceptionDetails));
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
    await command('Page.navigate', { url: base + '/mod/cadastros/produtos/produtos_lista.php?cadastro=valores' });
    await waitFor("document.querySelectorAll('.pv-product-toggle').length > 0");
    const overview = await evaluate("[...document.querySelectorAll('.pv-product-toggle')].map(button => button.textContent)");
    assert(overview.some(text => text.includes('AABB1234')), 'Produto de teste não listado.');
    assert(await evaluate("[...document.querySelectorAll('.pv-audit')].every(node=>node.textContent.includes('Inclusão:') && node.textContent.includes('Alteração:') && node.textContent.includes('Usuário:'))"));
    console.log('Grid de produtos:', overview.length);
    await evaluate("[...document.querySelectorAll('.pv-product-toggle')].find(button => button.textContent.includes('AABB1234')).click()");
    await waitFor("document.querySelectorAll('.pv-panel:not([hidden]) tbody tr').length === 4");
    assert(await evaluate("['Inclusão','Alteração','Usuário'].every(label=>[...document.querySelectorAll('.pv-values-table th')].some(node=>node.textContent===label))"));
    assert(await evaluate("!!window.jQuery('.pv-select').first().data('select2')"), 'Select2 não inicializado.');
    assert.equal(await evaluate("document.querySelector('.pv-panel:not([hidden]) button.btn-save').disabled"), true);
    await evaluate("document.querySelector('.pv-bulk input').focus();document.querySelector('.pv-bulk input').select()");
    await command('Input.insertText',{text:'123456'});
    assert.equal(await evaluate("document.querySelector('.pv-bulk input').value"),'1.234,56');
    await evaluate("document.querySelector('.pv-bulk input').select()");
    await command('Input.dispatchKeyEvent',{type:'keyDown',key:'Backspace',code:'Backspace',windowsVirtualKeyCode:8});
    await command('Input.dispatchKeyEvent',{type:'keyUp',key:'Backspace',code:'Backspace',windowsVirtualKeyCode:8});
    assert.equal(await evaluate("document.querySelector('.pv-bulk input').value"),'');
    const baseline = await evaluate("Number(document.querySelector('.pv-panel:not([hidden]) tbody tr input.pv-money').value.replace(',','.'))");
    const newRetail = await evaluate("Math.max(...[...document.querySelectorAll('.pv-panel:not([hidden]) tbody tr')].map(row=>Number(row.querySelector('.pv-money').value.replace(',','.'))))+30");
    const newRetailText = newRetail.toFixed(2).replace('.', ',');
    const snapshot = await command('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true });
    await fs.writeFile(path.join(fixture, 'valores-desktop.png'), Buffer.from(snapshot.data, 'base64'));
    // Aplicacao em lote e previa ainda sem gravar.
    await evaluate(`(() => {
        const panel = document.querySelector('.pv-panel:not([hidden])');
        panel.querySelector('thead input[type=checkbox]').click();
        panel.querySelector('.pv-bulk input').value = ${JSON.stringify(newRetailText)};
        [...panel.querySelectorAll('button')].find(button => button.textContent === 'Aplicar na grade').click();
    })()`);
    assert.equal(await evaluate("document.querySelectorAll('.pv-row-changed').length"), 4);
    assert.equal(await evaluate("document.querySelector('.pv-panel:not([hidden]) tbody tr input.pv-money').value"), newRetailText);
    assert.equal(await evaluate("document.querySelectorAll('.pv-panel:not([hidden]) tbody tr')[0].querySelectorAll('.pv-money')[1].value"), (newRetail / 2).toFixed(2).replace('.', ','));
    assert.equal(await evaluate("fetch(window.produtosValoresConfig.api+'?action=get',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({id:'AABB1234'})}).then(r=>r.json()).then(r=>Number(r.rows[0].PrecoVendaTabela))"), baseline);
    await evaluate("document.querySelector('.pv-panel:not([hidden]) button.btn-save').click()");
    await waitFor("document.querySelector('#pv-aviso').textContent.includes('4 itens atualizados')");
    await evaluate("[...document.querySelectorAll('.pv-product-toggle')].find(button => button.textContent.includes('AABB1234')).click()");
    await waitFor("document.querySelectorAll('.pv-panel:not([hidden]) tbody tr').length === 4");
    assert.equal(await evaluate("document.querySelector('.pv-panel:not([hidden]) tbody tr input.pv-money').value"), newRetailText);
    // Edicao individual recalcula o atacado; cancelar pergunta antes de descartar.
    await evaluate(`(() => {
        const input = document.querySelector('.pv-panel:not([hidden]) tbody tr input.pv-money');
        input.value = ${JSON.stringify((newRetail + 10).toFixed(2).replace('.', ','))}; input.dispatchEvent(new Event('input', {bubbles:true})); input.dispatchEvent(new Event('change', {bubbles:true}));
    })()`);
    assert.equal(await evaluate("document.querySelectorAll('.pv-panel:not([hidden]) tbody tr')[0].querySelectorAll('.pv-money')[1].value"), ((newRetail + 10) / 2).toFixed(2).replace('.', ','));
    await evaluate(`(() => {
        const controls = document.querySelectorAll('.pv-panel:not([hidden]) tbody tr')[0].querySelectorAll('.pv-money');
        for (const [index, value] of [[2, '0,00'], [0, '1,15']]) {
            controls[index].value = value;
            controls[index].dispatchEvent(new Event('input', {bubbles:true}));
            controls[index].dispatchEvent(new Event('change', {bubbles:true}));
        }
    })()`);
    assert.equal(await evaluate("document.querySelectorAll('.pv-panel:not([hidden]) tbody tr')[0].querySelectorAll('.pv-money')[1].value"), '0,58');
    await evaluate("[...document.querySelector('.pv-panel:not([hidden])').querySelectorAll('button')].find(button => button.textContent === 'Cancelar').click()");
    assert.equal(dialogs, 1);
    await evaluate("[...document.querySelectorAll('.pv-product-toggle')].find(button => button.textContent.includes('AABB1234')).click()");
    await waitFor("document.querySelectorAll('.pv-panel:not([hidden]) tbody tr').length === 4");
    assert.equal(await evaluate("document.querySelector('.pv-panel:not([hidden]) tbody tr input.pv-money').value"), newRetailText);
    // Conferencia mobile: a rolagem da grade fica dentro do painel.
    await command('Emulation.setDeviceMetricsOverride', { width: 390, height: 844, deviceScaleFactor: 1, mobile: true });
    await delay(100);
    assert(await evaluate("document.documentElement.scrollWidth <= window.innerWidth + 1"), 'Overflow horizontal fora da grade.');
    assert.equal(await evaluate("getComputedStyle(document.querySelector('.pv-values-table')).display"), 'table');
    assert.equal(await evaluate("getComputedStyle(document.querySelector('.pv-values-table thead')).display"), 'table-header-group');
    assert(await evaluate("document.querySelector('.pv-table-scroll').scrollWidth > document.querySelector('.pv-table-scroll').clientWidth"), 'Grade deve permitir rolagem horizontal no celular.');
    const mobile = await command('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true });
    await fs.writeFile(path.join(fixture, 'valores-mobile.png'), Buffer.from(mobile.data, 'base64'));
    assert.deepEqual(errors, [], 'Erros JavaScript.');
    console.log('PASS: Chrome desktop/mobile, Select2, previa sem gravar, salvamento, recalculo e descarte.');
    console.log('Capturas:', path.join(fixture, 'valores-desktop.png'), path.join(fixture, 'valores-mobile.png'));
} finally {
    if (ws) ws.close(); chrome.kill(); server.kill();
}
