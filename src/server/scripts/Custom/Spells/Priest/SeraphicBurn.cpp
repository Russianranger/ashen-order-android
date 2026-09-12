#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_seraphic_burn : public SpellScript
{
    PrepareSpellScript(spell_seraphic_burn);

    SpellCastResult CheckCast()
    {
        Unit* caster = GetCaster();
        if (caster && caster->HasAura(855692))
        {
            return SPELL_FAILED_DONT_REPORT;

        }
        return SPELL_CAST_OK;
    }

    void FilterTargets(std::list<WorldObject*>& targets)
    {
        //LOG_ERROR("spells", "Filtering targets");
        targets.remove_if([this](WorldObject* obj) -> bool
            {
                if (Unit* target = obj->ToUnit())
                {
                    //LOG_ERROR("spells", "Checking target: %s, Flags: %u", target->GetName().c_str(), target->GetUnitFlags());

                    if (target->HasUnitFlag(UNIT_FLAG_DISABLE_MOVE) ||
                        target->HasUnitFlag(UNIT_FLAG_PACIFIED) ||
                        target->HasUnitFlag(UNIT_FLAG_IMMUNE_TO_PC) ||
                        target->HasUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC) ||
                        target->HasUnitFlag(UNIT_FLAG_NON_ATTACKABLE) ||
                        target->HasUnitFlag(UNIT_FLAG_NOT_ATTACKABLE_1) ||
                        target->HasUnitFlag(UNIT_FLAG_NOT_SELECTABLE))
                    {
                        //LOG_ERROR("spells", "Filtering out target: %s due to flags", target->GetName().c_str());
                        return true;
                    }

                    if (target->ToCreature() && target->ToCreature()->GetCreatureTemplate()->rank == CREATURE_ELITE_WORLDBOSS)
                    {
                       // LOG_ERROR("spells", "Filtering out target: %s due to rank", target->GetName().c_str());
                        return true;
                    }
                }
                return false;
            });
    }

    void HandlePullTowards(SpellEffIndex effIndex)
    {
        Unit* target = GetHitUnit();
        if (!target)
            return;

        // Debugging output
       // LOG_ERROR("spells", "Handling pull towards target: %s, Flags: %u", target->GetName().c_str(), target->GetUnitFlags());

        if (target->HasUnitFlag(UNIT_FLAG_DISABLE_MOVE) ||
            target->HasUnitFlag(UNIT_FLAG_PACIFIED) ||
            target->HasUnitFlag(UNIT_FLAG_IMMUNE_TO_PC) ||
            target->HasUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC) ||
            target->HasUnitFlag(UNIT_FLAG_NON_ATTACKABLE) ||
            target->HasUnitFlag(UNIT_FLAG_NOT_ATTACKABLE_1) ||
            target->HasUnitFlag(UNIT_FLAG_NOT_SELECTABLE))
        {
            //LOG_ERROR("spells", "Preventing pull of target: %s due to flags", target->GetName().c_str());
            PreventHitDefaultEffect(effIndex);
            return;
        }

        if (target->ToCreature() && target->ToCreature()->GetCreatureTemplate()->rank == CREATURE_ELITE_WORLDBOSS)
        {
           // LOG_ERROR("spells", "Preventing pull of target: %s due to rank", target->GetName().c_str());
            PreventHitDefaultEffect(effIndex);
            return;
        }
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_seraphic_burn::CheckCast);
        OnEffectHitTarget += SpellEffectFn(spell_seraphic_burn::HandlePullTowards, EFFECT_1, SPELL_EFFECT_PULL_TOWARDS);
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_seraphic_burn::FilterTargets, EFFECT_1, TARGET_UNIT_DEST_AREA_ALLY);
    }
};

void AddSC_seraphic_burn()
{
    RegisterSpellScript(spell_seraphic_burn);
}
