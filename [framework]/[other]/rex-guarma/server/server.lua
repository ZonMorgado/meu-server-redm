local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

-----------------------------------------------------------------------
-- buy ticket
-----------------------------------------------------------------------
RegisterServerEvent('rex-guarma:server:buyticket')
AddEventHandler('rex-guarma:server:buyticket', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local totalcost = amount * Config.TicketCost
    local cashBalance = Player.PlayerData.money['cash']

    if cashBalance >= totalcost then
        Player.Functions.RemoveMoney('cash', totalcost)
        Player.Functions.AddItem('boat_ticket', amount)
        TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['boat_ticket'], 'add', amount)
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_1'), type = 'success', duration = 7000 })
    else 
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_2'), type = 'error', duration = 7000 })
    end
end)

-----------------------------------------------------------------------
-- remove ticket
-----------------------------------------------------------------------
RegisterNetEvent('rex-guarma:server:removeItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'remove', amount)
end)
