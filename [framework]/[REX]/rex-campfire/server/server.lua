local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

-----------------------
-- use campfire
-----------------------
RSGCore.Functions.CreateUseableItem('campfire', function(source, item)
    local src = source
    TriggerClientEvent('rex-campfire:client:createcampfire', src, Config.CampfireProp, 'campfire')
end)

-----------------------
-- check player has the ingredients
-----------------------
RSGCore.Functions.CreateCallback('rex-campfire:server:checkingredients', function(source, cb, ingredients)
    local src = source
    local hasItems = false
    local icheck = 0
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    for k, v in pairs(ingredients) do
        if Player.Functions.GetItemByName(v.item) and Player.Functions.GetItemByName(v.item).amount >= v.amount then
            icheck = icheck + 1
            if icheck == #ingredients then
                cb(true)
            end
        else
            cb(false)
        end
    end
end)

-----------------------
-- finish cooking
-----------------------
RegisterNetEvent('rex-campfire:server:finishcooking', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local receive = data.receive
    local giveamount = data.giveamount
    for k, v in pairs(data.ingredients) do
        Player.Functions.RemoveItem(v.item, v.amount)
        TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[v.item], 'remove', v.amount)
    end
    Player.Functions.AddItem(receive, giveamount)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[receive], 'add', giveamount)
    TriggerEvent('rsg-log:server:CreateLog', 'cooking', locale('sv_lang_1'), 'green', firstname..' '..lastname..' ('..citizenid..locale('sv_lang_2')..RSGCore.Shared.Items[receive].label)
end)

-----------------------
-- delete item
-----------------------
RegisterNetEvent('rex-campfire:server:deleteitem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'remove', amount)
end)
