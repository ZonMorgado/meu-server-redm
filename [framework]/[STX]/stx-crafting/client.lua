local RSGCore = exports['rsg-core']:GetCoreObject()



for _, craftingConfig in ipairs(Config.CraftingMenus) do
    if craftingConfig.useEvent then
        RegisterNetEvent(craftingConfig.event, function()
            OpenCraftingMenu(craftingConfig)
        end)
    end
    RegisterCommand(craftingConfig.id, function()
        TriggerEvent(craftingConfig.event)
    end)
end



for _, craftingConfig in ipairs(Config.CraftingMenus) do
    exports['rsg-target']:AddBoxZone(craftingConfig.id, craftingConfig.coords, 1, 1, {
        name = craftingConfig.id,
        heading = craftingConfig.heading or 0,
        debugPoly = false,
        minZ = craftingConfig.minZ,
        maxZ = craftingConfig.maxZ
    }, {
        options = {
            {
                icon = "fas fa-utensils",
                label = "Start Crafting",
                action = function()
                    OpenCraftingMenu(craftingConfig)
                end,
                job = craftingConfig.jobaccess,
            }
        },
        distance = 2.0
    })
end



for _, cookingConfig in ipairs(Config.CookingMenus) do
    exports['rsg-target']:AddBoxZone(cookingConfig.id, cookingConfig.coords, 1, 1, {
        name = cookingConfig.id,
        heading = cookingConfig.heading or 0,
        debugPoly = false,
        minZ = cookingConfig.minZ,
        maxZ = cookingConfig.maxZ
    }, {
        options = {
            {
                icon = "fas fa-utensils",
                label = "Start Cooking",
                action = function()
                    OpenCookingMenu(cookingConfig)
                end
                
            }
        },
        distance = 2.0
    })
end



function OpenCraftingMenu(menuConfig)
    local craftingMenu = jo.menu.create(menuConfig.id .. 'MainMenu', {
        title = menuConfig.name,
        subtitle = "Select a category",
        onEnter = function()
            print('Entered ' .. menuConfig.name)
        end,
        onBack = function()
            jo.menu.show(false)
        end,
        onExit = function()
            print('Exited ' .. menuConfig.name)
        end,
    })

    -- Add categories dynamically
    for _, category in ipairs(menuConfig.categories) do
        craftingMenu:addItem({
            title = category,
            child = menuConfig.id .. category .. 'SubMenu'
        })

        local categoryMenu = jo.menu.create(menuConfig.id .. category .. 'SubMenu', {
            title = category,
            subtitle = "Select an item to craft",
            onEnter = function()
                print('Entered ' .. category .. ' Category Menu')
            end,
            onBack = function()
                print('Back to ' .. category .. ' Category Menu')
            end,
            onExit = function()
                print('Exited ' .. category .. ' Category Menu')
            end,
        })

        for _, item in ipairs(menuConfig.items) do
            if item.category == category then
                local itemImages = CreateItemImageDisplay(item.ingredients)

                categoryMenu:addItem({
                    title = RSGCore.Shared.Items[tostring(item.name)].label,
                    description = itemImages,
                    onClick = function()
                        jo.menu.show(false)
                        CraftItem(item)
                    end
                })
            end
        end
        categoryMenu:send()
    end

    craftingMenu:send()
    jo.menu.setCurrentMenu(menuConfig.id .. 'MainMenu', false, true)
    jo.menu.show(true)
end



function CraftItem(item)
    if HasRequirements(item.ingredients) then
        jo.notif.simpleTop('Crafting Started', "You just started crafting " .. item.name, 5000)
        if lib.progressBar({
            duration = 5000,
            label = 'Crafting ' .. item.name,
            disableControl = true,
            disable = {
                move = true,
                combat = true,
            },
            anim = { 
                dict = item.dict,
                clip = item.clip
            }
        }) then
            TriggerServerEvent('stx-crafting:server:MehnatKrBhadwe', item.name, item.ingredients, item.amount)
        else
            print('Crafting canceled')
        end
    else
        print('Missing Ingredients for: ' .. item.name)
    end
end



function OpenCookingMenu(menuConfig)
    local cookingMenu = jo.menu.create(menuConfig.id .. 'CookingMenu', {
        title = menuConfig.name,
        subtitle = "Select a dish to cook",
        onEnter = function()
            print('Entered Cooking Menu')
        end,
        onBack = function()
            jo.menu.show(false)
        end,
        onExit = function()
            print('Exited Cooking Menu')
        end,
    })

    for _, item in ipairs(menuConfig.items) do
        local itemImages = CreateItemImageDisplay(item.ingredients)

        cookingMenu:addItem({
            title = item.name,
            description = itemImages,
            onClick = function()
                jo.menu.show(false)
                CookItem(item)
            end
        })
    end

    cookingMenu:send()
    jo.menu.setCurrentMenu(menuConfig.id .. 'CookingMenu', false, true)
    jo.menu.show(true)
end



function CookItem(item)
    if HasRequirements(item.ingredients) then
        jo.notif.simpleTop('Cooking Started', "You just started cooking " .. item.name, 5000)
        if lib.progressBar({
            duration = 7000,
            label = 'Cooking ' .. item.name,
            disableControl = true,
            disable = {
                move = true,
                combat = true,
            },
            anim = {
                dict = 'amb_work@world_human_hammer@table@male_a@trans',
                clip = 'base_trans_base'
            }
        }) then
            TriggerServerEvent('stx-crafting:server:MehnatKrBhadwe', item.name, item.ingredients)
        else
            print('Cooking canceled')
        end
    else
        jo.notif.rightError("Missing Ingredients for: " .. item.name)
    end
end



function CreateItemImageDisplay(ingredients)
    local itemImages = ""
    for ingredientName, amount in pairs(ingredients) do
        local itemData = RSGCore.Shared.Items[tostring(ingredientName)] or {}
        local itemImage = itemData.image or "placeholder.png"
        local itemLabel = itemData.label or "ITEM NOT FOUND"
        itemImages = itemImages .. "<div style='display: inline-block; position: relative; margin-right: 10px; text-align: center;'>" ..
            "<img src='nui://rsg-inventory/html/images/" .. itemImage .. "' style='width: 90px; height: 90px; '>" ..
            "<span style='position: absolute; top: 2px; right: 2px; color: wheat; font-size: 15px; font-weight: bold; background-color: rgba(0, 0, 0, 1); padding: 2px 5px; border-radius: 3px;'>" ..
            amount .. "</span>" ..
            "<div style='margin-top: 5px; color: wheat; font-size: 14px; font-weight: bold;'>" .. itemLabel .. "</div>" ..
            "</div>"
    end
    return itemImages
end



function HasRequirements(requirements)
    local missing = {}
    for item, amount in pairs(requirements) do
        if not RSGCore.Functions.HasItem(item, amount) then
            table.insert(missing, string.format("%dx %s", amount, item))
        end
    end

    if #missing == 0 then
        return true
    else
        jo.notif.rightError("You are missing: " .. table.concat(missing, ", "))
        return false
    end
end

AddEventHandler("onResourceStop", function(resourceName)
    local resource = GetCurrentResourceName()
        if resource ~= resourceName then return end
        for _, craftingConfig in ipairs(Config.CraftingMenus) do
        exports['rsg-target']:RemoveZone(craftingConfig.id)
        end
        for _, cookingConfig in ipairs(Config.CookingMenus) do
            exports['rsg-target']:RemoveZone(cookingConfig.id)
        end
    end)