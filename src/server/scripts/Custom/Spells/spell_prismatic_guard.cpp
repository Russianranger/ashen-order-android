#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_prismatic_guard : public SpellScriptLoader
{
public:
    spell_prismatic_guard() : SpellScriptLoader("spell_prismatic_guard") { }

    class spell_prismatic_guard_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_prismatic_guard_SpellScript);

        SpellCastResult CheckCast()
        {
            Unit* caster = GetCaster();
            if (caster->HasAura(858823))
            {
                return SPELL_FAILED_CASTER_AURASTATE;
            }
            return SPELL_CAST_OK;
        }

        void Register() override
        {
            OnCheckCast += SpellCheckCastFn(spell_prismatic_guard_SpellScript::CheckCast);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_prismatic_guard_SpellScript();
    }
};

class spell_custom_martyr : public SpellScriptLoader
{
public:
    spell_custom_martyr() : SpellScriptLoader("spell_custom_martyr") { }

    class spell_custom_martyr_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_custom_martyr_SpellScript);

        SpellCastResult CheckCast()
        {
            Unit* caster = GetCaster();
            if (caster->HasAura(858824))
            {
                return SPELL_FAILED_CASTER_AURASTATE;
            }
            return SPELL_CAST_OK;
        }

        void Register() override
        {
            OnCheckCast += SpellCheckCastFn(spell_custom_martyr_SpellScript::CheckCast);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_custom_martyr_SpellScript();
    }
};


void AddSC_spell_prismatic_guard()
{
    new spell_prismatic_guard();
    new spell_custom_martyr();
}
