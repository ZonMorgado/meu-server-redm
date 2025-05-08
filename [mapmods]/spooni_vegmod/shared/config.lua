Config = {}

Config.DevMode = false

--Veg Modifiers Flags
local Debris = 1
local Grass = 2
local Bush = 4
local Weed = 8
local Flower = 16
local Sapling = 32
local Tree = 64
local Rock = 128
local LongGrass = 256
local AllFlags = Debris + Grass + Bush + Weed + Flower + Sapling + Tree + Rock + LongGrass

-- Veg Modifier Types
local VMT_Cull = 1
local VMT_Flatten = 2
local VMT_FlattenDeepSurface = 4
local VMT_Explode = 8
local VMT_Push = 16
local VMT_Decal = 32
local AllModifiers = VMT_Cull + VMT_Flatten + VMT_FlattenDeepSurface + VMT_Explode + VMT_Push + VMT_Decal

Config.VegZones = {
    { -- bal-medicoffice
        coords = vector3(-809.2277, -1234.9084, 42.9989), -- Coords
        radius = 0.3, -- Radius
        distance = 50.0, -- View Distance
        vegmod = { flag = AllFlags, type = AllModifiers } -- Veg Modifiers Flags/Types
    },
}
