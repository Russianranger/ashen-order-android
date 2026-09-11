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

-- Dumping structure for table acore_world.achievement_criteria_dbc
DROP TABLE IF EXISTS `achievement_criteria_dbc`;
CREATE TABLE IF NOT EXISTS `achievement_criteria_dbc` (
  `ID` int NOT NULL DEFAULT '0',
  `Achievement_Id` int NOT NULL DEFAULT '0',
  `Type` int NOT NULL DEFAULT '0',
  `Asset_Id` int NOT NULL DEFAULT '0',
  `Quantity` int NOT NULL DEFAULT '0',
  `Start_Event` int NOT NULL DEFAULT '0',
  `Start_Asset` int NOT NULL DEFAULT '0',
  `Fail_Event` int NOT NULL DEFAULT '0',
  `Fail_Asset` int NOT NULL DEFAULT '0',
  `Description_Lang_enUS` varchar(100) DEFAULT NULL,
  `Description_Lang_enGB` varchar(100) DEFAULT NULL,
  `Description_Lang_koKR` varchar(100) DEFAULT NULL,
  `Description_Lang_frFR` varchar(100) DEFAULT NULL,
  `Description_Lang_deDE` varchar(100) DEFAULT NULL,
  `Description_Lang_enCN` varchar(100) DEFAULT NULL,
  `Description_Lang_zhCN` varchar(100) DEFAULT NULL,
  `Description_Lang_enTW` varchar(100) DEFAULT NULL,
  `Description_Lang_zhTW` varchar(100) DEFAULT NULL,
  `Description_Lang_esES` varchar(100) DEFAULT NULL,
  `Description_Lang_esMX` varchar(100) DEFAULT NULL,
  `Description_Lang_ruRU` varchar(100) DEFAULT NULL,
  `Description_Lang_ptPT` varchar(100) DEFAULT NULL,
  `Description_Lang_ptBR` varchar(100) DEFAULT NULL,
  `Description_Lang_itIT` varchar(100) DEFAULT NULL,
  `Description_Lang_Unk` varchar(100) DEFAULT NULL,
  `Description_Lang_Mask` int unsigned NOT NULL DEFAULT '0',
  `Flags` int NOT NULL DEFAULT '0',
  `Timer_Start_Event` int NOT NULL DEFAULT '0',
  `Timer_Asset_Id` int NOT NULL DEFAULT '0',
  `Timer_Time` int NOT NULL DEFAULT '0',
  `Ui_Order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table acore_world.achievement_criteria_dbc: 8 rows
DELETE FROM `achievement_criteria_dbc`;
/*!40000 ALTER TABLE `achievement_criteria_dbc` DISABLE KEYS */;
INSERT INTO `achievement_criteria_dbc` (`ID`, `Achievement_Id`, `Type`, `Asset_Id`, `Quantity`, `Start_Event`, `Start_Asset`, `Fail_Event`, `Fail_Asset`, `Description_Lang_enUS`, `Description_Lang_enGB`, `Description_Lang_koKR`, `Description_Lang_frFR`, `Description_Lang_deDE`, `Description_Lang_enCN`, `Description_Lang_zhCN`, `Description_Lang_enTW`, `Description_Lang_zhTW`, `Description_Lang_esES`, `Description_Lang_esMX`, `Description_Lang_ruRU`, `Description_Lang_ptPT`, `Description_Lang_ptBR`, `Description_Lang_itIT`, `Description_Lang_Unk`, `Description_Lang_Mask`, `Flags`, `Timer_Start_Event`, `Timer_Asset_Id`, `Timer_Time`, `Ui_Order`) VALUES
	(13478, 1430, 5, 80, 0, 0, 0, 0, 0, 'Level to 80', '80 ë ˆë²¨', 'Atteindre le niveau 80', 'Erreicht Stufe 80', 'å‡åˆ°80çº§', 'å‡è‡³80ç´š', 'Alcanza el nivel 80', 'Alcanza el nivel 80', 'Ð”Ð¾ÑÑ‚Ð¸Ð³Ð½ÑƒÑ‚ÑŒ 80-Ð³Ð¾ ÑƒÑ€Ð¾Ð²Ð½Ñ', '', '', '', '', '', '', '', 16712190, 2, 0, 0, 0, 1),
	(13475, 291, 110, 44212, 1, 0, 0, 0, 0, 'Goblin', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712190, 0, 0, 0, 0, 11),
	(13473, 2422, 110, 61815, 1, 0, 0, 0, 0, 'Goblin', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712190, 0, 0, 0, 0, 11),
	(13472, 1005, 53, 12, 1, 0, 0, 0, 0, 'Worgen', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712190, 0, 0, 0, 0, 6),
	(13474, 2422, 110, 61815, 1, 0, 0, 0, 0, 'Worgen', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712190, 0, 0, 0, 0, 12),
	(13477, 1429, 5, 80, 0, 0, 0, 0, 0, 'Level to 80', '80 ë ˆë²¨', 'Atteindre le niveau 80', 'Erreicht Stufe 80', 'å‡åˆ°80çº§', 'å‡è‡³80ç´š', 'Alcanza el nivel 80', 'Alcanza el nivel 80', 'Ð”Ð¾ÑÑ‚Ð¸Ð³Ð½ÑƒÑ‚ÑŒ 80-Ð³Ð¾ ÑƒÑ€Ð¾Ð²Ð½Ñ', '', '', '', '', '', '', '', 16712190, 2, 0, 0, 0, 1),
	(13471, 246, 53, 9, 1, 0, 0, 0, 0, 'Goblin', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712190, 0, 0, 0, 0, 6),
	(13476, 291, 110, 44212, 1, 0, 0, 0, 0, 'Worgen', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712190, 0, 0, 0, 0, 12);
/*!40000 ALTER TABLE `achievement_criteria_dbc` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
