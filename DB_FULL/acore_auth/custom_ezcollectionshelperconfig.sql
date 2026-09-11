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

-- Dumping structure for table acore_auth.custom_ezcollectionshelperconfig
DROP TABLE IF EXISTS `custom_ezcollectionshelperconfig`;
CREATE TABLE IF NOT EXISTS `custom_ezcollectionshelperconfig` (
  `RealmID` tinyint DEFAULT NULL,
  `Prefix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'ezCollections',
  `Version` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '2.4.4',
  `CacheVersion` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0',
  `ModulesConfPath` varchar(255) DEFAULT '../../etc/modules',
  `AllowedToHide` varchar(255) DEFAULT 'HEAD:SHOULDER:BACK:CHEST:TABARD:SHIRT:WRIST:HANDS:WAIST:LEGS:FEET:MAINHAND:OFFHAND:RANGED:MISC:ENCHANT'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_auth.custom_ezcollectionshelperconfig: ~0 rows (approximately)
DELETE FROM `custom_ezcollectionshelperconfig`;
INSERT INTO `custom_ezcollectionshelperconfig` (`RealmID`, `Prefix`, `Version`, `CacheVersion`, `ModulesConfPath`, `AllowedToHide`) VALUES
	(1, 'ezCollections', '2.4.4', '5', './configs/modules', 'HEAD:SHOULDER:BACK:CHEST:TABARD:SHIRT:WRIST:HANDS:WAIST:LEGS:FEET:MAINHAND:OFFHAND:RANGED:MISC:ENCHANT');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
