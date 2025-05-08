local RSGCore = exports['rsg-core']:GetCoreObject()

-- give reward
RegisterServerEvent('rsg-stdenisbankheist:server:reward')
AddEventHandler('rsg-stdenisbankheist:server:reward', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local chance = math.random(1,100)
    if chance <= 50 then
        local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        local item2 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        local item3 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        -- add items
        Player.Functions.AddItem(item1, Config.SmallRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
        Player.Functions.AddItem(item2, Config.SmallRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")
        Player.Functions.AddItem(item3, Config.SmallRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item3], "add")
        lib.notify(src, { title = 'small loot reward this time!', type = 'primary', duration = 5000 })

    elseif chance >= 50 and chance <= 80 then -- medium reward
        local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        local item2 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        local item3 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        -- add items
        Player.Functions.AddItem(item1, Config.MediumRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
        Player.Functions.AddItem(item2, Config.MediumRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")
        Player.Functions.AddItem(item3, Config.MediumRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item3], "add")
        lib.notify(src, { title = 'medium loot reward this time!', type = 'inform', duration = 5000 })
    elseif chance > 80 then -- large reward
        local item1 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        local item2 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        local item3 = Config.RewardItems[math.random(1, #Config.RewardItems)]
        -- add items
        Player.Functions.AddItem(item1, Config.LargeRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
        Player.Functions.AddItem(item2, Config.LargeRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")
        Player.Functions.AddItem(item3, Config.LargeRewardAmount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item3], "add")
        Player.Functions.AddMoney(Config.MoneyRewardType, Config.MoneyRewardAmount, "bank-heist")
        lib.notify(src, { title = 'large loot reward this time!', type = 'inform', duration = 5000 })
        Wait(5000)
        lib.notify(src, { title = 'addtional '..Config.MoneyRewardAmount..' '..Config.MoneyRewardType..' looted!', type = 'inform', duration = 5000 })
    end
end)

-- remove item
RegisterNetEvent('rsg-stdenisbankheist:server:removeItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item], "remove")
end)

local ALARMS = {}
RegisterServerEvent('BANK:ALARM')
AddEventHandler('BANK:ALARM', function(coords, player)
    if not ALARMS[player] then
        ALARMS[player] = true
        exports["xsound"]:PlayUrlPos(-1, "alarm2", Config.AlarmRing, Config.AlarmVolume, coords, true)
        exports["xsound"]:Distance(-1, "alarm2", Config.AlarmRadius) 
        Wait(Config.AlarmTime)
        exports["xsound"]:Destroy(-1, "alarm2")
        ALARMS[player] = nil
   end
end)


exports['rsg-core']:AddItem('dynamite', {
    name = 'dynamite',
    label = 'dynamite',
    weight = 10,
    type = 'item',
    image = 'water_bottle.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'For all the thirsty out there'
})

exports['rsg-core']:AddItem('lockpick', {
    name = 'lockpick',
    label = 'lockpick',
    weight = 10,
    type = 'item',
    image = 'water_bottle.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'For all the thirsty out there'
})







