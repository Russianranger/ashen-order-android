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

-- Dumping structure for table acore_world.statbooster_enchant_template
DROP TABLE IF EXISTS `statbooster_enchant_template`;
CREATE TABLE IF NOT EXISTS `statbooster_enchant_template` (
  `Id` int unsigned DEFAULT NULL,
  `iLvlMin` int unsigned DEFAULT NULL,
  `iLvlMax` int unsigned DEFAULT NULL,
  `RoleMask` int unsigned DEFAULT NULL,
  `ClassMask` int unsigned DEFAULT NULL,
  `SubClassMask` int unsigned DEFAULT NULL,
  `ItemTypeMask` int unsigned DEFAULT '0',
  `Description` varchar(50) DEFAULT NULL,
  `Note` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.statbooster_enchant_template: ~81 rows (approximately)
DELETE FROM `statbooster_enchant_template`;
INSERT INTO `statbooster_enchant_template` (`Id`, `iLvlMin`, `iLvlMax`, `RoleMask`, `ClassMask`, `SubClassMask`, `ItemTypeMask`, `Description`, `Note`) VALUES
	(74, 1, 20, 7, 0, 0, 0, '+1 Agility', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(79, 1, 20, 12, 0, 0, 0, '+1 Intellect', 'HYBRID/SPELL - ALL - ALL'),
	(206, 1, 20, 8, 0, 0, 0, '+1 Spell Power', 'SPELL - ALL - ALL'),
	(66, 1, 20, 0, 0, 0, 0, '+1 Stamina', 'ALL - ALL - ALL'),
	(82, 1, 20, 8, 0, 0, 0, '+1 Spirit', 'SPELL - ALL - ALL'),
	(75, 20, 40, 7, 0, 0, 0, '+2 Agility', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(80, 20, 40, 12, 0, 0, 0, '+2 Intellect', 'HYBRID/SPELL - ALL - ALL'),
	(72, 20, 40, 0, 0, 0, 0, '+2 Stamina', 'ALL - ALL - ALL'),
	(83, 20, 40, 8, 0, 0, 0, '+2 Spirit', 'SPELL - ALL - ALL'),
	(207, 20, 40, 8, 0, 0, 0, '+2 Spell Power', 'SPELL - ALL - ALL'),
	(76, 40, 50, 7, 0, 0, 0, '+3 Agility', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(81, 40, 50, 12, 0, 0, 0, '+3 Intellect', 'HYBRID/SPELL - ALL - ALL'),
	(73, 40, 50, 0, 0, 0, 0, '+3 Stamina', 'ALL - ALL - ALL'),
	(64, 40, 50, 8, 0, 0, 0, '+3 Spirit', 'SPELL - ALL - ALL'),
	(2910, 40, 50, 8, 0, 0, 0, '+3 Spell Power', 'SPELL - ALL - ALL'),
	(90, 50, 90, 7, 0, 0, 0, '+4 Agility', 'TANK/PHYS/HYRBRID - ALL - ALL'),
	(94, 50, 90, 12, 0, 0, 0, '+4 Intellect', 'HYBRID/SPELL - ALL - ALL'),
	(102, 50, 90, 0, 0, 0, 0, '+4 Stamina', 'ALL - ALL - ALL'),
	(99, 50, 90, 8, 0, 0, 0, '+4 Spirit', 'SPELL - ALL - ALL'),
	(208, 50, 90, 8, 0, 0, 0, '+4 Spell Power', 'SPELL - ALL - ALL'),
	(91, 60, 90, 7, 0, 0, 0, '+5 Agility', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(95, 60, 90, 12, 0, 0, 0, '+5 Intellect', 'HYBRID/SPELL - ALL - ALL'),
	(103, 60, 90, 0, 0, 0, 0, '+5 Stamina', 'ALL - ALL - ALL'),
	(2370, 60, 90, 8, 0, 0, 0, '+3 mp5', 'SPELL - ALL - ALL'),
	(209, 60, 90, 8, 0, 0, 0, '+5 Spell Power', 'SPELL - ALL - ALL'),
	(92, 70, 90, 7, 0, 0, 0, '+6 Agility', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(96, 70, 90, 12, 0, 0, 0, '+6 Intellect', 'HYBRID/SPELL - ALL - ALL'),
	(104, 70, 90, 0, 0, 0, 0, '+6 Stamina', 'ALL - ALL - ALL'),
	(100, 70, 90, 8, 0, 0, 0, '+6 Spirit', 'SPELL - ALL - ALL'),
	(210, 70, 90, 8, 0, 0, 0, '+6 Spell Power', 'SPELL - ALL - ALL'),
	(93, 90, 100, 7, 0, 0, 0, '+7 Agility', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(97, 90, 100, 12, 0, 0, 0, '+7 Intellect', 'HYBRID/SPELL - ALL - ALL'),
	(105, 90, 100, 0, 0, 0, 0, '+7 Stamina', 'ALL - ALL - ALL'),
	(2374, 90, 100, 8, 0, 0, 0, '+5 mp5', 'SPELL - ALL - ALL'),
	(211, 90, 100, 8, 0, 0, 0, '+7 Spell Power', 'SPELL - ALL - ALL'),
	(343, 100, 284, 7, 0, 0, 0, '+8 Agility', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(350, 100, 284, 12, 0, 0, 0, '+8 Intellect', 'HYBRID/SPELL - ALL - ALL'),
	(353, 100, 284, 0, 0, 0, 0, '+8 Stamina', 'ALL - ALL - ALL'),
	(351, 100, 284, 8, 0, 0, 0, '+8 Spirit', 'SPELL - ALL - ALL'),
	(212, 100, 284, 8, 0, 0, 0, '+8 Spell Power', 'SPELL - ALL - ALL'),
	(344, 20, 40, 7, 0, 0, 0, '+32 Armor', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(346, 40, 50, 7, 0, 0, 0, '+36 Armor', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(345, 50, 90, 7, 0, 0, 0, '+40 Armor', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(348, 70, 90, 7, 0, 0, 0, '+48 Armor', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(348, 60, 90, 7, 0, 0, 0, '+48 Armor', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(385, 90, 100, 7, 0, 0, 0, '+60 Armor', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(1889, 100, 284, 7, 0, 0, 0, '+70 Armor', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(3765, 70, 90, 3, 0, 0, 0, '+4 ArmorPenetrationRating', 'TANK/PHYS - ALL - ALL'),
	(3880, 90, 100, 3, 0, 0, 0, '+6 ArmorPenetrationRating', 'TANK/PHYS - ALL - ALL'),
	(111, 1, 20, 3, 0, 0, 0, '+ 2 DefenseRating', 'TANK/PHYS - ALL - ALL'),
	(111, 20, 40, 3, 0, 0, 0, '+ 2 DefenseRating', 'TANK/PHYS - ALL - ALL'),
	(112, 40, 50, 3, 0, 0, 0, '+ 3 DefenseRating', 'TANK/PHYS - ALL - ALL'),
	(112, 50, 90, 3, 0, 0, 0, '+ 3 DefenseRating', 'TANK/PHYS - ALL - ALL'),
	(113, 60, 90, 3, 0, 0, 0, '+ 4 DefenseRating', 'TANK/PHYS - ALL - ALL'),
	(38, 70, 90, 3, 0, 0, 0, '+ 5 DefenseRating', 'TANK/PHYS - ALL - ALL'),
	(116, 90, 100, 3, 0, 0, 0, '+ 7 DefenseRating', 'TANK/PHYS - ALL - ALL'),
	(1946, 100, 284, 3, 0, 0, 0, '+ 10 DefenseRating', 'TANK/PHYS - ALL - ALL'),
	(1563, 1, 20, 7, 0, 0, 0, '+2 AttackPower', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(1583, 20, 40, 7, 0, 0, 0, '+4 AttackPower', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(1584, 40, 50, 7, 0, 0, 0, '+6 AttackPower', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(1585, 50, 90, 7, 0, 0, 0, '+8 AttackPower', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(1586, 60, 90, 7, 0, 0, 0, '+10 AttackPower', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(1586, 70, 90, 7, 0, 0, 0, '+12 AttackPower', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(1588, 90, 100, 7, 0, 0, 0, '+14 AttackPower', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(1589, 100, 284, 7, 0, 0, 0, '+16 AttackPower', 'TANK/PHYS/HYBRID - ALL - ALL'),
	(3309, 60, 90, 0, 0, 0, 0, '+6 Haste Rating', 'ALL - ALL - ALL'),
	(3270, 70, 90, 0, 0, 0, 0, '+8 Haste Rating', 'ALL - ALL - ALL'),
	(931, 90, 100, 0, 0, 0, 0, '+10  Haste Rating', 'ALL - ALL - ALL'),
	(3386, 100, 284, 0, 0, 0, 0, '+12  Haste Rating', 'ALL - ALL - ALL'),
	(3308, 50, 90, 0, 0, 0, 0, '+4 Haste Rating', 'ALL - ALL - ALL'),
	(3922, 50, 90, 0, 0, 0, 0, '+4 Crit Rating', 'ALL - ALL - ALL'),
	(3923, 60, 90, 0, 0, 0, 0, '+6 Crit Rating', 'ALL - ALL - ALL'),
	(3924, 70, 90, 0, 0, 0, 0, '+8 Crit Rating', 'ALL - ALL - ALL'),
	(3925, 90, 100, 0, 0, 0, 0, '+10  Crit Rating', 'ALL - ALL - ALL'),
	(3926, 100, 284, 0, 0, 0, 0, '+12  Crit Rating', 'ALL - ALL - ALL'),
	(3882, 100, 284, 3, 0, 0, 0, '+8 ArmorPenetrationRating', 'TANK/PHYS - ALL - ALL'),
	(2366, 50, 90, 8, 0, 0, 0, '+2 Mp5', 'SPELL - ALL - ALL'),
	(99, 60, 90, 8, 0, 0, 0, '+5 Spirit', 'SPELL - ALL - ALL'),
	(2371, 70, 90, 8, 0, 0, 0, '+4 Mp5', 'SPELL - ALL - ALL'),
	(101, 90, 100, 8, 0, 0, 0, '+7 Spirit', 'SPELL - ALL - ALL'),
	(2376, 100, 284, 8, 0, 0, 0, '+6 mp5', 'SPELL - ALL - ALL');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
