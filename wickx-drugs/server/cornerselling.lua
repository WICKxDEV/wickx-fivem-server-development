local StolenDrugs = {}

local function getAvailableDrugs(source)
    local AvailableDrugs = {}
    local Player = WKXCore.Functions.GetPlayer(source)

    if not Player then return nil end

    for k in pairs(Config.DrugsPrice) do
        local item = Player.Functions.GetItemByName(k)

        if item then
            AvailableDrugs[#AvailableDrugs + 1] = {
                item = item.name,
                amount = item.amount,
                label = WKXCore.Shared.Items[item.name]['label']
            }
        end
    end
    return table.type(AvailableDrugs) ~= 'empty' and AvailableDrugs or nil
end

WKXCore.Functions.CreateCallback('wickx-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    cb(getAvailableDrugs(source))
end)

RegisterNetEvent('wickx-drugs:server:giveStealItems', function(drugType, amount)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player or StolenDrugs == {} then return end
    for k, v in pairs(StolenDrugs) do
        if drugType == v.item and amount == v.amount then
            exports['wickx-inventory']:AddItem(src, drugType, amount, false, false, 'wickx-drugs:server:giveStealItems')
            table.remove(StolenDrugs, k)
        end
    end
end)

RegisterNetEvent('wickx-drugs:server:sellCornerDrugs', function(drugType, amount, price)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)
    if not availableDrugs or not Player then return end
    local item = availableDrugs[drugType].item
    local hasItem = Player.Functions.GetItemByName(item)
    if hasItem.amount >= amount then
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('success.offer_accepted'), 'success')
        exports['wickx-inventory']:RemoveItem(src, item, amount, false, 'wickx-drugs:server:sellCornerDrugs')
        Player.Functions.AddMoney('cash', price, 'wickx-drugs:server:sellCornerDrugs')
        TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[item], 'remove')
        TriggerClientEvent('wickx-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
    else
        TriggerClientEvent('wickx-drugs:client:cornerselling', src)
    end
end)

RegisterNetEvent('wickx-drugs:server:robCornerDrugs', function(drugType, amount)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)
    if not availableDrugs or not Player then return end
    local item = availableDrugs[drugType].item
    exports['wickx-inventory']:RemoveItem(src, item, amount, false, 'wickx-drugs:server:robCornerDrugs')
    table.insert(StolenDrugs, { item = item, amount = amount })
    TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[item], 'remove')
    TriggerClientEvent('wickx-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
end)
