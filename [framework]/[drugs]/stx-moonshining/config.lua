Config = Config or {}

Config.MashProgressTime = 60 -- How long in seconds it takes to finish mashing

Config.Target = 'ox_target' -- rsg-target or ox_target

Config.UnknownEnabled = false -- If enabled, if none of the ingredients match Config.Mashes, it will give a specific mash option
Config.UnknownMash = 'unknownmash' -- What mash can be made, if the ingredients don't match any of the mashes!
Config.UnknownAmount = math.random(2, 5) -- The amount of mash will be given from the unknown type!

Config.MoonshineHeatIntervalPrep = 3 -- How much the heat will raise every second until it reaches the desired temperature it needs!
Config.MoonshineHeatIntervalNormal = 0.5 -- How much it will raise after it reaches the temperature it needs!
Config.MoonshineHeatReductionAmount = 40 -- How much the temperature will go down when cooling moonshine kit!
Config.WaterItem = 'water' -- Item used to cooldown moonshine still!

Config.XPInterval = 10 -- How much XP the still will get for each moonshine!
Config.MaxXP = 500 -- Maximum amount of XP the still can have!

Config.Moonshinekit = 'moonshinekit' -- The item for the moonshining kit!
Config.Moonshinebucket = 'mashbucket' -- The item for the moonshining bucket!
Config.BucketModel = 'p_waterbucket01x' -- The model for the moonshining bucket!
Config.MoonshineKits = { -- The different levels and models for Still!
    {
        xp = 100,
        model = 'mp001_p_mp_still01x',
        reduceTime = 0, -- How much time will be reduced in producing moonshine in minutes!
    },
    {
        xp = 250,
        model = 'p_still03x',
        reduceTime = 8, -- How much time will be reduced in producing moonshine in minutes!
    },
    {
        xp = 500,
        model = 'p_still02x',
        reduceTime = 20, -- How much time will be reduced in producing moonshine in minutes!
    },
}

Config.Moonshine = {
    {
        item = 'absinthe_moonshine', -- The name of the moonshine itemself
        time = 300, -- How long in seconds it takes to brew the moonshine!
        ingredient = 'absinthe_mash', -- What type of mash is needed to brew the moonshine!
    },
    {
        item = 'apple_moonshine',
        time = 300,
        ingredient = 'apple_mash',
    },
    {
        item ='blackberry_moonshine',
        time = 300,
        ingredient = 'blackberry_mash',
    },
    {
        item = 'peach_moonshine',
        time = 300,
        ingredient = 'peach_mash',
    },
    {
        item = 'raspberry_moonshine',
        time = 300,
        ingredient = 'raspberry_mash',
    },
    {
        item = 'fruitpunch_moonshine',
        time = 300,
        ingredient = 'fruitpunchmash',
    },
}

Config.Mashes = {
    {
        item = 'apple_mash', -- The mash given from the given ingredients
        amount = math.random(2, 5), -- How much mash will be given for each time, can be a solid number too!
        ingredients = {
            {item = 'apple', min = 2, max = 3}, -- Ingredient item name, the minimum and the maximum amount required!
            {item = 'sugar_cane', min = 1, max = 1}, -- Ingredient item name, the minimum and the maximum amount required!
            {item = 'water', min = 2, max = 2}, -- Ingredient item name, the minimum and the maximum amount required!
        },
    },
    {
        item = 'blackberry_mash',
        amount = math.random(2, 5),
        ingredients = {
            {item = 'blackberry', min = 3, max = 5},
            {item = 'water', min = 1, max = 2},
            {item = 'sugar_cane', min = 1, max = 1},
        }
    },
    {
        item = 'fruitpunch_moonshine',
        amount = math.random(2, 5),
        ingredients = {
            {item = 'apple', min = 1, max = 2},
            {item = 'sugar_cane', min = 1, max = 1},
            {item = 'orange', min = 1, max = 2},
            {item = 'peach', min = 1, max = 2},
            {item = 'water', min = 2, max = 2},
            {item = 'blackberry', min = 1, max = 2}
        }   
    },
}

Config.MashItems = { -- The items that can be added into the bucket, to make mash(Doesn't need to match any ingredients, that's the fun part exploration!)
    'apple',
    'peach',
    'blacberry',
    'water',
    'cocaine',
    'orange',
    'potato',
    'carrot',
    'sugar_cane',
    'corn',
    'wheat',
    'rye',
    'indianseed',
    'sugarseed',
    'carrotseed',
    'tomatoseed',
    'broccoliseed',
    'potatoseed',
    'artichokeseed',
    'tomato',
    'broccoli',
    'yeast',
    'malt',
    'hops',
    'bread',
    'smallnugget',
    'mediumnugget',
    'largenugget',
}