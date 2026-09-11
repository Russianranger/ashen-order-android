local NPC_ID_HONOR = 842341
local NPC_ID_HONOR_HORDE = 842342


local RankReqKillDefault = {
	RANK_ONE_HK_COUNT        = 50,    
    RANK_TWO_HK_COUNT        = 100,   
    RANK_THREE_HK_COUNT      = 500,   
    RANK_FOUR_HK_COUNT       = 1000,  
    RANK_FIVE_HK_COUNT       = 2000,  
    RANK_SIX_HK_COUNT        = 4000,  
    RANK_SEVEN_HK_COUNT      = 5000,  
    RANK_EIGHT_HK_COUNT      = 6000,  
    RANK_NINE_HK_COUNT       = 8000,  
    RANK_TEN_HK_COUNT        = 10000, 
    RANK_ELEVEN_HK_COUNT     = 12500, 
    RANK_TWELVE_HK_COUNT     = 15000, 
    RANK_THIRTEEN_HK_COUNT   = 20000, 
    RANK_FOURTEEN_HK_COUNT   = 25000  
}


local Titles = {    
	PRIVATE                  = 1,
    CORPORAL                 = 2,
    SERGEANT                 = 3,
    MASTER_SERGEANT          = 4,
    SERGEANT_MAJOR           = 5,
    KNIGHT                   = 6,
    KNIGHT_LIEUTENANT        = 7,
    KNIGHT_CAPTAIN           = 8,
    KNIGHT_CHAMPION          = 9,
    LIEUTENANT_COMMANDER     = 10,
    COMMANDER                = 11,
    MARSHAL                  = 12,
    FIELD_MARSHAL            = 13,
    GRAND_MARSHAL            = 14,
	
	SCOUT                    = 15,
    GRUNT                    = 16,
    SERGEANT_H               = 17,
    SENIOR_SERGEANT          = 18,
    FIRST_SERGEANT           = 19,
    STONE_GUARD              = 20,
    BLOOD_GUARD              = 21,
    LEGIONNAIRE              = 22,
    CENTURION                = 23,
    CHAMPION                 = 24,
    LIEUTENANT_GENERAL       = 25,
    GENERAL                  = 26,
    WARLORD                  = 27,
    HIGH_WARLORD             = 28
}


local FeatsOfStrength = {
	FOS_GRAND_MARSHAL         = 433,
    FOS_FIELD_MARSHAL         = 434,
    FOS_MARSHAL               = 473,
    FOS_COMMANDER             = 435,
    FOS_LIEUTENANT_COMMANDER  = 436,
    FOS_KNIGHT_CHAMPION       = 437,
    FOS_KNIGHT_CAPTAIN        = 438,
    FOS_KNIGHT_LIEUTENANT     = 472,
    FOS_KNIGHT                = 439,
    FOS_SERGEANT_MAJOR        = 440,
    FOS_MASTER_SERGEANT       = 441,
    FOS_SARGEANT              = 471,
    FOS_CORPORAL              = 470,
    FOS_PRIVATE               = 442,

    FOS_HIGH_WARLORD          = 443,
    FOS_WARLORD               = 445,
    FOS_GENERAL               = 446,
    FOS_LIEUTENANT_GENERAL    = 444,
    FOS_CHAMPION              = 447,
    FOS_CENTURION             = 448,
    FOS_LEGIONNAIRE           = 469,
    FOS_BLOOD_GUARD           = 449,
    FOS_STONE_GUARD           = 451,
    FOS_FIRST_SARGEANT        = 452,
    FOS_SENIOR_SERGEANT       = 450,
    FOS_SARGEANT_H            = 453,
    FOS_GRUNT                 = 468,
    FOS_SCOUT                 = 454
}


local function GetAvailableTitlesAndAchievements(teamId)
    local titles = {}
    local achievements = {}

    if teamId == 0 then -- Alliance
        table.insert(titles, Titles.PRIVATE)
        table.insert(achievements, FeatsOfStrength.FOS_PRIVATE)
        
        table.insert(titles, Titles.CORPORAL)
        table.insert(achievements, FeatsOfStrength.FOS_CORPORAL)
        
        table.insert(titles, Titles.SERGEANT)
        table.insert(achievements, FeatsOfStrength.FOS_SARGEANT)
        
        table.insert(titles, Titles.MASTER_SERGEANT)
        table.insert(achievements, FeatsOfStrength.FOS_MASTER_SERGEANT)
        
        table.insert(titles, Titles.SERGEANT_MAJOR)
        table.insert(achievements, FeatsOfStrength.FOS_SERGEANT_MAJOR)
        
        table.insert(titles, Titles.KNIGHT)
        table.insert(achievements, FeatsOfStrength.FOS_KNIGHT)
        
        table.insert(titles, Titles.KNIGHT_LIEUTENANT)
        table.insert(achievements, FeatsOfStrength.FOS_KNIGHT_LIEUTENANT)
        
        table.insert(titles, Titles.KNIGHT_CAPTAIN)
        table.insert(achievements, FeatsOfStrength.FOS_KNIGHT_CAPTAIN)
        
        table.insert(titles, Titles.KNIGHT_CHAMPION)
        table.insert(achievements, FeatsOfStrength.FOS_KNIGHT_CHAMPION)
        
        table.insert(titles, Titles.LIEUTENANT_COMMANDER)
        table.insert(achievements, FeatsOfStrength.FOS_LIEUTENANT_COMMANDER)
        
        table.insert(titles, Titles.COMMANDER)
        table.insert(achievements, FeatsOfStrength.FOS_COMMANDER)
        
        table.insert(titles, Titles.MARSHAL)
        table.insert(achievements, FeatsOfStrength.FOS_MARSHAL)
        
        table.insert(titles, Titles.FIELD_MARSHAL)
        table.insert(achievements, FeatsOfStrength.FOS_FIELD_MARSHAL)
        
        table.insert(titles, Titles.GRAND_MARSHAL)
        table.insert(achievements, FeatsOfStrength.FOS_GRAND_MARSHAL)
    else -- Horde
        table.insert(titles, Titles.SCOUT)
        table.insert(achievements, FeatsOfStrength.FOS_SCOUT)
        
        table.insert(titles, Titles.GRUNT)
        table.insert(achievements, FeatsOfStrength.FOS_GRUNT)
        
        table.insert(titles, Titles.SERGEANT_H)
        table.insert(achievements, FeatsOfStrength.FOS_SARGEANT_H)
        
        table.insert(titles, Titles.SENIOR_SERGEANT)
        table.insert(achievements, FeatsOfStrength.FOS_SENIOR_SERGEANT)
        
        table.insert(titles, Titles.FIRST_SERGEANT)
        table.insert(achievements, FeatsOfStrength.FOS_FIRST_SARGEANT)
        
        table.insert(titles, Titles.STONE_GUARD)
        table.insert(achievements, FeatsOfStrength.FOS_STONE_GUARD)
        
        table.insert(titles, Titles.BLOOD_GUARD)
        table.insert(achievements, FeatsOfStrength.FOS_BLOOD_GUARD)
        
        table.insert(titles, Titles.LEGIONNAIRE)
        table.insert(achievements, FeatsOfStrength.FOS_LEGIONNAIRE)
        
        table.insert(titles, Titles.CENTURION)
        table.insert(achievements, FeatsOfStrength.FOS_CENTURION)
        
        table.insert(titles, Titles.CHAMPION)
        table.insert(achievements, FeatsOfStrength.FOS_CHAMPION)
        
        table.insert(titles, Titles.LIEUTENANT_GENERAL)
        table.insert(achievements, FeatsOfStrength.FOS_LIEUTENANT_GENERAL)
        
        table.insert(titles, Titles.GENERAL)
        table.insert(achievements, FeatsOfStrength.FOS_GENERAL)
        
        table.insert(titles, Titles.WARLORD)
        table.insert(achievements, FeatsOfStrength.FOS_WARLORD)
        
        table.insert(titles, Titles.HIGH_WARLORD)
        table.insert(achievements, FeatsOfStrength.FOS_HIGH_WARLORD)
    end

    return titles, achievements
end

local function PlayerEligibleForTitleAndAchievement(player, titleId, achievementId)
    return not (player:HasTitle(titleId) or player:HasAchieved(achievementId))
end

local function GetPlayerTotalKills(player)
    local guid = player:GetGUIDLow()
    local result = CharDBQuery("SELECT totalKills FROM characters WHERE guid = " .. guid)
    if result then
        local row = result:GetRow() 
        if row then
            return row.totalKills 
        end
    end
    return 0 
end


local function PvPRankOnGossipHello(event, player, object)
    local teamId = player:GetTeam()

    local titles, achievements = GetAvailableTitlesAndAchievements(teamId)

    for i, title in ipairs(titles) do
        local achievementId = achievements[i]
        if PlayerEligibleForTitleAndAchievement(player, title, achievementId) then
            player:GossipMenuAddItem(0, "Receive PvP Rank: " .. title, 1, i)
        end
    end
    player:GossipSendMenu(1, object)
end

local function PvPRankOnGossipSelect(event, player, object, sender, intid, code, menu_id)
  local kills = GetPlayerTotalKills(player)
    local teamId = player:GetTeam()
    local titles, achievements = GetAvailableTitlesAndAchievements(teamId) 
    
    
    local requiredKillsForTitle = {
        [Titles.PRIVATE] = RankReqKillDefault.RANK_ONE_HK_COUNT,
        [Titles.CORPORAL] = RankReqKillDefault.RANK_TWO_HK_COUNT,
        [Titles.SERGEANT] = RankReqKillDefault.RANK_THREE_HK_COUNT,
        [Titles.MASTER_SERGEANT] = RankReqKillDefault.RANK_FOUR_HK_COUNT,
        [Titles.SERGEANT_MAJOR] = RankReqKillDefault.RANK_FIVE_HK_COUNT,
        [Titles.KNIGHT] = RankReqKillDefault.RANK_SIX_HK_COUNT,
        [Titles.KNIGHT_LIEUTENANT] = RankReqKillDefault.RANK_SEVEN_HK_COUNT,
        [Titles.KNIGHT_CAPTAIN] = RankReqKillDefault.RANK_EIGHT_HK_COUNT,
        [Titles.KNIGHT_CHAMPION] = RankReqKillDefault.RANK_NINE_HK_COUNT,
        [Titles.LIEUTENANT_COMMANDER] = RankReqKillDefault.RANK_TEN_HK_COUNT,
        [Titles.COMMANDER] = RankReqKillDefault.RANK_ELEVEN_HK_COUNT,
        [Titles.MARSHAL] = RankReqKillDefault.RANK_TWELVE_HK_COUNT,
        [Titles.FIELD_MARSHAL] = RankReqKillDefault.RANK_THIRTEEN_HK_COUNT,
        [Titles.GRAND_MARSHAL] = RankReqKillDefault.RANK_FOURTEEN_HK_COUNT,
        [Titles.SCOUT] = RankReqKillDefault.RANK_ONE_HK_COUNT,
        [Titles.GRUNT] = RankReqKillDefault.RANK_TWO_HK_COUNT,
        [Titles.SERGEANT_H] = RankReqKillDefault.RANK_THREE_HK_COUNT,
        [Titles.SENIOR_SERGEANT] = RankReqKillDefault.RANK_FOUR_HK_COUNT,
        [Titles.FIRST_SERGEANT] = RankReqKillDefault.RANK_FIVE_HK_COUNT,
        [Titles.STONE_GUARD] = RankReqKillDefault.RANK_SIX_HK_COUNT,
        [Titles.BLOOD_GUARD] = RankReqKillDefault.RANK_SEVEN_HK_COUNT,
        [Titles.LEGIONNAIRE] = RankReqKillDefault.RANK_EIGHT_HK_COUNT,
        [Titles.CENTURION] = RankReqKillDefault.RANK_NINE_HK_COUNT,
        [Titles.CHAMPION] = RankReqKillDefault.RANK_TEN_HK_COUNT,
        [Titles.LIEUTENANT_GENERAL] = RankReqKillDefault.RANK_ELEVEN_HK_COUNT,
        [Titles.GENERAL] = RankReqKillDefault.RANK_TWELVE_HK_COUNT,
        [Titles.WARLORD] = RankReqKillDefault.RANK_THIRTEEN_HK_COUNT,
        [Titles.HIGH_WARLORD] = RankReqKillDefault.RANK_FOURTEEN_HK_COUNT,
    }

   local titleId = titles[intid]
    local achievementId = achievements[intid]
    local requiredKills = requiredKillsForTitle[titleId] 

    if titleId and achievementId and PlayerEligibleForTitleAndAchievement(player, titleId, achievementId) then
        if kills >= requiredKills then
            player:SetAchievement(achievementId)
            player:SetKnownTitle(titleId)  
        else
            player:SendBroadcastMessage("You need " .. requiredKills - kills .. " more honorable kills for this title.")
        end
    end
    player:GossipComplete()
end


RegisterCreatureGossipEvent(NPC_ID_HONOR, 1, PvPRankOnGossipHello)
RegisterCreatureGossipEvent(NPC_ID_HONOR, 2, PvPRankOnGossipSelect)
RegisterCreatureGossipEvent(NPC_ID_HONOR_HORDE, 1, PvPRankOnGossipHello)
RegisterCreatureGossipEvent(NPC_ID_HONOR_HORDE, 2, PvPRankOnGossipSelect)
