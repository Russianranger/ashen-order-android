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

-- Dumping structure for table acore_world.mapdifficulty_dbc
DROP TABLE IF EXISTS `mapdifficulty_dbc`;
CREATE TABLE IF NOT EXISTS `mapdifficulty_dbc` (
  `ID` int NOT NULL DEFAULT '0',
  `MapID` int NOT NULL DEFAULT '0',
  `Difficulty` int NOT NULL DEFAULT '0',
  `Message_Lang_enUS` varchar(200) DEFAULT NULL,
  `Message_Lang_enGB` varchar(200) DEFAULT NULL,
  `Message_Lang_koKR` varchar(200) DEFAULT NULL,
  `Message_Lang_frFR` varchar(200) DEFAULT NULL,
  `Message_Lang_deDE` varchar(200) DEFAULT NULL,
  `Message_Lang_enCN` varchar(200) DEFAULT NULL,
  `Message_Lang_zhCN` varchar(200) DEFAULT NULL,
  `Message_Lang_enTW` varchar(200) DEFAULT NULL,
  `Message_Lang_zhTW` varchar(200) DEFAULT NULL,
  `Message_Lang_esES` varchar(200) DEFAULT NULL,
  `Message_Lang_esMX` varchar(200) DEFAULT NULL,
  `Message_Lang_ruRU` varchar(200) DEFAULT NULL,
  `Message_Lang_ptPT` varchar(200) DEFAULT NULL,
  `Message_Lang_ptBR` varchar(200) DEFAULT NULL,
  `Message_Lang_itIT` varchar(200) DEFAULT NULL,
  `Message_Lang_Unk` varchar(100) DEFAULT NULL,
  `Message_Lang_Mask` int unsigned NOT NULL DEFAULT '0',
  `RaidDuration` int NOT NULL DEFAULT '0',
  `MaxPlayers` int NOT NULL DEFAULT '0',
  `Difficultystring` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.mapdifficulty_dbc: 2 rows
DELETE FROM `mapdifficulty_dbc`;
/*!40000 ALTER TABLE `mapdifficulty_dbc` DISABLE KEYS */;
INSERT INTO `mapdifficulty_dbc` (`ID`, `MapID`, `Difficulty`, `Message_Lang_enUS`, `Message_Lang_enGB`, `Message_Lang_koKR`, `Message_Lang_frFR`, `Message_Lang_deDE`, `Message_Lang_enCN`, `Message_Lang_zhCN`, `Message_Lang_enTW`, `Message_Lang_zhTW`, `Message_Lang_esES`, `Message_Lang_esMX`, `Message_Lang_ruRU`, `Message_Lang_ptPT`, `Message_Lang_ptBR`, `Message_Lang_itIT`, `Message_Lang_Unk`, `Message_Lang_Mask`, `RaidDuration`, `MaxPlayers`, `Difficultystring`) VALUES
	(755, 249, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 604800, 25, 'RAID_DIFFICULTY_40PLAYER'),
	(754, 533, 2, 'You must be level 60 and in a raid group to enter.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16712190, 604800, 25, 'RAID_DIFFICULTY_40PLAYER');
/*!40000 ALTER TABLE `mapdifficulty_dbc` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
