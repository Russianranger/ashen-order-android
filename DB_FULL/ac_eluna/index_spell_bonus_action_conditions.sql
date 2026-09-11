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

-- Dumping structure for table ac_eluna.index_spell_bonus_action_conditions
DROP TABLE IF EXISTS `index_spell_bonus_action_conditions`;
CREATE TABLE IF NOT EXISTS `index_spell_bonus_action_conditions` (
  `spell_id` int NOT NULL,
  `condition_type` enum('aura','item','item_equipped','map_id','zone_id','area_id','active_event','min_level','class','race','phase_mask','quest_rewarded','quest_incomplete','min_hp_pct','max_hp_pct') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `condition_value` int DEFAULT NULL,
  PRIMARY KEY (`spell_id`,`condition_type`),
  CONSTRAINT `spell_id` FOREIGN KEY (`spell_id`) REFERENCES `index_spell_bonus_action` (`spell_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table ac_eluna.index_spell_bonus_action_conditions: ~0 rows (approximately)
DELETE FROM `index_spell_bonus_action_conditions`;
INSERT INTO `index_spell_bonus_action_conditions` (`spell_id`, `condition_type`, `condition_value`) VALUES
	(17016, 'item', 12815);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
