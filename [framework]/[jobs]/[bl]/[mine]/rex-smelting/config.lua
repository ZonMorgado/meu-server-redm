Config = {}

---------------------------------
-- settings
---------------------------------
Config.Image = "rsg-inventory/html/images/"
Config.Keybind = 'J'

---------------------------------
-- npc settings
---------------------------------
Config.DistanceSpawn = 20.0
Config.FadeIn = true

---------------------------------
-- npc locations
---------------------------------
Config.SmeltingLocations = {
    {
        name = 'Smelting Furnace',
        prompt = 'furnace1',
        coords = vector3(499.38, 678.90, 117.43),
        npcmodel = `mp_u_M_M_lom_rhd_smithassistant_01`,
        npccoords = vector4(499.38, 678.90, 117.43, 125.32),
        showblip = true
    },
}

---------------------------------
-- smelting items
---------------------------------
Config.Smelting = {
    ----------------------
    -- bars
    ----------------------
    {
        category = 'Bars',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'gold_ore', amount = 1 },
        },
        receive = 'goldflakes',
        giveamount = 3
    },
    
    {
        category = 'Nuggets',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'goldflakes', amount = 2 },
        },
        receive = 'smallnugget',
        giveamount = 1
    },
    {
        category = 'Nuggets',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'goldflakes', amount = 4 },
        },
        receive = 'mediumnugget',
        giveamount = 1
    },
    {
        category = 'Nuggets',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'goldflakes', amount = 6 },
        },
        receive = 'largenugget',
        giveamount = 1
    },
    -- add more as required
    {
        category = 'Ores',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'aluminum_ore', amount = 3 },
        },
        receive = 'aluminum',
        giveamount = 1
    },
    {
        category = 'Ores',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'ironore', amount = 3 },
        },
        receive = 'iron',
        giveamount = 1
    },
    {
        category = 'Ores',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'copper_ore', amount = 3 },
        },
        receive = 'copper',
        giveamount = 1
    },
    {
        category = 'Ores',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'silver_ore', amount = 3 },
        },
        receive = 'silver',
        giveamount = 1
    },
    {
        category = 'Ores',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'unrefined_steel', amount = 3 },
        },
        receive = 'steel',
        giveamount = 1
    },

    ---
    {
        category = 'Gems',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'emeraldore', amount = 3 },
        },
        receive = 'emerald',
        giveamount = 1
    },
    {
        category = 'Gems',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'rubyore', amount = 3 },
        },
        receive = 'ruby',
        giveamount = 1
    },
    {
        category = 'Gems',
        smelttime = 30000,
        ingredients = { 
            [1] = { item = 'diamondore', amount = 3 },
        },
        receive = 'diamond',
        giveamount = 1
    },
}
