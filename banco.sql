-- --------------------------------------------------------
-- Banco: allop_devel
-- Servidor MySQL: 5.7.35-log
-- Dump estrutural gerado pelo projeto Allop em 2026-09-21 17:06:44
-- Dados nao incluidos.
-- --------------------------------------------------------
/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.1.2-MariaDB, for Win64 (AMD64)
--
-- Host: g.gcompdv.com.br    Database: allop_devel
-- ------------------------------------------------------
-- Server version	5.7.35-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `KidStok`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `KidStok` (
  `Codigo` varchar(10) NOT NULL,
  `REFERENCIA` varchar(20) NOT NULL,
  `ID_LINHA` int(11) NOT NULL DEFAULT '0',
  `LINHA` varchar(20) NOT NULL,
  `ID_COLECAO` int(11) NOT NULL DEFAULT '0',
  `COLECAO` varchar(30) NOT NULL,
  `ID_GRUPO` int(11) NOT NULL DEFAULT '0',
  `GRUPO` varchar(60) NOT NULL,
  `GRUPO_CATEGORIA` varchar(60) NOT NULL,
  `ID_COMPOSICAO` int(11) NOT NULL DEFAULT '0',
  `COMPOSICAO` varchar(20) NOT NULL,
  `ID_CARACTERISTICA` int(11) NOT NULL DEFAULT '0',
  `CARACTERISTICA` varchar(30) NOT NULL,
  `COR` varchar(20) DEFAULT NULL,
  `ID_GENERO` int(11) NOT NULL DEFAULT '0',
  `GENERO` varchar(10) NOT NULL,
  `FORNECEDOR` varchar(30) DEFAULT NULL,
  `COD_FOR_COMPLETO` varchar(20) DEFAULT NULL,
  `COD_FORNECEDOR_R3` varchar(20) DEFAULT NULL,
  `ID_CATEGORIA` varchar(2) DEFAULT '',
  `CATEGORIA` varchar(40) DEFAULT NULL,
  `TAMANHO` varchar(20) DEFAULT NULL,
  `Descricao` varchar(50) NOT NULL,
  `Unidade` varchar(10) NOT NULL,
  `Varejo` decimal(20,6) NOT NULL,
  `Atacado` decimal(20,6) NOT NULL,
  `Compra` decimal(20,6) NOT NULL,
  `SetorLaranja` varchar(10) NOT NULL,
  `PrecoCheio` varchar(10) NOT NULL,
  `ENCOMENDA` varchar(10) DEFAULT NULL,
  `FASHION` varchar(10) DEFAULT NULL,
  `Status` varchar(10) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(20) NOT NULL,
  KEY `IDXREF` (`REFERENCIA`),
  KEY `IDXCodigo` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `KidStokAntesGCom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `KidStokAntesGCom` (
  `CODIGO` varchar(10) NOT NULL,
  `REFERENCIA_MASTER` varchar(8) NOT NULL,
  `NCM` varchar(10) NOT NULL,
  `REFERENCIA` varchar(20) NOT NULL,
  `ID_LINHA` int(11) NOT NULL DEFAULT '0',
  `LINHA` varchar(60) NOT NULL,
  `ID_COLECAO` int(11) NOT NULL DEFAULT '0',
  `COLECAO` varchar(20) NOT NULL,
  `ID_GRUPO` int(11) NOT NULL DEFAULT '0',
  `GRUPO` varchar(60) NOT NULL,
  `GRUPO_CATEGORIA` varchar(60) NOT NULL,
  `ID_COMPOSICAO` int(11) NOT NULL DEFAULT '0',
  `COMPOSICAO` varchar(20) NOT NULL,
  `ID_CARACTERISTICA` int(11) NOT NULL DEFAULT '0',
  `CARACTERISTICA` varchar(20) DEFAULT NULL,
  `COR` varchar(10) DEFAULT NULL,
  `ID_GENERO` int(11) NOT NULL DEFAULT '0',
  `GENERO` varchar(10) NOT NULL,
  `FORNECEDOR` varchar(10) DEFAULT NULL,
  `COD_FOR_COMPLETO` varchar(10) DEFAULT NULL,
  `COD_FORNECEDOR_R3` varchar(10) DEFAULT NULL,
  `ID_CATEGORIA` varchar(2) DEFAULT NULL,
  `CATEGORIA` varchar(30) DEFAULT NULL,
  `TAMANHO` varchar(10) DEFAULT NULL,
  `DESCRICAO` varchar(50) NOT NULL,
  `UNIDADE` varchar(10) NOT NULL,
  `VAREJO` decimal(20,6) NOT NULL,
  `ATACADO` decimal(20,6) NOT NULL,
  `COMPRA` decimal(20,6) NOT NULL,
  `SETOR_LARANJA` varchar(10) NOT NULL,
  `PRECO_CHEIO` varchar(10) NOT NULL,
  `ENCOMENDA` varchar(10) NOT NULL,
  `FASHION` varchar(10) NOT NULL,
  `STATUS` varchar(10) NOT NULL,
  `INCLUSAO` date NOT NULL,
  `ALTERACAO` date NOT NULL,
  `USUARIO` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bancos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `bancos` (
  `codigoBanco` varchar(3) NOT NULL,
  `nome` varchar(200) NOT NULL,
  PRIMARY KEY (`codigoBanco`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cargos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cargos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Cargo` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cests_ncm`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cests_ncm` (
  `ncm` varchar(8) CHARACTER SET latin1 NOT NULL,
  `cest` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `descricao` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Status` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT 'Ativo',
  PRIMARY KEY (`ncm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cests_ncm_after_insert` AFTER INSERT ON `cests_ncm` FOR EACH ROW BEGIN
	REPLACE INTO cests_ncm_api(	CodigoNCM,
											CodigoCD
										)
										(
											SELECT 
												t1.ncm,
												t2.Codigo			 
											FROM 
												cests_ncm	t1,
												empresas_cd t2
												WHERE 
												t1.ncm = NEW.ncm
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cests_ncm_after_update` AFTER UPDATE ON `cests_ncm` FOR EACH ROW BEGIN
	REPLACE INTO cests_ncm_api(	CodigoNCM,
											CodigoCD
										)
										(
											SELECT 
												t1.ncm,
												t2.Codigo			 
											FROM 
												cests_ncm	t1,
												empresas_cd t2
												WHERE 
												t1.ncm = NEW.ncm
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cests_ncm_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cests_ncm_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoNCM` varchar(8) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoNCM`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cests_ncm_copy`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cests_ncm_copy` (
  `ncm` varchar(8) CHARACTER SET latin1 NOT NULL,
  `cest` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `descricao` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Status` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT 'Ativo',
  PRIMARY KEY (`ncm`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cfops`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cfops` (
  `CFOP` varchar(4) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `Operacao` varchar(8) NOT NULL DEFAULT '' COMMENT 'Entrada / Saída',
  `ICMS_CST` varchar(3) NOT NULL DEFAULT '00' COMMENT 'ST_ICMS',
  `ICMS_Reducao` double NOT NULL DEFAULT '0',
  `PIS_CST` varchar(2) NOT NULL DEFAULT '01' COMMENT 'ST_PIS',
  `PIS_Aliquota` double NOT NULL DEFAULT '0',
  `COFINS_CST` varchar(2) NOT NULL DEFAULT '01' COMMENT 'ST_COFINS',
  `COFINS_Aliquota` double NOT NULL DEFAULT '0',
  `IPI_CST` varchar(2) NOT NULL DEFAULT '53',
  `IPI_Aliquota` double NOT NULL DEFAULT '0',
  `DestacaTributos` varchar(1) NOT NULL DEFAULT '0' COMMENT 'S/N',
  `Mensagem` varchar(120) NOT NULL DEFAULT '',
  `Devolucao` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S/N',
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo' COMMENT 'Ativo/Inativo',
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`CFOP`),
  UNIQUE KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_cfops_st_icms` (`ICMS_CST`),
  KEY `FK_cfops_st_pis` (`PIS_CST`),
  KEY `FK_cfops_st_cofins` (`COFINS_CST`),
  KEY `FK_cfops_st_ipi` (`IPI_CST`),
  CONSTRAINT `FK_cfops_st_cofins` FOREIGN KEY (`COFINS_CST`) REFERENCES `st_cofins` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cfops_st_icms` FOREIGN KEY (`ICMS_CST`) REFERENCES `st_icms` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cfops_st_ipi` FOREIGN KEY (`IPI_CST`) REFERENCES `st_ipi` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cfops_st_pis` FOREIGN KEY (`PIS_CST`) REFERENCES `st_pis` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cfops_after_insert` AFTER INSERT ON `cfops` FOR EACH ROW BEGIN
	REPLACE INTO cfops_api(	CFOP,
								CodigoCD
							) (
								SELECT 
											t1.CFOP,
											t2.Codigo			 
										FROM 
											cfops t1,
											empresas_cd t2
										WHERE 
											t1.CFOP = NEW.CFOP
								);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cfops_after_update` AFTER UPDATE ON `cfops` FOR EACH ROW BEGIN
	REPLACE INTO cfops_api(	CFOP,
								CodigoCD
							) (
								SELECT 
											t1.CFOP,
											t2.Codigo			 
										FROM 
											cfops t1,
											empresas_cd t2
										WHERE 
											t1.CFOP = NEW.CFOP
								);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cfops_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cfops_api` (
  `CodigoCD` int(11) NOT NULL,
  `CFOP` varchar(4) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CFOP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cidades`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cidades` (
  `Codigo` int(11) NOT NULL COMMENT 'Auto Incremento SC',
  `Cidade` varchar(30) NOT NULL,
  `IBGE` varchar(7) DEFAULT NULL,
  `Estado` varchar(2) NOT NULL,
  `CampoPesquisa` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `Index_2` (`CampoPesquisa`) USING BTREE,
  UNIQUE KEY `Index_4` (`Cidade`,`Estado`) USING BTREE,
  KEY `FK_tbCidades_1` (`Estado`) USING BTREE,
  KEY `FK_cidades_ibge` (`IBGE`),
  CONSTRAINT `FK_cidades_ibge` FOREIGN KEY (`IBGE`) REFERENCES `ibge` (`IBGE`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cidades_after_insert` AFTER INSERT ON `cidades` FOR EACH ROW BEGIN
	REPLACE INTO cidades_api(	CodigoCidade,
										CodigoCD
									)
									(
										SELECT 
											t1.Codigo,
											t2.Codigo			 
										FROM 
											cidades 		t1,
											empresas_cd t2
										WHERE 
											t1.Codigo = NEW.Codigo
								);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cidades_after_update` AFTER UPDATE ON `cidades` FOR EACH ROW BEGIN
	REPLACE INTO cidades_api(	CodigoCidade,
										CodigoCD
									)
									(
										SELECT 
											t1.Codigo,
											t2.Codigo			 
										FROM 
											cidades 		t1,
											empresas_cd t2
										WHERE 
											t1.Codigo = NEW.Codigo
								);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cidades_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cidades_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoCidade` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoCidade`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras` (
  `CD` int(10) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `FornecedorCodigo` varchar(2) CHARACTER SET latin1 NOT NULL COMMENT 'produtos_fornecedor',
  `Referencia` varchar(15) NOT NULL DEFAULT '',
  `DataPedido` date DEFAULT NULL,
  `HoraPedido` time DEFAULT NULL,
  `PrevisaoEntrega` date DEFAULT NULL,
  `QtdeTotal` double NOT NULL DEFAULT '0',
  `Itens` double NOT NULL DEFAULT '0',
  `QtdeEntregue` double NOT NULL DEFAULT '0',
  `QtdeSaldo` double DEFAULT '0',
  `ValorTotal` double NOT NULL DEFAULT '0',
  `Observacoes` text,
  `Usuario` varchar(30) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Controle` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CD`,`Pedido`) USING BTREE,
  KEY `IDXCdEmpresaPedido` (`CD`,`Empresa`,`Pedido`),
  KEY `FK_compras_empresas` (`Empresa`),
  KEY `FK_compras_produtos_fornecedor` (`FornecedorCodigo`),
  KEY `IDXDataHoraPedido` (`DataPedido`),
  KEY `IDXDataHoraPrevistaEntrega` (`PrevisaoEntrega`) USING BTREE,
  KEY `IDXReferencia` (`Referencia`),
  CONSTRAINT `FK_compras_empresas` FOREIGN KEY (`Empresa`) REFERENCES `empresas` (`Codigo`),
  CONSTRAINT `FK_compras_empresas_cd` FOREIGN KEY (`CD`) REFERENCES `empresas_cd` (`Codigo`),
  CONSTRAINT `FK_compras_produtos_fornecedor` FOREIGN KEY (`FornecedorCodigo`) REFERENCES `produtos_fornecedor` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `compras_before_delete` BEFORE DELETE ON `compras` FOR EACH ROW BEGIN
	DELETE FROM
	compras_agenda 
	WHERE 
	compras_agenda.CD = OLD.CD
	AND
	compras_agenda.Pedido = OLD.Pedido 
	AND  
	compras_agenda.DataEntrega >= CURRENT_DATE();
	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `compras_agenda`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_agenda` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Fornecedor` varchar(2) NOT NULL,
  `CD` bigint(20) DEFAULT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `DataPedido` date DEFAULT NULL,
  `Referencia` varchar(15) NOT NULL,
  `CodFornecedor` varchar(60) NOT NULL,
  `DataEntrega` date NOT NULL,
  `DataAgendamento` date DEFAULT NULL COMMENT 'obrigatório para passar para o agendamento',
  `NF_numero` int(11) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `Volume` int(11) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `Qtde` int(11) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `NomeMotorista` varchar(50) DEFAULT NULL,
  `Placa_Veiculo` varchar(8) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `Conferente` varchar(50) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `Recepcao` varchar(40) DEFAULT NULL COMMENT 'usuario que recebeu',
  `Situacao` int(11) NOT NULL DEFAULT '0' COMMENT '1 - Aguardando, 2-Agendado, 3-Liberado Entrega, 4-Entregue, 5... 9 -  Cancelado',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(40) DEFAULT '',
  `Posicao` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `FK_compras_agenda_compras_agenda_board` (`Situacao`),
  CONSTRAINT `FK_compras_agenda_compras_agenda_board` FOREIGN KEY (`Situacao`) REFERENCES `compras_agenda_board` (`brdid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_agenda_board`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_agenda_board` (
  `brdid` int(11) NOT NULL AUTO_INCREMENT,
  `brdnome` varchar(50) DEFAULT NULL,
  `brdordem` int(11) NOT NULL,
  PRIMARY KEY (`brdid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_agenda_docs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_agenda_docs` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ComprasAgendaID` bigint(20) unsigned NOT NULL,
  `TipoDocumento` varchar(15) NOT NULL DEFAULT '' COMMENT 'Nota Fiscal, Romaneio, Etc',
  `Documento` int(11) NOT NULL DEFAULT '0',
  `Volumes` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `FK_compras_agenda_docs_compras_agenda` (`ComprasAgendaID`),
  CONSTRAINT `FK_compras_agenda_docs_compras_agenda` FOREIGN KEY (`ComprasAgendaID`) REFERENCES `compras_agenda` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_agenda_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_agenda_hst` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Fornecedor` varchar(2) NOT NULL,
  `CD` bigint(20) DEFAULT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `DataPedido` date DEFAULT NULL,
  `Referencia` varchar(15) NOT NULL,
  `CodFornecedor` varchar(60) NOT NULL,
  `DataEntrega` date NOT NULL,
  `DataAgendamento` date DEFAULT NULL COMMENT 'obrigatório para passar para o agendamento',
  `NF_numero` int(11) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `Volume` int(11) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `Qtde` int(11) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `NomeMotorista` varchar(50) DEFAULT NULL,
  `Placa_Veiculo` varchar(8) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `Conferente` varchar(50) DEFAULT NULL COMMENT 'obrigatório para passar para liberado entrega',
  `Recepcao` varchar(40) DEFAULT NULL COMMENT 'usuario que recebeu',
  `Situacao` int(11) NOT NULL DEFAULT '0' COMMENT '1 - Aguardando, 2-Agendado, 3-Liberado Entrega, 4-Entregue, 5... 9 -  Cancelado',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(40) DEFAULT '',
  `Posicao` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_agenda_itens`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_agenda_itens` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `CompasAgendaID` bigint(20) unsigned NOT NULL,
  `Distribuidora` varchar(20) NOT NULL DEFAULT '',
  `Quantidade` int(11) NOT NULL DEFAULT '0',
  `Tamanho` varchar(50) DEFAULT NULL,
  `Cor` varchar(50) DEFAULT NULL,
  `Descricao` varchar(50) DEFAULT NULL,
  `Saldo` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_compras_agenda_itens_compras_agenda` (`CompasAgendaID`),
  CONSTRAINT `FK_compras_agenda_itens_compras_agenda` FOREIGN KEY (`CompasAgendaID`) REFERENCES `compras_agenda` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_agenda_itens_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_agenda_itens_hst` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `CompasAgendaID` bigint(20) unsigned NOT NULL,
  `Distribuidora` varchar(20) NOT NULL DEFAULT '',
  `Quantidade` int(11) NOT NULL DEFAULT '0',
  `Tamanho` varchar(50) DEFAULT NULL,
  `Cor` varchar(50) DEFAULT NULL,
  `Descricao` varchar(50) DEFAULT NULL,
  `Saldo` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_compras_agenda_itens_hst_compras_agenda_hst` (`CompasAgendaID`),
  CONSTRAINT `FK_compras_agenda_itens_hst_compras_agenda_hst` FOREIGN KEY (`CompasAgendaID`) REFERENCES `compras_agenda_hst` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7037 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_contagem`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_contagem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idCartao` bigint(20) unsigned NOT NULL,
  `CD` int(10) NOT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `Fornecedor` varchar(2) NOT NULL COMMENT 'ligado a tabela de fornecedor',
  `Conferente` varchar(50) DEFAULT NULL COMMENT 'ligado a tabela de conferentes',
  `DataEntrega` date NOT NULL,
  `DataChegada` date DEFAULT NULL,
  `HoraChegada` time DEFAULT NULL,
  `Referencia` varchar(20) DEFAULT NULL,
  `TotalItens` int(11) NOT NULL DEFAULT '0' COMMENT 'quantos itens distintos tem',
  `TotalContagem` int(11) NOT NULL DEFAULT '0' COMMENT 'total de peças contadas',
  `TotalQtdeInformada` int(11) NOT NULL DEFAULT '0' COMMENT 'tem que ser igual totalContagem',
  `Sts` int(11) NOT NULL DEFAULT '0' COMMENT '0-Contagem; 2-Liberado; 99-Consolidado',
  PRIMARY KEY (`id`),
  KEY `FK_compras_contagem_compras_agenda` (`idCartao`),
  KEY `FK_compras_contagem_produtos_fornecedor` (`Fornecedor`),
  KEY `FK_compras_contagem_compras` (`CD`,`Pedido`),
  CONSTRAINT `FK_compras_contagem_compras` FOREIGN KEY (`CD`, `Pedido`) REFERENCES `compras` (`CD`, `Pedido`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_compras_contagem_compras_agenda` FOREIGN KEY (`idCartao`) REFERENCES `compras_agenda` (`ID`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_compras_contagem_produtos_fornecedor` FOREIGN KEY (`Fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_contagem_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_contagem_hst` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idCartao` bigint(20) unsigned NOT NULL,
  `CD` int(10) NOT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `Fornecedor` varchar(2) NOT NULL COMMENT 'ligado a tabela de fornecedor',
  `Conferente` varchar(50) DEFAULT NULL COMMENT 'ligado a tabela de conferentes',
  `DataEntrega` date NOT NULL,
  `DataChegada` date DEFAULT NULL,
  `HoraChegada` time DEFAULT NULL,
  `Referencia` varchar(20) DEFAULT NULL,
  `TotalItens` int(11) NOT NULL DEFAULT '0' COMMENT 'quantos itens distintos tem',
  `TotalContagem` int(11) NOT NULL DEFAULT '0' COMMENT 'total de peças contadas',
  `TotalQtdeInformada` int(11) NOT NULL DEFAULT '0' COMMENT 'tem que ser igual totalContagem',
  `Sts` int(11) NOT NULL DEFAULT '0' COMMENT '0-Contagem; 2-Liberado; 99-Consolidado',
  PRIMARY KEY (`id`),
  KEY `FK_compras_contagem_hst_compras_agenda_hst` (`idCartao`),
  CONSTRAINT `FK_compras_contagem_hst_compras_agenda_hst` FOREIGN KEY (`idCartao`) REFERENCES `compras_agenda_hst` (`ID`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_contagem_itens`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_contagem_itens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `idComprasContagem` int(11) NOT NULL,
  `ReferenciaMaster` varchar(50) DEFAULT NULL,
  `Referencia` varchar(20) DEFAULT NULL,
  `Tamanho` varchar(2) DEFAULT NULL COMMENT 'ligada a tabela de tamanho',
  `Cor` varchar(2) DEFAULT NULL COMMENT 'ligada a tabela de cor',
  `Qtde` int(11) NOT NULL DEFAULT '0',
  `QtdeContagem` int(11) NOT NULL DEFAULT '0' COMMENT 'quanto ele contou',
  `Saldo` int(11) NOT NULL DEFAULT '0' COMMENT 'Qtde - QtdeContagem',
  `StsControle` int(11) NOT NULL DEFAULT '0' COMMENT '2-Não Aceitar; 1-Aceitar ',
  `AguardarSaldoRestante` int(11) NOT NULL DEFAULT '0' COMMENT '2-Não Aguardar; 1-Aguardar',
  PRIMARY KEY (`id`),
  KEY `FK_compras_contagem_itens_produtos_tamanho` (`Tamanho`),
  KEY `FK_compras_contagem_itens_produtos_cor` (`Cor`),
  KEY `FK_compras_contagem_itens_compras_contagem` (`idComprasContagem`),
  KEY `IDXMasterTamanho` (`ReferenciaMaster`,`Tamanho`) USING BTREE,
  CONSTRAINT `FK_compras_contagem_itens_compras_contagem` FOREIGN KEY (`idComprasContagem`) REFERENCES `compras_contagem` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_compras_contagem_itens_produtos_cor` FOREIGN KEY (`Cor`) REFERENCES `produtos_cor` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_compras_contagem_itens_produtos_tamanho` FOREIGN KEY (`Tamanho`) REFERENCES `produtos_tamanho` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_contagem_itens_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_contagem_itens_hst` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `idComprasContagem` int(11) NOT NULL,
  `ReferenciaMaster` varchar(50) DEFAULT NULL,
  `Referencia` varchar(20) DEFAULT NULL,
  `Tamanho` varchar(2) DEFAULT NULL COMMENT 'ligada a tabela de tamanho',
  `Cor` varchar(2) DEFAULT NULL COMMENT 'ligada a tabela de cor',
  `Qtde` int(11) NOT NULL DEFAULT '0',
  `QtdeContagem` int(11) NOT NULL DEFAULT '0' COMMENT 'quanto ele contou',
  `Saldo` int(11) NOT NULL DEFAULT '0' COMMENT 'Qtde - QtdeContagem',
  `StsControle` int(11) NOT NULL DEFAULT '0' COMMENT '2-Não Aceitar; 1-Aceitar ',
  `AguardarSaldoRestante` int(11) NOT NULL DEFAULT '0' COMMENT '2-Não Aguardar; 1-Aguardar',
  PRIMARY KEY (`id`),
  KEY `IDXMasterTamanho` (`ReferenciaMaster`,`Tamanho`)
) ENGINE=InnoDB AUTO_INCREMENT=7037 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_hst` (
  `CD` int(10) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `FornecedorCodigo` varchar(2) CHARACTER SET latin1 NOT NULL COMMENT 'produtos_fornecedor',
  `Referencia` varchar(15) NOT NULL DEFAULT '',
  `DataPedido` date DEFAULT NULL,
  `HoraPedido` time DEFAULT NULL,
  `PrevisaoEntrega` date DEFAULT NULL,
  `QtdeTotal` double NOT NULL DEFAULT '0',
  `Itens` double NOT NULL DEFAULT '0',
  `QtdeEntregue` double NOT NULL DEFAULT '0',
  `QtdeSaldo` double DEFAULT '0',
  `ValorTotal` double NOT NULL DEFAULT '0',
  `Observacoes` text,
  `Usuario` varchar(30) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Controle` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CD`,`Pedido`),
  KEY `FK_compras_hst_empresas` (`Empresa`),
  KEY `FK_compras_hst_produtos_fornecedor` (`FornecedorCodigo`),
  KEY `IDXCdEmpresaPedido` (`CD`,`Empresa`,`Pedido`) USING BTREE,
  KEY `IDXDataHoraPrevistaEntrega` (`PrevisaoEntrega`),
  KEY `IDXReferencia` (`Referencia`),
  KEY `IDXDataHoraPedido` (`DataPedido`),
  CONSTRAINT `FK_compras_hst_empresas` FOREIGN KEY (`Empresa`) REFERENCES `empresas` (`Codigo`),
  CONSTRAINT `FK_compras_hst_empresas_cd` FOREIGN KEY (`CD`) REFERENCES `empresas_cd` (`Codigo`),
  CONSTRAINT `FK_compras_hst_produtos_fornecedor` FOREIGN KEY (`FornecedorCodigo`) REFERENCES `produtos_fornecedor` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_itens`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_itens` (
  `CD` int(10) NOT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `Produto` varchar(8) CHARACTER SET latin1 NOT NULL,
  `Sequencia` int(11) unsigned NOT NULL DEFAULT '0',
  `Distribuidora` varchar(15) NOT NULL,
  `Referencia` varchar(8) NOT NULL,
  `Quantidade` double NOT NULL DEFAULT '0',
  `ValorUnitario` double NOT NULL DEFAULT '0',
  `ValorTotal` double NOT NULL DEFAULT '0',
  `Entregue` double NOT NULL DEFAULT '0',
  `Saldo` double DEFAULT NULL,
  `PrevisaoEntrega` date DEFAULT NULL,
  PRIMARY KEY (`CD`,`Pedido`,`Produto`,`Sequencia`) USING BTREE,
  KEY `IDXReferenciaCDPedido` (`CD`,`Pedido`),
  KEY `FK_compras_itens_produtos` (`Produto`),
  CONSTRAINT `FK_compras_itens_compras` FOREIGN KEY (`CD`, `Pedido`) REFERENCES `compras` (`CD`, `Pedido`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_compras_itens_produtos` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `compras_itens_after_insert` AFTER INSERT ON `compras_itens` FOR EACH ROW BEGIN
	UPDATE 
		compras t1
	SET 
		t1.Itens      = t1.Itens + 1,
		t1.QtdeTotal  = (t1.QtdeTotal  +  NEW.Quantidade),  
		t1.ValorTotal = (t1.ValorTotal +  NEW.ValorTotal),
		t1.QtdeSaldo  = (t1.QtdeSaldo  +  NEW.Quantidade)
	WHERE
	   t1.CD = NEW.CD
	AND
	   t1.Pedido = NEW.Pedido;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `compras_itens_after_update` AFTER UPDATE ON `compras_itens` FOR EACH ROW BEGIN
	UPDATE 
		compras t1
	SET 
		t1.Itens      = (SELECT COUNT(1) FROM compras_itens it WHERE it.CD = OLD.CD AND it.Pedido = OLD.Pedido),
		t1.QtdeTotal  = (SELECT SUM(it.Quantidade) FROM compras_itens it WHERE it.CD = NEW.CD AND it.Pedido = NEW.Pedido),
		t1.ValorTotal = (SELECT SUM(it.ValorTotal) FROM compras_itens it WHERE it.CD = NEW.CD AND it.Pedido = NEW.Pedido),
		t1.QtdeSaldo  = (SELECT SUM(it.Saldo) FROM compras_itens it WHERE it.CD = NEW.CD AND it.Pedido = NEW.Pedido),
		t1.QtdeEntregue = (SELECT SUM(it.Entregue) FROM compras_itens it WHERE it.CD = NEW.CD AND it.Pedido = NEW.Pedido)
	WHERE
	   t1.CD = OLD.CD
	AND
	   t1.Pedido = OLD.Pedido;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `compras_itens_after_delete` AFTER DELETE ON `compras_itens` FOR EACH ROW BEGIN

	UPDATE 
		compras t1
	SET 
		t1.Itens      = (SELECT COUNT(1) FROM compras_itens it WHERE it.CD = OLD.CD AND it.Pedido = OLD.Pedido),
		t1.QtdeTotal  = COALESCE((SELECT SUM(it.Quantidade) FROM compras_itens it WHERE it.CD = OLD.CD AND it.Pedido = OLD.Pedido), 0),
		t1.ValorTotal = COALESCE((SELECT SUM(it.ValorTotal) FROM compras_itens it WHERE it.CD = OLD.CD AND it.Pedido = OLD.Pedido),0),
		t1.QtdeSaldo  = COALESCE( (SELECT SUM(it.Saldo) FROM compras_itens it WHERE it.CD = OLD.CD AND it.Pedido = OLD.Pedido),0),
		t1.QtdeEntregue = COALESCE((SELECT SUM(it.Entregue) FROM compras_itens it WHERE it.CD = OLD.CD AND it.Pedido = OLD.Pedido),0)
	WHERE
	   t1.CD = OLD.CD
	AND
	   t1.Pedido = OLD.Pedido;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `compras_itens_entrega`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_itens_entrega` (
  `CD` int(10) NOT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `Produto` varchar(8) CHARACTER SET latin1 NOT NULL,
  `Sequencia` int(11) NOT NULL DEFAULT '0',
  `Dsitribuidora` varchar(15) NOT NULL,
  `Referencia` varchar(8) NOT NULL,
  `Motivo` varchar(60) NOT NULL DEFAULT '',
  `Baixa` varchar(1) NOT NULL DEFAULT 'P' COMMENT 'P-parcial, T-total',
  `SaldoAnterior` double NOT NULL DEFAULT '0',
  `Entregue` double NOT NULL DEFAULT '0',
  `Saldo` double NOT NULL DEFAULT '0',
  `DataPrevisaoEntrega` date DEFAULT NULL,
  `DataEntrega` date DEFAULT NULL,
  `Usuario` varchar(30) NOT NULL DEFAULT '',
  `Inclusão` date DEFAULT NULL,
  KEY `IDXReferenciaCDPedido` (`CD`,`Pedido`,`Produto`,`Sequencia`) USING BTREE,
  KEY `FK_compras_itens_entrega_produtos` (`Produto`),
  CONSTRAINT `FK_compras_itens_entrega_compras` FOREIGN KEY (`CD`, `Pedido`) REFERENCES `compras` (`CD`, `Pedido`),
  CONSTRAINT `FK_compras_itens_entrega_produtos` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_itens_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_itens_hst` (
  `CD` int(10) NOT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `Produto` varchar(8) CHARACTER SET latin1 NOT NULL,
  `Sequencia` int(11) unsigned NOT NULL DEFAULT '0',
  `Distribuidora` varchar(15) NOT NULL,
  `Referencia` varchar(8) NOT NULL,
  `Quantidade` double NOT NULL DEFAULT '0',
  `ValorUnitario` double NOT NULL DEFAULT '0',
  `ValorTotal` double NOT NULL DEFAULT '0',
  `Entregue` double NOT NULL DEFAULT '0',
  `Saldo` double DEFAULT NULL,
  `PrevisaoEntrega` date DEFAULT NULL,
  PRIMARY KEY (`CD`,`Pedido`,`Produto`,`Sequencia`) USING BTREE,
  KEY `IDXReferenciaCDPedido` (`CD`,`Pedido`) USING BTREE,
  KEY `FK_compras_itens_produtos` (`Produto`) USING BTREE,
  CONSTRAINT `FK_compras_itens_hst_compras_hst` FOREIGN KEY (`CD`, `Pedido`) REFERENCES `compras_hst` (`CD`, `Pedido`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `compras_itens_hst_ibfk_2` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_recontagem`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_recontagem` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDContagem` int(11) DEFAULT NULL,
  `Sequencia` varchar(50) DEFAULT NULL,
  `Conferente` int(11) DEFAULT NULL,
  `Produto` varchar(50) DEFAULT NULL,
  `Quantidade` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_compras_recontagem_conferentes` (`Conferente`),
  KEY `FK_compras_recontagem_compras_contagem` (`IDContagem`),
  CONSTRAINT `FK_compras_recontagem_compras_contagem` FOREIGN KEY (`IDContagem`) REFERENCES `compras_contagem` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_compras_recontagem_conferentes` FOREIGN KEY (`Conferente`) REFERENCES `conferentes` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compras_recontagem_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `compras_recontagem_hst` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDContagem` int(11) DEFAULT NULL,
  `Sequencia` varchar(50) DEFAULT NULL,
  `Conferente` int(11) DEFAULT NULL,
  `Produto` varchar(50) DEFAULT NULL,
  `Quantidade` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `FK_compras_recontagem_conferentes` (`Conferente`) USING BTREE,
  KEY `FK_compras_recontagem_compras_contagem` (`IDContagem`) USING BTREE,
  CONSTRAINT `FK_compras_recontagem_hst_conferentes` FOREIGN KEY (`Conferente`) REFERENCES `conferentes` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conferentes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `conferentes` (
  `Codigo` int(11) NOT NULL,
  `Nome` varchar(40) NOT NULL,
  `Tipo` varchar(1) CHARACTER SET utf8 NOT NULL COMMENT 'E-entrada, S-saida',
  `Sts` varchar(8) CHARACTER SET utf8 NOT NULL DEFAULT 'Ativo' COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`),
  KEY `IDXNome` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_email`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `config_email_after_insert` AFTER INSERT ON `config_email` FOR EACH ROW BEGIN
	REPLACE INTO config_email_api(	CodigoEmail,
												CodigoCD
											)
											(
												SELECT 
													t1.Codigo,
													t2.Codigo			 
												FROM 
													config_email	t1,
													empresas_cd 	t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `config_email_after_update` AFTER UPDATE ON `config_email` FOR EACH ROW BEGIN
	REPLACE INTO config_email_api(	CodigoEmail,
												CodigoCD
											)
											(
												SELECT 
													t1.Codigo,
													t2.Codigo			 
												FROM 
													config_email	t1,
													empresas_cd 	t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `config_email_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `config_email_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoEmail` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoEmail`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_email_dest`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `config_email_dest` (
  `ContaEmail` int(11) NOT NULL,
  `DestinatarioEmail` varchar(120) NOT NULL DEFAULT '',
  `Status` varchar(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`ContaEmail`,`DestinatarioEmail`),
  CONSTRAINT `FK_config_email_dest_config_email` FOREIGN KEY (`ContaEmail`) REFERENCES `config_email` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabela de Destinatário de e-mails\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_geral`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `config_geral` (
  `TituloRelatorios` varchar(60) DEFAULT '',
  `LogoDefault` longblob,
  `ContaEmail` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `configuracoes_contadores`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `configuracoes_contadores` (
  `Controle` varchar(60) COLLATE latin1_general_ci NOT NULL,
  `Descricao` varchar(60) COLLATE latin1_general_ci DEFAULT NULL,
  `Contador` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`Controle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `configuracoes_nfe`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `configuracoes_nfe` (
  `Empresa` int(11) NOT NULL,
  PRIMARY KEY (`Empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consultores`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `consultores` (
  `Codigo` int(11) NOT NULL,
  `Nome` varchar(40) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(40) NOT NULL DEFAULT '',
  `Status` varchar(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXNome` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `consultores_after_insert` AFTER INSERT ON `consultores` FOR EACH ROW BEGIN
	REPLACE INTO consultores_api(	CodigoConsultor,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												consultores	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `consultores_after_update` AFTER UPDATE ON `consultores` FOR EACH ROW BEGIN
	REPLACE INTO consultores_api(	CodigoConsultor,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												consultores	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `consultores_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `consultores_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoConsultor` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoConsultor`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contador_registros`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `contador_registros` (
  `CD` int(11) NOT NULL DEFAULT '0',
  `TableName` varchar(120) NOT NULL,
  `Descricao` varchar(120) NOT NULL,
  `Contador` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`CD`,`TableName`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_compras`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cp_compras` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cd_id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `Fornecedor_id` varchar(2) CHARACTER SET latin1 NOT NULL COMMENT 'R1',
  `DataPedido` date NOT NULL,
  `MarkupFranqueadora` decimal(6,2) NOT NULL,
  `MarkupFranquia` decimal(6,2) NOT NULL,
  `MarkupTotal` decimal(6,2) NOT NULL,
  `ValorTotalPedido` decimal(15,2) NOT NULL DEFAULT '0.00',
  `status_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Id da tabela cp_compras_status',
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
  `Categoria` varchar(2) COLLATE utf8mb4_swedish_ci DEFAULT NULL COMMENT 'Codigo da tabela produtos_categoria (R2)',
  `DataHoraEnvioFornecedor` datetime DEFAULT NULL COMMENT 'Data e Hora Envio ao fornecedor',
  `DataHoraRespostaFornecedor` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_cp_compras_produtos_fornecedor` (`Fornecedor_id`),
  KEY `FK_cp_compras_empresas` (`empresa_id`),
  KEY `FK_cp_compras_empresas_cd` (`cd_id`) USING BTREE,
  KEY `FK_cp_compras_cp_compras_status` (`status_id`),
  CONSTRAINT `FK_cp_compras_cp_compras_status` FOREIGN KEY (`status_id`) REFERENCES `cp_compras_status` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_empresas` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_empresas_cd` FOREIGN KEY (`cd_id`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_produtos_fornecedor` FOREIGN KEY (`Fornecedor_id`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_compras_emails`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_compras_itens`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
  `Categoria` varchar(2) DEFAULT NULL COMMENT 'Codigo da tabela produtos_categoria (R2)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `Index 3` (`cp_compras_id`,`referencia_fornecedor`),
  KEY `FK_cp_compras_itens_produtos_categorias` (`Categoria`),
  CONSTRAINT `FK_cp_compras_itens_cp_compras` FOREIGN KEY (`cp_compras_id`) REFERENCES `cp_compras` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_itens_produtos_categorias` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=304 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cp_compras_itens_after_update` AFTER UPDATE ON `cp_compras_itens` FOR EACH ROW
BEGIN
  IF NOT (OLD.`total_qtde` <=> NEW.`total_qtde`) OR NOT (OLD.`Sts` <=> NEW.`Sts`) OR NOT (OLD.`entrega` <=> NEW.`entrega`) THEN
    INSERT INTO `cp_compras_itens_log`
      (`compras_itens_id`, `cp_compras_id`, `referencia_fornecedor`, `descricao`, `composicao`, `ncm`, `entrega`, `entrega_anterior`, `total_qtde`, `total_produto`, `Foto`, `Sts`, `Iteracao`, `Localizacao`)
    VALUES
      (OLD.`id`, OLD.`cp_compras_id`, OLD.`referencia_fornecedor`, OLD.`descricao`, OLD.`composicao`, OLD.`ncm`, OLD.`entrega`, OLD.`entrega_anterior`, OLD.`total_qtde`, OLD.`total_produto`, OLD.`Foto`, OLD.`Sts`,
       (SELECT c.`Iteracao` FROM `cp_compras` c WHERE c.`id` = OLD.`cp_compras_id` LIMIT 1),
       (SELECT c.`Localizacao` FROM `cp_compras` c WHERE c.`id` = OLD.`cp_compras_id` LIMIT 1));
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cp_compras_itens_cores`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
  KEY `FK_cp_compras_itens_cores_cp_compras_itens_tamanhos` (`compras_itens_tamanho_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5789 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cp_compras_itens_cores_after_update` AFTER UPDATE ON `cp_compras_itens_cores` FOR EACH ROW
BEGIN
  IF NOT (OLD.`Qtde` <=> NEW.`Qtde`) OR NOT (OLD.`preco_proposta` <=> NEW.`preco_proposta`) OR NOT (OLD.`Sts` <=> NEW.`Sts`) THEN
    INSERT INTO `cp_compras_itens_cores_log`
      (`compras_itens_cores_id`, `compras_itens_tamanho_id`, `sku`, `cor`, `Qtde`, `preco_fornecedor`, `preco_proposta`, `valor_total_produto`, `preco_franqueado`, `markup_franquia`, `preco_loja`, `markup_loja`, `markup_total`, `Sts`, `Iteracao`, `Localizacao`)
    VALUES
      (OLD.`id`, OLD.`compras_itens_tamanho_id`, OLD.`sku`, OLD.`cor`, OLD.`Qtde`, OLD.`preco_fornecedor`, OLD.`preco_proposta`, OLD.`valor_total_produto`, OLD.`preco_franqueado`, OLD.`markup_franquia`, OLD.`preco_loja`, OLD.`markup_loja`, OLD.`markup_total`, OLD.`Sts`,
       (SELECT c.`Iteracao` FROM `cp_compras` c INNER JOIN `cp_compras_itens` i ON i.`cp_compras_id` = c.`id` INNER JOIN `cp_compras_itens_tamanhos` t ON t.`compras_itens_id` = i.`id` WHERE t.`id` = OLD.`compras_itens_tamanho_id` LIMIT 1),
       (SELECT c.`Localizacao` FROM `cp_compras` c INNER JOIN `cp_compras_itens` i ON i.`cp_compras_id` = c.`id` INNER JOIN `cp_compras_itens_tamanhos` t ON t.`compras_itens_id` = i.`id` WHERE t.`id` = OLD.`compras_itens_tamanho_id` LIMIT 1));
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cp_compras_itens_cores_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cp_compras_itens_cores_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compras_itens_cores_id` bigint(20) unsigned NOT NULL,
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
  `Iteracao` int(11) NOT NULL DEFAULT '0' COMMENT 'Iteracoes allop',
  `Localizacao` varchar(15) NOT NULL DEFAULT 'KidStok' COMMENT 'Allop/Fornecedor',
  PRIMARY KEY (`id`),
  KEY `IDXTamanho_id` (`compras_itens_tamanho_id`),
  KEY `IDXid` (`compras_itens_cores_id`) USING BTREE,
  CONSTRAINT `FK_cp_compras_itens_cores_log_cp_compras_itens_cores` FOREIGN KEY (`compras_itens_cores_id`) REFERENCES `cp_compras_itens_cores` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=520 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_compras_itens_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cp_compras_itens_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compras_itens_id` bigint(20) unsigned NOT NULL,
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
  `Iteracao` int(11) NOT NULL DEFAULT '0' COMMENT 'Iteracoes allop',
  `Localizacao` varchar(15) NOT NULL DEFAULT 'KidStok' COMMENT 'Allop/Fornecedor',
  PRIMARY KEY (`id`),
  KEY `IDXCompras_id` (`cp_compras_id`),
  KEY `IDXId` (`compras_itens_id`) USING BTREE,
  CONSTRAINT `FK_cp_compras_itens_log_cp_compras_itens` FOREIGN KEY (`compras_itens_id`) REFERENCES `cp_compras_itens` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_compras_itens_rateios`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cp_compras_itens_rateios` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id do registro',
  `compras_itens_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `cor` varchar(50) NOT NULL COMMENT 'Cor',
  `Percentual` double(8,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXitemCor` (`compras_itens_id`,`cor`),
  CONSTRAINT `FK_compras_itens_rateio_compras_itens` FOREIGN KEY (`compras_itens_id`) REFERENCES `cp_compras_itens` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=706 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_compras_itens_tamanhos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cp_compras_itens_tamanhos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compras_itens_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'id do item',
  `tamanho` varchar(20) NOT NULL COMMENT 'tamanho do produto',
  `entrega` date DEFAULT NULL COMMENT 'data de entrega',
  `entrega_anterior` date DEFAULT NULL COMMENT 'data de entrega anterior',
  `markup_franquia` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da franquia',
  `markup_loja` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da loja (franqueado)',
  `qtde_total` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Total de quantidades',
  `valor_total` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor total do tamanho',
  `Itens` int(11) NOT NULL DEFAULT '0' COMMENT 'Quantidade de itens tem o tamanho',
  `Sts` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0-Inativo, 1-Ativo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXItensTamanho` (`compras_itens_id`,`tamanho`) USING BTREE,
  CONSTRAINT `FK_cp_compras_itens_tamanhos_cp_compras_itens` FOREIGN KEY (`compras_itens_id`) REFERENCES `cp_compras_itens` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=491 DEFAULT CHARSET=latin1 COMMENT='Tabela de itens de tamanhos, separação de tamanhos.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `cp_compras_itens_tamanhos_after_update` AFTER UPDATE ON `cp_compras_itens_tamanhos` FOR EACH ROW
BEGIN
  INSERT INTO `cp_compras_itens_tamanhos_log`
    (`compras_itens_tamanho_id`, `compras_itens_id`, `tamanho`, `entrega`, `entrega_anterior`, `markup_franquia`, `markup_loja`, `qtde_total`, `valor_total`, `Itens`, `Sts`, `Iteracao`, `Localizacao`)
  VALUES
    (OLD.`id`, OLD.`compras_itens_id`, OLD.`tamanho`, OLD.`entrega`, OLD.`entrega_anterior`, OLD.`markup_franquia`, OLD.`markup_loja`, OLD.`qtde_total`, OLD.`valor_total`, OLD.`Itens`, OLD.`Sts`,
     (SELECT c.`Iteracao` FROM `cp_compras` c INNER JOIN `cp_compras_itens` i ON i.`cp_compras_id` = c.`id` WHERE i.`id` = OLD.`compras_itens_id` LIMIT 1),
     (SELECT c.`Localizacao` FROM `cp_compras` c INNER JOIN `cp_compras_itens` i ON i.`cp_compras_id` = c.`id` WHERE i.`id` = OLD.`compras_itens_id` LIMIT 1));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cp_compras_itens_tamanhos_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cp_compras_itens_tamanhos_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compras_itens_tamanho_id` bigint(20) unsigned NOT NULL,
  `compras_itens_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'id do item',
  `tamanho` varchar(20) NOT NULL COMMENT 'tamanho do produto',
  `entrega` date DEFAULT NULL COMMENT 'data de entrega',
  `entrega_anterior` date DEFAULT NULL COMMENT 'data de entrega anterior',
  `markup_franquia` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da franquia',
  `markup_loja` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da loja (franqueado)',
  `qtde_total` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Total de quantidades',
  `valor_total` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor total do tamanho',
  `Itens` int(11) NOT NULL DEFAULT '0' COMMENT 'Quantidade de itens tem o tamanho',
  `Sts` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0-Inativo, 1-Ativo',
  `Iteracao` int(11) NOT NULL DEFAULT '0' COMMENT 'Iteracoes allop',
  `Localizacao` varchar(15) NOT NULL DEFAULT 'KidStok' COMMENT 'Allop/Fornecedor',
  PRIMARY KEY (`id`),
  KEY `IDXIdItensTamanho` (`compras_itens_id`,`tamanho`),
  KEY `IDXId` (`compras_itens_tamanho_id`) USING BTREE,
  CONSTRAINT `FK_cp_compras_itens_tamanhos_log_cp_compras_itens_tamanhos` FOREIGN KEY (`compras_itens_tamanho_id`) REFERENCES `cp_compras_itens_tamanhos` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1879 DEFAULT CHARSET=latin1 COMMENT='Tabela de itens de tamanhos, separação de tamanhos.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_compras_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cp_compras_status` (
  `id` int(11) NOT NULL,
  `descricao_compras` varchar(120) NOT NULL DEFAULT '',
  `descricao_portal` varchar(120) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_depara_cor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cp_depara_cor` (
  `cor_fornecedor` varchar(50) NOT NULL,
  `codigo_ks` varchar(2) NOT NULL,
  PRIMARY KEY (`cor_fornecedor`),
  KEY `FK_cp_depara_cor_produtos_cor` (`codigo_ks`),
  CONSTRAINT `FK_cp_depara_cor_produtos_cor` FOREIGN KEY (`codigo_ks`) REFERENCES `produtos_cor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `empresas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
  `CRT` varchar(1) NOT NULL DEFAULT '3' COMMENT '1 - Simples Nacional, 2 Simples Nacional - Excesso Sublimite, 3 - Regime Normal, 4 MEI',
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
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `allop_devel`.`empresas_after_insert` AFTER INSERT ON `empresas` FOR EACH ROW BEGIN
	REPLACE INTO empresas_api(	CodigoEmpresa,
										CodigoCD
									)
									(
										SELECT 
											t1.Codigo,
											t2.Codigo			 
										FROM 
											empresas		t1,
											empresas_cd t2
										WHERE 
											t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `allop_devel`.`empresas_after_update` AFTER UPDATE ON `empresas` FOR EACH ROW BEGIN
	REPLACE INTO empresas_api(	CodigoEmpresa,
										CodigoCD
									)
									(
										SELECT 
											t1.Codigo,
											t2.Codigo			 
										FROM 
											empresas		t1,
											empresas_cd t2
										WHERE 
											t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `empresas_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `empresas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoEmpresa`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `empresas_cd`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `empresas_cd` (
  `Codigo` int(11) NOT NULL,
  `NomeCD` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXNomeCD` (`NomeCD`),
  KEY `FK_empresas_cd_situacao` (`Status`),
  CONSTRAINT `FK_empresas_cd_situacao` FOREIGN KEY (`Status`) REFERENCES `situacao` (`StsNome`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `allop_devel`.`empresas_cd_after_insert` AFTER INSERT ON `empresas_cd` FOR EACH ROW BEGIN
	REPLACE INTO empresas_cd_api (Codigo) (SELECT Codigo FROM empresas_cd);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `allop_devel`.`empresas_cd_after_update` AFTER UPDATE ON `empresas_cd` FOR EACH ROW BEGIN
	REPLACE INTO empresas_cd_api (Codigo) (SELECT Codigo FROM empresas_cd);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `empresas_cd_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `empresas_cd_api` (
  `Codigo` int(11) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entrada_de_mercadorias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `entrada_de_mercadorias` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `CD` int(11) NOT NULL,
  `Pedido` bigint(20) unsigned NOT NULL,
  `Data` date NOT NULL,
  `Hora` time NOT NULL,
  `Itens` int(11) NOT NULL,
  `Quantidades` int(11) NOT NULL,
  PRIMARY KEY (`Codigo`),
  KEY `FK_entrada_de_mercadorias_empresas_cd` (`CD`),
  CONSTRAINT `FK_entrada_de_mercadorias_empresas_cd` FOREIGN KEY (`CD`) REFERENCES `empresas_cd` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entrada_de_mercadorias_itens`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `entrada_de_mercadorias_itens` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Referencia` varchar(50) DEFAULT NULL,
  `Quantidade` int(11) DEFAULT NULL,
  `fk_entrada_de_mercadorias` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Codigo`) USING BTREE,
  KEY `FK_entrada_de_mercadorias_itens_entrada_de_mercadorias` (`fk_entrada_de_mercadorias`),
  CONSTRAINT `FK_entrada_de_mercadorias_itens_entrada_de_mercadorias` FOREIGN KEY (`fk_entrada_de_mercadorias`) REFERENCES `entrada_de_mercadorias` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estados`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `estados` (
  `Sigla` varchar(2) NOT NULL,
  `Estado` varchar(20) NOT NULL,
  `IBGE` varchar(2) DEFAULT NULL,
  `ICMSAliquota` double(4,2) NOT NULL DEFAULT '0.00',
  `WebServiceNFe` varchar(5) NOT NULL,
  `Regiao` varchar(15) NOT NULL,
  `ICMS_Interna` double(4,2) NOT NULL DEFAULT '0.00',
  `FCP` double(4,2) NOT NULL DEFAULT '0.00',
  `Status` varchar(8) DEFAULT NULL COMMENT 'Ativo/Inativo',
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(50) NOT NULL,
  PRIMARY KEY (`Sigla`),
  UNIQUE KEY `Estado` (`Estado`),
  KEY `Rregiao` (`Regiao`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `estados_after_insert` AFTER INSERT ON `estados` FOR EACH ROW BEGIN
	REPLACE INTO estados_api(	CodigoEstado,
											CodigoCD
										)
										(
											SELECT 
												t1.Sigla,
												t2.Codigo			 
											FROM 
												estados	t1,
												empresas_cd t2
												WHERE 
												t1.Sigla = NEW.Sigla
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `estados_after_update` AFTER UPDATE ON `estados` FOR EACH ROW BEGIN
	REPLACE INTO estados_api(	CodigoEstado,
											CodigoCD
										)
										(
											SELECT 
												t1.Sigla,
												t2.Codigo			 
											FROM 
												estados	t1,
												empresas_cd t2
												WHERE 
												t1.Sigla = NEW.Sigla
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `estados_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `estados_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoEstado` varchar(2) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoEstado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etiquetas_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `etiquetas_api` (
  `CD` int(11) NOT NULL,
  `Lote` bigint(20) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etiquetas_cab`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `etiquetas_cab` (
  `Lote` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `CD` int(11) NOT NULL,
  `Identificacao` varchar(60) NOT NULL DEFAULT '',
  `IDPedidoCompra` bigint(20) unsigned zerofill NOT NULL DEFAULT '00000000000000000000',
  `DataLote` date DEFAULT NULL,
  `TotalItens` int(11) DEFAULT NULL,
  `TotalQuantidades` int(11) DEFAULT NULL,
  `Inclusao` date DEFAULT NULL,
  `Liberado` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S/N - Liberado para impressao',
  PRIMARY KEY (`Lote`),
  UNIQUE KEY `IDXCDLote` (`CD`,`Lote`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etiquetas_ite`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `etiquetas_ite` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Lote` bigint(20) unsigned NOT NULL,
  `Produto` varchar(8) NOT NULL,
  `Referencia` varchar(15) NOT NULL,
  `Descricao` varchar(50) NOT NULL DEFAULT '',
  `DescricaoComplementar` varchar(80) NOT NULL DEFAULT '',
  `Quantidade` double(8,2) NOT NULL DEFAULT '0.00',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00',
  `Tamanho` varchar(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `IDXLote` (`Lote`),
  KEY `IDXReferencia` (`Referencia`),
  CONSTRAINT `FK_etiquetas_ite_etiquetas_cab` FOREIGN KEY (`Lote`) REFERENCES `etiquetas_cab` (`Lote`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fechamento`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `fechamento` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Franqueado` int(11) NOT NULL,
  `DataFechamento` date DEFAULT NULL,
  `HoraFechamento` time DEFAULT NULL,
  `ProvisoriosTotal` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor total do fechamento (Soma dos Provisorios)',
  `ProvisoriosCreditos` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Total de Valores Creditos Provisorios',
  `ProvisoriosDebitos` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Total de Valores Debitos  Provisorios',
  `ValorFechamento` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor total do fechamento',
  `TotalRomaneios` int(11) NOT NULL DEFAULT '0' COMMENT 'Soma quantos romaneios tem no fechamento (todos provisorios)',
  `TotalItens` int(11) NOT NULL DEFAULT '0' COMMENT 'Soma total do itens do romaneios por provisorios',
  `TotalPecas` int(11) NOT NULL DEFAULT '0' COMMENT 'Soma total da quantidade de pecas dos romaneios por provisorios',
  `Desconto` double(6,2) NOT NULL DEFAULT '0.00' COMMENT 'Percentual de desconto a visata',
  `FechamentoCreditos` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor de Creditos lancados no fechamento',
  `FechamentoDebitos` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor de Debitos lancados no fechamento',
  `ValorTotalReceber` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor total receber  = ( ValorFechamento + FechamentoCreditos - FechamentoDebitos)',
  `Liberado` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fechamento_lancamentos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `fechamento_lancamentos` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Fechamento` int(11) unsigned NOT NULL,
  `TipoLancamento` int(11) NOT NULL,
  `Operacao` varchar(1) NOT NULL COMMENT 'C-Credito, D-Debito',
  `Valor` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Quando a operacao for Debito - lancar o valor negativo',
  `Data` date NOT NULL,
  `Observacao` varchar(60) NOT NULL DEFAULT '',
  `Usuario` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `FK_provisorios_lancamentos_tipos_lancamentos` (`TipoLancamento`) USING BTREE,
  KEY `FK_provisorios_lancamentos_provisorios` (`Fechamento`) USING BTREE,
  CONSTRAINT `FK_fechamento_lancamentos_fechamento` FOREIGN KEY (`Fechamento`) REFERENCES `fechamento` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_fechamento_lancamentos_tipos_lancamentos` FOREIGN KEY (`TipoLancamento`) REFERENCES `tipos_lancamentos` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `fechamento_lancamentos_after_insert` AFTER INSERT ON `fechamento_lancamentos` FOR EACH ROW BEGIN
	CALL sp_fechamentos_atualizar_totais_creditos(NEW.Fechamento);
	CALL sp_fechamentos_atualizar_totais_debitos(NEW.Fechamento);
	CALL sp_fechamentos_atualizar_saldo(NEW.Fechamento);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `fechamento_lancamentos_after_update` AFTER UPDATE ON `fechamento_lancamentos` FOR EACH ROW BEGIN
	CALL sp_fechamentos_atualizar_totais_creditos(NEW.Fechamento);
	CALL sp_fechamentos_atualizar_totais_debitos(NEW.Fechamento);
	CALL sp_fechamentos_atualizar_saldo(NEW.Fechamento);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `fechamento_lancamentos_after_delete` AFTER DELETE ON `fechamento_lancamentos` FOR EACH ROW BEGIN
	CALL sp_fechamentos_atualizar_totais_creditos(OLD.Fechamento);
	CALL sp_fechamentos_atualizar_totais_debitos(OLD.Fechamento);
	CALL sp_fechamentos_atualizar_saldo(OLD.Fechamento);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `financeiro_tipos_pagamento`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `financeiro_tipos_pagamento` (
  `Codigo` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `Fechamento` varchar(1) NOT NULL DEFAULT 'N',
  `Pagar` varchar(1) NOT NULL DEFAULT 'N',
  `Receber` varchar(1) NOT NULL DEFAULT 'N',
  `Sts` varchar(8) NOT NULL DEFAULT 'Ativo',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXDescricao` (`Descricao`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `franqueados`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `franqueados` (
  `Codigo` int(11) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(60) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXNome` (`Nome`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `franqueados_after_insert` AFTER INSERT ON `franqueados` FOR EACH ROW BEGIN
	REPLACE INTO franqueados_api(	CodigoFranqueado,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												franqueados	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `franqueados_after_update` AFTER UPDATE ON `franqueados` FOR EACH ROW BEGIN
	REPLACE INTO franqueados_api(	CodigoFranqueado,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												franqueados	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `franqueados_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `franqueados_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoFranqueado` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoFranqueado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `franqueados_conta`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `franqueados_conta` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Franqueado` int(11) NOT NULL,
  `Saldo` int(11) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ibge`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `ibge` (
  `IBGE` varchar(7) NOT NULL DEFAULT '',
  `Estado` varchar(2) NOT NULL DEFAULT '',
  `Cidade` varchar(30) NOT NULL DEFAULT '',
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`IBGE`),
  UNIQUE KEY `IDX_CidadeEstado` (`Cidade`,`Estado`) USING BTREE,
  KEY `FK_Estados` (`Estado`),
  CONSTRAINT `FK_ibge_estados` FOREIGN KEY (`Estado`) REFERENCES `estados` (`Sigla`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `ibge_after_insert` AFTER INSERT ON `ibge` FOR EACH ROW BEGIN
	REPLACE INTO ibge_api(	CodigoIBGE,
											CodigoCD
										)
										(
											SELECT 
												t1.IBGE,
												t2.Codigo			 
											FROM 
												ibge	t1,
												empresas_cd t2
												WHERE 
												t1.IBGE = NEW.IBGE
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `ibge_after_update` AFTER UPDATE ON `ibge` FOR EACH ROW BEGIN
	REPLACE INTO ibge_api(	CodigoIBGE,
											CodigoCD
										)
										(
											SELECT 
												t1.IBGE,
												t2.Codigo			 
											FROM 
												ibge	t1,
												empresas_cd t2
												WHERE 
												t1.IBGE = NEW.IBGE
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ibge_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `ibge_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoIBGE` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoIBGE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log_scripts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `log_scripts` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Tabelas` varchar(500) DEFAULT '',
  `Descricao` varchar(500) DEFAULT '',
  `Data` datetime DEFAULT CURRENT_TIMESTAMP,
  `Homologacao` varchar(1) DEFAULT '' COMMENT 'Executou em homologacao',
  `Producao` varchar(1) DEFAULT '' COMMENT 'Executou em producao',
  `DataProducao` date DEFAULT NULL,
  `DataHomologacao` date DEFAULT NULL,
  `ScriptSQL` text,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `inserted_date` datetime DEFAULT NULL,
  `username` varchar(90) NOT NULL,
  `application` varchar(255) NOT NULL,
  `creator` varchar(30) NOT NULL,
  `ip_user` varchar(255) NOT NULL,
  `action` varchar(30) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=213111 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_cab`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_cab` (
  `NFe` bigint(20) unsigned NOT NULL COMMENT 'Identificador do Registro ID(autoIncremento)',
  `NumeroNFe` int(11) unsigned NOT NULL COMMENT 'Numero da Nota Fiscal',
  `SerieNFe` varchar(3) NOT NULL DEFAULT '' COMMENT 'Serie da Nota Fiscal ( serie)',
  `ChaveNFe` varchar(44) NOT NULL DEFAULT '' COMMENT 'Chave da Nota Fiscal (atributo ID)',
  `TipoNFe` varchar(1) NOT NULL DEFAULT '' COMMENT '0-Entrada, 1-Saida (tpNF)',
  `SituacaNFe` varchar(1) NOT NULL DEFAULT '' COMMENT 'A-Autorizada(padrão), C-cancelada, I - Inutilizada, D - Denegada',
  `CD` int(11) NOT NULL COMMENT 'Codigo do CD',
  `Empresa` int(11) NOT NULL COMMENT 'Codigo da Empresa',
  `CNPJ_CPF_Emitente` varchar(18) NOT NULL DEFAULT '' COMMENT 'CNPJ ou CPF do Emitente da nota',
  `Nome_Emitente` varchar(60) NOT NULL DEFAULT '' COMMENT 'Nome do Emitente da Nota ',
  `CNPJ_CPF_Destinatario` varchar(18) NOT NULL DEFAULT '' COMMENT 'CNPJ ou CPF do Destinatario',
  `Nome_Destinatario` varchar(60) NOT NULL DEFAULT '' COMMENT 'Nome do Destinatario',
  `DataEmissao` date DEFAULT NULL COMMENT 'Data de Emissão (dEmi)',
  `HoraEmissao` time DEFAULT NULL COMMENT 'Hora de Emissão',
  `DataSaida` date DEFAULT NULL COMMENT 'Data de Saida',
  `HoraSaida` time DEFAULT NULL COMMENT 'Hora de Saida',
  `TotalItens` int(11) NOT NULL DEFAULT '0' COMMENT 'Total de Itens (Produtos)',
  `TotalQtde` double NOT NULL DEFAULT '0' COMMENT 'Total de Quantidades',
  `Pedido` bigint(20) unsigned DEFAULT NULL,
  `IDCtrl` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`NFe`) USING BTREE,
  UNIQUE KEY `IDXChaveNFe` (`ChaveNFe`),
  KEY `IDXNumero` (`NumeroNFe`) USING BTREE,
  KEY `IDXNomeEmitente` (`Nome_Emitente`) USING BTREE,
  KEY `IDXNomeDestinatario` (`Nome_Destinatario`) USING BTREE,
  KEY `IDXDAtaEmissao` (`DataEmissao`,`HoraEmissao`) USING BTREE,
  KEY `FK_nfe_cab_compras_ctrl_entrega_cab` (`IDCtrl`),
  KEY `FK_nfe_cab_compras` (`CD`,`Pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_dest`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_dest` (
  `NFe` bigint(20) unsigned NOT NULL,
  `CNPJ` varchar(18) NOT NULL COMMENT 'CNPJ do Destinatario',
  `xNome` varchar(120) NOT NULL COMMENT 'Nome do Destinatario - Razao Social',
  `xFant` varchar(80) NOT NULL DEFAULT '' COMMENT 'Nome Fantasia',
  `xLgr` varchar(120) NOT NULL COMMENT 'Endereço',
  `nro` varchar(10) NOT NULL COMMENT 'Numero',
  `xCpl` varchar(60) NOT NULL DEFAULT '' COMMENT 'Complemento',
  `xBairro` varchar(60) NOT NULL COMMENT 'Bairro',
  `cMun` varchar(10) NOT NULL COMMENT 'Codigo Municipio - IBGE',
  `xMun` varchar(80) NOT NULL COMMENT 'Nome do Municipio - Cidade',
  `UF` varchar(2) NOT NULL DEFAULT '' COMMENT 'Estado',
  `CEP` varchar(10) NOT NULL DEFAULT '' COMMENT 'Cep',
  `cPais` varchar(5) NOT NULL DEFAULT '' COMMENT 'Código do País',
  `xPais` varchar(60) NOT NULL DEFAULT '' COMMENT 'Nome do País',
  `fone` varchar(30) NOT NULL DEFAULT '' COMMENT 'Numero do Telefone',
  `indIEDest` varchar(1) NOT NULL DEFAULT '' COMMENT 'Indicador IE destinatario',
  `IE` varchar(15) NOT NULL DEFAULT '' COMMENT 'Inscrição Estadual',
  `Suframa` varchar(15) NOT NULL DEFAULT '' COMMENT 'Inscrição Suframa',
  PRIMARY KEY (`NFe`) USING BTREE,
  KEY `IDXNome` (`xNome`) USING BTREE,
  KEY `IDXCnpj` (`CNPJ`) USING BTREE,
  CONSTRAINT `FK_nfe_dest_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_det`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_det` (
  `NFe` bigint(20) unsigned NOT NULL,
  `nItem` int(10) unsigned NOT NULL COMMENT 'Sequencia',
  `cProd` varchar(30) NOT NULL COMMENT 'Codigo do Produto',
  `cEAN` varchar(14) NOT NULL DEFAULT '',
  `xProd` varchar(120) NOT NULL DEFAULT '',
  `NCM` varchar(12) NOT NULL DEFAULT '',
  `CFOP` varchar(5) NOT NULL DEFAULT '',
  `uCom` varchar(2) NOT NULL DEFAULT '',
  `qCom` double NOT NULL DEFAULT '0',
  `vUnCom` double NOT NULL DEFAULT '0',
  `vProd` double NOT NULL DEFAULT '0',
  `cEANTrib` varchar(13) NOT NULL DEFAULT '0',
  `uTrib` varchar(2) NOT NULL DEFAULT '',
  `qTrib` double NOT NULL DEFAULT '0',
  `vUnTrib` double NOT NULL DEFAULT '0',
  `indTot` varchar(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`NFe`,`nItem`),
  CONSTRAINT `FK_nfe_det_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_det_icms_difal`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_det_icms_difal` (
  `NFe` bigint(20) unsigned NOT NULL,
  `nItem` int(11) unsigned NOT NULL,
  `vBCUFDest` double(15,2) NOT NULL DEFAULT '0.00',
  `vBCFCPUFDest_Opc` double(15,2) NOT NULL DEFAULT '0.00',
  `pFCPUFDest_Opc` double(6,2) NOT NULL DEFAULT '0.00',
  `pICMSUFDest` double(6,2) NOT NULL DEFAULT '0.00',
  `pICMSInter` double(6,2) NOT NULL DEFAULT '0.00',
  `pICMSInterPart` double(6,2) NOT NULL DEFAULT '0.00',
  `vFCPUFDest_Opc` double(15,2) NOT NULL DEFAULT '0.00',
  `vICMSUFDest` double(15,2) NOT NULL DEFAULT '0.00',
  `vICMSUFRemet` double(15,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`NFe`,`nItem`),
  CONSTRAINT `FK_nfe_det_icms_difal_nfe_det` FOREIGN KEY (`NFe`, `nItem`) REFERENCES `nfe_det` (`NFe`, `nItem`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_det_impostos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_det_impostos` (
  `NFe` bigint(20) unsigned NOT NULL COMMENT 'ID NFe',
  `nItem` int(11) unsigned NOT NULL COMMENT 'Nr. do Item(Sequencia)',
  `ICMS_orig` varchar(1) NOT NULL DEFAULT '' COMMENT 'Origem do Produto',
  `ICMS_CST` varchar(3) NOT NULL DEFAULT '' COMMENT 'CST - ICMS',
  `ICMS_modBC` varchar(3) NOT NULL DEFAULT '' COMMENT 'modelo da Base Calculo - ICMS',
  `ICMS_vBC` double NOT NULL DEFAULT '0' COMMENT 'Base de Calculo - ICMS',
  `ICMS_pICMS` double NOT NULL DEFAULT '0' COMMENT 'Aliquota Calculo - ICMS',
  `ICMS_vICMS` double NOT NULL DEFAULT '0' COMMENT 'Valor - ICMS',
  `IPI_CST` varchar(2) NOT NULL DEFAULT '' COMMENT 'CST - IPI',
  `IPI_cEnq` varchar(15) NOT NULL DEFAULT '' COMMENT 'Codigo Enquadramento - IPI',
  `IPI_vBC` double NOT NULL DEFAULT '0' COMMENT 'Base de Calculo - IPI',
  `IPI_pIPI` double NOT NULL DEFAULT '0' COMMENT 'Aliquota - IPI',
  `IPI_vIPI` double NOT NULL DEFAULT '0' COMMENT 'Valor - IPI',
  `PIS_CST` varchar(2) NOT NULL DEFAULT '' COMMENT 'CST - PIS',
  `PIS_vBC` double NOT NULL DEFAULT '0' COMMENT 'Base Calculo - PIS',
  `PIS_pPIS` double NOT NULL DEFAULT '0' COMMENT 'Aliquota - PIS',
  `PIS_vPIS` double NOT NULL DEFAULT '0' COMMENT 'Valor - PIS',
  `COFINS_CST` varchar(2) NOT NULL DEFAULT '' COMMENT 'CST - COFINS',
  `COFINS_vBC` double NOT NULL DEFAULT '0' COMMENT 'Base Calculo - COFINS',
  `COFINS_pCOFINS` double NOT NULL DEFAULT '0' COMMENT 'Aliquota - COFINS',
  `COFINS_vCOFINS` double NOT NULL DEFAULT '0' COMMENT 'Valor - COFINS',
  PRIMARY KEY (`NFe`,`nItem`),
  CONSTRAINT `FK_nfe_det_impostos_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_nfe_det_impostos_nfe_det` FOREIGN KEY (`NFe`, `nItem`) REFERENCES `nfe_det` (`NFe`, `nItem`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_emit`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_emit` (
  `NFe` bigint(20) unsigned NOT NULL,
  `CNPJ` varchar(18) NOT NULL COMMENT 'CNPJ do emitente',
  `xNome` varchar(120) NOT NULL COMMENT 'Nome do Emitente - Razao Social',
  `xFant` varchar(80) NOT NULL DEFAULT '' COMMENT 'Nome Fantasia',
  `xLgr` varchar(120) NOT NULL COMMENT 'Endereço',
  `nro` varchar(10) NOT NULL COMMENT 'Numero',
  `xCpl` varchar(60) NOT NULL DEFAULT '' COMMENT 'Complemento',
  `xBairro` varchar(60) NOT NULL COMMENT 'Bairro',
  `cMun` varchar(10) NOT NULL COMMENT 'Codigo Municipio - IBGE',
  `xMun` varchar(80) NOT NULL COMMENT 'Nome do Municipio - Cidade',
  `UF` varchar(2) NOT NULL DEFAULT '' COMMENT 'Estado',
  `CEP` varchar(10) NOT NULL DEFAULT '' COMMENT 'Cep',
  `cPais` varchar(5) NOT NULL DEFAULT '' COMMENT 'Código do País',
  `xPais` varchar(60) NOT NULL DEFAULT '' COMMENT 'Nome do País',
  `fone` varchar(30) NOT NULL DEFAULT '' COMMENT 'Numero do Telefone',
  `IE` varchar(15) NOT NULL DEFAULT '' COMMENT 'Inscrição Estadual',
  `CRT` varchar(1) NOT NULL DEFAULT '' COMMENT 'Codigo do Regime Tributário',
  PRIMARY KEY (`NFe`),
  KEY `IDXNome` (`xNome`),
  KEY `IDXCnpj` (`CNPJ`),
  CONSTRAINT `FK_nfe_emit_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_ide`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_ide` (
  `NFe` bigint(20) unsigned NOT NULL,
  `versao` varchar(10) NOT NULL DEFAULT '' COMMENT 'Versao do XML',
  `Id` varchar(50) NOT NULL DEFAULT '' COMMENT 'ID - Chave',
  `cUF` varchar(2) NOT NULL DEFAULT '' COMMENT 'Codigo da UF (Estado)',
  `cNF` varchar(10) NOT NULL DEFAULT '' COMMENT 'Código da Nota Fiscal',
  `natOp` varchar(120) NOT NULL DEFAULT '' COMMENT 'Descrição da Natureza de operacao',
  `cMod` varchar(2) NOT NULL DEFAULT '' COMMENT '55 - NFe, 65 - NFCe',
  `serie` varchar(2) NOT NULL DEFAULT '' COMMENT 'Serie da Nota Fiscal',
  `nNF` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero da Nota Fiscal',
  `dhEmi` varchar(30) NOT NULL DEFAULT '' COMMENT 'Data e Hora de Emissao da nota fiscal',
  `tpNF` varchar(1) NOT NULL DEFAULT '' COMMENT 'Tipo Nota 0-Entrada, 1-Saida',
  `idDest` varchar(1) NOT NULL DEFAULT '' COMMENT 'Identifica o Destinatario',
  `cMunFG` varchar(7) NOT NULL DEFAULT '' COMMENT 'Codigo do Municipio IBGE',
  `tpImp` varchar(1) NOT NULL DEFAULT '' COMMENT 'Tipo de impressao',
  `tpEmis` varchar(1) NOT NULL DEFAULT '' COMMENT 'Tipo de Emissao',
  `cDV` varchar(1) NOT NULL DEFAULT '' COMMENT 'Digito Verificador',
  `tpAmb` varchar(1) NOT NULL DEFAULT '' COMMENT 'Tipo de Ambiente, 1-producao, 2-homologacao',
  `finNFe` varchar(1) NOT NULL DEFAULT '' COMMENT 'Finalidade da Nota',
  `indFinal` varchar(1) NOT NULL DEFAULT '' COMMENT 'Indicador de Consumidor final',
  `indPres` varchar(1) NOT NULL DEFAULT '' COMMENT 'Indicador Presencial',
  `procEmi` varchar(1) NOT NULL DEFAULT '',
  `verProc` varchar(15) NOT NULL DEFAULT '' COMMENT 'Versao do sistema emitente',
  KEY `IDXNFe` (`NFe`) USING BTREE,
  CONSTRAINT `FK_nfe_ide_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_nfref`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_nfref` (
  `NFe` bigint(20) unsigned NOT NULL COMMENT 'ID - NFe',
  `refNFe` varchar(44) NOT NULL COMMENT 'Chave Nota Referenciada',
  PRIMARY KEY (`NFe`,`refNFe`) USING BTREE,
  CONSTRAINT `FK_nfe_nfref_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_pedidos_compra`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_pedidos_compra` (
  `ID` bigint(20) unsigned NOT NULL,
  `NFe` bigint(20) unsigned NOT NULL,
  `CD` int(10) unsigned NOT NULL DEFAULT '0',
  `Pedido` bigint(20) unsigned NOT NULL,
  `Produto` varchar(8) NOT NULL DEFAULT '',
  `Sequencia` int(11) NOT NULL DEFAULT '0',
  `Distribuidora` varchar(15) NOT NULL DEFAULT '',
  `Quantidade` double NOT NULL DEFAULT '0',
  `Inclusao` date DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDXNFe` (`NFe`,`Pedido`) USING BTREE,
  KEY `IDXPedido` (`Pedido`,`NFe`),
  KEY `IDXCDPedido` (`CD`,`Pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_total`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_total` (
  `NFe` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'ID NFe',
  `vBC` double NOT NULL DEFAULT '0' COMMENT 'Base ICMS',
  `vICMS` double NOT NULL DEFAULT '0' COMMENT 'Vlr ICMS',
  `vICMSDeson` double NOT NULL DEFAULT '0' COMMENT 'Vlr. ICMS Des.',
  `vFCP` double NOT NULL DEFAULT '0' COMMENT 'Vlr FCP',
  `vBCST` double NOT NULL DEFAULT '0' COMMENT 'Base ICMS-ST',
  `vST` double NOT NULL DEFAULT '0' COMMENT 'Vlr ICMS-ST',
  `vFCPST` double NOT NULL DEFAULT '0' COMMENT 'Vlr FCP',
  `vFCPSTRet` double NOT NULL DEFAULT '0' COMMENT 'Vlr FCP-ST',
  `vProd` double NOT NULL DEFAULT '0' COMMENT 'Total Produtos',
  `vFrete` double NOT NULL DEFAULT '0' COMMENT 'Vlr Frete',
  `vSeg` double NOT NULL DEFAULT '0' COMMENT 'Vlr Seguro',
  `vDesc` double NOT NULL DEFAULT '0' COMMENT 'Vlr Desconto',
  `vOutro` double NOT NULL DEFAULT '0' COMMENT 'Vlr Outras',
  `vII` double NOT NULL DEFAULT '0' COMMENT 'Vlr II',
  `vIPI` double NOT NULL DEFAULT '0' COMMENT 'Vlr IPI',
  `vIPIDevol` double NOT NULL DEFAULT '0' COMMENT 'Vlr IPI-Dev',
  `vPIS` double NOT NULL DEFAULT '0' COMMENT 'Vlr PIS',
  `vCOFINS` double NOT NULL DEFAULT '0' COMMENT 'Vlr COFINS',
  `vNF` double NOT NULL DEFAULT '0' COMMENT 'TOTAL NFe',
  `infCpl` text COMMENT 'Inf. Complementares.',
  PRIMARY KEY (`NFe`),
  CONSTRAINT `FK_nfe_total_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_transportadora`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_transportadora` (
  `NFe` bigint(20) unsigned NOT NULL,
  `CNPJ_CPF` varchar(18) NOT NULL DEFAULT '',
  `xNome` varchar(60) NOT NULL DEFAULT '',
  `IE` varchar(15) NOT NULL DEFAULT '',
  `xEnder` varchar(60) NOT NULL DEFAULT '',
  `xMun` varchar(60) NOT NULL DEFAULT '',
  `UF` varchar(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`NFe`),
  CONSTRAINT `FK_nfe_transportadora_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nfe_xml`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nfe_xml` (
  `NFe` bigint(20) unsigned NOT NULL,
  `ChaveNFe` varchar(45) NOT NULL DEFAULT '',
  `XML_proc` longtext NOT NULL,
  PRIMARY KEY (`NFe`),
  CONSTRAINT `FK_nfe_xml_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permissoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `permissoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(120) NOT NULL,
  `modulo` varchar(40) NOT NULL,
  `Ordem` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `IDXModuloOrdem` (`modulo`,`Ordem`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permissoes_usuario`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `permissoes_usuario` (
  `permissao_id` int(11) NOT NULL,
  `usuario_login` varchar(255) NOT NULL,
  PRIMARY KEY (`permissao_id`,`usuario_login`),
  KEY `FK_permissoes_usuario_seguranca_users` (`usuario_login`),
  CONSTRAINT `FK_permissoes_usuario_permissoes` FOREIGN KEY (`permissao_id`) REFERENCES `permissoes` (`id`),
  CONSTRAINT `FK_permissoes_usuario_seguranca_users` FOREIGN KEY (`usuario_login`) REFERENCES `seguranca_users` (`login`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pf_colecao`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=38593 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pf_usuario_fornecedor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `pf_usuario_fornecedor` (
  `id_usuario` int(10) unsigned NOT NULL,
  `id_fornecedor` varchar(2) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_fornecedor`),
  KEY `FK_pf_usuario_fornecedor_produtos_fornecedor` (`id_fornecedor`),
  CONSTRAINT `FK_pf_usuario_fornecedor_pf_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `pf_usuarios` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_pf_usuario_fornecedor_produtos_fornecedor` FOREIGN KEY (`id_fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pf_usuarios`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pf_usuarios_copy`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `pf_usuarios_copy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `perfil` enum('admin','fornecedor') DEFAULT 'fornecedor',
  `status` tinyint(1) DEFAULT '1' COMMENT '0 - Inativo, 1 - Ativo',
  `criado_em` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pre_cadastro`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `pre_cadastro` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Auto incremento',
  `cp_compras_id` bigint(20) unsigned NOT NULL COMMENT 'Pedido de Compra',
  `cd_id` int(10) NOT NULL,
  `empresa_id` int(10) NOT NULL,
  `fornecedor_id` varchar(2) NOT NULL COMMENT 'R1',
  `Categoria` varchar(2) NOT NULL COMMENT 'R2',
  `data_entrega` date DEFAULT NULL COMMENT 'Data Entrega',
  `markup_franqueadora` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da Franqueadora',
  `markup_franquia` decimal(15,2) NOT NULL DEFAULT '0.00',
  `markup_total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `valor_total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `Itens` int(11) NOT NULL DEFAULT '0',
  `QtdeItens` int(11) NOT NULL DEFAULT '0',
  `Tamanhos` int(11) NOT NULL DEFAULT '0',
  `QtdeTamanhos` int(11) NOT NULL DEFAULT '0',
  `Cores` int(11) NOT NULL DEFAULT '0',
  `QtdeCores` int(11) NOT NULL DEFAULT '0',
  `consolidado` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - nao consolidado, 1 - consolidado',
  `compra` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - nao gerou compra, 1 - gerou compra',
  PRIMARY KEY (`id`),
  KEY `FK_pre_cadastro_cp_compras` (`cp_compras_id`),
  KEY `FK_pre_cadastro_empresas_cd` (`cd_id`),
  KEY `FK_pre_cadastro_empresas` (`empresa_id`),
  KEY `FK_pre_cadastro_produtos_fornecedor` (`fornecedor_id`),
  KEY `FK_pre_cadastro_produtos_categorias` (`Categoria`),
  CONSTRAINT `FK_pre_cadastro_cp_compras` FOREIGN KEY (`cp_compras_id`) REFERENCES `cp_compras` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_empresas` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_empresas_cd` FOREIGN KEY (`cd_id`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_produtos_categorias` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_produtos_fornecedor` FOREIGN KEY (`fornecedor_id`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pre_cadastro_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `pre_cadastro_hst` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Auto incremento',
  `cp_compras_id` bigint(20) unsigned NOT NULL COMMENT 'Pedido de Compra',
  `cd_id` int(10) NOT NULL,
  `empresa_id` int(10) NOT NULL,
  `fornecedor_id` varchar(2) NOT NULL COMMENT 'R1',
  `Categoria` varchar(2) NOT NULL COMMENT 'R2',
  `data_entrega` date DEFAULT NULL COMMENT 'Data Entrega',
  `markup_franqueadora` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'Markup da Franqueadora',
  `markup_franquia` decimal(15,2) NOT NULL DEFAULT '0.00',
  `markup_total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `valor_total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `Itens` int(11) NOT NULL DEFAULT '0',
  `QtdeItens` int(11) NOT NULL DEFAULT '0',
  `Tamanhos` int(11) NOT NULL DEFAULT '0',
  `QtdeTamanhos` int(11) NOT NULL DEFAULT '0',
  `Cores` int(11) NOT NULL DEFAULT '0',
  `QtdeCores` int(11) NOT NULL DEFAULT '0',
  `consolidado` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - nao consolidado, 1 - consolidado',
  `compra` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - nao gerou compra, 1 - gerou compra',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_pre_cadastro_cp_compras` (`cp_compras_id`) USING BTREE,
  KEY `FK_pre_cadastro_empresas_cd` (`cd_id`) USING BTREE,
  KEY `FK_pre_cadastro_empresas` (`empresa_id`) USING BTREE,
  KEY `FK_pre_cadastro_produtos_fornecedor` (`fornecedor_id`) USING BTREE,
  KEY `FK_pre_cadastro_produtos_categorias` (`Categoria`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pre_cadastro_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `pre_cadastro_item` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pre_cadastro_id` bigint(20) unsigned NOT NULL,
  `cp_compras_itens_id` bigint(20) unsigned NOT NULL,
  `referencia_fornecedor` varchar(25) NOT NULL COMMENT 'referencia do fornecedor',
  `r1` varchar(2) DEFAULT NULL COMMENT 'Codigo do fornecedor',
  `r2` varchar(2) DEFAULT NULL COMMENT 'Codigo da categoria',
  `r3` varchar(4) DEFAULT NULL COMMENT 'Codigo do fornecedor',
  `referencia_master` varchar(8) DEFAULT NULL COMMENT 'Combinacao de R1+R2+R3',
  `codigo_fornecdor` varchar(200) NOT NULL DEFAULT '' COMMENT 'codigo do fornecedor',
  `composicao` varchar(255) NOT NULL DEFAULT '',
  `colecao_id` int(10) unsigned DEFAULT NULL COMMENT 'Colecao do item. tabela produtos_colecao',
  `linha` int(11) unsigned DEFAULT NULL COMMENT 'Marca',
  `peso` double NOT NULL DEFAULT '0',
  `descricao` varchar(50) NOT NULL COMMENT 'descricao do produto 50 caracteres pas uso do NFC-e',
  `descricao_complementar` varchar(70) NOT NULL DEFAULT '',
  `Unidade` varchar(2) NOT NULL DEFAULT 'PC',
  `Grupo` varchar(40) DEFAULT NULL COMMENT 'Grupo',
  `grupo_categoria` varchar(40) DEFAULT NULL COMMENT 'Grupo / Categoria',
  `genero_id` int(11) DEFAULT NULL COMMENT 'Masculino, feminino, unisex',
  `composicao_id` int(11) DEFAULT NULL COMMENT 'Composicao ',
  `caracteristica_id` int(11) DEFAULT NULL COMMENT 'Caracteristica',
  `setor_laranja` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S-sim,N-nao',
  `preco_cheio` varchar(1) NOT NULL DEFAULT 'N',
  `encomenda` varchar(1) NOT NULL DEFAULT 'N',
  `estilo` int(11) DEFAULT NULL,
  `preco_compra` double NOT NULL DEFAULT '0' COMMENT 'Preco de Compta',
  `preco_compra_tabela` double NOT NULL DEFAULT '0' COMMENT 'Atacado - preco franqueado',
  `preco_venda_tabela` double NOT NULL DEFAULT '0' COMMENT 'Varejo - preco de venda do franqueado',
  `ncm` varchar(10) DEFAULT NULL,
  `origem` varchar(1) DEFAULT NULL,
  `cst_icms` varchar(3) NOT NULL DEFAULT '',
  `aliquota_icms` decimal(10,2) NOT NULL DEFAULT '0.00',
  `reducao_icms` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cst_pis` varchar(2) NOT NULL DEFAULT '',
  `aliquota_pis` decimal(10,2) NOT NULL DEFAULT '0.00',
  `aliquota_cofins` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cst_cofins` varchar(2) NOT NULL DEFAULT '',
  `cst_ipi` varchar(2) NOT NULL DEFAULT '',
  `aliquota_ipi` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cfop` varchar(4) NOT NULL DEFAULT '5102',
  `cfop_propria` varchar(4) NOT NULL DEFAULT '',
  `sts` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 - ativo, 0 - inativo',
  `compra_nro` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero do pedido de compra gerado',
  PRIMARY KEY (`id`),
  KEY `FK_pre_cadastro_item_pre_cadastro` (`pre_cadastro_id`),
  KEY `FK_pre_cadastro_item_cp_compras_itens` (`cp_compras_itens_id`),
  KEY `FK_pre_cadastro_item_produtos_fornecedor` (`r1`),
  KEY `FK_pre_cadastro_item_produtos_categorias` (`r2`),
  KEY `FK_pre_cadastro_item_produtos_colecao` (`colecao_id`),
  KEY `FK_pre_cadastro_item_produtos_linhas` (`linha`),
  KEY `FK_pre_cadastro_item_produtos_medidas` (`Unidade`),
  KEY `FK_pre_cadastro_item_produtos_grupos` (`Grupo`),
  KEY `FK_pre_cadastro_item_produtos_grupos_2` (`grupo_categoria`),
  KEY `FK_pre_cadastro_item_produtos_generos` (`genero_id`),
  KEY `FK_pre_cadastro_item_produtos_composicoes` (`composicao_id`),
  KEY `FK_pre_cadastro_item_produtos_caracteristicas` (`caracteristica_id`),
  KEY `FK_pre_cadastro_item_produtos_estilos` (`estilo`),
  KEY `FK_pre_cadastro_item_cests_ncm` (`ncm`),
  KEY `FK_pre_cadastro_item_st_origem` (`origem`),
  KEY `FK_pre_cadastro_item_st_icms` (`cst_icms`),
  KEY `FK_pre_cadastro_item_st_pis` (`cst_pis`),
  KEY `FK_pre_cadastro_item_st_cofins` (`cst_cofins`),
  KEY `FK_pre_cadastro_item_st_ipi` (`cst_ipi`),
  KEY `FK_pre_cadastro_item_cfops` (`cfop`),
  KEY `FK_pre_cadastro_item_cfops_2` (`cfop_propria`),
  CONSTRAINT `FK_pre_cadastro_item_cests_ncm` FOREIGN KEY (`ncm`) REFERENCES `cests_ncm` (`ncm`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_cfops` FOREIGN KEY (`cfop`) REFERENCES `cfops` (`CFOP`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_cfops_2` FOREIGN KEY (`cfop_propria`) REFERENCES `cfops` (`CFOP`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_cp_compras_itens` FOREIGN KEY (`cp_compras_itens_id`) REFERENCES `cp_compras_itens` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_pre_cadastro` FOREIGN KEY (`pre_cadastro_id`) REFERENCES `pre_cadastro` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_caracteristicas` FOREIGN KEY (`caracteristica_id`) REFERENCES `produtos_caracteristicas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_categorias` FOREIGN KEY (`r2`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_colecao` FOREIGN KEY (`colecao_id`) REFERENCES `produtos_colecao` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_composicoes` FOREIGN KEY (`composicao_id`) REFERENCES `produtos_composicoes` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_estilos` FOREIGN KEY (`estilo`) REFERENCES `produtos_estilos` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_fornecedor` FOREIGN KEY (`r1`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_generos` FOREIGN KEY (`genero_id`) REFERENCES `produtos_generos` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_grupos` FOREIGN KEY (`Grupo`) REFERENCES `produtos_grupos` (`Grupo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_grupos_2` FOREIGN KEY (`grupo_categoria`) REFERENCES `produtos_grupos` (`SubGrupo`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_linhas` FOREIGN KEY (`linha`) REFERENCES `produtos_linhas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_produtos_medidas` FOREIGN KEY (`Unidade`) REFERENCES `produtos_medidas` (`Sigla`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_st_cofins` FOREIGN KEY (`cst_cofins`) REFERENCES `st_cofins` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_st_icms` FOREIGN KEY (`cst_icms`) REFERENCES `st_icms` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_st_ipi` FOREIGN KEY (`cst_ipi`) REFERENCES `st_ipi` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_st_origem` FOREIGN KEY (`origem`) REFERENCES `st_origem` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_st_pis` FOREIGN KEY (`cst_pis`) REFERENCES `st_pis` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pre_cadastro_item_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `pre_cadastro_item_hst` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pre_cadastro_id` bigint(20) unsigned NOT NULL,
  `cp_compras_itens_id` bigint(20) unsigned NOT NULL,
  `referencia_fornecedor` varchar(25) NOT NULL COMMENT 'referencia do fornecedor',
  `r1` varchar(2) DEFAULT NULL COMMENT 'Codigo do fornecedor',
  `r2` varchar(2) DEFAULT NULL COMMENT 'Codigo da categoria',
  `r3` varchar(4) DEFAULT NULL COMMENT 'Codigo do fornecedor',
  `referencia_master` varchar(8) DEFAULT NULL COMMENT 'Combinacao de R1+R2+R3',
  `codigo_fornecdor` varchar(200) NOT NULL DEFAULT '' COMMENT 'codigo do fornecedor',
  `composicao` varchar(255) NOT NULL DEFAULT '',
  `colecao_id` int(10) unsigned DEFAULT NULL COMMENT 'Colecao do item. tabela produtos_colecao',
  `linha` int(11) unsigned DEFAULT NULL COMMENT 'Marca',
  `peso` double NOT NULL DEFAULT '0',
  `descricao` varchar(50) NOT NULL COMMENT 'descricao do produto 50 caracteres pas uso do NFC-e',
  `descricao_complementar` varchar(70) NOT NULL DEFAULT '',
  `Unidade` varchar(2) NOT NULL DEFAULT 'PC',
  `Grupo` varchar(40) DEFAULT NULL COMMENT 'Grupo',
  `grupo_categoria` varchar(40) DEFAULT NULL COMMENT 'Grupo / Categoria',
  `genero_id` int(11) DEFAULT NULL COMMENT 'Masculino, feminino, unisex',
  `composicao_id` int(11) DEFAULT NULL COMMENT 'Composicao ',
  `caracteristica_id` int(11) DEFAULT NULL COMMENT 'Caracteristica',
  `setor_laranja` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S-sim,N-nao',
  `preco_cheio` varchar(1) NOT NULL DEFAULT 'N',
  `encomenda` varchar(1) NOT NULL DEFAULT 'N',
  `estilo` int(11) DEFAULT NULL,
  `preco_compra` double NOT NULL DEFAULT '0' COMMENT 'Preco de Compta',
  `preco_compra_tabela` double NOT NULL DEFAULT '0' COMMENT 'Atacado - preco franqueado',
  `preco_venda_tabela` double NOT NULL DEFAULT '0' COMMENT 'Varejo - preco de venda do franqueado',
  `ncm` varchar(10) DEFAULT NULL,
  `origem` varchar(1) DEFAULT NULL,
  `cst_icms` varchar(3) NOT NULL DEFAULT '',
  `aliquota_icms` decimal(10,2) NOT NULL DEFAULT '0.00',
  `reducao_icms` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cst_pis` varchar(2) NOT NULL DEFAULT '',
  `aliquota_pis` decimal(10,2) NOT NULL DEFAULT '0.00',
  `aliquota_cofins` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cst_cofins` varchar(2) NOT NULL DEFAULT '',
  `cst_ipi` varchar(2) NOT NULL DEFAULT '',
  `aliquota_ipi` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cfop` varchar(4) NOT NULL DEFAULT '5102',
  `cfop_propria` varchar(4) NOT NULL DEFAULT '',
  `sts` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 - ativo, 0 - inativo',
  `compra_nro` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero do pedido de compra gerado',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_pre_cadastro_item_pre_cadastro` (`pre_cadastro_id`) USING BTREE,
  KEY `FK_pre_cadastro_item_cp_compras_itens` (`cp_compras_itens_id`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_fornecedor` (`r1`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_categorias` (`r2`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_colecao` (`colecao_id`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_linhas` (`linha`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_grupos` (`Grupo`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_grupos_2` (`grupo_categoria`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_generos` (`genero_id`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_composicoes` (`composicao_id`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_caracteristicas` (`caracteristica_id`) USING BTREE,
  KEY `FK_pre_cadastro_item_produtos_estilos` (`estilo`) USING BTREE,
  KEY `FK_pre_cadastro_item_cests_ncm` (`ncm`) USING BTREE,
  KEY `FK_pre_cadastro_item_st_origem` (`origem`) USING BTREE,
  KEY `FK_pre_cadastro_item_st_icms` (`cst_icms`) USING BTREE,
  KEY `FK_pre_cadastro_item_st_pis` (`cst_pis`) USING BTREE,
  KEY `FK_pre_cadastro_item_st_cofins` (`cst_cofins`) USING BTREE,
  KEY `FK_pre_cadastro_item_st_ipi` (`cst_ipi`) USING BTREE,
  KEY `FK_pre_cadastro_item_cfops` (`cfop`) USING BTREE,
  KEY `FK_pre_cadastro_item_cfops_2` (`cfop_propria`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pre_cadastro_item_pro`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `pre_cadastro_item_pro` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pre_cadastro_item_id` bigint(20) unsigned NOT NULL COMMENT 'Id do item do pre cadastro',
  `referencia_master` varchar(8) NOT NULL,
  `tamanho` varchar(2) NOT NULL,
  `cor` varchar(2) NOT NULL,
  `referencia` varchar(15) NOT NULL COMMENT 'referencia = referencia_master + tamanho e cor',
  `sku` varchar(100) NOT NULL DEFAULT '',
  `qtde` double NOT NULL DEFAULT '0',
  `preco_fornecedor` double NOT NULL DEFAULT '0',
  `preco_compra` double NOT NULL DEFAULT '0' COMMENT 'Preco de Compra',
  `preco_atacado` double NOT NULL DEFAULT '0' COMMENT 'Preco Compra Tabela',
  `preco_varejo` double NOT NULL DEFAULT '0' COMMENT 'Preco Venda Tabela',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXReferencia` (`referencia`),
  KEY `FK_pre_cadastro_item_pro_pre_cadastro_item` (`pre_cadastro_item_id`),
  KEY `FK_pre_cadastro_item_pro_produtos_tamanho` (`tamanho`),
  KEY `FK_pre_cadastro_item_pro_produtos_cor_2` (`cor`),
  CONSTRAINT `FK_pre_cadastro_item_pro_pre_cadastro_item` FOREIGN KEY (`pre_cadastro_item_id`) REFERENCES `pre_cadastro_item` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_pro_produtos_cor_2` FOREIGN KEY (`cor`) REFERENCES `produtos_cor` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_item_pro_produtos_tamanho` FOREIGN KEY (`tamanho`) REFERENCES `produtos_tamanho` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pre_cadastro_item_pro_hst`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `pre_cadastro_item_pro_hst` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pre_cadastro_item_id` bigint(20) unsigned NOT NULL COMMENT 'Id do item do pre cadastro',
  `referencia_master` varchar(8) NOT NULL,
  `tamanho` varchar(2) NOT NULL,
  `cor` varchar(2) NOT NULL,
  `referencia` varchar(15) NOT NULL COMMENT 'referencia = referencia_master + tamanho e cor',
  `sku` varchar(100) NOT NULL DEFAULT '',
  `qtde` double NOT NULL DEFAULT '0',
  `preco_fornecedor` double NOT NULL DEFAULT '0',
  `preco_compra` double NOT NULL DEFAULT '0' COMMENT 'Preco de Compra',
  `preco_atacado` double NOT NULL DEFAULT '0' COMMENT 'Preco Compra Tabela',
  `preco_varejo` double NOT NULL DEFAULT '0' COMMENT 'Preco Venda Tabela',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `IDXReferencia` (`referencia`) USING BTREE,
  KEY `FK_pre_cadastro_item_pro_pre_cadastro_item` (`pre_cadastro_item_id`) USING BTREE,
  KEY `FK_pre_cadastro_item_pro_produtos_tamanho` (`tamanho`) USING BTREE,
  KEY `FK_pre_cadastro_item_pro_produtos_cor_2` (`cor`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prm_sistema`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `prm_sistema` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `CD` int(11) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos` (
  `Codigo` varchar(8) NOT NULL,
  `Distribuidora` varchar(15) DEFAULT NULL,
  `GTIN` varchar(14) DEFAULT NULL,
  `Linha` int(11) unsigned NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL COMMENT '4 ultimos digitos do CodFornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N' COMMENT 'Produto só por encomenda',
  `LocalFisico` int(11) DEFAULT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `CodigoAlternativo` varchar(20) NOT NULL DEFAULT '',
  `Fashion` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S-fashion, N-não fashion',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXDistribuidora` (`Distribuidora`),
  KEY `IDXDescricao` (`Descricao`),
  KEY `FK_produtos_produtos_medidas` (`Unidade`),
  KEY `FK_produtos_produtos_grupos` (`Grupo`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`),
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`),
  KEY `FK_produtos_produtos_categorias` (`Categoria`),
  KEY `FK_produtos_produtos_colecao` (`Colecao`),
  KEY `FK_produtos_produtos_composicoes` (`Composicao`),
  KEY `FK_produtos_produtos_cor` (`Cor`),
  KEY `FK_produtos_produtos_generos` (`Genero`),
  KEY `FK_produtos_produtos_linhas` (`Linha`),
  KEY `FK_produtos_produtos_local_fisico` (`LocalFisico`),
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`),
  KEY `FK_produtos_st_cofins` (`CST_COFINS`),
  KEY `FK_produtos_st_ipi` (`CST_IPI`),
  KEY `FK_produtos_st_origem` (`Origem`),
  KEY `FK_produtos_st_pis` (`CST_PIS`),
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`),
  KEY `FK_produtos_produtos_GrupoSubGrupo` (`Grupo`,`GrupoCategoria`),
  KEY `FK_produtos_cests_ncm` (`NCM`),
  KEY `FK_produtos_produtos_estilos` (`Estilo`),
  CONSTRAINT `FK_produtos_cests_ncm` FOREIGN KEY (`NCM`) REFERENCES `cests_ncm` (`ncm`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_cfops` FOREIGN KEY (`CFOP`) REFERENCES `cfops` (`CFOP`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_GrupoSubGrupo` FOREIGN KEY (`Grupo`, `GrupoCategoria`) REFERENCES `produtos_grupos` (`Grupo`, `SubGrupo`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_caracteristicas` FOREIGN KEY (`Caracteristica`) REFERENCES `produtos_caracteristicas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_categorias` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_colecao` FOREIGN KEY (`Colecao`) REFERENCES `produtos_colecao` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_composicoes` FOREIGN KEY (`Composicao`) REFERENCES `produtos_composicoes` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_cor` FOREIGN KEY (`Cor`) REFERENCES `produtos_cor` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_fornecedor` FOREIGN KEY (`Fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_generos` FOREIGN KEY (`Genero`) REFERENCES `produtos_generos` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_linhas` FOREIGN KEY (`Linha`) REFERENCES `produtos_linhas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_local_fisico` FOREIGN KEY (`LocalFisico`) REFERENCES `produtos_local_fisico` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_produtos_tamanho` FOREIGN KEY (`Tamanho`) REFERENCES `produtos_tamanho` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_st_cofins` FOREIGN KEY (`CST_COFINS`) REFERENCES `st_cofins` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_st_icms` FOREIGN KEY (`CST_ICMS`) REFERENCES `st_icms` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_st_ipi` FOREIGN KEY (`CST_IPI`) REFERENCES `st_ipi` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_st_origem` FOREIGN KEY (`Origem`) REFERENCES `st_origem` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_st_pis` FOREIGN KEY (`CST_PIS`) REFERENCES `st_pis` (`Codigo`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_antes_gcom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_antes_gcom` (
  `Codigo` varchar(8) NOT NULL,
  `Distribuidora` varchar(15) DEFAULT NULL,
  `GTIN` varchar(14) DEFAULT NULL,
  `Linha` int(11) unsigned NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL COMMENT '4 ultimos digitos do CodFornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N' COMMENT 'Produto só por encomenda',
  `LocalFisico` int(11) DEFAULT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `CodigoAlternativo` varchar(20) NOT NULL DEFAULT '',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXDistribuidora` (`Distribuidora`) USING BTREE,
  KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_produtos_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_produtos_produtos_grupos` (`Grupo`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`) USING BTREE,
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`) USING BTREE,
  KEY `FK_produtos_produtos_categorias` (`Categoria`) USING BTREE,
  KEY `FK_produtos_produtos_colecao` (`Colecao`) USING BTREE,
  KEY `FK_produtos_produtos_composicoes` (`Composicao`) USING BTREE,
  KEY `FK_produtos_produtos_cor` (`Cor`) USING BTREE,
  KEY `FK_produtos_produtos_generos` (`Genero`) USING BTREE,
  KEY `FK_produtos_produtos_linhas` (`Linha`) USING BTREE,
  KEY `FK_produtos_produtos_local_fisico` (`LocalFisico`) USING BTREE,
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_produtos_st_cofins` (`CST_COFINS`) USING BTREE,
  KEY `FK_produtos_st_ipi` (`CST_IPI`) USING BTREE,
  KEY `FK_produtos_st_origem` (`Origem`) USING BTREE,
  KEY `FK_produtos_st_pis` (`CST_PIS`) USING BTREE,
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`) USING BTREE,
  KEY `FK_produtos_produtos_GrupoSubGrupo` (`Grupo`,`GrupoCategoria`) USING BTREE,
  KEY `FK_produtos_cests_ncm` (`NCM`) USING BTREE,
  KEY `FK_produtos_produtos_estilos_teste` (`Estilo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProduto` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoCD`,`CodigoProduto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_barras`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_barras` (
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`) USING BTREE,
  CONSTRAINT `FK_produtos_barras_1` FOREIGN KEY (`Codigo`) REFERENCES `produtos` (`Codigo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_barras_antes_gcom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_barras_antes_gcom` (
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_barras_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_barras_api` (
  `CodigoCD` int(11) NOT NULL DEFAULT '0',
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`,`CodigoCD`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_barras_gcom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_barras_gcom` (
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab` (
  `Referencia` varchar(8) DEFAULT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL DEFAULT '' COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL DEFAULT '' COMMENT '4 ultimos digitos do codigo do fornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Linha` int(11) unsigned NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(3000) NOT NULL,
  `Tamanho` varchar(3000) DEFAULT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo',
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S/N',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `IDXDistribuidora` (`Referencia`) USING BTREE,
  KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_produtos_produtos_linhas` (`Linha`) USING BTREE,
  KEY `FK_produtos_produtos_colecao` (`Colecao`) USING BTREE,
  KEY `FK_produtos_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_produtos_st_origem` (`Origem`) USING BTREE,
  KEY `FK_produtos_st_pis` (`CST_PIS`) USING BTREE,
  KEY `FK_produtos_st_cofins` (`CST_COFINS`) USING BTREE,
  KEY `FK_produtos_st_ipi` (`CST_IPI`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`) USING BTREE,
  KEY `FK_produtos_produtos_cor` (`Cor`) USING BTREE,
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`) USING BTREE,
  KEY `FK_produtos_produtos_categorias` (`Categoria`) USING BTREE,
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_produtos_produtos_generos` (`Genero`) USING BTREE,
  KEY `FK_produtos_produtos_composicoes` (`Composicao`) USING BTREE,
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`) USING BTREE,
  KEY `FK_produtos_cab_produtos_grupos` (`Grupo`,`GrupoCategoria`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `FK_produtos_cab_cests_ncm` (`NCM`),
  KEY `FK_produtos_cab_produtos_estilos` (`Estilo`),
  CONSTRAINT `FK_produtos_cab_cests_ncm` FOREIGN KEY (`NCM`) REFERENCES `cests_ncm` (`ncm`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_cab_produtos_estilos` FOREIGN KEY (`Estilo`) REFERENCES `produtos_estilos` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_cab_produtos_grupos` FOREIGN KEY (`Grupo`, `GrupoCategoria`) REFERENCES `produtos_grupos` (`Grupo`, `SubGrupo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_10` FOREIGN KEY (`Caracteristica`) REFERENCES `produtos_caracteristicas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_11` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_12` FOREIGN KEY (`Colecao`) REFERENCES `produtos_colecao` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_13` FOREIGN KEY (`Composicao`) REFERENCES `produtos_composicoes` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_14` FOREIGN KEY (`Fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_15` FOREIGN KEY (`Genero`) REFERENCES `produtos_generos` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_2` FOREIGN KEY (`CFOP`) REFERENCES `cfops` (`CFOP`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_3` FOREIGN KEY (`Linha`) REFERENCES `produtos_linhas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_4` FOREIGN KEY (`Unidade`) REFERENCES `produtos_medidas` (`Sigla`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_5` FOREIGN KEY (`CST_COFINS`) REFERENCES `st_cofins` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_6` FOREIGN KEY (`CST_ICMS`) REFERENCES `st_icms` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_7` FOREIGN KEY (`CST_IPI`) REFERENCES `st_ipi` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_8` FOREIGN KEY (`Origem`) REFERENCES `st_origem` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_ibfk_9` FOREIGN KEY (`CST_PIS`) REFERENCES `st_pis` (`Codigo`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_antes_gcom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_antes_gcom` (
  `Referencia` varchar(8) DEFAULT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL DEFAULT '' COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL DEFAULT '' COMMENT '4 ultimos digitos do codigo do fornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Linha` int(11) unsigned NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(3000) NOT NULL,
  `Tamanho` varchar(3000) DEFAULT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo',
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S/N',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `IDXDistribuidora` (`Referencia`) USING BTREE,
  KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_produtos_produtos_linhas` (`Linha`) USING BTREE,
  KEY `FK_produtos_produtos_colecao` (`Colecao`) USING BTREE,
  KEY `FK_produtos_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_produtos_st_origem` (`Origem`) USING BTREE,
  KEY `FK_produtos_st_pis` (`CST_PIS`) USING BTREE,
  KEY `FK_produtos_st_cofins` (`CST_COFINS`) USING BTREE,
  KEY `FK_produtos_st_ipi` (`CST_IPI`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`) USING BTREE,
  KEY `FK_produtos_produtos_cor` (`Cor`) USING BTREE,
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`) USING BTREE,
  KEY `FK_produtos_produtos_categorias` (`Categoria`) USING BTREE,
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_produtos_produtos_generos` (`Genero`) USING BTREE,
  KEY `FK_produtos_produtos_composicoes` (`Composicao`) USING BTREE,
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`) USING BTREE,
  KEY `FK_produtos_cab_produtos_grupos` (`Grupo`,`GrupoCategoria`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `FK_produtos_cab_cests_ncm` (`NCM`) USING BTREE,
  KEY `FK_produtos_produtos_estilos` (`Estilo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_aux`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_aux` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `HashCode` varchar(60) DEFAULT NULL,
  `Referencia` varchar(8) DEFAULT NULL,
  `HashCodeDate` date DEFAULT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedorR3` varchar(4) NOT NULL DEFAULT '' COMMENT '4 ultimos digitos do codigo do fornecedor',
  `Grupo` varchar(40) NOT NULL,
  `Categoria` varchar(2) NOT NULL,
  `Descricao` varchar(130) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S/N',
  `Varejo` double NOT NULL DEFAULT '0',
  `Atacado` double NOT NULL DEFAULT '0',
  `Compra` double NOT NULL DEFAULT '0',
  `PrecoCheio` varchar(1) NOT NULL DEFAULT '',
  `Encomenda` varchar(1) NOT NULL DEFAULT '',
  `SetorLaranja` varchar(1) NOT NULL DEFAULT 'N',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Tamanho` varchar(100) DEFAULT '',
  `Cor` varchar(100) DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `IDXHasCodeReferencia` (`HashCode`,`Referencia`),
  KEY `IDXGrupo` (`Grupo`)
) ENGINE=InnoDB AUTO_INCREMENT=3200 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_aux_outras_informacoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_aux_outras_informacoes` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `HashCode` varchar(60) DEFAULT NULL,
  `Referencia` varchar(50) DEFAULT NULL,
  `HashCodeDate` date DEFAULT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedorR3` varchar(4) NOT NULL DEFAULT '',
  `Grupo` varchar(40) NOT NULL DEFAULT '',
  `Categoria` varchar(2) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N',
  `LocalFisico` int(11) DEFAULT NULL,
  `GTIN` varchar(14) NOT NULL DEFAULT '',
  `CodigoAlternativo` varchar(20) NOT NULL DEFAULT '',
  `Status` varchar(10) NOT NULL DEFAULT '',
  `Peso` double(13,3) DEFAULT '0.000',
  `Tamanho` varchar(3000) DEFAULT '',
  `Cor` varchar(3000) DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `Index 2` (`Referencia`,`HashCode`),
  KEY `FK_produtos_cab_aux_outras_informacoes_produtos_local_fisico` (`LocalFisico`),
  CONSTRAINT `FK_produtos_cab_aux_outras_informacoes_produtos_local_fisico` FOREIGN KEY (`LocalFisico`) REFERENCES `produtos_local_fisico` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1217 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_gcom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_gcom` (
  `Referencia` varchar(8) DEFAULT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL DEFAULT '' COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL DEFAULT '' COMMENT '4 ultimos digitos do codigo do fornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Linha` int(11) unsigned NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(3000) NOT NULL,
  `Tamanho` varchar(3000) DEFAULT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo',
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S/N',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `IDXDistribuidora` (`Referencia`) USING BTREE,
  KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_produtos_produtos_linhas` (`Linha`) USING BTREE,
  KEY `FK_produtos_produtos_colecao` (`Colecao`) USING BTREE,
  KEY `FK_produtos_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_produtos_st_origem` (`Origem`) USING BTREE,
  KEY `FK_produtos_st_pis` (`CST_PIS`) USING BTREE,
  KEY `FK_produtos_st_cofins` (`CST_COFINS`) USING BTREE,
  KEY `FK_produtos_st_ipi` (`CST_IPI`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`) USING BTREE,
  KEY `FK_produtos_produtos_cor` (`Cor`) USING BTREE,
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`) USING BTREE,
  KEY `FK_produtos_produtos_categorias` (`Categoria`) USING BTREE,
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_produtos_produtos_generos` (`Genero`) USING BTREE,
  KEY `FK_produtos_produtos_composicoes` (`Composicao`) USING BTREE,
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`) USING BTREE,
  KEY `FK_produtos_cab_produtos_grupos` (`Grupo`,`GrupoCategoria`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `FK_produtos_cab_cests_ncm` (`NCM`) USING BTREE,
  KEY `FK_produtos_produtos_estilos` (`Estilo`) USING BTREE,
  CONSTRAINT `produtos_cab_gcom_ibfk_1` FOREIGN KEY (`NCM`) REFERENCES `cests_ncm` (`ncm`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_10` FOREIGN KEY (`CFOP`) REFERENCES `cfops` (`CFOP`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_11` FOREIGN KEY (`Linha`) REFERENCES `produtos_linhas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_12` FOREIGN KEY (`Unidade`) REFERENCES `produtos_medidas` (`Sigla`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_13` FOREIGN KEY (`CST_COFINS`) REFERENCES `st_cofins` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_14` FOREIGN KEY (`CST_ICMS`) REFERENCES `st_icms` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_15` FOREIGN KEY (`CST_IPI`) REFERENCES `st_ipi` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_16` FOREIGN KEY (`Origem`) REFERENCES `st_origem` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_17` FOREIGN KEY (`CST_PIS`) REFERENCES `st_pis` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_2` FOREIGN KEY (`Grupo`, `GrupoCategoria`) REFERENCES `produtos_grupos` (`Grupo`, `SubGrupo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_3` FOREIGN KEY (`Estilo`) REFERENCES `produtos_estilos` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_4` FOREIGN KEY (`Caracteristica`) REFERENCES `produtos_caracteristicas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_5` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_6` FOREIGN KEY (`Colecao`) REFERENCES `produtos_colecao` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_7` FOREIGN KEY (`Composicao`) REFERENCES `produtos_composicoes` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_8` FOREIGN KEY (`Fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_gcom_ibfk_9` FOREIGN KEY (`Genero`) REFERENCES `produtos_generos` (`Codigo`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_grade`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_grade` (
  `Referencia` varchar(15) NOT NULL,
  `Distribuidora` varchar(15) NOT NULL,
  `GTIN` varchar(14) NOT NULL DEFAULT '',
  `Linha` int(11) unsigned NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL COMMENT '4 ultimos digitos do CodFornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `LocalFisico` int(11) DEFAULT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N',
  `CodigoAlternativo` varchar(20) NOT NULL DEFAULT '',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Distribuidora`) USING BTREE,
  KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_produtos_produtos_linhas` (`Linha`) USING BTREE,
  KEY `FK_produtos_produtos_colecao` (`Colecao`) USING BTREE,
  KEY `FK_produtos_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_produtos_st_origem` (`Origem`) USING BTREE,
  KEY `FK_produtos_st_pis` (`CST_PIS`) USING BTREE,
  KEY `FK_produtos_st_cofins` (`CST_COFINS`) USING BTREE,
  KEY `FK_produtos_st_ipi` (`CST_IPI`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`) USING BTREE,
  KEY `FK_produtos_produtos_local_fisico` (`LocalFisico`) USING BTREE,
  KEY `FK_produtos_produtos_cor` (`Cor`) USING BTREE,
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`) USING BTREE,
  KEY `FK_produtos_produtos_categorias` (`Categoria`) USING BTREE,
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_produtos_produtos_generos` (`Genero`) USING BTREE,
  KEY `FK_produtos_produtos_composicoes` (`Composicao`) USING BTREE,
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`) USING BTREE,
  KEY `FK_produtos_produtos_grupos` (`Grupo`) USING BTREE,
  KEY `FK_produtos_grupos` (`Grupo`,`GrupoCategoria`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `IDXReferenciaConsolidacao` (`Referencia`,`Consolidado`),
  KEY `FK_produtos_cab_grade_cests_ncm` (`NCM`),
  KEY `FK_produtos_cab_grade_produtos_estilos` (`Estilo`),
  CONSTRAINT `FK_produtos_cab` FOREIGN KEY (`Referencia`) REFERENCES `produtos_cab` (`Referencia`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_cab_grade_cests_ncm` FOREIGN KEY (`NCM`) REFERENCES `cests_ncm` (`ncm`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_cab_grade_produtos_estilos` FOREIGN KEY (`Estilo`) REFERENCES `produtos_estilos` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_cab_grade_produtos_grupos` FOREIGN KEY (`Grupo`, `GrupoCategoria`) REFERENCES `produtos_grupos` (`Grupo`, `SubGrupo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_1` FOREIGN KEY (`CFOP`) REFERENCES `cfops` (`CFOP`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_10` FOREIGN KEY (`Linha`) REFERENCES `produtos_linhas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_11` FOREIGN KEY (`LocalFisico`) REFERENCES `produtos_local_fisico` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_12` FOREIGN KEY (`Unidade`) REFERENCES `produtos_medidas` (`Sigla`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_13` FOREIGN KEY (`Tamanho`) REFERENCES `produtos_tamanho` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_14` FOREIGN KEY (`CST_COFINS`) REFERENCES `st_cofins` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_15` FOREIGN KEY (`CST_ICMS`) REFERENCES `st_icms` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_16` FOREIGN KEY (`CST_IPI`) REFERENCES `st_ipi` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_17` FOREIGN KEY (`Origem`) REFERENCES `st_origem` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_18` FOREIGN KEY (`CST_PIS`) REFERENCES `st_pis` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_3` FOREIGN KEY (`Caracteristica`) REFERENCES `produtos_caracteristicas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_4` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_5` FOREIGN KEY (`Colecao`) REFERENCES `produtos_colecao` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_6` FOREIGN KEY (`Composicao`) REFERENCES `produtos_composicoes` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_7` FOREIGN KEY (`Cor`) REFERENCES `produtos_cor` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_8` FOREIGN KEY (`Fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_cab_grade_ibfk_9` FOREIGN KEY (`Genero`) REFERENCES `produtos_generos` (`Codigo`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_grade_antes_gcom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_grade_antes_gcom` (
  `Referencia` varchar(15) NOT NULL,
  `Distribuidora` varchar(15) NOT NULL,
  `GTIN` varchar(14) NOT NULL DEFAULT '',
  `Linha` int(11) unsigned NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL COMMENT '4 ultimos digitos do CodFornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `LocalFisico` int(11) DEFAULT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N',
  `CodigoAlternativo` varchar(20) NOT NULL DEFAULT '',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Distribuidora`) USING BTREE,
  KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_produtos_produtos_linhas` (`Linha`) USING BTREE,
  KEY `FK_produtos_produtos_colecao` (`Colecao`) USING BTREE,
  KEY `FK_produtos_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_produtos_st_origem` (`Origem`) USING BTREE,
  KEY `FK_produtos_st_pis` (`CST_PIS`) USING BTREE,
  KEY `FK_produtos_st_cofins` (`CST_COFINS`) USING BTREE,
  KEY `FK_produtos_st_ipi` (`CST_IPI`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`) USING BTREE,
  KEY `FK_produtos_produtos_local_fisico` (`LocalFisico`) USING BTREE,
  KEY `FK_produtos_produtos_cor` (`Cor`) USING BTREE,
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`) USING BTREE,
  KEY `FK_produtos_produtos_categorias` (`Categoria`) USING BTREE,
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_produtos_produtos_generos` (`Genero`) USING BTREE,
  KEY `FK_produtos_produtos_composicoes` (`Composicao`) USING BTREE,
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`) USING BTREE,
  KEY `FK_produtos_produtos_grupos` (`Grupo`) USING BTREE,
  KEY `FK_produtos_grupos` (`Grupo`,`GrupoCategoria`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `IDXReferenciaConsolidacao` (`Referencia`,`Consolidado`) USING BTREE,
  KEY `FK_produtos_cab_grade_cests_ncm` (`NCM`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_grade_aux`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_grade_aux` (
  `Referencia` varchar(15) NOT NULL,
  `ID_CabAux` bigint(20) unsigned NOT NULL,
  `Distribuidora` varchar(15) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedorR3` varchar(4) NOT NULL COMMENT '4 ultimos digitos do CodFornecedor',
  `Grupo` varchar(40) DEFAULT '',
  `Categoria` varchar(2) NOT NULL,
  `Varejo` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `Atacado` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `Compra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `Status` varchar(8) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N',
  `Selecionado` varchar(1) NOT NULL DEFAULT 'N',
  `Tamanho` varchar(50) DEFAULT '',
  `Cor` varchar(50) DEFAULT '',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Distribuidora`,`ID_CabAux`) USING BTREE,
  KEY `IDXReferenciaConsolidacao` (`Referencia`,`Consolidado`) USING BTREE,
  KEY `FK_produtos_cab_grade_aux_produtos_cab_aux` (`ID_CabAux`),
  CONSTRAINT `FK_produtos_cab_grade_aux_produtos_cab_aux` FOREIGN KEY (`ID_CabAux`) REFERENCES `produtos_cab_aux` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_grade_aux_outras_informacoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_grade_aux_outras_informacoes` (
  `Referencia` varchar(14) NOT NULL,
  `ID_CabAux` bigint(20) NOT NULL,
  `Distribuidora` varchar(15) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedorR3` varchar(4) NOT NULL,
  `Grupo` varchar(40) NOT NULL DEFAULT '',
  `Categoria` varchar(2) NOT NULL,
  `GTIN` varchar(50) NOT NULL DEFAULT '',
  `LocalFisico` int(11) DEFAULT NULL,
  `Status` varchar(8) NOT NULL DEFAULT '',
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N',
  `Selecionado` varchar(1) NOT NULL DEFAULT 'N',
  `CodigoAlternativo` varchar(50) NOT NULL DEFAULT '',
  `Peso` double(13,3) DEFAULT '0.000',
  `Tamanho` varchar(50) DEFAULT '',
  `Cor` varchar(50) DEFAULT '',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID_CabAux`,`Distribuidora`),
  KEY `Index 1` (`Consolidado`,`Referencia`) USING BTREE,
  KEY `FK_produto_local` (`LocalFisico`),
  KEY `IDXCabAux` (`ID_CabAux`) USING BTREE,
  KEY `IDXQuebra` (`Grupo`,`Selecionado`,`Distribuidora`),
  CONSTRAINT `FK_produto_local` FOREIGN KEY (`LocalFisico`) REFERENCES `produtos_local_fisico` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_produtos_cab_grade_au` FOREIGN KEY (`ID_CabAux`) REFERENCES `produtos_cab_aux_outras_informacoes` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cab_grade_gcom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cab_grade_gcom` (
  `Referencia` varchar(15) NOT NULL,
  `Distribuidora` varchar(15) NOT NULL,
  `GTIN` varchar(14) NOT NULL DEFAULT '',
  `Linha` int(11) unsigned NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL COMMENT '4 ultimos digitos do CodFornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `LocalFisico` int(11) DEFAULT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Consolidado` varchar(1) NOT NULL DEFAULT 'N',
  `CodigoAlternativo` varchar(20) NOT NULL DEFAULT '',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Distribuidora`) USING BTREE,
  KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_produtos_produtos_linhas` (`Linha`) USING BTREE,
  KEY `FK_produtos_produtos_colecao` (`Colecao`) USING BTREE,
  KEY `FK_produtos_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_produtos_st_origem` (`Origem`) USING BTREE,
  KEY `FK_produtos_st_pis` (`CST_PIS`) USING BTREE,
  KEY `FK_produtos_st_cofins` (`CST_COFINS`) USING BTREE,
  KEY `FK_produtos_st_ipi` (`CST_IPI`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`) USING BTREE,
  KEY `FK_produtos_produtos_local_fisico` (`LocalFisico`) USING BTREE,
  KEY `FK_produtos_produtos_cor` (`Cor`) USING BTREE,
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`) USING BTREE,
  KEY `FK_produtos_produtos_categorias` (`Categoria`) USING BTREE,
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_produtos_produtos_generos` (`Genero`) USING BTREE,
  KEY `FK_produtos_produtos_composicoes` (`Composicao`) USING BTREE,
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`) USING BTREE,
  KEY `FK_produtos_produtos_grupos` (`Grupo`) USING BTREE,
  KEY `FK_produtos_grupos` (`Grupo`,`GrupoCategoria`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `IDXReferenciaConsolidacao` (`Referencia`,`Consolidado`) USING BTREE,
  KEY `FK_produtos_cab_grade_cests_ncm` (`NCM`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_caracteristicas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_caracteristicas` (
  `Codigo` int(11) NOT NULL,
  `Caracteristica` varchar(40) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(50) DEFAULT '',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXCaracteristica` (`Caracteristica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_caracteristicas_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_caracteristicas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCaracteristica` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoCaracteristica`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_categoria_caracteristicas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_categoria_caracteristicas` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Categoria` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) DEFAULT '',
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXCategoriaComposicao` (`Categoria`,`Caracteristica`) USING BTREE,
  KEY `FK_produtos_categoria_caracteristicas_produtos_caracteristicas` (`Caracteristica`),
  CONSTRAINT `FK_produtos_categoria_caracteristicas_produtos_caracteristicas` FOREIGN KEY (`Caracteristica`) REFERENCES `produtos_caracteristicas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_produtos_categoria_caracteristicas_produtos_categorias_livre` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias_livre` (`Codigo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1476 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_categoria_caracteristicas_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_categoria_caracteristicas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCategoriaCaracteristica` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoCategoriaCaracteristica`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_categoria_composicao`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_categoria_composicao` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Categoria` int(11) NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) DEFAULT '',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXCategoriaComposicao` (`Categoria`,`Composicao`),
  KEY `FK_produtos_categoria_composicao_produtos_composicoes` (`Composicao`),
  CONSTRAINT `FK_produtos_categoria_composicao_produtos_categorias_livre` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias_livre` (`Codigo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_categoria_composicao_produtos_composicoes` FOREIGN KEY (`Composicao`) REFERENCES `produtos_composicoes` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1455 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_categoria_composicao_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_categoria_composicao_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCategoriaComposicao` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoProdutoCategoriaComposicao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_categorias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_categorias` (
  `Codigo` varchar(2) NOT NULL,
  `TipoProduto` varchar(30) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXTipProduto` (`TipoProduto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='R2 -> tbProdutosTipo ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_categorias_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_categorias_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCategoria` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoProdutoCategoria`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_categorias_livre`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_categorias_livre` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `CategoriaLivre` varchar(40) CHARACTER SET latin1 NOT NULL,
  `Sts` varchar(8) NOT NULL DEFAULT 'Ativo',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXCategoriaLivre` (`CategoriaLivre`)
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_categorias_livre_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_categorias_livre_api` (
  `CodigoCategoriaLivre` int(11) NOT NULL,
  `CodigoCD` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoCategoriaLivre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_colecao`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_colecao` (
  `Codigo` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Colecao` varchar(40) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Externo` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 - Interno, 1 - Externo',
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXModelo` (`Colecao`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1 COMMENT='tbModelos - Modelos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_colecao_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_colecao_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoColecao` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoProdutoColecao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_composicoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_composicoes` (
  `Codigo` int(11) NOT NULL,
  `Composicao` varchar(40) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) DEFAULT '',
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXComposicao` (`Composicao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_composicoes_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_composicoes_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoComposicao` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoComposicao`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_conta_corrente`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_conta_corrente` (
  `CD` int(11) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `Registro` bigint(20) NOT NULL,
  `DataMov` date DEFAULT NULL,
  `Produto` varchar(8) NOT NULL,
  `Referencia` varchar(15) NOT NULL,
  `Operacao` varchar(10) NOT NULL DEFAULT '' COMMENT 'Entrada/Saida',
  `Motivo` varchar(120) NOT NULL DEFAULT '',
  `Quantidade` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Entrada -> positivo , Saida -> Negativo',
  `SaldoContaCorrente` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'SaldoContaCorrente = ultimo saldo Conta corrente desse item + Quantidade',
  `CustoMedio` double(12,2) NOT NULL DEFAULT '0.00',
  `CustoUltimo` double(12,2) NOT NULL DEFAULT '0.00',
  `PrecoVenda` double(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`CD`,`Registro`),
  KEY `IDXProCDReg` (`Produto`,`CD`,`Registro`),
  KEY `FK_produtos_conta_corrente_empresas` (`Empresa`),
  KEY `IDXCDRegPro` (`CD`,`Empresa`,`Registro`,`Produto`) USING BTREE,
  KEY `IDXDtMovProCD` (`DataMov`,`Produto`,`CD`,`Empresa`) USING BTREE,
  KEY `IDXRefDtMov` (`Referencia`,`DataMov`,`CD`,`Empresa`) USING BTREE,
  KEY `IDXDtMovRef` (`DataMov`,`Referencia`,`CD`,`Empresa`) USING BTREE,
  CONSTRAINT `FK_produtos_conta_corrente_empresas` FOREIGN KEY (`Empresa`) REFERENCES `empresas` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_produtos_conta_corrente_empresas_cd` FOREIGN KEY (`CD`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_produtos_conta_corrente_produtos` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cor` (
  `Codigo` varchar(2) NOT NULL,
  `Nome` varchar(20) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `Nome` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tbProdutosCor\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_cor_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_cor_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCor` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoCD`,`CodigoProdutoCor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_custos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_custos` (
  `Produto` varchar(8) NOT NULL DEFAULT '',
  `Estoque` double(15,3) NOT NULL DEFAULT '0.000',
  `CustoMedio` double(12,2) NOT NULL DEFAULT '0.00',
  `CustoUltimo` double(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`Produto`) USING BTREE,
  CONSTRAINT `FK_produtos_custos_produtos` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_estilos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_estilos` (
  `Codigo` int(11) NOT NULL,
  `Descricao` varchar(120) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `Index 2` (`Descricao`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_estoque`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_estoque` (
  `CD` int(11) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `Produto` varchar(8) CHARACTER SET latin1 NOT NULL,
  `Referencia` varchar(20) COLLATE latin1_general_ci NOT NULL,
  `Estoque` double(12,2) NOT NULL DEFAULT '0.00',
  `DataPrimeiraCompra` date DEFAULT NULL,
  `ValorUltimaCompra` double(12,2) NOT NULL DEFAULT '0.00',
  `DataUltimaCompra` date DEFAULT NULL,
  `DataUltimaVenda` date DEFAULT NULL,
  `ValorUltimaVenda` double(12,2) NOT NULL DEFAULT '0.00',
  `CustoUnitario` double(12,2) NOT NULL,
  `CustoMedio` double(12,2) NOT NULL,
  PRIMARY KEY (`CD`,`Empresa`,`Produto`),
  KEY `IDXCdEmpresaReferencia` (`CD`,`Empresa`,`Referencia`),
  KEY `IDXProdutoCdEmprea` (`Produto`,`CD`,`Empresa`) USING BTREE,
  KEY `IDXReferenciaCdEmpresa` (`Referencia`,`CD`,`Empresa`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_fornecedor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_fornecedor_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_fornecedor_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoFornecedor` varchar(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoProdutoFornecedor`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_fotos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_fotos` (
  `Referencia` varchar(8) CHARACTER SET latin1 NOT NULL,
  `Sequencia` int(5) NOT NULL DEFAULT '0',
  `Foto` mediumblob NOT NULL,
  `Usuario` varchar(50) NOT NULL,
  `Inclusao` date NOT NULL,
  PRIMARY KEY (`Referencia`,`Sequencia`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `produtos_fotos_before_insert` BEFORE INSERT ON `produtos_fotos` FOR EACH ROW BEGIN
	CALL allop_kidstok.sp_atualiza_data_alteracao_produtos_cab(NEW.Referencia);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `produtos_fotos_before_update` BEFORE UPDATE ON `produtos_fotos` FOR EACH ROW BEGIN
	CALL allop_kidstok.sp_atualiza_data_alteracao_produtos_cab(NEW.Referencia);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `produtos_fotos_before_delete` BEFORE DELETE ON `produtos_fotos` FOR EACH ROW BEGIN
	CALL allop_kidstok.sp_atualiza_data_alteracao_produtos_cab(OLD.Referencia);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `produtos_fotos_old`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_fotos_old` (
  `Referencia` varchar(8) CHARACTER SET latin1 NOT NULL,
  `Sequencia` int(5) NOT NULL DEFAULT '0',
  `Arquivo` varchar(250) NOT NULL DEFAULT '',
  `Usuario` varchar(50) NOT NULL,
  `Inclusao` date NOT NULL,
  PRIMARY KEY (`Referencia`,`Sequencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_gcom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_gcom` (
  `Codigo` varchar(8) NOT NULL,
  `Distribuidora` varchar(15) DEFAULT NULL,
  `GTIN` varchar(14) DEFAULT NULL,
  `Linha` int(11) unsigned NOT NULL,
  `Colecao` int(11) unsigned NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Composicao` int(11) NOT NULL,
  `Caracteristica` int(11) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Genero` int(11) NOT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL COMMENT '4 ultimos digitos do CodFornecedor',
  `Categoria` varchar(2) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `Origem` varchar(1) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `SetorLaranja` varchar(1) DEFAULT 'N',
  `PrecoCheio` varchar(1) DEFAULT 'N',
  `Encomenda` varchar(1) DEFAULT 'N' COMMENT 'Produto só por encomenda',
  `LocalFisico` int(11) DEFAULT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` datetime NOT NULL,
  `Alteracao` datetime NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `CodigoAlternativo` varchar(20) NOT NULL DEFAULT '',
  `Fashion` varchar(1) NOT NULL DEFAULT '0',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `Foto` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXDistribuidora` (`Distribuidora`) USING BTREE,
  KEY `IDXDescricao` (`Descricao`) USING BTREE,
  KEY `FK_produtos_produtos_medidas` (`Unidade`) USING BTREE,
  KEY `FK_produtos_produtos_grupos` (`Grupo`) USING BTREE,
  KEY `FK_produtos_st_icms` (`CST_ICMS`) USING BTREE,
  KEY `FK_produtos_cfops` (`CFOP`) USING BTREE,
  KEY `FK_produtos_produtos_caracteristicas` (`Caracteristica`) USING BTREE,
  KEY `FK_produtos_produtos_categorias` (`Categoria`) USING BTREE,
  KEY `FK_produtos_produtos_colecao` (`Colecao`) USING BTREE,
  KEY `FK_produtos_produtos_composicoes` (`Composicao`) USING BTREE,
  KEY `FK_produtos_produtos_cor` (`Cor`) USING BTREE,
  KEY `FK_produtos_produtos_generos` (`Genero`) USING BTREE,
  KEY `FK_produtos_produtos_linhas` (`Linha`) USING BTREE,
  KEY `FK_produtos_produtos_local_fisico` (`LocalFisico`) USING BTREE,
  KEY `FK_produtos_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_produtos_st_cofins` (`CST_COFINS`) USING BTREE,
  KEY `FK_produtos_st_ipi` (`CST_IPI`) USING BTREE,
  KEY `FK_produtos_st_origem` (`Origem`) USING BTREE,
  KEY `FK_produtos_st_pis` (`CST_PIS`) USING BTREE,
  KEY `FK_produtos_produtos_fornecedor` (`Fornecedor`) USING BTREE,
  KEY `FK_produtos_produtos_GrupoSubGrupo` (`Grupo`,`GrupoCategoria`) USING BTREE,
  KEY `FK_produtos_cests_ncm` (`NCM`) USING BTREE,
  KEY `FK_produtos_produtos_estilos_teste` (`Estilo`) USING BTREE,
  CONSTRAINT `produtos_gcom_ibfk_1` FOREIGN KEY (`NCM`) REFERENCES `cests_ncm` (`ncm`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_10` FOREIGN KEY (`Genero`) REFERENCES `produtos_generos` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_11` FOREIGN KEY (`Linha`) REFERENCES `produtos_linhas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_12` FOREIGN KEY (`LocalFisico`) REFERENCES `produtos_local_fisico` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_13` FOREIGN KEY (`Tamanho`) REFERENCES `produtos_tamanho` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_14` FOREIGN KEY (`CST_COFINS`) REFERENCES `st_cofins` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_15` FOREIGN KEY (`CST_ICMS`) REFERENCES `st_icms` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_16` FOREIGN KEY (`CST_IPI`) REFERENCES `st_ipi` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_17` FOREIGN KEY (`Origem`) REFERENCES `st_origem` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_18` FOREIGN KEY (`CST_PIS`) REFERENCES `st_pis` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_2` FOREIGN KEY (`CFOP`) REFERENCES `cfops` (`CFOP`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_3` FOREIGN KEY (`Grupo`, `GrupoCategoria`) REFERENCES `produtos_grupos` (`Grupo`, `SubGrupo`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_4` FOREIGN KEY (`Caracteristica`) REFERENCES `produtos_caracteristicas` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_5` FOREIGN KEY (`Categoria`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_6` FOREIGN KEY (`Colecao`) REFERENCES `produtos_colecao` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_7` FOREIGN KEY (`Composicao`) REFERENCES `produtos_composicoes` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_8` FOREIGN KEY (`Cor`) REFERENCES `produtos_cor` (`Codigo`) ON UPDATE CASCADE,
  CONSTRAINT `produtos_gcom_ibfk_9` FOREIGN KEY (`Fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_generos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_generos` (
  `Codigo` int(11) NOT NULL,
  `Genero` varchar(20) NOT NULL,
  `Abreviado` varchar(5) NOT NULL DEFAULT '',
  `Status` varchar(8) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXGenero` (`Genero`),
  KEY `IDXAbreviado` (`Abreviado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_generos_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_generos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoGenero` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoGenero`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_grupos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_grupos` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Grupo` varchar(40) NOT NULL,
  `SubGrupo` varchar(40) NOT NULL,
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo',
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXGrupoSubGrupo` (`Grupo`,`SubGrupo`),
  KEY `FK_produtos_grupos_produtos_categorias_livre` (`SubGrupo`),
  CONSTRAINT `FK_produtos_grupos_produtos_categorias_livre` FOREIGN KEY (`SubGrupo`) REFERENCES `produtos_categorias_livre` (`CategoriaLivre`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_produtos_grupos_produtos_grupos_livre` FOREIGN KEY (`Grupo`) REFERENCES `produtos_grupos_livre` (`GrupoLivre`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=487 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_grupos_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_grupos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoGrupo` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CodigoProdutoGrupo`,`CodigoCD`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_grupos_livre`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_grupos_livre` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `GrupoLivre` varchar(40) CHARACTER SET latin1 NOT NULL,
  `Sts` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT 'Ativo',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) DEFAULT '',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXGrupoLivre` (`GrupoLivre`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_grupos_livre_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_grupos_livre_api` (
  `CodigoGrupoLivre` int(11) NOT NULL,
  `CodigoCD` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoGrupoLivre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_grupos_tamanho`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_grupos_tamanho` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `GrupoLivre` int(11) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `Ordem` int(4) NOT NULL DEFAULT '0' COMMENT 'Ordem a ser apresentado na tela (para uso do Order By)',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXGrupoTamanho` (`GrupoLivre`,`Tamanho`) USING BTREE,
  KEY `IDXGrupoOrdem` (`GrupoLivre`,`Ordem`) USING BTREE,
  KEY `FK_produtos_grupos_tamanho_produtos_tamanho` (`Tamanho`),
  CONSTRAINT `FK_produtos_grupos_tamanho_produtos_grupos_livre` FOREIGN KEY (`GrupoLivre`) REFERENCES `produtos_grupos_livre` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_produtos_grupos_tamanho_produtos_tamanho` FOREIGN KEY (`Tamanho`) REFERENCES `produtos_tamanho` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_linhas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_linhas` (
  `Codigo` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Linha` varchar(40) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXLinha` (`Linha`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COMMENT='tbMarcas';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_linhas_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_linhas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoLinha` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoLinha`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_local_fisico`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_local_fisico` (
  `Codigo` int(11) NOT NULL,
  `Local` varchar(10) NOT NULL DEFAULT '',
  `Utilizado` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S-sim/N-não',
  `Compartilhado` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S/N',
  `Status` varchar(8) NOT NULL DEFAULT 'Ativo' COMMENT 'Ativo/Inativo',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) DEFAULT '',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXLocal` (`Local`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `produtos_local_fisico_after_insert` AFTER INSERT ON `produtos_local_fisico` FOR EACH ROW BEGIN
	REPLACE INTO produtos_local_fisico_api(	CodigoLocalFisico,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												produtos_local_fisico	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `produtos_local_fisico_after_update` AFTER UPDATE ON `produtos_local_fisico` FOR EACH ROW BEGIN
	REPLACE INTO produtos_local_fisico_api(	CodigoLocalFisico,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												produtos_local_fisico	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `produtos_local_fisico_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_local_fisico_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoLocalFisico` int(11) NOT NULL,
  PRIMARY KEY (`CodigoLocalFisico`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_log_preco`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_log_preco` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `DataHora` datetime DEFAULT NULL,
  `Produto` varchar(8) NOT NULL,
  `Referencia` varchar(20) NOT NULL,
  `Acao` varchar(15) NOT NULL COMMENT 'Inclusão/Alteração',
  `VarejoOLD` double NOT NULL DEFAULT '0',
  `VarejoNEW` double NOT NULL DEFAULT '0',
  `AtacadoOLD` double NOT NULL DEFAULT '0',
  `AtacadoNEW` double NOT NULL DEFAULT '0',
  `CompraOLD` double NOT NULL DEFAULT '0',
  `CompraNEW` double NOT NULL DEFAULT '0',
  `Usuario` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IDXProdutoDataHora` (`Produto`,`DataHora`) USING BTREE,
  KEY `IDXDataHoraProduto` (`DataHora`,`Produto`)
) ENGINE=InnoDB AUTO_INCREMENT=55049 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_medidas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_medidas` (
  `Sigla` varchar(2) NOT NULL,
  `Unidade` varchar(30) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Sigla`),
  UNIQUE KEY `Index_2` (`Unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tbMedidas';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_medidas_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_medidas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoMedida` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoProdutoMedida`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_precos_cab`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_precos_cab` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Numero do Lote',
  `Descricao` varchar(60) NOT NULL COMMENT 'Descricao da atualizacao de preco',
  `DataAtualizacao` date NOT NULL COMMENT 'Data que sera atualizado o preco',
  `DataVoltaAtualizacao` date DEFAULT NULL COMMENT 'Data que tera que voltar os precos anteriores',
  `Atualizado` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-Não atualizou preco, 1-Pedente Volta Preco, 9-Finalizado',
  `QtdeItens` int(11) NOT NULL DEFAULT '0' COMMENT 'Quantidade de itens ',
  `Usuario` varchar(60) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDXDataAtualizacao` (`DataAtualizacao`,`Atualizado`) USING BTREE,
  KEY `IDXDataVoltaAtualizacao` (`DataVoltaAtualizacao`,`Atualizado`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_precos_cab_h`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_precos_cab_h` (
  `ID` bigint(20) NOT NULL,
  `Descricao` varchar(60) NOT NULL COMMENT 'Descricao da atualizacao de preco',
  `DataAtualizacao` date NOT NULL COMMENT 'Data que sera atualizado o preco',
  `DataVoltaAtualizacao` date DEFAULT NULL COMMENT 'Data que tera que voltar os precos anteriores',
  `Atualizado` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-Não atualizou preco, 1-Atualizou preco',
  `QtdeItens` int(11) NOT NULL DEFAULT '0' COMMENT 'Quantidade de itens ',
  `Usuario` varchar(60) NOT NULL COMMENT 'Usuario que incluiu ou atualizou',
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_precos_itens`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_precos_itens` (
  `IDItens` bigint(20) NOT NULL AUTO_INCREMENT,
  `IDCab` bigint(20) NOT NULL COMMENT 'ID do Cabecalho, Numero do Lote',
  `Sequencia` int(11) NOT NULL DEFAULT '0' COMMENT 'Sequencia para organizar',
  `ReferenciaMaster` varchar(15) NOT NULL COMMENT 'referencia com 8 caracteres',
  `Produto` varchar(8) NOT NULL COMMENT 'Codigo do produto',
  `Referencia` varchar(15) NOT NULL COMMENT 'Referencia = Distribuidora',
  `Descricao` varchar(60) NOT NULL COMMENT 'Descrição do produto',
  `PrecoAtacadoAtual` double NOT NULL DEFAULT '0' COMMENT 'Preco Atual do Atacado',
  `PrecoVarejoAtual` double NOT NULL DEFAULT '0' COMMENT 'Preco Atual do Varejo',
  `PrecoAtacadoNovo` double NOT NULL DEFAULT '0' COMMENT 'Preco Novo do Atacado',
  `PrecoVarejoNovo` double NOT NULL DEFAULT '0' COMMENT 'Preco Novo do Varejo',
  PRIMARY KEY (`IDItens`),
  UNIQUE KEY `IDXCabSequenciaProduto` (`IDCab`,`Sequencia`,`Produto`),
  KEY `FK_produtos_precos_itens_produtos` (`Produto`),
  CONSTRAINT `FK_produtos_precos_itens_produtos` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_produtos_precos_itens_produtos_precos_cab` FOREIGN KEY (`IDCab`) REFERENCES `produtos_precos_cab` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_precos_itens_h`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_precos_itens_h` (
  `IDItens` bigint(20) NOT NULL,
  `IDCab` bigint(20) NOT NULL COMMENT 'ID do Cabecalho, numero do lote',
  `Sequencia` int(11) NOT NULL DEFAULT '0' COMMENT 'Sequencia para organizar',
  `ReferenciaMaster` varchar(15) NOT NULL COMMENT 'referencia com 8 caracteres',
  `Produto` varchar(8) NOT NULL COMMENT 'Codigo do produto',
  `Referencia` varchar(15) NOT NULL COMMENT 'Referencia = Distribuidora',
  `Descricao` varchar(60) NOT NULL COMMENT 'Descricao do produto',
  `PrecoAtacadoAtual` double NOT NULL DEFAULT '0' COMMENT 'Preco Atual do Atacado',
  `PrecoVarejoAtual` double NOT NULL DEFAULT '0' COMMENT 'Preco Atual do Varejo',
  `PrecoAtacadoNovo` double NOT NULL DEFAULT '0' COMMENT 'Preco Novo do Atacado',
  `PrecoVarejoNovo` double NOT NULL DEFAULT '0' COMMENT 'Preco Novo do Varejo',
  PRIMARY KEY (`IDItens`),
  KEY `FK_produtos_precos_itens_h_produtos_precos_cab_h` (`IDCab`),
  CONSTRAINT `FK_produtos_precos_itens_h_produtos_precos_cab_h` FOREIGN KEY (`IDCab`) REFERENCES `produtos_precos_cab_h` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_prm`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_prm` (
  `Codigo` int(11) NOT NULL,
  `CFOP` varchar(4) NOT NULL DEFAULT '',
  `Origem` varchar(1) NOT NULL DEFAULT '',
  `CST_ICMS` varchar(3) NOT NULL DEFAULT '',
  `AliquotaICMS` double NOT NULL DEFAULT '0',
  `ReducaoBaseICMS` double NOT NULL DEFAULT '0',
  `CST_PIS` varchar(2) NOT NULL DEFAULT '',
  `AliquotaPIS` double NOT NULL DEFAULT '0',
  `CST_COFINS` varchar(2) NOT NULL DEFAULT '',
  `AliquotaCOFINS` double NOT NULL DEFAULT '0',
  `CST_IPI` varchar(2) NOT NULL DEFAULT '',
  `AliquotaIPI` double NOT NULL DEFAULT '0',
  `UpperCase` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'Identifica se é upper case as descricoes',
  `PrecoAtacadoMetadeVarejo` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'Identifica se o preco de Atacado vai ser igual ao preço Varejo dividido por 2',
  PRIMARY KEY (`Codigo`) USING BTREE,
  KEY `Index 1` (`CFOP`) USING BTREE,
  KEY `Index 3` (`Origem`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_referencias_prod`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_referencias_prod` (
  `Referencia` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `produtos_referencias_vw`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `produtos_referencias_vw` AS SELECT
 1 AS `Referencia`,
  1 AS `Distribuidora`,
  1 AS `PrecoVendaTabela`,
  1 AS `PrecoCompraTabela`,
  1 AS `PrecoCheio`,
  1 AS `Codigo`,
  1 AS `Descricao` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `produtos_tamanho`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_tamanho` (
  `Codigo` varchar(2) NOT NULL,
  `Nome` varchar(20) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `Nome` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tbProdutosTamanho';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_tamanho_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_tamanho_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoTamanho` varchar(2) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoProdutoTamanho`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtos_tamanho_ordem`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `produtos_tamanho_ordem` (
  `Codigo` varchar(2) NOT NULL,
  `Ordem` int(11) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  CONSTRAINT `FK_produtos_tamanho_ordem_produtos_tamanho` FOREIGN KEY (`Codigo`) REFERENCES `produtos_tamanho` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='tbProdutosTamanho';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `produtos_vw_grid`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `produtos_vw_grid` AS SELECT
 1 AS `Referencia`,
  1 AS `Fornecedor`,
  1 AS `CodFornecedor`,
  1 AS `CodFornecedorR3`,
  1 AS `Categoria`,
  1 AS `Status`,
  1 AS `Usuario`,
  1 AS `Consolidado`,
  1 AS `DescricaoCompleta`,
  1 AS `NomeFornecedor`,
  1 AS `Encomenda`,
  1 AS `TipoProduto`,
  1 AS `Foto`,
  1 AS `Estilo` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `produtos_vw_saida`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `produtos_vw_saida` AS SELECT
 1 AS `Codigo`,
  1 AS `GTIN`,
  1 AS `CodigoAlternativo`,
  1 AS `Distribuidora`,
  1 AS `Fornecedor`,
  1 AS `NomeFornecedor`,
  1 AS `CodFornecedor`,
  1 AS `CodFornecedorR3`,
  1 AS `Descricao`,
  1 AS `DescricaoComplementar`,
  1 AS `Caracteristica`,
  1 AS `Composicao`,
  1 AS `Unidade`,
  1 AS `Cor`,
  1 AS `NomeCor`,
  1 AS `Foto`,
  1 AS `Linha`,
  1 AS `Colecao`,
  1 AS `Categoria`,
  1 AS `Genero`,
  1 AS `Grupo`,
  1 AS `GrupoCategoria`,
  1 AS `Tamanho`,
  1 AS `Fashion`,
  1 AS `Estilo`,
  1 AS `NCM`,
  1 AS `CST_ICMS`,
  1 AS `AliquotaICMS`,
  1 AS `ReducaoICMS`,
  1 AS `CST_PIS`,
  1 AS `AliquotaPIS`,
  1 AS `CST_COFINS`,
  1 AS `AliquotaCOFINS`,
  1 AS `CST_IPI`,
  1 AS `AliquotaIPI`,
  1 AS `CFOP`,
  1 AS `CFOP_ProducaoProria`,
  1 AS `Origem`,
  1 AS `PrecoVendaTabela`,
  1 AS `PrecoCompraTabela`,
  1 AS `PrecoCompra`,
  1 AS `PrecoCheio`,
  1 AS `SetorLaranja`,
  1 AS `Encomenda`,
  1 AS `Status`,
  1 AS `Usuario`,
  1 AS `Peso`,
  1 AS `Quantidade`,
  1 AS `ValorTotal`,
  1 AS `Data_Romaneio`,
  1 AS `Filial`,
  1 AS `Romaneio`,
  1 AS `Sequencia` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `produtos_vw_tudo`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `produtos_vw_tudo` AS SELECT
 1 AS `Codigo`,
  1 AS `GTIN`,
  1 AS `CodigoAlternativo`,
  1 AS `Distribuidora`,
  1 AS `Fornecedor`,
  1 AS `NomeFornecedor`,
  1 AS `CodFornecedor`,
  1 AS `CodFornecedorR3`,
  1 AS `Descricao`,
  1 AS `DescricaoComplementar`,
  1 AS `Caracteristica`,
  1 AS `Composicao`,
  1 AS `Unidade`,
  1 AS `Cor`,
  1 AS `NomeCor`,
  1 AS `Foto`,
  1 AS `Linha`,
  1 AS `Colecao`,
  1 AS `Categoria`,
  1 AS `Genero`,
  1 AS `Grupo`,
  1 AS `GrupoCategoria`,
  1 AS `Tamanho`,
  1 AS `Fashion`,
  1 AS `Estilo`,
  1 AS `NCM`,
  1 AS `CST_ICMS`,
  1 AS `AliquotaICMS`,
  1 AS `ReducaoICMS`,
  1 AS `CST_PIS`,
  1 AS `AliquotaPIS`,
  1 AS `CST_COFINS`,
  1 AS `AliquotaCOFINS`,
  1 AS `CST_IPI`,
  1 AS `AliquotaIPI`,
  1 AS `CFOP`,
  1 AS `CFOP_ProducaoProria`,
  1 AS `Origem`,
  1 AS `PrecoVendaTabela`,
  1 AS `PrecoCompraTabela`,
  1 AS `PrecoCompra`,
  1 AS `PrecoCheio`,
  1 AS `SetorLaranja`,
  1 AS `Encomenda`,
  1 AS `Status`,
  1 AS `Inclusao`,
  1 AS `Alteracao`,
  1 AS `Usuario`,
  1 AS `Peso` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `provisorios`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `provisorios` (
  `Id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Franqueado` int(11) NOT NULL,
  `Cliente` int(11) NOT NULL,
  `TotalProvisorio` double DEFAULT '0' COMMENT 'Soma de todos os valores dos Romaneios',
  `TotalCreditos` double DEFAULT '0',
  `TotalDebitos` double DEFAULT '0',
  `TotalRomaneios` int(11) DEFAULT '0' COMMENT 'Qtde de Romaneios',
  `TotalItens` int(11) DEFAULT '0' COMMENT 'Qtde de Itens',
  `TotalPecas` int(11) DEFAULT '0' COMMENT 'Qtde de Peças dos romaneios',
  `TotalSaldo` double DEFAULT '0' COMMENT 'TotalProvisorio - TotalDebitos + TotalCreditos',
  `DataLiberacao` date DEFAULT NULL,
  `Usuario` varchar(50) DEFAULT NULL,
  `Inclusao` date DEFAULT NULL,
  `ObservacaoFechamento` text,
  `ObservacaoFaturamento` text,
  `Fechamento` int(11) unsigned DEFAULT NULL COMMENT 'ID do fechamento',
  `Liberado` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `FK_provisorios_franqueados` (`Franqueado`),
  KEY `FK_provisorios_responsaveis` (`Cliente`),
  KEY `FK_provisorios_fechamento` (`Fechamento`) USING BTREE,
  CONSTRAINT `FK_provisorios_fechamento` FOREIGN KEY (`Fechamento`) REFERENCES `fechamento` (`ID`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_provisorios_franqueados` FOREIGN KEY (`Franqueado`) REFERENCES `franqueados` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_provisorios_responsaveis` FOREIGN KEY (`Cliente`) REFERENCES `responsaveis` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `provisorios_lancamentos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `provisorios_lancamentos` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Provisorio` int(11) unsigned NOT NULL,
  `TipoLancamento` int(11) NOT NULL,
  `Operacao` varchar(1) NOT NULL COMMENT 'C-Credito, D-Debito',
  `Valor` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Quando a operacao for Debito - lancar o valor negativo',
  `Data` date NOT NULL,
  `Observacao` varchar(60) NOT NULL DEFAULT '',
  `Usuario` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `FK_provisorios_lancamentos_provisorios` (`Provisorio`),
  KEY `FK_provisorios_lancamentos_tipos_lancamentos` (`TipoLancamento`) USING BTREE,
  CONSTRAINT `FK_provisorios_lancamentos_provisorios` FOREIGN KEY (`Provisorio`) REFERENCES `provisorios` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_provisorios_lancamentos_tipos_lancamentos` FOREIGN KEY (`TipoLancamento`) REFERENCES `tipos_lancamentos` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `provisorios_lancamentos_after_insert` AFTER INSERT ON `provisorios_lancamentos` FOR EACH ROW BEGIN
	CALL sp_provisorios_atualizar_totais_creditos(NEW.Provisorio);
	CALL sp_provisorios_atualizar_totais_debitos(NEW.Provisorio);
	CALL sp_provisorios_atualizar_saldo(NEW.Provisorio);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `provisorios_lancamentos_after_update` AFTER UPDATE ON `provisorios_lancamentos` FOR EACH ROW BEGIN
	CALL sp_provisorios_atualizar_totais_creditos(NEW.Provisorio);
	CALL sp_provisorios_atualizar_totais_debitos(NEW.Provisorio);
	CALL sp_provisorios_atualizar_saldo(NEW.Provisorio);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `provisorios_lancamentos_after_delete` AFTER DELETE ON `provisorios_lancamentos` FOR EACH ROW BEGIN
	CALL sp_provisorios_atualizar_totais_creditos(OLD.Provisorio);
	CALL sp_provisorios_atualizar_totais_debitos(OLD.Provisorio);
	CALL sp_provisorios_atualizar_saldo(OLD.Provisorio);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ramo_atividades`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `ramo_atividades` (
  `Codigo` int(11) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Fixo` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1-fixo, 0-Não Fixo',
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `ramo_atividades_after_insert` AFTER INSERT ON `ramo_atividades` FOR EACH ROW BEGIN
	REPLACE INTO ramo_atividades_api(	CodigoRamoAtividades,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												ramo_atividades	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `ramo_atividades_after_update` AFTER UPDATE ON `ramo_atividades` FOR EACH ROW BEGIN
	REPLACE INTO ramo_atividades_api(	CodigoRamoAtividades,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												ramo_atividades	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ramo_atividades_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `ramo_atividades_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoRamoAtividades` int(11) NOT NULL,
  PRIMARY KEY (`CodigoRamoAtividades`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regioes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `regioes` (
  `Regiao` varchar(15) NOT NULL,
  PRIMARY KEY (`Regiao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `regioes_after_insert` AFTER INSERT ON `regioes` FOR EACH ROW BEGIN
	REPLACE INTO regioes_api(	CodigoRegiao,
											CodigoCD
										)
										(
											SELECT 
												t1.Regiao,
												t2.Codigo			 
											FROM 
												regioes	t1,
												empresas_cd t2
												WHERE 
												t1.Regiao = NEW.Regiao
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `regioes_after_update` AFTER UPDATE ON `regioes` FOR EACH ROW BEGIN
	REPLACE INTO regioes_api(	CodigoRegiao,
											CodigoCD
										)
										(
											SELECT 
												t1.Regiao,
												t2.Codigo			 
											FROM 
												regioes	t1,
												empresas_cd t2
												WHERE 
												t1.Regiao = NEW.Regiao
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `regioes_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `regioes_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoRegiao` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoRegiao`,`CodigoCD`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `responsaveis`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `responsaveis` (
  `Codigo` int(11) NOT NULL,
  `Razao` varchar(50) NOT NULL,
  `Fantasia` varchar(40) NOT NULL,
  `Pessoa` varchar(8) NOT NULL,
  `NascimentoFundacao` date DEFAULT NULL,
  `CNPJ_CPF` varchar(18) NOT NULL,
  `IE_RG` varchar(20) NOT NULL,
  `IM` varchar(20) DEFAULT NULL,
  `TipoLogradouro` varchar(10) DEFAULT NULL,
  `Endereco` varchar(60) DEFAULT NULL,
  `Numero` varchar(6) NOT NULL,
  `Complemento` varchar(20) DEFAULT NULL,
  `Bairro` varchar(30) NOT NULL,
  `Cidade` varchar(50) NOT NULL,
  `IBGE` varchar(7) DEFAULT NULL,
  `Estado` varchar(2) NOT NULL,
  `CEP` varchar(9) NOT NULL,
  `Fone1_DDD` varchar(2) DEFAULT NULL,
  `Fone1_Numero` varchar(10) DEFAULT NULL,
  `Fone1_Contato` varchar(30) DEFAULT NULL,
  `Fone2_DDD` varchar(2) DEFAULT NULL,
  `Fone2_Numero` varchar(10) DEFAULT NULL,
  `Fone2_Contato` varchar(30) DEFAULT NULL,
  `HomePage` varchar(50) DEFAULT NULL,
  `eMail_Conta` varchar(50) DEFAULT NULL,
  `eMail2_NFe` varchar(80) DEFAULT NULL,
  `Observacoes` text,
  `RamoAtividade` int(11) NOT NULL,
  `Filial` int(11) NOT NULL,
  `Consultor` int(11) DEFAULT NULL,
  `Franqueado` int(11) DEFAULT NULL,
  `Conversao` double NOT NULL DEFAULT '0',
  `PercentualQtde` double NOT NULL DEFAULT '0',
  `Status` varchar(8) NOT NULL,
  `Cliente` varchar(1) NOT NULL COMMENT '0-nao, 1-sim',
  `Fornecedor` varchar(1) NOT NULL COMMENT '0-nao, 1-sim',
  `ConsumidorFinal` varchar(1) NOT NULL DEFAULT '0' COMMENT '0-nao, 1-Sim',
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  KEY `FK_responsaveis_ramo_atividades` (`RamoAtividade`),
  KEY `IDXCpf` (`CNPJ_CPF`),
  KEY `IDXRazao` (`Razao`),
  KEY `IDXFantasia` (`Fantasia`),
  KEY `FK_responsaveis_empresas` (`Filial`),
  KEY `FK_responsaveis_cidades` (`Cidade`),
  KEY `FK_responsaveis_consultores` (`Consultor`),
  KEY `FK_responsaveis_franqueados` (`Franqueado`),
  CONSTRAINT `FK_responsaveis_consultores` FOREIGN KEY (`Consultor`) REFERENCES `consultores` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_responsaveis_empresas` FOREIGN KEY (`Filial`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_responsaveis_franqueados` FOREIGN KEY (`Franqueado`) REFERENCES `franqueados` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_responsaveis_ramo_atividades` FOREIGN KEY (`RamoAtividade`) REFERENCES `ramo_atividades` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `responsaveis_after_insert` AFTER INSERT ON `responsaveis` FOR EACH ROW BEGIN
	REPLACE INTO responsaveis_api(	CodigoResponsavel,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												responsaveis	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `responsaveis_after_update` AFTER UPDATE ON `responsaveis` FOR EACH ROW BEGIN
	REPLACE INTO responsaveis_api(	CodigoResponsavel,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												responsaveis	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `responsaveis_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `responsaveis_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoResponsavel` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoResponsavel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `responsaveis_entrega`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `responsaveis_entrega` (
  `Responsavel` int(11) NOT NULL,
  `Utiliza` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-Não utiliza endereco 1- Utiliza',
  `CEP` varchar(9) NOT NULL DEFAULT '',
  `TipoLogradouro` varchar(10) DEFAULT '',
  `Endereco` varchar(60) DEFAULT '',
  `Numero` varchar(10) DEFAULT '',
  `Complemento` varchar(20) DEFAULT '',
  `Bairro` varchar(30) DEFAULT '',
  `Cidade` varchar(30) NOT NULL DEFAULT '',
  `Estado` varchar(2) NOT NULL,
  `IBGE` varchar(7) DEFAULT NULL,
  KEY `FK_responsaveis_entrega_responsaveis` (`Responsavel`),
  CONSTRAINT `FK_responsaveis_entrega_responsaveis` FOREIGN KEY (`Responsavel`) REFERENCES `responsaveis` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `responsaveis_entrega_after_insert` AFTER INSERT ON `responsaveis_entrega` FOR EACH ROW BEGIN
	REPLACE INTO responsaveis_entrega_api(	CodigoResponsavelEntrega,
											CodigoCD
										)
										(
											SELECT 
												t1.Responsavel,
												t2.Codigo			 
											FROM 
												responsaveis_entrega	t1,
												empresas_cd t2
												WHERE 
												t1.Responsavel = NEW.Responsavel
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `responsaveis_entrega_after_update` AFTER UPDATE ON `responsaveis_entrega` FOR EACH ROW BEGIN
	REPLACE INTO responsaveis_entrega_api(	CodigoResponsavelEntrega,
											CodigoCD
										)
										(
											SELECT 
												t1.Responsavel,
												t2.Codigo			 
											FROM 
												responsaveis_entrega	t1,
												empresas_cd t2
												WHERE 
												t1.Responsavel = NEW.Responsavel
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `responsaveis_entrega_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `responsaveis_entrega_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoResponsavelEntrega` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoResponsavelEntrega`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `responsaveis_tributos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `responsaveis_tributos` (
  `Responsavel` int(11) NOT NULL,
  `Suframa` varchar(10) NOT NULL DEFAULT '',
  `ICMS_Diferenciado` tinyint(1) NOT NULL DEFAULT '0',
  `ST_ICMS` varchar(3) DEFAULT '',
  `CFOP` varchar(4) NOT NULL DEFAULT '',
  `Texto_ICMS` text,
  `PISCOFINS_Diferenciado` tinyint(1) NOT NULL DEFAULT '0',
  `ST_PIS` varchar(2) DEFAULT '',
  `Aliquota_PIS` double NOT NULL DEFAULT '0',
  `ST_COFINS` varchar(2) DEFAULT '',
  `Aliquota_COFINS` double NOT NULL DEFAULT '0',
  `Texto_PISCOFINS` text,
  `IPI_Diferenciado` tinyint(1) NOT NULL DEFAULT '0',
  `Texto_IPI` text,
  PRIMARY KEY (`Responsavel`),
  CONSTRAINT `FK_responsaveis_tributos_responsaveis` FOREIGN KEY (`Responsavel`) REFERENCES `responsaveis` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `responsaveis_tributos_after_insert` AFTER INSERT ON `responsaveis_tributos` FOR EACH ROW BEGIN
	REPLACE INTO responsaveis_tributos_api(	CodigoResponsavelTributo,
											CodigoCD
										)
										(
											SELECT 
												t1.Responsavel,
												t2.Codigo			 
											FROM 
												responsaveis_tributos	t1,
												empresas_cd t2
												WHERE 
												t1.Responsavel = NEW.Responsavel
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `responsaveis_tributos_after_update` AFTER UPDATE ON `responsaveis_tributos` FOR EACH ROW BEGIN
	REPLACE INTO responsaveis_tributos_api(	CodigoResponsavelTributo,
											CodigoCD
										)
										(
											SELECT 
												t1.Responsavel,
												t2.Codigo			 
											FROM 
												responsaveis_tributos	t1,
												empresas_cd t2
												WHERE 
												t1.Responsavel = NEW.Responsavel
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `responsaveis_tributos_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `responsaveis_tributos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoResponsavelTributo` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoResponsavelTributo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `rmnUH`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `rmnUH` AS SELECT
 1 AS `Codigo`,
  1 AS `GTIN`,
  1 AS `Quantidade`,
  1 AS `ValorTotal`,
  1 AS `Data_Romaneio` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `romaneios_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `romaneios_api` (
  `CodigoCD` int(11) NOT NULL,
  `IDRomaneio` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`IDRomaneio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `romaneios_cab`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `romaneios_cab` (
  `CD` int(11) NOT NULL,
  `IDRomaneio` bigint(20) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `Romaneio` varchar(3) NOT NULL,
  `Movimento_Data` date NOT NULL,
  `Movimento_Hora` varchar(8) NOT NULL DEFAULT '00:00:00',
  `Movimento_Tipo` varchar(1) NOT NULL COMMENT 'S-Saída, E-Entrada',
  `Situacao` int(11) NOT NULL DEFAULT '0' COMMENT '0 - Em digitaçao(Bipagem), 10 - Provisório, 20 - Aguardando Fechamento, 30 - Liberado Faturamento, 99 - Consolidado',
  `Cliente` int(11) NOT NULL,
  `Franqueado` int(11) DEFAULT NULL,
  `NotaFiscal` int(11) NOT NULL DEFAULT '0',
  `Serie` varchar(3) NOT NULL DEFAULT '',
  `Separador` int(11) DEFAULT NULL,
  `ValorPedido` double(12,2) NOT NULL DEFAULT '0.00',
  `TotalQuantidade` double(13,3) NOT NULL DEFAULT '0.000',
  `TentativaLiberar` int(11) NOT NULL DEFAULT '0',
  `TotalItens` double(12,2) NOT NULL DEFAULT '0.00',
  `Consolidacao_Data` date DEFAULT NULL,
  `Consolidacao_Hora` time DEFAULT NULL,
  `ValorFracionado` double(12,2) NOT NULL DEFAULT '0.00',
  `ValorRestante` double(12,2) NOT NULL DEFAULT '0.00',
  `Pedido` bigint(20) NOT NULL DEFAULT '0',
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Observacoes` varchar(500) DEFAULT NULL,
  `IdProvisorio` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`CD`,`IDRomaneio`) USING BTREE,
  UNIQUE KEY `IDXCdIDEmpresa` (`CD`,`IDRomaneio`,`Empresa`) USING BTREE,
  KEY `FK_romaneios_cab_responsaveis` (`Cliente`),
  KEY `FK_romaneios_cab_responsaveis_2` (`Separador`),
  KEY `IDXMovDataCliente` (`Movimento_Data`,`Cliente`),
  KEY `IDXConsolidacaoCliente` (`Cliente`),
  KEY `FK_romaneios_cab_franqueados` (`Franqueado`),
  KEY `IDXCDClienteMovDataRomaneio` (`CD`,`Cliente`,`Movimento_Data`,`Romaneio`,`Empresa`) USING BTREE,
  KEY `FK_romaneios_cab_provisorios` (`IdProvisorio`),
  CONSTRAINT `FK_romaneios_cab_franqueados` FOREIGN KEY (`Franqueado`) REFERENCES `franqueados` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_romaneios_cab_provisorios` FOREIGN KEY (`IdProvisorio`) REFERENCES `provisorios` (`Id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_romaneios_cab_responsaveis` FOREIGN KEY (`Cliente`) REFERENCES `responsaveis` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_romaneios_cab_responsaveis_2` FOREIGN KEY (`Separador`) REFERENCES `responsaveis` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `romaneios_cab_before_update` BEFORE UPDATE ON `romaneios_cab` FOR EACH ROW BEGIN
	IF NEW.Situacao = 0 THEN
		REPLACE INTO romaneios_api	(CodigoCD, IDRomaneio)	VALUES (NEW.CD, NEW.IDRomaneio);
	END IF;
	

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `romaneios_cab_after_update` AFTER UPDATE ON `romaneios_cab` FOR EACH ROW BEGIN
 	CALL sp_provisorios_atualizar_totais(OLD.IdProvisorio);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `romaneios_cab_online`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `romaneios_cab_online` (
  `CD` int(11) NOT NULL,
  `IDRomaneio` bigint(20) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `Romaneio` varchar(3) NOT NULL,
  `Movimento_Data` date NOT NULL,
  `Movimento_Hora` varchar(8) NOT NULL DEFAULT '00:00:00',
  `Movimento_Tipo` varchar(1) NOT NULL COMMENT 'S-Saída, E-Entrada',
  `Situacao` int(11) NOT NULL DEFAULT '0' COMMENT '0 - Em digitaçao(Bipagem), 10 - Provisório, 20 - Aguardando Fechamento, 30 - Liberado Faturamento, 99 - Consolidado',
  `Cliente` int(11) NOT NULL,
  `Franqueado` int(11) DEFAULT NULL,
  `NotaFiscal` int(11) NOT NULL DEFAULT '0',
  `Serie` varchar(3) NOT NULL DEFAULT '',
  `TabelaDePreco` int(11) NOT NULL DEFAULT '0',
  `Separador` int(11) DEFAULT NULL,
  `ValorPedido` double(12,2) NOT NULL DEFAULT '0.00',
  `TotalQuantidade` double(13,3) NOT NULL DEFAULT '0.000',
  `TentativaLiberar` int(11) NOT NULL DEFAULT '0',
  `TotalItens` double(12,2) NOT NULL DEFAULT '0.00',
  `ValorFracionado` double(12,2) NOT NULL DEFAULT '0.00',
  `ValorRestante` double(12,2) NOT NULL DEFAULT '0.00',
  `Pedido` bigint(20) NOT NULL DEFAULT '0',
  `Observacoes` varchar(30) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `TipoCliente` varchar(1) NOT NULL DEFAULT 'C' COMMENT 'C - Cliente ; F - Funcionario',
  PRIMARY KEY (`CD`,`IDRomaneio`) USING BTREE,
  UNIQUE KEY `IDXCdIDEmpresa` (`CD`,`IDRomaneio`,`Empresa`) USING BTREE,
  KEY `FK_romaneios_cab_romaneios_tabela_preco` (`TabelaDePreco`) USING BTREE,
  KEY `FK_romaneios_cab_responsaveis` (`Cliente`) USING BTREE,
  KEY `FK_romaneios_cab_responsaveis_2` (`Separador`) USING BTREE,
  KEY `IDXMovDataCliente` (`Movimento_Data`,`Cliente`) USING BTREE,
  KEY `IDXConsolidacaoCliente` (`Cliente`) USING BTREE,
  KEY `FK_romaneios_cab_franqueados` (`Franqueado`) USING BTREE,
  KEY `IDXCDClienteMovDataRomaneio` (`CD`,`Cliente`,`Movimento_Data`,`Romaneio`,`Empresa`) USING BTREE,
  CONSTRAINT `romaneios_cab_online_ibfk_1` FOREIGN KEY (`Franqueado`) REFERENCES `franqueados` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `romaneios_cab_online_ibfk_2` FOREIGN KEY (`Cliente`) REFERENCES `responsaveis` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `romaneios_cab_online_ibfk_3` FOREIGN KEY (`Separador`) REFERENCES `responsaveis` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `romaneios_cab_online_ibfk_4` FOREIGN KEY (`TabelaDePreco`) REFERENCES `romaneios_tabela_preco` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `romaneios_contador`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `romaneios_contador` (
  `Cliente` int(11) NOT NULL,
  `Contador` varchar(3) NOT NULL,
  PRIMARY KEY (`Cliente`),
  CONSTRAINT `FK_romaneios_contador_responsaveis` FOREIGN KEY (`Cliente`) REFERENCES `responsaveis` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `romaneios_ite`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `romaneios_ite` (
  `CD` int(11) NOT NULL,
  `IDRomaneio` bigint(20) NOT NULL,
  `Referencia` varchar(15) NOT NULL,
  `Produto` varchar(8) NOT NULL,
  `Sequencia` int(11) NOT NULL,
  `Quantidade` double(13,3) NOT NULL DEFAULT '0.000',
  `ValorUnitario` double(12,2) NOT NULL DEFAULT '0.00',
  `ValorTotal` double(12,2) NOT NULL DEFAULT '0.00',
  `CustoMedio` double(12,2) DEFAULT '0.00',
  `CustoUltimo` double(12,2) DEFAULT '0.00',
  `PrecoCheio` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'Preco Cheio S/N',
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  PRIMARY KEY (`CD`,`IDRomaneio`,`Referencia`) USING BTREE,
  KEY `FK_romaneios_ite_produtos` (`IDRomaneio`,`Produto`) USING BTREE,
  KEY `FK_ProdutosReferencia` (`Referencia`) USING BTREE,
  KEY `FK_ItensProdutos` (`Produto`),
  CONSTRAINT `FK_ItensProdutos` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_romaneios_ite_romaneios_cab` FOREIGN KEY (`CD`, `IDRomaneio`) REFERENCES `romaneios_cab` (`CD`, `IDRomaneio`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `romaneios_ite_after_insert` AFTER INSERT ON `romaneios_ite` FOR EACH ROW BEGIN
	UPDATE 
		romaneios_cab cab 
	SET
		cab.TotalQuantidade = cab.TotalQuantidade + NEW.Quantidade,
		cab.TotalItens = cab.TotalItens + 1,
		cab.ValorPedido = cab.ValorPedido + NEW.ValorTotal
	WHERE
	   cab.CD = NEW.CD
	AND
	   cab.IDRomaneio = NEW.IDRomaneio;		
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `romaneios_ite_after_update` AFTER UPDATE ON `romaneios_ite` FOR EACH ROW BEGIN

	UPDATE 
		romaneios_cab cab 
	SET
		cab.TotalQuantidade = cab.TotalQuantidade - OLD.Quantidade,
		cab.ValorPedido = cab.ValorPedido - OLD.ValorTotal
	WHERE
	   cab.CD = OLD.CD
	AND
	   cab.IDRomaneio = OLD.IDRomaneio;	
	   
	UPDATE 
		romaneios_cab cab 
	SET
		cab.TotalQuantidade = cab.TotalQuantidade + NEW.Quantidade,
		cab.ValorPedido = cab.ValorPedido + NEW.ValorTotal
	WHERE
	   cab.CD = NEW.CD
	AND
	   cab.IDRomaneio = NEW.IDRomaneio;	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `romaneios_ite_after_delete` AFTER DELETE ON `romaneios_ite` FOR EACH ROW BEGIN
	UPDATE 
		romaneios_cab cab 
	SET
		cab.TotalQuantidade = cab.TotalQuantidade - OLD.Quantidade,
		cab.ValorPedido = cab.ValorPedido - OLD.ValorTotal,
		cab.TotalItens = cab.TotalItens - 1
	WHERE
	   cab.CD = OLD.CD
	AND
	   cab.IDRomaneio = OLD.IDRomaneio;	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `romaneios_ite_online`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `romaneios_ite_online` (
  `CD` int(11) NOT NULL,
  `IDRomaneio` bigint(20) NOT NULL,
  `Referencia` varchar(15) NOT NULL,
  `Produto` varchar(8) NOT NULL,
  `Sequencia` int(11) NOT NULL,
  `Quantidade` double(13,3) NOT NULL DEFAULT '0.000',
  `ValorUnitario` double(12,2) NOT NULL DEFAULT '0.00',
  `ValorTotal` double(12,2) NOT NULL DEFAULT '0.00',
  `CustoMedio` double(12,2) DEFAULT '0.00',
  `CustoUltimo` double(12,2) DEFAULT '0.00',
  `PrecoCheio` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'Preco Cheio S/N',
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  PRIMARY KEY (`CD`,`IDRomaneio`,`Referencia`) USING BTREE,
  KEY `FK_romaneios_ite_produtos` (`IDRomaneio`,`Produto`) USING BTREE,
  KEY `FK_ProdutosReferencia` (`Referencia`) USING BTREE,
  KEY `FK_ItensProdutos` (`Produto`) USING BTREE,
  CONSTRAINT `romaneios_ite_online_ibfk_1` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `romaneios_ite_online_ibfk_2` FOREIGN KEY (`CD`, `IDRomaneio`) REFERENCES `romaneios_cab` (`CD`, `IDRomaneio`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seg_aplicacoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seg_aplicacoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `rota` varchar(255) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `ordem` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDXMenuOrdem` (`menu_id`,`ordem`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seg_menu`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seg_menu` (
  `id` int(11) NOT NULL,
  `menu` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seg_perfil`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seg_perfil` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seg_perfil_permissoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seg_usuarios`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seg_usuarios_permissoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `segapps`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `segapps` (
  `Nivel` int(11) NOT NULL,
  `Ordem` int(11) NOT NULL,
  `app_name` varchar(128) NOT NULL,
  `app_type` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`app_name`),
  KEY `IDXNivelOrdem` (`Nivel`,`Ordem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seggroups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seggroups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seggroups_apps`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seggroups_apps` (
  `group_id` int(11) NOT NULL,
  `Nivel` int(11) NOT NULL,
  `Ordem` int(11) NOT NULL,
  `app_name` varchar(128) NOT NULL,
  `priv_access` varchar(1) DEFAULT NULL,
  `priv_insert` varchar(1) DEFAULT NULL,
  `priv_delete` varchar(1) DEFAULT NULL,
  `priv_update` varchar(1) DEFAULT NULL,
  `priv_export` varchar(1) DEFAULT NULL,
  `priv_print` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`group_id`,`app_name`),
  KEY `seggroups_apps_ibfk_2` (`app_name`),
  KEY `IDXGrupoNivelOrdemApp` (`group_id`,`Nivel`,`Ordem`,`app_name`),
  CONSTRAINT `seggroups_apps_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `seggroups` (`group_id`) ON DELETE CASCADE,
  CONSTRAINT `seggroups_apps_ibfk_2` FOREIGN KEY (`app_name`) REFERENCES `segapps` (`app_name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seggroups_apps_copy`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seggroups_apps_copy` (
  `group_id` int(11) NOT NULL,
  `Nivel` int(11) NOT NULL,
  `Ordem` int(11) NOT NULL,
  `app_name` varchar(128) NOT NULL,
  `priv_access` varchar(1) DEFAULT NULL,
  `priv_insert` varchar(1) DEFAULT NULL,
  `priv_delete` varchar(1) DEFAULT NULL,
  `priv_update` varchar(1) DEFAULT NULL,
  `priv_export` varchar(1) DEFAULT NULL,
  `priv_print` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`group_id`,`app_name`) USING BTREE,
  KEY `seggroups_apps_ibfk_2` (`app_name`) USING BTREE,
  KEY `IDXGrupoNivelOrdemApp` (`group_id`,`Nivel`,`Ordem`,`app_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `segnivel_menu`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `segnivel_menu` (
  `Nivel` int(11) NOT NULL,
  `Descricao` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`Nivel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `segsettings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `segsettings` (
  `set_name` varchar(255) NOT NULL,
  `set_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_aplicacoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_aplicacoes` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Grupo` int(11) NOT NULL DEFAULT '0',
  `Ordem` int(11) NOT NULL DEFAULT '0',
  `Descricao` varchar(120) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `NomeAplicacao` varchar(120) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXAplicacao` (`NomeAplicacao`) USING BTREE,
  KEY `IDXGrupoOrdem` (`Grupo`,`Ordem`) USING BTREE,
  CONSTRAINT `FK_seguranca_aplicacoes_seguranca_grupo_menu` FOREIGN KEY (`Grupo`) REFERENCES `seguranca_grupo_menu` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_apps`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_apps` (
  `Nivel` int(11) DEFAULT NULL,
  `Ordem` int(11) DEFAULT NULL,
  `app_name` varchar(128) NOT NULL,
  `app_type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`app_name`),
  KEY `IDXNivelOrdem` (`Nivel`,`Ordem`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_grupo_menu`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_grupo_menu` (
  `Codigo` int(11) NOT NULL,
  `Grupo` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXGrupo` (`Grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_logged`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_logged` (
  `login` varchar(255) NOT NULL,
  `date_login` varchar(128) DEFAULT NULL,
  `sc_session` varchar(32) DEFAULT NULL,
  `ip` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_logs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_logs` (
  `Codigo` int(8) NOT NULL AUTO_INCREMENT,
  `DataHora` datetime DEFAULT NULL,
  `Usuario` varchar(90) NOT NULL,
  `Aplicacao` varchar(255) NOT NULL,
  `Acao` varchar(30) NOT NULL,
  `Descricao` text,
  PRIMARY KEY (`Codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=255 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_menu`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_menu` (
  `Grupo` int(11) NOT NULL DEFAULT '0',
  `Ordem` int(11) NOT NULL DEFAULT '0',
  `Descricao` varchar(120) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `Aplicacao` varchar(120) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  KEY `IDXGrupo` (`Grupo`),
  CONSTRAINT `FK_seguranca_menu_seguranca_grupo_menu` FOREIGN KEY (`Grupo`) REFERENCES `seguranca_grupo_menu` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_parametros`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_parametros` (
  `Tipo` varchar(1) NOT NULL COMMENT 'U-usuario  / S - sistema',
  `Parametro` varchar(15) NOT NULL DEFAULT 'U' COMMENT 'Combinação Tipo+''PRM''+Aplicacao com zeros a esquerda',
  `Sequencia` int(11) NOT NULL DEFAULT '0',
  `NomeAplicacao` varchar(120) NOT NULL DEFAULT '',
  `Grupo` int(11) NOT NULL DEFAULT '0',
  `Descricao` varchar(120) NOT NULL,
  PRIMARY KEY (`Parametro`),
  KEY `IDXNomeAplicacao` (`NomeAplicacao`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_parametros_sistema`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_parametros_sistema` (
  `Empresa` int(11) NOT NULL DEFAULT '0',
  `Parametro` varchar(10) COLLATE latin1_general_ci NOT NULL COMMENT 'Combinação Tipo+''PRM''+Aplicacao com zeros a esquerda',
  PRIMARY KEY (`Parametro`,`Empresa`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_parametros_usuario`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_parametros_usuario` (
  `Usuario` int(11) NOT NULL,
  `Parametro` varchar(10) COLLATE latin1_general_ci NOT NULL COMMENT 'Combinação Tipo+''PRM''+Aplicacao com zeros a esquerda',
  PRIMARY KEY (`Usuario`,`Parametro`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_parametros_valores`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_parametros_valores` (
  `Empresa` int(11) NOT NULL DEFAULT '0',
  `Parametro` varchar(10) COLLATE latin1_general_ci NOT NULL COMMENT 'Combinação Tipo+''PRM''+Aplicacao com zeros a esquerda',
  PRIMARY KEY (`Empresa`,`Parametro`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_settings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_settings` (
  `set_name` varchar(255) NOT NULL,
  `set_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_users`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_users` (
  `login` varchar(255) NOT NULL,
  `pswd` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `active` varchar(1) DEFAULT NULL,
  `activation_code` varchar(32) DEFAULT NULL,
  `priv_admin` varchar(1) DEFAULT NULL,
  `mfa` varchar(255) DEFAULT NULL,
  `picture` longblob,
  `role` int(11) DEFAULT NULL,
  `phone` varchar(64) DEFAULT NULL,
  `pswd_last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mfa_last_updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`login`),
  KEY `FK_seguranca_users_cargos` (`role`),
  CONSTRAINT `FK_seguranca_users_cargos` FOREIGN KEY (`role`) REFERENCES `cargos` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_users_apps`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_users_apps` (
  `Nivel` int(11) DEFAULT NULL,
  `Ordem` int(11) DEFAULT NULL,
  `login` varchar(255) NOT NULL,
  `app_name` varchar(128) NOT NULL,
  `priv_access` varchar(1) DEFAULT NULL,
  `priv_insert` varchar(1) DEFAULT NULL,
  `priv_delete` varchar(1) DEFAULT NULL,
  `priv_update` varchar(1) DEFAULT NULL,
  `priv_export` varchar(1) DEFAULT NULL,
  `priv_print` varchar(1) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT '',
  PRIMARY KEY (`login`,`app_name`),
  KEY `seguranca_users_apps_ibfk_2` (`app_name`),
  KEY `IDXNivelOrdem` (`Nivel`,`Ordem`) USING BTREE,
  CONSTRAINT `seguranca_users_apps_ibfk_1` FOREIGN KEY (`login`) REFERENCES `seguranca_users` (`login`) ON DELETE CASCADE,
  CONSTRAINT `seguranca_users_apps_ibfk_2` FOREIGN KEY (`app_name`) REFERENCES `seguranca_apps` (`app_name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_usuarios`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_usuarios` (
  `Codigo` int(11) NOT NULL DEFAULT '0',
  `AcessoUsuario` varchar(30) NOT NULL,
  `AcessoSenha` varchar(15) NOT NULL,
  `AcessoStatus` varchar(8) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXAcessoUsuario` (`AcessoUsuario`),
  KEY `FK_tbparametrizacaologin_2` (`Empresa`) USING BTREE,
  CONSTRAINT `FK_seguranca_usuarios_empresas` FOREIGN KEY (`Empresa`) REFERENCES `empresas` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_usuarios_aplicacoes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_usuarios_aplicacoes` (
  `Usuario` int(11) NOT NULL,
  `Aplicacao` int(11) NOT NULL,
  `Visualizar` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-Falso/1-true',
  `Incluir` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-Falso/1-true',
  `Editar` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-Falso/1-true',
  `Excluir` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-Falso/1-true',
  `Imprimir` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-Falso/1-true',
  `Liberar` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-Falso/1-true',
  `Consolidar` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-Falso/1-true',
  UNIQUE KEY `IDXUsuarioAplicacao` (`Usuario`,`Aplicacao`) USING BTREE,
  KEY `FK_seguranca_usuarios_aplicacoes_seguranca_aplicacoes` (`Aplicacao`),
  CONSTRAINT `FK_seguranca_usuarios_aplicacoes_seguranca_aplicacoes` FOREIGN KEY (`Aplicacao`) REFERENCES `seguranca_aplicacoes` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_seguranca_usuarios_aplicacoes_seguranca_usuarios` FOREIGN KEY (`Usuario`) REFERENCES `seguranca_usuarios` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seguranca_usuarios_empresas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `seguranca_usuarios_empresas` (
  `Usuario` int(11) NOT NULL,
  `Empresa` int(11) NOT NULL,
  PRIMARY KEY (`Usuario`,`Empresa`),
  KEY `FK_seguranca_usuarios_empresas_empresas` (`Empresa`),
  CONSTRAINT `FK_seguranca_usuarios_empresas_empresas` FOREIGN KEY (`Empresa`) REFERENCES `empresas` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_seguranca_usuarios_empresas_seguranca_usuarios` FOREIGN KEY (`Usuario`) REFERENCES `seguranca_usuarios` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `segusers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `segusers` (
  `login` varchar(60) NOT NULL,
  `pswd` varchar(40) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `active` varchar(1) DEFAULT NULL,
  `activation_code` varchar(32) DEFAULT NULL,
  `priv_admin` varchar(1) DEFAULT NULL,
  `mfa` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `segusers_empresa`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `segusers_empresa` (
  `login` varchar(60) NOT NULL,
  `Empresa` int(11) NOT NULL,
  PRIMARY KEY (`login`,`Empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `segusers_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `segusers_groups` (
  `login` varchar(60) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`login`,`group_id`),
  KEY `segusers_groups_ibfk_2` (`group_id`),
  CONSTRAINT `FK_segusers_groups_segusers` FOREIGN KEY (`login`) REFERENCES `segusers` (`login`),
  CONSTRAINT `segusers_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `seggroups` (`group_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `segusers_pre_cadastro_sts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `segusers_pre_cadastro_sts` (
  `Login` varchar(60) NOT NULL,
  `Situacao` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`Login`) USING BTREE,
  CONSTRAINT `FK_segusers_pre_cadastro_sts_segusers` FOREIGN KEY (`Login`) REFERENCES `segusers` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Pre-Cadastro Situacao - Relacionamento de usuarios e situacao de pre cadastro\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `situacao`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `situacao` (
  `StsNome` varchar(8) NOT NULL,
  PRIMARY KEY (`StsNome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `st_cofins`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_cofins` (
  `Codigo` varchar(2) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Operacao` varchar(1) NOT NULL DEFAULT '' COMMENT 'E/S',
  `IncideImposto` varchar(1) NOT NULL DEFAULT '' COMMENT 'S/N',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_cofins_after_insert` AFTER INSERT ON `st_cofins` FOR EACH ROW BEGIN
	REPLACE INTO st_cofins_api(	CodigoCofins,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_cofins	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_cofins_after_update` AFTER UPDATE ON `st_cofins` FOR EACH ROW BEGIN
	REPLACE INTO st_cofins_api(	CodigoCofins,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_cofins	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `st_cofins_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_cofins_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoCofins` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoCofins`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `st_icms`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_icms` (
  `Codigo` varchar(3) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `SimplesNacional` varchar(1) NOT NULL DEFAULT 'N',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_icms_after_insert` AFTER INSERT ON `st_icms` FOR EACH ROW BEGIN
	REPLACE INTO st_icms_api(	CodigoIcms,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_icms	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_icms_after_update` AFTER UPDATE ON `st_icms` FOR EACH ROW BEGIN
	REPLACE INTO st_icms_api(	CodigoIcms,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_icms	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `st_icms_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_icms_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoIcms` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoIcms`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `st_ipi`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_ipi` (
  `Codigo` varchar(2) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Operacao` varchar(1) NOT NULL DEFAULT '' COMMENT 'E/S',
  `IncideImposto` varchar(1) NOT NULL DEFAULT '' COMMENT 'S/N',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_ipi_after_insert` AFTER INSERT ON `st_ipi` FOR EACH ROW BEGIN
	REPLACE INTO st_ipi_api(	CodigoIpi,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_ipi	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_ipi_after_update` AFTER UPDATE ON `st_ipi` FOR EACH ROW BEGIN
	REPLACE INTO st_ipi_api(	CodigoIpi,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_ipi	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `st_ipi_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_ipi_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoIpi` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoIpi`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `st_origem`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_origem` (
  `Codigo` varchar(1) NOT NULL,
  `Descricao` varchar(200) NOT NULL,
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_origem_after_insert` AFTER INSERT ON `st_origem` FOR EACH ROW BEGIN
	REPLACE INTO st_origem_api(	CodigoOrigem,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_origem	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_origem_after_update` AFTER UPDATE ON `st_origem` FOR EACH ROW BEGIN
	REPLACE INTO st_origem_api(	CodigoOrigem,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_origem	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `st_origem_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_origem_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoOrigem` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoOrigem`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `st_pis`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_pis` (
  `Codigo` varchar(2) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Operacao` varchar(1) NOT NULL DEFAULT '' COMMENT 'E/S',
  `IncideImposto` varchar(1) NOT NULL DEFAULT '' COMMENT 'S/N',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_pis_after_insert` AFTER INSERT ON `st_pis` FOR EACH ROW BEGIN
	REPLACE INTO st_pis_api(	CodigoPis,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_pis	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `st_pis_after_update` AFTER UPDATE ON `st_pis` FOR EACH ROW BEGIN
	REPLACE INTO st_pis_api(	CodigoPis,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												st_pis	t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `st_pis_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `st_pis_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoPis` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoPis`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbcest`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tbcest` (
  `cest` varchar(7) NOT NULL,
  `ncm` varchar(8) NOT NULL,
  `descricao` varchar(520) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbcidades`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tbcidades` (
  `Codigo` varchar(5) NOT NULL,
  `Cidade` varchar(30) NOT NULL,
  `IBGE` varchar(7) DEFAULT NULL,
  `SIAFI` varchar(6) DEFAULT NULL,
  `Estado` varchar(2) NOT NULL,
  `TaxaEntrega` double(12,2) NOT NULL DEFAULT '0.00',
  `CampoPesquisa` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `Index_2` (`CampoPesquisa`),
  UNIQUE KEY `Index_4` (`Cidade`,`Estado`),
  KEY `FK_tbCidades_1` (`Estado`),
  CONSTRAINT `FK_tbCidades_1` FOREIGN KEY (`Estado`) REFERENCES `tbestados` (`Sigla`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbfranqueados`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tbfranqueados` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `LimiteCredito_Verde` double(12,2) NOT NULL DEFAULT '0.00',
  `LimiteCredito_Amarelo` double(12,2) NOT NULL DEFAULT '0.00',
  `LimiteCredito_Vermelho` double(12,2) NOT NULL DEFAULT '0.00',
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbprodutos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tbprodutos` (
  `Codigo` varchar(8) NOT NULL,
  `Distribuidora` varchar(15) DEFAULT NULL,
  `GTIN` varchar(14) NOT NULL,
  `Marca` varchar(40) NOT NULL,
  `Modelo` varchar(40) NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `SubGrupo` varchar(40) NOT NULL,
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Tributacao` varchar(12) NOT NULL,
  `ClassificacaoFiscal` varchar(8) DEFAULT NULL,
  `SituacaoTributaria` varchar(4) DEFAULT NULL,
  `AliquotaICMS` double(5,2) DEFAULT '0.00',
  `ReducaoICMS` double(5,2) DEFAULT '0.00',
  `CST_PIS` varchar(2) DEFAULT NULL,
  `AliquotaPIS` double(5,2) DEFAULT '0.00',
  `CST_COFINS` varchar(2) DEFAULT NULL,
  `AliquotaCOFINS` double(5,2) DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) DEFAULT '0.00',
  `CFOP_1` varchar(4) DEFAULT NULL,
  `Peso` double(13,3) DEFAULT '0.000',
  `EstoqueTotal` double(13,3) DEFAULT '0.000',
  `EstoqueReservado` double(13,3) DEFAULT '0.000',
  `EstoqueDisponivel` double(13,3) DEFAULT '0.000',
  `EstoqueMinimo` double(13,3) DEFAULT '0.000',
  `EstoqueMaximo` double(13,3) DEFAULT '0.000',
  `EstoqueContabil` double(13,3) NOT NULL,
  `FatorConversao` double(13,3) DEFAULT '0.000',
  `UltimaCompraData` date DEFAULT NULL,
  `UltimaCompraValor` double(12,2) DEFAULT '0.00',
  `CustoMedioData` date DEFAULT NULL,
  `CustoMedioValor` double(12,2) DEFAULT '0.00',
  `UltimaVendaData` date DEFAULT NULL,
  `UltimaVendaValor` double(12,2) DEFAULT '0.00',
  `PrecoVendaTabela` double(12,2) DEFAULT '0.00',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00',
  `PrecoCompra` double(12,2) DEFAULT '0.00',
  `SetorLaranja` varchar(1) DEFAULT NULL,
  `PrecoCheio` varchar(1) DEFAULT NULL,
  `Flag_NovoCadastro` varchar(1) NOT NULL,
  `LocalFisico` varchar(10) DEFAULT NULL,
  `Observacoes` text,
  `CampoPesquisa` varchar(250) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `Index_1` (`CampoPesquisa`),
  KEY `FK_tbProdutos_1` (`Marca`),
  KEY `FK_tbProdutos_2` (`Modelo`),
  KEY `FK_tbProdutos_3` (`Grupo`,`SubGrupo`),
  KEY `FK_tbProdutos_4` (`Unidade`),
  KEY `Index_7` (`Distribuidora`),
  KEY `Index_8` (`GTIN`) USING BTREE,
  CONSTRAINT `FK_tbProdutos_1` FOREIGN KEY (`Marca`) REFERENCES `tbmarcas` (`Marca`) ON UPDATE CASCADE,
  CONSTRAINT `FK_tbProdutos_2` FOREIGN KEY (`Modelo`) REFERENCES `tbmodelos` (`Modelo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_tbProdutos_3` FOREIGN KEY (`Grupo`, `SubGrupo`) REFERENCES `tbgrupos` (`Grupo`, `SubGrupo`) ON UPDATE CASCADE,
  CONSTRAINT `FK_tbProdutos_4` FOREIGN KEY (`Unidade`) REFERENCES `tbmedidas` (`Sigla`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbprodutosbarras`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tbprodutosbarras` (
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`),
  CONSTRAINT `FK_tbProdutosBarras_1` FOREIGN KEY (`Codigo`) REFERENCES `tbprodutos` (`Codigo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbramoatividade`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tbramoatividade` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `RamoAtividade` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbresponsaveis`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tbresponsaveis` (
  `Codigo` int(11) NOT NULL DEFAULT '0',
  `Razao` varchar(50) NOT NULL,
  `Fantasia` varchar(40) NOT NULL,
  `Pessoa` varchar(8) NOT NULL,
  `NascimentoFundacao` date NOT NULL,
  `CNPJ_CPF` varchar(18) NOT NULL,
  `IE_RG` varchar(20) NOT NULL,
  `IM` varchar(20) DEFAULT NULL,
  `TipoLogradouro` varchar(10) DEFAULT NULL,
  `Endereco` varchar(40) NOT NULL,
  `Numero` varchar(6) NOT NULL,
  `Complemento` varchar(20) DEFAULT NULL,
  `TipoBairro` varchar(15) DEFAULT NULL,
  `Bairro` varchar(30) NOT NULL,
  `Cidade` varchar(5) NOT NULL,
  `Estado` varchar(2) NOT NULL,
  `CEP` varchar(9) NOT NULL,
  `Fone1_DDD` varchar(2) DEFAULT NULL,
  `Fone1_Numero` varchar(10) DEFAULT NULL,
  `Fone1_Contato` varchar(30) DEFAULT NULL,
  `Fone2_DDD` varchar(2) DEFAULT NULL,
  `Fone2_Numero` varchar(10) DEFAULT NULL,
  `Fone2_Contato` varchar(30) DEFAULT NULL,
  `Fone3_DDD` varchar(2) DEFAULT NULL,
  `Fone3_Numero` varchar(10) DEFAULT NULL,
  `Fone3_Contato` varchar(30) DEFAULT NULL,
  `Fax_DDD` varchar(2) DEFAULT NULL,
  `Fax_Numero` varchar(10) DEFAULT NULL,
  `Fax_Contato` varchar(30) DEFAULT NULL,
  `HomePage` varchar(50) DEFAULT NULL,
  `eMail1_Conta` varchar(50) DEFAULT NULL,
  `eMail1_Contato` varchar(30) DEFAULT NULL,
  `eMail2_Conta` varchar(50) DEFAULT NULL,
  `eMail2_Contato` varchar(30) DEFAULT NULL,
  `eMail3_Conta` varchar(50) DEFAULT NULL,
  `eMail3_Contato` varchar(30) DEFAULT NULL,
  `Observacoes` text,
  `RamoAtividade` varchar(50) NOT NULL,
  `Filial` varchar(4) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Cliente` varchar(1) NOT NULL,
  `Fornecedor` varchar(1) NOT NULL,
  `Funcionario` varchar(1) NOT NULL,
  `Funcao` varchar(50) DEFAULT NULL,
  `CampoPesquisa` varchar(130) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `Index_6` (`CampoPesquisa`),
  KEY `FK_tbresponsaveis_1` (`Cidade`) USING BTREE,
  KEY `FK_tbresponsaveis_3` (`RamoAtividade`) USING BTREE,
  KEY `FK_tbresponsaveis_4` (`Filial`) USING BTREE,
  KEY `FK_tbresponsaveis_2` (`Estado`) USING BTREE,
  KEY `FK_tbresponsaveis_5` (`Funcao`),
  KEY `IDX_ClienteStatus` (`Cliente`,`Status`),
  KEY `IDXStatusCampoPesquisa` (`Status`,`CampoPesquisa`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbresponsaveisadicionais`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tbresponsaveisadicionais` (
  `Responsavel` int(11) NOT NULL DEFAULT '0',
  `Bloqueio_Venda` varchar(1) NOT NULL,
  `Bloqueio_Motivo` varchar(50) DEFAULT NULL,
  `Bloqueio_Tela` varchar(1) NOT NULL,
  `Bloqueio_Pedido` varchar(1) NOT NULL,
  `Restricao_Venda` varchar(1) NOT NULL,
  `Restricao_Orgao` varchar(50) DEFAULT NULL,
  `Restricao_Tela` varchar(1) NOT NULL,
  `Restricao_Pedido` varchar(1) NOT NULL,
  `Observacao_Venda` varchar(200) DEFAULT NULL,
  `Observacao_Tela` varchar(1) NOT NULL,
  `Observacao_Pedido` varchar(1) NOT NULL,
  `Consumidor_Final` varchar(1) NOT NULL DEFAULT 'S',
  `Distribuidora` varchar(10) DEFAULT NULL,
  `Regiao_Padrao` varchar(30) DEFAULT NULL,
  `Regiao_Tela` varchar(1) NOT NULL,
  `Regiao_Pedido` varchar(1) NOT NULL,
  `Vendedor_Padrao` varchar(8) DEFAULT NULL,
  `Vendedor_Tela` varchar(1) NOT NULL,
  `Vendedor_Pedido` varchar(1) NOT NULL,
  `Vendedor_Alterar` varchar(1) NOT NULL,
  `TabelaPreco_Padrao` varchar(120) DEFAULT NULL,
  `TabelaPreco_Alterar` varchar(1) NOT NULL,
  `TabelaPreco_Produtos` double(12,2) NOT NULL DEFAULT '0.00',
  `TabelaPreco_Servicos` double(12,2) NOT NULL DEFAULT '0.00',
  `TabelaPreco_Consumos` double(12,2) NOT NULL DEFAULT '0.00',
  `Forma_Padrao` varchar(2) DEFAULT NULL,
  `Forma_Alterar` varchar(1) NOT NULL,
  `Condicao_Padrao` varchar(3) DEFAULT NULL,
  `Condicao_Alterar` varchar(1) NOT NULL,
  `Conheceu` varchar(50) NOT NULL,
  `Fotografo` varchar(50) NOT NULL,
  `Cerimonialista` varchar(50) NOT NULL,
  `InfoBanco_Favorecido` varchar(50) DEFAULT NULL,
  `InfoBanco_Banco` varchar(50) DEFAULT NULL,
  `InfoBanco_Agencia` varchar(4) DEFAULT NULL,
  `InfoBanco_Conta` varchar(13) DEFAULT NULL,
  `LimiteCredito_Valor` double(12,2) NOT NULL DEFAULT '0.00',
  `LimiteCredito_Tela` varchar(1) NOT NULL,
  `LimiteCredito_Pedido` varchar(1) NOT NULL,
  `LimiteCredito_Habilitado` varchar(1) NOT NULL,
  `EnderecoEntrega` varchar(1) NOT NULL,
  `E_CEP` varchar(9) DEFAULT NULL,
  `E_Endereco` varchar(40) DEFAULT NULL,
  `E_Numero` varchar(6) DEFAULT NULL,
  `E_Complemento` varchar(20) DEFAULT NULL,
  `E_Bairro` varchar(30) DEFAULT NULL,
  `E_Cidade` varchar(5) DEFAULT NULL,
  `E_Estado` varchar(2) DEFAULT NULL,
  `E_Fone_DDD` varchar(2) DEFAULT NULL,
  `E_Fone_Numero` varchar(10) DEFAULT NULL,
  `E_Fone_Contato` varchar(30) DEFAULT NULL,
  `DIF_ICMS` varchar(1) NOT NULL,
  `DIF_ICMS_Texto` text NOT NULL,
  `DIF_ICMS_CST` varchar(4) NOT NULL,
  `DIF_IPI` varchar(1) NOT NULL,
  `DIF_IPI_Texto` text NOT NULL,
  `DIF_PIS_COFINS` varchar(1) NOT NULL,
  `DIF_PIS_COFINS_Texto` text NOT NULL,
  `DIF_PIS` double(4,2) NOT NULL DEFAULT '0.00',
  `DIF_PIS_ST` varchar(2) NOT NULL,
  `DIF_COFINS` double(4,2) NOT NULL DEFAULT '0.00',
  `DIF_COFINS_ST` varchar(2) NOT NULL,
  `CFOP_1` varchar(4) NOT NULL,
  `SUFRAMA` varchar(9) NOT NULL,
  `Franqueado` varchar(50) NOT NULL,
  `Conversao` double NOT NULL DEFAULT '0',
  `QtdePercentual` double NOT NULL DEFAULT '0',
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Responsavel`),
  KEY `IDXFranqueado` (`Franqueado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipos_lancamentos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tipos_lancamentos` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Codigo do tipo de credito',
  `Descricao` varchar(40) NOT NULL DEFAULT '',
  `Sts` varchar(10) NOT NULL DEFAULT 'Ativo' COMMENT 'Ativo / Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_saida_produtos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tmp_saida_produtos` (
  `Data_Romaneio` date NOT NULL,
  `Filial` varchar(4) NOT NULL DEFAULT '',
  `Romaneio` varchar(50) NOT NULL DEFAULT '',
  `Sequencia` varchar(3) NOT NULL DEFAULT '0',
  `Codigo` varchar(8) NOT NULL,
  `GTIN` varchar(14) DEFAULT NULL,
  `CodigoAlternativo` varchar(20) NOT NULL DEFAULT '',
  `Distribuidora` varchar(15) DEFAULT NULL,
  `Fornecedor` varchar(2) NOT NULL,
  `NomeFornecedor` varchar(30) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL COMMENT 'Codigo do Fornecedor Completo',
  `CodFornecedorR3` varchar(4) NOT NULL COMMENT '4 ultimos digitos do CodFornecedor',
  `Descricao` varchar(50) NOT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL,
  `Caracteristica` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `Composicao` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `Unidade` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `NomeCor` varchar(20) DEFAULT NULL,
  `Foto` int(11) NOT NULL DEFAULT '0',
  `Linha` varchar(40) DEFAULT NULL,
  `Colecao` varchar(40) DEFAULT NULL,
  `Categoria` varchar(30) DEFAULT NULL,
  `Genero` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `Grupo` varchar(40) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Tamanho` varchar(20) DEFAULT NULL,
  `Fashion` varchar(1) NOT NULL DEFAULT '' COMMENT 'S-fashion, N-não fashion',
  `Estilo` int(11) NOT NULL DEFAULT '0',
  `NCM` varchar(8) NOT NULL,
  `CST_ICMS` varchar(3) NOT NULL,
  `AliquotaICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `ReducaoICMS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_PIS` varchar(2) NOT NULL,
  `AliquotaPIS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_COFINS` varchar(2) NOT NULL,
  `AliquotaCOFINS` double(5,2) NOT NULL DEFAULT '0.00',
  `CST_IPI` varchar(2) NOT NULL,
  `AliquotaIPI` double(5,2) NOT NULL DEFAULT '0.00',
  `CFOP` varchar(4) NOT NULL,
  `CFOP_ProducaoProria` varchar(4) NOT NULL DEFAULT '',
  `Origem` varchar(1) NOT NULL,
  `PrecoVendaTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Varejo',
  `PrecoCompraTabela` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Atacado',
  `PrecoCompra` double(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Compra',
  `PrecoCheio` varchar(1) DEFAULT NULL,
  `SetorLaranja` varchar(1) DEFAULT NULL,
  `Encomenda` varchar(1) DEFAULT NULL COMMENT 'Produto só por encomenda',
  `Status` varchar(8) NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Peso` double(13,3) NOT NULL DEFAULT '0.000',
  `Quantidade` double(13,3) NOT NULL DEFAULT '0.000',
  `ValorTotal` double(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`Data_Romaneio`,`Romaneio`,`Filial`,`Sequencia`,`Codigo`) USING BTREE,
  KEY `idx_data_romaneio` (`Data_Romaneio`) USING BTREE,
  KEY `idx_verificacao` (`Data_Romaneio`,`Filial`,`Romaneio`,`Sequencia`,`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED
/*!50500 PARTITION BY RANGE  COLUMNS(Data_Romaneio)
(PARTITION p_2022_anterior VALUES LESS THAN ('2023-01-01') ENGINE = InnoDB,
 PARTITION p_2023 VALUES LESS THAN ('2024-01-01') ENGINE = InnoDB,
 PARTITION p_2024 VALUES LESS THAN ('2025-01-01') ENGINE = InnoDB,
 PARTITION p2025_01 VALUES LESS THAN ('2025-02-01') ENGINE = InnoDB,
 PARTITION p2025_02 VALUES LESS THAN ('2025-03-01') ENGINE = InnoDB,
 PARTITION p2025_03 VALUES LESS THAN ('2025-04-01') ENGINE = InnoDB,
 PARTITION p2025_04 VALUES LESS THAN ('2025-05-01') ENGINE = InnoDB,
 PARTITION p2025_05 VALUES LESS THAN ('2025-06-01') ENGINE = InnoDB,
 PARTITION p2025_06 VALUES LESS THAN ('2025-07-01') ENGINE = InnoDB,
 PARTITION p2025_07 VALUES LESS THAN ('2025-08-01') ENGINE = InnoDB,
 PARTITION p2025_08 VALUES LESS THAN ('2025-09-01') ENGINE = InnoDB,
 PARTITION p2025_09 VALUES LESS THAN ('2025-10-01') ENGINE = InnoDB,
 PARTITION p2025_10 VALUES LESS THAN ('2025-11-01') ENGINE = InnoDB,
 PARTITION p2025_11 VALUES LESS THAN ('2025-12-01') ENGINE = InnoDB,
 PARTITION p2025_12 VALUES LESS THAN ('2026-01-01') ENGINE = InnoDB,
 PARTITION p2026_01 VALUES LESS THAN ('2026-02-01') ENGINE = InnoDB,
 PARTITION p2026_02 VALUES LESS THAN ('2026-03-01') ENGINE = InnoDB,
 PARTITION p2026_03 VALUES LESS THAN ('2026-04-01') ENGINE = InnoDB,
 PARTITION p2026_04 VALUES LESS THAN ('2026-05-01') ENGINE = InnoDB,
 PARTITION p2026_05 VALUES LESS THAN ('2026-06-01') ENGINE = InnoDB,
 PARTITION p2026_06 VALUES LESS THAN ('2026-07-01') ENGINE = InnoDB,
 PARTITION p2026_07 VALUES LESS THAN ('2026-08-01') ENGINE = InnoDB,
 PARTITION p2026_08 VALUES LESS THAN ('2026-09-01') ENGINE = InnoDB,
 PARTITION p2026_09 VALUES LESS THAN ('2026-10-01') ENGINE = InnoDB,
 PARTITION p2026_10 VALUES LESS THAN ('2026-11-01') ENGINE = InnoDB,
 PARTITION p2026_11 VALUES LESS THAN ('2026-12-01') ENGINE = InnoDB,
 PARTITION p2026_12 VALUES LESS THAN ('2027-01-01') ENGINE = InnoDB,
 PARTITION p_futuro VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transportadoras`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `transportadoras` (
  `Codigo` int(11) NOT NULL DEFAULT '0',
  `Razao` varchar(50) NOT NULL,
  `Fantasia` varchar(40) NOT NULL,
  `Pessoa` varchar(8) NOT NULL,
  `CNPJ_CPF` varchar(18) NOT NULL,
  `IE_RG` varchar(20) NOT NULL,
  `Endereco` varchar(40) NOT NULL,
  `Numero` varchar(6) NOT NULL,
  `Complemento` varchar(20) DEFAULT NULL,
  `Bairro` varchar(30) NOT NULL,
  `Cidade` varchar(30) NOT NULL,
  `Estado` varchar(2) NOT NULL,
  `CEP` varchar(9) NOT NULL,
  `Celular_DDD` varchar(2) DEFAULT NULL,
  `Celular_Numero` varchar(8) DEFAULT NULL,
  `Celular_Contato` varchar(30) DEFAULT NULL,
  `Telefone_DDD` varchar(2) DEFAULT NULL,
  `Telefone_Numero` varchar(8) DEFAULT NULL,
  `Telefone_Contato` varchar(30) DEFAULT NULL,
  `eMail1_Conta` varchar(40) DEFAULT NULL,
  `eMail1_Contato` varchar(30) DEFAULT NULL,
  `Observacoes` text,
  `Placa` varchar(7) DEFAULT NULL,
  `Placa_UF` varchar(2) DEFAULT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`),
  KEY `FK_tbtransportadoras_1` (`Estado`),
  KEY `FK_tbtransportadoras_2` (`Placa_UF`),
  KEY `IDXDoc` (`CNPJ_CPF`),
  KEY `IDXRazao` (`Razao`),
  KEY `IDXFantasia` (`Fantasia`),
  CONSTRAINT `FK_transportadoras_allop_devel.estados` FOREIGN KEY (`Estado`) REFERENCES `estados` (`Sigla`) ON UPDATE CASCADE,
  CONSTRAINT `FK_transportadoras_allop_devel.estados_2` FOREIGN KEY (`Placa_UF`) REFERENCES `estados` (`Sigla`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `transportadoras_after_insert` AFTER INSERT ON `transportadoras` FOR EACH ROW BEGIN
	REPLACE INTO transportadoras_api(CodigoTransportadora,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												transportadoras t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `transportadoras_after_update` AFTER UPDATE ON `transportadoras` FOR EACH ROW BEGIN
	REPLACE INTO transportadoras_api(CodigoTransportadora,
											CodigoCD
										)
										(
											SELECT 
												t1.Codigo,
												t2.Codigo			 
											FROM 
												transportadoras t1,
												empresas_cd t2
												WHERE 
												t1.Codigo = NEW.Codigo
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `transportadoras_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `transportadoras_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoTransportadora` int(11) NOT NULL,
  PRIMARY KEY (`CodigoTransportadora`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `urls_allop`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `urls_allop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cd_id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `modulo` varchar(60) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_cp_compras_config_empresas` (`empresa_id`),
  KEY `IDXCdEmpresa` (`cd_id`,`empresa_id`) USING BTREE,
  CONSTRAINT `FK_cp_compras_config_empresas` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_config_empresas_cd` FOREIGN KEY (`cd_id`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `veiculos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `veiculos` (
  `Placa` varchar(7) NOT NULL,
  `Placa_UF` varchar(2) NOT NULL,
  `Veiculo` varchar(10) NOT NULL,
  `AnoFabrica` varchar(4) NOT NULL,
  `AnoModelo` varchar(4) NOT NULL,
  `Renavam` varchar(12) NOT NULL,
  `Tara` double(13,3) NOT NULL DEFAULT '0.000',
  `Cubagem` double(13,3) NOT NULL DEFAULT '0.000',
  `PesoMaximo` double(13,3) NOT NULL DEFAULT '0.000',
  `Propriedade_Veiculo` varchar(1) NOT NULL,
  `Tipo_Veiculo` varchar(1) NOT NULL,
  `Tipo_Rodado` varchar(2) NOT NULL,
  `Tipo_Carroceria` varchar(2) NOT NULL,
  `Motorista_Nome` varchar(40) NOT NULL,
  `Motorista_CPF` varchar(14) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Placa`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `veiculos_after_insert` AFTER INSERT ON `veiculos` FOR EACH ROW BEGIN
	REPLACE INTO veiculos_api(	CodigoVeiculo,
											CodigoCD
										)
										(
											SELECT 
												t1.Placa,
												t2.Codigo			 
											FROM 
												veiculos	t1,
												empresas_cd t2
												WHERE 
												t1.Placa = NEW.Placa
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`allopdevel`@`%`*/ /*!50003 TRIGGER `veiculos_after_update` AFTER UPDATE ON `veiculos` FOR EACH ROW BEGIN
	REPLACE INTO veiculos_api(	CodigoVeiculo,
											CodigoCD
										)
										(
											SELECT 
												t1.Placa,
												t2.Codigo			 
											FROM 
												veiculos	t1,
												empresas_cd t2
												WHERE 
												t1.Placa = NEW.Placa
											);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `veiculos_api`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `veiculos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoVeiculo` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoVeiculo`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `veiculos_carrocerias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `veiculos_carrocerias` (
  `Codigo` varchar(2) NOT NULL DEFAULT '',
  `Descricao` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `veiculos_propriedades`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `veiculos_propriedades` (
  `Codigo` varchar(1) NOT NULL,
  `Descricao` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `veiculos_rodados`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `veiculos_rodados` (
  `Codigo` varchar(2) NOT NULL,
  `Descricao` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `veiculos_tipos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `veiculos_tipos` (
  `Codigo` varchar(1) NOT NULL DEFAULT '',
  `Descricao` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `videos_de_ajuda`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `videos_de_ajuda` (
  `Codigo` int(11) NOT NULL,
  `Nivel` int(11) NOT NULL,
  `Descricao` varchar(100) NOT NULL,
  `URL` varchar(350) NOT NULL,
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`),
  KEY `FK_videos_de_ajuda_segnivel_menu` (`Nivel`),
  CONSTRAINT `FK_videos_de_ajuda_segnivel_menu` FOREIGN KEY (`Nivel`) REFERENCES `segnivel_menu` (`Nivel`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `vw_compras_contagem_itens_para_conta_corrente`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vw_compras_contagem_itens_para_conta_corrente` AS SELECT
 1 AS `CD`,
  1 AS `Empresa`,
  1 AS `Pedido`,
  1 AS `Produto`,
  1 AS `Distribuidora`,
  1 AS `ValorUnitario`,
  1 AS `ValorTotal`,
  1 AS `idCartao`,
  1 AS `Contagem`,
  1 AS `Qtde`,
  1 AS `QtdeContagem`,
  1 AS `AguardarSaldoRestante`,
  1 AS `Saldo`,
  1 AS `UltimoRegistro` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_compras_pedidos_compras_relatorios_itens_atrasados`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vw_compras_pedidos_compras_relatorios_itens_atrasados` AS SELECT
 1 AS `CD_detalhe`,
  1 AS `Pedido_detalhe`,
  1 AS `Produto_detalhe`,
  1 AS `Sequencia_detalhe`,
  1 AS `Distribuidora_detalhe`,
  1 AS `Referencia_detalhe`,
  1 AS `Quantidade_detalhe`,
  1 AS `ValorUnitario_detalhe`,
  1 AS `ValorTotal_detalhe`,
  1 AS `Entregue_detalhe`,
  1 AS `Saldo_detalhe`,
  1 AS `PrevisaoEntrega_detalhe`,
  1 AS `Fornecedor`,
  1 AS `Categoria`,
  1 AS `CodFornecedorR3`,
  1 AS `Colecao`,
  1 AS `Linha`,
  1 AS `Descricao`,
  1 AS `DescricaoComplementar`,
  1 AS `Grupo`,
  1 AS `GrupoCategoria`,
  1 AS `Genero`,
  1 AS `Composicao`,
  1 AS `Caracteristica`,
  1 AS `SetorLaranja`,
  1 AS `PrecoCheio`,
  1 AS `Encomenda`,
  1 AS `Tamanho`,
  1 AS `Cor`,
  1 AS `Status`,
  1 AS `DataPedido`,
  1 AS `CodFornecedor` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_compras_pedidos_compras_relatorios_itens_comprados`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vw_compras_pedidos_compras_relatorios_itens_comprados` AS SELECT
 1 AS `CD_detalhe`,
  1 AS `Pedido_detalhe`,
  1 AS `Produto_detalhe`,
  1 AS `Sequencia_detalhe`,
  1 AS `Distribuidora_detalhe`,
  1 AS `Referencia_detalhe`,
  1 AS `Quantidade_detalhe`,
  1 AS `ValorUnitario_detalhe`,
  1 AS `ValorTotal_detalhe`,
  1 AS `Entregue_detalhe`,
  1 AS `Saldo_detalhe`,
  1 AS `PrevisaoEntrega_detalhe`,
  1 AS `Fornecedor`,
  1 AS `Categoria`,
  1 AS `CodFornecedorR3`,
  1 AS `Colecao`,
  1 AS `Linha`,
  1 AS `Descricao`,
  1 AS `DescricaoComplementar`,
  1 AS `Grupo`,
  1 AS `GrupoCategoria`,
  1 AS `Genero`,
  1 AS `Composicao`,
  1 AS `Caracteristica`,
  1 AS `SetorLaranja`,
  1 AS `PrecoCheio`,
  1 AS `Encomenda`,
  1 AS `Tamanho`,
  1 AS `Cor`,
  1 AS `Status`,
  1 AS `DataPedido`,
  1 AS `CodFornecedor`,
  1 AS `Varejo`,
  1 AS `Estilo` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_produtos_fabrica`
--

SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vw_produtos_fabrica` AS SELECT
 1 AS `Referencia`,
  1 AS `Fornecedor`,
  1 AS `CodFornecedor`,
  1 AS `CodFornecedorR3`,
  1 AS `Categoria`,
  1 AS `Colecao`,
  1 AS `Linha`,
  1 AS `Grupo`,
  1 AS `GrupoCategoria`,
  1 AS `Composicao`,
  1 AS `Caracteristica`,
  1 AS `Genero`,
  1 AS `Descricao`,
  1 AS `DescricaoComplementar`,
  1 AS `Unidade`,
  1 AS `Cor`,
  1 AS `Tamanho`,
  1 AS `NCM`,
  1 AS `CST_ICMS`,
  1 AS `Origem`,
  1 AS `AliquotaICMS`,
  1 AS `ReducaoICMS`,
  1 AS `CST_PIS`,
  1 AS `AliquotaPIS`,
  1 AS `CST_COFINS`,
  1 AS `AliquotaCOFINS`,
  1 AS `CST_IPI`,
  1 AS `AliquotaIPI`,
  1 AS `CFOP`,
  1 AS `Peso`,
  1 AS `PrecoCompra`,
  1 AS `PrecoCompraTabela`,
  1 AS `PrecoVendaTabela`,
  1 AS `SetorLaranja`,
  1 AS `PrecoCheio`,
  1 AS `Status`,
  1 AS `Inclusao`,
  1 AS `Alteracao`,
  1 AS `Usuario`,
  1 AS `Consolidado`,
  1 AS `DescricaoCompleta`,
  1 AS `NomeFornecedor`,
  1 AS `Encomenda`,
  1 AS `TipoProduto`,
  1 AS `nome_colecao`,
  1 AS `nome_linha`,
  1 AS `nome_comp`,
  1 AS `nome_carac`,
  1 AS `nome_genero`,
  1 AS `genero_abreviado`,
  1 AS `nome_unidade`,
  1 AS `Foto`,
  1 AS `Estilo` */;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'allop_devel'
--

--
-- Dumping routines for database 'allop_devel'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` FUNCTION `sf_compras2compras_hst`(
	`prmCD` INT,
	`prmPedido` INT
) RETURNS int(11)
    COMMENT 'se retornar 0 não foi para historico se for 1 foi para historico'
BEGIN
	SET @QTDE_ITENS_DIFERENTE_DE_0 := 0;
	SET @IdAgenda :=0;
	SELECT
		COUNT(*)
	INTO
		@QTDE_ITENS_DIFERENTE_DE_0
	FROM
		compras_itens
	WHERE
		CD = prmCD
	AND
		Pedido = prmPedido
	AND
		Saldo <> 0;
	
	IF @QTDE_ITENS_DIFERENTE_DE_0 = 0 THEN
			
			
			INSERT INTO
				compras_hst
			(
				SELECT
					*
				FROM
					compras
				WHERE
					CD = prmCD
				AND
					Pedido = prmPedido
			);
			
			INSERT INTO
				compras_itens_hst
			(
				SELECT
					*
				FROM
					compras_itens
				WHERE
					CD = prmCD
				AND
					Pedido = prmPedido
			);
			-- Movendo agenda para o histórico
			INSERT INTO
				compras_agenda_hst
			(
				SELECT
					*
				FROM
					compras_agenda
				WHERE
					CD = prmCD
				AND
					Pedido = prmPedido
			);
			
			
			INSERT INTO
				compras_agenda_docs_hst
			(
				SELECT
					docs.*
				FROM
					compras_agenda AS agd
				INNER JOIN
					compras_agenda_docs AS docs
				ON
					agd.id = docs.IDAgenda
				AND 
					agd.CD = prmCD
				AND
					agd.Pedido = prmPedido
			);
			
			
			-- Deletando pedido de compra
			DELETE FROM
				compras
			WHERE
				CD = prmCD	
			AND
				Pedido = prmPedido;
			RETURN 1;
		ELSE
			RETURN 0;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` FUNCTION `sf_criar_proximo_codigo_da_tabela`(
	`prmCD` INT,
	`prmTableName` VARCHAR(100)
) RETURNS bigint(20)
BEGIN
	SET @COD := 0;
	SET @EXISTE_ESSA_TABELA := 0;
	
	SELECT 
		COUNT(*) 
	INTO
		@EXISTE_ESSA_TABELA
	FROM 
		contador_registros
	WHERE 
		contador_registros.CD = prmCD 
	AND 
		contador_registros.TableName = prmTableName;
	
	IF	@EXISTE_ESSA_TABELA <> 0 THEN
		UPDATE 
			contador_registros 
		SET 
			Contador = Contador + 1 
		WHERE 
			CD = prmCD 
		AND 
			TableName = prmTableName;
		
		ELSE
			INSERT
				contador_registros 
			SET 
				Contador =  1 ,
				CD = prmCD ,
				Descricao ='',
				TableName = prmTableName;
		
	END IF;

	SELECT 
		COALESCE(Contador,0) AS Contador 
	INTO
		@COD
	FROM 
		contador_registros 
	WHERE 
		CD = prmCD 
	AND 
		TableName = prmTableName;
	
	RETURN @COD;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` FUNCTION `sf_validar_arrasto_compras_agenda`(
	`prmID` INT,
	`prmBoardAtual` INT
) RETURNS int(11)
BEGIN
	SET @MOVER_AGENDAMENTO = 0;
	SET @MOVER_LIBERADO_ENTREGA =0;
	SET @TEM_CONTAGEM =0;
	SET @idContagem :=0;
	SET @stsContagem :=0;
	
	
	
	SELECT 
		compras_contagem.id,
		compras_contagem.Sts
	INTO 
		@idContagem,
		@stsContagem
	FROM
		compras_contagem
	WHERE
		compras_contagem.idCartao =prmID;
		
	IF @idContagem <> false  THEN
		
		if   prmBoardAtual <> 4 AND 	@stsContagem = 1 THEN
			RETURN 4;
		END IF;
		
		CALL sf_validar_consolidacao_contagem(1);
		
	END IF;
		

	SELECT 
		COUNT(*)
	INTO 
		@MOVER_AGENDAMENTO
	FROM
		compras_agenda
	WHERE
		ID =prmID
	AND(
			(ISNULL( compras_agenda.NF_numero) = TRUE || compras_agenda.NF_numero <= 0)
		OR
			(ISNULL( compras_agenda.Volume) = TRUE || compras_agenda.Volume <= 0)
		OR
			(ISNULL( compras_agenda.Qtde) = TRUE || compras_agenda.Qtde <= 0)
		OR
			(ISNULL( compras_agenda.DataAgendamento) = TRUE || compras_agenda.DataAgendamento < CURDATE()	)
			
		);

	SELECT 
		COUNT(*)
	INTO 
		@MOVER_LIBERADO_ENTREGA
	FROM
		compras_agenda
	WHERE
		ID =prmID
	AND(
		(ISNULL( compras_agenda.Placa_Veiculo) = TRUE || compras_agenda.Placa_Veiculo = '')
	OR
		(ISNULL( compras_agenda.Conferente) = TRUE || compras_agenda.Conferente = '')
	OR
		(ISNULL( compras_agenda.NomeMotorista) = TRUE || compras_agenda.NomeMotorista = '')
	OR
		(ISNULL( compras_agenda.Recepcao) = TRUE || compras_agenda.Recepcao = '')
	);
	
	
	
	-- se não tem data de agendamento  voltar para a situação 1 , e retornar 1
	IF @MOVER_AGENDAMENTO =  1 AND prmBoardAtual > 1 then

		RETURN 1;
		ELSE
			-- senão se não tem os dados obrigatorios para liberar para entrega voltar uma situação anterior e retornar uma situação
			IF @MOVER_LIBERADO_ENTREGA = 1  AND prmBoardAtual > 2 THEN
				RETURN 2;
			END IF;
			
			
	END IF;
	
	-- senão retorna 0
	RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` FUNCTION `sf_validar_consolidacao_contagem`(
	`prmIdContagem` INT(11)
) RETURNS int(11)
BEGIN
	SET @QTDE_ITEM := 0;
   SET @QTDE_CAB_COMPRAS_PENDENTES :=0;
   
	SELECT
		COUNT(*)
	INTO 
		@QTDE_ITEM
	FROM
		compras_contagem_itens
	WHERE
		compras_contagem_itens.idComprasContagem = prmIdContagem
	AND
		compras_contagem_itens.StsControle = 2;
	
	
	
	-- se tem item recusado voltar situação do controle/	
	IF (@QTDE_ITEM <> 0) THEN
		UPDATE
		 	compras_contagem
		SET
		 	compras_contagem.Sts = 1
		WHERE
			compras_contagem.id = prmIdContagem;
		 
		RETURN 4;
	END IF;
	
	SELECT
		COUNT(*)
	INTO 
		@QTDE_CAB_COMPRAS_PENDENTES
	FROM
		compras_contagem_itens
	WHERE
		compras_contagem_itens.idComprasContagem = prmIdContagem
	AND
		compras_contagem_itens.StsControle = 0;
	
	
	
		/*se tem item pendente */	
	IF (@QTDE_CAB_COMPRAS_PENDENTES <> 0) THEN
		RETURN 4;
	END IF;

 	RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `check_apis_de_dados`(
	IN `prm_codigo_cd` INT
)
    COMMENT 'esse procedimento retorna uma lista das tabelas e a quantidade de registros cada uma tem'
BEGIN
   DECLARE reg_estados_api                             INTEGER;
   DECLARE reg_ibge_api                                INTEGER;
   DECLARE reg_cidades_api                             INTEGER;
   DECLARE reg_cests_ncm_api                           INTEGER;
   DECLARE reg_cfops_api                               INTEGER;  
   DECLARE reg_config_email_api                        INTEGER;
   DECLARE reg_consultores_api                         INTEGER;
   DECLARE reg_empresas_cd_api                         INTEGER;
   DECLARE reg_empresas_api                            INTEGER;
   DECLARE reg_franqueados_api                         INTEGER;
   DECLARE reg_st_cofins_api                           INTEGER;
   DECLARE reg_st_icms_api                             INTEGER;
   DECLARE reg_st_ipi_api                              INTEGER;
   DECLARE reg_st_origem_api                           INTEGER;
   DECLARE reg_st_pis_api                              INTEGER;
   DECLARE reg_produtos_categorias_livre_api           INTEGER;
   DECLARE reg_produtos_grupos_livre_api               INTEGER;
   DECLARE reg_produtos_categorias_api                 INTEGER;
   DECLARE reg_produtos_colecao_api                    INTEGER;
   DECLARE reg_produtos_composicoes_api                INTEGER;
   DECLARE reg_produtos_caracteristicas_api            INTEGER;
   DECLARE reg_produtos_categoria_caracteristicas_api  INTEGER;
   DECLARE reg_produtos_categoria_composicao_api       INTEGER;
   DECLARE reg_produtos_cor_api                        INTEGER;
   DECLARE reg_produtos_fornecedor_api                 INTEGER;
   DECLARE reg_produtos_generos_api                    INTEGER;
   DECLARE reg_produtos_grupos_api                     INTEGER;
   DECLARE reg_produtos_linhas_api                     INTEGER;
   DECLARE reg_produtos_medidas_api                    INTEGER;
   DECLARE reg_produtos_tamanho_api                    INTEGER;
   DECLARE reg_produtos_api                            INTEGER;
   DECLARE reg_produtos_barras_api                     INTEGER;
   DECLARE reg_ramo_atividades_api                     INTEGER;
   DECLARE reg_regioes_api                             INTEGER;
   DECLARE reg_responsaveis_api                        INTEGER;
   DECLARE reg_responsaveis_entrega_api                INTEGER;
   DECLARE reg_responsaveis_tributos_api               INTEGER;
   DECLARE reg_romaneios_api                           INTEGER;
   DECLARE reg_transportadoras_api                     INTEGER;
   DECLARE reg_veiculos_api                            INTEGER;   

   SELECT COUNT(*) INTO reg_estados_api                            FROM  estados_api                             WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_ibge_api                               FROM  ibge_api                                WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_cidades_api                            FROM  cidades_api                             WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_cests_ncm_api                          FROM  cests_ncm_api                           WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_cfops_api                              FROM  cfops_api                               WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_config_email_api                       FROM  config_email_api                        WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_consultores_api                        FROM  consultores_api                         WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_empresas_cd_api                        FROM  empresas_cd_api                         WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_empresas_api                           FROM  empresas_api                            WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_franqueados_api                        FROM  franqueados_api                         WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_categorias_livre_api          FROM  produtos_categorias_livre_api           WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_grupos_livre_api              FROM  produtos_grupos_livre_api               WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_categorias_api                FROM  produtos_categorias_api                 WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_colecao_api                   FROM  produtos_colecao_api                    WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_composicoes_api               FROM  produtos_composicoes_api                WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_caracteristicas_api           FROM  produtos_caracteristicas_api            WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_categoria_caracteristicas_api FROM  produtos_categoria_caracteristicas_api  WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_categoria_composicao_api      FROM  produtos_categoria_composicao_api       WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_cor_api                       FROM  produtos_cor_api                        WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_fornecedor_api                FROM  produtos_fornecedor_api                 WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_generos_api                   FROM  produtos_generos_api                    WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_grupos_api                    FROM  produtos_grupos_api                     WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_linhas_api                    FROM  produtos_linhas_api                     WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_medidas_api                   FROM  produtos_medidas_api                    WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_tamanho_api                   FROM  produtos_tamanho_api                    WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_api                           FROM  produtos_api                            WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_produtos_barras_api                    FROM  produtos_barras_api                     WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_ramo_atividades_api                    FROM  ramo_atividades_api                     WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_regioes_api                            FROM  regioes_api                             WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_responsaveis_api                       FROM  responsaveis_api                        WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_responsaveis_entrega_api               FROM  responsaveis_entrega_api                WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_responsaveis_tributos_api              FROM  responsaveis_tributos_api               WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_romaneios_api                          FROM  romaneios_api                           WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_st_cofins_api                          FROM  st_cofins_api                           WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_st_icms_api                            FROM  st_icms_api                             WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_st_ipi_api                             FROM  st_ipi_api                              WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_st_origem_api                          FROM  st_origem_api                           WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_st_pis_api                             FROM  st_pis_api                              WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_transportadoras_api                    FROM  transportadoras_api                     WHERE CodigoCD = prm_codigo_cd;
   SELECT COUNT(*) INTO reg_veiculos_api                           FROM  veiculos_api                            WHERE CodigoCD = prm_codigo_cd;
   
    SELECT	reg_estados_api                           ,
			reg_ibge_api                              ,
			reg_cidades_api                           ,
			reg_cests_ncm_api                         ,
			reg_cfops_api                             ,
			reg_config_email_api                      ,
			reg_consultores_api                       ,
			reg_empresas_cd_api                       ,
			reg_empresas_api                          ,
			reg_franqueados_api                       ,
			reg_produtos_categorias_livre_api         ,
			reg_produtos_grupos_livre_api             ,
			reg_produtos_categorias_api               ,
			reg_produtos_colecao_api                  ,
			reg_produtos_composicoes_api              ,
			reg_produtos_caracteristicas_api          ,
			reg_produtos_categoria_caracteristicas_api,
			reg_produtos_categoria_composicao_api     ,
			reg_produtos_cor_api                      ,
			reg_produtos_fornecedor_api               ,
			reg_produtos_generos_api                  ,
			reg_produtos_grupos_api                   ,
			reg_produtos_linhas_api                   ,
			reg_produtos_medidas_api                  ,
			reg_produtos_tamanho_api                  ,
			reg_produtos_api                          ,
			reg_produtos_barras_api                   ,
			reg_ramo_atividades_api                   ,
			reg_regioes_api                           ,
			reg_responsaveis_api                      ,
			reg_responsaveis_entrega_api              ,
			reg_responsaveis_tributos_api             ,
			reg_romaneios_api                         ,
			reg_st_cofins_api                         ,
			reg_st_icms_api                           ,
			reg_st_ipi_api                            ,
			reg_st_origem_api                         ,
			reg_st_pis_api                            ,
			reg_transportadoras_api                   ,
			reg_veiculos_api                          ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `HeidiSQL_temproutine_1`(
	IN `prmCD` INT,
	IN `prmEmpresa` INT,
	IN `prmProduto` VARCHAR(50),
	IN `prmReferencia` VARCHAR(50),
	IN `prmEstoque` INT,
	IN `prmValorUltimaCompra` INT,
	IN `prmDataUltimaCompra` DATE,
	IN `prmCustoUnitario` INT,
	IN `prmCustoMedio` INT
)
REPLACE INTO produtos_estoque
	(
		CD, 
		Empresa, 
		Produto, 
		Referencia,  
		ValorUltimaCompra, 
		DataUltimaCompra, 
		DataUltimaVenda, 
		ValorUltimaVenda, 
		CustoUnitario, 
		CustoMedio
	)VALUES (
		prmCD, 
		prmEmpresa, 
		prmProduto, 
		prmReferencia,  
		prmValorUltimaCompra, 
		prmDataUltimaCompra,  
		prmCustoUnitario, 
		prmCustoMedio
	); ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `produtos_000_sp`(
	IN `prmCodigo` VARCHAR(20)
)
BEGIN
	-- Outras variaveis
	SET	@Codigo 			:= '';
	SET	@Distribuidora := '';
	SET	@Marca 			:= ''; 
	SET 	@Modelo 			:= '';
	SET	@Grupo  			:= ''; 
	SET	@SubGrupo 		:= ''; 
	SET	@Unidade 		:= '';
	SET   @Sts           := '';

	SET	@ContMarca 		:= 0; 
	SET 	@ContModelo 	:= 0;
	SET	@ContGrupo		:= 0; 
	SET 	@ContUnidade 	:= 0;
	SET 	@ContTPEC      := 0;
	SET   @ContPro       := 0;
	
	-- Preços
	SET	@PrecoVendaTabela		 		:= 0;
	SET   @PrecoVendaTabelaAnterior 	:= 0;
	SET 	@PrecoCompraTabela	 		:= 0;
	SET   @SetorLaranja         		:= 'N';			
	SET   @PrecoVenda   			 		:= 0;
	
	SELECT 
		pro.Codigo, 
		pro.Distribuidora, 
		linha.Linha Marca,
		colecao.Colecao Modelo,
		pro.Grupo, 
		pro.GrupoCategoria SubGrupo, 
		pro.Unidade,
		pro.PrecoVendaTabela,
		pro.PrecoCompraTabela,
		pro.SetorLaranja,
		pro.`Status`
	INTO
		@Codigo,
		@Distribuidora,
		@Marca,
	 	@Modelo,
	 	@Grupo,
		@SubGrupo,
		@Unidade,
		@PrecoVendaTabela,
		@PrecoCompraTabela,
		@SetorLaranja,
		@Sts
	FROM 
		produtos pro,
		produtos_linhas linha,
		produtos_colecao colecao
	WHERE
		pro.Linha = linha.Codigo
	AND
		pro.Colecao = colecao.Codigo
	AND
		pro.Codigo = prmCodigo;
  	
  	-- ---------------------------------------------------------------------------
  	-- tbMarcas
  	-- ---------------------------------------------------------------------------
  	SELECT COUNT(1) INTO @ContMarca FROM ks_desenv.tbMarcas WHERE Marca = @Marca; 
	   
	IF @ContMarca < 1 THEN
		INSERT INTO ks_desenv.tbMarcas (
										Marca, 
										`Status`, 
										Inclusao, 
										Alteracao, 
										Usuario
										)(
								  		SELECT 
										  Linha, 
										  `Status`, 
										  Inclusao, 
										  Alteracao, 
										  Usuario
										FROM 
											produtos_linhas
										WHERE
										   Linha = @Marca
										);
  	END IF;
  	
  	-- ------------------------------------------------------------------------------
  	-- tbModelos
  	-- ------------------------------------------------------------------------------
  	SELECT COUNT(1) INTO @ContModelo FROM ks_desenv.tbModelos WHERE Modelo = @Modelo;
  	
   IF @ContModelo < 1 THEN 
      INSERT INTO ks_desenv.tbModelos (
													Modelo, 
													`Status`, 
													Inclusao, 
													Alteracao, 
													Usuario
													)(
													SELECT 
														Colecao, 
														`Status`, 
														Inclusao, 
														Alteracao, 
														Usuario
													FROM 
														produtos_colecao
													WHERE 
													   Colecao = @Modelo
													);
   END IF;


	-- -----------------------------------------------------------------------------------------------------------
  	-- tbGrupos
  	-- -----------------------------------------------------------------------------------------------------------
  	SELECT COUNT(1) INTO @ContGrupo FROM ks_desenv.tbGrupos WHERE Grupo = @Grupo AND SubGrupo = @SubGrupo;
  	
  	IF @ContGrupo < 1 THEN
  		INSERT INTO ks_desenv.tbGrupos (
									  Grupo, 
									  SubGrupo, 
									  CampoPesquisa, 
									  `Status`, 
									  Inclusao, 
									  Alteracao, 
									  Usuario
		  							)(
		  								SELECT 
										  	Grupo, 
										  	SubGrupo, 
										  	CONCAT(Grupo,' | ',SubGrupo) CampoPesquisa,
										  	`Status`, 
										  	Inclusao, 
										  	Alteracao, 
										  	Usuario
										FROM 
											produtos_grupos
		  								WHERE 
										  Grupo = @Grupo AND SubGrupo = @SubGrupo
		  								);
  	END IF;


  	-- ---------------------------------------------------------------------------------
  	-- tbMedidas
  	-- ---------------------------------------------------------------------------------
  	
  	SELECT COUNT(1) INTO @ContUnidade FROM ks_desenv.tbMedidas WHERE Sigla = @Unidade;
  	
  	IF @ContUnidade < 1 THEN
  		INSERT INTO ks_desenv.tbMedidas (
	  									Sigla, 
										Unidade, 
										`Status`, 
										CampoPesquisa, 
										Inclusao, 
										Alteracao, 
										Usuario
										)(
										SELECT 
											Sigla, 
											Unidade, 
											`Status`, 
											CONCAT(Sigla,' / ',Unidade) CampoPesquisa,
											Inclusao, 
											Alteracao, 
											Usuario
										FROM 
											produtos_medidas
										WHERE
										   Sigla = @Unidade
										);

  	END IF;
  	
  	-- ---------------------------------------------------------------------------------
  	-- PRODUTOS E TPEC (tbProdutos, tbProdutosTPEC
  	-- ---------------------------------------------------------------------------------
  	
	-- Antes de Inserir ou atualizar o produto pegar o valor de venda anterior
	SELECT COUNT(1),COALESCE(PrecoVendaTabela,0) INTO @ContPro, @PrecoVendaTabelaAnterior FROM ks_desenv.tbProdutos WHERE Codigo = prmCodigo;
	
	-- Insere ou Atualiza o produto
	REPLACE INTO 
		ks_desenv.tbProdutos (
									Codigo, 
									Distribuidora, 
									GTIN, 
									Marca, 
									Modelo, 
									Grupo, 
									SubGrupo, 
									Descricao, 
									DescricaoComplementar, 
									Unidade, 
									Tributacao,
									ClassificacaoFiscal, 
									SituacaoTributaria, 
									AliquotaICMS, 
									ReducaoICMS, 
									CST_PIS, 
									AliquotaPIS, 
									CST_COFINS, 
									AliquotaCOFINS, 
									CST_IPI, 
									AliquotaIPI, 
									CFOP_1, 
									Peso, 
									PrecoVendaTabela, 
									PrecoCompraTabela, 
									PrecoCompra, 
									SetorLaranja, 
									PrecoCheio, 
									CampoPesquisa, 
									`Status`, 
									Inclusao, 
									Alteracao, 
									Usuario
								)(
									SELECT 
										pro.Codigo, 
										pro.Distribuidora, 
										pro.GTIN, 
										linha.Linha Marca,
										colecao.Colecao Modelo,
										pro.Grupo, 
										pro.GrupoCategoria SubGrupo, 
										pro.Descricao, 
										pro.DescricaoComplementar, 
										pro.Unidade, 
										'Produto' Tributacao,
										pro.NCM ClassificacaoFiscal, 
										CONCAT(pro.Origem,pro.CST_ICMS) SituacaoTributaria, 
										pro.AliquotaICMS, 
										pro.ReducaoICMS, 
										pro.CST_PIS, 
										pro.AliquotaPIS, 
										pro.CST_COFINS, 
										pro.AliquotaCOFINS, 
										pro.CST_IPI, 
										pro.AliquotaIPI, 
										pro.CFOP, 
										pro.Peso, 
										pro.PrecoVendaTabela, 
										pro.PrecoCompraTabela, 
										pro.PrecoCompra, 
										pro.SetorLaranja, 
										pro.PrecoCheio, 
										CONCAT(linha.Linha,' | ',colecao.Colecao,' | ',pro.Grupo,' | ',pro.GrupoCategoria,' - ', pro.Descricao,' (',pro.Codigo,') ',pro.Distribuidora) CampoPesquisa,
										pro.Status, 
										pro.Inclusao, 
										pro.Alteracao, 
										pro.Usuario
									FROM 
										produtos pro,
										produtos_linhas linha,
										produtos_colecao colecao
									WHERE
										pro.Linha = linha.Codigo
									AND
										pro.Colecao = colecao.Codigo
									AND
									   pro.Codigo = prmCodigo);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `produtos_000_versao_inicial_sp`()
BEGIN
	-- Declara as variaveis para uso do cursor
	DECLARE fim_do_cursor	INT;
	DECLARE cod_filial 		VARCHAR(4);
	DECLARE pct_fator			DOUBLE(12,2);
	DECLARE uf_estado			VARCHAR(2);
	DECLARE pct_icms        DOUBLE(12,2);
	
	DECLARE c CURSOR FOR
		SELECT 
				emp.Codigo, 
				emp.Fator,
				emp.Estado,
				est.ICMS
		FROM 
			ks_desenv.tbEmpresas emp,
			ks_desenv.tbEstados  est
		WHERE
		   emp.Estado = est.Sigla;
			
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_do_cursor = 1;

	-- Outras variaveis
	SET	@Codigo 			:= '';
	SET	@Distribuidora := '';
	SET	@Marca 			:= ''; 
	SET 	@Modelo 			:= '';
	SET	@Grupo  			:= ''; 
	SET	@SubGrupo 		:= ''; 
	SET	@Unidade 		:= '';
	SET   @Sts           := '';

	SET	@ContMarca 		:= 0; 
	SET 	@ContModelo 	:= 0;
	SET	@ContGrupo		:= 0; 
	SET 	@ContUnidade 	:= 0;
	SET 	@ContTPEC      := 0;
	SET   @ContPro       := 0;
	
	-- Preços
	SET	@PrecoVendaTabela		 		:= 0;
	SET   @PrecoVendaTabelaAnterior 	:= 0;
	SET 	@PrecoCompraTabela	 		:= 0;
	SET   @SetorLaranja         		:= 'N';			
	SET   @PrecoVenda   			 		:= 0;
	
	SELECT 
		pro.Codigo, 
		pro.Distribuidora, 
		linha.Linha Marca,
		colecao.Colecao Modelo,
		pro.Grupo, 
		pro.GrupoCategoria SubGrupo, 
		pro.Unidade,
		pro.PrecoVendaTabela,
		pro.PrecoCompraTabela,
		pro.SetorLaranja,
		pro.`Status`
	INTO
		@Codigo,
		@Distribuidora,
		@Marca,
	 	@Modelo,
	 	@Grupo,
		@SubGrupo,
		@Unidade,
		@PrecoVendaTabela,
		@PrecoCompraTabela,
		@SetorLaranja,
		@Sts
	FROM 
		produtos pro,
		produtos_linhas linha,
		produtos_colecao colecao
	WHERE
		pro.Linha = linha.Codigo
	AND
		pro.Colecao = colecao.Codigo
	AND
		pro.Codigo = prmCodigo;
  	
  	-- ---------------------------------------------------------------------------
  	-- tbMarcas
  	-- ---------------------------------------------------------------------------
  	SELECT COUNT(1) INTO @ContMarca FROM ks_desenv.tbMarcas WHERE Marca = @Marca; 
	   
	IF @ContMarca < 1 THEN
		INSERT INTO ks_desenv.tbMarcas (
										Marca, 
										`Status`, 
										Inclusao, 
										Alteracao, 
										Usuario
										)(
								  		SELECT 
										  Linha, 
										  `Status`, 
										  Inclusao, 
										  Alteracao, 
										  Usuario
										FROM 
											produtos_linhas
										WHERE
										   Linha = @Marca
										);
  	END IF;
  	
  	-- ------------------------------------------------------------------------------
  	-- tbModelos
  	-- ------------------------------------------------------------------------------
  	SELECT COUNT(1) INTO @ContModelo FROM ks_desenv.tbModelos WHERE Modelo = @Modelo;
  	
   IF @ContModelo < 1 THEN 
      INSERT INTO ks_desenv.tbModelos (
													Modelo, 
													`Status`, 
													Inclusao, 
													Alteracao, 
													Usuario
													)(
													SELECT 
														Colecao, 
														`Status`, 
														Inclusao, 
														Alteracao, 
														Usuario
													FROM 
														produtos_colecao
													WHERE 
													   Colecao = @Modelo
													);
   END IF;


	-- -----------------------------------------------------------------------------------------------------------
  	-- tbGrupos
  	-- -----------------------------------------------------------------------------------------------------------
  	SELECT COUNT(1) INTO @ContGrupo FROM ks_desenv.tbGrupos WHERE Grupo = @Grupo AND SubGrupo = @SubGrupo;
  	
  	IF @ContGrupo < 1 THEN
  		INSERT INTO ks_desenv.tbGrupos (
									  Grupo, 
									  SubGrupo, 
									  CampoPesquisa, 
									  `Status`, 
									  Inclusao, 
									  Alteracao, 
									  Usuario
		  							)(
		  								SELECT 
										  	Grupo, 
										  	SubGrupo, 
										  	CONCAT(Grupo,' | ',SubGrupo) CampoPesquisa,
										  	`Status`, 
										  	Inclusao, 
										  	Alteracao, 
										  	Usuario
										FROM 
											produtos_grupos
		  								WHERE 
										  Grupo = @Grupo AND SubGrupo = @SubGrupo
		  								);
  	END IF;


  	-- ---------------------------------------------------------------------------------
  	-- tbMedidas
  	-- ---------------------------------------------------------------------------------
  	
  	SELECT COUNT(1) INTO @ContUnidade FROM ks_desenv.tbMedidas WHERE Sigla = @Unidade;
  	
  	IF @ContUnidade < 1 THEN
  		INSERT INTO ks_desenv.tbMedidas (
	  									Sigla, 
										Unidade, 
										`Status`, 
										CampoPesquisa, 
										Inclusao, 
										Alteracao, 
										Usuario
										)(
										SELECT 
											Sigla, 
											Unidade, 
											`Status`, 
											CONCAT(Sigla,' / ',Unidade) CampoPesquisa,
											Inclusao, 
											Alteracao, 
											Usuario
										FROM 
											produtos_medidas
										WHERE
										   Sigla = @Unidade
										);

  	END IF;
  	
  	-- ---------------------------------------------------------------------------------
  	-- PRODUTOS E TPEC (tbProdutos, tbProdutosTPEC
  	-- ---------------------------------------------------------------------------------
  	
	-- Antes de Inserir ou atualizar o produto pegar o valor de venda anterior
	SELECT COUNT(1),COALESCE(PrecoVendaTabela,0) INTO @ContPro, @PrecoVendaTabelaAnterior FROM ks_desenv.tbProdutos WHERE Codigo = prmCodigo;
	
	-- Insere ou Atualiza o produto
	REPLACE INTO ks_desenv.tbProdutos (
										Codigo, 
										Distribuidora, 
										GTIN, 
										Marca, 
										Modelo, 
										Grupo, 
										SubGrupo, 
										Descricao, 
										DescricaoComplementar, 
										Unidade, 
										Tributacao,
										ClassificacaoFiscal, 
										SituacaoTributaria, 
										AliquotaICMS, 
										ReducaoICMS, 
										CST_PIS, 
										AliquotaPIS, 
										CST_COFINS, 
										AliquotaCOFINS, 
										CST_IPI, 
										AliquotaIPI, 
										CFOP_1, 
										Peso, 
										PrecoVendaTabela, 
										PrecoCompraTabela, 
										PrecoCompra, 
										SetorLaranja, 
										PrecoCheio, 
										CampoPesquisa, 
										`Status`, 
										Inclusao, 
										Alteracao, 
										Usuario
									)(
										SELECT 
											pro.Codigo, 
											pro.Distribuidora, 
											pro.GTIN, 
											linha.Linha Marca,
											colecao.Colecao Modelo,
											pro.Grupo, 
											pro.GrupoCategoria SubGrupo, 
											pro.Descricao, 
											pro.DescricaoComplementar, 
											pro.Unidade, 
											'Produto' Tributacao,
											pro.NCM ClassificacaoFiscal, 
											CONCAT(pro.Origem,pro.CST_ICMS) SituacaoTributaria, 
											pro.AliquotaICMS, 
											pro.ReducaoICMS, 
											pro.CST_PIS, 
											pro.AliquotaPIS, 
											pro.CST_COFINS, 
											pro.AliquotaCOFINS, 
											pro.CST_IPI, 
											pro.AliquotaIPI, 
											pro.CFOP, 
											pro.Peso, 
											pro.PrecoVendaTabela, 
											pro.PrecoCompraTabela, 
											pro.PrecoCompra, 
											pro.SetorLaranja, 
											pro.PrecoCheio, 
											CONCAT(linha.Linha,' | ',colecao.Colecao,' | ',pro.Grupo,' | ',pro.GrupoCategoria,' - ', pro.Descricao,' (',pro.Codigo,') ',pro.Distribuidora) CampoPesquisa,
											pro.Status, 
											pro.Inclusao, 
											pro.Alteracao, 
											pro.Usuario
										FROM 
											produtos pro,
											produtos_linhas linha,
											produtos_colecao colecao
										WHERE
											pro.Linha = linha.Codigo
										AND
											pro.Colecao = colecao.Codigo
										AND
										   pro.Codigo = prmCodigo);
	

	OPEN c;
		SET fim_do_cursor = 0;
		
		WHILE fim_do_cursor = 0
		DO
			FETCH c INTO cod_filial, pct_fator, uf_estado, pct_icms;			
				IF fim_do_cursor = 0 THEN
				
					-- Pegao preco de Venda
					SET @PrecoVenda   := @PrecoVendaTabela;
					
					-- Se não for Setor Laranja - aplica o fator
				   IF @SetorLaranja  = 'N' THEN -- Se não for Setor Laranja
						SET @PrecoVenda := IF(pct_fator > 1, Round((pct_fator * @PrecoVendaTabela) + 0.5, 0), @PrecoVendaTabela);
					END IF;
					
					-- Verifica se existe TPEC para produto e Filial									   			
					SELECT COUNT(1) INTO @ContTPEC FROM ks_desenv.tbProdutosTPEC TPEC WHERE TPEC.Filial = cod_filial AND TPEC.Produto = prmCodigo;
					
					-- Se não existir - insere no TPC
					IF @ContTPEC = 0 THEN
						INSERT INTO ks_desenv.tbProdutosTPEC (
																			Filial, 
																			Produto, 
																			`Status`, 
																			PrecoVendaTabela, 
																			EstoqueDisponivel, 
																			CustoMedio, 
																			CustoUltimo, 
																			SituacaoTributaria, 
																			AliquotaICMS, 
																			ReducaoICMS, 
																			CST_PIS, 
																			AliquotaPIS, 
																			CST_COFINS, 
																			AliquotaCOFINS, 
																			CST_IPI, 
																			AliquotaIPI, 
																			CFOP_1, 
																			Flag_Atualizacao
																			) (
																				SELECT 
																					cod_filial, 
																					Codigo Produto, 
																					`Status`, 
																					@PrecoVenda PrecoVendaTabela, 
																					0 EstoqueDisponivel, 
																					@PrecoCompraTabela CustoMedio, 
																					@PrecoCompraTabela CustoUltimo, 
																					SituacaoTributaria, 
																					pct_icms AliquotaICMS, 
																					ReducaoICMS, 
																					CST_PIS, 
																					AliquotaPIS, 
																					CST_COFINS, 
																					AliquotaCOFINS, 
																					CST_IPI, 
																					AliquotaIPI, 
																					CFOP_1, 
																					'S' Flag_Atualizacao  
																				FROM 
																					ks_desenv.tbProdutos
																				WHERE 
																					Codigo = prmCodigo
																);
					ELSE											
						-- Insere na tabela TPEC_AUX para atualizacao do preco no PDV
						-- apenas se o valor de venda for diferente do anterior
						IF @PrecoVendaTabela <> @PrecoVendaTabelaAnterior then
							REPLACE INTO 
								ks_desenv.tbProdutosTPEC_Aux (
																		Filial, 
																		Produto, 
																		PrecoVendaTabela
																		) VALUES (
																		cod_filial,
																		prmCodigo,
																		@PrecoVenda
																		);
						END IF;
					
						UPDATE 
							ks_desenv.tbProdutosTPEC
						SET
							PrecoVendaTabela 	= @PrecoVenda,
							`Status` 			= @Sts,
							Flag_Atualizacao  = 'S'
						WHERE
							Filial  = cod_filial
						AND
						   Produto = prmCodigo;					   
					END IF;					
				END IF;
		END WHILE;
	CLOSE c;									   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_atualizar_agendamentos`(
	IN `numero_pedido` INT,
	IN `cd_pedido` INT
)
    COMMENT 'essa store proceducedure atualiza os dados da agenda  de um pedido do cd'
BEGIN
/*
	DECLARE agenda_id BIGINT(20);
	DECLARE agenda_fornecedor VARCHAR(20);
	DECLARE agenda_cd VARCHAR(20);
	DECLARE agenda_pedido VARCHAR(20);
	DECLARE agenda_DataPedido VARCHAR(20);
	DECLARE agenda_Referencia VARCHAR(20);	
	DECLARE agenda_CodFornecedor VARCHAR(20);	
	DECLARE agenda_DataEntrega VARCHAR(20);		
	DECLARE agenda_DataAgendamento VARCHAR(20);		
	DECLARE agenda_NF_numero VARCHAR(20);		
	DECLARE agenda_Volume VARCHAR(20);		
	DECLARE agenda_Qtde VARCHAR(20);	
	DECLARE agenda_Placa_Veiculo VARCHAR(20);	
	DECLARE agenda_Conferente VARCHAR(20);	
	DECLARE agenda_Recepcao VARCHAR(20);	
	DECLARE agenda_Situacao VARCHAR(20);
	DECLARE agenda_Inclusao VARCHAR(20);	
	DECLARE agenda_Alteracao VARCHAR(20);	
	DECLARE agenda_Usuario VARCHAR(20);
	DECLARE agenda_Posicao VARCHAR(20);
*/
	SET @QTDE_CARTAO := 0;
	SET @QTDE_ITENS := 0;
	
	SELECT
		COUNT(*)
	INTO
		@QTDE_CARTAO
	FROM
		compras_agenda
	WHERE
		Pedido= numero_pedido 
	AND   
		CD = cd_pedido;

	IF @QTDE_CARTAO = 0 THEN
				
			INSERT INTO
				compras_agenda
				(
					ID,
					Fornecedor, 
					CD, 
					Pedido, 
					DataPedido, 
					Referencia, 
					CodFornecedor, 
					DataEntrega, 
					DataAgendamento, 
					NF_numero, 
					Volume, 
					Qtde, 
					Placa_Veiculo, 
					Conferente, 
					Recepcao, 
					Situacao, 
					Inclusao, 
					Alteracao, 
					Usuario, 
					Posicao
				)(
					SELECT
							NULL, 
							compras.FornecedorCodigo,
							compras.CD,
							compras.Pedido,
							compras.DataPedido,
							compras.Referencia,
							produtos_cab.CodFornecedor,
							PrevisaoEntrega,
							null,
							0, 
							0, 
							0,
							'', 
							null, 
							'',
							1,
							compras.Inclusao,
							compras.Alteracao,
							compras.Usuario,
							0
					FROM
						compras
					INNER JOIN
						produtos_cab
					ON
						compras.Referencia = produtos_cab.Referencia
					WHERE 
						Pedido= numero_pedido AND   CD = cd_pedido
				);
				
				INSERT INTO
					compras_agenda_itens
				(
					ID, CompasAgendaID, Distribuidora, Quantidade, Tamanho, Cor, Descricao, Saldo
				)
				(
					SELECT 
						NULL,
						compras_agenda.ID,
						compras_itens.Distribuidora,
						compras_itens.Quantidade,
						produtos_cab_grade.Tamanho,
						produtos_cab_grade.Cor,
						produtos_cab_grade.Descricao, 
						compras_itens.Saldo
					FROM 
						compras_agenda
					INNER JOIN
						compras_itens
					ON
						compras_itens.Pedido = compras_agenda.Pedido
					And
						compras_itens.CD = compras_agenda.CD
					INNER join
						produtos_cab_grade
					on
						produtos_cab_grade.Distribuidora = compras_itens.Distribuidora
					WHERE 
						compras_agenda.Pedido= numero_pedido 
					AND   
						compras_agenda.CD = cd_pedido
					AND
						compras_itens.Saldo > 0
					
				);
			
			ELSE
				UPDATE
					compras_agenda
				INNER JOIN
					compras
				on
					compras_agenda.Pedido= compras.Pedido 
				AND     
					compras_agenda.CD = compras.CD
				SET
					compras_agenda.DataPedido  = compras.DataPedido, 
					compras_agenda.DataEntrega = compras.PrevisaoEntrega, 
					compras_agenda.Alteracao = compras.Alteracao, 
					compras_agenda.Usuario = compras.Usuario, 
					compras_agenda.Posicao = 0
				WHERE
					compras_agenda.Pedido= numero_pedido AND   compras_agenda.CD = cd_pedido;
					
			UPDATE 
				compras_agenda_itens
			INNER JOIN 
				compras_itens
			ON
				compras_agenda_itens.Distribuidora = compras_itens.Distribuidora
			SET
				compras_agenda_itens.Quantidade = compras_itens.Quantidade,
				compras_agenda_itens.Saldo = compras_itens.Saldo
			WHERE
				compras_itens.Pedido = numero_pedido 
			AND   
				compras_itens.CD = cd_pedido;
					
					
				
	END IF;

	
	
	/*
	DECLARE agenda_id BIGINT(20);
	DECLARE agenda_title VARCHAR(300);
	DECLARE agenda_description TEXT;
	DECLARE agenda_start_date DATE;
	DECLARE agenda_final_date DATE;
	DECLARE agenda_recurrence CHAR(1);
	DECLARE agenda_period CHAR(1);
	DECLARE agenda_category INT(11);
	DECLARE agenda_event_color VARCHAR(255);
	DECLARE agenda_cd INT;
	DECLARE agenda_numero_pedido INT;	
	DECLARE agenda_empresa INT;	
	DECLARE agenda_fornecedor CHAR(2);	
	DECLARE agenda_referencia VARCHAR(15);	
	DECLARE fim_do_loop INT DEFAULT 0;


	
	DECLARE
	 	c 
	CURSOR FOR
		 	SELECT
			(
				SELECT
				  	CONCAT(produtos_fornecedor.Codigo, ' - ', produtos_fornecedor.NomeFornecedor) 
				FROM
					produtos_fornecedor 
				WHERE 
					produtos_fornecedor.Codigo = LEFT(compras_itens.Referencia,2)
			),
			CONCAT('Pedido: ', numero_pedido, ' - ', compras_itens.Referencia),
			'N',
			'D',
			0,
			compras_itens.PrevisaoEntrega,
			compras_itens.PrevisaoEntrega,
			'#ff7f50',
			cd_pedido,
			numero_pedido,
			LEFT(compras_itens.Referencia,2),
			compras_itens.Referencia,
			compras.Empresa
		FROM
			compras_itens
		JOIN
			compras
		ON
			compras.CD  = compras_itens.CD
		AND
			compras.Pedido  = compras_itens.Pedido
		WHERE	
			compras_itens.CD = cd_pedido
		AND
			compras_itens.Pedido = numero_pedido
		AND
			compras_itens.Saldo >0
		GROUP BY compras_itens.PrevisaoEntrega;
																
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_do_loop = 1;
	
	DELETE FROM	
		compras_agenda 
	WHERE 
		CD = cd_pedido	
	AND 
		Pedido = numero_pedido
	AND 
		start_date >= CURRENT_DATE();
	
	OPEN c;
	
	
		
	WHILE(fim_do_loop <> 1) DO
		
		SELECT COALESCE(MAX(compras_agenda.id),0)+1 INTO agenda_id FROM compras_agenda;
		
		FETCH
			c
		INTO 
			agenda_title,
			agenda_description,
			agenda_recurrence,
			agenda_period,
			agenda_category,
			agenda_start_date,
			agenda_final_date, 
			agenda_event_color, 
			agenda_cd,
			agenda_numero_pedido,	
			agenda_fornecedor ,
			agenda_referencia,
			agenda_empresa ;
		
		SET @EXISTE_CONTROLE = 0;
		
		SELECT sf_existe_ctrl_entrega(agenda_cd, agenda_numero_pedido, agenda_start_date)	INTO	@EXISTE_CONTROLE;
		
		
		
		INSERT INTO
				compras_agenda
		(
				
				compras_agenda.title,
				compras_agenda.description,
				compras_agenda.recurrence,
				compras_agenda.period,
				compras_agenda.category,
				compras_agenda.start_date,
				compras_agenda.end_date,
				compras_agenda.event_color,
				compras_agenda.CD,
				compras_agenda.Pedido,
				compras_agenda.FornecedorCodigo,
				compras_agenda.Referencia,
				compras_agenda.Empresa
		)
		VALUES
		(
			agenda_title,
			agenda_description,
			agenda_recurrence,
			agenda_period,
			agenda_category,
			agenda_start_date,
			agenda_final_date, 
			IF(@EXISTE_CONTROLE = 0, agenda_event_color, '#5484ed'), 
			agenda_cd,
			agenda_numero_pedido,	
			agenda_fornecedor ,
			agenda_referencia,
			agenda_empresa
		);
	END WHILE;*/
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_atualizar_produtos_estoque_entrada`(
	IN `prmCD` INT,
	IN `prmEmpresa` INT,
	IN `prmProduto` VARCHAR(50),
	IN `prmReferencia` VARCHAR(50),
	IN `prmEstoque` DOUBLE,
	IN `prmValorUltimaCompra` DOUBLE,
	IN `prmDataUltimaCompra` DATE,
	IN `prmCustoUnitario` DOUBLE,
	IN `prmCustoMedio` DOUBLE
)
BEGIN
	REPLACE INTO produtos_estoque
	(
		CD, 
		Empresa, 
		Produto, 
		Referencia,  
		ValorUltimaCompra, 
		DataUltimaCompra,  
		CustoUnitario, 
		CustoMedio,
		Estoque
	)VALUES (
		prmCD, 
		prmEmpresa, 
		prmProduto, 
		prmReferencia,  
		prmValorUltimaCompra, 
		prmDataUltimaCompra,  
		prmCustoUnitario, 
		prmCustoMedio,
		prmEstoque
	);
	
	-- Atualiza a data da primeira compra
	UPDATE
		produtos_estoque
	SET
		DataPrimeiraCompra = DataUltimaCompra
	WHERE
		CD=prmCD 
	AND
		Empresa = prmEmpresa
	AND
		Produto= prmProduto
	AND
		DataPrimeiraCompra IS NULL;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_atualizar_seggroups_apps_dsitribuir_apps_para_usuarios`()
BEGIN
	/*DELETE FROM
		seggroups_apps 
	WHERE 
		app_name NOT IN (SELECT	segapps.app_name FROM segapps);

	REPLACE INTO 
		seggroups_apps(ordem, nivel, app_name, group_id)  
		(
			 SELECT
				 ordem, nivel, app_name, group_id
			FROM 
				seggroups,
				segapps
				
		);*/
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_atualizar_se_tem_foto`(
	IN `prmReferencia` VARCHAR(50),
	IN `prmTemFoto` INT
)
BEGIN
	UPDATE
		produtos_cab
	SET
		Foto= prmTemFoto
	WHERE
		Referencia = prmReferencia;
		
	UPDATE
		produtos_cab_grade
	SET
		Foto= prmTemFoto
	WHERE
		Referencia = prmReferencia;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_atualizar_valor_total_do_pedido`()
BEGIN
	UPDATE compras
	SET 
	ValorTotal = 0;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_atualiza_data_alteracao_produtos_cab`(
	IN `prmReferencia` VARCHAR(20)
)
BEGIN
	
	UPDATE produtos_cab SET Alteracao = NOW() WHERE Referencia = LEFT(prmReferencia,8);
	IF LENGTH(prmReferencia) > 8 THEN
			UPDATE produtos_cab_grade SET Alteracao = NOW() WHERE Distribuidora = prmReferencia;
		ELSE 
			UPDATE produtos_cab_grade SET Alteracao = NOW() WHERE LEFT(Distribuidora,8) = LEFT(prmReferencia,8);
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_config_contadores`(
	IN `inTabela` VARCHAR(60)
)
BEGIN
	-- Declara as variaveis
	SET @Contador 							= 0;
	
	-- Faz a Select Somando um no Contador
	SELECT 
		(tbcont.Contador + 1) 
	INTO 
		@Contador 
	FROM 
		configuracoes_contadores tbcont 
	WHERE 
		tbcont.Controle = inTabela;
		
	-- Atualiza o Contador 	
	UPDATE 
		configuracoes_contadores tbcont 
	SET 
		tbcont.Contador = @Contador 
	WHERE 
		tbcont.Controle = inTabela;
		
	-- Retorna o Contador
	SELECT @Contador;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_conta_corrente_contagem`(
	IN `prmIdCartao` INT
)
BEGIN
    DECLARE fim_do_loop INT;
    DECLARE MaxReg BIGINT(20);
    DECLARE RegCount BIGINT(20);
    DECLARE CD_ITEM BIGINT(20);
    DECLARE PEDIDO BIGINT(20);
    DECLARE EMPRESA_ITEM INT(11);
    DECLARE RESGISTRO_ITEM BIGINT(20);
    DECLARE PRODUTO_ITEM VARCHAR(20);
    DECLARE REFERENCIA_ITEM VARCHAR(20);
    DECLARE QTDE_ITEM DOUBLE;
    DECLARE SALDO_CONTA_CORRENTE_ITEM DOUBLE;
    DECLARE CUSTO_ULTIMO_ITEM DOUBLE;
    DECLARE PRECO_VENDA_ITEM DOUBLE;

    DECLARE TOTAL_CUSTO_MEDIO_ANTERIOR DOUBLE;
    DECLARE TOTAL_CUSTO_MEDIO_NOVO DOUBLE;
    DECLARE CUSTO_MEDIO_NOVO DOUBLE;

    -- Operação deve ser Entrada, Saída
    DECLARE c CURSOR FOR
        SELECT
            CCEI.Empresa,
            CCEI.CD,
            CCEI.Pedido,
            CCEI.Produto,
            CCEI.Distribuidora,
            COALESCE(CCEI.QtdeContagem, 0) AS QtdeContagem,  -- COALESCE aqui
            COALESCE(CCEI.ValorUnitario, 0) AS ValorUnitario, -- COALESCE aqui
            P.PrecoVendaTabela
        FROM
            vw_compras_contagem_itens_para_conta_corrente AS CCEI
        JOIN
            produtos AS P
        ON
            CCEI.Distribuidora = P.Distribuidora
        WHERE
            CCEI.idCartao = prmIdCartao;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_do_loop = 1;

    OPEN c;
        SET fim_do_loop = 0;
        loop_principal: LOOP
            FETCH c INTO EMPRESA_ITEM, CD_ITEM, PEDIDO, PRODUTO_ITEM,REFERENCIA_ITEM,QTDE_ITEM,CUSTO_ULTIMO_ITEM,PRECO_VENDA_ITEM;

            IF fim_do_loop = 1 THEN
                LEAVE loop_principal;
            END IF;

            SET MaxReg = 0;
            SET RegCount = 0;
            SELECT COALESCE(MAX(Registro),0) INTO MaxReg FROM produtos_conta_corrente WHERE Empresa = EMPRESA_ITEM AND CD = CD_ITEM AND Produto = PRODUTO_ITEM;
				SET @CustoUltimo = 0;

            SELECT
                COUNT(1),
                COALESCE(t1.SaldoContaCorrente,0),
                (COALESCE(t1.CustoMedio,0) * COALESCE(t1.SaldoContaCorrente,0)),
                COALESCE(t1.CustoUltimo, 0)
            INTO
                RegCount,
                SALDO_CONTA_CORRENTE_ITEM,
                TOTAL_CUSTO_MEDIO_ANTERIOR,
                @CustoUltimo
            FROM
                produtos_conta_corrente t1
            WHERE
                t1.Registro = MaxReg
            AND
                CD = CD_ITEM
            AND
                Produto = PRODUTO_ITEM;

				-- ultimo registro --
				SET @TOTAL_CustoAnterior     = (SALDO_CONTA_CORRENTE_ITEM * @CustoUltimo);
				
				-- novo registro
				SET @CUSTO_Atual          = CUSTO_ULTIMO_ITEM;
				SET @CUSTO_TOTAL_Atual    = (QTDE_ITEM * @CUSTO_Atual);
				
				-- CALCULO CUSTO MEDIO
				SET @TOTAL_GERAL_CUSTO    = @TOTAL_CustoAnterior + @CUSTO_TOTAL_Atual;
				SET @TOTAL_GERAL_QTDE     = SALDO_CONTA_CORRENTE_ITEM + QTDE_ITEM;
				
				SET CUSTO_MEDIO_NOVO     = (@TOTAL_GERAL_CUSTO / @TOTAL_GERAL_QTDE);

            -- Calcula o total do custo medio anterior
            -- SET TOTAL_CUSTO_MEDIO_NOVO = CUSTO_ULTIMO_ITEM * QTDE_ITEM;
            -- SET CUSTO_MEDIO_NOVO = IF((SALDO_CONTA_CORRENTE_ITEM + QTDE_ITEM) = 0,0,(TOTAL_CUSTO_MEDIO_NOVO + TOTAL_CUSTO_MEDIO_ANTERIOR )/(SALDO_CONTA_CORRENTE_ITEM + QTDE_ITEM));

            INSERT INTO produtos_conta_corrente (
                CD,
                Empresa,
                Registro,
                DataMov,
                Produto,
                Referencia,
                Operacao,
                Motivo,
                Quantidade,
                SaldoContaCorrente,
                CustoMedio,
                CustoUltimo,
                PrecoVenda
            ) VALUES (
                CD_ITEM,
                EMPRESA_ITEM,
                sf_criar_proximo_codigo_da_tabela(CD_ITEM, 'conta_corrente'),
                CURRENT_DATE(),
                PRODUTO_ITEM,
                REFERENCIA_ITEM,
                'Entrada',
                CONCAT('Pedido: ',PEDIDO,' Cartão: ', prmIdCartao),
                QTDE_ITEM,
                COALESCE(SALDO_CONTA_CORRENTE_ITEM, 0) + QTDE_ITEM,
                COALESCE(CUSTO_MEDIO_NOVO,0),
                CUSTO_ULTIMO_ITEM,
                PRECO_VENDA_ITEM
            );
			 CALL `sp_atualizar_produtos_estoque_entrada`(CD_ITEM, EMPRESA_ITEM, PRODUTO_ITEM, REFERENCIA_ITEM, COALESCE(SALDO_CONTA_CORRENTE_ITEM, 0) + QTDE_ITEM, CUSTO_ULTIMO_ITEM, CURRENT_DATE(), PRECO_VENDA_ITEM, CUSTO_MEDIO_NOVO);
        END LOOP loop_principal;
    CLOSE c;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_fechamentos_atualizar_saldo`(
	IN `prmIDFechamento` INT
)
BEGIN
	UPDATE 
		fechamento
	SET
		ValorTotalReceber=ValorFechamento+ProvisoriosDebitos+ProvisoriosCreditos+FechamentoCreditos+FechamentoDebitos
	WHERE 
		ID= prmIDFechamento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_fechamentos_atualizar_totais`(
	IN `prmIdDoFechamento` INT
)
BEGIN
	UPDATE
		fechamento
	LEFT JOIN 
		(
			SELECT
				COALESCE(SUM(TotalProvisorio),0) ttlPrvsr, 
				COALESCE(SUM(TotalCreditos),0) ttlCrdts, 
				COALESCE(SUM(TotalDebitos),0) ttlDbts, 
				COALESCE(SUM(TotalRomaneios),0) ttlRmns,
				COALESCE(SUM(TotalItens),0) ttlItns, 
				SUM(TotalPecas) ttlPcs,
				fechamento
			FROM 
				provisorios
			WHERE
				fechamento = prmIdDoFechamento
		) AS Prvsrs
	ON
		fechamento.ID = Prvsrs.Fechamento
	SET
		ProvisoriosTotal=COALESCE(ttlPrvsr,0),
		ProvisoriosCreditos=COALESCE(ttlCrdts,0),
		ProvisoriosDebitos=COALESCE(ttlDbts,0),
		ValorFechamento=COALESCE(ttlPrvsr,0),
		TotalRomaneios=COALESCE(ttlRmns,0),
		TotalItens=COALESCE(ttlItns,0),
		TotalPecas=COALESCE(ttlPcs,0)
	WHERE
		fechamento.ID =prmIdDoFechamento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_fechamentos_atualizar_totais_creditos`(
	IN `prmIdFechamento` INT
)
BEGIN
	UPDATE
		fechamento
	LEFT JOIN
		(
			SELECT
				fechamento_lancamentos.Fechamento,
				SUM(Valor) AS somaDeTodosCreditos
			FROM
				fechamento_lancamentos
			WHERE 
				Operacao= 'C'
			AND
				Fechamento=prmIdFechamento
		) AS lncmnts
	ON 
		fechamento.Id =	lncmnts.Fechamento
	SET
		fechamento.FechamentoCreditos =COALESCE(somaDeTodosCreditos,0)
	WHERE
		fechamento.Id = prmIdFechamento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_fechamentos_atualizar_totais_debitos`(
	IN `prmIdFechamento` INT
)
UPDATE
		fechamento
	LEFT JOIN
		(
			SELECT
				fechamento_lancamentos.Fechamento,
				SUM(Valor) AS somaDeTodosDebitos
			FROM
				fechamento_lancamentos
			WHERE 
				Operacao= 'D'
			AND
				fechamento=prmIdFechamento
		) AS lncmnts
	ON 
		fechamento.Id =	lncmnts.Fechamento
	SET
		fechamento.FechamentoDebitos =COALESCE( somaDeTodosDebitos,0)
	WHERE
		fechamento.Id = prmIdFechamento ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_inicial`(
	IN `prmCD` INT
)
BEGIN
   REPLACE INTO cests_ncm_api    							   SELECT prmCD,ncm FROM cests_ncm_api; 
   REPLACE INTO cfops_api    								      SELECT prmCD,ncm FROM cfops_api;					
   REPLACE INTO cidades_api    							      SELECT prmCD,ncm FROM cidades_api;					
   REPLACE INTO config_email_api    						   SELECT prmCD,ncm FROM config_email_api; 					
   REPLACE INTO consultores_api    						      SELECT prmCD,ncm FROM consultores_api;					
   REPLACE INTO empresas_api    							      SELECT prmCD,ncm FROM empresas_api;				
   REPLACE INTO empresas_cd_api    						      SELECT prmCD,ncm FROM empresas_cd_api;				
   REPLACE INTO estados_api    							      SELECT prmCD,ncm FROM estados_api;				
   REPLACE INTO franqueados_api    						      SELECT prmCD,ncm FROM franqueados_api;				
   REPLACE INTO ibge_api    								      SELECT prmCD,ncm FROM ibge_api;				
   REPLACE INTO produtos_api    							      SELECT prmCD,ncm FROM produtos_api;				
   REPLACE INTO produtos_barras_api    					   SELECT prmCD,ncm FROM produtos_barras_api;				
   REPLACE INTO produtos_caracteristicas_api    			SELECT prmCD,ncm FROM produtos_caracteristicas_api;
   REPLACE INTO produtos_categoria_caracteristicas_api   SELECT prmCD,ncm FROM produtos_categoria_caracteristicas_api;
   REPLACE INTO produtos_categoria_composicao_api    		SELECT prmCD,ncm FROM produtos_categoria_composicao_api;
   REPLACE INTO produtos_categorias_api    				   SELECT prmCD,ncm FROM produtos_categorias_api;
   REPLACE INTO produtos_categorias_livre_api    			SELECT prmCD,ncm FROM produtos_categorias_livre_api;
   REPLACE INTO produtos_colecao_api    					   SELECT prmCD,ncm FROM produtos_colecao_api;
   REPLACE INTO produtos_composicoes_api    				   SELECT prmCD,ncm FROM produtos_composicoes_api;
   REPLACE INTO produtos_cor_api    						   SELECT prmCD,ncm FROM produtos_cor_api;
   REPLACE INTO produtos_fornecedor_api    				   SELECT prmCD,ncm FROM produtos_fornecedor_api;
   REPLACE INTO produtos_generos_api    				      SELECT prmCD,ncm FROM produtos_generos_api;
   REPLACE INTO produtos_grupos_api    					   SELECT prmCD,ncm FROM produtos_grupos_api;
   REPLACE INTO produtos_grupos_livre_api    				SELECT prmCD,ncm FROM produtos_grupos_livre_api;
   REPLACE INTO produtos_linhas_api    					   SELECT prmCD,ncm FROM produtos_linhas_api;
   REPLACE INTO produtos_local_fisico_api    				SELECT prmCD,ncm FROM produtos_local_fisico_api;
   REPLACE INTO produtos_medidas_api    					   SELECT prmCD,ncm FROM produtos_medidas_api;
   REPLACE INTO produtos_tamanho_api    					   SELECT prmCD,ncm FROM produtos_tamanho_api;
   REPLACE INTO ramo_atividades_api    					   SELECT prmCD,ncm FROM ramo_atividades_api;
   REPLACE INTO regioes_api    							      SELECT prmCD,ncm FROM regioes_api;
   REPLACE INTO responsaveis_api    						   SELECT prmCD,ncm FROM responsaveis_api;
   REPLACE INTO responsaveis_entrega_api    				   SELECT prmCD,ncm FROM responsaveis_entrega_api;
   REPLACE INTO responsaveis_tributos_api    				SELECT prmCD,ncm FROM responsaveis_tributos_api;
   REPLACE INTO romaneios_api    							   SELECT prmCD,ncm FROM romaneios_api;
   REPLACE INTO st_cofins_api    							   SELECT prmCD,ncm FROM st_cofins_api;
   REPLACE INTO st_icms_api    							      SELECT prmCD,ncm FROM st_icms_api;
   REPLACE INTO st_ipi_api    								   SELECT prmCD,ncm FROM st_ipi_api;
   REPLACE INTO st_origem_api    							   SELECT prmCD,ncm FROM st_origem_api;
   REPLACE INTO st_pis_api    								   SELECT prmCD,ncm FROM st_pis_api;
   REPLACE INTO transportadoras_api    					   SELECT prmCD,ncm FROM transportadoras_api;
   REPLACE INTO veiculos_api    							      SELECT prmCD,ncm FROM veiculos_api;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_mover_compras_agenda_para_hst`(
	IN `prmId` INT
)
BEGIN
	
	SET @ID_CONTAGEM := (SELECT id FROM compras_contagem WHERE idCartao = prmId);
	
	

	INSERT INTO
		compras_agenda_hst
	(
		SELECT
			*
		FROM
			compras_agenda
		WHERE
			ID = prmId
	);
	
		INSERT INTO
		compras_agenda_itens_hst
	(
		SELECT
			*
		FROM
			compras_agenda_itens
		WHERE
			compras_agenda_itens.CompasAgendaID = prmId
	);
	
	
	
	CALL sp_mover_compras_recontagem_para_hst(@ID_CONTAGEM );
	
	CALL sp_mover_compras_contagem_para_hst(@ID_CONTAGEM );
	
	DELETE FROM compras_agenda WHERE ID = prmId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_mover_compras_contagem_para_hst`(
	IN `prmId` INT
)
BEGIN
	INSERT INTO
		compras_contagem_hst
	(
		SELECT
			*
		FROM
			compras_contagem
		WHERE
			id = prmId
	);
	
	INSERT INTO
		compras_contagem_itens_hst
	(
		SELECT
			*
		FROM
			compras_contagem_itens
		WHERE
			idComprasContagem = prmId
	);
	
	DELETE FROM compras_contagem WHERE id = prmId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_mover_compras_recontagem_para_hst`(
	IN `prmIdContagem` INT
)
BEGIN
	INSERT INTO
		compras_recontagem_hst
	(
		SELECT
			*
		FROM
			compras_recontagem
		WHERE 
			IDContagem = prmIdContagem
	);
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_novo_registro_compras_agenda`(
	IN `fornecedor_do_pedido` CHAR(2),
	IN `data_de_entrega_pedido` DATE,
	IN `cd_do_pedido` INT,
	IN `numero_do_pedido` INT,
	IN `referencia_do_pedido` CHAR(8),
	IN `prmEmpresa` INT
)
BEGIN
	/*SET @Qtd = 0;
	
	SET @Proximo_Codigo :=0;
	
	SELECT
		COUNT(1)
	INTO
		@Qtd
	FROM
		compras_agenda
	WHERE 
		compras_agenda.FornecedorCodigo = fornecedor_do_pedido
	AND 
		compras_agenda.start_date = data_de_entrega_pedido
	AND
		compras_agenda.Pedido = numero_do_pedido
	AND
	 	compras_agenda.CD = cd_do_pedido;
	 	
	IF @Qtd = 0 THEN
		SELECT 
			COALESCE(MAX(id),0) +1
		INTO
		 	@Proximo_Codigo
		FROM 
			compras_agenda;
			
			
		INSERT INTO
			compras_agenda
		(
			
			compras_agenda.title,
			compras_agenda.description,
			compras_agenda.recurrence,
			compras_agenda.period,
			compras_agenda.category,
			compras_agenda.start_date,
			compras_agenda.end_date,
			compras_agenda.event_color,
			compras_agenda.CD,
			compras_agenda.Pedido,
			compras_agenda.FornecedorCodigo,
			compras_agenda.Referencia,
			compras_agenda.Empresa
		)
		VALUES
		(
			
			(SELECT CONCAT(produtos_fornecedor.Codigo, ' - ', produtos_fornecedor.NomeFornecedor) FROM produtos_fornecedor WHERE produtos_fornecedor.Codigo = fornecedor_do_pedido),
			CONCAT('Pedido: ', numero_do_pedido, ' - ', referencia_do_pedido),
			'N',
			'D',
			0,
			data_de_entrega_pedido,
			data_de_entrega_pedido,
			'#ff7f50',
			cd_do_pedido,
			numero_do_pedido,
			fornecedor_do_pedido,
			referencia_do_pedido,
			prmEmpresa
		);
		
	END IF;*/
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_pre_cadastro2hst`(
	IN `codigoDoPreCadastro` INT
)
    COMMENT 'quando finalizar o processo do pre cadastro, ou seja na consolidacao de compras - no pre cadastro, essa procedure vai copiar para as tabelas pre_cadastro_hst  e  pre_cadastro_itens_hst o pre cadastro, e apagar o regisro da tabela'
BEGIN
	/*removendo o registro do historico*/
	DELETE FROM pre_cadastro_hst WHERE 	Codigo = codigoDoPreCadastro;
	DELETE FROM pre_cadastro_itens_hst WHERE 	Codigo = codigoDoPreCadastro;

/* INSERIR no CAB do Historico os dados desse codigo */
	INSERT INTO
	 pre_cadastro_hst
	SELECT 
		*
	FROM 
		pre_cadastro
	WHERE
		Codigo = codigoDoPreCadastro;

	UPDATE pre_cadastro_hst
	SET
		situacao = 99
	WHERE
		Codigo = codigoDoPreCadastro;


/* INSERIR na grade do Historico os dados desse codigo */
	INSERT INTO
	 	pre_cadastro_itens_hst
	SELECT 
		*
	FROM 
		pre_cadastro_itens
	WHERE
		PreCadastro = codigoDoPreCadastro;
	
	/*removendo o registro do pre cadastro*/
	DELETE FROM pre_cadastro WHERE 	Codigo = codigoDoPreCadastro;
	DELETE FROM pre_cadastro_itens WHERE 	Codigo = codigoDoPreCadastro;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_provisorios_atualizar_saldo`(
	IN `prmIdProvisorio` INT
)
BEGIN
	UPDATE
		provisorios
	SET
		TotalSaldo=provisorios.TotalProvisorio + provisorios.TotalDebitos + provisorios.TotalCreditos
	WHERE 
		Id = prmIdProvisorio;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_provisorios_atualizar_totais`(
	IN `prmIdProvisorio` INT
)
BEGIN
	UPDATE
		 provisorios
	INNER JOIN
		(
			SELECT 
				IdProvisorio,
				romaneios_cab.Cliente,
				SUM(romaneios_cab.ValorPedido) AS totalValores,
				SUM(TotalQuantidade) AS totalQuantidades,
				SUM(TotalItens) AS totaisItens, 
				COUNT(*) AS qtdtTotalRomaneios 
			FROM 
				romaneios_cab 
			GROUP BY romaneios_cab.IdProvisorio
		) AS t0
	ON
			provisorios.Id = t0.IdProvisorio
	SET
		provisorios.TotalProvisorio = t0.totalValores,
		provisorios.TotalRomaneios = t0.qtdtTotalRomaneios,
		provisorios.TotalItens = t0.totaisItens,
		provisorios.TotalPecas = t0.totalQuantidades
	WHERE 
		provisorios.Id = prmIdProvisorio;
	
	CALL sp_provisorios_atualizar_saldo(prmIdProvisorio);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_provisorios_atualizar_totais_creditos`(
	IN `prmIdProvisorio` INT
)
BEGIN

	UPDATE
		provisorios
	LEFT JOIN
		(
			SELECT
				provisorios_lancamentos.Provisorio,
				SUM(Valor) AS somaDeTodosCreditos
			FROM
				provisorios_lancamentos
			WHERE 
				Operacao= 'C'
			AND
				Provisorio=prmIdProvisorio
		) AS lncmnts
	ON 
		provisorios.Id =	Provisorio
	SET
		provisorios.TotalCreditos =somaDeTodosCreditos
	WHERE
		provisorios.Id = prmIdProvisorio;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_provisorios_atualizar_totais_debitos`(
	IN `prmIdProvisorio` INT
)
BEGIN

	UPDATE
		provisorios
	LEFT JOIN
		(
			SELECT
				provisorios_lancamentos.Provisorio,
				SUM(Valor) AS somaDeTodosDebitos
			FROM
				provisorios_lancamentos
			WHERE 
				Operacao= 'D'
			AND
				Provisorio=prmIdProvisorio
		) AS lncmnts
	ON 
		provisorios.Id =	Provisorio
	SET
		provisorios.TotalDebitos =somaDeTodosDebitos
	WHERE
		provisorios.Id = prmIdProvisorio;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_somarNoItem`(
	IN `prmQtdeBipar` INT,
	IN `prmId` INT,
	IN `prmReferenciaBipar` VARCHAR(12)
)
BEGIN
	UPDATE 
		compras_contagem_itens
	SET
		QtdeContagem=(QtdeContagem + prmQtdeBipar), 
		Saldo = Qtde - QtdeContagem
 	WHERE 
 		idComprasContagem = prmId 
 	AND
		Referencia =prmReferenciaBipar;

	UPDATE 
		compras_contagem 
	SET 
		TotalContagem = (SELECT SUM(QtdeContagem) FROM compras_contagem_itens WHERE idComprasContagem = prmId)
	WHERE
		ID = prmId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`allopdevel`@`%` PROCEDURE `sp_teste`(
	IN `prmIdCartao` INT
)
BEGIN
    DECLARE fim_do_loop INT DEFAULT 0; -- Inicialização direta
    DECLARE MaxReg BIGINT(20);
    DECLARE RegCount BIGINT(20);

    DECLARE CD_ITEM BIGINT(20);
    DECLARE PEDIDO BIGINT(20);
    DECLARE EMPRESA_ITEM INT(11);
    DECLARE PRODUTO_ITEM VARCHAR(20);
    DECLARE REFERENCIA_ITEM VARCHAR(20);
    DECLARE QTDE_ITEM DOUBLE;
    DECLARE SALDO_CONTA_CORRENTE_ITEM DOUBLE;
    DECLARE CUSTO_ULTIMO_ITEM DOUBLE;
    DECLARE PRECO_VENDA_ITEM DOUBLE;

    DECLARE TOTAL_CUSTO_MEDIO_ANTERIOR DOUBLE;
    DECLARE TOTAL_CUSTO_MEDIO_NOVO DOUBLE;
    DECLARE CUSTO_MEDIO_NOVO DOUBLE;

    -- Operação deve ser Entrada, Saída
    DECLARE c CURSOR FOR
        SELECT
            CCEI.Empresa,
            CCEI.CD,
            CCEI.Pedido,
            CCEI.Produto,
            CCEI.Distribuidora,
            CCEI.QtdeContagem,
            CCEI.ValorTotal,
            P.PrecoVendaTabela
        FROM
            vw_compras_contagem_itens_para_conta_corrente AS CCEI
        JOIN
            produtos AS P
        ON
            CCEI.Distribuidora = P.Distribuidora
        WHERE
            CCEI.idCartao = prmIdCartao;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_do_loop = 1;

    OPEN c;

    read_loop: LOOP -- Nomeando o loop para melhor clareza
        FETCH c INTO EMPRESA_ITEM, CD_ITEM, PEDIDO, PRODUTO_ITEM, REFERENCIA_ITEM, QTDE_ITEM, CUSTO_ULTIMO_ITEM, PRECO_VENDA_ITEM;

        IF fim_do_loop = 1 THEN
            LEAVE read_loop; -- Sai do loop quando o cursor termina
        END IF;

        IF QTDE_ITEM > 0 THEN
            SELECT COALESCE(MAX(Registro), 0) INTO MaxReg FROM produtos_conta_corrente WHERE CD = CD_ITEM AND Produto = PRODUTO_ITEM;

            SELECT
                COUNT(1),
                COALESCE(t1.SaldoContaCorrente, 0),
                (COALESCE(t1.CustoMedio, 0) * COALESCE(t1.SaldoContaCorrente, 0))
            INTO
                RegCount,
                SALDO_CONTA_CORRENTE_ITEM,
                TOTAL_CUSTO_MEDIO_ANTERIOR
            FROM
                produtos_conta_corrente t1
            WHERE
                t1.Registro = MaxReg
            AND
                CD = CD_ITEM
            AND
                Produto = PRODUTO_ITEM;

            SET TOTAL_CUSTO_MEDIO_NOVO = CUSTO_ULTIMO_ITEM * QTDE_ITEM;
            SET CUSTO_MEDIO_NOVO = (TOTAL_CUSTO_MEDIO_NOVO + TOTAL_CUSTO_MEDIO_ANTERIOR) / (SALDO_CONTA_CORRENTE_ITEM + QTDE_ITEM);

            INSERT INTO produtos_conta_corrente (
                CD,
                Empresa,
                Registro,
                DataMov,
                Produto,
                Referencia,
                Operacao,
                Motivo,
                Quantidade,
                SaldoContaCorrente,
                CustoMedio,
                CustoUltimo,
                PrecoVenda
            ) VALUES (
                CD_ITEM,
                EMPRESA_ITEM,
                sf_criar_proximo_codigo_da_tabela(CD_ITEM, 'conta_corrente'),
                CURRENT_DATE(),
                PRODUTO_ITEM,
                REFERENCIA_ITEM,
                'Entrada',
                CONCAT('Pedido: ', PEDIDO, ' Cartão: ', prmIdCartao),
                QTDE_ITEM,
                COALESCE(SALDO_CONTA_CORRENTE_ITEM, 0) + QTDE_ITEM,
                CUSTO_MEDIO_NOVO,
                CUSTO_ULTIMO_ITEM,
                PRECO_VENDA_ITEM
            );
        END IF;
    END LOOP read_loop; -- Fechando o loop nomeado

    CLOSE c;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `produtos_referencias_vw`
--

/*!50001 DROP VIEW IF EXISTS `produtos_referencias_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `produtos_referencias_vw` AS select left(`produtos`.`Distribuidora`,8) AS `Referencia`,`produtos`.`Distribuidora` AS `Distribuidora`,`produtos`.`PrecoVendaTabela` AS `PrecoVendaTabela`,`produtos`.`PrecoCompraTabela` AS `PrecoCompraTabela`,`produtos`.`PrecoCheio` AS `PrecoCheio`,`produtos`.`Codigo` AS `Codigo`,`produtos`.`Descricao` AS `Descricao` from `produtos` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `produtos_vw_grid`
--

/*!50001 DROP VIEW IF EXISTS `produtos_vw_grid`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `produtos_vw_grid` AS select `cab`.`Referencia` AS `Referencia`,`cab`.`Fornecedor` AS `Fornecedor`,`cab`.`CodFornecedor` AS `CodFornecedor`,`cab`.`CodFornecedorR3` AS `CodFornecedorR3`,`cab`.`Categoria` AS `Categoria`,`cab`.`Status` AS `Status`,`cab`.`Usuario` AS `Usuario`,`cab`.`Consolidado` AS `Consolidado`,concat(`cab`.`Descricao`,' // ',`cab`.`DescricaoComplementar`) AS `DescricaoCompleta`,`r1`.`NomeFornecedor` AS `NomeFornecedor`,`cab`.`Encomenda` AS `Encomenda`,`r2`.`TipoProduto` AS `TipoProduto`,`cab`.`Foto` AS `Foto`,`cab`.`Estilo` AS `Estilo` from ((`produtos_cab` `cab` join `produtos_fornecedor` `r1` on((`cab`.`Fornecedor` = `r1`.`Codigo`))) join `produtos_categorias` `r2` on((`cab`.`Categoria` = `r2`.`Codigo`))) order by `cab`.`Alteracao` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `produtos_vw_saida`
--

/*!50001 DROP VIEW IF EXISTS `produtos_vw_saida`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `produtos_vw_saida` AS select `produtos_vw_tudo`.`Codigo` AS `Codigo`,`produtos_vw_tudo`.`GTIN` AS `GTIN`,`produtos_vw_tudo`.`CodigoAlternativo` AS `CodigoAlternativo`,`produtos_vw_tudo`.`Distribuidora` AS `Distribuidora`,`produtos_vw_tudo`.`Fornecedor` AS `Fornecedor`,`produtos_vw_tudo`.`NomeFornecedor` AS `NomeFornecedor`,`produtos_vw_tudo`.`CodFornecedor` AS `CodFornecedor`,`produtos_vw_tudo`.`CodFornecedorR3` AS `CodFornecedorR3`,`produtos_vw_tudo`.`Descricao` AS `Descricao`,`produtos_vw_tudo`.`DescricaoComplementar` AS `DescricaoComplementar`,`produtos_vw_tudo`.`Caracteristica` AS `Caracteristica`,`produtos_vw_tudo`.`Composicao` AS `Composicao`,`produtos_vw_tudo`.`Unidade` AS `Unidade`,`produtos_vw_tudo`.`Cor` AS `Cor`,`produtos_vw_tudo`.`NomeCor` AS `NomeCor`,`produtos_vw_tudo`.`Foto` AS `Foto`,`produtos_vw_tudo`.`Linha` AS `Linha`,`produtos_vw_tudo`.`Colecao` AS `Colecao`,`produtos_vw_tudo`.`Categoria` AS `Categoria`,`produtos_vw_tudo`.`Genero` AS `Genero`,`produtos_vw_tudo`.`Grupo` AS `Grupo`,`produtos_vw_tudo`.`GrupoCategoria` AS `GrupoCategoria`,`produtos_vw_tudo`.`Tamanho` AS `Tamanho`,`produtos_vw_tudo`.`Fashion` AS `Fashion`,`produtos_vw_tudo`.`Estilo` AS `Estilo`,`produtos_vw_tudo`.`NCM` AS `NCM`,`produtos_vw_tudo`.`CST_ICMS` AS `CST_ICMS`,`produtos_vw_tudo`.`AliquotaICMS` AS `AliquotaICMS`,`produtos_vw_tudo`.`ReducaoICMS` AS `ReducaoICMS`,`produtos_vw_tudo`.`CST_PIS` AS `CST_PIS`,`produtos_vw_tudo`.`AliquotaPIS` AS `AliquotaPIS`,`produtos_vw_tudo`.`CST_COFINS` AS `CST_COFINS`,`produtos_vw_tudo`.`AliquotaCOFINS` AS `AliquotaCOFINS`,`produtos_vw_tudo`.`CST_IPI` AS `CST_IPI`,`produtos_vw_tudo`.`AliquotaIPI` AS `AliquotaIPI`,`produtos_vw_tudo`.`CFOP` AS `CFOP`,`produtos_vw_tudo`.`CFOP_ProducaoProria` AS `CFOP_ProducaoProria`,`produtos_vw_tudo`.`Origem` AS `Origem`,`produtos_vw_tudo`.`PrecoVendaTabela` AS `PrecoVendaTabela`,`produtos_vw_tudo`.`PrecoCompraTabela` AS `PrecoCompraTabela`,`produtos_vw_tudo`.`PrecoCompra` AS `PrecoCompra`,`produtos_vw_tudo`.`PrecoCheio` AS `PrecoCheio`,`produtos_vw_tudo`.`SetorLaranja` AS `SetorLaranja`,`produtos_vw_tudo`.`Encomenda` AS `Encomenda`,`produtos_vw_tudo`.`Status` AS `Status`,`produtos_vw_tudo`.`Usuario` AS `Usuario`,`produtos_vw_tudo`.`Peso` AS `Peso`,`r`.`Quantidade` AS `Quantidade`,`r`.`ValorTotal` AS `ValorTotal`,`r`.`Data_Romaneio` AS `Data_Romaneio`,`r`.`Filial` AS `Filial`,`r`.`Romaneio` AS `Romaneio`,`r`.`Sequencia` AS `Sequencia` from (`allop_devel`.`produtos_vw_tudo` join (select `gcom_kidstok`.`tbRomaneios_Ite`.`Produto` AS `Produto`,`gcom_kidstok`.`tbRomaneios_Ite`.`Quantidade` AS `Quantidade`,`gcom_kidstok`.`tbRomaneios_Ite`.`ValorTotal` AS `ValorTotal`,`gcom_kidstok`.`tbRomaneios_Ite`.`Data_Romaneio` AS `Data_Romaneio`,`gcom_kidstok`.`tbRomaneios_Ite`.`Filial` AS `Filial`,`gcom_kidstok`.`tbRomaneios_Ite`.`Romaneio` AS `Romaneio`,`gcom_kidstok`.`tbRomaneios_Ite`.`Sequencia` AS `Sequencia` from `gcom_kidstok`.`tbRomaneios_Ite` union all select `gcom_kidstok`.`tbRomaneios_Ite_H`.`Produto` AS `Produto`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`Quantidade` AS `Quantidade`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`ValorTotal` AS `ValorTotal`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`Data_Romaneio` AS `Data_Romaneio`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`Filial` AS `Filial`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`Romaneio` AS `Romaneio`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`Sequencia` AS `Sequencia` from `gcom_kidstok`.`tbRomaneios_Ite_H`) `r` on((`produtos_vw_tudo`.`Codigo` = `r`.`Produto`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `produtos_vw_tudo`
--

/*!50001 DROP VIEW IF EXISTS `produtos_vw_tudo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `produtos_vw_tudo` AS select `p`.`Codigo` AS `Codigo`,`p`.`GTIN` AS `GTIN`,`p`.`CodigoAlternativo` AS `CodigoAlternativo`,`p`.`Distribuidora` AS `Distribuidora`,`p`.`Fornecedor` AS `Fornecedor`,`f`.`NomeFornecedor` AS `NomeFornecedor`,`p`.`CodFornecedor` AS `CodFornecedor`,`p`.`CodFornecedorR3` AS `CodFornecedorR3`,`p`.`Descricao` AS `Descricao`,`p`.`DescricaoComplementar` AS `DescricaoComplementar`,`car`.`Caracteristica` AS `Caracteristica`,`comp`.`Composicao` AS `Composicao`,`p`.`Unidade` AS `Unidade`,`p`.`Cor` AS `Cor`,`cor`.`Nome` AS `NomeCor`,`p`.`Foto` AS `Foto`,`l`.`Linha` AS `Linha`,`c`.`Colecao` AS `Colecao`,`cat`.`TipoProduto` AS `Categoria`,`gen`.`Genero` AS `Genero`,`p`.`Grupo` AS `Grupo`,`p`.`GrupoCategoria` AS `GrupoCategoria`,`t`.`Nome` AS `Tamanho`,`p`.`Fashion` AS `Fashion`,`p`.`Estilo` AS `Estilo`,`p`.`NCM` AS `NCM`,`p`.`CST_ICMS` AS `CST_ICMS`,`p`.`AliquotaICMS` AS `AliquotaICMS`,`p`.`ReducaoICMS` AS `ReducaoICMS`,`p`.`CST_PIS` AS `CST_PIS`,`p`.`AliquotaPIS` AS `AliquotaPIS`,`p`.`CST_COFINS` AS `CST_COFINS`,`p`.`AliquotaCOFINS` AS `AliquotaCOFINS`,`p`.`CST_IPI` AS `CST_IPI`,`p`.`AliquotaIPI` AS `AliquotaIPI`,`p`.`CFOP` AS `CFOP`,`p`.`CFOP_ProducaoProria` AS `CFOP_ProducaoProria`,`p`.`Origem` AS `Origem`,`p`.`PrecoVendaTabela` AS `PrecoVendaTabela`,`p`.`PrecoCompraTabela` AS `PrecoCompraTabela`,`p`.`PrecoCompra` AS `PrecoCompra`,`p`.`PrecoCheio` AS `PrecoCheio`,`p`.`SetorLaranja` AS `SetorLaranja`,`p`.`Encomenda` AS `Encomenda`,`p`.`Status` AS `Status`,`p`.`Inclusao` AS `Inclusao`,`p`.`Alteracao` AS `Alteracao`,`p`.`Usuario` AS `Usuario`,`p`.`Peso` AS `Peso` from (((((((((`produtos` `p` left join `produtos_linhas` `l` on((`p`.`Linha` = `l`.`Codigo`))) left join `produtos_colecao` `c` on((`p`.`Colecao` = `c`.`Codigo`))) left join `produtos_composicoes` `comp` on((`p`.`Composicao` = `comp`.`Codigo`))) left join `produtos_caracteristicas` `car` on((`p`.`Caracteristica` = `car`.`Codigo`))) left join `produtos_cor` `cor` on((`p`.`Cor` = `cor`.`Codigo`))) left join `produtos_generos` `gen` on((`p`.`Genero` = `gen`.`Codigo`))) join `produtos_fornecedor` `f` on((`p`.`Fornecedor` = `f`.`Codigo`))) left join `produtos_categorias` `cat` on((`p`.`Categoria` = `cat`.`Codigo`))) left join `produtos_tamanho` `t` on((`p`.`Tamanho` = `t`.`Codigo`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rmnUH`
--

/*!50001 DROP VIEW IF EXISTS `rmnUH`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `rmnUH` AS select `p`.`Codigo` AS `Codigo`,`p`.`GTIN` AS `GTIN`,`r`.`Quantidade` AS `Quantidade`,`r`.`ValorTotal` AS `ValorTotal`,`r`.`Data_Romaneio` AS `Data_Romaneio` from (`allop_devel`.`produtos_vw_tudo` `p` join (select `gcom_kidstok`.`tbRomaneios_Ite`.`Produto` AS `Produto`,`gcom_kidstok`.`tbRomaneios_Ite`.`Quantidade` AS `Quantidade`,`gcom_kidstok`.`tbRomaneios_Ite`.`ValorTotal` AS `ValorTotal`,`gcom_kidstok`.`tbRomaneios_Ite`.`Data_Romaneio` AS `Data_Romaneio` from `gcom_kidstok`.`tbRomaneios_Ite` union all select `gcom_kidstok`.`tbRomaneios_Ite_H`.`Produto` AS `Produto`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`Quantidade` AS `Quantidade`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`ValorTotal` AS `ValorTotal`,`gcom_kidstok`.`tbRomaneios_Ite_H`.`Data_Romaneio` AS `Data_Romaneio` from `gcom_kidstok`.`tbRomaneios_Ite_H`) `r` on((`p`.`Codigo` = `r`.`Produto`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_compras_contagem_itens_para_conta_corrente`
--

/*!50001 DROP VIEW IF EXISTS `vw_compras_contagem_itens_para_conta_corrente`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_compras_contagem_itens_para_conta_corrente` AS select `compras`.`CD` AS `CD`,`compras`.`Empresa` AS `Empresa`,`compras`.`Pedido` AS `Pedido`,`compras_itens`.`Produto` AS `Produto`,`compras_itens`.`Distribuidora` AS `Distribuidora`,`compras_itens`.`ValorUnitario` AS `ValorUnitario`,`compras_itens`.`ValorTotal` AS `ValorTotal`,`compras_agenda`.`ID` AS `idCartao`,`compras_contagem`.`id` AS `Contagem`,`compras_contagem_itens`.`Qtde` AS `Qtde`,`compras_contagem_itens`.`QtdeContagem` AS `QtdeContagem`,`compras_contagem_itens`.`AguardarSaldoRestante` AS `AguardarSaldoRestante`,`compras_contagem_itens`.`Saldo` AS `Saldo`,(select coalesce(max(`produtos_conta_corrente`.`Registro`),0) from `produtos_conta_corrente` where ((`produtos_conta_corrente`.`CD` = `compras_itens`.`CD`) and (`produtos_conta_corrente`.`Produto` = `compras_itens`.`Produto`))) AS `UltimoRegistro` from (((((`compras` join `compras_itens` on(((`compras`.`CD` = `compras_itens`.`CD`) and (`compras`.`Pedido` = `compras_itens`.`Pedido`)))) join `compras_agenda` on(((`compras_agenda`.`CD` = `compras_itens`.`CD`) and (`compras_agenda`.`Pedido` = `compras_itens`.`Pedido`)))) join `compras_agenda_itens` on((`compras_agenda`.`ID` = `compras_agenda_itens`.`CompasAgendaID`))) join `compras_contagem` on((`compras_contagem`.`idCartao` = `compras_agenda`.`ID`))) join `compras_contagem_itens` on(((`compras_contagem`.`id` = `compras_contagem_itens`.`idComprasContagem`) and (`compras_itens`.`Distribuidora` = convert(`compras_agenda_itens`.`Distribuidora` using utf8)) and (`compras_itens`.`Distribuidora` = convert(`compras_contagem_itens`.`Referencia` using utf8))))) where (`compras_contagem_itens`.`QtdeContagem` > 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_compras_pedidos_compras_relatorios_itens_atrasados`
--

/*!50001 DROP VIEW IF EXISTS `vw_compras_pedidos_compras_relatorios_itens_atrasados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_compras_pedidos_compras_relatorios_itens_atrasados` AS select `compras_itens`.`CD` AS `CD_detalhe`,`compras_itens`.`Pedido` AS `Pedido_detalhe`,`compras_itens`.`Produto` AS `Produto_detalhe`,`compras_itens`.`Sequencia` AS `Sequencia_detalhe`,`compras_itens`.`Distribuidora` AS `Distribuidora_detalhe`,`compras_itens`.`Referencia` AS `Referencia_detalhe`,`compras_itens`.`Quantidade` AS `Quantidade_detalhe`,`compras_itens`.`ValorUnitario` AS `ValorUnitario_detalhe`,`compras_itens`.`ValorTotal` AS `ValorTotal_detalhe`,`compras_itens`.`Entregue` AS `Entregue_detalhe`,`compras_itens`.`Saldo` AS `Saldo_detalhe`,`compras_itens`.`PrevisaoEntrega` AS `PrevisaoEntrega_detalhe`,`produtos`.`Fornecedor` AS `Fornecedor`,`produtos`.`Categoria` AS `Categoria`,`produtos`.`CodFornecedorR3` AS `CodFornecedorR3`,`produtos`.`Colecao` AS `Colecao`,`produtos`.`Linha` AS `Linha`,`produtos`.`Descricao` AS `Descricao`,`produtos`.`DescricaoComplementar` AS `DescricaoComplementar`,`produtos`.`Grupo` AS `Grupo`,`produtos`.`GrupoCategoria` AS `GrupoCategoria`,`produtos`.`Genero` AS `Genero`,`produtos`.`Composicao` AS `Composicao`,`produtos`.`Caracteristica` AS `Caracteristica`,`produtos`.`SetorLaranja` AS `SetorLaranja`,`produtos`.`PrecoCheio` AS `PrecoCheio`,`produtos`.`Encomenda` AS `Encomenda`,`produtos`.`Tamanho` AS `Tamanho`,`produtos`.`Cor` AS `Cor`,`produtos`.`Status` AS `Status`,`compras`.`DataPedido` AS `DataPedido`,`produtos`.`CodFornecedor` AS `CodFornecedor` from ((`compras_itens` join `compras` on((`compras`.`CD` = `compras_itens`.`CD`))) join `produtos` on((`compras_itens`.`Produto` = `produtos`.`Codigo`))) where ((`compras`.`Pedido` = `compras_itens`.`Pedido`) and (`compras_itens`.`Saldo` <> 0) and ((`compras_itens`.`PrevisaoEntrega` + interval 10 day) < curdate())) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_compras_pedidos_compras_relatorios_itens_comprados`
--

/*!50001 DROP VIEW IF EXISTS `vw_compras_pedidos_compras_relatorios_itens_comprados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_compras_pedidos_compras_relatorios_itens_comprados` AS select `compras_itens`.`CD` AS `CD_detalhe`,`compras_itens`.`Pedido` AS `Pedido_detalhe`,`compras_itens`.`Produto` AS `Produto_detalhe`,`compras_itens`.`Sequencia` AS `Sequencia_detalhe`,`compras_itens`.`Distribuidora` AS `Distribuidora_detalhe`,`compras_itens`.`Referencia` AS `Referencia_detalhe`,`compras_itens`.`Quantidade` AS `Quantidade_detalhe`,`compras_itens`.`ValorUnitario` AS `ValorUnitario_detalhe`,`compras_itens`.`ValorTotal` AS `ValorTotal_detalhe`,`compras_itens`.`Entregue` AS `Entregue_detalhe`,`compras_itens`.`Saldo` AS `Saldo_detalhe`,`compras_itens`.`PrevisaoEntrega` AS `PrevisaoEntrega_detalhe`,`produtos`.`Fornecedor` AS `Fornecedor`,`produtos`.`Categoria` AS `Categoria`,`produtos`.`CodFornecedorR3` AS `CodFornecedorR3`,`produtos`.`Colecao` AS `Colecao`,`produtos`.`Linha` AS `Linha`,`produtos`.`Descricao` AS `Descricao`,`produtos`.`DescricaoComplementar` AS `DescricaoComplementar`,`produtos`.`Grupo` AS `Grupo`,`produtos`.`GrupoCategoria` AS `GrupoCategoria`,`produtos`.`Genero` AS `Genero`,`produtos`.`Composicao` AS `Composicao`,`produtos`.`Caracteristica` AS `Caracteristica`,`produtos`.`SetorLaranja` AS `SetorLaranja`,`produtos`.`PrecoCheio` AS `PrecoCheio`,`produtos`.`Encomenda` AS `Encomenda`,`produtos`.`Tamanho` AS `Tamanho`,`produtos`.`Cor` AS `Cor`,`produtos`.`Status` AS `Status`,`compras`.`DataPedido` AS `DataPedido`,`produtos`.`CodFornecedor` AS `CodFornecedor`,`produtos`.`PrecoVendaTabela` AS `Varejo`,`produtos`.`Estilo` AS `Estilo` from ((`compras_itens` join `compras` on((`compras`.`CD` = `compras_itens`.`CD`))) join `produtos` on((`compras_itens`.`Produto` = `produtos`.`Codigo`))) where (`compras`.`Pedido` = `compras_itens`.`Pedido`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_produtos_fabrica`
--

/*!50001 DROP VIEW IF EXISTS `vw_produtos_fabrica`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`allopdevel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_produtos_fabrica` AS select `cab`.`Referencia` AS `Referencia`,`cab`.`Fornecedor` AS `Fornecedor`,`cab`.`CodFornecedor` AS `CodFornecedor`,`cab`.`CodFornecedorR3` AS `CodFornecedorR3`,`cab`.`Categoria` AS `Categoria`,`cab`.`Colecao` AS `Colecao`,`cab`.`Linha` AS `Linha`,`cab`.`Grupo` AS `Grupo`,`cab`.`GrupoCategoria` AS `GrupoCategoria`,`cab`.`Composicao` AS `Composicao`,`cab`.`Caracteristica` AS `Caracteristica`,`cab`.`Genero` AS `Genero`,`cab`.`Descricao` AS `Descricao`,`cab`.`DescricaoComplementar` AS `DescricaoComplementar`,`cab`.`Unidade` AS `Unidade`,`cab`.`Cor` AS `Cor`,`cab`.`Tamanho` AS `Tamanho`,`cab`.`NCM` AS `NCM`,`cab`.`CST_ICMS` AS `CST_ICMS`,`cab`.`Origem` AS `Origem`,`cab`.`AliquotaICMS` AS `AliquotaICMS`,`cab`.`ReducaoICMS` AS `ReducaoICMS`,`cab`.`CST_PIS` AS `CST_PIS`,`cab`.`AliquotaPIS` AS `AliquotaPIS`,`cab`.`CST_COFINS` AS `CST_COFINS`,`cab`.`AliquotaCOFINS` AS `AliquotaCOFINS`,`cab`.`CST_IPI` AS `CST_IPI`,`cab`.`AliquotaIPI` AS `AliquotaIPI`,`cab`.`CFOP` AS `CFOP`,`cab`.`Peso` AS `Peso`,`cab`.`PrecoCompra` AS `PrecoCompra`,`cab`.`PrecoCompraTabela` AS `PrecoCompraTabela`,`cab`.`PrecoVendaTabela` AS `PrecoVendaTabela`,`cab`.`SetorLaranja` AS `SetorLaranja`,`cab`.`PrecoCheio` AS `PrecoCheio`,`cab`.`Status` AS `Status`,`cab`.`Inclusao` AS `Inclusao`,`cab`.`Alteracao` AS `Alteracao`,`cab`.`Usuario` AS `Usuario`,`cab`.`Consolidado` AS `Consolidado`,concat(`cab`.`Descricao`,' // ',`cab`.`DescricaoComplementar`) AS `DescricaoCompleta`,`r1`.`NomeFornecedor` AS `NomeFornecedor`,`cab`.`Encomenda` AS `Encomenda`,`r2`.`TipoProduto` AS `TipoProduto`,`clc`.`Colecao` AS `nome_colecao`,`linha`.`Linha` AS `nome_linha`,`comp`.`Composicao` AS `nome_comp`,`carac`.`Caracteristica` AS `nome_carac`,`gnr`.`Genero` AS `nome_genero`,`gnr`.`Abreviado` AS `genero_abreviado`,`md`.`Unidade` AS `nome_unidade`,`cab`.`Foto` AS `Foto`,`cab`.`Estilo` AS `Estilo` from ((((((((`produtos_cab` `cab` join `produtos_fornecedor` `r1` on((`cab`.`Fornecedor` = `r1`.`Codigo`))) join `produtos_categorias` `r2` on((`cab`.`Categoria` = `r2`.`Codigo`))) join `produtos_colecao` `clc` on((`clc`.`Codigo` = `cab`.`Colecao`))) join `produtos_linhas` `linha` on((`linha`.`Codigo` = `cab`.`Linha`))) join `produtos_composicoes` `comp` on((`comp`.`Codigo` = `cab`.`Composicao`))) join `produtos_caracteristicas` `carac` on((`carac`.`Codigo` = `cab`.`Caracteristica`))) join `produtos_generos` `gnr` on((`gnr`.`Codigo` = `cab`.`Genero`))) join `produtos_medidas` `md` on((`md`.`Sigla` = `cab`.`Unidade`))) order by `cab`.`Descricao` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-21 17:06:44
