local RSGCore = exports['rsg-core']:GetCoreObject()
local moonshinekits = {}
local buckets = {}

RSGCore.Functions.CreateUseableItem(Config.Moonshinekit, function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if TriggerClientEvent('jc-moonshining:client:placeKit', src, item.xp, nil) then
        Player.Functions.RemoveItem(item.name, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[item.name], 'remove')
    end
end)

RSGCore.Functions.CreateUseableItem(Config.Moonshinebucket, function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if TriggerClientEvent('jc-moonshining:client:placeBucket', src) then
        Player.Functions.RemoveItem(item.name, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[item.name], 'remove')
    end
end)

RSGCore.Functions.CreateCallback('moonshining:getData', function(source, cb, uniqueid)
    local src = source
    if moonshinekits[uniqueid] then
        cb(moonshinekits[uniqueid])
    else
        cb(false)
    end
end)

RSGCore.Functions.CreateCallback('moonshining:getBucketData', function(source, cb, entity)
    local src = source
    if buckets[entity] then
        cb(buckets[entity])
    else
        cb(false)
    end
end)

RSGCore.Functions.CreateCallback('moonshining:getIdentifier', function(_, cb, identifier)
    MySQL.query('SELECT `uniqueid` FROM `moonshining_stillkits` WHERE `uniqueid` = ?', {identifier}, function(response)
        if response and #response > 0 then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RSGCore.Functions.CreateCallback('moonshining:getBucketIdentifier', function(_, cb, identifier)
    MySQL.query('SELECT `uniqueid` FROM `moonshinekit_buckets` WHERE `uniqueid` = ?', {identifier}, function(response)
        if response and #response > 0 then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent('jc-moonshining:server:removeBlip', function(key)
    local src = source
    TriggerClientEvent('jc-moonshining:client:removeBlip', -1, key)
end)

RegisterNetEvent('jc-moonshining:server:addGlobalTarget', function(entity, coords, data, isNew)
    if not moonshinekits[data.uniqueid] then
        moonshinekits[data.uniqueid] = {isBrewing = data.isBrewing, model = data.model, uniqueid = data.uniqueid, progress = data.progress, reduceTime = data.reduceTime, temperature = data.temperature, health = data.health, moonshine = data.moonshine, amount = data.amount, xp = data.xp}
    end
    if isNew then
        MySQL.insert.await('INSERT INTO `moonshining_stillkits` (uniqueid, coords, data) VALUES (?, ?, ?)', {
            data.uniqueid, json.encode(coords), json.encode(moonshinekits[data.uniqueid])
        })
    end
    print('Line 75')
    TriggerClientEvent('jc-moonshining:client:addGlobalTarget', -1, entity, data.uniqueid)
end)

RegisterNetEvent('jc-moonshining:server:addGlobalBucketTarget', function(entity, coords, data, isNew)
    if not buckets[data.uniqueid] then
        buckets[data.uniqueid] = {isProcessing = data.isProcessing, uniqueid = data.uniqueid, progress = data.progress, mash = data.mash, amount = data.amount, ingredients = data.ingredients}
    end
    if isNew then
        MySQL.insert.await('INSERT INTO `moonshinekit_buckets` (uniqueid, coords, data) VALUES (?, ?, ?)', {
            data.uniqueid, json.encode(coords), json.encode(buckets[data.uniqueid])
        })
    end
    print('Line 88')
    TriggerClientEvent('jc-moonshining:client:addGlobalBucketTarget', -1, entity, data.uniqueid)
end)

RegisterNetEvent('jc-moonshining:server:addMash', function(entity, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if buckets[entity] then
        if #buckets[entity].ingredients < 10 then
            Player.Functions.RemoveItem(item, 1)
            TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[item], 'remove')
            buckets[entity].ingredients[#buckets[entity].ingredients + 1] = item
            MySQL.update.await('UPDATE `moonshinekit_buckets` SET data = ? WHERE uniqueid = ?', {json.encode(buckets[entity]), buckets[entity].uniqueid})
        else
            RSGCore.Functions.Notify(src, 'No more space in contents!', 'error', 3000)
        end
    end
end)

RegisterNetEvent('jc-moonshining:server:chooseMash', function(entity)
    local src = source
    local mashData = {}
    local foundMash = false

    if buckets[entity] then
        if #buckets[entity].ingredients <= 0 then
            RSGCore.Functions.Notify(src, 'No ingredients found in bucket!', 'error', 3000)
            return
        end

        local ingredients = buckets[entity].ingredients
        local itemCounts = {}

        for _, item in ipairs(ingredients) do
            if itemCounts[item] then
                itemCounts[item] = itemCounts[item] + 1
            else
                itemCounts[item] = 1
            end
        end

        local function matchesMash(mash)
            for _, ingredient in ipairs(mash.ingredients) do
                local itemName = ingredient.item
                local minCount = ingredient.min
                local maxCount = ingredient.max
                local count = itemCounts[itemName] or 0

                if count < minCount or count > maxCount then
                    return false
                end
            end
            return true
        end

        for _, mash in ipairs(Config.Mashes) do
            if matchesMash(mash) then
                mashData[#mashData + 1] = {
                    item = mash.item,
                    amount = mash.amount
                }
                foundMash = true
            end
        end

        if not foundMash then
            if Config.UnknownEnabled then
                mashData[#mashData + 1] = {
                    item = Config.UnknownMash,
                    amount = Config.UnknownAmount,
                }
            else
                RSGCore.Functions.Notify(src, 'No mash has been found!', 'error', 3000)
            end
        end
        TriggerClientEvent('jc-moonshining:client:chooseMash', src, entity, mashData)
    end
end)

RegisterNetEvent('jc-moonshining:server:startMashing', function(entity, item, amount)
    local src = source
    if buckets[entity] then
        buckets[entity].mash = item
        buckets[entity].amount = amount
        buckets[entity].isProcessing = true
        buckets[entity].progress = 0
        buckets[entity].ingredient = {}

        local totalProgressTime = Config.MashProgressTime
        local progressIncrement = 100 / totalProgressTime

        Citizen.CreateThread(function()
            while buckets[entity].progress < 100 and buckets[entity] do
                Wait(1000)
                buckets[entity].progress = buckets[entity].progress + progressIncrement

                if buckets[entity].progress >= 100 then
                    buckets[entity].progress = 100
                    buckets[entity].isProcessing = false
                    break
                end
            end
        end)
    else
        RSGCore.Functions.Notify(src, 'Couldn\'t find data!', 'error', 3000)
    end
end)

RegisterNetEvent('jc-moonshining:server:startBrewing', function(entity, uniqueid, coords, time)
    local src = source
    if moonshinekits[uniqueid] then
        moonshinekits[uniqueid].progress = 0
        moonshinekits[uniqueid].isBrewing = true

        local totalProgressTime = time
        local progressIncrement = 100 / totalProgressTime

        Citizen.CreateThread(function()
            while moonshinekits[uniqueid] and moonshinekits[uniqueid].progress < 100 do
                Citizen.Wait(1000)
                if moonshinekits[uniqueid] then
                    if moonshinekits[uniqueid].temperature <= 80 then
                        TriggerClientEvent('jc-moonshining:client:startBrewingSmoke', -1, uniqueid, coords)
                    end
                    if moonshinekits[uniqueid].temperature < 170 then
                        moonshinekits[uniqueid].temperature = moonshinekits[uniqueid].temperature + Config.MoonshineHeatIntervalPrep
                        MySQL.update.await('UPDATE `moonshining_stillkits` SET data = ? WHERE uniqueid = ?', {json.encode(moonshinekits[uniqueid]), moonshinekits[uniqueid].uniqueid})
                    elseif moonshinekits[uniqueid].temperature >= 170 and moonshinekits[uniqueid].temperature < 212 then
                        moonshinekits[uniqueid].progress = moonshinekits[uniqueid].progress + progressIncrement
                        moonshinekits[uniqueid].temperature = moonshinekits[uniqueid].temperature + Config.MoonshineHeatIntervalNormal
                        MySQL.update.await('UPDATE `moonshining_stillkits` SET data = ? WHERE uniqueid = ?', {json.encode(moonshinekits[uniqueid]), moonshinekits[uniqueid].uniqueid})
                    elseif moonshinekits[uniqueid].temperature >= Config.HighTemperature then
                        moonshinekits[uniqueid].temperature = moonshinekits[uniqueid].temperature + Config.MoonshineHeatIntervalNormal
                        MySQL.update.await('UPDATE `moonshining_stillkits` SET data = ? WHERE uniqueid = ?', {json.encode(moonshinekits[uniqueid]), moonshinekits[uniqueid].uniqueid})
                        if moonshinekits[uniqueid].temperature >= Config.DangerousTemperature then
                            moonshinekits[uniqueid].health = moonshinekits[uniqueid].health - Config.HealthReduction
                            if moonshinekits[uniqueid].health <= 0 then
                                MySQL.query.await('DELETE FROM `moonshining_stillkits` WHERE `uniqueid` = ?', {moonshinekits[uniqueid].uniqueid})
                                TriggerClientEvent('jc-moonshining:client:stopBrewingSmoke', -1, uniqueid, coords)
                                moonshinekits[uniqueid] = nil
                                TriggerClientEvent('jc-moonshining:client:destroyStill', -1, entity, moonshinekits[uniqueid].uniqueid)
                            end
                        end
                    end

                    if moonshinekits[uniqueid].progress >= 100 then
                        TriggerClientEvent('jc-moonshining:client:stopBrewingSmoke', -1, entity, nil)
                        moonshinekits[uniqueid].progress = 100
                        moonshinekits[uniqueid].isBrewing = false
                        break
                    end
                end
            end
        end)
    else
        RSGCore.Functions.Notify(src, 'Couldn\'t find data!', 'error', 3000)
    end
end)

RegisterNetEvent('jc-moonshining:server:removeIngredients', function(entity)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if buckets[entity] then
        for _, v in pairs(buckets[entity].ingredients) do
            Player.Functions.AddItem(v, 1)
            TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[v], 'add')
        end
        buckets[entity].ingredients = {}
        RSGCore.Functions.Notify(src, 'You have removed all the contents in the bucket!')
        MySQL.update.await('UPDATE `moonshinekit_buckets` SET data = ? WHERE uniqueid = ?', {json.encode(buckets[entity]), buckets[entity].uniqueid})
    end
end)

RegisterNetEvent('jc-moonshining:server:removeMash', function(entity)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if moonshinekits[entity] then
        for _, v in pairs(Config.Moonshine) do
            if v.item == moonshinekits[entity].moonshine then
                Player.Functions.AddItem(v.ingredient, moonshinekits[entity].amount)
                TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[v.ingredient], 'add')
                break
            end
        end
        moonshinekits[entity].moonshine = ''
        moonshinekits[entity].amount = 0
        RSGCore.Functions.Notify(src, 'You have removed all the contents in the still!')
        MySQL.update.await('UPDATE `moonshining_stillkits` SET data = ? WHERE uniqueid = ?', {json.encode(moonshinekits[entity]), moonshinekits[entity].uniqueid})
    end
end)

RegisterNetEvent('jc-moonshining:server:takeMash', function(entity)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if buckets[entity] then
        Player.Functions.AddItem(buckets[entity].mash, buckets[entity].amount)
        TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[buckets[entity].mash], 'add')
        buckets[entity].mash = ''
        buckets[entity].amount = 0
        buckets[entity].progress = 0
        buckets[entity].ingredients = {}
        MySQL.update.await('UPDATE `moonshinekit_buckets` SET data = ? WHERE uniqueid = ?', {json.encode(buckets[entity]), buckets[entity].uniqueid})
    end
end)

RegisterNetEvent('jc-moonshining:server:takeMoonshine', function(entity)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if moonshinekits[entity] then
        Player.Functions.AddItem(moonshinekits[entity].moonshine, moonshinekits[entity].amount)
        TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[moonshinekits[entity].moonshine], 'add')
        moonshinekits[entity].moonshine = ''
        moonshinekits[entity].amount = 0
        moonshinekits[entity].progress = 0
        if moonshinekits[entity].xp < Config.MaxXP then
            moonshinekits[entity].xp = moonshinekits[entity].xp + Config.XPInterval
        end
        while true do
            Wait(1000)
            if moonshinekits[entity].isBrewing or moonshinekits[entity].temperature <= 0 then break end
            moonshinekits[entity].temperature = moonshinekits[entity].temperature - 1
            if moonshinekits[entity].temperature <= 50 then
                TriggerClientEvent('jc-moonshining:client:stopBrewingSmoke', -1, moonshinekits[entity].uniqueid, nil)
            end
        end
        MySQL.update.await('UPDATE `moonshining_stillkits` SET data = ? WHERE uniqueid = ?', {json.encode(moonshinekits[entity]), moonshinekits[entity].uniqueid})
    end
end)

RegisterNetEvent('jc-moonshining:server:pickupBucket', function(entity)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if buckets[entity] then
        Player.Functions.AddItem(Config.Moonshinebucket, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[Config.Moonshinebucket], 'add')
        MySQL.query.await('DELETE FROM `moonshinekit_buckets` WHERE `uniqueid` = ?', {buckets[entity].uniqueid})
        buckets[entity] = nil
    end
end)

RegisterNetEvent('jc-moonshining:server:pickupStill', function(entity)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if moonshinekits[entity] then
        local info = {
            xp = moonshinekits[entity].xp
        }
        Player.Functions.AddItem(Config.Moonshinekit, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[Config.Moonshinekit], 'add')
        MySQL.query.await('DELETE FROM `moonshining_stillkits` WHERE `uniqueid` = ?', {moonshinekits[entity].uniqueid})
        TriggerClientEvent('jc-moonshining:client:stopBrewingSmoke', -1, moonshinekits[entity].uniqueid, nil)
        moonshinekits[entity] = nil
    end
end)

RegisterNetEvent('jc-moonshining:server:destroyStill', function(entity, uniqueid)
    if moonshinekits[uniqueid] then
        TriggerClientEvent('jc-moonshining:client:stopBrewingSmoke', -1, uniqueid, nil)
        MySQL.query.await('DELETE FROM `moonshining_stillkits` WHERE `uniqueid` = ?', {moonshinekits[uniqueid].uniqueid})
        moonshinekits[uniqueid] = nil
    end
end)

RegisterNetEvent('jc-moonshining:server:addMashToKit', function(entity, item, ingredient)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if moonshinekits[entity] then
        if moonshinekits[entity].moonshine == '' then
            moonshinekits[entity].moonshine = item
            moonshinekits[entity].amount = 1
            Player.Functions.RemoveItem(ingredient, 1)
            TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[ingredient], 'remove')
        else
            moonshinekits[entity].amount = moonshinekits[entity].amount + 1
            Player.Functions.RemoveItem(ingredient, 1)
            TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[ingredient], 'remove')
        end
        MySQL.update.await('UPDATE `moonshining_stillkits` SET data = ? WHERE uniqueid = ?', {json.encode(moonshinekits[entity]), moonshinekits[entity].uniqueid})
    else
        RSGCore.Functions.Notify(src, 'Couldn\'t find the data!', 'error', 3000)
    end
end)

RegisterNetEvent('jc-moonshining:server:coolstill', function(entity)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if moonshinekits[entity] then
        moonshinekits[entity].temperature = moonshinekits[entity].temperature - Config.MoonshineHeatReductionAmount
        moonshinekits[entity].amount = 1
        Player.Functions.RemoveItem(Config.WaterItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items[Config.WaterItem], 'remove')
        MySQL.update.await('UPDATE `moonshining_stillkits` SET data = ? WHERE uniqueid = ?', {json.encode(moonshinekits[entity]), moonshinekits[entity].uniqueid})
    else
        RSGCore.Functions.Notify(src, 'Couldn\'t find the data!', 'error', 3000)
    end
end)

RegisterNetEvent('jc-moonshining:server:checkActiveStills', function()
    local src = source
    MySQL.query('SELECT `uniqueid`, `coords`, `data` FROM `moonshining_stillkits`', {}, function(response)
        if response and #response > 0 then
            for i = 1, #response do
                local row = response[i]
                local data = json.decode(row.data)
                local coords = json.decode(row.coords)
                local uniqueid = row.uniqueid

                if moonshinekits[uniqueid] then
                    TriggerClientEvent('grp-mooshining:client:initializeKit', src, moonshinekits[uniqueid], coords)
                else
                    moonshinekits[uniqueid] = data
                    TriggerClientEvent('grp-mooshining:client:initializeKit', src, data, coords)
                end
            end
        end
    end)
end)

RegisterNetEvent('jc-moonshining:server:checkActiveBuckets', function()
    local src = source
    MySQL.query('SELECT `uniqueid`, `coords`, `data` FROM `moonshining_stillkits`', {}, function(response)
        if response and #response > 0 then
            for i = 1, #response do
                local row = response[i]
                local data = json.decode(row.data)
                local coords = json.decode(row.coords)
                local uniqueid = row.uniqueid

                if buckets[uniqueid] then
                    TriggerClientEvent('grp-mooshining:client:initializeBucket', src, buckets[uniqueid], coords)
                else
                    buckets[uniqueid] = data
                    TriggerClientEvent('grp-mooshining:client:initializeBucket', src, data, coords)
                end
            end
        end
    end)
end)