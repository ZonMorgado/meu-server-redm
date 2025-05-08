local RSGCore = exports['rsg-core']:GetCoreObject()

---------------------------------------------
-- target for collect fertilizer
---------------------------------------------
CreateThread(function()
    exports['rsg-target']:AddTargetModel(Config.FertilizerProps, {
        options = {
            {
                type = 'client',
                event = 'rex-farming:client:collectfertilizer',
                icon = 'far fa-eye',
                label = 'Collect Fertilizer',
                distance = 2
            }
        }
    })
end)

---------------------------------------------
-- collect fertilizer
---------------------------------------------
RegisterNetEvent('rex-farming:client:collectfertilizer', function()

    local hasItem = RSGCore.Functions.HasItem('bucket', 1)

    if not hasItem then
        lib.notify({ title = 'Bucket Needed!', type = 'error', duration = 7000 })
        return
    end

    if hasItem then

        for i = 1, #Config.FertilizerProps do
            local obj = Config.FertilizerProps[i]
            local pos = GetEntityCoords(PlayerPedId())
            local fertilizer = GetClosestObjectOfType(pos, 2.5, obj, false, false, false)

            if fertilizer and fertilizer ~= 0 then
                fertilizerObject = fertilizer
                coords = GetEntityCoords(fertilizerObject)

                if coords then break end
            end
        end

        -- progress bar
        LocalPlayer.state:set('inv_busy', true, true)
        lib.progressBar({
            duration = 10000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disableControl = true,
            disable = {
                move = true,
                mouse = true,
            },
            label = 'Collecting Fertilizer..',
        })
        LocalPlayer.state:set('inv_busy', false, true)

        if coords then
            RSGCore.Functions.TriggerCallback('rex-farming:server:checkcollectedfertilizer', function(exists)
                if not exists then
                    DeleteEntity(fertilizerObject)
                    SetObjectAsNoLongerNeeded(fertilizerObject)
                    TriggerServerEvent('rex-farming:server:collectedfertilizer', coords)
                    TriggerServerEvent('rex-farming:server:giveitem', 'fertilizer', 1)
                else
                    DeleteEntity(fertilizerObject)
                    SetObjectAsNoLongerNeeded(fertilizerObject)
                    lib.notify({ title = 'Already taken!', type = 'error', duration = 7000 })
                end
            end, coords)
        end

    end

end)
