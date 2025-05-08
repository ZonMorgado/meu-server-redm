Config = {}

Config.SpawnDistanceRadius = 30 -- the distance the animal spawns away from the bait 
Config.HideTime = 10000 -- the amount of time in miliseconds that you have to hide before animal aproaches the bait
Config.AnimalWait = 10000 -- the amount of time in miliseconds that the animal will wait at the bait until freeroam

Config.HuntingZones = {
	{
		name       = 'huntingzone1',
		coords     = vector3(-1054.0793, -673.3105, 72.3116),
		radius     = 100.0, 
		showblip   = true,
        blipName   = 'Hunting Zone',
        blipSprite = `blip_mp_deliver_target`,
        blipScale  = 0.2,
		animal       = 'mp_a_c_boar_01',
		bait       = 'consumable_herbivore_bait',
		animalname       = 'Boar',
		baitname       = 'Herbivore Bait',
		enterzone = true,
		health     = 200.0,
		timer     = 60,
	},
	{
		name       = 'huntingzone2',
		coords     = vector3(-2297.2400, -462.6606, 143.1794),
		radius     = 100.0, 
		showblip   = true,
        blipName   = 'Hunting Zone',
        blipSprite = `blip_mp_deliver_target`,
        blipScale  = 0.2,
		animal     = 'mp_a_c_beaver_01',
		bait       = 'consumable_herbivore_bait',
		animalname  = 'Beaver',
		baitname    = 'Herbivore Bait',
		enterzone = true,
		health     = 200.0,
		timer     = 60,
	},
	{
		name       = 'huntingzone3',
		coords     = vector3(1191.3398, 2047.3147, 324.7537),
		radius     = 100.0, 
		showblip   = true,
        blipName   = 'Hunting Zone',
        blipSprite = `blip_mp_deliver_target`,
        blipScale  = 0.2,
		animal       = 'mp_a_c_cougar_01',
		bait       = 'consumable_potent_predator_bait',
		animalname   = 'Cougar',
		baitname       = 'Potent Predator Bait',
		enterzone = true,
		health     = 200.0,
		timer     = 60,
	},
	{
		name       = 'huntingzone4',
		coords     = vector3(-1361.0551, -1384.6249, 94.1296),
		radius     = 100.0, 
		showblip   = true,
        blipName   = 'Hunting Zone6',
        blipSprite = `blip_mp_deliver_target`,
        blipScale  = 0.2,
		animal       = 'mp_a_c_coyote_01',
		bait       = 'consumable_predator_bait',
		animalname       = 'Coyote',
		baitname       = 'Predator Bait',
		enterzone = true,
		health     = 200.0,
		timer     = 60,
	},
	{
		name       = 'huntingzone5',
		coords     = vector3(390.9921, 1276.2581, 196.6426),
		radius     = 100.0, 
		showblip   = true,
        blipName   = 'Hunting Zone',
        blipSprite = `blip_mp_deliver_target`,
        blipScale  = 0.2,
		animal       = 'mp_a_c_panther_01',
		bait       = 'consumable_potent_predator_bait',
		animalname       = 'Panther',
		baitname       = 'Potent Predator Bait',
		enterzone = true,
		health     = 200.0,
		timer     = 60,
	},
	{
		name       = 'huntingzone6',
		coords     = vector3(-1392.3319, 2242.6992, 307.9457),
		radius     = 100.0, 
		showblip   = true,
        blipName   = 'Hunting Zone',
        blipSprite = `blip_mp_deliver_target`,
        blipScale  = 0.2,
		animal     = 'mp_a_c_wolf_01',
		bait       = 'consumable_predator_bait',
		animalname     = 'Wolf',
		baitname       = 'Predator Bait',
		enterzone = true,
		health     = 200.0,
		timer     = 60,
	},
		{
		name       = 'huntingzone7',
		coords     = vector3(2025.0481, -1026.3876, 43.3879),
		radius     = 100.0, 
		showblip   = true,
        blipName   = 'Hunting Zone',
        blipSprite = `blip_mp_deliver_target`,
        blipScale  = 0.2,
		animal     = 'a_c_alligator_02',
		bait       = 'consumable_potent_predator_bait',
		animalname     = 'Alligator',
		baitname       = 'Potent Predator Bait',
		enterzone = true,
		health     = 300.0,
		timer     = 60,
	},
}

-- Animal model hashes
local config = {}
config.animal_models = {
    ["mp_a_c_panther_01"] = true
}


Config.SpawnAnimal = {
	[1] = { ["Model"] = "mp_a_c_beaver_01", 	["Pos"] = vector3(-1182.29, 1063.17, 166.02 -1),		["Heading"] = 0.0 },
	[2] = { ["Model"] = "mp_a_c_cougar_01", 	["Pos"] = vector3(-2081.77, -175.32, 202.03 -1),		["Heading"] = 173.33 },
	[3] = { ["Model"] = "mp_a_c_alligator_01", 	["Pos"] = vector3(2341.46, -545.29, 41.92 -1),			["Heading"] = 139.76 },
	[4] = { ["Model"] = "mp_a_c_panther_01", 	["Pos"] = vector3(1115.52, 1897.05, 327.23 -1),			["Heading"] = 190.96 },
	[5] = { ["Model"] = "mp_a_c_panther_01", 	["Pos"] = vector3(979.01, -1229.21, 60.01 -1),			["Heading"] = 124.6 },
	[6] = { ["Model"] = "mp_a_c_wolf_01", 		["Pos"] = vector3(-627.36, 528.5, 97.01 -1),			["Heading"] = 299.06 },
	[7] = { ["Model"] = "mp_a_c_boar_01", 		["Pos"] = vector3(-1854.97, -1598.9, 107.29 -1),		["Heading"] = 341.83 },
	[8] = { ["Model"] = "mp_a_c_beaver_01", 	["Pos"] = vector3(-2357.043, -474.8927, 142.01301 -1),	["Heading"] = 1.227958 },
	[9] = { ["Model"] = "mp_a_c_panther_01", 	["Pos"] = vector3(1456.3269, -7087.985, 75.894462 -1),	["Heading"] = 34.374881 }, -- guarma
	[10] = { ["Model"] = "mp_a_c_cougar_01", 	["Pos"] = vector3(1261.06, 1190.20, 147.40 -1),			["Heading"] = 34.374881 }, -- Ponf Bears
	-- Diamonds 
	[12] = { ["Model"] = "mp_a_c_bear_01", 	["Pos"] = vector3(-2723.47, 725.09, 171.32 -1),			["Heading"] = -7.84 }, -- Ponf Bears
	[13] = { ["Model"] = "mp_a_c_bear_01", 	["Pos"] = vector3(-2130.42, 124.52, 236.62 -1),			["Heading"] = 137.71 }, -- Ponf Bears
	
--Rubys
	[14] = { ["Model"] = "a_c_snake_01", 	["Pos"] = vector3(2317.41455078125, 1137.5675048828125, 96.38571166992188 -1),			["Heading"] = -7.84 }, --snake
	[15] = { ["Model"] = "a_c_snake_01", 	["Pos"] = vector3(2317.41455078125, 1137.5675048828125, 96.38571166992188 -1),			["Heading"] = 137.71 }, -- Snake
	[16] = { ["Model"] = "a_c_snake_01", 	["Pos"] = vector3(2317.41455078125, 1137.5675048828125, 96.38571166992188 -1),			["Heading"] = -7.84 }, --snake
	[17] = { ["Model"] = "a_c_snake_01", 	["Pos"] = vector3(2317.41455078125, 1137.5675048828125, 96.38571166992188 -1),			["Heading"] = 137.71 }, -- Snake
	[18] = { ["Model"] = "a_c_snake_01", 	["Pos"] = vector3(2317.41455078125, 1137.5675048828125, 96.38571166992188 -1),			["Heading"] = -7.84 }, --snake
	[19] = { ["Model"] = "a_c_snake_01", 	["Pos"] = vector3(2317.41455078125, 1137.5675048828125, 96.38571166992188 -1),			["Heading"] = 137.71 }, -- Snake
	[20] = { ["Model"] = "a_c_snake_01", 	["Pos"] = vector3(2317.41455078125, 1137.5675048828125, 96.38571166992188 -1),			["Heading"] = -7.84 }, --snake
	[21] = { ["Model"] = "a_c_snake_01", 	["Pos"] = vector3(2317.41455078125, 1137.5675048828125, 96.38571166992188 -1),			["Heading"] = 137.71 }, -- Snake

	[22] = { ["Model"] = "a_c_snakeblacktailrattle_01", 	["Pos"] = vector3(2304.051025390625, 1135.0902099609375, 96.23624420166016 -1),			["Heading"] = -7.84 }, --snake
	[23] = { ["Model"] = "a_c_snakeblacktailrattle_01", 	["Pos"] = vector3(2304.051025390625, 1135.0902099609375, 96.23624420166016 -1),			["Heading"] = 137.71 }, -- Snake
	[24] = { ["Model"] = "a_c_snakeblacktailrattle_01", 	["Pos"] = vector3(2304.051025390625, 1135.0902099609375, 96.23624420166016 -1),			["Heading"] = -7.84 }, --snake
	[25] = { ["Model"] = "a_c_snakeblacktailrattle_01", 	["Pos"] = vector3(2304.051025390625, 1135.0902099609375, 96.23624420166016 -1),			["Heading"] = 137.71 }, -- Snake
	[26] = { ["Model"] = "a_c_snakeblacktailrattle_01", 	["Pos"] = vector3(2304.051025390625, 1135.0902099609375, 96.23624420166016 -1),			["Heading"] = -7.84 }, --snake
	[27] = { ["Model"] = "a_c_snakeblacktailrattle_01", 	["Pos"] = vector3(2304.051025390625, 1135.0902099609375, 96.23624420166016 -1),			["Heading"] = 137.71 }, -- Snake
	[28] = { ["Model"] = "a_c_snakeblacktailrattle_01", 	["Pos"] = vector3(2304.051025390625, 1135.0902099609375, 96.23624420166016 -1),			["Heading"] = -7.84 }, --snake
	[29] = { ["Model"] = "a_c_snakeblacktailrattle_01", 	["Pos"] = vector3(2304.051025390625, 1135.0902099609375, 96.23624420166016 -1),			["Heading"] = 137.71 }, -- Snake
	
	[30] = { ["Model"] = "mp_a_c_bear_01", 	["Pos"] = vector3(2325.337158203125, 1072.4620361328125, 93.56884765625 -1),			["Heading"] = 137.71 }, -- Ponf Bears

	[31] = { ["Model"] = "mp_a_c_alligator_01", 	["Pos"] = vector3(2364.126953125, 995.9747314453125, 73.90508270263672 -1),			["Heading"] = 139.76 }, -- Gator["Heading"] = 137.71 }, -- Ponf Bears
}