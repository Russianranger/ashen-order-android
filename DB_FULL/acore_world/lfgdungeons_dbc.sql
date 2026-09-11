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

-- Dumping structure for table acore_world.lfgdungeons_dbc
DROP TABLE IF EXISTS `lfgdungeons_dbc`;
CREATE TABLE IF NOT EXISTS `lfgdungeons_dbc` (
  `ID` int NOT NULL DEFAULT '0',
  `Name_Lang_enUS` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_enGB` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_koKR` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_frFR` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_deDE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_enCN` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_zhCN` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_enTW` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_zhTW` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_esES` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_esMX` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_ruRU` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_ptPT` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_ptBR` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_itIT` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_Unk` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Name_Lang_Mask` int unsigned NOT NULL DEFAULT '0',
  `MinLevel` int NOT NULL DEFAULT '0',
  `MaxLevel` int NOT NULL DEFAULT '0',
  `Target_Level` int NOT NULL DEFAULT '0',
  `Target_Level_Min` int NOT NULL DEFAULT '0',
  `Target_Level_Max` int NOT NULL DEFAULT '0',
  `MapID` int NOT NULL DEFAULT '0',
  `Difficulty` int NOT NULL DEFAULT '0',
  `Flags` int NOT NULL DEFAULT '0',
  `TypeID` int NOT NULL DEFAULT '0',
  `Faction` int NOT NULL DEFAULT '0',
  `TextureFilename` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ExpansionLevel` int NOT NULL DEFAULT '0',
  `Order_Index` int NOT NULL DEFAULT '0',
  `Group_Id` int NOT NULL DEFAULT '0',
  `Description_Lang_enUS` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_enGB` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_koKR` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_frFR` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_deDE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_enCN` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_zhCN` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_enTW` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_zhTW` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_esES` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_esMX` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_ruRU` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_ptPT` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_ptBR` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_itIT` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_Unk` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Description_Lang_Mask` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table acore_world.lfgdungeons_dbc: ~2 rows (approximately)
DELETE FROM `lfgdungeons_dbc`;
INSERT INTO `lfgdungeons_dbc` (`ID`, `Name_Lang_enUS`, `Name_Lang_enGB`, `Name_Lang_koKR`, `Name_Lang_frFR`, `Name_Lang_deDE`, `Name_Lang_enCN`, `Name_Lang_zhCN`, `Name_Lang_enTW`, `Name_Lang_zhTW`, `Name_Lang_esES`, `Name_Lang_esMX`, `Name_Lang_ruRU`, `Name_Lang_ptPT`, `Name_Lang_ptBR`, `Name_Lang_itIT`, `Name_Lang_Unk`, `Name_Lang_Mask`, `MinLevel`, `MaxLevel`, `Target_Level`, `Target_Level_Min`, `Target_Level_Max`, `MapID`, `Difficulty`, `Flags`, `TypeID`, `Faction`, `TextureFilename`, `ExpansionLevel`, `Order_Index`, `Group_Id`, `Description_Lang_enUS`, `Description_Lang_enGB`, `Description_Lang_koKR`, `Description_Lang_frFR`, `Description_Lang_deDE`, `Description_Lang_enCN`, `Description_Lang_zhCN`, `Description_Lang_enTW`, `Description_Lang_zhTW`, `Description_Lang_esES`, `Description_Lang_esMX`, `Description_Lang_ruRU`, `Description_Lang_ptPT`, `Description_Lang_ptBR`, `Description_Lang_itIT`, `Description_Lang_Unk`, `Description_Lang_Mask`) VALUES
	(1000, 'Onyxia\\\'s Lair (Vanilla)', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712190, 60, 83, 60, 60, 83, 249, 2, 0, 2, -1, '', 2, 0, 9, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712188),
	(1001, 'Naxxramas (Vanilla)', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712190, 60, 83, 60, 60, 83, 533, 2, 0, 2, -1, '', 2, 0, 9, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 16712188);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
