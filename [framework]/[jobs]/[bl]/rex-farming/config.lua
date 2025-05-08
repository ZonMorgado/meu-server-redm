Config = Config or {}
Config.FarmPlants = {}

---------------------------------------------
-- pland seed settings
---------------------------------------------
Config.ForwardDistance   = 2.0
Config.PromptGroupName   = 'Plant Seedling'
Config.PromptCancelName  = 'Cancel'
Config.PromptPlaceName   = 'Set'
Config.PromptRotateLeft  = 'Rotate Left'
Config.PromptRotateRight = 'Rotate Right'

---------------------------------
-- npc settings
---------------------------------
Config.DistanceSpawn = 20.0
Config.FadeIn = true

---------------------------------
-- general settings
---------------------------------
Config.RestrictTowns     = false -- will restrict players planting in towns
Config.GrowthTimer       = 10000 -- 60000 = every 1 min / testing 1000 = 1 seconds
Config.DeadPlantTime     = 60 * 60 * 72 -- time until plant is dead and removed from db - e.g. 60 * 60 * 24 for 1 day / 60 * 60 * 48 for 2 days / 60 * 60 * 72 for 3 days
Config.StartingThirst    = 1.0 -- starting plan thirst percentage
Config.StartingHunger    = 1.0 -- starting plan hunger percentage
Config.HungerIncrease    = 50.0 -- amount increased when watered
Config.ThirstIncrease    = 50.0 -- amount increased when fertilizer is used
Config.Degrade           = {min = 1, max = 2}
Config.QualityDegrade    = {min = 1, max = 2}
Config.GrowthIncrease    = {min = 10, max = 20}
Config.MaxPlantCount     = 30 -- maximum plants play can have at any one time
Config.CollectWaterTime  = 10000 -- time set to collect water
Config.CollectPooTime    = 3000 -- time set to collect fertilizer

---------------------------------
-- farm plants
---------------------------------
Config.FarmItems = {
    {
        planttype = 'corn',
        item = 'corn',
        label = 'Corn',
        -- reward settings
        poorRewardMin = 1,
        poorRewardMax = 2,
        goodRewardMin = 3,
        goodRewardMax = 4,
        exellentRewardMin = 5,
        exellentRewardMax = 6,
    },
    {
        planttype = 'sugar',
        item = 'sugar',
        label =  'Sugar',
        -- reward settings
        poorRewardMin = 1,
        poorRewardMax = 2,
        goodRewardMin = 3,
        goodRewardMax = 4,
        exellentRewardMin = 5,
        exellentRewardMax = 6,
    },
    {
        planttype = 'tobacco',
        item = 'tobacco',
        label = 'Tobacco',
        -- reward settings
        poorRewardMin = 1,
        poorRewardMax = 2,
        goodRewardMin = 3,
        goodRewardMax = 4,
        exellentRewardMin = 5,
        exellentRewardMax = 6,
    },
    {
        planttype = 'carrot',
        item = 'carrot',
        label = 'Carrot',
        -- reward settings
        poorRewardMin = 1,
        poorRewardMax = 2,
        goodRewardMin = 3,
        goodRewardMax = 4,
        exellentRewardMin = 5,
        exellentRewardMax = 6,
    },
    {
        planttype = 'tomato',
        item = 'tomato',
        label = 'Tomato',
        -- reward settings
        poorRewardMin = 1,
        poorRewardMax = 2,
        goodRewardMin = 3,
        goodRewardMax = 4,
        exellentRewardMin = 5,
        exellentRewardMax = 6,
    },
    {
        planttype = 'broccoli',
        item = 'broccoli',
        label = 'Broccoli',
        -- reward settings
        poorRewardMin = 1,
        poorRewardMax = 2,
        goodRewardMin = 3,
        goodRewardMax = 4,
        exellentRewardMin = 5,
        exellentRewardMax = 6,
    },
    {
        planttype = 'potato',
        item = 'potato',
        label = 'Potato',
        -- reward settings
        poorRewardMin = 1,
        poorRewardMax = 2,
        goodRewardMin = 3,
        goodRewardMax = 4,
        exellentRewardMin = 5,
        exellentRewardMax = 6,
    },
    {
        planttype = 'artichoke',
        item = 'artichoke',
        label = 'Artichoke',
        -- reward settings
        poorRewardMin = 1,
        poorRewardMax = 2,
        goodRewardMin = 3,
        goodRewardMax = 4,
        exellentRewardMin = 5,
        exellentRewardMax = 6,
    },
}

---------------------------------
-- blip settings
---------------------------------
Config.Blip = {
    blipName = Lang:t('blip.farm_shop'), -- Config.Blip.blipName
    blipSprite = 'blip_shop_market_stall', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

---------------------------------
-- farm shop
---------------------------------
Config.FarmShop = {
     [1] = { name = 'carrotseed',    price = 85, amount = 500,  info = {}, type = 'item', slot = 1, },
     [2] = { name = 'cornseed',      price = 85, amount = 500,  info = {}, type = 'item', slot = 2, },
     [3] = { name = 'sugarseed',     price = 85, amount = 500,  info = {}, type = 'item', slot = 3, },
     [4] = { name = 'tomatoseed',    price = 85, amount = 500,  info = {}, type = 'item', slot = 4, },
     [5] = { name = 'broccoliseed',  price = 85, amount = 500,  info = {}, type = 'item', slot = 5, },
     [6] = { name = 'potatoseed',    price = 85, amount = 500,  info = {}, type = 'item', slot = 6, },
     [7] = { name = 'artichokeseed', price = 85, amount = 500,  info = {}, type = 'item', slot = 7, },
     [8] = { name = 'bucket',        price = 250,   amount = 50,   info = {}, type = 'item', slot = 8, },
     [9] = { name = 'fertilizer',        price = 250,   amount = 50,   info = {}, type = 'item', slot = 9, },
     [10] = { name = 'cocaineseed',        price = 250,   amount = 50,   info = {}, type = 'item', slot = 9, },
}

---------------------------------
-- farm shop locations
---------------------------------
Config.FarmShopLocations = {
    { 
        name = 'Farm Shop',
        prompt = 'val-farmshop',
        coords = vector3(-261.18, 657.67, 113.35),
        showblip = true,
        npcmodel = `a_m_m_valfarmer_01`,
        npccoords = vector4(-261.18, 657.67, 113.35, 87.06),
    },
    { 
        name = 'Farm Shop',
        prompt = 'bal-farmshop',
        coords = vector3(-840.7544, -1366.0676, 43.7226),
        showblip = true,
        npcmodel = `a_m_m_valfarmer_01`,
        npccoords = vector4(-841.5750, -1366.1588, 43.6814, 99.2905),
    },
}

---------------------------------
-- water props
---------------------------------
Config.WaterProps = {
    `p_watertrough01x`,
    `p_watertroughsml01x`,
    `p_watertrough01x_new`,
    `p_watertrough02x`,
    `p_watertrough03x`,
}

---------------------------------
-- fertilizer props
---------------------------------
Config.FertilizerProps = {
    `p_horsepoop02x`,
    `p_horsepoop03x`,
    `new_p_horsepoop02x_static`,
    `p_poop01x`,
    `p_poop02x`,
    `p_poopile01x`,
    `p_sheeppoop01`,
    `p_sheeppoop02x`,
    `p_sheeppoop03x`,
    `p_wolfpoop01x`,
    `p_wolfpoop02x`,
    `p_wolfpoop03x`,
    `s_horsepoop01x`,
    `s_horsepoop02x`,
    `s_horsepoop03x`,
    `mp007_p_mp_horsepoop03x`,
}
