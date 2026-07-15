-- --------------------------------------------------------
-- Banco: allop_devel
-- Servidor MySQL: 5.7.35-log
-- Dump estrutural gerado pelo projeto Allop em 2026-07-15 13:00:01
-- Dados nao incluidos.
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- --------------------------------------------------------
-- Estrutura da tabela `KidStok`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `KidStokAntesGCom`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `bancos`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `bancos` (
  `codigoBanco` varchar(3) NOT NULL,
  `nome` varchar(200) NOT NULL,
  PRIMARY KEY (`codigoBanco`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `cargos`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cargos` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Cargo` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `cests_ncm`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cests_ncm` (
  `ncm` varchar(8) CHARACTER SET latin1 NOT NULL,
  `cest` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `descricao` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Status` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT 'Ativo',
  PRIMARY KEY (`ncm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `cests_ncm_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cests_ncm_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoNCM` varchar(8) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoNCM`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `cests_ncm_copy`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cests_ncm_copy` (
  `ncm` varchar(8) CHARACTER SET latin1 NOT NULL,
  `cest` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `descricao` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Status` varchar(8) CHARACTER SET latin1 NOT NULL DEFAULT 'Ativo',
  PRIMARY KEY (`ncm`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `cfops`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `cfops_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cfops_api` (
  `CodigoCD` int(11) NOT NULL,
  `CFOP` varchar(4) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CFOP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `cidades`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `cidades_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cidades_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoCidade` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoCidade`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `compras`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_agenda`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `compras_agenda_board`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras_agenda_board` (
  `brdid` int(11) NOT NULL AUTO_INCREMENT,
  `brdnome` varchar(50) DEFAULT NULL,
  `brdordem` int(11) NOT NULL,
  PRIMARY KEY (`brdid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `compras_agenda_docs`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_agenda_hst`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_agenda_itens`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `compras_agenda_itens_hst`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_contagem`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_contagem_hst`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_contagem_itens`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_contagem_itens_hst`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_hst`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_itens`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_itens_entrega`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_itens_hst`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_recontagem`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `compras_recontagem_hst`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `conferentes`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `conferentes` (
  `Codigo` int(11) NOT NULL,
  `Nome` varchar(40) NOT NULL,
  `Tipo` varchar(1) CHARACTER SET utf8 NOT NULL COMMENT 'E-entrada, S-saida',
  `Sts` varchar(8) CHARACTER SET utf8 NOT NULL DEFAULT 'Ativo' COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`),
  KEY `IDXNome` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `config_email`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `config_email_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `config_email_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoEmail` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoEmail`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `config_email_dest`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `config_email_dest` (
  `ContaEmail` int(11) NOT NULL,
  `DestinatarioEmail` varchar(120) NOT NULL DEFAULT '',
  `Status` varchar(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`ContaEmail`,`DestinatarioEmail`),
  CONSTRAINT `FK_config_email_dest_config_email` FOREIGN KEY (`ContaEmail`) REFERENCES `config_email` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabela de Destinatário de e-mails\r\n';

-- --------------------------------------------------------
-- Estrutura da tabela `config_geral`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `config_geral` (
  `TituloRelatorios` varchar(60) DEFAULT '',
  `LogoDefault` longblob,
  `ContaEmail` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `configuracoes_contadores`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `configuracoes_contadores` (
  `Controle` varchar(60) COLLATE latin1_general_ci NOT NULL,
  `Descricao` varchar(60) COLLATE latin1_general_ci DEFAULT NULL,
  `Contador` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`Controle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------
-- Estrutura da tabela `configuracoes_nfe`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `configuracoes_nfe` (
  `Empresa` int(11) NOT NULL,
  PRIMARY KEY (`Empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------
-- Estrutura da tabela `consultores`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `consultores_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `consultores_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoConsultor` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoConsultor`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `contador_registros`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `contador_registros` (
  `CD` int(11) NOT NULL DEFAULT '0',
  `TableName` varchar(120) NOT NULL,
  `Descricao` varchar(120) NOT NULL,
  `Contador` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`CD`,`TableName`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras`
-- --------------------------------------------------------
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_cp_compras_produtos_fornecedor` (`Fornecedor_id`),
  KEY `FK_cp_compras_empresas` (`empresa_id`),
  KEY `FK_cp_compras_empresas_cd` (`cd_id`) USING BTREE,
  KEY `FK_cp_compras_cp_compras_status` (`status_id`),
  CONSTRAINT `FK_cp_compras_cp_compras_status` FOREIGN KEY (`status_id`) REFERENCES `cp_compras_status` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_empresas` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_empresas_cd` FOREIGN KEY (`cd_id`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_cp_compras_produtos_fornecedor` FOREIGN KEY (`Fornecedor_id`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_emails`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_itens`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_itens_cores`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=4957 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_itens_cores_log`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_itens_log`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_itens_rateios`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cp_compras_itens_rateios` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id do registro',
  `compras_itens_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `cor` varchar(50) NOT NULL COMMENT 'Cor',
  `Percentual` double(8,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXitemCor` (`compras_itens_id`,`cor`),
  CONSTRAINT `FK_compras_itens_rateio_compras_itens` FOREIGN KEY (`compras_itens_id`) REFERENCES `cp_compras_itens` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_itens_tamanhos`
-- --------------------------------------------------------
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
  `Sts` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0-Inativo, 1-Ativo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDXItensTamanho` (`compras_itens_id`,`tamanho`) USING BTREE,
  CONSTRAINT `FK_cp_compras_itens_tamanhos_cp_compras_itens` FOREIGN KEY (`compras_itens_id`) REFERENCES `cp_compras_itens` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=latin1 COMMENT='Tabela de itens de tamanhos, separação de tamanhos.';

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_itens_tamanhos_log`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cp_compras_itens_tamanhos_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `compras_itens_tamanho_id` bigint(20) unsigned NOT NULL,
  `compras_itens_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'id do item',
  `tamanho` varchar(20) NOT NULL COMMENT 'tamanho do produto',
  `entrega` date NOT NULL COMMENT 'data de entrega',
  `entrega_anterior` date NOT NULL COMMENT 'data de entrega anterior',
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
) ENGINE=InnoDB AUTO_INCREMENT=589 DEFAULT CHARSET=latin1 COMMENT='Tabela de itens de tamanhos, separação de tamanhos.';

-- --------------------------------------------------------
-- Estrutura da tabela `cp_compras_status`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cp_compras_status` (
  `id` int(11) NOT NULL,
  `descricao_compras` varchar(120) NOT NULL DEFAULT '',
  `descricao_portal` varchar(120) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `empresas`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `empresas_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `empresas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoEmpresa`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `empresas_cd`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `empresas_cd` (
  `Codigo` int(11) NOT NULL,
  `NomeCD` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXNomeCD` (`NomeCD`),
  KEY `FK_empresas_cd_situacao` (`Status`),
  CONSTRAINT `FK_empresas_cd_situacao` FOREIGN KEY (`Status`) REFERENCES `situacao` (`StsNome`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `empresas_cd_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `empresas_cd_api` (
  `Codigo` int(11) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `entrada_de_mercadorias`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `entrada_de_mercadorias_itens`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `entrada_de_mercadorias_itens` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Referencia` varchar(50) DEFAULT NULL,
  `Quantidade` int(11) DEFAULT NULL,
  `fk_entrada_de_mercadorias` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Codigo`) USING BTREE,
  KEY `FK_entrada_de_mercadorias_itens_entrada_de_mercadorias` (`fk_entrada_de_mercadorias`),
  CONSTRAINT `FK_entrada_de_mercadorias_itens_entrada_de_mercadorias` FOREIGN KEY (`fk_entrada_de_mercadorias`) REFERENCES `entrada_de_mercadorias` (`Codigo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `estados`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `estados_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `estados_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoEstado` varchar(2) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoEstado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `etiquetas_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `etiquetas_api` (
  `CD` int(11) NOT NULL,
  `Lote` bigint(20) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `etiquetas_cab`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `etiquetas_ite`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `fechamento`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `fechamento_lancamentos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `financeiro_tipos_pagamento`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `franqueados`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `franqueados_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `franqueados_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoFranqueado` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoFranqueado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `franqueados_conta`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `franqueados_conta` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `Franqueado` int(11) NOT NULL,
  `Saldo` int(11) NOT NULL,
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `ibge`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `ibge_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibge_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoIBGE` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoIBGE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `log_scripts`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `logs`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=212471 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_cab`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_dest`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_det`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_det_icms_difal`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_det_impostos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_emit`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_ide`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_nfref`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `nfe_nfref` (
  `NFe` bigint(20) unsigned NOT NULL COMMENT 'ID - NFe',
  `refNFe` varchar(44) NOT NULL COMMENT 'Chave Nota Referenciada',
  PRIMARY KEY (`NFe`,`refNFe`) USING BTREE,
  CONSTRAINT `FK_nfe_nfref_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_pedidos_compra`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_total`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_transportadora`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `nfe_xml`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `nfe_xml` (
  `NFe` bigint(20) unsigned NOT NULL,
  `ChaveNFe` varchar(45) NOT NULL DEFAULT '',
  `XML_proc` longtext NOT NULL,
  PRIMARY KEY (`NFe`),
  CONSTRAINT `FK_nfe_xml_nfe_cab` FOREIGN KEY (`NFe`) REFERENCES `nfe_cab` (`NFe`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `permissoes`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `permissoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(120) NOT NULL,
  `modulo` varchar(40) NOT NULL,
  `Ordem` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `IDXModuloOrdem` (`modulo`,`Ordem`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `permissoes_usuario`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `permissoes_usuario` (
  `permissao_id` int(11) NOT NULL,
  `usuario_login` varchar(255) NOT NULL,
  PRIMARY KEY (`permissao_id`,`usuario_login`),
  KEY `FK_permissoes_usuario_seguranca_users` (`usuario_login`),
  CONSTRAINT `FK_permissoes_usuario_permissoes` FOREIGN KEY (`permissao_id`) REFERENCES `permissoes` (`id`),
  CONSTRAINT `FK_permissoes_usuario_seguranca_users` FOREIGN KEY (`usuario_login`) REFERENCES `seguranca_users` (`login`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `pf_colecao`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `pf_usuario_fornecedor`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pf_usuario_fornecedor` (
  `id_usuario` int(10) unsigned NOT NULL,
  `id_fornecedor` varchar(2) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_fornecedor`),
  KEY `FK_pf_usuario_fornecedor_produtos_fornecedor` (`id_fornecedor`),
  CONSTRAINT `FK_pf_usuario_fornecedor_pf_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `pf_usuarios` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pf_usuario_fornecedor_produtos_fornecedor` FOREIGN KEY (`id_fornecedor`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Estrutura da tabela `pf_usuarios`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `pf_usuarios_copy`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `pre_cadastro`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pre_cadastro` (
  `Codigo` bigint(20) unsigned NOT NULL,
  `Situacao` int(3) NOT NULL DEFAULT '10' COMMENT 'O estado atual do cadastro, ele dirá quem acessará e o que poderá alterar',
  `CD` int(11) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `R1` varchar(2) NOT NULL,
  `R2` varchar(2) NOT NULL,
  `R3` varchar(4) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL DEFAULT '',
  `Genero` int(11) NOT NULL,
  `ReferenciaMaster` varchar(8) NOT NULL DEFAULT '',
  `Data` date DEFAULT NULL,
  `Hora` time DEFAULT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL DEFAULT '',
  `MarkUpCompra` double NOT NULL DEFAULT '0' COMMENT 'Vem do fornecedor R1; Mark-up*Custo = Sugestão Venda PDV',
  `DataConsolidacaoProdutos` date DEFAULT NULL COMMENT 'Data que foi criado ao cadastro de produtos',
  `HoraConsolidacaoProdutos` time DEFAULT NULL COMMENT 'Hora que foi criado ao cadastro de produtos',
  `DataConsolidacaoCompras` date DEFAULT NULL COMMENT 'Data que foi criado ao cadastro de compras',
  `HoraConsolidacaoCompras` time DEFAULT NULL COMMENT 'hora que foi criado ao cadastro de compras',
  `Usuario` varchar(30) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `ncm` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`) USING BTREE,
  KEY `FK_pre_cadastro_empresas_cd` (`CD`) USING BTREE,
  KEY `FK_pre_cadastro_empresas` (`Empresa`) USING BTREE,
  KEY `FK_pre_cadastro_produtos_fornecedor` (`R1`) USING BTREE,
  KEY `FK_pre_cadastro_produtos_categorias` (`R2`) USING BTREE,
  KEY `FK_pre_cadastro_allop_devel.produtos_generos` (`Genero`),
  CONSTRAINT `FK_pre_cadastro_allop_devel.produtos_generos` FOREIGN KEY (`Genero`) REFERENCES `produtos_generos` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_empresas` FOREIGN KEY (`Empresa`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_empresas_cd` FOREIGN KEY (`CD`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_produtos_categorias` FOREIGN KEY (`R2`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_produtos_fornecedor` FOREIGN KEY (`R1`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `pre_cadastro_grupos`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pre_cadastro_grupos` (
  `HashCode` varchar(60) NOT NULL,
  `PreCadastro` bigint(20) unsigned NOT NULL,
  `Grupo` varchar(40) NOT NULL,
  `Referencia` varchar(15) NOT NULL,
  `GrupoCategoria` varchar(40) NOT NULL,
  `Composicao` int(11) NOT NULL DEFAULT '0',
  `Caracteristica` int(11) NOT NULL DEFAULT '0',
  `DataDeCriacao` date DEFAULT NULL,
  PRIMARY KEY (`HashCode`,`PreCadastro`,`Grupo`) USING BTREE,
  KEY `FK_pre_cadastro_grupos_pre_cadastro` (`PreCadastro`) USING BTREE,
  KEY `FK_pre_cadastro_grupos_produtos_grupos` (`Grupo`,`GrupoCategoria`) USING BTREE,
  CONSTRAINT `FK_pre_cadastro_grupos_pre_cadastro` FOREIGN KEY (`PreCadastro`) REFERENCES `pre_cadastro` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `pre_cadastro_hst`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pre_cadastro_hst` (
  `Codigo` bigint(20) unsigned NOT NULL,
  `Situacao` int(3) NOT NULL DEFAULT '10' COMMENT 'O estado atual do cadastro, ele dirá quem acessará e o que poderá alterar',
  `CD` int(11) NOT NULL,
  `Empresa` int(11) NOT NULL,
  `R1` varchar(2) NOT NULL,
  `R2` varchar(2) NOT NULL,
  `R3` varchar(4) NOT NULL,
  `CodFornecedor` varchar(200) NOT NULL DEFAULT '',
  `Genero` int(11) NOT NULL DEFAULT '1',
  `ReferenciaMaster` varchar(8) NOT NULL DEFAULT '',
  `Data` date DEFAULT NULL,
  `Hora` time DEFAULT NULL,
  `DescricaoComplementar` varchar(70) NOT NULL DEFAULT '' COMMENT 'Descrição do Pré Cadastro',
  `MarkUpCompra` double NOT NULL DEFAULT '0' COMMENT 'Vem do fornecedor R1; Mark-up*Custo = Sugestão Venda PDV',
  `DataConsolidacaoProdutos` date DEFAULT NULL COMMENT 'Data que foi criado ao cadastro de produtos',
  `HoraConsolidacaoProdutos` time DEFAULT NULL COMMENT 'Hora que foi criado ao cadastro de produtos',
  `DataConsolidacaoCompras` date DEFAULT NULL COMMENT 'Data que foi criado ao cadastro de compras',
  `HoraConsolidacaoCompras` time DEFAULT NULL COMMENT 'hora que foi criado ao cadastro de compras',
  `Usuario` varchar(30) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Inclusao` date DEFAULT NULL,
  `Alteracao` date DEFAULT NULL,
  `ncm` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`) USING BTREE,
  KEY `FK_pre_cadastro_empresas_cd` (`CD`) USING BTREE,
  KEY `FK_pre_cadastro_empresas` (`Empresa`) USING BTREE,
  KEY `FK_pre_cadastro_produtos_fornecedor` (`R1`) USING BTREE,
  KEY `FK_pre_cadastro_produtos_categorias` (`R2`) USING BTREE,
  KEY `FK_pre_cadastro_allop_devel.produtos_generos` (`Genero`) USING BTREE,
  CONSTRAINT `pre_cadastro_hst_ibfk_1` FOREIGN KEY (`Genero`) REFERENCES `produtos_generos` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `pre_cadastro_hst_ibfk_2` FOREIGN KEY (`Empresa`) REFERENCES `empresas` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `pre_cadastro_hst_ibfk_3` FOREIGN KEY (`CD`) REFERENCES `empresas_cd` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `pre_cadastro_hst_ibfk_4` FOREIGN KEY (`R2`) REFERENCES `produtos_categorias` (`Codigo`) ON UPDATE NO ACTION,
  CONSTRAINT `pre_cadastro_hst_ibfk_5` FOREIGN KEY (`R1`) REFERENCES `produtos_fornecedor` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `pre_cadastro_itens`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pre_cadastro_itens` (
  `Codigo` bigint(20) unsigned NOT NULL,
  `PreCadastro` bigint(20) unsigned NOT NULL,
  `GrupoLivre` varchar(40) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Quantidade` double NOT NULL DEFAULT '0',
  `CustoCompra` double NOT NULL DEFAULT '0',
  `Markup` double NOT NULL DEFAULT '0',
  `Varejo` double NOT NULL DEFAULT '0' COMMENT 'Calculado pelo Markup',
  `PrecoFinal` double NOT NULL DEFAULT '0' COMMENT 'Preco de Venda no PDV (Venda PDV)',
  `DataEntrega` date DEFAULT NULL,
  `Observacao` varchar(150) NOT NULL,
  `CFOPP` varchar(4) NOT NULL,
  `ncm` varchar(10) NOT NULL DEFAULT '',
  `ReferenciaMaster` varchar(8) NOT NULL,
  `Referencia` varchar(15) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXPreCadastroGrupoTamCor` (`PreCadastro`,`GrupoLivre`,`Tamanho`,`Cor`) USING BTREE,
  KEY `FK_pre_cadastro_itens_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_pre_cadastro_itens_produtos_cor` (`Cor`) USING BTREE,
  KEY `IDXrefMasterRef` (`ReferenciaMaster`,`Referencia`) USING BTREE,
  KEY `IDXReferencia` (`Referencia`) USING BTREE,
  KEY `FK_pre_cadastro_itens_produtos_grupos` (`GrupoLivre`) USING BTREE,
  CONSTRAINT `FK_pre_cadastro_itens_pre_cadastro` FOREIGN KEY (`PreCadastro`) REFERENCES `pre_cadastro` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_pre_cadastro_itens_produtos_cor` FOREIGN KEY (`Cor`) REFERENCES `produtos_cor` (`Codigo`),
  CONSTRAINT `FK_pre_cadastro_itens_produtos_grupos_livre` FOREIGN KEY (`GrupoLivre`) REFERENCES `produtos_grupos_livre` (`GrupoLivre`),
  CONSTRAINT `FK_pre_cadastro_itens_produtos_tamanho` FOREIGN KEY (`Tamanho`) REFERENCES `produtos_tamanho` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `pre_cadastro_itens_hst`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pre_cadastro_itens_hst` (
  `Codigo` bigint(20) unsigned NOT NULL,
  `PreCadastro` bigint(20) unsigned NOT NULL,
  `GrupoLivre` varchar(40) NOT NULL,
  `Tamanho` varchar(2) NOT NULL,
  `Cor` varchar(2) NOT NULL,
  `Quantidade` double NOT NULL DEFAULT '0',
  `CustoCompra` double NOT NULL DEFAULT '0',
  `Markup` double NOT NULL DEFAULT '0',
  `Varejo` double NOT NULL DEFAULT '0' COMMENT 'Calculado pelo Markup',
  `PrecoFinal` double NOT NULL DEFAULT '0' COMMENT 'Preco de Venda no PDV (Venda PDV)',
  `DataEntrega` date DEFAULT NULL,
  `Observacao` varchar(150) NOT NULL,
  `CFOPP` varchar(4) NOT NULL,
  `ncm` varchar(10) NOT NULL DEFAULT '',
  `ReferenciaMaster` varchar(8) NOT NULL,
  `Referencia` varchar(15) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXPreCadastroGrupoTamCor` (`PreCadastro`,`GrupoLivre`,`Tamanho`,`Cor`) USING BTREE,
  KEY `FK_pre_cadastro_itens_produtos_tamanho` (`Tamanho`) USING BTREE,
  KEY `FK_pre_cadastro_itens_produtos_cor` (`Cor`) USING BTREE,
  KEY `IDXrefMasterRef` (`ReferenciaMaster`,`Referencia`) USING BTREE,
  KEY `IDXReferencia` (`Referencia`) USING BTREE,
  KEY `FK_pre_cadastro_itens_produtos_grupos` (`GrupoLivre`) USING BTREE,
  CONSTRAINT `FK_pre_cadastro_itens_hst_pre_cadastro_hst` FOREIGN KEY (`PreCadastro`) REFERENCES `pre_cadastro_hst` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `pre_cadastro_itens_hst_ibfk_2` FOREIGN KEY (`Cor`) REFERENCES `produtos_cor` (`Codigo`),
  CONSTRAINT `pre_cadastro_itens_hst_ibfk_3` FOREIGN KEY (`GrupoLivre`) REFERENCES `produtos_grupos_livre` (`GrupoLivre`),
  CONSTRAINT `pre_cadastro_itens_hst_ibfk_4` FOREIGN KEY (`Tamanho`) REFERENCES `produtos_tamanho` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `pre_cadastro_situacao`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pre_cadastro_situacao` (
  `Codigo` int(11) NOT NULL,
  `Descricao` varchar(30) DEFAULT '',
  PRIMARY KEY (`Codigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `prm_sistema`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prm_sistema` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `CD` int(11) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_antes_gcom`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProduto` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoCD`,`CodigoProduto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_barras`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_barras` (
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`) USING BTREE,
  CONSTRAINT `FK_produtos_barras_1` FOREIGN KEY (`Codigo`) REFERENCES `produtos` (`Codigo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_barras_antes_gcom`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_barras_antes_gcom` (
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_barras_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_barras_api` (
  `CodigoCD` int(11) NOT NULL DEFAULT '0',
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`,`CodigoCD`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_barras_gcom`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_barras_gcom` (
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_antes_gcom`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_aux`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=2176 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_aux_outras_informacoes`
-- --------------------------------------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_gcom`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_grade`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_grade_antes_gcom`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_grade_aux`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_grade_aux_outras_informacoes`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cab_grade_gcom`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_caracteristicas`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_caracteristicas_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_caracteristicas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCaracteristica` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoCaracteristica`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_categoria_caracteristicas`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_categoria_caracteristicas_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_categoria_caracteristicas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCategoriaCaracteristica` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoCategoriaCaracteristica`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_categoria_composicao`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_categoria_composicao_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_categoria_composicao_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCategoriaComposicao` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoProdutoCategoriaComposicao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_categorias`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_categorias_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_categorias_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCategoria` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoProdutoCategoria`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_categorias_livre`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_categorias_livre_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_categorias_livre_api` (
  `CodigoCategoriaLivre` int(11) NOT NULL,
  `CodigoCD` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoCategoriaLivre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_colecao`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_colecao` (
  `Codigo` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Colecao` varchar(40) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  UNIQUE KEY `IDXModelo` (`Colecao`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1 COMMENT='tbModelos - Modelos';

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_colecao_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_colecao_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoColecao` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoProdutoColecao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_composicoes`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_composicoes_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_composicoes_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoComposicao` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoComposicao`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_conta_corrente`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cor`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_cor_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_cor_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoCor` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoCD`,`CodigoProdutoCor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_custos`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_custos` (
  `Produto` varchar(8) NOT NULL DEFAULT '',
  `Estoque` double(15,3) NOT NULL DEFAULT '0.000',
  `CustoMedio` double(12,2) NOT NULL DEFAULT '0.00',
  `CustoUltimo` double(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`Produto`) USING BTREE,
  CONSTRAINT `FK_produtos_custos_produtos` FOREIGN KEY (`Produto`) REFERENCES `produtos` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_estilos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_estoque`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_fornecedor`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_fornecedor_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_fornecedor_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoFornecedor` varchar(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoProdutoFornecedor`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_fotos`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_fotos` (
  `Referencia` varchar(8) CHARACTER SET latin1 NOT NULL,
  `Sequencia` int(5) NOT NULL DEFAULT '0',
  `Foto` mediumblob NOT NULL,
  `Usuario` varchar(50) NOT NULL,
  `Inclusao` date NOT NULL,
  PRIMARY KEY (`Referencia`,`Sequencia`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_fotos_old`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_fotos_old` (
  `Referencia` varchar(8) CHARACTER SET latin1 NOT NULL,
  `Sequencia` int(5) NOT NULL DEFAULT '0',
  `Arquivo` varchar(250) NOT NULL DEFAULT '',
  `Usuario` varchar(50) NOT NULL,
  `Inclusao` date NOT NULL,
  PRIMARY KEY (`Referencia`,`Sequencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_gcom`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_generos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_generos_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_generos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoGenero` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoGenero`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_grupos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_grupos_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_grupos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoGrupo` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CodigoProdutoGrupo`,`CodigoCD`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_grupos_livre`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_grupos_livre_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_grupos_livre_api` (
  `CodigoGrupoLivre` int(11) NOT NULL,
  `CodigoCD` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoGrupoLivre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_grupos_tamanho`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_linhas`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_linhas_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_linhas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoLinha` int(11) NOT NULL,
  PRIMARY KEY (`CodigoProdutoLinha`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_local_fisico`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_local_fisico_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_local_fisico_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoLocalFisico` int(11) NOT NULL,
  PRIMARY KEY (`CodigoLocalFisico`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_log_preco`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_medidas`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_medidas_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_medidas_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoMedida` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoProdutoMedida`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_precos_cab`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_precos_cab_h`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_precos_itens`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_precos_itens_h`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_prm`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_referencias_prod`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_referencias_prod` (
  `Referencia` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_tamanho`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_tamanho_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_tamanho_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoProdutoTamanho` varchar(2) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoProdutoTamanho`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `produtos_tamanho_ordem`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_tamanho_ordem` (
  `Codigo` varchar(2) NOT NULL,
  `Ordem` int(11) NOT NULL,
  PRIMARY KEY (`Codigo`) USING BTREE,
  CONSTRAINT `FK_produtos_tamanho_ordem_produtos_tamanho` FOREIGN KEY (`Codigo`) REFERENCES `produtos_tamanho` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='tbProdutosTamanho';

-- --------------------------------------------------------
-- Estrutura da tabela `provisorios`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `provisorios_lancamentos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `ramo_atividades`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `ramo_atividades_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ramo_atividades_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoRamoAtividades` int(11) NOT NULL,
  PRIMARY KEY (`CodigoRamoAtividades`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `regioes`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `regioes` (
  `Regiao` varchar(15) NOT NULL,
  PRIMARY KEY (`Regiao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `regioes_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `regioes_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoRegiao` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoRegiao`,`CodigoCD`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `responsaveis`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `responsaveis_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `responsaveis_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoResponsavel` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoResponsavel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `responsaveis_entrega`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `responsaveis_entrega_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `responsaveis_entrega_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoResponsavelEntrega` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoResponsavelEntrega`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `responsaveis_tributos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `responsaveis_tributos_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `responsaveis_tributos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoResponsavelTributo` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`CodigoResponsavelTributo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `romaneios_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `romaneios_api` (
  `CodigoCD` int(11) NOT NULL,
  `IDRomaneio` int(11) NOT NULL,
  PRIMARY KEY (`CodigoCD`,`IDRomaneio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `romaneios_cab`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `romaneios_cab_online`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `romaneios_contador`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `romaneios_contador` (
  `Cliente` int(11) NOT NULL,
  `Contador` varchar(3) NOT NULL,
  PRIMARY KEY (`Cliente`),
  CONSTRAINT `FK_romaneios_contador_responsaveis` FOREIGN KEY (`Cliente`) REFERENCES `responsaveis` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `romaneios_ite`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `romaneios_ite_online`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seg_aplicacoes`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seg_aplicacoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `rota` varchar(255) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `ordem` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDXMenuOrdem` (`menu_id`,`ordem`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Estrutura da tabela `seg_menu`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seg_menu` (
  `id` int(11) NOT NULL,
  `menu` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Estrutura da tabela `seg_perfil`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seg_perfil` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Estrutura da tabela `seg_perfil_permissoes`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seg_usuarios`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seg_usuarios_permissoes`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `segapps`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `segapps` (
  `Nivel` int(11) NOT NULL,
  `Ordem` int(11) NOT NULL,
  `app_name` varchar(128) NOT NULL,
  `app_type` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`app_name`),
  KEY `IDXNivelOrdem` (`Nivel`,`Ordem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `seggroups`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seggroups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `seggroups_apps`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seggroups_apps_copy`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `segnivel_menu`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `segnivel_menu` (
  `Nivel` int(11) NOT NULL,
  `Descricao` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`Nivel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `segsettings`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `segsettings` (
  `set_name` varchar(255) NOT NULL,
  `set_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_aplicacoes`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_apps`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_apps` (
  `Nivel` int(11) DEFAULT NULL,
  `Ordem` int(11) DEFAULT NULL,
  `app_name` varchar(128) NOT NULL,
  `app_type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`app_name`),
  KEY `IDXNivelOrdem` (`Nivel`,`Ordem`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_grupo_menu`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_grupo_menu` (
  `Codigo` int(11) NOT NULL,
  `Grupo` varchar(30) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`Codigo`),
  UNIQUE KEY `IDXGrupo` (`Grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_logged`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_logged` (
  `login` varchar(255) NOT NULL,
  `date_login` varchar(128) DEFAULT NULL,
  `sc_session` varchar(32) DEFAULT NULL,
  `ip` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_logs`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_logs` (
  `Codigo` int(8) NOT NULL AUTO_INCREMENT,
  `DataHora` datetime DEFAULT NULL,
  `Usuario` varchar(90) NOT NULL,
  `Aplicacao` varchar(255) NOT NULL,
  `Acao` varchar(30) NOT NULL,
  `Descricao` text,
  PRIMARY KEY (`Codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=255 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_menu`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_menu` (
  `Grupo` int(11) NOT NULL DEFAULT '0',
  `Ordem` int(11) NOT NULL DEFAULT '0',
  `Descricao` varchar(120) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `Aplicacao` varchar(120) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  KEY `IDXGrupo` (`Grupo`),
  CONSTRAINT `FK_seguranca_menu_seguranca_grupo_menu` FOREIGN KEY (`Grupo`) REFERENCES `seguranca_grupo_menu` (`Codigo`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_parametros`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_parametros_sistema`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_parametros_sistema` (
  `Empresa` int(11) NOT NULL DEFAULT '0',
  `Parametro` varchar(10) COLLATE latin1_general_ci NOT NULL COMMENT 'Combinação Tipo+''PRM''+Aplicacao com zeros a esquerda',
  PRIMARY KEY (`Parametro`,`Empresa`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_parametros_usuario`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_parametros_usuario` (
  `Usuario` int(11) NOT NULL,
  `Parametro` varchar(10) COLLATE latin1_general_ci NOT NULL COMMENT 'Combinação Tipo+''PRM''+Aplicacao com zeros a esquerda',
  PRIMARY KEY (`Usuario`,`Parametro`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_parametros_valores`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_parametros_valores` (
  `Empresa` int(11) NOT NULL DEFAULT '0',
  `Parametro` varchar(10) COLLATE latin1_general_ci NOT NULL COMMENT 'Combinação Tipo+''PRM''+Aplicacao com zeros a esquerda',
  PRIMARY KEY (`Empresa`,`Parametro`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_settings`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_settings` (
  `set_name` varchar(255) NOT NULL,
  `set_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_users`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_users_apps`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_usuarios`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_usuarios_aplicacoes`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `seguranca_usuarios_empresas`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `seguranca_usuarios_empresas` (
  `Usuario` int(11) NOT NULL,
  `Empresa` int(11) NOT NULL,
  PRIMARY KEY (`Usuario`,`Empresa`),
  KEY `FK_seguranca_usuarios_empresas_empresas` (`Empresa`),
  CONSTRAINT `FK_seguranca_usuarios_empresas_empresas` FOREIGN KEY (`Empresa`) REFERENCES `empresas` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_seguranca_usuarios_empresas_seguranca_usuarios` FOREIGN KEY (`Usuario`) REFERENCES `seguranca_usuarios` (`Codigo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Estrutura da tabela `segusers`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `segusers_empresa`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `segusers_empresa` (
  `login` varchar(60) NOT NULL,
  `Empresa` int(11) NOT NULL,
  PRIMARY KEY (`login`,`Empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `segusers_groups`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `segusers_groups` (
  `login` varchar(60) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`login`,`group_id`),
  KEY `segusers_groups_ibfk_2` (`group_id`),
  CONSTRAINT `FK_segusers_groups_segusers` FOREIGN KEY (`login`) REFERENCES `segusers` (`login`),
  CONSTRAINT `segusers_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `seggroups` (`group_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `segusers_pre_cadastro_sts`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `segusers_pre_cadastro_sts` (
  `Login` varchar(60) NOT NULL,
  `Situacao` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`Login`) USING BTREE,
  CONSTRAINT `FK_segusers_pre_cadastro_sts_segusers` FOREIGN KEY (`Login`) REFERENCES `segusers` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Pre-Cadastro Situacao - Relacionamento de usuarios e situacao de pre cadastro\r\n';

-- --------------------------------------------------------
-- Estrutura da tabela `situacao`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `situacao` (
  `StsNome` varchar(8) NOT NULL,
  PRIMARY KEY (`StsNome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `st_cofins`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_cofins` (
  `Codigo` varchar(2) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Operacao` varchar(1) NOT NULL DEFAULT '' COMMENT 'E/S',
  `IncideImposto` varchar(1) NOT NULL DEFAULT '' COMMENT 'S/N',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `st_cofins_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_cofins_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoCofins` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoCofins`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `st_icms`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_icms` (
  `Codigo` varchar(3) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `SimplesNacional` varchar(1) NOT NULL DEFAULT 'N',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `st_icms_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_icms_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoIcms` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoIcms`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `st_ipi`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_ipi` (
  `Codigo` varchar(2) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Operacao` varchar(1) NOT NULL DEFAULT '' COMMENT 'E/S',
  `IncideImposto` varchar(1) NOT NULL DEFAULT '' COMMENT 'S/N',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `st_ipi_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_ipi_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoIpi` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoIpi`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `st_origem`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_origem` (
  `Codigo` varchar(1) NOT NULL,
  `Descricao` varchar(200) NOT NULL,
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `st_origem_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_origem_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoOrigem` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoOrigem`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `st_pis`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_pis` (
  `Codigo` varchar(2) NOT NULL,
  `Descricao` varchar(150) NOT NULL,
  `Operacao` varchar(1) NOT NULL DEFAULT '' COMMENT 'E/S',
  `IncideImposto` varchar(1) NOT NULL DEFAULT '' COMMENT 'S/N',
  `Status` varchar(8) NOT NULL COMMENT 'Ativo/Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `st_pis_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `st_pis_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoPis` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CodigoPis`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `tbcest`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tbcest` (
  `cest` varchar(7) NOT NULL,
  `ncm` varchar(8) NOT NULL,
  `descricao` varchar(520) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `tbcidades`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `tbfranqueados`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `tbprodutos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `tbprodutosbarras`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tbprodutosbarras` (
  `Codigo` varchar(8) NOT NULL,
  `CodigoBarra` varchar(20) NOT NULL,
  PRIMARY KEY (`Codigo`,`CodigoBarra`),
  CONSTRAINT `FK_tbProdutosBarras_1` FOREIGN KEY (`Codigo`) REFERENCES `tbprodutos` (`Codigo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `tbramoatividade`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tbramoatividade` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT,
  `RamoAtividade` varchar(50) NOT NULL,
  `Status` varchar(8) NOT NULL,
  `Inclusao` date NOT NULL,
  `Alteracao` date NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `tbresponsaveis`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `tbresponsaveisadicionais`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `tipos_lancamentos`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tipos_lancamentos` (
  `Codigo` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Codigo do tipo de credito',
  `Descricao` varchar(40) NOT NULL DEFAULT '',
  `Sts` varchar(10) NOT NULL DEFAULT 'Ativo' COMMENT 'Ativo / Inativo',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Estrutura da tabela `tmp_saida_produtos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `transportadoras`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `transportadoras_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `transportadoras_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoTransportadora` int(11) NOT NULL,
  PRIMARY KEY (`CodigoTransportadora`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `urls_allop`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `veiculos`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da tabela `veiculos_api`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veiculos_api` (
  `CodigoCD` int(11) NOT NULL,
  `CodigoVeiculo` varchar(50) NOT NULL,
  PRIMARY KEY (`CodigoVeiculo`,`CodigoCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `veiculos_carrocerias`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veiculos_carrocerias` (
  `Codigo` varchar(2) NOT NULL DEFAULT '',
  `Descricao` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `veiculos_propriedades`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veiculos_propriedades` (
  `Codigo` varchar(1) NOT NULL,
  `Descricao` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `veiculos_rodados`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veiculos_rodados` (
  `Codigo` varchar(2) NOT NULL,
  `Descricao` varchar(30) NOT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `veiculos_tipos`
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veiculos_tipos` (
  `Codigo` varchar(1) NOT NULL DEFAULT '',
  `Descricao` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Estrutura da tabela `videos_de_ajuda`
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Estrutura da trigger `cests_ncm_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cests_ncm_after_insert`;
DELIMITER //
CREATE TRIGGER `cests_ncm_after_insert` AFTER INSERT ON `cests_ncm` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `cests_ncm_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cests_ncm_after_update`;
DELIMITER //
CREATE TRIGGER `cests_ncm_after_update` AFTER UPDATE ON `cests_ncm` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `cfops_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cfops_after_insert`;
DELIMITER //
CREATE TRIGGER `cfops_after_insert` AFTER INSERT ON `cfops` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `cfops_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cfops_after_update`;
DELIMITER //
CREATE TRIGGER `cfops_after_update` AFTER UPDATE ON `cfops` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `cidades_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cidades_after_insert`;
DELIMITER //
CREATE TRIGGER `cidades_after_insert` AFTER INSERT ON `cidades` FOR EACH ROW BEGIN
	REPLACE INTO cidades_api(	CodigoCidade,
										CodigoCD
									)
									(
										SELECT
											t1.Codigo,
											t2.Codigo
										FROM
											cidades		t1,
											empresas_cd t2
										WHERE
											t1.Codigo = NEW.Codigo
								);

END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `cidades_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cidades_after_update`;
DELIMITER //
CREATE TRIGGER `cidades_after_update` AFTER UPDATE ON `cidades` FOR EACH ROW BEGIN
	REPLACE INTO cidades_api(	CodigoCidade,
										CodigoCD
									)
									(
										SELECT
											t1.Codigo,
											t2.Codigo
										FROM
											cidades		t1,
											empresas_cd t2
										WHERE
											t1.Codigo = NEW.Codigo
								);

END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `compras_before_delete`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `compras_before_delete`;
DELIMITER //
CREATE TRIGGER `compras_before_delete` BEFORE DELETE ON `compras` FOR EACH ROW BEGIN
	DELETE FROM
	compras_agenda
	WHERE
	compras_agenda.CD = OLD.CD
	AND
	compras_agenda.Pedido = OLD.Pedido
	AND
	compras_agenda.DataEntrega >= CURRENT_DATE();

END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `compras_itens_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `compras_itens_after_insert`;
DELIMITER //
CREATE TRIGGER `compras_itens_after_insert` AFTER INSERT ON `compras_itens` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `compras_itens_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `compras_itens_after_update`;
DELIMITER //
CREATE TRIGGER `compras_itens_after_update` AFTER UPDATE ON `compras_itens` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `compras_itens_after_delete`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `compras_itens_after_delete`;
DELIMITER //
CREATE TRIGGER `compras_itens_after_delete` AFTER DELETE ON `compras_itens` FOR EACH ROW BEGIN

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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `config_email_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `config_email_after_insert`;
DELIMITER //
CREATE TRIGGER `config_email_after_insert` AFTER INSERT ON `config_email` FOR EACH ROW BEGIN
	REPLACE INTO config_email_api(	CodigoEmail,
												CodigoCD
											)
											(
												SELECT
													t1.Codigo,
													t2.Codigo
												FROM
													config_email	t1,
													empresas_cd	t2
												WHERE
												t1.Codigo = NEW.Codigo
											);

END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `config_email_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `config_email_after_update`;
DELIMITER //
CREATE TRIGGER `config_email_after_update` AFTER UPDATE ON `config_email` FOR EACH ROW BEGIN
	REPLACE INTO config_email_api(	CodigoEmail,
												CodigoCD
											)
											(
												SELECT
													t1.Codigo,
													t2.Codigo
												FROM
													config_email	t1,
													empresas_cd	t2
												WHERE
												t1.Codigo = NEW.Codigo
											);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `consultores_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `consultores_after_insert`;
DELIMITER //
CREATE TRIGGER `consultores_after_insert` AFTER INSERT ON `consultores` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `consultores_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `consultores_after_update`;
DELIMITER //
CREATE TRIGGER `consultores_after_update` AFTER UPDATE ON `consultores` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `cp_compras_itens_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cp_compras_itens_after_update`;
DELIMITER //
CREATE TRIGGER `cp_compras_itens_after_update` AFTER UPDATE ON `cp_compras_itens` FOR EACH ROW
BEGIN
  IF NOT (OLD.`total_qtde` <=> NEW.`total_qtde`) OR NOT (OLD.`Sts` <=> NEW.`Sts`) OR NOT (OLD.`entrega` <=> NEW.`entrega`) THEN
    INSERT INTO `cp_compras_itens_log`
      (`compras_itens_id`, `cp_compras_id`, `referencia_fornecedor`, `descricao`, `composicao`, `ncm`, `entrega`, `entrega_anterior`, `total_qtde`, `total_produto`, `Foto`, `Sts`, `Iteracao`, `Localizacao`)
    VALUES
      (OLD.`id`, OLD.`cp_compras_id`, OLD.`referencia_fornecedor`, OLD.`descricao`, OLD.`composicao`, OLD.`ncm`, OLD.`entrega`, OLD.`entrega_anterior`, OLD.`total_qtde`, OLD.`total_produto`, OLD.`Foto`, OLD.`Sts`,
       (SELECT c.`Iteracao` FROM `cp_compras` c WHERE c.`id` = OLD.`cp_compras_id` LIMIT 1),
       (SELECT c.`Localizacao` FROM `cp_compras` c WHERE c.`id` = OLD.`cp_compras_id` LIMIT 1));
  END IF;
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `cp_compras_itens_cores_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cp_compras_itens_cores_after_update`;
DELIMITER //
CREATE TRIGGER `cp_compras_itens_cores_after_update` AFTER UPDATE ON `cp_compras_itens_cores` FOR EACH ROW
BEGIN
  IF NOT (OLD.`Qtde` <=> NEW.`Qtde`) OR NOT (OLD.`preco_proposta` <=> NEW.`preco_proposta`) OR NOT (OLD.`Sts` <=> NEW.`Sts`) THEN
    INSERT INTO `cp_compras_itens_cores_log`
      (`compras_itens_cores_id`, `compras_itens_tamanho_id`, `sku`, `cor`, `Qtde`, `preco_fornecedor`, `preco_proposta`, `valor_total_produto`, `preco_franqueado`, `markup_franquia`, `preco_loja`, `markup_loja`, `markup_total`, `Sts`, `Iteracao`, `Localizacao`)
    VALUES
      (OLD.`id`, OLD.`compras_itens_tamanho_id`, OLD.`sku`, OLD.`cor`, OLD.`Qtde`, OLD.`preco_fornecedor`, OLD.`preco_proposta`, OLD.`valor_total_produto`, OLD.`preco_franqueado`, OLD.`markup_franquia`, OLD.`preco_loja`, OLD.`markup_loja`, OLD.`markup_total`, OLD.`Sts`,
       (SELECT c.`Iteracao` FROM `cp_compras` c INNER JOIN `cp_compras_itens` i ON i.`cp_compras_id` = c.`id` INNER JOIN `cp_compras_itens_tamanhos` t ON t.`compras_itens_id` = i.`id` WHERE t.`id` = OLD.`compras_itens_tamanho_id` LIMIT 1),
       (SELECT c.`Localizacao` FROM `cp_compras` c INNER JOIN `cp_compras_itens` i ON i.`cp_compras_id` = c.`id` INNER JOIN `cp_compras_itens_tamanhos` t ON t.`compras_itens_id` = i.`id` WHERE t.`id` = OLD.`compras_itens_tamanho_id` LIMIT 1));
  END IF;
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `cp_compras_itens_tamanhos_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `cp_compras_itens_tamanhos_after_update`;
DELIMITER //
CREATE TRIGGER `cp_compras_itens_tamanhos_after_update` AFTER UPDATE ON `cp_compras_itens_tamanhos` FOR EACH ROW
BEGIN
  INSERT INTO `cp_compras_itens_tamanhos_log`
    (`compras_itens_tamanho_id`, `compras_itens_id`, `tamanho`, `entrega`, `entrega_anterior`, `markup_franquia`, `markup_loja`, `qtde_total`, `valor_total`, `Itens`, `Sts`, `Iteracao`, `Localizacao`)
  VALUES
    (OLD.`id`, OLD.`compras_itens_id`, OLD.`tamanho`, OLD.`entrega`, OLD.`entrega_anterior`, OLD.`markup_franquia`, OLD.`markup_loja`, OLD.`qtde_total`, OLD.`valor_total`, OLD.`Itens`, OLD.`Sts`,
     (SELECT c.`Iteracao` FROM `cp_compras` c INNER JOIN `cp_compras_itens` i ON i.`cp_compras_id` = c.`id` WHERE i.`id` = OLD.`compras_itens_id` LIMIT 1),
     (SELECT c.`Localizacao` FROM `cp_compras` c INNER JOIN `cp_compras_itens` i ON i.`cp_compras_id` = c.`id` WHERE i.`id` = OLD.`compras_itens_id` LIMIT 1));
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `empresas_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `empresas_after_insert`;
DELIMITER //
CREATE TRIGGER `empresas_after_insert` AFTER INSERT ON `empresas` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `empresas_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `empresas_after_update`;
DELIMITER //
CREATE TRIGGER `empresas_after_update` AFTER UPDATE ON `empresas` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `empresas_cd_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `empresas_cd_after_insert`;
DELIMITER //
CREATE TRIGGER `empresas_cd_after_insert` AFTER INSERT ON `empresas_cd` FOR EACH ROW BEGIN
	REPLACE INTO empresas_cd_api (Codigo) (SELECT Codigo FROM empresas_cd);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `empresas_cd_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `empresas_cd_after_update`;
DELIMITER //
CREATE TRIGGER `empresas_cd_after_update` AFTER UPDATE ON `empresas_cd` FOR EACH ROW BEGIN
	REPLACE INTO empresas_cd_api (Codigo) (SELECT Codigo FROM empresas_cd);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `estados_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `estados_after_insert`;
DELIMITER //
CREATE TRIGGER `estados_after_insert` AFTER INSERT ON `estados` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `estados_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `estados_after_update`;
DELIMITER //
CREATE TRIGGER `estados_after_update` AFTER UPDATE ON `estados` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `fechamento_lancamentos_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `fechamento_lancamentos_after_insert`;
DELIMITER //
CREATE TRIGGER `fechamento_lancamentos_after_insert` AFTER INSERT ON `fechamento_lancamentos` FOR EACH ROW BEGIN
	CALL sp_fechamentos_atualizar_totais_creditos(NEW.Fechamento);
	CALL sp_fechamentos_atualizar_totais_debitos(NEW.Fechamento);
	CALL sp_fechamentos_atualizar_saldo(NEW.Fechamento);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `fechamento_lancamentos_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `fechamento_lancamentos_after_update`;
DELIMITER //
CREATE TRIGGER `fechamento_lancamentos_after_update` AFTER UPDATE ON `fechamento_lancamentos` FOR EACH ROW BEGIN
	CALL sp_fechamentos_atualizar_totais_creditos(NEW.Fechamento);
	CALL sp_fechamentos_atualizar_totais_debitos(NEW.Fechamento);
	CALL sp_fechamentos_atualizar_saldo(NEW.Fechamento);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `fechamento_lancamentos_after_delete`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `fechamento_lancamentos_after_delete`;
DELIMITER //
CREATE TRIGGER `fechamento_lancamentos_after_delete` AFTER DELETE ON `fechamento_lancamentos` FOR EACH ROW BEGIN
	CALL sp_fechamentos_atualizar_totais_creditos(OLD.Fechamento);
	CALL sp_fechamentos_atualizar_totais_debitos(OLD.Fechamento);
	CALL sp_fechamentos_atualizar_saldo(OLD.Fechamento);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `franqueados_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `franqueados_after_insert`;
DELIMITER //
CREATE TRIGGER `franqueados_after_insert` AFTER INSERT ON `franqueados` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `franqueados_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `franqueados_after_update`;
DELIMITER //
CREATE TRIGGER `franqueados_after_update` AFTER UPDATE ON `franqueados` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `ibge_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `ibge_after_insert`;
DELIMITER //
CREATE TRIGGER `ibge_after_insert` AFTER INSERT ON `ibge` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `ibge_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `ibge_after_update`;
DELIMITER //
CREATE TRIGGER `ibge_after_update` AFTER UPDATE ON `ibge` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `produtos_fotos_before_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `produtos_fotos_before_insert`;
DELIMITER //
CREATE TRIGGER `produtos_fotos_before_insert` BEFORE INSERT ON `produtos_fotos` FOR EACH ROW BEGIN
	CALL allop_kidstok.sp_atualiza_data_alteracao_produtos_cab(NEW.Referencia);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `produtos_fotos_before_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `produtos_fotos_before_update`;
DELIMITER //
CREATE TRIGGER `produtos_fotos_before_update` BEFORE UPDATE ON `produtos_fotos` FOR EACH ROW BEGIN
	CALL allop_kidstok.sp_atualiza_data_alteracao_produtos_cab(NEW.Referencia);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `produtos_fotos_before_delete`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `produtos_fotos_before_delete`;
DELIMITER //
CREATE TRIGGER `produtos_fotos_before_delete` BEFORE DELETE ON `produtos_fotos` FOR EACH ROW BEGIN
	CALL allop_kidstok.sp_atualiza_data_alteracao_produtos_cab(OLD.Referencia);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `produtos_local_fisico_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `produtos_local_fisico_after_insert`;
DELIMITER //
CREATE TRIGGER `produtos_local_fisico_after_insert` AFTER INSERT ON `produtos_local_fisico` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `produtos_local_fisico_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `produtos_local_fisico_after_update`;
DELIMITER //
CREATE TRIGGER `produtos_local_fisico_after_update` AFTER UPDATE ON `produtos_local_fisico` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `provisorios_lancamentos_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `provisorios_lancamentos_after_insert`;
DELIMITER //
CREATE TRIGGER `provisorios_lancamentos_after_insert` AFTER INSERT ON `provisorios_lancamentos` FOR EACH ROW BEGIN
	CALL sp_provisorios_atualizar_totais_creditos(NEW.Provisorio);
	CALL sp_provisorios_atualizar_totais_debitos(NEW.Provisorio);
	CALL sp_provisorios_atualizar_saldo(NEW.Provisorio);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `provisorios_lancamentos_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `provisorios_lancamentos_after_update`;
DELIMITER //
CREATE TRIGGER `provisorios_lancamentos_after_update` AFTER UPDATE ON `provisorios_lancamentos` FOR EACH ROW BEGIN
	CALL sp_provisorios_atualizar_totais_creditos(NEW.Provisorio);
	CALL sp_provisorios_atualizar_totais_debitos(NEW.Provisorio);
	CALL sp_provisorios_atualizar_saldo(NEW.Provisorio);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `provisorios_lancamentos_after_delete`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `provisorios_lancamentos_after_delete`;
DELIMITER //
CREATE TRIGGER `provisorios_lancamentos_after_delete` AFTER DELETE ON `provisorios_lancamentos` FOR EACH ROW BEGIN
	CALL sp_provisorios_atualizar_totais_creditos(OLD.Provisorio);
	CALL sp_provisorios_atualizar_totais_debitos(OLD.Provisorio);
	CALL sp_provisorios_atualizar_saldo(OLD.Provisorio);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `ramo_atividades_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `ramo_atividades_after_insert`;
DELIMITER //
CREATE TRIGGER `ramo_atividades_after_insert` AFTER INSERT ON `ramo_atividades` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `ramo_atividades_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `ramo_atividades_after_update`;
DELIMITER //
CREATE TRIGGER `ramo_atividades_after_update` AFTER UPDATE ON `ramo_atividades` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `regioes_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `regioes_after_insert`;
DELIMITER //
CREATE TRIGGER `regioes_after_insert` AFTER INSERT ON `regioes` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `regioes_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `regioes_after_update`;
DELIMITER //
CREATE TRIGGER `regioes_after_update` AFTER UPDATE ON `regioes` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `responsaveis_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `responsaveis_after_insert`;
DELIMITER //
CREATE TRIGGER `responsaveis_after_insert` AFTER INSERT ON `responsaveis` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `responsaveis_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `responsaveis_after_update`;
DELIMITER //
CREATE TRIGGER `responsaveis_after_update` AFTER UPDATE ON `responsaveis` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `responsaveis_entrega_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `responsaveis_entrega_after_insert`;
DELIMITER //
CREATE TRIGGER `responsaveis_entrega_after_insert` AFTER INSERT ON `responsaveis_entrega` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `responsaveis_entrega_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `responsaveis_entrega_after_update`;
DELIMITER //
CREATE TRIGGER `responsaveis_entrega_after_update` AFTER UPDATE ON `responsaveis_entrega` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `responsaveis_tributos_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `responsaveis_tributos_after_insert`;
DELIMITER //
CREATE TRIGGER `responsaveis_tributos_after_insert` AFTER INSERT ON `responsaveis_tributos` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `responsaveis_tributos_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `responsaveis_tributos_after_update`;
DELIMITER //
CREATE TRIGGER `responsaveis_tributos_after_update` AFTER UPDATE ON `responsaveis_tributos` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `romaneios_cab_before_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `romaneios_cab_before_update`;
DELIMITER //
CREATE TRIGGER `romaneios_cab_before_update` BEFORE UPDATE ON `romaneios_cab` FOR EACH ROW BEGIN
	IF NEW.Situacao = 0 THEN
		REPLACE INTO romaneios_api	(CodigoCD, IDRomaneio)	VALUES (NEW.CD, NEW.IDRomaneio);
	END IF;


END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `romaneios_cab_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `romaneios_cab_after_update`;
DELIMITER //
CREATE TRIGGER `romaneios_cab_after_update` AFTER UPDATE ON `romaneios_cab` FOR EACH ROW BEGIN
	CALL sp_provisorios_atualizar_totais(OLD.IdProvisorio);
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `romaneios_ite_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `romaneios_ite_after_insert`;
DELIMITER //
CREATE TRIGGER `romaneios_ite_after_insert` AFTER INSERT ON `romaneios_ite` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `romaneios_ite_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `romaneios_ite_after_update`;
DELIMITER //
CREATE TRIGGER `romaneios_ite_after_update` AFTER UPDATE ON `romaneios_ite` FOR EACH ROW BEGIN

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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `romaneios_ite_after_delete`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `romaneios_ite_after_delete`;
DELIMITER //
CREATE TRIGGER `romaneios_ite_after_delete` AFTER DELETE ON `romaneios_ite` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_cofins_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_cofins_after_insert`;
DELIMITER //
CREATE TRIGGER `st_cofins_after_insert` AFTER INSERT ON `st_cofins` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_cofins_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_cofins_after_update`;
DELIMITER //
CREATE TRIGGER `st_cofins_after_update` AFTER UPDATE ON `st_cofins` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_icms_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_icms_after_insert`;
DELIMITER //
CREATE TRIGGER `st_icms_after_insert` AFTER INSERT ON `st_icms` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_icms_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_icms_after_update`;
DELIMITER //
CREATE TRIGGER `st_icms_after_update` AFTER UPDATE ON `st_icms` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_ipi_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_ipi_after_insert`;
DELIMITER //
CREATE TRIGGER `st_ipi_after_insert` AFTER INSERT ON `st_ipi` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_ipi_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_ipi_after_update`;
DELIMITER //
CREATE TRIGGER `st_ipi_after_update` AFTER UPDATE ON `st_ipi` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_origem_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_origem_after_insert`;
DELIMITER //
CREATE TRIGGER `st_origem_after_insert` AFTER INSERT ON `st_origem` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_origem_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_origem_after_update`;
DELIMITER //
CREATE TRIGGER `st_origem_after_update` AFTER UPDATE ON `st_origem` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_pis_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_pis_after_insert`;
DELIMITER //
CREATE TRIGGER `st_pis_after_insert` AFTER INSERT ON `st_pis` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `st_pis_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `st_pis_after_update`;
DELIMITER //
CREATE TRIGGER `st_pis_after_update` AFTER UPDATE ON `st_pis` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `transportadoras_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `transportadoras_after_insert`;
DELIMITER //
CREATE TRIGGER `transportadoras_after_insert` AFTER INSERT ON `transportadoras` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `transportadoras_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `transportadoras_after_update`;
DELIMITER //
CREATE TRIGGER `transportadoras_after_update` AFTER UPDATE ON `transportadoras` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `veiculos_after_insert`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `veiculos_after_insert`;
DELIMITER //
CREATE TRIGGER `veiculos_after_insert` AFTER INSERT ON `veiculos` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

-- --------------------------------------------------------
-- Estrutura da trigger `veiculos_after_update`
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS `veiculos_after_update`;
DELIMITER //
CREATE TRIGGER `veiculos_after_update` AFTER UPDATE ON `veiculos` FOR EACH ROW BEGIN
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
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
