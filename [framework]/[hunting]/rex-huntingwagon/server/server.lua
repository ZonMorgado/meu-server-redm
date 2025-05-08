local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

----------------------------------------------------
-- generate wagon plate
----------------------------------------------------
local function GeneratePlate()
    local UniqueFound = false
    local plate = nil
    while not UniqueFound do
        plate = tostring(RSGCore.Shared.RandomStr(3) .. RSGCore.Shared.RandomInt(3)):upper()
        local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM rex_huntingwagon WHERE plate = ?", { plate })
        if result == 0 then
            UniqueFound = true
        end
    end
    return plate
end

----------------------------------------------------
-- buy and add hunting cart
----------------------------------------------------
RegisterServerEvent('rex-huntingwagon:server:buyhuntingcart', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local cashBalance = Player.PlayerData.money["cash"]
    
    if cashBalance >= Config.WagonPrice then
        local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM rex_huntingwagon WHERE citizenid = ?", { citizenid })
        
        -- Remove the check for existing wagons
        local plate = GeneratePlate()
        MySQL.insert('INSERT INTO rex_huntingwagon(citizenid, plate, huntingcamp, damaged, active) VALUES(@citizenid, @plate, @huntingcamp, @damaged, @active)', {
            ['@citizenid'] = citizenid,
            ['@plate'] = plate,
            ['@huntingcamp'] = data.huntingcamp,
            ['@damaged'] = 0,
            ['@active'] = 1,
        })
        Player.Functions.RemoveMoney('cash', Config.WagonPrice)
        
        -- Modify the success message to include the number of wagons owned
        local newCount = result + 1
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_1'), description = locale('sv_lang_2') .. locale('sv_lang_29') .. newCount .. locale('sv_lang_30'), type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_5'), description = '$'..Config.WagonPrice..locale('sv_lang_6'), type = 'error', duration = 7000 })
    end
end)

----------------------------------------------------
-- get wagons
----------------------------------------------------
RSGCore.Functions.CreateCallback('rex-huntingwagon:server:getwagons', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local wagon = MySQL.query.await('SELECT * FROM rex_huntingwagon WHERE citizenid=@citizenid', { ['@citizenid'] = citizenid })
    if wagon[1] == nil then return end
    cb(wagon)
end)

----------------------------------------------------
-- get wagon store
----------------------------------------------------
RSGCore.Functions.CreateCallback('rex-huntingwagon:server:getwagonstore', function(source, cb, plate)
    local wagonstore = MySQL.query.await('SELECT * FROM rex_huntingwagon_inventory WHERE plate=@plate', { ['@plate'] = plate })
    if wagonstore[1] == nil then return end
    cb(wagonstore)
end)

----------------------------------------------------
-- get tarp info
----------------------------------------------------
RSGCore.Functions.CreateCallback('rex-huntingwagon:server:gettarpinfo', function(source, cb, plate)
    local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM rex_huntingwagon_inventory WHERE plate = ?", { plate })
    cb(result)
end)

----------------------------------------------------
-- store good hunting wagon
----------------------------------------------------
RegisterServerEvent('rex-huntingwagon:server:updatewagonstore', function(location, plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local newLocation = MySQL.query.await('UPDATE rex_huntingwagon SET huntingcamp = ? WHERE plate = ?' , { location, plate })

    if newLocation == nil then
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_7'), description = locale('sv_lang_8'), type = 'error', duration = 5000 })
        return
    end
    
    TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_9'), description = locale('sv_lang_10')..location, type = 'success', duration = 5000 })
end)

----------------------------------------------------
-- store damaged hunting wagon
----------------------------------------------------
RegisterServerEvent('rex-huntingwagon:server:damagedwagon', function(location, plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local newLocation = MySQL.query.await('UPDATE rex_huntingwagon SET huntingcamp = ? WHERE plate = ?' , { location, plate })
    local newDamage = MySQL.query.await('UPDATE rex_huntingwagon SET damaged = ? WHERE plate = ?' , { 1, plate })

    if (newLocation == nil) or (newDamage == nil) then
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_11'), description = locale('sv_lang_12'), type = 'error', duration = 5000 })
        return
    end
    
    TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_13'), description = locale('sv_lang_14')..location, type = 'success', duration = 5000 })
end)

----------------------------------------------------
-- fix damaged hunting wagon
----------------------------------------------------
RegisterServerEvent('rex-huntingwagon:server:fixhuntingwagon', function(plate, price)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local cashBalance = Player.PlayerData.money['cash']
    if cashBalance >= price then
        Player.Functions.RemoveMoney('cash', price)
        MySQL.update('UPDATE rex_huntingwagon SET damaged = ? WHERE plate = ?' , { 0, plate })
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_15'), description = locale('sv_lang_16'), type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_17'), description = locale('sv_lang_18'), type = 'error', duration = 5000 })
    end
end)

----------------------------------------------------
-- add holding animal to database
----------------------------------------------------
RegisterServerEvent('rex-huntingwagon:server:addanimal', function(animalhash, animallabel, animallooted, plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM rex_huntingwagon_inventory WHERE plate = ?", { plate })
    if result < Config.TotalAnimalsStored then
        MySQL.insert('INSERT INTO rex_huntingwagon_inventory(animalhash, animallabel, animallooted, citizenid, plate) VALUES(@animalhash, @animallabel, @animallooted, @citizenid, @plate)', {
            ['@animalhash'] = animalhash,
            ['@animallabel'] = animallabel,
            ['@animallooted'] = animallooted,
            ['@citizenid'] = citizenid,
            ['@plate'] = plate
        })
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_19'), description = animallabel..locale('sv_lang_20'), type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_21'), description = locale('sv_lang_22')..Config.TotalAnimalsStored..locale('sv_lang_23'), type = 'error', duration = 5000 })
    end
end)

RegisterServerEvent('rex-huntingwagon:server:removeanimal', function(data)
    local src = source
    MySQL.update('DELETE FROM rex_huntingwagon_inventory WHERE id = ? AND plate = ?', { data.id, data.plate })
    TriggerClientEvent('rex-huntingwagon:client:takeoutanimal', src, data.animalhash, data.animallooted)
end)

----------------------------------------------------
-- sell hunting wagon
----------------------------------------------------
RegisterServerEvent('rex-huntingwagon:server:sellhuntingcart')
AddEventHandler('rex-huntingwagon:server:sellhuntingcart', function(plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid

    local sellPrice = (Config.WagonPrice * Config.WagonSellRate)

    local wagon = MySQL.query.await("SELECT * FROM rex_huntingwagon WHERE citizenid=@citizenid AND plate=@plate", {
        ['@citizenid'] = citizenid,
        ['@plate'] = plate
    })

    if wagon[1] then
        MySQL.update('DELETE FROM rex_huntingwagon WHERE id = ?', { wagon[1].id })
        MySQL.update('DELETE FROM stashitems WHERE stash = ?', { wagon[1].plate })
        Player.Functions.AddMoney('cash', sellPrice)
        TriggerClientEvent('ox_lib:notify', src, { title = locale('sv_lang_24'), description = locale('sv_lang_25') .. sellPrice, type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, { title = locale('sv_lang_26'), description = locale('sv_lang_27'), type = 'error', duration = 5000 })
    end
end)



---------------------------------------------
-- hunting wagon storage
---------------------------------------------
RegisterServerEvent('rex-huntingwagon:server:wagonstorage', function(plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local data = { label = locale('sv_lang_28'), maxweight = Config.StorageMaxWeight, slots = Config.StorageMaxSlots }
    local stashName = plate
    exports['rsg-inventory']:OpenInventory(src, stashName, data)
end)
