local RSGCore = exports['rsg-core']:GetCoreObject()
local SpawnedCampFires = {}
local CategoryMenus = {}
local fx_group = "scr_dm_ftb"
local fx_name = "scr_mp_chest_spawn_smoke"
local fx_scale = 1.0
lib.locale()

---------------------------------------------
-- check to see if prop can be place here
---------------------------------------------
local function CanPlacePropHere(playercoords)
    local canPlace = true
    local ZoneTypeId = 1
    local x,y,z =  table.unpack(playercoords)
    local town = Citizen.InvokeNative(0x43AD8FC02B429D33, x,y,z, ZoneTypeId)
    if town ~= false then
        canPlace = false
    end
    return canPlace
end

-----------------------
-- setup campfire
-----------------------
RegisterNetEvent('rex-campfire:client:setupcampfire', function(firecoords, heading, propmodel, item)
    local playercoords = GetEntityCoords(cache.ped)
    -- restrict town check
    if not CanPlacePropHere(playercoords) then
        lib.notify({ title = locale('cl_lang_12'), description = locale('cl_lang_13'), type = 'error', duration = 7000 })
        return
    end
    if #(playercoords - firecoords) < Config.PlaceDistance then
        local data = {}
        TaskStartScenarioInPlace(cache.ped, `WORLD_HUMAN_CROUCH_INSPECT`, 0, true)
        Wait(5000)
        data.firecoords = firecoords
        data.campfire = CreateObject(propmodel, firecoords, true, false, true)
        
        -- veg modifiy
        local veg_modifier_sphere = 0
        if veg_modifier_sphere == nil or veg_modifier_sphere == 0 then
            local veg_radius = 1.5
            local veg_Flags =  1 + 2 + 4 + 8 + 16 + 32 + 64 + 128 + 256
            local veg_ModType = 1
            veg_modifier_sphere = AddVegModifierSphere(firecoords.x, firecoords.y, firecoords.z, veg_radius, veg_ModType, veg_Flags, 0)
        else
            RemoveVegModifierSphere(Citizen.PointerValueIntInitialized(veg_modifier_sphere), 0)
            veg_modifier_sphere = 0
        end
        
        -- create target for the campfire
		exports.ox_target:addLocalEntity(data.campfire, {
			{
				name = 'single_campfire',
				icon = 'far fa-eye',
				label = locale('cl_lang_1'),
				onSelect = function()
					TriggerEvent('rex-campfire:client:openmenu', data)
				end,
				distance = 1.5
			}
		})
        -- end of target
        table.insert(SpawnedCampFires, data)
        ClearPedTasks(cache.ped)
        TriggerServerEvent('rex-campfire:server:deleteitem', item, 1)
    else
        lib.notify({ title = locale('cl_lang_2'), description = locale('cl_lang_3'), type = 'error', duration = 5000 })
    end
end)

-----------------------
-- campfire menu
-----------------------
RegisterNetEvent('rex-campfire:client:openmenu', function(data)
    lib.registerContext({
        id = 'campfire',
        title = locale('cl_lang_4'),
        options = {
            {
                title = locale('cl_lang_5'),
                icon = 'fa-solid fa-fire',
                event = 'rex-campfire:client:cookingmenu',
                arrow = true
            },
            {
                title = locale('cl_lang_6'),
                icon = 'fa-regular fa-circle-xmark',
                event = 'rex-campfire:client:destorycampfire',
                args = { campfire = data.campfire, firecoords = data.firecoords },
                arrow = true
            },
        }
    })
    lib.showContext('campfire')
end)

---------------------------------------------
-- cooking menu
---------------------------------------------
CreateThread(function()
    for _, v in ipairs(Config.Cooking) do
        local IngredientsMetadata = {}
        local setheader = RSGCore.Shared.Items[tostring(v.receive)].label
        local itemimg = "nui://"..Config.Image..RSGCore.Shared.Items[tostring(v.receive)].image

        for i, ingredient in ipairs(v.ingredients) do
            table.insert(IngredientsMetadata, { label = RSGCore.Shared.Items[ingredient.item].label, value = ingredient.amount })
        end

        local option = {
            title = setheader,
            icon = itemimg,
            event = 'rex-campfire:client:cookitem',
            metadata = IngredientsMetadata,
            args = {
                title = setheader,
                category = v.category,
                ingredients = v.ingredients,
                cooktime = v.cooktime,
                receive = v.receive,
                giveamount = v.giveamount
            }
        }

        if not CategoryMenus[v.category] then
            CategoryMenus[v.category] = {
                id = 'cooking_menu_' .. v.category,
                title = v.category,
                menu = 'cooking_menu',
                onBack = function() end,
                options = { option }
            }
        else
            table.insert(CategoryMenus[v.category].options, option)
        end
    end
end)

CreateThread(function()
    for category, MenuData in pairs(CategoryMenus) do
        RegisterNetEvent('rex-campfire:client:' .. category)
        AddEventHandler('rex-campfire:client:' .. category, function()
            lib.registerContext(MenuData)
            lib.showContext(MenuData.id)
        end)
    end
end)

RegisterNetEvent('rex-campfire:client:cookingmenu', function()
    local Menu = {
        id = 'cooking_menu',
        title = locale('cl_lang_7'),
        options = {}
    }

    for category, MenuData in pairs(CategoryMenus) do
        table.insert(Menu.options, {
            title = category,
            event = 'rex-campfire:client:' .. category,
            arrow = true
        })
    end

    lib.registerContext(Menu)
    lib.showContext(Menu.id)
end)

-----------------------
-- cook item
-----------------------
RegisterNetEvent('rex-campfire:client:cookitem', function(data)
    local hasItem = RSGCore.Functions.HasItem('weapon_melee_knife', 1)
    if not hasItem then
        lib.notify({ title = locale('cl_lang_8'), description = locale('cl_lang_9'), type = 'error', duration = 5000 })
        return
    end
    RSGCore.Functions.TriggerCallback('rex-campfire:server:checkingredients', function(hasRequired)
        if hasRequired == true then
            LocalPlayer.state:set('inv_busy', true, true) -- lock inventory
            lib.progressBar({
                duration = data.cooktime,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disableControl = true,
                disable = {
                    move = true,
                    mouse = true,
                },
                anim = {
                    dict = 'amb_camp@world_player_fire_cook_knife@male_a@wip_base',
                    clip = 'wip_base',
                    flag = 17,
                },
                prop = {
                    {
                        model = `w_melee_knife06`,
                        bone = 16750,
                        pos = vec3(-0.01, -0.02, 0.02),
                        rot = vec3(190.0, 0.0, 0.0)
                    },
                    {
                        model = `p_redefleshymeat01xa`,
                        bone = 16750,
                        pos = vec3(0.00, 0.02, -0.20),
                        rot = vec3(0.0, 0.0, 0.0)
                    },
                },
                label = locale('cl_lang_10').. RSGCore.Shared.Items[data.receive].label,
            })
            TriggerServerEvent('rex-campfire:server:finishcooking', data)
            LocalPlayer.state:set('inv_busy', false, true) -- unlock inventory
        else
            lib.notify({ title = locale('cl_lang_11'), type = 'inform', duration = 7000 })
        end
    end, data.ingredients)
end)

-----------------------
-- destory campfire
-----------------------
RegisterNetEvent('rex-campfire:client:destorycampfire', function(data)
    TaskStartScenarioInPlace(cache.ped, `WORLD_HUMAN_CROUCH_INSPECT`, 0, true)
    Wait(5000)
    SetEntityAsMissionEntity(data.campfire, false)
    FreezeEntityPosition(data.campfire, false)
    DeleteObject(data.campfire)
    local fxcoords = vector3(data.firecoords.x, data.firecoords.y, data.firecoords.z)
    UseParticleFxAsset(fx_group)
    smoke = StartParticleFxNonLoopedAtCoord(fx_name, fxcoords, 0.0, 0.0, 0.0, fx_scale, false, false, false, true)
    ClearPedTasks(cache.ped)
end)

---------------------------------------------
-- cleanup
---------------------------------------------
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for i = 1, #SpawnedCampFires do
        local campfires = SpawnedCampFires[i].campfire
        SetEntityAsMissionEntity(campfires, false)
        FreezeEntityPosition(campfires, false)
        DeleteObject(campfires)
    end
end)
