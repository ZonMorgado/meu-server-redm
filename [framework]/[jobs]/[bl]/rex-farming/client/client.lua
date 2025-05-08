local RSGCore = exports['rsg-core']:GetCoreObject()
local isBusy = false
local SpawnedPlants = {}
local HarvestedPlants = {}
local canHarvest = true

---------------------------------------------
-- spawn plants and setup target
---------------------------------------------
CreateThread(function()
    while true do
        Wait(150)

        local pos = GetEntityCoords(cache.ped)
        local InRange = false

        for i = 1, #Config.FarmPlants do
            local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.FarmPlants[i].x, Config.FarmPlants[i].y, Config.FarmPlants[i].z, true)

            if dist >= 50.0 then goto continue end

            local hasSpawned = false
            InRange = true

            for z = 1, #SpawnedPlants do
                local p = SpawnedPlants[z]

                if p.id == Config.FarmPlants[i].id then
                    hasSpawned = true
                end
            end

            if hasSpawned then goto continue end

            local planthash = Config.FarmPlants[i].hash
            local phash = GetHashKey(planthash)
            local data = {}

            while not HasModelLoaded(phash) do
                Wait(10)
                RequestModel(phash)
            end

            RequestModel(phash)
            data.id = Config.FarmPlants[i].id
            data.obj = CreateObject(phash, Config.FarmPlants[i].x, Config.FarmPlants[i].y, Config.FarmPlants[i].z, false, false, false)
            SetEntityHeading(data.obj, Config.FarmPlants[i].h)
            SetEntityAsMissionEntity(data.obj, true)
            PlaceObjectOnGroundProperly(data.obj)
            Wait(1000)
            FreezeEntityPosition(data.obj, true)
            SetModelAsNoLongerNeeded(data.obj)

            -- veg modifiy
            local veg_modifier_sphere = 0
            
            if veg_modifier_sphere == nil or veg_modifier_sphere == 0 then
                local veg_radius = 3.0
                local veg_Flags =  1 + 2 + 4 + 8 + 16 + 32 + 64 + 128 + 256
                local veg_ModType = 1
                veg_modifier_sphere = Citizen.InvokeNative(0xFA50F79257745E74, Config.FarmPlants[i].x, Config.FarmPlants[i].y, Config.FarmPlants[i].z, veg_radius, veg_ModType, veg_Flags, 0)
            else
                Citizen.InvokeNative(0x9CF1836C03FB67A2, Citizen.PointerValueIntInitialized(veg_modifier_sphere), 0)
                veg_modifier_sphere = 0
            end

            SpawnedPlants[#SpawnedPlants + 1] = data
            hasSpawned = false

            -- create target for the entity
            exports['rsg-target']:AddTargetEntity(data.obj, {
                options = {
                    {
                        type = 'client',
                        event = 'rex-farming:client:plantmenu',
                        icon = 'fa-solid fa-seedling',
                        label = 'Farmer Menu',
                        action = function()
                            TriggerEvent('rex-farming:client:plantmenu', data.id)
                        end
                    },
                },
                distance = 3
            })
            -- end of target

            ::continue::
        end

        if not InRange then
            Wait(5000)
        end
    end
end)

---------------------------------------------
-- plant menu
---------------------------------------------
RegisterNetEvent('rex-farming:client:plantmenu', function(id)

    RSGCore.Functions.TriggerCallback('rex-farming:server:getplantdata', function(result)
        
        local plantdata = json.decode(result[1].properties)

        -- hunger hungerColorScheme
        if plantdata.hunger > 50 then hungerColorScheme = 'green' end
        if plantdata.hunger <= 50 and plantdata.hunger > 10 then hungerColorScheme = 'yellow' end
        if plantdata.hunger <= 10 then hungerColorScheme = 'red' end

        -- thirst colorScheme
        if plantdata.thirst > 50 then thirstColorScheme = 'green' end
        if plantdata.thirst <= 50 and plantdata.thirst > 10 then thirstColorScheme = 'yellow' end
        if plantdata.thirst <= 10 then thirstColorScheme = 'red' end

        -- quality colorScheme
        if plantdata.quality > 50 then qualityColorScheme = 'green' end
        if plantdata.quality <= 50 and plantdata.quality > 10 then qualityColorScheme = 'yellow' end
        if plantdata.quality <= 10 then qualityColorScheme = 'red' end

        lib.registerContext({
            id = 'plant_menu',
            title = 'Plant Menu',
            options = {
                {
                    title = 'Growth : '..plantdata.growth,
                    progress = plantdata.growth,
                    colorScheme = 'green',
                    icon = 'fa-solid fa-hashtag',
                },
                {
                    title = 'Condition : '..plantdata.quality,
                    progress = plantdata.quality,
                    colorScheme = qualityColorScheme,
                    icon = 'fa-solid fa-hashtag',
                },
                {
                    title = 'Hunger : '..plantdata.hunger,
                    progress = plantdata.hunger,
                    colorScheme = hungerColorScheme,
                    icon = 'fa-solid fa-hashtag',
                },
                {
                    title = 'Thirst : '..plantdata.thirst,
                    progress = plantdata.thirst,
                    colorScheme = thirstColorScheme,
                    icon = 'fa-solid fa-hashtag',
                },
                {
                    title = 'Water Plant',
                    icon = 'fa-solid fa-droplet',
                    iconColor = '#74C0FC',
                    event = 'rex-farming:client:waterplant',
                    args = { plantid = plantdata.id },
                    arrow = true
                },
                {
                    title = 'Feed Plant',
                    icon = 'fa-solid fa-poop',
                    iconColor = '#D98880',
                    event = 'rex-farming:client:feedplant',
                    args = { plantid = plantdata.id },
                    arrow = true
                },
                {
                    title = 'Havest Plant',
                    icon = 'fa-solid fa-seedling',
                    iconColor = 'green',
                    event = 'rex-farming:client:harvestplant',
                    args = { plantid = plantdata.id, growth = plantdata.growth },
                    arrow = true
                },
            }
        })
        lib.showContext('plant_menu')

    end, id)

end)

---------------------------------------------
-- water plant
---------------------------------------------
RegisterNetEvent('rex-farming:client:waterplant', function(data)

    local hasItem = RSGCore.Functions.HasItem('fullbucket', 1)

    if hasItem and not isBusy then
        isBusy = true
        LocalPlayer.state:set("inv_busy", true, true)
        FreezeEntityPosition(cache.ped, true)
        Citizen.InvokeNative(0x5AD23D40115353AC, cache.ped, entity, -1)
        TaskStartScenarioInPlace(cache.ped, `WORLD_HUMAN_BUCKET_POUR_LOW`, 0, true)
        Wait(10000)
        ClearPedTasks(cache.ped)
        SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
        FreezeEntityPosition(cache.ped, false)
        TriggerServerEvent('rex-farming:server:waterPlant', data.plantid)
        LocalPlayer.state:set("inv_busy", false, true)
        isBusy = false
    else
        lib.notify({ title = 'Full Bucket Required', type = 'error', duration = 7000 })
    end

end)

---------------------------------------------
-- feed plants
---------------------------------------------
RegisterNetEvent('rex-farming:client:feedplant', function(data)

    local hasItem1 = RSGCore.Functions.HasItem('bucket', 1)
    local hasItem2 = RSGCore.Functions.HasItem('fertilizer', 1)

    if hasItem1 and hasItem2 and not isBusy then
        isBusy = true
        LocalPlayer.state:set("inv_busy", true, true)
        FreezeEntityPosition(cache.ped, true)
        Citizen.InvokeNative(0x5AD23D40115353AC, cache.ped, entity, -1)
        TaskStartScenarioInPlace(cache.ped, `WORLD_HUMAN_FEED_PIGS`, 0, true)
        Wait(14000)
        ClearPedTasks(cache.ped)
        SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
        FreezeEntityPosition(cache.ped, false)
        TriggerServerEvent('rex-farming:server:feedPlant', data.plantid)
        LocalPlayer.state:set("inv_busy", false, true)
        isBusy = false
    else
        lib.notify({ title = 'Bucket & Fertilizer Required', type = 'error', duration = 7000 })
    end

end)

---------------------------------------------
-- havest plants
---------------------------------------------
RegisterNetEvent('rex-farming:client:harvestplant', function(data)

    if data.growth < 100 then
        lib.notify({ title = 'Plant is not fully grown yet', type = 'error', duration = 7000 })
        return
    end

    if not isBusy then
        isBusy = true
        LocalPlayer.state:set("inv_busy", true, true)
        table.insert(HarvestedPlants, data.plantid)
        TriggerServerEvent('rex-farming:server:plantHasBeenHarvested', data.plantid)
        TaskStartScenarioInPlace(cache.ped, `WORLD_HUMAN_CROUCH_INSPECT`, 0, true)
        Wait(10000)
        ClearPedTasks(cache.ped)
        SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
        FreezeEntityPosition(cache.ped, false)
        TriggerServerEvent('rex-farming:server:harvestPlant', data.plantid)
        LocalPlayer.state:set("inv_busy", false, true)
        isBusy = false
        canHarvest = true
    end

end)

---------------------------------------------
-- update plant data
---------------------------------------------
RegisterNetEvent('rex-farming:client:updatePlantData')
AddEventHandler('rex-farming:client:updatePlantData', function(data)
    Config.FarmPlants = data
end)

---------------------------------------------
-- plant seeds
---------------------------------------------
RegisterNetEvent('rex-farming:client:plantnewseed')
AddEventHandler('rex-farming:client:plantnewseed', function(outputitem, inputitem, PropHash, pPos, heading)

    local pos = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 1.0, 0.0)

    if Config.RestrictTowns then
        if CanPlantSeedHere(pos) and not IsPedInAnyVehicle(cache.ped, false) and not isBusy then
            isBusy = true
            LocalPlayer.state:set("inv_busy", true, true)
            local anim1 = `WORLD_HUMAN_FARMER_RAKE`
            local anim2 = `WORLD_HUMAN_FARMER_WEEDING`

            FreezeEntityPosition(cache.ped, true)

            if not IsPedMale(cache.ped) then
                anim1 = `WORLD_HUMAN_CROUCH_INSPECT`
                anim2 = `WORLD_HUMAN_CROUCH_INSPECT`
            end

            TaskStartScenarioInPlace(cache.ped, anim1, 0, true)
            Wait(10000)
            ClearPedTasks(cache.ped)
            SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
            TaskStartScenarioInPlace(cache.ped, anim2, 0, true)
            Wait(20000)
            ClearPedTasks(cache.ped)
            SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
            FreezeEntityPosition(cache.ped, false)
            TriggerServerEvent('rex-farming:server:removeitem', inputitem, 1)
            TriggerServerEvent('rex-farming:server:plantnewseed', outputitem, PropHash, pPos, heading)
            LocalPlayer.state:set("inv_busy", false, true)
            isBusy = false
            return
        end
        lib.notify({ title = 'Can\'t plant that here!', type = 'error', duration = 7000 })
    else
        if not IsPedInAnyVehicle(cache.ped, false) and not isBusy then
            isBusy = true
            LocalPlayer.state:set("inv_busy", true, true)
            local anim1 = `WORLD_HUMAN_FARMER_RAKE`
            local anim2 = `WORLD_HUMAN_FARMER_WEEDING`

            FreezeEntityPosition(cache.ped, true)

            if not IsPedMale(cache.ped) then
                anim1 = `WORLD_HUMAN_CROUCH_INSPECT`
                anim2 = `WORLD_HUMAN_CROUCH_INSPECT`
            end

            TaskStartScenarioInPlace(cache.ped, anim1, 0, true)
            Wait(10000)
            ClearPedTasks(cache.ped)
            SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
            TaskStartScenarioInPlace(cache.ped, anim2, 0, true)
            Wait(20000)
            ClearPedTasks(cache.ped)
            SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
            FreezeEntityPosition(cache.ped, false)
            TriggerServerEvent('rex-farming:server:removeitem', inputitem, 1)
            TriggerServerEvent('rex-farming:server:plantnewseed', outputitem, PropHash, pPos, heading)
            LocalPlayer.state:set("inv_busy", false, true)
            isBusy = false
            return
        end
    end

end)

---------------------------------------------
-- can plant here function
---------------------------------------------
function CanPlantSeedHere(pos)
    local canPlant = true

    local ZoneTypeId = 1
    local x,y,z =  table.unpack(GetEntityCoords(cache.ped))
    local town = Citizen.InvokeNative(0x43AD8FC02B429D33, x,y,z, ZoneTypeId)
    if town ~= false then
        canPlant = false
    end

    for i = 1, #Config.FarmPlants do
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.FarmPlants[i].x, Config.FarmPlants[i].y, Config.FarmPlants[i].z, true) < 1.3 then
            canPlant = false
        end
    end
    
    return canPlant
end

---------------------------------------------
-- farm shop blips
---------------------------------------------
CreateThread(function()
    for _,v in pairs(Config.FarmShopLocations) do
        if v.showblip then
            local FarmShopBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(FarmShopBlip, joaat(Config.Blip.blipSprite), true)
            SetBlipScale(FarmShopBlip, Config.Blip.blipScale)
            SetBlipName(FarmShopBlip, Config.Blip.blipName)
        end
    end
end)

---------------------------------------------
-- open farm shop
---------------------------------------------
RegisterNetEvent('rex-farming:client:OpenFarmShop')
AddEventHandler('rex-farming:client:OpenFarmShop', function()
    local ShopItems = {}
    ShopItems.name = "Farm Shop"
    ShopItems.label = "Farm Shop"
    ShopItems.items = Config.FarmShop
    ShopItems.slots = #Config.FarmShop
    TriggerServerEvent("rex-farming:server:OpenStash", ShopItems)
end)



---------------------------------------------
-- remove plant object
---------------------------------------------
RegisterNetEvent('rex-farming:client:removePlantObject')
AddEventHandler('rex-farming:client:removePlantObject', function(plant)
    for i = 1, #SpawnedPlants do
        local o = SpawnedPlants[i]

        if o.id == plant then
            SetEntityAsMissionEntity(o.obj, false)
            FreezeEntityPosition(o.obj, false)
            DeleteObject(o.obj)
        end
    end
end)

---------------------------------------------
-- cleanup
---------------------------------------------
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for i = 1, #SpawnedPlants do
        local plants = SpawnedPlants[i].obj

        SetEntityAsMissionEntity(plants, false)
        FreezeEntityPosition(plants, false)
        DeleteObject(plants)
    end
end)
