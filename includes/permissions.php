<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "permissions.php";
$aplicacao_descricao = "Gerencia a busca de itens de menu e permissões de acesso.";

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/auth.php';

/**
 * Retorna os itens de menu agrupados por categoria, ordenados pelo ID do menu
 * e pela ordem da aplicação.
 */
function menu_items(): array
{
    $user = current_user();
    if (!$user) {
        return [];
    }

    $sql = "SELECT m.menu as grupo, a.nome, a.rota as arquivo
            FROM seg_aplicacoes a
            JOIN seg_menu m ON a.menu_id = m.id
            JOIN seg_perfil_permissoes p ON a.id = p.aplicacao_id
            WHERE p.perfil_id = :perfil_id
              AND p.visualizar = 1
              AND m.menu NOT IN ('Principal', 'Sair')
            ORDER BY m.id ASC, a.ordem ASC, a.nome ASC";

    $stmt = db()->prepare($sql);
    $stmt->execute(['perfil_id' => $user['perfil_id']]);
    
    $menu = [];
    while ($row = $stmt->fetch()) {
        $menu[$row['grupo']][] = ['nome' => $row['nome'], 'arquivo' => $row['arquivo']];
    }

    return $menu;
}
