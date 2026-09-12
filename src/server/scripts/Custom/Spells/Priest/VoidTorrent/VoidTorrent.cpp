#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_void_torrent_damage : public SpellScript
{
    PrepareSpellScript(spell_void_torrent_damage);

    void HandleDamage(SpellEffIndex /*effIndex*/)
    {
        if (Unit* caster = GetCaster())
        {
            int32 intellect = caster->GetStat(STAT_INTELLECT);
            int32 damage = CalculatePct(intellect, 29);

            SetHitDamage(damage);
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_void_torrent_damage::HandleDamage, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
    }
};

void AddSC_spell_void_torrent_damage()
{
    RegisterSpellScript(spell_void_torrent_damage);
}
