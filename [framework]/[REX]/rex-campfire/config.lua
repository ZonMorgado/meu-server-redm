Config = {}

---------------------------------
-- deploy prop settings
---------------------------------
Config.PromptGroupName = 'Place Campfire'
Config.PromptCancelName = 'Cancel'
Config.PromptPlaceName = 'Set'
Config.PromptRotateLeft = 'Rotate Left'
Config.PromptRotateRight = 'Rotate Right'
Config.CampfireProp = 'p_campfire05x'
Config.PlaceDistance = 5.0

---------------------------------
-- other settings
---------------------------------
Config.Image = 'rsg-inventory/html/images/'

---------------------------------
-- cooking system
---------------------------------
Config.Cooking = {
    {
        category = 'Fish',
        cooktime = 10000,
        ingredients = {
            [1] = { item = 'raw_fish', amount = 1 },
        },
        receive = 'cooked_fish',
        giveamount = 1
    },
    {
        category = 'Meat',
        cooktime = 10000,
        ingredients = {
            [1] = { item = 'raw_meat', amount = 1 },
        },
        receive = 'cooked_meat',
        giveamount = 1
    },
    -- add more as required
}
