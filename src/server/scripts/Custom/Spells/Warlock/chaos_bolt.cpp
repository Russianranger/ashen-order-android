#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"


class spell_lock_chaos_bolt : public SpellScript
{
    PrepareSpellScript(spell_lock_chaos_bolt);

    void RecalculateDamage(SpellEffIndex /*effIndex*/)
    {
        if (Unit* target = GetHitUnit())
        {
            if (target->GetHealthPct() <= 35.0f)
            {
                SetHitDamage(GetHitDamage() * 1.75);
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_lock_chaos_bolt::RecalculateDamage, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
    }
};

class aura_improved_corruption_and_immolate : public AuraScript
{
    PrepareAuraScript(aura_improved_corruption_and_immolate);

    void OnProc(AuraEffect const* aurEff, ProcEventInfo& eventInfo)
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        DamageInfo* damageInfo = eventInfo.GetDamageInfo();
        if (!damageInfo)
            return;

        SpellInfo const* procSpell = eventInfo.GetDamageInfo()->GetSpellInfo();
        if (!procSpell)
            return;

        // Cast on the caster, depending on the spell school (only one aura at a time)
        if (procSpell->SchoolMask & SPELL_SCHOOL_MASK_SHADOW)
        {
            caster->RemoveAura(837402);
            caster->CastSpell(caster, 837401, true); // Trigger Corruption on caster
        }
        else
        {
            caster->RemoveAura(837401);
            caster->CastSpell(caster, 837402, true); // Trigger Immolate on caster
        }
    }

    void Register() override
    {
        OnEffectProc += AuraEffectProcFn(aura_improved_corruption_and_immolate::OnProc, EFFECT_0, SPELL_AURA_DUMMY);
    }
};

void AddSC_spell_custom_chaos_bolt()
{
    RegisterSpellScript(spell_lock_chaos_bolt);
    RegisterSpellScript(aura_improved_corruption_and_immolate);
}
