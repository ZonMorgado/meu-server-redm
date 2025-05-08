local RSGCore = exports['rsg-core']:GetCoreObject()
local horsename = nil
local horsexp = 0
local newxp = 0
local horseid = nil
lib.locale()

------------------------------------
-- use horse trainer brush
------------------------------------
RSGCore.Functions.CreateUseableItem('trainer_brush', function(source, item)
    local src = source
    TriggerClientEvent('rex-horsetrainer:client:brushhorse', src, item.name)
end)

------------------------------------
-- use horse trainer feed
------------------------------------
RSGCore.Functions.CreateUseableItem('trainer_feed', function(source, item)
    local src = source
    TriggerClientEvent('rex-horsetrainer:client:feedhorse', src, item.name)
end)

------------------------------------
-- add horse xp
------------------------------------
RegisterNetEvent('rex-horsetrainer:server:updatexp',function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local cid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid = @citizenid AND active = @active', { ['@citizenid'] = cid, ['@active'] = 1 })

    if result[1] then
        horsename = result[1].name
        horseid = result[1].horseid
        horsexp = result[1].horsexp
    end

    newxp = horsexp + amount
    MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
    TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_1'), description = horsename.. locale('sv_lang_2') ..newxp, type = 'error', duration = 7000 })
end)

------------------------------------
-- remove item
------------------------------------
RegisterNetEvent('rex-horsetrainer:server:deleteItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'remove', amount)
end)
