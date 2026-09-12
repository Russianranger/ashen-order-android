#include "StatBoosterReroller.h"

bool StatBoosterRerollPlayerScript::CanCastItemUseSpell(Player* player, Item* item, SpellCastTargets const& targets, uint8 /*cast_count*/, uint32 /*glyphIndex*/)
{
    if (!item)
    {
        return true;
    }

    auto itemTemplate = item->GetTemplate();
    if (!itemTemplate)
    {
        return true;
    }

    const uint32 FirstRerollerItemId = 41605; // level 1-60
    const uint32 SecondRerollerItemId = 841605; // level 61-80

    // Check if the item is one of the reroller items and if the player level is appropriate
    if (itemTemplate->ItemId == FirstRerollerItemId && (player->GetLevel() < 1 || player->GetLevel() > 60))
    {
        ChatHandler(player->GetSession()).SendSysMessage("This Reroller can only be used by players between levels 1-60.");
        return false;
    }

    if (itemTemplate->ItemId == SecondRerollerItemId && (player->GetLevel() < 61 || player->GetLevel() > 80))
    {
        ChatHandler(player->GetSession()).SendSysMessage("This Reroller can only be used by players between levels 61-80.");
        return false;
    }

    if (itemTemplate->ItemId != FirstRerollerItemId && itemTemplate->ItemId != SecondRerollerItemId)
    {
        return true;
    }

    if (!sConfigMgr->GetOption<bool>("StatBoostReroll.Enable", false))
    {
        ChatHandler(player->GetSession()).SendSysMessage("This item is disabled.");
        return false;
    }

    auto targetItem = targets.GetItemTarget();
    if (!targetItem)
    {
        return false;
    }

    if (sConfigMgr->GetOption<bool>("StatBoostReroll.AllowOwnedItemsOnly", true) &&
        targetItem->GetOwner()->GetGUID() != player->GetGUID())
    {
        ChatHandler(player->GetSession()).SendSysMessage("You cannot re-roll items other than your own.");
        return false;
    }

    if (StatBoostMgr::BoostItem(player, targetItem, 100))
    {
        player->DestroyItemCount(itemTemplate->ItemId, 1, true);

        uint32 visualId = sConfigMgr->GetOption<uint32>("StatBoostReroll.VisualId", 62015);
        player->CastSpell(player, visualId);
        //player->HandleEmoteCommand(EMOTE_ONESHOT_LOOT);
    }
    else
    {
        ChatHandler(player->GetSession()).SendSysMessage("You cannot re-roll this item.");
    }

    return false;
}

void AddStatBoostRerollScripts()
{
    new StatBoosterRerollPlayerScript();
}
