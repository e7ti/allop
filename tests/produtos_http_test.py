"""Smoke test HTTP em cópia temporária do projeto, sem conexão aos bancos configurados.

Executar com: python tests/produtos_http_test.py
Requer PHP CLI com pdo_sqlite. A fixture adapta FOR UPDATE e metadados MySQL.
"""
import base64
import http.cookiejar
import json
from pathlib import Path
import shutil
import socket
import sqlite3
import subprocess
import tempfile
import time
import urllib.error
import urllib.request


ROOT = Path(__file__).resolve().parents[1]
TEMP = Path(tempfile.mkdtemp(prefix="allop-produtos-test-"))
FILES = [
    "config/app.php", "config/produtos.php", "config/produtos_schema.json",
    "includes/auth.php", "includes/permissions.php", "includes/layout.php",
    "includes/produtos.php", "includes/produtos_workflow.php", "api/bootstrap.php",
    "api/cadastros/produtos.php", "api/cadastros/produtos_processos.php",
    "mod/cadastros/produtos/produtos_lista.php", "mod/cadastros/produtos/produtos_form.php",
    "scripts/seed_produtos.php",
    "includes/grupo_categoria.php", "api/cadastros/grupo_categoria.php",
    "api/cadastros/produtos_associacoes.php",
    "mod/cadastros/produtos/grupo_categoria_grid.php",
    "includes/produtos_valores.php", "api/cadastros/produtos_valores.php",
    "mod/cadastros/produtos/valores_grid.php",
    "mod/cadastros/produtos/produtos_accordion.php",
]
for filename in FILES:
    target = TEMP / filename
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(ROOT / filename, target)

schemas = json.loads((ROOT / "config/produtos_schema.json").read_text(encoding="utf-8"))
db = sqlite3.connect(TEMP / "fixture.sqlite")
keys = {"produtos_cab": "Referencia", "produtos_cab_grade": "Distribuidora", "produtos": "Codigo",
        "produtos_precos_cab": "ID", "produtos_precos_cab_h": "ID", "produtos_precos_itens": "IDItens",
        "produtos_precos_itens_h": "IDItens", "produtos_log_preco": "Id", "produtos_medidas": "Sigla",
        "cests_ncm": "ncm", "cfops": "CFOP"}
for table, schema in schemas.items():
    columns = []
    for name, field in schema["fields"].items():
        numeric = field["type"] in ("int", "bigint", "tinyint", "smallint", "double", "decimal", "float")
        kind = "INTEGER" if field["auto"] or numeric else "TEXT"
        part = f'"{name}" {kind}'
        if name == keys.get(table, "Codigo") and table not in ("produtos_barras",):
            part += " PRIMARY KEY" + (" AUTOINCREMENT" if field["auto"] else "")
        if field["default"] is not None:
            part += " DEFAULT '" + str(field["default"]).replace("'", "''") + "'"
        columns.append(part)
    if table == "produtos":
        columns.append('FOREIGN KEY (Grupo, GrupoCategoria) REFERENCES produtos_grupos(Grupo, SubGrupo)')
    db.execute(f'CREATE TABLE "{table}" (' + ", ".join(columns) + ")")
db.executescript("""
CREATE TABLE produtos_fotos(Referencia TEXT, Sequencia INTEGER, Foto BLOB, Usuario TEXT, Inclusao TEXT);
CREATE TABLE produtos_referencias_prod(Referencia TEXT);
CREATE TABLE seg_menu(id INTEGER PRIMARY KEY, menu TEXT);
CREATE TABLE seg_perfil(id INTEGER PRIMARY KEY, nome TEXT);
CREATE TABLE seg_aplicacoes(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, rota TEXT, menu_id INTEGER, ordem INTEGER);
CREATE TABLE seg_perfil_permissoes(id INTEGER PRIMARY KEY AUTOINCREMENT, perfil_id INTEGER, aplicacao_id INTEGER,
 visualizar INTEGER, inserir INTEGER, editar INTEGER, excluir INTEGER, imprimir INTEGER, exportar INTEGER, processar INTEGER);
INSERT INTO seg_menu VALUES(30, 'Cadastros');
INSERT INTO seg_perfil VALUES(1, 'Administrador');
""")


def insert(table, values):
    columns = ", ".join('"' + key + '"' for key in values)
    db.execute(f'INSERT INTO "{table}" ({columns}) VALUES (' + ", ".join("?" for _ in values) + ")", list(values.values()))


for table, values in [
    ("produtos_fornecedor", {"Codigo": "AA", "NomeFornecedor": "Fornecedor", "Status": "Ativo"}),
    ("produtos_categorias", {"Codigo": "BB", "TipoProduto": "Categoria R2", "Status": "Ativo"}),
    ("produtos_grupos_livre", {"Codigo": 1, "GrupoLivre": "INFANTIL", "Sts": "Ativo"}),
    ("produtos_categorias_livre", {"Codigo": 1, "CategoriaLivre": "CAMISETA", "Sts": "Ativo"}),
    ("produtos_grupos", {"Codigo": 1, "Grupo": "INFANTIL", "SubGrupo": "CAMISETA", "Status": "Ativo"}),
    ("produtos_colecao", {"Codigo": 1, "Colecao": "VERAO", "Status": "Ativo"}),
    ("produtos_linhas", {"Codigo": 1, "Linha": "LINHA", "Status": "Ativo"}),
    ("produtos_composicoes", {"Codigo": 1, "Composicao": "ALGODAO", "Status": "Ativo"}),
    ("produtos_caracteristicas", {"Codigo": 1, "Caracteristica": "LISA", "Status": "Ativo"}),
    ("produtos_generos", {"Codigo": 1, "Genero": "UNISSEX", "Abreviado": "UN", "Status": "Ativo"}),
    ("produtos_estilos", {"Codigo": 0, "Descricao": "PADRAO", "Status": "Ativo"}),
    ("produtos_medidas", {"Sigla": "UN", "Unidade": "UNIDADE", "Status": "Ativo"}),
    ("cests_ncm", {"ncm": "12345678", "descricao": "NCM", "Status": "Ativo"}),
    ("cfops", {"CFOP": "5102", "Descricao": "VENDA", "Status": "Ativo"}),
    ("st_origem", {"Codigo": "0", "Descricao": "NACIONAL", "Status": "Ativo"}),
    ("st_icms", {"Codigo": "000", "Descricao": "ICMS", "Status": "Ativo"}),
    ("st_pis", {"Codigo": "01", "Descricao": "PIS", "Status": "Ativo"}),
    ("st_cofins", {"Codigo": "01", "Descricao": "COFINS", "Status": "Ativo"}),
    ("st_ipi", {"Codigo": "01", "Descricao": "IPI", "Status": "Ativo"}),
    ("produtos_prm", {"Codigo": 1, "CFOP": "5102", "Origem": "0", "CST_ICMS": "000", "CST_PIS": "01", "CST_COFINS": "01", "CST_IPI": "01", "PrecoAtacadoMetadeVarejo": "S", "UpperCase": "N"}),
]:
    insert(table, values)
for code in ("01", "02"):
    insert("produtos_cor", {"Codigo": code, "Nome": "COR " + code, "Status": "Ativo"})
for code in ("04", "06"):
    insert("produtos_tamanho", {"Codigo": code, "Nome": "TAM " + code, "Status": "Ativo"})
db.commit()
db.close()

(TEMP / "config/database.php").write_text("""<?php
require_once __DIR__.'/app.php';
const DB_NAME = 'fixture';
class FixturePDO extends PDO {
 public function prepare(string $query, array $options=[]): PDOStatement|false {
  $query = str_replace(' FOR UPDATE', '', $query);
  if (str_contains($query, 'information_schema.KEY_COLUMN_USAGE'))
   $query = "SELECT '' AS TABLE_NAME, '' AS COLUMN_NAME, '' AS REFERENCED_COLUMN_NAME WHERE 1=0 AND :table IS NOT NULL";
  return parent::prepare($query, $options);
 }
}
function db(): PDO { static $pdo; return $pdo ??= new FixturePDO('sqlite:'.__DIR__.'/../fixture.sqlite', null, null,
 [PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC]); }
""", encoding="utf-8")
(TEMP / "setup.php").write_text("""<?php
require __DIR__.'/config/database.php'; require __DIR__.'/scripts/seed_produtos.php';
registrar_aplicacoes_produtos(db()); registrar_aplicacoes_produtos(db());
echo db()->query('SELECT COUNT(*) FROM seg_aplicacoes')->fetchColumn();
""", encoding="utf-8")
result = subprocess.run(["php", str(TEMP / "setup.php")], capture_output=True, text=True)
assert result.returncode == 0 and result.stdout == "28", result.stdout + result.stderr
(TEMP / "session.php").write_text("""<?php
require __DIR__.'/includes/auth.php';
login_user(['id'=>1,'login'=>'fixture','nome'=>'Teste','perfil_id'=>1]); $_SESSION['produtos_csrf']='fixture-token'; echo 'ok';
""", encoding="utf-8")
sock = socket.socket()
sock.bind(("127.0.0.1", 0))
port = sock.getsockname()[1]
sock.close()
base = "http://127.0.0.1:" + str(port)
log = open(TEMP / "server.log", "w", encoding="utf-8")
kwargs = {"creationflags": subprocess.CREATE_NO_WINDOW} if hasattr(subprocess, "CREATE_NO_WINDOW") else {}
server = subprocess.Popen(["php", "-S", "127.0.0.1:" + str(port), "-t", str(TEMP)], stdout=log, stderr=log, **kwargs)
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
checks = 0


def request(path, data=None, status=200):
    global checks
    body = json.dumps(data).encode() if data is not None else None
    req = urllib.request.Request(base + path, body, {"Content-Type": "application/json"})
    try:
        response = opener.open(req)
        code, raw = response.status, response.read()
    except urllib.error.HTTPError as error:
        code, raw = error.code, error.read()
    assert code == status, (path, code, raw, "Log: " + str(TEMP / "server.log"))
    checks += 1
    return json.loads(raw)


def api(entity, action="list", data=None, status=200):
    return request("/api/cadastros/produtos.php?cadastro=" + entity + "&action=" + action, data, status)


def process(action, data=None, status=200):
    return request("/api/cadastros/produtos_processos.php", {"action": action, "csrf": "fixture-token", **(data or {})}, status)


try:
    for _ in range(50):
        try:
            opener.open(base + "/session.php")
            break
        except urllib.error.URLError:
            time.sleep(0.1)
    for entity in ["produtos", "valores", "outras_informacoes", "precos_lote", "fotos", "consolidar", "consulta_geral", "consulta_precos", "parametros", "importar_antigos", "colecao", "linha", "grupo", "grupos_tamanho", "categoria", "composicao", "caracteristica", "grupo_categoria", "categoria_composicao", "categoria_caracteristica", "fornecedor", "categoria_r2", "tamanho", "ordenar_tamanho", "cor", "genero", "estilo", "medida"]:
        grid_rows = api(entity)["data"]
        for grid_row in grid_rows:
            assert all(field in grid_row for field in ("Inclusao", "Alteracao", "Usuario")), entity
        if entity == "parametros":
            assert grid_rows and all(grid_rows[0][field] is None for field in ("Inclusao", "Alteracao", "Usuario"))
        raw = opener.open(base + "/mod/cadastros/produtos/produtos_lista.php?cadastro=" + entity).read()
        marker = b"window.produtosAccordionConfig" if entity == "produtos" else (b"window.produtosValoresConfig" if entity == "valores" else (b"window.grupoCategoriaConfig" if entity in ("grupo_categoria", "grupos_tamanho", "categoria_composicao", "categoria_caracteristica") else b"window.produtosConfig"))
        assert marker in raw and b"menu-submenu" in raw, entity
        checks += 1
    api("invalido", status=404)
    api("colecao", "save", {"csrf": "bad"}, 403)
    api("colecao", "save", {"Colecao": "NOVA", "Status": "Ativo", "Externo": "2", "csrf": "fixture-token"}, 422)
    new = api("colecao", "save", {"Colecao": "NOVA", "Status": "Ativo", "Externo": "0", "csrf": "fixture-token"})["id"]
    api("colecao", "save", {"id": new, "Colecao": "ALTERADA", "Status": "Ativo", "Externo": "1", "csrf": "fixture-token"})
    assert api("colecao", "get", {"id": new})["data"]["Colecao"] == "ALTERADA"
    api("colecao", "delete", {"id": new, "csrf": "fixture-token"})

    product = {"Fornecedor": "AA", "Categoria": "BB", "CodFornecedorR3": "1234", "CodFornecedor": "REF TESTE", "Grupo": "INFANTIL", "GrupoCategoria": "CAMISETA", "Colecao": 1, "Linha": 1, "Composicao": 1, "Caracteristica": 1, "Genero": 1, "Descricao": "PRODUTO TESTE", "DescricaoComplementar": "", "Unidade": "UN", "Cor": ["01", "02"], "Tamanho": ["04", "06"], "NCM": "12345678", "CST_ICMS": "000", "Origem": "0", "CST_PIS": "01", "CST_COFINS": "01", "CST_IPI": "01", "CFOP": "5102", "CFOP_ProducaoProria": "", "PrecoCompra": 10, "PrecoCompraTabela": 20, "PrecoVendaTabela": 40, "Status": "Ativo", "Estilo": 0, "csrf": "fixture-token"}
    api("produtos", "save", {**product, "GrupoCategoria": "INVALIDA"}, 422)
    saved = api("produtos", "save", product)
    audit_grid = api("produtos", "list", {"product_reference": saved["id"]})["data"][0]
    assert audit_grid["Inclusao"] and audit_grid["Alteracao"] and audit_grid["Usuario"] == "fixture"
    assert saved["id"] == "AABB1234" and saved["created"] == 4, saved
    reference = saved["id"]
    assert api("produtos", "product_search", {"q": reference})["results"][0]["id"] == reference
    assert api("produtos", "product_search", {"q": "PRODUTO TESTE"})["results"][0]["id"] == reference
    assert api("produtos", "product_search", {"q": "NAOEXISTE"})["results"] == []
    assert api("produtos", "list", {"product_reference": reference})["data"][0]["Referencia"] == reference
    assert api("produtos", "list", {"product_reference": reference[:4]})["data"] == []
    # Filtros multiplos: OR dentro de cada campo, AND entre fornecedor e categoria.
    filter_db = sqlite3.connect(TEMP / "fixture.sqlite")
    filter_db.row_factory = sqlite3.Row
    base_header = dict(filter_db.execute("SELECT * FROM produtos_cab WHERE Referencia=?", (reference,)).fetchone())
    for extra_ref, supplier, category in [("CCBB0001", "CC", "BB"), ("AADD0001", "AA", "DD"), ("CCDD0001", "CC", "DD")]:
        header = {**base_header, "Referencia": extra_ref, "Fornecedor": supplier, "Categoria": category}
        columns = ", ".join('"' + key + '"' for key in header)
        filter_db.execute('INSERT INTO produtos_cab (' + columns + ') VALUES (' + ','.join('?' for _ in header) + ')', list(header.values()))
    filter_db.commit()
    assert len(api("produtos", "list", {"Fornecedor": ["AA", "CC"]})["data"]) == 4
    assert len(api("produtos", "list", {"Categoria": ["BB", "DD"]})["data"]) == 4
    assert {r["Referencia"] for r in api("produtos", "list", {"Fornecedor": ["AA"], "Categoria": ["DD"]})["data"]} == {"AADD0001"}
    assert len(api("produtos", "list", {"Fornecedor": ["AA", "CC"], "Categoria": ["DD"]})["data"]) == 2
    assert len(api("produtos", "list", {"Fornecedor": [], "Categoria": []})["data"]) == 4
    assert len(api("produtos", "list", {"Fornecedor": ["AA", "AA"]})["data"]) == 2
    api("produtos", "list", {"Fornecedor": [["AA"]]}, 422)
    api("produtos", "list", {"Categoria": ["INVALIDA"]}, 422)
    get_filters = json.loads(opener.open(base + "/api/cadastros/produtos.php?cadastro=produtos&action=list&Fornecedor[]=AA&Fornecedor[]=CC&Categoria[]=DD").read())
    assert len(get_filters["data"]) == 2
    checks += 1
    filter_db.execute("DELETE FROM produtos_cab WHERE Referencia IN ('CCBB0001','AADD0001','CCDD0001')")
    filter_db.commit()
    filter_db.close()
    assert len(api("produtos", "get", {"id": reference})["details"]) == 4
    raw = opener.open(base + "/mod/cadastros/produtos/produtos_form.php?cadastro=produtos&id=" + reference).read()
    assert b'Cor[]' in raw and b'Tamanho[]' in raw
    process("consolidate", {"id": reference})
    assert api("produtos", "list", {"Tamanho": "06"})["data"][0]["Referencia"] == reference
    assert api("produtos", "list", {"Cor": "02"})["data"][0]["Referencia"] == reference
    assert api("produtos", "list", {"Tamanho": "60"})["data"] == []
    price_history = api("produtos", "price_history", {"id": reference})
    assert len(price_history["data"]) == 4
    one_history = api("produtos", "price_history", {"id": reference, "reference": "AABB12340401"})
    assert len(one_history["data"]) == 1 and one_history["data"][0]["Referencia"] == "AABB12340401"
    api("produtos", "price_history", {"id": reference, "reference": "OTHER1230401"}, 422)
    api("produtos", "price_history", {"id": "INEXISTE"}, 404)
    editor_before = api("produtos", "get", {"id": reference})
    rows = api("consulta_geral")["data"]
    assert len(rows) == 4 and rows[0]["Codigo"] == "00115001", rows
    codes = {row["Distribuidora"]: row["Codigo"] for row in rows}
    api("produtos", "save", {**product, "id": reference, "Descricao": "DESCRICAO ALTERADA"})
    api("produtos", "save", {**product, "id": reference, "version": editor_before["version"], "Descricao": "NAO DEVE GRAVAR"}, 409)
    assert api("produtos", "get", {"id": reference})["data"]["Descricao"] == "DESCRICAO ALTERADA"
    # Historico paginado, mais recente primeiro, sem incluir logs de outro produto.
    history_db = sqlite3.connect(TEMP / "fixture.sqlite")
    history_db.executemany("INSERT INTO produtos_log_preco (DataHora,Produto,Referencia,Acao,VarejoOLD,VarejoNEW,AtacadoOLD,AtacadoNEW,CompraOLD,CompraNEW,Usuario) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [("2099-01-01 10:00:00", "00115001", "AABB12340401", "Alteracao", 40, 42, 20, 21, 10, 10, "history-test") for _ in range(52)]
        + [("2099-01-01 10:00:00", "99999999", "ZZZZ00000401", "Alteracao", 40, 42, 20, 21, 10, 10, "outro")])
    history_db.commit()
    history_page = api("produtos", "price_history", {"id": reference})
    assert len(history_page["data"]) == 50 and history_page["more"]
    assert history_page["data"][0]["Id"] > history_page["data"][1]["Id"]
    next_history = api("produtos", "price_history", {"id": reference, "page": 2})
    assert len(next_history["data"]) == 6 and not next_history["more"]
    history_db.execute("DELETE FROM produtos_log_preco WHERE Usuario IN ('history-test','outro')")
    history_db.execute("UPDATE seg_perfil_permissoes SET visualizar=0 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE '%cadastro=produtos')")
    history_db.commit()
    api("produtos", "price_history", {"id": reference}, 403)
    history_db.execute("UPDATE seg_perfil_permissoes SET visualizar=1 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE '%cadastro=produtos')")
    history_db.commit()
    history_db.close()
    process("consolidate", {"id": reference})
    assert {row["Distribuidora"]: row["Codigo"] for row in api("consulta_geral")["data"]} == codes
    full = "AABB12340401"
    values = {"id": full, "PrecoCompra": 12, "PrecoCompraTabela": 25, "PrecoVendaTabela": 50, "PrecoCheio": "N", "SetorLaranja": "N", "Encomenda": "N", "Estilo": 0, "csrf": "fixture-token"}
    api("valores", "save", values)
    process("consolidate", {"id": reference})
    assert float(api("consulta_geral", "get", {"id": codes[full]})["data"]["PrecoVendaTabela"]) == 50
    # Valores: master, filtros de variantes, previa e gravacao atomica por produto.
    def pv(action="list", data=None, status=200):
        return request("/api/cadastros/produtos_valores.php?action=" + action, data, status)

    listed = pv(data={"Referencia": reference})
    assert listed["data"][0]["Referencia"] == reference and listed["data"][0]["Quantidade"] == 4
    assert pv(data={"CodFornecedorR3": "NAOEXISTE"})["data"] == []
    assert pv(data={"Tamanho": "04", "Cor": "01"})["data"][0]["Quantidade"] == 1
    initial_values = pv("get", {"id": reference})
    assert len(initial_values["rows"]) == 4 and initial_values["halfWholesale"]
    assert len(pv("get", {"id": reference, "Tamanho": "04"})["rows"]) == 2
    first, second = initial_values["rows"][:2]
    payload = {"id": reference, "csrf": "fixture-token", "rows": [
        {"id": first["Distribuidora"], "version": first["_version"], "values": {"PrecoVendaTabela": "60,00"}},
        {"id": second["Distribuidora"], "version": second["_version"], "values": {"PrecoCompra": "-1"}},
    ]}
    pv("save", {**payload, "csrf": "bad"}, 403)
    pv("save", payload, 422)
    assert pv("get", {"id": reference})["rows"][0]["_version"] == first["_version"]
    payload["rows"][1]["values"] = {"PrecoVendaTabela": "60,00", "Encomenda": "S"}
    assert pv("save", payload)["processed"] == 2
    pv("save", payload, 409)
    changed_values = pv("get", {"id": reference})
    assert all(float(row["PrecoCompraTabela"]) == 30 and row["Consolidado"] == "N" for row in changed_values["rows"][:2])
    assert float(api("consulta_geral", "get", {"id": codes[full]})["data"]["PrecoVendaTabela"]) == 50
    one = changed_values["rows"][0]
    pv("save", {"id": reference, "csrf": "fixture-token", "rows": [{"id": one["Distribuidora"], "version": one["_version"], "values": {"PrecoVendaTabela": "70", "PrecoCheio": "S"}}]})
    one = pv("get", {"id": reference})["rows"][0]
    assert float(one["PrecoCompraTabela"]) == 70
    pv("save", {"id": reference, "csrf": "fixture-token", "rows": [{"id": one["Distribuidora"], "version": one["_version"], "values": {"Status": "Inativo"}}]}, 422)
    # Restaura os valores do inicio para os demais cenarios e comprova que os itens nao alterados foram preservados.
    current_values = pv("get", {"id": reference})["rows"]
    assert current_values[2:][0]["_version"] == initial_values["rows"][2]["_version"]
    restore_rows = []
    for old, current in zip(initial_values["rows"], current_values):
        restore_rows.append({"id": old["Distribuidora"], "version": current["_version"], "values": {field: old[field] for field in ["PrecoVendaTabela", "PrecoCompraTabela", "PrecoCompra", "SetorLaranja", "PrecoCheio", "Encomenda", "Estilo"]}})
    pv("save", {"id": reference, "csrf": "fixture-token", "rows": restore_rows})
    db = sqlite3.connect(TEMP / "fixture.sqlite")
    db.execute("UPDATE seg_perfil_permissoes SET editar=0 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE '%cadastro=valores')")
    db.commit()
    assert pv("get", {"id": reference})["rows"]
    pv("save", payload, 403)
    db.execute("UPDATE seg_perfil_permissoes SET editar=1 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE '%cadastro=valores')")
    db.commit()
    db.close()
    process("consolidate", {"id": reference})
    # Alteração em lote é atômica, inclusive quando uma referência posterior falha.
    process("grade_bulk_valores", {"ids": [full, "INEXISTENTE"], "campo": "PrecoVendaTabela", "valor": "60"}, 422)
    assert float(api("valores", "get", {"id": full})["data"]["PrecoVendaTabela"]) == 50
    process("grade_bulk_valores", {"ids": [full], "campo": "PrecoVendaTabela", "valor": "60"})
    assert float(api("valores", "get", {"id": full})["data"]["PrecoCompraTabela"]) == 30
    process("grade_bulk_valores", {"ids": [full], "campo": "PrecoVendaTabela", "valor": "50"})
    process("consolidate", {"ids": [reference]})
    process("order_sizes", {"ordem": ["06", "04"]})
    assert api("ordenar_tamanho", "sizes")["data"][0]["Codigo"] == "06"
    process("order_sizes", {"ordem": ["06", "06"]}, 422)

    today = time.strftime("%Y-%m-%d")
    batch = api("precos_lote", "save", {"Descricao": "LOTE TESTE", "DataAtualizacao": today, "DataVoltaAtualizacao": "2099-12-31", "csrf": "fixture-token"})["id"]
    process("batch_item", {"id": batch, "referencia": full, "varejo": "80", "atacado": "40"})
    process("batch_item", {"id": batch, "referencia": full, "varejo": "80", "atacado": "40"}, 422)
    process("batch_apply", {"id": batch})
    assert float(api("consulta_geral", "get", {"id": codes[full]})["data"]["PrecoVendaTabela"]) == 80
    process("batch_apply", {"id": batch}, 422)
    process("batch_restore", {"id": batch})
    assert float(api("consulta_geral", "get", {"id": codes[full]})["data"]["PrecoVendaTabela"]) == 50
    api("precos_lote", "delete", {"id": batch, "csrf": "fixture-token"}, 422)

    # Upload multipart real, para passar por is_uploaded_file e validação de imagem.
    image = base64.b64decode("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jNn0AAAAASUVORK5CYII=")
    boundary = "fixture-boundary"
    parts = []
    for name, value in {"action": "photo_upload", "csrf": "fixture-token", "id": reference}.items():
        parts.append(f'--{boundary}\r\nContent-Disposition: form-data; name="{name}"\r\n\r\n{value}\r\n'.encode())
    parts.append(f'--{boundary}\r\nContent-Disposition: form-data; name="foto"; filename="foto.png"\r\nContent-Type: image/png\r\n\r\n'.encode() + image + b"\r\n")
    parts.append(f"--{boundary}--\r\n".encode())
    for _ in range(5):
        req = urllib.request.Request(base + "/api/cadastros/produtos_processos.php", b"".join(parts), {"Content-Type": "multipart/form-data; boundary=" + boundary})
        assert json.loads(opener.open(req).read())["success"]
        checks += 1
    try:
        opener.open(req)
        raise AssertionError("Limite de cinco fotos não aplicado")
    except urllib.error.HTTPError as error:
        assert error.code == 422
        checks += 1
    assert len(api("fotos", "photos", {"id": reference})["data"]) == 5
    assert int(api("produtos", "get", {"id": reference})["data"]["Foto"]) == 1
    process("photo_delete", {"id": reference, "sequencia": 1})
    assert len(api("fotos", "photos", {"id": reference})["data"]) == 4

    # Importação da base GCOM mantém os códigos e barras de origem e não sobrescreve os existentes.
    db = sqlite3.connect(TEMP / "fixture.sqlite")
    db.row_factory = sqlite3.Row
    for source, target, field, value in [
        ("produtos_cab", "produtos_cab_gcom", "Referencia", "AABB9999"),
        ("produtos_cab_grade", "produtos_cab_grade_gcom", "Distribuidora", "AABB99990401"),
        ("produtos", "produtos_gcom", "Distribuidora", "AABB99990401"),
    ]:
        row = dict(db.execute(f'SELECT * FROM "{source}" LIMIT 1').fetchone())
        row = {key: value_ for key, value_ in row.items() if key in schemas[target]["fields"]}
        row[field] = value
        if "Referencia" in row:
            row["Referencia"] = "AABB9999"
        row["CodFornecedorR3"] = "9999"
        if source == "produtos":
            row["Codigo"] = "00999001"
        insert(target, row)
    insert("produtos_barras_gcom", {"Codigo": "00999001", "CodigoBarra": "00999001"})
    db.commit()
    db.close()
    imported = process("import", {"referencia": "AABB9999", "faltantes": "S"})["data"]
    assert imported["source"] == "gcom" and imported["produtos"] == 1 and imported["barras"] == 1, imported
    assert process("import", {"referencia": "AABB9999", "faltantes": "S"})["data"]["produtos"] == 0
    process("import", {"referencia": "AABB9999", "faltantes": "N"}, 422)

    # Mantém referências consolidadas ao excluir o cadastro.
    api("produtos", "delete", {"id": reference, "csrf": "fixture-token"})
    assert len(api("consulta_geral")["data"]) == 5
    db = sqlite3.connect(TEMP / "fixture.sqlite")
    db.execute("UPDATE seg_perfil_permissoes SET visualizar=0 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE ?)", ("%cadastro=cor",))
    db.commit()
    db.close()
    api("cor", status=403)
    result = subprocess.run(["php", str(TEMP / "setup.php")], capture_output=True, text=True)
    assert result.stdout == "28", result.stdout + result.stderr
    api("cor", status=403)
    # Accordion: gravação por grupo, concorrência, permissões e remoção com dependências.
    def gc(action="list", data=None, status=200):
        return request("/api/cadastros/grupo_categoria.php?action=" + action, data, status)

    assert gc()["data"]
    gc("save&grupo=INFANTIL", status=405)
    initial = gc("get", {"grupo": "INFANTIL"})
    chosen = [row["SubGrupo"] for row in initial["vinculos"]]
    api("categoria", "save", {"CategoriaLivre": "NOVA", "Sts": "Ativo", "csrf": "fixture-token"})
    payload = {"grupo": "INFANTIL", "categorias": chosen + ["NOVA"], "version": initial["version"], "csrf": "fixture-token"}
    gc("save", {**payload, "csrf": "invalid"}, 403)
    gc("save", {**payload, "categorias": ["INEXISTENTE"]}, 422)
    assert gc("save", payload)["added"] == 1
    gc("save", payload, 409)
    current = gc("get", {"grupo": "INFANTIL"})
    remove = {"grupo": "INFANTIL", "categorias": chosen, "version": current["version"], "csrf": "fixture-token"}
    db = sqlite3.connect(TEMP / "fixture.sqlite")
    route = "%cadastro=grupo_categoria"
    db.execute("UPDATE seg_perfil_permissoes SET excluir=0 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE ?)", (route,))
    db.commit()
    gc("save", remove, 403)
    db.execute("UPDATE seg_perfil_permissoes SET excluir=1 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE ?)", (route,))
    db.execute('CREATE TABLE gc_dependency (categoria TEXT, FOREIGN KEY (categoria) REFERENCES produtos_grupos(SubGrupo) ON DELETE CASCADE)')
    db.execute("INSERT INTO gc_dependency VALUES ('NOVA')")
    db.commit()
    gc("save", remove, 422)
    assert db.execute("SELECT COUNT(*) FROM gc_dependency").fetchone()[0] == 1
    db.execute("DELETE FROM gc_dependency")
    db.commit()
    assert gc("save", remove)["removed"] == 1
    current = gc("get", {"grupo": "INFANTIL"})
    # Produtos consolidados continuam usando CAMISETA; a tentativa também inclui NOVA para provar atomicidade.
    gc("save", {"grupo": "INFANTIL", "categorias": ["NOVA"], "version": current["version"], "csrf": "fixture-token"}, 422)
    assert gc("get", {"grupo": "INFANTIL"})["version"] == current["version"]
    db.execute("UPDATE seg_perfil_permissoes SET inserir=0 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE ?)", (route,))
    db.commit()
    gc("save", {**payload, "version": current["version"]}, 403)
    db.execute("UPDATE seg_perfil_permissoes SET visualizar=0 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE ?)", (route,))
    db.commit()
    db.close()
    gc(status=403)
    # Mesmo contrato com chaves distintas: IDs numericos, tamanho com zero inicial e auditoria opcional.
    for entity, table, field, target, name_field in [
        ("grupos_tamanho", "produtos_grupos_tamanho", "Tamanho", "produtos_tamanho", "Nome"),
        ("categoria_composicao", "produtos_categoria_composicao", "Composicao", "produtos_composicoes", "Composicao"),
        ("categoria_caracteristica", "produtos_categoria_caracteristicas", "Caracteristica", "produtos_caracteristicas", "Caracteristica"),
    ]:
        def association(action="list", data=None, status=200):
            return request("/api/cadastros/produtos_associacoes.php?cadastro=" + entity + "&action=" + action, data, status)

        groups = association()["data"]
        assert groups and str(groups[0]["Grupo"]) == "1" and groups[0]["Nome"]
        original = association("get", {"grupo": "1"})
        ids = [str(row["Valor"]) for row in original["data"]]
        assert ids
        chosen = ids[:1]
        payload = {"grupo": "1", "categorias": chosen, "version": original["version"], "csrf": "fixture-token"}
        association("save", {**payload, "csrf": "invalid"}, 403)
        association("save", {**payload, "categorias": ["INEXISTENTE"]}, 422)
        association("save", payload)
        loaded = association("get", {"grupo": "1"})
        assert [row["SubGrupo"] for row in loaded["vinculos"]] == chosen
        association("save", payload, 409)
        db = sqlite3.connect(TEMP / "fixture.sqlite")
        before = db.execute(f'SELECT * FROM "{table}"').fetchall()
        # Sem mudancas preserva ID, ordem, status e auditoria.
        same = {**payload, "version": loaded["version"]}
        association("save", same)
        assert db.execute(f'SELECT * FROM "{table}"').fetchall() == before
        if entity == "grupos_tamanho":
            assert before[0][2] == chosen[0] and chosen[0] == "04"
        # Cada API usa as permissoes de sua propria aplicacao.
        route = "%cadastro=" + entity
        db.execute("UPDATE seg_perfil_permissoes SET excluir=0 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE ?)", (route,))
        db.commit()
        removal = {**same, "categorias": []}
        association("save", removal, 403)
        db.execute("UPDATE seg_perfil_permissoes SET excluir=1 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE ?)", (route,))
        # Chave estrangeira de teste com cascata deve impedir a remocao de um vinculo usado.
        dep = "dep_" + entity
        db.execute(f'CREATE TABLE "{dep}" (vinculo INTEGER, FOREIGN KEY (vinculo) REFERENCES "{table}"(Codigo) ON DELETE CASCADE)')
        db.execute(f'INSERT INTO "{dep}" SELECT Codigo FROM "{table}" LIMIT 1')
        db.commit()
        association("save", removal, 422)
        db.execute(f'DELETE FROM "{dep}"')
        db.commit()
        assert association("save", removal)["removed"] == 1
        empty = association("get", {"grupo": "1"})
        assert empty["vinculos"] == []
        # Item inativo nao pode ser associado novamente.
        db.execute(f'UPDATE "{target}" SET Status=\'Inativo\' WHERE Codigo=?', (chosen[0],))
        db.commit()
        association("save", {**payload, "version": empty["version"]}, 422)
        db.execute(f'UPDATE "{target}" SET Status=\'Ativo\' WHERE Codigo=?', (chosen[0],))
        db.execute("UPDATE seg_perfil_permissoes SET visualizar=0 WHERE aplicacao_id=(SELECT id FROM seg_aplicacoes WHERE rota LIKE ?)", (route,))
        db.commit()
        db.close()
        association(status=403)
    print(f"PASS: {checks} verificações HTTP; fixture isolada em {TEMP}")
finally:
    server.terminate()
    server.wait(timeout=10)
    log.close()
