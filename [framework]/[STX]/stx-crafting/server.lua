local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('stx-crafting:server:MehnatKrBhadwe')
AddEventHandler('stx-crafting:server:MehnatKrBhadwe', function(itemname, ingredients, amount)
    local src = source
    local player = RSGCore.Functions.GetPlayer(src)
    print(itemname, ingredients, amount)
    for item, amount in pairs(ingredients) do
        if not player.Functions.RemoveItem(item, amount) then
            jo.notif.rightError(src, 'Failed to craft '.. itemname)
            return
        end
    end

    player.Functions.AddItem(itemname, amount)
    jo.notif.rightSuccess(src, itemname .. " Crafted successfully")
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[itemname], "add", amount)
end)