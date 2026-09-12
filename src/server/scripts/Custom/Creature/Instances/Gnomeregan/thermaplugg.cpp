#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "SpellScript.h"
#include "GameObject.h"
#include "GameObjectAI.h"


enum ThermapluggSpells
{
    SPELL_ACTIVATE_BOMB_A = 11511,
    SPELL_ACTIVATE_BOMB_B = 11795,
    SPELL_KNOCK_AWAY = 10101,
    SPELL_KNOCK_AWAY_AOE = 11130,
    SPELL_WALKING_BOMB_EFFECT = 11504
};

enum ThermapluggNPCs
{
    NPC_WALKING_BOMB = 7915
};

enum ThermapluggGameObjects
{
    GO_BUTTON_1 = 142214,
    GO_BUTTON_2 = 142215,
    GO_BUTTON_3 = 142216,
    GO_BUTTON_4 = 142217,
    GO_BUTTON_5 = 142218,
    GO_BUTTON_6 = 142219,

    GO_GNOME_FACE_1 = 142211,
    GO_GNOME_FACE_2 = 142210,
    GO_GNOME_FACE_3 = 142209,
    GO_GNOME_FACE_4 = 142208,
    GO_GNOME_FACE_5 = 142213,
    GO_GNOME_FACE_6 = 142212
};

const float fBombSpawnZ = -316.2625f;
const uint8 MAX_GNOME_FACES = 6;

struct BombFace
{
    bool Activated;
    uint32 BombTimer;
    ObjectGuid GnomeFaceGUID;
};

class boss_thermaplugg : public CreatureScript
{
public:
    boss_thermaplugg() : CreatureScript("boss_thermaplugg") { }

    struct boss_thermapluggAI : public ScriptedAI
    {
        boss_thermapluggAI(Creature* creature) : ScriptedAI(creature) {}

        bool IsPhaseTwo;

        uint32 KnockAwayTimer;
        uint32 ActivateBombTimer;

        BombFace BombFaces[MAX_GNOME_FACES];
        float SpawnPos[3];

        std::list<ObjectGuid> SummonedBombGUIDs;
        std::list<ObjectGuid> LandedBombGUIDs;

        void Reset() override
        {
            ResetGameObjectsAndBombs();
            events.Reset();
            IsPhaseTwo = false;
            memset(&SpawnPos, 0.0f, sizeof(SpawnPos));
            LandedBombGUIDs.clear();

            for (uint8 i = 0; i < MAX_GNOME_FACES; ++i)
            {
                BombFaces[i].Activated = false;
                BombFaces[i].BombTimer = 0;
                BombFaces[i].GnomeFaceGUID.Clear();  // Initialize to an empty GUID
            }
        }

        void KilledUnit(Unit* victim) override
        {
            me->Yell("Usurpers! Gnomeregan is mine!", LANG_UNIVERSAL);
        }

        void JustDied(Unit* /*killer*/) override
        {
            ResetGameObjectsAndBombs();
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            ResetGameObjectsAndBombs();
            ScriptedAI::EnterEvadeMode();
        }

        void ResetGameObjectsAndBombs()
        {
            // Reset the game objects (gnome faces) and set them to the ready state
            for (uint8 i = 0; i < MAX_GNOME_FACES; ++i)
            {
                BombFaces[i].Activated = false; // Deactivate the bomb face
                BombFaces[i].BombTimer = 0;

                if (GameObject* face = ObjectAccessor::GetGameObject(*me, BombFaces[i].GnomeFaceGUID))
                {
                    face->UseDoorOrButton(10, false, me); // Use the door or button to deactivate
                    face->SetGoState(GO_STATE_READY);     // Set the game object state to ready

                    // Cast to GameObjectAI and call Activate
                    if (GameObjectAI* ai = face->AI())
                    {
                        ai->Reset(); // Ensure the AI is reset first
                        ai->DoAction(1); // You could define DoAction(1) to call Activate
                    }
                }
            }
        

            // Reset all buttons by despawning and resummoning them
            uint32 buttonEntries[MAX_GNOME_FACES] = { GO_BUTTON_1, GO_BUTTON_2, GO_BUTTON_3, GO_BUTTON_4, GO_BUTTON_5, GO_BUTTON_6 };
            for (uint8 i = 0; i < MAX_GNOME_FACES; ++i)
            {
                if (GameObject* button = me->FindNearestGameObject(buttonEntries[i], 100.0f))
                {
                    // Get the position and orientation of the button
                    float x = button->GetPositionX();
                    float y = button->GetPositionY();
                    float z = button->GetPositionZ();
                    float o = button->GetOrientation();

                    button->UseDoorOrButton(10, false, me);
                    // Despawn the button
                    button->DespawnOrUnsummon();

                    // Resummon the button at the same location
                    button = me->SummonGameObject(buttonEntries[i], x, y, z, o, 0, 0, 0, 0, 0);
                    if (button && button->AI())
                    {
                        button->AI()->Reset();
                    }
                }
            }

            // Despawn all summoned bombs
            for (const auto& guid : SummonedBombGUIDs)
            {
                if (Creature* bomb = ObjectAccessor::GetCreature(*me, guid))
                {
                    bomb->DespawnOrUnsummon();
                }
            }
            SummonedBombGUIDs.clear();
            LandedBombGUIDs.clear();

            // Despawn any nearby bombs that might have been missed
            std::list<Creature*> bombList;
            me->GetCreatureListWithEntryInGrid(bombList, NPC_WALKING_BOMB, 250.0f);
            for (Creature* bomb : bombList)
            {
                bomb->DespawnOrUnsummon();
            }

            events.Reset(); // Clear any active events
        }

        void JustEngagedWith(Unit* who) override
        {
            me->Yell("My machines are the future! They'll destroy you all!", LANG_UNIVERSAL);

            SpawnPos[0] = me->GetPositionX();
            SpawnPos[1] = me->GetPositionY();
            SpawnPos[2] = me->GetPositionZ();

            // Initialize combat timers
            KnockAwayTimer = urand(17000, 20000);
            ActivateBombTimer = urand(10000, 15000);

            // Find and store the GUIDs of the bomb face game objects
            BombFaces[0].GnomeFaceGUID = GetGameObjectGUIDByEntry(GO_GNOME_FACE_1);
            BombFaces[1].GnomeFaceGUID = GetGameObjectGUIDByEntry(GO_GNOME_FACE_2);
            BombFaces[2].GnomeFaceGUID = GetGameObjectGUIDByEntry(GO_GNOME_FACE_3);
            BombFaces[3].GnomeFaceGUID = GetGameObjectGUIDByEntry(GO_GNOME_FACE_4);
            BombFaces[4].GnomeFaceGUID = GetGameObjectGUIDByEntry(GO_GNOME_FACE_5);
            BombFaces[5].GnomeFaceGUID = GetGameObjectGUIDByEntry(GO_GNOME_FACE_6);
        }

        ObjectGuid GetGameObjectGUIDByEntry(uint32 entry)
        {
            std::list<GameObject*> gameObjectList;
            me->GetGameObjectListWithEntryInGrid(gameObjectList, entry, 100.0f);
            if (!gameObjectList.empty())
            {
                return gameObjectList.front()->GetGUID();
            }
            return ObjectGuid::Empty;
        }

        void JustSummoned(Creature* summoned) override
        {
            if (summoned->GetEntry() == NPC_WALKING_BOMB)
            {
                SummonedBombGUIDs.push_back(summoned->GetGUID());
                // Calculate point for falling down
                float fX = 0.2f * SpawnPos[0] + 0.8f * summoned->GetPositionX();
                float fY = 0.2f * SpawnPos[1] + 0.8f * summoned->GetPositionY();
                float fZ = SpawnPos[2] - 2.0f;
                summoned->UpdateGroundPositionZ(fX, fY, fZ);
                summoned->GetMotionMaster()->MovePoint(1, fX, fY, fZ);
            }
        }

        void MovementInform(uint32 type, uint32 id) override
        {
            if (type == POINT_MOTION_TYPE && id == 1)
            {
                LandedBombGUIDs.push_back(ObjectGuid::Empty); // Adding an empty GUID as a placeholder
            }
        }

        void SummonedCreatureDespawn(Creature* summoned) override
        {
            SummonedBombGUIDs.remove(summoned->GetGUID());
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            // Movement of Summoned mobs
            if (!LandedBombGUIDs.empty())
            {
                for (auto guid : LandedBombGUIDs)
                {
                    if (Creature* bomb = ObjectAccessor::GetCreature(*me, guid))
                        bomb->GetMotionMaster()->MoveFollow(me, 0.0f, 0.0f);
                }
                LandedBombGUIDs.clear();
            }

            if (!IsPhaseTwo && HealthBelowPct(50))
            {
                me->Yell("Usurpers! Gnomeregan is mine!", LANG_UNIVERSAL);
                IsPhaseTwo = true;
            }

            if (KnockAwayTimer <= diff)
            {
                if (IsPhaseTwo)
                {
                    DoCast(me, SPELL_KNOCK_AWAY_AOE);
                    KnockAwayTimer = 12000;
                }
                else
                {
                    DoCastVictim(SPELL_KNOCK_AWAY);
                    KnockAwayTimer = urand(17000, 20000);
                }
            }
            else
                KnockAwayTimer -= diff;

            if (ActivateBombTimer <= diff)
            {
                DoCast(me, IsPhaseTwo ? SPELL_ACTIVATE_BOMB_B : SPELL_ACTIVATE_BOMB_A);
                ActivateBombTimer = urand(IsPhaseTwo ? 6 : 12, IsPhaseTwo ? 12 : 17) * IN_MILLISECONDS;
                if (!urand(0, 5))
                    me->Yell("Explosions! MORE explosions! I got to have more explosions!", LANG_UNIVERSAL);
            }
            else
                ActivateBombTimer -= diff;

            // Spawn bombs
            for (uint8 i = 0; i < MAX_GNOME_FACES; ++i)
            {
                if (BombFaces[i].Activated)
                {
                    if (BombFaces[i].BombTimer <= diff)
                    {
                        std::list<Creature*> bombList;
                        GetCreatureListWithEntryInGrid(bombList, me, NPC_WALKING_BOMB, 250.0f);
                        if (bombList.size() < MAX_GNOME_FACES)
                        {
                            float fX = 0.0f, fY = 0.0f;
                            if (GameObject* face = ObjectAccessor::GetGameObject(*me, BombFaces[i].GnomeFaceGUID))
                            {
                                fX = 0.35f * SpawnPos[0] + 0.65f * face->GetPositionX();
                                fY = 0.35f * SpawnPos[1] + 0.65f * face->GetPositionY();
                            }
                            me->SummonCreature(NPC_WALKING_BOMB, fX, fY, fBombSpawnZ, 0.0f, TEMPSUMMON_CORPSE_DESPAWN);
                        }
                        BombFaces[i].BombTimer = urand(10000, 25000);
                    }
                    else
                        BombFaces[i].BombTimer -= diff;
                }
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_thermapluggAI(creature);
    }
};

class spell_boss_thermaplugg_activate_bomb : public SpellScriptLoader
{
public:
    spell_boss_thermaplugg_activate_bomb() : SpellScriptLoader("spell_boss_thermaplugg_activate_bomb") { }

    class spell_boss_thermaplugg_activate_bomb_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_boss_thermaplugg_activate_bomb_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            Unit* caster = GetCaster();
            if (!caster)
                return;

            Creature* creature = caster->ToCreature();
            if (!creature)
                return;

            uint8 randomFace = urand(0, MAX_GNOME_FACES - 1);
            boss_thermaplugg::boss_thermapluggAI* ai = dynamic_cast<boss_thermaplugg::boss_thermapluggAI*>(creature->AI());
            if (ai && !ai->BombFaces[randomFace].Activated)
            {
                ai->BombFaces[randomFace].Activated = true;
                ai->BombFaces[randomFace].BombTimer = urand(10000, 25000);
            }
        }

        void Register() override
        {
            OnEffectHitTarget += SpellEffectFn(spell_boss_thermaplugg_activate_bomb_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_boss_thermaplugg_activate_bomb_SpellScript();
    }
};

class go_gnomeface_button : public GameObjectScript
{
public:
    go_gnomeface_button() : GameObjectScript("go_gnomeface_button") { }

    bool OnGossipHello(Player* player, GameObject* go) override
    {
        Creature* thermaplugg = go->FindNearestCreature(NPC_WALKING_BOMB, 200.0f);
        if (!thermaplugg)
            return false;

        boss_thermaplugg::boss_thermapluggAI* ai = dynamic_cast<boss_thermaplugg::boss_thermapluggAI*>(thermaplugg->AI());
        if (!ai)
            return false;

        uint8 buttonIndex = 0;

        switch (go->GetEntry())
        {
        case GO_BUTTON_1:
            buttonIndex = 0;
            break;
        case GO_BUTTON_2:
            buttonIndex = 1;
            break;
        case GO_BUTTON_3:
            buttonIndex = 2;
            break;
        case GO_BUTTON_4:
            buttonIndex = 3;
            break;
        case GO_BUTTON_5:
            buttonIndex = 4;
            break;
        case GO_BUTTON_6:
            buttonIndex = 5;
            break;
        }

        ai->BombFaces[buttonIndex].Activated = false;
        return false;
    }
};


void AddSC_boss_thermaplugg()
{
   // new boss_thermaplugg();
    new spell_boss_thermaplugg_activate_bomb();
   // new go_gnomeface_button();
}

