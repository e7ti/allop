# ALLOP - Padroes do Sistema

**Data:** 01/06/2026  
**Atualizacao visual:** 19/06/2026  
**Atualizacao bancos:** 19/06/2026

## Objetivo

Este documento serve como referencia para novas implementacoes no sistema Allop.

Antes de criar novas telas, APIs ou modulos, seguir estes padroes e respeitar a estrutura atual do projeto.

## Estrutura Atual do Sistema

O projeto esta organizado em PHP puro, com telas em `mod/`, APIs em `api/`, includes compartilhados em `includes/`, configuracoes em `config/`, assets em `assets/`, scripts auxiliares em `scripts/` e documentacao em `docs/`.

### Raiz do Projeto

| Caminho | Finalidade |
| --- | --- |
| `index.php` | Entrada principal do sistema. |
| `dashboard.php` | Dashboard acessado pela logo do header. |
| `login.php` | Tela de login. |
| `logout.php` | Encerramento de sessao. |
| `alterar_senha_admin.php` | Alteracao de senha administrativa. |
| `banco.sql` | Estrutura do banco principal. |
| `banco_fotos.sql` | Estrutura do banco separado de fotos. |
| `README.md` | Documentacao geral do projeto. |

### Configuracoes

| Caminho | Finalidade |
| --- | --- |
| `config/app.php` | Configuracoes gerais da aplicacao. |
| `config/database.php` | Configuracoes de conexao com banco de dados. |

### Includes

| Caminho | Finalidade |
| --- | --- |
| `includes/auth.php` | Funcoes de autenticacao. |
| `includes/layout.php` | Layout compartilhado, header, footer e componentes visuais. |
| `includes/permissions.php` | Controle de permissoes. |

### APIs

| Caminho | Finalidade |
| --- | --- |
| `api/bootstrap.php` | Bootstrap padrao das APIs. |
| `api/seguranca/auth.php` | API de autenticacao. |
| `api/seguranca/admin_senha.php` | API para senha administrativa. |
| `api/seguranca/crud.php` | CRUD generico de seguranca. |
| `api/seguranca/options.php` | Opcoes auxiliares para telas de seguranca. |
| `api/seguranca/perfil_aplicacoes.php` | Permissoes por perfil e aplicacao. |
| `api/configuracoes/empresas.php` | API de empresas. |
| `api/configuracoes/empresas_cd.php` | API de empresas/CD. |
| `api/configuracoes/configuracoes_email.php` | API de configuracoes de e-mail. |
| `api/compras/cp_compras.php` | API de compras. |

### Modulos e Telas

#### Seguranca

| Caminho | Finalidade |
| --- | --- |
| `mod/seguranca/usuarios_lista.php` | Lista de usuarios. |
| `mod/seguranca/usuarios_form.php` | Formulario de usuarios. |
| `mod/seguranca/usuarios_permissoes_lista.php` | Lista de permissoes por usuario. |
| `mod/seguranca/usuarios_permissoes_form.php` | Formulario de permissoes por usuario. |
| `mod/seguranca/perfis_lista.php` | Lista de perfis. |
| `mod/seguranca/perfis_form.php` | Formulario de perfis. |
| `mod/seguranca/perfil_aplicacoes_lista.php` | Lista de permissoes por perfil. |
| `mod/seguranca/perfil_aplicacoes_form.php` | Formulario de permissoes por perfil. |
| `mod/seguranca/aplicacoes_lista.php` | Lista de aplicacoes. |
| `mod/seguranca/aplicacoes_form.php` | Formulario de aplicacoes. |

#### Configuracoes

| Caminho | Finalidade |
| --- | --- |
| `mod/configuracoes/empresas/empresas_lista.php` | Lista de empresas. |
| `mod/configuracoes/empresas/empresas_form.php` | Formulario de empresas. |
| `mod/configuracoes/empresas_cd/empresas_cd_lista.php` | Lista de empresas/CD. |
| `mod/configuracoes/empresas_cd/empresas_cd_form.php` | Formulario de empresas/CD. |
| `mod/configuracoes/configuracoes_email/configuracoes_email_lista.php` | Lista de configuracoes de e-mail. |
| `mod/configuracoes/configuracoes_email/configuracoes_email_form.php` | Formulario de configuracoes de e-mail. |

#### Compras

| Caminho | Finalidade |
| --- | --- |
| `mod/compras/cp_compras_lista.php` | Lista de compras. |
| `mod/compras/cp_compras_form.php` | Formulario de compras. |

### Assets

| Caminho | Finalidade |
| --- | --- |
| `assets/css/style.css` | CSS principal do sistema. |
| `assets/js/app.js` | JavaScript principal do sistema. |
| `assets/img/Allop.png` | Imagem/logo Allop. |
| `assets/img/Allop.jpeg` | Imagem/logo Allop. |
| `assets/img/logo-allop.svg` | Logo Allop em SVG. |
| `assets/img/logo_kidstok.png` | Logo Kidstok. |
| `assets/vendor/bootstrap/css/bootstrap.min.css` | Bootstrap local. |
| `assets/vendor/bootstrap/js/bootstrap.bundle.min.js` | Bootstrap JS local. |
| `assets/vendor/jquery/jquery.min.js` | jQuery local. |
| `assets/vendor/select2/css/select2.min.css` | Select2 CSS local. |
| `assets/vendor/select2/js/select2.min.js` | Select2 JS local. |

### Scripts e Documentacao

| Caminho | Finalidade |
| --- | --- |
| `scripts/seed_aplicacoes.php` | Seed/cadastro das aplicacoes, menus e permissoes. |
| `docs/plaintext.txt` | Documento-base em texto puro. |
| `docs/plaintext.md` | Versao em Markdown dos padroes do sistema. |
| `docs/def.txt` | Documentacao auxiliar. |

## Referencia dos Bancos

Ler e considerar os arquivos da raiz do projeto como referencia de estrutura:

- `banco.sql`: estrutura do banco principal.
- `banco_fotos.sql`: estrutura do banco separado de fotos.

### Banco Principal

| Item | Valor |
| --- | --- |
| Server | `g.gcompdv.com.br` |
| Banco | `allop_new` |
| Usuario | `allopdevel` |
| Senha | `Allop@Devel##2022` |
| Arquivo de referencia | `banco.sql` |

Tabelas conhecidas no banco principal, conforme `banco.sql`:

- `config_email`
- `cp_compras`
- `cp_compras_emails`
- `cp_compras_itens`
- `cp_compras_itens_detalhe`
- `cp_compras_itens_detalhe_log`
- `cp_compras_itens_percentuais`
- `pf_colecao`
- `pf_usuario_fornecedor`
- `pf_usuarios`
- `produtos_fornecedor`
- `seg_aplicacoes`
- `seg_menu`
- `seg_perfil`
- `seg_perfil_permissoes`
- `seg_usuarios`
- `seg_usuarios_permissoes`

### Banco de Fotos

| Item | Valor |
| --- | --- |
| Server | `g.gcompdv.com.br` |
| Banco | `allop_devel_fotos` |
| Usuario | `allopdevel` |
| Senha | `Allop@Devel##2022` |
| Arquivo de referencia | `banco_fotos.sql` |

Tabelas conhecidas no banco de fotos, conforme `banco_fotos.sql`:

- `cp_compras_fotos`
- `cp_compras_fotos_ks`

### Regras de Acesso aos Bancos

- O sistema tem permissao para acessar os dois bancos.
- Usar a conexao principal para tabelas do banco principal.
- Usar conexao separada para tabelas de fotos.
- Fotos de compras KidStok usam `cp_compras_fotos_ks` no banco `allop_devel_fotos`.
- Nao procurar tabelas de fotos no banco principal.

## Estrutura Padrao do Projeto

- Projeto em PHP puro.
- Aplicacoes/telas devem ficar em `mod/`.
- Modulos devem ficar em subpastas dentro de `mod/`.
- APIs devem ficar em `api/`.
- Includes compartilhados ficam em `includes/`.
- Configuracoes ficam em `config/`.
- CSS, JS, imagens e bibliotecas ficam em `assets/`.
- Documentacao e acompanhamento ficam em `docs/`.

Exemplos de telas:

```text
mod/seguranca/usuarios_lista.php
mod/seguranca/usuarios_form.php
mod/configuracoes/empresas/empresas_lista.php
mod/configuracoes/empresas/empresas_form.php
```

Exemplos de APIs:

```text
api/seguranca/crud.php
api/seguranca/perfil_aplicacoes.php
api/configuracoes/empresas.php
```

## Cabecalho Obrigatorio das Aplicacoes PHP

Todas as aplicacoes PHP devem conter:

```php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "nome_do_arquivo.php";
$aplicacao_descricao = "Descricao do que faz a aplicacao.";
```

## Banco de Dados - Seguranca

Usar as tabelas do `banco.sql`:

- `seg_menu`
- `seg_aplicacoes`
- `seg_perfil`
- `seg_perfil_permissoes`
- `seg_usuarios`
- `seg_usuarios_permissoes`

Nao criar tabelas via codigo. O banco sera criado manualmente.

O sistema pode inserir, atualizar e excluir dados nas tabelas existentes.

## Banco de Dados - Configuracoes

Usar as tabelas do `banco.sql`:

- `empresas_cd`
- `empresas`
- `config_email`

Tabelas de configuracoes devem ter lista e formulario em:

```text
mod/configuracoes/nome_tabela/nome_tabela_lista.php
mod/configuracoes/nome_tabela/nome_tabela_form.php
```

APIs especificas de configuracoes devem ficar em:

```text
api/configuracoes/nome_tabela.php
```

Toda nova tela deve ser cadastrada no `scripts/seed_aplicacoes.php`.

O seed deve:

- Criar/atualizar a aplicacao em `seg_aplicacoes`.
- Criar/atualizar menu quando necessario.
- Dar permissao ao perfil Administrador.
- Garantir a existencia da tabela quando solicitado.

## Menu Dinamico

- O menu vem de `seg_menu` e `seg_aplicacoes`.
- As permissoes de visualizacao vem de `seg_perfil_permissoes` e `seg_usuarios_permissoes`.
- O menu deve respeitar a ordem do campo `ordem` em `seg_aplicacoes`.
- O menu principal so deve aparecer se houver pelo menos uma aplicacao com permissao de visualizacao.
- O menu deve manter icones com destaque moderado.
- Fonte do menu deve ser um pouco maior que o padrao inicial.
- Header deve exibir as logos Allop e Kidstok.
- Dashboard deve ser acessado pela logo do header, sem menu Principal.

Ordem dos menus principais:

| Ordem | Menu |
| --- | --- |
| 10 | Configuracoes |
| 20 | Produtos |
| 30 | Cadastros |
| 40 | Compras |
| 50 | Operacional |
| 60 | Gerencial |
| 90 | Seguranca |
| 98 | Ajuda |
| 99 | Sair |

## Padrao de Listas

Arquivos de lista devem usar sufixo `_lista.php`.

Exemplos:

- `usuarios_lista.php`
- `aplicacoes_lista.php`

Toda lista deve ter:

- Header com filtro/pesquisa quando aplicavel.
- Botao Voltar no topo da pagina, alinhado com o titulo, fora do card.
- Botao Novo/Nova quando a tela permitir inclusao.
- Grid responsivo usando `table-custom`.
- Acoes no grid somente com icones: Editar e Excluir.

Padrao de header de lista com filtro:

- Filtro dentro de `div.grid-filter`.
- Filtro deve usar Select2.
- O botao Filtrar deve ficar colado ao Select2 dentro de `div.filter-inline`.
- O botao Filtrar deve ter icone via CSS.
- O botao Novo/Nova fica no header do card quando a tela permitir inclusao.

## Padrao de Formularios

Arquivos de formulario devem usar sufixo `_form.php`.

Exemplos:

- `usuarios_form.php`
- `aplicacoes_form.php`

Todo formulario deve ter:

- Botao Voltar no topo da pagina, alinhado com o titulo, fora do card.
- Botao Salvar no canto inferior direito.
- Labels maiores e em negrito.
- Campos organizados em `card-slim` quando fizer sentido.
- Formularios maiores devem separar blocos por cards `card-slim`.
- A descricao da aplicacao deve aparecer abaixo do titulo.
- Card/formulario deve manter fundo branco.
- Inputs, selects, `input-group-text` e Select2 devem usar fundo cinza claro `#f8f9fa`.
- Inputs, selects, `input-group-text` e Select2 devem usar altura compacta de `38px`.
- Campos pequenos dentro de grids/formularios densos devem usar altura compacta de `34px` quando aplicavel.
- Bordas dos campos devem usar cinza neutro `#dee2e6`.
- Foco de campos e Select2 deve usar laranja `#ff4500` com sombra leve.

Padrao do header da tela:

- Usar `render_header('Titulo', [...acoes...])` quando houver botao Voltar.

Exemplo:

```php
render_header('Empresa', [
    ['label' => 'Voltar', 'href' => 'empresas_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
]);
```

## Botoes

Padrao de cores:

- Botoes principais usam laranja degrade.
- Botao Voltar usa azul claro degrade.

Classes auxiliares:

| Classe | Uso |
| --- | --- |
| `btn-back` | Botao voltar. |
| `btn-new` | Botao novo/nova. |
| `btn-save` | Botao salvar. |
| `btn-edit` | Botao editar. |
| `btn-delete` | Botao excluir. |
| `btn-login` | Botao entrar. |
| `btn-exit` | Botao sair. |
| `btn-key` | Botao alterar senha. |

Regras:

- Os icones dos botoes sao aplicados via CSS.
- Nao usar caracteres como `<`, `+` ou `x` diretamente como icone.
- Icones dos botoes devem ter destaque moderado e tamanho padrao global no CSS.

## Grids

- Usar `table-custom`.
- Grids/listas devem usar fonte Poppins.
- Cabecalho do grid deve usar cinza suave `#f1f3f5`.
- Letras do cabecalho devem usar `#495057`, fortes e com bom contraste.
- Linhas do grid devem ter estilo slim card.
- Linhas/celulas do grid devem manter fundo branco.
- No mobile, a tabela deve se adaptar para cards.

## Filtros de Grids

- Todos os grids devem ter filtro com Select2 quando houver pesquisa.
- Todos os grids com filtro devem ter botao Filtrar.
- O grid deve carregar ao clicar em Filtrar e tambem no carregamento inicial.
- O Select2 e o botao Filtrar devem ficar colados visualmente.
- O bloco do filtro deve usar `div.filter-inline`.

## Fontes

- Todas as telas devem usar Poppins como fonte padrao.

## Padrao Visual Global

- Fundo geral das telas deve usar `#f8f9fa`.
- Cards principais devem manter fundo branco para contraste com a pagina.
- Titulos das aplicacoes devem usar cinza `#74818c`.
- Titulos de blocos dentro de cards devem usar cinza `#6b7580`.
- Nao copiar CSS externo inteiro para o projeto.
- Integracoes visuais devem ser seletivas em `assets/css/style.css`.

Variaveis de cor aprovadas no CSS global:

| Variavel | Valor |
| --- | --- |
| `--appf-page-bg` | `#f8f9fa` |
| `--appf-grid-header-bg` | `#f1f3f5` |
| `--appf-grid-header-text` | `#495057` |
| `--appf-form-border` | `#dee2e6` |
| `--appf-input-bg` | `#f8f9fa` |
| `--appf-form-muted` | `#6c757d` |
| `--appf-orange` | `#ff4500` |
| `--appf-title-gray` | `#74818c` |
| `--appf-block-title-gray` | `#6b7580` |

## Perfil x Aplicacoes

Arquivos:

- `mod/seguranca/perfil_aplicacoes_lista.php`
- `mod/seguranca/perfil_aplicacoes_form.php`
- `api/seguranca/perfil_aplicacoes.php`

Lista:

- Deve ser um grid.
- Deve ter Novo, Editar e Excluir.
- Editar abre o formulario com `perfil_id`.
- Excluir remove as permissoes do perfil na tabela `seg_perfil_permissoes`.

Formulario:

- Deve informar o perfil.
- Deve carregar as aplicacoes.
- Deve permitir marcar/desmarcar permissoes em grid: visualizar, inserir, editar, excluir, imprimir, exportar e processar.
- Deve salvar em lote na tabela `seg_perfil_permissoes`.

## Usuario x Aplicacoes

Arquivos:

- `mod/seguranca/usuarios_permissoes_lista.php`
- `mod/seguranca/usuarios_permissoes_form.php`

Tabela:

- `seg_usuarios_permissoes`

Atencao aos nomes reais das colunas no banco:

- `edtiar`
- `imprirmir`

Formulario:

- Card 1: Usuario e Aplicacao.
- Card 2: Checkboxes de permissoes.

## APIs

- Tudo que acessa banco deve ser feito via API PHP.
- APIs devem retornar JSON.
- APIs devem usar `api/bootstrap.php`.
- APIs que exigem login devem chamar `api_require_login()`.
- Para CRUD generico de seguranca, usar `api/seguranca/crud.php` quando adequado.
- Para regras especificas, criar API propria.
- APIs internas devem exigir login com `api_require_login()`.
- APIs publicas para terceiros devem ser separadas das APIs administrativas.

## Assets e Bibliotecas

- Nao usar CDN em telas.
- Bootstrap, jQuery e Select2 devem ficar baixados em `assets/vendor/`.
- Fontes externas podem ser importadas no CSS global quando forem padrao visual aprovado.
- CSS principal: `assets/css/style.css`.
- JS principal: `assets/js/app.js`.
- Imagens: `assets/img/`.

## Login e Layout

- Login deve usar logo.
- Header deve usar logo Allop e logo Kidstok.
- Header deve conter menu dinamico e informacoes do usuario.
- Footer deve ser mantido em todas as telas autenticadas.

## Validacoes Especificas

### Empresas

- Validar CNPJ no frontend e na API.
- CEP deve conter 8 digitos.
- Buscar CEP automaticamente e preencher endereco, bairro, cidade e UF.
- UF deve ser select.
- DDD deve conter apenas 2 digitos.
- Telefones devem conter apenas digitos.
- Separar o formulario em blocos usando `card-slim`.

## Validacao Tecnica

Sempre validar arquivos PHP alterados com:

```bash
php -l caminho/do/arquivo.php
```

Quando alterar varias telas, validar todas as telas alteradas.

## Observacoes Importantes

- Evitar alterar telas ou regras que nao foram solicitadas.
- Manter escopo pequeno.
- Nao sobrescrever senha do admin em seeds se o usuario ja existir.
- Nao sobrescrever permissoes existentes se ja houver registro.
- Evitar acentos em codigo e labels internos quando houver risco de encoding quebrado.

## Checklist Para Novas Implementacoes

- Confirmar se a tela deve ficar em `mod/` e qual modulo/subpasta usar.
- Criar API em `api/` quando houver acesso ao banco.
- Usar `api/bootstrap.php` e `api_require_login()` nas APIs internas.
- Seguir o cabecalho obrigatorio das aplicacoes PHP.
- Usar sufixos `_lista.php` e `_form.php`.
- Cadastrar nova tela em `scripts/seed_aplicacoes.php`.
- Garantir permissao ao perfil Administrador quando aplicavel.
- Usar classes visuais globais ja existentes em `assets/css/style.css`.
- Evitar CDN e usar bibliotecas locais em `assets/vendor/`.
- Validar arquivos PHP alterados com `php -l`.
