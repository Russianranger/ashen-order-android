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

-- Dumping structure for table acore_world.instance_template
DROP TABLE IF EXISTS `instance_template`;
CREATE TABLE IF NOT EXISTS `instance_template` (
  `map` smallint unsigned NOT NULL,
  `parent` smallint unsigned NOT NULL,
  `script` varchar(128) NOT NULL DEFAULT '',
  `allowMount` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`map`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.instance_template: 95 rows
DELETE FROM `instance_template`;
/*!40000 ALTER TABLE `instance_template` DISABLE KEYS */;
INSERT INTO `instance_template` (`map`, `parent`, `script`, `allowMount`) VALUES
	(249, 1, 'instance_onyxias_lair', 1),
	(289, 0, 'instance_scholomance', 1),
	(309, 0, 'instance_zulgurub', 1),
	(349, 1, 'instance_maraudon', 1),
	(329, 0, 'instance_stratholme', 1),
	(389, 1, 'instance_ragefire_chasm', 1),
	(409, 230, 'instance_molten_core', 1),
	(429, 1, 'instance_dire_maul', 1),
	(469, 229, 'instance_blackwing_lair', 1),
	(489, 0, '', 1),
	(509, 1, 'instance_ruins_of_ahnqiraj', 1),
	(531, 1, 'instance_temple_of_ahnqiraj', 1),
	(529, 0, '', 1),
	(532, 0, 'instance_karazhan', 1),
	(533, 571, 'instance_naxxramas', 1),
	(534, 1, 'instance_hyjal', 1),
	(540, 530, 'instance_shattered_halls', 1),
	(542, 530, 'instance_blood_furnace', 1),
	(543, 530, 'instance_hellfire_ramparts', 1),
	(544, 530, 'instance_magtheridons_lair', 1),
	(546, 530, 'instance_the_underbog', 1),
	(545, 530, 'instance_steam_vault', 1),
	(547, 530, 'instance_the_slave_pens', 1),
	(548, 530, 'instance_serpent_shrine', 1),
	(550, 530, 'instance_the_eye', 1),
	(552, 530, 'instance_arcatraz', 1),
	(553, 530, 'instance_the_botanica', 1),
	(554, 530, 'instance_mechanar', 1),
	(555, 530, 'instance_shadow_labyrinth', 1),
	(556, 530, 'instance_sethekk_halls', 1),
	(557, 530, 'instance_mana_tombs', 1),
	(558, 530, 'instance_auchenai_crypts', 1),
	(559, 0, '', 1),
	(560, 1, 'instance_old_hillsbrad', 1),
	(562, 0, '', 1),
	(564, 530, 'instance_black_temple', 1),
	(568, 530, 'instance_zulaman', 1),
	(565, 530, 'instance_gruuls_lair', 1),
	(574, 571, 'instance_utgarde_keep', 1),
	(572, 0, '', 1),
	(566, 0, '', 1),
	(575, 571, 'instance_utgarde_pinnacle', 1),
	(576, 571, 'instance_nexus', 1),
	(578, 571, 'instance_oculus', 1),
	(580, 530, 'instance_sunwell_plateau', 1),
	(585, 530, 'instance_magisters_terrace', 1),
	(599, 571, 'instance_halls_of_stone', 1),
	(595, 1, 'instance_culling_of_stratholme', 1),
	(600, 571, 'instance_drak_tharon_keep', 1),
	(601, 571, 'instance_azjol_nerub', 1),
	(602, 571, 'instance_halls_of_lightning', 1),
	(603, 571, 'instance_ulduar', 1),
	(44, 0, '', 1),
	(47, 1, 'instance_razorfen_kraul', 1),
	(43, 1, 'instance_wailing_caverns', 1),
	(36, 0, 'instance_deadmines', 1),
	(34, 0, 'instance_the_stockade', 1),
	(33, 0, 'instance_shadowfang_keep', 1),
	(30, 0, '', 1),
	(604, 571, 'instance_gundrak', 1),
	(608, 571, 'instance_violet_hold', 1),
	(269, 1, 'instance_the_black_morass', 1),
	(209, 1, 'instance_zulfarrak', 1),
	(230, 0, 'instance_blackrock_depths', 1),
	(229, 0, 'instance_blackrock_spire', 1),
	(189, 0, 'instance_scarlet_monastery', 1),
	(169, 0, '', 1),
	(129, 1, 'instance_razorfen_downs', 1),
	(109, 0, 'instance_sunken_temple', 1),
	(90, 0, 'instance_gnomeregan', 1),
	(70, 0, 'instance_uldaman', 1),
	(48, 1, 'instance_blackfathom_deeps', 1),
	(607, 0, '', 1),
	(615, 571, 'instance_obsidian_sanctum', 1),
	(616, 571, 'instance_eye_of_eternity', 1),
	(619, 571, 'instance_ahnkahet', 1),
	(624, 571, 'instance_vault_of_archavon', 1),
	(631, 0, 'instance_icecrown_citadel', 1),
	(632, 0, 'instance_forge_of_souls', 1),
	(628, 0, '', 1),
	(649, 571, 'instance_trial_of_the_crusader', 1),
	(658, 0, 'instance_pit_of_saron', 1),
	(650, 571, 'instance_trial_of_the_champion', 1),
	(668, 0, 'instance_halls_of_reflection', 1),
	(724, 0, 'instance_ruby_sanctum', 1),
	(670, 0, '', 1),
	(732, 0, '', 1),
	(996, 0, '', 1),
	(37, 0, '', 1),
	(671, 0, '', 1),
	(669, 0, '', 1),
	(734, 0, '', 1),
	(757, 0, '', 1),
	(2454, 1, '', 1),
	(2461, 0, 'instance_andorhal', 0);
/*!40000 ALTER TABLE `instance_template` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
