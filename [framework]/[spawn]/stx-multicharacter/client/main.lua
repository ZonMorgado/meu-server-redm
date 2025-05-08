
RegisterNetEvent('rsg-multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    isChossing = false
end)

RegisterNetEvent('rsg-multicharacter:client:chooseChar', function()
    SetEntityVisible(PlayerPedId(), false, false)
    -- SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Wait(1000)
    GetInteriorAtCoords(2960.2480, 484.1753, 47.3509, 267.9686)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), 2960.2480, 484.1753, 47.3509)

    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    Wait(10)
    exports.weathersync:setMyTime(0, 0, 0, 0, true)
    openCharMenu(true)
    while selectingChar do
        Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        DrawLightWithRange(coords.x, coords.y , coords.z + 1.0 , 255, 255, 255, 5.5, 50.0)
    end
end)

-- NUI

RegisterNetEvent("rsg-multicharacter:client:SpawnCharcterData", function(data)
    local cData = data.cData
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        RSGCore.Functions.TriggerCallback('rsg-multicharacter:server:getAppearance', function(appearance)
            local skinTable = appearance.skin or {}
            DataSkin = appearance.skin
            local clothesTable = appearance.clothes or {}
            local sex = tonumber(skinTable.sex) == 1 and `mp_male` or `mp_female`
            if sex ~= nil then
                CreateThread(function ()
                    RequestModel(sex)
                    while not HasModelLoaded(sex) do
                        Wait(0)
                    end
                    charPed = CreatePed(sex, 2958.8132, 482.9178, 47.7686 - 1, 291.0331, false, false)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    while not IsPedReadyToRender(charPed) do
                        Wait(1)
                    end
                    exports['rsg-appearance']:ApplySkinMultiChar(skinTable, charPed, clothesTable)
                end)
            else
                CreateThread(function()
                    local randommodels = {
                        "mp_male",
                        "mp_female",
                    }
                    local randomModel = randommodels[math.random(1, #randommodels)]
                    local model = joaat(randomModel)
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    Wait(100)
                    baseModel(randomModel)
                    charPed = CreatePed(model, 2958.8132, 482.9178, 47.7686 - 1, 291.0331, false, false)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
        end, cData.citizenid)
    else
        CreateThread(function()
            local randommodels = {
                "mp_male",
                "mp_female",
            }
            local randomModel = randommodels[math.random(1, #randommodels)]
            local model = joaat(randomModel)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            charPed = CreatePed(model, 2958.8132, 482.9178, 47.7686 - 1, 291.0331, false, false)
            Wait(100)
            baseModel(randomModel)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            NetworkSetEntityInvisibleToNetwork(charPed, true)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
    end

end)

RegisterNetEvent("rsg-multicharacter:client:selectcharacter", function(data)
    selectingChar = false
    local cData = data.cData
    print(DataSkin)
    if DataSkin ~= nil then
        DoScreenFadeOut(10)
        TriggerServerEvent('rsg-multicharacter:server:loadUserData', cData)
        openCharMenu(false)
        local model = IsPedMale(charPed) and 'mp_male' or 'mp_female'
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
        Wait(5000)
        TriggerServerEvent('rsg-appearance:server:LoadSkin')
        Wait(500)
        TriggerServerEvent('rsg-appearance:server:LoadClothes', 1)
        SetModelAsNoLongerNeeded(model)
    else
        DoScreenFadeOut(10)
        TriggerServerEvent('rsg-multicharacter:server:loadUserData', cData, true)
        openCharMenu(false)
        local model = IsPedMale(charPed) and 'mp_male' or 'mp_female'
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
        SetModelAsNoLongerNeeded(model)
    end
end)

RegisterNetEvent("rsg-multicharacter:client:CreateNewCharacter", function(data)
    selectingChar = false
    DoScreenFadeOut(150)
    Wait(200)
    TriggerEvent("rsg-multicharacter:client:closeNUI")
    DestroyAllCams(true)
    SetModelAsNoLongerNeeded(charPed)
    DeleteEntity(charPed)
    DoScreenFadeIn(1000)
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerEvent('rsg-appearance:client:OpenCreator', data)
end)


-- RegisterNUICallback('disconnectButton', function()
--     SetEntityAsMissionEntity(charPed, true, true)
--     DeleteEntity(charPed)
--     TriggerServerEvent('rsg-multicharacter:server:disconnect')
-- end)


-- RegisterNUICallback('removeBlur', function()
--     SetTimecycleModifier('default')
-- end)


-- RegisterNUICallback('removeCharacter', function(data) -- Removing a char
--     TriggerServerEvent('rsg-multicharacter:server:deleteCharacter', data.citizenid)
--     TriggerEvent('rsg-multicharacter:client:chooseChar')
-- end)

-- unstick player from start location
CreateThread(function()
    if LocalPlayer.state['isLoggedIn'] then
        exports['rsg-core']:createPrompt('unstick', vector3(-549.77, -3778.38, 238.60), RSGCore.Shared.Keybinds['J'], 'Set Me Free!', {
            type = 'client',
            event = 'rsg-multicharacter:client:unstick',
        })
    end
end)

RegisterNetEvent('rsg-multicharacter:client:unstick', function()
    SetEntityCoordsNoOffset(cache.ped, vector3(-169.47, 629.38, 114.03), true, true, true)
    FreezeEntityPosition(cache.ped, false)
end)