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

-- Dumping structure for table acore_characters.mail
DROP TABLE IF EXISTS `mail`;
CREATE TABLE IF NOT EXISTS `mail` (
  `id` int unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `messageType` tinyint unsigned NOT NULL DEFAULT '0',
  `stationery` tinyint NOT NULL DEFAULT '41',
  `mailTemplateId` smallint unsigned NOT NULL DEFAULT '0',
  `sender` int unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  `receiver` int unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  `subject` longtext,
  `body` longtext,
  `has_items` tinyint unsigned NOT NULL DEFAULT '0',
  `expire_time` int unsigned NOT NULL DEFAULT '0',
  `deliver_time` int unsigned NOT NULL DEFAULT '0',
  `money` int unsigned NOT NULL DEFAULT '0',
  `cod` int unsigned NOT NULL DEFAULT '0',
  `checked` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Mail System';

-- Dumping data for table acore_characters.mail: ~45 rows (approximately)
DELETE FROM `mail`;
INSERT INTO `mail` (`id`, `messageType`, `stationery`, `mailTemplateId`, `sender`, `receiver`, `subject`, `body`, `has_items`, `expire_time`, `deliver_time`, `money`, `cod`, `checked`) VALUES
	(288, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1740033713, 1737441713, 0, 0, 0),
	(289, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1740033715, 1737441715, 0, 0, 0),
	(290, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1740033717, 1737441717, 0, 0, 0),
	(291, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1740033718, 1737441718, 0, 0, 0),
	(292, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1740033721, 1737441721, 0, 0, 0),
	(293, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1740033722, 1737441722, 0, 0, 0),
	(294, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1740033724, 1737441724, 0, 0, 0),
	(302, 0, 62, 0, 4, 171, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1740036535, 1737444535, 0, 0, 1),
	(303, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 0, 1740097825, 1737505825, 0, 0, 1),
	(304, 3, 41, 141, 15585, 171, '', '', 0, 1740143230, 1737551230, 0, 0, 17),
	(305, 3, 41, 85, 15556, 171, '', '', 0, 1740194673, 1737602673, 0, 0, 17),
	(306, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 0, 1740232082, 1737640082, 0, 0, 1),
	(307, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 0, 1740232085, 1737640085, 0, 0, 1),
	(308, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 0, 1740331373, 1737739373, 0, 0, 1),
	(309, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 0, 1740331383, 1737739383, 0, 0, 1),
	(310, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 0, 1740331400, 1737739400, 0, 0, 1),
	(324, 3, 41, 84, 15549, 171, '', '', 0, 1740407236, 1737815236, 0, 0, 17),
	(325, 3, 41, 120, 7854, 171, '', '', 0, 1741573156, 1738981156, 0, 0, 17),
	(326, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 0, 1741849933, 1739257933, 0, 0, 1),
	(327, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859017, 1739267017, 0, 0, 0),
	(328, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859019, 1739267019, 0, 0, 0),
	(329, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859021, 1739267021, 0, 0, 0),
	(330, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859023, 1739267023, 0, 0, 0),
	(331, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859025, 1739267025, 0, 0, 0),
	(332, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859026, 1739267026, 0, 0, 0),
	(333, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859038, 1739267038, 0, 0, 0),
	(334, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859040, 1739267040, 0, 0, 0),
	(335, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859041, 1739267041, 0, 0, 0),
	(336, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859046, 1739267046, 0, 0, 0),
	(337, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859047, 1739267047, 0, 0, 0),
	(338, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859049, 1739267049, 0, 0, 0),
	(339, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859051, 1739267051, 0, 0, 0),
	(340, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859052, 1739267052, 0, 0, 0),
	(341, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859054, 1739267054, 0, 0, 0),
	(342, 0, 62, 0, 4, 41, 'Purchase of: Experience Token', 'Thank you for your purchase!', 0, 1741859057, 1739267057, 0, 0, 0),
	(343, 0, 61, 0, 41, 41, 'This item(s) have problems with equipping/storing in inventory.', 'There were problems with equipping item(s).', 0, 1742021376, 1739429376, 0, 0, 5),
	(349, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 0, 1742080005, 1739488005, 0, 0, 1),
	(359, 3, 41, 101, 10837, 171, '', '', 0, 1742499062, 1739907062, 0, 0, 16),
	(370, 2, 62, 0, 6, 171, '811:0:2:6105011:1', '               3:4200000:4200000:16236:210000:0:0', 0, 1742422519, 1739830519, 4006236, 0, 4),
	(371, 2, 62, 0, 6, 171, '14513:0:2:6105006:1', '               3:2300000:2300000:4500:115000:0:0', 0, 1742422519, 1739830519, 2189500, 0, 4),
	(372, 2, 62, 0, 6, 171, '14513:0:2:6105008:1', '               3:2300000:2300000:4500:115000:0:0', 0, 1742422519, 1739830519, 2189500, 0, 4),
	(373, 2, 62, 0, 6, 171, '1168:0:2:6105009:1', '               3:22090000:22090000:12688:1104500:0:0', 0, 1742422519, 1739830519, 20998188, 0, 4),
	(374, 2, 62, 0, 6, 171, '14513:0:2:6105007:1', '               3:2300000:2300000:4500:115000:0:0', 0, 1742422519, 1739830519, 2189500, 0, 4),
	(375, 2, 62, 0, 6, 171, '2244:0:2:6105010:1', '               3:21000000:21000000:15557:1050000:0:0', 0, 1742422519, 1739830519, 19965557, 0, 4),
	(376, 3, 41, 0, 34337, 171, 'Recovered Item', 'We recovered a lost item in the twisting nether and noted that it was yours.$B$BPlease find said object enclosed.', 1, 1742455370, 1739863370, 0, 0, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
