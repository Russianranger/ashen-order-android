#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"

class spell_mage_blink : public SpellScript
{
    PrepareSpellScript(spell_mage_blink);

    void HandleOnCast()
    {
        if (Player* player = GetCaster()->ToPlayer())
        {
            if (!player->HasSpellCooldown(300133))
            {
                player->CastSpell(player, 300133, false);
            }
        }
    }

    void Register() override
    {
        OnCast += SpellCastFn(spell_mage_blink::HandleOnCast);
    }
};



class spell_mage_blink_charge : public SpellScript
{
    PrepareSpellScript(spell_mage_blink_charge);

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        if (Player* caster = GetCaster()->ToPlayer())
        {
            const uint32 BlinkSpellId = 1953;

            if (caster->HasSpellCooldown(BlinkSpellId))
            {
                caster->RemoveSpellCooldown(BlinkSpellId, true);
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_mage_blink_charge::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

void AddSC_spell_mage_blink()
{
    RegisterSpellScript(spell_mage_blink);
    RegisterSpellScript(spell_mage_blink_charge);
}
