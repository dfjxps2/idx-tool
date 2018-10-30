-- MySQL dump 10.13  Distrib 5.7.24, for Linux (x86_64)
--
-- Host: localhost    Database: idxcfg
-- ------------------------------------------------------
-- Server version	5.7.24-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `b04_data_col`
--

DROP TABLE IF EXISTS `b04_data_col`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b04_data_col` (
  `Data_Col_Id` varchar(20) NOT NULL,
  `Data_Col_Catg` char(6) DEFAULT NULL,
  `Data_Col_Src_Flag` smallint(6) DEFAULT NULL,
  `Data_Col_Nm` varchar(60) DEFAULT NULL,
  `Data_Col_En_Nm` varchar(60) DEFAULT NULL,
  `Algor_Type` char(8) DEFAULT NULL,
  `Data_Colsql` varchar(3000) DEFAULT NULL,
  `Sts_Cycle_Type` char(2) DEFAULT NULL,
  `Dim_Type_Cd` varchar(60) DEFAULT NULL,
  `Data_Scope_Desc` varchar(3000) DEFAULT NULL,
  `Dim_Scope_Desc` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`Data_Col_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据集表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b04_data_col`
--

LOCK TABLES `b04_data_col` WRITE;
/*!40000 ALTER TABLE `b04_data_col` DISABLE KEYS */;
INSERT INTO `b04_data_col` VALUES ('DS0103010000','06',1,'六次人口普查人口基本情况','h_bj30_stat_c_03_01','ALG002','select \r\nt1.data_year\r\n,\'110100000000\' as zone_cd\r\n,t2.Adim_Ind_Id\r\nt1.value\r\nfrom historydb.h_bj30_stat_c_03_01 t1\r\nleft outer join basedb.B99_ADIM_MAP t2 on t1.item = t2.item\r\nwhere t2.Data_Col_Src_Tbl = \'h_bj30_stat_c_03_01\';','01','无','',''),('DS0106010000','06',1,'全社会固定资产投资和增长速度情况(亿元)(1978-当年)','h_bj30_stat_c_06_01','ALG001','\r\nselect\r\ndata_year\r\n,\'110100000000\' as zone_cd\r\n, \'all\' as dim_cd\r\n,investment_fixed_assets_whole_society\r\n,wsfai_urban_fixed_assets_investment\r\n,wsfai_ufai_real_estate_development_investment\r\n,tsifa_rural_investment_fixed_assets\r\n,tsifa_infrastructure_investment\r\n,investment_fixed_assets_construction_and_installation\r\n,newly_added_fixed_assets\r\n,fixed_asset_investment_whole_society_increased_over_previous_yea\r\n,investment_fixed_assets_urban_areas_increased_from_previous_year\r\n,real_estate_development_investment\r\n,investment_rural_fixed_assets\r\n,infrastructure_investment\r\n,construction_and_installation_investment\r\nfrom historydb.h_bj30_stat_c_06_01  where stat_year=\'2017\' ;','01','无','',''),('DS0106140000','06',1,'保障性安居工程建设情况(亿元、万平方米)','h_bj30_stat_c_06_14','ALG003','select \r\nt1.data_year\r\n,\'110100000000\' as zone_cd\r\n,t2.Adim_Ind_Id\r\nt1.value\r\nt1.year_last_year_pct\r\nfrom historydb.h_bj30_stat_c_06_14 t1\r\nleft outer join basedb.B99_ADIM_MAP t2 on t1.item = t2.item\r\nwhere t2.Data_Col_Src_Tbl = \'h_bj30_stat_c_06_14\';','01','无','','');
/*!40000 ALTER TABLE `b04_data_col` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `b04_ind_cfg`
--

DROP TABLE IF EXISTS `b04_ind_cfg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `b04_ind_cfg` (
  `Data_Col_Id` varchar(20) NOT NULL,
  `Fld_Id` int(11) NOT NULL,
  `Fld_Cn_Nm` varchar(80) DEFAULT NULL,
  `Fld_En_Nm` varchar(80) DEFAULT NULL,
  `Fld_Type` varchar(20) DEFAULT NULL,
  `Dim_Ind` smallint(6) DEFAULT NULL,
  `Ind_Cn_Nm` varchar(60) DEFAULT NULL,
  `Ind_Id` varchar(20) DEFAULT NULL,
  `Iba_Fld_Nm` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`Data_Col_Id`,`Fld_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='指标配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `b04_ind_cfg`
--

LOCK TABLES `b04_ind_cfg` WRITE;
/*!40000 ALTER TABLE `b04_ind_cfg` DISABLE KEYS */;
INSERT INTO `b04_ind_cfg` VALUES ('DS0103010000',1,'数据年份','data_year','string',1,'','','data_cycle'),('DS0103010000',2,'区域编号','zone_cd','string',1,'','','region_cd'),('DS0103010000',3,'分析维度编号','dim_cd','string',2,'','','dim_cd'),('DS0103010000',4,'值','value','string',0,'','',''),('DS0103010000',5,'指标ID','dim_cd','string',1,'指标ID','','ind_id'),('DS0106010000',1,'数据年份','data_year','string',1,'','','data_cycle'),('DS0106010000',2,'区域编号','zone_cd','string',1,'','','region_cd'),('DS0106010000',3,'分析维度编号','dim_cd','string',1,'','','dim_cd'),('DS0106010000',4,'全社会固定资产投资','investment_fixed_assets_whole_society','string',0,'固定资产投资金额','I0106010001',''),('DS0106010000',5,'全社会固定资产投资-城镇固定资产投资','wsfai_urban_fixed_assets_investment','string',0,'固定资产城镇投资金额','I0106010002',''),('DS0106010000',6,'全社会固定资产投资-城镇固定资产投资-房地产开发投资','wsfai_ufai_real_estate_development_investment','string',0,'固定资产城镇房地产开发投资金额','I0106010003',''),('DS0106010000',7,'全社会固定资产投资-农村固定资产投资','tsifa_rural_investment_fixed_assets','string',0,'固定资产农村投资金额','I0106010004',''),('DS0106010000',8,'全社会固定资产投资-基础设施投资','tsifa_infrastructure_investment','string',0,'固定资产基础设施投资金额','I0106010005',''),('DS0106010000',9,'全社会固定资产投资-建筑安装投资','investment_fixed_assets_construction_and_installation','string',0,'固定资产建筑安装投资金额','I0106010005',''),('DS0106010000',10,'新增固定资产','newly_added_fixed_assets','string',0,'新增固定资产金额','I0106010007',''),('DS0106010000',11,'全社会固定资产投资比上年增长','fixed_asset_investment_whole_society_increased_over_previous_yea','string',0,'固定资产投资额同比增长比例','I0106010008',''),('DS0106010000',12,'全社会固定资产投资比上年增长-城镇固定资产投资','investment_fixed_assets_urban_areas_increased_from_previous_year','string',0,'固定资产城镇投资额同比增长比例','I0106010009',''),('DS0106010000',13,'房地产开发投资','real_estate_development_investment','string',0,'固定资产城镇房地产开发投资额同比增长比例','I0106010010',''),('DS0106010000',14,'农村固定资产投资','investment_rural_fixed_assets','string',0,'固定资产农村投资额同比增长比例','I0106010011',''),('DS0106010000',15,'基础设施投资','infrastructure_investment','string',0,'固定资产基础设施投资额同比增长比例','I0106010012',''),('DS0106010000',16,'建筑安装投资','construction_and_installation_investment','string',0,'固定资产建筑安装投资额同比增长比例','I0106010013',''),('DS0106140000',1,'数据年份','data_year','string',1,'','','data_cycle'),('DS0106140000',2,'区域编号','zone_cd','string',1,'','','region_cd'),('DS0106140000',3,'指标ID','dim_cd','string',1,'指标ID',NULL,'ind_id'),('DS0106140000',4,'分析维度编号','dim_cd','string',2,'','','dim_cd'),('DS0106140000',5,'值','value','string',0,'','01',''),('DS0106140000',6,'当年为去年占比','year_last_year_pct','string',0,'','02','');
/*!40000 ALTER TABLE `b04_ind_cfg` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-30 21:44:37
