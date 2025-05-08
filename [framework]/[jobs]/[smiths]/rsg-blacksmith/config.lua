Config = {}

-- blacksmith blip settings
Config.BlacksmithBlip = {
    blipName = 'Blacksmith Crafting', -- Config.Blip.blipName
    blipSprite = 'blip_shop_blacksmith', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

-- blacksmith shop blip settings
Config.ShopBlip = {
    blipName = 'Blacksmith Shop', -- Config.Blip.blipName
    blipSprite = 'blip_shop_store', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

-- settings
Config.StorageMaxWeight = 4000000
Config.StorageMaxSlots = 48
Config.Debug = false
Config.Keybind = 'J'

-- blacksmith crafting locations
Config.BlacksmithCraftingPoint = {

    {   -- valentine
        name = 'Blacksmith Crafting',
        location = 'valblacksmith',
        coords = vector3(-369.3893, 796.19067, 116.19599),
        job = 'valblacksmith',
        showblip = true
    },
    
}

-- blacksmith shops
Config.BlacksmithShops = {

    {
        shopid = 'valblacksmithshop',
        shopname = 'Valentine Blacksmith Shop',
        coords = vector3(-364.1691, 799.62487, 116.25514),
        jobaccess = 'valblacksmith',
        showblip = true
    },
    
}

-- blacksmith crafting
Config.BlacksmithCrafting = {

    -- tools
    {
        title =  'Pickaxe',
        category = 'Tools',
        crafttime = 5000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
        },
        receive = "pickaxe",
        giveamount = 1
    },
    {
        title =  'Axe',
        category = 'Tools',
        crafttime = 5000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
        },
        receive = "axe",
        giveamount = 1
    },
    -- goldpanning
    {
        title =  'Gold Pan',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 3 },
        },
        receive = "goldpan",
        giveamount = 1
    },

    -- melee
    {
        title =  'Knife',
        category = 'Melee',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "steel", amount = 1 },
            [2] = { item = "wood",  amount = 1 },
        },
        receive = "weapon_melee_knife",
        giveamount = 1
    },

    {
        title =  'Lasso',
        category = 'Melee',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "wood",  amount = 2 },
        },
        receive = "weapon_lasso",
        giveamount = 1
    },
    {
        title =  'Bow',
        category = 'Weponary',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "wood",  amount = 2 },
            [2] = { item = "aluminum",  amount = 1 },
        },
        receive = "weapon_bow",
        giveamount = 1
    },
    {
        title =  'Improved Bow',
        category = 'Weponary',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "weapon_bow",  amount = 1 },
            [2] = { item = "aluminum",  amount = 2 },
            [3] = { item = "wood",  amount = 4 },
        },
        receive = "weapon_bow_improved",
        giveamount = 1
    },
    
    {
        title =  'Arrows',
        category = 'Weponary',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "wood",  amount = 1 },
        },
        receive = "ammo_arrow",
        giveamount = 1
    },


    -- goldrush
    {
        title =  'Gold Rocker Shovel',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "wood",  amount = 2 },
            [2] = { item = "steel",  amount = 2 },
        },
        receive = "gr_shovel",
        giveamount = 1
    },

    {
        title =  'Rocker',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "wood",  amount = 2 },
            [2] = { item = "steel",  amount = 2 },
        },
        receive = "goldrocker",
        giveamount = 1
    },

    {
        title =  'Gold Bucket',
        category = 'Tools',
        crafttime = 30000,
        icon = 'fa-solid fa-screwdriver-wrench',
        ingredients = { 
            [1] = { item = "wood",  amount = 2 },
            [2] = { item = "steel",  amount = 2 },
        },
        receive = "gr_bucket",
        giveamount = 1
    },
    

}
