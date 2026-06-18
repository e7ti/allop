ALLOP - PADROES DO SISTEMA
Data: 01/06/2026
Atualizacao visual: 02/06/2026

OBJETIVO
Este arquivo serve como referencia para novas implementacoes no sistema Allop.
Antes de criar novas telas, APIs ou modulos, seguir estes padroes.


ESTRUTURA DO PROJETO
- Projeto em PHP puro.
- Aplicacoes/telas devem ficar em mod/.
- Modulos devem ficar em subpastas dentro de mod/.
  Exemplo:
  - mod/seguranca/usuarios_lista.php
  - mod/seguranca/usuarios_form.php
  - mod/configuracoes/empresas/empresas_lista.php
  - mod/configuracoes/empresas/empresas_form.php
- APIs devem ficar em api/.
  Exemplo:
  - api/seguranca/crud.php
  - api/seguranca/perfil_aplicacoes.php
  - api/configuracoes/empresas.php
- Includes compartilhados ficam em includes/.
- Configuracoes ficam em config/.
- CSS, JS, imagens e bibliotecas ficam em assets/.
- Documentacao e acompanhamento ficam em docs/.


CABECALHO OBRIGATORIO DAS APLICACOES PHP
Todas as aplicacoes PHP devem conter:

/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "nome_do_arquivo.php";
$aplicacao_descricao = "Descricao do que faz a aplicacao.";


BANCO DE DADOS - SEGURANCA
Usar as tabelas do banco.sql:
- seg_menu
- seg_aplicacoes
- seg_perfil
- seg_perfil_permissoes
- seg_usuarios
- seg_usuarios_permissoes

Nao criar tabelas via codigo. O banco sera criado manualmente.
O sistema pode inserir, atualizar e excluir dados nas tabelas existentes.

BANCO DE DADOS - CONFIGURACOES
Usar as tabelas do banco.sql:
- empresas_cd
- empresas
- config_email

Tabelas de configuracoes devem ter lista e formulario em:
- mod/configuracoes/nome_tabela/nome_tabela_lista.php
- mod/configuracoes/nome_tabela/nome_tabela_form.php

APIs especificas de configuracoes devem ficar em:
- api/configuracoes/nome_tabela.php

Toda nova tela deve ser cadastrada no scripts/seed_aplicacoes.php.
O seed deve:
- Criar/atualizar a aplicacao em seg_aplicacoes.
- Criar/atualizar menu quando necessario.
- Dar permissao ao perfil Administrador.
- Garantir a existencia da tabela quando solicitado.


MENU DINAMICO
- O menu vem de seg_menu e seg_aplicacoes.
- As permissoes de visualizacao vem de:
  - seg_perfil_permissoes
  - seg_usuarios_permissoes
- O menu deve respeitar a ordem do campo ordem em seg_aplicacoes.
- O menu principal so deve aparecer se houver pelo menos uma aplicacao com permissao de visualizacao.
- O menu deve manter icones com destaque moderado.
- Fonte do menu deve ser um pouco maior que o padrao inicial.
- Header deve exibir as logos Allop e Kidstok.
- Ordem dos menus principais:
  - 10 Configuracoes
  - 20 Produtos
  - 30 Cadastros
  - 40 Compras
  - 50 Operacional
  - 60 Gerencial
  - 90 Seguranca
  - 98 Ajuda
  - 99 Sair
- Dashboard deve ser acessado pela logo do header, sem menu Principal.


PADRAO DE LISTAS
Arquivos de lista devem usar sufixo _lista.php.
Exemplo:
- usuarios_lista.php
- aplicacoes_lista.php

Toda lista deve ter:
- Header com filtro/pesquisa quando aplicavel.
- Botao Voltar no topo da pagina, alinhado com o titulo, fora do card.
- Botao Novo/Nova quando a tela permitir inclusao.
- Grid responsivo usando table-custom.
- Acoes no grid somente com icones:
  - Editar
  - Excluir

Padrao de header de lista com filtro:
- Filtro dentro de div.grid-filter.
- Filtro deve usar Select2.
- O botao Filtrar deve ficar colado ao Select2 dentro de div.filter-inline.
- O botao Filtrar deve ter icone via CSS.
- O botao Novo/Nova fica no header do card quando a tela permitir inclusao.


PADRAO DE FORMULARIOS
Arquivos de formulario devem usar sufixo _form.php.
Exemplo:
- usuarios_form.php
- aplicacoes_form.php

Todo formulario deve ter:
- Botao Voltar no topo da pagina, alinhado com o titulo, fora do card.
- Botao Salvar no canto inferior direito.
- Labels maiores e em negrito.
- Campos organizados em card-slim quando fizer sentido.
- Formularios maiores devem separar blocos por cards card-slim.
- A descricao da aplicacao deve aparecer abaixo do titulo.
- Card/formulario deve manter fundo branco.
- Inputs, selects, input-group-text e Select2 devem usar fundo cinza claro #f8f9fa.
- Bordas dos campos devem usar cinza neutro #dee2e6.
- Foco de campos e Select2 deve usar laranja #ff4500 com sombra leve.

Padrao do header da tela:
- Usar render_header('Titulo', [...acoes...]) quando houver botao Voltar.
- Exemplo:
  render_header('Empresa', [
      ['label' => 'Voltar', 'href' => 'empresas_lista.php', 'class' => 'btn btn-outline-secondary btn-back'],
  ]);


BOTOES
Padrao de cores:
- Botoes principais usam laranja degrade.
- Botao Voltar usa azul claro degrade.

Classes auxiliares de botoes:
- btn-back: botao voltar.
- btn-new: botao novo/nova.
- btn-save: botao salvar.
- btn-edit: botao editar.
- btn-delete: botao excluir.
- btn-login: botao entrar.
- btn-exit: botao sair.
- btn-key: botao alterar senha.

Os icones dos botoes sao aplicados via CSS.
Nao usar caracteres como "<", "+", "x" diretamente como icone.
Icones dos botoes devem ter destaque moderado e tamanho padrao global no CSS.


GRIDS
- Usar table-custom.
- Grids/listas devem usar fonte Poppins.
- Cabecalho do grid deve usar cinza suave #f1f3f5.
- Letras do cabecalho devem usar #495057, fortes e com bom contraste.
- Linhas do grid devem ter estilo slim card.
- Linhas/celulas do grid devem manter fundo branco.
- No mobile, a tabela deve se adaptar para cards.

FILTROS DE GRIDS
- Todos os grids devem ter filtro com Select2 quando houver pesquisa.
- Todos os grids com filtro devem ter botao Filtrar.
- O grid deve carregar ao clicar em Filtrar e tambem no carregamento inicial.
- O Select2 e o botao Filtrar devem ficar colados visualmente.
- O bloco do filtro deve usar div.filter-inline.

FONTES
- Todas as telas devem usar Poppins como fonte padrao.


PADRAO VISUAL GLOBAL
- Fundo geral das telas deve usar #f8f9fa.
- Cards principais devem manter fundo branco para contraste com a pagina.
- Titulos das aplicacoes devem usar cinza #74818c.
- Titulos de blocos dentro de cards devem usar cinza #6b7580.
- Nao copiar CSS externo inteiro para o projeto.
- Integracoes visuais devem ser seletivas em assets/css/style.css.
- Variaveis de cor aprovadas no CSS global:
  - --appf-page-bg: #f8f9fa
  - --appf-grid-header-bg: #f1f3f5
  - --appf-grid-header-text: #495057
  - --appf-form-border: #dee2e6
  - --appf-input-bg: #f8f9fa
  - --appf-form-muted: #6c757d
  - --appf-orange: #ff4500
  - --appf-title-gray: #74818c
  - --appf-block-title-gray: #6b7580


PERFIL X APLICACOES
Arquivos:
- mod/seguranca/perfil_aplicacoes_lista.php
- mod/seguranca/perfil_aplicacoes_form.php
- api/seguranca/perfil_aplicacoes.php

Lista:
- Deve ser um grid.
- Deve ter Novo, Editar e Excluir.
- Editar abre o formulario com perfil_id.
- Excluir remove as permissoes do perfil na tabela seg_perfil_permissoes.

Formulario:
- Deve informar o perfil.
- Deve carregar as aplicacoes.
- Deve permitir marcar/desmarcar permissoes em grid:
  - visualizar
  - inserir
  - editar
  - excluir
  - imprimir
  - exportar
  - processar
- Deve salvar em lote na tabela seg_perfil_permissoes.


USUARIO X APLICACOES
Arquivos:
- mod/seguranca/usuarios_permissoes_lista.php
- mod/seguranca/usuarios_permissoes_form.php

Tabela:
- seg_usuarios_permissoes

Atencao aos nomes reais das colunas no banco:
- edtiar
- imprirmir

Formulario:
- Card 1: Usuario e Aplicacao.
- Card 2: Checkboxes de permissoes.


APIS
- Tudo que acessa banco deve ser feito via API PHP.
- APIs devem retornar JSON.
- APIs devem usar api/bootstrap.php.
- APIs que exigem login devem chamar api_require_login().
- Para CRUD generico de seguranca, usar api/seguranca/crud.php quando adequado.
- Para regras especificas, criar API propria.
- APIs internas devem exigir login com api_require_login().
- APIs publicas para terceiros devem ser separadas das APIs administrativas.


ASSETS E BIBLIOTECAS
- Nao usar CDN em telas.
- Bootstrap, jQuery e Select2 devem ficar baixados em assets/vendor/.
- Fontes externas podem ser importadas no CSS global quando forem padrao visual aprovado.
- CSS principal:
  - assets/css/style.css
- JS principal:
  - assets/js/app.js
- Imagens:
  - assets/img/


LOGIN E LAYOUT
- Login deve usar logo.
- Header deve usar logo Allop e logo Kidstok.
- Header deve conter menu dinamico e informacoes do usuario.
- Footer deve ser mantido em todas as telas autenticadas.

VALIDACOES ESPECIFICAS
Empresas:
- Validar CNPJ no frontend e na API.
- CEP deve conter 8 digitos.
- Buscar CEP automaticamente e preencher endereco, bairro, cidade e UF.
- UF deve ser select.
- DDD deve conter apenas 2 digitos.
- Telefones devem conter apenas digitos.
- Separar o formulario em blocos usando card-slim.


VALIDACAO
Sempre validar arquivos PHP alterados com:
php -l caminho/do/arquivo.php

Quando alterar varias telas, validar todas as telas alteradas.


OBSERVACOES IMPORTANTES
- Evitar alterar telas ou regras que nao foram solicitadas.
- Manter escopo pequeno.
- Nao sobrescrever senha do admin em seeds se o usuario ja existir.
- Nao sobrescrever permissoes existentes se ja houver registro.
- Evitar acentos em codigo e labels internos quando houver risco de encoding quebrado.

Aguarde minhas instrucoes.
