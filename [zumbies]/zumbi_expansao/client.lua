
local zombieModels = {
    { model = `CS_MrAdler`, outfit = 1 },
    { model = `CS_SwampFreak`, outfit = 0 },
    { model = `RE_SavageAftermath_Males_01`, outfit = 3 },
    { model = `RE_SavageAftermath_Females_01`, outfit = 0 },
    { model = `A_M_M_ArmCholeraCorpse_01`, outfit = 4 },
    { model = `A_M_M_UniCorpse_01`, outfit = 159 },
    { model = `U_M_M_APFDeadMan_01`, outfit = 0 },
}

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

function SpawnZombieAtCoords(coords)
    local choice = zombieModels[math.random(#zombieModels)]
    local model = choice.model
    local outfit = choice.outfit or 0

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    local ped = CreatePed(model, coords.x, coords.y, coords.z, 0.0, true, false, 0, 0)
    if not DoesEntityExist(ped) then
        print("[ZUMBI] ERRO: Modelo não pôde ser criado.")
        return
    end

    SetPedOutfitPreset(ped, outfit)
    SetEntityHealth(ped, 200)
    DecorSetBool(ped, "zombie", true)

    LoadAnimDict("move_m@injured")
    SetPedMovementClipset(ped, "move_m@injured", 1.0)

    print("[ZUMBI] Spawnado: " .. tostring(model) .. " (outfit " .. tostring(outfit) .. ")")
end

-- Spawn fixo por toda a cidade
local spawnLocations = {
    vector3(-1800.0, -400.0, 155.0),
    vector3(1230.0, -1290.0, 76.9),
    vector3(-5225.0, -3472.0, -21.0),
    vector3(-370.0, 796.0, 117.0),
    vector3(2950.0, 1395.0, 45.0),
    vector3(1350.0, -1300.0, 77.0),
    vector3(-758.0, -1275.0, 44.0),
}

CreateThread(function()
    while true do
        Wait(20000)
        for i = 1, #spawnLocations do
            local base = spawnLocations[i]
            for j = 1, 3 do
                local offset = vector3(
                    base.x + math.random(-20, 20),
                    base.y + math.random(-20, 20),
                    base.z
                )
                SpawnZombieAtCoords(offset)
            end
        end
    end
end)

-- Animações realistas para zumbis
CreateThread(function()
    while true do
        Wait(1500)
        for _, ped in pairs(GetGamePool('CPed')) do
            if DecorExistOn(ped, "zombie") and not IsPedDeadOrDying(ped) then
                local health = GetEntityHealth(ped)
                if health < 80 and not IsEntityPlayingAnim(ped, "amb_crawl@male_a", "crawl_fwd", 3) then
                    RequestAnimDict("amb_crawl@male_a")
                    while not HasAnimDictLoaded("amb_crawl@male_a") do Wait(10) end
                    TaskPlayAnim(ped, "amb_crawl@male_a", "crawl_fwd", 8.0, -8.0, -1, 1, 0, false, false, false)
                end
            end
        end
    end
end)

-- Ao morrer, contorcer
CreateThread(function()
    while true do
        Wait(1000)
        for _, ped in pairs(GetGamePool('CPed')) do
            if DecorExistOn(ped, "zombie") and IsEntityDead(ped) and not DecorExistOn(ped, "anim_morto") then
                RequestAnimDict("dead@bodyguard@struggle")
                while not HasAnimDictLoaded("dead@bodyguard@struggle") do Wait(10) end
                TaskPlayAnim(ped, "dead@bodyguard@struggle", "death", 8.0, -8.0, 3000, 1, 0, false, false, false)
                DecorSetBool(ped, "anim_morto", true)
            end
        end
    end
end)


-- Ataque com animação ao detectar jogador
CreateThread(function()
    while true do
        Wait(3000)
        for _, ped in pairs(GetGamePool('CPed')) do
            if DecorExistOn(ped, "zombie") and not IsPedDeadOrDying(ped) then
                local player = PlayerPedId()
                local dist = #(GetEntityCoords(ped) - GetEntityCoords(player))
                if dist < 5.0 then
                    RequestAnimDict("melee@unarmed@streamed_core")
                    while not HasAnimDictLoaded("melee@unarmed@streamed_core") do Wait(10) end
                    TaskPlayAnim(ped, "melee@unarmed@streamed_core", "ground_attack_on_spot", 8.0, -8.0, 2000, 1, 0, false, false, false)
                    ApplyDamageToPed(player, 10, false)
                    TriggerEvent("zombie:infectPlayer")
                    print("[ZUMBI] Ataque realizado.")
                end
            end
        end
    end
end)

-- Infecção
local infected = false
RegisterNetEvent("zombie:infectPlayer", function()
    if infected then return end
    infected = true
    print("[ZUMBI] Jogador infectado.")
    DoScreenFadeOut(500)
    Wait(1000)
    DoScreenFadeIn(500)
    StartScreenEffect("DeathFailOut", 0, false)
    ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
    Wait(180000)
    if infected then
        SetEntityHealth(PlayerPedId(), 0)
        print("[ZUMBI] Morreu por infecção.")
    end
end)

RegisterCommand("curarinfeccao", function()
    infected = false
    StopScreenEffect("DeathFailOut")
    print("[ZUMBI] Cura aplicada.")
end)

-- Menu Admin
RegisterCommand("zadmin", function()
    lib.registerContext({
        id = 'zombie_admin',
        title = 'Administração Zumbi',
        options = {
            {
                title = 'Spawnar Horda',
                onSelect = function()
                    local coords = GetEntityCoords(PlayerPedId())
                    for i = 1, 5 do
                        local offset = vector3(coords.x + math.random(-10,10), coords.y + math.random(-10,10), coords.z)
                        SpawnZombieAtCoords(offset)
                    end
                end
            },
            {
                title = 'Curar Infecção',
                onSelect = function()
                    infected = false
                    StopScreenEffect("DeathFailOut")
                end
            },
            {
                title = 'Remover Zumbis',
                onSelect = function()
                    for _, ped in pairs(GetGamePool('CPed')) do
                        if DecorExistOn(ped, "zombie") then DeleteEntity(ped) end
                    end
                end
            },
        }
    })
    lib.showContext('zombie_admin')
end)
