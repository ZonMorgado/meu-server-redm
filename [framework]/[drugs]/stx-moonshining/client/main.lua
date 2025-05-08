local RSGCore = exports['rsg-core']:GetCoreObject()
local brewing = {}
local stills = {}

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

function GenerateIdentifier()
    local identifiers = {
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'X',
        'Y',
        'Z',
    }
    local identifier = ''
    for i = 1, 4 do 
        identifier = identifier .. tostring(identifiers[math.random(1, #identifiers)])
    end
    identifier = identifier .. math.random(1000, 9999)
    return identifier
end

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
        Wait(0)
    end
    Wait(2500)
    TriggerServerEvent('jc-moonshining:server:checkActiveStills')
    TriggerServerEvent('jc-moonshining:server:checkActiveBuckets')
end)

RegisterNetEvent('jc-moonshining:client:addBlip', function(coords)
    local key = coords.x .. ' ' .. coords.y
    if not stills[key] and Config.AllowBlips then
        stills[key] = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords)
        SetBlipSprite(stills[key], 553094466, true)
        SetBlipScale(stills[key], 0.2)
        local blipname = Citizen.InvokeNative(0x9CB1A1623062F402, stills[key], 'Moonshine Still')
    end
end)

RegisterNetEvent('jc-moonshining:client:removeBlip', function(key)
    if stills[key] then
        RemoveBlip(stills[key])
        stills[key] = nil
    end
end)

RegisterNetEvent('jc-moonshining:client:placeKit', function(oldXp, data)
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
    Wait(5000)
    ClearPedTasks(PlayerPedId())
    local model = ''
    local reduceTime = 0
    local xp = 0
    if oldXp then
        xp = oldXp
    end

    for k, v in pairs(Config.MoonshineKits) do
        if v.xp >= xp then
            model = v.model
            reduceTime = v.reduceTime
        end 
    end

    local coords = GetEntityCoords(PlayerPedId())
    while not HasModelLoaded(model) do
        Wait(1)
        RequestModel(model) 
    end
    
    local moonshinekit = CreateObject(model, coords.x + 2.0, coords.y, coords.z - 1.0, true, false, false)
    SetEntityInvincible(moonshinekit, true)
    PlaceObjectOnGroundProperly(moonshinekit)
    FreezeEntityPosition(moonshinekit, true)
    local net_ent = ObjToNet(moonshinekit)
    local identifier = GenerateIdentifier()

    local shouldBreak = false
    RSGCore.Functions.TriggerCallback('moonshining:getIdentifier', function(data)
        if data then
            while true do
                Wait(1)
                RSGCore.Functions.TriggerCallback('moonshining:getIdentifier', function(data)
                    if data then
                        identifier = GenerateIdentifier()
                    else
                        shouldBreak = true
                    end
                end, identifier)
                if shouldBreak then break end
            end
        else
            if not data then
                local PlayerData = RSGCore.Functions.GetPlayerData()
                local newData = {
                    owner = PlayerData.citizenid,
                    uniqueid = identifier,
                    model = model,
                    reduceTime = reduceTime,
                    xp = xp,
                    isBrewing = false,
                    health = 100,
                    temperature = 0,
                    progress = 0,
                    amount = 0,
                    moonshine = '',
                }
                TriggerServerEvent('jc-moonshining:server:addGlobalTarget', net_ent, GetEntityCoords(moonshinekit), newData, true)
                TriggerEvent('jc-moonshining:client:addBlip', GetEntityCoords(moonshinekit))
            else
                TriggerServerEvent('jc-moonshining:server:addGlobalTarget', net_ent, GetEntityCoords(moonshinekit), data, true)
            end
        end
    end, identifier)
end)

RegisterNetEvent('grp-mooshining:client:initializeKit', function(data, coords)
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local model = data.model
    while not HasModelLoaded(model) do
        Wait(1)
        RequestModel(model)
    end

    local moonshinestill = CreateObject(model, coords.x, coords.y, coords.z, false, false)
    FreezeEntityPosition(moonshinestill, true)
    SetEntityInvincible(moonshinestill, true)
    PlaceObjectOnGroundProperly(moonshinestill)
    NetworkRegisterEntityAsNetworked(moonshinestill)
    Wait(2500)
    local net_ent = ObjToNet(moonshinestill)
    TriggerServerEvent('jc-moonshining:server:addGlobalTarget', net_ent, GetEntityCoords(moonshinestill), data, false)
    if data.owner == PlayerData.citizenid then
        TriggerEvent('jc-moonshining:client:addBlip', GetEntityCoords(moonshinestill))
    end
end)

RegisterNetEvent('grp-mooshining:client:initializeBucket', function(data, coords)
    local model = Config.BucketModel
    while not HasModelLoaded(model) do
        Wait(1)
        RequestModel(model)
    end

    local bucket = CreateObject(model, coords.x, coords.y, coords.z, false, false)
    FreezeEntityPosition(bucket, true)
    SetEntityInvincible(bucket, true)
    PlaceObjectOnGroundProperly(bucket)
    NetworkRegisterEntityAsNetworked(bucket)
    Wait(100)
    local net_ent = ObjToNet(bucket)
    TriggerServerEvent('jc-moonshining:server:addGlobalBucketTarget', net_ent, GetEntityCoords(bucket), data, false)
end)

RegisterNetEvent('jc-moonshining:client:placeBucket', function()
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
    Wait(5000)
    ClearPedTasks(PlayerPedId())
    local model = Config.BucketModel
    local coords = GetEntityCoords(PlayerPedId())
    while not HasModelLoaded(model) do
        Wait(1)
        RequestModel(model) 
    end
    local bucket = CreateObject(model, coords.x, coords.y, coords.z, true, false, false)
    SetEntityInvincible(bucket, true)
    PlaceObjectOnGroundProperly(bucket)
    FreezeEntityPosition(bucket, true)
    local identifier = GenerateIdentifier()
    Wait(100)
    local net_ent = ObjToNet(bucket)

    local shouldBreak = false
    RSGCore.Functions.TriggerCallback('moonshining:getBucketIdentifier', function(data)
        if data then
            while true do
                Wait(1)
                RSGCore.Functions.TriggerCallback('moonshining:getBucketIdentifier', function(data)
                    if data then
                        identifier = GenerateIdentifier()
                    else
                        shouldBreak = true
                    end
                end, identifier)
                
                if shouldBreak then
                    break
                end
            end
        else
            if not data then
                local data = {
                    isProcessing = false,
                    progress = 0,
                    amount = 0,
                    mash = '',
                    uniqueid = identifier,
                    ingredients = {}
                }
                TriggerServerEvent('jc-moonshining:server:addGlobalBucketTarget', net_ent, GetEntityCoords(bucket), data, true)
            end
        end
    end, identifier)
end)

RegisterNetEvent('jc-moonshining:client:addGlobalTarget', function(net_ent, uniqueid)
    local entity = NetToObj(net_ent)
    if Config.Target == 'rsg-target' then
        exports['rsg-target']:AddTargetEntity(entity, {
            options = {
                {
                    label = 'Open Moonshine Kit',
                    icon = 'fas fa-still',
                    action = function()
                        RSGCore.Functions.TriggerCallback('moonshining:getData', function(data)
                            if data then
                                lib.registerContext({
                                    id = 'moonshinekit',
                                    title = 'Moonshining Kit',
                                    options = {
                                        {
                                            title = 'Health',
                                            progress = data.health,
                                            readOnly = true,
                                            colorScheme = '#E03131',
                                        },
                                        {
                                            title = 'Progress: ' .. data.progress .. '%',
                                            progress = data.progress,
                                            readOnly = true,
                                            colorScheme = '#51CF66',
                                        },
                                        {
                                            title = 'Temperature: ' .. data.temperature .. '°',
                                            progress = data.temperature,
                                            arrow = true,
                                            colorScheme = '#C92A2A',
                                            onSelect = function()
                                                if data.temperature >= Config.MoonshineHeatReductionAmount then
                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_CAMP_JACK_ES_BUCKET_POUR'), 0, false)
                                                    Wait(5000)
                                                    ClearPedTasks(PlayerPedId())
                                                    local plyCoords = GetEntityCoords(PlayerPedId())
                                                    local bucket = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 1.5, GetHashKey('p_bucket03x'))
                                                    if bucket then
                                                        DetachEntity(bucket)
                                                        ClearPedTasksImmediately(PlayerPedId())
                                                        Wait(100)
                                                        DeleteObject(bucket)
                                                        if DoesEntityExist(bucket) then
                                                            DeleteEntity(bucket)
                                                        end
                                                    end
                                                    TriggerServerEvent('jc-moonshining:server:coolstill', uniqueid)
                                                else
                                                    RSGCore.Functions.Notify('The still isn\'t that hot yet..', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Contents: ' .. data.amount,
                                            readOnly = true,
                                        },
                                        {
                                            title = 'Add Mash',
                                            description = 'Add a mash to start brewing!',
                                            arrow = true,
                                            onSelect = function()
                                                if not data.isBrewing then
                                                    local PlayerData = RSGCore.Functions.GetPlayerData()
                                                    local items = PlayerData.items
                                                    local tableData = {}

                                                    for _, v in pairs(items) do
                                                        for _, i in pairs(Config.Moonshine) do
                                                            if data.moonshine == '' then
                                                                if v.name == i.ingredient then
                                                                    tableData[#tableData + 1] = {
                                                                        title = v.label,
                                                                        description = 'Add ' .. RSGCore.Shared.Items[i.ingredient].label .. ' to the moonshine kit!',
                                                                        onSelect = function()
                                                                            TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_CAMP_JACK_ES_BUCKET_POUR'), 0, false)
                                                                            Wait(5000)
                                                                            ClearPedTasks(PlayerPedId())
                                                                            local plyCoords = GetEntityCoords(PlayerPedId())
                                                                            local bucket = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 1.5, GetHashKey('p_bucket03x'))
                                                                            if bucket then
                                                                                DetachEntity(bucket)
                                                                                ClearPedTasksImmediately(PlayerPedId())
                                                                                Wait(100)
                                                                                DeleteObject(bucket)
                                                                                if DoesEntityExist(bucket) then
                                                                                    DeleteEntity(bucket)
                                                                                end
                                                                            end
                                                                            TriggerServerEvent('jc-moonshining:server:addMashToKit', uniqueid, i.item, i.ingredient)
                                                                        end
                                                                    }
                                                                end
                                                            elseif data.moonshine == i.item and v.name == i.ingredient then
                                                                tableData[#tableData + 1] = {
                                                                    title = RSGCore.Shared.Items[i.ingredient].label,
                                                                    description = 'Add ' .. RSGCore.Shared.Items[i.ingredient].label .. ' to the moonshine kit!',
                                                                    onSelect = function()
                                                                        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_CAMP_JACK_ES_BUCKET_POUR'), 0, false)
                                                                        Wait(5000)
                                                                        ClearPedTasks(PlayerPedId())
                                                                        local plyCoords = GetEntityCoords(PlayerPedId())
                                                                        local bucket = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 1.5, GetHashKey('p_bucket03x'))
                                                                        if bucket then
                                                                            DetachEntity(bucket)
                                                                            ClearPedTasksImmediately(PlayerPedId())
                                                                            Wait(100)
                                                                            DeleteObject(bucket)
                                                                            if DoesEntityExist(bucket) then
                                                                                DeleteEntity(bucket)
                                                                            end
                                                                        end
                                                                        TriggerServerEvent('jc-moonshining:server:addMashToKit', uniqueid, i.item, i.ingredient)
                                                                    end
                                                                }
                                                            end
                                                        end
                                                    end

                                                    lib.registerContext({
                                                        id = 'add_mash_to_kit',
                                                        title = 'Add Mash',
                                                        options = tableData
                                                    })
                                                    lib.showContext('add_mash_to_kit')
                                                else
                                                    RSGCore.Functions.Notify('Can\'t add mash whilst brewing!', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Start Brewing',
                                            description = 'Start the brewing process!',
                                            onSelect = function()
                                                local time = 0
                                                for _, value in pairs(Config.Moonshine) do
                                                    if value.item == data.moonshine then
                                                        time = value.time
                                                        break
                                                    end
                                                end

                                                if not data.isBrewing and data.amount > 0 and data.progress == 0 then
                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                    Wait(5000)
                                                    ClearPedTasks(PlayerPedId())
                                                    TriggerServerEvent('jc-moonshining:server:startBrewing', net_ent, uniqueid, GetEntityCoords(entity), time - data.reduceTime)
                                                elseif not data.isBrewing and data.amount <= 0 then
                                                    RSGCore.Functions.Notify('There\'s no mash in the still kit!', 'error', 3000)
                                                else
                                                    RSGCore.Functions.Notify('Moonshine still already brewing!', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Remove Mash',
                                            description = 'Remove mash you\'ve added in the still',
                                            onSelect = function()
                                                if not data.isBrewing and data.amount > 0 and data.progress == 0 then
                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                    Wait(5000)
                                                    ClearPedTasks(PlayerPedId())
                                                    TriggerServerEvent('jc-moonshining:server:removeMash', uniqueid)
                                                else
                                                    RSGCore.Functions.Notify('You can\'t remove mash whilst brewing, or when there is none!', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Take Contents',
                                            description = 'Take the moonshine that has been brewed!',
                                            onSelect = function()
                                                if not data.isBrewing and data.progress <= 100 then
                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                    Wait(5000)
                                                    ClearPedTasks(PlayerPedId())
                                                    TriggerServerEvent('jc-moonshining:server:takeMoonshine', uniqueid)
                                                else
                                                    RSGCore.Functions.Notify('You can\'t take moonshine whilst brewing, or progress is less than completed!', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Pickup',
                                            description = 'Pickup the moonshine still!',
                                            onSelect = function()
                                                if not data.isBrewing and data.temperature <= 50 then
                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                    Wait(5000)
                                                    ClearPedTasks(PlayerPedId())
                                                    TriggerServerEvent('jc-moonshining:server:pickupStill', uniqueid)
                                                    local stillPos = GetEntityCoords(entity)
                                                    local key = stillPos.x .. ' ' .. stillPos.y
                                                    TriggerServerEvent('jc-moonshining:server:removeBlip', key)
                                                    DeleteObject(entity)
                                                    DeleteObject(net_ent)
                                                elseif data.isBrewing then
                                                    RSGCore.Functions.Notify('Can\'t pick up still whilst brewing!', 'error', 3000)
                                                elseif data.temperature > 10 then
                                                    RSGCore.Functions.Notify('You can\'t pick it up whilst this hot!', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Destroy',
                                            description = 'Destroy the moonshine still!',
                                            onSelect = function()
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                RSGCore.Functions.Notify('Run!')
                                                Wait(10000)
                                                local stillPos = GetEntityCoords(entity)
                                                local key = stillPos.x .. ' ' .. stillPos.y
                                                TriggerServerEvent('jc-moonshining:server:removeBlip', key)
                                                local coords = GetEntityCoords(entity)
                                                Citizen.InvokeNative(0x7D6F58F69DA92530, coords.x, coords.y, coords.z, 25, 1.0, true, false, true)
                                                TriggerServerEvent('jc-moonshining:server:destroyStill', entity, uniqueid)
                                                DeleteObject(entity)
                                                DeleteObject(net_ent)
                                            end
                                        }
                                    }
                                })
                                lib.showContext('moonshinekit')
                            else
                                RSGCore.Functions.Notify('No data could be found..', 'error', 3000)
                            end
                        end, uniqueid)
                    end
                },
            }
        })
    elseif Config.Target == "murphy_interact" then
        exports.murphy_interact:AddEntityInteraction({
            netId = net_ent,
            id = 'stx-moonshining' ..net_ent, -- needed for removing interactions
            distance = 4.0, -- optional
            interactDst = 1.5, -- optional
            offset = vec3(0.0, 0.0, 0.0), -- optional
            bone = 'engine', -- optional
            options = {
                {
                    label = 'Hello World!',
                    action = function(entity, coords, args)
                        print(entity, coords, json.encode(args))
                    end,
                },
            }
        })

    else
        exports['ox_target']:addEntity(net_ent, {
            {
                label = 'Open Moonshine Kit',
                icon = 'fas fa-still',
                onSelect = function()
                    RSGCore.Functions.TriggerCallback('moonshining:getData', function(data)
                        if data then
                            lib.registerContext({
                                id = 'moonshinekit',
                                title = 'Moonshining Kit',
                                options = {
                                    {
                                        title = 'Health',
                                        progress = data.health,
                                        readOnly = true,
                                        colorScheme = '#E03131',
                                    },
                                    {
                                        title = 'Progress: ' .. data.progress .. '%',
                                        progress = data.progress,
                                        readOnly = true,
                                        colorScheme = '#51CF66',
                                    },
                                    {
                                        title = 'Temperature: ' .. data.temperature .. '°',
                                        progress = data.temperature,
                                        arrow = true,
                                        colorScheme = '#C92A2A',
                                        onSelect = function()
                                            if data.temperature >= Config.MoonshineHeatReductionAmount then
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_CAMP_JACK_ES_BUCKET_POUR'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                local plyCoords = GetEntityCoords(PlayerPedId())
                                                local bucket = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 1.5, GetHashKey('p_bucket03x'))
                                                if bucket then
                                                    DetachEntity(bucket)
                                                    ClearPedTasksImmediately(PlayerPedId())
                                                    Wait(100)
                                                    DeleteObject(bucket)
                                                    if DoesEntityExist(bucket) then
                                                        DeleteEntity(bucket)
                                                    end
                                                end
                                                TriggerServerEvent('jc-moonshining:server:coolstill', uniqueid)
                                            else
                                                RSGCore.Functions.Notify('The still isn\'t that hot yet..', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Contents: ' .. data.amount,
                                        readOnly = true,
                                    },
                                    {
                                        title = 'Add Mash',
                                        description = 'Add a mash to start brewing!',
                                        arrow = true,
                                        onSelect = function()
                                            if not data.isBrewing then
                                                local PlayerData = RSGCore.Functions.GetPlayerData()
                                                local items = PlayerData.items
                                                local tableData = {}

                                                for _, v in pairs(items) do
                                                    for _, i in pairs(Config.Moonshine) do
                                                        if data.moonshine == '' then
                                                            if v.name == i.ingredient then
                                                                tableData[#tableData + 1] = {
                                                                    title = v.label,
                                                                    description = 'Add ' .. RSGCore.Shared.Items[i.ingredient].label .. ' to the moonshine kit!',
                                                                    onSelect = function()
                                                                        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_CAMP_JACK_ES_BUCKET_POUR'), 0, false)
                                                                        Wait(5000)
                                                                        ClearPedTasks(PlayerPedId())
                                                                        local plyCoords = GetEntityCoords(PlayerPedId())
                                                                        local bucket = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 1.5, GetHashKey('p_bucket03x'))
                                                                        if bucket then
                                                                            DetachEntity(bucket)
                                                                            ClearPedTasksImmediately(PlayerPedId())
                                                                            Wait(100)
                                                                            DeleteObject(bucket)
                                                                            if DoesEntityExist(bucket) then
                                                                                DeleteEntity(bucket)
                                                                            end
                                                                        end
                                                                        TriggerServerEvent('jc-moonshining:server:addMashToKit', uniqueid, i.item, i.ingredient)
                                                                    end
                                                                }
                                                            end
                                                        elseif data.moonshine == i.item and v.name == i.ingredient then
                                                            tableData[#tableData + 1] = {
                                                                title = RSGCore.Shared.Items[i.ingredient].label,
                                                                description = 'Add ' .. RSGCore.Shared.Items[i.ingredient].label .. ' to the moonshine kit!',
                                                                onSelect = function()
                                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_CAMP_JACK_ES_BUCKET_POUR'), 0, false)
                                                                    Wait(5000)
                                                                    ClearPedTasks(PlayerPedId())
                                                                    local plyCoords = GetEntityCoords(PlayerPedId())
                                                                    local bucket = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 1.5, GetHashKey('p_bucket03x'))
                                                                    if bucket then
                                                                        DetachEntity(bucket)
                                                                        ClearPedTasksImmediately(PlayerPedId())
                                                                        Wait(100)
                                                                        DeleteObject(bucket)
                                                                        if DoesEntityExist(bucket) then
                                                                            DeleteEntity(bucket)
                                                                        end
                                                                    end
                                                                    TriggerServerEvent('jc-moonshining:server:addMashToKit', uniqueid, i.item, i.ingredient)
                                                                end
                                                            }
                                                        end
                                                    end
                                                end

                                                lib.registerContext({
                                                    id = 'add_mash_to_kit',
                                                    title = 'Add Mash',
                                                    options = tableData
                                                })
                                                lib.showContext('add_mash_to_kit')
                                            else
                                                RSGCore.Functions.Notify('Can\'t add mash whilst brewing!', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Start Brewing',
                                        description = 'Start the brewing process!',
                                        onSelect = function()
                                            local time = 0
                                            for _, value in pairs(Config.Moonshine) do
                                                if value.item == data.moonshine then
                                                    time = value.time
                                                    break
                                                end
                                            end

                                            if not data.isBrewing and data.amount > 0 and data.progress == 0 then
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                TriggerServerEvent('jc-moonshining:server:startBrewing', net_ent, uniqueid, GetEntityCoords(entity), time - data.reduceTime)
                                            elseif not data.isBrewing and data.amount <= 0 then
                                                RSGCore.Functions.Notify('There\'s no mash in the still kit!', 'error', 3000)
                                            else
                                                RSGCore.Functions.Notify('Moonshine still already brewing!', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Remove Mash',
                                        description = 'Remove mash you\'ve added in the still',
                                        onSelect = function()
                                            if not data.isBrewing and data.amount > 0 and data.progress == 0 then
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                TriggerServerEvent('jc-moonshining:server:removeMash', uniqueid)
                                            else
                                                RSGCore.Functions.Notify('You can\'t remove mash whilst brewing, or when there is none!', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Take Contents',
                                        description = 'Take the moonshine that has been brewed!',
                                        onSelect = function()
                                            if not data.isBrewing and data.progress <= 100 then
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                TriggerServerEvent('jc-moonshining:server:takeMoonshine', uniqueid)
                                            else
                                                RSGCore.Functions.Notify('You can\'t take moonshine whilst brewing, or progress is less than completed!', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Pickup',
                                        description = 'Pickup the moonshine still!',
                                        onSelect = function()
                                            if not data.isBrewing and data.temperature <= 50 then
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                TriggerServerEvent('jc-moonshining:server:pickupStill', uniqueid)
                                                local stillPos = GetEntityCoords(entity)
                                                local key = stillPos.x .. ' ' .. stillPos.y
                                                TriggerServerEvent('jc-moonshining:server:removeBlip', key)
                                                DeleteObject(entity)
                                                DeleteObject(net_ent)
                                            elseif data.isBrewing then
                                                RSGCore.Functions.Notify('Can\'t pick up still whilst brewing!', 'error', 3000)
                                            elseif data.temperature > 10 then
                                                RSGCore.Functions.Notify('You can\'t pick it up whilst this hot!', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Destroy',
                                        description = 'Destroy the moonshine still!',
                                        onSelect = function()
                                            TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                            Wait(5000)
                                            ClearPedTasks(PlayerPedId())
                                            RSGCore.Functions.Notify('Run!')
                                            Wait(10000)
                                            local stillPos = GetEntityCoords(entity)
                                            local key = stillPos.x .. ' ' .. stillPos.y
                                            TriggerServerEvent('jc-moonshining:server:removeBlip', key)
                                            local coords = GetEntityCoords(entity)
                                            Citizen.InvokeNative(0x7D6F58F69DA92530, coords.x, coords.y, coords.z, 25, 1.0, true, false, true)
                                            TriggerServerEvent('jc-moonshining:server:destroyStill', entity, uniqueid)
                                            DeleteObject(entity)
                                            DeleteObject(net_ent)
                                        end
                                    }
                                }
                            })
                            lib.showContext('moonshinekit')
                        else
                            RSGCore.Functions.Notify('No data could be found..', 'error', 3000)
                        end
                    end, uniqueid)
                end
            },
        })
    end
end)

RegisterNetEvent('jc-moonshining:client:addGlobalBucketTarget', function(net_ent, uniqueid)
    local entity = NetToObj(net_ent)
    if Config.Target == 'rsg-target' then
        exports['rsg-target']:AddTargetEntity(net_ent, {
            options = {
                {
                    label = 'Moonshine Bucket',
                    icon = 'fas fa-bucket',
                    action = function()
                        RSGCore.Functions.TriggerCallback('moonshining:getBucketData', function(data)
                            if data then
                                lib.registerContext({
                                    id = 'moonshine_bucket',
                                    title = 'Moonshine Bucket',
                                    options = {
                                        {
                                            title = 'Contents: ' .. #data.ingredients,
                                            readOnly = true,
                                        },
                                        {
                                            title = 'Progress',
                                            progress = data.progress,
                                            readOnly = true,
                                            colorScheme = '#ADB5BD',
                                        },
                                        {
                                            title = 'Add Ingredients',
                                            description = 'Add ingredients to create mash!',
                                            arrow = true,
                                            onSelect = function()
                                                if not data.isProcessing and data.progress == 0 then
                                                    local PlayerData = RSGCore.Functions.GetPlayerData()
                                                    local items = PlayerData.items
                                                    local tableData = {}

                                                    for _, v in pairs(items) do
                                                        for _, i in pairs(Config.MashItems) do
                                                            if v.name == i then
                                                                tableData[#tableData + 1] = {
                                                                    title = v.label,
                                                                    description = 'Put in a ' .. v.label,
                                                                    onSelect = function()
                                                                        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                                        Wait(5000)
                                                                        ClearPedTasks(PlayerPedId())
                                                                        TriggerServerEvent('jc-moonshining:server:addMash', uniqueid, v.name)
                                                                    end
                                                                }
                                                            end
                                                        end
                                                    end
                                                    lib.registerContext({
                                                        id = 'add_mash',
                                                        title = 'Add Mash',
                                                        options = tableData
                                                    })
                                                    lib.showContext('add_mash')
                                                else
                                                    RSGCore.Functions.Notify('Can\'t add ingredients when mashing or progress is over 0!', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Start Mash',
                                            description = 'Start the mashing process',
                                            onSelect = function()
                                                if not data.isProcessing then
                                                    TriggerServerEvent('jc-moonshining:server:chooseMash', uniqueid)
                                                else
                                                    RSGCore.Functions.Notify('You are already mashing silly!', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Remove Ingredients',
                                            description = 'Remove the contents from the bucket!',
                                            onSelect = function()
                                                if data.isProcessing then
                                                    RSGCore.Functions.Notify('Can\'t take ingredients whilst mashing or has mash in it!', 'error', 3000)
                                                elseif not data.isProcessing and #data.ingredients > 0 then
                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                    Wait(5000)
                                                    ClearPedTasks(PlayerPedId())
                                                    TriggerServerEvent('jc-moonshining:server:removeIngredients', uniqueid)
                                                else
                                                    RSGCore.Functions.Notify('No ingredients in the bucket!', 'error', 3000)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Take Contents',
                                            description = 'Take the mashed contents!',
                                            onSelect = function()
                                                if data.isProcessing or data.progress < 100 then
                                                    RSGCore.Functions.Notify('Can\'t take contents whilst mashing or empty!', 'error', 3000)
                                                elseif not data.isProcessing and data.progress >= 100 then
                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                    Wait(5000)
                                                    ClearPedTasks(PlayerPedId())
                                                    TriggerServerEvent('jc-moonshining:server:takeMash', uniqueid)
                                                end
                                            end
                                        },
                                        {
                                            title = 'Pickup',
                                            description = 'Pickup the bucket!',
                                            onSelect = function()
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                TriggerServerEvent('jc-moonshining:server:pickupBucket', uniqueid)
                                                DeleteObject(entity)
                                                DeleteEntity(entity)
                                                DeleteObject(net_ent)
                                            end
                                        },
                                    }
                                })
                                lib.showContext('moonshine_bucket')
                            else
                                RSGCore.Functions.Notify('No data found!', 'error', 3000)
                                DeleteObject(entity)
                                DeleteObject(net_ent)
                            end
                        end, uniqueid)
                    end
                }
            }
        })
    else
        exports['ox_target']:addEntity(net_ent, {
            {
                label = 'Moonshine Bucket',
                icon = 'fas fa-bucket',
                onSelect = function()
                    RSGCore.Functions.TriggerCallback('moonshining:getBucketData', function(data)
                        if data then
                            lib.registerContext({
                                id = 'moonshine_bucket',
                                title = 'Moonshine Bucket',
                                options = {
                                    {
                                        title = 'Contents: ' .. #data.ingredients,
                                        readOnly = true,
                                    },
                                    {
                                        title = 'Progress',
                                        progress = data.progress,
                                        readOnly = true,
                                        colorScheme = '#ADB5BD',
                                    },
                                    {
                                        title = 'Add Ingredients',
                                        description = 'Add ingredients to create mash!',
                                        arrow = true,
                                        onSelect = function()
                                            if not data.isProcessing and data.progress == 0 then
                                                local PlayerData = RSGCore.Functions.GetPlayerData()
                                                local items = PlayerData.items
                                                local tableData = {}

                                                for _, v in pairs(items) do
                                                    for _, i in pairs(Config.MashItems) do
                                                        if v.name == i then
                                                            tableData[#tableData + 1] = {
                                                                title = v.label,
                                                                description = 'Put in a ' .. v.label,
                                                                onSelect = function()
                                                                    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                                    Wait(5000)
                                                                    ClearPedTasks(PlayerPedId())
                                                                    TriggerServerEvent('jc-moonshining:server:addMash', uniqueid, v.name)
                                                                end
                                                            }
                                                        end
                                                    end
                                                end
                                                lib.registerContext({
                                                    id = 'add_mash',
                                                    title = 'Add Mash',
                                                    options = tableData
                                                })
                                                lib.showContext('add_mash')
                                            else
                                                RSGCore.Functions.Notify('Can\'t add ingredients when mashing or progress is over 0!', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Start Mash',
                                        description = 'Start the mashing process',
                                        onSelect = function()
                                            if not data.isProcessing then
                                                TriggerServerEvent('jc-moonshining:server:chooseMash', uniqueid)
                                            else
                                                RSGCore.Functions.Notify('You are already mashing silly!', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Remove Ingredients',
                                        description = 'Remove the contents from the bucket!',
                                        onSelect = function()
                                            if data.isProcessing then
                                                RSGCore.Functions.Notify('Can\'t take ingredients whilst mashing or has mash in it!', 'error', 3000)
                                            elseif not data.isProcessing and #data.ingredients > 0 then
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                TriggerServerEvent('jc-moonshining:server:removeIngredients', uniqueid)
                                            else
                                                RSGCore.Functions.Notify('No ingredients in the bucket!', 'error', 3000)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Take Contents',
                                        description = 'Take the mashed contents!',
                                        onSelect = function()
                                            if data.isProcessing or data.progress < 100 then
                                                RSGCore.Functions.Notify('Can\'t take contents whilst mashing or empty!', 'error', 3000)
                                            elseif not data.isProcessing and data.progress >= 100 then
                                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                                Wait(5000)
                                                ClearPedTasks(PlayerPedId())
                                                TriggerServerEvent('jc-moonshining:server:takeMash', uniqueid)
                                            end
                                        end
                                    },
                                    {
                                        title = 'Pickup',
                                        description = 'Pickup the bucket!',
                                        onSelect = function()
                                            TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                                            Wait(5000)
                                            ClearPedTasks(PlayerPedId())
                                            TriggerServerEvent('jc-moonshining:server:pickupBucket', uniqueid)
                                            DeleteObject(entity)
                                            DeleteEntity(entity)
                                            DeleteObject(net_ent)
                                        end
                                    },
                                }
                            })
                            lib.showContext('moonshine_bucket')
                        else
                            RSGCore.Functions.Notify('No data found!', 'error', 3000)
                            DeleteObject(entity)
                            DeleteObject(net_ent)
                        end
                    end, uniqueid)
                end
            }
        })
    end
end)

RegisterNetEvent('jc-moonshining:client:chooseMash', function(net_ent, data)
    local tableData = {}
    for _, v in pairs(data) do
        tableData[#tableData + 1] = {
            title = RSGCore.Shared.Items[v.item].label,
            description = 'Process the mash of ' .. RSGCore.Shared.Items[v.item].label,
            onSelect = function()
                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 0, false)
                Wait(5000)
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent('jc-moonshining:server:startMashing', net_ent, v.item, v.amount)
                RSGCore.Functions.Notify('Start mashing, please wait a bit...')
            end
        }
    end

    lib.registerContext({
        id = 'produce_mash',
        title = 'Produce Mash',
        options = tableData
    })
    lib.showContext('produce_mash')
end)

RegisterNetEvent('jc-moonshining:client:destroyStill', function(net_ent)
    Citizen.InvokeNative(0x22970F3A088B133B, brewing[uniqueid], true)
    local entity = NetToObj(net_ent)
    DeleteObject(entity)
    DeleteObject(net_ent)
end)

RegisterNetEvent('jc-moonshining:client:startBrewingSmoke', function(uniqueid, smokecoords)
    if not brewing[uniqueid] then
        UseParticleFxAsset('scr_adv_sok')
        brewing[uniqueid] = StartParticleFxLoopedAtCoord('scr_adv_sok_torchsmoke', smokecoords, -2,0.0,0.0, 2.0, false, false, false, true)
        Citizen.InvokeNative(0x9DDC222D85D5AF2A, brewing[uniqueid], 10.0)
        SetParticleFxLoopedAlpha(brewing[uniqueid], 1.0)
        SetParticleFxLoopedColour(brewing[uniqueid], 1.0,1.0,1.0, false)
    end
end)

RegisterNetEvent('jc-moonshining:client:stopBrewingSmoke', function(uniqueid, coords)
    if brewing[uniqueid] then
        Citizen.InvokeNative(0x22970F3A088B133B, brewing[uniqueid], true)
        brewing[uniqueid] = nil
    end
end)