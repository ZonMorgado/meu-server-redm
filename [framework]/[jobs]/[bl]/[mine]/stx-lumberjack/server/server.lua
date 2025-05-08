local RSGCore = exports['rsg-core']:GetCoreObject()


RegisterServerEvent("cools-lumberjack:axecheck")
AddEventHandler("cools-lumberjack:axecheck", function(tree)
	local _source = source
	local choppingtree = tree
    local Player = RSGCore.Functions.GetPlayer(_source)
	if Player.Functions.GetItemByName(Config.Axe) then
		if Player.Functions.GetItemByName(Config.Axe).amount >= 1 then
			TriggerClientEvent("cools-lumberjack:axechecked", _source, choppingtree)
		else
			TriggerClientEvent("cools-lumberjack:noaxe", _source)
			TriggerClientEvent('RSGCore:Notify', _source, 'you dont have an axe!', 'primary')
		end
	else
		TriggerClientEvent("cools-lumberjack:noaxe", _source)
		TriggerClientEvent('RSGCore:Notify', _source, 'you dont have an axe!', 'primary')

	end

end)

function keysx(table)
    local keys = 0
    for k,v in pairs(table) do
       keys = keys + 1
    end
    return keys
end

RegisterServerEvent('cools-lumberjack:addItem')
AddEventHandler('cools-lumberjack:addItem', function()
	local _source = source
	local Player = RSGCore.Functions.GetPlayer(_source)
	local chance =  math.random(1,10)
	local reward = {}
	for k,v in pairs(Config.Items) do 
		if v.chance >= chance then
			table.insert(reward,v)
		end
	end
	local chance2 = math.random(1,keysx(reward))
	if Player.Functions.AddItem(reward[chance2].name, reward[chance2].amount) then

		TriggerClientEvent('RSGCore:Notify', _source, 3,'you got some wood!', 'primary')
		TriggerClientEvent('inventory:client:ItemBox', _source, RSGCore.Shared.Items[reward[chance2].name], "add")

	else
		TriggerClientEvent('RSGCore:Notify', _source, 3, "You can't carry more items", 1500)
	end
end)