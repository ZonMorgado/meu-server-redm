local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent('CoolsMining:miningResult')
AddEventHandler('CoolsMining:miningResult', function()
    local source = source
    local Player = RSGCore.Functions.GetPlayer(source)

    for _, metal in ipairs(Config.metals) do
        print(metal.name, metal.rarity)
    end

    for _, gem in ipairs(Config.gems) do
        print(gem.name, gem.rarity)
    end

    -- Select two items
    local itemsFound = {}
    local numItemsFound = 0

    -- Select a metal
    local metalIndex = math.random(1, #Config.metals) -- Use Config.metals
    local metalName = Config.metals[metalIndex].name  -- Use Config.metals
    table.insert(itemsFound, metalName)
    numItemsFound = numItemsFound + 1

    -- Select a gem (ultra-rare)
    if math.random() <= 0.05 then -- 5% chance for ultra-rare gem
        local gemIndex = math.random(1, #Config.gems)   -- Use Config.gems
        local gemName = Config.gems[gemIndex].name      -- Use Config.gems
        table.insert(itemsFound, gemName)
        numItemsFound = numItemsFound + 1
    end

    if numItemsFound == 0 then
        RSGCore.Functions.Notify(source, "Didn't find anything", 'primary', 3000)
    else
        local hasItems = {}
        for _, itemName in ipairs(itemsFound) do
            local hasItem = Player.Functions.GetItemByName(itemName)
            hasItems[itemName] = hasItem and hasItem.amount or 0
        end

        local enoughSpace = true
        for _, itemName in ipairs(itemsFound) do
            if hasItems[itemName] + 2 > 30 then
                enoughSpace = true
                break
            end
        end

        if not enoughSpace then
            lib.notify(source, { title = "Notification", description = "You don't have enough space", type = 'primary', duration = 3000 })
        else
            local message = "I found"
            for _, itemName in ipairs(itemsFound) do
                Player.Functions.AddItem(itemName, math.random(1, 3))
                TriggerClientEvent("rsg-inventory:client:ItemBox", source, RSGCore.Shared.Items[itemName], "add")
                message = message .. " " .. itemName .. " and"
            end
            message = message:sub(1, -4) -- Remove the last " and" from the message
            RSGCore.Functions.Notify(source, message, 'primary', 3000)
        end
    end
end)