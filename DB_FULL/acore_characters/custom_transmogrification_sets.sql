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

-- Dumping structure for table acore_characters.custom_transmogrification_sets
DROP TABLE IF EXISTS `custom_transmogrification_sets`;
CREATE TABLE IF NOT EXISTS `custom_transmogrification_sets` (
  `Owner` int unsigned NOT NULL COMMENT 'Player guidlow',
  `PresetID` tinyint unsigned NOT NULL COMMENT 'Preset identifier',
  `SetName` text COMMENT 'SetName',
  `SetData` text COMMENT 'Slot1 Entry1 Slot2 Entry2',
  PRIMARY KEY (`Owner`,`PresetID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='6_1';

-- Dumping data for table acore_characters.custom_transmogrification_sets: ~7 rows (approximately)
DELETE FROM `custom_transmogrification_sets`;
INSERT INTO `custom_transmogrification_sets` (`Owner`, `PresetID`, `SetName`, `SetData`) VALUES
	(41, 0, 'Outrunner', '2 163658 3 1 4 170525 5 163402 6 800058 7 800057 8 1 9 752012 15 49778 '),
	(41, 1, 'Barbarian Elf', '2 1 4 4968 5 1 6 24145 7 20900 8 1 9 888881 15 23346 '),
	(41, 2, 'Rusted', '2 1 4 1 5 1 6 899991 7 899994 8 1 9 899992 '),
	(41, 3, 'Jade', '0 136830 2 1 14 1 4 14915 18 1 3 1 8 1 9 14917 5 1 6 14920 7 14913 '),
	(41, 4, 'Musty', '2 1 3 1 4 900114 5 1 6 900113 7 900110 8 1 9 900112 15 49778 '),
	(41, 5, 'Paladin Tattoo Set', '0 1 2 1 4 164402 18 1 3 1 8 1 9 899992 5 162853 6 61262 7 751014 16 14145 16 14145 '),
	(41, 6, 'Set', '0 1 2 99350 14 800041 4 164402 18 63378 3 1 9 113808 5 1 6 100527 7 113806 '),
	(171, 1, 'S1', '0 148548 2 28612 14 3153 4 78805 3 65008 8 16671 9 5337 5 1 6 11749 7 21688 15 133283 16 22818 15 133283 16 22818 ');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
