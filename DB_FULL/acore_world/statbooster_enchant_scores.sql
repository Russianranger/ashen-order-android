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

-- Dumping structure for table acore_world.statbooster_enchant_scores
DROP TABLE IF EXISTS `statbooster_enchant_scores`;
CREATE TABLE IF NOT EXISTS `statbooster_enchant_scores` (
  `mod_type` int DEFAULT NULL,
  `mod_id` int DEFAULT NULL,
  `subclass` int DEFAULT NULL,
  `tank_score` int DEFAULT NULL,
  `phys_score` int DEFAULT NULL,
  `spell_score` int DEFAULT NULL,
  `hybrid_score` int DEFAULT NULL,
  `note` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.statbooster_enchant_scores: ~23 rows (approximately)
DELETE FROM `statbooster_enchant_scores`;
INSERT INTO `statbooster_enchant_scores` (`mod_type`, `mod_id`, `subclass`, `tank_score`, `phys_score`, `spell_score`, `hybrid_score`, `note`) VALUES
	(0, 44, 0, 1, 2, 0, 1, 'ITEM_MOD_ARMOR_PENETRATION_RATING - ALL'),
	(0, 38, 0, 1, 2, 0, 1, 'ITEM_MOD_ATTACK_POWER - ALL'),
	(0, 4, 0, 1, 2, 0, 1, 'ITEM_MOD_STRENGTH - ALL'),
	(0, 3, 0, 1, 2, 0, 1, 'ITEM_MOD_AGILITY - ALL'),
	(0, 5, 1, 0, 0, 1, 0, 'ITEM_MOD_INTELLECT - CLOTH'),
	(0, 5, 2, 0, 0, 1, 1, 'ITEM_MOD_INTELLECT - LEATHER'),
	(0, 5, 3, 1, 0, 1, 1, 'ITEM_MOD_INTELLECT - MAIL'),
	(0, 5, 4, 1, 0, 1, 0, 'ITEM_MOD_INTELLECT - PLATE'),
	(0, 5, 0, 1, 0, 3, 2, 'ITEM_MOD_INTELLECT - ALL'),
	(0, 6, 0, 0, 0, 1, 0, 'ITEM_MOD_SPIRIT - ALL'),
	(0, 43, 0, 0, 0, 1, 0, 'ITEM_MOD_MANA_REGENERATION - ALL'),
	(0, 41, 0, 0, 0, 1, 0, 'ITEM_MOD_SPELL_HEALING_DONE - ALL'),
	(0, 45, 0, 0, 0, 1, 0, 'ITEM_MOD_SPELL_POWER - ALL'),
	(0, 47, 0, 0, 0, 1, 0, 'ITEM_MOD_SPELL_PENETRATION - ALL'),
	(0, 42, 0, 0, 0, 1, 0, 'ITEM_MOD_SPELL_DAMAGE_DONE - ALL'),
	(0, 14, 0, 3, 0, 0, 0, 'ITEM_MOD_PARRY_RATING - ALL'),
	(0, 13, 0, 3, 0, 0, 0, 'ITEM_MOD_DODGE_RATING - ALL'),
	(0, 12, 0, 3, 0, 0, 0, 'ITEM_MOD_DEFENSE_SKILL_RATING - ALL'),
	(0, 15, 0, 3, 0, 0, 0, 'ITEM_MOD_BLOCK_RATING - ALL'),
	(1, 99, 0, 1, 2, 0, 1, 'SPELL_AURA_MOD_ATTACK_POWER - ALL'),
	(1, 135, 0, 0, 0, 0, 1, 'SPELL_AURA_MOD_HEALING_DONE - ALL'),
	(1, 85, 0, 0, 0, 0, 1, 'SPELL_AURA_MOD_POWER_REGEN - ALL'),
	(1, 13, 0, 0, 0, 0, 1, 'SPELL_AURA_MOD_DAMAGE_DONE - ALL');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
