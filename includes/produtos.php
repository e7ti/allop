<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'produtos.php';
$aplicacao_descricao = 'Validação, permissões e consultas dos cadastros de produtos.';
require_once __DIR__ . '/auth.php';
require_once __DIR__ . '/../config/produtos.php';
date_default_timezone_set('America/Sao_Paulo');

function produtos_permissoes(string $entity): array
{
    $user = current_user();
    if (!$user) {
        return [];
    }
    $stmt = db()->prepare('SELECT p.* FROM seg_perfil_permissoes p
        JOIN seg_aplicacoes a ON a.id = p.aplicacao_id
        WHERE p.perfil_id = :perfil AND a.rota = :rota LIMIT 1');
    $stmt->execute(['perfil' => $user['perfil_id'], 'rota' => produtos_rota($entity)]);
    return $stmt->fetch() ?: [];
}

function produtos_csrf(): string
{
    return $_SESSION['produtos_csrf'] ??= bin2hex(random_bytes(32));
}

function produtos_campos_form(array $config): array
{
    return array_filter($config['fields'], static fn($field, $name) =>
        !in_array($name, ['Inclusao', 'Alteracao', 'Usuario', 'Consolidado', 'Foto'], true) && !$field['auto']
        && ($config['form_fields'] === null || in_array($name, $config['form_fields'], true)), ARRAY_FILTER_USE_BOTH);
}

function produtos_validar(array $config, array $input, bool $editing): array
{
    $values = [];
    foreach (produtos_campos_form($config) as $name => $field) {
        if ($editing && $name === $config['key']) {
            continue;
        }
        $raw = $input[$name] ?? $field['default'] ?? '';
        if (!is_scalar($raw) && $raw !== null) {
            throw new InvalidArgumentException(produtos_label($name) . ': valor inválido.');
        }
        $value = trim((string) $raw);
        $label = produtos_label($name);
        if ($value === '') {
            if ($field['nullable']) {
                $values[$name] = null;
                continue;
            }
            if (($field['default'] === '' || ($config['entity'] === 'produtos' && in_array($name, ['DescricaoComplementar', 'CFOP_ProducaoProria'], true))) && $name !== $config['key']) {
                $values[$name] = '';
                continue;
            }
            throw new InvalidArgumentException('Informe ' . $label . '.');
        }
        if (in_array($field['type'], ['int', 'bigint', 'tinyint', 'smallint'], true)) {
            if (!preg_match('/^\d+$/D', $value) || strlen($value) > 18 || (float) $value > PHP_INT_MAX) {
                throw new InvalidArgumentException($label . ': informe um inteiro válido.');
            }
        } elseif (in_array($field['type'], ['double', 'decimal', 'float'], true)) {
            $value = str_replace(',', '.', $value);
            if (!is_numeric($value) || !is_finite((float) $value) || (float) $value < 0) {
                throw new InvalidArgumentException($label . ': informe um número positivo ou zero.');
            }
        } elseif (in_array($field['type'], ['date', 'datetime'], true)) {
            $date = DateTimeImmutable::createFromFormat($field['type'] === 'date' ? '!Y-m-d' : '!Y-m-d\TH:i', $value);
            if (!$date || $date->format($field['type'] === 'date' ? 'Y-m-d' : 'Y-m-d\TH:i') !== $value) {
                throw new InvalidArgumentException($label . ': data inválida.');
            }
            $value = $date->format($field['type'] === 'date' ? 'Y-m-d' : 'Y-m-d H:i:s');
        } elseif ($field['size'] && (function_exists('mb_strlen') ? mb_strlen($value, 'UTF-8') : preg_match_all('/./us', $value)) > (int) $field['size']) {
            throw new InvalidArgumentException($label . ': limite de ' . $field['size'] . ' caracteres.');
        }
        if (in_array($name, ['Status', 'Sts'], true) && !in_array($value, ['Ativo', 'Inativo'], true)) {
            throw new InvalidArgumentException('Status inválido.');
        }
        if (in_array($name, ['ProducaoProria', 'UpperCase', 'PrecoAtacadoMetadeVarejo', 'PrecoCheio', 'SetorLaranja', 'Encomenda'], true) && !in_array($value, ['S', 'N'], true)) {
            throw new InvalidArgumentException($label . ': selecione Sim ou Não.');
        }
        if ($name === 'Externo' && !in_array($value, ['0', '1'], true)) {
            throw new InvalidArgumentException('Externo inválido.');
        }
        if (isset($config['relations'][$name])) {
            $relation = $config['relations'][$name];
            foreach (!empty($relation['multiple']) ? explode(';', $value) : [$value] as $relatedValue) {
                $stmt = db()->prepare("SELECT 1 FROM `{$relation['table']}` WHERE `{$relation['key']}` = ? LIMIT 1");
                $stmt->execute([$relatedValue]);
                if (!$stmt->fetchColumn()) {
                    throw new InvalidArgumentException($label . ': selecione um cadastro existente.');
                }
            }
        }
        $values[$name] = $value;
    }
    foreach (['Inclusao', 'Alteracao', 'Usuario'] as $audit) {
        if (!isset($config['fields'][$audit]) || ($editing && $audit === 'Inclusao')) {
            continue;
        }
        $values[$audit] = $audit === 'Usuario'
            ? mb_substr((string) (current_user()['login'] ?? ''), 0, (int) $config['fields'][$audit]['size'], 'UTF-8')
            : date($config['fields'][$audit]['type'] === 'date' ? 'Y-m-d' : 'Y-m-d H:i:s');
    }
    return $values;
}

function produtos_pesquisa(array $config, array $data): array
{
    $where = [];
    $params = [];
    if ($config['entity'] === 'produtos' && isset($data['product_reference']) && is_string($data['product_reference']) && $data['product_reference'] !== '') {
        $where[] = 'Referencia = :product_reference';
        $params['product_reference'] = $data['product_reference'];
    }
    $q = trim((string) ($data['q'] ?? ''));
    if ($q !== '') {
        $parts = [];
        foreach (produtos_colunas($config) as $i => $column) {
            $parts[] = "`$column` LIKE :q$i";
            $params['q' . $i] = '%' . $q . '%';
        }
        $where[] = '(' . implode(' OR ', $parts) . ')';
    }
    if ($config['entity'] === 'consolidar') {
        $where[] = "Consolidado = 'N'";
    }
    if ($config['entity'] === 'importar_antigos' && $q === '') {
        $where[] = '1 = 0';
    }
    foreach (['Fornecedor', 'Categoria', 'Status', 'Colecao', 'Linha', 'Grupo', 'GrupoCategoria', 'Genero', 'Composicao', 'Caracteristica', 'Estilo', 'Consolidado', 'Tamanho', 'Cor'] as $filter) {
        if ($config['entity'] === 'produtos' && in_array($filter, ['Fornecedor', 'Categoria'], true) && isset($data[$filter]) && is_array($data[$filter])) {
            $selected = $data[$filter];
            if (count($selected) > 200 || array_filter($selected, static fn($value) => !is_string($value) || strlen($value) !== 2)) {
                throw new InvalidArgumentException(produtos_label($filter) . ': seleção inválida.');
            }
            $selected = array_values(array_unique($selected));
            if ($selected) {
                $marks = [];
                foreach ($selected as $index => $value) {
                    $key = 'multi_' . $filter . '_' . $index;
                    $marks[] = ':' . $key;
                    $params[$key] = $value;
                }
                $where[] = "`$filter` IN (" . implode(', ', $marks) . ')';
            }
            continue;
        }
        if (isset($config['fields'][$filter]) && isset($data[$filter]) && is_scalar($data[$filter]) && (string) $data[$filter] !== '') {
            if (!empty($config['relations'][$filter]['multiple'])) {
                $where[] = "(`$filter` = :f_$filter OR `$filter` LIKE :fs_$filter OR `$filter` LIKE :fm_$filter OR `$filter` LIKE :fe_$filter)";
                $params['f_' . $filter] = (string) $data[$filter];
                $params['fs_' . $filter] = $data[$filter] . ';%';
                $params['fm_' . $filter] = '%;' . $data[$filter] . ';%';
                $params['fe_' . $filter] = '%;' . $data[$filter];
            } else {
                $where[] = "`$filter` = :f_$filter";
                $params['f_' . $filter] = (string) $data[$filter];
            }
        }
    }
    foreach (['CodFornecedorR3', 'CodFornecedor', 'DescricaoComplementar'] as $filter) {
        if (isset($config['fields'][$filter]) && isset($data[$filter]) && is_scalar($data[$filter]) && trim((string) $data[$filter]) !== '') {
            $where[] = "`$filter` LIKE :f_$filter";
            $params['f_' . $filter] = '%' . trim((string) $data[$filter]) . '%';
        }
    }
    return [$where ? ' WHERE ' . implode(' AND ', $where) : '', $params];
}
