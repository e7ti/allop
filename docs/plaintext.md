# ALLOP — Arquitetura e padrões do sistema

**Documento-base:** 01/06/2026
**Última revisão do código:** 10/07/2026
**Última revisão do `banco.sql`:** 14/07/2026
**Escopo revisado:** aplicação PHP, APIs, banco principal, banco de fotos, seed, assets e módulos existentes.

## 1. Objetivo

Este documento descreve o estado atual do sistema Allop e os padrões que devem ser preservados em novas implementações.

As informações abaixo foram conferidas diretamente no código. Quando houver divergência entre uma regra planejada e a implementação atual, a divergência está registrada em **Pontos de atenção conhecidos**.

## 2. Visão geral

O Allop é uma aplicação web responsiva em PHP puro, com:

- renderização das telas no servidor;
- sessão PHP para autenticação;
- PDO para acesso ao MySQL;
- APIs PHP que respondem JSON;
- Bootstrap 5.3.6, jQuery 3.7.1 e Select2 4.1.0-rc.0 distribuídos localmente;
- CSS e JavaScript compartilhados;
- menu dinâmico baseado no perfil do usuário;
- bancos separados para dados operacionais e fotos.

Fluxo principal:

```text
index.php
  ├─ usuário sem sessão → login.php → api/seguranca/auth.php
  └─ usuário autenticado → dashboard.php
                               └─ telas em mod/
                                    └─ chamadas AJAX para api/
                                         ├─ db()       → banco principal
                                         └─ db_fotos() → banco de fotos
```

## 3. Estrutura do projeto

| Caminho | Responsabilidade |
| --- | --- |
| `index.php` | Direciona para login ou dashboard conforme a sessão. |
| `login.php` | Tela pública de autenticação. |
| `logout.php` | Encerra a sessão. |
| `dashboard.php` | Painel inicial autenticado com indicadores e gráficos de pedidos de compra. |
| `alterar_senha_admin.php` | Tela específica para alteração da senha do usuário `admin`. |
| `config/` | Configuração geral e conexões PDO. |
| `includes/` | Autenticação, permissões, layout e envio SMTP. |
| `mod/` | Telas dos módulos. |
| `api/` | Endpoints JSON usados pelas telas. |
| `assets/css/` | Estilo global. |
| `assets/js/` | Comportamento global e regras das telas. |
| `assets/vendor/` | Bootstrap, jQuery e Select2 locais. |
| `assets/img/` | Logos e imagens do sistema. |
| `scripts/` | Rotinas administrativas, incluindo o seed. |
| `docs/` | Documentação e registros auxiliares. |
| `banco.sql` | Referência do banco principal. |
| `banco_fotos.sql` | Referência do banco de fotos. |

### Arquivos compartilhados centrais

| Arquivo | Função |
| --- | --- |
| `config/app.php` | Define nome da aplicação, caminho-base, `app_url()` e escape HTML com `h()`. |
| `config/database.php` | Define `db()` e `db_fotos()`, ambas conexões PDO com prepared statements nativos. |
| `includes/auth.php` | Inicializa sessão e fornece login, logout, usuário atual e proteção de páginas. |
| `includes/permissions.php` | Consulta as aplicações visíveis para o perfil e monta os grupos do menu. |
| `includes/layout.php` | Renderiza header, menu, conteúdo, footer e inclui os assets locais. |
| `includes/smtp_mailer.php` | Cliente SMTP implementado com socket, STARTTLS/SSL e autenticação opcional. |
| `api/bootstrap.php` | Inicialização comum das APIs, leitura da requisição e resposta JSON. |
| `assets/js/app.js` | CRUD genérico, Select2, validações, empresas, e-mail e todo o fluxo de compras. |
| `assets/css/style.css` | Tema, responsividade, cards, grids, formulários, botões e módulo de compras. |

## 4. Módulos implementados

### 4.1 Segurança

| Tela | API |
| --- | --- |
| `mod/seguranca/usuarios_lista.php` / `usuarios_form.php` | `api/seguranca/crud.php?entity=usuarios` |
| `mod/seguranca/perfis_lista.php` / `perfis_form.php` | `api/seguranca/crud.php?entity=perfis` |
| `mod/seguranca/aplicacoes_lista.php` / `aplicacoes_form.php` | `api/seguranca/crud.php?entity=aplicacoes` |
| `mod/seguranca/perfil_aplicacoes_lista.php` / `perfil_aplicacoes_form.php` | `api/seguranca/perfil_aplicacoes.php` |
| `mod/seguranca/usuarios_permissoes_lista.php` / `usuarios_permissoes_form.php` | `api/seguranca/crud.php?entity=usuarios_permissoes` |

APIs auxiliares:

- `api/seguranca/auth.php`: valida usuário ativo e senha;
- `api/seguranca/options.php`: fornece opções remotas para Select2;
- `api/seguranca/admin_senha.php`: altera a senha do login `admin`;
- `api/seguranca/crud.php`: CRUD genérico das entidades de Segurança;
- `api/seguranca/perfil_aplicacoes.php`: manutenção em lote das permissões do perfil.

As senhas novas são gravadas com `password_hash()`. O login aceita tanto hash quanto texto puro legado.

### 4.2 Configurações

| Funcionalidade | Telas | API |
| --- | --- | --- |
| Empresas CD | `mod/configuracoes/empresas_cd/` | `api/configuracoes/empresas_cd.php` |
| Empresas | `mod/configuracoes/empresas/` | `api/configuracoes/empresas.php` |
| Configurações de e-mail | `mod/configuracoes/configuracoes_email/` | `api/configuracoes/configuracoes_email.php` |

Empresas possuem validações de CNPJ, CEP, código IBGE, UF, DDD e telefones. A tela consulta o serviço ViaCEP diretamente no navegador para preencher endereço.

### 4.3 Compras

| Arquivo | Responsabilidade |
| --- | --- |
| `mod/compras/cp_compras_lista.php` | Pesquisa e lista até 200 pedidos. |
| `mod/compras/cp_compras_form.php` | Cabeçalho, itens, variações, rateio, fotos e workflow do pedido. |
| `api/compras/cp_compras.php` | Regras de consulta, persistência, fotos, e-mail e workflow. |
| `api/compras/cp_compras_pdf.php` | Gera o PDF completo do pedido em A4 paisagem. |

O formulário organiza os dados em accordions hierárquicos: cada item contém
seus tamanhos, e cada tamanho contém suas cores. O percentual é informado em
cada cor, com totalizador e validação de 100% dentro do respectivo tamanho.

Principais ações da API:

| Ação | Comportamento |
| --- | --- |
| `list` | Lista pedidos com CD, empresa, fornecedor, localização, total e status. |
| `get` | Carrega cabeçalho e a hierarquia de itens, tamanhos, cores, rateios e indicadores de fotos. |
| `save` | Insere ou atualiza o pedido e mantém itens, tamanhos, cores e rateios por update quando já existem. |
| `delete` | Exclui um pedido quando ele não está com o fornecedor. |
| `options` | Pesquisa CD, empresa, fornecedor ou referência. |
| `defaults` | Retorna CD/empresa automaticamente quando existe somente um registro. |
| `referencia` | Carrega uma referência e suas combinações de tamanho/cor de `pf_colecao`. |
| `fotos_list` | Lista fotos da KidStok em `cp_compras_fotos_ks`. |
| `fotos_fornecedor_list` | Lista fotos do fornecedor em `cp_compras_fotos`. |
| `fotos_upload` / `fotos_delete` | Mantém fotos da KidStok e sincroniza o indicador do item. |
| `enviar_proposta` | Envia e-mail, publica o pedido e transfere a localização para `Fornecedor`. |
| `aprovar` | Aprova somente pedido publicado, devolve a localização para `KidStok` e marca como `Aprovado` ou `Aprovado Aguardando Foto Fornecedor` conforme fotos do fornecedor. |
| `recusar` | Marca como `Recusado`, registra motivo e devolve para `KidStok`. |

O botão **Imprimir PDF** é exibido em pedidos já gravados. O relatório contém dados do cabeçalho, auditoria, itens, tamanhos, cores, preços, markups e um resumo do rateio das cores de cada tamanho. A geração usa Dompdf instalado localmente pelo Composer.

Regras atuais de compras:

- CD, empresa, fornecedor e data do pedido são obrigatórios;
- o frontend exige pelo menos um item confirmado;
- uma referência não pode aparecer mais de uma vez no mesmo pedido;
- os percentuais das cores de cada tamanho devem totalizar 100%;
- itens, tamanhos e cores possuem status ativo/inativo;
- alterar o status do item aplica o mesmo status em cascata para seus tamanhos e cores;
- alterar o status do tamanho aplica o mesmo status em cascata para suas cores;
- tamanho inativo não exige cor ativa nem rateio de 100%, e tamanho ativo depende de pelo menos uma cor ativa;
- o total é recalculado a partir de quantidade × preço proposto;
- itens, tamanhos, cores e rateios existentes são atualizados ao editar; somente registros removidos da hierarquia são excluídos;
- pedido localizado no `Fornecedor` fica somente para visualização e impressão; não pode ser editado, excluído, aprovado, recusado nem ter fotos KidStok alteradas;
- pedido não publicado não pode ser aprovado;
- pedido aprovado sem fotos do fornecedor fica com status `Aprovado Aguardando Foto Fornecedor`;
- o envio de proposta usa a configuração ativa de `config_email` para o CD/empresa;
- os destinatários são usuários ativos de `pf_usuarios` vinculados ao fornecedor em `pf_usuario_fornecedor`;
- fotos são armazenadas em Base64 no banco de fotos.

## 5. Autenticação, menu e permissões

### Autenticação

- a sessão guarda `id`, `nome`, `login` e `perfil_id`;
- páginas internas chamam `require_login()`;
- APIs internas normalmente chamam `api_require_login()`;
- respostas de API seguem o formato `{"success": true|false, ...}`;
- falhas usam os códigos HTTP 401, 403, 404, 422 ou 500, conforme o caso.

### Menu

O menu é formado por:

- `seg_menu`: grupo principal;
- `seg_aplicacoes`: nome, rota, grupo e ordem;
- `seg_perfil_permissoes.visualizar`: define se a aplicação aparece para o perfil.

A consulta ordena por `seg_menu.id`, `seg_aplicacoes.ordem` e nome. Os grupos `Principal` e `Sair` não vêm do banco: a logo abre o dashboard e o link Sair é fixo no layout.

IDs previstos pelo seed:

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

Permissões cadastradas:

- visualizar;
- inserir;
- editar;
- excluir;
- imprimir;
- exportar;
- processar.

## 6. Bancos de dados

### 6.1 Banco principal

A configuração executada pelo sistema está em `config/database.php` e atualmente aponta para o banco **`allop_devel`**. Credenciais não devem ser copiadas para documentação, commits ou mensagens; a fonte atual é o arquivo de configuração e, idealmente, deve migrar para variáveis de ambiente.

O schema abaixo foi atualizado a partir do `banco.sql` em 14/07/2026. O arquivo
é um dump estrutural parcial do banco `allop_devel`, sem dados, com tabelas do
módulo Allop e algumas dependências de catálogo/produtos do ERP.

Tabelas presentes no `banco.sql`:

| Domínio | Tabelas |
| --- | --- |
| Segurança | `seg_menu`, `seg_aplicacoes`, `seg_perfil`, `seg_perfil_permissoes`, `seg_usuarios`, `seg_usuarios_permissoes` |
| Compras | `cp_compras`, `cp_compras_status`, `cp_compras_emails`, `cp_compras_itens`, `cp_compras_itens_log`, `cp_compras_itens_tamanhos`, `cp_compras_itens_tamanhos_log`, `cp_compras_itens_cores`, `cp_compras_itens_cores_log`, `cp_compras_itens_rateios` |
| Catálogo/fornecedor | `produtos`, `produtos_colecao`, `produtos_fornecedor`, `pf_colecao`, `pf_usuarios`, `pf_usuarios_copy`, `pf_usuario_fornecedor` |

`empresas`, `empresas_cd` e `urls_allop` deixaram de constar no `banco.sql`
nesta revisão, apesar de continuarem em uso ativo pelo código (módulo
Configurações e API de Compras). Ver item correspondente em **Pontos de
atenção conhecidos**.

O modelo registrado no arquivo organiza as variações de um item na hierarquia
`cp_compras_itens` → `cp_compras_itens_tamanhos` → `cp_compras_itens_cores`.
Cada registro de `cp_compras_itens_rateios` relaciona um tamanho a uma de suas
cores e armazena o percentual da quantidade destinado àquela combinação. Os
percentuais devem totalizar 100% dentro de cada tamanho, e a quantidade da cor
é calculada por `qtde_total do tamanho × percentual / 100`.

A tabela `cp_compras` ganhou a coluna `status_id`, com chave estrangeira para
a nova tabela `cp_compras_status` (`id`, `descricao_compras`,
`descricao_portal`), no lugar da antiga coluna `Sts` (varchar) que existia
nesta definição de tabela. O código (`api/compras/cp_compras.php`,
`dashboard.php`, `api/compras/cp_compras_pdf.php`) já persiste e consulta o
pedido por `status_id`; toda leitura faz `LEFT JOIN cp_compras_status` e expõe
o texto como `descricao_compras` (mantido com o nome de campo `Sts` na
resposta da API e no HTML, para preservar o contrato com o frontend). Ver
seed automático do catálogo em **Pontos de atenção conhecidos**.

Status oficiais de `cp_compras_status`:

| id | descricao_compras | descricao_portal | Uso no sistema |
| --- | --- | --- | --- |
| 0 | Aberto | Aberto | Pedido em aberto, ainda em andamento. |
| 1 | Aprovado Aguardando Foto Fornecedor | Aprovado Aguardando Foto Fornecedor | Pedido aprovado comercialmente, mas ainda aguardando fotos do fornecedor. |
| 2 | Aprovado | Aprovado | Pedido aprovado com fotos do fornecedor quando exigidas. |
| 3 | Recusado | Recusado | Pedido recusado, com motivo, data e usuário da recusa. |

Nas telas internas do sistema, incluindo `cp_compras_lista`, dashboard,
formulário e PDF, o status apresentado ao usuário deve ser sempre
`cp_compras_status.descricao_compras`. O campo `descricao_portal` é reservado
para o portal do fornecedor. A localização do pedido (`KidStok` ou
`Fornecedor`) deve aparecer somente nos campos/colunas de localização; ela não
deve ser concatenada ao status nem gerar rótulos como `Aberto Aguardando
KidStok` ou `Aberto Aguardando Fornecedor`.

As tabelas de log registram o snapshot anterior de itens, tamanhos e cores em
atualizações. Elas também armazenam `Iteracao` e `Localizacao` do pedido no
momento da alteração e agora possuem chave estrangeira `ON DELETE CASCADE`
para a tabela de origem (antes não havia esse vínculo):

| Tabela de log | Origem | Observação |
| --- | --- | --- |
| `cp_compras_itens_log` | `cp_compras_itens` | Alimentada quando mudam `total_qtde`, `Sts` ou `entrega`. |
| `cp_compras_itens_tamanhos_log` | `cp_compras_itens_tamanhos` | Alimentada a cada update do tamanho. |
| `cp_compras_itens_cores_log` | `cp_compras_itens_cores` | Alimentada quando mudam `Qtde`, `preco_proposta` ou `Sts`. |

Triggers presentes no `banco.sql`:

- `cp_compras_itens_after_update`;
- `cp_compras_itens_tamanhos_after_update`;
- `cp_compras_itens_cores_after_update`.

Nesta revisão, `cp_compras_itens_after_update` foi corrigido para gravar
`compras_itens_id` no log; antes gravava incorretamente o valor de origem na
coluna `id` (chave primária autoincrementada do próprio log).

O dump possui chaves estrangeiras para tabelas que não estão definidas no próprio
arquivo, pois pertencem ao schema legado ou não foram exportadas neste recorte:
`situacao`, `config_email`, `cests_ncm`, `cfops`, `empresas`, `empresas_cd`,
`produtos_grupos`, `produtos_caracteristicas`, `produtos_categorias`,
`produtos_composicoes`, `produtos_cor`, `produtos_generos`, `produtos_linhas`,
`produtos_local_fisico`, `produtos_tamanho`, `st_cofins`, `st_icms`, `st_ipi`,
`st_origem` e `st_pis`.

### 6.2 Banco de fotos

A conexão `db_fotos()` aponta para **`allop_devel_fotos`**.

| Tabela | Uso |
| --- | --- |
| `cp_compras_fotos` | Fotos recebidas do fornecedor; somente leitura no módulo atual. |
| `cp_compras_fotos_ks` | Fotos mantidas pela KidStok; leitura, inclusão e exclusão. |

As fotos são relacionadas por pedido, referência do fornecedor, fornecedor e sequência. Não há chave estrangeira entre os dois bancos.

## 7. Seed de aplicações

O script `scripts/seed_aplicacoes.php`:

- garante o perfil `Administrador`;
- cadastra ou atualiza menus e aplicações;
- concede todas as permissões ao Administrador quando ainda não existe registro;
- cria o usuário inicial `admin` somente se ele ainda não existir;
- remove rotas antigas de e-mail;
- remove as aplicações de `Principal` e `Sair`;
- cria tabelas auxiliares com `CREATE TABLE IF NOT EXISTS`;
- recria as triggers de log de itens, tamanhos e cores.

Aplicações registradas atualmente:

- Usuários;
- Perfis;
- Aplicações;
- Perfil x Aplicações;
- Usuário x Aplicações;
- Empresas CD;
- Empresas;
- E-mail;
- Pedidos de Compra.

O seed é idempotente na maior parte das operações, mas altera dados de menu e executa DDL. Deve ser executado conscientemente e com backup.

## 8. Padrões para novas implementações

### Cabeçalho PHP

Todo arquivo de aplicação deve declarar:

```php
/*
    Autor: Claudio Barto
    Data : DD/MM/AAAA
*/
$aplicacao_nome = "nome_do_arquivo.php";
$aplicacao_descricao = "Descrição objetiva da aplicação.";
```

### Telas

- manter telas dentro de `mod/<modulo>/`;
- usar os sufixos `_lista.php` e `_form.php`;
- chamar `require_login()` antes de renderizar conteúdo interno;
- usar `render_header()` e `render_footer()`;
- colocar o botão Voltar junto ao título e Salvar no rodapé do formulário;
- reutilizar `card-slim`, `table-custom`, `grid-filter` e `filter-inline`;
- usar Select2 nos filtros e relacionamentos pesquisáveis;
- exibir ações de grid com as classes globais de ícone;
- manter responsividade para celular, tablet e desktop;
- cadastrar novas telas no seed e conceder a permissão apropriada.

### APIs

- manter endpoints em `api/<modulo>/`;
- incluir `api/bootstrap.php`;
- exigir sessão com `api_require_login()` nas APIs internas;
- ler entrada por `request_data()`;
- responder somente por `api_response()`;
- usar prepared statements;
- validar dados também no servidor;
- envolver operações compostas em transação;
- não expor mensagens sensíveis de infraestrutura ao cliente.

### Frontend e visual

- não adicionar CDN; bibliotecas devem permanecer em `assets/vendor/`;
- centralizar estilos em `assets/css/style.css`;
- centralizar comportamento compartilhado em `assets/js/app.js`;
- manter Poppins como fonte visual do sistema;
- usar fundo de página `#f8f9fa`, cards brancos e laranja `#ff4500` como destaque;
- usar campos compactos, borda `#dee2e6` e foco laranja;
- preservar o comportamento mobile das tabelas em formato de cards;
- evitar JavaScript inline extenso em novas telas.

### Banco

- confirmar no schema real os nomes e tipos antes de programar;
- usar `db()` para dados principais e `db_fotos()` exclusivamente para fotos;
- não incluir credenciais em documentação nova;
- evitar DDL em rotinas de aplicação;
- atualizar `banco.sql`/`banco_fotos.sql` quando uma mudança manual de schema for aprovada;
- preservar os nomes legados quando a migração não fizer parte do escopo.

## 9. Pontos de atenção conhecidos

Estes itens foram encontrados nas revisões do código e do `banco.sql` de 10/07/2026 e não foram corrigidos nesta atualização documental:

1. **Permissão incompleta:** o menu usa apenas permissões do perfil. `seg_usuarios_permissoes` não participa da montagem do menu, e as APIs não validam permissões de inserir, editar, excluir ou processar; validam apenas a sessão.
2. **Dashboard sem filtro por permissão:** os indicadores de compras do dashboard ainda não variam conforme permissões do usuário.
3. **Alteração de senha admin:** `api/seguranca/admin_senha.php` não chama `api_require_login()`.
4. **Coluna divergente:** `banco.sql` define `seg_usuarios_permissoes.editar`, mas `api/seguranca/crud.php` usa `edtiar`. A coluna `imprirmir` está grafada dessa forma tanto no schema quanto no código.
5. **Tabelas de e-mail divergentes:** o módulo de Configurações usa `configuracoes_email`, o envio de propostas usa `config_email`, e o `banco.sql` atual apenas referencia `config_email` por FK em `cp_compras_emails`, sem criar `config_email` nem `configuracoes_email`.
6. **Tabela de situação ausente no dump:** `empresas.Status` e `empresas_cd.Status` referenciam `situacao.StsNome`, mas `situacao` não está criada no `banco.sql` atual.
7. **Tabelas de configuração fora do dump:** `banco.sql` atual não define mais `empresas`, `empresas_cd` nem `urls_allop`, embora as três sigam em uso ativo no código (módulo Configurações e o workflow de envio de proposta em Compras, que consulta `urls_allop` para localizar a URL do portal do fornecedor por CD/empresa).
8. **Coluna de empresa ausente:** a API de empresas usa a coluna `ibge`, mas ela não existe em `empresas` no `banco.sql` atual.
9. **Seed divergente do banco:** o seed cria algumas estruturas auxiliares com definições diferentes do `banco.sql`, incluindo tabelas de e-mail e `urls_allop`.
10. **Dependências de produtos incompletas no dump:** `produtos` possui FKs para várias tabelas legadas que não estão criadas no `banco.sql`, como `cfops`, `cests_ncm`, tabelas `produtos_*` e tabelas `st_*`.
11. **Credenciais no código:** as conexões usam constantes versionadas em `config/database.php`; o recomendado é usar variáveis de ambiente.
12. **Erros de API:** várias APIs devolvem diretamente `Throwable::getMessage()`, o que pode revelar detalhes do banco.
13. **CSRF:** não há token CSRF nos formulários ou ações mutáveis.
14. **Senha legada:** o login aceita senha em texto puro para compatibilidade, embora novas senhas sejam salvas com hash.
15. **Transação entre bancos:** upload de fotos abre transações separadas nos dois bancos; não existe atomicidade distribuída caso apenas um commit conclua.
16. **Dependências externas:** a busca de CEP usa ViaCEP pelo navegador e o CSS importa a fonte Poppins do Google Fonts. São as exceções atuais à regra de assets locais.
17. **Tabela de backup sem uso:** `pf_usuarios_copy` está presente no `banco.sql` como cópia estrutural de `pf_usuarios`, sem qualquer referência no código; aparenta ser um artefato de backup/teste esquecido no dump.
18. **Seed do catálogo de status:** `cp_compras_status` não tem dados no `banco.sql` (dump sem dados). `api/compras/cp_compras.php` semeia automaticamente as 4 linhas padrão (`Aberto`, `Aprovado Aguardando Foto Fornecedor`, `Aprovado`, `Recusado`, IDs 0-3) na primeira leitura se a tabela estiver vazia; se o ambiente já tiver essas linhas com texto diferente, `cp_status_id()` cai para `Aberto` como fallback.

## 10. Validação antes de entregar alterações

Para cada PHP alterado:

```bash
php -l caminho/do/arquivo.php
```

Checklist:

- conferir rotas relativas com a aplicação instalada em subpasta;
- testar sessão expirada e respostas JSON de erro;
- testar lista, filtro, inclusão, edição e exclusão;
- testar o layout em celular, tablet e desktop;
- validar regras no frontend e na API;
- verificar o perfil Administrador e o menu após mudanças no seed;
- testar rollback de operações compostas;
- conferir os dois bancos quando houver fotos;
- revisar o console do navegador e o log do PHP;
- não sobrescrever alterações alheias ao escopo.

## 11. Regra de manutenção deste documento

Atualizar este arquivo sempre que houver:

- novo módulo, tela ou endpoint;
- alteração de menu ou permissão;
- mudança no workflow de compras;
- nova tabela, coluna ou conexão;
- atualização de biblioteca;
- mudança relevante no padrão visual;
- correção de algum ponto de atenção conhecido.

A documentação deve descrever o comportamento efetivamente presente no código, deixando requisitos futuros claramente identificados como planejados.
