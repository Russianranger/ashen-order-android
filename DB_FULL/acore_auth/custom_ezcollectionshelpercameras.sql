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

-- Dumping structure for table acore_auth.custom_ezcollectionshelpercameras
DROP TABLE IF EXISTS `custom_ezcollectionshelpercameras`;
CREATE TABLE IF NOT EXISTS `custom_ezcollectionshelpercameras` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `option` int DEFAULT NULL,
  `race` int DEFAULT '30',
  `sex` int DEFAULT '3',
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `f` float DEFAULT NULL,
  `anim` int DEFAULT '0',
  `name` int DEFAULT '0',
  `class` int DEFAULT '2',
  `subclass` int DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table acore_auth.custom_ezcollectionshelpercameras: ~0 rows (approximately)
DELETE FROM `custom_ezcollectionshelpercameras`;
INSERT INTO `custom_ezcollectionshelpercameras` (`Id`, `option`, `race`, `sex`, `x`, `y`, `z`, `f`, `anim`, `name`, `class`, `subclass`) VALUES
	(1, 1, 30, 3, -1, -1, -1, -1, 0, 0, 2, 15);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
