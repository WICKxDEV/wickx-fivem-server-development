local WKXCore = exports['wickx-core']:GetCoreObject()

RegisterNetEvent('wickx-newsjob:server:addVehicleItems', function(plate)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= 'reporter' then return end
    if not exports['wickx-vehiclekeys']:HasKeys(src, plate) then return end

    for slot, item in pairs(Config.VehicleItems) do
        exports['wickx-inventory']:AddItem('trunk-' .. plate, item.name, item.amount, slot, item.info, 'wickx-newsjob:vehicleItems')
    end
end)

if Config.UseableItems then
    WKXCore.Functions.CreateUseableItem('newscam', function(source)
        local Player = WKXCore.Functions.GetPlayer(source)
        if not Player or Player.PlayerData.job.name ~= 'reporter' then return end
            
        TriggerClientEvent('Cam:ToggleCam', source)
    end)

    WKXCore.Functions.CreateUseableItem('newsmic', function(source)
        local Player = WKXCore.Functions.GetPlayer(source)
        if not Player or Player.PlayerData.job.name ~= 'reporter' then return end
            
        TriggerClientEvent('Mic:ToggleMic', source)
    end)

    WKXCore.Functions.CreateUseableItem('newsbmic', function(source)
        local Player = WKXCore.Functions.GetPlayer(source)
        if not Player or Player.PlayerData.job.name ~= 'reporter' then return end
            
        TriggerClientEvent('Mic:ToggleBMic', source)
    end)

else
    WKXCore.Commands.Add('newscam', 'Grab a news camera', {}, false, function(source, _)
        local Player = WKXCore.Functions.GetPlayer(source)
        if not Player or Player.PlayerData.job.name ~= 'reporter' then return end

        TriggerClientEvent('Cam:ToggleCam', source)
    end)

    WKXCore.Commands.Add('newsmic', 'Grab a news microphone', {}, false, function(source, _)
        local Player = WKXCore.Functions.GetPlayer(source)
        if not Player or Player.PlayerData.job.name ~= 'reporter' then return end
                
        TriggerClientEvent('Mic:ToggleMic', source)
    end)

    WKXCore.Commands.Add('newsbmic', 'Grab a Boom microphone', {}, false, function(source, _)
        local Player = WKXCore.Functions.GetPlayer(source)
        if not Player or Player.PlayerData.job.name ~= 'reporter' then return end
                
        TriggerClientEvent('Mic:ToggleBMic', source)
    end)
end
