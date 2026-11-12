# Cadastros > Produtos

Integração de 30/10/2026 no projeto `D:\E7TI\PHP\allop`, usando `allop_devel`.

## Fontes

As 28 opções foram identificadas no menu autenticado da homologação. As regras foram conferidas na exportação `D:\E7TI\PHP\sc9_Allop_20261030-104131.zip`, em `evt/`, `apl/` e na biblioteca `files/devel/conf/sys/lib/consolidacao.php`. Os arquivos foram decodificados em pasta temporária sem executar código do Scriptcase. Credenciais, cookies e a exportação não foram adicionados ao projeto.

## Implementação

| Opções | Comportamento nativo |
| --- | --- |
| Produtos | Inclusão, edição, consulta e exclusão. Referência R1 + R2 + R3; descrição automática quando vazia; validação de relacionamentos, tributos, cores/tamanhos ativos e preços; geração das combinações na grade |
| Produtos - Valores | Edição individual ou em lote das referências selecionadas; compra, atacado, varejo, preço cheio, setor laranja, encomenda e estilo. Alterações ficam pendentes de consolidação |
| Produtos - Outras Informações | Edição individual ou em lote de GTIN, localização, código alternativo, status e peso. O alternativo precisa identificar outra referência consolidada com o mesmo tamanho/cor |
| Produtos - Alteração de Preços em Lote | Cabeçalho, datas, itens por referência completa ou master, edição/exclusão de itens, aplicação, restauração e histórico. Considera o parâmetro de atacado e o indicador de preço cheio |
| Produtos - Fotos | Consulta, upload e exclusão; até cinco imagens por produto, com até 10 MB por arquivo. Indicador de foto e datas atualizados nas tabelas de produtos |
| Produtos - CONSOLIDAR | Processamento individual ou das referências selecionadas. Publica a grade em `produtos`, mantém códigos existentes, gera código/GTIN para inclusões e administra códigos de barras e alternativos |
| Produtos - Consulta Geral; Produtos - Consulta de Preços | Consulta paginada dos produtos consolidados, com filtros e consulta completa dos campos |
| Produtos - Parâmetros | Manutenção dos padrões tributários, maiúsculas e relação atacado/varejo; exclusão bloqueada |
| Produtos - Importar Antigos | Importação pela master ou referência completa, com prioridade da base GCOM sobre Antes GCOM, preservando códigos e barras de origem. Permite incluir apenas faltantes |
| Coleção; Linha; Grupo; Categoria; Composição; Característica; Fornecedor (R1); Categoria (R2); Tamanho; Cor; Gênero; Estilo; Unidade de Medida | Listagem, consulta e manutenção dos cadastros. Validação no servidor, auditoria, seletores pesquisáveis e bloqueio de exclusão quando há vínculos |
| Grupos / Tamanho; Grupo / Categoria; Categoria / Composição; Categoria / Característica | Manutenção dos vínculos individuais entre os cadastros |
| Tamanho - Ordenar | Ordenação por setas com gravação da lista completa, além da manutenção individual de `Ordem` |

Listagens têm 50 registros por página; os detalhes de grades e lotes têm 500 por página. O layout foi adaptado ao Allop com Bootstrap e Select2 locais e apresentação em celular. Os exportadores e relatórios automáticos específicos do Scriptcase não foram reproduzidos.

## Regras e proteções

- A edição do cabeçalho mantém as grades anteriores e os valores individuais, como o legado; novas combinações são acrescentadas. Referências presentes em `produtos_referencias_prod` são preservadas e informadas ao usuário.
- Referências já consolidadas não são apagadas pela exclusão do produto. Quando a família já possui produtos publicados, são removidas somente grades ainda não publicadas.
- A consolidação preserva o código e o GTIN dos produtos existentes. Inclusões usam o próximo código com oito posições, inicialmente após 115000, e GTIN com 14 posições.
- Alterar o grupo do cabeçalho também propaga o grupo para manter válida a chave estrangeira composta com a categoria.
- Alterações compostas usam transações. Consolidação, importação, fotos e processamento de preços usam trava MySQL compartilhada. Os preços para retorno são capturados no momento da aplicação do lote.
- A restauração recusa referências cujo preço mudou posteriormente, evitando sobrescrever outro ajuste.
- As APIs novas verificam sessão, permissões por perfil, POST, token de formulário e entradas. Tabelas e colunas vêm de catálogo estático; SQL usa parâmetros.
- As datas do módulo usam `America/Sao_Paulo`.
- Não se executa a procedure `produtos_000_sp`, que contém integrações com outro banco. A biblioteca de consolidação conferida no ZIP não a chama.

## Banco e ativação

A conexão principal em `config/database.php` foi ajustada para `allop_devel`, conforme a confirmação do usuário. As outras configurações e `config/database copy.php` foram preservadas.

Foi executado:

```powershell
php scripts/seed_produtos.php --database=allop_devel
```

O instalador específico registrou 28 aplicações em Cadastro/Cadastros e criou permissões apropriadas para Administrador. Ele é idempotente e preserva permissões existentes. Os demais perfis precisam receber suas permissões pelas telas de segurança. O seed geral também passou a registrar o submenu, mas não foi executado nesta integração.

Os três gatilhos de `allop_devel.produtos_fotos` ainda apontavam para `allop_kidstok`. Foi executado:

```powershell
php scripts/ajustar_triggers_fotos_produtos.php --execute
```

As chamadas agora usam `sp_atualiza_data_alteracao_produtos_cab` do próprio banco. As definições anteriores foram guardadas em `C:\Users\claud\AppData\Local\Temp\allop_devel_fotos_triggers_20261030_140556.sql`. O ajuste consta também em `banco.sql`. Nenhuma tabela foi criada ou removida, e não houve testes de gravação nos produtos, preços ou fotos do banco remoto.

## Lotes programados

Aplicação e retorno podem ser executados pela tela. Para execução automática nas datas cadastradas:

```powershell
# Consulta os lotes vencidos sem alterar dados:
php scripts/processar_precos_produtos.php

# Processa os lotes e retornos vencidos:
php scripts/processar_precos_produtos.php --execute
```

O segundo comando deve ser configurado no cron ou Agendador de Tarefas do servidor. **Nenhum agendador foi instalado ou ativado nesta sessão**, e esse executor não foi executado contra os dados reais. O processamento usa os estados existentes 0 (não aplicado), 1 (aguarda retorno) e 9 (finalizado); mantém a consulta do lote e grava cópia em `produtos_precos_cab_h`/`produtos_precos_itens_h`.

## Arquivos

- `config/produtos.php` e `config/produtos_schema.json`: opções, rotas, tabelas, campos e relacionamentos permitidos.
- `includes/produtos.php`: permissões, validação e filtros.
- `includes/produtos_workflow.php`: produtos/grades, consolidação, importação, fotos, ordenação e lotes.
- `api/cadastros/produtos.php` e `produtos_processos.php`: APIs do módulo.
- `mod/cadastros/produtos/`: listagem e formulário compartilhados.
- `includes/permissions.php` e `includes/layout.php`: submenu e navegação por teclado.
- `assets/js/app.js` e `assets/css/style.css`: comportamento e apresentação.
- `scripts/seed_produtos.php`: registro transacional do menu.
- `scripts/ajustar_triggers_fotos_produtos.php`: ajuste dos três gatilhos, com cópia anterior.
- `scripts/processar_precos_produtos.php`: executor CLI de lotes programados.

## Verificações

- Sintaxe PHP e JavaScript dos arquivos envolvidos.
- 44 schemas e os campos dos seletores comparados com `allop_devel`, por leitura, sem divergências.
- Conferência das 28 aplicações instaladas para Administrador e dos três gatilhos corrigidos.
- `python tests/produtos_http_test.py`: 109 verificações HTTP em cópia temporária com SQLite, sem conexão aos bancos configurados. Incluem 28 listagens, auxiliares, geração de grade, preservação de códigos, consolidação, alteração em lote e rollback, aplicação/retorno de preços, importação e idempotência, fotos e limite de imagens, ordenação, permissões e token inválido.
- Conferência em Chrome local, com dados fictícios: Select2, criação de produto pela interface, cálculo de atacado, grade gerada, submenu, lote finalizado, seleção em lote, ordenação e layout em desktop e celular. Um bloqueio indevido de campo opcional foi encontrado e corrigido.
- A fixture SQLite adapta `FOR UPDATE` e metadados de exclusão. Os testes isolados não comprovam concorrência, gatilhos ou integrações MySQL. Não foram executados consolidação, importação, lotes ou gravação de fotos nos dados remotos.
