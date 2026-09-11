local Magmakin = {}

Magmakin.NPC_ID = 12806
Magmakin.SPELL_IDS = {
    FLAME_BUFFET = 23341,
    MAGMA_BLAST = 20565,
    LAVA_BURST = 49232,
    FIRE_NOVA = 23462,
    GARR = 12057
}

function Magmakin.CastFlameBuffet(eventId, delay, calls, creature)
    if not creature:IsCasting() then
        creature:CastSpell(creature:GetVictim(), Magmakin.SPELL_IDS.FLAME_BUFFET, false)
    end
end

function Magmakin.CastMagmaBlast(eventId, delay, calls, creature)
    if not creature:IsCasting() then
        local targets = creature:GetAITargets(10)
        if #targets > 0 then
            local target = targets[math.random(#targets)]
            creature:CastSpell(target, Magmakin.SPELL_IDS.MAGMA_BLAST, false)
        end
    end
end

function Magmakin.CastLavaBurst(eventId, delay, calls, creature)
    if not creature:IsCasting() then
        creature:CastSpell(creature:GetVictim(), Magmakin.SPELL_IDS.LAVA_BURST, true)
    end
end

function Magmakin.CastFireNova(eventId, delay, calls, creature)
    if not creature:IsCasting() then
        creature:CastSpell(creature, Magmakin.SPELL_IDS.FIRE_NOVA, true)
    end
end

function Magmakin.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Magmakin.CastFlameBuffet, 16000, 0)
    creature:RegisterEvent(Magmakin.CastMagmaBlast, 10000, 0)
    creature:RegisterEvent(Magmakin.CastLavaBurst, 6000, 0)
    creature:RegisterEvent(Magmakin.CastFireNova, 20000, 0)
end

function Magmakin.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end


function Magmakin.CheckForGarr(eventId, delay, calls, creature)
    local gar = creature:GetCreaturesInRange(150, Magmakin.SPELL_IDS.GARR, 0, 1)
    if #gar > 0 and not gar[1]:IsDead() then
        creature:Respawn()
    else
        creature:DespawnOrUnsummon()
        creature:RemoveEvents()
    end
end

function Magmakin.CheckForGarrAndCastSpell(eventId, delay, calls, creature)
    local garrs = creature:GetCreaturesInRange(150, Magmakin.SPELL_IDS.GARR, 0, 1)
    local garrAlive = false
    for _, garr in ipairs(garrs) do
        if garr and not garr:IsDead() then
            garrAlive = true
            break
        end
    end

    if not garrAlive and not creature:IsDead() then
        creature:CastSpell(creature, 826068, true)
    end
end

function Magmakin.OnSpawn(event, creature)
    creature:RegisterEvent(Magmakin.CheckForGarrAndCastSpell, 3000, 0)
end

function Magmakin.OnDied(event, creature, killer)
    creature:RemoveEvents()
    creature:RegisterEvent(Magmakin.CheckForGarr, 180000, 1) 
end

RegisterCreatureEvent(Magmakin.NPC_ID, 1, Magmakin.OnEnterCombat)
RegisterCreatureEvent(Magmakin.NPC_ID, 2, Magmakin.OnLeaveCombat)
RegisterCreatureEvent(Magmakin.NPC_ID, 4, Magmakin.OnDied)
RegisterCreatureEvent(Magmakin.NPC_ID, 5, Magmakin.OnSpawn)
