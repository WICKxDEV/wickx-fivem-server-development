local WKXCore = exports['wickx-core']:GetCoreObject()
local trunkBusy = {}

function IsCloseToTarget(source, target)
    if not DoesPlayerExist(target) then return false end
    return #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 2.0
end

RegisterNetEvent('wickx-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('wickx-radialmenu:trunk:client:Door', -1, plate, door, open)
end)

RegisterNetEvent('wickx-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

RegisterNetEvent('wickx-trunk:server:KidnapTrunk', function(target, closestVehicle)
    local src = source
    if not IsCloseToTarget(src, target) then return end
    TriggerClientEvent('wickx-trunk:client:KidnapGetIn', target, closestVehicle)
end)

WKXCore.Functions.CreateCallback('wickx-trunk:server:getTrunkBusy', function(_, cb, plate)
    if trunkBusy[plate] then
        cb(true)
        return
    end
    cb(false)
end)

WKXCore.Commands.Add('getintrunk', Lang:t('general.getintrunk_command_desc'), {}, false, function(source)
    TriggerClientEvent('wickx-trunk:client:GetIn', source)
end)

WKXCore.Commands.Add('putintrunk', Lang:t('general.putintrunk_command_desc'), {}, false, function(source)
    TriggerClientEvent('wickx-trunk:server:KidnapTrunk', source)
end)
