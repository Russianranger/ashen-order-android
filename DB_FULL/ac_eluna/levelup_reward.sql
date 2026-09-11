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

-- Dumping structure for table ac_eluna.levelup_reward
DROP TABLE IF EXISTS `levelup_reward`;
CREATE TABLE IF NOT EXISTS `levelup_reward` (
  `level` int NOT NULL,
  `counter` int DEFAULT '0',
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table ac_eluna.levelup_reward: ~30 rows (approximately)
DELETE FROM `levelup_reward`;
INSERT INTO `levelup_reward` (`level`, `counter`) VALUES
	(2, 4),
	(5, 1),
	(6, 1),
	(15, 2),
	(20, 1),
	(21, 4),
	(22, 2),
	(23, 1),
	(24, 3),
	(25, 24),
	(26, 5),
	(27, 7),
	(28, 3),
	(30, 1),
	(32, 1),
	(35, 1),
	(38, 1),
	(39, 1),
	(45, 1),
	(61, 16),
	(62, 12),
	(63, 4),
	(65, 11),
	(69, 1),
	(70, 1),
	(71, 1),
	(75, 2),
	(76, 1),
	(77, 1),
	(80, 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
