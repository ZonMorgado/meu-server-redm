
local RSGCore = exports['rsg-core']:GetCoreObject()

local weapons = {
	[1] = { ['weapon'] = 'WEAPON_REVOLVER_CATTLEMAN', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Cattleman Revolver', ['AMMOlabel'] = 'revolver ammo',['ammo'] = 'ammo_revolver', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 24,["weapon_AMOUNT"] = 1},
	[2] = { ['weapon'] = 'WEAPON_REVOLVER_DOUBLEACTION', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Double-Action Revolver', ['AMMOlabel'] = 'revolver ammo',['ammo'] = 'ammo_revolver', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 24},
	[3] = { ['weapon'] = 'WEAPON_REVOLVER_SCHOFIELD', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Schofield Revolver', ['AMMOlabel'] = 'revolver ammo',['ammo'] = 'ammo_revolver', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 24},
	[4] = { ['weapon'] = 'WEAPON_REVOLVER_LEMAT', ["PRICE"] = "Contact Gunsmith", ['label'] = 'LeMat Revolver', ['AMMOlabel'] = 'revolver ammo',['ammo'] = 'ammo_revolver', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 24},
	[5] = { ['weapon'] = 'WEAPON_PISTOL_VOLCANIC', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Volcanic Pistol', ['AMMOlabel'] = 'pistol ammo',['ammo'] = 'ammo_pistol', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 24},
	[6] = { ['weapon'] = 'WEAPON_PISTOL_SEMIAUTO', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Semi-Automatic Pistol', ['AMMOlabel'] = 'pistol ammo',['ammo'] = 'ammo_pistol', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 24},
	[7] = { ['weapon'] = 'WEAPON_PISTOL_MAUSER', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Mauser Pistol', ['AMMOlabel'] = 'pistol ammo',['ammo'] = 'ammo_pistol', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 24},
	[8] = { ['weapon'] = 'WEAPON_REPEATER_CARBINE', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Carbine Repeater', ['AMMOlabel'] = 'repeater ammo',['ammo'] = 'ammo_repeater', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 16},
	[9] = { ['weapon'] = 'WEAPON_REPEATER_WINCHESTER', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Lancaster Repeater', ['AMMOlabel'] = 'repeater ammo',['ammo'] = 'ammo_repeater', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 16},
	[10] = { ['weapon'] = 'WEAPON_REPEATER_EVANS', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Carbine Repeater', ['AMMOlabel'] = 'repeater ammo',['ammo'] = 'ammo_repeater', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 16},
	[11] = { ['weapon'] = 'WEAPON_REPEATER_HENRY', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Litchfield Repeater', ['AMMOlabel'] = 'repeater ammo',['ammo'] = 'ammo_repeater', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 16},
	[12] = { ['weapon'] = 'WEAPON_RIFLE_VARMINT', ["PRICE"] = 35, ['label'] = 'Varmint Rifle', ['AMMOlabel'] = 'rifle ammo',['ammo'] = 'ammo_rifle', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 12},
	[13] = { ['weapon'] = 'WEAPON_RIFLE_SPRINGFIELD', ["PRICE"] = 55, ['label'] = 'Springfield Rifle', ['AMMOlabel'] = 'rifle ammo',['ammo'] = 'ammo_rifle', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 12},
	[14] = { ['weapon'] = 'WEAPON_RIFLE_BOLTACTION', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Bolt-Action Rifle', ['AMMOlabel'] = 'rifle ammo',['ammo'] = 'ammo_rifle', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 12},
	[15] = { ['weapon'] = 'WEAPON_SNIPERRIFLE_ROLLINGBLOCK', ["PRICE"] = 75, ['label'] = 'Rolling-Block Rifle', ['AMMOlabel'] = 'rifle ammo',['ammo'] = 'ammo_rifle', ["AMMOPRICE"] = 12,["AMMO_AMOUNT"] = 12},
	[16] = { ['weapon'] = 'WEAPON_SNIPERRIFLE_CARCANO', ["PRICE"] = 70, ['label'] = 'Carcano Rifle', ['AMMOlabel'] = 'rifle ammo',['ammo'] = 'ammo_rifle', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 12},
	[17] = { ['weapon'] = 'WEAPON_SHOTGUN_SAWEDOFF', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Sawed-Off Shotgun', ['AMMOlabel'] = 'shotgun ammo',['ammo'] = 'ammo_shotgun', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 8},
	[18] = { ['weapon'] = 'WEAPON_SHOTGUN_DOUBLEBARREL', ["PRICE"] = 33, ['label'] = 'Double-Barrel Shotgun', ['AMMOlabel'] = 'shotgun ammo',['ammo'] = 'ammo_shotgun', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 8},
	[19] = { ['weapon'] = 'WEAPON_SHOTGUN_PUMP', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Pump-Action Shotgun', ['AMMOlabel'] = 'shotgun ammo',['ammo'] = 'ammo_shotgun', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 8},
	[20] = { ['weapon'] = 'WEAPON_SHOTGUN_REPEATING', ["PRICE"] = 43, ['label'] = 'Repeating Shotgun', ['AMMOlabel'] = 'shotgun ammo',['ammo'] = 'ammo_shotgun', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 8},
	[21] = { ['weapon'] = 'WEAPON_SHOTGUN_SEMIAUTO', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Semi-Automatic Shotgun', ['AMMOlabel'] = 'shotgun ammo',['ammo'] = 'ammo_shotgun', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 8},
	[22] = { ['weapon'] = 'WEAPON_BOW', ["PRICE"] = 20, ['label'] = 'Hunting Bow', ['AMMOlabel'] = 'arrows',['ammo'] = 'ammo_arrow', ["AMMOPRICE"] = 10,["AMMO_AMOUNT"] = 20},
	[23] = { ['weapon'] = 'WEAPON_LASSO', ["PRICE"] = 5, ['label'] = 'Lasso', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[24] = { ['weapon'] = 'WEAPON_MELEE_BROKEN_SWORD', ["PRICE"] = 20, ['label'] = 'Antique Sword', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[25] = { ['weapon'] = 'WEAPON_MELEE_LANTERN', ["PRICE"] = 10, ['label'] = 'Lantern', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[26] = { ['weapon'] = 'WEAPON_MELEE_HATCHET', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Hatchet', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[27] = { ['weapon'] = 'WEAPON_MELEE_KNIFE', ["PRICE"] = 10, ['label'] = 'Hunting Knife', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[28] = { ['weapon'] = 'WEAPON_THROWN_THROWING_KNIVES', ["PRICE"] = 10, ['label'] = 'Throwing Knives', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[29] = { ['weapon'] = 'WEAPON_MELEE_MACHETE', ["PRICE"] = 20, ['label'] = 'Machete', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[30] = { ['weapon'] = 'WEAPON_THROWN_TOMAHAWK', ["PRICE"] = "Contact Gunsmith", ['label'] = 'Tomahawk', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[31] = { ['weapon'] = 'WEAPON_THROWN_DYNAMITE', ["PRICE"] = 50, ['label'] = 'Dynamite Sticks', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},
	[32] = { ['weapon'] = 'WEAPON_THROWN_MOLOTOV', ["PRICE"] = 30, ['label'] = 'Fire Bottles', ['AMMOlabel'] = '', ["AMMOPRICE"] = 0},


}

local code = math.random(111111,9999999)

RegisterNetEvent("gunCatalogue:getCode")
AddEventHandler("gunCatalogue:getCode", function()
	local _source = source
	TriggerClientEvent('gunCatalogue:SendCode', _source, code)
end)


function doesweaponexist(weapon)
	for i = 1,#weapons do
		if weapons[i]['weapon'] == weapon then
			return true
		end
	end
	return false
end

function weapon2(weapon)
	for i = 1,#weapons do
		if weapons[i]['weapon'] == weapon then
			return weapons[i]
		end
	end
	return false
end

---------------------------------------------------------------------------------------------
