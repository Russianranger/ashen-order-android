#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"

class spell_mage_fire_blast : public SpellScript
{
    PrepareSpellScript(spell_mage_fire_blast);

    void HandleOnCast()
    {
        if (Player* player = GetCaster()->ToPlayer())
        {
            if (player->HasAura(844055))
            {
                if (!player->HasSpellCooldown(300135))
                {
                    player->CastSpell(player, 300135, false);
                }
            }
        }
    }

    void Register() override
    {
        OnCast += SpellCastFn(spell_mage_fire_blast::HandleOnCast);
    }
};

class spell_mage_fire_blast_charge : public SpellScript
{
    PrepareSpellScript(spell_mage_fire_blast_charge);

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        if (Player* caster = GetCaster()->ToPlayer())
        {
            std::vector<uint32> FireBlastSpellIds = { 2136, 2137, 2138, 8412, 8414, 10197, 10199, 27078, 27079, 42872, 42873 };

            for (uint32 spellId : FireBlastSpellIds)
            {
                if (caster->HasSpellCooldown(spellId))
                {
                    caster->RemoveSpellCooldown(spellId, true);
                }
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_mage_fire_blast_charge::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

void AddSC_spell_mage_fire_blast_charges()
{
    RegisterSpellScript(spell_mage_fire_blast);
    RegisterSpellScript(spell_mage_fire_blast_charge);
}
