local RSGCore = exports['rsg-core']:GetCoreObject()
MenuData = {}
TriggerEvent("ak_menubase:getData",function(call)
    MenuData = call
end)

local minerblips = {
    {["CaveName"] = "Annesburg Coal Mine", x = 2752.87, y = 1364.09, z = 67.91},
    {["CaveName"] = "Mount Hagen Mine", x = -1425.83, y = 1200.13, z = 225.64},
	{["CaveName"] = "Gap Tooth Mine", x = -5966.1992, y = -3171.3459, z = -23.8947},
}


local spawnedRocks = 0
local Rocks = {}
local InArea = false
local entity
local mining = false

Citizen.CreateThread(function()
	for _, info in pairs(minerblips) do
        local blip = N_0x554d9d53f696d002(1664425300, info.x, info.y, info.z)
		SetBlipSprite(blip, 1258184551, 1)
	  SetBlipScale(blip, 0.2)
	  Citizen.InvokeNative(0x9CB1A1623062F402, blip, info.CaveName)
	end  
end)


Citizen.CreateThread(function()
    while true do
        Wait(5000)
        local ped = Ped()
        local pos = GetEntityCoords(ped)
        for k,v in pairs(minerblips) do
            if GetDistanceZTrue(pos,v) < 80.0 then
                InArea = true
                SpawnRocks()
            end
        end
    end
end)

----check distance for both caves, if both false dont run thread & delete objects (Saves performance???), prolly a better way todo this but fuck it
Citizen.CreateThread(function()
    while true do
        Wait(10000)
        local ped = Ped()
        local pos = GetEntityCoords(ped)
        if InArea then
            local AnnesburgCave = {x =2752.87, y = 1364.09, z = 67.9}
            local HiddenWaterFallCave =  {x = 2293.26, y = 1070.23, z = 81.43}
            local MountHagenCave = {x = -1425.83, y = 1200.13, z = 225.64}
            if GetDistanceZTrue(pos,AnnesburgCave) > 100.0 and GetDistanceZTrue(pos,HiddenWaterFallCave) > 100.0 and GetDistanceZTrue(pos,MountHagenCave) > 100.0 then
                InArea = false
                for k, v in pairs(Rocks) do
                    DeleteObject(v)
                end
                spawnedRocks = 0
            end
        end
    end
end)


---check distance from spawned rock 
-- Citizen.CreateThread(function()
--     while true do
--         Wait(5)
--         if InArea then
--             local ped = Ped()
--             local pos = GetEntityCoords(ped)
--             local nearbyObject, nearbyID
--             for i=1, #Rocks, 1 do
--                 local EntCoords = GetEntityCoords(Rocks[i])
--                 if GetDistanceZTrue(pos,EntCoords) < 3 then
--                     nearbyObject, nearbyID = Rocks[i], i
--                     if nearbyObject then
--                         DrawText3D(EntCoords.x, EntCoords.y, EntCoords.z, 'Press [Enter] Mine Rock')
--                         if whenKeyJustPressed("ENTER") then
--                                 local hasItemm = RSGCore.Functions.HasItem('pickaxe', 1)
--                                 if hasItemm then
--                                     mining = true
--                                     local W = math.random(8000,15000)
--                                     MineAndAttach()
--                                     Wait(100)
--                                     FreezeEntityPosition(ped,true)
--                                     Wait(W)
--                                     FreezeEntityPosition(ped,false)
--                                     DeleteObject(entity)
--                                     ClearPedTasks(ped)
--                                     SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
--                                     DeleteObject(nearbyObject)
--                                     table.remove(Rocks, nearbyID)
--                                     spawnedRocks = spawnedRocks - 1
--                                     TriggerServerEvent("CoolsMining:miningResult")
--                                     Wait(100)
--                                     mining = false
--                                 else
    
--                                 end
--                             end
--                     else
--                         mining = false
--                     end
--                 end
--             end
--         end
--     end
-- end)

function SpawnRocks()
    while spawnedRocks < 20 do
        local RockCoords = GenerateRockCoords()
        -- print(RockCoords)
        local obj = CreateObject(GetHashKey('BGV_ROCK_SCREE_SIM_02'), RockCoords.x, RockCoords.y,RockCoords.z, false, false, false)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        table.insert(Rocks, obj)
        spawnedRocks = spawnedRocks + 1
        exports.murphy_interact:AddLocalEntityInteraction({
            entity = obj,
            name = 'interactionName', -- optional
            id = 'stx-mining' ..obj, -- needed for removing interactions
            distance = 5.0, -- optional
            interactDst = 1.8, -- optional
            ignoreLos = false, -- optional ignores line of sight
            offset = vec3(0.0, 0.0, 0.0), -- optional
            options = {
                {
                    label = 'Mine Rock',
                    action = function(entity, coords, args)
                        local hasItemm = RSGCore.Functions.HasItem('pickaxe', 1)
                        if hasItemm then
                            mining = true
                            local W = math.random(8000,15000)
                            MineAndAttach()
                            Wait(100)
                            FreezeEntityPosition(ped,true)
                            Wait(W)
                            FreezeEntityPosition(ped,false)
                            DeleteObject(entity)
                            ClearPedTasks(ped)
                            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
                            DeleteObject(obj)
                            table.remove(Rocks, nearbyID)
                            spawnedRocks = spawnedRocks - 1
                            TriggerServerEvent("CoolsMining:miningResult")
                            Wait(100)
                            mining = false
                            exports.murphy_interact:RemoveLocalEntityInteraction(obj, 'stx-mining' ..obj)
                        else

                        end
                    end,
                },
            }
        })
	end
end

function GenerateRockCoords()
	while true do
		Wait(1)

		local RockCoordX, RockCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-40, 40)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-40, 40)
        for k, v in pairs(minerblips) do
            if GetDistance(GetEntityCoords(Ped()),v) < 80.0 then
                RockCoordX = v.x + modX
                RockCoordY = v.y + modY
            end
        end

		local coordZ = GetCoordZ(RockCoordX, RockCoordY)
		local coord = vector3(RockCoordX, RockCoordY, coordZ)

        if ValidateRockCoord(coord) then
			return coord
		end
	end
end


function ValidateRockCoord(rockCoord)
	if spawnedRocks > 0 then
        local validate = true
        local outsideinterior = Citizen.InvokeNative(0xF291396B517E25B2,rockCoord.x, rockCoord.y, rockCoord.z) --ISENTITYOUTSIDE

		for k, v in pairs(Rocks) do
            if GetDistance(rockCoord,GetEntityCoords(v)) < 5 then
				validate = false
            end
            if outsideinterior then
                validate = false
            end
        end

        for k,v in pairs(minerblips) do
            if GetDistance(rockCoord,v) > 50 then
                if not k then 
                    validate = false
                end
            end
        end

		return validate
	else
		return true
	end
end

function GetCoordZ(x, y)

    for height = 1, 1000 do
		local foundGround, groundZ = GetGroundZAndNormalFor_3dCoord(x, y, height+0.0)

		if foundGround then
            return groundZ
		end
	end
end

function MineAndAttach()
    if not IsPedMale(Ped()) then
        local waiting = 0
        local dict = "amb_work@world_human_pickaxe@wall@male_d@base"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            waiting = waiting + 100
            Wait(100)
            if waiting > 5000 then
                TriggerEvent("redemrp_notification:start", "Request Animation is broken, Relog", 4, "warning")
                break
            end      
        end

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_HAND")
        local modelHash = GetHashKey("P_PICKAXE01X")
        LoadModel(modelHash)
        entity = CreateObject(modelHash, coords.x, coords.y,coords.z, true, false, false)
        SetEntityVisible(entity, true)
        SetEntityAlpha(entity, 255, false)
        Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
        SetModelAsNoLongerNeeded(modelHash)
        AttachEntityToEntity(entity,ped, boneIndex, -0.030, -0.300, -0.010, 0.0, 100.0, 68.0, false, false, false, true, 2, true)  ---6th rotates axe point
        TaskPlayAnim(ped, dict, "base", 1.0, 8.0, -1, 1, 0, false, false, false)
    else
        TaskStartScenarioInPlace(Ped(), GetHashKey('WORLD_HUMAN_PICKAXE_WALL'), 60000, true, false, false, false)
    end
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(Rocks) do
			DeleteObject(v)
		end
	end
end)

--Citizen.CreateThread(function()
--    while true do
--        Wait(1)
--        local canwait = true
--        local playerPed = PlayerPedId()
--        local coords = GetEntityCoords(playerPed)
--        if isCreatorOpened then
--            DrawLightWithRange(coords.x+1 , coords.y+1 , coords.z + 1, 255, 255, 255, 2.5 ,10.0)
--        end
--        for k,v in pairs(Config.MenuLocation) do
--            local dist =  Vdist(coords, v)
--            if dist < 2 then
--                if dist  < 20 then
--                    canwait = false
--                end
--                if not active then
--                    active = true
--                    target = k
--                    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", 'Press ~INPUT_JUMP~ to access menu', Citizen.ResultAsLong())
--                    Citizen.InvokeNative(0xFA233F8FE190514C, str)
--                    Citizen.InvokeNative(0xE9990552DEC71600)
--                end
--                if IsControlJustReleased(0, Config.OpenKey) then
--                    TriggerEvent('VoidMining:OpenShop')
--                end
--                
--            else
--                if active and k == target then
--                    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", " ", Citizen.ResultAsLong())
--                    Citizen.InvokeNative(0xFA233F8FE190514C, str)
--                    Citizen.InvokeNative(0xE9990552DEC71600)
--                    active = false
--                end
--            end
--        end
--        if canwait then
--            Wait(1000)
--        end
--
--    end
--end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()

        if mining then
            -- DisableControlAction(0, 0x80F28E95, true) -- L key
            --DisableAllControlActions(0) -- disables all controls

            --DisableControlAction(0, 0x4BC9DABB, false) -- X key
        else
            Wait(500)
        end
    end
end)