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

-- Dumping structure for table acore_characters.character_homebind
DROP TABLE IF EXISTS `character_homebind`;
CREATE TABLE IF NOT EXISTS `character_homebind` (
  `guid` int unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `mapId` smallint unsigned NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
  `zoneId` smallint unsigned NOT NULL DEFAULT '0' COMMENT 'Zone Identifier',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Player System';

-- Dumping data for table acore_characters.character_homebind: ~17 rows (approximately)
DELETE FROM `character_homebind`;
INSERT INTO `character_homebind` (`guid`, `mapId`, `zoneId`, `posX`, `posY`, `posZ`) VALUES
	(3, 0, 85, 1676.71, 1678.31, 121.67),
	(41, 0, 1519, -8866.22, 671.43, 97.9028),
	(43, 0, 1519, -8874.52, 1053.25, 104.8),
	(44, 1, 1637, 1633.33, -4439.11, 15.7588),
	(51, 0, 1519, -8874.52, 1053.25, 104.8),
	(137, 0, 2117, 1676.71, 1678.31, 121.67),
	(139, 1, 188, 10311.3, 832.463, 1326.41),
	(159, 1, 221, -2917.58, -257.98, 52.9968),
	(163, 530, 3431, 10349.6, -6357.29, 33.4026),
	(168, 0, 9, -8949.95, -132.493, 83.5312),
	(171, 0, 340, -6652.54, -2149.76, 245.351),
	(186, 530, 3431, 10349.6, -6357.29, 33.4026),
	(187, 530, 3526, -3961.64, -13931.2, 100.615),
	(189, 1, 221, -2917.58, -257.98, 52.9968),
	(191, 0, 1519, -8874.52, 1053.25, 104.8),
	(194, 0, 9, -8949.95, -132.493, 83.5312),
	(199, 0, 9, -8949.95, -132.493, 83.5312);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
