local spawnedPeds = {}
lib.locale()

local function NearNPC(npcmodel, npccoords, heading)
    local spawnedPed = CreatePed(npcmodel, npccoords.x, npccoords.y, npccoords.z - 1.0, heading, false, false, 0, 0)
    SetEntityAlpha(spawnedPed, 0, false)
    SetRandomOutfitVariation(spawnedPed, true)
    SetEntityCanBeDamaged(spawnedPed, false)
    SetEntityInvincible(spawnedPed, true)
    FreezeEntityPosition(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    SetPedCanBeTargetted(spawnedPed, false)

    if Config.FadeIn then
        for i = 0, 255, 51 do
            Wait(50)
            SetEntityAlpha(spawnedPed, i, false)
        end
    end

    return spawnedPed
end

CreateThread(function()
    for k,v in pairs(Config.barberlocations) do
        local coords = v.npccoords
        local newpoint = lib.points.new({
            coords = coords,
            heading = coords.w,
            distance = Config.DistanceSpawn,
            model = v.npcmodel,
            id = v.id,
            ped = nil
        })

        newpoint.onEnter = function(self)
            if not self.ped then
                lib.requestModel(self.model, 10000)
                self.ped = NearNPC(self.model, self.coords, self.heading)

                pcall(function ()
                    if Config.UseTarget then
                        exports['rsg-target']:AddTargetEntity(self.ped, {
                            options = {
                                {
                                    icon = 'fa-solid fa-eye',
                                    label = locale('cl_open_barber'),
                                    targeticon = 'fa-solid fa-eye',
                                    action = function()
                                        TriggerEvent('rsg-barber:client:menu', self.id)
                                    end
                                },
                            },
                            distance = 2.0,
                        })
                    end
                end)
            end
        end

        newpoint.onExit = function(self)
            exports['rsg-target']:RemoveTargetEntity(self.ped, locale('cl_open_barber'))
            if self.ped and DoesEntityExist(self.ped) then
                if Config.FadeIn then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(self.ped, i, false)
                    end
                end
                DeleteEntity(self.ped)
                self.ped = nil
            end
        end

        spawnedPeds[k] = newpoint
    end
end)

-- cleanup
AddEventHandler("onResourceStop", function(resourceName)
local resource = GetCurrentResourceName()
    if resource ~= resourceName then return end
    for k, v in pairs(spawnedPeds) do
        exports['rsg-target']:RemoveTargetEntity(v.ped, locale('cl_open_barber'))
        if v.ped and DoesEntityExist(v.ped) then
            DeleteEntity(v.ped)
        end
        spawnedPeds[k] = nil
    end
end)
