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

-- Dumping structure for table acore_characters.emblem_transferences
DROP TABLE IF EXISTS `emblem_transferences`;
CREATE TABLE IF NOT EXISTS `emblem_transferences` (
  `sender_guid` int NOT NULL,
  `receiver_guid` int NOT NULL,
  `emblem_entry` mediumint NOT NULL,
  `amount` int NOT NULL,
  `active` bit(1) NOT NULL DEFAULT b'1',
  `sent_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `received_timestamp` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='[mod-emblem-transfer] Registers transferences between characters';

-- Dumping data for table acore_characters.emblem_transferences: ~2 rows (approximately)
DELETE FROM `emblem_transferences`;
INSERT INTO `emblem_transferences` (`sender_guid`, `receiver_guid`, `emblem_entry`, `amount`, `active`, `sent_timestamp`, `received_timestamp`) VALUES
	(41, 44, 47241, 16, b'0', '2024-07-28 04:35:55', '2024-08-07 15:49:36'),
	(175, 44, 829435, 8, b'0', '2024-08-07 15:38:58', '2024-08-07 15:49:36');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
