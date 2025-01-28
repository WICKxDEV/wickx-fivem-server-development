-- Event Handler

AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if not WKXCore.Players[src] then return end
    local Player = WKXCore.Players[src]
    TriggerEvent('wickxlog:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..' .. '\n **Reason:** ' .. reason)
    TriggerEvent('WKXCore:Server:PlayerDropped', Player)
    Player.Functions.Save()
    WKXCore.Player_Buckets[Player.PlayerData.license] = nil
    WKXCore.Players[src] = nil
end)

AddEventHandler("onResourceStop", function(resName)
    for i,v in pairs(WKXCore.UsableItems) do
        if v.resource == resName then
            WKXCore.UsableItems[i] = nil
        end
    end
end)

-- Player Connecting
local readyFunction = MySQL.ready
local databaseConnected, bansTableExists = readyFunction == nil, readyFunction == nil
if readyFunction ~= nil then
    MySQL.ready(function()
        databaseConnected = true

        local DatabaseInfo = WKXCore.Functions.GetDatabaseInfo()
        if not DatabaseInfo or not DatabaseInfo.exists then return end

        local result = MySQL.query.await('SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ? AND TABLE_NAME = "bans";', {DatabaseInfo.database})
        if result and result[1] then
            bansTableExists = true
        end
    end)
end

local function onPlayerConnecting(name, _, deferrals)
    local src = source
    deferrals.defer()

    if WKXCore.Config.Server.Closed and not IsPlayerAceAllowed(src, 'WKXadmin.join') then
        return deferrals.done(WKXCore.Config.Server.ClosedReason)
    end

    if not databaseConnected then
        return deferrals.done(Lang:t('error.connecting_database_error'))
    end

    if WKXCore.Config.Server.Whitelist then
        Wait(0)
        deferrals.update(string.format(Lang:t('info.checking_whitelisted'), name))
        if not WKXCore.Functions.IsWhitelisted(src) then
            return deferrals.done(Lang:t('error.not_whitelisted'))
        end
    end

    Wait(0)
    deferrals.update(string.format('Hello %s. Your license is being checked', name))
    local license = WKXCore.Functions.GetIdentifier(src, 'license')

    if not license then
        return deferrals.done(Lang:t('error.no_valid_license'))
    elseif WKXCore.Config.Server.CheckDuplicateLicense and WKXCore.Functions.IsLicenseInUse(license) then
        return deferrals.done(Lang:t('error.duplicate_license'))
    end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.checking_ban'), name))

    if not bansTableExists then
        return deferrals.done(Lang:t('error.ban_table_not_found'))
    end

    local success, isBanned, reason = pcall(WKXCore.Functions.IsPlayerBanned, src)
    if not success then return deferrals.done(Lang:t('error.connecting_database_error')) end
    if isBanned then return deferrals.done(reason) end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.join_server'), name))
    deferrals.done()

    TriggerClientEvent('WKXCore:Client:SharedUpdate', src, WKXCore.Shared)
end

AddEventHandler('playerConnecting', onPlayerConnecting)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('WKXCore:Server:CloseServer', function(reason)
    local src = source
    if WKXCore.Functions.HasPermission(src, 'admin') then
        reason = reason or 'No reason specified'
        WKXCore.Config.Server.Closed = true
        WKXCore.Config.Server.ClosedReason = reason
        for k in pairs(WKXCore.Players) do
            if not WKXCore.Functions.HasPermission(k, WKXCore.Config.Server.WhitelistPermission) then
                WKXCore.Functions.Kick(k, reason, nil, nil)
            end
        end
    else
        WKXCore.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

RegisterNetEvent('WKXCore:Server:OpenServer', function()
    local src = source
    if WKXCore.Functions.HasPermission(src, 'admin') then
        WKXCore.Config.Server.Closed = false
    else
        WKXCore.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

-- Callback Events --

-- Client Callback
RegisterNetEvent('WKXCore:Server:TriggerClientCallback', function(name, ...)
    if WKXCore.ClientCallbacks[name] then
        WKXCore.ClientCallbacks[name].promise:resolve(...)

        if WKXCore.ClientCallbacks[name].callback then
            WKXCore.ClientCallbacks[name].callback(...)
        end

        WKXCore.ClientCallbacks[name] = nil
    end
end)

-- Server Callback
RegisterNetEvent('WKXCore:Server:TriggerCallback', function(name, ...)
    if not WKXCore.ServerCallbacks[name] then return end

    local src = source

    WKXCore.ServerCallbacks[name](src, function(...)
        TriggerClientEvent('WKXCore:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Player

RegisterNetEvent('WKXCore:UpdatePlayer', function()
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    local newHunger = Player.PlayerData.metadata['hunger'] - WKXCore.Config.Player.HungerRate
    local newThirst = Player.PlayerData.metadata['thirst'] - WKXCore.Config.Player.ThirstRate
    if newHunger <= 0 then
        newHunger = 0
    end
    if newThirst <= 0 then
        newThirst = 0
    end
    Player.Functions.SetMetaData('thirst', newThirst)
    Player.Functions.SetMetaData('hunger', newHunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
    Player.Functions.Save()
end)

RegisterNetEvent('WKXCore:ToggleDuty', function()
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('info.off_duty'))
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('info.on_duty'))
    end

    TriggerEvent('WKXCore:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('WKXCore:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- BaseEvents

-- Vehicles
RegisterServerEvent('baseevents:enteringVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entering'
    }
    TriggerClientEvent('WKXCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteredVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entered'
    }
    TriggerClientEvent('WKXCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteringAborted', function()
    local src = source
    TriggerClientEvent('WKXCore:Client:AbortVehicleEntering', src)
end)

RegisterServerEvent('baseevents:leftVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Left'
    }
    TriggerClientEvent('WKXCore:Client:VehicleInfo', src, data)
end)

-- Items

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon.
RegisterNetEvent('WKXCore:Server:UseItem', function(item)
    print(string.format('%s triggered WKXCore:Server:UseItem by ID %s with the following data. This event is deprecated due to exploitation, and will be removed soon. Check wickxinventory for the right use on this event.', GetInvokingResource(), source))
    WKXCore.Debug(item)
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot)
RegisterNetEvent('WKXCore:Server:RemoveItem', function(itemName, amount)
    local src = source
    print(string.format('%s triggered WKXCore:Server:RemoveItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.', GetInvokingResource(), src, amount, itemName))
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot, info)
RegisterNetEvent('WKXCore:Server:AddItem', function(itemName, amount)
    local src = source
    print(string.format('%s triggered WKXCore:Server:AddItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.', GetInvokingResource(), src, amount, itemName))
end)

-- Non-Chat Command Calling (ex: wickxadminmenu)

RegisterNetEvent('WKXCore:CallCommand', function(command, args)
    local src = source
    if not WKXCore.Commands.List[command] then return end
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    local hasPerm = WKXCore.Functions.HasPermission(src, 'command.' .. WKXCore.Commands.List[command].name)
    if hasPerm then
        if WKXCore.Commands.List[command].argsrequired and #WKXCore.Commands.List[command].arguments ~= 0 and not args[#WKXCore.Commands.List[command].arguments] then
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.missing_args2'), 'error')
        else
            WKXCore.Commands.List[command].callback(src, args)
        end
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.no_access'), 'error')
    end
end)

-- Use this for player vehicle spawning
-- Vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
WKXCore.Functions.CreateCallback('WKXCore:Server:SpawnVehicle', function(source, cb, model, coords, warp)
    local veh = WKXCore.Functions.SpawnVehicle(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

-- Use this for long distance vehicle spawning
-- vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
WKXCore.Functions.CreateCallback('WKXCore:Server:CreateVehicle', function(source, cb, model, coords, warp)
    local veh = WKXCore.Functions.CreateAutomobile(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

--WKXCore.Functions.CreateCallback('WKXCore:HasItem', function(source, cb, items, amount)
-- https://github.com/WKXcore-framework/wickxinventory/blob/e4ef156d93dd1727234d388c3f25110c350b3bcf/server/main.lua#L2066
--end)
