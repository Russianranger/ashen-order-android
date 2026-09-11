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

-- Dumping structure for table acore_characters.custom_item_enchant_visuals
DROP TABLE IF EXISTS `custom_item_enchant_visuals`;
CREATE TABLE IF NOT EXISTS `custom_item_enchant_visuals` (
  `iguid` int unsigned NOT NULL COMMENT 'item DB guid',
  `display` int unsigned NOT NULL COMMENT 'enchantID',
  PRIMARY KEY (`iguid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='stores the enchant IDs for the visuals';

-- Dumping data for table acore_characters.custom_item_enchant_visuals: ~5 rows (approximately)
DELETE FROM `custom_item_enchant_visuals`;
INSERT INTO `custom_item_enchant_visuals` (`iguid`, `display`) VALUES
	(112165640, 13),
	(120363479, 2673),
	(120363480, 2673),
	(125963132, 13),
	(146316148, 1903);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
