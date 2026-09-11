local TIK_TOK = {}

local SPELL_ID_BITE = 7938
local SPELL_ID_SWEEPING_SLAM = 12887
local SPELL_ID_THUNDERCLAP = 8147
local SPELL_ID_REND = 13738

function TIK_TOK.Ability1(event, delay, repeats, creature)
    creature:CastSpell(creature:GetVictim(), SPELL_ID_BITE, true)
end

function TIK_TOK.Ability2(event, delay, repeats, creature)
    creature:CastSpell(creature:GetVictim(), SPELL_ID_SWEEPING_SLAM, true)
end

function TIK_TOK.Ability3(event, delay, repeats, creature)
    creature:CastSpell(creature, SPELL_ID_THUNDERCLAP, true)
end

function TIK_TOK.Ability4(event, delay, repeats, creature)
    creature:CastSpell(creature:GetVictim(), SPELL_ID_REND, true)
end

function TIK_TOK.OnEnterCombat(event, creature, target)
    creature:SendUnitEmote("Tik-Tok lets out a menacing hiss.")

    creature:RegisterEvent(TIK_TOK.Ability1, math.random(6000, 8000), 0) 
    creature:RegisterEvent(TIK_TOK.Ability2, math.random(9000, 12000), 0) 
    creature:RegisterEvent(TIK_TOK.Ability3, math.random(10000, 15000), 0) 
    creature:RegisterEvent(TIK_TOK.Ability4, math.random(1000, 14000), 0)  
end

function TIK_TOK.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function TIK_TOK.OnDied(event, creature, victim)
    creature:RemoveEvents()
end

RegisterCreatureEvent(8882089, 1, TIK_TOK.OnEnterCombat)       
RegisterCreatureEvent(8882089, 2, TIK_TOK.OnLeaveCombat)       
RegisterCreatureEvent(8882089, 4, TIK_TOK.OnDied)
