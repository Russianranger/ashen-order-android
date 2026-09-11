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

-- Dumping structure for table acore_characters.zone_difficulty_disallowed_buffs
DROP TABLE IF EXISTS `zone_difficulty_disallowed_buffs`;
CREATE TABLE IF NOT EXISTS `zone_difficulty_disallowed_buffs` (
  `MapID` int NOT NULL DEFAULT '0',
  `DisallowedBuffs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `Enabled` tinyint DEFAULT '1',
  `Comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`MapID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table acore_characters.zone_difficulty_disallowed_buffs: ~15 rows (approximately)
DELETE FROM `zone_difficulty_disallowed_buffs`;
INSERT INTO `zone_difficulty_disallowed_buffs` (`MapID`, `DisallowedBuffs`, `Enabled`, `Comment`) VALUES
	(30, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Alterac Valley: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(249, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Onyxia\'s Lair: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(309, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Zul Gurub: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(409, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Molten Core: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(469, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Blackwing Lair: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(489, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Warsong Gulch: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(509, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Ruins of Ahn\'Qiraj: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(529, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Arathi Basin: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(531, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Temple of Ahn\'Qiraj: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(556, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Eye of the Storm: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(559, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Ring of Trials: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(562, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Blade\'s Edge Arena: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(572, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Ruins of Lordaeron: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(617, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Dalaran Arena: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder'),
	(618, '15366 16609 22888 24425 22817 22818 22820 15123', 1, 'Forbid in Ring of Valor: Songflower Serenade, Warchiefs Blessing, Rallying Cry of the Dragonslayer, Spirit of Zandalar, Fengus\' Ferocity\', Mol\'dar\'s Moxie, Slip\'kik\'s Savvy, Resist Fire from Scarshield Spellbinder');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
