local RSGCore = exports['rsg-core']:GetCoreObject()

---------------------------------------------
-- target for collect water
---------------------------------------------
CreateThread(function()
    exports['rsg-target']:AddTargetModel(Config.WaterProps, {
        options = {
            {
                type = 'client',
                event = 'rex-farming:client:collectwater',
                icon = 'far fa-eye',
                label = 'Collect Water',
                distance = 1.5
            }
        }
    })
end)

---------------------------------------------
-- collect water
---------------------------------------------
RegisterNetEvent('rex-farming:client:collectwater', function()

    local hasItem = RSGCore.Functions.HasItem('bucket', 1)

    if not hasItem then
        lib.notify({ title = 'Bucket Needed!', type = 'error', duration = 7000 })
        return
    end

    if hasItem then
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
            label = 'Collecting Water..',
        })
        LocalPlayer.state:set('inv_busy', false, true)
        TriggerServerEvent('rex-farming:server:giveitem', 'fullbucket', 1)
    end

end)
