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

-- Dumping structure for table acore_characters.characters_npcbot_gear_storage
DROP TABLE IF EXISTS `characters_npcbot_gear_storage`;
CREATE TABLE IF NOT EXISTS `characters_npcbot_gear_storage` (
  `guid` int unsigned NOT NULL DEFAULT '0',
  `item_guid` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_guid`),
  KEY `existing_player` (`guid`),
  CONSTRAINT `characters_npcbot_gear_storage_ibfk_1` FOREIGN KEY (`item_guid`) REFERENCES `item_instance` (`guid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `existing_player` FOREIGN KEY (`guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bot item storage system';

-- Dumping data for table acore_characters.characters_npcbot_gear_storage: ~22 rows (approximately)
DELETE FROM `characters_npcbot_gear_storage`;
INSERT INTO `characters_npcbot_gear_storage` (`guid`, `item_guid`) VALUES
	(41, 114919528),
	(41, 114919529),
	(41, 114919530),
	(41, 114919531),
	(41, 114919532),
	(41, 114919533),
	(41, 114919534),
	(41, 114919538),
	(41, 114919539),
	(41, 114919540),
	(41, 114919541),
	(41, 114919542),
	(41, 114919543),
	(41, 114919544),
	(41, 114919547),
	(41, 114919548),
	(41, 114919549),
	(41, 114919550),
	(41, 114919551),
	(41, 114919552),
	(41, 114919553),
	(41, 117476898);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
