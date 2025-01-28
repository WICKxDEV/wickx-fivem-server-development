RegisterNetEvent('wickx-radialmenu:server:RemoveStretcher', function(pos, stretcherObject)
    TriggerClientEvent('wickx-radialmenu:client:RemoveStretcherFromArea', -1, pos, stretcherObject)
end)

RegisterNetEvent('wickx-radialmenu:Stretcher:BusyCheck', function(target, type)
    local src = source
    if not IsCloseToTarget(src, target) then return end
    TriggerClientEvent('wickx-radialmenu:Stretcher:client:BusyCheck', target, source, type)
end)

RegisterNetEvent('wickx-radialmenu:server:BusyResult', function(isBusy, target, type)
    local src = source
    if not IsCloseToTarget(src, target) then return end
    TriggerClientEvent('wickx-radialmenu:client:Result', target, isBusy, type)
end)
