#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "Creature.h"

class spell_custom_dungeon_corpse_explosion : public SpellScriptLoader
{
public:
    spell_custom_dungeon_corpse_explosion() : SpellScriptLoader("spell_custom_dungeon_corpse_explosion") { }

    class spell_custom_dungeon_corpse_explosion_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_custom_dungeon_corpse_explosion_SpellScript);

        void HandleDamageCalc(SpellEffIndex /*effIndex*/)
        {
            if (Unit* target = GetHitUnit())
            {
                // Check if the target has flags to skip damage
                if (Creature* creature = target->ToCreature())
                {
                    if (creature->GetCreatureTemplate()->flags_extra & (CREATURE_FLAG_EXTRA_TRIGGER | CREATURE_FLAG_EXTRA_IGNORE_COMBAT))
                    {
                        SetHitDamage(0);
                        return;
                    }
                }

                // Determine damage based on caster's rank or specific entry
                if (Unit* caster = GetCaster())
                {
                    int32 damage = 0;
                    if (Creature* casterCreature = caster->ToCreature())
                    {
                        switch (casterCreature->GetEntry())
                        {
                        case 12099: // Firesworn
                        case 13996: // Blackwing Tech
                        case 14880: // Skittering Razzashi
                        case 351073: // Naxx
                            damage = CalculatePct(target->GetMaxHealth(), 10);
                            break;
                        case 351016: // Naxx
                        case 351017: // Naxx
                            damage = CalculatePct(target->GetMaxHealth(), 15);
                            break;
                        case 11262: // Onyxian Whelp
                        case 12468: // BWL whelps
                        case 14022: // BWL whelps
                        case 14025: // BWL whelps
                        case 14024: // BWL whelps
                        case 15300: // Vekniss Drone
                        case 11439: // Jandice Illusion
                            damage = CalculatePct(target->GetMaxHealth(), 5.76);
                            break;
                        case 11583: // Risen Bone Constructs
                        case 15718: // Ouro Scarab
                        case 351088: // Maex spiderling
                        case 14264: // Drakonid
                        case 15622: // Veknis Borer
                        case 83021:
                        case 815725:
                            damage = CalculatePct(target->GetMaxHealth(), 3);
                            break;
                        case 14261: // Drakonid
                        case 14262: // Drakonid
                        case 14263: // Drakonid
                        case 14265: // Drakonid
                        case 35103: // Skitterer
                            damage = CalculatePct(target->GetMaxHealth(), 5);
                            break;
                        case 351004: // Gluth since zombies are enemies.
                            damage = CalculatePct(target->GetMaxHealth(), 0);
                            break;
                        default:
                            if (casterCreature->GetCreatureTemplate()->rank == CREATURE_ELITE_NORMAL)
                            {
                                damage = CalculatePct(target->GetMaxHealth(), 8.5);
                            }
                            else
                            {
                                damage = CalculatePct(target->GetMaxHealth(), 22.5);
                            }
                            break;
                        }
                    }
                    else
                    {
                        damage = CalculatePct(target->GetMaxHealth(), 23.5);
                    }
                    SetHitDamage(damage);
                }
            }
        }

        void Register() override
        {
            OnEffectHitTarget += SpellEffectFn(spell_custom_dungeon_corpse_explosion_SpellScript::HandleDamageCalc, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_custom_dungeon_corpse_explosion_SpellScript();
    }
};


void AddSC_script_spell_custom_dungeon_corpse_explosion()
{
    new spell_custom_dungeon_corpse_explosion();
}
