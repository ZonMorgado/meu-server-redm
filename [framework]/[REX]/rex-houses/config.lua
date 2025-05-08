Config = {}

Config.Debug = false

---------------------------------
-- settings
---------------------------------
Config.BillingCycle     = 730 -- will remove credit every x hour/s
Config.LandTaxPerCycle  = 60 -- $ amount of tax added per cycle
Config.StartCredit      = 8
Config.CreditWarning    = 5 -- 5 x Config.LandTaxPerCycle amount : warning will trigger when < : example 5 x 1 = 5 so telegram will trigger on 4 hours
Config.SellBack         = 0.8 -- example: 0.5 = 50% of the buy price / 0.8 = 80% of the buy price
Config.StorageMaxWeight = 4000000
Config.StorageMaxSlots  = 50
Config.OwnedHouseBlips  = false -- when set to true, only the owned house will show the blip
Config.PurgeStorage     = false -- purge house inventory when the house is taken back by not paying taxes (disabled by default)

---------------------------------
-- npc settings
---------------------------------
Config.DistanceSpawn = 20.0 -- Distance before spawning/despawning the ped. (GTA Units.)
Config.FadeIn = true

-- blip settings
Config.Blip = {
    blipName   = Lang:t('client.estate_agent'), -- Config.Blip.blipName
    blipSprite = 'blip_ambient_quartermaster', -- Config.Blip.blipSprite
    blipScale  = 0.2 -- Config.Blip.blipScale
}

-- prompt locations
Config.EstateAgents = {

    {    --valentine
        name      = Lang:t('client.estate_agent'),
        prompt    = 'valestateagent',
        coords    = vector3(-269.8878, 780.14752, 119.48716),
        location  = 'newhanover', -- state
        npcmodel  = `A_M_O_SDUpperClass_01`,
        npccoords = vector4(-269.8878, 780.14752, 119.48716, 211.18072),
        showblip  = true
    },
    {    --blackwater
        name      = Lang:t('client.estate_agent'),
        prompt    = 'blkestateagent',
        coords    = vector3(-800.3775, -1193.046, 43.9986),
        location  = 'westelizabeth', -- state
        npcmodel  = `A_M_O_SDUpperClass_01`,
        npccoords = vector4(-800.3775, -1193.046, 43.9986, 83.373489),
        showblip  = true
    },
    {    --armadillo
        name      = Lang:t('client.estate_agent'),
        prompt    = 'armestateagent',
        coords    = vector3(-3658.934, -2620.835, -13.3414),
        location  = 'newaustin', -- state
        npcmodel  = `A_M_O_SDUpperClass_01`,
        npccoords = vector4(-3645.582, -2554.068, -12.9329, 101.52233),
        showblip  = true
    },
    {    --hagen
        name      = Lang:t('client.estate_agent'),
        prompt    = 'hagestateagent',
        coords    = vector3(-1347.746, 2405.7084, 307.06127),
        location  = 'ambarino', -- state
        npcmodel  = `A_M_O_SDUpperClass_01`,
        npccoords = vector4(-1347.746, 2405.7084, 307.06127, 296.02886),
        showblip  = true
    },
    {    --saint denis
        name      = Lang:t('client.estate_agent'),
        prompt    = 'stdenisestateagent',
        coords    = vector3(2579.4704, -1295.061, 52.926433),
        location  = 'lemoyne', -- state
        npcmodel  = `A_M_O_SDUpperClass_01`,
        npccoords = vector4(2580.8422, -1294.852, 52.926437, 91.423034),
        showblip  = true
    }
}

-- house config
Config.Houses = {

    {    -- house1
        name            = Lang:t('property.house1'),
        houseid         = 'house1',
        houseprompt     = 'houseprompt1',
        menucoords      = vector3(220.0229, 984.58837, 190.89463),
        blipcoords      = vector3(215.80004882813, 988.06512451172, 189.9015045166),
        showblip        = true
    },
    {    -- house2
        name            = Lang:t('property.house2'),
        houseid         = 'house2',
        houseprompt     = 'houseprompt2',
        menucoords      = vector3(-608.9351, -33.68871, 85.995544),
        blipcoords      = vector3(-615.93969726563, -27.086599349976, 84.997604370117),
        showblip        = true
    },
    {    -- house3
        name            = Lang:t('property.house3'),
        houseid         = 'house3',
        houseprompt     = 'houseprompt3',
        menucoords      = vector3(1887.1403, 300.56072, 77.066558),
        blipcoords      = vector3(1888.1700439453,297.95916748047,76.076202392578),
        showblip        = true
    },
    {    -- house4
        name            = Lang:t('property.house4'),
        houseid         = 'house4',
        houseprompt     = 'houseprompt4',
        menucoords      = vector3(1787.467, -81.54805, 56.802436),
        blipcoords      = vector3(1781.1064453125,-89.115615844727,55.815963745117),
        showblip        = true
    },
    {    -- house5
        name            = Lang:t('property.house5'),
        houseid         = 'house5',
        houseprompt     = 'houseprompt5',
        menucoords      = vector3(1269.6508, -412.1731, 97.596702),
        blipcoords      = vector3(1264.1951904297,-404.07095336914,96.595031738281),
        showblip        = true
    },
    {    -- house6
        name            = Lang:t('property.house6'),
        houseid         = 'house6',
        houseprompt     = 'houseprompt6',
        menucoords      = vector3(1619.2441, -364.0213, 75.897171),
        blipcoords      = vector3(1627.2501220703,-366.25610351563,74.909873962402),
        showblip        = true
    },
    {    -- house7
        name            = Lang:t('property.house7'),
        houseid         = 'house7',
        houseprompt     = 'houseprompt7',
        menucoords      = vector3(-2367.865, -2394.804, 62.278335),
        blipcoords      = vector3(-2368.841796875,-2390.40625,61.520217895508),
        showblip        = true
    },
    {    -- house8
        name            = Lang:t('property.house8'),
        houseid         = 'house8',
        houseprompt     = 'houseprompt8',
        menucoords      = vector3(1120.2464, 492.69769, 97.284187),
        blipcoords      = vector3(1114.0626220703,493.74633789063,96.290939331055),
        showblip        = true
    },
    {    -- house9
        name            = Lang:t('property.house9'),
        houseid         = 'house9',
        houseprompt     = 'houseprompt9',
        menucoords      = vector3(-63.72145, -392.5166, 72.218261),
        blipcoords      = vector3(-64.242599487305,-393.56112670898,71.248695373535),
        showblip        = true
    },
    {    -- house10
        name            = Lang:t('property.house10'),
        houseid         = 'house10',
        houseprompt     = 'houseprompt10',
        menucoords      = vector3(339.88751, -667.7122, 42.811027),
        blipcoords      = vector3(338.25341796875,-669.94842529297,41.821144104004),
        showblip        = true
    },
    {    -- house11
        name            = Lang:t('property.house11'),
        houseid         = 'house11',
        houseprompt     = 'houseprompt11',
        menucoords      = vector3(1111.6049, -1304.963, 66.403602),
        blipcoords      = vector3(1111.4659423828,-1297.5782470703,65.41828918457),
        showblip        = true
    },
    {    -- house12
        name            = Lang:t('property.house12'),
        houseid         = 'house12',
        houseprompt     = 'houseprompt12',
        menucoords      = vector3(1369.3358, -870.8798, 70.127265),
        blipcoords      = vector3(1365.4197998047,-872.88018798828,69.162147521973),
        showblip        = true
    },
    {    -- house13
        name            = Lang:t('property.house13'),
        houseid         = 'house13',
        houseprompt     = 'houseprompt13',
        menucoords      = vector3(2064.4531, -854.3615, 43.360958),
        blipcoords      = vector3(2068.3598632813,-847.32141113281,42.350879669189),
        showblip        = true
    },
    {    -- house14
        name            = Lang:t('property.house14'),
        houseid         = 'house14',
        houseprompt     = 'houseprompt14',
        menucoords      = vector3(2254.1096, -795.2846, 44.226325),
        blipcoords      = vector3(2253.8466796875,-797.30505371094,43.133113861084),
        showblip        = true
    },
    {    -- house15
        name            = Lang:t('property.house15'),
        houseid         = 'house15',
        houseprompt     = 'houseprompt15',
        menucoords      = vector3(2373.1706, -862.4254, 43.020359),
        blipcoords      = vector3(2370.9301757813,-857.48553466797,42.043087005615),
        showblip        = true
    },
    {    -- house16
        name            = Lang:t('property.house16'),
        houseid         = 'house16',
        houseprompt     = 'houseprompt16',
        menucoords      = vector3(1706.3145, -1004.643, 43.473499),
        blipcoords      = vector3(1709.3989257813,-1003.7617797852,42.480758666992),
        showblip        = true
    },
    {    -- house17
        name            = Lang:t('property.house17'),
        houseid         = 'house17',
        houseprompt     = 'houseprompt17',
        menucoords      = vector3(2624.0607, 1696.1097, 115.70227),
        blipcoords      = vector3(2628.2214355469,1694.3289794922,114.66619110107),
        showblip        = true
    },
    {    -- house18
        name            = Lang:t('property.house18'),
        houseid         = 'house18',
        houseprompt     = 'houseprompt18',
        menucoords      = vector3(2990.2619, 2184.7788, 166.74037),
        blipcoords      = vector3(2993.4243164063,2188.4375,165.73570251465),
        showblip        = true
    },
    {    -- house19
        name            = Lang:t('property.house19'),
        houseid         = 'house19',
        houseprompt     = 'houseprompt19',
        menucoords      = vector3(2477.8996, 1998.1372, 168.2523),
        blipcoords      = vector3(2473.8527832031,1996.4063720703,167.22595214844),
        showblip        = true
    },
    {    -- house20
        name            = Lang:t('property.house20'),
        houseid         = 'house20',
        houseprompt     = 'houseprompt20',
        menucoords      = vector3(-422.9819, 1738.1881, 216.55885),
        blipcoords      = vector3(-422.6643371582,1733.5697021484,215.59002685547),
        showblip        = true
    },
    {    -- house21
        name            = Lang:t('property.house21'),
        houseid         = 'house21',
        houseprompt     = 'houseprompt21',
        menucoords      = vector3(897.28363, 261.66098, 116.00907),
        blipcoords      = vector3(900.34381103516,265.21841430664,115.04807281494),
        showblip        = true
    },
    {    -- house22
        name            = Lang:t('property.house22'),
        houseid         = 'house22',
        houseprompt     = 'houseprompt22',
        menucoords      = vector3(-1353.182, 2436.3557, 308.40505),
        blipcoords      = vector3(-1347.9483642578,2435.2036132813,307.49612426758),
        showblip        = true
    },
    {    -- house23
        name            = Lang:t('property.house23'),
        houseid         = 'house23',
        houseprompt     = 'houseprompt23',
        menucoords      = vector3(-553.2758, 2701.4128, 320.41564),
        blipcoords      = vector3(-556.41680908203,2698.8635253906,319.38018798828),
        showblip        = true
    },
    {    -- house24
        name            = Lang:t('property.house24'),
        houseid         = 'house24',
        houseprompt     = 'houseprompt24',
        menucoords      = vector3(-1021.677, 1695.299, 244.31025),
        blipcoords      = vector3(-1019.1105957031,1688.2989501953,243.27978515625),
        showblip        = true
    },
    {    -- house25
        name            = Lang:t('property.house25'),
        houseid         = 'house25',
        houseprompt     = 'houseprompt25',
        menucoords      = vector3(-1819.195, 657.87084, 131.85984),
        blipcoords      = vector3(-1815.1489257813,654.96380615234,130.88250732422),
        showblip        = true
    },
    {    -- house26
        name            = Lang:t('property.house26'),
        houseid         = 'house26',
        houseprompt     = 'houseprompt26',
        menucoords      = vector3(-2173.403, 715.4107, 122.61867),
        blipcoords      = vector3(-2182.5109863281,716.46356201172,121.62875366211),
        showblip        = true
    },
    {    -- house27
        name            = Lang:t('property.house27'),
        houseid         = 'house27',
        houseprompt     = 'houseprompt27',
        menucoords      = vector3(-2579.494, -1380.417, 149.2548),
        blipcoords      = vector3(-2575.826171875,-1379.3582763672,148.27227783203),
        showblip        = true
    },
    {    -- house28
        name            = Lang:t('property.house28'),
        houseid         = 'house28',
        houseprompt     = 'houseprompt28',
        menucoords      = vector3(-2375.747, -1591.876, 154.28628),
        blipcoords      = vector3(-2374.3642578125,-1592.6021728516,153.29959106445),
        showblip        = true
    },
    {    -- house29
        name            = Lang:t('property.house29'),
        houseid         = 'house29',
        houseprompt     = 'houseprompt29',
        menucoords      = vector3(-1410.868, -2671.971, 42.17152),
        blipcoords      = vector3(-1410.5717773438,-2674.2229003906,41.185203552246),
        showblip        = true
    },
    {    -- house30
        name            = Lang:t('property.house30'),
        houseid         = 'house30',
        houseprompt     = 'houseprompt30',
        menucoords      = vector3(-3960.028, -2124.254, -4.076438),
        blipcoords      = vector3(-3958.3901367188,-2129.3940429688,-5.235463142395),
        showblip        = true
    },
    {    -- house31
        name            = Lang:t('property.house31'),
        houseid         = 'house31',
        houseprompt     = 'houseprompt31',
        menucoords      = vector3(-4370.378, -2415.955, 20.399623),
        blipcoords      = vector3(-4366.0122070313,-2416.3056640625,19.423376083374),
        showblip        = true
    },
    {    -- house32
        name            = Lang:t('property.house32'),
        houseid         = 'house32',
        houseprompt     = 'houseprompt32',
        menucoords      = vector3(-5549.529, -2399.353, -8.745719),
        blipcoords      = vector3(-5552.146484375,-2401.5205078125,-9.7140893936157),
        showblip        = true
    },
    {    -- house33
        name            = Lang:t('property.house33'),
        houseid         = 'house33',
        houseprompt     = 'houseprompt33',
        menucoords      = vector3(-3550.882, -3008.228, 11.887498),
        blipcoords      = vector3(-3552.3842773438,-3012.0998535156,10.820337295532),
        showblip        = true
    },
    {    -- house34
        name            = Lang:t('property.house34'),
        houseid         = 'house34',
        houseprompt     = 'houseprompt34',
        menucoords      = vector3(-1962.949, 2157.6286, 327.58007),
        blipcoords      = vector3(-1959.1854248047,2160.2043457031,326.55380249023),
        showblip        = true
    },
    {    -- house35
        name            = Lang:t('property.house35'),
        houseid         = 'house35',
        houseprompt     = 'houseprompt35',
        menucoords      = vector3(-1488.904, 1248.895, 314.49044),
        blipcoords      = vector3(-1494.4030761719,1246.7662353516,313.5432434082),
        showblip        = true
    },
    {    -- house36
        name            = Lang:t('property.house36'),
        houseid         = 'house36',
        houseprompt     = 'houseprompt36',
        menucoords      = vector3(3028.9965, 1780.9338, 84.127723),
        blipcoords      = vector3(3024.1213378906,1777.0731201172,83.169136047363),
        showblip        = true
    },
    {    -- house37
        name            = Lang:t('property.house37'),
        houseid         = 'house37',
        houseprompt     = 'houseprompt37',
        menucoords      = vector3(1984.8593, 1196.9948, 171.40205),
        blipcoords      = vector3(1981.9653320313,1195.0833740234,170.41778564453),
        showblip        = true
    },
    {    -- house38
        name            = Lang:t('property.house38'),
        houseid         = 'house38',
        houseprompt     = 'houseprompt38',
        menucoords      = vector3(2718.0898, 710.00518, 79.543266),
        blipcoords      = vector3(2716.8154296875,708.16693115234,78.605178833008),
        showblip        = true
    },
    {    -- house39
        name            = Lang:t('property.house39'),
        houseid         = 'house39',
        houseprompt     = 'houseprompt39',
        menucoords      = vector3(2823.6367, 275.38955, 48.096889),
        blipcoords      = vector3(2824.4970703125,270.89910888672,47.120807647705),
        showblip        = true
    },
    {    -- house40
        name            = Lang:t('property.house40'),
        houseid         = 'house40',
        houseprompt     = 'houseprompt40',
        menucoords      = vector3(1391.1662, -2085.114, 52.56631),
        blipcoords      = vector3(1387.3020019531,-2077.4401855469,51.581089019775),
        showblip        = true
    },
    -- 41 spare
    {    -- house42
        name            = Lang:t('property.house42'),
        houseid         = 'house42',
        houseprompt     = 'houseprompt42',
        menucoords      = vector3(1700.9014, 1512.7069, 147.86967),
        blipcoords      = vector3(1697.4683837891,1508.2376708984,146.8824005127),
        showblip        = true
    },
    {    -- house43
        name            = Lang:t('property.house43'),
        houseid         = 'house43',
        houseprompt     = 'houseprompt43',
        menucoords      = vector3(-3402.104, -3304.445, -4.457978),
        blipcoords      = vector3(-3400.0258789063,-3302.1235351563,-5.3948922157288),
        showblip        = true
    },
    {    -- house44
        name            = Lang:t('property.house44'),
        houseid         = 'house44',
        houseprompt     = 'houseprompt44',
        menucoords      = vector3(-819.3696, 356.07235, 98.078361),
        blipcoords      = vector3(-818.61383056641,351.16165161133,97.108840942383),
        showblip        = true
    },
    {    -- house45
        name            = Lang:t('property.house45'),
        houseid         = 'house45',
        houseprompt     = 'houseprompt45',
        menucoords      = vector3(2712.8942, -1288.714, 60.344982),
        blipcoords      = vector3(2711.4370117188,-1293.0838623047,59.458484649658),
        showblip        = true
    },
    {    -- house46
        name            = Lang:t('property.house46'),
        houseid         = 'house46',
        houseprompt     = 'houseprompt46',
        menucoords      = vector3(-2568.017, 350.39498, 151.45018),
        blipcoords      = vector3(-2571.12, 350.7572, 151.45018),
        showblip        = true
    },
    {    -- house47
        name            = Lang:t('property.house47'),
        houseid         = 'house47',
        houseprompt     = 'houseprompt47',
        menucoords      = vector3(2309.7172, -331.0284, 41.898754),
        blipcoords      = vector3(2307.529, -332.8371, 41.898715),
        showblip        = true
    },
    {    -- house48
        name            = Lang:t('property.house48'),
        houseid         = 'house48',
        houseprompt     = 'houseprompt48',
        menucoords      = vector3(-5627.474, -2947.845, 6.7072935),
        blipcoords      = vector3(-5622.978, -2944.408, 6.755721),
        showblip        = true
    },
    {    -- house49
        name            = Lang:t('property.house49'),
        houseid         = 'house49',
        houseprompt     = 'houseprompt49',
        menucoords      = vector3(-1029.277, -285.3069, 82.06932),
        blipcoords      = vector3(-1029.37, -285.2012, 82.073776),
        showblip        = true
    },
    {    -- house50
        name            = Lang:t('property.house50'),
        houseid         = 'house50',
        houseprompt     = 'houseprompt50',
        menucoords      = vector3(239.79168, -64.06994, 105.89093),
        blipcoords      = vector3(237.50721, -61.15749, 105.13743),
        showblip        = true
    },
    {    -- house51
        name            = Lang:t('property.house51'),
        houseid         = 'house51',
        houseprompt     = 'houseprompt51',
        menucoords      = vector3(637.63818, -222.2627, 144.72094),
        blipcoords      = vector3(644.97546, -214.6335, 142.29745),
        showblip        = true
    },
    {    -- house52
        name            = Lang:t('property.house52'),
        houseid         = 'house52',
        houseprompt     = 'houseprompt52',
        menucoords      = vector3(-1169.946, -1812.159, 62.807331),
        blipcoords      = vector3(-1165.017, -1823.073, 61.949291),
        showblip        = true
    },
    {    -- house53
        name            = Lang:t('property.house53'),
        houseid         = 'house53',
        houseprompt     = 'houseprompt53',
        menucoords      = vector3(2286.2614, -77.61277, 45.589088),
        blipcoords      = vector3(2284.8142, -85.49312, 45.577217),
        showblip        = true
    },
    {    -- house54
        name            = Lang:t('property.house54'),
        houseid         = 'house54',
        houseprompt     = 'houseprompt54',
        menucoords      = vector3(2239.0559, -144.6374, 47.631141),
        blipcoords      = vector3(2239.0559, -144.6374, 47.631141),
        showblip        = true
    },
    {    -- house55
        name            = Lang:t('property.house55'),
        houseid         = 'house55',
        houseprompt     = 'houseprompt55',
        menucoords      = vector3(2239.0559, -144.6374, 47.631141),
        blipcoords      = vector3(2239.0559, -144.6374, 47.631141),
        showblip        = true
    },
    {    -- house56
        name            = Lang:t('property.house56'),
        houseid         = 'house56',
        houseprompt     = 'houseprompt56',
        menucoords      = vector3(-1643.13, -1364.481, 84.402816),
        blipcoords      = vector3(-1642.641, -1362.496, 84.402816),
        showblip        = true
    },
    {    -- house57
        name            = Lang:t('property.house57'),
        houseid         = 'house57',
        houseprompt     = 'houseprompt57',
        menucoords      = vector3(1426.3626, -1364.029, 81.831481),
        blipcoords      = vector3(1427.4974, -1364.888, 81.843536),
        showblip        = true
    },
    {    -- house58
        name            = Lang:t('property.house58'),
        houseid         = 'house58',
        houseprompt     = 'houseprompt58',
        menucoords      = vector3(-2690.28, -357.0526, 148.79687),
        blipcoords      = vector3(-2689.055, -356.0094, 148.80963),
        showblip        = true
    },
    {    -- house59
        name            = Lang:t('property.house59'),
        houseid         = 'house59',
        houseprompt     = 'houseprompt59',
        menucoords      = vector3(-2458.855, 840.68566, 146.38858),
        blipcoords      = vector3(-2459.966, 838.43872, 146.36059),
        showblip        = true
    },
    {    -- house60
        name            = Lang:t('property.house60'),
        houseid         = 'house60',
        houseprompt     = 'houseprompt60',
        menucoords      = vector3(778.93719, 846.88494, 118.90489),
        blipcoords      = vector3(779.729, 849.19171, 118.93957),
        showblip        = true
    },
    {    -- house61
        name            = Lang:t('property.house61'),
        houseid         = 'house61',
        houseprompt     = 'houseprompt61',
        menucoords      = vector3(2384.4101, -1214.971, 47.156871),
        blipcoords      = vector3(2388.3269, -1216.173, 47.1553),
        showblip        = true
    },
}

-- door config
Config.HouseDoors = {

    ---------------------------------------------------------------------------
    {
        houseid         = 'house1',
        name            = Lang:t('property.house1'),
        doorid          = 3598523785,
        doorcoords = vector3(215.80004882813, 988.06512451172, 189.9015045166)
    },
    {
        houseid         = 'house1',
        name            = Lang:t('property.house1'),
        doorid          = 2031215067,
        doorcoords = vector3(222.8265838623, 990.53399658203, 189.9015045166)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house2',
        name            = Lang:t('property.house2'),
        doorid          = 1189146288,
        doorcoords = vector3(-615.93969726563, -27.086599349976, 84.997604370117)
    },
    {
        houseid         = 'house2',
        name            = Lang:t('property.house2'),
        doorid          = 906448125,
        doorcoords = vector3(-608.73846435547, -26.612947463989, 84.997634887695)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house3',
        name            = Lang:t('property.house3'),
        doorid          = 2821676992,
        doorcoords = vector3(1888.1700439453,297.95916748047,76.076202392578)
    },
    {
        houseid         = 'house3',
        name            = Lang:t('property.house3'),
        doorid          = 1510914117,
        doorcoords = vector3(1891.0832519531,302.62200927734,76.091575622559)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house4',
        name            = Lang:t('property.house4'),
        doorid          = 3549587335,
        doorcoords = vector3(1781.1064453125,-89.115615844727,55.815963745117)
    },
    {
        houseid         = 'house4',
        name            = Lang:t('property.house4'),
        doorid          = 3000692149,
        doorcoords = vector3(1781.3618164063,-82.687698364258,55.798538208008)
    },
    {
        houseid         = 'house4',
        name            = Lang:t('property.house4'),
        doorid          = 1928053488,
        doorcoords = vector3(1792.0642089844,-83.22380065918,55.798538208008)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house5',
        name            = Lang:t('property.house5'),
        doorid          = 772977516,
        doorcoords = vector3(1264.1951904297,-404.07095336914,96.595031738281)
    },
    {
        houseid         = 'house5',
        name            = Lang:t('property.house5'),
        doorid          = 527767089,
        doorcoords = vector3(1266.837890625,-412.62899780273,96.595031738281),
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house6',
        name            = Lang:t('property.house6'),
        doorid          = 3468185317,
        doorcoords = vector3(1627.2501220703,-366.25610351563,74.909873962402)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house7',
        name            = Lang:t('property.house7'),
        doorid          = 2779142555,
        doorcoords = vector3(-2368.841796875,-2390.40625,61.520217895508)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house8',
        name            = Lang:t('property.house8'),
        doorid          = 1239033969,
        doorcoords = vector3(1114.0626220703,493.74633789063,96.290939331055)
    },
    {
        houseid         = 'house8',
        name            = Lang:t('property.house8'),
        doorid          = 1597362984,
        doorcoords = vector3(1116.3991699219,485.99212646484,96.306297302246)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house9',
        name            = Lang:t('property.house9'),
        doorid          = 1299456376,
        doorcoords = vector3(-64.242599487305,-393.56112670898,71.248695373535)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house10',
        name            = Lang:t('property.house10'),
        doorid          = 2933656395,
        doorcoords = vector3(338.25341796875,-669.94842529297,41.821144104004)
    },
    {
        houseid         = 'house10',
        name            = Lang:t('property.house10'),
        doorid          = 3238637478,
        doorcoords = vector3(347.24737548828,-666.05346679688,41.822761535645)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house11',
        name            = Lang:t('property.house11'),
        doorid          = 3544613794,
        doorcoords = vector3(1111.4659423828,-1297.5782470703,65.41828918457)
    },
    {
        houseid         = 'house11',
        name            = Lang:t('property.house11'),
        doorid          = 1485561723,
        doorcoords = vector3(1114.6071777344,-1305.0754394531,65.41828918457)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house12',
        name            = Lang:t('property.house12'),
        doorid          = 1511858696,
        doorcoords = vector3(1365.4197998047,-872.88018798828,69.162147521973)
    },
    {
        houseid         = 'house12',
        name            = Lang:t('property.house12'),
        doorid          = 1282705079,
        doorcoords = vector3(1376.0239257813,-873.24206542969,69.11506652832)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house13',
        name            = Lang:t('property.house13'),
        doorid          = 2238665296,
        doorcoords = vector3(2068.3598632813,-847.32141113281,42.350879669189)
    },
    {
        houseid         = 'house13',
        name            = Lang:t('property.house13'),
        doorid          = 2080980868,
        doorcoords = vector3(2069.7229003906,-847.31500244141,42.350879669189)
    },
    {
        houseid         = 'house13',
        name            = Lang:t('property.house13'),
        doorid          = 2700347737,
        doorcoords = vector3(2064.388671875,-847.32141113281,42.350879669189)
    },
    {
        houseid         = 'house13',
        name            = Lang:t('property.house13'),
        doorid          = 2544301759,
        doorcoords = vector3(2065.7514648438,-847.31500244141,42.350879669189)
    },
    {
        houseid         = 'house13',
        name            = Lang:t('property.house13'),
        doorid          = 3720952508,
        doorcoords = vector3(2069.7219238281,-855.87939453125,42.350879669189)
    },
    {
        houseid         = 'house13',
        name            = Lang:t('property.house13'),
        doorid          = 350169319,
        doorcoords = vector3(2068.3588867188,-855.8857421875,42.350879669189)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house14',
        name            = Lang:t('property.house14'),
        doorid          = 984852093,
        doorcoords = vector3(2253.8466796875,-797.30505371094,43.133113861084)
    },
    {
        houseid         = 'house14',
        name            = Lang:t('property.house14'),
        doorid          = 3473362722,
        doorcoords = vector3(2257.2678222656,-792.70416259766,43.167179107666)
    },
    {
        houseid         = 'house14',
        name            = Lang:t('property.house14'),
        doorid          = 686097120,
        doorcoords = vector3(2257.9418945313,-786.59753417969,43.184906005859)
    },
    {
        houseid         = 'house14',
        name            = Lang:t('property.house14'),
        doorid          = 3107660458,
        doorcoords = vector3(2254.5458984375,-781.7353515625,43.165546417236)
    },
    {
        houseid         = 'house14',
        name            = Lang:t('property.house14'),
        doorid          = 3419719645,
        doorcoords = vector3(2252.3625488281,-781.66015625,43.165538787842)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house15',
        name            = Lang:t('property.house15'),
        doorid          = 3945582303,
        doorcoords = vector3(2370.9301757813,-857.48553466797,42.043087005615)
    },
    {
        houseid         = 'house15',
        name            = Lang:t('property.house15'),
        doorid          = 862008394,
        doorcoords = vector3(2370.8708496094,-864.43804931641,42.040088653564)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house16',
        name            = Lang:t('property.house16'),
        doorid          = 1661737397,
        doorcoords = vector3(1709.3989257813,-1003.7617797852,42.480758666992)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house17',
        name            = Lang:t('property.house17'),
        doorid          = 1574473390,
        doorcoords = vector3(2628.2214355469,1694.3289794922,114.66619110107)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house18',
        name            = Lang:t('property.house18'),
        doorid          = 3731688048,
        doorcoords = vector3(2993.4243164063,2188.4375,165.73570251465)
    },
    {
        houseid         = 'house18',
        name            = Lang:t('property.house18'),
        doorid          = 344028824,
        doorcoords = vector3(2989.1081542969,2193.7414550781,165.73979187012)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house19',
        name            = Lang:t('property.house19'),
        doorid          = 2652873387,
        doorcoords = vector3(2473.8527832031,1996.4063720703,167.22595214844)
    },
    {
        houseid         = 'house19',
        name            = Lang:t('property.house19'),
        doorid          = 2061942857,
        doorcoords = vector3(2472.6179199219,2001.7778320313,167.22595214844)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house20',
        name            = Lang:t('property.house20'),
        doorid          = 3702071668,
        doorcoords = vector3(-422.6643371582,1733.5697021484,215.59002685547)
    },
    {
        houseid         = 'house20',
        name            = Lang:t('property.house20'),
        doorid          = 4070066247,
        doorcoords = vector3(-397.8464, 1721.6102, 216.164)
    },
    {
        houseid         = 'house20',
        name            = Lang:t('property.house20'),
        doorid          = 3444471262,
        doorcoords = vector3(-389.1067, 1730.9625, 216.22805)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house21',
        name            = Lang:t('property.house21'),
        doorid          = 1934463007,
        doorcoords = vector3(900.34381103516,265.21841430664,115.04807281494)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house22',
        name            = Lang:t('property.house22'),
        doorid          = 2183007198,
        doorcoords = vector3(-1347.9483642578,2435.2036132813,307.49612426758)
    },
    {
        houseid         = 'house22',
        name            = Lang:t('property.house22'),
        doorid          = 4288310487,
        doorcoords = vector3(-1348.2998046875,2447.0854492188,307.48056030273)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house23',
        name            = Lang:t('property.house23'),
        doorid          = 872775928,
        doorcoords = vector3(-556.41680908203,2698.8635253906,319.38018798828)
    },
    {
        houseid         = 'house23',
        name            = Lang:t('property.house23'),
        doorid          = 2385374047,
        doorcoords = vector3(-557.96398925781,2708.9880371094,319.43182373047)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house24',
        name            = Lang:t('property.house24'),
        doorid          = 3167436574,
        doorcoords = vector3(-1019.1105957031,1688.2989501953,243.27978515625)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house25',
        name            = Lang:t('property.house25'),
        doorid          = 1195519038,
        doorcoords = vector3(-1815.1489257813,654.96380615234,130.88250732422)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house26',
        name            = Lang:t('property.house26'),
        doorid          = 2212914984,
        doorcoords = vector3(-2182.5109863281,716.46356201172,121.62875366211)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house27',
        name            = Lang:t('property.house27'),
        doorid          = 562830153,
        doorcoords = vector3(-2575.826171875,-1379.3582763672,148.27227783203)
    },
    {
        houseid         = 'house27',
        name            = Lang:t('property.house27'),
        doorid          = 663425326,
        doorcoords = vector3(-2578.7858886719,-1385.2464599609,148.26223754883)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house28',
        name            = Lang:t('property.house28'),
        doorid          = 1171581101,
        doorcoords = vector3(-2374.3642578125,-1592.6021728516,153.29959106445)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house29',
        name            = Lang:t('property.house29'),
        doorid          = 52014802,
        doorcoords = vector3(-1410.5717773438,-2674.2229003906,41.185203552246)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house30',
        name            = Lang:t('property.house30'),
        doorid          = 4164042403,
        doorcoords = vector3(-3958.3901367188,-2129.3940429688,-5.235463142395)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house31',
        name            = Lang:t('property.house31'),
        doorid          = 2047072501,
        doorcoords = vector3(-4366.0122070313,-2416.3056640625,19.423376083374)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house32',
        name            = Lang:t('property.house32'),
        doorid          = 2715667864,
        doorcoords = vector3(-5552.146484375,-2401.5205078125,-9.7140893936157)
    },
    {
        houseid         = 'house32',
        name            = Lang:t('property.house32'),
        doorid          = 1263476860,
        doorcoords = vector3(-5555.2666015625,-2397.3522949219,-9.7149391174316)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house33',
        name            = Lang:t('property.house33'),
        doorid          = 1894337720,
        doorcoords = vector3(-3552.3842773438,-3012.0998535156,10.820337295532)
    },
    {
        houseid         = 'house33',
        name            = Lang:t('property.house33'),
        doorid          = 120764251,
        doorcoords = vector3(-3555.4401855469,-3007.9375,10.820337295532)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house34',
        name            = Lang:t('property.house34'),
        doorid          = 943176298,
        doorcoords = vector3(-1959.1854248047,2160.2043457031,326.55380249023)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house35',
        name            = Lang:t('property.house35'),
        doorid          = 2971757040,
        doorcoords = vector3(-1494.4030761719,1246.7662353516,313.5432434082)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house36',
        name            = Lang:t('property.house36'),
        doorid          = 1973911195,
        doorcoords = vector3(3024.1213378906,1777.0731201172,83.169136047363)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house37',
        name            = Lang:t('property.house37'),
        doorid          = 784290387,
        doorcoords = vector3(1981.9653320313,1195.0833740234,170.41778564453)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house38',
        name            = Lang:t('property.house38'),
        doorid          = 843137708,
        doorcoords = vector3(2716.8154296875,708.16693115234,78.605178833008)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house39',
        name            = Lang:t('property.house39'),
        doorid          = 4275653891,
        doorcoords = vector3(2824.4970703125,270.89910888672,47.120807647705)
    },
    {
        houseid         = 'house39',
        name            = Lang:t('property.house39'),
        doorid          = 1431398235,
        doorcoords = vector3(2820.5607910156,278.90881347656,50.09118270874)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house40',
        name            = Lang:t('property.house40'),
        doorid          = 896012811,
        doorcoords = vector3(1387.3020019531,-2077.4401855469,51.581089019775)
    },
    {
        houseid         = 'house40',
        name            = Lang:t('property.house40'),
        doorid          = 2813949612,
        doorcoords = vector3(1385.0637207031,-2085.1806640625,51.583812713623)
    },
    ---------------------------------------------------------------------------
    -- 41 spare
    ---------------------------------------------------------------------------
    {
        houseid         = 'house42',
        name            = Lang:t('property.house42'),
        doorid          = 868379185,
        doorcoords = vector3(1697.4683837891,1508.2376708984,146.8824005127)
    },
    {
        houseid         = 'house42',
        name            = Lang:t('property.house42'),
        doorid          = 640077562,
        doorcoords = vector3(1702.7976074219,1514.3333740234,146.87799072266)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house43',
        name            = Lang:t('property.house43'),
        doorid          = 3045682143,
        doorcoords = vector3(-3400.0258789063,-3302.1235351563,-5.3948922157288)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house44',
        name            = Lang:t('property.house44'),
        doorid          = 1915887592,
        doorcoords = vector3(-818.61383056641,351.16165161133,97.108840942383)
    },
    {
        houseid         = 'house44',
        name            = Lang:t('property.house44'),
        doorid          = 3324299212,
        doorcoords = vector3(-819.14367675781,358.73443603516,97.10627746582)
    },
    ---------------------------------------------------------------------------
    {
        houseid         = 'house45',
        name            = Lang:t('property.house45'),
        doorid          = 1180868565,
        doorcoords = vector3(2711.4370117188,-1293.0838623047,59.458484649658)
    },
    ---------------------------------------------------------------------------
    --pronghorn autumn and braden
    {
        houseid         = 'house46',
        name            = Lang:t('property.house46'),
        doorid          = 218846865,
        doorcoords = vector3(-2569.469970703125, 352.8999938964844, 150.5337371826172)
    },
    {
        houseid         = 'house46',
        name            = Lang:t('property.house46'),
        doorid          = 639207597,
        doorcoords = vector3(-2579.75537109375, 344.6000061035156, 150.54786682128906)
    },
    {
        houseid         = 'house46',
        name            = Lang:t('property.house46'),
        doorid          = 1012217124,
        doorcoords = vector3(-2569.469970703125, 335.9700012207031, 150.54786682128906)
    },
    ---right house
    {
        houseid         = 'house46',
        name            = Lang:t('property.house46'),
        doorid          = 1535511805,
        doorcoords = vector3(-2590.841064453125, 457.8380126953125, 146.0139617919922)
    },
    
    {
        houseid         = 'house46',
        name            = Lang:t('property.house46'),
        doorid          = 2395304827, --working
        doorcoords = vector3(-2596.81591796875, 458.4296875, 146.9975128173828)
    },
    ---left house
    {
        houseid         = 'house46',
        name            = Lang:t('property.house46'),
        doorid          = 982192611, --working
        doorcoords = vector3(-2586.36669921875, 439.4800109863281, 146.97999572753906)
    },
    {
        houseid         = 'house46',
        name            = Lang:t('property.house46'),
        doorid          = 2413608077, --working
        doorcoords = vector3(-2597.52294921875, 436.87542724609375, 146.9471435546875)
    },
 
    
    
    
    
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    {
        houseid         = 'house47',
        name            = Lang:t('property.house47'),
        doorid          = 3108731901,
        doorcoords = vector3(2307.5063, -333.1673, 41.895164)
    },
    {
        houseid         = 'house47',
        name            = Lang:t('property.house47'),
        doorid          = 362914435,
        doorcoords = vector3(2311.6889, -327.8833, 41.86837)
    },
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    {
        houseid         = 'house48',
        name            = Lang:t('property.house48'),
        doorid          = 2785987570,
        doorcoords = vector3(-5623.18,-2943.08,5.757)
    },
    {
        houseid         = 'house48',
        name            = Lang:t('property.house48'),
        doorid          = 3064818991,
        doorcoords = vector3(-5624.28,-2944.98,5.74)
    },
    {
        houseid         = 'house48',
        name            = Lang:t('property.house48'),
        doorid          = 3364065499,
        doorcoords = vector3(-5631.96,-2938.66,5.78)
    },
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    {
        houseid         = 'house49',
        name            = Lang:t('property.house49'),
        doorid          = 2467261149,
        doorcoords = vector3(-1032.677, -287.9074, 82.268844)
    },
    -- {
    --     houseid         = 'house49',
    --     name            = Lang:t('property.house49'),
    --     doorid          = 362914435,
    --     doorcoords = vector3(2311.6889, -327.8833, 41.86837)
    -- },
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    {
        houseid         = 'house50',
        name            = Lang:t('property.house50'),
        doorid          = 4253084944,
        doorcoords = vector3(2285.2563, -84.25365, 45.568889)
    },
    {
        houseid         = 'house50',
        name            = Lang:t('property.house50'),
        doorid          = 269849145,
        doorcoords = vector3(236.00117, -69.09773, 105.8682)
    },
    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
   
    {
        houseid         = 'house51',
        name            = Lang:t('property.house51'),
        doorid          = 1851177169,
        doorcoords = vector3(640.17718, -221.1513, 144.76742)
    },
    {
        houseid         = 'house51',
        name            = Lang:t('property.house51'),
        doorid          = 1553962339,
        doorcoords = vector3(632.92871, -218.4532, 144.71482)
    },
    ---------------------------------------------------------------------------
    
    --------------------------------------------------------------------------
    {
        houseid         = 'house52',
        name            = Lang:t('property.house52'),
        doorid          = 1572397678,
        doorcoords = vector3(-1167.369, -1816.54, 63.150253)
    },
    {
        houseid         = 'house52',
        name            = Lang:t('property.house52'),
        doorid          = 2695653460,
        doorcoords = vector3(-1170.382, -1817.402, 63.14159)
    },
    {
        houseid         = 'house52',
        name            = Lang:t('property.house52'),
        doorid          = 1299923443,
        doorcoords = vector3(-1170.999, -1809.57, 62.830249)
    },
    {
        houseid         = 'house52',
        name            = Lang:t('property.house52'),
        doorid          = 874909457,
        doorcoords = vector3(-1173.536, -1810.978, 62.803565)
    },
    
    ---------------------------------------------------------------------------
    --bluewater marsh ranch
    --------------------------------------------------------------------------
    {
        houseid         = 'house53',
        name            = Lang:t('property.house53'),
        doorid          = 4067361695,
        doorcoords = vector3(2284.6005859375, -84.13994598388672, 44.55998611450195)
    },
    {
        houseid         = 'house53',
        name            = Lang:t('property.house53'),
        doorid          = 4069181361,
        doorcoords = vector3(2284.7255859375, -77.3845443725586, 44.56999588012695)
    },
    ---------------------------------------------------------------------------
    --bleuwater marsh house
    --------------------------------------------------------------------------
    {
        houseid         = 'house54',
        name            = Lang:t('property.house54'),
        doorid          = 1762076266,
        doorcoords = vector3(2237.07568359375, -141.64028930664062, 46.6264419555664)
    },
    {
        houseid         = 'house54',
        name            = Lang:t('property.house54'),
        doorid          = 2689340659,
        doorcoords = vector3(2234.14404296875, -147.45721435546875, 47.15731430053711)
    },
    ---------------------------------------------------------------------------
    --cumberland forest
    --------------------------------------------------------------------------
    {
        houseid         = 'house55',
        name            = Lang:t('property.house54'),
        doorid          = 202296518,
        doorcoords = vector3(-67.3031997680664, 1235.837646484375, 169.76470947265625)
    },
    ---------------------------------------------------------------------------
    --great plains i think mcfarlanes
    --------------------------------------------------------------------------
    {
        houseid         = 'house56',
        name            = Lang:t('property.house56'),
        doorid          = 1606546482,
        doorcoords = vector3(-1646.2449951171875, -1367.1334228515625, 83.46566009521484)
    },
    {
        houseid         = 'house56',
        name            = Lang:t('property.house56'),
        doorid          = 2310818050,
        doorcoords = vector3(-1637.0777587890625, -1352.267333984375, 84.17796325683594)
    },
    {
        houseid         = 'house56',
        name            = Lang:t('property.house56'),
        doorid          = 818583340,
        doorcoords = vector3(-1649.207275390625, -1359.2379150390625, 83.46454620361328)
    },
    -- {
    --     houseid         = 'house56',
    --     name            = Lang:t('property.house56'),
    --     doorid          = 874909457,
    --     doorcoords = vector3(-1173.536, -1810.978, 62.803565)
    -- },
      ---------------------------------------------------------------------------
    --rhodes masnion
    --------------------------------------------------------------------------
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 3588743099,
        doorcoords = vector3(1425.4344482421875, -1367.2890625, 80.84294891357422)
    },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 2710659207,
        doorcoords = vector3(1425.9898, -1368.319, 81.748962)
    },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 1391745490,
        doorcoords = vector3(1431.0502, -1370.639, 81.747856)
    },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 1933935600,
        doorcoords = vector3(1432.2485, -1371.202, 81.74868)
    },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 2168829556,
    --     doorcoords = vector3(1434.0036, -1372.019, 81.748764)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 2290855548,
    --     doorcoords = vector3(1435.3203, -1372.538, 81.748474)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 1949299785,
    --     doorcoords = vector3(1431.4423828125, -1370.1708984375, 80.8331298828125)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 2945188489,
    --     doorcoords = vector3(1431.4423828125, -1370.1708984375, 80.8331298828125)
    -- },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 137610238,
        doorcoords = vector3(1431.6572, -1364.773, 81.74382)
    },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 1037179150,
        doorcoords = vector3(1430.3686, -1364.332, 81.743957)
    },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 443869312,
    --     doorcoords = vector3(1430.1042, -1363.004, 81.743888)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 1880161675,
    --     doorcoords = vector3(1430.4494, -1362.359, 81.743888)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 2627759401,
    --     doorcoords = vector3(1429.458251953125, -1363.3154296875, 80.83924865722656)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 1516622389,
    --     doorcoords = vector3(1429.9202880859375, -1362.3099365234375, 80.834716796875)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 1852313785,
    --     doorcoords = vector3(1425.2396240234375, -1364.063720703125, 80.84025573730469)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 1456261887,
    --     doorcoords = vector3(1424.7774658203125, -1365.067138671875, 80.83920288085938)
    -- },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 1754894799,
        doorcoords = vector3(1431.637939453125, -1365.3740234375, 84.16584777832031)
    },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 2227667279,
        doorcoords = vector3(1430.63671875, -1364.9063720703125, 84.16439819335938)
    },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 3071061684,
    --     doorcoords = vector3(1426.422119140625, -1367.85546875, 84.20870971679688)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 1285460218,
    --     doorcoords = vector3(1427.4244384765625, -1368.3162841796875, 84.20756530761719)
    -- },

    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 1281743208,
    --     doorcoords = vector3(1431.14599609375, -1369.9600830078125, 84.21088409423828)
    -- },
    -- {
    --     houseid         = 'house57',
    --     name            = Lang:t('property.house57'),
    --     doorid          = 2894614736,
    --     doorcoords = vector3(1432.0303955078125, -1370.5645751953125, 84.2084732055664)
    -- },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 1584758151,
        doorcoords = vector3(1431.14599609375, -1369.9600830078125, 84.21088409423828)
    },
    {
        houseid         = 'house57',
        name            = Lang:t('property.house57'),
        doorid          = 3193894013,
        doorcoords = vector3(1432.0303955078125, -1370.5645751953125, 84.2084732055664)
    },

    ---------------------------------------------------------------------------
    --shaman house vector3(-2687.081, -354.2728, 148.77404)
    --------------------------------------------------------------------------
    {
        houseid         = 'house58',
        name            = Lang:t('property.house58'),
        doorid          = 1367057172,
        doorcoords = vector3(-2687.080078, -354.850006, 147.820007)
    },

    ---------------------------------------------------------------------------
    --treehouse
    --------------------------------------------------------------------------
    {
        houseid         = 'house59',
        name            = Lang:t('property.house59'),
        doorid          = 524178042,
        doorcoords = vector3(-2459.966, 838.43896, 146.36062)
    },

     ---------------------------------------------------------------------------
    --new hanover farm 
    --------------------------------------------------------------------------
    {
        houseid         = 'house60',
        name            = Lang:t('property.house60'),
        doorid          = 4123766266,
        doorcoords = vector3(779.46551, 849.23419, 118.93576)
    },

    {
        houseid         = 'house60',
        name            = Lang:t('property.house60'),
        doorid          = 417362979,
        doorcoords = vector3(773.56958, 840.81732, 118.70379)
    },
   
    ---------------------------------------------------------------------------
    --st d mansion
    --------------------------------------------------------------------------
    {
        houseid         = 'house61',
        name            = Lang:t('property.house61'),
        doorid          = 1291327218,
        doorcoords = vector3(2387.9267, -1216.933, 47.155231)
    },

    {
        houseid         = 'house61',
        name            = Lang:t('property.house61'),
        doorid          = 1587886668,
        doorcoords = vector3(2387.9863, -1215.351, 47.155231)
    },
    {
        houseid         = 'house61',
        name            = Lang:t('property.house61'),
        doorid          = 3517504371,
        doorcoords = vector3(2367.9472, -1207.939, 47.010848)
    },
    ---back doors
    {
        houseid         = 'house61',
        name            = Lang:t('property.house61'),
        doorid          = 895866323,
        doorcoords = vector3(2360.9841, -1215.474, 47.193767)
    },
    {
        houseid         = 'house61',
        name            = Lang:t('property.house61'),
        doorid          = 1130131904,
        doorcoords = vector3(2360.6975, -1217.146, 47.194042)
    },
     ---back gates
     {
        houseid         = 'house61',
        name            = Lang:t('property.house61'),
        doorid          = 1313209843,
        doorcoords = vector3(2301.0439, -1218.099, 44.008773)
    },
    {
        houseid         = 'house61',
        name            = Lang:t('property.house61'),
        doorid          = 3419633928,
        doorcoords = vector3(2301.0458, -1215.682, 44.008888)
    },
   
   
   
    
   
    
    



    
    
    

}

