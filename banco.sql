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

-- Copiando estrutura para tabela allop_new.configuracoes_email
DROP TABLE IF EXISTS `config_email`;
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

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_new.empresas
DROP TABLE IF EXISTS `empresas`;
CREATE TABLE `empresas` (
	`Codigo` INT(11) NOT NULL,
	`EmpresaCD` INT(11) NOT NULL,
	`Nome` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`Fantasia` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`CNPJ` VARCHAR(14) NOT NULL COLLATE 'utf8_general_ci',
	`IE` VARCHAR(15) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`CEP` VARCHAR(8) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`TipoEndereco` VARCHAR(25) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Endereco` VARCHAR(60) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Numero` VARCHAR(10) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Complemento` VARCHAR(40) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Bairro` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Cidade` VARCHAR(60) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`UF` VARCHAR(2) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`ibge` VARCHAR(7) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`FoneDDD` VARCHAR(2) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`FoneNro` VARCHAR(10) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`CelularDDD` VARCHAR(2) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`CelularNro` VARCHAR(10) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Responsavel` VARCHAR(60) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Observacoes` VARCHAR(250) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`CRT` VARCHAR(1) NOT NULL DEFAULT '3' COLLATE 'utf8_general_ci',
	`Status` VARCHAR(8) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Usuario` VARCHAR(60) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`Inclusao` DATE NULL DEFAULT NULL,
	`Alteracao` DATE NULL DEFAULT NULL,
	PRIMARY KEY (`Codigo`) USING BTREE,
	UNIQUE INDEX `IDXNome` (`Nome`) USING BTREE,
	UNIQUE INDEX `IDXFantasia` (`Fantasia`) USING BTREE,
	UNIQUE INDEX `IDXCnpj` (`CNPJ`) USING BTREE,
	INDEX `FK_empresas_situacao` (`Status`) USING BTREE,
	INDEX `FK_empresas_empresas_cd` (`EmpresaCD`) USING BTREE,
	CONSTRAINT `FK_empresas_empresas_cd` FOREIGN KEY (`EmpresaCD`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION ON DELETE RESTRICT,
	CONSTRAINT `FK_empresas_situacao` FOREIGN KEY (`Status`) REFERENCES `situacao` (`StsNome`) ON UPDATE NO ACTION ON DELETE RESTRICT
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_new.empresas_cd
DROP TABLE IF EXISTS `empresas_cd`;
CREATE TABLE IF NOT EXISTS `empresas_cd` (
  `Codigo` int(11) NOT NULL,
  `NomeCD` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXNomeCD` (`NomeCD`),
  KEY `FK_empresas_cd_situacao` (`Status`),
  CONSTRAINT `FK_empresas_cd_situacao` FOREIGN KEY (`Status`) REFERENCES `situacao` (`StsNome`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_new.seg_aplicacoes
DROP TABLE IF EXISTS `seg_aplicacoes`;
CREATE TABLE IF NOT EXISTS `seg_aplicacoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `rota` varchar(255) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `ordem` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDXMenuOrdem` (`menu_id`,`ordem`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_new.seg_menu
DROP TABLE IF EXISTS `seg_menu`;
CREATE TABLE IF NOT EXISTS `seg_menu` (
  `id` int(11) NOT NULL,
  `menu` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_new.seg_perfil
DROP TABLE IF EXISTS `seg_perfil`;
CREATE TABLE IF NOT EXISTS `seg_perfil` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_new.seg_perfil_permissoes
DROP TABLE IF EXISTS `seg_perfil_permissoes`;
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_new.seg_usuarios
DROP TABLE IF EXISTS `seg_usuarios`;
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

-- Copiando estrutura para tabela allop_new.seg_usuarios_permissoes
DROP TABLE IF EXISTS `seg_usuarios_permissoes`;
CREATE TABLE IF NOT EXISTS `seg_usuarios_permissoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `aplicacao_id` int(11) NOT NULL,
  `visualizar` int(11) NOT NULL,
  `inserir` int(11) NOT NULL,
  `edtiar` int(11) NOT NULL,
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
