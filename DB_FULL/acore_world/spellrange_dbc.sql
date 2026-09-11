-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.2 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7013
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table acore_world.spellrange_dbc
DROP TABLE IF EXISTS `spellrange_dbc`;
CREATE TABLE IF NOT EXISTS `spellrange_dbc` (
  `ID` int NOT NULL DEFAULT '0',
  `RangeMin_1` float NOT NULL DEFAULT '0',
  `RangeMin_2` float NOT NULL DEFAULT '0',
  `RangeMax_1` float NOT NULL DEFAULT '0',
  `RangeMax_2` float NOT NULL DEFAULT '0',
  `Flags` int NOT NULL DEFAULT '0',
  `DisplayName_Lang_enUS` text,
  `DisplayName_Lang_enGB` text,
  `DisplayName_Lang_koKR` text,
  `DisplayName_Lang_frFR` text,
  `DisplayName_Lang_deDE` text,
  `DisplayName_Lang_enCN` text,
  `DisplayName_Lang_zhCN` text,
  `DisplayName_Lang_enTW` text,
  `DisplayName_Lang_zhTW` text,
  `DisplayName_Lang_esES` text,
  `DisplayName_Lang_esMX` text,
  `DisplayName_Lang_ruRU` text,
  `DisplayName_Lang_ptPT` text,
  `DisplayName_Lang_ptBR` text,
  `DisplayName_Lang_itIT` text,
  `DisplayName_Lang_Unk` text,
  `DisplayName_Lang_Mask` int unsigned NOT NULL DEFAULT '0',
  `DisplayNameShort_Lang_enUS` text,
  `DisplayNameShort_Lang_enGB` text,
  `DisplayNameShort_Lang_koKR` text,
  `DisplayNameShort_Lang_frFR` text,
  `DisplayNameShort_Lang_deDE` text,
  `DisplayNameShort_Lang_enCN` text,
  `DisplayNameShort_Lang_zhCN` text,
  `DisplayNameShort_Lang_enTW` text,
  `DisplayNameShort_Lang_zhTW` text,
  `DisplayNameShort_Lang_esES` text,
  `DisplayNameShort_Lang_esMX` text,
  `DisplayNameShort_Lang_ruRU` text,
  `DisplayNameShort_Lang_ptPT` text,
  `DisplayNameShort_Lang_ptBR` text,
  `DisplayNameShort_Lang_itIT` text,
  `DisplayNameShort_Lang_Unk` text,
  `DisplayNameShort_Lang_Mask` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.spellrange_dbc: 1 rows
DELETE FROM `spellrange_dbc`;
/*!40000 ALTER TABLE `spellrange_dbc` DISABLE KEYS */;
INSERT INTO `spellrange_dbc` (`ID`, `RangeMin_1`, `RangeMin_2`, `RangeMax_1`, `RangeMax_2`, `Flags`, `DisplayName_Lang_enUS`, `DisplayName_Lang_enGB`, `DisplayName_Lang_koKR`, `DisplayName_Lang_frFR`, `DisplayName_Lang_deDE`, `DisplayName_Lang_enCN`, `DisplayName_Lang_zhCN`, `DisplayName_Lang_enTW`, `DisplayName_Lang_zhTW`, `DisplayName_Lang_esES`, `DisplayName_Lang_esMX`, `DisplayName_Lang_ruRU`, `DisplayName_Lang_ptPT`, `DisplayName_Lang_ptBR`, `DisplayName_Lang_itIT`, `DisplayName_Lang_Unk`, `DisplayName_Lang_Mask`, `DisplayNameShort_Lang_enUS`, `DisplayNameShort_Lang_enGB`, `DisplayNameShort_Lang_koKR`, `DisplayNameShort_Lang_frFR`, `DisplayNameShort_Lang_deDE`, `DisplayNameShort_Lang_enCN`, `DisplayNameShort_Lang_zhCN`, `DisplayNameShort_Lang_enTW`, `DisplayNameShort_Lang_zhTW`, `DisplayNameShort_Lang_esES`, `DisplayNameShort_Lang_esMX`, `DisplayNameShort_Lang_ruRU`, `DisplayNameShort_Lang_ptPT`, `DisplayNameShort_Lang_ptBR`, `DisplayNameShort_Lang_itIT`, `DisplayNameShort_Lang_Unk`, `DisplayNameShort_Lang_Mask`) VALUES
	(114, 0, 0, 35, 35, 0, 'Hunter Range', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2031676, 'Hunter', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2031668);
/*!40000 ALTER TABLE `spellrange_dbc` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
