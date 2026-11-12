// Chrome local + PHP, com copia temporaria e APIs ficticias; nunca usa os bancos configurados.
// node tests/pre_cadastro_fotos_browser_test.mjs
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import net from 'node:net';
import { spawn } from 'node:child_process';
import assert from 'node:assert/strict';
import { fileURLToPath } from 'node:url';

const repo = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const fixture = await fs.mkdtemp(path.join(os.tmpdir(), 'allop-pre-cadastro-test-'));
for (const name of ['config/app.php', 'includes/auth.php', 'includes/layout.php', 'mod/compras/pre_cadastro_produtos_form.php']) {
    const target = path.join(fixture, name);
    await fs.mkdir(path.dirname(target), { recursive: true });
    await fs.copyFile(path.join(repo, name), target);
}
await fs.cp(path.join(repo, 'assets'), path.join(fixture, 'assets'), { recursive: true });
await fs.mkdir(path.join(fixture, 'api/compras'), { recursive: true });
await fs.mkdir(path.join(fixture, 'api/seguranca'), { recursive: true });
await fs.writeFile(path.join(fixture, 'config/database.php'), `<?php
require_once __DIR__ . '/app.php';
function db() { throw new RuntimeException('Banco proibido na fixture.'); }
function db_fotos() { throw new RuntimeException('Banco de fotos proibido na fixture.'); }
`);
await fs.writeFile(path.join(fixture, 'includes/permissions.php'), "<?php require_once __DIR__ . '/auth.php'; function menu_items(): array { return []; }");
await fs.writeFile(path.join(fixture, 'session.php'), `<?php
require_once __DIR__ . '/includes/auth.php';
login_user(['id'=>1,'nome'=>'Teste','login'=>'teste','perfil_id'=>1]); echo 'ok';
`);
const product = { tamanho: '01', tamanho_origem: 'P', cor: '01', cor_origem: 'Azul', qtde: 2, preco_compra: 10, preco_atacado: 20, preco_varejo: 40, valor_total_produto: 20 };
const items = ['REF-A', 'REF-B', 'SEM-FOTO', 'ERRO-PARCIAL'].map((reference, index) => ({
    cp_compras_itens_id: index + 1, referencia_fornecedor: reference, r1: 'AA', r2: 'BB', r3: '000' + index,
    descricao: 'Produto ficticio ' + index, agrupar_cores_duplicadas: 'S',
    origem: '0', origem_text: '0 - Nacional', cfop: '6102', cfop_text: '6102 - Venda',
    cst_icms: '000', cst_icms_text: '000 - ICMS', cst_pis: '01', cst_pis_text: '01 - PIS',
    cst_cofins: '02', cst_cofins_text: '02 - COFINS', cst_ipi: '53', cst_ipi_text: '53 - IPI',
    aliquota_icms: 0, reducao_icms: 12.5, aliquota_pis: 1.65, aliquota_cofins: 7.6, aliquota_ipi: 0,
    products: [{ ...product }, { ...product }]
}));
const payload = { success: true, pedido: { id: 123, cd: 'CD Teste', empresa: 'Empresa Teste', fornecedor: 'Fornecedor Teste' },
    groups: [{ cp_compras_id: 123, fornecedor_id: 'AA', Categoria: 'BB', consolidado: 0, items }] };
await fs.writeFile(path.join(fixture, 'payload.json'), JSON.stringify(payload));
await fs.writeFile(path.join(fixture, 'api/compras/pre_cadastro_produtos.php'), `<?php
header('Content-Type: application/json');
if (($_GET['action'] ?? '') === 'get') { readfile(__DIR__.'/../../payload.json'); }
else { echo '{"success":true,"results":[]}'; }
`);
await fs.writeFile(path.join(fixture, 'api/seguranca/options.php'), '<?php header("Content-Type: application/json"); echo \'{"success":true,"results":[]}\';');
await fs.writeFile(path.join(fixture, 'api/compras/cp_compras.php'), `<?php
header('Content-Type: application/json');
file_put_contents(__DIR__.'/../../photo-requests.log', json_encode($_GET)."\\n", FILE_APPEND);
if (($_GET['pedido_id'] ?? '') !== '123' || ($_GET['fornecedor_id'] ?? '') !== 'AA') { http_response_code(422); echo '{}'; exit; }
if (($_GET['referencia'] ?? '') === 'ERRO-PARCIAL' && ($_GET['action'] ?? '') === 'fotos_fornecedor_list') { http_response_code(500); echo '{}'; exit; }
$photos = ($_GET['referencia'] ?? '') === 'SEM-FOTO' ? [] : [['id'=>1,'Sequencia'=>1,'src'=>'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jA1sAAAAASUVORK5CYII=']];
echo json_encode(['success'=>true,'data'=>$photos]);
`);
const chromeProfile = await fs.mkdtemp(path.join(os.tmpdir(), 'allop-pre-cadastro-chrome-'));
const socket = net.createServer();
await new Promise(resolve => socket.listen(0, '127.0.0.1', resolve));
const port = socket.address().port;
await new Promise(resolve => socket.close(resolve));
const server = spawn('php', ['-S', '127.0.0.1:' + port, '-t', fixture], { windowsHide: true, stdio: 'ignore' });
const chrome = spawn('C:/Program Files/Google/Chrome/Application/chrome.exe', [
    '--headless=new', '--remote-debugging-port=0', '--user-data-dir=' + chromeProfile,
    '--no-first-run', '--no-default-browser-check', '--disable-background-networking', 'about:blank'
], { windowsHide: true, stdio: 'ignore' });
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));
let ws;
try {
    let debugPort;
    for (let n = 0; n < 100; n++) {
        try { debugPort = Number((await fs.readFile(path.join(chromeProfile, 'DevToolsActivePort'), 'utf8')).split('\n')[0]); break; }
        catch (_) { await delay(100); }
    }
    assert(debugPort, 'Chrome nao iniciou.');
    const targets = await (await fetch('http://127.0.0.1:' + debugPort + '/json/list')).json();
    ws = new WebSocket(targets.find(target => target.type === 'page').webSocketDebuggerUrl);
    await new Promise((resolve, reject) => { ws.onopen = resolve; ws.onerror = reject; });
    let sequence = 0;
    const pending = new Map();
    const errors = [];
    function command(method, params = {}) {
        const id = ++sequence;
        return new Promise((resolve, reject) => {
            const timer = setTimeout(() => { pending.delete(id); reject(new Error('Timeout: ' + method)); }, 15000);
            pending.set(id, { resolve, reject, timer });
            ws.send(JSON.stringify({ id, method, params }));
        });
    }
    ws.onmessage = event => {
        const data = JSON.parse(event.data);
        if (data.id && pending.has(data.id)) {
            const result = pending.get(data.id); pending.delete(data.id); clearTimeout(result.timer);
            if (data.error) result.reject(new Error(data.error.message)); else result.resolve(data.result);
        } else if (data.method === 'Runtime.exceptionThrown') errors.push(data.params.exceptionDetails.text);
    };
    async function evaluate(expression) {
        const result = await command('Runtime.evaluate', { expression, awaitPromise: true, returnByValue: true });
        if (result.exceptionDetails) throw new Error(JSON.stringify(result.exceptionDetails));
        return result.result.value;
    }
    async function waitFor(expression) {
        for (let n = 0; n < 100; n++) { if (await evaluate(expression)) return; await delay(100); }
        throw new Error('Condicao nao atendida: ' + expression + '\n' + JSON.stringify({ errors, body: await evaluate('document.body?.textContent.slice(0, 1200)') }));
    }
    await command('Page.enable'); await command('Runtime.enable'); await command('Network.enable');
    await command('Network.setBlockedURLs', { urls: ['*fonts.googleapis.com*', '*fonts.gstatic.com*'] });
    await command('Emulation.setDeviceMetricsOverride', { width: 1440, height: 1000, deviceScaleFactor: 1, mobile: false });
    const base = 'http://127.0.0.1:' + port;
    await command('Page.navigate', { url: base + '/session.php' });
    await waitFor("document.body?.textContent.trim() === 'ok'");
    await command('Page.navigate', { url: base + '/mod/compras/pre_cadastro_produtos_form.php?id=1' });
    await waitFor("document.querySelectorAll('.pre-cadastro-fotos-tab').length === 4");
    assert.equal(await evaluate("[...document.querySelectorAll('[data-field=agrupar_cores_duplicadas]')].every(input=>input.value==='S' && input.parentElement.querySelector('input[type=checkbox]').checked)"), true);
    assert.equal(await fs.readFile(path.join(fixture, 'photo-requests.log'), 'utf8').catch(() => ''), '', 'Fotos devem carregar somente ao abrir a aba.');
    await evaluate("document.querySelector('#pre-cadastro-item-0-0-heading button').click()");
    await waitFor("document.querySelector('#pre-cadastro-item-0-0-collapse').classList.contains('show')");
    await evaluate("document.querySelector('#pre-cadastro-item-0-0-tributos-tab').click()");
    assert.equal(await evaluate("document.querySelector('#pre-cadastro-item-0-0-tributos [data-field=origem]').value"), '0');
    assert.equal(await evaluate("document.querySelector('#pre-cadastro-item-0-0-tributos [data-field=cst_icms]').value"), '000');
    assert.equal(await evaluate("document.querySelector('#pre-cadastro-item-0-0-tributos [data-field=cfop]').value"), '6102');
    assert.equal(await evaluate("document.querySelector('#pre-cadastro-item-0-0-tributos [data-field=reducao_icms]').value"), '12.5');
    assert.equal(await evaluate("document.querySelector('#pre-cadastro-item-0-0-tributos [data-field=aliquota_icms]').value"), '0');
    await evaluate("const aliquota=document.querySelector('#pre-cadastro-item-0-0-tributos [data-field=aliquota_pis]'); aliquota.value='2.15'; aliquota.dispatchEvent(new Event('input',{bubbles:true}))");
    await evaluate("document.querySelector('#pre-cadastro-item-0-0-fotos-tab').click()");
    await waitFor("document.querySelectorAll('#pre-cadastro-item-0-0-fotos .pre-cadastro-foto-select').length === 2");
    assert.equal(await evaluate("document.querySelectorAll('.pre-cadastro-foto-select:checked').length"), 0);
    await evaluate("document.querySelector('#pre-cadastro-item-0-0-fotos input[value=\"fornecedor:1\"]').click()");
    assert.equal(await evaluate("document.querySelector('#pre-cadastro-item-0-0-fotos .pre-cadastro-foto-select:checked').value"), 'fornecedor:1');
    await evaluate("document.querySelector('#pre-cadastro-item-0-0-fotos input[value=\"kidstok:1\"]').click()");
    assert.equal(await evaluate("document.querySelectorAll('#pre-cadastro-item-0-0-fotos input:checked').length"), 1);
    await evaluate("document.querySelector('.pre-cadastro-foto-zoom').click()");
    await waitFor("document.querySelector('#pre-cadastro-foto-preview-modal').classList.contains('show')");
    await waitFor("!bootstrap.Modal.getInstance(document.querySelector('#pre-cadastro-foto-preview-modal'))._isTransitioning");
    await evaluate("document.querySelector('#pre-cadastro-foto-preview-modal .btn-close').click()");
    await waitFor("!document.querySelector('#pre-cadastro-foto-preview-modal').classList.contains('show')");
    await evaluate("document.querySelector('#pre-cadastro-item-0-0-dados-tab').click(); const input=document.querySelector('[data-field=descricao]'); input.value='Edicao preservada'; input.dispatchEvent(new Event('input',{bubbles:true}));");
    await evaluate("document.querySelector('#pre-cadastro-item-0-0-fotos-tab').click(); document.querySelector('#pre-cadastro-item-0-0-fotos .pre-cadastro-fotos-reload').click()");
    await waitFor("!!document.querySelector('#pre-cadastro-item-0-0-fotos input[value=\"kidstok:1\"]:checked')");
    assert.equal(await evaluate("preCadastroGroups[0].items[0].descricao"), 'Edicao preservada');
    assert.equal(await evaluate("Number(preCadastroGroups[0].items[0].aliquota_pis)"), 2.15, 'Preservar edicao tributaria ao navegar entre abas.');
    for (const index of [1, 2, 3]) {
        await evaluate(`document.querySelector('#pre-cadastro-item-0-${index}-heading button').click()`);
        await waitFor(`document.querySelector('#pre-cadastro-item-0-${index}-collapse').classList.contains('show')`);
        await evaluate(`document.querySelector('#pre-cadastro-item-0-${index}-fotos-tab').click()`);
        await waitFor(`document.querySelector('#pre-cadastro-item-0-${index}-fotos .pre-cadastro-fotos-reload') !== null`);
    }
    assert.equal(await evaluate("document.querySelectorAll('#pre-cadastro-item-0-1-fotos input:checked').length"), 0, 'Selecao isolada por item.');
    assert(await evaluate("document.querySelector('#pre-cadastro-item-0-2-fotos').textContent.includes('Nenhuma imagem')"));
    assert.equal(await evaluate("document.querySelectorAll('#pre-cadastro-item-0-3-fotos .pre-cadastro-foto-select').length"), 1, 'Erro de uma origem preserva a outra.');
    assert(await evaluate("!!document.querySelector('#pre-cadastro-item-0-3-fotos .alert-warning')"));
    await evaluate("document.querySelector('#pre-cadastro-item-0-3-fotos input').click()");
    const desktop = await command('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true });
    await fs.writeFile(path.join(fixture, 'pre-cadastro-desktop.png'), Buffer.from(desktop.data, 'base64'));
    await command('Emulation.setDeviceMetricsOverride', { width: 390, height: 844, deviceScaleFactor: 1, mobile: true });
    assert(await evaluate("document.documentElement.scrollWidth <= window.innerWidth + 1"), 'Overflow horizontal no celular.');
    const mobile = await command('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true });
    await fs.writeFile(path.join(fixture, 'pre-cadastro-mobile.png'), Buffer.from(mobile.data, 'base64'));
    assert.deepEqual(errors, [], 'Erros JavaScript.');
    console.log('PASS: checkbox padrao, fotos sob demanda, selecao por item/origem, ampliacao, recarga sem perder edicoes, estado vazio, erro parcial e layout mobile.');
    console.log('Fixture e capturas:', fixture);
} finally {
    if (ws) ws.close();
    chrome.kill(); server.kill();
}
