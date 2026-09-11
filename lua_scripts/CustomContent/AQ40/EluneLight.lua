local DespairRemover = {}

DespairRemover.CREATURE_ID = 400160
DespairRemover.AURA_OF_DESPAIR_SPELL = 26476
DespairRemover.CLOSE_DISTANCE = 2
DespairRemover.RADIUS_DISTANCE = 150

function DespairRemover.RemoveAuraOfDespairStacks(event, delay, pCall, creature)
    local players_in_range = creature:GetPlayersInRange(DespairRemover.CLOSE_DISTANCE)
    
    if players_in_range then
        for _, player in pairs(players_in_range) do
            if player:HasAura(DespairRemover.AURA_OF_DESPAIR_SPELL) then
                local aura = player:GetAura(DespairRemover.AURA_OF_DESPAIR_SPELL)
                local current_stacks = aura:GetStackAmount()
                
                if current_stacks > 1 then
                    aura:SetStackAmount(current_stacks - 2)
                else
                    player:RemoveAura(DespairRemover.AURA_OF_DESPAIR_SPELL)
                end
            end
        end
    end
end


function DespairRemover.RemoveAuraOfDespairStacks(event, delay, pCall, creature)
    local players_in_range = creature:GetPlayersInRange(DespairRemover.CLOSE_DISTANCE)
    
    if players_in_range then
        for _, player in pairs(players_in_range) do
            if player:HasAura(DespairRemover.AURA_OF_DESPAIR_SPELL) then
                local aura = player:GetAura(DespairRemover.AURA_OF_DESPAIR_SPELL)
                local current_stacks = aura:GetStackAmount()
                
                if current_stacks > 1 then
                    aura:SetStackAmount(current_stacks - 2)
                else
                    player:RemoveAura(DespairRemover.AURA_OF_DESPAIR_SPELL)
                end
            end
        end
    end

    -- Iterate through creatures in range and remove aura stacks
    local creatures_in_range = creature:GetCreaturesInRange(DespairRemover.RADIUS_DISTANCE)
    for _, otherCreature in pairs(creatures_in_range) do
        local otherCreatureID = otherCreature:GetEntry()
        if otherCreatureID >= 70000 and otherCreatureID <= 90000 and otherCreature:HasAura(DespairRemover.AURA_OF_DESPAIR_SPELL) then
            local aura = otherCreature:GetAura(DespairRemover.AURA_OF_DESPAIR_SPELL)
            local current_stacks = aura:GetStackAmount()
            if current_stacks > 1 then
                aura:SetStackAmount(current_stacks - 2)
            else
                otherCreature:RemoveAura(DespairRemover.AURA_OF_DESPAIR_SPELL)
            end
        end
    end
end

function DespairRemover.OnCreatureSpawn(event, creature)
    local creatures_in_range = creature:GetCreaturesInRange(DespairRemover.CLOSE_DISTANCE, DespairRemover.CREATURE_ID)
    local otherCreatureExists = false
    
    for _, otherCreature in pairs(creatures_in_range) do
        if otherCreature:GetGUID() ~= creature:GetGUID() then
            otherCreatureExists = true
            break
        end
    end
    
    if otherCreatureExists then
        creature:DespawnOrUnsummon()
        return
    end
    
    creature:RegisterEvent(DespairRemover.RemoveAuraOfDespairStacks, 750, 0)
end

function DespairRemover.OnCreatureDeath(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(DespairRemover.CREATURE_ID, 5, DespairRemover.OnCreatureSpawn)
RegisterCreatureEvent(DespairRemover.CREATURE_ID, 4, DespairRemover.OnCreatureDeath)