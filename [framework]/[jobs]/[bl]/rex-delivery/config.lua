Config = {}

Config.Debug = false

---------------------------------
-- blip settings
---------------------------------
Config.Blip = {
    blipName = 'Delivery Job',  -- Config.Blip.blipName
    blipSprite = 'blip_ambient_delivery', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

---------------------------------
-- npc settings
---------------------------------
Config.DistanceSpawn = 20.0
Config.FadeIn = true

---------------------------------
-- settings
---------------------------------
Config.SpawnVehDistance = 5.0 -- check to see if another cart has spawned

---------------------------------
-- delivery locations
---------------------------------
Config.DeliveryLocations = {
    {   -- saint denis -> valentine ( distance 3794 / $37.94)
        name         = 'Valentine Delivery',
        deliveryid   = 'delivery1',
        cartspawn    = vector4(2898.8957, -1169.942, 46.293143, 100.06992),
        cart         = 'wagon04x',
        cargo        = 'pg_teamster_wagon04x_gen',
        light        = 'pg_teamster_wagon04x_lightupgrade3',
        startcoords  = vector3(2904.26, -1168.62, 46.13),
        endcoords    = vector3(-350.7503, 788.47381, 116.0307),
        deliverytime = 20, -- in mins
        showgps      = true,
        showblip     = true,
        npcmodel     = `a_m_m_deliverytravelers_warm_01`,
        npccoords    = vector4(2904.26, -1168.62, 46.13, 96.60),
    },
    {   -- valentine -> blackwater ( distance 2200 / $22.00)
        name         = 'Blackwater Delivery',
        deliveryid   = 'delivery2',
        cartspawn    = vector4(-343.9931, 809.86401, 116.8878, 132.8083),
        cart         = 'wagon04x',
        cargo        = 'pg_teamster_wagon04x_perishables',
        light        = 'pg_teamster_wagon04x_lightupgrade3',
        startcoords  = vector3(-338.52, 814.72, 117.00),
        endcoords    = vector3(-739.7944, -1354.417, 43.461048),
        deliverytime = 20, -- in mins
        showgps      = true,
        showblip     = true,
        npcmodel     = `a_m_m_deliverytravelers_warm_01`,
        npccoords    = vector4(-338.52, 814.72, 117.00, 114.75),
    },
    {   -- blackwater -> strawberry ( distance 1303 / $13.03)
        name         = 'Strawberry Delivery',
        deliveryid   = 'delivery3',
        cartspawn    = vector4(-757.1296, -1225.244, 43.74446, 0.8211954),
        cart         = 'cart01',
        cargo        = 'pg_teamster_cart01_breakables',
        light        = 'pg_teamster_cart01_lightupgrade3',
        startcoords  = vector3(-743.91, -1219.10, 43.25),
        endcoords    = vector3(-1792.688, -434.3452, 155.59338),
        deliverytime = 20, -- in mins
        showgps      = true,
        showblip     = true,
        npcmodel     = `a_m_m_deliverytravelers_warm_01`,
        npccoords    = vector4(-743.91, -1219.10, 43.25, 120.49),
    },
    {   -- strawberry -> mcfarlands ranch ( distance 2033 / $20.33)
        name         = 'Ranch Delivery',
        deliveryid   = 'delivery4',
        cartspawn    = vector4(-1788.618, -439.5259, 155.38444, 80.844512),
        cart         = 'wagon02x',
        cargo        = 'pg_vl_rancher01',
        light        = 'pg_teamster_wagon02x_lightupgrade3',
        startcoords  = vector3(-1795.95, -428.14, 155.90),
        endcoords    = vector3(-2381.418, -2384.764, 61.069843),
        deliverytime = 20, -- in mins
        showgps      = true,
        showblip     = true,
        npcmodel     = `a_m_m_deliverytravelers_warm_01`,
        npccoords    = vector4(-1795.95, -428.14, 155.90, 274.72),
    },
    {   -- mcfarlands ranch -> tumbleweed  ( distance 3214 / $32.14)
        name         = 'Tumbleweed Delivery',
        deliveryid   = 'delivery5',
        cartspawn    = vector4(-2358.09, -2385.02, 62.25, 191.99),
        cart         = 'wagon05x',
        cargo        = 'pg_teamster_wagon05x_gen',
        light        = 'pg_teamster_wagon05x_lightupgrade3',
        startcoords  = vector3(-2357.58, -2367.44, 62.18),
        endcoords    = vector3(-5521.942, -2938.532, -1.995861),
        deliverytime = 20, -- in mins
        showgps      = true,
        showblip     = true,
        npcmodel     = `a_m_m_deliverytravelers_warm_01`,
        npccoords    = vector4(-2357.58, -2367.44, 62.18, 205.85),
    },
    {   -- tumbleweed -> annesburg  ( distance 9595 / $95.95)
        name         = 'The Long Run',
        deliveryid   = 'delivery6',
        cartspawn    = vector4(-5523.004, -2936.102, -1.807142, 255.0812),
        cart         = 'wagon02x',
        cargo        = 'pg_gunforhire03x',
        light        = 'pg_teamster_wagon02x_lightupgrade3',
        startcoords  = vector3(-5529.32, -2932.75, -1.95),
        endcoords    = vector3(3017.0349, 1438.4769, 46.421833),
        deliverytime = 20, -- in mins
        showgps      = true,
        showblip     = true,
        npcmodel     = `a_m_m_deliverytravelers_warm_01`,
        npccoords    = vector4(-5529.32, -2932.75, -1.95, 214.46),
    },
    {   -- oil fields -> van horn  ( distance 2528 / $25.28)
        name         = 'The Oil Run',
        deliveryid   = 'delivery7',
        cartspawn    = vector4(439.78543, 699.36962, 117.06561, 122.11738),
        cart         = 'oilWagon02x',
        cargo        = '',
        light        = '',
        startcoords  = vector3(444.59, 695.98, 116.69),
        endcoords    = vector3(2964.2658, 563.59588, 44.368358),
        deliverytime = 20, -- in mins
        showgps      = true,
        showblip     = true,
        npcmodel     = `a_m_m_deliverytravelers_warm_01`,
        npccoords    = vector4(444.59, 695.98, 116.69, 94.45),
    },
}

-- https://github.com/femga/rdr3_discoveries/blob/f729ba03f75a591ce5c841642dc873345242f612/vehicles/vehicle_modding/vehicle_propsets.lua
-- https://github.com/femga/rdr3_discoveries/blob/f729ba03f75a591ce5c841642dc873345242f612/vehicles/vehicle_modding/vehicle_lantern_propsets.lua
