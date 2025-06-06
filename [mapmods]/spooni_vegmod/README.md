# 🌱 VegMod
Documentation relating to the [spooni_vegmod](https://github.com/Spooni-Development/spooni_vegmod).

## 1. Installation
spooni_vegmod works Standalone. 

- Download the resource
  - On [Github](https://github.com/Spooni-Development/spooni_vegmod)
- Drag and drop the resource into your resources folder
  - `spooni_vegmod`
- Add this ensure in your server.cfg
  ```
    ensure spooni_vegmod
  ```
- At the end
  - Restart the server

If you have any problems, you can always open a ticket in the [Spooni Discord](https://discord.gg/spooni).

## 2. Usage
This tool allows you to change the vegetation on the map. 

## 3. For developers

```lua
Config = {}

Config.DevMode = true

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
    { -- spooni_sd_farming Hall
        coords = vector3(2683.269, -840.933, 42.300), -- Coords
        radius = 10.0, -- Radius
        distance = 50.0, -- View Distance
        vegmod = { flag = AllFlags, type = AllModifiers,} -- Veg Modifiers Flags/Types
    },
    { -- spooni_sd_farming Office
        coords = vector3(2694.118, -851.498, 42.312),
        radius = 5.0,
        distance = 50.0,
        vegmod = { flag = AllFlags, type = AllModifiers,}
    },
}
```
