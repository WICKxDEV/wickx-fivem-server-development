-- Variables
local ObjectList = {}
local SpawnedSpikes = {}
local spikemodel = `P_ld_stinger_s`
local ClosestSpike = nil

-- Functions

local function GetClosestPoliceObject()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil

    for id, _ in pairs(ObjectList) do
        local dist2 = #(pos - ObjectList[id].coords)
        if current then
            if dist2 < dist then
                current = id
                dist = dist2
            end
        else
            dist = dist2
            current = id
        end
    end
    return current, dist
end

function GetClosestSpike()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    local maxDistance = 50.0

    for id, _ in pairs(SpawnedSpikes) do
        local spikeCoords = vector3(SpawnedSpikes[id].coords.x, SpawnedSpikes[id].coords.y, SpawnedSpikes[id].coords.z)
        local currentDist = #(pos - spikeCoords)

        if current then
            if currentDist < dist then
                current = id
                dist = currentDist
            end
        else
            current = id
            dist = currentDist
        end
    end

    if dist and dist <= maxDistance then
        ClosestSpike = current
    else
        ClosestSpike = nil
    end
end

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Events

RegisterNetEvent('police:client:spawnCone', function()
    WKXCore.Functions.Progressbar('spawn_object', Lang:t('progressbar.place_object'), 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@narcotics@trash',
        anim = 'drop_front',
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        TriggerServerEvent('police:server:spawnObject', 'cone')
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        WKXCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end)

RegisterNetEvent('police:client:spawnBarrier', function()
    WKXCore.Functions.Progressbar('spawn_object', Lang:t('progressbar.place_object'), 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@narcotics@trash',
        anim = 'drop_front',
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        TriggerServerEvent('police:server:spawnObject', 'barrier')
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        WKXCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end)

RegisterNetEvent('police:client:spawnRoadSign', function()
    WKXCore.Functions.Progressbar('spawn_object', Lang:t('progressbar.place_object'), 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@narcotics@trash',
        anim = 'drop_front',
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        TriggerServerEvent('police:server:spawnObject', 'roadsign')
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        WKXCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end)

RegisterNetEvent('police:client:spawnTent', function()
    WKXCore.Functions.Progressbar('spawn_object', Lang:t('progressbar.place_object'), 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@narcotics@trash',
        anim = 'drop_front',
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        TriggerServerEvent('police:server:spawnObject', 'tent')
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        WKXCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end)

RegisterNetEvent('police:client:spawnLight', function()
    WKXCore.Functions.Progressbar('spawn_object', Lang:t('progressbar.place_object'), 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@narcotics@trash',
        anim = 'drop_front',
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        TriggerServerEvent('police:server:spawnObject', 'light')
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), 'anim@narcotics@trash', 'drop_front', 1.0)
        WKXCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end)

RegisterNetEvent('police:client:deleteObject', function()
    local objectId, dist = GetClosestPoliceObject()
    if dist < 5.0 then
        WKXCore.Functions.Progressbar('remove_object', Lang:t('progressbar.remove_object'), 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@',
            anim = 'plant_floor',
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 1.0)
            TriggerServerEvent('police:server:deleteObject', objectId)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 1.0)
            WKXCore.Functions.Notify(Lang:t('error.canceled'), 'error')
        end)
    end
end)

RegisterNetEvent('police:client:removeObject', function(objectId)
    NetworkRequestControlOfEntity(ObjectList[objectId].object)
    DeleteObject(ObjectList[objectId].object)
    ObjectList[objectId] = nil
end)

RegisterNetEvent('police:client:spawnObject', function(objectId, type, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local heading = GetEntityHeading(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(PlayerPedId())
    local x, y, z = table.unpack(coords + forward * 0.5)
    local spawnedObj = CreateObject(Config.Objects[type].model, x, y, z, true, false, false)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetEntityHeading(spawnedObj, heading)
    FreezeEntityPosition(spawnedObj, Config.Objects[type].freeze)
    ObjectList[objectId] = {
        id = objectId,
        object = spawnedObj,
        coords = vector3(x, y, z - 0.3),
    }
end)

RegisterNetEvent('police:client:SpawnSpikeStrip', function()
    if #SpawnedSpikes + 1 < Config.MaxSpikes then
        if PlayerJob.type == 'leo' and PlayerJob.onduty then
            local spawnCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
            local spike = CreateObject(spikemodel, spawnCoords.x, spawnCoords.y, spawnCoords.z, 1, 1, 1)
            local netid = NetworkGetNetworkIdFromEntity(spike)
            SetNetworkIdExistsOnAllMachines(netid, true)
            SetNetworkIdCanMigrate(netid, false)
            SetEntityHeading(spike, GetEntityHeading(PlayerPedId()))
            PlaceObjectOnGroundProperly(spike)
            SpawnedSpikes[#SpawnedSpikes + 1] = {
                coords = vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z),
                netid = netid,
                object = spike,
            }
            TriggerServerEvent('police:server:SyncSpikes', SpawnedSpikes)
        end
    else
        WKXCore.Functions.Notify(Lang:t('error.no_spikestripe'), 'error')
    end
end)

RegisterNetEvent('police:client:SyncSpikes', function(table)
    SpawnedSpikes = table
end)

-- Threads

CreateThread(function()
    while true do
        local sleep = 1000
        if LocalPlayer.state.isLoggedIn then
            GetClosestSpike()

            if ClosestSpike then
                sleep = 0

                -- Vehicle Interaction (Bursting Tires)
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle and vehicle ~= 0 then
                    local tires = {
                        { bone = 'wheel_lf', index = 0 },
                        { bone = 'wheel_rf', index = 1 },
                        { bone = 'wheel_lm', index = 2 },
                        { bone = 'wheel_rm', index = 3 },
                        { bone = 'wheel_lr', index = 4 },
                        { bone = 'wheel_rr', index = 5 }
                    }

                    for a = 1, #tires do
                        local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                        local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 15.0, spikemodel, 1, 1, 1)
                        local spikePos = GetEntityCoords(spike, false)
                        local distance = #(tirePos - spikePos)

                        if distance < 1.8 then
                            if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                                SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                            end
                        end
                    end
                end

                -- Ped Interaction (Deleting Spike)
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local dist = #(pos - SpawnedSpikes[ClosestSpike].coords)
                if dist < 4 and not IsPedInAnyVehicle(ped, false) then
                    if PlayerJob.type == 'leo' and PlayerJob.onduty then
                        DrawText3D(pos.x, pos.y, pos.z, Lang:t('info.delete_spike'))
                        if IsControlJustPressed(0, 38) then
                            local spike = NetToEnt(SpawnedSpikes[ClosestSpike].netid)
                            NetworkRegisterEntityAsNetworked(spike)
                            NetworkRequestControlOfEntity(spike)
                            SetEntityAsMissionEntity(spike)
                            Wait(500)
                            DeleteEntity(spike)
                            SpawnedSpikes[ClosestSpike] = nil
                            ClosestSpike = nil
                            TriggerServerEvent('police:server:SyncSpikes', SpawnedSpikes)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
