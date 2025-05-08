local RSGCore = exports['rsg-core']:GetCoreObject()

CreateThread(function() 
    for _, shopConfig in pairs(Config.StoreLocations) do 
        local itemTable = Config.Products[shopConfig.products]
        exports['rsg-inventory']:CreateShop({
            name = shopConfig.name,
            label = shopConfig.label,
            slots = #itemTable,
            items = itemTable,
            persistentStock = shopConfig.persistentStock,
        })
    end
end)

-------------------------
-- open shop
-------------------------
RegisterNetEvent('rsg-shops:server:openstore', function(products, name, label)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local playerjobtype = Player.PlayerData.job.type
    if products == 'armoury' and playerjobtype ~= 'leo' then return end
    if products == 'medic' and playerjobtype ~= 'medic' then return end

    local itemTable = Config.Products[products]
    exports['rsg-inventory']:CreateShop({
        name = name,
        label = label,
        slots = itemTable and #itemTable or 0,
        items = itemTable,
    })
    
    exports['rsg-inventory']:OpenShop(source, name)
end)
