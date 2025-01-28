local WKXCore = exports['wickx-core']:GetCoreObject()

local Races = {}

RegisterNetEvent('wickx-streetraces:NewRace', function(RaceTable)
    local src = source
    local RaceId = math.random(1000, 9999)
    local xPlayer = WKXCore.Functions.GetPlayer(src)
    if xPlayer.Functions.RemoveMoney('cash', RaceTable.amount, 'streetrace-created') then
        Races[RaceId] = RaceTable
        Races[RaceId].creator = src
        Races[RaceId].joined[#Races[RaceId].joined + 1] = src
        TriggerClientEvent('wickx-streetraces:SetRace', -1, Races)
        TriggerClientEvent('wickx-streetraces:SetRaceId', src, RaceId)
        TriggerClientEvent('WKXCore:Notify', src, 'You joined the race for ' .. Config.Currency .. Races[RaceId].amount .. '.', 'success')
        UpdateRaceInfo(Races[RaceId])
    else
        TriggerClientEvent('WKXCore:Notify', src, 'You do not have ' .. Config.Currency .. RaceTable.amount .. '.', 'error')
    end
end)

RegisterNetEvent('wickx-streetraces:RaceWon', function(RaceId)
    local src = source
    local xPlayer = WKXCore.Functions.GetPlayer(src)
    xPlayer.Functions.AddMoney('cash', Races[RaceId].pot, 'race-won')
    TriggerClientEvent('WKXCore:Notify', src, 'You won the race and ' .. Config.Currency .. Races[RaceId].pot .. ',- recieved', 'success')
    TriggerClientEvent('wickx-streetraces:SetRace', -1, Races)
    TriggerClientEvent('wickx-streetraces:RaceDone', -1, RaceId, GetPlayerName(src))
end)

RegisterNetEvent('wickx-streetraces:JoinRace', function(RaceId)
    local src = source
    local xPlayer = WKXCore.Functions.GetPlayer(src)
    local zPlayer = WKXCore.Functions.GetPlayer(Races[RaceId].creator)
    if zPlayer ~= nil then
        if xPlayer.Functions.RemoveMoney('cash', Races[RaceId].amount, 'streetrace-joined') then
            Races[RaceId].pot = Races[RaceId].pot + Races[RaceId].amount
            Races[RaceId].joined[#Races[RaceId].joined + 1] = src
            TriggerClientEvent('wickx-streetraces:SetRace', -1, Races)
            TriggerClientEvent('wickx-streetraces:SetRaceId', src, RaceId)
            TriggerClientEvent('WKXCore:Notify', src, 'You joined the race', 'primary')
            TriggerClientEvent('WKXCore:Notify', Races[RaceId].creator, GetPlayerName(src) .. ' Joined the race', 'primary')
            UpdateRaceInfo(Races[RaceId])
        else
            TriggerClientEvent('WKXCore:Notify', src, 'You dont have enough cash', 'error')
        end
    else
        TriggerClientEvent('WKXCore:Notify', src, 'The person wo made the race is offline!', 'error')
        Races[RaceId] = {}
    end
end)

WKXCore.Commands.Add(Config.Commands.CreateRace, 'Start A Street Race', { { name = 'amount', help = 'The Stake Amount For The Race.' } }, false, function(source, args)
    local src = source
    local amount = tonumber(args[1])

    if not amount then return TriggerClientEvent('WKXCore:Notify', src, 'Usage: /' .. Config.Commands.CreateRace .. ' [AMOUNT]', 'error') end
    if amount < Config.MinimumStake then
        return TriggerClientEvent('WKXCore:Notify', src, 'The minimum stake is ' .. Config.Currency .. Config.MinimumStake, 'error')
    end
    if amount > Config.MaximumStake then
        return TriggerClientEvent('WKXCore:Notify', src, 'The maximum stake is ' .. Config.Currency .. Config.MaximumStake, 'error')
    end


    if GetJoinedRace(src) == 0 then
        TriggerClientEvent('wickx-streetraces:CreateRace', src, amount)
    else
        TriggerClientEvent('WKXCore:Notify', src, 'You Are Already In A Race', 'error')
    end
end)

WKXCore.Commands.Add(Config.Commands.CancelRace, 'Stop The Race You Created', {}, false, function(source, _)
    CancelRace(source)
end)

WKXCore.Commands.Add(Config.Commands.QuitRace, 'Leave A Race', {}, false, function(source, _)
    local src = source
    local RaceId = GetJoinedRace(src)
    if RaceId ~= 0 then
        if GetCreatedRace(src) ~= RaceId then
            local xPlayer = WKXCore.Functions.GetPlayer(src)
            xPlayer.Functions.AddMoney('cash', Races[RaceId].amount, 'Race Quit')

            Races[RaceId].pot = Races[RaceId].pot - Races[RaceId].amount
            TriggerClientEvent('wickx-streetraces:SetRace', -1, Races)

            TriggerClientEvent('wickx-streetraces:StopRace', src)
            RemoveFromRace(src)
            TriggerClientEvent('WKXCore:Notify', src, 'You Have Stepped Out Of The Race!', 'error')
            UpdateRaceInfo(Races[RaceId])
        else
            TriggerClientEvent('WKXCore:Notify', src, '/' .. Config.Commands.CancelRace .. ' To Stop The Race', 'error')
        end
    else
        TriggerClientEvent('WKXCore:Notify', src, 'You Are Not In A Race ', 'error')
    end
end)

WKXCore.Commands.Add(Config.Commands.StartRace, 'Start The Race', {}, false, function(source)
    local src = source
    local RaceId = GetCreatedRace(src)

    if RaceId ~= 0 then
        Races[RaceId].started = true
        TriggerClientEvent('wickx-streetraces:SetRace', -1, Races)
        TriggerClientEvent('wickx-streetraces:StartRace', -1, RaceId)
    else
        TriggerClientEvent('WKXCore:Notify', src, 'You Have Not Started A Race', 'error')
    end
end)

function CancelRace(source)
    local RaceId = GetCreatedRace(source)
    local Player = WKXCore.Functions.GetPlayer(source)

    if RaceId ~= 0 then
        for key in pairs(Races) do
            if Races[key] ~= nil and Races[key].creator == source then
                if not Races[key].started then
                    for _, iden in pairs(Races[key].joined) do
                        local xdPlayer = WKXCore.Functions.GetPlayer(iden)
                        xdPlayer.Functions.AddMoney('cash', Races[key].amount, 'Race')
                        TriggerClientEvent('WKXCore:Notify', xdPlayer.PlayerData.source, 'Race Has Ended, You Got Back ' .. Config.Currency .. Races[key].amount .. '', 'error')
                        TriggerClientEvent('wickx-streetraces:StopRace', xdPlayer.PlayerData.source)
                    end
                else
                    TriggerClientEvent('WKXCore:Notify', Player.PlayerData.source, 'The Race Has Already Started', 'error')
                end
                TriggerClientEvent('WKXCore:Notify', source, 'Race Stopped!', 'error')
                Races[key] = nil
            end
        end
        TriggerClientEvent('wickx-streetraces:SetRace', -1, Races)
    else
        TriggerClientEvent('WKXCore:Notify', source, 'You Have Not Started A Race!', 'error')
    end
end

function UpdateRaceInfo(race)
    for _, src in pairs(race.joined) do
        TriggerClientEvent('wickx-streetraces:UpdateRaceInfo', src, #race.joined, race.pot)
    end
end

function RemoveFromRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for i, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    table.remove(Races[key].joined, i)
                end
            end
        end
    end
end

function GetJoinedRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    return key
                end
            end
        end
    end
    return 0
end

function GetCreatedRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == identifier and not Races[key].started then
            return key
        end
    end
    return 0
end
