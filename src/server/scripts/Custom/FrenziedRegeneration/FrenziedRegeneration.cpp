#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"

enum SpellIds
{
    SPELL_AURA = 853270, 
    SPELL_ABSORB_SHIELD = 803368  
};

class spell_dru_frenzied_regeneration : public SpellScript
{
    PrepareSpellScript(spell_dru_frenzied_regeneration);

    void HandleAfterCast()
    {
        Player* player = GetCaster()->ToPlayer();
        if (!player)
            return;

        if (player->HasAura(SPELL_AURA))
        {
            player->CastSpell(player, SPELL_ABSORB_SHIELD, true);

            if (Aura* absorbShield = player->GetAura(SPELL_ABSORB_SHIELD))
            {
                int32 absorbAmount = player->GetMaxHealth() / 2;
                absorbShield->GetEffect(0)->SetAmount(absorbAmount);
            }
        }
    }

    void Register() override
    {
        AfterCast += SpellCastFn(spell_dru_frenzied_regeneration::HandleAfterCast);
    }
};

void AddSC_spell_dru_frenzied_regeneration()
{
    RegisterSpellScript(spell_dru_frenzied_regeneration);
}
