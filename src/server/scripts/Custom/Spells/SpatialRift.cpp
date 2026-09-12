#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"
#include "Map.h"
#include "GameTime.h" // Include for GameTime::GetGameTimeMS()

class spell_spatial_rift : public SpellScriptLoader
{
public:
    spell_spatial_rift() : SpellScriptLoader("spell_spatial_rift") { }

    class spell_spatial_rift_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_spatial_rift_SpellScript);

        uint32 SaveLocationSpellId = 100232;
        uint32 SpellOnTeleport = 72313;
        uint32 EmoteOnSpellCast = 51;
        const uint32 TeleportBackDuration = 3 * MINUTE;

        struct SavedLocation
        {
            uint32 mapId;
            float x, y, z, orientation;
            uint32 expiryTime; 
        };

        static std::map<ObjectGuid, SavedLocation> savedLocations;

        bool Load() override
        {
            return GetCaster()->IsPlayer();
        }

        void HandleOnCast()
        {
            Player* player = GetCaster()->ToPlayer();

            if (player->GetMapId() == 489)
            {
                ChatHandler(player->GetSession()).SendSysMessage("This spell does not function in Warsong Gulch.");
                return;
            }

            ObjectGuid playerGuid = player->GetGUID();
            player->HandleEmoteCommand(EmoteOnSpellCast);

            auto itr = savedLocations.find(playerGuid);
            uint32 currentTime = GameTime::GetGameTimeMS().count();

            if (itr == savedLocations.end() || static_cast<uint64>(currentTime) > static_cast<uint64>(itr->second.expiryTime))
            {
                SavedLocation location;
                location.mapId = player->GetMapId();
                location.x = player->GetPositionX();
                location.y = player->GetPositionY();
                location.z = player->GetPositionZ();
                location.orientation = player->GetOrientation();
                location.expiryTime = currentTime + (TeleportBackDuration * IN_MILLISECONDS);

                savedLocations[playerGuid] = location;

                player->AddAura(800232, player);
                ChatHandler(player->GetSession()).SendSysMessage("Your rift location has been saved for 3 minutes.");

            }
            else
            {
                player->TeleportTo(itr->second.mapId, itr->second.x, itr->second.y, itr->second.z, itr->second.orientation);
                player->CastSpell(player, SpellOnTeleport, true);

                if (player->HasAura(800232))
                {
                    player->RemoveAura(800232);
                }

                ChatHandler(player->GetSession()).SendSysMessage("You have been teleported back to your rift location.");
                savedLocations.erase(itr);
            }
        }

        void Register() override
        {
            OnCast += SpellCastFn(spell_spatial_rift_SpellScript::HandleOnCast);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_spatial_rift_SpellScript();
    }
};

std::map<ObjectGuid, spell_spatial_rift::spell_spatial_rift_SpellScript::SavedLocation> spell_spatial_rift::spell_spatial_rift_SpellScript::savedLocations;

class spell_custom_889483 : public SpellScriptLoader
{
public:
    spell_custom_889483() : SpellScriptLoader("spell_custom_889483") { }
    class spell_custom_889483_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_custom_889483_SpellScript);

        SpellCastResult CheckCast()
        {
            if (Unit* caster = GetCaster())
            {
                if (Player* player = caster->ToPlayer())
                {
                    // Check for hardcore items
                    if (player->HasItemCount(90000, 1, true) || player->HasItemCount(800048, 1, true) ||
                        player->HasItemCount(800051, 1, true) || player->HasItemCount(800084, 1, true) ||
                        player->HasItemCount(800085, 1, true) || player->HasItemCount(800086, 1, true) ||
                        player->HasItemCount(800049, 1, true) || player->HasItemCount(800050, 1, true))
                    {
                        player->GetSession()->SendAreaTriggerMessage("This item cannot be used while a hardcore challenge is active.");
                        return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;
                    }

                    // Check for hardcore aura
                    if (player->HasAura(80089))
                    {
                        player->GetSession()->SendAreaTriggerMessage("This item cannot be used while a hardcore challenge is active.");
                        return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;
                    }
                }
            }
            return SPELL_CAST_OK;
        }

        void HandleOnHit()
        {
            Unit* caster = GetCaster();
            if (!caster || caster->GetTypeId() != TYPEID_PLAYER)
                return;
            Player* player = caster->ToPlayer();
            uint8 maxLevel = sWorld->getIntConfig(CONFIG_MAX_PLAYER_LEVEL);
            if (player->GetLevel() >= maxLevel)
                return;
            uint8 currentLevel = player->GetLevel();
            uint32 xpForLevel = sObjectMgr->GetXPForLevel(currentLevel);
            float xpPercent = (currentLevel >= 60) ? 0.02f : 0.15f;
            uint32 xpToGive = uint32(float(xpForLevel) * xpPercent);
            player->GiveXP(xpToGive, nullptr);
        }

        void Register() override
        {
            OnCheckCast += SpellCheckCastFn(spell_custom_889483_SpellScript::CheckCast);
            OnHit += SpellHitFn(spell_custom_889483_SpellScript::HandleOnHit);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_custom_889483_SpellScript();
    }
};

void AddSC_spell_spatial_rift()
{
    new spell_spatial_rift();
    new spell_custom_889483();
}
