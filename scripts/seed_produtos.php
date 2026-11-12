<?php
/*
    Autor: Claudio Barto
    Data : 30/10/2026
*/
$aplicacao_nome = 'seed_produtos.php';
$aplicacao_descricao = 'Registra somente o submenu de produtos e suas permissões de administrador.';

function registrar_aplicacoes_produtos(PDO $pdo): void
{
    require_once __DIR__ . '/../config/produtos.php';
    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare("SELECT id FROM seg_menu WHERE menu IN ('Cadastros', 'Cadastro') ORDER BY id LIMIT 1");
        $stmt->execute();
        $menuId = $stmt->fetchColumn();
        if ($menuId === false) {
            $menuId = (int) $pdo->query('SELECT COALESCE(MAX(id), 0) + 1 FROM seg_menu')->fetchColumn();
            $stmt = $pdo->prepare('INSERT INTO seg_menu (id, menu) VALUES (?, ?)');
            $stmt->execute([$menuId, 'Cadastros']);
        }
        $stmt = $pdo->prepare('SELECT id FROM seg_perfil WHERE nome = ? LIMIT 1');
        $stmt->execute(['Administrador']);
        $perfilId = $stmt->fetchColumn();
        if ($perfilId === false) {
            throw new RuntimeException('Cadastre o perfil Administrador antes de registrar as aplicações de produtos.');
        }
        $order = 100;
        foreach (produtos_catalogo() as $entity => $item) {
            $route = produtos_rota($entity);
            $stmt = $pdo->prepare('SELECT id FROM seg_aplicacoes WHERE rota = ? LIMIT 1');
            $stmt->execute([$route]);
            $appId = $stmt->fetchColumn();
            if ($appId === false) {
                $stmt = $pdo->prepare('INSERT INTO seg_aplicacoes (nome, rota, menu_id, ordem) VALUES (?, ?, ?, ?)');
                $stmt->execute([$item[0], $route, $menuId, $order]);
                $appId = $pdo->lastInsertId();
            } else {
                $stmt = $pdo->prepare('UPDATE seg_aplicacoes SET nome = ?, menu_id = ?, ordem = ? WHERE id = ?');
                $stmt->execute([$item[0], $menuId, $order, $appId]);
            }
            // Preserva permissões existentes e concede somente na primeira instalação.
            $stmt = $pdo->prepare('SELECT id FROM seg_perfil_permissoes WHERE perfil_id = ? AND aplicacao_id = ? LIMIT 1');
            $stmt->execute([$perfilId, $appId]);
            if ($stmt->fetchColumn() === false) {
                $config = produtos_config($entity);
                $write = $item[3] ? 1 : 0;
                $insert = ($write && $config['can_create']) || $entity === 'fotos' ? 1 : 0;
                $delete = ($write && $config['can_delete']) || $entity === 'fotos' ? 1 : 0;
                $process = in_array($entity, ['consolidar', 'importar_antigos', 'precos_lote'], true) ? 1 : 0;
                $stmt = $pdo->prepare('INSERT INTO seg_perfil_permissoes
                    (perfil_id, aplicacao_id, visualizar, inserir, editar, excluir, imprimir, exportar, processar)
                    VALUES (?, ?, 1, ?, ?, ?, 0, 0, ?)');
                $stmt->execute([$perfilId, $appId, $insert, $write, $delete, $process]);
            }
            $order++;
        }
        $pdo->commit();
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $e;
    }
}

if (realpath($_SERVER['SCRIPT_FILENAME'] ?? '') === __FILE__) {
    if (PHP_SAPI !== 'cli') {
        http_response_code(403);
        exit('Execute este instalador pela linha de comando.');
    }
    $options = getopt('', ['config:', 'database:']);
    $configFile = realpath(__DIR__ . '/../' . ($options['config'] ?? 'config/database.php'));
    $configDir = realpath(__DIR__ . '/../config');
    if (!$configFile || dirname($configFile) !== $configDir) {
        fwrite(STDERR, "Informe um arquivo de configuração dentro de config/.\n");
        exit(1);
    }
    require_once $configFile;
    try {
        $database = (string) db()->query('SELECT DATABASE()')->fetchColumn();
        $expected = (string) ($options['database'] ?? 'allop_devel');
        if ($database !== $expected) {
            throw new RuntimeException("Banco configurado: $database. Esperado: $expected. Nenhuma alteração executada.");
        }
        registrar_aplicacoes_produtos(db());
        echo "Submenu Cadastros > Produtos registrado em $database (28 opções).\n";
    } catch (Throwable $e) {
        fwrite(STDERR, $e instanceof PDOException ? "Não foi possível registrar o menu. Confira a conexão e as tabelas de segurança.\n" : $e->getMessage() . "\n");
        exit(1);
    }
}
