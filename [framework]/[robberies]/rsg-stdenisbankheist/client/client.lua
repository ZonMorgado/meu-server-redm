local RSGCore = exports['rsg-core']:GetCoreObject()
local lockdownSecondsRemaining = 0 -- done to zero lockdown on restart
local cooldownSecondsRemaining = 0 -- done to zero cooldown on restart
local CurrentLawmen = 0
local lockpicked = false
local lockpicked2 = false
local dynamiteused = false
local vault1 = false
local vault2 = false
local robberystarted = false
local lockdownactive = false
local minigameKP = math.random(9, 15) -- It Generates Vault mini games controls and timer

------------------------------------------------------------------------------------------------------------------------

-- lock vault doors
Citizen.CreateThread(function()
    for k,v in pairs(Config.VaultDoors) do
        Citizen.InvokeNative(0xD99229FE93B46286,v,1,1,0,0,0,0)
        Citizen.InvokeNative(0x6BAB9442830C7F53,v,1)
    end
end)

------------------------------------------------------------------------------------------------------------------------

-- lockpick door
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
        local object = Citizen.InvokeNative(0xF7424890E4A094C0, 1634115439, 0)
        if object ~= 0 and lockdownSecondsRemaining == 0 and lockpicked == false then
            local objectPos = GetEntityCoords(object)
            if #(pos - objectPos) < 3.0 then
                awayFromObject = false
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Lockpick [J]")
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                    RSGCore.Functions.TriggerCallback('rsg-lawman:server:getlaw', function(result)
                        CurrentLawmen = result
                        if CurrentLawmen >= Config.MinimumLawmen then
                            local hasItem = RSGCore.Functions.HasItem('lockpick', 1)
                            if hasItem then
                                TriggerServerEvent('rsg-stdenisbankheist:server:removeItem', 'lockpick', 1)
                                TriggerEvent('rsg-lockpick:client:openLockpick', lockpickFinish)
                            else
                                lib.notify({ title = 'you need a lockpick.', type = 'error', duration = 5000 })   
                            end
                        else
                            lib.notify({ title = 'not enough lawmen on duty!', type = 'error', duration = 5000 })
                        end
                    end)
                end
            end
        end
        if awayFromObject then
            Wait(1000)
        end
    end
end)

function lockpickFinish(success)
    if success then
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        TriggerServerEvent("BANK:ALARM", coords, player)
        lib.notify({ title = 'lockpick successful', type = 'success', duration = 5000 })
        Citizen.InvokeNative(0x6BAB9442830C7F53, 1634115439, 0)
        lockpicked = true
        robberystarted = true
        handleLockdown()
        lockdownactive = true
    else
        lib.notify({ title = 'lockpick unsuccessful', type = 'error', duration = 5000 })
    end
end

------------------------------------------------------------------------------------------------------------------------

-- mid door vault prompt
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
        local object = Citizen.InvokeNative(0xF7424890E4A094C0, 965922748, 0)
        if object ~= 0 and robberystarted == true and lockpicked2 == false then
            local objectPos = GetEntityCoords(object)
            if #(pos - objectPos) < 3.0 then
                awayFromObject = false
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Lockpick [J]")
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                    local hasItem = RSGCore.Functions.HasItem('lockpick', 1)
                    if hasItem then
                        TriggerServerEvent('rsg-stdenisbankheist:server:removeItem', 'lockpick', 1)
                        local success = lib.skillCheck({'easy', 'easy', {areaSize = 50, speedMultiplier = 1}, 'easy'}, {'w', 'a', 's', 'd'})
                        if success then
                            lockpicked2 = true
                            lib.notify({ title = 'Door is Lockpicked!', type = 'success', duration = 5000 })
                            Citizen.InvokeNative(0x6BAB9442830C7F53, 965922748, 0)
                        else
                            lib.notify({ title = 'Lockpick failed!', type = 'error', duration = 5000 })
                        end
                    else
                        lib.notify({ title = 'you need a lockpick.', type = 'error', duration = 5000 })
                    end
                end
            end
        end
        if awayFromObject then
            Wait(1000)
        end
    end
end)



-- blow vault prompt
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
        local object = Citizen.InvokeNative(0xF7424890E4A094C0, 1751238140, 0)
        if object ~= 0 and robberystarted == true and dynamiteused == false then
            local objectPos = GetEntityCoords(object)
            if #(pos - objectPos) < 3.0 then
                awayFromObject = false
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Place Dynamite [J]")
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                    TriggerEvent('rsg-stdenisbankheist:client:boom')
                end
            end
        end
        if awayFromObject then
            Wait(1000)
        end
    end
end)

-- blow vault doors
RegisterNetEvent('rsg-stdenisbankheist:client:boom')
AddEventHandler('rsg-stdenisbankheist:client:boom', function()
    if robberystarted == true then
        local hasItem = RSGCore.Functions.HasItem('dynamite', 1)
        if hasItem then
            dynamiteused = true
            TriggerServerEvent('rsg-stdenisbankheist:server:removeItem', 'dynamite', 1)
            local playerPed = PlayerPedId()
            TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
            Wait(5000)
            ClearPedTasksImmediately(PlayerPedId())
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, 0.0))
            local prop = CreateObject(GetHashKey("p_dynamite01x"), x, y, z, true, false, true)
            SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
            PlaceObjectOnGroundProperly(prop)
            FreezeEntityPosition(prop,true)
            lib.notify({ title = 'explosives set, stand well back', type = 'inform', duration = 5000 })
            Wait(10000)
            AddExplosion(2643.9285, -1300.4292, 51.2461, 25 , 5000.0 ,true , false , 27)
            DeleteObject(prop)
            Citizen.InvokeNative(0x6BAB9442830C7F53, 1751238140, 0)
            RSGCore.Functions.TriggerCallback('rsg-lawman:server:getlaw', function(result)
                CurrentLawmen = result
                if CurrentLawmen >= Config.MinimumLawmen then
                    local alertcoords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent('rsg-lawman:server:lawmanAlert', 'Saint Denis Bank is being robbed')
                    else
                    TriggerEvent('rsg-stdenisbankheist:client:policenpc')
                end
            end)
        else
            lib.notify({ title = 'you need dynamite to do that', type = 'error', duration = 5000 })
        end
    else
            lib.notify({ title = 'you can\'t do that right now', type = 'error', duration = 5000 })
    end
end)

------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    exports['rsg-target']:AddBoxZone("stdvault1", vector3(2644.5898, -1306.8313, 52.3013), 1.2, 1.2, { 
    name = "stdvault1", 
    heading = 25, 
    debugPoly = false, 
    minZ = 51.5,
    maxZ = 53.1, 
  }, {
    options = {
      { 
        type = "client", 
        event = "rsg-stdenisbankheist:client:checkvault1",
        icon = 'fas fa-piggy-bank', 
        label = 'Search Vault',
      }
    },
    distance = 1.5, 
  })
end)


-- loot vault1
RegisterNetEvent('rsg-stdenisbankheist:client:checkvault1', function()
    local player = PlayerPedId()
    
    SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
    if robberystarted == true and vault1 == false then
        RequestAnimDict("mini_games@safecrack@base")
        while not HasAnimDictLoaded("mini_games@safecrack@base") do
            Wait(100)
        end
        TaskPlayAnim(player, "mini_games@safecrack@base", "base_stage_00", 3.0, 3.0, -1, 1, 0, false, false, false)
        local Vault1Hack = exports['legends-keypress']:startkp(minigameKP, minigameKP)
        if Vault1Hack then 
            if lib.progressBar({
                name = 'search_vault1',       -- Progressbar ID (optional)
                label = 'Searching Vault',        -- Progressbar label/message
                duration = 10000,        -- Duration (1 minute)
                useWhileDead = false,
                canCancel = false,
                disable = {
                    move = true,
                },
                anim = {
                    dict = 'script_ca@cachr@ig@ig4_vaultloot',  -- Animation dictionary
                    clip = 'ig13_14_grab_money_front01_player_zero',  -- Animation clip
                    flags = 1                                  -- Animation flags
                },
            }) then
                ClearPedTasks(player)
                FreezeEntityPosition(player, false)
                SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
                TriggerServerEvent('rsg-stdenisbankheist:server:reward')
                vault1 = true
            end
        else
            ClearPedTasks(player)
            FreezeEntityPosition(player, false)
            lib.notify({ title = 'Safe Hack Failed', type = 'error', duration = 5000 })
        end
    else
        lib.notify({ title = 'vault is not lootable', type = 'error', duration = 5000 })
    end
end)

Citizen.CreateThread(function()
    exports['rsg-target']:AddBoxZone("stdvault2", vector3(2644.8992, -1303.5588, 52.3013), 0.7, 0.6, { 
    name = "stdvault2", 
    heading = 25, 
    debugPoly = false, 
    minZ = 52.0,
    maxZ = 52.6, 
  }, {
    options = {
      { 
        type = "client", 
        event = "rsg-stdenisbankheist:client:checkvault2",
        icon = 'fas fa-piggy-bank', 
        label = 'Search Vault',
      }
    },
    distance = 1.5, 
  })
end)


-- loot vault2
RegisterNetEvent('rsg-stdenisbankheist:client:checkvault2', function()
    local player = PlayerPedId()
    
    SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
    if robberystarted == true and vault2 == false then
        RequestAnimDict("mini_games@safecrack@base")
        while not HasAnimDictLoaded("mini_games@safecrack@base") do
            Wait(100)
        end
        TaskPlayAnim(player, "mini_games@safecrack@base", "base_stage_00", 3.0, 3.0, -1, 1, 0, false, false, false)
        local Vault2Hack = exports['legends-keypress']:startkp(minigameKP, minigameKP)
        if Vault2Hack then 
            if lib.progressBar({
                name = 'search_vault2',       -- Progressbar ID (optional)
                label = 'Searching Vault',        -- Progressbar label/message
                duration = 10000,        -- Duration (1 minute)
                useWhileDead = false,
                canCancel = false,
                disable = {
                    move = true,
                },
                anim = {
                    dict = 'script_ca@cachr@ig@ig4_vaultloot',  -- Animation dictionary
                    clip = 'ig13_14_grab_money_front01_player_zero',  -- Animation clip
                    flags = 1                                  -- Animation flags
                },
            }) then
                ClearPedTasks(player)
                FreezeEntityPosition(player, false)
                SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
                TriggerServerEvent('rsg-stdenisbankheist:server:reward')
                vault2 = true
            end
        else
            ClearPedTasks(player)
            FreezeEntityPosition(player, false)
            lib.notify({ title = 'Safe Hack Failed', type = 'error', duration = 5000 })
        end
    else
        lib.notify({ title = 'vault is not lootable', type = 'error', duration = 5000 })
    end
end)
------------------------------------------------------------------------------------------------------------------------


Citizen.CreateThread(function()
    exports['rsg-target']:AddBoxZone("stdvault3", vector3(2641.1702, -1303.5114, 52.0436), 0.7, 0.6, { 
        name = "stdvault3", 
        heading = 25, 
        debugPoly = false, 
        minZ = 51.5,
        maxZ = 52.8, 
      }, {
        options = {
          { 
            type = "client", 
            event = "rsg-stdenisbankheist:client:checkvault3",
            icon = 'fas fa-piggy-bank', 
            label = 'Search Vault',
          }
        },
        distance = 1.5, 
      })
end)

RegisterNetEvent('rsg-stdenisbankheist:client:checkvault3', function()
    local player = PlayerPedId()
    
    SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
    if robberystarted == true and vault3 == false then
        RequestAnimDict("mini_games@safecrack@base")
        while not HasAnimDictLoaded("mini_games@safecrack@base") do
            Wait(100)
        end
        TaskPlayAnim(player, "mini_games@safecrack@base", "base_stage_00", 3.0, 3.0, -1, 1, 0, false, false, false)
        local Vault3Hack = exports['legends-keypress']:startkp(minigameKP, minigameKP)
        if Vault3Hack then 
            if lib.progressBar({
                name = 'search_vault3',       -- Progressbar ID (optional)
                label = 'Searching Vault',        -- Progressbar label/message
                duration = 10000,        -- Duration (1 minute)
                useWhileDead = false,
                canCancel = false,
                disable = {
                    move = true,
                },
                anim = {
                    dict = 'script_ca@cachr@ig@ig4_vaultloot',  -- Animation dictionary
                    clip = 'ig13_14_grab_money_front01_player_zero',  -- Animation clip
                    flags = 1                                  -- Animation flags
                },
            }) then
                ClearPedTasks(player)
                FreezeEntityPosition(player, false)
                SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
                TriggerServerEvent('rsg-stdenisbankheist:server:reward')
                vault3 = true
                if vault3 then
                    lib.notify({ title = 'Robbery Successful!', type = 'success', duration = 5000 })
                end
            end
        else
            ClearPedTasks(player)
            FreezeEntityPosition(player, false)
            lib.notify({ title = 'Safe Hack Failed', type = 'error', duration = 5000 })
        end
    else
        lib.notify({ title = 'vault is not lootable', type = 'error', duration = 5000 })
    end
end)
------------------------------------------------------------------------------------------------------------------------

function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

-- start mission npcs
RegisterNetEvent('rsg-stdenisbankheist:client:policenpc')
AddEventHandler('rsg-stdenisbankheist:client:policenpc', function()
    for z, x in pairs(Config.HeistNpcs) do
    while not HasModelLoaded( GetHashKey(Config.HeistNpcs[z]["Model"]) ) do
        Wait(500)
        modelrequest( GetHashKey(Config.HeistNpcs[z]["Model"]) )
    end
    local npc = CreatePed(GetHashKey(Config.HeistNpcs[z]["Model"]), Config.HeistNpcs[z]["Pos"].x, Config.HeistNpcs[z]["Pos"].y, Config.HeistNpcs[z]["Pos"].z, Config.HeistNpcs[z]["Heading"], true, false, 0, 0)
    while not DoesEntityExist(npc) do
        Wait(300)
    end
    if not NetworkGetEntityIsNetworked(npc) then
        NetworkRegisterEntityAsNetworked(npc)
    end
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
    GiveWeaponToPed_2(npc, 0x64356159, 500, true, 1, false, 0.0)
    TaskCombatPed(npc, PlayerPedId())
    end
end)

------------------------------------------------------------------------------------------------------------------------

-- bank lockdown timer
function handleLockdown()
    lockdownSecondsRemaining = Config.BankLockdown
    Citizen.CreateThread(function()
        while lockdownSecondsRemaining > 0 do
            Wait(1000)
            lockdownSecondsRemaining = lockdownSecondsRemaining - 1
        end
    end)
end

-- bank lockdown and reset after cooldown
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if robberystarted == true and lockdownactive == true then
            exports['rsg-core']:DrawText('Bank Lockdown in '..lockdownSecondsRemaining..' seconds!', 'left')
        end
        if lockdownSecondsRemaining == 0 and robberystarted == true and lockdownactive == true then
            -- lock doors
            for k,v in pairs(Config.VaultDoors) do
                Citizen.InvokeNative(0xD99229FE93B46286,v,1,1,0,0,0,0)
                Citizen.InvokeNative(0x6BAB9442830C7F53,v,1)
            end
            -- disable vault looting / trigger cooldown
            vault1 = true
            vault2 = true
            vault3 = true
            exports['rsg-core']:HideText()
            lockdownactive = false
            handleCooldown()
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------

-- cooldown timer
function handleCooldown()
    cooldownSecondsRemaining = Config.BankCooldown
    Citizen.CreateThread(function()
        while cooldownSecondsRemaining > 0 do
            Wait(1000)
            cooldownSecondsRemaining = cooldownSecondsRemaining - 1
        end
    end)
end

-- reset bank so it can be robbed again
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if lockdownactive == false and cooldownSecondsRemaining == 0 and robberystarted == true then
            -- confirm doors are locked
            for k,v in pairs(Config.VaultDoors) do
                Citizen.InvokeNative(0xD99229FE93B46286,v,1,1,0,0,0,0)
                Citizen.InvokeNative(0x6BAB9442830C7F53,v,1)
            end
            -- reset bank robbery
            robberystarted = false
            lockpicked = false
            lockpicked2 = false
            dynamiteused = false
            vault1 = false
            vault2 = false
            vault3 = false
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

------------------------------------------------------------------------------------------------------------------------




AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        exports['rsg-target']:RemoveZone("stdvault1")
        exports['rsg-target']:RemoveZone("stdvault2")
        exports['rsg-target']:RemoveZone("stdvault3")
        vault1 = true
        vault2 = true
        vault3 = true
        exports['rsg-core']:HideText()
        lockdownactive = false
    end
end)