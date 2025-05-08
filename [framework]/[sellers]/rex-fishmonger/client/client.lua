local RSGCore = exports['rsg-core']:GetCoreObject()
local SpawnedFishMongerBilps = {}
lib.locale()

-----------------------------------------------------------------
-- fish monger prompts and blips
-----------------------------------------------------------------
Citizen.CreateThread(function()
    for _,v in pairs(Config.FishMongerLocations) do
        exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds[Config.KeyBind], locale('cl_lang_1')..v.name, {
            type = 'client',
            event = 'rex-fishmonger:client:mainmenu',
        })
        if v.showblip == true then
            local FishMongerBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(FishMongerBlip, joaat(Config.Blip.blipSprite), true)
            SetBlipScale(FishMongerBlip, Config.Blip.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, FishMongerBlip, v.name)
            table.insert(SpawnedFishMongerBilps, FishMongerBlip)
        end
    end
end)

-----------------------------------------------------------------
-- fish monger menu
-----------------------------------------------------------------
RegisterNetEvent('rex-fishmonger:client:mainmenu', function()
    lib.registerContext(
        {
            id = 'fishmonger_menu',
            title = locale('cl_lang_2'),
            position = 'top-right',
            options = {
                {   title = locale('cl_lang_3'),
                    description = locale('cl_lang_4'),
                    icon = 'fas fa-fish',
                    event = 'rex-fishmonger:client:selltofishmonger',
                },
                {   title = locale('cl_lang_13'),
                    description = locale('cl_lang_14'),
                    icon = 'fas fa-fish',
                    event = 'rex-fishmonger:client:processfish',
                },
                {
                    title = locale('cl_lang_5'),
                    description = locale('cl_lang_6'),
                    icon = 'fas fa-shopping-basket',
                    event = 'rex-fishmonger:client:openfishmongershop',
                },
            }
        }
    )
    lib.showContext('fishmonger_menu')
end)

-----------------------------------------------------------------
-- process bar before selling
-----------------------------------------------------------------
RegisterNetEvent('rex-fishmonger:client:selltofishmonger', function()
    LocalPlayer.state:set("inv_busy", true, true) -- lock inventory
    if lib.progressBar({
        duration = Config.SellTime,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disableControl = true,
        disable = {
            move = true,
            mouse = true,
        },
        label = locale('cl_lang_12'),
    }) then
        TriggerServerEvent('rex-fishmonger:server:sellfish')
    end
    LocalPlayer.state:set("inv_busy", false, true) -- unlock inventory
end)

-----------------------------------------------------------------
-- process bar before processing
-----------------------------------------------------------------
RegisterNetEvent('rex-fishmonger:client:processfish', function()
    LocalPlayer.state:set("inv_busy", true, true) -- lock inventory
    if lib.progressBar({
        duration = Config.SellTime,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disableControl = true,
        disable = {
            move = true,
            mouse = true,
        },
        label = locale('cl_lang_15'),
    }) then
        TriggerServerEvent('rex-fishmonger:server:processfish')
    end
    LocalPlayer.state:set("inv_busy", false, true) -- unlock inventory
end)

-----------------------------------------------------------------
-- player processfish
-----------------------------------------------------------------
RegisterNetEvent('rex-fishmonger:client:playerprocessfish', function()
    local hasItem = RSGCore.Functions.HasItem('weapon_melee_knife', 1)
    if not hasItem then
        lib.notify({ title = locale('cl_lang_16'), description = locale('cl_lang_17'), type = 'error', duration = 5000 })
        return
    end
    LocalPlayer.state:set("inv_busy", true, true) -- lock inventory
    if lib.progressBar({
        duration = Config.SellTime,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disableControl = true,
        disable = {
            move = true,
            mouse = true,
        },
        label = locale('cl_lang_15'),
    }) then
        TriggerServerEvent('rex-fishmonger:server:processfish')
    end
    LocalPlayer.state:set("inv_busy", false, true) -- unlock inventory
end)

-----------------------------------------------------------------
-- fish monger shop
-----------------------------------------------------------------
RegisterNetEvent('rex-fishmonger:client:openfishmongershop')
AddEventHandler('rex-fishmonger:client:openfishmongershop', function()
    TriggerServerEvent('rsg-shops:server:openstore', 'fishmonger', 'fishmonger', 'Fishmonger Shop')
end)
