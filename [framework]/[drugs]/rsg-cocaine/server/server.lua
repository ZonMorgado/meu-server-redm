local RSGcore = exports['rsg-core']:GetCoreObject()
local PlantsLoaded = false

-- use seed
RSGcore.Functions.CreateUseableItem("cocaineseed", function(source, item)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    TriggerClientEvent('rsg-cocaine:client:plantNewSeed', src, 'cocaine')
    Player.Functions.RemoveItem('cocaineseed', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaineseed'], "remove")
end)

-- use cocainebag
RSGcore.Functions.CreateUseableItem("cocainebag", function(source, item)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    TriggerClientEvent('rsg-cocaine:client:SmokeCocaine', src)
end)

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        if PlantsLoaded then
            TriggerClientEvent('rsg-cocaine:client:updatePlantData', -1, Config.Plants)
        end
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('rsg-cocaine:server:getPlants')
    PlantsLoaded = true
end)

RegisterServerEvent('rsg-cocaine:server:savePlant')
AddEventHandler('rsg-cocaine:server:savePlant', function(data, plantId)
    local data = json.encode(data)
    MySQL.Async.execute('INSERT INTO cocaine_plants (properties, plantid) VALUES (@properties, @plantid)', {
        ['@properties'] = data,
        ['@plantid'] = plantId
    })
end)

-- give seed
RegisterServerEvent('rsg-cocaine:server:giveSeed')
AddEventHandler('rsg-cocaine:server:giveSeed', function()
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    Player.Functions.AddItem('cocaineseed', math.random(1, 2))
    TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaineseed'], "add")
end)

-- plant seed
RegisterServerEvent('rsg-cocaine:server:plantNewSeed')
AddEventHandler('rsg-cocaine:server:plantNewSeed', function(type, location)
    local src = source
    local plantId = math.random(111111, 999999)
    local Player = RSGcore.Functions.GetPlayer(src)
    local SeedData = {
        id = plantId, 
        type = type, 
        x = location.x, 
        y = location.y, 
        z = location.z, 
        hunger = Config.StartingHunger, 
        thirst = Config.StartingThirst, 
        growth = 0.0, 
        quality = 100.0, 
        grace = true, 
        beingHarvested = false, 
        planter = Player.PlayerData.citizenid,
        planttime = os.time(),
    }

    local PlantCount = 0

    for k, v in pairs(Config.Plants) do
        if v.planter == Player.PlayerData.citizenid then
            PlantCount = PlantCount + 1
        end
    end

    if PlantCount >= Config.MaxPlantCount then
        local dbs = {
            title = 'Cocaine',
            description = 'You already have ' .. Config.MaxPlantCount .. ' plants down',
            type = 'error',
            duration = 3000,
            position = "center-right",
        }
        TriggerClientEvent('ox_lib:notify', source, dbs)

        --TriggerClientEvent('RSGcore:Notify', src, 'You already have ' .. Config.MaxPlantCount .. ' plants down', 'error')
    else
        table.insert(Config.Plants, SeedData)
        TriggerEvent('rsg-cocaine:server:savePlant', SeedData, plantId)
        TriggerEvent('rsg-cocaine:server:updatePlants')
    end
end)

-- check plant
RegisterServerEvent('rsg-cocaine:server:plantHasBeenHarvested')
AddEventHandler('rsg-cocaine:server:plantHasBeenHarvested', function(plantId)
    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            v.beingHarvested = true
        end
    end
    TriggerEvent('rsg-cocaine:server:updatePlants')
end)

-- distory plant (police)
RegisterServerEvent('rsg-cocaine:server:destroyPlant')
AddEventHandler('rsg-cocaine:server:destroyPlant', function(plantId)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            table.remove(Config.Plants, k)
        end
    end
    TriggerClientEvent('rsg-cocaine:client:removePlantObject', src, plantId)
    TriggerEvent('rsg-cocaine:server:PlantRemoved', plantId)
    TriggerEvent('rsg-cocaine:server:updatePlants')
    --TriggerClientEvent('RSGcore:Notify', src, 'you destroyed the plant', 'success')

    local dbs = {
        title = 'Cocaine',
        description = 'You destroyed the plant',
        type = 'success',
        duration = 3000,
        position = "center-right",
    }
    TriggerClientEvent('ox_lib:notify', source, dbs)
end)

-- harvest plant
RegisterServerEvent('rsg-cocaine:server:harvestPlant')
AddEventHandler('rsg-cocaine:server:harvestPlant', function(plantId)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    local amount
    local label
    local item
    local poorQuality = false
    local goodQuality = false
    local exellentQuality = false
    local hasFound = false

    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            for y = 1, #Config.YieldRewards do
                if v.type == Config.YieldRewards[y].type then
                    label = Config.YieldRewards[y].label
                    item = Config.YieldRewards[y].item
                    amount = math.random(Config.YieldRewards[y].rewardMin, Config.YieldRewards[y].rewardMax)
                    local quality = math.ceil(v.quality)
                    hasFound = true
                    table.remove(Config.Plants, k)
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
    if hasFound then        
        if poorQuality then
            local pooramount = math.random(1,3)
            Player.Functions.AddItem('cocaine', pooramount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaine'], "add")
            local dbs = {
                title = 'Cocaine',
                description = 'You harvest '.. pooramount ..' Cocaine Leaf',
                type = 'success',
                duration = 3000,
                position = "center-right",
            }
            TriggerClientEvent('ox_lib:notify', source, dbs)
            --TriggerClientEvent('RSGcore:Notify', src, 'You harvest '.. pooramount ..' Cocaine Leaf', 'success')
            Player.Functions.SetMetaData("dealerrep", Player.PlayerData.metadata["dealerrep"] + pooramount)
            Wait(5000)
            TriggerEvent('rsg-cocaine:server:dealerrep', src)
        elseif goodQuality then
            local goodamount = math.random(3,6)
            Player.Functions.AddItem('cocaine', goodamount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaine'], "add")
            --TriggerClientEvent('RSGcore:Notify', src, 'You harvest '.. goodamount ..' Cocaine Leaf', 'success')
            Player.Functions.SetMetaData("dealerrep", Player.PlayerData.metadata["dealerrep"] + goodamount)
            Wait(5000)
            TriggerEvent('rsg-cocaine:server:dealerrep', src)
        elseif exellentQuality then
            local exellentamount = math.random(6,12)
            Player.Functions.AddItem('cocaine', exellentamount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaine'], "add")
            Player.Functions.AddItem('cocaineseed', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaineseed'], "add")
            --TriggerClientEvent('RSGcore:Notify', src, 'You harvest '.. exellentamount ..' Cocaine Leaf', 'success')
            Player.Functions.SetMetaData("dealerrep", Player.PlayerData.metadata["dealerrep"] + exellentamount)
            Wait(5000)
            TriggerEvent('rsg-cocaine:server:dealerrep', src)
        else
            print("something went wrong!")
        end
        TriggerClientEvent('rsg-cocaine:client:removePlantObject', src, plantId)
        TriggerEvent('rsg-cocaine:server:PlantRemoved', plantId)
        TriggerEvent('rsg-cocaine:server:updatePlants')
    end
end)

RegisterServerEvent('rsg-cocaine:server:updatePlants')
AddEventHandler('rsg-cocaine:server:updatePlants', function()
    local src = source
    TriggerClientEvent('rsg-cocaine:client:updatePlantData', src, Config.Plants)
end)

-- water plant
RegisterServerEvent('rsg-cocaine:server:waterPlant')
AddEventHandler('rsg-cocaine:server:waterPlant', function(plantId)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            Config.Plants[k].thirst = Config.Plants[k].thirst + Config.ThirstIncrease
            if Config.Plants[k].thirst > 100.0 then
                Config.Plants[k].thirst = 100.0
            end
        end
    end
    Player.Functions.RemoveItem('water', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['water'], "remove")
    TriggerEvent('rsg-cocaine:server:updatePlants')
end)

-- feed plant
RegisterServerEvent('rsg-cocaine:server:feedPlant')
AddEventHandler('rsg-cocaine:server:feedPlant', function(plantId)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            Config.Plants[k].hunger = Config.Plants[k].hunger + Config.HungerIncrease
            if Config.Plants[k].hunger > 100.0 then
                Config.Plants[k].hunger = 100.0
            end
        end
    end
    Player.Functions.RemoveItem('fertilizer', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['fertilizer'], "remove")
    TriggerEvent('rsg-cocaine:server:updatePlants')
end)

-- update plant
RegisterServerEvent('rsg-cocaine:server:updateCocainePlants')
AddEventHandler('rsg-cocaine:server:updateCocainePlants', function(id, data)
    local result = MySQL.query.await('SELECT * FROM cocaine_plants WHERE plantid = @plantid', {
        ['@plantid'] = id
    })
    if result[1] then
        local newData = json.encode(data)
        MySQL.Async.execute('UPDATE cocaine_plants SET properties = @properties WHERE plantid = @id', {
            ['@properties'] = newData,
            ['@id'] = id
        })
    end
end)

-- remove plant
RegisterServerEvent('rsg-cocaine:server:PlantRemoved')
AddEventHandler('rsg-cocaine:server:PlantRemoved', function(plantId)
    local result = MySQL.query.await('SELECT * FROM cocaine_plants')
    if result then
        for i = 1, #result do
            local plantData = json.decode(result[i].properties)
            if plantData.id == plantId then
                MySQL.Async.execute('DELETE FROM cocaine_plants WHERE id = @id', {
                    ['@id'] = result[i].id
                })
                for k, v in pairs(Config.Plants) do
                    if v.id == plantId then
                        table.remove(Config.Plants, k)
                    end
                end
            end
        end
    end
end)

-- get plant
RegisterServerEvent('rsg-cocaine:server:getPlants')
AddEventHandler('rsg-cocaine:server:getPlants', function()
    local data = {}
    local result = MySQL.query.await('SELECT * FROM cocaine_plants')
    if result[1] then
        for i = 1, #result do
            local plantData = json.decode(result[i].properties)
            print('loading cocaine plant with ID: '..plantData.id)
            table.insert(Config.Plants, plantData)
        end
    end
end)

-- plant timer
Citizen.CreateThread(function()
    while true do
        Wait(Config.GrowthTimer)
        for i = 1, #Config.Plants do
            if Config.Plants[i].growth < 100 then
                if Config.Plants[i].grace then
                    Config.Plants[i].grace = false
                else
                    Config.Plants[i].thirst = Config.Plants[i].thirst - 1
                    Config.Plants[i].hunger = Config.Plants[i].hunger - 1
                    Config.Plants[i].growth = Config.Plants[i].growth + 1

                    if Config.Plants[i].growth > 100 then
                        Config.Plants[i].growth = 100
                    end

                    if Config.Plants[i].hunger < 0 then
                        Config.Plants[i].hunger = 0
                    end

                    if Config.Plants[i].thirst < 0 then
                        Config.Plants[i].thirst = 0
                    end

                    if Config.Plants[i].quality < 25 then
                        Config.Plants[i].quality = 25
                    end

                    if Config.Plants[i].thirst < 75 or Config.Plants[i].hunger < 75 then
                        Config.Plants[i].quality = Config.Plants[i].quality - 1
                    end
                end
            else
                local untildead = Config.Plants[i].planttime + Config.DeadPlantTime
                local currenttime = os.time()
                if currenttime > untildead then
                    deadid = Config.Plants[i].id
                    print('Removing Dead Plant with ID '..deadid)
                    TriggerEvent('rsg-cocaine:server:PlantRemoved', deadid)
                end
            end
            TriggerEvent('rsg-cocaine:server:updateCocainePlants', Config.Plants[i].id, Config.Plants[i])
        end
        TriggerEvent('rsg-cocaine:server:updatePlants')
    end
end)

-- check your dealer reputation
RSGcore.Commands.Add("dealerrep", "check your dealer reputation ", {}, false, function(source)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    local curRep = Player.PlayerData.metadata["dealerrep"]
    --TriggerClientEvent('RSGcore:Notify', src, 'Your dealer reputation is '.. curRep, 'primary')
    local dbs = {
        title = 'Cocaine',
        description = 'Your dealer reputation is '.. curRep,
        type = 'success',
        duration = 3000,
        position = "center-right",
    }
    TriggerClientEvent('ox_lib:notify', source, dbs)
end)

-- used by harvest to show new dealer reputation
RegisterServerEvent('rsg-cocaine:server:dealerrep')
AddEventHandler('rsg-cocaine:server:dealerrep', function(source)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    local curRep = Player.PlayerData.metadata["dealerrep"]
    --TriggerClientEvent('RSGcore:Notify', src, 'Your dealer reputation increased to '.. curRep, 'primary')

    local dbs = {
        title = 'Cocaine',
        description = 'Your dealer reputation increased to '.. curRep,
        type = 'success',
        duration = 3000,
        position = "center-right",
    }
    TriggerClientEvent('ox_lib:notify', source, dbs)
end)

-- trade cocaine
RegisterServerEvent('rsg-cocaine:server:tradecocaine')
AddEventHandler('rsg-cocaine:server:tradecocaine', function(data) -- 1 / 5 / 10
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    local checkcocaine = Player.Functions.GetItemByName("cocaine")
    local trade = data.trade
    if checkcocaine ~= nil then
        local playercocaine = Player.Functions.GetItemByName('cocaine').amount
        --print(trade)
        if trade == 1 then
            if playercocaine >= 10 then
                Player.Functions.RemoveItem('cocaine', 10)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaine'], "remove")
                Player.Functions.AddItem('cocainebag', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocainebag'], "remove")
            else
                --riggerClientEvent('RSGcore:Notify', src, 'You don\'t have enough Cocaine to do that!', 'error')
                    local dbs = {
                        title = 'Cocaine',
                        description = 'You don\'t have enough Cocaine to do that!',
                        type = 'error',
                        duration = 3000,
                        position = "center-right",
                    }
                    TriggerClientEvent('ox_lib:notify', source, dbs)   
            end
        elseif trade == 5 then
            if playercocaine >= 50 then
                Player.Functions.RemoveItem('cocaine', 50)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaine'], "remove")
                Player.Functions.AddItem('cocainebag', 5)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocainebag'], "remove")
            else
                --TriggerClientEvent('RSGcore:Notify', src, 'You don\'t have enough cocaine leaves to do that!', 'error')
                    local dbs = {
                        title = 'Cocaine',
                        description = 'You don\'t have enough cocaine leaves to do that!',
                        type = 'error',
                        duration = 3000,
                        position = "center-right",
                    }
                    TriggerClientEvent('ox_lib:notify', source, dbs)  
            end
        elseif trade == 10 then
            if playercocaine >= 100 then
                Player.Functions.RemoveItem('cocaine', 100)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocaine'], "remove")
                Player.Functions.AddItem('cocainebag', 10)
                TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items['cocainebag'], "remove")
            else
                --TriggerClientEvent('RSGcore:Notify', src, 'You don\'t have enough cocaineleaves to do that!', 'error')
                    local dbs = {
                        title = 'Cocaine',
                        description = 'You don\'t have enough cocaineleaves to do that!',
                        type = 'error',
                        duration = 3000,
                        position = "center-right",
                    }
                    TriggerClientEvent('ox_lib:notify', source, dbs) 
            end
        else
            --TriggerClientEvent('RSGcore:Notify', src, 'not enough to complete the trade!', 'error')
            local dbs = {
                title = 'Cocaine',
                description = 'not enough to complete the trade!',
                type = 'error',
                duration = 3000,
                position = "center-right",
            }
            TriggerClientEvent('ox_lib:notify', source, dbs) 
        end
    else
        --TriggerClientEvent('RSGcore:Notify', src, 'You do not have any cocaine leaves!', 'error')
            local dbs = {
                title = 'Cocaine',
                description = 'You do not have any cocaine leaves!',
                type = 'error',
                duration = 3000,
                position = "center-right",
            }
            TriggerClientEvent('ox_lib:notify', source, dbs)     
    end
end)

-- remove item
RegisterServerEvent('rsg-cocaine:server:removeitem')
AddEventHandler('rsg-cocaine:server:removeitem', function(item, amount)
    local src = source
    local Player = RSGcore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGcore.Shared.Items[item], "remove")
end)
