#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"

class spell_sha_elemental_mastery : public SpellScript
{
    PrepareSpellScript(spell_sha_elemental_mastery);

    void HandleOnCast()
    {
        if (Unit* caster = GetCaster())
        {
            // Shaman T2 5pc
            if (caster->HasAura(872321))
            {
                caster->CastSpell(caster, 855447, true);
            }
        }
    }

    void Register() override
    {
        OnCast += SpellCastFn(spell_sha_elemental_mastery::HandleOnCast);
    }
};

void AddSC_spell_sha_elemental_mastery()
{
    RegisterSpellScript(spell_sha_elemental_mastery);
}
