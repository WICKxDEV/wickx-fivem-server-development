local WKXCore = exports['wickx-core']:GetCoreObject()

local function exploitBan(id, reason)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            GetPlayerName(id),
            WKXCore.Functions.GetIdentifier(id, 'license'),
            WKXCore.Functions.GetIdentifier(id, 'discord'),
            WKXCore.Functions.GetIdentifier(id, 'ip'),
            reason,
            2147483647,
            'wickx-pawnshop'
        })
    TriggerEvent('wickx-log:server:CreateLog', 'pawnshop', 'Player Banned', 'red',
        string.format('%s was banned by %s for %s', GetPlayerName(id), 'wickx-pawnshop', reason), true)
    DropPlayer(id, 'You were permanently banned by the server for: Exploiting')
end

RegisterNetEvent('wickx-pawnshop:server:sellPawnItems', function(itemName, itemAmount, itemPrice)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    local totalPrice = (tonumber(itemAmount) * itemPrice)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local dist
    for _, value in pairs(Config.PawnLocation) do
        dist = #(playerCoords - value.coords)
        if #(playerCoords - value.coords) < 2 then
            dist = #(playerCoords - value.coords)
            break
        end
    end
    if dist > 5 then
        exploitBan(src, 'sellPawnItems Exploiting')
        return
    end
    if exports['wickx-inventory']:RemoveItem(src, itemName, tonumber(itemAmount), false, 'wickx-pawnshop:server:sellPawnItems') then
        if Config.BankMoney then
            Player.Functions.AddMoney('bank', totalPrice, 'wickx-pawnshop:server:sellPawnItems')
        else
            Player.Functions.AddMoney('cash', totalPrice, 'wickx-pawnshop:server:sellPawnItems')
        end
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.sold', { value = tonumber(itemAmount), value2 = WKXCore.Shared.Items[itemName].label, value3 = totalPrice }), 'success')
        TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[itemName], 'remove')
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.no_items'), 'error')
    end
    TriggerClientEvent('wickx-pawnshop:client:openMenu', src)
end)

RegisterNetEvent('wickx-pawnshop:server:meltItemRemove', function(itemName, itemAmount, item)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if exports['wickx-inventory']:RemoveItem(src, itemName, itemAmount, false, 'wickx-pawnshop:server:meltItemRemove') then
        TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[itemName], 'remove')
        local meltTime = (tonumber(itemAmount) * item.time)
        TriggerClientEvent('wickx-pawnshop:client:startMelting', src, item, tonumber(itemAmount), (meltTime * 60000 / 1000))
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('info.melt_wait', { value = meltTime }), 'primary')
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.no_items'), 'error')
    end
end)

RegisterNetEvent('wickx-pawnshop:server:pickupMelted', function(item)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local dist
    for _, value in pairs(Config.PawnLocation) do
        dist = #(playerCoords - value.coords)
        if #(playerCoords - value.coords) < 2 then
            dist = #(playerCoords - value.coords)
            break
        end
    end
    if dist > 5 then
        exploitBan(src, 'pickupMelted Exploiting')
        return
    end
    for _, v in pairs(item.items) do
        local meltedAmount = v.amount
        for _, m in pairs(v.item.reward) do
            local rewardAmount = m.amount
            if exports['wickx-inventory']:AddItem(src, m.item, (meltedAmount * rewardAmount), false, false, 'wickx-pawnshop:server:pickupMelted') then
                TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[m.item], 'add')
                TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.items_received', { value = (meltedAmount * rewardAmount), value2 = WKXCore.Shared.Items[m.item].label }), 'success')
                TriggerClientEvent('wickx-pawnshop:client:resetPickup', src)
            else
                TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.inventory_full', { value = WKXCore.Shared.Items[m.item].label }), 'warning', 7500)
            end
        end
    end
    TriggerClientEvent('wickx-pawnshop:client:openMenu', src)
end)

WKXCore.Functions.CreateCallback('wickx-pawnshop:server:getInv', function(source, cb)
    local Player = WKXCore.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items
    return cb(inventory)
end)
