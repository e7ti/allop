# ALLOP - Arquitetura, Regras e Padroes do Sistema

**Projeto correto para manutencao:** `D:\E7TI\PHP\allop`  
**Atencao:** nao usar `D:\E7TI\PHP\appf` para demandas do Allop.

**Documento-base:** 01/06/2026  
**Ultima revisao documental:** 31/07/2026  
**Ultima revisao conferida do codigo:** 31/07/2026  
**Ultima revisao conferida do `banco.sql`:** 15/07/2026  
**Ultima revisao conferida do `banco_fotos.sql`:** 19/06/2026  
**Escopo conferido:** aplicacao PHP, APIs, telas, assets, seed, banco principal, banco de fotos e documentacao existente.

## 1. Objetivo

Este documento descreve o estado atual do sistema Allop e os padroes que devem ser preservados em manutencoes, correcoes e novos desenvolvimentos.

As informacoes abaixo foram conferidas diretamente no projeto em `D:\E7TI\PHP\allop`. Quando existe diferenca entre uma intencao original, uma documentacao antiga e o comportamento implementado, a diferenca esta registrada em **Pontos de atencao conhecidos**.

## 2. Visao Geral

O Allop e uma aplicacao web responsiva em PHP puro, com telas renderizadas no servidor e APIs PHP retornando JSON para operacoes de CRUD e fluxos especificos.

Principais caracteristicas:

- PHP procedural, sem framework backend;
- autenticacao por sessao PHP;
- PDO para acesso ao MySQL;
- banco principal separado do banco de fotos;
- telas em `mod/`;
- endpoints em `api/`;
- Bootstrap, jQuery e Select2 distribuidos localmente em `assets/vendor/`;
- Dompdf instalado via Composer para geracao de PDF;
- menu dinamico por perfil;
- dashboard de compras;
- modulo de compras com pedido, itens, tamanhos, cores, rateio, fotos, e-mail, logs e workflow.

Fluxo principal:

```text
index.php
  -> sem sessao: login.php -> api/seguranca/auth.php
  -> com sessao: dashboard.php
       -> telas em mod/
            -> chamadas AJAX para api/
                 -> db()       -> banco principal
                 -> db_fotos() -> banco de fotos
```

## 3. Estrutura do Projeto

| Caminho | Responsabilidade |
| --- | --- |
| `index.php` | Redireciona para login ou dashboard conforme a sessao. |
| `login.php` | Tela publica de autenticacao. |
| `logout.php` | Encerra a sessao. |
| `dashboard.php` | Painel autenticado com indicadores, graficos e ultimos pedidos de compra. |
| `alterar_senha_admin.php` | Tela especifica para trocar a senha do usuario `admin`. |
| `config/` | Configuracao geral e conexoes PDO. |
| `includes/` | Autenticacao, permissoes, layout e envio SMTP. |
| `mod/` | Telas dos modulos do sistema. |
| `api/` | Endpoints JSON usados pelas telas. |
| `assets/css/` | CSS global do sistema. |
| `assets/js/` | JavaScript global, CRUD generico e logica de compras. |
| `assets/vendor/` | Bootstrap, jQuery e Select2 locais. |
| `assets/img/` | Logos e imagens institucionais, incluindo `SemFoto.png` como placeholder atual de item sem foto. |
| `scripts/` | Rotinas administrativas, incluindo `seed_aplicacoes.php`. |
| `docs/` | Documentacao e registros auxiliares. |
| `banco.sql` | Dump estrutural do banco principal. |
| `banco_fotos.sql` | Dump estrutural do banco de fotos. |
| `vendor/` | Dependencias do Composer. Nao usar como referencia de regra do projeto. |

Arquivos Markdown/documentacao proprios:

- `docs/plaintext.md`: este documento, fonte principal de manutencao;
- `docs/plaintext.txt`: documento legado de padroes;
- `docs/def.txt`: briefing inicial legado.

## 4. Arquivos Compartilhados Centrais

| Arquivo | Funcao |
| --- | --- |
| `config/app.php` | Define `APP_NAME`, `APP_DATE`, `BASE_PATH`, `BASE_URL`, `app_url()` e `h()`. |
| `config/database.php` | Define `db()` e `db_fotos()` com PDO, erro por excecao e prepared statements nativos. |
| `includes/auth.php` | Inicializa sessao e fornece `current_user()`, `require_login()`, `login_user()` e `logout_user()`. |
| `includes/permissions.php` | Monta o menu com base em `seg_perfil_permissoes.visualizar`. |
| `includes/layout.php` | Renderiza header, menu, area de conteudo, footer e assets locais. |
| `includes/smtp_mailer.php` | Cliente SMTP por socket com SSL implicito, STARTTLS e autenticacao opcional. |
| `api/bootstrap.php` | Inicializacao comum das APIs, `api_response()`, `request_data()` e `api_require_login()`. |
| `assets/js/app.js` | CRUD generico, Select2, alertas, confirmacao, sincronizacao de grids, ViaCEP, empresas, e-mail e fluxo completo de compras. |
| `assets/css/style.css` | Tema global, responsividade, botoes com icones, grids, dashboard, login e componentes de compras. |
| `scripts/seed_aplicacoes.php` | Seed de menus, aplicacoes, perfil Administrador, permissoes, usuario inicial e estruturas auxiliares. |

## 5. Bibliotecas e Recursos

| Componente | Local | Uso |
| --- | --- | --- |
| PHP puro | arquivos `.php` | Renderizacao server-side, APIs JSON, sessao, regras e PDF. |
| PDO MySQL | `config/database.php` | Acesso ao banco principal e ao banco de fotos. |
| Bootstrap 5.3.6 | `assets/vendor/bootstrap/` | Layout, grid, navbar, dropdowns, botoes, cards, modais e utilitarios. |
| jQuery 3.7.1 | `assets/vendor/jquery/jquery.min.js` | AJAX, manipulacao de DOM e integracao com Select2. |
| Select2 4.1.0-rc.0 | `assets/vendor/select2/` | Campos pesquisaveis locais e remotos. |
| Dompdf 3.1 | `composer.json`, `vendor/` | PDF do pedido de compra. |
| ViaCEP | navegador, em `assets/js/app.js` | Preenchimento de endereco no cadastro de Empresas. |
| Google Fonts/Poppins | `assets/css/style.css` | Fonte visual principal via `@import`. |

Regra geral: manter bibliotecas locais. As excecoes atuais sao ViaCEP no navegador e Google Fonts no CSS.

## 6. Modulos Implementados

### 6.1 Seguranca

| Tela | API |
| --- | --- |
| `mod/seguranca/usuarios_lista.php` / `usuarios_form.php` | `api/seguranca/crud.php?entity=usuarios` |
| `mod/seguranca/perfis_lista.php` / `perfis_form.php` | `api/seguranca/crud.php?entity=perfis` |
| `mod/seguranca/aplicacoes_lista.php` / `aplicacoes_form.php` | `api/seguranca/crud.php?entity=aplicacoes` |
| `mod/seguranca/perfil_aplicacoes_lista.php` / `perfil_aplicacoes_form.php` | `api/seguranca/perfil_aplicacoes.php` |
| `mod/seguranca/usuarios_permissoes_lista.php` / `usuarios_permissoes_form.php` | `api/seguranca/crud.php?entity=usuarios_permissoes` |

APIs auxiliares:

| API | Acoes/comportamento |
| --- | --- |
| `api/seguranca/auth.php` | Valida login ativo, aceita senha com `password_verify()` e texto puro legado, cria sessao e retorna redirect. |
| `api/seguranca/options.php` | Fornece opcoes Select2 para perfis, aplicacoes, menus, usuarios, CDs e empresas. |
| `api/seguranca/admin_senha.php` | Altera a senha do login `admin` com `password_hash()`. Nao exige sessao atualmente. |
| `api/seguranca/crud.php` | CRUD generico para entidades de seguranca. |
| `api/seguranca/perfil_aplicacoes.php` | Lista perfis, lista permissoes por perfil, salva permissoes em lote e exclui permissoes de um perfil. |

Entidades aceitas pelo CRUD generico:

- `usuarios`;
- `perfis`;
- `aplicacoes`;
- `perfil_aplicacoes`;
- `usuarios_permissoes`;
- `menus`.

Acoes de `api/seguranca/perfil_aplicacoes.php`:

- `profiles`: lista perfis com total de permissoes;
- `list`: lista todas as aplicacoes e permissoes do perfil informado;
- `save`: grava permissoes em lote com upsert por perfil/aplicacao;
- `delete_profile`: remove todas as permissoes de um perfil.

Permissoes previstas em `seg_perfil_permissoes`:

- `visualizar`;
- `inserir`;
- `editar`;
- `excluir`;
- `imprimir`;
- `exportar`;
- `processar`.

Observacao importante: em `seg_usuarios_permissoes`, o codigo usa as grafias legadas `edtiar` e `imprirmir`.

### 6.2 Configuracoes

| Funcionalidade | Telas | API |
| --- | --- | --- |
| Empresas CD | `mod/configuracoes/empresas_cd/` | `api/configuracoes/empresas_cd.php` |
| Empresas | `mod/configuracoes/empresas/` | `api/configuracoes/empresas.php` |
| Configuracoes de e-mail | `mod/configuracoes/configuracoes_email/` | `api/configuracoes/configuracoes_email.php` |

Empresas CD:

- acoes `list`, `get`, `save` e `delete`;
- `Codigo` e informado ou calculado por `MAX(Codigo) + 1`;
- valida `NomeCD` e `Status`;
- lista ate 200 registros e filtra por codigo, nome do CD ou status.

Empresas:

- acoes `list`, `get`, `save` e `delete`;
- `Codigo` e informado ou calculado por `MAX(Codigo) + 1`;
- valida CD, Nome, Fantasia, CNPJ e Status;
- valida CNPJ pelo digito verificador;
- normaliza CNPJ, IE, CEP, IBGE, DDD e telefones para digitos;
- valida CEP com 8 digitos, IBGE com 7 digitos, DDD com 2 digitos e UF valida;
- detecta se a coluna `ibge` existe antes de consultar ou persistir;
- lista ate 200 registros e filtra por nome, fantasia, CNPJ ou cidade;
- usa ViaCEP no frontend para auxiliar o preenchimento de endereco.

Configuracoes de e-mail:

- acoes `list`, `get`, `save` e `delete`;
- persiste na tabela `config_email`;
- usa `cd_id`, `empresa_id`, `NomeConta`, `Habilitado`, `Servidor`, `Porta`, `ModoAutenticado`, `ModoSSL`, `Email`, `Senha` e `Status`;
- lista ate 200 registros e filtra por conta, servidor, e-mail ou status;
- e usada pelo envio de propostas de compra.

### 6.3 Compras

| Arquivo | Responsabilidade |
| --- | --- |
| `mod/compras/cp_compras_lista.php` | Pesquisa e lista pedidos de compra. |
| `mod/compras/cp_compras_form.php` | Cabecalho, itens, tamanhos, cores, rateio, fotos, logs e workflow. |
| `api/compras/cp_compras.php` | API principal de compras. |
| `api/compras/cp_compras_pdf.php` | Gera PDF completo do pedido em A4 paisagem. |

#### Acoes da API de Compras

| Acao | Comportamento |
| --- | --- |
| `options` | Pesquisa CDs, empresas, fornecedores e referencias para Select2. |
| `defaults` | Retorna CD/empresa automaticamente quando existe apenas um registro. |
| `list` | Lista ate 200 pedidos por numero, status, localizacao, fornecedor, empresa ou CD. Tambem aceita `pedido_id`. |
| `get` | Carrega cabecalho, itens, tamanhos, cores, rateios, indicadores de fotos e indicadores de log da iteracao atual. |
| `referencia` | Carrega referencia do fornecedor a partir de `pf_colecao`, com tamanhos e cores. |
| `save` | Insere ou atualiza pedido, itens, tamanhos, cores e rateios em transacao no banco principal. |
| `delete` | Exclui pedido editavel e seus filhos. |
| `fotos_list` | Lista fotos KidStok em `cp_compras_fotos_ks`. |
| `fotos_fornecedor_list` | Lista fotos do fornecedor em `cp_compras_fotos`. |
| `fotos_upload` | Recebe upload de imagens. Origem padrao `kidstok` grava em `cp_compras_fotos_ks`; origem `fornecedor` existe no contrato, mas e bloqueada pela regra interna. |
| `fotos_delete` | Exclui foto KidStok. Fotos do fornecedor sao bloqueadas para exclusao pela tela interna. |
| `cor_log_ultimo` | Retorna o ultimo log de preco da cor do pedido. |
| `enviar_proposta` | Envia e-mail, publica o pedido, muda localizacao para `Fornecedor` e incrementa `Iteracao`. |
| `aprovar` | Aprova pedido publicado; se ainda nao ha foto do fornecedor, muda para `Aprovado Aguardando Foto Fornecedor`, envia e-mail e devolve ao fornecedor. |
| `recusar` | Recusa pedido publicado, exige motivo e devolve para `KidStok`. |

#### Estrutura Funcional do Pedido

O pedido e organizado nesta hierarquia:

```text
cp_compras
  -> cp_compras_itens
       -> cp_compras_itens_tamanhos
            -> cp_compras_itens_cores
       -> cp_compras_itens_rateios
```

O frontend apresenta os itens em accordions. Cada item contem tamanhos, cada tamanho contem cores, e o rateio percentual e aplicado por cor no item quando informado.

O formulario de compra usa layout em duas colunas em desktop:

- coluna principal com dados do pedido e itens;
- painel lateral `Resumo do pedido` com total de pecas, total/ativos/inativos de itens, tamanhos e cores, total financeiro e botoes de workflow;
- em telas menores o resumo vai para o topo do conteudo.

No resumo ficam `Salvar alteracoes`, `Imprimir PDF`, `Enviar Proposta`, `Enviar Fornecedor`, `Aprovar` e `Recusar`, exibidos conforme status, publicacao, localizacao, fotos e alteracoes pendentes.

A lista `cp_compras_lista` usa a mesma ordem de campos do dashboard em `Ultimos 10 pedidos`: Pedido, Data, CD, Empresa, Fornecedor, Status, Localizacao, Publicado, Valor e Acoes.

Regras de gravacao e validacao:

- CD, empresa, fornecedor e data do pedido sao obrigatorios;
- o frontend exige ao menos um item confirmado;
- uma referencia nao pode aparecer mais de uma vez no mesmo pedido;
- item ativo deve ter ao menos um tamanho ativo;
- tamanho ativo deve ter nome, quantidade total maior que zero e ao menos uma cor ativa;
- tamanho duplicado no mesmo item e bloqueado;
- cor duplicada no mesmo tamanho e bloqueada;
- percentual de rateio deve estar entre 0% e 100%;
- se algum percentual for informado, o total do rateio do tamanho deve fechar 100%;
- se houver rateio em mais de um tamanho do item, os tamanhos devem ter o mesmo conjunto de cores;
- o percentual de uma mesma cor deve ser igual em todos os tamanhos que participam do rateio;
- a soma dos percentuais por item deve fechar 100% quando houver rateio;
- a soma das quantidades das cores deve bater com `qtde_total` do tamanho;
- quantidades zeradas inativam cores automaticamente;
- tamanho sem cor ativa ou com quantidade total zero e inativado;
- item sem tamanho ativo e inativado;
- item ou tamanho inativo zera seus totais de quantidade e valor;
- somente itens/tamanhos/cores ativos entram nas validacoes de quantidade e rateio;
- o total do pedido e recalculado no servidor pela soma dos totais das cores ativas;
- registros existentes sao atualizados; registros removidos da hierarquia sao excluidos;
- datas de entrega vazias nos tamanhos sao gravadas como `NULL`, sem assumir a data do item nem a data do pedido.
- a quantidade de pecas exibida no item e no resumo e derivada da soma das cores ativas; quando um tamanho nao tem cores, usa a quantidade do tamanho.

#### Status Oficiais de Compras

`cp_compras.status_id` referencia `cp_compras_status.id`. O campo textual `Sts` ainda aparece em respostas e HTML para manter compatibilidade com o frontend, mas o codigo atual consulta e persiste por `status_id`.

| id | `descricao_compras` | `descricao_portal` | Uso |
| --- | --- | --- | --- |
| 0 | Aberto | Aberto | Pedido em edicao. |
| 1 | Aprovado Aguardando Foto Fornecedor | Aprovado Aguardando Foto Fornecedor | Pedido aprovado comercialmente, aguardando fotos do fornecedor. |
| 2 | Aprovado | Aprovado | Pedido aprovado. |
| 3 | Recusado | Recusado | Pedido recusado com motivo. |

O catalogo de status e garantido por `cp_ensure_status_catalog()`, que faz upsert dos IDs 0 a 3. Isso corrige textos divergentes nos IDs canonicos sem remover linhas extras.

Regras de status, localizacao e workflow:

- pedidos novos entram como `Aberto`, `Publicado = 0` e `Localizacao = KidStok`;
- pedido localizado em `Fornecedor` nao permite edicao, exclusao, aprovacao ou recusa pela tela interna;
- pedido `Aprovado` ou `Recusado` fica somente para visualizacao e impressao;
- pedido `Aprovado Aguardando Foto Fornecedor` nao permite edicao do pedido;
- se `Aprovado Aguardando Foto Fornecedor` estiver em `KidStok`, o formulario pode exibir `Enviar Fornecedor`;
- aprovacao exige pedido publicado;
- se a KidStok alterar preco, valor ou data de entrega em relacao ao pedido carregado, `Aprovar` e `Recusar` ficam bloqueados/ocultos; o caminho correto passa a ser `Enviar Proposta`;
- ao salvar alteracoes locais de preco, valor ou data de entrega, o pedido e marcado como `Publicado = 0` para exigir nova proposta ao fornecedor;
- aprovacao sem fotos do fornecedor envia e-mail e muda para `Aprovado Aguardando Foto Fornecedor`, `Localizacao = Fornecedor`, `Publicado = 1` e incrementa `Iteracao`;
- aprovacao de pedido aguardando foto exige fotos do fornecedor antes de mudar para `Aprovado`;
- aprovacao com fotos do fornecedor muda para `Aprovado` e `Localizacao = KidStok`;
- recusa exige pedido publicado e motivo;
- `enviar_proposta` usa `config_email`, `urls_allop` com modulo `apPF` e usuarios ativos do fornecedor em `pf_usuarios`/`pf_usuario_fornecedor`;
- o e-mail e enviado em texto puro e HTML pelo cliente SMTP proprio;
- localizacoes validas no fluxo atual sao `KidStok` e `Fornecedor`;
- a localizacao nao deve ser concatenada ao status.

#### Fotos

O banco de fotos e acessado por `db_fotos()`.

| Tabela | Origem | Uso na tela interna |
| --- | --- | --- |
| `cp_compras_fotos_ks` | KidStok | Listagem, upload e exclusao quando o pedido permite fotos KidStok. |
| `cp_compras_fotos` | Fornecedor | Listagem/visualizacao; upload e exclusao sao bloqueados pela regra interna. |

Regras atuais:

- fotos sao armazenadas em Base64;
- uploads aceitos precisam passar por `is_uploaded_file()` e `getimagesize()`;
- a listagem monta `data:image/*;base64,...` e detecta JPEG, PNG, GIF e WebP pelo prefixo Base64;
- as fotos sao relacionadas por pedido, referencia do fornecedor, fornecedor e sequencia;
- nao ha chave estrangeira entre o banco principal e o banco de fotos;
- a flag `cp_compras_itens.Foto` e sincronizada pela contagem de fotos KidStok;
- o formulario mostra indicadores separados para fotos KidStok e fotos Fornecedor;
- fotos do fornecedor sao consideradas para definir se um pedido aguardando foto pode avancar para `Aprovado`;
- o modal de fotos altera titulo, listagem e permissao conforme a origem (`kidstok` ou `fornecedor`);
- a aba Fotos do item usa dois paineis: `Fotos KidStok` com `Gerenciar fotos` e `Fotos do fornecedor` com `Ver fotos`;
- `Gerenciar fotos` abre modal com area de clique/arraste para upload KidStok, listagem e exclusao;
- `Ver fotos` abre o mesmo modal em modo de visualizacao para fotos do fornecedor;
- item sem foto usa `assets/img/SemFoto.png` como placeholder visual;
- a API abre transacoes no banco principal e no banco de fotos durante upload KidStok, mas nao ha atomicidade distribuida real entre conexoes.

#### PDF

`api/compras/cp_compras_pdf.php`:

- exige sessao por `require_login()`;
- usa Dompdf com fonte DejaVu Sans;
- gera A4 paisagem;
- nao permite recursos remotos (`isRemoteEnabled = false`);
- usa parser HTML5 do Dompdf;
- exibe dados do cabecalho, auditoria, status, localizacao, publicacao, iteracao, itens, tamanhos, cores, precos, markups e resumo de rateio;
- adiciona numeracao de paginas no rodape;
- abre o PDF no navegador com `Attachment = false`.

### 6.4 Dashboard

`dashboard.php` exibe:

- card de pedidos abertos;
- card de pedidos aprovados;
- card de pedidos aprovados aguardando foto do fornecedor;
- card de pedidos recusados;
- card de total geral;
- grafico de barras por status;
- donut financeiro;
- grid dos ultimos 10 pedidos.

Detalhes:

- os status usam os IDs 0, 1, 2 e 3 de `cp_compras_status`;
- os titulos dos cards vem de `descricao_compras`, com fallback em texto padrao;
- cada card mostra quantidade e valor total em reais;
- a grid mostra status, localizacao e publicacao separadamente;
- a grid usa botao de edicao apenas para pedido aberto e editavel;
- pedidos fechados, aguardando foto ou localizados em `Fornecedor` usam botao de visualizacao;
- quando consultas do dashboard falham, os indicadores caem para zero e a listagem fica vazia.

## 7. Autenticacao, Sessao, Menu e Permissoes

Sessao:

- a sessao guarda `id`, `nome`, `login` e `perfil_id`;
- paginas internas chamam `require_login()`;
- APIs internas normalmente chamam `api_require_login()`;
- login aceita senha com hash e senha em texto puro legado;
- novas senhas sao gravadas com `password_hash()`;
- logout limpa `$_SESSION`, remove o cookie da sessao quando aplicavel e chama `session_destroy()`.

Formato de resposta das APIs:

```json
{
  "success": true
}
```

Falhas usam `success: false` e normalmente incluem `message`. Os status HTTP usados incluem 401, 403, 404, 422 e 500.

Menu:

- `seg_menu` define grupos;
- `seg_aplicacoes` define nome, rota, menu e ordem;
- `seg_perfil_permissoes.visualizar = 1` define o que aparece no menu;
- `seg_usuarios_permissoes` existe, mas nao participa da montagem do menu atual;
- `Principal` e `Sair` nao vem do banco no layout atual;
- menus `Principal` e `Sair` sao filtrados em `menu_items()`;
- o link da logo abre `dashboard.php`;
- o link `Sair` e fixo no header.

IDs de menu previstos pelo seed:

| ID | Menu |
| --- | --- |
| 10 | Configuracoes |
| 20 | Produtos |
| 30 | Cadastros |
| 40 | Compras |
| 50 | Operacional |
| 60 | Gerencial |
| 90 | Seguranca |
| 98 | Ajuda |

## 8. Banco de Dados

### 8.1 Banco Principal

`config/database.php` aponta o sistema para o banco principal de desenvolvimento `allop_devel`. As credenciais existem no arquivo de configuracao, mas nao devem ser copiadas para novas documentacoes, commits ou mensagens.

`banco.sql` contem:

- 240 tabelas;
- 67 triggers;
- dump estrutural, sem dados.

Principais grupos de tabelas:

| Dominio | Tabelas principais |
| --- | --- |
| Seguranca | `seg_menu`, `seg_aplicacoes`, `seg_perfil`, `seg_perfil_permissoes`, `seg_usuarios`, `seg_usuarios_permissoes` |
| Compras | `cp_compras`, `cp_compras_status`, `cp_compras_emails`, `cp_compras_itens`, `cp_compras_itens_tamanhos`, `cp_compras_itens_cores`, `cp_compras_itens_rateios` |
| Logs de compras | `cp_compras_itens_log`, `cp_compras_itens_tamanhos_log`, `cp_compras_itens_cores_log` |
| Configuracoes | `empresas`, `empresas_cd`, `config_email`, `urls_allop`, `situacao` |
| Portal fornecedor | `pf_colecao`, `pf_usuarios`, `pf_usuarios_copy`, `pf_usuario_fornecedor` |
| Catalogo/ERP legado | tabelas `produtos*`, `KidStok`, `cfops`, `cests_ncm`, `st_*`, `compras*`, `nfe_*`, `romaneios_*`, `fechamento*`, `provisorios*`, `transportadoras*`, `veiculos*` e auxiliares |

Triggers relevantes para compras:

- `cp_compras_itens_after_update`;
- `cp_compras_itens_cores_after_update`;
- `cp_compras_itens_tamanhos_after_update`.

Essas triggers gravam snapshots em tabelas de log usando os dados antigos (`OLD`) e consultam `Iteracao`/`Localizacao` no pedido.

### 8.2 Banco de Fotos

`config/database.php` aponta o banco de fotos para `allop_devel_fotos`.

`banco_fotos.sql` contem duas tabelas:

- `cp_compras_fotos`;
- `cp_compras_fotos_ks`.

As tabelas tem estrutura equivalente para armazenar fotos em Base64, com campos de pedido, referencia do fornecedor, fornecedor, sequencia e foto.

## 9. Seed de Aplicacoes

`scripts/seed_aplicacoes.php`:

- garante o perfil `Administrador`;
- remove a aplicacao antiga `dashboard.php` do menu;
- remove menus vazios `Principal` e `Sair`;
- renomeia a grafia sem cedilha do menu de seguranca para a grafia acentuada quando aplicavel;
- cria ou atualiza menus canonicos;
- corrige rotas antigas de e-mail;
- cadastra aplicacoes existentes;
- concede todas as permissoes ao Administrador quando a permissao ainda nao existe;
- cria o usuario `admin` apenas se ele ainda nao existir;
- cria tabelas auxiliares com `CREATE TABLE IF NOT EXISTS`;
- cria ou ajusta estruturas ligadas a `config_email`, `urls_allop` e compras;
- recria triggers de log de compras com `DROP TRIGGER IF EXISTS` + `CREATE TRIGGER`;
- imprime `Seed executado com sucesso.`.

Aplicacoes registradas pelo seed:

- Usuarios;
- Perfis;
- Aplicacoes;
- Perfil x Aplicacoes;
- Usuario x Aplicacoes;
- Empresas CD;
- Empresas;
- E-mail;
- Pedidos de Compra.

O seed e parcialmente idempotente, mas executa DDL e altera dados de menu/permissoes. Deve ser usado com backup e consciencia do ambiente.

## 10. Padroes Para Novas Implementacoes

Cabecalho obrigatorio em aplicacoes:

```php
/*
    Autor: Claudio Barto
    Data : DD/MM/AAAA
*/
$aplicacao_nome = "nome_do_arquivo.php";
$aplicacao_descricao = "Descricao objetiva da aplicacao.";
```

Telas:

- criar telas dentro de `mod/<modulo>/`;
- usar sufixos `_lista.php` e `_form.php`;
- chamar `require_login()` antes de renderizar conteudo interno;
- usar `render_header()` e `render_footer()`;
- usar APIs PHP para acessar banco;
- nao acessar banco diretamente a partir de tela quando for operacao de CRUD;
- usar Select2 em filtros e relacionamentos pesquisaveis;
- usar `card-slim`, `table-custom`, `grid-filter` e `filter-inline`;
- colocar Voltar junto ao titulo e Salvar no rodape do formulario;
- bloquear o botao Salvar durante requisicoes;
- usar botoes com classes globais (`btn-new`, `btn-save`, `btn-sync`, `btn-edit`, `btn-view`, `btn-delete`, `btn-print`, `btn-photo`, `btn-filter`, `btn-back`);
- manter responsividade em celular, tablet e desktop;
- cadastrar novas telas no seed.

APIs:

- criar endpoints em `api/<modulo>/`;
- incluir `api/bootstrap.php`;
- exigir sessao com `api_require_login()` nas APIs internas;
- ler entrada por `request_data()`;
- responder por `api_response()`;
- usar prepared statements;
- validar dados tambem no servidor;
- usar transacao em operacoes compostas;
- evitar expor mensagens sensiveis de infraestrutura.

Frontend:

- manter Bootstrap, jQuery e Select2 locais;
- centralizar estilos em `assets/css/style.css`;
- centralizar comportamentos compartilhados em `assets/js/app.js`;
- preservar Poppins como fonte visual enquanto a dependencia externa existir;
- manter fundo `#f8f9fa`, cards brancos e laranja `#ff4500` como destaque;
- manter tabelas responsivas em formato de cards no mobile;
- evitar JavaScript inline extenso em telas novas.

Banco:

- confirmar nomes e tipos no schema real antes de programar;
- usar `db()` para dados principais;
- usar `db_fotos()` exclusivamente para fotos;
- nao documentar credenciais;
- evitar DDL em rotinas de aplicacao;
- atualizar `banco.sql` e `banco_fotos.sql` quando uma mudanca de schema for aprovada;
- preservar nomes legados quando a migracao nao fizer parte do escopo.

## 11. Componentes Visuais Internos

| Componente | Classes/funcoes | Uso |
| --- | --- | --- |
| Layout base | `.app-shell`, `.app-content`, `.page-heading` | Estrutura comum das telas. |
| Menu | `menu_items()`, `menu_icon()`, `.menu-main-link`, `.menu-svg` | Menu por perfil com icones SVG inline. |
| Cards | `.card-slim`, `.dashboard-tile`, `.dashboard-chart-card` | Formularios, dashboards e paineis. |
| Grids | `.table-custom`, `.grid-shell`, `.grid-filter`, `.filter-inline` | Listagens responsivas em linhas-card, com espacamento entre linhas e hover destacado. |
| Botoes | `.btn-new`, `.btn-save`, `.btn-sync`, `.btn-edit`, `.btn-view`, `.btn-delete`, `.btn-print`, `.btn-photo`, `.btn-manage-photos`, `.btn-filter`, `.btn-back` | Acoes padronizadas com icones por CSS. |
| Alertas | `appAlert()`, `appOkAlert()`, `appConfirm()` | Mensagens e confirmacao via Bootstrap Modal/Alert. |
| Salvamento | `setFormSaving()` | Bloqueia botao e mostra processamento. |
| Status | `.badge-status-*`, `.cp-localizacao-badge`, `.dashboard-grid-badge` | Badges de status, localizacao e publicacao. |
| Pedido | `.cp-pedido-status-hero`, `.cp-compra-layout`, `.cp-pedido-resumo`, `.cp-compra-item`, `.cp-compra-tamanho`, `.cp-compra-cor` | Status destacado, resumo lateral, workflow e hierarquia de compra. |
| Rateio | `#cp-rateio-modal`, `.cp-rateio-*` | Percentuais por cor e quantidades por tamanho. |
| Fotos | `#cp-fotos-modal`, `.cp-item-fotos-panels`, `.cp-foto-dropzone`, `.cp-fotos-grid`, `.cp-foto-card`, `.cp-foto-preview-img` | Paineis de fotos, upload, exclusao e preview de imagens. |
| Log de cor | `#cp-cor-log-modal`, `.cp-preco-alterado-*`, `.btn-price-log` | Comparacao de preco com ultimo log. |
| Login | `.login-page`, `.login-shell`, `.login-card`, `.login-showcase` | Tela de acesso com logos e alternancia de visibilidade da senha. |

## 12. Pontos de Atencao Conhecidos

1. **Permissao incompleta nas APIs:** o menu usa `visualizar` por perfil, mas as APIs nao validam permissoes especificas de inserir, editar, excluir, imprimir, exportar ou processar.
2. **Permissoes por usuario sem efeito no menu:** `seg_usuarios_permissoes` existe e possui telas, mas nao participa da montagem do menu.
3. **Dashboard sem filtro por permissoes:** os indicadores de compras ainda nao variam conforme permissoes do usuario.
4. **Troca de senha admin publica:** `api/seguranca/admin_senha.php` nao chama `api_require_login()`.
5. **Grafias legadas:** `seg_usuarios_permissoes` usa `edtiar` e `imprirmir` no codigo.
6. **Credenciais no codigo:** `config/database.php` contem constantes versionadas; o recomendado e migrar para variaveis de ambiente.
7. **Erros expostos:** varias APIs retornam `Throwable::getMessage()` diretamente ao cliente.
8. **CSRF ausente:** nao ha token CSRF nos formularios ou acoes mutaveis.
9. **Senha legada aceita:** o login aceita texto puro para compatibilidade.
10. **DDL no seed:** `seed_aplicacoes.php` cria tabelas auxiliares e recria triggers; isso deve ser executado com backup.
11. **Transacao entre bancos:** operacoes com fotos podem envolver banco principal e banco de fotos sem atomicidade distribuida real.
12. **Dependencias externas:** ViaCEP e Google Fonts sao dependencias externas atuais.
13. **`ibge` opcional em Empresas:** a API detecta a coluna; se ausente, ignora a persistencia.
14. **Referencias legadas ausentes no dump:** foram identificadas referencias para tabelas como `romaneios_tabela_preco`, `tbestados`, `tbgrupos`, `tbmarcas`, `tbmedidas` e `tbmodelos`, que nao aparecem como tabelas base no `banco.sql`.
15. **`pf_usuarios_copy`:** tabela presente no dump sem referencia no codigo atual.
16. **Status autocorrigidos por upsert:** `cp_ensure_status_catalog()` regrava os textos canonicos dos IDs 0 a 3 em `cp_compras_status`; alteracoes manuais nesses IDs podem ser sobrescritas.
17. **Encoding legado:** varios arquivos PHP e documentos legados ainda exibem acentos quebrados em strings ja versionadas; novos textos deste documento foram gravados em UTF-8/ASCII para reduzir novas quebras.
18. **Contrato de fotos do fornecedor:** a acao `fotos_upload` aceita `origem=fornecedor`, mas `cp_require_foto_mutavel()` bloqueia qualquer insercao ou exclusao em `cp_compras_fotos` pela tela interna.
19. **Workflow depende de snapshot no frontend:** o bloqueio de `Aprovar` e `Recusar` apos alteracoes locais de preco, valor ou entrega compara a grade atual com o estado carregado em `cpCompraWorkflowSnapshot`. Alteracoes feitas por fora da tela dependem do estado persistido e das regras da API.

## 13. Como Recriar o Projeto do Zero

Esta secao descreve o caminho minimo para reconstruir o Allop em um ambiente novo usando o codigo e os dumps atuais do repositorio. Ela complementa a documentacao de arquitetura; nao substitui a conferencia do codigo quando houver divergencia.

### 13.1 Requisitos do Ambiente

Ambiente esperado:

- servidor web com PHP habilitado, como Apache/IIS/Nginx com PHP-FPM;
- PHP com extensoes `pdo`, `pdo_mysql`, `mbstring`, `openssl`, `json`, `fileinfo` e `gd` quando houver geracao/manipulacao de imagem ou PDF;
- MySQL ou MariaDB compativel com o dump existente;
- Composer instalado para restaurar dependencias PHP;
- navegador com acesso aos assets locais do projeto.

O projeto pode rodar em subpasta, pois `config/app.php` calcula `BASE_URL` com base em `SCRIPT_NAME`. Mesmo assim, depois de publicar em uma nova pasta, conferir rotas de `api/`, `mod/` e assets.

### 13.2 Arquivos Necessarios

Para recriar o projeto, manter estes itens:

- codigo fonte da raiz, `api/`, `config/`, `includes/`, `mod/`, `assets/`, `scripts/` e `docs/`;
- `composer.json` e `composer.lock`;
- `banco.sql`;
- `banco_fotos.sql`;
- imagens em `assets/img/`, especialmente `SemFoto.png`;
- bibliotecas locais em `assets/vendor/`.

A pasta `vendor/` pode ser recriada com Composer quando `composer.json` e `composer.lock` estiverem presentes.

### 13.3 Passo a Passo

1. Copiar o projeto para a pasta servida pelo web server.
2. Rodar `composer install` na raiz do projeto para restaurar `vendor/`.
3. Criar o banco principal no MySQL/MariaDB.
4. Importar `banco.sql` no banco principal.
5. Criar o banco de fotos.
6. Importar `banco_fotos.sql` no banco de fotos.
7. Ajustar `config/database.php` com host, nome dos bancos, usuarios, senhas e charset do novo ambiente.
8. Acessar `index.php` pelo navegador e validar se a tela de login carrega com CSS, JS e imagens.
9. Executar `scripts/seed_aplicacoes.php` apenas apos backup ou em ambiente novo, para criar/atualizar menus, aplicacoes, permissoes, perfil Administrador e usuario administrador inicial.
10. Entrar como administrador e trocar a senha inicial imediatamente pela tela `alterar_senha_admin.php` ou por fluxo administrativo equivalente.
11. Conferir o menu do perfil Administrador e liberar permissoes dos demais perfis conforme necessario.
12. Testar dashboard, listagens principais, cadastro de empresas/CD, configuracao de e-mail e fluxo de pedido de compra.

### 13.4 Ordem Recomendada de Validacao Inicial

Depois da instalacao:

- abrir `login.php` e validar autenticacao;
- abrir `dashboard.php` e validar indicadores e `Ultimos 10 pedidos`;
- abrir `mod/seguranca/*_lista.php` para conferir menus, perfis e permissoes;
- abrir `mod/configuracoes/empresas/empresas_lista.php`;
- abrir `mod/configuracoes/empresas_cd/empresas_cd_lista.php`;
- abrir `mod/configuracoes/configuracoes_email/configuracoes_email_lista.php`;
- abrir `mod/compras/cp_compras_lista.php`;
- criar ou editar um pedido em `mod/compras/cp_compras_form.php`;
- testar upload/visualizacao de fotos usando o banco de fotos;
- gerar PDF por `api/compras/cp_compras_pdf.php`;
- testar envio de e-mail apenas com SMTP configurado.

### 13.5 Pontos que Nao Devem Ser Inferidos

Ao recriar o sistema, nao inventar:

- credenciais de banco ou SMTP;
- URL publica definitiva;
- dados comerciais reais, fornecedores, empresas ou produtos;
- permissoes especificas de perfis diferentes de Administrador;
- alteracoes de schema fora dos dumps `banco.sql` e `banco_fotos.sql`.

Se o ambiente novo precisar de dados reais, eles devem vir de importacao autorizada ou cadastro manual, nao da documentacao.

## 14. Validacao Antes de Entregar Alteracoes

Para cada PHP alterado:

```bash
php -l caminho/do/arquivo.php
```

Checklist:

- conferir rotas relativas quando a aplicacao roda em subpasta;
- testar sessao expirada e JSON de erro;
- testar lista, filtro, inclusao, edicao e exclusao;
- testar layout em celular, tablet e desktop;
- validar regras no frontend e na API;
- conferir perfil Administrador e menu apos mudancas no seed;
- testar rollback de operacoes compostas;
- conferir banco principal e banco de fotos quando houver fotos;
- revisar console do navegador e log do PHP;
- nao sobrescrever mudancas fora do escopo.

## 15. Regra de Manutencao Deste Documento

Atualizar este arquivo sempre que houver:

- novo modulo, tela ou endpoint;
- alteracao de menu ou permissao;
- mudanca no workflow de compras;
- nova tabela, coluna, trigger ou conexao;
- atualizacao de biblioteca;
- mudanca relevante no padrao visual;
- correcao de ponto de atencao conhecido.

A documentacao deve sempre descrever o comportamento efetivamente presente no codigo. Requisitos futuros devem ficar marcados como planejados, nao como implementados.
