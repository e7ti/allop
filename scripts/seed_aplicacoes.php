<?php
/*
    Autor: Claudio Barto
    Data : 01/06/2026
*/
$aplicacao_nome = "seed_aplicacoes.php";
$aplicacao_descricao = "Insere aplicacoes ausentes, perfil Administrador, permissoes e usuario admin quando necessario.";



require_once __DIR__ . '/../config/database.php';

function findId(string $table, string $column, string $value): ?int
{
    $stmt = db()->prepare("SELECT id FROM $table WHERE $column = :value LIMIT 1");
    $stmt->execute(['value' => $value]);
    $id = $stmt->fetchColumn();
    return $id !== false && $id !== null ? (int) $id : null;
}

function nextMenuId(): int
{
    return (int) db()->query("SELECT COALESCE(MAX(id), 0) + 1 FROM seg_menu")->fetchColumn();
}

function saveMenu(string $menu, ?int $forceId = null): int
{
    $id = findId('seg_menu', 'menu', $menu);
    if ($id !== null) {
        if ($forceId !== null && $id !== $forceId) {
            $stmt = db()->prepare("SELECT id FROM seg_menu WHERE id = :id LIMIT 1");
            $stmt->execute(['id' => $forceId]);
            if (!$stmt->fetchColumn()) {
                $stmt = db()->prepare("UPDATE seg_menu SET id = :force_id WHERE id = :id");
                $stmt->execute(['force_id' => $forceId, 'id' => $id]);

                $stmt = db()->prepare("UPDATE seg_aplicacoes SET menu_id = :force_id WHERE menu_id = :id");
                $stmt->execute(['force_id' => $forceId, 'id' => $id]);

                return $forceId;
            }
        }

        $stmt = db()->prepare("UPDATE seg_menu SET menu = :menu WHERE id = :id");
        $stmt->execute(['id' => $id, 'menu' => $menu]);

        return $id;
    }

    if ($forceId !== null) {
        $stmt = db()->prepare("SELECT id FROM seg_menu WHERE id = :id LIMIT 1");
        $stmt->execute(['id' => $forceId]);
        if ($stmt->fetchColumn()) {
            $stmt = db()->prepare("UPDATE seg_menu SET menu = :menu WHERE id = :id");
            $stmt->execute(['id' => $forceId, 'menu' => $menu]);
            return $forceId;
        }
    }

    $id = $forceId ?? nextMenuId();
    $stmt = db()->prepare("INSERT INTO seg_menu (id, menu) VALUES (:id, :menu)");
    $stmt->execute(['id' => $id, 'menu' => $menu]);
    return $id;
}

function deleteAplicacaoByRoute(string $route): void
{
    $aplicacaoId = findId('seg_aplicacoes', 'rota', $route);
    if (!$aplicacaoId) {
        return;
    }

    $stmt = db()->prepare("DELETE FROM seg_perfil_permissoes WHERE aplicacao_id = :id");
    $stmt->execute(['id' => $aplicacaoId]);

    $stmt = db()->prepare("DELETE FROM seg_usuarios_permissoes WHERE aplicacao_id = :id");
    $stmt->execute(['id' => $aplicacaoId]);

    $stmt = db()->prepare("DELETE FROM seg_aplicacoes WHERE id = :id");
    $stmt->execute(['id' => $aplicacaoId]);
}

function deleteMenuByName(string $menu): void
{
    $stmt = db()->prepare(
        "DELETE m
           FROM seg_menu m
           LEFT JOIN seg_aplicacoes a ON a.menu_id = m.id
          WHERE m.menu = :menu
            AND a.id IS NULL"
    );
    $stmt->execute(['menu' => $menu]);
}

function renameMenuIfExists(string $from, string $to): void
{
    $menuId = findId('seg_menu', 'menu', $from);
    if (!$menuId || findId('seg_menu', 'menu', $to)) {
        return;
    }

    $stmt = db()->prepare("UPDATE seg_menu SET menu = :to WHERE id = :id");
    $stmt->execute(['to' => $to, 'id' => $menuId]);
}

function saveAplicacao(array $app): int
{
    $id = findId('seg_aplicacoes', 'rota', $app['rota']);
    if ($id) {
        $stmt = db()->prepare(
            "UPDATE seg_aplicacoes
                SET nome = :nome,
                    menu_id = :menu_id,
                    ordem = :ordem
              WHERE id = :id"
        );
        $stmt->execute([
            'nome' => $app['nome'],
            'menu_id' => $app['menu_id'],
            'ordem' => $app['ordem'],
            'id' => $id,
        ]);
        return $id;
    }

    $stmt = db()->prepare(
        "INSERT INTO seg_aplicacoes (nome, rota, menu_id, ordem)
         VALUES (:nome, :rota, :menu_id, :ordem)"
    );
    $stmt->execute($app);
    return (int) db()->lastInsertId();
}

function ensurePerfilPermissao(int $perfilId, int $aplicacaoId): void
{
    $stmt = db()->prepare(
        "SELECT id
           FROM seg_perfil_permissoes
          WHERE perfil_id = :perfil_id
            AND aplicacao_id = :aplicacao_id
          LIMIT 1"
    );
    $stmt->execute(['perfil_id' => $perfilId, 'aplicacao_id' => $aplicacaoId]);

    if ($stmt->fetchColumn()) {
        return;
    }

    $stmt = db()->prepare(
        "INSERT INTO seg_perfil_permissoes
            (aplicacao_id, perfil_id, visualizar, inserir, editar, excluir, imprimir, exportar, processar)
         VALUES
            (:aplicacao_id, :perfil_id, 1, 1, 1, 1, 1, 1, 1)"
    );
    $stmt->execute(['aplicacao_id' => $aplicacaoId, 'perfil_id' => $perfilId]);
}

$perfilId = findId('seg_perfil', 'nome', 'Administrador');
if (!$perfilId) {
    $stmt = db()->prepare("INSERT INTO seg_perfil (nome) VALUES (:nome)");
    $stmt->execute(['nome' => 'Administrador']);
    $perfilId = (int) db()->lastInsertId();
}

deleteAplicacaoByRoute('dashboard.php');
deleteMenuByName('Principal');
deleteMenuByName('Sair');
renameMenuIfExists('Seguranca', 'Segurança');

$menuConfiguracoesId = saveMenu('Configurações', 10);
$menuProdutosId = saveMenu('Produtos', 20);
$menuCadastrosId = saveMenu('Cadastros', 30);
$menuComprasId = saveMenu('Compras', 40);
$menuOperacionalId = saveMenu('Operacional', 50);
$menuGerencialId = saveMenu('Gerencial', 60);
$menuSegurancaId = saveMenu('Segurança', 90);
$menuAjudaId = saveMenu('Ajuda', 98);

$empresasRoute = 'mod/configuracoes/empresas/empresas_lista.php';
$empresasCdRoute = 'mod/configuracoes/empresas_cd/empresas_cd_lista.php';
$emailRoute = 'mod/configuracoes/configuracoes_email/configuracoes_email_lista.php';
$cpComprasRoute = 'mod/compras/cp_compras_lista.php';
$oldEmailRoutes = [
    'mod/configuracoes_email/email_lista.php',
    'mod/configuracoes/email_lista.php',
];

foreach ($oldEmailRoutes as $oldEmailRoute) {
    $oldEmailRouteId = findId('seg_aplicacoes', 'rota', $oldEmailRoute);
    if (!$oldEmailRouteId) {
        continue;
    }

    $emailRouteId = findId('seg_aplicacoes', 'rota', $emailRoute);
    if ($emailRouteId && $emailRouteId !== $oldEmailRouteId) {
        $stmt = db()->prepare("DELETE FROM seg_perfil_permissoes WHERE aplicacao_id = :id");
        $stmt->execute(['id' => $oldEmailRouteId]);
        $stmt = db()->prepare("DELETE FROM seg_usuarios_permissoes WHERE aplicacao_id = :id");
        $stmt->execute(['id' => $oldEmailRouteId]);
        $stmt = db()->prepare("DELETE FROM seg_aplicacoes WHERE id = :id");
        $stmt->execute(['id' => $oldEmailRouteId]);
        continue;
    }

    $stmt = db()->prepare("UPDATE seg_aplicacoes SET rota = :rota WHERE id = :id");
    $stmt->execute([
        'rota' => $emailRoute,
        'id' => $oldEmailRouteId,
    ]);
}

$aplicacoes = [
    ['nome' => 'Usuarios', 'rota' => 'mod/seguranca/usuarios_lista.php', 'menu_id' => $menuSegurancaId, 'ordem' => 10],
    ['nome' => 'Perfis', 'rota' => 'mod/seguranca/perfis_lista.php', 'menu_id' => $menuSegurancaId, 'ordem' => 20],
    ['nome' => 'Aplicacoes', 'rota' => 'mod/seguranca/aplicacoes_lista.php', 'menu_id' => $menuSegurancaId, 'ordem' => 30],
    ['nome' => 'Perfil x Aplicacoes', 'rota' => 'mod/seguranca/perfil_aplicacoes_lista.php', 'menu_id' => $menuSegurancaId, 'ordem' => 40],
    ['nome' => 'Usuario x Aplicacoes', 'rota' => 'mod/seguranca/usuarios_permissoes_lista.php', 'menu_id' => $menuSegurancaId, 'ordem' => 50],
    ['nome' => 'Empresas CD', 'rota' => $empresasCdRoute, 'menu_id' => $menuConfiguracoesId, 'ordem' => 5],
    ['nome' => 'Empresas', 'rota' => $empresasRoute, 'menu_id' => $menuConfiguracoesId, 'ordem' => 6],
    ['nome' => 'E-mail', 'rota' => $emailRoute, 'menu_id' => $menuConfiguracoesId, 'ordem' => 10],
    ['nome' => 'Pedidos de Compra', 'rota' => $cpComprasRoute, 'menu_id' => $menuComprasId, 'ordem' => 10],
];

foreach ($aplicacoes as $app) {
    $appId = saveAplicacao($app);
    ensurePerfilPermissao($perfilId, $appId);
}

if (!findId('seg_usuarios', 'login', 'admin')) {
    $stmt = db()->prepare(
        "INSERT INTO seg_usuarios (perfil_id, nome, login, senha, ativo)
         VALUES (:perfil_id, :nome, :login, :senha, 1)"
    );
    $stmt->execute([
        'perfil_id' => $perfilId,
        'nome' => 'Administrador',
        'login' => 'admin',
        'senha' => password_hash('Allop@E7ti', PASSWORD_DEFAULT),
    ]);
}

// Garante a existencia da tabela de empresas CD
db()->exec("CREATE TABLE IF NOT EXISTS `empresas_cd` (
    `Codigo` int(11) NOT NULL,
    `NomeCD` varchar(50) NOT NULL,
    `Status` varchar(8) NOT NULL,
    PRIMARY KEY (`Codigo`),
    UNIQUE KEY `IDXNomeCD` (`NomeCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

// Garante a existencia da tabela de empresas
db()->exec("CREATE TABLE IF NOT EXISTS `empresas` (
    `Codigo` int(11) NOT NULL,
    `EmpresaCD` int(11) NOT NULL,
    `Nome` varchar(50) NOT NULL,
    `Fantasia` varchar(50) NOT NULL,
    `CNPJ` varchar(14) NOT NULL,
    `IE` varchar(15) NOT NULL DEFAULT '',
    `CEP` varchar(8) NOT NULL DEFAULT '',
    `TipoEndereco` varchar(25) NOT NULL DEFAULT '',
    `Endereco` varchar(60) NOT NULL DEFAULT '',
    `Numero` varchar(10) NOT NULL DEFAULT '',
    `Complemento` varchar(40) NOT NULL DEFAULT '',
    `Bairro` varchar(50) NOT NULL DEFAULT '',
    `Cidade` varchar(60) NOT NULL DEFAULT '',
    `UF` varchar(2) NOT NULL DEFAULT '',
    `FoneDDD` varchar(2) NOT NULL DEFAULT '',
    `FoneNro` varchar(10) NOT NULL DEFAULT '',
    `CelularDDD` varchar(2) NOT NULL DEFAULT '',
    `CelularNro` varchar(10) NOT NULL DEFAULT '',
    `Responsavel` varchar(60) NOT NULL DEFAULT '',
    `Observacoes` varchar(250) NOT NULL DEFAULT '',
    `CRT` varchar(1) NOT NULL DEFAULT '3',
    `Status` varchar(8) NOT NULL DEFAULT '',
    `Usuario` varchar(60) NOT NULL DEFAULT '',
    `Inclusao` date DEFAULT NULL,
    `Alteracao` date DEFAULT NULL,
    PRIMARY KEY (`Codigo`),
    UNIQUE KEY `IDXNome` (`Nome`),
    UNIQUE KEY `IDXFantasia` (`Fantasia`),
    UNIQUE KEY `IDXCnpj` (`CNPJ`),
    KEY `FK_empresas_empresas_cd` (`EmpresaCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

// Garante a existencia da tabela de configuracoes de e-mail
db()->exec("CREATE TABLE IF NOT EXISTS `configuracoes_email` (
    `Codigo` int(11) NOT NULL AUTO_INCREMENT,
    `cd_id` int(11) NOT NULL,
    `empresa_id` int(11) NOT NULL,
    `NomeConta` varchar(40) NOT NULL DEFAULT '',
    `Habilitado` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1-habilitado, 0-desabilitado',
    `Servidor` varchar(120) NOT NULL DEFAULT '' COMMENT 'Servidor de email',
    `Porta` varchar(10) NOT NULL DEFAULT '' COMMENT 'Porta',
    `ModoAutenticado` varchar(1) NOT NULL DEFAULT '' COMMENT 'Autenticacao S/N',
    `ModoSSL` varchar(1) NOT NULL DEFAULT '' COMMENT ' Modo SSL S/N',
    `Email` varchar(120) NOT NULL DEFAULT '' COMMENT 'Usuario',
    `Senha` varchar(120) NOT NULL DEFAULT '' COMMENT 'Senha',
    `Status` varchar(8) NOT NULL,
    PRIMARY KEY (`Codigo`),
    UNIQUE KEY `IDXNomeConta` (`NomeConta`),
    UNIQUE KEY `IDXCdEmpresaCodigo` (`cd_id`,`empresa_id`,`Codigo`),
    KEY `FK_config_email_empresas` (`empresa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

// Garante a existencia da tabela de URLs dos portais Allop
db()->exec("CREATE TABLE IF NOT EXISTS `urls_allop` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `cd_id` int(11) NOT NULL,
    `empresa_id` int(11) NOT NULL,
    `url_portal_compras` varchar(255) NOT NULL DEFAULT '',
    `url_portal_fornecedor` varchar(255) NOT NULL DEFAULT '',
    `Status` varchar(8) NOT NULL DEFAULT 'Ativo',
    PRIMARY KEY (`id`),
    UNIQUE KEY `IDXUrlsAllopCdEmpresa` (`cd_id`,`empresa_id`),
    KEY `FK_urls_allop_empresas` (`empresa_id`),
    CONSTRAINT `FK_urls_allop_empresas` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
    CONSTRAINT `FK_urls_allop_empresas_cd` FOREIGN KEY (`cd_id`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

// Garante a existencia das tabelas hierarquicas de tamanhos, cores e rateios
db()->exec("CREATE TABLE IF NOT EXISTS `cp_compras_itens_log` (
    `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `log_data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `id` bigint(20) unsigned NOT NULL,
    `cp_compras_id` bigint(20) unsigned NOT NULL DEFAULT '0',
    `referencia_fornecedor` varchar(25) NOT NULL,
    `descricao` varchar(255) NOT NULL,
    `composicao` varchar(255) NOT NULL,
    `ncm` varchar(255) NOT NULL,
    `entrega` date DEFAULT NULL,
    `entrega_anterior` date DEFAULT NULL,
    `total_qtde` double DEFAULT NULL,
    `total_produto` decimal(15,2) DEFAULT NULL,
    `Foto` tinyint(4) NOT NULL DEFAULT '0',
    `Sts` tinyint(4) NOT NULL DEFAULT '1',
    PRIMARY KEY (`log_id`),
    KEY `IDXLogItemId` (`id`),
    KEY `IDXLogItemData` (`log_data`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

db()->exec("CREATE TABLE IF NOT EXISTS `cp_compras_itens_tamanhos` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `compras_itens_id` bigint(20) unsigned NOT NULL,
    `tamanho` varchar(20) NOT NULL DEFAULT '',
    `entrega` date DEFAULT NULL,
    `entrega_anterior` date DEFAULT NULL,
    `markup_franquia` decimal(8,2) NOT NULL DEFAULT '0.00',
    `markup_loja` decimal(8,2) NOT NULL DEFAULT '0.00',
    `qtde_total` decimal(8,2) NOT NULL DEFAULT '0.00',
    `valor_total` decimal(15,2) NOT NULL DEFAULT '0.00',
    `Itens` int(11) NOT NULL DEFAULT '0',
    `Sts` tinyint(4) NOT NULL DEFAULT '1',
    PRIMARY KEY (`id`),
    UNIQUE KEY `IDXItensTamanho` (`compras_itens_id`,`tamanho`),
    CONSTRAINT `FK_cp_compras_itens_tamanhos_cp_compras_itens` FOREIGN KEY (`compras_itens_id`) REFERENCES `cp_compras_itens` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

db()->exec("CREATE TABLE IF NOT EXISTS `cp_compras_itens_tamanhos_log` (
    `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `log_data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `id` bigint(20) unsigned NOT NULL,
    `compras_itens_id` bigint(20) unsigned NOT NULL DEFAULT '0',
    `tamanho` varchar(20) NOT NULL,
    `entrega` date DEFAULT NULL,
    `entrega_anterior` date DEFAULT NULL,
    `markup_franquia` decimal(8,2) NOT NULL DEFAULT '0.00',
    `markup_loja` decimal(8,2) NOT NULL DEFAULT '0.00',
    `qtde_total` decimal(8,2) NOT NULL DEFAULT '0.00',
    `valor_total` decimal(8,2) NOT NULL DEFAULT '0.00',
    `Itens` int(11) NOT NULL DEFAULT '0',
    `Sts` tinyint(4) NOT NULL DEFAULT '1',
    PRIMARY KEY (`log_id`),
    KEY `IDXLogTamanhoId` (`id`),
    KEY `IDXLogTamanhoData` (`log_data`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

db()->exec("CREATE TABLE IF NOT EXISTS `cp_compras_itens_cores` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `compras_itens_tamanho_id` bigint(20) unsigned NOT NULL,
    `sku` varchar(100) DEFAULT NULL,
    `cor` varchar(50) NOT NULL,
    `Qtde` double(8,2) NOT NULL DEFAULT '0.00',
    `preco_fornecedor` decimal(15,2) NOT NULL DEFAULT '0.00',
    `preco_proposta` decimal(15,2) NOT NULL DEFAULT '0.00',
    `valor_total_produto` decimal(15,2) NOT NULL DEFAULT '0.00',
    `preco_franqueado` decimal(15,2) NOT NULL DEFAULT '0.00',
    `markup_franquia` double(8,2) NOT NULL DEFAULT '0.00',
    `preco_loja` decimal(15,2) NOT NULL DEFAULT '0.00',
    `markup_loja` double(12,2) NOT NULL DEFAULT '0.00',
    `markup_total` double(8,2) NOT NULL DEFAULT '0.00',
    `Sts` tinyint(4) NOT NULL DEFAULT '1',
    PRIMARY KEY (`id`),
    UNIQUE KEY `IDXCorTamanho` (`id`,`compras_itens_tamanho_id`),
    KEY `FK_compras_tamanho_cores` (`compras_itens_tamanho_id`),
    CONSTRAINT `FK_compras_tamanho_cores` FOREIGN KEY (`compras_itens_tamanho_id`) REFERENCES `cp_compras_itens_tamanhos` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

db()->exec("CREATE TABLE IF NOT EXISTS `cp_compras_itens_cores_log` (
    `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `log_data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `id` bigint(20) unsigned NOT NULL,
    `compras_itens_tamanho_id` bigint(20) unsigned NOT NULL DEFAULT '0',
    `sku` varchar(100) DEFAULT NULL,
    `cor` varchar(50) NOT NULL,
    `Qtde` double(8,2) NOT NULL DEFAULT '0.00',
    `preco_fornecedor` decimal(15,2) NOT NULL DEFAULT '0.00',
    `preco_proposta` decimal(15,2) NOT NULL DEFAULT '0.00',
    `valor_total_produto` decimal(15,2) NOT NULL DEFAULT '0.00',
    `preco_franqueado` decimal(15,2) NOT NULL DEFAULT '0.00',
    `markup_franquia` double(8,2) NOT NULL DEFAULT '0.00',
    `preco_loja` decimal(15,2) NOT NULL DEFAULT '0.00',
    `markup_loja` double(12,2) NOT NULL DEFAULT '0.00',
    `markup_total` double(8,2) NOT NULL DEFAULT '0.00',
    `Sts` tinyint(4) NOT NULL DEFAULT '1',
    PRIMARY KEY (`log_id`),
    KEY `IDXLogCorId` (`id`),
    KEY `IDXLogCorData` (`log_data`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

db()->exec("CREATE TABLE IF NOT EXISTS `cp_compras_itens_rateios` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `compras_itens_tamanho_id` bigint(20) unsigned NOT NULL,
    `compras_itens_cor_id` bigint(20) unsigned NOT NULL,
    `percentual` decimal(7,4) NOT NULL DEFAULT '0.0000',
    PRIMARY KEY (`id`),
    UNIQUE KEY `IDXRateioTamanhoCor` (`compras_itens_tamanho_id`,`compras_itens_cor_id`),
    KEY `IDXRateioCorTamanho` (`compras_itens_cor_id`,`compras_itens_tamanho_id`),
    CONSTRAINT `FK_rateio_tamanho_cor` FOREIGN KEY (`compras_itens_cor_id`,`compras_itens_tamanho_id`) REFERENCES `cp_compras_itens_cores` (`id`,`compras_itens_tamanho_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

db()->exec("DROP TRIGGER IF EXISTS `cp_compras_itens_after_update`;");
db()->exec("CREATE TRIGGER `cp_compras_itens_after_update` AFTER UPDATE ON `cp_compras_itens` FOR EACH ROW
BEGIN
  INSERT INTO `cp_compras_itens_log`
    (`id`, `cp_compras_id`, `referencia_fornecedor`, `descricao`, `composicao`, `ncm`, `entrega`, `entrega_anterior`, `total_qtde`, `total_produto`, `Foto`, `Sts`)
  VALUES
    (OLD.`id`, OLD.`cp_compras_id`, OLD.`referencia_fornecedor`, OLD.`descricao`, OLD.`composicao`, OLD.`ncm`, OLD.`entrega`, OLD.`entrega_anterior`, OLD.`total_qtde`, OLD.`total_produto`, OLD.`Foto`, OLD.`Sts`);
END;");

db()->exec("DROP TRIGGER IF EXISTS `cp_compras_itens_tamanhos_after_update`;");
db()->exec("CREATE TRIGGER `cp_compras_itens_tamanhos_after_update` AFTER UPDATE ON `cp_compras_itens_tamanhos` FOR EACH ROW
BEGIN
  INSERT INTO `cp_compras_itens_tamanhos_log`
    (`id`, `compras_itens_id`, `tamanho`, `entrega`, `entrega_anterior`, `markup_franquia`, `markup_loja`, `qtde_total`, `valor_total`, `Itens`, `Sts`)
  VALUES
    (OLD.`id`, OLD.`compras_itens_id`, OLD.`tamanho`, OLD.`entrega`, OLD.`entrega_anterior`, OLD.`markup_franquia`, OLD.`markup_loja`, OLD.`qtde_total`, OLD.`valor_total`, OLD.`Itens`, OLD.`Sts`);
END;");

db()->exec("DROP TRIGGER IF EXISTS `cp_compras_itens_cores_after_update`;");
db()->exec("CREATE TRIGGER `cp_compras_itens_cores_after_update` AFTER UPDATE ON `cp_compras_itens_cores` FOR EACH ROW
BEGIN
  INSERT INTO `cp_compras_itens_cores_log`
    (`id`, `compras_itens_tamanho_id`, `sku`, `cor`, `Qtde`, `preco_fornecedor`, `preco_proposta`, `valor_total_produto`, `preco_franqueado`, `markup_franquia`, `preco_loja`, `markup_loja`, `markup_total`, `Sts`)
  VALUES
    (OLD.`id`, OLD.`compras_itens_tamanho_id`, OLD.`sku`, OLD.`cor`, OLD.`Qtde`, OLD.`preco_fornecedor`, OLD.`preco_proposta`, OLD.`valor_total_produto`, OLD.`preco_franqueado`, OLD.`markup_franquia`, OLD.`preco_loja`, OLD.`markup_loja`, OLD.`markup_total`, OLD.`Sts`);
END;");

echo "Seed executado com sucesso.\n";
?>
