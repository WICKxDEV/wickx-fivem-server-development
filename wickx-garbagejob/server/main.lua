local WKXCore = exports['wickx-core']:GetCoreObject()
local Routes = {}

local function CanPay(Player)
    return Player.PlayerData.money['bank'] >= Config.TruckPrice
end

WKXCore.Functions.CreateCallback('wickx-garbagejob:server:NewShift', function(source, cb, continue)
    local Player = WKXCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    local shouldContinue = false
    local nextStop = 0
    local totalNumberOfStops = 0
    local bagNum = 0

    if CanPay(Player) or continue then
        math.randomseed(os.time())
        local MaxStops = math.random(Config.MinStops, #Config.Locations['trashcan'])
        local allStops = {}

        for _ = 1, MaxStops do
            local stop = math.random(#Config.Locations['trashcan'])
            local newBagAmount = math.random(Config.MinBagsPerStop, Config.MaxBagsPerStop)
            allStops[#allStops + 1] = { stop = stop, bags = newBagAmount }
        end

        Routes[CitizenId] = {
            stops = allStops,
            currentStop = 1,
            started = true,
            currentDistance = 0,
            depositPay = Config.TruckPrice,
            actualPay = 0,
            stopsCompleted = 0,
            totalNumberOfStops = #allStops
        }

        nextStop = allStops[1].stop
        shouldContinue = true
        totalNumberOfStops = #allStops
        bagNum = allStops[1].bags
    else
        TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.not_enough', { value = Config.TruckPrice }), 'error')
    end
    cb(shouldContinue, nextStop, bagNum, totalNumberOfStops)
end)

RegisterNetEvent('wickx-garbagejob:server:payDeposit', function()
    local Player = WKXCore.Functions.GetPlayer(source)
    if not Player.Functions.RemoveMoney('bank', Config.TruckPrice, 'garbage-deposit') then
        TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.not_enough', { value = Config.TruckPrice }), 'error')
    end
end)

WKXCore.Functions.CreateCallback('wickx-garbagejob:server:NextStop', function(source, cb, currentStop, currentStopNum, currLocation)
    local Player = WKXCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    local currStopCoords = Config.Locations['trashcan'][currentStop].coords
    currStopCoords = vector3(currStopCoords.x, currStopCoords.y, currStopCoords.z)
    local distance = #(currLocation - currStopCoords)
    local newStop = 0
    local shouldContinue = false
    local newBagAmount = 0

    if (math.random(100) >= Config.CryptoStickChance) and Config.GiveCryptoStick then
        exports['wickx-inventory']:AddItem(source, 'cryptostick', 1, false, false, 'wickx-garbagejob:server:NextStop')
        TriggerClientEvent('wickx-inventory:client:ItemBox', source, WKXCore.Shared.Items['cryptostick'], 'add')
        TriggerClientEvent('WKXCore:Notify', source, Lang:t('info.found_crypto'))
    end

    if distance <= 20 then
        if currentStopNum >= #Routes[CitizenId].stops then
            Routes[CitizenId].stopsCompleted = tonumber(Routes[CitizenId].stopsCompleted) + 1
            newStop = currentStop
        else
            newStop = Routes[CitizenId].stops[currentStopNum + 1].stop
            newBagAmount = Routes[CitizenId].stops[currentStopNum + 1].bags
            shouldContinue = true
            local bagAmount = Routes[CitizenId].stops[currentStopNum].bags
            local totalNewPay = 0

            for _ = 1, bagAmount do
                totalNewPay = totalNewPay + math.random(Config.BagLowerWorth, Config.BagUpperWorth)
            end

            Routes[CitizenId].actualPay = math.ceil(Routes[CitizenId].actualPay + totalNewPay)
            Routes[CitizenId].stopsCompleted = tonumber(Routes[CitizenId].stopsCompleted) + 1
        end
    else
        TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.too_far'), 'error')
    end
    cb(shouldContinue, newStop, newBagAmount)
end)

WKXCore.Functions.CreateCallback('wickx-garbagejob:server:EndShift', function(source, cb)
    local Player = WKXCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    local status = false
    if Routes[CitizenId] ~= nil then status = true end
    cb(status)
end)

RegisterNetEvent('wickx-garbagejob:server:PayShift', function(continue)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    if Routes[CitizenId] ~= nil then
        local depositPay = Routes[CitizenId].depositPay
        if tonumber(Routes[CitizenId].stopsCompleted) < tonumber(Routes[CitizenId].totalNumberOfStops) then
            depositPay = 0
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.early_finish', { completed = Routes[CitizenId].stopsCompleted, total = Routes[CitizenId].totalNumberOfStops }), 'error')
        end
        if continue then
            depositPay = 0
        end
        local totalToPay = depositPay + Routes[CitizenId].actualPay
        local payoutDeposit = Lang:t('info.payout_deposit', { value = depositPay })
        if depositPay == 0 then
            payoutDeposit = ''
        end

        Player.Functions.AddMoney('bank', totalToPay, 'garbage-payslip')
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.pay_slip', { total = totalToPay, deposit = payoutDeposit }), 'success')
        Routes[CitizenId] = nil
    else
        TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.never_clocked_on'), 'error')
    end
end)

WKXCore.Commands.Add('cleargarbroutes', 'Removes garbo routes for user (admin only)', { { name = 'id', help = 'Player ID (may be empty)' } }, false, function(source, args)
    local Player = WKXCore.Functions.GetPlayer(tonumber(args[1]))
    local CitizenId = Player.PlayerData.citizenid
    local count = 0
    for k, _ in pairs(Routes) do
        if k == CitizenId then
            count = count + 1
        end
    end

    TriggerClientEvent('WKXCore:Notify', source, Lang:t('success.clear_routes', { value = count }), 'success')
    Routes[CitizenId] = nil
end, 'admin')
