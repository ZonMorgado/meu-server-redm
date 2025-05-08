local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

-----------------------------------------------------------------------
-- blips
-----------------------------------------------------------------------
Citizen.CreateThread(function()
    for _,v in pairs(Config.PortLocations) do  
        local PortBlip = BlipAddForCoords(1664425300, v.coords)
        SetBlipSprite(PortBlip, joaat(Config.Blip.blipSprite), true)
        SetBlipScale(PortBlip, Config.Blip.blipScale)
        SetBlipName(PortBlip, Config.Blip.blipName)
    end
end)

RegisterNetEvent('rex-guarma:client:mainmenu', function(currentport)
    if currentport == 'stdenis'then
        lib.registerContext(
            {
                id = 'guarma_main_menu',
                title = 'St Denis Port Menu',
                position = 'top-right',
                options = {
                    {   
                        title = locale('cl_lang_1'),
                        icon = 'fa-solid fa-ticket',
                        event = 'rex-guarma:client:buyticket',
                    },
                    {
                        title = locale('cl_lang_11'),
                        icon = 'fa-solid fa-ferry',
                        event = 'rex-guarma:client:dotravel',
                        args = { destination = 'guarma'}
                    },
                }
            }
        )
        lib.showContext('guarma_main_menu')
    else
        lib.registerContext(
            {
                id = 'guarma_main_menu',
                title = locale('cl_lang_12'),
                position = 'top-right',
                options = {
                    {   
                        title = locale('cl_lang_1'),
                        icon = 'fa-solid fa-ticket',
                        event = 'rex-guarma:client:buyticket',
                    },
                    {
                        title = locale('cl_lang_13'),
                        icon = 'fa-solid fa-ferry',
                        event = 'rex-guarma:client:dotravel',
                        args = { destination = 'stdenis'}
                    },
                }
            }
        )
        lib.showContext('guarma_main_menu')
    end
end)

-------------------------------------------------------------------------------------------
-- buy tickets
-------------------------------------------------------------------------------------------
RegisterNetEvent('rex-guarma:client:buyticket', function()
    local input = lib.inputDialog(locale('cl_lang_1'), {
        { 
            label = locale('cl_lang_2'),
            description = locale('cl_lang_3')..Config.TicketCost,
            type = 'input',
            min = 1,
            max = 10,
            required = true,
            icon = 'fa-solid fa-hashtag'
        },
    })
    if not input then return end
    TriggerServerEvent('rex-guarma:server:buyticket', tonumber(input[1]))
end)

-----------------------------------------------------------------------
-- travel
-----------------------------------------------------------------------
RegisterNetEvent('rex-guarma:client:dotravel')
AddEventHandler('rex-guarma:client:dotravel', function(data)
    local hasItem = RSGCore.Functions.HasItem('boat_ticket', 1)
    
    if hasItem then
        if data.destination == 'guarma' then
            TriggerServerEvent('rex-guarma:server:removeItem', 'boat_ticket', 1)
            DoScreenFadeOut(500)
            Wait(1000)
            Citizen.InvokeNative(0x203BEFFDBE12E96A, cache.ped, 2652.301, -1586.043, 48.337059 -1, 183.40074)
            Wait(1500)
            DoScreenFadeIn(1800)
            SetCinematicModeActive(true)
            Wait(10000)
            Citizen.InvokeNative(0x1E5B70E53DB661E5, 0, 0, 0, locale('cl_lang_4'), locale('cl_lang_5'), locale('cl_lang_6'))
            Wait(20000)
            Citizen.InvokeNative(0x74E2261D2A66849A, 1)
            Citizen.InvokeNative(0xA657EC9DBC6CC900, 1935063277)
            Citizen.InvokeNative(0xE8770EE02AEE45C2, 1)
            Citizen.InvokeNative(0x203BEFFDBE12E96A, cache.ped, 1268.4954, -6853.771, 43.318477 -1, 241.44442)
            SetCinematicModeActive(false)
            ShutdownLoadingScreen()
        end
        
        if data.destination == 'stdenis' then
            TriggerServerEvent('rex-guarma:server:removeItem', 'boat_ticket', 1)
            DoScreenFadeOut(500)
            Wait(1000)
            Citizen.InvokeNative(0x1E5B70E53DB661E5, 0, 0, 0, locale('cl_lang_7'), locale('cl_lang_8'), locale('cl_lang_9'))
            Wait(30000)
            Citizen.InvokeNative(0x74E2261D2A66849A, 0)
            Citizen.InvokeNative(0xA657EC9DBC6CC900, -1868977180)
            Citizen.InvokeNative(0xE8770EE02AEE45C2, 0)
            Citizen.InvokeNative(0x203BEFFDBE12E96A, cache.ped, 2663.2485, -1544.214, 45.969753 -1, 266.12268)
            ShutdownLoadingScreen()
            DoScreenFadeIn(1000)
            Wait(1000)
            SetCinematicModeActive(false)
        end
    else
        lib.notify({ title = locale('cl_lang_10'), duration = 5000, type = 'error' })
    end
end)

-----------------------------------------------------------------------
--Toggle guarma world stuff
-----------------------------------------------------------------------
function SetGuarmaWorldhorizonActive(toggle)
    Citizen.InvokeNative(0x74E2261D2A66849A , toggle)
end

function SetWorldWaterType(waterType)
    Citizen.InvokeNative(0xE8770EE02AEE45C2, waterType)
    local waveDirection = 0 -- 1 and 2 
    local waveAmount = 1.28 -- amount of waves
    local waveSpeed = 1.86  -- wave animation speed
    SetOceanGuarmaWaterQuadrant(0.1, 50.04, waveDirection, 1.15, waveAmount, -1082130432, waveSpeed, 8.1, 1)
end

function SetWorldMapType(mapType)
    Citizen.InvokeNative(0xA657EC9DBC6CC900, mapType)
end

function IsInGuarma()
    local x, y, z = table.unpack(GetEntityCoords(cache.ped))
    return x >= 0 and y <= -4096
end

local GuarmaMode = false

CreateThread(function()
    while true do
        Wait(500)

        if IsInGuarma() then
            if not GuarmaMode then
                SetGuarmaWorldhorizonActive(true);
                SetWorldWaterType(1);
                SetWorldMapType(`guarma`)
                GuarmaMode = true
            end
        else
            if GuarmaMode then
                SetGuarmaWorldhorizonActive(false);
                SetWorldWaterType(0);
                SetWorldMapType(`world`)
                GuarmaMode = false
            end
        end
    end
end)
