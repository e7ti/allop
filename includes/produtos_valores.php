<?php
require_once __DIR__ . '/produtos.php';

function produtos_valores_filtro(array $data): array
{
    $where = [];
    $params = [];
    $fields = produtos_config('valores')['fields'];
    foreach (['Referencia', 'CodFornecedorR3', 'CodFornecedor', 'Descricao', 'DescricaoComplementar'] as $field) {
        if (isset($data[$field]) && is_string($data[$field]) && trim($data[$field]) !== '') {
            $where[] = "`$field` LIKE ?";
            $params[] = '%' . trim($data[$field]) . '%';
        }
    }
    foreach (['Fornecedor', 'Categoria', 'Colecao', 'Linha', 'Grupo', 'GrupoCategoria', 'Genero', 'Composicao', 'Caracteristica', 'Estilo', 'Tamanho', 'Cor', 'Status', 'Consolidado', 'SetorLaranja', 'PrecoCheio', 'Encomenda'] as $field) {
        if (isset($fields[$field], $data[$field]) && is_scalar($data[$field]) && (string) $data[$field] !== '') {
            $where[] = "`$field` = ?";
            $params[] = (string) $data[$field];
        }
    }
    return [$where ? ' WHERE ' . implode(' AND ', $where) : '', $params];
}

function produtos_valores_versao(array $row): string
{
    return hash('sha256', json_encode($row, JSON_UNESCAPED_UNICODE));
}

function produtos_valores_dinheiro($value): string
{
    if (!is_scalar($value)) {
        throw new InvalidArgumentException('Informe um valor monetário válido.');
    }
    $value = trim((string) $value);
    if (strpos($value, ',') !== false) {
        if (!preg_match('/^(?:\d+|\d{1,3}(?:\.\d{3})+),\d{1,2}$/D', $value)) {
            throw new InvalidArgumentException('Informe um valor positivo com até duas casas decimais.');
        }
        $value = str_replace(',', '.', str_replace('.', '', $value));
    }
    if (!preg_match('/^\d+(?:\.\d{1,2})?$/D', $value) || !is_finite((float) $value) || (float) $value > 99999999.99) {
        throw new InvalidArgumentException('Informe um valor entre 0 e 99.999.999,99, com até duas casas decimais.');
    }
    return number_format((float) $value, 2, '.', '');
}
