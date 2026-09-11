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

-- Dumping structure for table store.store_logs
DROP TABLE IF EXISTS `store_logs`;
CREATE TABLE IF NOT EXISTS `store_logs` (
  `account` int DEFAULT NULL,
  `guid` int DEFAULT NULL,
  `serviceId` int DEFAULT NULL,
  `currencyId` int DEFAULT NULL,
  `cost` int DEFAULT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table store.store_logs: ~29 rows (approximately)
DELETE FROM `store_logs`;
INSERT INTO `store_logs` (`account`, `guid`, `serviceId`, `currencyId`, `cost`, `time`) VALUES
	(3, 171, 28, 2, 190, '2024-12-05 08:42:31'),
	(3, 171, 28, 2, 190, '2024-12-10 07:50:24'),
	(3, 171, 28, 2, 190, '2024-12-20 09:11:41'),
	(3, 171, 28, 2, 190, '2025-01-09 06:42:40'),
	(3, 171, 32, 2, 750, '2025-01-14 07:29:53'),
	(3, 41, 32, 2, 500, '2025-01-21 06:41:53'),
	(3, 41, 32, 2, 500, '2025-01-21 06:41:55'),
	(3, 41, 32, 2, 500, '2025-01-21 06:41:57'),
	(3, 41, 32, 2, 500, '2025-01-21 06:41:58'),
	(3, 41, 32, 2, 500, '2025-01-21 06:42:01'),
	(3, 41, 32, 2, 500, '2025-01-21 06:42:02'),
	(3, 41, 32, 2, 500, '2025-01-21 06:42:04'),
	(3, 171, 32, 2, 500, '2025-01-21 07:28:55'),
	(3, 41, 32, 2, 500, '2025-02-11 09:43:37'),
	(3, 41, 32, 2, 500, '2025-02-11 09:43:39'),
	(3, 41, 32, 2, 500, '2025-02-11 09:43:41'),
	(3, 41, 32, 2, 500, '2025-02-11 09:43:43'),
	(3, 41, 32, 2, 500, '2025-02-11 09:43:45'),
	(3, 41, 32, 2, 500, '2025-02-11 09:43:46'),
	(3, 41, 32, 2, 500, '2025-02-11 09:43:58'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:00'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:01'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:06'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:07'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:09'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:11'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:12'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:14'),
	(3, 41, 32, 2, 500, '2025-02-11 09:44:17');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
