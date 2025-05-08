Config = {}

Config.CraftingMenus = {
    {
        id = 'gunsmithcrafting',
        name = 'Gunsmith Crafting',
        coords = vector3(-285.1708, 634.2106, 112.0707),
        heading = 100,
        minZ = 45.0,
        maxZ = 47.0,
        useEvent = true,
        event = 'stx-crafting:client:gunsmithcrafting',
        jobaccess = 'vallaw',
        categories = {'weapon', 'tool'},
        items = {
            { 
                name = "camping_1", 
                category = "weapon", 
                amount = 1,
                dict = 'mech_inventory@crafting@fallbacks@volatile_dynamite',
                clip = 'loop',
                ingredients = { 
                    bread = 10, 
                    apple = 5 
                } 
            },
            { 
                name = "wood", 
                category = "tool",
                amount = 1, 
                dict = 'amb_work@world_human_sledgehammer_new@after_swing@male_a@base',
                clip = 'base',
                ingredients = {
                     bread = 5,
                     apple = 2 
                } 
            },
        }
    },
}


Config.CookingMenus = {
    {
        id = 'campfirecooking',
        name = 'Campfire Cooking',
        coords = vector3(-278.5337, 628.8825, 112.4861),
        heading = 100,
        minZ = 45.0,
        maxZ = 47.0,
        items = {
            { name = "bread", ingredients = { water = 2, bread = 2 } },
            { name = "water", ingredients = { water = 2 } },
        }
    }
}


