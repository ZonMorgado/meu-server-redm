-- local QBCore = exports['qb-core']:GetCoreObject()
local Result = nil
local NUI_status = false

local UseInteractSound = false
local debug = true

RegisterNetEvent('mor-lock:client:openLockpick', function(callback, circles)
    lockpickCallback = callback
    exports['mor-lock']:StartLockPickCircle(total,circles) 
end)

function StartLockPickCircle(circles, seconds, callback)
    Result = nil
    if debug then
        print(circles, "This be the lock")
    end
    NUI_status = true
    SendNUIMessage({
        action = 'start',
        value = circles,
		time = seconds,
    })
    while NUI_status do
        Wait(5)
        SetNuiFocus(NUI_status, false)
    end
    Wait(100)
    SetNuiFocus(false, false)
    lockpickCallback = callback
    return Result
end

RegisterNUICallback('fail', function()
    ClearPedTasks(PlayerPedId())
    Result = false
    Wait(100)
    NUI_status = false
    --print('fail')
end)

RegisterNUICallback('success', function()
	Result = true
	Wait(100)
	NUI_status = false
    SetNuiFocus(false, false)
    print(Result)
    return Result
end)



if debug then
    RegisterCommand("lpgame", function()
	    local time = math.random(7,10)
	    local circles =  math.random(2,4)
	    local success = exports['mor-lock']:StartLockPickCircle(circles, time, success)
	    print(success)
	    if success then
		    print("WIN")
	    else
		    print("FAIL")
	    end
    end)
end