#include "ScriptMgr.h"
#include "Player.h"
#include "ObjectMgr.h"
#include "DatabaseEnv.h"
#include "Chat.h"
#include "GossipDef.h"
#include "Item.h"
#include "WorldSession.h"

class npc_account_item_bank : public CreatureScript
{
public:
    npc_account_item_bank() : CreatureScript("npc_account_item_bank") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        ClearGossipMenuFor(player);
        AddGossipItemFor(player, GOSSIP_ICON_MONEY_BAG, "Deposit Item", 1, 0);
        AddGossipItemFor(player, GOSSIP_ICON_MONEY_BAG, "Withdraw Item", 2, 0);
        SendGossipMenuFor(player, 1, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();

        switch (action)
        {
        case 1:
            ListDepositItems(player, creature);  // Show eligible items to deposit
            break;
        case 2:
            ListWithdrawItems(player, creature, 0);  // Show available items for withdrawal (page 0)
            break;
        }
        return true;
    }

    void ListDepositItems(Player* player, Creature* creature)
    {
        bool found = false;

        // Iterate through the player's inventory to find eligible items
        for (uint8 i = INVENTORY_SLOT_ITEM_START; i < INVENTORY_SLOT_ITEM_END; ++i)
        {
            if (Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, i))
            {
                const ItemTemplate* temp = item->GetTemplate();
                if (IsEligibleForDeposit(temp))
                {
                    // Display item in the gossip menu
                    AddGossipItemFor(player, GOSSIP_ICON_MONEY_BAG, temp->Name1, 1000 + i, 0);
                    found = true;
                }
            }
        }

        if (!found)
        {
            ChatHandler(player->GetSession()).PSendSysMessage("No eligible items to deposit.");
        }

        SendGossipMenuFor(player, 1, creature->GetGUID());
    }

    bool OnGossipSelectCode(Player* player, Creature* creature, uint32 sender, uint32 action, const char* /*code*/) override
    {
        if (action >= 1000 && action < 1100)
        {
            uint8 slot = action - 1000;
            DepositItem(player, creature, slot);
        }
        return true;
    }

    bool IsEligibleForDeposit(const ItemTemplate* temp)
    {
        // Check if the item is Bind on Pickup and is either armor or weapon
        return temp->Bonding == BIND_WHEN_PICKED_UP &&
            (temp->Class == ITEM_CLASS_ARMOR || temp->Class == ITEM_CLASS_WEAPON);
    }

    void DepositItem(Player* player, Creature* creature, uint8 slot)
    {
        if (Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
        {
            const ItemTemplate* temp = item->GetTemplate();
            uint32 accountId = player->GetSession()->GetAccountId();

            CharacterDatabase.Execute(
                "INSERT INTO account_item_deposit (account_id, item_entry, item_name, itemlevel, requiredlevel) "
                "VALUES ({}, {}, '{}', {}, {})",
                accountId, temp->ItemId, temp->Name1, temp->ItemLevel, temp->RequiredLevel);

            player->DestroyItem(INVENTORY_SLOT_BAG_0, slot, true);
            ChatHandler(player->GetSession()).PSendSysMessage("Item deposited successfully.");
        }
        CloseGossipMenuFor(player);
    }

    void ListWithdrawItems(Player* player, Creature* creature, uint32 page)
    {
        uint32 accountId = player->GetSession()->GetAccountId();
        std::string query = "SELECT item_entry, item_name, itemlevel FROM account_item_deposit WHERE account_id = " + std::to_string(accountId);
        QueryResult result = CharacterDatabase.Query(query);

        if (!result)
        {
            ChatHandler(player->GetSession()).PSendSysMessage("No items available for withdrawal.");
            CloseGossipMenuFor(player);
            return;
        }

        uint32 index = 0;
        do
        {
            if (index >= page * 30 && index < (page + 1) * 30)
            {
                uint32 itemEntry = (*result)[0].Get<uint32>();
                std::string itemName = (*result)[1].Get<std::string>();
                uint32 itemLevel = (*result)[2].Get<uint32>();

                AddGossipItemFor(player, GOSSIP_ICON_MONEY_BAG, itemName + " (Level " + std::to_string(itemLevel) + ")", 2000 + itemEntry, 0);
            }
            ++index;
        } while (result->NextRow());

        // Pagination handling
        if (index > (page + 1) * 30)
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Next Page", 3000 + page + 1, 0);

        if (page > 0)
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Previous Page", 3000 + page - 1, 0);

        SendGossipMenuFor(player, 1, creature->GetGUID());
    }

    void WithdrawItem(Player* player, Creature* creature, uint32 itemEntry)
    {
        QueryResult result = CharacterDatabase.Query(
            "SELECT item_name FROM account_item_deposit WHERE account_id = {} AND item_entry = {}",
            player->GetSession()->GetAccountId(), itemEntry);

        if (result)
        {
            const ItemTemplate* temp = sObjectMgr->GetItemTemplate(itemEntry);
            if (!temp) return;

            ItemPosCountVec dest;
            InventoryResult msg = player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, itemEntry, 1);
            if (msg == EQUIP_ERR_OK)
            {
                Item* item = player->StoreNewItem(dest, itemEntry, true);
                player->SendNewItem(item, 1, true, false);

                CharacterDatabase.Execute(
                    "DELETE FROM account_item_deposit WHERE account_id = {} AND item_entry = {} LIMIT 1",
                    player->GetSession()->GetAccountId(), itemEntry);

                ChatHandler(player->GetSession()).PSendSysMessage("Item withdrawn successfully.");
            }
            else
            {
                player->SendEquipError(msg, nullptr, nullptr, itemEntry);
            }
        }
        CloseGossipMenuFor(player);
    }
};

void AddSC_npc_account_item_bank()
{
//    new npc_account_item_bank();
}
