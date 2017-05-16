/*
SQLyog Ultimate - MySQL GUI v8.22 
MySQL - 5.5.5-10.1.0-MariaDB : Database - esf
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`esf` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;

USE `esf`;

/*Table structure for table `certificate` */

DROP TABLE IF EXISTS `certificate`;

CREATE TABLE `certificate` (
  `CERTIFICATE_SERIAL_NUMBER` varchar(200) COLLATE utf8_bin NOT NULL,
  `CERTIFICATE` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`CERTIFICATE_SERIAL_NUMBER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `invoice` */

DROP TABLE IF EXISTS `invoice`;

CREATE TABLE `invoice` (
  `INVOICE_ID` bigint(20) unsigned NOT NULL,
  `NUM` varchar(120) COLLATE utf8_bin NOT NULL,
  `DATE` bigint(20) NOT NULL,
  `TURNOVER_DATE` timestamp NULL DEFAULT NULL,
  `REGISTRATION_NUMBER` varchar(80) COLLATE utf8_bin DEFAULT NULL,
  `RELATED_DATE` bigint(20) DEFAULT NULL,
  `RELATED_NUM` varchar(120) COLLATE utf8_bin DEFAULT NULL,
  `RELATED_REGISTRATION_NUMBER` varchar(80) COLLATE utf8_bin DEFAULT NULL,
  `INVOICE_TYPE` tinyint(4) unsigned NOT NULL,
  `DELIVERY_CONTRACT_NUM` varchar(80) COLLATE utf8_bin DEFAULT NULL,
  `DELIVERY_CONTRACT_DATE` timestamp NULL DEFAULT NULL,
  `DELIVERY_TERM` text COLLATE utf8_bin,
  `DELIVERY_EXERCISE_WAY` text COLLATE utf8_bin,
  `DELIVERY_WARRANT` varchar(120) COLLATE utf8_bin DEFAULT NULL,
  `DELIVERY_WARRANT_DATE` timestamp NULL DEFAULT NULL,
  `DELIVERY_DESTINATION` text COLLATE utf8_bin,
  `CONSIGNOR_TIN` varchar(12) COLLATE utf8_bin DEFAULT NULL,
  `CONSIGNOR_NAME` text COLLATE utf8_bin,
  `CONSIGNOR_ADDRESS` text COLLATE utf8_bin,
  `CONSIGNEE_TIN` varchar(12) COLLATE utf8_bin DEFAULT NULL,
  `CONSIGNEE_NAME` text COLLATE utf8_bin,
  `CONSIGNEE_ADDRESS` text COLLATE utf8_bin,
  `PUBLIC_OFFICE_IIK` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `PUBLIC_OFFICE_PRODUCT_CODE` varchar(24) COLLATE utf8_bin DEFAULT NULL,
  `PUBLIC_OFFICE_PAY_PURPOSE` text COLLATE utf8_bin,
  `SIGNATURE_TYPE` tinyint(4) unsigned NOT NULL,
  `SIGNATURE` text COLLATE utf8_bin,
  `OPERATOR_FULL_NAME` text COLLATE utf8_bin,
  `ADD_INF` text COLLATE utf8_bin,
  `CERTIFICATE_SERIAL_NUMBER` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `PRODUCT_CURRENCY_CODE` varchar(3) COLLATE utf8_bin NOT NULL,
  `PRODUCT_CURRENCY_RATE` decimal(14,2) DEFAULT NULL,
  `PRODUCT_TOTAL_PRICE_WITHOUT_TAX` decimal(17,2) NOT NULL,
  `PRODUCT_TOTAL_EXCISE_AMOUNT` decimal(14,2) NOT NULL,
  `PRODUCT_TOTAL_TURNOVER_SIZE` decimal(17,2) NOT NULL,
  `PRODUCT_TOTAL_NDS_AMOUNT` decimal(14,2) NOT NULL,
  `PRODUCT_TOTAL_PRICE_WITH_TAX` decimal(17,2) NOT NULL,
  `DRAFT_ID` bigint(20) DEFAULT NULL,
  `IMPORTED_ID` bigint(20) DEFAULT NULL,
  `INPUT_DATE` bigint(20) NOT NULL,
  `OLD_SIGNATURE` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`INVOICE_ID`),
  KEY `idx_num` (`NUM`),
  KEY `idx_invoice_type` (`INVOICE_TYPE`),
  KEY `idx_registration_number` (`REGISTRATION_NUMBER`),
  KEY `idx_input_date` (`INPUT_DATE`),
  KEY `idx_input_date_type` (`INVOICE_TYPE`,`INPUT_DATE`),
  KEY `idx_date` (`DATE`),
  KEY `idx_product_currency_code` (`PRODUCT_CURRENCY_CODE`),
  KEY `idx_product_total_turnover_size` (`PRODUCT_TOTAL_TURNOVER_SIZE`),
  KEY `idx_product_total_nds_amount` (`PRODUCT_TOTAL_NDS_AMOUNT`),
  KEY `idx_product_total_price_without_tax` (`PRODUCT_TOTAL_PRICE_WITHOUT_TAX`),
  KEY `idx_product_total_price_with_tax` (`PRODUCT_TOTAL_PRICE_WITH_TAX`),
  KEY `idx_product_total_price_excise_amount` (`PRODUCT_TOTAL_EXCISE_AMOUNT`),
  KEY `idx_num_date` (`NUM`,`DATE`),
  KEY `idx_related_num_date` (`RELATED_DATE`,`RELATED_NUM`),
  KEY `idx_consignor_name` (`CONSIGNOR_NAME`(10)),
  KEY `idx_consignee_name` (`CONSIGNEE_NAME`(10)),
  KEY `idx_consignor_address` (`CONSIGNOR_ADDRESS`(10)),
  KEY `idx_consignee_address` (`CONSIGNEE_ADDRESS`(10)),
  KEY `idx_operator_full_name` (`OPERATOR_FULL_NAME`(10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `invoice_hash` */

DROP TABLE IF EXISTS `invoice_hash`;

CREATE TABLE `invoice_hash` (
  `INVOICE_ID` bigint(20) unsigned NOT NULL,
  `INVOICE_HASH` mediumtext COLLATE utf8_bin,
  PRIMARY KEY (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `invoice_history` */

DROP TABLE IF EXISTS `invoice_history`;

CREATE TABLE `invoice_history` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `INVOICE_ID` bigint(20) unsigned NOT NULL,
  `INVOICE_STATUS` tinyint(4) unsigned NOT NULL,
  `DATE` bigint(20) DEFAULT NULL,
  `CLIENT_ID` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `USER_ID` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `USER_NAME` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION` text COLLATE utf8_bin,
  `AGENT_TYPE` tinyint(4) unsigned DEFAULT NULL,
  `USER_ACCESS_UID` binary(16) DEFAULT NULL,
  `CHANGE_TYPE` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `idx_id_invoice_id` (`ID`,`INVOICE_ID`),
  KEY `idx_invoice_id` (`INVOICE_ID`),
  KEY `idx_invoice_status` (`INVOICE_STATUS`),
  KEY `idx_date` (`DATE`),
  KEY `idx_status_date` (`INVOICE_STATUS`,`DATE`)
) ENGINE=InnoDB AUTO_INCREMENT=321 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `jo_op_participant` */

DROP TABLE IF EXISTS `jo_op_participant`;

CREATE TABLE `jo_op_participant` (
  `INVOICE_ID` bigint(20) unsigned NOT NULL,
  `IDX` smallint(5) unsigned NOT NULL,
  `SHARE_IDX` smallint(5) unsigned NOT NULL,
  `TYPE` tinyint(4) unsigned NOT NULL,
  `TIN` varchar(12) COLLATE utf8_bin DEFAULT NULL,
  `PRODUCT_SHARE_PRODUCT_NUMBER` int(10) unsigned NOT NULL,
  `PRODUCT_SHARE_PRODUCT_QUANTITY` decimal(18,6) NOT NULL,
  `PRODUCT_SHARE_PRICE_WITHOUT_TAX` decimal(18,6) DEFAULT NULL,
  `PRODUCT_SHARE_EXCISE_AMOUNT` decimal(18,6) DEFAULT NULL,
  `PRODUCT_SHARE_TURNOVER_SIZE` decimal(18,6) DEFAULT NULL,
  `PRODUCT_SHARE_NDS_AMOUNT` decimal(18,6) DEFAULT NULL,
  `PRODUCT_SHARE_PRICE_WITH_TAX` decimal(18,6) DEFAULT NULL,
  KEY `idx_invoice_id` (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `messages` */

DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `IS_SYSTEM` tinyint(1) DEFAULT NULL,
  `SENDER_TIN` varchar(12) COLLATE utf8_bin DEFAULT NULL,
  `OPERATOR_LOGIN` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `OPERATOR_FULLNAME` text COLLATE utf8_bin,
  `SENDER_FULLNAME` text COLLATE utf8_bin,
  `CREATED_TIMESTAMP` bigint(20) DEFAULT NULL,
  `RECIPIENT_TIN` varchar(12) COLLATE utf8_bin DEFAULT NULL,
  `RECIPIENT_FULLNAME` text COLLATE utf8_bin,
  `INVOICE_ID` bigint(20) unsigned DEFAULT NULL,
  `INVOICE_KEY` varchar(80) COLLATE utf8_bin DEFAULT NULL,
  `RECIPIENT_GROUP` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `TXT` text COLLATE utf8_bin,
  `TXT_KZ` text COLLATE utf8_bin,
  PRIMARY KEY (`ID`),
  KEY `idx_invoice` (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `participant` */

DROP TABLE IF EXISTS `participant`;

CREATE TABLE `participant` (
    `INVOICE_ID` BIGINT(20) UNSIGNED NOT NULL,
    `IDX` SMALLINT(5) UNSIGNED NOT NULL,
    `TYPE` TINYINT(4) UNSIGNED NOT NULL,
    `TIN` VARCHAR(12) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `TIN_SEARCH` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
    `COUNTRY_CODE` VARCHAR(3) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `NAME` TEXT NULL COLLATE 'utf8_bin',
    `ADDRESS` TEXT NULL COLLATE 'utf8_bin',
    `CERTIFICATE_SERIES` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `CERTIFICATE_NUM` VARCHAR(7) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `STATUSES` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
    `DELIVERY_DOC_NUM` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `DELIVERY_DOC_DATE` TIMESTAMP NULL DEFAULT NULL,
    `KBE` VARCHAR(2) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `BIK` VARCHAR(8) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `IIK` VARCHAR(34) NULL DEFAULT NULL COLLATE 'utf8_bin',
    `BANK` TEXT NULL COLLATE 'utf8_bin',
    `TRAILER` TEXT NULL COLLATE 'utf8_bin',
    INDEX `idx_invoice_id` (`INVOICE_ID`),
    INDEX `idx_invoice_id_type` (`INVOICE_ID`, `TYPE`),
    INDEX `idx_tin_search` (`TIN_SEARCH`),
    INDEX `idx_name` (`NAME`(10)),
    INDEX `idx_address` (`ADDRESS`(10))
) COLLATE='utf8_bin' ENGINE=InnoDB;

/*Table structure for table `product` */

DROP TABLE IF EXISTS `product`;

CREATE TABLE `product` (
  `INVOICE_ID` bigint(20) unsigned NOT NULL,
  `IDX` smallint(5) unsigned NOT NULL,
  `DESCRIPTION` text COLLATE utf8_bin NOT NULL,
  `UNIT_CODE` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `UNIT_NOMENCLATURE` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `UNIT_PRICE` decimal(18,6) DEFAULT NULL,
  `PRICE_WITHOUT_TAX` decimal(17,2) NOT NULL,
  `EXCISE_RATE` decimal(14,2) DEFAULT NULL,
  `EXCISE_AMOUNT` decimal(17,2) DEFAULT NULL,
  `TURNOVER_SIZE` decimal(17,2) NOT NULL,
  `NDS_RATE` int(11) DEFAULT NULL,
  `NDS_AMOUNT` decimal(17,2) NOT NULL,
  `PRICE_WITH_TAX` decimal(17,2) NOT NULL,
  `APPLICATION_NUMBER_IN_CUSTOMS_UNION` varchar(80) COLLATE utf8_bin DEFAULT NULL,
  `ADDITIONAL` text COLLATE utf8_bin,
  KEY `idx_invoice_id` (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `state` */

DROP TABLE IF EXISTS `state`;

CREATE TABLE `state` (
  `INVOICE_ID` bigint(20) unsigned NOT NULL,
  `STATUS` tinyint(4) unsigned NOT NULL,
  `CANCEL_REASON` text COLLATE utf8_bin,
  `LAST_UPDATE_DATE` bigint(20) NOT NULL,
  `DELIVERY_DATE` timestamp NULL DEFAULT NULL,
  `VERSION` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ID`),
  KEY `idx_status` (`STATUS`),
  KEY `idx_last_update_date` (`LAST_UPDATE_DATE`),
  KEY `idx_status_last_update_date` (`STATUS`,`LAST_UPDATE_DATE`),
  KEY `idx_invoice_id_status` (`INVOICE_ID`,`STATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `user_access` */

DROP TABLE IF EXISTS `user_access`;

CREATE TABLE `user_access` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `USER_TIN` bigint(20) unsigned DEFAULT NULL,
  `AGENT_TYPE` tinyint(4) unsigned DEFAULT NULL,
  `USER_FULL_NAME` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `SERVICE` text COLLATE utf8_bin,
  `IP_ADDRESS` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `ACCESS_TIME` timestamp NULL DEFAULT NULL,
  `UID` binary(16) DEFAULT NULL,
  `REQUEST_CONTENT` mediumtext COLLATE utf8_bin,
  PRIMARY KEY (`ID`),
  KEY `idx_service` (`SERVICE`(5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `user_access_component_description` */

DROP TABLE IF EXISTS `user_access_component_description`;

ALTER TABLE `jo_op_participant` ADD COLUMN `ID` BIGINT NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`ID`);
ALTER TABLE `participant` ADD COLUMN `ID` BIGINT NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`ID`);
ALTER TABLE `product` ADD COLUMN `ID` BIGINT NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`ID`);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
