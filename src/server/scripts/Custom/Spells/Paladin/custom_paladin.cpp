#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"

class spell_divine_steed_charges : public SpellScript
{
    PrepareSpellScript(spell_divine_steed_charges);

    void HandleOnCast()
    {
        if (Player* player = GetCaster()->ToPlayer())
        {
            // If the hidden spell is NOT on cooldown, cast it to represent the first charge being used
            if (!player->HasSpellCooldown(300130))
            {
                player->CastSpell(player, 300130, false);
            }
            // else
            // {
                 // If the hidden spell IS on cooldown, apply the cooldown to Divine Steed, representing the second charge being used
                 //player->AddSpellCooldown(GetSpellInfo()->Id, 0, 35 * IN_MILLISECONDS); // Apply 35-second cooldown to Divine Steed
                 //player->CastSpell(player, 300131, true); // Cast Divine Exhaustion for visual indicator. Optional.

            // }
        }
    }

    void Register() override
    {
        OnCast += SpellCastFn(spell_divine_steed_charges::HandleOnCast);
    }
};


// This second script is optional but nice if you want the main spell to have a cooldown visual.
// Just make sure to create a cooldown of the main spell in spell.dbc.
// This gets applied to the hidden spell in spell_script_names
// You can also remove the player->AddSpellCooldown(GetSpellInfo()->Id, 0, 35 * IN_MILLISECONDS); line above if you use below.
// Make sure that Spelleffect_0 is still Dummy for the hidden spell
class spell_pa_reset_divine_steed : public SpellScript
{
    PrepareSpellScript(spell_pa_reset_divine_steed);

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        if (Player* caster = GetCaster()->ToPlayer())
        {
            const uint32 DivineSteedSpellId = 100130;

            if (caster->HasSpellCooldown(DivineSteedSpellId))
            {
                caster->RemoveSpellCooldown(DivineSteedSpellId, true);
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_pa_reset_divine_steed::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

// Avenger's Shield - Custom Script
class spell_pal_avengers_shield : public SpellScript
{
    PrepareSpellScript(spell_pal_avengers_shield);

    void HandleOnHit()
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        Unit* target = GetHitUnit();
        if (!target)
            return;

        int32 damage = GetHitDamage();

        // Tier 3
        if (caster->HasAura(818007))
        {
            int32 customSpellDamage = CalculatePct(damage, 15); // 75% of the Avenger's Shield damage (over 10 seconds every 2 seconds in this case)
            caster->CastCustomSpell(target, 865930, &customSpellDamage, nullptr, nullptr, true);
        }
    }

    void Register() override
    {
        OnHit += SpellHitFn(spell_pal_avengers_shield::HandleOnHit);
    }
};

// Shield of Righteousness - Custom Script
class spell_pal_shield_of_righteousness : public SpellScript
{
    PrepareSpellScript(spell_pal_shield_of_righteousness);

    void HandleAfterCast()
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        // 20% chance to reset the cooldown of Avenger's Shield
        if (roll_chance_i(20))
        {
            caster->CastSpell(caster, 800132, true);
        }

        // Tier 3
        if (caster->HasAura(863222))
        {
            int32 absorbAmount = CalculatePct(caster->GetMaxHealth(), 15); // 15% of the caster's total health
            caster->CastCustomSpell(caster, 89800, &absorbAmount, nullptr, nullptr, true);
        }
    }

    void Register() override
    {
        AfterCast += SpellCastFn(spell_pal_shield_of_righteousness::HandleAfterCast);
    }
};

class spell_pal_reset_avengers_shield : public SpellScript
{
    PrepareSpellScript(spell_pal_reset_avengers_shield);

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        if (Player* caster = GetCaster()->ToPlayer())
        {
            const uint32 AvengersShieldSpellIds[] = { 31935, 32699, 32700, 48826, 48827 };

            for (uint32 spellId : AvengersShieldSpellIds)
            {
                caster->RemoveSpellCooldown(spellId, true);
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_pal_reset_avengers_shield::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

// Divine Protection - Custom Script
class spell_pal_divine_protection : public AuraScript
{
    PrepareAuraScript(spell_pal_divine_protection);

    void HandleAfterEffectRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        // Tier 3
        if (!caster->HasAura(863223))
            return;

        // Calculate the total heal amount (50% of max health) and divide by the number of ticks (6)
        int32 totalHealAmount = CalculatePct(caster->GetMaxHealth(), 50);
        int32 tickHealAmount = totalHealAmount / 6; // Divide by 6 ticks

        // Cast the custom heal-over-time spell (ID: 89801) with the divided tick amount
        caster->CastCustomSpell(caster, 89801, &tickHealAmount, nullptr, nullptr, true);
    }

    void Register() override
    {
        AfterEffectRemove += AuraEffectRemoveFn(spell_pal_divine_protection::HandleAfterEffectRemove, EFFECT_1, SPELL_AURA_MOD_DAMAGE_PERCENT_TAKEN, AURA_EFFECT_HANDLE_REAL);
    }
};

void AddSC_spell_custom_paladin()
{
    RegisterSpellScript(spell_divine_steed_charges);
    RegisterSpellScript(spell_pa_reset_divine_steed);
    RegisterSpellScript(spell_pal_avengers_shield);
    RegisterSpellScript(spell_pal_shield_of_righteousness);
    RegisterSpellScript(spell_pal_reset_avengers_shield);
    RegisterSpellScript(spell_pal_divine_protection);
}
