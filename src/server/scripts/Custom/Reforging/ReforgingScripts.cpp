#include "Reforging.h"
#include <sstream>
#include <string>
#include <vector>
#include "Creature.h"
#include "Define.h"
#include "EventProcessor.h"
#include "GossipDef.h"
#include "Item.h"
#include "ItemTemplate.h"
#include "ObjectGuid.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "ScriptMgr.h"
#include "SharedDefines.h"
#include "Spell.h"
#include "Transaction.h"
#include "WorldPacket.h"
#include "WorldSession.h"
#include "DatabaseEnv.h"

/*
Reforging by Rochet2
http://rochet2.github.io/

Rules of thumb:
Item can be reforged once.
Item reforge wont show to anyone but you in tooltips. Stats will be there nevertheless.
You will see the increased stats on all tooltips of the same item you reforged.
You can disable the stat changes to tooltips by setting send_cache_packets to false in Reforging.cpp.
Reforges are stripped when you mail, ah, guildbank the item etc. Only YOU can have the reforge.
Only item base stats are reforgable. Enchants and random stats are not.

This script is made blizzlike. This means that the reforgable stats etc are from CATACLYSM! Dinkle Edit: Not anymore. I've extended stats but kept stamina removed.
I have been informed that some stats were removed etc that would be important to be reforgable.
However I do not know what those stats are currently. Do look through the statTypes to add whatever you want.
Edit IsReforgable is you want to tweak requirements

*/

// Remember to add to GetStatName too
static const ItemModType statTypes[] = { ITEM_MOD_SPIRIT, ITEM_MOD_DODGE_RATING, ITEM_MOD_PARRY_RATING, ITEM_MOD_HIT_RATING, ITEM_MOD_CRIT_RATING, ITEM_MOD_HASTE_RATING, ITEM_MOD_EXPERTISE_RATING, ITEM_MOD_AGILITY, ITEM_MOD_STRENGTH, ITEM_MOD_INTELLECT, ITEM_MOD_DEFENSE_SKILL_RATING, ITEM_MOD_BLOCK_RATING, ITEM_MOD_RESILIENCE_RATING, ITEM_MOD_MANA_REGENERATION, ITEM_MOD_ARMOR_PENETRATION_RATING, ITEM_MOD_HEALTH_REGEN, ITEM_MOD_SPELL_PENETRATION };
static const uint8 stat_type_max = sizeof(statTypes) / sizeof(*statTypes);

static const char* GetStatName(uint32 ItemStatType)
{
    switch (ItemStatType)
    {
    case ITEM_MOD_SPIRIT: return "Spirit"; break;
    case ITEM_MOD_DODGE_RATING: return "Dodge rating"; break;
    case ITEM_MOD_PARRY_RATING: return "Parry rating"; break;
    case ITEM_MOD_HIT_RATING: return "Hit rating"; break;
    case ITEM_MOD_CRIT_RATING: return "Crit rating"; break;
    case ITEM_MOD_HASTE_RATING: return "Haste rating"; break;
    case ITEM_MOD_EXPERTISE_RATING: return "Expertise rating"; break;
    case ITEM_MOD_AGILITY: return "Agility"; break;
    case ITEM_MOD_STRENGTH: return "Strength"; break;
    case ITEM_MOD_INTELLECT: return "Intellect"; break;
    case ITEM_MOD_DEFENSE_SKILL_RATING: return "Defense skill rating"; break;
    case ITEM_MOD_BLOCK_RATING: return "Block rating"; break;
    case ITEM_MOD_RESILIENCE_RATING: return "Resilience rating"; break;
    case ITEM_MOD_MANA_REGENERATION: return "Mana regeneration"; break;
    case ITEM_MOD_ARMOR_PENETRATION_RATING: return "Armor penetration rating"; break;
    case ITEM_MOD_HEALTH_REGEN: return "Health regen"; break;
    case ITEM_MOD_SPELL_PENETRATION: return "Spell penetration"; break;
    default: return NULL;
    }
}

static const char* GetSlotName(uint8 slot, WorldSession* /*session*/)
{
    switch (slot)
    {
        case EQUIPMENT_SLOT_HEAD: return "Head";
        case EQUIPMENT_SLOT_NECK: return "Neck";
        case EQUIPMENT_SLOT_SHOULDERS: return "Shoulders";
        case EQUIPMENT_SLOT_BODY: return "Shirt";
        case EQUIPMENT_SLOT_CHEST: return "Chest";
        case EQUIPMENT_SLOT_WAIST: return "Waist";
        case EQUIPMENT_SLOT_LEGS: return "Legs";
        case EQUIPMENT_SLOT_FEET: return "Feet";
        case EQUIPMENT_SLOT_WRISTS: return "Wrists";
        case EQUIPMENT_SLOT_HANDS: return "Hands";
        case EQUIPMENT_SLOT_FINGER1: return "First Finger";
        case EQUIPMENT_SLOT_FINGER2: return "Second Finger";
        case EQUIPMENT_SLOT_TRINKET1: return "First Trinket";
        case EQUIPMENT_SLOT_TRINKET2: return "Second Trinket";
        case EQUIPMENT_SLOT_BACK: return "Back";
        case EQUIPMENT_SLOT_MAINHAND: return "Main Hand";
        case EQUIPMENT_SLOT_OFFHAND: return "Off Hand";
        case EQUIPMENT_SLOT_TABARD: return "Tabard";
        case EQUIPMENT_SLOT_RANGED: return "Ranged";
        default: return NULL;
    }
}

static uint32 Melt(uint8 i, uint8 j)
{
    return (i << 8) + j;
}

static void Unmelt(uint32 melt, uint8& i, uint8& j)
{
    i = melt >> 8;
    j = melt & 0xFF;
}

static Item* GetEquippedItem(Player* player, uint32 guidlow)
{
    for (uint8 i = EQUIPMENT_SLOT_START; i < INVENTORY_SLOT_ITEM_END; ++i)
        if (Item* pItem = player->GetItemByPos(INVENTORY_SLOT_BAG_0, i))
            if (pItem->GetGUID().GetCounter() == guidlow)
                return pItem;
    return NULL;
}

static bool IsReforgable(Item* invItem, Player* player)
{
    //if (!invItem->IsEquipped())
    //    return false;
    if (invItem->GetOwnerGUID() != player->GetGUID())
        return false;
    const ItemTemplate* pProto = invItem->GetTemplate();
    //if (pProto->ItemLevel < 200)
    //    return false;
    //if (pProto->Quality == ITEM_QUALITY_HEIRLOOM) // block heirlooms necessary?
    //    return false;
    if (!pProto->StatsCount || pProto->StatsCount >= MAX_ITEM_PROTO_STATS) // Mandatory! Do NOT remove or edit
        return false;
    if (!player->reforgeMap.empty() && player->reforgeMap.find(invItem->GetGUID().GetCounter()) != player->reforgeMap.end()) // Mandatory! Do NOT remove or edit
        return false;
    for (uint32 i = 0; i < pProto->StatsCount; ++i)
    {
        if (!GetStatName(pProto->ItemStat[i].ItemStatType))
            continue;
        if (((int32)floorf((float)pProto->ItemStat[i].ItemStatValue * 0.4f)) > 1)
            return true;
    }
    return false;
}

static void UpdatePlayerReforgeStats(Item* invItem, Player* player, uint32 decrease, uint32 increase) // stat types
{
    const ItemTemplate* pProto = invItem->GetTemplate();
    int32 stat_diff = 0;

    for (uint32 i = 0; i < pProto->StatsCount; ++i)
    {
        if (pProto->ItemStat[i].ItemStatType == increase)
            return; // Should not have the increased stat already
        if (pProto->ItemStat[i].ItemStatType == decrease)
            stat_diff = (int32)floorf((float)pProto->ItemStat[i].ItemStatValue * 0.4f);
    }

    if (stat_diff <= 0)
        return; // Should have some kind of diff

    uint32 currencyItemId = 0;
    uint32 costAmount = 0;

    if (player->getLevel() <= 69)
    {
        currencyItemId = 37711; // Reward Points
        costAmount = 50;
    }
    else if (player->getLevel() <= 79)
    {
        currencyItemId = 29434; // Badges of Justice
        costAmount = 10;
    }
    else if (player->getLevel() == 80)
    {
        currencyItemId = 40752; // Emblems of Heroism
        costAmount = 10;
    }

    if (!player->HasItemCount(currencyItemId, costAmount))
    {
        ChatHandler(player->GetSession()).SendNotification("Not enough currency for reforging.");
        return;
    }

    // Deduct the cost
    player->DestroyItemCount(currencyItemId, costAmount, true, false);

    // Update player stats
    if (invItem->IsEquipped())
        player->_ApplyItemMods(invItem, invItem->GetSlot(), false);
    uint32 guidlow = invItem->GetGUID().GetCounter();
    ReforgeData& data = player->reforgeMap[guidlow];
    data.increase = increase;
    data.decrease = decrease;
    data.stat_value = stat_diff;
    if (invItem->IsEquipped())
        player->_ApplyItemMods(invItem, invItem->GetSlot(), true);

    // Save reforge to database (implementation depends on your database structure)
    // CharacterDatabase.PExecute("REPLACE INTO `custom_reforging` (`GUID`, `increase`, `decrease`, `stat_value`) VALUES (%u, %u, %u, %d)", guidlow, increase, decrease, stat_diff);

    SendReforgePacket(player, invItem->GetEntry(), 0, &data); // Ensure this function correctly updates client-side UI
    // player->SaveToDB(); // Consider saving player data if necessary
}

class REFORGE_SERVER : public WorldScript
{
public:
    REFORGE_SERVER() : WorldScript("REFORGE_SERVER")
    {
    }

    void OnStartup() override
    {
        CharacterDatabase.Query("DELETE FROM `custom_reforging` WHERE NOT EXISTS (SELECT 1 FROM `item_instance` WHERE `item_instance`.`guid` = `custom_reforging`.`GUID`)");
    }
};


class REFORGE_PLAYER : public PlayerScript
{
public:
    REFORGE_PLAYER() : PlayerScript("REFORGE_PLAYER")
    {
    }

    class SendRefPackLogin : public BasicEvent
    {
    public:
        SendRefPackLogin(Player* _player) : player(_player)
        {
            _player->m_Events.AddEvent(this, _player->m_Events.CalculateTime(1000));
        }

        bool Execute(uint64, uint32) override
        {
            SendReforgePackets(player);
            return true;
        }
        Player* player;
    };

    void OnLogin(Player* player) override
    {
        uint32 playerGUID = player->GetGUID().GetCounter();
        QueryResult result = CharacterDatabase.Query("SELECT `GUID`, `increase`, `decrease`, `stat_value` FROM `custom_reforging` WHERE `Owner` = {}", playerGUID);
        if (result)
        {
            do
            {
                uint32 lowGUID = (*result)[0].Get<uint32>();
                Item* invItem = player->GetItemByGuid(ObjectGuid(HighGuid::Item, 0, lowGUID));
                if (invItem && invItem->IsEquipped())
                    player->_ApplyItemMods(invItem, invItem->GetSlot(), false);
                ReforgeData& data = player->reforgeMap[lowGUID];
                data.increase = (*result)[1].Get<uint32>();
                data.decrease = (*result)[2].Get<uint32>();
                data.stat_value = (*result)[3].Get<int32>();
                if (invItem && invItem->IsEquipped())
                    player->_ApplyItemMods(invItem, invItem->GetSlot(), true);
                // SendReforgePacket(player, entry, lowGUID);
            } while (result->NextRow());

            // SendReforgePackets(player);
            new SendRefPackLogin(player);
        }
    }

    //void OnLogout(Player* player) override
    //{
    //    if (player->reforgeMap.empty())
    //        return;
    //    for (ReforgeMapType::const_iterator it = player->reforgeMap.begin(); it != player->reforgeMap.end();)
    //    {
    //        ReforgeMapType::const_iterator old_it = it++;
    //        RemoveReforge(player, old_it->first, false);
    //    }
    //}

    void OnSave(Player* player) override
    {
        uint32 lowguid = player->GetGUID().GetCounter();
        auto trans = CharacterDatabase.BeginTransaction();
        trans->Append("DELETE FROM `custom_reforging` WHERE `Owner` = {}", lowguid);
        if (!player->reforgeMap.empty())
        {
            // Only save items that are in inventory / bank / etc
            std::vector<Item*> items = GetItemList(player);
            for (std::vector<Item*>::const_iterator it = items.begin(); it != items.end(); ++it)
            {
                ReforgeMapType::const_iterator it2 = player->reforgeMap.find((*it)->GetGUID().GetCounter());
                if (it2 == player->reforgeMap.end())
                    continue;

                const ReforgeData& data = it2->second;
                trans->Append("REPLACE INTO `custom_reforging` (`GUID`, `increase`, `decrease`, `stat_value`, `Owner`) VALUES ({}, {}, {}, {}, {})", it2->first, data.increase, data.decrease, data.stat_value, lowguid);
            }
        }

        if (trans->GetSize()) // basically never false
            CharacterDatabase.CommitTransaction(trans);
    }
};

class REFORGER_NPC : public CreatureScript
{
public:
    REFORGER_NPC() : CreatureScript("REFORGER_NPC") { }

    struct Timed : public BasicEvent
    {
        // This timed event tries to fix modify money breaking gossip
        // This event closes the gossip menu and on the second player update tries to open the next menu
        Timed(Player* player, Creature* creature) : guid(creature->GetGUID()), player(player), triggered(false)
        {
            CloseGossipMenuFor(player);
            player->m_Events.AddEvent(this, player->m_Events.CalculateTime(1));
        }

        bool Execute(uint64, uint32) override
        {
            if (!triggered)
            {
                triggered = true;
                player->m_Events.AddEvent(this, player->m_Events.CalculateTime(1));
                return false;
            }
            if (Creature* creature = player->GetNPCIfCanInteractWith(guid, UNIT_NPC_FLAG_GOSSIP))
                REFORGER_NPC().OnGossipHello(player, creature);

            //LOG_ERROR("server.error", "Timed Event");
            return true;
        }

        ObjectGuid guid;
        Player* player;
        bool triggered;
    };

    bool OnGossipHello(Player* player, Creature* creature) override
    {
     //   LOG_ERROR("server.error", "OnGossipHello");
        AddGossipItemFor(player, GOSSIP_ICON_BATTLE, "Select slot of the item to reforge:", 0, Melt(MAIN_MENU, 0));
        for (uint8 slot = EQUIPMENT_SLOT_START; slot < EQUIPMENT_SLOT_END; ++slot)
        {
            if (Item* invItem = player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
            {
                if (IsReforgable(invItem, player))
                {
                    if (const char* slotname = GetSlotName(slot, player->GetSession()))
                    {
                        std::ostringstream gossipText;
                        gossipText << slotname << ":"; // Add a colon after the slot name

                        // Determine color code based on item quality
                        std::string colorCode;
                        switch (invItem->GetTemplate()->Quality)
                        {
                        case ITEM_QUALITY_POOR: colorCode = "|cff9d9d9d"; break; // Grey
                        case ITEM_QUALITY_NORMAL: colorCode = "|cffffffff"; break; // White
                        case ITEM_QUALITY_UNCOMMON: colorCode = "|cff1eff00"; break; // Green
                        case ITEM_QUALITY_RARE: colorCode = "|cff0070dd"; break; // Blue
                        case ITEM_QUALITY_EPIC: colorCode = "|cffa335ee"; break; // Purple
                        case ITEM_QUALITY_LEGENDARY: colorCode = "|cffff8000"; break; // Orange
                        case ITEM_QUALITY_ARTIFACT: colorCode = "|cffe6cc80"; break; // Artifact
                        case ITEM_QUALITY_HEIRLOOM: colorCode = "|cffe6cc80"; break; // Heirloom
                        default: colorCode = "|cffffffff"; // Default to white if no quality match
                        }

                        // Append item name with quality color on a new line
                        gossipText << "\n" << colorCode << "[" << invItem->GetTemplate()->Name1 << "]|r";

                        // Add the gossip item with the constructed text
                        AddGossipItemFor(player, GOSSIP_ICON_TRAINER, gossipText.str(), 0, Melt(SELECT_STAT_REDUCE, slot));
                    }
                }
            }
        }
        AddGossipItemFor(player, GOSSIP_ICON_TRAINER, "Remove Reforges", 0, Melt(SELECT_RESTORE, 0));
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Update Menu", 0, Melt(MAIN_MENU, 0));
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 melt) override
    {

      //  LOG_ERROR("server.error", "OnGossipSelect");
        ClearGossipMenuFor(player);

        uint8 menu, action;
        Unmelt(melt, menu, action);

        switch (menu)
        {
            case MAIN_MENU: OnGossipHello(player, creature); break;
            case SELECT_STAT_REDUCE:
                // action = slot
                if (Item* invItem = player->GetItemByPos(INVENTORY_SLOT_BAG_0, action))
                {
                    if (IsReforgable(invItem, player))
                    {
                        uint32 guidlow = invItem->GetGUID().GetCounter();
                        const ItemTemplate* pProto = invItem->GetTemplate();
                        AddGossipItemFor(player, GOSSIP_ICON_BATTLE, "Stat to decrease:", sender, melt);
                        for (uint32 i = 0; i < pProto->StatsCount; ++i)
                        {
                            int32 stat_diff = ((int32)floorf((float)pProto->ItemStat[i].ItemStatValue * 0.4f));
                            if (stat_diff > 1)
                                if (const char* stat_name = GetStatName(pProto->ItemStat[i].ItemStatType))
                                {
                                    std::ostringstream oss;
                                    oss << stat_name << " (" << pProto->ItemStat[i].ItemStatValue << " |cFFDB2222-" << stat_diff << "|r)";
                                    AddGossipItemFor(player, GOSSIP_ICON_TRAINER, oss.str(), guidlow, Melt(SELECT_STAT_INCREASE, i));
                                }
                        }
                        AddGossipItemFor(player, GOSSIP_ICON_TALK, "Back..", 0, Melt(MAIN_MENU, 0));
                        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, creature->GetGUID());
                    }
                    else
                    {
                        ChatHandler(player->GetSession()).SendNotification("Invalid item selected");
                        OnGossipHello(player, creature);
                    }
                }
                else
                {
                    ChatHandler(player->GetSession()).SendNotification("Invalid item selected");
                    OnGossipHello(player, creature);
                }
                break;
            case SELECT_STAT_INCREASE:
                // sender = item guidlow
                // action = StatsCount id
            {
                Item* invItem = GetEquippedItem(player, sender);
                if (invItem)
                {
                    const ItemTemplate* pProto = invItem->GetTemplate();
                    int32 stat_diff = ((int32)floorf((float)pProto->ItemStat[action].ItemStatValue * 0.4f));

                    AddGossipItemFor(player, GOSSIP_ICON_BATTLE, "Stat to increase:", sender, melt);
                    for (uint8 i = 0; i < stat_type_max; ++i)
                    {
                        if (pProto->ItemStat[action].ItemStatType == ITEM_MOD_ATTACK_POWER &&
                            (statTypes[i] == ITEM_MOD_AGILITY || statTypes[i] == ITEM_MOD_STRENGTH))
                        {
                            continue;
                        }

                        bool cont = false;
                        for (uint32 j = 0; j < pProto->StatsCount; ++j)
                        {
                            if (statTypes[i] == pProto->ItemStat[j].ItemStatType)
                            {
                                cont = true;
                                break;
                            }
                        }
                        if (cont) continue;

                        if (const char* stat_name = GetStatName(statTypes[i]))
                        {
                            std::ostringstream oss;
                            oss << stat_name << " |cFF3ECB3C+" << stat_diff << "|r";

                            // Determine the cost and currency based on player's level
                            std::string currencyName;
                            int costAmount = 0;
                            std::string costIcon;
                            if (player->getLevel() <= 69)
                            {
                                currencyName = "Reward Points";
                                costAmount = 50;
                                costIcon = "INV_REWARD_POINTS1";
                            }
                            else if (player->getLevel() <= 79)
                            {
                                currencyName = "Badges of Justice";
                                costAmount = 10;
                                costIcon = "spell_holy_championsbond";
                            }
                            else if (player->getLevel() == 80)
                            {
                                currencyName = "Emblems of Heroism";
                                costAmount = 10;
                                costIcon = "spell_holy_proclaimchampion";
                            }

                            // Append cost message to gossip option
                            oss << "\n\nCost: " << costAmount << " |TInterface\\Icons\\" << costIcon << ":20|t";

                            std::string colorCode;
                            switch (pProto->Quality)
                            {
                            case ITEM_QUALITY_POOR: colorCode = "|cff9d9d9d"; break; // Grey
                            case ITEM_QUALITY_NORMAL: colorCode = "|cffffffff"; break; // White
                            case ITEM_QUALITY_UNCOMMON: colorCode = "|cff1eff00"; break; // Green
                            case ITEM_QUALITY_RARE: colorCode = "|cff0070dd"; break; // Blue
                            case ITEM_QUALITY_EPIC: colorCode = "|cffa335ee"; break; // Purple
                            case ITEM_QUALITY_LEGENDARY: colorCode = "|cffff8000"; break; // Orange
                            case ITEM_QUALITY_ARTIFACT: colorCode = "|cffe6cc80"; break; // Artifact
                            case ITEM_QUALITY_HEIRLOOM: colorCode = "|cffe6cc80"; break; // Heirloom
                            default: colorCode = "|cffffffff"; // Default to white if no quality match
                            }
                            
                            std::string confirmationMessage = "Are you sure you want to reforge\n\n" + colorCode + "[" + pProto->Name1 + "]" + "|r for " + std::to_string(costAmount) + " " + currencyName + "?";

                            AddGossipItemFor(player, GOSSIP_ICON_INTERACT_1, oss.str(), sender, Melt(i, (uint8)pProto->ItemStat[action].ItemStatType), confirmationMessage, 0, false);
                        }
                    }
                    AddGossipItemFor(player, GOSSIP_ICON_TALK, "Back..", 0, Melt(SELECT_STAT_REDUCE, invItem->GetSlot()));
                    SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, creature->GetGUID());
                }
                else
                {
                    ChatHandler(player->GetSession()).SendNotification("Invalid item selected");
                    OnGossipHello(player, creature);
                }
            }
            break;
            case SELECT_RESTORE:
            {
                AddGossipItemFor(player, GOSSIP_ICON_BATTLE, "Select slot to remove reforge from:", sender, melt);
                if (!player->reforgeMap.empty())
                {
                    for (uint8 slot = EQUIPMENT_SLOT_START; slot < EQUIPMENT_SLOT_END; ++slot)
                    {
                        if (Item* invItem = player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
                        {
                            if (player->reforgeMap.find(invItem->GetGUID().GetCounter()) != player->reforgeMap.end())
                            {
                                if (const char* slotname = GetSlotName(slot, player->GetSession()))
                                {
                                    std::ostringstream gossipText;
                                    gossipText << slotname << ":"; // Add a colon after the slot name

                                    // Determine color code based on item quality
                                    std::string colorCode;
                                    switch (invItem->GetTemplate()->Quality)
                                    {
                                    case ITEM_QUALITY_POOR: colorCode = "|cff9d9d9d"; break; // Grey
                                    case ITEM_QUALITY_NORMAL: colorCode = "|cffffffff"; break; // White
                                    case ITEM_QUALITY_UNCOMMON: colorCode = "|cff1eff00"; break; // Green
                                    case ITEM_QUALITY_RARE: colorCode = "|cff0070dd"; break; // Blue
                                    case ITEM_QUALITY_EPIC: colorCode = "|cffa335ee"; break; // Purple
                                    case ITEM_QUALITY_LEGENDARY: colorCode = "|cffff8000"; break; // Orange
                                    case ITEM_QUALITY_ARTIFACT: colorCode = "|cffe6cc80"; break; // Artifact
                                    case ITEM_QUALITY_HEIRLOOM: colorCode = "|cffe6cc80"; break; // Heirloom
                                    default: colorCode = "|cffffffff"; // Default to white if no quality match
                                    }

                                    // Append item name with quality color on a new line
                                    gossipText << "\n" << colorCode << "[" << invItem->GetTemplate()->Name1 << "]|r";

                                    // Add the gossip item with the constructed text
                                    AddGossipItemFor(player, GOSSIP_ICON_INTERACT_1, gossipText.str(), invItem->GetGUID().GetCounter(), Melt(RESTORE, 0), "Remove reforge from\n\n" + gossipText.str(), 0, false);
                                }
                            }
                        }
                    }
                }
                AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Update menu", sender, melt);
                AddGossipItemFor(player, GOSSIP_ICON_TALK, "Back..", 0, Melt(MAIN_MENU, 0));
                SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, creature->GetGUID());
            }
            break;
            case RESTORE:
                // sender = item guidlow
                {
                    if (player->GetItemByGuid(ObjectGuid(HighGuid::Item, 0, sender)))
                    {
                        if (!player->reforgeMap.empty() && player->reforgeMap.find(sender) != player->reforgeMap.end())
                            RemoveReforge(player, sender, true);
                    }
                    OnGossipHello(player, creature);
                }
                break;
            default: // Reforge
                // sender = item guidlow
                // menu = stat type to increase index to statTypes[]
                // action = stat type to decrease
                {
                    if (menu < stat_type_max)
                    {
                        Item* invItem = GetEquippedItem(player, sender);
                        if (invItem && IsReforgable(invItem, player))
                        {
                            if (player->HasEnoughMoney(invItem->GetTemplate()->SellPrice < (10 * GOLD) ? (10 * GOLD) : invItem->GetTemplate()->SellPrice))
                            {
                                // int32 stat_diff = ((int32)floorf((float)invItem->GetTemplate()->ItemStat[action].ItemStatValue * 0.4f));
                                UpdatePlayerReforgeStats(invItem, player, action, statTypes[menu]); // rewrite this function
                            }
                            else
                            {
                                ChatHandler(player->GetSession()).SendNotification("Not enough currency.");
                            }
                        }
                        else
                        {
                            ChatHandler(player->GetSession()).SendNotification("Invalid item selected");
                        }
                    }
                    // OnGossipHello(player, creature);
                    new Timed(player, creature);
                }
        }
        return true;
    }

    enum Menus
    {
        MAIN_MENU = 200, // stat_type_max
        SELECT_ITEM,
        SELECT_STAT_REDUCE,
        SELECT_STAT_INCREASE,
        SELECT_RESTORE,
        RESTORE,
        REFORGE,
    };
};

void AddSC_REFORGER_NPC()
{
    new REFORGE_SERVER;
    new REFORGER_NPC;
    new REFORGE_PLAYER;
}
