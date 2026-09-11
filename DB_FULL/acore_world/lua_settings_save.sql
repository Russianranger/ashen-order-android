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

-- Dumping structure for table acore_world.lua_settings_save
DROP TABLE IF EXISTS `lua_settings_save`;
CREATE TABLE IF NOT EXISTS `lua_settings_save` (
  `entry` int unsigned NOT NULL AUTO_INCREMENT,
  `LuaScriptName` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `VariableName` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TrueFalse` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `Value` int unsigned DEFAULT NULL,
  `Text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`entry`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.lua_settings_save: ~44 rows (approximately)
DELETE FROM `lua_settings_save`;
INSERT INTO `lua_settings_save` (`entry`, `LuaScriptName`, `VariableName`, `TrueFalse`, `Value`, `Text`) VALUES
	(1, 'Binding_Menu', 'enabled', 'false', 0, '0'),
	(2, 'Binding_Menu', 'MenuMenus', 'false', 0, '0'),
	(3, 'Binding_Menu', 'commandline1', '0', 0, 'menubind'),
	(4, 'DungeonStatsReward_Check', 'enabled', 'false', 0, '0'),
	(5, 'DungeonStatsReward_Check', 'MenuMenus', 'false', 0, '0'),
	(6, 'DungeonStatsReward_Check', 'commandline1', '0', 0, 'drstats'),
	(7, 'DungeonStatsReward_Check', 'StatChangeNotice', '0', 0, '|cffff3347Note: |cffffd000Stats changes won\'t be updated until the next time you login.'),
	(8, 'DungeonStatsReward_Check', 'BuyStats', 'false', 0, '0'),
	(9, 'DungeonStatsReward_Check', 'MainStatCost', '0', 25, '0'),
	(10, 'DungeonStatsReward_Check', 'TradeStats', 'true', 0, '0'),
	(11, 'DungeonStatsReward_Check', 'StatTradeRate', '0', 2, '0'),
	(12, 'Party_Summon_Menu', 'enabled', 'true', 0, '0'),
	(13, 'Party_Summon_Menu', 'MenuMenus', 'true', 0, '0'),
	(14, 'Party_Summon_Menu', 'commandline1', '0', 0, 'menuparty'),
	(15, 'Party_Summon_Menu', 'LeaderOnly', 'false', 0, '0'),
	(16, 'ReCustomize_Character', 'enabled', 'true', 0, '0'),
	(17, 'ReCustomize_Character', 'MenuMenus', 'true', 0, '0'),
	(18, 'ReCustomize_Character', 'commandline1', '0', 0, 'rcmenu'),
	(19, 'ReCustomize_Character', 'StatChangeNotice', '0', 0, '|cffff3347Note: |cffffd000Log out to use.'),
	(20, 'ReCustomize_Character', 'Change_Race', 'true', 0, '0'),
	(21, 'ReCustomize_Character', 'Change_Faction', 'true', 0, '0'),
	(22, 'ReCustomize_Character', 'Use_Items_instead', 'false', 0, '0'),
	(23, 'ReCustomize_Character', 'Redo_Items', 'false', 0, '0'),
	(24, 'ReCustomize_Character', 'ReCustomize_Cost', '0', 25, '0'),
	(25, 'ReCustomize_Character', 'Change_Race_Cost', '0', 75, '0'),
	(26, 'ReCustomize_Character', 'Change_Faction_Cost', '0', 150, '0'),
	(27, 'ReCustomize_Character', 'ReCustomize_Item', '0', 7777777, '0'),
	(28, 'ReCustomize_Character', 'ReCustomize_Item_displayid', '0', 36521, '0'),
	(29, 'ReCustomize_Character', 'ReCustomize_Item_Name', '0', 0, 'ReCustomize Token'),
	(30, 'ReCustomize_Character', 'ReCustomize_Item_Desc', '0', 0, 'Item Need to ReCustomize You.'),
	(31, 'ReCustomize_Character', 'ReCustomize_Item_Quality', '0', 4, '0'),
	(32, 'ReCustomize_Character', 'ReCustomize_Item_Bonding', '0', 0, '0'),
	(33, 'ReCustomize_Character', 'Change_Race_Item', '0', 7777778, '0'),
	(34, 'ReCustomize_Character', 'Change_Race_Item_displayid', '0', 36521, '0'),
	(35, 'ReCustomize_Character', 'Change_Race_Item_Name', '0', 0, 'Change Race Token'),
	(36, 'ReCustomize_Character', 'Change_Race_Item_Desc', '0', 0, 'Item Need to Change Race You.'),
	(37, 'ReCustomize_Character', 'Change_Race_Item_Quality', '0', 4, '0'),
	(38, 'ReCustomize_Character', 'Change_Race_Item_Bonding', '0', 0, '0'),
	(39, 'ReCustomize_Character', 'Change_Faction_Item', '0', 7777779, '0'),
	(40, 'ReCustomize_Character', 'Change_Faction_Item_displayid', '0', 36521, '0'),
	(41, 'ReCustomize_Character', 'Change_Faction_Item_Name', '0', 0, 'Change Faction Token'),
	(42, 'ReCustomize_Character', 'Change_Faction_Item_Desc', '0', 0, 'Item Need to Change Faction You.'),
	(43, 'ReCustomize_Character', 'Change_Faction_Item_Quality', '0', 4, '0'),
	(44, 'ReCustomize_Character', 'Change_Faction_Item_Bonding', '0', 0, '0');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
