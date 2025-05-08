local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Rexshack-RedM/rsg-weaponsmith/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------

RSGCore.Commands.Add("inspect", Lang:t('label.inspect'), {}, false, function(source, args)
    local src = source
    TriggerClientEvent("rsg-weaponsmith:client:inspectweapon", src)
end)

-- check player has the ingredients
RSGCore.Functions.CreateCallback('rsg-weaponsmith:server:checkingredients', function(source, cb, ingredients)
    local src = source
    local hasItems = false
    local icheck = 0
    local Player = RSGCore.Functions.GetPlayer(src)
    for k, v in pairs(ingredients) do
        if Player.Functions.GetItemByName(v.item) and Player.Functions.GetItemByName(v.item).amount >= v.amount then
            icheck = icheck + 1
            if icheck == #ingredients then
                cb(true)
            end
        else
            TriggerClientEvent('RSGCore:Notify', src, Lang:t('error.you_dont_have_the_required_items'), 'error')
            cb(false)
            return
        end
    end
end)

-- finish crafting parts
RegisterServerEvent('rsg-weaponsmith:server:finishcraftingparts')
AddEventHandler('rsg-weaponsmith:server:finishcraftingparts', function(ingredients, receive, giveamount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- remove ingredients
    for k, v in pairs(ingredients) do
        if Config.Debug == true then
            print(v.item)
            print(v.amount)
        end
        Player.Functions.RemoveItem(v.item, v.amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[v.item], "remove")
    end
    -- add crafting item
    Player.Functions.AddItem(receive, giveamount)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[receive], "add")
end)

-- finish crafting weapon / ammo
RegisterServerEvent('rsg-weaponsmith:server:finishcrafting')
AddEventHandler('rsg-weaponsmith:server:finishcrafting', function(ingredients, receive, giveamount, job)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- remove ingredients
    for k, v in pairs(ingredients) do
        if Config.Debug == true then
            print(v.item)
            print(v.amount)
        end
        Player.Functions.RemoveItem(v.item, v.amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[v.item], "remove")
    end
    -- add stock to weaponsmith
    TriggerClientEvent('rsg-weaponsmith:client:choosetheevent', src, receive, giveamount, job)

end)

RegisterServerEvent('rsg-weaponsmith:server:addtoshop', function(receive, giveamount, job)
    MySQL.query('SELECT * FROM weaponsmith_stock WHERE weaponsmith = ? AND item = ?',{job, receive} , function(result)
        if result[1] ~= nil then
            local stockadd = result[1].stock + giveamount
            MySQL.update('UPDATE weaponsmith_stock SET stock = ? WHERE weaponsmith = ? AND item = ?',{stockadd, job, receive})
        else
            MySQL.insert('INSERT INTO weaponsmith_stock (`weaponsmith`, `item`, `stock`) VALUES (?, ?, ?);', {job, receive, giveamount})
        end
    end)

end)

RegisterNetEvent('rsg-weaponsmith:server:giveplayeritems', function(receive, giveamount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(receive, giveamount)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[receive], "add")
end)


RegisterNetEvent("stx-weaponsmith:server:openstash", function(playerjob)
    local src = source
    --local playerjob = RSGCore.Functions.GetPlayer(src).PlayerData.job.name
    local data = { label = "Storage", maxweight = 100000, slots = 25 }
    local stashName = "Blacksmith" .. playerjob
    exports['rsg-inventory']:OpenInventory(src, stashName, data)

end)
--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
