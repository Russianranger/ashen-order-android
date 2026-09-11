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

-- Dumping structure for table ac_eluna.binding_menu
DROP TABLE IF EXISTS `binding_menu`;
CREATE TABLE IF NOT EXISTS `binding_menu` (
  `entry` int unsigned NOT NULL AUTO_INCREMENT,
  `CharID` int unsigned DEFAULT NULL,
  `BindName` varchar(40) DEFAULT NULL,
  `mappId` int unsigned DEFAULT NULL,
  `xCoord` varchar(12) DEFAULT NULL,
  `yCoord` varchar(12) DEFAULT NULL,
  `zCoord` varchar(12) DEFAULT NULL,
  `orientation` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`entry`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table ac_eluna.binding_menu: ~25 rows (approximately)
DELETE FROM `binding_menu`;
INSERT INTO `binding_menu` (`entry`, `CharID`, `BindName`, `mappId`, `xCoord`, `yCoord`, `zCoord`, `orientation`) VALUES
	(52, 44, 'Ayamiss', 509, '-9612.6230', '1567.47875', '21.8143672', '3.32232332'),
	(53, 157, 'Testspot', 0, '-13593.007', '-289.80746', '15.5685558', '1.27349722'),
	(54, 157, 'test2', 1, '-5409.2695', '3664.95410', '9.06869029', '2.67197465'),
	(55, 44, 'Gilneas Portraits', 0, '-1492.3575', '1437.80651', '35.8731155', '4.67972898'),
	(56, 44, 'SM Art', 189, '241.740005', '-328.93884', '18.5347633', '0.17633168'),
	(57, 41, 'BWL Entrance', 0, '-7664.6103', '-1216.5991', '287.787658', '3.96580100'),
	(58, 41, 'ubrs', 229, '113.285293', '-319.37417', '66.2161026', '0.06725572'),
	(60, 44, 'KJ', 580, '1686.09057', '602.348876', '28.0502986', '1.40403544'),
	(61, 41, 'Morgans Vigil', 0, '-8375.2333', '-2751.3247', '186.562805', '1.95203673'),
	(62, 41, 'BRS Entrance', 0, '-7524.9306', '-1228.8500', '285.731842', '2.09543991'),
	(63, 41, 'Ironforge', 0, '-4923.0854', '-952.62243', '501.530853', '0.99892657'),
	(65, 41, 'Lights Hope', 0, '2280.89184', '-5316.1347', '88.3068008', '1.83676862'),
	(66, 41, 'av cave', 0, '-13.590420', '-326.68698', '131.373855', '4.22077751'),
	(68, 41, 'scholo', 0, '1266.94824', '-2556.7951', '94.1261978', '5.62004327'),
	(71, 41, 'everlook', 1, '6718.07421', '-4664.9731', '720.951904', '1.56350445'),
	(72, 41, 'ZG Island', 0, '-11822.828', '1247.28881', '2.34565377', '1.67701172'),
	(74, 44, 'Naxx', 0, '3126.29492', '-3868.1359', '138.140472', '3.22398114'),
	(75, 44, 'maexxna', 533, '3484.11865', '-3845.6035', '303.467224', '5.33442354'),
	(76, 44, 'stalks', 533, '2902.91015', '-3763.7353', '273.620574', '3.78301191'),
	(77, 41, 'MC', 0, '-7516.6386', '-1046.3056', '182.301177', '0.67845636'),
	(78, 41, 'Ony', 1, '-4736.7426', '-3745.4172', '53.8991622', '0.56775432'),
	(79, 41, 'ZG', 0, '-11916.299', '-1208.3699', '92.2867965', '4.66526651'),
	(81, 41, 'Songflower', 1, '6272.12109', '-2012.4654', '575.674133', '1.02268111'),
	(82, 41, 'AQ', 1, '-8251.2275', '1537.61657', '-4.7031421', '0.27707472'),
	(83, 177, 'thrall', 1, '1915.33337', '-4128.2631', '43.2106781', '5.99793815');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
