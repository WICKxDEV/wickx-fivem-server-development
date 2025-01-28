-- Variables

local blockedPeds = {
    'mp_m_freemode_01',
    'mp_f_freemode_01',
    'tony',
    'g_m_m_chigoon_02_m',
    'u_m_m_jesus_01',
    'a_m_y_stbla_m',
    'ig_terry_m',
    'a_m_m_ktown_m',
    'a_m_y_skater_m',
    'u_m_y_coop',
    'ig_car3guy1_m',
}

local lastSpectateCoord = nil
local isSpectating = false

-- Events

RegisterNetEvent('wickx-admin:client:spectate', function(targetPed)
    WKXCore.Functions.TriggerCallback('wickx-admin:isAdmin', function(isAdmin)
        if not isAdmin then return end
        local myPed = PlayerPedId()
        local targetplayer = GetPlayerFromServerId(targetPed)
        local target = GetPlayerPed(targetplayer)
        if not isSpectating then
            isSpectating = true
            SetEntityVisible(myPed, false)                  -- Set invisible
            SetEntityCollision(myPed, false, false)         -- Set collision
            SetEntityInvincible(myPed, true)                -- Set invincible
            NetworkSetEntityInvisibleToNetwork(myPed, true) -- Set invisibility
            lastSpectateCoord = GetEntityCoords(myPed)      -- save my last coords
            NetworkSetInSpectatorMode(true, target)         -- Enter Spectate Mode
        else
            isSpectating = false
            NetworkSetInSpectatorMode(false, target)         -- Remove From Spectate Mode
            NetworkSetEntityInvisibleToNetwork(myPed, false) -- Set Visible
            SetEntityCollision(myPed, true, true)            -- Set collision
            SetEntityCoords(myPed, lastSpectateCoord)        -- Return Me To My Coords
            SetEntityVisible(myPed, true)                    -- Remove invisible
            SetEntityInvincible(myPed, false)                -- Remove godmode
            lastSpectateCoord = nil                          -- Reset Last Saved Coords
        end
    end)
end)

RegisterNetEvent('wickx-admin:client:SendReport', function(name, src, msg)
    TriggerServerEvent('wickx-admin:server:SendReport', name, src, msg)
end)

local function getVehicleFromVehList(hash)
    for _, v in pairs(WKXCore.Shared.Vehicles) do
        if hash == v.hash then
            return v.model
        end
    end
end



RegisterNetEvent('wickx-admin:client:SaveCar', function()
    WKXCore.Functions.TriggerCallback('wickx-admin:isAdmin', function(isAdmin)
        if not isAdmin then return end
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped)

        if veh ~= nil and veh ~= 0 then
            local plate = WKXCore.Functions.GetPlate(veh)
            local props = WKXCore.Functions.GetVehicleProperties(veh)
            local hash = props.model
            local vehname = getVehicleFromVehList(hash)
            if WKXCore.Shared.Vehicles[vehname] ~= nil and next(WKXCore.Shared.Vehicles[vehname]) ~= nil then
                TriggerServerEvent('wickx-admin:server:SaveCar', props, WKXCore.Shared.Vehicles[vehname], GetHashKey(veh), plate)
            else
                WKXCore.Functions.Notify(Lang:t('error.no_store_vehicle_garage'), 'error')
            end
        else
            WKXCore.Functions.Notify(Lang:t('error.no_vehicle'), 'error')
        end
    end)
end)

local function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
        Wait(0)
    end
end

local function isPedAllowedRandom(skin)
    local retval = false
    for _, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end

RegisterNetEvent('wickx-admin:client:SetModel', function(skin)
    WKXCore.Functions.TriggerCallback('wickx-admin:isAdmin', function(isAdmin)
        if not isAdmin then return end
        local ped = PlayerPedId()
        local model = GetHashKey(skin)
        SetEntityInvincible(ped, true)

        if IsModelInCdimage(model) and IsModelValid(model) then
            LoadPlayerModel(model)
            SetPlayerModel(PlayerId(), model)

            if isPedAllowedRandom(skin) then
                SetPedRandomComponentVariation(ped, true)
            end

            SetModelAsNoLongerNeeded(model)
        end
        SetEntityInvincible(ped, false)
    end)
end)

RegisterNetEvent('wickx-admin:client:SetSpeed', function(speed)
    WKXCore.Functions.TriggerCallback('wickx-admin:isAdmin', function(isAdmin)
        if not isAdmin then return end
        local ped = PlayerId()
        if speed == 'fast' then
            SetRunSprintMultiplierForPlayer(ped, 1.49)
            SetSwimMultiplierForPlayer(ped, 1.49)
        else
            SetRunSprintMultiplierForPlayer(ped, 1.0)
            SetSwimMultiplierForPlayer(ped, 1.0)
        end
    end)
end)

RegisterNetEvent('wickx-admin:client:GiveNuiFocus', function(focus, mouse)
    SetNuiFocus(focus, mouse)
end)

local performanceModIndices = { 11, 12, 13, 15, 16 }
function PerformanceUpgradeVehicle(vehicle, customWheels)
    customWheels = customWheels or false
    local max
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        SetVehicleModKit(vehicle, 0)
        for _, modType in ipairs(performanceModIndices) do
            max = GetNumVehicleMods(vehicle, tonumber(modType)) - 1
            SetVehicleMod(vehicle, modType, max, customWheels)
        end
        ToggleVehicleMod(vehicle, 18, true) -- Turbo
        SetVehicleFixed(vehicle)
    end
end

RegisterNetEvent('wickx-admin:client:maxmodVehicle', function()
    WKXCore.Functions.TriggerCallback('wickx-admin:isAdmin', function(isAdmin)
        if not isAdmin then return end
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        PerformanceUpgradeVehicle(vehicle)
    end)
end)
