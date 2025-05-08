Config = {}

---------------------------------
-- general settings
---------------------------------
Config.Debug = false
-------------------------
Config.FeedCooldown = 5 -- cooldown before feeding can take place again (in mins)
Config.FeedXP = 1 -- brush horse amount of xp given
Config.HealthIncrease = 100
-------------------------
Config.BrushCooldown = 5 -- cooldown before cleaning can take place again (in mins)
Config.BrushXP = 1 -- brush horse amount of xp given
-------------------------
Config.RidingXP = 1 -- riding horse amount of xp given
Config.RidingWait = 60000 -- amount time between xp given
-------------------------
Config.LeadingXP = 1 -- leading horse amount of xp given
Config.LeadingWait = 20000 -- amount time between xp given
-------------------------

---------------------------------
-- blip settings
---------------------------------
Config.Blip = {
    blipName = 'Horse Trainer Shop', -- Config.Blip.blipName
    blipSprite = 'blip_shop_horse_saddle', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

---------------------------------
-- npc settings
---------------------------------
Config.DistanceSpawn = 20.0
Config.FadeIn = true

---------------------------------
-- horse trainer location
---------------------------------
Config.HorseTrainerLocations = {
    {
        name = 'Master Horse Trainer',
        prompt = 'val-horsetrainer',
        coords = vector3(-383.21, 790.66, 115.88),
        npcmodel = `mp_lm_stealhorse_buyers_01`,
        npccoords = vector4(-383.21, 790.66, 115.88, 133.75),
        showblip = true
    },
}
