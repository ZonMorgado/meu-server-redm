RSGCore = exports[Config.CoreSettings.coreName]:GetCoreObject()
charPed = nil
selectingChar = true
isChossing = false
DataSkin = nil

CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            Wait(500)
            TriggerEvent('rsg-multicharacter:client:chooseChar')
            return
        end
    end
end)

local cams = {
    {
        type = "customization",
        x = -561.8157,
        y = -3780.966,
        z = 239.0805,
        rx = -4.2146,
        ry = -0.0007,
        rz = -87.8802,
        fov = 30.0
    },
    {
        type = "selection",
        x = -562.8157,
        y = -3776.266,
        z = 239.0805,
        rx = -4.2146,
        ry = -0.0007,
        rz = -87.8802,
        fov = 30.0
    }
}

function baseModel(sex)
    if (sex == 'mp_male') then
        ApplyShopItemToPed(charPed, 0x158cb7f2, true, true, true); --head
        ApplyShopItemToPed(charPed, 361562633,  true, true, true); --hair
        ApplyShopItemToPed(charPed, 62321923,   true, true, true); --hand
        ApplyShopItemToPed(charPed, 3550965899, true, true, true); --legs
        ApplyShopItemToPed(charPed, 612262189,  true, true, true); --Eye
        ApplyShopItemToPed(charPed, 319152566,  true, true, true); --
        ApplyShopItemToPed(charPed, 0x2CD2CB71, true, true, true); -- shirt
        ApplyShopItemToPed(charPed, 0x151EAB71, true, true, true); -- bots
        ApplyShopItemToPed(charPed, 0x1A6D27DD, true, true, true); -- pants
    else
        ApplyShopItemToPed(charPed, 0x1E6FDDFB, true, true, true); -- head
        ApplyShopItemToPed(charPed, 272798698,  true, true, true); -- hair
        ApplyShopItemToPed(charPed, 869083847,  true, true, true); -- Eye
        ApplyShopItemToPed(charPed, 736263364,  true, true, true); -- hand
        ApplyShopItemToPed(charPed, 0x193FCEC4, true, true, true); -- shirt
        ApplyShopItemToPed(charPed, 0x285F3566, true, true, true); -- pants
        ApplyShopItemToPed(charPed, 0x134D7E03, true, true, true); -- bots
    end
end

function skyCam(bool)
    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
        SetCamCoord(cam, Config.MulticharacterHandler.cam1.x, Config.MulticharacterHandler.cam1.y, Config.MulticharacterHandler.cam1.z)
        SetCamRot(cam, Config.MulticharacterHandler.cam1rot.x, Config.MulticharacterHandler.cam1rot.y, Config.MulticharacterHandler.cam1rot.z)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        fixedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
        SetCamCoord(fixedCam, Config.MulticharacterHandler.cam2.x, Config.MulticharacterHandler.cam2.y, Config.MulticharacterHandler.cam2.z)
        SetCamRot(fixedCam, Config.MulticharacterHandler.cam2rot.x, Config.MulticharacterHandler.cam2rot.y, Config.MulticharacterHandler.cam2rot.z)
        SetCamActive(fixedCam, true)
        SetCamActiveWithInterp(fixedCam, cam, 3900, true, true)
        Wait(3900)
        DestroyCam(groundCam)
        InterP = true
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

-- Handlers

AddEventHandler('onResourceStop', function(resource)
    if (GetCurrentResourceName() == resource) then
        DeleteEntity(charPed)
        SetModelAsNoLongerNeeded(charPed)
    end
end)

local id = "rsg_multicharacter"
local menu = jo.menu.create('rsg_multicharacter',{
    title = Config.MenuSettings.Header, --The big title of the menu
    subtitle = Config.MenuSettings.SubTitle, --The subtitle of the menu
    onEnter = function(currentData)
        print('Enter in menu '..id)
    end,
    onExit = function(currentData)
        print('Exit menu '..id)
    end,
})

function openCharMenu(bool)
    local ch = {}
    local num = 0
    local cidstarter = 0
    if bool == false then
        jo.menu.show(false)
        skyCam(false)
        return
    end
    RSGCore.Functions.TriggerCallback("rsg-multicharacter:server:AchieveConfigInformation", function(result)
        RSGCore.Functions.TriggerCallback("rsg-multicharacter:server:CharacterSetUpCallback", function(result2)
            choosingCharacter = bool
            if result2 then
                for k, v in pairs (result2) do
                    menu:addItem({
                        title = v.charinfo.firstname .. " " .. v.charinfo.lastname,
                        textRight = v.cid,
                        icon = "lifestyle",
                        statistics = {
                            {label = "Citizen ID", value = v.citizenid},
                            {label = "CID", value = v.cid},
                            {label = "Job", value = v.job.label.. " - " ..v.job.grade.name},
                            {label = "Nationality", value = v.charinfo.nationality},
                            {label = "Birth Date", value = v.charinfo.birthdate},
                            
                        },
                        onActive = function(currentData)
                            local db = {
                                cData = v,
                            }
                            TriggerEvent('rsg-multicharacter:client:SpawnCharcterData', db)
                        end,
                        onClick = function(currentData)
                            local db = {
                                cData = v,
                            }
                            TriggerEvent("rsg-multicharacter:client:selectcharacter", db)
                        end,
                    })
                    if cidstarter < v.cid then
                        cidstarter = v.cid
                    end
                    num = num + 1
                end
            end
            local checker = result - num
            for i = 1, checker do
                cidstarter = cidstarter + 1
                menu:addItem({
                    title = "Empty Slot",
                    data = {
                        id = cidstarter,
                    },
                    onActive = function(currentData)
                        local db = {
                            cData = nil
                        }
                        TriggerEvent('rsg-multicharacter:client:SpawnCharcterData', db)
                    end,
                    onClick = function(currentData)
                        local db = {
                            cid = currentData.item.data.id,
                        }
                        openCharMenu(false)
                        TriggerEvent("rsg-multicharacter:client:CreateNewCharacter", db)
                    end,
                })
            end
            menu:use(false)
            menu:send()
            jo.menu.setCurrentMenu('rsg_multicharacter')
            jo.menu.show(true)
            Wait(100)
            skyCam(bool)
        end)
    end)
end