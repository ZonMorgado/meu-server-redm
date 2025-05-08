local RSGCore = exports['rsg-core']:GetCoreObject()
local cocaineshop

-- prompts
Citizen.CreateThread(function()
    for cocaineshop, v in pairs(Config.CocaineShopLocations) do
        exports['rsg-core']:createPrompt(v.location, v.coords, RSGCore.Shared.Keybinds['J'], 'Open ' .. v.name, {
            type = 'client',
            event = 'rsg-cocaine:client:openMenu',
            args = {},
        })
        if v.showblip == true then
            local cocaineBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(cocaineBlip, Config.Blip.blipSprite, 1)
            SetBlipScale(cocaineBlip, Config.Blip.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, cocaineBlip, Config.Blip.blipName)
        end
    end
end)

-- draw marker if set to true in config
CreateThread(function()
    while true do
        local sleep = 0
        for cocaineshop, v in pairs(Config.CocaineShopLocations) do
            if v.showmarker == true then
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x07DCE236, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 215, 0, 155, false, false, false, 1, false, false, false)
            end
        end
        Wait(sleep)
    end
end)

-- outlaw menu
RegisterNetEvent('rsg-cocaine:client:openMenu', function(data)

    lib.registerContext({
        id = 'rsg_cocaine_menu',
        title = 'TRADER',
        menu = 'rsg_cocaine_menu__',
        options = {
            {
                title = 'Trade 10 Cocaine Leaves',
                event = "rsg-cocaine:server:tradecocaine",
                args = {
                    trade = 1,
                },
            },
            {
                title = 'Trade 50 Cocaine Leaves',
                event = "rsg-cocaine:server:tradecocaine",
                args = {
                    trade = 5,
                },
            },
            {
                title = 'Trade 100 Cocaine Leaves',
                event = "rsg-cocaine:server:tradecocaine",
                args = {
                    trade = 10,
                },
            }
        }
    })
     
    lib.showContext('rsg_cocaine_menu')

end)

-- Cocaine trader shop
RegisterNetEvent('rsg-cocaine:client:OpenCocaineShop')
AddEventHandler('rsg-cocaine:client:OpenCocaineShop', function()
    local ShopItems = {}
    ShopItems.label = "Cocaine Trader"
    ShopItems.items = Config.CocaineShop
    ShopItems.slots = #Config.CocaineShop
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "cocaineShop_"..math.random(1, 99), ShopItems)
end)