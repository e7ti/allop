<?php
require_once __DIR__ . '/produtos.php';

function grupo_categoria_vinculos(PDO $pdo, string $grupo, ?array $config = null): array
{
    $config = $config ?? produtos_associacao_config('grupo_categoria');
    $stmt = $pdo->prepare("SELECT * FROM `{$config['table']}` WHERE `{$config['parent']}` = ? ORDER BY Codigo");
    $stmt->execute([$grupo]);
    return $stmt->fetchAll();
}

function grupo_categoria_versao(array $rows): string
{
    return hash('sha256', json_encode($rows, JSON_UNESCAPED_UNICODE));
}

// Confere cada chave estrangeira completa, inclusive vinculos com ON DELETE CASCADE.
function grupo_categoria_em_uso(PDO $pdo, array $vinculo, string $referencedTable = 'produtos_grupos'): bool
{
    $constraints = [];
    if ($pdo->getAttribute(PDO::ATTR_DRIVER_NAME) === 'mysql') {
        $stmt = $pdo->prepare('SELECT TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME, REFERENCED_COLUMN_NAME
            FROM information_schema.KEY_COLUMN_USAGE
            WHERE REFERENCED_TABLE_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME = :table
            ORDER BY TABLE_NAME, CONSTRAINT_NAME, ORDINAL_POSITION');
        $stmt->execute(['table' => $referencedTable]);
        foreach ($stmt->fetchAll() as $row) {
            $constraints[$row['TABLE_NAME'] . ':' . $row['CONSTRAINT_NAME']][] = $row;
        }
    } else {
        // Permite verificar as mesmas regras na fixture SQLite isolada.
        foreach ($pdo->query("SELECT name FROM sqlite_master WHERE type = 'table'")->fetchAll() as $table) {
            $name = str_replace('`', '``', $table['name']);
            foreach ($pdo->query("PRAGMA foreign_key_list(`$name`)")->fetchAll() as $fk) {
                if ($fk['table'] === $referencedTable) {
                    $constraints[$name . ':' . $fk['id']][] = ['TABLE_NAME' => $table['name'],
                        'COLUMN_NAME' => $fk['from'], 'REFERENCED_COLUMN_NAME' => $fk['to']];
                }
            }
        }
    }
    foreach ($constraints as $fields) {
        $where = [];
        $params = [];
        foreach ($fields as $field) {
            $where[] = '`' . str_replace('`', '``', $field['COLUMN_NAME']) . '` = ?';
            $params[] = $vinculo[$field['REFERENCED_COLUMN_NAME']];
        }
        $table = str_replace('`', '``', $fields[0]['TABLE_NAME']);
        $stmt = $pdo->prepare("SELECT 1 FROM `$table` WHERE " . implode(' AND ', $where) . ' LIMIT 1');
        $stmt->execute($params);
        if ($stmt->fetchColumn()) {
            return true;
        }
    }
    return false;
}
