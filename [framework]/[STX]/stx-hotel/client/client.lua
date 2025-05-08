local RSGCore = exports['rsg-core']:GetCoreObject()
local isLoggedIn = false

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

--------------------------------------------------------------------------------------------------

-- hotel prompts
Citizen.CreateThread(function()
    for hotel, v in pairs(Config.HotelLocations) do
        exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds['J'], Lang:t('menu.open') .. v.name, {
            type = 'client',
            event = 'stx-hotel:client:menu',
            args = { v.name, v.location },
        })
        if v.showblip == true then
            local HotelBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(HotelBlip, joaat(Config.Blip.blipSprite), true)
            SetBlipScale(HotelBlip, Config.Blip.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, HotelBlip, Config.Blip.blipName)
        end
    end
end)

RegisterNetEvent('stx-hotel:client:menu', function(hotelname, hotellocation)
    TriggerEvent('rsg-horses:client:FleeHorse')
--     lib.registerContext(
--         {
--             id = 'hotel_menu',
--             title = hotelname,
--             position = 'top-right',
--             options = {
--                 {
--                     title = Lang:t('menu.check_in'),
--                     description = '',
--                     icon = 'fas fa-concierge-bell',
--                     serverEvent = 'stx-hotel:server:CheckIn',
--                     args = {
--                         location = hotellocation
--                     }
--                 },
--                 {
--                     title = Lang:t('menu.rent_room_deposit',{startCredit = Config.StartCredit}),
--                     description = '',
--                     icon = 'fas fa-bed',
--                     serverEvent = 'stx-hotel:server:RentRoom',
--                     args = {
--                         location = hotellocation
--                     }
--                 },
--             }
--         }
--     )
--     lib.showContext('hotel_menu')
-- end)

local hotel_menu = jo.menu.create('hotel_menu', {
    title = hotelname,
    onEnter = function()
    end,
    onBack = function()
        jo.menu.show(false)  -- Hide the menu
    end,
    onExit = function()
    end,
})

-------------
-- Add items to the menu
-------------

hotel_menu:addItem({
    title = Lang:t('menu.check_in'),
    --subtitle = '<span style="font-size: 20px;">' ..locale('cl_lang_4').. '</span>',
    icon = "meat",
    onClick = function()
        TriggerServerEvent('stx-hotel:server:CheckIn', hotellocation)
        jo.menu.show(false)
    end,
})

hotel_menu:addItem({
    title = Lang:t('menu.rent_room_deposit',{startCredit = Config.StartCredit}),
    --subtitle = '<span style="font-size: 20px;">' ..locale('cl_lang_14').. '</span>',
    icon = "horse_saddlebags",
    onClick = function()
        TriggerServerEvent('stx-hotel:server:RentRoom', hotellocation) 
        jo.menu.show(false)
    end,
})

-------------
-- Send the menu to the NUI
-------------
hotel_menu:send()

-------------
-- Show the menu
-------------
jo.menu.setCurrentMenu('hotel_menu',false,true)
jo.menu.show(true)  -- Display the menu
end)

--------------------------------------------------------------------------------------------------

-- transfer player to room
RegisterNetEvent('stx-hotel:client:gotoRoom', function(location)
    if location == 'valentine' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-323.935, 767.02294, 121.6327, 102.64147))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if location == 'strawberry' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-1813.903, -370.0737, 166.49919, 269.52258))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if location == 'rhodes' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(1331.4257, -1371.862, 80.490127, 259.164))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if location == 'stdenis' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(2637.925, -1222.1, 59.600513, 179.36787))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if location == 'blackwater' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-820.16, -1324.35, 47.97, 90.93))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if location == 'tumbleweed' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-5513.73, -2972.29, 2.22, 21.03))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if location == 'annesburg' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(2946.09, 1330.59, 44.46, 167.87))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
end)

--------------------------------------------------------------------------------------------------

-- room menu prompt
Citizen.CreateThread(function()
    for hotelexit, v in pairs(Config.HotelRoom) do
        exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds['J'], Lang:t('menu.room_menu'), {
            type = 'client',
            event = 'stx-hotel:client:roommenu',
            args = { v.location },
        })
    end
end)

RegisterNetEvent('stx-hotel:client:roommenu', function(location)
    RSGCore.Functions.TriggerCallback('stx-hotel:server:GetActiveRoom', function(result)
        -- lib.registerContext(
        --     {
        --         id = 'room_menu',
        --         title = Lang:t('menu.hotel_room')..result.roomid,
        --         position = 'top-right',
        --         options = {
        --             {
        --                 title = Lang:t('menu.add_credit'),
        --                 description = Lang:t('text.current_credit')..result.credit,
        --                 icon = 'fas fa-dollar-sign',
        --                 event = 'stx-hotel:client:addcredit',
        --                 args = { room = result.roomid, credit = result.credit },
        --             },
        --             {
        --                 title = Lang:t('menu.wardrobe'),
        --                 description = '',
        --                 icon = 'fas fa-hat-cowboy-side',
        --                 event = 'rsg-appearance:client:ClockRoom',
        --                 args = { },
        --             },
        --             {
        --                 title = Lang:t('menu.room_locker'),
        --                 description = '',
        --                 icon = 'fas fa-box',
        --                 event = 'stx-hotel:client:roomlocker',
        --                 args = { roomid = result.roomid, location = result.location },
        --             },
        --             {
        --                 title = 'Mini-Bar',
        --                 description = '',
        --                 icon = 'fas fa-glass-cheers',
        --                 event = 'stx-hotel:client:minibar',
        --                 args = { roomid = result.roomid },
        --             },
        --             {
        --                 title = Lang:t('menu.leave_room'),
        --                 description = '',
        --                 icon = 'fas fa-door-open',
        --                 event = 'stx-hotel:client:leaveroom',
        --                 args = { exitroom = result.location },
        --             },
        --         }
        --     }
        -- )
        -- lib.showContext('room_menu')
        local room_menu = jo.menu.create('room_menu', {
            title = Lang:t('menu.hotel_room')..result.roomid,
            onEnter = function()
            end,
            onBack = function()
                jo.menu.show(false)  -- Hide the menu
            end,
            onExit = function()
            end,
        })
        
        -------------
        -- Add items to the menu
        -------------
        
        room_menu:addItem({
            title = Lang:t('menu.add_credit'),
            subtitle = '<span style="font-size: 20px;">' ..Lang:t('text.current_credit')..result.credit.. '</span>',
            icon = "meat",
            onClick = function()
                TriggerEvent('stx-hotel:client:addcredit', result.roomid, result.credit )
                jo.menu.show(false)
            end,
        })
        
        room_menu:addItem({
            title = Lang:t('menu.wardrobe'),
            --subtitle = '<span style="font-size: 20px;">' ..locale('cl_lang_14').. '</span>',
            icon = "horse_saddlebags",
            onClick = function()
                TriggerEvent('kd_clothingstore:openWardrobe') 
                jo.menu.show(false)
            end,
        })

        room_menu:addItem({
            title = Lang:t('menu.room_locker'),
            --subtitle = '<span style="font-size: 20px;">' ..locale('cl_lang_14').. '</span>',
            icon = "horse_saddlebags",
            onClick = function()
                TriggerEvent('stx-hotel:client:roomlocker', result.roomid, result.location ) 
                jo.menu.show(false)
            end,
        })

        room_menu:addItem({
            title = 'Mini-Bar',
            --subtitle = '<span style="font-size: 20px;">' ..locale('cl_lang_14').. '</span>',
            icon = "horse_saddlebags",
            onClick = function()
                TriggerEvent('stx-hotel:client:minibar', result.roomid) 
                jo.menu.show(false)
            end,
        })
        room_menu:addItem({
            title = Lang:t('menu.leave_room'),
            --subtitle = '<span style="font-size: 20px;">' ..locale('cl_lang_14').. '</span>',
            onClick = function()
                TriggerEvent('stx-hotel:client:leaveroom', result.location) 
                jo.menu.show(false)
            end,
        })
        
        -------------
        -- Send the menu to the NUI
        -------------
        room_menu:send()
        
        -------------
        -- Show the menu
        -------------
        jo.menu.setCurrentMenu('room_menu',false,true)
        jo.menu.show(true)  -- Display the menu
    end)
end)



--------------------------------------------------------------------------------------------------

RegisterNetEvent('stx-hotel:client:addcredit', function(roomid, credit)
    local input = lib.inputDialog(Lang:t('menu.add_credit_room')..roomid, {
        { 
            type = 'number',
            label = 'Add Credit', 
            icon = 'fa-solid fa-dollar-sign'
        },
    })
    
    if not input then
        return
    end
    
    local newcredit = (tonumber(input[1]) + credit)
    
    TriggerServerEvent('stx-hotel:server:addcredit', tonumber(newcredit), tonumber(input[1]), roomid)
end)

--------------------------------------------------------------------------------------------------

-- leave room
RegisterNetEvent('stx-hotel:client:leaveroom')
AddEventHandler('stx-hotel:client:leaveroom', function(exitroom)
    if Config.Debug == true then
        print(exitroom)
    end
    local roomlocation = exitroom
    if roomlocation == 'valentine' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('stx-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-328.99, 772.95, 117.45, 13.64))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if roomlocation == 'strawberry' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('stx-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-1814.274, -369.9327, 162.88313, 277.07699))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if roomlocation == 'rhodes' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('stx-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(1334.2458, -1368.744, 80.490165, 258.45336))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if roomlocation == 'stdenis' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('stx-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(2633.2497, -1223.527, 59.594661, 176.20422))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if roomlocation == 'blackwater' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('stx-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-819.7, -1313.11, 43.77, 248.03))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if roomlocation == 'tumbleweed' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('stx-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-5518.85, -2976.54, -0.78, 108.9))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if roomlocation == 'annesburg' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('stx-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(2946.28, 1333.36, 44.45, 55.87))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
end)

--------------------------------------------------------------------------------------------------

-- room storage locker
RegisterNetEvent('stx-hotel:client:roomlocker', function(roomid, location)
    local maxweight = Config.StorageMaxWeight
    local slots = Config.StorageMaxSlots
    local stashName = 'room_'..roomid..'_'..location
    TriggerServerEvent('stx-hotel:server:OpenStash', maxweight, slots, stashName )
end)



RegisterNetEvent('stx-hotel:client:minibar')
AddEventHandler('stx-hotel:client:minibar', function(roomid)
    local ShopItems = {}
    ShopItems.name = "MiniBar_"..math.random(1, 99)
    ShopItems.label = Lang:t('menu.room')..roomid..' Mini-Bar'
    ShopItems.items = Config.MiniBar
    ShopItems.slots = #Config.MiniBar
    TriggerServerEvent('stx-hotel:server:OpenShop', ShopItems)
end)

--------------------------------------------------------------------------------------------------

-- lock hotel doors
Citizen.CreateThread(function()
    for k,v in pairs(Config.HotelDoors) do
        Citizen.InvokeNative(0xD99229FE93B46286, v, 1,1,0,0,0,0)
        DoorSystemSetDoorState(v, 1) 
    end
end)

--[[
    DOORSTATE_INVALID = -1,
    0 = DOORSTATE_UNLOCKED,
    1 = DOORSTATE_LOCKED_UNBREAKABLE,
    2 = DOORSTATE_LOCKED_BREAKABLE,
    3 = DOORSTATE_HOLD_OPEN_POSITIVE,
    4 = DOORSTATE_HOLD_OPEN_NEGATIVE
--]]

--------------------------------------------------------------------------------------------------
