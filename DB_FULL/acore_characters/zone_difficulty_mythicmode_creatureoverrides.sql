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

-- Dumping structure for table acore_characters.zone_difficulty_mythicmode_creatureoverrides
DROP TABLE IF EXISTS `zone_difficulty_mythicmode_creatureoverrides`;
CREATE TABLE IF NOT EXISTS `zone_difficulty_mythicmode_creatureoverrides` (
  `CreatureEntry` int NOT NULL DEFAULT '0',
  `HPModifier` float NOT NULL DEFAULT '1',
  `Enabled` tinyint DEFAULT '1',
  `Comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table acore_characters.zone_difficulty_mythicmode_creatureoverrides: ~4 rows (approximately)
DELETE FROM `zone_difficulty_mythicmode_creatureoverrides`;
INSERT INTO `zone_difficulty_mythicmode_creatureoverrides` (`CreatureEntry`, `HPModifier`, `Enabled`, `Comment`) VALUES
	(1128001, 1, 1, 'Chromie NPC - prevent changing hp.'),
	(18831, 2.5, 1, 'Maulgar, Gruul\'s Lair HPx2.5'),
	(19044, 2.8, 1, 'Gruul, Gruul\'s Lair HPx2.8'),
	(17257, 2.5, 1, 'Magtheridon, Magtheridon\'s Lair HPx2.5');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
