local CharredEarth = {}

CharredEarth.CREATURE_ID = 387570
CharredEarth.SPELL_ID = 100148

function CharredEarth.OnSpawn(event, creature)
    creature:CastSpell(creature, CharredEarth.SPELL_ID, true)
end

RegisterCreatureEvent(CharredEarth.CREATURE_ID, 5, CharredEarth.OnSpawn)
