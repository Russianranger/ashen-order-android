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

-- Dumping structure for table ac_eluna.eventscript_encounters
DROP TABLE IF EXISTS `eventscript_encounters`;
CREATE TABLE IF NOT EXISTS `eventscript_encounters` (
  `time_stamp` int NOT NULL,
  `playerGuid` int NOT NULL,
  `encounter` int DEFAULT '0',
  `difficulty` tinyint DEFAULT '0',
  `group_type` tinyint DEFAULT '0',
  `duration` int NOT NULL,
  PRIMARY KEY (`time_stamp`,`playerGuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table ac_eluna.eventscript_encounters: 4 rows
DELETE FROM `eventscript_encounters`;
/*!40000 ALTER TABLE `eventscript_encounters` DISABLE KEYS */;
INSERT INTO `eventscript_encounters` (`time_stamp`, `playerGuid`, `encounter`, `difficulty`, `group_type`, `duration`) VALUES
	(1678004492, 1, 1, 1, 1, 20171),
	(1678004416, 1, 1, 10, 1, 3198),
	(1678004392, 1, 1, 10, 1, 18494),
	(1678004342, 1, 1, 10, 1, 44796);
/*!40000 ALTER TABLE `eventscript_encounters` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
