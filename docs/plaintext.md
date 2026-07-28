# ALLOP - Arquitetura, regras e padrões do sistema

**Projeto correto para manutenção:** `D:\E7TI\PHP\allop`  
**Atenção:** não usar `D:\E7TI\PHP\appf` para demandas do Allop.

**Documento-base:** 01/06/2026  
**Última revisão do código:** 28/07/2026  
**Última revisão do `banco.sql`:** 15/07/2026  
**Última revisão do `banco_fotos.sql`:** 19/06/2026  
**Escopo conferido:** aplicação PHP, APIs, telas, assets, seed, banco principal, banco de fotos e documentação existente.

## 1. Objetivo

Este documento descreve o estado atual do sistema Allop e os padrões que devem ser preservados em manutenções, correções e novos desenvolvimentos.

As informações foram conferidas diretamente no projeto em `D:\E7TI\PHP\allop`. Quando há diferença entre uma intenção original e o comportamento implementado, a diferença está registrada em **Pontos de atenção conhecidos**.

## 2. Visão geral

O Allop é uma aplicação web responsiva em PHP puro, com telas renderizadas no servidor e APIs PHP retornando JSON para operações de CRUD e fluxos específicos.

Principais características:

- PHP procedural, sem framework backend;
- autenticação por sessão PHP;
- PDO para acesso ao MySQL;
- banco principal separado do banco de fotos;
- telas em `mod/`;
- endpoints em `api/`;
- Bootstrap, jQuery e Select2 distribuídos localmente em `assets/vendor/`;
- Dompdf instalado via Composer para geração de PDF;
- menu dinâmico por perfil;
- dashboard de compras;
- módulo de compras com pedido, itens, tamanhos, cores, rateio, fotos, e-mail e workflow.

Fluxo principal:

```text
index.php
  -> sem sessão: login.php -> api/seguranca/auth.php
  -> com sessão: dashboard.php
       -> telas em mod/
            -> chamadas AJAX para api/
                 -> db()       -> banco principal
                 -> db_fotos() -> banco de fotos
```

## 3. Estrutura do projeto

| Caminho | Responsabilidade |
| --- | --- |
| `index.php` | Redireciona para login ou dashboard conforme a sessão. |
| `login.php` | Tela pública de autenticação. |
| `logout.php` | Encerra a sessão. |
| `dashboard.php` | Painel autenticado com indicadores, gráficos e últimos pedidos de compra. |
| `alterar_senha_admin.php` | Tela específica para trocar a senha do usuário `admin`. |
| `config/` | Configuração geral e conexões PDO. |
| `includes/` | Autenticação, permissões, layout e envio SMTP. |
| `mod/` | Telas dos módulos do sistema. |
| `api/` | Endpoints JSON usados pelas telas. |
| `assets/css/` | CSS global do sistema. |
| `assets/js/` | JavaScript global, CRUD genérico e lógica de compras. |
| `assets/vendor/` | Bootstrap, jQuery e Select2 locais. |
| `assets/img/` | Logos e imagens institucionais. |
| `scripts/` | Rotinas administrativas, incluindo `seed_aplicacoes.php`. |
| `docs/` | Documentação e registros auxiliares. |
| `banco.sql` | Dump estrutural do banco principal. |
| `banco_fotos.sql` | Dump estrutural do banco de fotos. |

## 4. Arquivos compartilhados centrais

| Arquivo | Função |
| --- | --- |
| `config/app.php` | Define `APP_NAME`, `APP_DATE`, `BASE_PATH`, `BASE_URL`, `app_url()` e `h()`. |
| `config/database.php` | Define `db()` e `db_fotos()` com PDO, erro por exceção e prepared statements nativos. |
| `includes/auth.php` | Inicializa sessão e fornece `current_user()`, `require_login()`, `login_user()` e `logout_user()`. |
| `includes/permissions.php` | Monta o menu com base em `seg_perfil_permissoes.visualizar`. |
| `includes/layout.php` | Renderiza header, menu, área de conteúdo, footer e assets locais. |
| `includes/smtp_mailer.php` | Cliente SMTP por socket com SSL implícito, STARTTLS e autenticação opcional. |
| `api/bootstrap.php` | Inicialização comum das APIs, `api_response()`, `request_data()` e `api_require_login()`. |
| `assets/js/app.js` | CRUD genérico, Select2, alertas, confirmação, sincronização de grids e fluxo completo de compras. |
| `assets/css/style.css` | Tema global, responsividade, botões com ícones, grids, dashboard e componentes de compras. |
| `scripts/seed_aplicacoes.php` | Seed de menus, aplicações, Administrador, permissões e estruturas auxiliares. |

## 5. Bibliotecas e recursos

| Componente | Local | Uso |
| --- | --- | --- |
| PHP puro | arquivos `.php` | Renderização server-side, APIs JSON, sessão, regras e PDF. |
| PDO MySQL | `config/database.php` | Acesso ao banco principal e ao banco de fotos. |
| Bootstrap 5.3.6 | `assets/vendor/bootstrap/` | Layout, grid, navbar, dropdowns, botões, cards, modais e utilitários. |
| jQuery 3.7.1 | `assets/vendor/jquery/jquery.min.js` | AJAX, manipulação de DOM e integração com Select2. |
| Select2 4.1.0-rc.0 | `assets/vendor/select2/` | Campos pesquisáveis locais e remotos. |
| Dompdf 3.1 | `composer.json`, `vendor/` | PDF do pedido de compra. |
| ViaCEP | navegador, em `assets/js/app.js` | Preenchimento de endereço no cadastro de Empresas. |
| Google Fonts/Poppins | `assets/css/style.css` | Fonte visual principal via `@import`. |

Observação: a regra geral do projeto é manter bibliotecas locais. As exceções atuais são ViaCEP no navegador e Google Fonts no CSS.

## 6. Módulos implementados

### 6.1 Segurança

| Tela | API |
| --- | --- |
| `mod/seguranca/usuarios_lista.php` / `usuarios_form.php` | `api/seguranca/crud.php?entity=usuarios` |
| `mod/seguranca/perfis_lista.php` / `perfis_form.php` | `api/seguranca/crud.php?entity=perfis` |
| `mod/seguranca/aplicacoes_lista.php` / `aplicacoes_form.php` | `api/seguranca/crud.php?entity=aplicacoes` |
| `mod/seguranca/perfil_aplicacoes_lista.php` / `perfil_aplicacoes_form.php` | `api/seguranca/perfil_aplicacoes.php` |
| `mod/seguranca/usuarios_permissoes_lista.php` / `usuarios_permissoes_form.php` | `api/seguranca/crud.php?entity=usuarios_permissoes` |

APIs auxiliares:

| API | Ações/comportamento |
| --- | --- |
| `api/seguranca/auth.php` | Valida login ativo, aceita senha com `password_verify()` e texto puro legado, cria sessão e retorna redirect. |
| `api/seguranca/options.php` | Fornece opções Select2 para perfis, aplicações, menus, usuários, CDs e empresas. |
| `api/seguranca/admin_senha.php` | Altera a senha do login `admin` com `password_hash()`. Não exige sessão atualmente. |
| `api/seguranca/crud.php` | CRUD genérico para entidades de segurança. |
| `api/seguranca/perfil_aplicacoes.php` | Lista perfis, lista permissões por perfil, salva permissões em lote e exclui permissões do perfil. |

Entidades aceitas pelo CRUD genérico:

- `usuarios`;
- `perfis`;
- `aplicacoes`;
- `perfil_aplicacoes`;
- `usuarios_permissoes`;
- `menus`.

Permissões previstas:

- `visualizar`;
- `inserir`;
- `editar`;
- `excluir`;
- `imprimir`;
- `exportar`;
- `processar`.

Observação importante: em `seg_usuarios_permissoes`, o código usa as grafias legadas `edtiar` e `imprirmir`.

### 6.2 Configurações

| Funcionalidade | Telas | API |
| --- | --- | --- |
| Empresas CD | `mod/configuracoes/empresas_cd/` | `api/configuracoes/empresas_cd.php` |
| Empresas | `mod/configuracoes/empresas/` | `api/configuracoes/empresas.php` |
| Configurações de e-mail | `mod/configuracoes/configuracoes_email/` | `api/configuracoes/configuracoes_email.php` |

Empresas CD:

- ações `list`, `get`, `save` e `delete`;
- `Codigo` é informado ou calculado por `MAX(Codigo) + 1`;
- valida `NomeCD` e `Status`.

Empresas:

- ações `list`, `get`, `save` e `delete`;
- `Codigo` é informado ou calculado por `MAX(Codigo) + 1`;
- valida CD, Nome, Fantasia, CNPJ e Status;
- valida CNPJ pelo dígito verificador;
- normaliza CNPJ, IE, CEP, IBGE, DDD e telefones para dígitos;
- valida CEP com 8 dígitos, IBGE com 7 dígitos, DDD com 2 dígitos e UF válida;
- detecta se a coluna `ibge` existe antes de consultar ou persistir;
- usa ViaCEP no frontend para auxiliar o preenchimento de endereço.

Configurações de e-mail:

- ações `list`, `get`, `save` e `delete`;
- persiste na tabela `config_email`;
- usa `cd_id`, `empresa_id`, `NomeConta`, `Habilitado`, `Servidor`, `Porta`, `ModoAutenticado`, `ModoSSL`, `Email`, `Senha` e `Status`;
- é usada pelo envio de propostas de compra.

### 6.3 Compras

| Arquivo | Responsabilidade |
| --- | --- |
| `mod/compras/cp_compras_lista.php` | Pesquisa e lista pedidos de compra. |
| `mod/compras/cp_compras_form.php` | Cabeçalho, itens, tamanhos, cores, rateio, fotos, logs e workflow. |
| `api/compras/cp_compras.php` | API principal de compras. |
| `api/compras/cp_compras_pdf.php` | Gera PDF completo do pedido em A4 paisagem. |

#### Ações da API de compras

| Ação | Comportamento |
| --- | --- |
| `options` | Pesquisa CDs, empresas, fornecedores e referências para Select2. |
| `defaults` | Retorna CD/empresa automaticamente quando existe apenas um registro. |
| `list` | Lista até 200 pedidos por número, status, localização, fornecedor, empresa ou CD. |
| `get` | Carrega cabeçalho, itens, tamanhos, cores, rateios, indicadores de fotos e último log de cor. |
| `referencia` | Carrega referência do fornecedor a partir de `pf_colecao`, com tamanhos e cores. |
| `save` | Insere ou atualiza pedido, itens, tamanhos, cores e rateios em transação. |
| `delete` | Exclui pedido editável e seus filhos. |
| `fotos_list` | Lista fotos KidStok em `cp_compras_fotos_ks`. |
| `fotos_fornecedor_list` | Lista fotos do fornecedor em `cp_compras_fotos`. |
| `fotos_upload` | Recebe upload. Para origem padrão `kidstok`, grava em `cp_compras_fotos_ks`; origem `fornecedor` existe no contrato, mas é bloqueada pela regra de mutabilidade. |
| `fotos_delete` | Exclui foto. Fotos do fornecedor são bloqueadas para exclusão pela tela interna. |
| `cor_log_ultimo` | Retorna o último log da cor do pedido, comparando quantidade e preços. |
| `enviar_proposta` | Envia e-mail, publica o pedido, muda localização para `Fornecedor` e incrementa iteração. |
| `aprovar` | Aprova pedido publicado; pode aprovar direto ou colocar em aguardando foto do fornecedor. |
| `recusar` | Recusa pedido publicado após interação com fornecedor, exige motivo e devolve para `KidStok`. |

#### Estrutura funcional do pedido

O pedido é organizado nesta hierarquia:

```text
cp_compras
  -> cp_compras_itens
       -> cp_compras_itens_tamanhos
            -> cp_compras_itens_cores
       -> cp_compras_itens_rateios
```

O frontend apresenta os itens em accordions. Cada item contém tamanhos, cada tamanho contém cores, e o rateio percentual é aplicado por cor no item quando informado.

Regras de gravação e validação:

- CD, empresa, fornecedor e data do pedido são obrigatórios;
- o frontend exige ao menos um item confirmado;
- uma referência não pode aparecer mais de uma vez no mesmo pedido;
- item ativo deve ter ao menos um tamanho ativo;
- tamanho ativo deve ter nome, quantidade total maior que zero e ao menos uma cor ativa;
- tamanho duplicado no mesmo item é bloqueado;
- cor duplicada no mesmo tamanho é bloqueada;
- percentual de rateio deve estar entre 0% e 100%;
- se algum percentual for informado, o total do rateio deve fechar 100%;
- os tamanhos que participam do rateio devem ter o mesmo conjunto de cores;
- o percentual de uma mesma cor deve ser igual em todos os tamanhos que participam do rateio;
- a soma das quantidades das cores deve bater com `qtde_total` do tamanho;
- quantidades zeradas inativam cores automaticamente;
- tamanho sem cor ativa ou com quantidade total zero é inativado;
- item sem tamanho ativo é inativado;
- item ou tamanho inativo zera seus totais de quantidade e valor;
- somente itens/tamanhos/cores ativos entram nas validações de quantidade e rateio;
- o total do pedido é recalculado no servidor pela soma dos totais das cores ativas;
- registros existentes são atualizados; registros removidos da hierarquia são excluídos;
- datas de entrega vazias nos tamanhos são gravadas como `NULL`, sem assumir a data do item nem a data do pedido.

#### Status oficiais de compras

`cp_compras.status_id` referencia `cp_compras_status.id`. O campo textual `Sts` ainda aparece em respostas e HTML para manter compatibilidade com o frontend, mas o código atual consulta e persiste por `status_id`.

| id | `descricao_compras` | `descricao_portal` | Uso |
| --- | --- | --- | --- |
| 0 | Aberto | Aberto | Pedido em edição. |
| 1 | Aprovado Aguardando Foto Fornecedor | Aprovado Aguardando Foto Fornecedor | Pedido aprovado comercialmente, aguardando fotos. |
| 2 | Aprovado | Aprovado | Pedido aprovado. |
| 3 | Recusado | Recusado | Pedido recusado com motivo. |

O catálogo de status é garantido por `cp_ensure_status_catalog()`, que faz upsert dos IDs 0 a 3. Isso corrige textos divergentes nos IDs canônicos sem remover linhas extras.

Regras de status, localização e workflow:

- pedidos novos entram como `Aberto`, `Publicado = 0` e `Localizacao = KidStok`;
- pedido localizado em `Fornecedor` não permite edição, exclusão, aprovação ou recusa pela tela interna;
- pedido `Aprovado` ou `Recusado` fica somente para visualização e impressão;
- pedido `Aprovado Aguardando Foto Fornecedor` não permite edição do pedido;
- se `Aprovado Aguardando Foto Fornecedor` estiver em `KidStok`, o formulário pode exibir `Enviar Fornecedor`;
- aprovação exige pedido publicado;
- recusa exige pedido publicado, iteração maior que zero e motivo;
- `enviar_proposta` usa `config_email`, `urls_allop` com módulo `apPF` e usuários ativos do fornecedor em `pf_usuarios`/`pf_usuario_fornecedor`;
- o e-mail é enviado em texto puro e HTML pelo cliente SMTP próprio;
- localizações válidas no fluxo atual são `KidStok` e `Fornecedor`;
- a localização não deve ser concatenada ao status.

#### Fotos

O banco de fotos é acessado por `db_fotos()`.

| Tabela | Origem | Uso na tela interna |
| --- | --- | --- |
| `cp_compras_fotos_ks` | KidStok | Listagem, upload e exclusão quando o pedido permite fotos KidStok. |
| `cp_compras_fotos` | Fornecedor | Listagem/visualização; upload e exclusão são bloqueados pela regra interna. |

Regras atuais:

- fotos são armazenadas em Base64;
- as fotos são relacionadas por pedido, referência do fornecedor, fornecedor e sequência;
- não há chave estrangeira entre o banco principal e o banco de fotos;
- a flag `cp_compras_itens.Foto` é sincronizada pela contagem de fotos KidStok;
- o formulário mostra indicadores separados para fotos KidStok e fotos Fornecedor;
- fotos do fornecedor são consideradas para definir se um pedido aguardando foto pode avançar para `Aprovado`;
- o modal de fotos altera título, listagem e permissão conforme a origem (`kidstok` ou `fornecedor`).

#### PDF

`api/compras/cp_compras_pdf.php`:

- exige sessão por `require_login()`;
- usa Dompdf com fonte DejaVu Sans;
- gera A4 paisagem;
- não permite recursos remotos (`isRemoteEnabled = false`);
- exibe dados do cabeçalho, auditoria, status, localização, itens, tamanhos, cores, preços, markups e resumo de rateio;
- abre o PDF no navegador com `Attachment = false`.

### 6.4 Dashboard

`dashboard.php` exibe:

- card de pedidos abertos;
- card de pedidos aprovados;
- card de pedidos aprovados aguardando foto do fornecedor;
- card de pedidos recusados;
- card de total geral;
- gráfico de barras por status;
- donut financeiro;
- grid dos últimos 10 pedidos.

Detalhes:

- os status usam os IDs 0, 1, 2 e 3 de `cp_compras_status`;
- os títulos dos cards vêm de `descricao_compras`, com fallback em texto padrão;
- cada card mostra quantidade e valor total em reais;
- a grid usa botão de edição apenas para pedido aberto e editável;
- pedidos fechados, aguardando foto ou localizados em `Fornecedor` usam botão de visualização.

## 7. Autenticação, sessão, menu e permissões

Sessão:

- a sessão guarda `id`, `nome`, `login` e `perfil_id`;
- páginas internas chamam `require_login()`;
- APIs internas normalmente chamam `api_require_login()`;
- login aceita senha com hash e senha em texto puro legado;
- novas senhas são gravadas com `password_hash()`.

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
- `Principal` e `Sair` não vêm do banco no layout atual;
- o link da logo abre `dashboard.php`;
- o link `Sair` é fixo no header.

IDs de menu previstos pelo seed:

| ID | Menu |
| --- | --- |
| 10 | Configurações |
| 20 | Produtos |
| 30 | Cadastros |
| 40 | Compras |
| 50 | Operacional |
| 60 | Gerencial |
| 90 | Segurança |
| 98 | Ajuda |

## 8. Banco de dados

### 8.1 Banco principal

`config/database.php` aponta o sistema para o banco principal de desenvolvimento. Credenciais existem no arquivo de configuração, mas não devem ser copiadas para novas documentações, commits ou mensagens.

`banco.sql` contém:

- 240 tabelas;
- 67 triggers;
- dump estrutural, sem dados.

Principais grupos de tabelas:

| Domínio | Tabelas principais |
| --- | --- |
| Segurança | `seg_menu`, `seg_aplicacoes`, `seg_perfil`, `seg_perfil_permissoes`, `seg_usuarios`, `seg_usuarios_permissoes` |
| Compras | `cp_compras`, `cp_compras_status`, `cp_compras_emails`, `cp_compras_itens`, `cp_compras_itens_tamanhos`, `cp_compras_itens_cores`, `cp_compras_itens_rateios` |
| Logs de compras | `cp_compras_itens_log`, `cp_compras_itens_tamanhos_log`, `cp_compras_itens_cores_log` |
| Configurações | `empresas`, `empresas_cd`, `config_email`, `urls_allop`, `situacao` |
| Portal fornecedor | `pf_colecao`, `pf_usuarios`, `pf_usuarios_copy`, `pf_usuario_fornecedor` |
| Catálogo/ERP legado | tabelas `produtos*`, `KidStok`, `cfops`, `cests_ncm`, `st_*`, `compras*`, `nfe_*`, `romaneios_*`, `fechamento*`, `provisorios*`, `transportadoras*`, `veiculos*` e auxiliares |

Triggers relevantes para compras:

- `cp_compras_itens_after_update`;
- `cp_compras_itens_cores_after_update`;
- `cp_compras_itens_tamanhos_after_update`.

Essas triggers gravam snapshots em tabelas de log usando os dados antigos (`OLD`) e consultam `Iteracao`/`Localizacao` no pedido.

### 8.2 Banco de fotos

`banco_fotos.sql` contém duas tabelas:

- `cp_compras_fotos`;
- `cp_compras_fotos_ks`.

As tabelas têm estrutura equivalente para armazenar fotos em Base64, com campos de pedido, referência do fornecedor, fornecedor, sequência e foto.

## 9. Seed de aplicações

`scripts/seed_aplicacoes.php`:

- garante o perfil `Administrador`;
- remove a aplicação antiga `dashboard.php` do menu;
- remove menus vazios `Principal` e `Sair`;
- renomeia `Seguranca` para `Segurança` quando aplicável;
- cria ou atualiza menus canônicos;
- corrige rotas antigas de e-mail;
- cadastra aplicações existentes;
- concede todas as permissões ao Administrador quando a permissão ainda não existe;
- cria o usuário `admin` apenas se ele ainda não existir;
- cria tabelas auxiliares com `CREATE TABLE IF NOT EXISTS`;
- recria triggers de log de compras com `DROP TRIGGER IF EXISTS` + `CREATE TRIGGER`;
- imprime `Seed executado com sucesso.`.

Aplicações registradas pelo seed:

- Usuarios;
- Perfis;
- Aplicacoes;
- Perfil x Aplicacoes;
- Usuario x Aplicacoes;
- Empresas CD;
- Empresas;
- E-mail;
- Pedidos de Compra.

O seed é parcialmente idempotente, mas executa DDL e altera dados de menu/permissões. Deve ser usado com backup e consciência do ambiente.

## 10. Padrões para novas implementações

Cabeçalho obrigatório em aplicações:

```php
/*
    Autor: Claudio Barto
    Data : DD/MM/AAAA
*/
$aplicacao_nome = "nome_do_arquivo.php";
$aplicacao_descricao = "Descrição objetiva da aplicação.";
```

Telas:

- criar telas dentro de `mod/<modulo>/`;
- usar sufixos `_lista.php` e `_form.php`;
- chamar `require_login()` antes de renderizar conteúdo interno;
- usar `render_header()` e `render_footer()`;
- usar APIs PHP para acessar banco;
- não acessar banco diretamente a partir de tela quando for operação de CRUD;
- usar Select2 em filtros e relacionamentos pesquisáveis;
- usar `card-slim`, `table-custom`, `grid-filter` e `filter-inline`;
- colocar Voltar junto ao título e Salvar no rodapé do formulário;
- bloquear o botão Salvar durante requisições;
- usar botões com classes globais (`btn-new`, `btn-save`, `btn-sync`, `btn-edit`, `btn-view`, `btn-delete`, `btn-print`, `btn-photo`);
- manter responsividade em celular, tablet e desktop;
- cadastrar novas telas no seed.

APIs:

- criar endpoints em `api/<modulo>/`;
- incluir `api/bootstrap.php`;
- exigir sessão com `api_require_login()` nas APIs internas;
- ler entrada por `request_data()`;
- responder por `api_response()`;
- usar prepared statements;
- validar dados também no servidor;
- usar transação em operações compostas;
- evitar expor mensagens sensíveis de infraestrutura.

Frontend:

- manter Bootstrap, jQuery e Select2 locais;
- centralizar estilos em `assets/css/style.css`;
- centralizar comportamentos compartilhados em `assets/js/app.js`;
- preservar Poppins como fonte visual enquanto a dependência externa existir;
- manter fundo `#f8f9fa`, cards brancos e laranja `#ff4500` como destaque;
- manter tabelas responsivas em formato de cards no mobile;
- evitar JavaScript inline extenso em telas novas.

Banco:

- confirmar nomes e tipos no schema real antes de programar;
- usar `db()` para dados principais;
- usar `db_fotos()` exclusivamente para fotos;
- não documentar credenciais;
- evitar DDL em rotinas de aplicação;
- atualizar `banco.sql` e `banco_fotos.sql` quando uma mudança de schema for aprovada;
- preservar nomes legados quando a migração não fizer parte do escopo.

## 11. Componentes visuais internos

| Componente | Classes/funções | Uso |
| --- | --- | --- |
| Layout base | `.app-shell`, `.app-content`, `.page-heading` | Estrutura comum das telas. |
| Menu | `menu_items()`, `menu_icon()`, `.menu-main-link`, `.menu-svg` | Menu por perfil com ícones SVG inline. |
| Cards | `.card-slim`, `.dashboard-tile`, `.dashboard-chart-card` | Formulários, dashboards e painéis. |
| Grids | `.table-custom`, `.grid-shell`, `.grid-filter`, `.filter-inline` | Listagens responsivas. |
| Botões | `.btn-new`, `.btn-save`, `.btn-sync`, `.btn-edit`, `.btn-view`, `.btn-delete`, `.btn-print`, `.btn-photo` | Ações padronizadas com ícones por CSS. |
| Alertas | `appAlert()`, `appOkAlert()`, `appConfirm()` | Mensagens e confirmação via Bootstrap Modal/Alert. |
| Salvamento | `setFormSaving()` | Bloqueia botão e mostra processamento. |
| Status | `.badge-status-*`, `.cp-localizacao-badge`, `.dashboard-grid-badge` | Badges de status, localização e publicação. |
| Pedido | `.cp-pedido-status-hero`, `.cp-compra-item`, `.cp-compra-tamanho`, `.cp-compra-cor` | Status destacado e hierarquia de compra. |
| Rateio | `#cp-rateio-modal`, `.cp-rateio-*` | Percentuais por cor e quantidades por tamanho. |
| Fotos | `#cp-fotos-modal`, `.cp-fotos-grid`, `.cp-foto-card` | Listagem, upload, exclusão e preview de imagens. |
| Log de cor | `#cp-cor-log-modal`, `.cp-preco-alterado-*` | Comparação de quantidade/preço com último log. |

## 12. Pontos de atenção conhecidos

1. **Permissão incompleta nas APIs:** o menu usa `visualizar` por perfil, mas as APIs não validam permissões específicas de inserir, editar, excluir, imprimir, exportar ou processar.
2. **Permissões por usuário sem efeito no menu:** `seg_usuarios_permissoes` existe e possui telas, mas não participa da montagem do menu.
3. **Dashboard sem filtro por permissão:** os indicadores de compras ainda não variam conforme permissões do usuário.
4. **Troca de senha admin pública:** `api/seguranca/admin_senha.php` não chama `api_require_login()`.
5. **Grafias legadas:** `seg_usuarios_permissoes` usa `edtiar` e `imprirmir` no código.
6. **Credenciais no código:** `config/database.php` contém constantes versionadas; o recomendado é migrar para variáveis de ambiente.
7. **Erros expostos:** várias APIs retornam `Throwable::getMessage()` diretamente ao cliente.
8. **CSRF ausente:** não há token CSRF nos formulários ou ações mutáveis.
9. **Senha legada aceita:** o login aceita texto puro para compatibilidade.
10. **DDL no seed:** `seed_aplicacoes.php` cria tabelas auxiliares e recria triggers; isso deve ser executado com backup.
11. **Transação entre bancos:** operações com fotos podem envolver banco principal e banco de fotos sem atomicidade distribuída.
12. **Dependências externas:** ViaCEP e Google Fonts são dependências externas atuais.
13. **`ibge` opcional em Empresas:** a API detecta a coluna; se ausente, ignora a persistência.
14. **Referências legadas ausentes no dump:** foram identificadas referências para tabelas como `romaneios_tabela_preco`, `tbestados`, `tbgrupos`, `tbmarcas`, `tbmedidas` e `tbmodelos`, que não aparecem como tabelas base no `banco.sql`.
15. **`pf_usuarios_copy`:** tabela presente no dump sem referência no código atual.
16. **Status autocorrigidos por upsert:** `cp_ensure_status_catalog()` regrava os textos canônicos dos IDs 0 a 3 em `cp_compras_status`; alterações manuais nesses IDs podem ser sobrescritas.

## 13. Validação antes de entregar alterações

Para cada PHP alterado:

```bash
php -l caminho/do/arquivo.php
```

Checklist:

- conferir rotas relativas quando a aplicação roda em subpasta;
- testar sessão expirada e JSON de erro;
- testar lista, filtro, inclusão, edição e exclusão;
- testar layout em celular, tablet e desktop;
- validar regras no frontend e na API;
- conferir perfil Administrador e menu após mudanças no seed;
- testar rollback de operações compostas;
- conferir banco principal e banco de fotos quando houver fotos;
- revisar console do navegador e log do PHP;
- não sobrescrever mudanças fora do escopo.

## 14. Regra de manutenção deste documento

Atualizar este arquivo sempre que houver:

- novo módulo, tela ou endpoint;
- alteração de menu ou permissão;
- mudança no workflow de compras;
- nova tabela, coluna, trigger ou conexão;
- atualização de biblioteca;
- mudança relevante no padrão visual;
- correção de ponto de atenção conhecido.

A documentação deve sempre descrever o comportamento efetivamente presente no código. Requisitos futuros devem ficar marcados como planejados, não como implementados.
