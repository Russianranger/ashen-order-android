#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"

class spell_orb_of_restriction : public SpellScriptLoader
{
public:
    spell_orb_of_restriction() : SpellScriptLoader("spell_orb_of_restriction") { }

    class spell_orb_of_restriction_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_orb_of_restriction_SpellScript);

        SpellCastResult CheckLevel()
        {
            if (Unit* caster = GetCaster())
            {
                if (Player* player = caster->ToPlayer())
                {
                    if (player->getLevel() > 60)
                    {
                        ChatHandler(player->GetSession()).SendNotification("You cannot use this item at your level.");
                        return SPELL_FAILED_CUSTOM_ERROR;
                    }
                }
            }
            return SPELL_CAST_OK;
        }

        void Register() override
        {
            OnCheckCast += SpellCheckCastFn(spell_orb_of_restriction_SpellScript::CheckLevel);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_orb_of_restriction_SpellScript();
    }
};

class spell_talisman_of_binding : public SpellScriptLoader
{
public:
    spell_talisman_of_binding() : SpellScriptLoader("spell_talisman_of_binding") { }

    class spell_talisman_of_binding_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_talisman_of_binding_AuraScript);

        // This function calculates the aura’s base amount.
        void CalculateAmount(AuraEffect const* /*aurEff*/, int32& amount, bool& canBeRecalculated)
        {
            if (Unit* caster = GetCaster())
            {
                // Get the caster’s maximum health.
                int32 health = caster->GetMaxHealth();
                amount = int32(health * 0.0066f);

                // Ensure the amount is at least 5.
                if (amount < 5)
                    amount = 5;

                canBeRecalculated = false;
            }
        }

        void Register() override
        {
            DoEffectCalcAmount += AuraEffectCalcAmountFn(spell_talisman_of_binding_AuraScript::CalculateAmount, EFFECT_0, SPELL_AURA_DAMAGE_SHIELD);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_talisman_of_binding_AuraScript();
    }
};

class item_restricted_below_60 : public ItemScript
{
public:
    item_restricted_below_60() : ItemScript("item_restricted_below_60") { }

    bool OnUse(Player* player, Item* /*item*/, SpellCastTargets const& /*targets*/) override
    {
        if (player->GetLevel() > 60)
        {
            ChatHandler(player->GetSession()).SendNotification("|cffff0000You cannot use this item above level 60!|r");
            player->CastSpell(player, 823436, true);
            return true;
        }
        return false;
    }
};

class spell_remove_aura_if_high_level : public AuraScript
{
    PrepareAuraScript(spell_remove_aura_if_high_level);

    void HandleOnApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        // Get the unit that cast the aura.
        Unit* caster = GetCaster();
        if (!caster)
            return;

        // Check if the caster is a player and is level 61 or higher.
        if (caster->GetLevel() >= 61)
        {
            // Remove the aura from the target immediately.
            GetTarget()->RemoveAura(GetSpellInfo()->Id);
        }
    }

    void Register() override
    {
        // Register our OnApply hook on effect index 0 for SPELL_AURA_MOD_PERCENT_STAT (ID 80).
        OnEffectApply += AuraEffectApplyFn(spell_remove_aura_if_high_level::HandleOnApply, EFFECT_0, SPELL_AURA_MOD_PERCENT_STAT, AURA_EFFECT_HANDLE_REAL);
    }
};

class spell_dummy_level_check : public SpellScriptLoader
{
public:
    spell_dummy_level_check() : SpellScriptLoader("spell_dummy_level_check") { }

    class spell_dummy_level_check_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_dummy_level_check_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                if (caster->GetLevel() >= 61)
                {
                    caster->CastSpell(caster, 815007, true);
                }
            }
        }

        void Register() override
        {
            // Register our handler for effect index 0 when the dummy spell is processed.
            OnEffectHitTarget += SpellEffectFn(spell_dummy_level_check_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_dummy_level_check_SpellScript();
    }
};

void AddSC_spell_legendary_spells()
{
    new spell_orb_of_restriction();
    new spell_talisman_of_binding();
    new item_restricted_below_60();
    new spell_remove_aura_if_high_level();
    new spell_dummy_level_check();
}
