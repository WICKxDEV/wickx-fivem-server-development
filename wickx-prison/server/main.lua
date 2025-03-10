local WKXCore = exports['wickx-core']:GetCoreObject()
local GotItems = {}
local AlarmActivated = false

RegisterNetEvent('prison:server:SetJailStatus', function(jailTime)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.SetMetaData('injail', jailTime)
    if jailTime > 0 then
        if Player.PlayerData.job.name ~= 'unemployed' then
            Player.Functions.SetJob('unemployed')
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('info.lost_job'))
        end
    else
        GotItems[source] = nil
    end
end)

RegisterNetEvent('prison:server:SaveJailItems', function()
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    if not Player.PlayerData.metadata['jailitems'] or table.type(Player.PlayerData.metadata['jailitems']) == 'empty' then
        Player.Functions.SetMetaData('jailitems', Player.PlayerData.items)
        Player.Functions.AddMoney('cash', 80, 'jail money')
        Wait(2000)
        Player.Functions.ClearInventory()
    end
end)

RegisterNetEvent('prison:server:GiveJailItems', function(escaped)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    if escaped then
        Player.Functions.SetMetaData('jailitems', {})
        return
    end
    for _, v in pairs(Player.PlayerData.metadata['jailitems']) do
        exports['wickx-inventory']:AddItem(src, v.name, v.amount, false, v.info, 'prison:server:GiveJailItems')
    end
    Player.Functions.SetMetaData('jailitems', {})
end)

RegisterNetEvent('prison:server:ResetJailItems', function()
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.SetMetaData('jailitems', {})
end)

RegisterNetEvent('prison:server:SecurityLockdown', function()
    TriggerClientEvent('prison:client:SetLockDown', -1, true)
    for _, v in pairs(WKXCore.Functions.GetPlayers()) do
        local Player = WKXCore.Functions.GetPlayer(v)
        if Player then
            if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
                TriggerClientEvent('prison:client:PrisonBreakAlert', v)
            end
        end
    end
end)

RegisterNetEvent('prison:server:SetGateHit', function(key)
    TriggerClientEvent('prison:client:SetGateHit', -1, key, true)
    if math.random(1, 100) <= 50 then
        for _, v in pairs(WKXCore.Functions.GetPlayers()) do
            local Player = WKXCore.Functions.GetPlayer(v)
            if Player then
                if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
                    TriggerClientEvent('prison:client:PrisonBreakAlert', v)
                end
            end
        end
    end
end)

RegisterNetEvent('prison:server:CheckRecordStatus', function()
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    local CriminalRecord = Player.PlayerData.metadata['criminalrecord']
    local currentDate = os.date('*t')

    if (CriminalRecord['date'].month + 1) == 13 then
        CriminalRecord['date'].month = 0
    end

    if CriminalRecord['hasRecord'] then
        if currentDate.month == (CriminalRecord['date'].month + 1) or currentDate.day == (CriminalRecord['date'].day - 1) then
            CriminalRecord['hasRecord'] = false
            CriminalRecord['date'] = nil
        end
    end
end)

RegisterNetEvent('prison:server:JailAlarm', function()
    if AlarmActivated then return end
    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)
    local middle = vec2(Config.Locations['middle'].x, Config.Locations['middle'].y)
    if #(coords.xy - middle) < 200 then return error('"prison:server:JailAlarm" triggered whilst the player was too close to the prison, cancelled event') end
    TriggerClientEvent('prison:client:JailAlarm', -1, true)
    SetTimeout(5 * 60000, function()
        TriggerClientEvent('prison:client:JailAlarm', -1, false)
    end)
end)

RegisterNetEvent('prison:server:CheckChance', function()
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.metadata.injail == 0 or GotItems[src] then return end
    local chance = math.random(100)
    local odd = math.random(100)
    if chance ~= odd then return end
    if not exports['wickx-inventory']:AddItem(src, 'phone', 1, false, false, 'prison:server:CheckChance') then return end
    TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items['phone'], 'add')
    TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.found_phone'), 'success')
    GotItems[src] = true
end)

WKXCore.Functions.CreateCallback('prison:server:IsAlarmActive', function(_, cb)
    cb(AlarmActivated)
end)
