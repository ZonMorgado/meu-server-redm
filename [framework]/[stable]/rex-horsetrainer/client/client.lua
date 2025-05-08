local RSGCore = exports['rsg-core']:GetCoreObject()
local cleancooldownSecondsRemaining = 0
local feedcooldownSecondsRemaining = 0
local horsePed = 0
local horse = 0
local horseEXP = 0
local maxedEXP = false
lib.locale()

--------------------------------------
-- horse trainer shop blips
--------------------------------------
CreateThread(function()
    for _,v in pairs(Config.HorseTrainerLocations) do
        if v.showblip == true then
            local HorseTrainerBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(HorseTrainerBlip, joaat(Config.Blip.blipSprite), true)
            SetBlipScale(HorseTrainerBlip, Config.Blip.blipScale)
            SetBlipName(HorseTrainerBlip, Config.Blip.blipName)
        end
    end
end)

-----------------------------
-- check horse EXP
-----------------------------
local function CheckEXP()
    RSGCore.Functions.TriggerCallback('rsg-horses:server:GetActiveHorse', function(data)
        horseEXP = data.horsexp
    end)
    maxedEXP = false
end

-----------------------------
-- cleaning cooldown timer
-----------------------------
local function CleaningCooldown()
    cleancooldownSecondsRemaining = (Config.BrushCooldown * 60)
    CreateThread(function()
        while cleancooldownSecondsRemaining > 0 do
            Wait(1000)
            cleancooldownSecondsRemaining = cleancooldownSecondsRemaining - 1
            if Config.Debug then
                print(cleancooldownSecondsRemaining)
            end
        end
    end)
end

-----------------------------
-- feeding cooldown timer
-----------------------------
local function FeedingCooldown()
    feedcooldownSecondsRemaining = (Config.FeedCooldown * 60)
    CreateThread(function()
        while feedcooldownSecondsRemaining > 0 do
            Wait(1000)
            feedcooldownSecondsRemaining = feedcooldownSecondsRemaining - 1
            if Config.Debug then
                print(feedcooldownSecondsRemaining)
            end
        end
    end)
end

-----------------------------
-- brush horse xp
-----------------------------
RegisterNetEvent('rex-horsetrainer:client:brushhorse', function(item)
    local hasCertificate = RSGCore.Functions.HasItem('trainer_certificate', 1)
    if not hasCertificate then
        lib.notify({ title = locale('cl_lang_1'), description = locale('cl_lang_2'), type = 'error', duration = 7000 })
        return
    end
    if cleancooldownSecondsRemaining ~= 0 then
        lib.notify({ title = locale('cl_lang_3'), description = locale('cl_lang_4') ..cleancooldownSecondsRemaining.. locale('cl_lang_5'), type = 'error', duration = 7000 })
        return
    end
    horse = GetLastMount(cache.ped)
    horsePed = exports['rsg-horses']:CheckActiveHorse()
    local hasItem = RSGCore.Functions.HasItem(item, 1)
    if hasItem and horse == horsePed and IsPedOnMount(cache.ped) then
        Citizen.InvokeNative(0xCD181A959CFDD7F4, cache.ped, horsePed, `INTERACTION_BRUSH`, 0, 0)
        Wait(8000)
        Citizen.InvokeNative(0xE3144B932DFDFF65, horsePed, 0.0, -1, 1, 1)
        ClearPedEnvDirt(horsePed)
        ClearPedDamageDecalByZone(horsePed, 10, 'ALL')
        ClearPedBloodDamage(horsePed)
        PlaySoundFrontend('Core_Fill_Up', 'Consumption_Sounds', true, 0)
        CleaningCooldown()
        CheckEXP()
        if horseEXP >= 5000 then
            lib.notify({ title = locale('cl_lang_6'), description = locale('cl_lang_7'), type = 'error', duration = 7000 })
            return
        end
        TriggerServerEvent('rex-horsetrainer:server:updatexp', Config.BrushXP)
    end
end)

-----------------------------
-- feed horse xp
-----------------------------
RegisterNetEvent('rex-horsetrainer:client:feedhorse', function(item)
    local hasCertificate = RSGCore.Functions.HasItem('trainer_certificate', 1)
    if not hasCertificate then
        lib.notify({ title = locale('cl_lang_1'), description = locale('cl_lang_2'), type = 'error', duration = 7000 })
        return
    end
    if feedcooldownSecondsRemaining ~= 0 then
        lib.notify({ title = locale('cl_lang_8'), description = locale('cl_lang_4') ..feedcooldownSecondsRemaining.. locale('cl_lang_5'), type = 'error', duration = 7000 })
        return
    end
    horse = GetLastMount(cache.ped)
    horsePed = exports['rsg-horses']:CheckActiveHorse()
    local hasItem = RSGCore.Functions.HasItem(item, 1)
    if hasItem and horse == horsePed and IsPedOnMount(cache.ped) then
        Citizen.InvokeNative(0xCD181A959CFDD7F4, cache.ped, horsePed, -224471938, 0, 0)
        local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, horsePed, 0)
        if not tonumber(valueHealth) then valueHealth = 0 end
        Wait(3500)
        Citizen.InvokeNative(0xC6258F41D86676E0, horsePed, 0, valueHealth + Config.HealthIncrease)
        PlaySoundFrontend('Core_Fill_Up', 'Consumption_Sounds', true, 0)
        FeedingCooldown()
        CheckEXP()
        if horseEXP >= 5000 then
            lib.notify({ title = locale('cl_lang_6'), description = locale('cl_lang_7'), type = 'error', duration = 7000 })
            return
        end
        TriggerServerEvent('rex-horsetrainer:server:updatexp', Config.FeedXP)
        TriggerServerEvent('rex-horsetrainer:server:deleteItem', item, 1)
    end
end)

-----------------------------
-- riding horse xp
-----------------------------
CreateThread(function()
    while true do
        if LocalPlayer.state['isLoggedIn'] then
            horse = GetLastMount(cache.ped)
            horsePed = exports['rsg-horses']:CheckActiveHorse()
            local hasCertificate = RSGCore.Functions.HasItem('trainer_certificate', 1)
            if not IsPedStopped(horsePed) and horse == horsePed and IsPedOnMount(cache.ped) and hasCertificate then
                CheckEXP()
                if horseEXP >= 5000 then
                    return
                end
                TriggerServerEvent('rex-horsetrainer:server:updatexp', Config.RidingXP)
            end
        end
        Wait(Config.RidingWait)
    end
end)

-----------------------------
-- leading horse xp
-----------------------------
CreateThread(function()
    while true do
        if LocalPlayer.state['isLoggedIn'] then
            horse = GetLastMount(cache.ped)
            horsePed = exports['rsg-horses']:CheckActiveHorse()
            local hasCertificate = RSGCore.Functions.HasItem('trainer_certificate', 1)
            if horsePed ~= 0 and horse ~= 0 then
                if IsPedLeadingHorse(horsePed) and horse == horsePed and not IsPedOnMount(cache.ped) and not IsPedStopped(horsePed) and hasCertificate then
                    CheckEXP()
                    if horseEXP >= 5000 then
                        return
                    end
                    TriggerServerEvent('rex-horsetrainer:server:updatexp', Config.LeadingXP)
                end
            end
        end
        Wait(Config.LeadingWait)
    end
end)

-----------------------------
-- horse trainer shop
-----------------------------
RegisterNetEvent('rex-horsetrainer:client:openshop', function()
    local hasCertificate = RSGCore.Functions.HasItem('trainer_certificate', 1)
    if not hasCertificate then
        lib.notify({ title = locale('cl_lang_1'), description = locale('cl_lang_2'), type = 'error', duration = 7000 })
        return
    end
    TriggerServerEvent('rsg-shops:server:openstore', 'horsetrainer', 'horsetrainer', 'Horse Trainer')
end)
