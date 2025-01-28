-- Variables
local WKXCore = exports['wickx-core']:GetCoreObject()
local financetimer = {}

-- Handlers
-- Store game time for player when they load
RegisterNetEvent('wickx-vehicleshop:server:addPlayer', function(citizenid)
    financetimer[citizenid] = os.time()
end)

-- Deduct stored game time from player on logout
RegisterNetEvent('wickx-vehicleshop:server:removePlayer', function(citizenid)
    if financetimer[citizenid] then
        local playTime = financetimer[citizenid]
        local financetime = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { citizenid })
        for _, v in pairs(financetime) do
            if v.balance >= 1 then
                local newTime = (v.financetime - ((os.time() - playTime) / 60))
                if newTime < 0 then newTime = 0 end
                MySQL.update('UPDATE player_vehicles SET financetime = ? WHERE plate = ?', { math.ceil(newTime), v.plate })
            end
        end
    end
    financetimer[citizenid] = nil
end)

-- Deduct stored game time from player on quit because we can't get citizenid
AddEventHandler('playerDropped', function()
    local src = source
    local license
    for _, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len('license:')) == 'license:' then
            license = v
        end
    end
    if license then
        local vehicles = MySQL.query.await('SELECT * FROM player_vehicles WHERE license = ?', { license })
        if vehicles then
            for _, v in pairs(vehicles) do
                local playTime = financetimer[v.citizenid]
                if v.balance >= 1 and playTime then
                    local newTime = (v.financetime - ((os.time() - playTime) / 60))
                    if newTime < 0 then newTime = 0 end
                    MySQL.update('UPDATE player_vehicles SET financetime = ? WHERE plate = ?', { math.ceil(newTime), v.plate })
                end
            end
            if vehicles[1] and financetimer[vehicles[1].citizenid] then financetimer[vehicles[1].citizenid] = nil end
        end
    end
end)

-- Functions
local function round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

local function calculateFinance(vehiclePrice, downPayment, paymentamount)
    local balance = vehiclePrice - downPayment
    local vehPaymentAmount = balance / paymentamount
    return round(balance), round(vehPaymentAmount)
end

local function calculateNewFinance(paymentAmount, vehData)
    local newBalance = tonumber(vehData.balance - paymentAmount)
    local minusPayment = vehData.paymentsLeft - 1
    local newPaymentsLeft = newBalance / minusPayment
    local newPayment = newBalance / newPaymentsLeft
    return round(newBalance), round(newPayment), newPaymentsLeft
end

local function GeneratePlate()
    local plate = WKXCore.Shared.RandomInt(1) .. WKXCore.Shared.RandomStr(2) .. WKXCore.Shared.RandomInt(3) .. WKXCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

local function comma_value(amount)
    local formatted = amount
    local k
    while true do
        formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

-- Callbacks
WKXCore.Functions.CreateCallback('wickx-vehicleshop:server:getVehicles', function(source, cb)
    local src = source
    local player = WKXCore.Functions.GetPlayer(src)
    if player then
        local vehicles = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { player.PlayerData.citizenid })
        if vehicles[1] then
            cb(vehicles)
        end
    end
end)

-- Events

-- Brute force vehicle deletion
RegisterNetEvent('wickx-vehicleshop:server:deleteVehicle', function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    DeleteEntity(vehicle)
end)

-- Sync vehicle for other players
RegisterNetEvent('wickx-vehicleshop:server:swapVehicle', function(data)
    local src = source
    TriggerClientEvent('wickx-vehicleshop:client:swapVehicle', -1, data)
    Wait(1500)                                                -- let new car spawn
    TriggerClientEvent('wickx-vehicleshop:client:homeMenu', src) -- reopen main menu
end)

-- Send customer for test drive
RegisterNetEvent('wickx-vehicleshop:server:customTestDrive', function(vehicle, playerid)
    local src = source
    local target = tonumber(playerid)
    if not WKXCore.Functions.GetPlayer(target) then
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.Invalid_ID'), 'error')
        return
    end
    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target))) < 3 then
        TriggerClientEvent('wickx-vehicleshop:client:customTestDrive', target, vehicle)
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.playertoofar'), 'error')
    end
end)

-- Make a finance payment
RegisterNetEvent('wickx-vehicleshop:server:financePayment', function(paymentAmount, vehData)
    local src = source
    local player = WKXCore.Functions.GetPlayer(src)
    local cash = player.PlayerData.money['cash']
    local bank = player.PlayerData.money['bank']
    local plate = vehData.vehiclePlate
    paymentAmount = tonumber(paymentAmount)
    local minPayment = tonumber(vehData.paymentAmount)
    local timer = (Config.PaymentInterval * 60)
    local newBalance, newPaymentsLeft, newPayment = calculateNewFinance(paymentAmount, vehData)
    if newBalance > 0 then
        if player and paymentAmount >= minPayment then
            if cash >= paymentAmount then
                player.Functions.RemoveMoney('cash', paymentAmount, 'financed vehicle')
                MySQL.update('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', { newBalance, newPayment, newPaymentsLeft, timer, plate })
            elseif bank >= paymentAmount then
                player.Functions.RemoveMoney('bank', paymentAmount, 'financed vehicle')
                MySQL.update('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', { newBalance, newPayment, newPaymentsLeft, timer, plate })
            else
                TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
            end
        else
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.minimumallowed') .. comma_value(minPayment), 'error')
        end
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.overpaid'), 'error')
    end
end)


-- Pay off vehice in full
RegisterNetEvent('wickx-vehicleshop:server:financePaymentFull', function(data)
    local src = source
    local player = WKXCore.Functions.GetPlayer(src)
    local cash = player.PlayerData.money['cash']
    local bank = player.PlayerData.money['bank']
    local vehBalance = data.vehBalance
    local vehPlate = data.vehPlate
    if player and vehBalance ~= 0 then
        if cash >= vehBalance then
            player.Functions.RemoveMoney('cash', vehBalance, 'paid off vehicle')
            MySQL.update('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', { 0, 0, 0, 0, vehPlate })
        elseif bank >= vehBalance then
            player.Functions.RemoveMoney('bank', vehBalance, 'paid off vehicle')
            MySQL.update('UPDATE player_vehicles SET balance = ?, paymentamount = ?, paymentsleft = ?, financetime = ? WHERE plate = ?', { 0, 0, 0, 0, vehPlate })
        else
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
        end
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.alreadypaid'), 'error')
    end
end)

-- Buy public vehicle outright
RegisterNetEvent('wickx-vehicleshop:server:buyShowroomVehicle', function(vehicle)
    local src = source
    vehicle = vehicle.buyVehicle
    local pData = WKXCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = WKXCore.Shared.Vehicles[vehicle]['price']
    local plate = GeneratePlate()
    if cash > tonumber(vehiclePrice) then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            'pillboxgarage',
            0
        })
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.purchased'), 'success')
        TriggerClientEvent('wickx-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
    elseif bank > tonumber(vehiclePrice) then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            'pillboxgarage',
            0
        })
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.purchased'), 'success')
        TriggerClientEvent('wickx-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
    end
end)

-- Finance public vehicle
RegisterNetEvent('wickx-vehicleshop:server:financeVehicle', function(downPayment, paymentAmount, vehicle)
    local src = source
    downPayment = tonumber(downPayment)
    paymentAmount = tonumber(paymentAmount)
    local pData = WKXCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = WKXCore.Shared.Vehicles[vehicle]['price']
    local timer = (Config.PaymentInterval * 60)
    local minDown = tonumber(round((Config.MinimumDown / 100) * vehiclePrice))
    if downPayment > vehiclePrice then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notworth'), 'error') end
    if downPayment < minDown then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.downtoosmall'), 'error') end
    if paymentAmount > Config.MaximumPayments then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.exceededmax'), 'error') end
    local plate = GeneratePlate()
    local balance, vehPaymentAmount = calculateFinance(vehiclePrice, downPayment, paymentAmount)
    if cash >= downPayment then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            'pillboxgarage',
            0,
            balance,
            vehPaymentAmount,
            paymentAmount,
            timer
        })
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.purchased'), 'success')
        TriggerClientEvent('wickx-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', downPayment, 'vehicle-bought-in-showroom')
    elseif bank >= downPayment then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            'pillboxgarage',
            0,
            balance,
            vehPaymentAmount,
            paymentAmount,
            timer
        })
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.purchased'), 'success')
        TriggerClientEvent('wickx-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', downPayment, 'vehicle-bought-in-showroom')
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
    end
end)

-- Sell vehicle to customer
RegisterNetEvent('wickx-vehicleshop:server:sellShowroomVehicle', function(data, playerid)
    local src = source
    local player = WKXCore.Functions.GetPlayer(src)
    local target = WKXCore.Functions.GetPlayer(tonumber(playerid))

    if not target then
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.Invalid_ID'), 'error')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target.PlayerData.source))) < 3 then
        local cid = target.PlayerData.citizenid
        local cash = target.PlayerData.money['cash']
        local bank = target.PlayerData.money['bank']
        local vehicle = data
        local vehiclePrice = WKXCore.Shared.Vehicles[vehicle]['price']
        local commission = round(vehiclePrice * Config.Commission)
        local plate = GeneratePlate()
        if cash >= tonumber(vehiclePrice) then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                'pillboxgarage',
                0
            })
            TriggerClientEvent('wickx-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission, 'vehicle sale commission')
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.earned_commission', { amount = comma_value(commission) }), 'success')
            exports['wickx-banking']:AddMoney(player.PlayerData.job.name, vehiclePrice, 'Vehicle sale')
            TriggerClientEvent('WKXCore:Notify', target.PlayerData.source, Lang:t('success.purchased'), 'success')
        elseif bank >= tonumber(vehiclePrice) then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                'pillboxgarage',
                0
            })
            TriggerClientEvent('wickx-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission, 'vehicle sale commission')
            exports['wickx-banking']:AddMoney(player.PlayerData.job.name, vehiclePrice, 'Vehicle sale')
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.earned_commission', { amount = comma_value(commission) }), 'success')
            TriggerClientEvent('WKXCore:Notify', target.PlayerData.source, Lang:t('success.purchased'), 'success')
        else
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
        end
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.playertoofar'), 'error')
    end
end)

-- Finance vehicle to customer
RegisterNetEvent('wickx-vehicleshop:server:sellfinanceVehicle', function(downPayment, paymentAmount, vehicle, playerid)
    local src = source
    local player = WKXCore.Functions.GetPlayer(src)
    local target = WKXCore.Functions.GetPlayer(tonumber(playerid))

    if not target then
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.Invalid_ID'), 'error')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target.PlayerData.source))) < 3 then
        downPayment = tonumber(downPayment)
        paymentAmount = tonumber(paymentAmount)
        local cid = target.PlayerData.citizenid
        local cash = target.PlayerData.money['cash']
        local bank = target.PlayerData.money['bank']
        local vehiclePrice = WKXCore.Shared.Vehicles[vehicle]['price']
        local timer = (Config.PaymentInterval * 60)
        local minDown = tonumber(round((Config.MinimumDown / 100) * vehiclePrice))
        if downPayment > vehiclePrice then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notworth'), 'error') end
        if downPayment < minDown then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.downtoosmall'), 'error') end
        if paymentAmount > Config.MaximumPayments then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.exceededmax'), 'error') end
        local commission = round(vehiclePrice * Config.Commission)
        local plate = GeneratePlate()
        local balance, vehPaymentAmount = calculateFinance(vehiclePrice, downPayment, paymentAmount)
        if cash >= downPayment then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                'pillboxgarage',
                0,
                balance,
                vehPaymentAmount,
                paymentAmount,
                timer
            })
            TriggerClientEvent('wickx-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('cash', downPayment, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission, 'vehicle sale commission')
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.earned_commission', { amount = comma_value(commission) }), 'success')
            exports['wickx-banking']:AddMoney(player.PlayerData.job.name, vehiclePrice, 'Vehicle sale')
            TriggerClientEvent('WKXCore:Notify', target.PlayerData.source, Lang:t('success.purchased'), 'success')
        elseif bank >= downPayment then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                target.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                'pillboxgarage',
                0,
                balance,
                vehPaymentAmount,
                paymentAmount,
                timer
            })
            TriggerClientEvent('wickx-vehicleshop:client:buyShowroomVehicle', target.PlayerData.source, vehicle, plate)
            target.Functions.RemoveMoney('bank', downPayment, 'vehicle-bought-in-showroom')
            player.Functions.AddMoney('bank', commission, 'vehicle sale commission')
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.earned_commission', { amount = comma_value(commission) }), 'success')
            exports['wickx-banking']:AddMoney(player.PlayerData.job.name, vehiclePrice, 'Vehicle sale')
            TriggerClientEvent('WKXCore:Notify', target.PlayerData.source, Lang:t('success.purchased'), 'success')
        else
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notenoughmoney'), 'error')
        end
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.playertoofar'), 'error')
    end
end)

-- Check if payment is due
RegisterNetEvent('wickx-vehicleshop:server:checkFinance', function()
    local src = source
    local player = WKXCore.Functions.GetPlayer(src)
    local query = 'SELECT * FROM player_vehicles WHERE citizenid = ? AND balance > 0 AND financetime < 1'
    local result = MySQL.query.await(query, { player.PlayerData.citizenid })
    if result[1] then
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('general.paymentduein', { time = Config.PaymentWarning }))
        Wait(Config.PaymentWarning * 60000)
        local vehicles = MySQL.query.await(query, { player.PlayerData.citizenid })
        for _, v in pairs(vehicles) do
            local plate = v.plate
            MySQL.query('DELETE FROM player_vehicles WHERE plate = @plate', { ['@plate'] = plate })
            --MySQL.update('UPDATE player_vehicles SET citizenid = ? WHERE plate = ?', {'REPO-'..v.citizenid, plate}) -- Use this if you don't want them to be deleted
            TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.repossessed', { plate = plate }), 'error')
        end
    end
end)

-- Transfer vehicle to player in passenger seat
WKXCore.Commands.Add('transfervehicle', Lang:t('general.command_transfervehicle'), { { name = 'ID', help = Lang:t('general.command_transfervehicle_help') }, { name = 'amount', help = Lang:t('general.command_transfervehicle_amount') } }, false, function(source, args)
    local src = source
    local buyerId = tonumber(args[1])
    local sellAmount = tonumber(args[2])
    if buyerId == 0 then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.Invalid_ID'), 'error') end
    local ped = GetPlayerPed(src)
    local targetPed = GetPlayerPed(buyerId)
    if targetPed == 0 then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.buyerinfo'), 'error') end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notinveh'), 'error') end
    local plate = WKXCore.Shared.Trim(GetVehicleNumberPlateText(vehicle))
    if not plate then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.vehinfo'), 'error') end
    local player = WKXCore.Functions.GetPlayer(src)
    local target = WKXCore.Functions.GetPlayer(buyerId)
    local row = MySQL.single.await('SELECT * FROM player_vehicles WHERE plate = ?', { plate })
    if Config.PreventFinanceSelling then
        if row.balance > 0 then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.financed'), 'error') end
    end
    if row.citizenid ~= player.PlayerData.citizenid then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.notown'), 'error') end
    if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) > 5.0 then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.playertoofar'), 'error') end
    local targetcid = target.PlayerData.citizenid
    local targetlicense = WKXCore.Functions.GetIdentifier(target.PlayerData.source, 'license')
    if not target then return TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.buyerinfo'), 'error') end
    if not sellAmount then
        MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', { targetcid, targetlicense, plate })
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.gifted'), 'success')
        TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
        TriggerClientEvent('WKXCore:Notify', buyerId, Lang:t('success.received_gift'), 'success')
        return
    end
    if target.Functions.GetMoney('cash') > sellAmount then
        MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', { targetcid, targetlicense, plate })
        player.Functions.AddMoney('cash', sellAmount, 'transferred vehicle')
        target.Functions.RemoveMoney('cash', sellAmount, 'transferred vehicle')
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.soldfor') .. comma_value(sellAmount), 'success')
        TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
        TriggerClientEvent('WKXCore:Notify', buyerId, Lang:t('success.boughtfor') .. comma_value(sellAmount), 'success')
    elseif target.Functions.GetMoney('bank') > sellAmount then
        MySQL.update('UPDATE player_vehicles SET citizenid = ?, license = ? WHERE plate = ?', { targetcid, targetlicense, plate })
        player.Functions.AddMoney('bank', sellAmount, 'transferred vehicle')
        target.Functions.RemoveMoney('bank', sellAmount, 'transferred vehicle')
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.soldfor') .. comma_value(sellAmount), 'success')
        TriggerClientEvent('vehiclekeys:client:SetOwner', buyerId, plate)
        TriggerClientEvent('WKXCore:Notify', buyerId, Lang:t('success.boughtfor') .. comma_value(sellAmount), 'success')
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.buyertoopoor'), 'error')
    end
end)
