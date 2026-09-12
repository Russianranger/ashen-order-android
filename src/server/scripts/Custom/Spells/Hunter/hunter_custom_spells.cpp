#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_hun_serpents_sting_instant_damage : public AuraScript
{
    PrepareAuraScript(spell_hun_serpents_sting_instant_damage);

    void HandleEffect(AuraEffect const* aurEff, AuraEffectHandleModes mode)
    {
        Unit* target = GetTarget();
        Unit* caster = GetCaster();

        if (!target || !caster)
            return;

        if (!caster->HasAura(844054))
            return;

        SpellInfo const* spellInfo = aurEff->GetSpellInfo();

        int32 tickAmount = aurEff->GetAmount(); 
        uint32 maxTicks = spellInfo->GetMaxTicks(); 

        int32 totalDotDamage = tickAmount * maxTicks;

        int32 totalDamage = caster->SpellDamageBonusDone(target, spellInfo, totalDotDamage, SPELL_DIRECT_DAMAGE, EFFECT_0);
        totalDamage = target->SpellDamageBonusTaken(caster, spellInfo, totalDamage, SPELL_DIRECT_DAMAGE);

        int32 instantDamage = totalDamage / 2;

        caster->CastCustomSpell(target, 857783, &instantDamage, nullptr, nullptr, true);
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_hun_serpents_sting_instant_damage::HandleEffect, EFFECT_0, SPELL_AURA_PERIODIC_DAMAGE, AURA_EFFECT_HANDLE_REAL_OR_REAPPLY_MASK);
    }
};

void AddSC_custom_hunter_spell_scripts()
{
    RegisterSpellScript(spell_hun_serpents_sting_instant_damage);
}
