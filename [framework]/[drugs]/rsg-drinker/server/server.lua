local RSGCore = exports['rsg-core']:GetCoreObject()

RSGCore.Functions.CreateUseableItem("beer", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("rsg-drinker:client:DrinkBeer", src, item.name)
    end
end)

RSGCore.Functions.CreateUseableItem("whiskey", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("rsg-drinker:client:DrinkWhiskey", src, item.name)
    end
end)

for k, v in pairs (Config.Moonshine) do
    RSGCore.Functions.CreateUseableItem(v, function(source, item)
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent("rsg-drinker:client:DrinkMoonshine", src, item.name)
        end
    end)
end


RSGCore.Functions.CreateUseableItem("vodka", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("rsg-drinker:client:DrinkVodka", src, item.name)
    end
end)

RSGCore.Functions.CreateUseableItem("coffee", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("rsg-drinker:client:DrinkCoffee", src, item.name)
    end
end)
