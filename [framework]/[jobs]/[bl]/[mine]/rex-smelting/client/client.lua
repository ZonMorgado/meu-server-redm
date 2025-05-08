local RSGCore = exports['rsg-core']:GetCoreObject()
local CategoryMenus = {}
lib.locale()

--------------------------------------
-- prompts and blips
--------------------------------------
Citizen.CreateThread(function()
    for _,v in pairs(Config.SmeltingLocations) do
        exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds[Config.Keybind], locale('cl_lang_1'), {
            type = 'client',
            event = 'rex-smelting:client:smeltingmenu'
        })
        if v.showblip == true then    
            local SmeltingBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(SmeltingBlip, joaat('blip_shop_blacksmith'), true)
            SetBlipScale(SmeltingBlip, 0.2)
            SetBlipName(SmeltingBlip, locale('cl_lang_2'))
        end
    end
end)

---------------------------------------------
-- smelting menu
---------------------------------------------
CreateThread(function()
    for _, v in ipairs(Config.Smelting) do
        local IngredientsMetadata = {}
        print("SHUFF")
        local setheader = RSGCore.Shared.Items[tostring(v.receive)].label
        local itemimg = "nui://"..Config.Image..RSGCore.Shared.Items[tostring(v.receive)].image

        for i, ingredient in ipairs(v.ingredients) do
            table.insert(IngredientsMetadata, { label = RSGCore.Shared.Items[ingredient.item].label, value = ingredient.amount })
        end

        local option = {
            title = setheader,
            icon = itemimg,
            event = 'rex-smelting:client:smeltitem',
            metadata = IngredientsMetadata,
            args = {
                title = setheader,
                category = v.category,
                ingredients = v.ingredients,
                smelttime = v.smelttime,
                receive = v.receive,
                giveamount = v.giveamount
            }
        }

        if not CategoryMenus[v.category] then
            CategoryMenus[v.category] = {
                id = 'smelting_menu_' .. v.category,
                title = v.category,
                menu = 'smelting_menu',
                onBack = function() end,
                options = { option }
            }
        else
            table.insert(CategoryMenus[v.category].options, option)
        end
    end
end)

CreateThread(function()
    for category, MenuData in pairs(CategoryMenus) do
        RegisterNetEvent('rex-smelting:client:' .. category)
        AddEventHandler('rex-smelting:client:' .. category, function()
            lib.registerContext(MenuData)
            lib.showContext(MenuData.id)
        end)
    end
end)

RegisterNetEvent('rex-smelting:client:smeltingmenu', function()
    local Menu = {
        id = 'smelting_menu',
        title = locale('cl_lang_3'),
        options = {}
    }

    for category, MenuData in pairs(CategoryMenus) do
        table.insert(Menu.options, {
            title = category,
            event = 'rex-smelting:client:' .. category,
            arrow = true
        })
    end

    lib.registerContext(Menu)
    lib.showContext(Menu.id)
end)

---------------------------------------------
-- smelt item
---------------------------------------------
RegisterNetEvent('rex-smelting:client:smeltitem', function(data)
    -- check smelting items
    RSGCore.Functions.TriggerCallback('rex-smelting:server:checkingredients', function(hasRequired)
        if hasRequired == true then
            LocalPlayer.state:set("inv_busy", true, true) -- lock inventory
            lib.progressBar({
                duration = tonumber(data.smelttime),
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disableControl = true,
                disable = {
                    move = true,
                    mouse = true,
                },
                label = locale('cl_lang_4').. RSGCore.Shared.Items[data.receive].label,
            })
            TriggerServerEvent('rex-smelting:server:finishsmelting', data)
            LocalPlayer.state:set("inv_busy", false, true) -- unlock inventory
        else
            lib.notify({ title = locale('cl_lang_5'), type = 'inform', duration = 7000 })
        end
    end, data.ingredients)
end)
