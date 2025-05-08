local RSGCore = exports['rsg-core']:GetCoreObject()
local isBusy = false
local canPan = false
lib.locale()

-- ensure prop is loaded
local function LoadModel(model)
    local attempts = 0
    while attempts < 100 and not HasModelLoaded(model) do
        RequestModel(model)
        Wait(10)
        attempts = attempts + 1
    end
    return IsModelValid(model)
end

-- attach gold pan to ped
local function AttachPan()
    if not DoesEntityExist(prop_goldpan) then
    local coords = GetEntityCoords(cache.ped)
    local modelHash = GetHashKey("P_CS_MININGPAN01X")  
    LoadModel(modelHash)
    prop_goldpan = CreateObject(modelHash, coords.x+0.30, coords.y+0.10,coords.z, true, false, false)
    SetEntityVisible(prop_goldpan, true)
    SetEntityAlpha(prop_goldpan, 255, false)
    Citizen.InvokeNative(0x283978A15512B2FE, prop_goldpan, true)   
    local boneIndex = GetEntityBoneIndexByName(cache.ped, "SKEL_R_HAND")
    AttachEntityToEntity(prop_goldpan, cache.ped, boneIndex, 0.2, 0.0, -0.20, -100.0, -50.0, 0.0, false, false, false, true, 2, true)
    SetModelAsNoLongerNeeded(modelHash)
    end
end

-- ped crouch
local function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local coords = GetEntityCoords(cache.ped)
    TaskPlayAnim(cache.ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

-- ped does gold shake anim
local function GoldShake()
    local dict = "script_re@gold_panner@gold_success"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    TaskPlayAnim(cache.ped, dict, "SEARCH02", 1.0, 8.0, -1, 1, 0, false, false, false)
end

-- delete goldpan prop
local function DeletePan(entity)
    DeleteObject(entity)
    DeleteEntity(entity)
    Wait(100)          
    ClearPedTasks(cache.ped)
end

RegisterNetEvent('rex-goldpanning:client:startgoldpanning')
AddEventHandler('rex-goldpanning:client:startgoldpanning', function()
    local coords = GetEntityCoords(cache.ped)
    local water = Citizen.InvokeNative(0x5BA7A68A346A5A91, coords.x, coords.y, coords.z)
    if not isBusy then

        for k,v in pairs(Config.WaterTypes) do 
            if water == Config.WaterTypes[k]["waterhash"]  then
                canPan = true
                break
            end
        end

        if canPan and water ~= false then
            isBusy = true
            AttachPan()
            CrouchAnim()
            Wait(6000)
            ClearPedTasks(cache.ped)
            GoldShake()
            local randomwait = math.random(12000,28000)
            Wait(randomwait)
            DeletePan(prop_goldpan) 
            TriggerServerEvent('rex-goldpanning:server:givereward')
            isBusy = false
            canPan = false
        else
            lib.notify({ title = locale('cl_lang_1'), type = 'error', duration = 7000 })
        end
    else
        lib.notify({ title = locale('cl_lang_2'), type = 'error', duration = 7000 })
    end
end)
