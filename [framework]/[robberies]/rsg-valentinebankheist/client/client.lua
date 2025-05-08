local RSGCore = exports['rsg-core']:GetCoreObject()
local lockdownSecondsRemaining = 0 -- done to zero lockdown on restart
local cooldownSecondsRemaining = 0 -- done to zero cooldown on restart
local CurrentLawmen = 0
local lockpicked = false
local lockpicked2 = false
local dynamiteused = false
local vault1 = false
local vault2 = false
local vault3 = false
local vault4 = false
local vault5 = false
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
        local object = Citizen.InvokeNative(0xF7424890E4A094C0, 1340831050, 0)
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
                                TriggerServerEvent('rsg-valentinebankheist:server:removeItem', 'lockpick', 1)
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
        Citizen.InvokeNative(0x6BAB9442830C7F53, 1340831050, 0)
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
        local object = Citizen.InvokeNative(0xF7424890E4A094C0, 3718620420, 0)
        if object ~= 0 and robberystarted == true and lockpicked2 == false then
            local objectPos = GetEntityCoords(object)
            if #(pos - objectPos) < 3.0 then
                awayFromObject = false
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Lockpick [J]")
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                    local hasItem = RSGCore.Functions.HasItem('lockpick', 1)
                    if hasItem then
                        TriggerServerEvent('rsg-valentinebankheist:server:removeItem', 'lockpick', 1)
                        local success = lib.skillCheck({'easy', 'easy', {areaSize = 50, speedMultiplier = 1}, 'easy'}, {'w', 'a', 's', 'd'})
                        if success then
                            lockpicked2 = true
                            lib.notify({ title = 'Door is Lockpicked!', type = 'success', duration = 5000 })
                            Citizen.InvokeNative(0x6BAB9442830C7F53, 3718620420, 0)
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
        local object = Citizen.InvokeNative(0xF7424890E4A094C0, 576950805, 0)
        if object ~= 0 and robberystarted == true and dynamiteused == false then
            local objectPos = GetEntityCoords(object)
            if #(pos - objectPos) < 3.0 then
                awayFromObject = false
                DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Place Dynamite [J]")
                if IsControlJustReleased(0, RSGCore.Shared.Keybinds['J']) then
                    TriggerEvent('rsg-valentinebankheist:client:boom')
                end
            end
        end
        if awayFromObject then
            Wait(1000)
        end
    end
end)
-- blow vault doors
RegisterNetEvent('rsg-valentinebankheist:client:boom')
AddEventHandler('rsg-valentinebankheist:client:boom', function()
    if robberystarted == true then
        local hasItem = RSGCore.Functions.HasItem('dynamite', 1)
        if hasItem then
            dynamiteused = true
            TriggerServerEvent('rsg-valentinebankheist:server:removeItem', 'dynamite', 1)
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
            AddExplosion(-307.24, 767.2, 118.7, 25 , 5000.0 ,true , false , 27)
            DeleteObject(prop)
            Citizen.InvokeNative(0x6BAB9442830C7F53, 576950805, 0)
            RSGCore.Functions.TriggerCallback('rsg-lawman:server:getlaw', function(result)
                CurrentLawmen = result
                if CurrentLawmen >= Config.MinimumLawmen then
                    local alertcoords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent('rsg-lawman:server:lawmanAlert', 'Valentine Bank is being robbed')
                    else
                    TriggerEvent('rsg-valentinebankheist:client:policenpc')
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
    exports['rsg-target']:AddBoxZone("valvault1", vector3(-308.18, 762.1, 118.7), 0.5, 0.7, { 
    name = "valvault1", 
    heading = 12.0, 
    debugPoly = false, 
    minZ = 118.5,
    maxZ = 119.1, 
  }, {
    options = {
      { 
        type = "client", 
        event = "rsg-valentinebankheist:client:checkvault1",
        icon = 'fas fa-piggy-bank', 
        label = 'Search Vault',
      }
    },
    distance = 1.5, 
  })
end)


-- loot vault1
RegisterNetEvent('rsg-valentinebankheist:client:checkvault1', function()
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
                TriggerServerEvent('rsg-valentinebankheist:server:reward')
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
------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    exports['rsg-target']:AddBoxZone("valvault2", vector3(-309.465, 762.68, 118.493), 0.6, 0.8, { 
        name = "valvault2", 
        heading = 12, 
        debugPoly = false, 
        minZ = 116.5,
        maxZ = 119.4, 
      }, {
        options = {
          { 
            type = "client", 
            event = "rsg-valentinebankheist:client:checkvault2",
            icon = 'fas fa-piggy-bank', 
            label = 'Search Vault',
          }
        },
        distance = 1.5, 
      })
end)

-- loot vault2
RegisterNetEvent('rsg-valentinebankheist:client:checkvault2', function()
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
                TriggerServerEvent('rsg-valentinebankheist:server:reward')
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

Citizen.CreateThread(function()
    exports['rsg-target']:AddBoxZone("valvault3", vector3(-309.487, 763.78, 118.493), 0.6, 0.8, { 
        name = "valvault3", 
        heading = 12, 
        debugPoly = false, 
        minZ = 116.5,
        maxZ = 119.4, 
      }, {
        options = {
          { 
            type = "client", 
            event = "rsg-valentinebankheist:client:checkvault3",
            icon = 'fas fa-piggy-bank', 
            label = 'Search Vault',
          }
        },
        distance = 1.5, 
      })
end)

-- loot vault3
RegisterNetEvent('rsg-valentinebankheist:client:checkvault3', function()
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
                TriggerServerEvent('rsg-valentinebankheist:server:reward')
                vault3 = true
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
    exports['rsg-target']:AddBoxZone("valvault4", vector3(-309.79, 764.78, 118.493), 0.6, 0.8, { 
        name = "valvault4", 
        heading = 12, 
        debugPoly = false, 
        minZ = 116.5,
        maxZ = 119.4, 
      }, {
        options = {
          { 
            type = "client", 
            event = "rsg-valentinebankheist:client:checkvault4",
            icon = 'fas fa-piggy-bank', 
            label = 'Search Vault',
          }
        },
        distance = 1.5, 
      })
end)

-- loot vault4
RegisterNetEvent('rsg-valentinebankheist:client:checkvault4', function()
    local player = PlayerPedId()
    
    SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
    if robberystarted == true and vault4 == false then
        RequestAnimDict("mini_games@safecrack@base")
        while not HasAnimDictLoaded("mini_games@safecrack@base") do
            Wait(100)
        end
        TaskPlayAnim(player, "mini_games@safecrack@base", "base_stage_00", 3.0, 3.0, -1, 1, 0, false, false, false)
        local Vault4Hack = exports['legends-keypress']:startkp(minigameKP, minigameKP)
        if Vault4Hack then 
            if lib.progressBar({
                name = 'search_vault4',       -- Progressbar ID (optional)
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
                TriggerServerEvent('rsg-valentinebankheist:server:reward')
                vault4 = true
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
    exports['rsg-target']:AddBoxZone("valvault5", vector3(-308.7877, 765.6704, 118.7), 0.5, 0.7, { 
        name = "valvault5", 
        heading = 12.0,
        debugPoly = false, 
        minZ = 118.5,
        maxZ = 119.1, 
      }, {
        options = {
          { 
            type = "client", 
            event = "rsg-valentinebankheist:client:checkvault5",
            icon = 'fas fa-piggy-bank', 
            label = 'Search Vault',
          }
        },
        distance = 1.5, 
      })
end)

-- loot vault5
RegisterNetEvent('rsg-valentinebankheist:client:checkvault5', function()
    local player = PlayerPedId()
    
    SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
    if robberystarted == true and vault5 == false then
        RequestAnimDict("mini_games@safecrack@base")
        while not HasAnimDictLoaded("mini_games@safecrack@base") do
            Wait(100)
        end
        TaskPlayAnim(player, "mini_games@safecrack@base", "base_stage_00", 3.0, 3.0, -1, 1, 0, false, false, false)
        local Vault5Hack = exports['legends-keypress']:startkp(minigameKP, minigameKP)
        if Vault5Hack then 
            if lib.progressBar({
                name = 'search_vault5',       -- Progressbar ID (optional)
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
                TriggerServerEvent('rsg-valentinebankheist:server:reward')
                vault5 = true
            end
            if vault5 then
                lib.notify({ title = 'Robbery Successful!', type = 'success', duration = 5000 })
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
RegisterNetEvent('rsg-valentinebankheist:client:policenpc')
AddEventHandler('rsg-valentinebankheist:client:policenpc', function()
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
            vault4 = true
            vault5 = true
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
            vault4 = false
            vault5 = false
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

Citizen.CreateThread(function()
    exports['rsg-core']:createPrompt('valpolicelock', vector3(-302.72, 772.64, 118.7), RSGCore.Shared.Keybinds['J'], 'Emergency Menu', {
        type = 'client',
        event = 'rsg-valentinebankheist:client:bankmenu',
        args = {},
    })
end)

-- emergency menu
RegisterNetEvent('rsg-valentinebankheist:client:bankmenu', function()
    lib.registerContext({
        id = 'oxbankmenu',
        title = 'Emergency Menu',
        options = {
          {
            title = 'Lock Bank',
            description = 'used by law enforcement to lock bank in an emergency!',
            icon = 'fas fa-lock',
            event = 'rsg-valentinebankheist:client:policelock',
            arrow = true,
            args = {
                isServer = false,
            }
          },
          {
            title = 'Unlock Bank',
            description = 'used by law enforcement to unlock bank in an emergency!',
            icon = 'fas fa-lock-open',
            event = 'rsg-valentinebankheist:client:policeunlock',
            arrow = true,
            args = {
                isServer = false,
            }
          }
        }
      })
      lib.showContext('oxbankmenu')
end)
RegisterNetEvent('rsg-valentinebankheist:client:policelock', function()
    RSGCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.type == "leo" then
            -- lock doors
            for k,v in pairs(Config.VaultDoors) do
                Citizen.InvokeNative(0x6BAB9442830C7F53,v,1)
            end
            lib.notify({ title = 'emergency doors locked', type = 'success', duration = 5000 })
        else
            lib.notify({ title = 'law enforcement only', type = 'error', duration = 5000 })
        end
    end)
end)

RegisterNetEvent('rsg-valentinebankheist:client:policeunlock', function()
    RSGCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.type == "leo" then
            -- lock doors
            for k,v in pairs(Config.VaultDoors) do
                Citizen.InvokeNative(0x6BAB9442830C7F53,v,0)
            end
            lib.notify({ title = 'emergency doors unlocked', type = 'success', duration = 5000 })
        else
            lib.notify({ title = 'law enforcement only', type = 'error', duration = 5000 })
        end
    end)
end)

------------------------------------------------------------------------------------------------------------------------




AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        exports['rsg-core']:deletePrompt('valpolicelock')
        exports['rsg-target']:RemoveZone("valvault1")
        exports['rsg-target']:RemoveZone("valvault2")
        exports['rsg-target']:RemoveZone("valvault3")
        exports['rsg-target']:RemoveZone("valvault4")
        exports['rsg-target']:RemoveZone("valvault5")
        vault1 = true
        vault2 = true
        vault3 = true
        vault4 = true
        vault5 = true
        exports['rsg-core']:HideText()
        lockdownactive = false
    end
end)