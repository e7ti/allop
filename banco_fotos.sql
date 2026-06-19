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

-- Copiando estrutura para tabela allop_devel_fotos.cp_compras_fotos
CREATE TABLE IF NOT EXISTS `cp_compras_fotos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cp_compras_id` bigint(20) NOT NULL COMMENT 'ID da tabela de cp_compras -> Allop',
  `ref_fornecedor` varchar(25) NOT NULL COMMENT 'Codigo do fornecedor, referencia do fornecedor',
  `fornecedor_id` varchar(2) NOT NULL COMMENT 'id do fornecedor da tabela produtos_fornecedor, ex: KK - Kyly',
  `Sequencia` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero sequencial para foto, quando tem mais de uma foto, faz parte da chave unica',
  `foto` mediumblob COMMENT 'Base 64 da foto',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXCompras` (`cp_compras_id`,`ref_fornecedor`,`fornecedor_id`,`Sequencia`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela allop_devel_fotos.cp_compras_fotos_ks
CREATE TABLE IF NOT EXISTS `cp_compras_fotos_ks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cp_compras_id` bigint(20) NOT NULL COMMENT 'ID da tabela de cp_compras -> Allop',
  `ref_fornecedor` varchar(25) NOT NULL COMMENT 'Codigo do fornecedor, referencia do fornecedor',
  `fornecedor_id` varchar(2) NOT NULL COMMENT 'id do fornecedor da tabela produtos_fornecedor, ex: KK - Kyly',
  `Sequencia` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero sequencial para foto, quando tem mais de uma foto, faz parte da chave unica',
  `foto` mediumblob COMMENT 'Base 64 da foto',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `IDXCompras` (`cp_compras_id`,`ref_fornecedor`,`fornecedor_id`,`Sequencia`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- Exportação de dados foi desmarcado.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
