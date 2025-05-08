local RSGCore = exports['rsg-core']:GetCoreObject()

----------------------------------------------------
-- give cash reward
----------------------------------------------------
RegisterNetEvent('rex-delivery:server:givereward', function(cashreward)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.AddMoney('cash', cashreward)
end)
