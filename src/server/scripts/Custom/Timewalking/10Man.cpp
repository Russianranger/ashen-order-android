#include "ScriptMgr.h"
#include "Player.h"
#include "Creature.h"
#include "Chat.h"
#include "ScriptedGossip.h"
#include "WorldSession.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "Map.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "CellImpl.h"
#include "Creature.h"
#include "Item.h"
#include "10Man.h"
#include "PlayerMapChangeHandler.h"
#include <list>
#include <algorithm>
#include <random>

const static uint32 GOSSIP_ICON = 0;
const static uint32 TYRANNICAL_SPELL_ID = 800142;
const static uint32 DECAY_SPELL_ID = 811142;
const static uint32 NECROTIC_SPELL_ID = 811143;
const static uint32 NULLIFYING_TEMPEST_SPELL_ID = 961618;
const static uint32 CORPSE_EXPLOSION_SPELL_ID = 861617;

enum RewardItemID : uint32
{
    REWARD_ITEM_ID_RAID = 37711,       // reward item ID for raids
    REWARD_ITEM_ID_DUNGEON = 37711,    // Reward item ID for dungeons
    STATBONUS_REROLLER_ITEM_ID = 834054,
    ANCIENT_IDOL_ITEM_ID = 22637,
    FIERY_CORE_ITEM_ID = 17010,        // Fiery Core item ID
    LAVA_CORE_ITEM_ID = 17011,         // Lava Core item ID
    SULFURON_INGOT = 17203,            // Eye of Sulfuras
    BLOOD_OF_THE_MOUNTAIN = 11382,     // Blood of the Mountain
    CACHE_OF_ONYXIA = 820025,          // Onyxia Cache
    SILITHID_CACHE = 820027,            // AQ20 Cache
    SANDWORN_SHARD = 834055,            
    CRYSALLINE_SCARAB = 834056,
    ANCIENT_QIRAJI_CACHE = 820028,
    NOZDORMU_TOKEN = 819858,
    NAXX_SATCHEL = 820030,
    NAXX_CACHE = 820029,
};

enum MapID : uint32
{
    MAP_ID_ZG = 309,                   // Map ID for ZG
    MAP_ID_STRATHOLME = 329,           // Map ID for Stratholme
    MAP_ID_DIRE_MAUL = 429,            // Map ID for Dire Maul
    MAP_ID_UBRS = 229,                 // Map ID for UBRS
    MAP_ID_SCHOLO = 289,               // Map ID for Scholomance
    MAP_ID_MC = 409,                   // Map ID for Molten Core
    MAP_ID_BWL = 469,                  // Map ID for Blackwing Lair
    MAP_ID_ONYXIA = 249,               // Map ID for Onyxia's Lair
    MAP_ID_AQ20 = 509,                 // Map ID for AQ20
    MAP_ID_AQ40 = 531,                 // Map ID for AQ40
    MAP_ID_NAXX = 533,                 // Map ID for Naxxramas
    MAP_ID_MAURADON = 349,             // Map ID for Mauradon
    MAP_ID_SUNKEN_TEMPLE = 109,        // Map ID for Sunken Temple
    MAP_ID_BRD = 230,                  // Map ID for Blackrock Depths
};

enum BossEntryID : uint32
{
    HAKKAR_ENTRY_ID = 14834,           // Entry ID for Hakkar
    RAGNAROS_ENTRY_ID = 11502,         // Entry ID for Ragnaros
    GOLEMAGG_ENTRY_ID = 800066,         // Entry ID for Golemagg bunny
    ONYXIA_ENTRY_ID = 301000,          // Entry ID for Onyxia
    MAJORDOMO_ENTRY_ID = 12018,         // Entry ID for Majordomo Executus
    CHROMAGGUS_ENTRY_ID = 14020,       // Entry ID for Chromaggus
    NEFARIAN_ENTRY_ID = 11583,         // Entry ID for Nefarian
    VALTHORAX_ENTRY_ID = 800067,       // Entry ID for Valthorax bunny
    OSSIRIAN_ENTRY_ID = 15339,          // Entry ID for Ossirian the Unscarred
    CTHUN_ENTRY_ID = 15727,            // Entry ID for C'Thun
    OURO_ENTRY_ID = 15517,             // Entry ID for Ouro
    BG_S = 15509,                      // Entry ID for Battlguard Sartura (jk, Huhuran)
    LOATHEB_ENTRY_ID = 351020,        // Entry ID for Loatheb
    KELTHUZAD_ENTRY_ID = 351019,      // Entry ID for Kel'Thuzad
    SAPPHIRON_ENTRY_ID = 351018,     // Entry ID for Sapphiron
    BALNAZZAR_ENTRY_ID = 10813,        // Entry ID for Balnazzar
    UBRS_SCHOLO_STRATH_SPECIAL_ENTRY_ID = 800068,        // Entry ID for bunny for stuff
    RAMSTEIN_ENTRY_ID = 10439,         // Entry ID for Ramstein the Gorger
    RAS_FROSTWHISPER_ENTRY_ID = 10508, // Entry ID for Ras Frostwhisper
    DARKMASTER_GANDLING_ENTRY_ID = 1853,       // Entry ID for Darkmaster Gandling
    WARM_MASTER_VOONE_ENTRY_ID = 9237,        // Entry ID for Warmaster Voone
    OVERLORD_WYRMTHALAK_ENTRY_ID = 9568,       // Entry ID for Overlord Wyrmthalak
    THE_BEAST_ENTRY_ID = 10430,                // Entry ID for The Beast
    GENERAL_DRAKKISATH_ENTRY_ID = 10363,       // Entry ID for General Drakkisath
    LETHTENDRIS_ENTRY_ID = 14327,              // Entry ID for Lethtendris
    TENDRIS_WARPWOOD_ENTRY_ID = 11489,         // Entry ID for Tendris Warpwood
    PRINCESS_THERADRAS_ENTRY_ID = 12201,       // Entry ID for Princess Theradras
    ERANIKUS_ENTRY_ID = 5709,                  // Entry ID for Shade of Eranikus
    GENERAL_ANGERFORGE_ENTRY_ID = 9033,        // Entry ID for General Angerforge
    EMPEROR_DAGRAN_ENTRY_ID = 9019,            // Entry ID for Emperor Dagran Thaurissan
};

std::list<uint32> challengeAuras = { TYRANNICAL_SPELL_ID, DECAY_SPELL_ID, NECROTIC_SPELL_ID, NULLIFYING_TEMPEST_SPELL_ID, CORPSE_EXPLOSION_SPELL_ID };

void DistributeChallengeRewards(Player* player, Creature* boss, uint32 baseRewardLevel, bool isDungeon)
{
   
    uint32 activeAuras = 0;
    for (uint32 auraID : challengeAuras) {
        if (player->HasAura(auraID) || boss->HasAura(auraID)) {
            activeAuras++;
        }
    }

    // Get map ID and boss entry ID
    uint32 mapId = player->GetMapId();
    uint32 bossEntryId = boss->GetEntry();

    // Determine the total quantity of items to reward
    uint32 totalRewardQuantity = baseRewardLevel * activeAuras;
    uint32 totalRewardQuantityTwo = activeAuras;

    uint32 ChestRewardNumber = 0;

    switch (activeAuras)
    {
    case 1:
        ChestRewardNumber = 0;
    case 2:
        ChestRewardNumber = 1;
        break;
    case 3:
        ChestRewardNumber = 2;
        break;
    case 4:
        ChestRewardNumber = 3;
        break;
    case 5:
        ChestRewardNumber = 4;
        break;
    default:
        ChestRewardNumber = 0; // Default to 0 if no auras are active or beyond range
        break;
    }

    if (totalRewardQuantity > 0) {
        if (bossEntryId == 800064) {
            if (mapId == MAP_ID_SCHOLO) { // Dinkle made an oopsie poopsie here and didn't want to spawn new invisible bunnies in scholo
                player->AddItem(REWARD_ITEM_ID_DUNGEON, 7 * totalRewardQuantityTwo); 
                player->AddItem(STATBONUS_REROLLER_ITEM_ID, urand(0, 1)); 
            }
            else {
                player->AddItem(REWARD_ITEM_ID_DUNGEON, 5 * totalRewardQuantityTwo); 
                player->AddItem(STATBONUS_REROLLER_ITEM_ID, 1); 
            }
        }
        else {
            if (isDungeon) {
                switch (mapId) {
                case MAP_ID_STRATHOLME:
                    if (bossEntryId == BALNAZZAR_ENTRY_ID || bossEntryId == UBRS_SCHOLO_STRATH_SPECIAL_ENTRY_ID ||
                        bossEntryId == RAMSTEIN_ENTRY_ID || bossEntryId == 10812) {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 8 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(12811, totalRewardQuantityTwo);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 7 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, urand(0, 1));
                    }
                    break;
                case MAP_ID_UBRS:
                    if (bossEntryId == WARM_MASTER_VOONE_ENTRY_ID || bossEntryId == OVERLORD_WYRMTHALAK_ENTRY_ID || bossEntryId == THE_BEAST_ENTRY_ID || bossEntryId == GENERAL_DRAKKISATH_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 8 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 7 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, urand(0, 1));
                    }
                    break;
                case MAP_ID_SCHOLO:
                    if (bossEntryId == RAS_FROSTWHISPER_ENTRY_ID || bossEntryId == DARKMASTER_GANDLING_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 8 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(12753, totalRewardQuantityTwo);
                    }
                    else {
                    player->AddItem(REWARD_ITEM_ID_DUNGEON, 7 * totalRewardQuantityTwo);
                    player->AddItem(STATBONUS_REROLLER_ITEM_ID, urand(0, 1));
                    }
                    break;
                case MAP_ID_DIRE_MAUL:
                    if (bossEntryId == LETHTENDRIS_ENTRY_ID || bossEntryId == TENDRIS_WARPWOOD_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 8 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 7 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, urand(0, 1));
                    }
                    break;
                case MAP_ID_MAURADON:
                    if (bossEntryId == PRINCESS_THERADRAS_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 5 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 3 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, urand(0, 3));
                    }
                    break;
                case MAP_ID_SUNKEN_TEMPLE:
                    if (bossEntryId == ERANIKUS_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 5 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 3 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, urand(0, 3));
                    }
                    break;
                case MAP_ID_BRD:
                    if (bossEntryId == GENERAL_ANGERFORGE_ENTRY_ID || bossEntryId == EMPEROR_DAGRAN_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 7 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(11370, 2 * totalRewardQuantityTwo);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_DUNGEON, 5 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, urand(0, 2));
                        player->AddItem(11370, totalRewardQuantityTwo);

                    }
                    break;
                default:
                    player->AddItem(REWARD_ITEM_ID_DUNGEON, totalRewardQuantity);
                    break;
                }
            }
            else {
                switch (mapId) {
                case MAP_ID_ZG:
                    if (bossEntryId == HAKKAR_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(ANCIENT_IDOL_ITEM_ID, 2 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(820026, ChestRewardNumber);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_RAID, 10 * totalRewardQuantityTwo);
                        player->AddItem(ANCIENT_IDOL_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, 1);
                    }
                    break;
                case MAP_ID_MC:
                    if (bossEntryId == RAGNAROS_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(FIERY_CORE_ITEM_ID, 2 * totalRewardQuantityTwo);
                        player->AddItem(LAVA_CORE_ITEM_ID, 2 * totalRewardQuantityTwo);
                        player->AddItem(BLOOD_OF_THE_MOUNTAIN, 1);
                        player->AddItem(820023, ChestRewardNumber);
                        player->AddItem(819859, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else if (bossEntryId == GOLEMAGG_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 15 * totalRewardQuantityTwo);
                        player->AddItem(FIERY_CORE_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(LAVA_CORE_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(BLOOD_OF_THE_MOUNTAIN, 1);
                        player->AddItem(SULFURON_INGOT, 1);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(819859, totalRewardQuantityTwo);
                        player->AddItem(820023, ChestRewardNumber);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_RAID, 10 * totalRewardQuantityTwo);
                        player->AddItem(FIERY_CORE_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(LAVA_CORE_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(BLOOD_OF_THE_MOUNTAIN, 1);
                        player->AddItem(819859, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    break;
                case MAP_ID_BWL:
                    if (bossEntryId == NEFARIAN_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 25 * totalRewardQuantityTwo);
                        player->AddItem(820024, ChestRewardNumber);
                        player->AddItem(18562, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else if (bossEntryId == CHROMAGGUS_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(820024, ChestRewardNumber);
                        player->AddItem(18562, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else if (bossEntryId == VALTHORAX_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(820024, ChestRewardNumber);
                        player->AddItem(18562, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_RAID, 15 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(18562, 1);
                    }
                    break;
                case MAP_ID_ONYXIA:
                    if (bossEntryId == ONYXIA_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(CACHE_OF_ONYXIA, ChestRewardNumber);
                    }
                    break;
                case MAP_ID_AQ20:
                    if (bossEntryId == OSSIRIAN_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(SILITHID_CACHE, ChestRewardNumber);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(SANDWORN_SHARD, 2 * totalRewardQuantityTwo);
                        player->AddItem(21761, totalRewardQuantityTwo);
                        player->AddItem(22203, 2 * totalRewardQuantityTwo);
                        player->AddItem(CRYSALLINE_SCARAB, 1);

                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_RAID, 10 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(21761, totalRewardQuantityTwo);
                        player->AddItem(22203, 2* totalRewardQuantityTwo);
                    }
                    break;
                case MAP_ID_AQ40:
                    if (bossEntryId == CTHUN_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 25 * totalRewardQuantityTwo);
                        player->AddItem(CRYSALLINE_SCARAB, totalRewardQuantityTwo);
                        player->AddItem(SANDWORN_SHARD, 3 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(ANCIENT_QIRAJI_CACHE, ChestRewardNumber);
                        player->AddItem(21762, totalRewardQuantityTwo);
                        player->AddItem(21230, totalRewardQuantityTwo);
                        player->AddItem(21229, 2 * totalRewardQuantityTwo);
                        player->AddItem(NOZDORMU_TOKEN, 2 * totalRewardQuantityTwo);

                    }
                    else if (bossEntryId == OURO_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(CRYSALLINE_SCARAB, totalRewardQuantityTwo);
                        player->AddItem(SANDWORN_SHARD, 3 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(ANCIENT_QIRAJI_CACHE, ChestRewardNumber);
                        player->AddItem(21762, totalRewardQuantityTwo);
                        player->AddItem(21229, totalRewardQuantityTwo);
                        player->AddItem(NOZDORMU_TOKEN, totalRewardQuantityTwo);
                    }
                    else if (bossEntryId == BG_S) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(CRYSALLINE_SCARAB, totalRewardQuantityTwo);
                        player->AddItem(SANDWORN_SHARD, 3 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(ANCIENT_QIRAJI_CACHE, ChestRewardNumber);
                        player->AddItem(21762, totalRewardQuantityTwo);
                        player->AddItem(21229, totalRewardQuantityTwo);
                        player->AddItem(NOZDORMU_TOKEN, totalRewardQuantityTwo);
                    }
                    else {
                        player->AddItem(REWARD_ITEM_ID_RAID, 15 * totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        player->AddItem(CRYSALLINE_SCARAB, 1);
                        player->AddItem(SANDWORN_SHARD, 2 * totalRewardQuantityTwo);
                        player->AddItem(21762, totalRewardQuantityTwo);
                        player->AddItem(21229, totalRewardQuantityTwo);
                        player->AddItem(NOZDORMU_TOKEN, totalRewardQuantityTwo);
                    }
                    break;
                case MAP_ID_NAXX: 
                    if (bossEntryId == KELTHUZAD_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 30 * totalRewardQuantityTwo);
                        player->AddItem(NAXX_CACHE, ChestRewardNumber);
                        player->AddItem(NAXX_SATCHEL, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else if (bossEntryId == LOATHEB_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 20 * totalRewardQuantityTwo);
                        player->AddItem(NAXX_CACHE, ChestRewardNumber);
                        player->AddItem(NAXX_SATCHEL, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    }
                    else if (bossEntryId == SAPPHIRON_ENTRY_ID) {
                        player->AddItem(REWARD_ITEM_ID_RAID, 25 * totalRewardQuantityTwo);
                        player->AddItem(NAXX_CACHE, ChestRewardNumber);
                        player->AddItem(NAXX_SATCHEL, totalRewardQuantityTwo);
                        player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                        if (urand(1, 100) <= 2) {  // 2% chance for saph's icy reins
                            player->AddItem(860118, 1);
                        }
                    }
                    else {
                        // General rewards for other bosses in Naxxramas
                        player->AddItem(REWARD_ITEM_ID_RAID, 15 * totalRewardQuantityTwo);
                        player->AddItem(NAXX_SATCHEL, totalRewardQuantityTwo);
                    }
                    break;
                default:
                    // General reward logic for other raids
                    player->AddItem(REWARD_ITEM_ID_RAID, totalRewardQuantity);
                    player->AddItem(STATBONUS_REROLLER_ITEM_ID, totalRewardQuantityTwo);
                    break;
                }
            }
        }
        ChatHandler(player->GetSession()).PSendSysMessage("Congratulations! You've received a reward for killing a boss with challenge(s) active!");
    }
}

class TENMAN_NPC : public CreatureScript
{
public:
    TENMAN_NPC() : CreatureScript("TENMAN_NPC") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        // Check if the player already has one of the challenge auras
        for (uint32 aura : challengeAuras)
        {
            if (player->HasAura(aura))
            {
                ChatHandler(player->GetSession()).SendSysMessage("You have already chosen a challenge.");
                return false;
            }
        }

        ClearGossipMenuFor(player);

        AddGossipItemFor(player, GOSSIP_ICON, "Bronze Challenge - 1 Affix", 0, 1);
        AddGossipItemFor(player, GOSSIP_ICON, "Silver Challenge - 2 Affixes", 0, 2);
        AddGossipItemFor(player, GOSSIP_ICON, "Gold Challenge - 3 Affixes", 0, 3);
        AddGossipItemFor(player, GOSSIP_ICON, "Platinum Challenge - 4 Affixes", 0, 4);
        AddGossipItemFor(player, GOSSIP_ICON, "Diamond Challenge - 5 Affixes", 0, 5);
        AddGossipItemFor(player, GOSSIP_ICON, "Nevermind...", 0, 6);

        SendGossipMenuFor(player, 1, creature->GetGUID());

        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();

        if (action != 6)  // Exclude "Nevermind..." action
        {
            // Randomize affixes
            std::vector<uint32> randomizedAuras(challengeAuras.begin(), challengeAuras.end());
            std::shuffle(randomizedAuras.begin(), randomizedAuras.end(), std::mt19937(std::random_device()()));

            uint32 numberOfAffixes = 0;
            switch (action)
            {
            case 1: numberOfAffixes = 1; break;
            case 2: numberOfAffixes = 2; break;
            case 3: numberOfAffixes = 3; break;
            case 4: numberOfAffixes = 4; break;
            case 5: numberOfAffixes = 5; break;
            default: break;
            }

            std::set<uint32> appliedAffixes;
            if (numberOfAffixes >= 3)
            {
                appliedAffixes.insert(TYRANNICAL_SPELL_ID);
                ApplyAllPlayerBuff(player, true, TYRANNICAL_SPELL_ID);
            }

            for (uint32 i = 0; i < randomizedAuras.size() && appliedAffixes.size() < numberOfAffixes; ++i)
            {
                uint32 affix = randomizedAuras[i];
                if (appliedAffixes.count(affix) > 0)
                    continue;

                if (numberOfAffixes < 3 && affix == TYRANNICAL_SPELL_ID)
                    continue;

                if ((numberOfAffixes == 2 || numberOfAffixes == 3) && ((affix == DECAY_SPELL_ID && appliedAffixes.count(CORPSE_EXPLOSION_SPELL_ID)) || (affix == CORPSE_EXPLOSION_SPELL_ID && appliedAffixes.count(DECAY_SPELL_ID))))
                    continue;

                ApplyAllPlayerBuff(player, true, affix);
                appliedAffixes.insert(affix);
            }

            Map* map = player->GetMap();
            if (map)
            {
                // Capture player's current position
                float playerX = player->GetPositionX();
                float playerY = player->GetPositionY();
                float playerZ = player->GetPositionZ();
                float playerO = player->GetOrientation();

                // Schedule the respawn logic to happen after 5 seconds
                player->m_scheduler.Schedule(5s, [map](TaskContext /*context*/)
                    {
                        auto& creatureStore = map->GetCreatureBySpawnIdStore();
                        for (auto& pair : creatureStore)
                        {
                            Creature* mapCreature = pair.second;
                            if (mapCreature && mapCreature->isDead())
                            {
                                if (mapCreature->IsDungeonBoss())
                                {
                                    mapCreature->Respawn(true);  // Force respawn for bosses
                                }
                                else
                                {
                                    mapCreature->Respawn();
                                }
                            }
                        }

                        Map::PlayerList const& players = map->GetPlayers();
                        for (auto& pair : players)
                        {
                            if (Player* player = pair.GetSource())
                            {
                                ChatHandler(player->GetSession()).SendSysMessage("All creatures in the instance have been respawned.");
                            }
                        }
                    });

                if (numberOfAffixes > 0)  // Schedule teleportation if any affix was selected
                {
                    creature->DespawnOrUnsummon(10000);
                    for (int i = 5; i > 0; --i)
                    {
                        player->m_scheduler.Schedule(std::chrono::seconds(5 - i), [playerGuid = player->GetGUID(), i](TaskContext /*context*/)
                            {
                                if (Player* player = ObjectAccessor::FindPlayer(playerGuid))
                                {
                                    std::string countdownMsg = "Teleporting in " + std::to_string(i) + " second(s)...";
                                    player->TextEmote(countdownMsg, nullptr, true);
                                }
                            });
                    }

                    // Schedule the teleportation to happen after 5 seconds
                    player->m_scheduler.Schedule(5s, [map, playerX, playerY, playerZ, playerO](TaskContext /*context*/)
                        {
                            // Teleport all NPCBots to the saved player position
                            auto& creatureStore = map->GetCreatureBySpawnIdStore();
                            for (auto& pair : creatureStore)
                            {
                                Creature* mapCreature = pair.second;
                                if (mapCreature && mapCreature->IsNPCBotOrPet())
                                {
                                    mapCreature->NearTeleportTo(playerX, playerY, playerZ, playerO);
                                }
                            }

                            // Teleport all players in the instance to the saved player position
                            Map::PlayerList const& players = map->GetPlayers();
                            for (auto& pair : players)
                            {
                                if (Player* mapPlayer = pair.GetSource())
                                {
                                    mapPlayer->NearTeleportTo(playerX, playerY, playerZ, playerO);
                                    ChatHandler(mapPlayer->GetSession()).SendSysMessage("You have been teleported.");
                                }
                            }
                        });
                    // Save all players to the instance if the map is a raid
                    if (map->IsRaid())
                    {
                        Map::PlayerList const& players = map->GetPlayers();
                        for (auto& pair : players)
                        {
                            if (Player* mapPlayer = pair.GetSource())
                            {
                                InstanceSave* mapSave = sInstanceSaveMgr->GetInstanceSave(map->GetInstanceId());
                                if (mapSave)
                                {
                                    sInstanceSaveMgr->PlayerBindToInstance(mapPlayer->GetGUID(), mapSave, true, mapPlayer);
                                }
                            }
                        }
                    }
                }
            }
        }

        CloseGossipMenuFor(player);
        return true;
    }

private:
    static void ApplyAllPlayerBuff(Player* player, bool apply, uint32 spellId = 0) {
        std::list<Player*> nearbyPlayers;
        Acore::AnyPlayerInObjectRangeCheck checker(player, 100.0f);
        Acore::PlayerListSearcher<Acore::AnyPlayerInObjectRangeCheck> searcher(player, nearbyPlayers, checker);
        Cell::VisitWorldObjects(player, searcher, 100.0f);

        for (Player* nearbyPlayer : nearbyPlayers) {
            if (apply && spellId) {
                nearbyPlayer->AddAura(spellId, nearbyPlayer);
            }
            else if (!apply && spellId) {
                nearbyPlayer->RemoveAura(spellId);
            }
        }
    }
};

class creature_tyrant_aura_dummy_despawners : public CreatureScript
{
public:
    creature_tyrant_aura_dummy_despawners() : CreatureScript("creature_tyrant_aura_dummy_despawners") {}

    struct creature_tyrant_aura_dummy_despawnersAI : public ScriptedAI
    {
        creature_tyrant_aura_dummy_despawnersAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            events.Reset();
            me->AddAura(800140, me);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!me->GetMap()->IsDungeon() && !me->GetMap()->IsRaid())
            {
                me->DespawnOrUnsummon();
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new creature_tyrant_aura_dummy_despawnersAI(creature);
    }
};

class creature_corpse_aura_dummy_despawners : public CreatureScript
{
public:
    creature_corpse_aura_dummy_despawners() : CreatureScript("creature_corpse_aura_dummy_despawners") {}

    struct creature_corpse_aura_dummy_despawnersAI : public ScriptedAI
    {
        creature_corpse_aura_dummy_despawnersAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            events.Reset();
            me->AddAura(861616, me);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!me->GetMap()->IsDungeon() && !me->GetMap()->IsRaid())
            {
                me->DespawnOrUnsummon();
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new creature_corpse_aura_dummy_despawnersAI(creature);
    }
};

class creature_nullify_aura_dummy_despawners : public CreatureScript
{
public:
    creature_nullify_aura_dummy_despawners() : CreatureScript("creature_nullify_aura_dummy_despawners") {}

    struct creature_nullify_aura_dummy_despawnersAI : public ScriptedAI
    {
        creature_nullify_aura_dummy_despawnersAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            events.Reset();
            me->AddAura(880139, me);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!me->GetMap()->IsDungeon() && !me->GetMap()->IsRaid())
            {
                me->DespawnOrUnsummon();
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new creature_nullify_aura_dummy_despawnersAI(creature);
    }
};

class creature_decay_aura_dummy_despawners : public CreatureScript
{
public:
    creature_decay_aura_dummy_despawners() : CreatureScript("creature_decay_aura_dummy_despawners") {}

    struct creature_decay_aura_dummy_despawnersAI : public ScriptedAI
    {
        creature_decay_aura_dummy_despawnersAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            events.Reset();
            me->AddAura(800139, me);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!me->GetMap()->IsDungeon() && !me->GetMap()->IsRaid())
            {
                me->DespawnOrUnsummon();
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new creature_decay_aura_dummy_despawnersAI(creature);
    }
};

class creature_enfeeble_aura_dummy_despawners : public CreatureScript
{
public:
    creature_enfeeble_aura_dummy_despawners() : CreatureScript("creature_enfeeble_aura_dummy_despawners") {}

    struct creature_enfeeble_aura_dummy_despawnersAI : public ScriptedAI
    {
        creature_enfeeble_aura_dummy_despawnersAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            events.Reset();
            me->AddAura(107099, me);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!me->GetMap()->IsDungeon() && !me->GetMap()->IsRaid())
            {
                me->DespawnOrUnsummon();
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new creature_enfeeble_aura_dummy_despawnersAI(creature);
    }
};

class spell_summon_tyrant_npc : public SpellScriptLoader
{
public:
    spell_summon_tyrant_npc() : SpellScriptLoader("spell_summon_tyrant_npc") {}

    class spell_summon_tyrant_npc_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_summon_tyrant_npc_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                if (!caster->FindNearestCreature(83029, 70.0f, true)) // Check if a tyrant NPC already exists within 70 yards
                {
                    if (TempSummon* summon = caster->SummonCreature(83029, caster->GetPosition(), TEMPSUMMON_TIMED_DESPAWN, 17200000)) // 2hr
                    {
                        summon->AddAura(800140, summon);
                        summon->SetFaction(caster->GetFaction());
                        if (Player* player = caster->ToPlayer())
                        {
                            AddSummonedCreature(player, summon);
                        }
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_summon_tyrant_npc_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_summon_tyrant_npc_SpellScript();
    }
};

class spell_summon_corpse_explosion_npc : public SpellScriptLoader
{
public:
    spell_summon_corpse_explosion_npc() : SpellScriptLoader("spell_summon_corpse_explosion_npc") {}

    class spell_summon_corpse_explosion_npc_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_summon_corpse_explosion_npc_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                if (!caster->FindNearestCreature(83030, 70.0f, true)) // Check if a corpse explosion NPC already exists within 70 yards
                {
                    if (TempSummon* summon = caster->SummonCreature(83030, caster->GetPosition(), TEMPSUMMON_TIMED_DESPAWN, 17200000)) // 2hr
                    {
                        summon->AddAura(861616, summon); // Apply aura on self upon spawn
                        summon->SetFaction(caster->GetFaction());
                        if (Player* player = caster->ToPlayer())
                        {
                            AddSummonedCreature(player, summon);
                        }
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_summon_corpse_explosion_npc_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_summon_corpse_explosion_npc_SpellScript();
    }
};

class spell_summon_nullifying_npc : public SpellScriptLoader
{
public:
    spell_summon_nullifying_npc() : SpellScriptLoader("spell_summon_nullifying_npc") {}

    class spell_summon_nullifying_npc_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_summon_nullifying_npc_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                if (!caster->FindNearestCreature(83031, 70.0f, true)) // Check if a nullifying NPC already exists within 70 yards
                {
                    if (TempSummon* summon = caster->SummonCreature(83031, caster->GetPosition(), TEMPSUMMON_TIMED_DESPAWN, 17200000)) // 2hr
                    {
                        summon->AddAura(880139, summon); // Apply aura on self upon spawn
                        summon->SetFaction(caster->GetFaction());
                        if (Player* player = caster->ToPlayer())
                        {
                            AddSummonedCreature(player, summon);
                        }
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_summon_nullifying_npc_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_summon_nullifying_npc_SpellScript();
    }
};

class spell_summon_decay_npc : public SpellScriptLoader
{
public:
    spell_summon_decay_npc() : SpellScriptLoader("spell_summon_decay_npc") {}

    class spell_summon_decay_npc_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_summon_decay_npc_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                if (!caster->FindNearestCreature(83032, 70.0f, true)) // Check if a nullifying NPC already exists within 70 yards
                {
                    if (TempSummon* summon = caster->SummonCreature(83032, caster->GetPosition(), TEMPSUMMON_TIMED_DESPAWN, 17200000)) // 2hr
                    {
                        summon->AddAura(800139, summon); // Apply aura on self upon spawn
                        summon->SetFaction(caster->GetFaction());
                        if (Player* player = caster->ToPlayer())
                        {
                            AddSummonedCreature(player, summon);
                        }
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_summon_decay_npc_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_summon_decay_npc_SpellScript();
    }
};

class spell_summon_enfeeble_npc : public SpellScriptLoader
{
public:
    spell_summon_enfeeble_npc() : SpellScriptLoader("spell_summon_enfeeble_npc") {}

    class spell_summon_enfeeble_npc_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_summon_enfeeble_npc_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                if (!caster->FindNearestCreature(83033, 70.0f, true)) // Check if a nullifying NPC already exists within 70 yards
                {
                    if (TempSummon* summon = caster->SummonCreature(83033, caster->GetPosition(), TEMPSUMMON_TIMED_DESPAWN, 17200000)) // 2hr
                    {
                        summon->AddAura(107099, summon); // Apply aura on self upon spawn
                        summon->SetFaction(caster->GetFaction());
                        if (Player* player = caster->ToPlayer())
                        {
                            AddSummonedCreature(player, summon);
                        }
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_summon_enfeeble_npc_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_summon_enfeeble_npc_SpellScript();
    }
};

class challenge_loot_bunny_dungeon_one : public CreatureScript
{
public:
    challenge_loot_bunny_dungeon_one() : CreatureScript("challenge_loot_bunny_dungeon_one") {}

    struct challenge_loot_bunny_dungeon_oneAI : public ScriptedAI
    {
        challenge_loot_bunny_dungeon_oneAI(Creature* creature) : ScriptedAI(creature) {}

        void JustDied(Unit* /*killer*/) override
        {
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            for (auto const& playerPair : players)
            {
                Player* player = playerPair.GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, 1, true);
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new challenge_loot_bunny_dungeon_oneAI(creature);
    }
};

class challenge_loot_bunny_dungeon_three : public CreatureScript
{
public:
    challenge_loot_bunny_dungeon_three() : CreatureScript("challenge_loot_bunny_dungeon_three") {}

    struct challenge_loot_bunny_dungeon_threeAI : public ScriptedAI
    {
        challenge_loot_bunny_dungeon_threeAI(Creature* creature) : ScriptedAI(creature) {}

        void JustDied(Unit* /*killer*/) override
        {
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            for (auto const& playerPair : players)
            {
                Player* player = playerPair.GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, 3, true);
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new challenge_loot_bunny_dungeon_threeAI(creature);
    }
};

class challenge_loot_bunny_dungeon_five : public CreatureScript
{
public:
    challenge_loot_bunny_dungeon_five() : CreatureScript("challenge_loot_bunny_dungeon_five") {}

    struct challenge_loot_bunny_dungeon_fiveAI : public ScriptedAI
    {
        challenge_loot_bunny_dungeon_fiveAI(Creature* creature) : ScriptedAI(creature) {}

        void JustDied(Unit* /*killer*/) override
        {
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            for (auto const& playerPair : players)
            {
                Player* player = playerPair.GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, 5, true);
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new challenge_loot_bunny_dungeon_fiveAI(creature);
    }
};

class challenge_loot_bunny_dungeon_roller : public CreatureScript
{
public:
    challenge_loot_bunny_dungeon_roller() : CreatureScript("challenge_loot_bunny_dungeon_roller") {}

    struct challenge_loot_bunny_dungeon_rollerAI : public ScriptedAI
    {
        challenge_loot_bunny_dungeon_rollerAI(Creature* creature) : ScriptedAI(creature) {}

        void JustDied(Unit* /*killer*/) override
        {
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            for (auto const& playerPair : players)
            {
                Player* player = playerPair.GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, 1, true);
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new challenge_loot_bunny_dungeon_rollerAI(creature);
    }
};

class challenge_loot_bunny_raid : public CreatureScript
{
public:
    challenge_loot_bunny_raid() : CreatureScript("challenge_loot_bunny_raid") {}

    struct challenge_loot_bunny_raidAI : public ScriptedAI
    {
        challenge_loot_bunny_raidAI(Creature* creature) : ScriptedAI(creature) {}

        void JustDied(Unit* /*killer*/) override
        {
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            for (auto const& playerPair : players)
            {
                Player* player = playerPair.GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, 1, false);
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new challenge_loot_bunny_raidAI(creature);
    }
};

class challenge_loot_bunny_mc_chest : public CreatureScript
{
public:
    challenge_loot_bunny_mc_chest() : CreatureScript("challenge_loot_bunny_mc_chest") {}

    struct challenge_loot_bunny_mc_chestAI : public ScriptedAI
    {
        challenge_loot_bunny_mc_chestAI(Creature* creature) : ScriptedAI(creature) {}

        void JustDied(Unit* /*killer*/) override
        {
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            for (auto const& playerPair : players)
            {
                Player* player = playerPair.GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, 1, false);
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new challenge_loot_bunny_mc_chestAI(creature);
    }
};

class challenge_loot_bunny_bwl_chest : public CreatureScript
{
public:
    challenge_loot_bunny_bwl_chest() : CreatureScript("challenge_loot_bunny_bwl_chest") {}

    struct challenge_loot_bunny_bwl_chestAI : public ScriptedAI
    {
        challenge_loot_bunny_bwl_chestAI(Creature* creature) : ScriptedAI(creature) {}

        void JustDied(Unit* /*killer*/) override
        {
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            for (auto const& playerPair : players)
            {
                Player* player = playerPair.GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, 1, false);
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new challenge_loot_bunny_bwl_chestAI(creature);
    }
};

class challenge_loot_bunny_strath_scholo_ubrs : public CreatureScript
{
public:
    challenge_loot_bunny_strath_scholo_ubrs() : CreatureScript("challenge_loot_bunny_strath_scholo_ubrs") {}

    struct challenge_loot_bunny_strath_scholo_ubrs_chestAI : public ScriptedAI
    {
        challenge_loot_bunny_strath_scholo_ubrs_chestAI(Creature* creature) : ScriptedAI(creature) {}

        void JustDied(Unit* /*killer*/) override
        {
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            for (auto const& playerPair : players)
            {
                Player* player = playerPair.GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, 1, true);
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new challenge_loot_bunny_strath_scholo_ubrs_chestAI(creature);
    }
};

class spell_aura_of_decay : public SpellScriptLoader
{
public:
    spell_aura_of_decay() : SpellScriptLoader("spell_aura_of_decay") { }

    class spell_aura_of_decay_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_aura_of_decay_AuraScript);

        void OnPeriodic(AuraEffect const* aurEff)
        {
            if (Unit* target = GetTarget())
            {
                if (Creature* creature = target->ToCreature())
                {
                    // Check for TRIGGER or CREATURE_FLAG_EXTRA_IGNORE_COMBAT or CREATURE_FLAG_EXTRA_CIVILIAN flag
                    if (creature->GetCreatureTemplate()->flags_extra & (CREATURE_FLAG_EXTRA_TRIGGER | CREATURE_FLAG_EXTRA_CIVILIAN))
                    {
                        PreventDefaultAction();
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectPeriodic += AuraEffectPeriodicFn(spell_aura_of_decay_AuraScript::OnPeriodic, EFFECT_1, SPELL_AURA_PERIODIC_DAMAGE_PERCENT);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_aura_of_decay_AuraScript();
    }
};

void AddSC_TENMAN()
{
    new creature_tyrant_aura_dummy_despawners();
    new creature_corpse_aura_dummy_despawners();
    new creature_nullify_aura_dummy_despawners();
    new creature_decay_aura_dummy_despawners();
    new creature_enfeeble_aura_dummy_despawners();
    new challenge_loot_bunny_dungeon_one();
    new challenge_loot_bunny_dungeon_three();
    new challenge_loot_bunny_dungeon_five();
    new challenge_loot_bunny_dungeon_roller();
    new challenge_loot_bunny_raid();
    new challenge_loot_bunny_mc_chest();
    new challenge_loot_bunny_bwl_chest();
    new challenge_loot_bunny_strath_scholo_ubrs();
    new TENMAN_NPC();
    new spell_summon_tyrant_npc();
    new spell_summon_corpse_explosion_npc();
    new spell_summon_nullifying_npc();
    new spell_summon_decay_npc();
    new spell_summon_enfeeble_npc();
    new spell_aura_of_decay();
}
