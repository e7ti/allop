# ALLOP - Arquitetura, Regras e Padroes do Sistema

**Projeto correto para manutencao:** `D:\E7TI\PHP\allop`  
**Atencao:** CERTIFIQUE-SE QUE VOCE ESTA NO WORKSPACE ALLOP.

**Documento-base:** 01/06/2026  
**Ultima revisao documental:** 12/11/2026
**Ultima revisao conferida do codigo:** 12/11/2026
**Ultima revisao conferida do `banco.sql`:** 03/11/2026
**Ultima revisao conferida do `banco_fotos.sql`:** 03/11/2026
**Escopo desta revisao (12/11/2026):** leitura estatica da estrutura, inicializacao, autenticacao, menu, APIs, telas e scripts, com conferencia dos contratos de e-mail e de Cadastros > Produtos. Antes do commit, a sintaxe PHP/JavaScript foi validada e a suite isolada passou com 216 verificacoes HTTP em fixture SQLite. Nao houve conexao aos bancos configurados, envio SMTP, execucao de seeds, ajuste de triggers ou nova execucao dos testes de navegador. As datas de conferencia dos dumps acima foram mantidas como registro da revisao anterior.

**Verificacoes historicas:** em 04/11/2026, foram registradas 215 verificacoes HTTP em copia temporaria com SQLite e conferencia do cadastro de Produtos com accordion e cinco abas no Chrome local, em desktop e celular; Valores foi conferido em 03/11/2026. As capturas e verificacoes visuais nao foram refeitas em 12/11/2026. Os testes isolados nao comprovam integracao ou concorrencia MySQL; a conferencia visual especifica dos quatro accordions de associacoes permanece pendente. A integracao de 30/10/2026 esta registrada em `docs/conversao_produtos.md`.

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
- menu dinamico por perfil, com submenu de Produtos;
- modulo Cadastros > Produtos com 28 opcoes, grades, consolidacao, fotos, importacao e lotes de precos;
- dashboard de compras;
- modulo de compras com pedido, itens, tamanhos, cores, rateio, fotos, e-mail, logs, workflow, pre-cadastro e de/para de cores.

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
| `sx.php` | Tela externa, com sessao propria `allop_sx`, para pesquisar usuarios e alterar senhas no banco principal. |
| `config/` | Configuracao geral e conexoes PDO. |
| `includes/` | Autenticacao, permissoes, layout e envio SMTP. |
| `mod/` | Telas dos modulos do sistema. |
| `api/` | Endpoints JSON usados pelas telas. |
| `assets/css/` | CSS global do sistema. |
| `assets/js/` | JavaScript global, CRUD generico e logica de compras. |
| `assets/vendor/` | Bootstrap, jQuery e Select2 locais. |
| `assets/img/` | Logos e imagens institucionais, incluindo `SemFoto.png` como placeholder atual de item sem foto. |
| `scripts/` | Rotinas administrativas, incluindo `seed_aplicacoes.php`. |
| `tests/` | Teste HTTP isolado de Produtos com fixture SQLite e testes de interface de Valores e do cadastro com accordion, usando Node.js e Chrome local. |
| `docs/` | Documentacao e registros auxiliares. |
| `banco.sql` | Dump estrutural do banco principal. |
| `banco_fotos.sql` | Dump estrutural do banco de fotos. |
| `vendor/` | Dependencias do Composer. Nao usar como referencia de regra do projeto. |

Arquivos Markdown/documentacao proprios:

- `docs/plaintext.md`: este documento, fonte principal de manutencao;
- `docs/conversao_produtos.md`: registro da integracao de Produtos de 30/10/2026, regras, ativacao e verificacoes historicas;
- `docs/plaintext.txt`: documento legado de padroes;
- `docs/def.txt`: briefing inicial legado.

## 4. Arquivos Compartilhados Centrais

| Arquivo | Funcao |
| --- | --- |
| `config/app.php` | Define `APP_NAME`, `APP_DATE`, `BASE_PATH`, `BASE_URL`, `app_url()` e `h()`. |
| `config/database.php` | Configuracao ativa; define `db()` e `db_fotos()` com PDO, erro por excecao e prepared statements nativos. |
| `config/database devel.php` / `config/database producao.php` | Copias locais de configuracao; nao sao incluidas pelo fluxo normal nem selecionadas automaticamente. Permanecem fora do commit. |
| `includes/auth.php` | Inicializa sessao e fornece `current_user()`, `require_login()`, `login_user()` e `logout_user()`. |
| `includes/permissions.php` | Monta o menu com base em `seg_perfil_permissoes.visualizar` e agrupa as rotas de cadastros de produtos em submenu. |
| `includes/layout.php` | Renderiza header, menu, area de conteudo, footer e assets locais. |
| `includes/smtp_mailer.php` | Cliente SMTP por socket com SSL implicito, STARTTLS e autenticacao opcional. |
| `includes/pre_cadastro_tributos.php` | Leitura e mapeamento de `produtos_prm` para os tributos do pre-cadastro, com preservacao de campos ja preenchidos. |
| `api/bootstrap.php` | Inicializacao comum das APIs, `api_response()`, `request_data()` e `api_require_login()`. |
| `sx.php` | Fluxo publico de troca de senha por usuario, com token CSRF proprio e Select2 remoto interno ao arquivo. |
| `assets/js/app.js` | CRUD generico, Select2, alertas, confirmacao, sincronizacao de grids, ViaCEP, empresas, e-mail e fluxo completo de compras. |
| `assets/css/style.css` | Tema global, responsividade, botoes com icones, grids, dashboard, login e componentes de compras. |
| `scripts/seed_aplicacoes.php` | Seed de menus, aplicacoes, perfil Administrador, permissoes, usuario inicial e estruturas auxiliares. |
| `config/produtos.php` | Catalogo das 28 opcoes de Produtos, rotas, tabelas, chaves, campos e capacidades de manutencao. |
| `config/produtos_schema.json` | Metadados estaticos de campos e relacionamentos usados pelo modulo de Produtos. |
| `includes/produtos.php` | Permissoes por rota/perfil, token CSRF, validacao e filtros de Produtos. |
| `includes/produtos_workflow.php` | Regras de cabecalho/grade, consolidacao, importacao, fotos, ordenacao e precos em lote. |
| `includes/grupo_categoria.php` | Leitura e versao de vinculos e verificacao de dependencias por chave estrangeira, compartilhadas pelas quatro associacoes de Produtos. |
| `assets/js/grupo_categoria.js` | Grid compartilhado com accordion, selecao de itens, filtros e salvamento por registro principal. |
| `api/cadastros/produtos_associacoes.php` | API comum das associacoes, com catalogo estatico de tabelas/chaves e permissoes por aplicacao. |
| `includes/produtos_valores.php` | Filtros, versao dos itens e validacao de valores monetarios da tela de Valores. |
| `api/cadastros/produtos_valores.php` | Listagem por master, carga de grade filtrada e gravacao transacional dos valores alterados. |
| `mod/cadastros/produtos/valores_grid.php` / `assets/js/produtos_valores.js` | Tela de Valores com filtros, accordion, edicao direta, previa em lote e salvamento por produto. |
| `mod/cadastros/produtos/produtos_accordion.php` / `assets/js/produtos_accordion.js` | Grid do cadastro principal com editor no accordion e abas de dados, tributos, referencias, fotos e historico de precos. |
| `assets/js/decimal_input.js` | Digitacao decimal da direita para a esquerda em campos opt-in de Produtos, com formatacao brasileira e conversao para o valor enviado a API. |
| `scripts/seed_produtos.php` | Registro transacional e especifico do submenu de Produtos e permissoes iniciais do Administrador. |
| `scripts/processar_precos_produtos.php` | Executor CLI para aplicacao e retorno de lotes vencidos. |
| `scripts/ajustar_triggers_fotos_produtos.php` | Ajuste especifico de triggers de fotos em `allop_devel`, com copia das definicoes anteriores. |

## 5. Bibliotecas e Recursos

| Componente | Local | Uso |
| --- | --- | --- |
| PHP puro | arquivos `.php` | Renderizacao server-side, APIs JSON, sessao, regras e PDF. |
| PDO MySQL | `config/database.php` | Acesso ao banco principal e ao banco de fotos. |
| Bootstrap 5.3.6 | `assets/vendor/bootstrap/` | Layout, grid, navbar, dropdowns, botoes, cards, modais e utilitarios. |
| jQuery 3.7.1 | `assets/vendor/jquery/jquery.min.js` | AJAX, manipulacao de DOM e integracao com Select2. |
| Select2 4.1.0-rc.0 | `assets/vendor/select2/` | Campos pesquisaveis locais e remotos. |
| Dompdf 3.1.5 | `composer.lock`, `vendor/` | PDF do pedido de compra; `composer.json` permite a faixa `^3.1`. |
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
| `mod/seguranca/cp_compras_emails_lista.php` / `cp_compras_emails_form.php` | `api/seguranca/crud.php?entity=cp_compras_emails` |

APIs auxiliares:

| API | Acoes/comportamento |
| --- | --- |
| `api/seguranca/auth.php` | Valida login ativo, aceita senha com `password_verify()` e texto puro legado, cria sessao e retorna redirect. |
| `api/seguranca/options.php` | Fornece opcoes Select2 para perfis, aplicacoes, menus, usuarios, CDs, empresas, contas de e-mail, cores KidStok e cores de colecao pendentes de de/para. |
| `api/seguranca/admin_senha.php` | Altera a senha do login `admin` com `password_hash()`. Nao exige sessao atualmente. |
| `api/seguranca/crud.php` | CRUD generico para entidades de seguranca. |
| `api/seguranca/perfil_aplicacoes.php` | Lista perfis, lista permissoes por perfil, salva permissoes em lote e exclui permissoes de um perfil. |

Telas raiz de senha:

- `alterar_senha_admin.php`: formulario publico para alterar somente a senha do login `admin`, chamando `api/seguranca/admin_senha.php`;
- `sx.php`: formulario publico com sessao propria `allop_sx`, token por formulario, pesquisa remota de usuarios em `seg_usuarios` e gravacao de senha com `password_hash()` para qualquer usuario selecionado.

Entidades aceitas pelo CRUD generico:

- `usuarios`;
- `perfis`;
- `aplicacoes`;
- `perfil_aplicacoes`;
- `usuarios_permissoes`;
- `cp_compras_emails`;
- `cp_depara_cor`;
- `menus`.

Observacoes de usuarios:

- o formulario usa `nome`, `login`, `senha`, `perfil_id`, `ativo` e `chequesapp`;
- `seg_usuarios.chequesapp` registra a habilitacao para o aplicativo de cheques (`0` nao, `1` sim), mas nao altera o menu ou a sessao do Allop;
- o CRUD converte `ativo` e `chequesapp` para `0` ou `1`;
- na edicao, senha vazia preserva a senha existente; senha preenchida e gravada com `password_hash()`;
- o formulario nao exige senha na inclusao e a API nao aplica tamanho minimo nessa entidade; as validacoes das telas publicas de troca de senha sao separadas.

E-mails de compras:

- usa o CRUD generico com a entidade `cp_compras_emails`;
- persiste `config_email_id`, `Nome`, `email` e `status` na tabela `cp_compras_emails`;
- a listagem mostra a conta vinculada de `config_email`, nome, e-mail e status textual;
- o campo `config_email_id` usa Select2 remoto do tipo `config_email`, fornecido por `api/seguranca/options.php`;
- os arquivos ficam em `mod/seguranca`, mas o seed cadastra a aplicacao no menu `Configuracoes`.

De/para de cores:

- usa o CRUD generico com a entidade `cp_depara_cor`;
- persiste `cor_fornecedor` e `codigo_ks` na tabela `cp_depara_cor`;
- a chave do registro e a propria `cor_fornecedor`, nao um `id` numerico;
- a listagem pesquisa por cor do fornecedor, codigo KidStok ou nome da cor em `produtos_cor`;
- o formulario em lote carrega ate 500 cores distintas de `pf_colecao.cor_produto`, mostra quantidade de itens por cor e permite vincular cada cor a `produtos_cor`;
- o Select2 `pf_colecao_cores` retorna somente cores de colecao ainda nao mapeadas;
- o Select2 `produtos_cor` retorna `Codigo - Nome`;
- os arquivos ficam em `mod/compras`, mas a API usada e `api/seguranca/crud.php`.

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

#### Configuracoes de e-mail

- acoes `list`, `get`, `save` e `delete`;
- persiste na tabela `config_email`;
- usa `cd_id`, `empresa_id`, `NomeConta`, `Habilitado`, `Servidor`, `Porta`, `ModoAutenticado`, `ModoSSL`, `Email`, `Senha` e `Status`;
- lista ate 200 registros e filtra por conta, servidor, e-mail ou status;
- e usada pelo envio de propostas de compra.

Contrato da API `api/configuracoes/configuracoes_email.php`:

| Acao | Entrada e retorno |
| --- | --- |
| `list` | `q` opcional; pesquisa parcial em `NomeConta`, `Servidor`, `Email` e `Status`, ordena por `Codigo` decrescente e retorna `data` com ate 200 registros, sem paginacao. |
| `get` | `id` numerico; retorna `data` com `Codigo AS id`, os campos da conta e os textos `cd_id_text`/`empresa_id_text` para os seletores. A empresa usa Fantasia, com fallback para Nome. Registro ausente nao recebe 404 explicito. |
| `save` | `id > 0` atualiza; sem ID positivo, insere e devolve o ID gerado. Somente campos do catalogo `$columns` entram no SQL. Payload sem campos permitidos retorna 422. |
| `delete` | Exclui por `Codigo = id` e retorna mensagem de sucesso; nao verifica explicitamente se uma linha foi removida. Restricoes do banco podem impedir a exclusao. |

`Habilitado` e convertido para inteiro booleano; o formulario envia `0` ou `1`. `ModoAutenticado` e `ModoSSL` usam `S`/`N`, e `Status` usa `Ativo`/`Inativo`. Os outros campos seguem para o PDO sem validacao de dominio especifica nessa API. Obrigatoriedade, tamanho e formato de e-mail sao exigidos principalmente pelo HTML do formulario; nao equivalem a validacao no servidor.

O formulario usa Select2 remoto para CD e empresa via `api/seguranca/options.php`, tipos `empresas_cd` e `empresas`. A listagem tambem usa Select2, mas envia o texto da conta selecionada como `q`; a selecao nao restringe pelo ID exato. Salvar mantem o formulario aberto e atualiza seu ID apos a inclusao.

O endpoint exige sessao, mas nao confere permissoes por acao, token CSRF ou metodo HTTP. A tela envia POST em `save`/`delete`, porem isso nao e imposto pelo backend. `action` e lida de GET ou POST, com padrao `list`; ao enviar JSON, informar a acao na URL.

`Senha` e armazenada como recebida e devolvida por `list` e `get`; o formulario de edicao a preenche novamente. Nao existe a regra de preservar a senha quando o campo e enviado vazio: omitir `Senha` preserva o valor no UPDATE, enviar `Senha` vazia o substitui. Esse comportamento difere do cadastro de usuarios.

#### Escolha da conta e transporte SMTP

O envio da proposta em `api/compras/cp_compras.php` seleciona a primeira conta por `Codigo` crescente com o mesmo `cd_id` e `empresa_id` do pedido, `Habilitado = 1` e `Status = 'Ativo'`. Se houver varias contas elegiveis, usa a de menor codigo; sem conta elegivel, interrompe o envio. Os destinatarios vem dos usuarios ativos do fornecedor em `pf_usuarios`/`pf_usuario_fornecedor`; o cadastro `cp_compras_emails` nao substitui essa consulta.

`includes/smtp_mailer.php` implementa o transporte por socket, sem biblioteca adicional:

- `ModoSSL = S` e porta 465: SSL implicito; em outra porta, usa STARTTLS e repete EHLO;
- `ModoSSL = N`: conexao TCP sem ativar TLS;
- `ModoAutenticado = S`: AUTH LOGIN usando `Email` e `Senha`;
- verifica certificado e nome do servidor nas conexoes TLS e configura timeout de 20 segundos para conexao e leitura;
- valida servidor, porta positiva e e-mail remetente no momento do envio; ignora destinatarios invalidos e elimina duplicados pelo endereco;
- usa `Email` como remetente e `NomeConta` como nome de exibicao, com fallback para Kidstok quando a chave nao e informada;
- aceita texto puro e HTML como alternativas MIME em UTF-8/Base64. O envio da proposta fornece os dois formatos.

Salvar uma conta nao testa conexao ou autenticacao SMTP. A API de configuracoes nao possui acao de envio de teste.

### 6.3 Compras

| Arquivo | Responsabilidade |
| --- | --- |
| `mod/compras/cp_compras_lista.php` | Pesquisa e lista pedidos de compra. |
| `mod/compras/cp_compras_form.php` | Cabecalho, itens, tamanhos, cores, rateio, fotos, logs e workflow. |
| `mod/compras/pre_cadastro_produtos_lista.php` | Lista pre-cadastros, mostra status de consolidacao/compra e expoe acoes de novo, editar, consolidar, gerar compra e historico. |
| `mod/compras/pre_cadastro_produtos_form.php` | Seleciona pedido de compra, gera a pre-visualizacao do pre-cadastro, permite completar dados obrigatorios e editar pre-cadastros ainda nao consolidados. |
| `mod/compras/cp_depara_cor_lista.php` | Lista mapeamentos entre cores do fornecedor e cores KidStok. |
| `mod/compras/cp_depara_cor_form.php` | Carrega cores de `pf_colecao`, mostra pendencias e salva mapeamentos em lote ou por linha. |
| `api/compras/cp_compras.php` | API principal de compras. |
| `api/compras/cp_compras_pdf.php` | Gera PDF completo do pedido em A4 paisagem. |
| `api/compras/pre_cadastro_produtos.php` | API para lista, preview, Select2, gravacao, edicao, consolidacao e historico do pre-cadastro de produtos. |

#### Acoes da API de Compras

| Acao | Comportamento |
| --- | --- |
| `options` | Pesquisa CDs, empresas, fornecedores, referencias e categorias para Select2. |
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
| `enviar_proposta` | Envia e-mail, publica o pedido, muda localizacao para `Fornecedor` e incrementa `Iteracao`. Tambem e a acao usada pelo botao `Enviar Fornecedor` quando o pedido esta em `Aprovado Aguardando Foto Fornecedor` e localizado em `KidStok`. |
| `aprovar` | Aprova pedido publicado; se ainda nao ha foto do fornecedor, muda para `Aprovado Aguardando Foto Fornecedor`, envia e-mail e devolve ao fornecedor. |
| `recusar` | Recusa pedido publicado, exige motivo e devolve para `KidStok`. |

#### Pre Cadastro Produtos

`mod/compras/pre_cadastro_produtos_lista.php` usa a rota cadastrada no menu Compras pelo seed. A tela lista os pre-cadastros ja gerados, exibe fornecedor e categoria com codigo e nome, destaca o status de consolidacao e disponibiliza as acoes conforme o estado do registro.

`mod/compras/pre_cadastro_produtos_form.php` e a tela de inclusao/edicao. Ela permite selecionar um pedido aprovado via Select2, carregar a hierarquia ativa de compras e montar os dados que serao gravados em `pre_cadastro`, `pre_cadastro_item` e `pre_cadastro_item_pro`.

Regras atuais:

- somente pedidos com `status_id = 2` (`Aprovado`) e ainda nao vinculados a `pre_cadastro.cp_compras_id` entram na pesquisa para novo pre-cadastro;
- `pre_cadastro` agrupa por pedido, categoria do item e data de entrega efetiva do tamanho ou do item;
- campos vindos do pedido e dos itens de compra sao preenchidos automaticamente quando existem;
- a colecao pode ser carregada de `pf_colecao` usando o SKU e o fornecedor;
- a descricao do item e ajustada em `descricao` com ate 50 caracteres e `descricao_complementar` com o restante usado pela tela;
- `r3` inicia em branco em novos registros, recebe foco ao clicar no item e deve ser informado pelo usuario antes de gravar;
- `r3` aceita apenas 4 numeros;
- `referencia_master` e `referencia` sao calculadas na tela a partir de `r1`, `r2`, `r3`, tamanho e cor;
- `Grupo` usa pesquisa distinta e `Grupo/Categoria` e filtrado pelo grupo selecionado;
- `Composicao` e `Caracteristica` usam o codigo de `Grupo/Categoria` para buscar opcoes em `produtos_categoria_composicao` e `produtos_categoria_caracteristicas`;
- quando a tabela `cp_depara_cor` existe e esta preenchida, a API usa o de/para entre cor do fornecedor e `produtos_cor.Codigo` para sugerir a cor KidStok;
- tamanho e cor tambem podem ser selecionados por Select2 a partir de `produtos_tamanho` e `produtos_cor`;
- campos sem origem em compras e campos com relacionamento usam Select2 remoto na propria API;
- os campos `setor_laranja` e `preco_cheio` usam toggles Sim/Nao por item, tamanho ou cor;
- quando `preco_cheio` e Sim, o Atacado acompanha o Varejo; o valor anterior do Atacado fica preservado para restauracao ao voltar para Nao;
- o item possui a opcao `Somar tamanho/cor duplicado`, marcada por padrao na geracao e na reabertura. E uma opcao de processamento, sem coluna propria persistida; desmarca-la vale para o envio atual. A tela e a API usam `S` quando a propriedade esta ausente, respeitando `N` explicito. Quando marcada, juntam referencias completas repetidas no grupo antes de validar/gravar, somam as quantidades e usam o maior preco entre as linhas agrupadas;
- campos tributarios obrigatorios incluem `cfop`, `cfop_propria`, `cst_icms`, `cst_pis`, `cst_cofins` e `cst_ipi`;
- ao gerar dados, a aba Tributos recebe os padroes do primeiro registro de `produtos_prm` por `Codigo` crescente: `CFOP`, `Origem`, CSTs e aliquotas de ICMS/PIS/COFINS/IPI; `ReducaoBaseICMS` preenche `reducao_icms`. Os seletores recebem codigo e descricao dos dominios, preservando `0` e zeros iniciais. Ao reabrir um pre-cadastro nao consolidado, apenas valores ausentes, nulos ou vazios recebem os padroes; valores salvos, inclusive aliquota zero, sao mantidos. Consolidados conservam os dados salvos. `CFOP propria` nao possui coluna equivalente em `produtos_prm` e continua manual; o NCM continua vindo do pedido. Sem parametros, a geracao avisa e mantem o preenchimento manual, sem assumir CFOP fixo;
- a gravacao valida campos obrigatorios, pedido aprovado, categoria, R2, R3, tamanho, cor, NCM, duplicidade de referencia e existencia de `referencia_master` em `produtos_cab` antes de inserir ou alterar;
- `estilo` e `origem` sao persistidos quando informados na tela;
- a gravacao usa transacao unica no banco principal e faz rollback em erro.
- a edicao abre os itens recolhidos e nao permite salvar quando `pre_cadastro.consolidado = 1`;
- apos consolidar, o pre-cadastro fica bloqueado para edicao.

Cada item tem uma aba **Imagens / IA**, implementada em `assets/js/pre_cadastro_fotos.js`. Ao abrir, consulta as acoes existentes `fotos_fornecedor_list` e `fotos_list` de `api/compras/cp_compras.php`, com pedido, referencia do fornecedor e fornecedor do grupo. Exibe as duas origens, permite selecionar uma imagem por item e amplia-la em modal. Atualizar imagens preserva a selecao enquanto a foto existir e nao altera os dados digitados. Uma falha de origem nao oculta as fotos da outra. As imagens sao carregadas sob demanda e a selecao fica apenas na tela, sem salvar Base64 no pre-cadastro. A integracao com o servico de IA e o contrato do JSON ainda dependem de definicao; esta aba ainda nao envia imagens a um provedor.

Acoes de `api/compras/pre_cadastro_produtos.php`:

| Acao | Comportamento |
| --- | --- |
| `options` | Pesquisa opcoes remotas de pedido, fornecedor, categoria, grupo, composicao, caracteristica, genero, estilo, origem, tributacao, tamanho, cor e demais relacionamentos da tela. |
| `preview` | Carrega os dados do pedido aprovado e monta a estrutura inicial de pre-cadastro. |
| `get` | Carrega um pre-cadastro existente com cabecalho, itens, tamanhos, cores e status de consolidacao. |
| `save` | Insere `pre_cadastro`, `pre_cadastro_item` e `pre_cadastro_item_pro`. |
| `update` | Atualiza um pre-cadastro ainda nao consolidado, recriando os filhos dentro da transacao. |
| `consolidate` | Gera `produtos_cab` a partir de `pre_cadastro_item`, gera `produtos_cab_grade` a partir de `pre_cadastro_item_pro` usando campos do item, grava `Consolidado = 'N'` nos produtos gerados e marca `pre_cadastro.consolidado = 1`. |
| `generate_purchase` | Gera pedidos na tabela `compras` e itens em `compras_itens` a partir de pre-cadastro consolidado, depois move o pre-cadastro para historico. |
| `history` | Move o registro para `pre_cadastro_hst`, `pre_cadastro_item_hst` e `pre_cadastro_item_pro_hst`, criando ou alinhando colunas historicas antes da copia. A tela oferece a acao apenas para consolidados, mas a API nao valida esse estado. |

A listagem consulta o banco diretamente em `mod/compras/pre_cadastro_produtos_lista.php`, carrega ate 200 registros por ID decrescente e nao possui acao `list` na API de pre-cadastro. As acoes de processamento usam a API.

Regras da listagem:

- `consolidado = 0` aparece como `Nao consolidado` em cor de alerta e exibe `Consolidar` e `Editar`;
- `consolidado = 1` aparece como `Consolidado` em verde e nao permite edicao;
- o botao `Gerar compra` aparece apenas quando `consolidado = 1` e `compra = 0`;
- o botao `Historico` aparece apenas quando `consolidado = 1` e possui tooltip `Move pre cadastro para historico`;
- ao gerar compra, cada registro de `pre_cadastro_item` gera um pedido novo em `compras`;
- cada registro de `pre_cadastro_item_pro` do item gera uma linha em `compras_itens`;
- a consolidacao grava em `produtos_cab` e `produtos_cab_grade` com `Consolidado = 'N'`; para gerar compra, a referencia tambem precisa existir em `produtos.Distribuidora`. A acao de consolidacao desta API nao insere diretamente em `produtos`;
- `pre_cadastro_item_pro.referencia` e validada contra `produtos.Distribuidora`;
- o numero de cada novo pedido e calculado por `MAX(Pedido) + 1` dentro do CD;
- `compras_itens.Produto` recebe o `produtos.Codigo` localizado pela `Distribuidora`, para preservar a chave estrangeira;
- `compras_itens.Distribuidora` recebe a referencia completa de `pre_cadastro_item_pro.referencia`;
- `pre_cadastro_item.compra_nro` e `pre_cadastro_item_pro.compra_nro` guardam o numero do pedido gerado;
- no final do processo, `pre_cadastro.compra` e marcado como `1` e o cabecalho, itens e grades sao copiados para `pre_cadastro_hst`, `pre_cadastro_item_hst` e `pre_cadastro_item_pro_hst`;
- apos copiar para historico, os registros originais sao removidos de `pre_cadastro_item_pro`, `pre_cadastro_item` e `pre_cadastro`, por isso deixam de aparecer na listagem ativa;
- a geracao roda em transacao e bloqueia pre-cadastro nao consolidado, compra ja gerada, itens/grades sem quantidade ou referencias nao cadastradas em `produtos.Distribuidora`.

#### De/Para de Cores

`mod/compras/cp_depara_cor_lista.php` usa a entidade `cp_depara_cor` do CRUD generico para listar, filtrar, editar e excluir mapeamentos. A listagem exibe a cor do fornecedor e a cor KidStok no formato `codigo - nome`.

`mod/compras/cp_depara_cor_form.php` e uma tela operacional em lote. Ela consulta cores distintas de `pf_colecao.cor_produto`, cruza com `cp_depara_cor` e `produtos_cor`, mostra o total de cores e pendencias, e permite salvar todas as linhas selecionadas ou uma linha por vez.

Regras atuais:

- `cor_fornecedor` e chave primaria em `cp_depara_cor`;
- `codigo_ks` referencia `produtos_cor.Codigo`;
- cores ja mapeadas aparecem com badge `Mapeada`;
- cores sem `codigo_ks` aparecem como `Pendente`;
- a tela em lote usa Select2 remoto para escolher a cor KidStok;
- o mapeamento e usado como sugestao automatica no pre-cadastro de produtos;
- sem mapeamento, o usuario precisa completar a cor KidStok manualmente no pre-cadastro.

#### Estrutura Funcional do Pedido

O pedido e organizado nesta hierarquia:

```text
cp_compras
  -> cp_compras_itens
       -> cp_compras_itens_tamanhos
            -> cp_compras_itens_cores
       -> cp_compras_itens_rateios
```

O frontend apresenta os itens em accordions. Cada item contem tamanhos, cada tamanho contem cores, e o rateio percentual e aplicado por cor no item quando informado. Ao focar a quantidade total de um tamanho, o bloco de cores do tamanho e expandido para facilitar a edicao da grade.

Na grade de cores, os campos Quantidade, Preco proposto, Franqueado e Loja podem ser editados quando o pedido esta editavel. A edicao em massa do item permite aplicar Quantidade total, Preco proposto, Franqueado e Loja aos tamanhos marcados como Destino; depois da aplicacao, os destinos sao desmarcados e os campos da edicao em massa sao limpos.

O formulario de compra usa layout em duas colunas em desktop:

- coluna principal com dados do pedido e itens;
- painel lateral `Resumo do pedido` com total de pecas, total/ativos/inativos de itens, tamanhos e cores, total financeiro e botoes de workflow;
- em telas menores o resumo vai para o topo do conteudo.

No resumo ficam `Salvar alteracoes`, `Imprimir PDF`, `Enviar Proposta`, `Enviar Fornecedor`, `Aprovar` e `Recusar`, exibidos conforme status, publicacao, localizacao, fotos e alteracoes pendentes.

No cabecalho do `cp_compras_form`, a linha de datas exibe `Criacao` (`Inclusao`), `Publicacao` (`DataPedido`), `Envio Fornecedor` (`DataHoraEnvioFornecedor`) e `Resposta Fornecedor` (`DataHoraRespostaFornecedor`).

A lista `cp_compras_lista` exibe: Pedido, Criacao, Publicacao, CD, Empresa, Fornecedor, Status, Localizacao, Publicado, Envio Fornecedor, Resposta Fornecedor, Valor e Acoes.

Regras de gravacao e validacao:

- CD, empresa, fornecedor e data do pedido sao obrigatorios;
- em `cp_compras`, `DataPedido` representa a data de publicacao do pedido;
- no formulario interno, a data de publicacao nao e editavel; em novo pedido, inicia com a data atual;
- em `cp_compras`, `Inclusao` representa a data de criacao/gravacao inicial do pedido;
- em `cp_compras`, `DataHoraEnvioFornecedor` representa a data e hora em que o pedido foi enviado ao fornecedor;
- em `cp_compras`, `DataHoraRespostaFornecedor` representa a data e hora da resposta do fornecedor;
- a categoria do pedido pode ser informada no cabecalho por Select2, pesquisando `produtos_categorias` em ordem alfabetica por `TipoProduto`;
- a categoria pode ficar em branco enquanto o pedido estiver em edicao;
- a categoria pode ser alterada quando o pedido estiver editavel na KidStok;
- envio de proposta ao fornecedor exige categoria informada;
- o frontend exige ao menos um item confirmado;
- uma referencia nao pode aparecer mais de uma vez no mesmo pedido;
- item ativo deve ter ao menos um tamanho ativo;
- tamanho ativo deve ter nome, quantidade total maior que zero e ao menos uma cor ativa;
- tamanho duplicado no mesmo item e bloqueado;
- cor duplicada no mesmo tamanho e bloqueada;
- o rateio e um recurso auxiliar para distribuir quantidade entre cores;
- percentual de rateio, total do rateio, conjunto de cores do rateio e soma das quantidades das cores nao bloqueiam o salvamento do pedido;
- quantidades zeradas inativam cores automaticamente;
- tamanho sem cor ativa ou com quantidade total zero e inativado;
- item sem tamanho ativo e inativado;
- item ou tamanho inativo zera seus totais de quantidade e valor;
- itens/tamanhos/cores inativos nao disparam validacoes de rateio;
- o total do pedido e recalculado no servidor pela soma dos totais das cores ativas;
- registros existentes sao atualizados; registros removidos da hierarquia sao excluidos;
- a data de entrega e informada por item e aplicada em cascata aos tamanhos;
- a data de entrega de cada tamanho pode ser alterada manualmente depois da cascata do item;
- se o fornecedor alterar a data de entrega do tamanho, o campo Data entrega fica destacado em vermelho na tela interna;
- datas de entrega vazias nos tamanhos sao gravadas como `NULL`, sem assumir a data do pedido.
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
- se `Aprovado Aguardando Foto Fornecedor` estiver em `KidStok`, o formulario pode exibir `Enviar Fornecedor`, que chama `enviar_proposta` para publicar novamente e devolver o pedido ao fornecedor;
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
- a grid mostra os mesmos campos principais da listagem de pedidos: pedido, criacao, publicacao, CD, empresa, fornecedor, status, localizacao, publicado, envio fornecedor, resposta fornecedor, valor e acoes;
- a grid usa botao de edicao apenas para pedido aberto e editavel;
- pedidos fechados, aguardando foto ou localizados em `Fornecedor` usam botao de visualizacao;
- quando consultas do dashboard falham, os indicadores caem para zero e a listagem fica vazia.

### 6.5 Cadastros > Produtos

O modulo usa as rotas compartilhadas `mod/cadastros/produtos/produtos_lista.php` e `produtos_form.php`. A listagem encaminha `produtos` para `produtos_accordion.php`, `valores` para `valores_grid.php` e as quatro associacoes para `grupo_categoria_grid.php`; as demais opcoes usam a renderizacao generica. O parametro `cadastro` identifica a opcao do catalogo em `config/produtos.php`; cada rota de listagem corresponde a uma aplicacao e suas permissoes no banco.

| Opcoes (`cadastro`) | Comportamento |
| --- | --- |
| `produtos` | Cadastro com accordion e cinco abas, cabecalho em `produtos_cab`, referencia R1 + R2 + R3 e geracao de combinacoes em `produtos_cab_grade`, mantendo validacoes e grades existentes. |
| `valores` | Tela unica com filtros, grid por referencia master e accordion de tamanhos/cores. Edicao direta de valores/indicadores e previa em lote antes de salvar por produto. |
| `outras_informacoes` | Edicao individual ou em lote de GTIN, local fisico, codigo alternativo, status e peso, pendentes de consolidacao. |
| `precos_lote` | Cabecalho e itens por referencia master ou completa, aplicacao, retorno de precos e historico. |
| `fotos` | Consulta, upload e exclusao em `produtos_fotos`, no banco principal; ate cinco imagens por produto e 10 MB por arquivo. |
| `consolidar` | Publicacao das grades pendentes em `produtos`, individualmente ou por selecao de ate 200 referencias master. |
| `consulta_geral`, `consulta_precos` | Consulta dos produtos consolidados. |
| `parametros` | Padroes tributarios, descricoes em maiusculas e relacao atacado/varejo. Exclusao bloqueada. |
| `importar_antigos` | Importacao por master de oito caracteres ou referencia completa de doze, priorizando GCOM sobre Antes GCOM e permitindo apenas faltantes. |
| `colecao`, `linha`, `grupo`, `categoria`, `composicao`, `caracteristica`, `fornecedor`, `categoria_r2`, `tamanho`, `cor`, `genero`, `estilo`, `medida` | Manutencao de dominios, com validacao, auditoria e bloqueio de exclusao quando existem vinculos. |
| `grupo_categoria` | Grid de grupos com accordion e categorias selecionaveis; busca, filtros e gravacao em lote por grupo. |
| `grupos_tamanho` | Accordion por grupo com selecao em lote de tamanhos; preserva `Ordem` dos vinculos mantidos e usa a ordem geral para os novos, ou zero quando nao cadastrada. |
| `categoria_composicao`, `categoria_caracteristica` | Accordion por categoria com selecao em lote de composicoes ou caracteristicas. |
| `ordenar_tamanho` | Ordenacao por setas e gravacao da lista completa, alem da manutencao individual de `Ordem`. |

Listagens genericas usam 50 registros por pagina; Valores usa 30 referencias master por pagina. Detalhes de grades e lotes usam 500 itens por pagina. As associacoes carregam a lista dos registros principais e seus itens ao expandir. A interface usa Bootstrap e Select2 locais. Exportadores e relatorios automaticos especificos do Scriptcase nao foram reproduzidos.

#### Cadastro de Produtos com Accordion e Abas

A rota `mod/cadastros/produtos/produtos_lista.php?cadastro=produtos` carrega o grid especifico. As linhas exibem referencia, descricao, fornecedor/categoria, status e consolidacao, com espacamento vertical moderado e bordas de 10 px. A pesquisa principal usa Select2 remoto: digitar referencia ou descricao retorna sugestoes `Referencia - Descricao`, com 25 opcoes por pagina. Selecionar filtra automaticamente a referencia exata (`product_reference`), em conjunto com os filtros avancados. Limpar o Select2 remove essa restricao; Limpar reinicia todos os filtros. Trocar a selecao respeita o aviso de alteracoes pendentes. O grid mantem a paginacao de 50 produtos. Tamanho e cor filtram codigos completos nas listas separadas por ponto e virgula do cabecalho.

Referencia (Select2), Fornecedor (R1), Categoria (R2) e Codigo (R3) ficam na mesma linha de filtros principais no desktop. R1 e R2 usam Select2 com selecao multipla, mantendo a lista aberta para selecionar varias opcoes; R3 aceita ate quatro caracteres. O filtro considera qualquer fornecedor selecionado e qualquer categoria selecionada, combinando os dois campos entre si e com os demais filtros. Nenhuma opcao selecionada significa todos naquele campo. O envio conserva os arrays completos (`Fornecedor[]` e `Categoria[]` em GET); a API aceita tambem os valores unicos anteriores, usa parametros SQL em `IN` e limita cada lista a 200 codigos. Essa mudanca e exclusiva dos filtros: fornecedor e categoria do editor continuam unicos. Os demais campos ficam em Mais filtros; em telas menores, os filtros principais se reorganizam em duas ou uma coluna.

Um produto fica aberto por vez. As cinco abas sao:

- **Dados do produto:** Referencia, Fornecedor (R1), Categoria (R2) e R3 na primeira linha no desktop, seguidos da classificacao e demais campos cadastrais; em telas menores, a linha se reorganiza em duas ou uma coluna;
- **Tributos:** NCM, origem, CSTs, aliquotas, reducao de ICMS e CFOPs;
- **Grade de referencias:** tamanhos/cores e valores padrao para novas combinacoes, seguidos das referencias existentes com precos, status e consolidacao, em paginas de 500 itens;
- **Fotos:** consulta, inclusao e exclusao usando as permissoes da aplicacao `fotos`, limites de cinco imagens e 10 MB e endpoints ja existentes;
- **Historico de precos:** consulta da tabela real `produtos_log_preco` (sem acento), por referencia master e suas variantes, mostrando data/hora, acao, usuario e compra/atacado/varejo anteriores e novos. Permite filtrar uma referencia completa, com paginacao de 50 registros, ordenados por data/hora e ID decrescentes.

O botao Novo produto abre o mesmo editor no grid; fotos e historico ficam disponiveis apos o primeiro salvamento. Edicao e inclusao usam as permissoes existentes de `produtos`. Fornecedor, categoria R2 e R3 ficam bloqueados na edicao para preservar a referencia. As abas conservam os dados locais, e fechar/trocar de produto, filtrar, paginar ou sair da tela avisa sobre alteracoes pendentes. Abas e tabelas rolam dentro do painel no celular; as abas tambem aceitam navegacao pelas setas, Home e End.

Salvar reusa `api/cadastros/produtos.php?action=save&cadastro=produtos` e `ProdutosWorkflow::saveProduct()`, mantendo a transacao, os valores individuais existentes e o estado pendente de consolidacao. `get` retorna `version`, calculada a partir do cabecalho; o novo editor envia essa versao na edicao, e um conflito retorna HTTP 409 com rollback. Clientes anteriores que nao enviam `version` conservam o contrato existente. As alteracoes de fotos atualizam a versao do editor apenas quando os demais dados do cabecalho permanecem iguais, preservando edicoes locais e a deteccao de mudancas externas.

A acao nova `price_history` da API generica e exclusiva de `cadastro=produtos`, exige sessao e visualizar da aplicacao, confere a existencia do produto e limita a consulta ao master solicitado e suas variantes. Nao grava nem recalcula historicos. As abas de fotos respeitam a permissao independente de visualizar/inserir/excluir de `fotos`.

O formulario antigo `produtos_form.php?cadastro=produtos` continua acessivel para compatibilidade. O grid principal passa a usar o editor incorporado. Nenhuma tabela, coluna ou menu foi criado para esta alteracao.

Os campos decimais de Produtos usam digitacao da direita para a esquerda: somente os algarismos sao necessarios e a virgula e posicionada automaticamente. Precos, aliquotas e reducoes usam duas casas, e peso usa tres conforme o schema. Por exemplo, `1234` produz `12,34` em preco/aliquota e `1,234` em peso; milhares recebem ponto. O helper opt-in `AllopDecimal` e carregado no layout e aplicado ao accordion, a tela de Valores (grade e lote), aos formularios compartilhados, aos itens de lotes de precos e ao campo Peso das alteracoes em lote de outras informacoes. Inteiros, codigos e demais telas sem o atributo `data-decimal-places` preservam a digitacao existente.

Leituras do banco sao formatadas sem reinterpretar a escala; os dados enviados as APIs usam ponto decimal e nao levam separador de milhar. Campos vazios de aplicacao em lote continuam significando manter o valor. A mascara aceita selecionar/substituir, apagar e colar valores formatados; pesos com tres casas sao preservados ao salvar. A digitação real, Backspace, separador de milhar e persistencia foram conferidos no Chrome com a fixture SQLite, incluindo o formulario de Outras Informacoes.

#### Produtos - Valores

A rota `mod/cadastros/produtos/produtos_lista.php?cadastro=valores` abre a nova tela unica. Referencia, fornecedor R1, categoria R2 e colecao ficam sempre visiveis; Mais filtros inclui R3, referencia do fornecedor, descricao/complemento, linha, grupo/categoria do grupo, genero, composicao, caracteristica, estilo, tamanho, cor, indicadores, status e consolidacao. Os seletores usam Select2 remoto da API generica com as permissoes de `valores`.

O grid agrupa por referencia master e mostra descricao, fornecedor/categoria, quantidade de variantes correspondentes aos filtros em relacao ao total e consolidacao. Um produto fica aberto por vez. O accordion mostra somente as variantes correspondentes aos filtros, com paginacao explicita de 500 itens. Navegar entre produtos, paginas, filtros ou sair da tela alerta sobre alteracoes pendentes.

Na grade, e possivel editar Varejo, Atacado, Compra, Setor Laranja, Preco Cheio, Encomenda e Estilo. A selecao por checkbox limita a aplicacao em lote aos itens da pagina atual; edicoes individuais independem dessa selecao. Campos de lote vazios mantem o valor existente, zero e um valor valido e os seletores iniciam em Nao alterar. Aplicar na grade altera somente a previa local e destaca os campos alterados; Salvar alteracoes grava somente os itens modificados, incluindo edicoes individuais, em transacao unica por produto.

A API especifica `api/cadastros/produtos_valores.php` tem acoes `list`, `get` e `save`. `save` exige POST, sessao, visualizar/editar da aplicacao `valores`, CSRF e uma lista de ate 500 itens com `id`, `version` e `values`, alem do `id` da referencia master. A API valida pertencimento ao produto, campos permitidos e versao por item; conflito retorna HTTP 409 com rollback integral. Grava por `ProdutosWorkflow::saveGrade()` e marca grade/cabecalho como pendentes, sem publicar automaticamente em `produtos`.

Valores aceitam virgula ou ponto decimal, ate duas casas e faixa de 0 a 99.999.999,99; formato brasileiro com milhar e virgula tambem e aceito. Compra deve ser menor ou igual a atacado, e atacado menor ou igual a varejo. Ao alterar varejo, `PrecoAtacadoMetadeVarejo = S` recalcula atacado pela metade, com arredondamento para centavos; Preco Cheio = S sempre iguala atacado e varejo. A previa e a API aplicam essas regras. Vinculos, permissoes e schema existentes sao preservados. Perfis com visualizar sem editar recebem a grade em consulta.

O layout mantem a tabela com rolagem interna no celular, sem transforma-la nos cards do CSS generico. Foram executadas 188 verificacoes HTTP isoladas e o teste de interface no Chrome local, em desktop e celular, com dados ficticios: Select2, previa sem persistencia, salvamento, recarga, edicao individual, arredondamento, cancelamento com aviso e rolagem interna. As capturas foram inspecionadas; nenhum banco configurado foi acessado.

#### APIs de Produtos

As quatro associacoes usam `api/cadastros/produtos_associacoes.php?cadastro=...`, com acoes `list` (registros principais e quantidades), `get` (itens ativos ou ja vinculados, vinculos e versao) e `save`. Os valores permitidos de `cadastro` sao `grupo_categoria`, `grupos_tamanho`, `categoria_composicao` e `categoria_caracteristica`, definidos em `produtos_associacao_config()` de `config/produtos.php`. `api/cadastros/grupo_categoria.php` permanece como rota de compatibilidade, fixada em Grupo / Categoria.

O contrato POST compartilhado usa `grupo` para a chave do registro principal, `categorias` para a lista de chaves dos itens, `version` e `csrf`. Esses nomes sao internos: a interface apresenta grupo/categoria e tamanhos/composicoes/caracteristicas conforme o cadastro. As chaves numericas sao transportadas como strings, preservando tambem os zeros iniciais dos tamanhos. `get` retorna `Valor` (chave) e `Nome` (descricao) separadamente; a busca e a ordenacao usam a descricao.

A listagem mostra inclusive registros sem vinculos. Um accordion fica aberto por vez; busca e filtros Todos os itens/Vinculados/Nao vinculados atuam sobre a selecao atual. Alteracoes pendentes exigem confirmacao ao fechar ou trocar de registro e geram aviso ao sair da pagina. As rotas antigas dos formularios dessas quatro associacoes redirecionam para o grid. `mod/cadastros/produtos/grupo_categoria_grid.php` e `assets/js/grupo_categoria.js` sao compartilhados entre elas.

Os itens aparecem em ordem alfabetica em portugues, preenchendo a primeira coluna de cima para baixo e continuando na segunda. Busca e filtros recalculam a divisao dos itens visiveis; no celular, a lista segue em uma coluna.

A gravacao exige visualizar; inclusoes exigem inserir e remocoes exigem editar e excluir, sempre na aplicacao correspondente ao cadastro solicitado. Preserva codigo, status, ordem e auditoria dos vinculos mantidos e insere novos vinculos ativos com auditoria quando esses campos existem na tabela. Registros inativos nao recebem novos vinculos; itens inativos ja vinculados continuam visiveis. Remocoes verificam as chaves estrangeiras completas, inclusive `ON DELETE CASCADE`, e recusam vinculos usados em outros cadastros. A operacao e transacional, bloqueia o registro principal no MySQL e compara a versao dos vinculos para evitar sobrescrever alteracoes concorrentes (HTTP 409). Nenhuma tabela ou permissao nova e necessaria.

`api/cadastros/produtos.php` recebe `cadastro` e `action`:

| Acao | Contrato |
| --- | --- |
| `list`, `get` | Listagem paginada e consulta de registro, relacionamentos e detalhes. |
| `defaults`, `options` | Valores padrao e opcoes de relacionamentos ativos para Select2. |
| `price_history` | Somente `produtos`: historico paginado de `produtos_log_preco`, limitado ao produto solicitado, com filtro opcional de referencia completa. |
| `product_search` | Somente `produtos`: sugestoes Select2 por referencia ou descricao, com `results` e `pagination.more`; exige visualizar da aplicacao. |
| `sizes` | Lista completa de tamanhos ordenados, somente para `ordenar_tamanho`. |
| `photos`, `photo` | Sequencias das fotos e conteudo binario da imagem, somente para `fotos`. `photo` nao retorna JSON quando encontra a imagem. |
| `save`, `delete` | Exigem POST, token `csrf`, capacidade do cadastro e permissao especifica de inserir/editar/excluir, alem de visualizar. |

`api/cadastros/produtos_processos.php` aceita apenas POST, exige sessao, token `csrf`, permissao de visualizar e permissao da operacao:

| Acao | Aplicacao / permissao |
| --- | --- |
| `consolidate` | `consolidar` / `processar` |
| `import` | `importar_antigos` / `processar` |
| `photo_upload`, `photo_delete` | `fotos` / `inserir` ou `excluir` |
| `batch_item`, `batch_item_delete` | `precos_lote` / `editar` |
| `batch_apply`, `batch_restore` | `precos_lote` / `processar` |
| `order_sizes` | `ordenar_tamanho` / `editar` |
| `grade_bulk_valores`, `grade_bulk_informacoes` | `valores` ou `outras_informacoes` / `editar` |

Os processos executam transacao e, em MySQL, usam a trava compartilhada `allop_produtos_` + `DB_NAME`, com espera de ate dez segundos. O executor CLI de precos usa a mesma trava. As tabelas e campos do CRUD sao definidos no catalogo/metadados; valores de entrada usam parametros SQL.

#### Regras de Consolidacao e Integracao com Compras

- salvar cabecalho preserva grades e valores individuais existentes e acrescenta novas combinacoes; referencias em `produtos_referencias_prod` sao preservadas;
- excluir uma familia com produtos publicados remove somente grades ainda nao publicadas;
- consolidar publica grades com `Consolidado = 'N'` em `produtos`, preserva codigo e GTIN existentes e marca as grades processadas como consolidadas;
- novas publicacoes geram codigo de oito posicoes a partir do maior codigo atual, com base 115000 quando vazio, e GTIN de quatorze posicoes;
- codigo alternativo deve apontar para outra referencia consolidada com o mesmo tamanho/cor;
- a consolidacao PHP nao executa `produtos_000_sp`, procedure com integracoes externas;
- a consolidacao do pre-cadastro de Compras gera apenas cabecalho/grade pendentes; a publicacao por este modulo permite que as referencias passem a existir em `produtos.Distribuidora`, exigido para gerar compra;
- fotos de Produtos ficam no banco principal, enquanto as fotos de pedidos de compra usam `db_fotos()`;
- os tres gatilhos `produtos_fotos_before_insert`, `produtos_fotos_before_update` e `produtos_fotos_before_delete` do dump chamam `sp_atualiza_data_alteracao_produtos_cab` sem prefixo de outro banco.

#### Lotes de Precos e Agendamento

O fluxo considera parametros de atacado e preco cheio. Na aplicacao, captura os precos vigentes para retorno; na restauracao, recusa referencias cujos precos mudaram posteriormente. Os estados sao `0` (nao aplicado), `1` (aguarda retorno) e `9` (finalizado). Aplicacao e retorno atualizam o historico em `produtos_precos_cab_h` e `produtos_precos_itens_h`, mantendo a consulta do lote.

```powershell
# Apenas consulta lotes vencidos no banco configurado:
php scripts/processar_precos_produtos.php

# Aplica lotes e retornos vencidos no banco configurado:
php scripts/processar_precos_produtos.php --execute
```

A execucao automatica depende de cron ou Agendador de Tarefas configurado no servidor. A presenca do script nao comprova que o agendamento esteja ativo. As datas do modulo usam `America/Sao_Paulo`.

## 7. Autenticacao, Sessao, Menu e Permissoes

Sessao:

- a sessao guarda `id`, `nome`, `login` e `perfil_id`;
- paginas internas chamam `require_login()`;
- APIs internas normalmente chamam `api_require_login()`;
- `sx.php` usa uma sessao separada chamada `allop_sx`, apenas para token de formulario;
- login aceita senha com hash e senha em texto puro legado;
- novas senhas sao gravadas com `password_hash()`;
- logout limpa `$_SESSION`, remove o cookie da sessao quando aplicavel e chama `session_destroy()`.

Formato de resposta das APIs:

```json
{
  "success": true
}
```

Falhas usam `success: false` e normalmente incluem `message`. Os status HTTP usados incluem 401, 403, 404, 405, 409, 422 e 500; em Produtos, 405 indica metodo incorreto e 409 indica conflito de versao. O fluxo `sx.php` tambem pode retornar 419 quando o token proprio do formulario expira ou nao confere.

`api/bootstrap.php` define o Content-Type JSON. `request_data()` decodifica o corpo quando o Content-Type contem `application/json`; nos demais casos retorna POST, se houver, ou GET. Nao mescla automaticamente parametros da URL com o corpo. Cada endpoint resolve `action` separadamente: configuracoes de e-mail usa GET/POST, enquanto `produtos_processos.php` le a acao dos dados retornados por `request_data()`. Conferir o endpoint antes de montar chamadas JSON. Fotos e PDF possuem respostas binarias proprias.

`api_require_login()` verifica somente a existencia de `current_user()` na sessao. A verificacao de permissoes por perfil e de CSRF depende do endpoint; nao e fornecida automaticamente pelo bootstrap.

Menu:

- `seg_menu` define grupos;
- `seg_aplicacoes` define nome, rota, menu e ordem;
- `seg_perfil_permissoes.visualizar = 1` define o que aparece no menu;
- `seg_usuarios_permissoes` existe, mas nao participa da montagem do menu atual;
- `Principal` e `Sair` nao vem do banco no layout atual;
- menus `Principal` e `Sair` sao filtrados em `menu_items()`;
- o link da logo abre `dashboard.php`;
- o link `Sair` e fixo no header.
- rotas iniciadas por `mod/cadastros/produtos/produtos_lista.php?cadastro=` sao agrupadas em um submenu visual `Produtos`, na posicao da primeira rota desse grupo;
- o layout suporta abertura do submenu por clique e navegacao por teclado;
- o formulario de aplicacoes (`mod/seguranca/aplicacoes_form.php`) cadastra `nome`, `rota`, `menu_id` e `ordem` pelo CRUD generico; nao ha campo proprio de submenu nessa tela;
- no modulo de Produtos, as permissoes sao consultadas por perfil e pela rota completa com `cadastro`, e tambem sao verificadas nas APIs. Esse controle nao se estende automaticamente aos endpoints antigos.

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

Na configuracao local conferida em 12/11/2026, `config/database.php` define `DB_NAME = allop_devel`. As copias locais `config/database devel.php` e `config/database producao.php` nao sao carregadas pelo fluxo normal da aplicacao. Nao existe seletor automatico de ambiente entre esses arquivos; `seed_produtos.php` permite escolher explicitamente um arquivo de `config/` via `--config`. As credenciais existem nos arquivos de configuracao, mas nao devem ser copiadas para novas documentacoes, commits ou mensagens.

O cabecalho de `banco.sql` identifica a origem como `allop_devel`, com geracao em 21/09/2026 e servidor MySQL 5.7.35-log. O nome no dump nao comprova o schema ou os dados do banco ativo; esta revisao conferiu apenas os arquivos locais.

`banco.sql` contem:

- 241 tabelas;
- 67 triggers;
- 4 funcoes;
- 28 procedures;
- 9 views;
- dump estrutural, sem dados.

Principais grupos de tabelas:

| Dominio | Tabelas principais |
| --- | --- |
| Seguranca | `seg_menu`, `seg_aplicacoes`, `seg_perfil`, `seg_perfil_permissoes`, `seg_usuarios`, `seg_usuarios_permissoes` |
| Compras | `cp_compras`, `cp_compras_status`, `cp_compras_emails`, `cp_depara_cor`, `cp_compras_itens`, `cp_compras_itens_tamanhos`, `cp_compras_itens_cores`, `cp_compras_itens_rateios` |
| Logs de compras | `cp_compras_itens_log`, `cp_compras_itens_tamanhos_log`, `cp_compras_itens_cores_log` |
| Configuracoes | `empresas`, `empresas_cd`, `config_email`, `urls_allop`, `situacao` |
| Portal fornecedor | `pf_colecao`, `pf_usuarios`, `pf_usuarios_copy`, `pf_usuario_fornecedor` |
| Agenda e conferencia de compras legado | `compras_agenda*`, `compras_contagem*`, `compras_recontagem*`, `conferentes`, `entrada_de_mercadorias*` |
| Etiquetas e pre-cadastro | `etiquetas_cab`, `etiquetas_ite`, `etiquetas_api`, `pre_cadastro`, `pre_cadastro_item`, `pre_cadastro_item_pro` |
| Catalogo/ERP legado | tabelas `produtos*`, `KidStok`, `KidStokAntesGCom`, `cfops`, `cests_ncm`, `st_*`, `compras*`, `nfe_*`, `romaneios_*`, `fechamento*`, `provisorios*`, `transportadoras*`, `veiculos*`, `tb*` e auxiliares |
| Cadastros auxiliares/API | `bancos`, `cargos`, `cidades*`, `estados*`, `franqueados*`, `consultores*`, `ramo_atividades*`, `regioes*`, `responsaveis*`, `configuracoes_*`, `logs`, `log_scripts` |
| Views e rotinas legadas | views `produtos_*`, `vw_compras_*`, `vw_produtos_fabrica`, `rmnUH`, funcoes `sf_*` e procedures `sp_*`/legadas presentes no dump. |

Triggers relevantes para compras:

- `cp_compras_itens_after_update`;
- `cp_compras_itens_cores_after_update`;
- `cp_compras_itens_tamanhos_after_update`.

Essas triggers gravam snapshots em tabelas de log usando os dados antigos (`OLD`) e consultam `Iteracao`/`Localizacao` no pedido.

As tabelas de historico do pre-cadastro (`pre_cadastro_hst`, `pre_cadastro_item_hst` e `pre_cadastro_item_pro_hst`) sao criadas ou alinhadas pelo seed e pela API antes do processo de mover para historico.

O dump inclui `pre_cadastro.consolidado`, `pre_cadastro.compra` e `pre_cadastro_item.compra_nro`, mas nao inclui `compra_nro` em `pre_cadastro_item_pro`. O seed acrescenta essa coluna e tambem a garante no historico da grade; a API so preenche `pre_cadastro_item_pro.compra_nro` quando a coluna existe.

### 8.2 Banco de Fotos

Na configuracao local conferida em 12/11/2026, `config/database.php` define `DB_FOTOS_NAME = allop_devel_fotos`. A configuracao ativa usa o banco principal `allop_devel` e o banco de fotos `allop_devel_fotos`. As copias de configuracao nao sao selecionadas automaticamente. Os nomes foram conferidos nos arquivos, sem conexao aos bancos nesta revisao.

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
- concede todas as permissoes ao Administrador quando a permissao ainda nao existe; em permissoes existentes, atualiza somente `visualizar` conforme o cadastro da aplicacao, preservando os demais campos;
- cria o usuario `admin` apenas se ele ainda nao existir;
- cria tabelas auxiliares com `CREATE TABLE IF NOT EXISTS`;
- cria ou ajusta estruturas ligadas a `config_email`, `urls_allop` e compras;
- garante `pre_cadastro.consolidado`, `pre_cadastro.compra`, `pre_cadastro_item.compra_nro` e `pre_cadastro_item_pro.compra_nro`;
- cria ou alinha `pre_cadastro_hst`, `pre_cadastro_item_hst` e `pre_cadastro_item_pro_hst` com as tabelas origem;
- registra a aplicacao `De/Para de Cores` no menu Compras;
- chama `registrar_aplicacoes_produtos()` de `scripts/seed_produtos.php` para registrar as 28 opcoes de Cadastros > Produtos;
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
- E-mails de Compras;
- Pedidos de Compra;
- Pre Cadastro Produtos;
- Gerar Pre Cadastro Produtos, cadastrado com `visualizar = 0` para apoiar o formulario sem aparecer no menu.
- De/Para de Cores.

O seed e parcialmente idempotente, mas executa DDL e altera dados de menu/permissoes. Deve ser usado com backup e consciencia do ambiente.

Para instalar somente as aplicacoes de Produtos, o seed especifico exige CLI, perfil `Administrador` existente e conferencia do nome do banco:

```powershell
php scripts/seed_produtos.php --database=allop_devel
```

O argumento `--database` valida o banco conectado; nao troca a conexao. O padrao esperado e `allop_devel`. `--config` permite informar um arquivo dentro de `config/`. O registro usa transacao, aproveita o menu `Cadastro`/`Cadastros` existente ou cria `Cadastros`, atualiza nome/rota/ordem e preserva permissoes ja existentes. Novas permissoes do Administrador respeitam as capacidades de cada opcao, com imprimir/exportar desabilitados. Outros perfis precisam de liberacao nas telas de seguranca. O seed especifico nao cria as tabelas comerciais.

`scripts/ajustar_triggers_fotos_produtos.php` e uma rotina separada e exclusiva de `allop_devel`. Sem argumentos, consulta os tres gatilhos de fotos e informa os que ainda chamam a procedure de `allop_kidstok`. Com `--execute`, salva as definicoes anteriores em arquivo SQL temporario e substitui essas chamadas por chamadas locais. O dump atual ja contem as chamadas locais; nao executar o ajuste como passo obrigatorio de uma instalacao nova.

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
- usar `db_fotos()` para as fotos de compras em `cp_compras_fotos`/`cp_compras_fotos_ks`; as fotos do cadastro de Produtos ficam em `produtos_fotos` no banco principal e usam `db()`;
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
| Botoes | `.btn-new`, `.btn-save`, `.btn-sync`, `.btn-edit`, `.btn-view`, `.btn-delete`, `.btn-print`, `.btn-photo`, `.btn-manage-photos`, `.btn-filter`, `.btn-back`, `.btn-consolidate`, `.btn-generate-purchase`, `.btn-history` | Acoes padronizadas com icones por CSS. |
| Alertas | `appAlert()`, `appOkAlert()`, `appConfirm()` | Mensagens e confirmacao via Bootstrap Modal/Alert. |
| Salvamento | `setFormSaving()` | Bloqueia botao e mostra processamento. |
| Status | `.badge-status-*`, `.cp-localizacao-badge`, `.dashboard-grid-badge` | Badges de status, localizacao e publicacao. |
| Pedido | `.cp-pedido-status-hero`, `.cp-compra-layout`, `.cp-pedido-resumo`, `.cp-compra-item`, `.cp-compra-tamanho`, `.cp-compra-cor` | Status destacado, resumo lateral, workflow e hierarquia de compra. |
| Rateio | `#cp-rateio-modal`, `.cp-rateio-*` | Percentuais por cor e quantidades por tamanho. |
| Fotos | `#cp-fotos-modal`, `.cp-item-fotos-panels`, `.cp-foto-dropzone`, `.cp-fotos-grid`, `.cp-foto-card`, `.cp-foto-preview-img` | Paineis de fotos, upload, exclusao e preview de imagens. |
| Log de cor | `#cp-cor-log-modal`, `.cp-preco-alterado-*`, `.btn-price-log` | Comparacao de preco com ultimo log. |
| Login | `.login-page`, `.login-shell`, `.login-card`, `.login-showcase` | Tela de acesso com logos e alternancia de visibilidade da senha. |
| SX | `.sx-wrap`, `.sx-panel`, `.sx-title`, `.sx-mark`, `.btn-sx` | Tela externa `sx.php` para alteracao de senha de usuarios. Os estilos ficam inline no proprio arquivo. |
| Pre-cadastro | `.pre-cadastro-ref-badges`, `.pre-cadastro-metric-badges`, `.pre-cadastro-toggle`, `.pre-cadastro-tamanhos-accordion`, `.btn-pre-cadastro-consolidar`, `.btn-pre-cadastro-historico` | Badges de referencias e metricas, toggles Sim/Nao, accordions de itens/tamanhos, grade de produtos gerados e acoes da listagem. |
| De/para de cores | `.cp-depara-cor-select`, `.cp-depara-cor-status`, `.cp-depara-cor-save-row` | Select2 de cor KidStok, badge de mapeamento e salvamento por linha no formulario em lote. |

## 12. Pontos de Atencao Conhecidos

1. **Permissao incompleta nas APIs antigas:** o menu usa `visualizar` por perfil, mas os endpoints antigos nao validam todas as permissoes por acao. As APIs de Cadastros > Produtos verificam visualizar e permissoes especificas de gravacao/processamento; nao generalizar essa protecao para o restante do sistema.
2. **Permissoes por usuario sem efeito no menu:** `seg_usuarios_permissoes` existe e possui telas, mas nao participa da montagem do menu.
3. **Dashboard sem filtro por permissoes:** os indicadores de compras ainda nao variam conforme permissoes do usuario.
4. **Troca de senha admin publica:** `api/seguranca/admin_senha.php` nao chama `api_require_login()` e o formulario `alterar_senha_admin.php` fica fora do fluxo autenticado.
5. **Grafias legadas:** `seg_usuarios_permissoes` usa `edtiar` e `imprirmir` no codigo.
6. **Credenciais no codigo:** `config/database.php` e as copias locais de configuracao contem credenciais em constantes; o recomendado e migrar para variaveis de ambiente.
7. **Erros expostos:** varias APIs retornam `Throwable::getMessage()` diretamente ao cliente.
8. **CSRF ausente ou parcial:** os formularios e acoes antigas nao possuem protecao uniforme. As gravacoes e processos de Cadastros > Produtos exigem POST e token CSRF de sessao. `sx.php` valida token proprio, mas continua fora da autenticacao principal.
9. **Senha legada aceita:** o login aceita texto puro para compatibilidade.
10. **DDL no seed:** `seed_aplicacoes.php` cria tabelas auxiliares e recria triggers; isso deve ser executado com backup.
11. **Transacao entre bancos:** operacoes com fotos podem envolver banco principal e banco de fotos sem atomicidade distribuida real.
12. **Dependencias externas:** ViaCEP e Google Fonts sao dependencias externas atuais.
13. **`ibge` opcional em Empresas:** a API detecta a coluna; se ausente, ignora a persistencia.
14. **Referencias legadas parcialmente fora do dump:** o `banco.sql` atual inclui tabelas `tb*` legadas como `tbcest`, `tbcidades`, `tbfranqueados`, `tbprodutos`, `tbprodutosbarras`, `tbramoatividade`, `tbresponsaveis` e `tbresponsaveisadicionais`, mas ainda ha referencias historicas para nomes como `romaneios_tabela_preco`, `tbestados`, `tbgrupos`, `tbmarcas`, `tbmedidas` e `tbmodelos` que nao aparecem como tabelas base no dump.
15. **`pf_usuarios_copy`:** tabela presente no dump sem referencia no codigo atual.
16. **Status autocorrigidos por upsert:** `cp_ensure_status_catalog()` regrava os textos canonicos dos IDs 0 a 3 em `cp_compras_status`; alteracoes manuais nesses IDs podem ser sobrescritas.
17. **Encoding legado:** varios arquivos PHP e documentos legados ainda exibem acentos quebrados em strings ja versionadas; novos textos deste documento foram gravados em UTF-8/ASCII para reduzir novas quebras.
18. **Contrato de fotos do fornecedor:** a acao `fotos_upload` aceita `origem=fornecedor`, mas `cp_require_foto_mutavel()` bloqueia qualquer insercao ou exclusao em `cp_compras_fotos` pela tela interna.
19. **Workflow depende de snapshot no frontend:** o bloqueio de `Aprovar` e `Recusar` apos alteracoes locais de preco, valor ou entrega compara a grade atual com o estado carregado em `cpCompraWorkflowSnapshot`. Alteracoes feitas por fora da tela dependem do estado persistido e das regras da API.
20. **Pre-cadastro sem permissao propria por acao:** `pre_cadastro_produtos.php` exige sessao, mas nao confere permissao especifica de processar/gravar antes de gerar ou inserir o pre-cadastro.
21. **De/para de cores opcional:** a sugestao automatica de cor KidStok no pre-cadastro depende da existencia e preenchimento de `cp_depara_cor`; a tela `mod/compras/cp_depara_cor_form.php` ajuda a manter esse mapa, mas sem ele a cor precisa ser completada manualmente.
22. **`sx.php` publico para troca de senha:** a tela externa possui token de formulario, mas nao exige login, perfil, permissao ou segredo adicional antes de listar usuarios e alterar senhas de `seg_usuarios`.
23. **Historico sem validacao de consolidacao na API:** a listagem so oferece `Historico` para registros consolidados, mas `pc_mover_pre_cadastro_historico()` verifica o ID e a existencia do registro sem exigir `consolidado = 1`.
24. **Consultas diretas em telas:** a listagem de pre-cadastro, o formulario em lote de de/para e o dashboard consultam o banco no PHP da propria tela. Sao excecoes atuais ao padrao de concentrar acesso a dados em APIs.
25. **Senha de usuario sem validacao minima no CRUD:** o formulario de usuarios permite senha vazia na inclusao e a API generica nao exige tamanho minimo; na edicao, senha vazia preserva o valor existente.
26. **Ambiente do banco de fotos:** a configuracao ativa voltou a apontar para `allop_devel_fotos`, junto ao principal `allop_devel`, em 12/11/2026. Conferir ambos ao preparar ambiente e antes de gravar fotos de pedidos; nomes de bancos nao comprovam disponibilidade ou conteudo.
27. **Lotes dependem de agendador externo:** o script de precos nao instala cron/tarefa; sem agendamento, aplicacao e retorno dependem de execucao manual.
28. **Limites dos testes isolados de Produtos:** a fixture SQLite adapta `FOR UPDATE` e metadados MySQL; nao comprova concorrencia, triggers, procedures ou integracoes reais do MySQL.
29. **Senha SMTP exposta nas consultas autenticadas:** `configuracoes_email.php` inclui `Senha` nas respostas de `list` e `get`, e nao verifica permissao especifica da aplicacao. O campo password no formulario apenas mascara a exibicao visual.
30. **Validacao de e-mail concentrada no formulario:** o cadastro de contas nao valida no servidor todos os campos obrigatorios, formato, porta ou modos. A validacao de transporte ocorre somente no envio; gravar a configuracao nao comprova funcionamento do SMTP.

## 13. Como Recriar o Projeto do Zero

Esta secao descreve o caminho minimo para reconstruir o Allop em um ambiente novo usando o codigo e os dumps atuais do repositorio. Ela complementa a documentacao de arquitetura; nao substitui a conferencia do codigo quando houver divergencia.

### 13.1 Requisitos do Ambiente

Ambiente esperado:

- servidor web com PHP habilitado, como Apache/IIS/Nginx com PHP-FPM;
- PHP com extensoes `pdo`, `pdo_mysql`, `dom`, `mbstring`, `openssl`, `json`, `fileinfo` e `gd` quando houver geracao/manipulacao de imagem ou PDF; `dom` e `mbstring` sao requisitos do Dompdf no `composer.lock`;
- MySQL ou MariaDB compativel com o dump existente;
- Composer instalado para restaurar dependencias PHP;
- navegador com acesso aos assets locais do projeto.

`composer.json` nao declara uma versao minima explicita de PHP; conferir a compatibilidade das dependencias de `composer.lock` com o runtime escolhido. Para executar o teste isolado de Produtos, tambem sao necessarios Python 3 e PHP CLI com `pdo_sqlite`.

O projeto pode rodar em subpasta, pois `config/app.php` calcula `BASE_URL` com base em `SCRIPT_NAME`. Mesmo assim, depois de publicar em uma nova pasta, conferir rotas de `api/`, `mod/` e assets.

### 13.2 Arquivos Necessarios

Para recriar o projeto, manter estes itens:

- codigo fonte da raiz, `api/`, `config/`, `includes/`, `mod/`, `assets/`, `scripts/` e `docs/`;
- `composer.json` e `composer.lock`;
- `banco.sql`;
- `banco_fotos.sql`;
- imagens em `assets/img/`, especialmente `SemFoto.png`;
- telas raiz `login.php`, `dashboard.php`, `alterar_senha_admin.php` e `sx.php`, quando esses fluxos forem usados no ambiente;
- bibliotecas locais em `assets/vendor/`.

A pasta `vendor/` pode ser recriada com Composer quando `composer.json` e `composer.lock` estiverem presentes. As copias locais de configuracao nao sao necessarias a execucao.

### 13.3 Passo a Passo

1. Copiar o projeto para a pasta servida pelo web server.
2. Rodar `composer install` na raiz do projeto para restaurar `vendor/`.
3. Criar o banco principal no MySQL/MariaDB.
4. Importar `banco.sql` no banco principal.
5. Criar o banco de fotos.
6. Importar `banco_fotos.sql` no banco de fotos.
7. Ajustar `config/database.php` com host, nome dos bancos, usuarios, senhas e charset do novo ambiente; alterar apenas as copias locais de configuracao nao muda as conexoes utilizadas.
8. Acessar `index.php` pelo navegador e validar se a tela de login carrega com CSS, JS e imagens.
9. Executar `scripts/seed_aplicacoes.php` apenas apos backup ou em ambiente novo, para criar/atualizar menus, aplicacoes, permissoes, perfil Administrador e usuario administrador inicial.
10. Entrar como administrador e trocar a senha inicial imediatamente pela tela `alterar_senha_admin.php` ou por fluxo administrativo equivalente.
11. Se `sx.php` for publicado no ambiente, restringir seu acesso na camada de infraestrutura ou substituir por fluxo autenticado.
12. Conferir o menu do perfil Administrador e liberar permissoes dos demais perfis conforme necessario.
13. Testar dashboard, listagens principais, cadastro de empresas/CD, configuracao de e-mail e fluxo de pedido de compra.
14. Conferir as 28 aplicacoes no submenu Cadastros > Produtos e as permissoes de cada perfil; se apenas esse modulo precisar ser registrado, usar o seed especifico descrito na secao 9.
15. Validar cadastros auxiliares, cabecalho/grade, consolidacao e consultas de Produtos em ambiente de teste. Configurar agendador de precos somente quando esse processamento automatico for necessario.

Os dumps sao estruturais e o seed nao popula todo o catalogo comercial e fiscal. Fluxos de compras e pre-cadastro dependem de empresas/CDs, fornecedores, colecoes, categorias, tamanhos, cores e demais dominios cadastrados ou importados. A geracao de compra tambem depende das referencias em `produtos.Distribuidora`.

### 13.4 Ordem Recomendada de Validacao Inicial

Depois da instalacao:

- abrir `login.php` e validar autenticacao;
- abrir `dashboard.php` e validar indicadores e `Ultimos 10 pedidos`;
- abrir `mod/seguranca/*_lista.php` para conferir menus, perfis e permissoes;
- abrir `mod/configuracoes/empresas/empresas_lista.php`;
- abrir `mod/configuracoes/empresas_cd/empresas_cd_lista.php`;
- abrir `mod/configuracoes/configuracoes_email/configuracoes_email_lista.php`;
- abrir `mod/compras/cp_compras_lista.php`;
- abrir `mod/compras/cp_depara_cor_lista.php` e conferir o mapeamento de cores quando houver `pf_colecao` e `produtos_cor`;
- criar ou editar um pedido em `mod/compras/cp_compras_form.php`;
- testar upload/visualizacao de fotos usando o banco de fotos;
- gerar PDF por `api/compras/cp_compras_pdf.php`;
- testar envio de e-mail apenas com SMTP configurado e conta ativa/habilitada para o mesmo CD e empresa do pedido;
- abrir `mod/cadastros/produtos/produtos_lista.php?cadastro=produtos` e conferir submenu, filtros e paginacao;
- validar parametros e dominios antes de gerar grade e consolidar produtos;
- conferir upload de fotos em `produtos_fotos` no banco principal e as permissoes por acao;
- validar aplicacao/retorno de lotes com dados de teste, incluindo conflito de precos.

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
- em pre-cadastro, conferir consolidacao, existencia das referencias em `produtos.Distribuidora`, geracao de compra e movimentacao para historico;
- conferir banco principal e banco de fotos quando houver fotos;
- revisar console do navegador e log do PHP;
- nao sobrescrever mudancas fora do escopo.

Para alteracoes no modulo de Produtos, ha um teste HTTP existente:

Em 12/11/2026, antes do commit, `python tests/produtos_http_test.py` passou com 216 verificacoes HTTP em fixture SQLite; a sintaxe dos arquivos PHP e JavaScript envolvidos tambem foi validada. As demais contagens e capturas mencionadas nesta secao sao registros de execucoes anteriores; os testes de navegador nao foram refeitos nessa data. As suites cobrem Produtos; nao ha suite especifica de configuracoes de e-mail ou SMTP em `tests/`.

```powershell
python tests/produtos_http_test.py
```

Ele cria copia temporaria dos arquivos necessarios, substitui a conexao por fixture SQLite e sobe servidor PHP local, sem conectar aos bancos configurados do projeto. Cobre listagens, geracao de grade, consolidacao e preservacao de codigos, edicoes em lote, rollback, lotes e retorno de precos, importacao, fotos, ordenacao, permissoes e CSRF. Inclui os quatro grids de associacao e a API em lote, conflito de versao, permissoes por aplicacao, preservacao de dados existentes, zeros iniciais dos tamanhos, itens inativos e protecao contra exclusao de vinculos em uso, inclusive com cascata. Requer Python 3 e PHP CLI com `pdo_sqlite`; nao substitui validacao das particularidades MySQL. A execucao historica de 30/10/2026 esta descrita em `docs/conversao_produtos.md`; o teste foi executado novamente em 03/11/2026 com 168 verificacoes para validar as quatro associacoes.

O teste opcional de interface de Valores usa Chrome local no Windows e Node.js com `WebSocket` global. Ele recebe exclusivamente o diretorio de uma fixture SQLite gerada pelo teste HTTP (o caminho e impresso ao final), copia os assets e inicia PHP/Chrome temporarios, encerrados no final:

```powershell
node tests/produtos_valores_browser_test.mjs CAMINHO_DA_FIXTURE
```

O script recusa configuracoes sem os marcadores da fixture. Valida previa sem gravacao, salvamento, recarga, calculo de atacado, arredondamento, aviso ao cancelar e rolagem mobile. Salva `valores-desktop.png` e `valores-mobile.png` na fixture.

Os padroes tributarios do pre-cadastro possuem teste isolado:

```powershell
php tests/pre_cadastro_tributos_test.php
```

Executado em 12/11/2026 com 32 verificacoes em SQLite em memoria, sem carregar a configuracao de banco. Confere ordem dos parametros, mapeamento, descricoes, zeros iniciais, preservacao de valores salvos/zero, preenchimento de campos vazios e ausencia de parametros.

Para a galeria e exibicao dos tributos na interface, o teste usa APIs ficticias e bloqueia o acesso a banco na copia temporaria:

```powershell
node tests/pre_cadastro_fotos_browser_test.mjs
```

Requer PHP CLI, Node.js com `WebSocket` global e Chrome no caminho Windows usado pelos demais testes de interface. Foi executado em 12/11/2026: checkbox marcado, carga sob demanda, selecao por item/origem, ampliacao, recarga preservando edicoes, estado vazio, erro parcial e layout mobile. Salva `pre-cadastro-desktop.png` e `pre-cadastro-mobile.png` na fixture temporaria. Nao testa um provedor real de IA; a integracao ainda nao foi definida.

Para o cadastro de Produtos com accordion e cinco abas:

```powershell
node tests/produtos_accordion_browser_test.mjs CAMINHO_DA_FIXTURE
```

Esse teste tambem recusa configuracoes fora da fixture e valida Select2, abas, edicao e salvamento de tributos, grade existente, fotos, historico, descarte de alteracoes, navegacao por teclado, criacao e reabertura de produto, geracao de grade e upload de foto com edicao pendente. Salva `produtos-desktop.png` e `produtos-mobile.png`; as capturas foram inspecionadas em 04/11/2026. A suite HTTP teve 215 verificacoes nessa data, incluindo historico paginado/isolado por produto, permissoes e conflito de versao do cabecalho. Os testes de interface sao separados dessa contagem.

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
