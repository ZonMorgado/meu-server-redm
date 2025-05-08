RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    LocalPlayer.state:set('inv_busy', false, true)
end)

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('inv_busy', true, true)
end)

RegisterNetEvent('RSGCore:Client:UpdateObject', function()
    RSGCore = exports['rsg-core']:GetCoreObject()
end)

RegisterNetEvent('rsg-inventory:client:giveAnim', function()
    if IsPedInAnyVehicle(cache.ped, false) then return end

    local dict = 'mp_common'
    lib.requestAnimDict(dict)
    TaskPlayAnim(cache.ped, dict, 'givetake1_b', 8.0, 1.0, -1, 16, 0, false, false, false)
    RemoveAnimDict(dict)
end)