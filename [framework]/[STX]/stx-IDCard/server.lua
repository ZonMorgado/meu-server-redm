
RegisterNetEvent('stx-IDCard:server:openRegister',function(town)
    local src = source
    local Character = BSGetName(src)
    local data = {
        action = "register",
        name = Character.firstname.." "..Character.lastname,
    }
    TriggerClientEvent('stx-IDCard:client:openRegister',src,data)
end)

RegisterNetEvent('stx-IDCard:server:createIDCard',function(data)
    local src = source
    BSAddItem(src,"idcard",1,{
        idcarddata = data,
        description = data.name.."'s IDCard <input type='hidden' value='"..math.random(1,999999).."'>"
    })
    Notify({
        source = src,
        text = "IDCard successfully received!",
        time = 5000,
        type = "success"
    })
end)

BSRegisterUsableItem("idcard",function(data)
    local src = data.source
    local item = data.item
    if item.metadata and item.metadata.idcarddata then
        TriggerClientEvent('stx-IDCard:client:openIDCard',-1,item,GetEntityCoords(GetPlayerPed(src)))
    else
        Notify({
            source = src,
            text = "IDCard Error! Please register",
            time = 5000,
            type = "error"
        })
    end
end)