# ALLOP — Arquitetura e padrões do sistema

**Documento-base:** 01/06/2026
**Última revisão do código:** 02/07/2026
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
| `dashboard.php` | Painel inicial autenticado. Atualmente contém atalhos estáticos de Segurança. |
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

Principais ações da API:

| Ação | Comportamento |
| --- | --- |
| `list` | Lista pedidos com CD, empresa, fornecedor, localização, total e status. |
| `get` | Carrega cabeçalho, itens, detalhes, percentuais e indicadores de fotos. |
| `save` | Insere ou atualiza o pedido e recria seus itens e detalhes em transação. |
| `delete` | Exclui um pedido quando ele não está com o fornecedor. |
| `options` | Pesquisa CD, empresa, fornecedor ou referência. |
| `defaults` | Retorna CD/empresa automaticamente quando existe somente um registro. |
| `referencia` | Carrega uma referência e suas combinações de tamanho/cor de `pf_colecao`. |
| `fotos_list` | Lista fotos da KidStok em `cp_compras_fotos_ks`. |
| `fotos_fornecedor_list` | Lista fotos do fornecedor em `cp_compras_fotos`. |
| `fotos_upload` / `fotos_delete` | Mantém fotos da KidStok e sincroniza o indicador do item. |
| `enviar_proposta` | Envia e-mail, publica o pedido e transfere a localização para `Fornecedor`. |
| `aprovar` | Marca como `Aprovado` e devolve a localização para `KidStok`. |
| `recusar` | Marca como `Recusado`, registra motivo e devolve para `KidStok`. |

Regras atuais de compras:

- CD, empresa, fornecedor e data do pedido são obrigatórios;
- o frontend exige pelo menos um item confirmado;
- uma referência não pode aparecer mais de uma vez no mesmo pedido;
- percentuais positivos de um item devem totalizar 100%;
- o total é recalculado a partir de quantidade × preço proposto;
- itens e detalhes antigos são excluídos e recriados ao editar;
- pedido localizado no `Fornecedor` fica somente para visualização e não pode ser editado, excluído ou ter fotos KidStok alteradas;
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

Tabelas referenciadas pelo código ou por `banco.sql`:

| Domínio | Tabelas |
| --- | --- |
| Segurança | `seg_menu`, `seg_aplicacoes`, `seg_perfil`, `seg_perfil_permissoes`, `seg_usuarios`, `seg_usuarios_permissoes` |
| Configurações | `empresas_cd`, `empresas`, `config_email`, `configuracoes_email` |
| Compras | `cp_compras`, `cp_compras_itens`, `cp_compras_itens_detalhe`, `cp_compras_itens_percentuais`, `cp_compras_itens_detalhe_log`, `cp_compras_emails` |
| Catálogo/fornecedor | `produtos_fornecedor`, `pf_colecao`, `pf_usuarios`, `pf_usuario_fornecedor` |

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
- cria tabelas auxiliares com `CREATE TABLE IF NOT EXISTS`.

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

Estes itens foram encontrados na revisão de 02/07/2026 e não foram corrigidos nesta atualização documental:

1. **Permissão incompleta:** o menu usa apenas permissões do perfil. `seg_usuarios_permissoes` não participa da montagem do menu, e as APIs não validam permissões de inserir, editar, excluir ou processar; validam apenas a sessão.
2. **Dashboard estático:** os cards do dashboard não são filtrados por permissão.
3. **Alteração de senha admin:** `api/seguranca/admin_senha.php` não chama `api_require_login()`.
4. **Coluna divergente:** `banco.sql` define `seg_usuarios_permissoes.editar`, mas `api/seguranca/crud.php` usa `edtiar`. A coluna `imprirmir` está grafada dessa forma tanto no schema quanto no código.
5. **Tabela de e-mail divergente:** o módulo de Configurações usa `configuracoes_email`; o envio de propostas e `banco.sql` usam `config_email`.
6. **Schema de empresas incompleto:** `banco.sql` não contém a criação de `empresas` e `empresas_cd`. O seed as cria, mas a API de empresas também usa a coluna `ibge`, ausente na definição criada pelo seed.
7. **Regra e implementação do seed:** a regra histórica dizia que tabelas seriam criadas manualmente, porém o seed atual executa quatro `CREATE TABLE IF NOT EXISTS`.
8. **SQL duplicado:** `banco.sql` contém definições repetidas de `cp_compras_itens_detalhe_log`, `cp_compras_emails` e `cp_compras_itens_percentuais`, além de trecho de trigger que precisa ser revisado antes de uma importação limpa.
9. **Credenciais no código:** as conexões usam constantes versionadas em `config/database.php`; o recomendado é usar variáveis de ambiente.
10. **Erros de API:** várias APIs devolvem diretamente `Throwable::getMessage()`, o que pode revelar detalhes do banco.
11. **CSRF:** não há token CSRF nos formulários ou ações mutáveis.
12. **Senha legada:** o login aceita senha em texto puro para compatibilidade, embora novas senhas sejam salvas com hash.
13. **Transação entre bancos:** upload de fotos abre transações separadas nos dois bancos; não existe atomicidade distribuída caso apenas um commit conclua.
14. **Dependências externas:** a busca de CEP usa ViaCEP pelo navegador e o CSS importa a fonte Poppins do Google Fonts. São as exceções atuais à regra de assets locais.

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
