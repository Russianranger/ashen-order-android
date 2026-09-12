#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"

class spell_arcane_surge : public SpellScript
{
    PrepareSpellScript(spell_arcane_surge);

    void HandleDamage(SpellEffIndex /*effIndex*/)
    {
        if (Unit* caster = GetCaster())
        {
            if (caster->GetTypeId() != TYPEID_PLAYER)
                return;

            Player* player = caster->ToPlayer();
            float manaPercent = float(player->GetPower(POWER_MANA)) / player->GetMaxPower(POWER_MANA);
            float damageMultiplier = manaPercent * 4.0f; // Calculate the multiplier based on current mana percentage

            // Get the Arcane Spell Power
            int32 spellPower = player->GetInt32Value(PLAYER_FIELD_MOD_DAMAGE_DONE_POS + SPELL_SCHOOL_ARCANE);

            // Calculate the total damage
            int32 baseDamage = GetHitDamage();
            int32 totalDamage = baseDamage + (spellPower * damageMultiplier);

            // Check if Arcane Power is active
            if (player->HasAura(12042))
            {
                // Increase damage by 20% if the aura is active
                totalDamage = int32(totalDamage * 1.20f);
            }

            SetHitDamage(totalDamage);

            // Drain all mana
            player->SetPower(POWER_MANA, 0);
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_arcane_surge::HandleDamage, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
    }
};

void AddSC_spell_arcane_surge()
{
    RegisterSpellScript(spell_arcane_surge);
}
