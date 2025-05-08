local RSGCore = exports[Config.core]:GetCoreObject()
local destinationPoint = Config.DestinationPoint
local vehicle
local pedestrian
local playerPed = PlayerPedId()
local playerCoords
local closestVehicle
local closestVDistance
local awayFromObject
local robberystarted = false
local dynamiteused = false
local dynamiteexploded = false
local wagonlooted = false
local wagonRobbed = false

if Config.RSGV2 then
    -- Override the Notify function to use your own logic
    RSGCore.Functions.Notify = function(message, messageType, duration)
        TriggerEvent('ox_lib:notify', {title = "", description = message, type = messageType, duration = 5000 })
    end
    
    
    RSGCore.Functions.Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
        if GetResourceState('progressbar') ~= 'started' then error('progressbar needs to be started in order for RSGCore.Functions.Progressbar to work') end
        exports['progressbar']:Progress({
            name = name:lower(),
            duration = duration,
            label = label,
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            controlDisables = disableControls,
            animation = animation,
            prop = prop,
            propTwo = propTwo,
        }, function(cancelled)
            if not cancelled then
                if onFinish then
                    onFinish()
                end
            else
                if onCancel then
                    onCancel()
                end
            end
        end)
    end
    
end

Citizen.CreateThread(function()
    exports[Config.core]:createPrompt('wagonrobbery', Config.StartMission, RSGCore.Shared.Keybinds['E'], 'Start The Gold Wagon Job', {
        type = 'client',
        event = 'wagonrobbery:client:startrobbery',
        args = { },
    })
    while true do
        Wait(0)
        playerCoords = GetEntityCoords(playerPed)
        awayFromObject = true
        closestVehicle, closestVDistance = RSGCore.Functions.GetClosestVehicle(playerCoords)
        if closestVDistance < 3.0 and closestVehicle == vehicle then
            awayFromObject = false
            print('This is the gold wagon!')
            local objectPos = GetEntityCoords(closestVehicle)
            if dynamiteexploded == false then
            DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Place Dynamite [J]")
            if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                TriggerEvent('wagonrobbery:client:boom')
            end
            end
            if dynamiteexploded == true then
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Loot Gold [J]")
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                TriggerEvent('wagonrobbery:client:lootgold')
            end
            end
        end
        if awayFromObject then
            Wait(1000)
        end
    end
    

end)

RegisterNetEvent('wagonrobbery:client:lootgold')
AddEventHandler('wagonrobbery:client:lootgold', function()
    
    TriggerServerEvent('hud:server:GainStress', math.random(30, 40))
    local player = PlayerPedId()
    SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
    if robberystarted == true and dynamiteexploded == true and wagonlooted == false then
            TriggerServerEvent('rsg-lawman:server:lawmanAlert', 'Gold wagon being robbed!')
            local animDict = "script_ca@cachr@ig@ig4_vaultloot"
            local anim = "ig13_14_grab_money_front01_player_zero"
            RequestAnimDict(animDict)
            while ( not HasAnimDictLoaded(animDict) ) do
                Wait(100)
            end
            TaskPlayAnim(player, animDict, anim, 8.0, -8.0, 10000, 1, 0, true, 0, false, 0, false)
            Wait(10000)
            ClearPedTasks(player)
            SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
            TriggerServerEvent('wagonrobbery:server:reward')
            wagonlooted = true
    else
        RSGCore.Functions.Notify('Wagon not lootable', 'error')
    end

end)
-- blow armored wagon
RegisterNetEvent('wagonrobbery:client:boom')
AddEventHandler('wagonrobbery:client:boom', function()
    if robberystarted == true then
        local hasItem = RSGCore.Functions.HasItem(Config.DynamiteItem, 1)
        if hasItem then
            dynamiteused = true
            TriggerServerEvent('wagonrobbery:server:removeItem', Config.DynamiteItem, 1)
            local playerPed = PlayerPedId()
            TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
            Wait(5000)
            ClearPedTasksImmediately(PlayerPedId())
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, 0.0))
            local prop = CreateObject(GetHashKey("p_dynamite01x"), x, y, z, true, false, true)
            SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
            PlaceObjectOnGroundProperly(prop)
            FreezeEntityPosition(prop,true)
            RSGCore.Functions.Notify('explosives set, stand well back', 'primary')
            Wait(10000)
            AddExplosion(x, y, z, 25 , 5000.0 ,true , false , 27)
            DeleteObject(prop)
            dynamiteexploded = true
            local alertcoords = GetEntityCoords(PlayerPedId())
            
        else
            RSGCore.Functions.Notify('you need dynamite to do that', 'error')
        end
    else
        RSGCore.Functions.Notify('you can\'t do that right now', 'error')
    end
end)


RegisterNetEvent('wagonrobbery:client:spawnwagon')
AddEventHandler('wagonrobbery:client:spawnwagon', function()

    -- Define the spawn point for the vehicle
    local spawnPoint = Config.StartPoint

    -- Get the hash for the Coach7 vehicle model
    local vehicleHash = GetHashKey("STAGECOACH004_2X")
    local randomPedHash = GetHashKey("A_M_M_deliverytravelers_warm_01")
    print(vehicleHash)
    RequestModel(vehicleHash)
    RequestModel(randomPedHash)

    if not IsModelInCdimage(vehicleHash) then return end
    while not HasModelLoaded(vehicleHash) do
        Wait(0)
    end
    if not IsModelInCdimage(randomPedHash) then return end
    while not HasModelLoaded(randomPedHash) do
        Wait(0)
    end
    -- Spawn the Coach7 vehicle
    vehicle = CreateVehicle(vehicleHash, spawnPoint,93.9773, true, false)
    

    while not DoesEntityExist(vehicle) do 
        Wait(20) 
        vehicle = CreateVehicle(vehicleHash, spawnPoint,93.9773, true, false)
    end
    if not NetworkGetEntityIsNetworked(vehicle) then
        NetworkRegisterEntityAsNetworked(vehicle)
    end
    print(vehicle)
    -- Define the starting point for the pedestrian NPC
    local startPoint = Config.StartPoint

    -- Define the destination point for the pedestrian NPC


    -- Get a random pedestrian model hash
    

    -- Create the pedestrian NPC
    pedestrian = CreatePedInsideVehicle(vehicle, randomPedHash, -1, true, false)

    while not DoesEntityExist(pedestrian) do Wait(0) end
    if not NetworkGetEntityIsNetworked(pedestrian) then
        NetworkRegisterEntityAsNetworked(pedestrian)
    end

    -- Set the NPC's route to the destination point
    TaskVehicleDriveToCoord(pedestrian, vehicle, destinationPoint.x,destinationPoint.y,destinationPoint.z, 15.0, 0, vehicleHash, 0, 5.0, 0)

    -- Set the NPC's starting point to be in the driver's seat
    SetPedIntoVehicle(pedestrian, vehicle, -1)

    -- Set the vehicle to be driven by the NPC
    SetVehicleHasBeenOwnedByPlayer(vehicle, false)
    SetVehicleAsNoLongerNeeded(vehicle)
    SetVehicleForwardSpeed(vehicle, 3.5)
    TaskVehicleDriveToCoord(pedestrian, vehicle, destinationPoint.x,destinationPoint.y,destinationPoint.z, 2.0, 0, vehicleHash, 0, 5.0, 0)
    Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, vehicle) -- blips

end)

RegisterNetEvent('wagonrobbery:client:startrobbery')
AddEventHandler('wagonrobbery:client:startrobbery', function()

    RSGCore.Functions.TriggerCallback('wagonrobbery:server:getWagonRobbed', function(wagonRobbed)
        if wagonRobbed then
            RSGCore.Functions.Notify("The gold wagon has already been robbed.", 'error')
            return
        end

        local hasItem = RSGCore.Functions.HasItem(Config.BpoItem, 1)
        if hasItem then
            RSGCore.Functions.Notify("The Armored wagon is taking this road to Valentine bank!", 'primary')
            RSGCore.Functions.Notify("Prepare yourselves!", 'primary')
            TriggerServerEvent('wagonrobbery:server:setWagonRobbed')
            TriggerServerEvent('wagonrobbery:server:removeItem', Config.BpoItem, 1)
            TriggerEvent('wagonrobbery:client:spawnwagon')
            TriggerEvent('wagonrobbery:client:callbandits')
            robberystarted = true
            local playerPed = PlayerPedId()
            local serverId = NetworkGetPlayerIndexFromPed(playerPed)
            local playerName = GetPlayerName(serverId)
            TriggerServerEvent('rsg-log:server:CreateLog', 'robbery', 'Armored Wagon Robbery', 'white', '**' .. playerName .. '** ID: ' .. serverId .. ' Started Robbery ', false)
        else
            RSGCore.Functions.Notify("Get us the armored wagons blueprint and let's rob that thing!", 'error')
        end
    end)


    local playerPed = PlayerPedId()
    local serverId = NetworkGetPlayerIndexFromPed(playerPed)
    local playerName = GetPlayerName(serverId)
    --TriggerServerEvent('rsg-log:server:CreateLog', 'robbery', 'Armored Wagon Robbery', 'white', '**' .. playerName .. '** ID: ' .. serverId .. ' Started Robbery ', false)

 
end)

local spawnbandits = false
local calloffbandits = false
local cooldownSecondsRemaining = 0
local npcs = {}
local horse = {}
function banditsTrigger(bandits)
    spawnbandits = true
    for v,k in pairs(bandits) do
        local horsemodel = GetHashKey(Config.HorseModels[math.random(1,#Config.HorseModels)])
        local banditmodel = GetHashKey(Config.BanditsModel[math.random(1,#Config.BanditsModel)])
        local banditWeapon = Config.Weapons[math.random(1,#Config.Weapons)]
        RequestModel(banditmodel)
        if not HasModelLoaded(banditmodel) then RequestModel(banditmodel) end
        while not HasModelLoaded(banditmodel) do Wait(1) end
        Wait(100)
        -- create bandits
        npcs[v] = CreatePed(banditmodel, k, true, true, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, npcs[v], true)
        --Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, npcs[v]) -- blips
        -- give weapon to bandits
        GiveWeaponToPed(npcs[v], banditWeapon, 50, true, true, 1, false, 0.5, 1.0, 1.0, true, 0, 0)
        SetCurrentPedWeapon(npcs[v], banditWeapon, true)
        -- create horse sit bandits on horse
        RequestModel(horsemodel)
        if not HasModelLoaded(horsemodel) then RequestModel(horsemodel) end
        while not HasModelLoaded(horsemodel) do Wait(1) end
        Wait(100)
        horse[v] = CreatePed(horsemodel, k, true, true, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, horse[v], true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horse[v],0x20359E53,true,true,true) --saddle
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horse[v],0x508B80B9,true,true,true) --blanket
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horse[v],0xF0C30271,true,true,true) --bag
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horse[v],0x12F0DF9F,true,true,true) --bedroll
        Citizen.InvokeNative(0xD3A7B003ED343FD9, horse[v],0x67AF7302,true,true,true) --stirups
        Citizen.InvokeNative(0x028F76B6E78246EB, npcs[v], horse[v], -1)
        TaskFollowAndConverseWithPed(
	npcs[v] --[[ Ped ]], 
	pedestrian --[[ Ped ]], 
	0 --[[ Any ]], 
	0 --[[ Any ]], 
	0 --[[ number ]], 
	0 --[[ number ]], 
	true --[[ integer ]], 
	0 --[[ Any ]], 
	0 --[[ Any ]], 
	0 --[[ number ]], 
	0 --[[ number ]]
)
      
    end
end
RegisterNetEvent('wagonrobbery:client:callbandits')
AddEventHandler('wagonrobbery:client:callbandits', function(data)



    Wait(300)
        for v,k in pairs(Config.Bandits) do

                banditsTrigger(k.bandits)

        end
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end