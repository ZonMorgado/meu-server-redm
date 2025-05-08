Config = {}

---------------------------------
-- settings
---------------------------------
Config.Keybind = 'J' -- keybind prompt to open shop

---------------------------------
-- shop items

-- amount: default stock (remove to enable unlimited stock)
-- buyPrice: enables selling items to shop
-- maxStock: limits how much items players can sell to shop
-- minQuality: minimum quality that can be sold to shop (default 1)
-- restock: amount of items to be restocked per restock cycle

-- example: { name = 'bread', amount = 50, price = 0.10, buyPrice = 0.05, maxStock = 100, minQuality = 50, restock = 10 },
---------------------------------
Config.Products = {
    ['normal'] = {
        { name = 'bread', amount = 50, price = 0.10 },
        { name = 'water', amount = 50, price = 0.10 },
        { name = 'campfire', amount = 50, price = 0.10 },
        { name = 'canteen100', amount = 50, price = 0.10 },
        { name = 'basic_hunt_bait', amount = 50, price = 0.10 },
        { name = 'prime_hunt_bait', amount = 50, price = 0.10 },
        { name = 'consumable_herbivore_bait', amount = 50, price = 0.10 },
        { name = 'consumable_potent_herbivore_bait', amount = 50, price = 0.10 },
        { name = 'consumable_predator_bait', amount = 50, price = 0.10 },
        { name = 'consumable_potent_predator_bait', amount = 50, price = 0.10 },
        { name = 'paper', amount = 50, price = 0.10 },
        { name = 'lockpick', amount = 50, price = 0.10 },
        { name = 'cigar', amount = 50, price = 0.10 },
        { name = 'matches', amount = 50, price = 0.10 },
        { name = 'cigarette1', amount = 50, price = 0.10 },
        { name = 'dynamite', amount = 50, price = 0.10 },
    },

    ["moonshine"] = {
        { name = 'moonshinekit', amount = 50, price = 0.10 },
        { name = 'moonshinebucket', amount = 50, price = 0.10 },
        { name = 'apple', amount = 50, price = 0.10 },
        { name = 'orange', amount = 50, price = 0.10 },
        { name = 'peach', amount = 50, price = 0.10 },
        { name = 'blackberry', amount = 50, price = 0.10 },
    },
    ["horsetrainer"] = {
        { name = 'trainer_brush', amount = 50, price = 0.10 },
        { name = 'trainer_feed', amount = 50, price = 0.10 },

    },

    ["fishmonger"] = {
        { name = 'p_baitbread01x', amount = 50, price = 0.10 },
        { name = 'p_baitcorn01x', amount = 50, price = 0.10 },
        { name = 'p_baitcheese01x', amount = 50, price = 0.10 },
        { name = 'p_baitworm01x', amount = 50, price = 0.10 },
        { name = 'p_baitcricket01x', amount = 50, price = 0.10 },
        { name = 'p_crawdad01x', amount = 50, price = 0.10 },
        { name = 'weapon_fishingrod', amount = 50, price = 0.10 },
        { name = 'fishtrap', amount = 50, price = 0.10 },

    },
    ['weapons'] = {
        { name = 'weapon_revolver_cattleman',            amount = 1, price = 50 },
        { name = 'weapon_revolver_doubleaction',         amount = 1, price = 127 },
        { name = 'weapon_revolver_doubleaction_gambler', amount = 1, price = 190 },
        { name = 'weapon_revolver_lemat',                amount = 1, price = 317 },
        { name = 'weapon_revolver_navy',                 amount = 1, price = 275 },
        { name = 'weapon_revolver_schofield',            amount = 1, price = 192 },
        { name = 'weapon_pistol_mauser',                 amount = 1, price = 600 },
        { name = 'weapon_pistol_semiauto',               amount = 1, price = 537 },
        { name = 'weapon_pistol_volcanic',               amount = 1, price = 270 },
        { name = 'weapon_rifle_boltaction',              amount = 1, price = 216 },
        { name = 'weapon_rifle_elephant',                amount = 1, price = 580 },
        { name = 'weapon_rifle_springfield',             amount = 1, price = 156 },
        { name = 'weapon_rifle_varmint',                 amount = 1, price = 72 },
        { name = 'weapon_repeater_carbine',              amount = 1, price = 90 },
        { name = 'weapon_repeater_evans',                amount = 1, price = 300 },
        { name = 'weapon_repeater_winchester',           amount = 1, price = 243 },
        { name = 'weapon_repeater_henry',                amount = 1, price = 348 },
        { name = 'weapon_sniperrifle_rollingblock',      amount = 1, price = 411 },
        { name = 'weapon_sniperrifle_carcano',           amount = 1, price = 456 },
        { name = 'ammo_box_revolver',                    amount = 10, price = 10 },
        { name = 'ammo_box_pistol',                      amount = 10, price = 10 },
        { name = 'ammo_box_rifle',                       amount = 10, price = 10 },
        { name = 'ammo_box_repeater',                    amount = 10, price = 10 },
        { name = 'ammo_box_shotgun',                     amount = 10, price = 10 },
        { name = 'ammo_box_rifle_elephant',              amount = 10, price = 10 },
    },
    ['armoury'] = {
        { name = 'weapon_revolver_cattleman',  amount = 1, price = 0 },
        { name = 'weapon_repeater_winchester', amount = 1, price = 0 },
        { name = 'ammo_box_revolver',          amount = 10, price = 0 },
        { name = 'ammo_box_repeater',          amount = 10, price = 0 },
    },
    ['horse'] = {
        { name = 'horse_brush',   amount = 50, price = 5 },
        { name = 'horse_lantern', amount = 50, price = 10 },
        { name = 'sugarcube',     amount = 50, price = 1 },
    },
    ['prison'] = {
        { name = 'bread', amount = 50, price = 0.10 },
        { name = 'water', amount = 50, price = 0.10 },
    },
    ['medic'] = {
        { name = 'bandage',  amount = 50, price = 0 },
        { name = 'firstaid', amount = 50, price = 0 }
    },
}

---------------------------------
-- shop locations and blips

-- persistentStock (true/false): enables stock to persist over server restart
---------------------------------
Config.StoreLocations = {
    ---------------------------------
    -- general store
    ---------------------------------

    {
        label = 'Moonshine Store',
        name = 'moon-shack1',
        products = 'moonshine',
        shopcoords = vector3(1615.7694, 837.2839, 121.3020),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = false,
        persistentStock = false,
    },
    {
        label = 'Moonshine Store',
        name = 'moon-shack2',
        products = 'moonshine',
        shopcoords = vector3(-1086.6167, 695.5826, 80.6450),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = false,
        persistentStock = false,
    },
    {
        label = 'Rhodes General Store',
        name = 'gen-rhodes',
        products = 'normal',
        shopcoords = vector3(1328.99, -1293.28, 77.02 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    {
        label = 'Valentine General Store',
        name = 'gen-valentine',
        products = 'normal',
        shopcoords = vector3(-322.433, 803.797, 117.882 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    {
        label = 'Strawberry General Store',
        name = 'gen-strawberry',
        products = 'normal',
        shopcoords = vector3(-1791.49, -386.87, 160.33 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    {
        label = 'Annesburg General Store',
        name = 'gen-annesburg',
        products = 'normal',
        shopcoords = vector3(2931.35, 1365.94, 45.19 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    {
        label = 'Saint Denis General Store',
        name = 'gen-stdenis',
        products = 'normal',
        shopcoords = vector3(2859.81, -1200.37, 49.59 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    {
        label = 'Tumbleweed General Store',
        name = 'gen-tumbleweed',
        products = 'normal',
        shopcoords = vector3(-5487.613, -2938.54, -0.38 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    {
        label = 'Armadillo General Store',
        name = 'gen-armadillo',
        products = 'normal',
        shopcoords = vector3(-3685.56, -2622.59, -13.43 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    {
        label = 'Blackwater General Store',
        name = 'gen-blackwater',
        products = 'normal',
        shopcoords = vector3(-785.18, -1323.83, 43.88 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    {
        label = 'Van Horn General Store',
        name = 'gen-vanhorn',
        products = 'normal',
        shopcoords = vector3(3027.03, 561.00, 44.72 -0.8),
        blipsprite = 'blip_shop_store',
        blipscale = 0.2,
        showblip = true,
        persistentStock = false,
    },
    ---------------------------------
    -- gunsmith
    ---------------------------------
    -- {
    --     label = 'Valentine Gunsmith',
    --     name = 'wep-valentine',
    --     products = 'weapons',
    --     shopcoords = vector3(-281.24, 780.71, 119.53),
    --     blipsprite = 'blip_shop_gunsmith',
    --     blipscale = 0.2,
    --     showblip = true,
    --     persistentStock = false,
    -- },
    -- {
    --     label = 'Tumbleweed Gunsmith',
    --     name = 'wep-tumbleweed',
    --     products = 'weapons',
    --     shopcoords = vector3(-5508.18, -2964.27, -0.63),
    --     blipsprite = 'blip_shop_gunsmith',
    --     blipscale = 0.2,
    --     showblip = true,
    --     persistentStock = false,
    -- },
    -- {
    --     label = 'Saint Denis Gunsmith',
    --     name = 'wep-stdenis',
    --     products = 'weapons',
    --     shopcoords = vector3(2716.42, -1285.42, 49.63),
    --     blipsprite = 'blip_shop_gunsmith',
    --     blipscale = 0.2,
    --     showblip = true,
    --     persistentStock = false,
    -- },
    -- {
    --     label = 'Rhodes Gunsmith',
    --     name = 'wep-rhodes',
    --     products = 'weapons',
    --     shopcoords = vector3(1322.75, -1321.47, 77.89),
    --     blipsprite = 'blip_shop_gunsmith',
    --     blipscale = 0.2,
    --     showblip = true,
    --     persistentStock = false,
    -- },
    -- {
    --     label = 'Annesburg Gunsmith',
    --     name = 'wep-annesburg',
    --     products = 'weapons',
    --     shopcoords = vector3(2946.50, 1319.53, 44.82),
    --     blipsprite = 'blip_shop_gunsmith',
    --     blipscale = 0.2,
    --     showblip = true,
    --     persistentStock = false,
    -- },

}
