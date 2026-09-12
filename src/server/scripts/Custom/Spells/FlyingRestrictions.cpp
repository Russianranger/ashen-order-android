#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"
#include "Chat.h"
#include "SpellAuraEffects.h"
#include <format>  // Include for std::format

class spell_mount_restriction : public SpellScriptLoader
{
public:
    spell_mount_restriction() : SpellScriptLoader("spell_mount_restriction") { }

    class spell_mount_restriction_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_mount_restriction_SpellScript);

        SpellCastResult CheckMountRestrictions()
        {
            Unit* caster = GetCaster();
            if (caster->GetTypeId() != TYPEID_PLAYER)
                return SPELL_CAST_OK;

            Player* player = caster->ToPlayer();
            uint32 mapId = player->GetMapId();
            uint32 requiredRidingSkill = 225;

            // Check for Outland (map 530) and player level
            if (mapId == 530 && player->getLevel() < 70)
            {
                ChatHandler(player->GetSession()).SendSysMessage("You must be at least level 70 to use this mount in Outland.");
                return SPELL_FAILED_LEVEL_REQUIREMENT;
            }

            // Check for Northrend (map 571) and Cold Weather Flying skill
            if (mapId == 571 && !player->HasSpell(54197)) // Cold Weather Flying spell ID
            {
                ChatHandler(player->GetSession()).SendSysMessage("You need Cold Weather Flying to use this mount in Northrend.");
                return SPELL_FAILED_NOT_HERE;
            }

            // Check for required riding skill for players level 70 or greater
            if (player->getLevel() >= 70 && player->GetSkillValue(SKILL_RIDING) < requiredRidingSkill)
            {
                ChatHandler(player->GetSession()).SendSysMessage("You need at least 225 riding skill to use this mount.");
                return SPELL_FAILED_LOW_CASTLEVEL;
            }

            return SPELL_CAST_OK;
        }

        void Register() override
        {
            OnCheckCast += SpellCheckCastFn(spell_mount_restriction_SpellScript::CheckMountRestrictions);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_mount_restriction_SpellScript();
    }
};

class spell_repair_item_PlayerScript : public PlayerScript
{
public:
    spell_repair_item_PlayerScript() : PlayerScript("spell_repair_item_PlayerScript") { }

    void OnSpellCast(Player* player, Spell* spell, bool /*skipCheck*/)
    {
        uint32 spellId = spell->GetSpellInfo()->Id;

        const uint32 REPAIR_SPELL_ID = 85978;

        if (spellId != REPAIR_SPELL_ID)
            return;

        Item* targetItem = spell->m_targets.GetItemTarget();
        if (!targetItem)
        {
            ChatHandler(player->GetSession()).SendSysMessage("No item was targeted.");
            return;
        }

        ItemTemplate const* itemTemplate = targetItem->GetTemplate();
        if (!itemTemplate)
        {
            ChatHandler(player->GetSession()).SendSysMessage("Invalid item template.");
            return;
        }

        // Check if the item is a weapon or plate armor
        bool canRepair = false;

        switch (itemTemplate->Class)
        {
        case ITEM_CLASS_WEAPON:
            // Accept any weapon
            canRepair = true;
            break;

        case ITEM_CLASS_ARMOR:
            if (itemTemplate->SubClass == ITEM_SUBCLASS_ARMOR_PLATE ||
                itemTemplate->SubClass == ITEM_SUBCLASS_ARMOR_SHIELD)
            {
                canRepair = true;
            }
            else
            {
                canRepair = false;
            }
            break;

        default:
            canRepair = false;
            break;
        }

        if (!canRepair)
        {
            ChatHandler(player->GetSession()).SendSysMessage("This spell can only repair plate armor or weapons.");
            return;
        }

        uint32 currentDurability = targetItem->GetUInt32Value(ITEM_FIELD_DURABILITY);
        uint32 maxDurability = targetItem->GetUInt32Value(ITEM_FIELD_MAXDURABILITY);

        if (maxDurability == 0)
        {
            ChatHandler(player->GetSession()).SendSysMessage("This item cannot be repaired.");
            return;
        }

        // Check if item is already at maximum durability
        if (currentDurability == maxDurability)
        {
            ChatHandler(player->GetSession()).SendSysMessage("This item is already at maximum durability.");
            return;
        }

        // Repair the item
        targetItem->SetUInt32Value(ITEM_FIELD_DURABILITY, maxDurability);
        targetItem->SetState(ITEM_CHANGED, player);

        std::string itemName = itemTemplate->Name1;
        std::string message = fmt::format("Your {} has been repaired.", itemName);
        ChatHandler(player->GetSession()).SendSysMessage(message.c_str());

        // spell->SetCastResult(SPELL_FAILED_DONT_REPORT);
    }
};

void AddSC_custom_flying_spell_scripts()
{
    new spell_mount_restriction();
    new spell_repair_item_PlayerScript();
}
