local RSGCore = exports['rsg-core']:GetCoreObject()

-- Buy New Boats
RegisterServerEvent('stx-boats:BuyBoat')
AddEventHandler('stx-boats:BuyBoat', function(buyData, location)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenId = Player.PlayerData.citizenid
    local name = buyData.boatName
    local model = buyData.boatModel
    local buyPrice = buyData.buyPrice
    local money = Player.PlayerData.money.cash
    if money >= buyPrice then
        Player.Functions.RemoveMoney('cash', buyPrice)
        lib.notify({ title = _U("bought") .. name .. _U("frcash") .. buyPrice, type = 'success', duration = 6000, position = 'center-right' })

        MySQL.Async.execute('INSERT INTO player_boats (citizenid, name, model, location) VALUES (@citizenid, @name, @model, @location)', {
            ['@citizenid'] = citizenId,
            ['@name'] = name,
            ['@model'] = model,
            ['@location'] = location
        })
    else
        lib.notify({ title = _U("shortCash"), type = 'error', duration = 6000, position = 'center-right' })
    end
end)

-- Get List of Owned Boats
RegisterServerEvent('stx-boats:GetOwnedBoats')
AddEventHandler('stx-boats:GetOwnedBoats', function(location, shopId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenId = Player.PlayerData.citizenid

    local result = MySQL.query.await('SELECT * FROM player_boats WHERE citizenid = @citizenid AND location = @location', {
        ['@citizenid'] = citizenId,
        ['@location'] = location
    })
    if result[1] then
        TriggerClientEvent("stx-boats:OwnedBoatsMenu", src, result, shopId)
    else
        lib.notify({ title = _U("noBoats"), type = 'error', duration = 6000, position = 'center-right' })
    end
end)

-- Sell Owned Boats
RegisterServerEvent('stx-boats:SellBoat')
AddEventHandler('stx-boats:SellBoat', function(ownedData, boatData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenId = Player.PlayerData.citizenid
    local name = ownedData.name
    local model = ownedData.model
    local location = ownedData.location
    local sellPrice = boatData.sellPrice

    Player.Functions.AddMoney('cash', sellPrice)
    lib.notify({ title = _U("sold") .. name .. _U("frcash") .. sellPrice, type = 'success', duration = 6000, position = 'center-right' })

    MySQL.Async.execute('DELETE FROM player_boats WHERE citizenid = @citizenid AND location = @location AND name = @name AND model = @model LIMIT 1', {
        ['@citizenid'] = citizenId,
        ['@location'] = location,
        ['@name'] = name,
        ['@model'] = model
    })
end)

-- Transfer Owned Boats Between Shops
RegisterServerEvent('stx-boats:TransferBoat')
AddEventHandler('stx-boats:TransferBoat', function(ownedData, transferLocation, transferMode, boatData, shopName)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenId = Player.PlayerData.citizenid
    local name = ownedData.name
    local model = ownedData.model
    local location = ownedData.location

    if transferMode == "menuTransfer" then
        local transferPrice = boatData.transferPrice
        local money = Player.PlayerData.money.cash
        if money >= transferPrice then
            Player.Functions.RemoveMoney('cash', transferPrice)
            lib.notify({ title = _U("transferred") .. name .. _U("to") .. shopName .. _U("frcash") .. transferPrice, type = 'success', duration = 7000, position = 'center-right' })

            MySQL.Async.execute('UPDATE player_boats SET location = @transferLocation WHERE citizenid = @citizenid AND location = @location AND name = @name AND model = @model LIMIT 1', {
                ['@citizenid'] = citizenId,
                ['@location'] = location,
                ['@name'] = name,
                ['@model'] = model,
                ['@transferLocation'] = transferLocation
            })
        else
            lib.notify({ title = _U("shortCash"), type = 'error', duration = 6000, position = 'center-right' })
        end

    elseif transferMode == "driveTransfer" then

        MySQL.Async.execute('UPDATE player_boats SET location = @transferLocation WHERE citizenid = @citizenid AND location = @location AND name = @name AND model = @model LIMIT 1', {
            ['@citizenid'] = citizenId,
            ['@location'] = location,
            ['@name'] = name,
            ['@model'] = model,
            ['@transferLocation'] = transferLocation
        })
    end
end)

-- Prevent NPC Boat Spawns
if Config.blockNpcBoats then
    AddEventHandler('entityCreating', function(entity)
        if GetEntityType(entity) == 2 then
            if GetVehicleType(entity) == "boat" then
                if GetEntityPopulationType(entity) ~= 7 and GetEntityPopulationType(entity) ~= 8 then
                    CancelEvent()
                end
            end
        end
    end)
end
