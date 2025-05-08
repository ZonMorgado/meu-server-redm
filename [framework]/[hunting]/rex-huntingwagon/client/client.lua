local RSGCore = exports['rsg-core']:GetCoreObject()
local hutingwagonspawned = false
local currentHuntingWagon = nil
local currentHuntingPlate = nil
local closestWagonStore = nil
local showingprompt = false
local wagonBlip = nil
lib.locale()

-------------------------------------------------------------------------------------------
-- blips
-------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for _, v in pairs(Config.HunterLocations) do
        if v.showblip == true then
            local HunterBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(HunterBlip,  joaat(Config.Blip.blipSprite), true)
            SetBlipScale(Config.Blip.blipScale, 0.2)
            SetBlipName(HunterBlip, Config.Blip.blipName)
        end
    end
end)

-------------------------------------------------------------------------------------------
-- hunter camp main menu
-------------------------------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:openhuntermenu', function(location, wagonspawn)

    lib.registerContext({
        id = 'hunter_mainmenu',
        title = locale('cl_lang_2'),
        options = {
            {
                title = locale('cl_lang_3')..Config.WagonPrice..')',
                description = locale('cl_lang_4'),
                icon = 'fa-solid fa-horse-head',
                serverEvent = 'rex-huntingwagon:server:buyhuntingcart',
                args = { huntingcamp = location },
                arrow = true
            },
            {
                title = locale('cl_lang_5'),
                description = locale('cl_lang_6'),
                icon = 'fa-solid fa-eye',
                event = 'rex-huntingwagon:client:spawnwagon',
                args = { huntingcamp = location, spawncoords = wagonspawn },
                arrow = true
            },
            {
                title = locale('cl_lang_39'),
                icon = 'fa-solid fa-basket-shopping',
                event = 'rex-huntingwagon:client:openshop',
                arrow = true
            },
        }
    })
    lib.showContext('hunter_mainmenu')

end)

---------------------------------------------------------------------
-- get wagon
---------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:spawnwagon', function(data)
    RSGCore.Functions.TriggerCallback('rex-huntingwagon:server:getwagons', function(results)
        if results == nil then return lib.notify({ title = locale('cl_lang_7'), description = locale('cl_lang_8'), type = 'inform', duration = 5000 }) end
        if hutingwagonspawned then return lib.notify({ title = locale('cl_lang_9'), description = locale('cl_lang_10'), type = 'error', duration = 5000 }) end
        
        local options = {}
        for i = 1, #results do
            local wagon = results[i]
            table.insert(options, {
                title = locale('cl_lang_42') .. wagon.plate,
                description = wagon.huntingcamp .. (wagon.damaged == 1 and locale('cl_lang_43') or ''),
                event = 'rex-huntingwagon:client:spawnSelectedWagon',
                args = { wagon = wagon, spawncoords = data.spawncoords }
            })
        end

        if #options == 0 then
            return lib.notify({ title = locale('cl_lang_14'), description = locale('cl_lang_15'), type = 'inform', duration = 5000 })
        end

        lib.registerContext({
            id = 'wagon_selection_menu',
            title = locale('cl_lang_44'),
            options = options
        })
        lib.showContext('wagon_selection_menu')
    end)
end)

RegisterNetEvent('rex-huntingwagon:client:spawnSelectedWagon', function(data)
    local wagon = data.wagon
    if wagon.damaged == 1 then
        lib.notify({ title = locale('cl_lang_12'), description = locale('cl_lang_13'), type = 'error', duration = 5000 })
        TriggerEvent('rex-huntingwagon:client:fixwagon', wagon.plate)
        return
    end

    local carthash = joaat('huntercart01')
    local propset = joaat('pg_mp005_huntingWagonTarp01')
    local lightset = joaat('pg_teamster_cart06_lightupgrade3')

    if wagonBlip then
        RemoveBlip(wagonBlip)
    end

    if IsModelAVehicle(carthash) then
        Citizen.CreateThread(function()
            RequestModel(carthash)
            while not HasModelLoaded(carthash) do
                Citizen.Wait(0)
            end
            local huntingcart = CreateVehicle(carthash, data.spawncoords, true, false)
            Citizen.InvokeNative(0x06FAACD625D80CAA, huntingcart)
            SetVehicleOnGroundProperly(huntingcart)
            currentHuntingWagon = huntingcart
            currentHuntingPlate = wagon.plate
            Wait(200)
            Citizen.InvokeNative(0x75F90E4051CC084C, huntingcart, propset)
            Citizen.InvokeNative(0xC0F0417A90402742, huntingcart, lightset)
            Citizen.InvokeNative(0xF89D82A0582E46ED, huntingcart, 5)
            Citizen.InvokeNative(0x8268B098F6FCA4E2, huntingcart, 2)
            Citizen.InvokeNative(0x06FAACD625D80CAA, huntingcart)

            wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, huntingcart)
            Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, locale('cl_lang_45')..'('..wagon.plate..')')

            SetEntityVisible(huntingcart, true)
            SetModelAsNoLongerNeeded(carthash)

            Wait(1000)

            -- set hunting wagon tarp
            RSGCore.Functions.TriggerCallback('rex-huntingwagon:server:gettarpinfo', function(results)
                local percentage = results * Config.TotalAnimalsStored / 100
                Citizen.InvokeNative(0x31F343383F19C987, huntingcart, tonumber(percentage), 1)
            end, wagon.plate)

            -- setup target
            exports.ox_target:addLocalEntity(huntingcart, {
                {
                    name = 'hunting_wagon',
                    icon = 'far fa-eye',
                    label = locale('cl_lang_16'),
                    onSelect = function()
                        TriggerEvent('rex-huntingwagon:client:openmenu', wagon.plate)
                    end,
                    distance = Config.TargetDistance
                }
            })

            lib.notify({ title = locale('cl_lang_46'), description = locale('cl_lang_11'), type = 'inform', duration = 5000 })
            hutingwagonspawned = true
        end)
    end
end)
---------------------------------------------------------------------
-- get closest hunter camp to store wagon
---------------------------------------------------------------------
local function SetClosestStoreLocation()
    local pos = GetEntityCoords(cache.ped, true)
    local current = nil
    local dist = nil

    for k, v in pairs(Config.HunterLocations) do
        local dest = vector3(v.coords.x, v.coords.y, v.coords.z)
        local dist2 = #(pos - dest)

        if current then
            if dist2 < dist then
                current = v.location
                dist = dist2
            end
        else
            dist = dist2
            current = v.location
        end
    end

    if current ~= closestWagonStore then
        closestWagonStore = current
    end
end

---------------------------------------------------------------------
-- get wagon state
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if hutingwagonspawned then
            local drivable = Citizen.InvokeNative(0xB86D29B10F627379, currentHuntingWagon, false, false) -- IsVehicleDriveable
            if not drivable then
                lib.notify({ title = locale('cl_lang_17'), description = locale('cl_lang_18'), type = 'inform', duration = 10000 })
                DeleteVehicle(currentHuntingWagon)
                SetEntityAsNoLongerNeeded(currentHuntingWagon)
                hutingwagonspawned = false
                SetClosestStoreLocation()
                TriggerServerEvent('rex-huntingwagon:server:damagedwagon', closestWagonStore, currentHuntingPlate)
                lib.hideTextUI()
            end
        end
    end
end)

---------------------------------------------------------------------
-- store wagon
---------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:storewagon', function(data)
    if hutingwagonspawned then
        DeleteVehicle(currentHuntingWagon)
        SetEntityAsNoLongerNeeded(currentHuntingWagon)
        hutingwagonspawned = false
        SetClosestStoreLocation()
        TriggerServerEvent('rex-huntingwagon:server:updatewagonstore', closestWagonStore, currentHuntingPlate)
        if wagonBlip then
            RemoveBlip(wagonBlip)
        end
    end
end)

---------------------------------------------------------------------
-- hunting wagon menu
---------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:openmenu', function(wagonplate)
    local sellprice = (Config.WagonPrice * Config.WagonSellRate)
    lib.registerContext({
        id = 'hunterwagon_menu',
        title = locale('cl_lang_19'),
        options = {
            {
                title = locale('cl_lang_20'),
                description = locale('cl_lang_21'),
                icon = 'fa-solid fa-circle-down',
                event = 'rex-huntingwagon:client:addanimal',
                args = { plate = wagonplate },
                arrow = true
            },
            {
                title = locale('cl_lang_22'),
                description = locale('cl_lang_23'),
                icon = 'fa-solid fa-circle-up',
                event = 'rex-huntingwagon:client:getHuntingWagonStore',
                args = { plate = wagonplate },
                arrow = true
            },
            {
                title = locale('cl_lang_24'),
                description = locale('cl_lang_25'),
                icon = 'fa-solid fa-box',
                event = 'rex-huntingwagon:client:getHuntingWagonInventory',
                args = { plate = wagonplate },
                arrow = true
            },
            {
                title = locale('cl_lang_26'),
                description = locale('cl_lang_27'),
                icon = 'fa-solid fa-circle-xmark',
                event = 'rex-huntingwagon:client:storewagon',
                arrow = true
            },
            {
                title = locale('cl_lang_28')..sellprice..')',
                description = locale('cl_lang_29'),
                icon = 'fa-solid fa-dollar-sign',
                event = 'rex-huntingwagon:client:sellwagoncheck',
                args = { plate = wagonplate },
                arrow = true
            },
        }
    })
    lib.showContext('hunterwagon_menu')

end)

---------------------------------------------------------------------
-- sell wagon check
---------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:sellwagoncheck', function(data)
    local input = lib.inputDialog(locale('cl_lang_30'), {
        { 
            label = locale('cl_lang_31'),
            type = 'select',
            options = { 
                { value = 'yes', label = locale('cl_lang_32') },
                { value = 'no', label = locale('cl_lang_33') }
            },
            required = true,
            icon = 'fa-solid fa-circle-question'
        },
    })

    if not input then
        return
    end

    if input[1] == 'no' then
        return
    end

    if input[1] == 'yes' then
        TriggerServerEvent('rex-huntingwagon:server:sellhuntingcart', data.plate )
        if hutingwagonspawned then
            DeleteVehicle(currentHuntingWagon)
            SetEntityAsNoLongerNeeded(currentHuntingWagon)
            hutingwagonspawned = false
            exports['rsg-core']:deletePrompt(string.lower(data.plate))
            showingprompt = false
        end
    end
end)

---------------------------------------------------------------------
-- add animal to the database
---------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:addanimal', function(data)
    local ped = PlayerPedId()
    local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
    local holdinghash = GetEntityModel(holding)
    local holdinganimal = Citizen.InvokeNative(0x9A100F1CF4546629, holding)
    local holdinglooted = Citizen.InvokeNative(0x8DE41E9902E85756, holding)

    if holding ~= false and holdinganimal == 1 then
        for i = 1, #Config.Animals do
            if Config.Animals[i].modelhash == holdinghash then
                local modelhash = Config.Animals[i].modelhash
                local modellabel = Config.Animals[i].modellabel
                local modellooted = holdinglooted
                local deleted = DeleteThis(holding, modellabel)
                if deleted then
                    TriggerServerEvent('rex-huntingwagon:server:addanimal', modelhash, modellabel, modellooted, data.plate)
                else
                    lib.notify({ title = locale('cl_lang_34'), description = locale('cl_lang_35'), type = 'error', duration = 5000 })
                end
            end
        end
    end
    
    -- update hunting wagon tarp
    RSGCore.Functions.TriggerCallback('rex-huntingwagon:server:gettarpinfo', function(results)
        local change = (results + 1)
        local percentage = change * Config.TotalAnimalsStored / 100
        Citizen.InvokeNative(0x31F343383F19C987, currentHuntingWagon, tonumber(percentage), 1)
    end, currentHuntingPlate)
    
end)

---------------------------------------------------------------------
-- delete animal player is holding
---------------------------------------------------------------------
function DeleteThis(holding, modellabel)
    NetworkRequestControlOfEntity(holding)
    SetEntityAsMissionEntity(holding, true, true)
    Wait(100)
    lib.progressBar({
        duration = Config.StoreTime,
        label = locale('cl_lang_47') .. modellabel,
        useWhileDead = false,
        canCancel = false,
    })
    DeleteEntity(holding)
    Wait(500)
    local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, cache.ped)
    local holdingcheck = GetPedType(entitycheck)
    if holdingcheck == 0 then
        return true
    else
        return false
    end
end

---------------------------------------------------------------------
-- get what is stored in the hunting wagon / remove carcus
---------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:getHuntingWagonStore', function(data)
    RSGCore.Functions.TriggerCallback('rex-huntingwagon:server:getwagonstore', function(results)
        local options = {}
        for k, v in ipairs(results) do
            options[#options + 1] = {
                title = v.animallabel,
                description = '',
                icon = 'fa-solid fa-box',
                serverEvent = 'rex-huntingwagon:server:removeanimal',
                args = {
                    id = v.id,
                    plate = v.plate,
                    animallooted = v.animallooted,
                    animalhash = v.animalhash,
                },
                arrow = true,
            }
        end
        lib.registerContext({
            id = 'hunting_inv_menu',
            title = locale('cl_lang_36'),
            position = 'top-right',
            options = options
        })
        lib.showContext('hunting_inv_menu')
    end, data.plate)
end)

---------------------------------------------------------------------
-- takeout animal
---------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:takeoutanimal', function(animalhash, animallooted)
    local pos = GetOffsetFromEntityInWorldCoords(currentHuntingWagon, 0.0, -3.0, 0.0)
    
    modelHash = tonumber(animalhash)

    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(1)
        end
    end

    animal = CreatePed(modelHash, pos.x, pos.y, pos.z, true, true, true)
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, animal, 0, false)

    if animallooted == 1 then
        Citizen.InvokeNative(0x6BCF5F3D8FFE988D, animal, animallooted)
        SetEntityHealth(animal, 0, 0)
        SetEntityAsMissionEntity(animal, true, true)
    else
        SetEntityHealth(animal, 0, 0)
        SetEntityAsMissionEntity(animal, true, true)
    end
    
    -- update hunting wagon tarp
    RSGCore.Functions.TriggerCallback('rex-huntingwagon:server:gettarpinfo', function(results)
        local change = (results - 1)
        local percentage = change * Config.TotalAnimalsStored / 100
        Citizen.InvokeNative(0x31F343383F19C987, currentHuntingWagon, tonumber(percentage), 1)
    end, currentHuntingPlate)

end)

---------------------------------------------------------------------
-- fix hunting wagon
---------------------------------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:fixwagon', function(plate)
    local fixprice = (Config.WagonPrice * Config.WagonFixRate)
    local input = lib.inputDialog(locale('cl_lang_37'), {
        { 
            label = locale('cl_lang_38')..fixprice,
            type = 'select',
            options = { 
                { value = 'yes', label = locale('cl_lang_32') },
                { value = 'no', label = locale('cl_lang_33') }
            },
            required = true,
            icon = 'fa-solid fa-circle-question'
        },
    })

    if not input then
        return
    end

    if input[1] == 'no' then
        return
    end

    if input[1] == 'yes' then
        TriggerServerEvent('rex-huntingwagon:server:fixhuntingwagon', plate, fixprice )
    end
end)

---------------------------------------------
-- hunting wagon storage
---------------------------------------------
RegisterNetEvent('rex-huntingwagon:client:getHuntingWagonInventory', function(data)
    TriggerServerEvent('rex-huntingwagon:server:wagonstorage', data.plate)
end)

--------------------------------------
-- hunting shop
--------------------------------------
RegisterNetEvent('rex-huntingwagon:client:openshop', function()
    TriggerServerEvent('rsg-shops:server:openstore', 'hunting', 'hunting', 'Hunting')
end)
