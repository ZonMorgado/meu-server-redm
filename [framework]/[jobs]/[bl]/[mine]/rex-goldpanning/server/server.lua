local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

----------------------------
-- use goldpan
----------------------------
RSGCore.Functions.CreateUseableItem('goldpan', function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    TriggerClientEvent('rex-goldpanning:client:startgoldpanning', src, item.name)
end)

----------------------------
-- give reward
----------------------------
RegisterServerEvent('rex-goldpanning:server:givereward')
AddEventHandler('rex-goldpanning:server:givereward', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local foundgold = math.random(100)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    if foundgold <= Config.GoldChance then
        local chance = math.random(100)
        if chance <= 50 then
            local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
            Player.Functions.AddItem(item1, Config.SmallRewardAmount)
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item1], 'add', 1)
            TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_1'), type = 'success' })
            TriggerEvent('rsg-log:server:CreateLog', 'goldpanning', locale('sv_lang_2'), 'yellow', firstname..' '..lastname..locale('sv_lang_3'))
        end
        if chance >= 50 and chance <= 80 then -- medium reward
            local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
            local item2 = Config.RewardItems[math.random(1, #Config.RewardItems)]
            Player.Functions.AddItem(item1, Config.MediumRewardAmount)
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item1], 'add', 1)
            Player.Functions.AddItem(item2, Config.MediumRewardAmount)
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item2], 'add', 1)
            TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_4'), type = 'success' })
            TriggerEvent('rsg-log:server:CreateLog', 'goldpanning', locale('sv_lang_5'), 'yellow', firstname..' '..lastname..locale('sv_lang_6'))
        end
        if chance > 80 then -- large reward
            local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
            local item2 = Config.RewardItems[math.random(1, #Config.RewardItems)]
            local item3 = Config.RewardItems[math.random(1, #Config.RewardItems)]
            Player.Functions.AddItem(item1, Config.LargeRewardAmount)
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item1], 'add', 1)
            Player.Functions.AddItem(item2, Config.LargeRewardAmount)
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item2], 'add', 1)
            Player.Functions.AddItem(item3, Config.LargeRewardAmount)
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item3], 'add', 1)
            TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_7'), type = 'success' })
            TriggerEvent('rsg-log:server:CreateLog', 'goldpanning', locale('sv_lang_8'), 'yellow', firstname..' '..lastname..locale('sv_lang_9'))
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_10'), type = 'error' })
    end
end)
