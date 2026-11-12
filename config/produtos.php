<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'produtos.php';
$aplicacao_descricao = 'Cadastros e consultas do submenu de produtos.';

function produtos_catalogo(): array
{
    return [
        'produtos' => ['Produtos', 'produtos_cab', 'Referencia', true],
        'valores' => ['Produtos - Valores', 'produtos_cab_grade', 'Distribuidora', true],
        'outras_informacoes' => ['Produtos - Outras Informações', 'produtos_cab_grade', 'Distribuidora', true],
        'precos_lote' => ['Produtos - Alteração de Preços em Lote', 'produtos_precos_cab', 'ID', true],
        'fotos' => ['Produtos - Fotos', 'produtos_cab', 'Referencia', false],
        'consolidar' => ['Produtos - CONSOLIDAR', 'produtos_cab', 'Referencia', false],
        'consulta_geral' => ['Produtos - Consulta Geral', 'produtos', 'Codigo', false],
        'consulta_precos' => ['Produtos - Consulta de Preços', 'produtos', 'Codigo', false],
        'parametros' => ['Produtos - Parâmetros', 'produtos_prm', 'Codigo', true],
        'importar_antigos' => ['Produtos - Importar Antigos', 'produtos_antes_gcom', 'Codigo', false],
        'colecao' => ['Coleção', 'produtos_colecao', 'Codigo', true],
        'linha' => ['Linha', 'produtos_linhas', 'Codigo', true],
        'grupo' => ['Grupo', 'produtos_grupos_livre', 'Codigo', true],
        'grupos_tamanho' => ['Grupos / Tamanho', 'produtos_grupos_tamanho', 'Codigo', true],
        'categoria' => ['Categoria', 'produtos_categorias_livre', 'Codigo', true],
        'composicao' => ['Composição', 'produtos_composicoes', 'Codigo', true],
        'caracteristica' => ['Característica', 'produtos_caracteristicas', 'Codigo', true],
        'grupo_categoria' => ['Grupo / Categoria', 'produtos_grupos', 'Codigo', true],
        'categoria_composicao' => ['Categoria / Composição', 'produtos_categoria_composicao', 'Codigo', true],
        'categoria_caracteristica' => ['Categoria / Característica', 'produtos_categoria_caracteristicas', 'Codigo', true],
        'fornecedor' => ['Fornecedor (R1)', 'produtos_fornecedor', 'Codigo', true],
        'categoria_r2' => ['Categoria (R2)', 'produtos_categorias', 'Codigo', true],
        'tamanho' => ['Tamanho', 'produtos_tamanho', 'Codigo', true],
        'ordenar_tamanho' => ['Tamanho - Ordenar', 'produtos_tamanho_ordem', 'Codigo', true],
        'cor' => ['Cor', 'produtos_cor', 'Codigo', true],
        'genero' => ['Gênero', 'produtos_generos', 'Codigo', true],
        'estilo' => ['Estilo', 'produtos_estilos', 'Codigo', true],
        'medida' => ['Unidade de Medida', 'produtos_medidas', 'Sigla', true],
    ];
}

// Associacoes simples: cada opcao conserva sua tabela, chaves e permissoes.
function produtos_associacao_config(string $entity): ?array
{
    $types = [
        'grupo_categoria' => ['Grupo', 'SubGrupo', 'grupo', 'categorias', 'categoria'],
        'grupos_tamanho' => ['GrupoLivre', 'Tamanho', 'grupo', 'tamanhos', 'tamanho'],
        'categoria_composicao' => ['Categoria', 'Composicao', 'categoria', 'composições', 'composição'],
        'categoria_caracteristica' => ['Categoria', 'Caracteristica', 'categoria', 'características', 'característica'],
    ];
    if (!isset($types[$entity])) {
        return null;
    }
    [$parent, $child, $parentLabel, $childrenLabel, $childLabel] = $types[$entity];
    $config = produtos_config($entity);
    $relation = $config['relations'][$parent];
    $target = $config['relations'][$child];
    return $config + [
        'parent' => $parent, 'child' => $child, 'source' => $relation, 'target' => $target,
        'parent_status' => in_array($relation['table'], ['produtos_grupos_livre', 'produtos_categorias_livre'], true) ? 'Sts' : 'Status',
        'target_status' => $target['table'] === 'produtos_categorias_livre' ? 'Sts' : 'Status',
        'parent_label' => $parentLabel, 'children_label' => $childrenLabel, 'child_label' => $childLabel,
    ];
}

function produtos_rota(string $entity): string
{
    return 'mod/cadastros/produtos/produtos_lista.php?cadastro=' . rawurlencode($entity);
}

function produtos_config(string $entity): ?array
{
    $item = produtos_catalogo()[$entity] ?? null;
    if (!$item) {
        return null;
    }
    static $schemas;
    $schemas ??= json_decode(file_get_contents(__DIR__ . '/produtos_schema.json'), true, 512, JSON_THROW_ON_ERROR);
    $schema = $schemas[$item[1]];
    $formFields = [
        'valores' => ['Distribuidora', 'PrecoCompra', 'PrecoCompraTabela', 'PrecoVendaTabela', 'PrecoCheio', 'SetorLaranja', 'Encomenda', 'Estilo'],
        'outras_informacoes' => ['Distribuidora', 'GTIN', 'LocalFisico', 'CodigoAlternativo', 'Status', 'Peso'],
        'precos_lote' => ['Descricao', 'DataAtualizacao', 'DataVoltaAtualizacao'],
    ];
    return ['entity' => $entity, 'title' => $item[0], 'table' => $item[1], 'key' => $item[2],
        'editable' => $item[3], 'fields' => $schema['fields'], 'relations' => $schema['relations'],
        'form_fields' => $formFields[$entity] ?? null,
        'can_create' => !in_array($entity, ['valores', 'outras_informacoes'], true),
        'can_delete' => !in_array($entity, ['valores', 'outras_informacoes', 'parametros'], true)];
}

function produtos_label(string $field): string
{
    return [
        'Codigo' => 'Código', 'Sigla' => 'Sigla', 'Nome' => 'Nome', 'Status' => 'Status', 'Sts' => 'Status',
        'Inclusao' => 'Inclusão', 'Alteracao' => 'Alteração', 'Usuario' => 'Usuário', 'Colecao' => 'Coleção',
        'Externo' => 'Externo', 'Linha' => 'Linha', 'GrupoLivre' => 'Grupo', 'CategoriaLivre' => 'Categoria',
        'Composicao' => 'Composição', 'Caracteristica' => 'Característica', 'Grupo' => 'Grupo',
        'SubGrupo' => 'Categoria', 'Categoria' => 'Categoria (R2)', 'Tamanho' => 'Tamanho', 'Ordem' => 'Ordem',
        'NomeFornecedor' => 'Fornecedor', 'ProducaoProria' => 'Produção própria', 'MarkUpCompra' => 'Markup de compra',
        'MarkupFranqueadora' => 'Markup da franqueadora', 'CFOP_PP' => 'CFOP produção própria',
        'Genero' => 'Gênero', 'Abreviado' => 'Abreviado', 'Descricao' => 'Descrição', 'Unidade' => 'Unidade',
        'Referencia' => 'Referência', 'Distribuidora' => 'Referência completa', 'Fornecedor' => 'Fornecedor (R1)',
        'CodFornecedor' => 'Referência do fornecedor', 'CodFornecedorR3' => 'Referência (R3)',
        'DescricaoComplementar' => 'Descrição complementar', 'GrupoCategoria' => 'Categoria do grupo',
        'PrecoCompra' => 'Compra', 'PrecoCompraTabela' => 'Atacado', 'PrecoVendaTabela' => 'Varejo',
        'Consolidado' => 'Consolidado', 'LocalFisico' => 'Local físico', 'CodigoAlternativo' => 'Código alternativo',
        'DataAtualizacao' => 'Data de atualização', 'DataVoltaAtualizacao' => 'Data de retorno',
        'Atualizado' => 'Situação', 'QtdeItens' => 'Itens', 'UpperCase' => 'Descrições em maiúsculas',
        'PrecoAtacadoMetadeVarejo' => 'Atacado igual à metade do varejo', 'ReducaoBaseICMS' => 'Redução da base ICMS',
    ][$field] ?? trim(preg_replace('/(?<=[a-z])(?=[A-Z])/', ' ', str_replace('_', ' ', $field)));
}

function produtos_colunas(array $config, bool $audit = false): array
{
    $sets = [
        'produtos_cab' => ['Referencia', 'Descricao', 'Fornecedor', 'Categoria', 'CodFornecedorR3', 'Status', 'Consolidado'],
        'produtos_cab_grade' => ['Distribuidora', 'Descricao', 'Tamanho', 'Cor', 'PrecoCompra', 'PrecoCompraTabela', 'PrecoVendaTabela', 'Status'],
        'produtos' => ['Codigo', 'Distribuidora', 'Descricao', 'PrecoCompra', 'PrecoCompraTabela', 'PrecoVendaTabela', 'Status'],
        'produtos_antes_gcom' => ['Codigo', 'Distribuidora', 'Descricao', 'Status'],
        'produtos_precos_cab' => ['ID', 'Descricao', 'DataAtualizacao', 'DataVoltaAtualizacao', 'Atualizado', 'QtdeItens'],
    ];
    $columns = $sets[$config['table']] ?? array_values(array_filter(array_keys($config['fields']),
        static fn($f) => !in_array($f, ['Inclusao', 'Alteracao', 'Usuario'], true)));
    return $audit ? array_values(array_unique(array_merge($columns, ['Inclusao', 'Alteracao', 'Usuario']))) : $columns;
}

function produtos_aviso(string $entity): string
{
    return [
        'produtos' => 'A referência é formada por fornecedor (R1), categoria (R2) e R3. Salvar gera as combinações de tamanho e cor e deixa o produto pendente de consolidação.',
        'valores' => 'As alterações são gravadas na grade e ficam pendentes de consolidação.',
        'outras_informacoes' => 'As alterações são gravadas na grade e ficam pendentes de consolidação.',
        'precos_lote' => 'Cadastre os itens e confira os preços antes de aplicar o lote. A data de retorno permite restaurar os preços anteriores.',
        'consolidar' => 'Consolidar publica a grade em Produtos, preservando os códigos das referências existentes.',
        'importar_antigos' => 'Informe a referência master (8 caracteres) ou completa (12 caracteres). A origem GCOM tem prioridade sobre a base anterior.',
    ][$entity] ?? '';
}
