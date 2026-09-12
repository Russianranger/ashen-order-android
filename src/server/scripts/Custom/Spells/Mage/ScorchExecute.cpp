#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_mage_scorch_execute : public SpellScript
{
    PrepareSpellScript(spell_mage_scorch_execute);

    void HandleOnHit()
    {
        if (Unit* target = GetHitUnit())
        {
            if (target->GetHealthPct() < 35.0f)
            {
                int32 damage = GetHitDamage();
                SetHitDamage(int32(damage * 3.75f));

                if (Unit* caster = GetCaster())
                {
                    if (caster->HasAura(880044))
                    {
                        caster->AddAura(811095, caster);
                    }
                }
            }
        }
    }

    void Register() override
    {
        OnHit += SpellHitFn(spell_mage_scorch_execute::HandleOnHit);
    }
};

void AddSC_spell_mage_scorch_execute()
{
    RegisterSpellScript(spell_mage_scorch_execute);
}
