-- --------------------------------------------------------
-- Servidor:                     g.gcompdv.com.br
-- Versão do servidor:           5.7.35-log - MySQL Community Server (GPL)
-- OS do Servidor:               Linux
-- HeidiSQL Versão:              12.7.0.6850
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Copiando estrutura para tabela allop_devel.situacao
CREATE TABLE IF NOT EXISTS `situacao` (
  `StsNome` varchar(8) NOT NULL,
  PRIMARY KEY (`StsNome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando estrutura para tabela allop_devel.empresas_cd
CREATE TABLE IF NOT EXISTS `empresas_cd` (
  `Codigo` int(11) NOT NULL,
  `NomeCD` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXNomeCD` (`NomeCD`),
  KEY `FK_empresas_cd_situacao` (`Status`),
  CONSTRAINT `FK_empresas_cd_situacao` FOREIGN KEY (`Status`) REFERENCES `situacao` (`StsNome`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando estrutura para tabela allop_devel.empresas
CREATE TABLE IF NOT EXISTS `empresas` (
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
  UNIQUE KEY `IDXNome` (`Nome`) USING BTREE,
  UNIQUE KEY `IDXFantasia` (`Fantasia`) USING BTREE,
  UNIQUE KEY `IDXCnpj` (`CNPJ`),
  KEY `FK_empresas_situacao` (`Status`),
  KEY `FK_empresas_empresas_cd` (`EmpresaCD`),
  CONSTRAINT `FK_empresas_empresas_cd` FOREIGN KEY (`EmpresaCD`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_empresas_situacao` FOREIGN KEY (`Status`) REFERENCES `situacao` (`StsNome`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando estrutura para tabela allop_devel.config_email
CREATE TABLE IF NOT EXISTS `config_email` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `cd_id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `NomeConta` varchar(40) NOT NULL DEFAULT '',
  `Habilitado` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1-habilitado, 0-desabilitado',
  `Servidor` varchar(120) NOT NULL DEFAULT '' COMMENT 'Servidor de email',
  `Porta` varchar(10) NOT NULL DEFAULT '' COMMENT 'Porta',
  `ModoAutenticado` varchar(1) NOT NULL DEFAULT '' COMMENT 'Autenticacao S/N',
  `ModoSSL` varchar(1) NOT NULL DEFAULT '' COMMENT ' Modo SSL S/N',
  `Email` varchar(120) NOT NULL DEFAULT '' COMMENT 'Usuário',
  `Senha` varchar(120) NOT NULL DEFAULT '' COMMENT 'Senha',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXNomeConta` (`NomeConta`),
  UNIQUE KEY `IDXCdEmpresaCodigo` (`cd_id`,`empresa_id`,`Codigo`),
  KEY `FK_config_email_empresas` (`empresa_id`),
  CONSTRAINT `FK_config_email_empresas` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_config_email_empresas_cd` FOREIGN KEY (`cd_id`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Copiando estrutura para tabela allop_devel.configuracoes_email
CREATE TABLE IF NOT EXISTS `configuracoes_email` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando estrutura para tabela allop_devel.cp_compras
CREATE TABLE IF NOT EXISTS `cp_compras` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cd_id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `Fornecedor_id` varchar(2) CHARACTER SET latin1 NOT NULL,
  `DataPedido` date NOT NULL,
  `MarkupFranqueadora` decimal(6,2) NOT NULL,
  `MarkupFranquia` decimal(6,2) NOT NULL,
  `MarkupTotal` decimal(6,2) NOT NULL,
  `ValorTotalPedido` decimal(15,2) NOT NULL DEFAULT '0.00',
  `Sts` varchar(30) CHARACTER SET latin1 NOT NULL DEFAULT 'Aberto' COMMENT 'Aberto/Aprovado/Recusado/Aprovado aguardando foto/Consolidado',
  `TemFotos` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 - Não tem, 1 - Tem',
  `StsMotivo` varchar(500) CHARACTER SET latin1 DEFAULT '',
  `Localizacao` varchar(15) CHARACTER SET latin1 NOT NULL DEFAULT 'KidStok' COMMENT 'Allop/Fornecedor',
  `DataAprovacao` date DEFAULT NULL,
  `DataRecusa` date DEFAULT NULL,
  `UsuarioAprovacao` varchar(50) CHARACTER SET latin1 DEFAULT '',
  `UsuarioRecusa` varchar(50) CHARACTER SET latin1 DEFAULT '',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `Iteracao` int(11) NOT NULL DEFAULT '0' COMMENT 'Iteracoes allop',
  `Publicado` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_cp_compras_produtos_fornecedor` (`Fornecedor_id`),
  KEY `FK_cp_compras_empresas` (`empresa_id`),
  KEY `FK_cp_compras_empresas_cd` (`cd_id`) USING BTREE,
  CONSTRAINT `FK_cp_compras_empresas` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_empresas_cd` FOREIGN KEY (`cd_id`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_produtos_fornecedor` FOREIGN KEY (`Fornecedor_id`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.cp_compras_config
CREATE TABLE IF NOT EXISTS `cp_compras_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cd_id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `url_portal_compras` varchar(255) NOT NULL DEFAULT '',
  `url_portal_fornecedor` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXCdEmpresa` (`cd_id`,`empresa_id`),
  KEY `FK_cp_compras_config_empresas` (`empresa_id`),
  CONSTRAINT `FK_cp_compras_config_empresas` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_config_empresas_cd` FOREIGN KEY (`cd_id`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.cp_compras_emails
CREATE TABLE IF NOT EXISTS `cp_compras_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config_email_id` int(11) NOT NULL,
  `Nome` varchar(60) NOT NULL,
  `email` varchar(120) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-inativo, 1-ativo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXEmail` (`email`),
  KEY `IDXNome` (`Nome`),
  KEY `FK_cp_compras_emails_config_email` (`config_email_id`),
  CONSTRAINT `FK_cp_compras_emails_config_email` FOREIGN KEY (`config_email_id`) REFERENCES `config_email` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.cp_compras_itens
CREATE TABLE IF NOT EXISTS `cp_compras_itens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cp_compras_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `referencia_fornecedor` varchar(25) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `composicao` varchar(255) NOT NULL,
  `ncm` varchar(255) NOT NULL,
  `entrega` date DEFAULT NULL,
  `entrega_anterior` date DEFAULT NULL,
  `total_qtde` double DEFAULT NULL,
  `total_produto` decimal(15,2) DEFAULT NULL,
  `Foto` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 - Sem foto, 1 - Tem foto',
  `Sts` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0 - inativo, 1 - ativo',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `Index 3` (`cp_compras_id`,`referencia_fornecedor`),
  CONSTRAINT `FK_cp_compras_itens_cp_compras` FOREIGN KEY (`cp_compras_id`) REFERENCES `cp_compras` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.cp_compras_itens_cores
CREATE TABLE IF NOT EXISTS `cp_compras_itens_cores` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compras_itens_tamanho_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `sku` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cor` varchar(50) NOT NULL,
  `Qtde` double(8,2) NOT NULL DEFAULT '0.00',
  `preco_fornecedor` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'Preco Tabela Fornecedor',
  `preco_proposta` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'Preco Proposta',
  `valor_total_produto` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor Total do Produto',
  `preco_franqueado` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'Preco Franqueado - Simulado',
  `markup_franquia` double(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da Franquia',
  `preco_loja` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'Preco Loja - Simulacao',
  `markup_loja` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da Loja',
  `markup_total` double(8,2) NOT NULL DEFAULT '0.00',
  `Sts` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0 - inativo, 1 - ativo',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_cp_compras_itens_cores_cp_compras_itens_tamanhos` (`compras_itens_tamanho_id`),
  CONSTRAINT `FK_cp_compras_itens_cores_cp_compras_itens_tamanhos` FOREIGN KEY (`compras_itens_tamanho_id`) REFERENCES `cp_compras_itens_tamanhos` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4231 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.cp_compras_itens_tamanhos
CREATE TABLE IF NOT EXISTS `cp_compras_itens_tamanhos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compras_itens_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'id do item',
  `tamanho` varchar(20) NOT NULL COMMENT 'tamanho do produto',
  `entrega` date NOT NULL COMMENT 'data de entrega',
  `entrega_anterior` date NOT NULL COMMENT 'data de entrega anterior',
  `markup_franquia` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da franquia',
  `markup_loja` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da loja (franqueado)',
  `qtde_total` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Total de quantidades',
  `valor_total` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor total do tamanho',
  `Itens` int(11) NOT NULL DEFAULT '0' COMMENT 'Quantidade de itens tem o tamanho',
  `Sts` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0 - inativo, 1 - ativo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXItensTamanho` (`compras_itens_id`,`tamanho`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Tabela de itens de tamanhos, separação de tamanhos.';

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.cp_compras_itens_rateios
CREATE TABLE IF NOT EXISTS `cp_compras_itens_rateios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compras_itens_tamanho_id` bigint(20) unsigned NOT NULL,
  `compras_itens_cor_id` bigint(20) unsigned NOT NULL,
  `percentual` decimal(7,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXRateioTamanhoCor` (`compras_itens_tamanho_id`,`compras_itens_cor_id`),
  KEY `IDXRateioCor` (`compras_itens_cor_id`),
  CONSTRAINT `FK_cp_compras_itens_rateios_cp_compras_itens_tamanhos` FOREIGN KEY (`compras_itens_tamanho_id`) REFERENCES `cp_compras_itens_tamanhos` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_rateio_cor` FOREIGN KEY (`compras_itens_cor_id`) REFERENCES `cp_compras_itens_cores` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Rateio percentual das cores para cada tamanho';

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.pf_colecao
CREATE TABLE IF NOT EXISTS `pf_colecao` (
  `id_item` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `colecao_id` int(11) unsigned NOT NULL COMMENT 'Coluna "Colecao" do CSV',
  `id_fornecedor` varchar(2) CHARACTER SET latin1 NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_referencia` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cor_produto` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tamanho` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `peso` decimal(10,3) DEFAULT '0.000',
  `ncm` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `composicao` text COLLATE utf8mb4_unicode_ci,
  `valor_unitario` decimal(10,2) DEFAULT '0.00',
  `data_importacao` date DEFAULT NULL,
  `hora_importacao` time DEFAULT NULL,
  PRIMARY KEY (`id_item`),
  UNIQUE KEY `sku` (`id_fornecedor`,`sku`) USING BTREE,
  KEY `idx_sku` (`sku`),
  KEY `idx_referencia` (`codigo_referencia`),
  KEY `idx_colecao_id` (`colecao_id`) USING BTREE,
  KEY `FK_pf_colecao_produtos_fornecedor` (`id_fornecedor`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30268 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.pf_usuarios
CREATE TABLE IF NOT EXISTS `pf_usuarios` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `perfil` enum('admin','fornecedor') DEFAULT 'fornecedor',
  `status` tinyint(1) DEFAULT '1' COMMENT '0 - Inativo, 1 - Ativo',
  `criado_em` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.pf_usuario_fornecedor
CREATE TABLE IF NOT EXISTS `pf_usuario_fornecedor` (
  `id_usuario` int(10) unsigned NOT NULL,
  `id_fornecedor` varchar(2) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_fornecedor`),
  KEY `FK_pf_usuario_fornecedor_produtos_fornecedor` (`id_fornecedor`),
  CONSTRAINT `FK_pf_usuario_fornecedor_pf_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `pf_usuarios` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pf_usuario_fornecedor_produtos_fornecedor` FOREIGN KEY (`id_fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.produtos_fornecedor
CREATE TABLE IF NOT EXISTS `produtos_fornecedor` (
  `Codigo` varchar(2) NOT NULL,
  `NomeFornecedor` varchar(30) NOT NULL,
  `ProducaoProria` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'Indica se é producao propria',
  `MarkUpCompra` double NOT NULL DEFAULT '0',
  `MarkupFranqueadora` double NOT NULL DEFAULT '0',
  `CFOP_PP` varchar(4) NOT NULL DEFAULT '',
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXNome` (`NomeFornecedor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='R1 -> tbProdutosFornecedor';

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.seg_aplicacoes
CREATE TABLE IF NOT EXISTS `seg_aplicacoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `rota` varchar(255) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `ordem` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDXMenuOrdem` (`menu_id`,`ordem`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.seg_menu
CREATE TABLE IF NOT EXISTS `seg_menu` (
  `id` int(11) NOT NULL,
  `menu` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.seg_perfil
CREATE TABLE IF NOT EXISTS `seg_perfil` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.seg_perfil_permissoes
CREATE TABLE IF NOT EXISTS `seg_perfil_permissoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aplicacao_id` int(11) NOT NULL,
  `perfil_id` int(11) NOT NULL,
  `visualizar` tinyint(4) NOT NULL DEFAULT '0',
  `inserir` tinyint(4) NOT NULL DEFAULT '0',
  `editar` tinyint(4) NOT NULL DEFAULT '0',
  `excluir` tinyint(4) NOT NULL DEFAULT '0',
  `imprimir` tinyint(4) NOT NULL DEFAULT '0',
  `exportar` tinyint(4) NOT NULL DEFAULT '0',
  `processar` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK__seg_aplicacoes` (`aplicacao_id`),
  KEY `FK__seg_perfil` (`perfil_id`),
  CONSTRAINT `FK__seg_aplicacoes` FOREIGN KEY (`aplicacao_id`) REFERENCES `seg_aplicacoes` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK__seg_perfil` FOREIGN KEY (`perfil_id`) REFERENCES `seg_perfil` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.seg_usuarios
CREATE TABLE IF NOT EXISTS `seg_usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `perfil_id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `login` varchar(120) NOT NULL,
  `senha` varchar(120) NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0-Inativo, 1-Ativo',
  PRIMARY KEY (`id`),
  KEY `FK_seg_usuarios_seg_perfil` (`perfil_id`),
  CONSTRAINT `FK_seg_usuarios_seg_perfil` FOREIGN KEY (`perfil_id`) REFERENCES `seg_perfil` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel.seg_usuarios_permissoes
CREATE TABLE IF NOT EXISTS `seg_usuarios_permissoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `aplicacao_id` int(11) NOT NULL,
  `visualizar` int(11) NOT NULL,
  `inserir` int(11) NOT NULL,
  `editar` int(11) NOT NULL,
  `excluir` int(11) NOT NULL,
  `imprirmir` int(11) NOT NULL,
  `exportar` int(11) NOT NULL,
  `processar` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_seg_usuarios_permissoes_seg_usuarios` (`usuario_id`),
  KEY `FK_seg_usuarios_permissoes_seg_aplicacoes` (`aplicacao_id`),
  CONSTRAINT `FK_seg_usuarios_permissoes_seg_aplicacoes` FOREIGN KEY (`aplicacao_id`) REFERENCES `seg_aplicacoes` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_seg_usuarios_permissoes_seg_usuarios` FOREIGN KEY (`usuario_id`) REFERENCES `seg_usuarios` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Permissoes por usuario';

-- Exportação de dados foi desmarcado.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
