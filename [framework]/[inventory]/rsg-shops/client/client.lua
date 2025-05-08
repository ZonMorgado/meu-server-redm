local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

-------------------------
-- prompts & blips
-------------------------
CreateThread(function()
    for _,v in pairs(Config.StoreLocations) do
        exports['rsg-core']:createPrompt(v.name, v.shopcoords, RSGCore.Shared.Keybinds[Config.Keybind], locale('lang_1') .. v.label, {
            type = 'server',
            event = 'rsg-shops:server:openstore',
            args = {v.products, v.name, v.label},
        })
        if v.showblip == true then    
            local StoreBlip = BlipAddForCoords(1664425300, v.shopcoords)
            SetBlipSprite(StoreBlip, joaat(v.blipsprite), true)
            SetBlipScale(StoreBlip, v.blipscale)
            SetBlipName(StoreBlip, v.label)
        end
    end
end)
