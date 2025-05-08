Config = Config or {}
Config.Plants = {}

-- start plant settings
Config.GrowthTimer = 60000 -- 60000 = every 1 min / testing 1000 = 1 seconds
Config.DeadPlantTime = 60 * 60 * 6 -- time until plant is dead and removed from db - e.g. 60 * 60 * 24 for 1 day / 60 * 60 * 48 for 2 days / 60 * 60 * 72 for 3 days
Config.StartingThirst = 100.0 -- starting plan thirst percentage
Config.StartingHunger = 100.0 -- starting plan hunger percentage
Config.HungerIncrease = 25.0 -- amount increased when watered
Config.ThirstIncrease = 25.0 -- amount increased when fertilizer is used
Config.Degrade = {min = 40, max = 60}
Config.QualityDegrade = {min = 8, max = 12}
Config.GrowthIncrease = {min = 10, max = 20}
Config.MaxPlantCount = 20 -- maximum plants play can have at any one time
Config.DrugEffect = true -- true/false if you want to have drug effect occur
Config.DrugEffectTime = 300000 -- drug effect time in milliseconds
Config.YieldRewards = {
    {type = "cocaine", rewardMin = 5, rewardMax = 6, item = 'cocaine', label = 'Cocaine Leaf'},
}
-- end plant settings

-- start cocaine trader settings
Config.CocainePlantImage = "rsg-inventory/html/images/cocaine.png"
Config.CocainePlantLabel = "10 x Cocaine = 1 x Bag"

Config.Blip = {
    blipName = 'Cocaine Trader', -- Config.Blip.blipName
    blipSprite = 819673798, -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

-- Cocaine trader shop
Config.CocaineShop = {

    [1] = { name = "cocaineseed", price = 5, amount = 50, info = {}, type = "item",	slot = 1, },

}

-- Cocaine trader prompt locations
Config.CocaineShopLocations = {

    {name = 'Cocaine Trader', location = 'cocainedealer-1', coords = vector3(2786.319, -1555.876, 49.52058), showblip = true, showmarker = false}, --Cocaine dealer

}

-- end Cocaine trader settings