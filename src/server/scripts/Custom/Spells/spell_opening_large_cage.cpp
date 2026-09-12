#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_opening_large_cage : public SpellScriptLoader
{
public:
    spell_opening_large_cage() : SpellScriptLoader("spell_opening_large_cage") { }

    class spell_opening_large_cage_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_opening_large_cage_SpellScript);

        void HandleAfterCast()
        {
            if (Unit* caster = GetCaster())
            {
                std::list<Creature*> creatureList;
                std::vector<uint32> creatureEntries = { 881402, 881405, 819720, 818756, 831434, 814874, 819077, 820977 }; 

                caster->GetCreatureListWithEntryInGrid(creatureList, 881402, 20.0f);
                caster->GetCreatureListWithEntryInGrid(creatureList, 881405, 20.0f);
                caster->GetCreatureListWithEntryInGrid(creatureList, 819720, 20.0f);
                caster->GetCreatureListWithEntryInGrid(creatureList, 818756, 20.0f);
                caster->GetCreatureListWithEntryInGrid(creatureList, 831434, 20.0f);
                caster->GetCreatureListWithEntryInGrid(creatureList, 814874, 20.0f);
                caster->GetCreatureListWithEntryInGrid(creatureList, 819077, 20.0f);
                caster->GetCreatureListWithEntryInGrid(creatureList, 820977, 20.0f);

                for (Creature* creature : creatureList)
                {
                    if (creature->GetEntry() == 820977)
                    {
                        creature->m_Events.AddEvent(new MoveCreatureForward(creature, 5.5f), creature->m_Events.CalculateTime(1800));
                        creature->m_Events.AddEvent(new CastSpecialSpellAndYell(creature, 833830, "I've got somethin' for you to chew on, Beast!"), creature->m_Events.CalculateTime(3600));
                        continue;
                    }

                    if (std::find(creatureEntries.begin(), creatureEntries.end(), creature->GetEntry()) != creatureEntries.end() && !creature->HasAura(833829))
                    {
                        creature->m_Events.AddEvent(new MoveCreatureForward(creature, 6.5f), creature->m_Events.CalculateTime(1800));
                        creature->m_Events.AddEvent(new CastDelayedSpellAndYell(creature, 833829), creature->m_Events.CalculateTime(3300));
                    }
                }
            }
        }

        struct MoveCreatureForward : public BasicEvent
        {
            Creature* _creature;
            float _distance;

            MoveCreatureForward(Creature* creature, float distance) : _creature(creature), _distance(distance) {}

            bool Execute(uint64 /*currentTime*/, uint32 /*diff*/) override
            {
                float x, y, z;
                _creature->GetClosePoint(x, y, z, _creature->GetObjectSize(), _distance);
                _creature->GetMotionMaster()->MovePoint(0, x, y, z);
                return true;
            }
        };

        struct CastDelayedSpellAndYell : public BasicEvent
        {
            Creature* _creature;
            uint32 _spellId;

            CastDelayedSpellAndYell(Creature* creature, uint32 spellId) : _creature(creature), _spellId(spellId) {}

            bool Execute(uint64 /*currentTime*/, uint32 /*diff*/) override
            {
                static const char* dialogues[] = {
                    "Somebody help us! We're walking into a death trap!",
                    "It's a nightmare! We're doomed!",
                    "Oh gods, why are you so cruel?!",
                    "Oh God Its Gonna Eat ME!",
                    "Run away! Run away!",
                    "Released, only to be devoured by that monster!",
                    "This isn't freedom, it's a death sentence!",
                    "They're not freeing us--they're serving us to that beast!",
                    "Running is useless! We can't escape it!",
                    "They free us just to feed us to their beast!",
                    "Fleeing was never an option, was it?",
                    "No, no, no! This can't be happening!",
                    "The gates open to a fate worse than captivity!",
                    "There's no way out, only deeper into darkness!",
                    "Why release us only to lead us to slaughter?",
                    "Is there no mercy left in this world?",
                    "This freedom is just another prison!"
                };

                int index = rand() % (sizeof(dialogues) / sizeof(const char*));
                _creature->Yell(dialogues[index], LANG_UNIVERSAL);
                _creature->CastSpell(_creature, _spellId, true);
                return true;
            }
        };

        struct CastSpecialSpellAndYell : public BasicEvent
        {
            Creature* _creature;
            uint32 _spellId;
            const char* _yellMessage;

            CastSpecialSpellAndYell(Creature* creature, uint32 spellId, const char* yellMessage) : _creature(creature), _spellId(spellId), _yellMessage(yellMessage) {}

            bool Execute(uint64 /*currentTime*/, uint32 /*diff*/) override
            {
                _creature->Yell(_yellMessage, LANG_UNIVERSAL);
                _creature->PlayDirectSound(188051); 
                _creature->CastSpell(_creature, _spellId, true);
                return true;
            }
        };

        void Register() override
        {
            AfterCast += SpellCastFn(spell_opening_large_cage_SpellScript::HandleAfterCast);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_opening_large_cage_SpellScript();
    }
};

void AddSC_spell_opening_large_cage()
{
    new spell_opening_large_cage();
}
