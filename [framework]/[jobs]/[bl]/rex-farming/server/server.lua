local RSGCore = exports['rsg-core']:GetCoreObject()
local PlantsLoaded = false
local CollectedFertilizer = {}

---------------------------------------------
-- cornseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('cornseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'corn', 'CRP_CORNSTALKS_AB_SIM', 'cornseed')
end)

---------------------------------------------
-- sugarseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('sugarseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'sugar', 'CRP_SUGARCANE_AC_SIM', 'sugarseed')
end)

---------------------------------------------
-- carrotseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('carrotseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'carrot', 'CRP_CARROTS_AA_SIM', 'carrotseed')
end)

---------------------------------------------
-- tomatoseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('tomatoseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'tomato', 'CRP_TOMATOES_AA_SIM', 'tomatoseed')
end)

---------------------------------------------
-- broccoliseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('broccoliseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'broccoli', 'crp_broccoli_aa_sim', 'broccoliseed')
end)

---------------------------------------------
-- potatoseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('potatoseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'potato', 'crp_potato_aa_sim', 'potatoseed')
end)

---------------------------------------------
-- artichokeseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('artichokeseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'artichoke', 'crp_artichoke_aa_sim', 'artichokeseed')
end)

---------------------------------------------
-- appleseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('appleseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'apple', 'p_tree_apple_01', 'appleseed')
end)

---------------------------------------------
-- peachseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('peachseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'peaches', 'p_tree_apple_01', 'peachseed')
end)

---------------------------------------------
-- garlicseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('garlicseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'garlic', 'crowsgarlic_p', 'garlicseed')
end)

---------------------------------------------
-- wheatseed
---------------------------------------------
RSGCore.Functions.CreateUseableItem('wheatseed', function(source)
    local src = source
    TriggerClientEvent('rex-farming:client:preplantseed', src, 'wheat', 'crp_wheat_dry_aa_sim', 'wheatseed')
end)


---------------------------------------------
-- get plant data
---------------------------------------------
RSGCore.Functions.CreateCallback('rex-farming:server:getplantdata', function(source, cb, plantid)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    MySQL.query('SELECT * FROM rex_farm_plants WHERE plantid = ?', { plantid }, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

-----------------------------------------------------------------------

-- remove seed item
RegisterServerEvent('rex-farming:server:removeitem')
AddEventHandler('rex-farming:server:removeitem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'remove')
end)

-----------------------------------------------------------------------

-- update plant data
CreateThread(function()
    while true do
        Wait(5000)

        if PlantsLoaded then
            TriggerClientEvent('rex-farming:client:updatePlantData', -1, Config.FarmPlants)
        end
    end
end)

CreateThread(function()
    TriggerEvent('rex-farming:server:getPlants')
    PlantsLoaded = true
end)

RegisterServerEvent('rex-farming:server:savePlant')
AddEventHandler('rex-farming:server:savePlant', function(data, plantId, citizenid)
    local datas = json.encode(data)

    MySQL.Async.execute('INSERT INTO rex_farm_plants (properties, plantid, citizenid) VALUES (@properties, @plantid, @citizenid)',
    {
        ['@properties'] = datas,
        ['@plantid'] = plantId,
        ['@citizenid'] = citizenid
    })
end)

-- plant seed
RegisterServerEvent('rex-farming:server:plantnewseed')
AddEventHandler('rex-farming:server:plantnewseed', function(outputitem, prophash, position, heading)
    local src = source
    local plantId = math.random(111111, 999999)
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    local SeedData =
    {
        id = plantId,
        planttype = outputitem,
        x = position.x,
        y = position.y,
        z = position.z,
        h = heading,
        hunger = Config.StartingHunger,
        thirst = Config.StartingThirst,
        growth = 0.0,
        quality = 100.0,
        grace = true,
        hash = prophash,
        beingHarvested = false,
        planter = Player.PlayerData.citizenid,
        planttime = os.time()
    }

    local PlantCount = 0

    for _, v in pairs(Config.FarmPlants) do
        if v.planter == Player.PlayerData.citizenid then
            PlantCount = PlantCount + 1
        end
    end

    if PlantCount >= Config.MaxPlantCount then
        TriggerClientEvent('RSGCore:Notify', src, Lang:t('error.you_already_have_plants_down',{MaxPlantCount = Config.MaxPlantCount}), 'error')
    else
        table.insert(Config.FarmPlants, SeedData)
        TriggerEvent('rex-farming:server:savePlant', SeedData, plantId, citizenid)
        TriggerEvent('rex-farming:server:updatePlants')
    end
end)

-- check plant
RegisterServerEvent('rex-farming:server:plantHasBeenHarvested')
AddEventHandler('rex-farming:server:plantHasBeenHarvested', function(plantId)
    for _, v in pairs(Config.FarmPlants) do
        if v.id == plantId then
            v.beingHarvested = true
        end
    end
    TriggerEvent('rex-farming:server:updatePlants')
end)

-- distory plant (police)
RegisterServerEvent('rex-farming:server:destroyPlant')
AddEventHandler('rex-farming:server:destroyPlant', function(plantId)
    local src = source

    for k, v in pairs(Config.FarmPlants) do
        if v.id == plantId then
            table.remove(Config.FarmPlants, k)
        end
    end

    TriggerClientEvent('rex-farming:client:removePlantObject', -1, plantId)
    TriggerEvent('rex-farming:server:PlantRemoved', plantId)
    TriggerEvent('rex-farming:server:updatePlants')
    TriggerClientEvent('RSGCore:Notify', src, Lang:t('success.you_distroyed_the_plant'), 'success')
end)

-- harvest plant and give reward
RegisterServerEvent('rex-farming:server:harvestPlant')
AddEventHandler('rex-farming:server:harvestPlant', function(plantId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local poorAmount = 0
    local goodAmount = 0
    local exellentAmount = 0
    local poorQuality = false
    local goodQuality = false
    local exellentQuality = false
    local hasFound = false
    local label = nil
    local item = nil

    for k, v in pairs(Config.FarmPlants) do
        if v.id == plantId then
            for y = 1, #Config.FarmItems do
                if v.planttype == Config.FarmItems[y].planttype then
                    label = Config.FarmItems[y].label
                    item = Config.FarmItems[y].item
                    poorAmount = math.random(Config.FarmItems[y].poorRewardMin, Config.FarmItems[y].poorRewardMax)
                    goodAmount = math.random(Config.FarmItems[y].goodRewardMin, Config.FarmItems[y].goodRewardMax)
                    exellentAmount = math.random(Config.FarmItems[y].exellentRewardMin, Config.FarmItems[y].exellentRewardMax)
                    local quality = math.ceil(v.quality)
                    hasFound = true

                    table.remove(Config.FarmPlants, k)

                    if quality > 0 and quality <= 25 then -- poor
                        poorQuality = true
                    elseif quality >= 25 and quality <= 75 then -- good
                        goodQuality = true
                    elseif quality >= 75 then -- excellent
                        exellentQuality = true
                    end
                end
            end
        end
    end

    -- give rewards
    if not hasFound then return end

    if poorQuality then
        Player.Functions.AddItem(item, poorAmount)
        TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'add')
        TriggerClientEvent('RSGCore:Notify', src, Lang:t('success.you_harvest_label',{amount = poorAmount, label = label}), 'success')
    elseif goodQuality then
        Player.Functions.AddItem(item, goodAmount)
        TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'add')
        TriggerClientEvent('RSGCore:Notify', src, Lang:t('success.you_harvest_label',{amount = goodAmount, label = label}), 'success')
    elseif exellentQuality then
        Player.Functions.AddItem(item, exellentAmount)
        TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'add')
        TriggerClientEvent('RSGCore:Notify', src, Lang:t('success.you_harvest_label',{amount = exellentAmount, label = label}), 'success')
    else
        print('something went wrong!')
    end

    TriggerClientEvent('rex-farming:client:removePlantObject', -1, plantId)
    TriggerEvent('rex-farming:server:PlantRemoved', plantId)
    TriggerEvent('rex-farming:server:updatePlants')
end)

RegisterServerEvent('rex-farming:server:updatePlants')
AddEventHandler('rex-farming:server:updatePlants', function()
    local src = source
    TriggerClientEvent('rex-farming:client:updatePlantData', src, Config.FarmPlants)
end)

-- water plant
RegisterServerEvent('rex-farming:server:waterPlant')
AddEventHandler('rex-farming:server:waterPlant', function(plantId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    for k, v in pairs(Config.FarmPlants) do
        if v.id == plantId then
            Config.FarmPlants[k].thirst = Config.FarmPlants[k].thirst + Config.ThirstIncrease
            if Config.FarmPlants[k].thirst > 100.0 then
                Config.FarmPlants[k].thirst = 100.0
            end
        end
    end

    if not Player.Functions.RemoveItem('fullbucket', 1) then return end

    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['fullbucket'], 'remove')
    Player.Functions.AddItem('bucket', 1) --add empty bucket
    TriggerEvent('rex-farming:server:updatePlants')
end)

-- feed plant
RegisterServerEvent('rex-farming:server:feedPlant')
AddEventHandler('rex-farming:server:feedPlant', function(plantId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    for k, v in pairs(Config.FarmPlants) do
        if v.id == plantId then
            Config.FarmPlants[k].hunger = Config.FarmPlants[k].hunger + Config.HungerIncrease

            if Config.FarmPlants[k].hunger > 100.0 then
                Config.FarmPlants[k].hunger = 100.0
            end
        end
    end

    if not Player.Functions.RemoveItem('fertilizer', 1) then return end

    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['fertilizer'], 'remove')
    TriggerEvent('rex-farming:server:updatePlants')
end)

-- update plant
RegisterServerEvent('rex-farming:server:updateFarmPlants')
AddEventHandler('rex-farming:server:updateFarmPlants', function(id, data)
    local result = MySQL.query.await('SELECT * FROM rex_farm_plants WHERE plantid = @plantid', { ['@plantid'] = id })

    if not result[1] then return end

    local newData = json.encode(data)
    MySQL.Async.execute('UPDATE rex_farm_plants SET properties = @properties WHERE plantid = @id', { ['@properties'] = newData, ['@id'] = id })
end)

-- remove plant
RegisterServerEvent('rex-farming:server:PlantRemoved')
AddEventHandler('rex-farming:server:PlantRemoved', function(plantId)
    local result = MySQL.query.await('SELECT * FROM rex_farm_plants')

    if not result then return end

    for i = 1, #result do
        local plantData = json.decode(result[i].properties)

        if plantData.id == plantId then
            MySQL.Async.execute('DELETE FROM rex_farm_plants WHERE id = @id', { ['@id'] = result[i].id })
            for k, v in pairs(Config.FarmPlants) do
                if v.id == plantId then
                    table.remove(Config.FarmPlants, k)
                end
            end
        end
    end
end)

-- get plant
RegisterServerEvent('rex-farming:server:getPlants')
AddEventHandler('rex-farming:server:getPlants', function()
    local result = MySQL.query.await('SELECT * FROM rex_farm_plants')

    if not result[1] then return end

    for i = 1, #result do
        local plantData = json.decode(result[i].properties)
        print('loading '..plantData.planttype..' plant with ID: '..plantData.id)
        table.insert(Config.FarmPlants, plantData)
    end
end)

-- give farmer collected water/fertilizer
RegisterServerEvent('rex-farming:server:giveitem')
AddEventHandler('rex-farming:server:giveitem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, amount)
    if item == 'fullbucket' then
        Player.Functions.RemoveItem('bucket', 1)
    end
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'add')
end)

-- collected fertilizer
RegisterNetEvent('rex-farming:server:collectedfertilizer')
AddEventHandler('rex-farming:server:collectedfertilizer', function(coords)
    local exists = false

    for i = 1, #CollectedFertilizer do
        local fertilizer = CollectedFertilizer[i]
        if fertilizer == coords then
            exists = true
            break
        end
    end

    if not exists then
        CollectedFertilizer[#CollectedFertilizer + 1] = coords
    end

end)

RSGCore.Functions.CreateCallback('rex-farming:server:checkcollectedfertilizer', function(source, cb, coords)
    local exists = false
    for i = 1, #CollectedFertilizer do
        local fertilizer = CollectedFertilizer[i]

        if fertilizer == coords then
            exists = true
            break
        end
    end
    cb(exists)
end)

-- plant timer
CreateThread(function()
    while true do
        Wait(Config.GrowthTimer)

        for i = 1, #Config.FarmPlants do
            if Config.FarmPlants[i].growth < 100 then
                if Config.FarmPlants[i].grace then
                    Config.FarmPlants[i].grace = false
                else
                    Config.FarmPlants[i].thirst = Config.FarmPlants[i].thirst - 1
                    Config.FarmPlants[i].hunger = Config.FarmPlants[i].hunger - 1
                    Config.FarmPlants[i].growth = Config.FarmPlants[i].growth + 1

                    if Config.FarmPlants[i].growth > 100 then
                        Config.FarmPlants[i].growth = 100
                    end

                    if Config.FarmPlants[i].hunger < 0 then
                        Config.FarmPlants[i].hunger = 0
                    end

                    if Config.FarmPlants[i].thirst < 0 then
                        Config.FarmPlants[i].thirst = 0
                    end

                    if Config.FarmPlants[i].quality < 25 then
                        Config.FarmPlants[i].quality = 25
                    end

                    if Config.FarmPlants[i].thirst < 75 or Config.FarmPlants[i].hunger < 75 then
                        Config.FarmPlants[i].quality = Config.FarmPlants[i].quality - 1
                    end
                end
            else
                local untildead = Config.FarmPlants[i].planttime + Config.DeadPlantTime
                local currenttime = os.time()

                if currenttime > untildead then
                    local deadid = Config.FarmPlants[i].id

                    print('Removing Dead Plant with ID '..deadid)

                    TriggerEvent('rex-farming:server:PlantRemoved', deadid)
                end
            end

            TriggerEvent('rex-farming:server:updateFarmPlants', Config.FarmPlants[i].id, Config.FarmPlants[i])
        end

        TriggerEvent('rex-farming:server:updatePlants')
    end
end)


RegisterNetEvent('rex-farming:server:OpenStash', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    exports['rsg-inventory']:CreateShop({
        name = data.name,
        label = data.label,
        slot = data.slot,
        items = data.items
    })
    exports['rsg-inventory']:OpenShop(source, data.name)
end)

exports['rsg-core']:AddItem('fullbucket', {
    name = 'fullbucket',
    label = 'full bucket',
    weight = 10,
    type = 'item',
    image = 'water_bottle.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'For all the thirsty out there'
})
