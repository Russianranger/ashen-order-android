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

-- Dumping structure for table acore_characters.characters_npcbot_transmog
DROP TABLE IF EXISTS `characters_npcbot_transmog`;
CREATE TABLE IF NOT EXISTS `characters_npcbot_transmog` (
  `entry` int unsigned NOT NULL,
  `slot` tinyint unsigned NOT NULL,
  `item_id` int unsigned NOT NULL DEFAULT '0',
  `fake_id` int NOT NULL DEFAULT '-1',
  PRIMARY KEY (`entry`,`slot`),
  CONSTRAINT `bot_id` FOREIGN KEY (`entry`) REFERENCES `characters_npcbot` (`entry`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table acore_characters.characters_npcbot_transmog: ~14 rows (approximately)
DELETE FROM `characters_npcbot_transmog`;
INSERT INTO `characters_npcbot_transmog` (`entry`, `slot`, `item_id`, `fake_id`) VALUES
	(70897, 2, 60098, 181374),
	(70897, 4, 18686, 0),
	(84238, 0, 17182, 171724),
	(84238, 3, 11735, 76990),
	(84238, 4, 12927, 76992),
	(84238, 5, 15141, 76988),
	(84238, 6, 816864, 77186),
	(84238, 7, 11802, 76986),
	(84238, 8, 820619, 77171),
	(84238, 10, 23286, 76989),
	(84248, 0, 921680, 921679),
	(84248, 4, 816856, 0),
	(84251, 6, 22431, 0),
	(84251, 11, 22960, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
