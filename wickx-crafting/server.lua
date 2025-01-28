local WKXCore = exports['wickx-core']:GetCoreObject()

-- Functions

local function IncreasePlayerXP(source, xpGain, xpType)
    local Player = WKXCore.Functions.GetPlayer(source)
    if Player then
        local currentXP = Player.Functions.GetRep(xpType)
        local newXP = currentXP + xpGain
        Player.Functions.AddRep(xpType, newXP)
        TriggerClientEvent('WKXCore:Notify', source, string.format(Lang:t('notifications.xpGain'), xpGain, xpType), 'success')
    end
end

-- Callbacks

WKXCore.Functions.CreateCallback('crafting:getPlayerInventory', function(source, cb)
    local player = WKXCore.Functions.GetPlayer(source)
    if player then
        cb(player.PlayerData.items)
    else
        cb({})
    end
end)

-- Events
RegisterServerEvent('wickx-crafting:server:removeMaterials', function(itemName, amount)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if Player then
        exports['wickx-inventory']:RemoveItem(src, itemName, amount, false, 'wickx-crafting:server:removeMaterials')
        TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[itemName], 'remove')
    end
end)

RegisterNetEvent('wickx-crafting:server:removeCraftingTable', function(benchType)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    exports['wickx-inventory']:RemoveItem(src, benchType, 1, false, 'wickx-crafting:server:removeCraftingTable')
    TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[benchType], 'remove')
    TriggerClientEvent('WKXCore:Notify', src, Lang:t('notifications.tablePlace'), 'success')
end)

RegisterNetEvent('wickx-crafting:server:addCraftingTable', function(benchType)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    if not exports['wickx-inventory']:AddItem(src, benchType, 1, false, false, 'wickx-crafting:server:addCraftingTable') then return end
    TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[benchType], 'add')
end)

RegisterNetEvent('wickx-crafting:server:receiveItem', function(craftedItem, requiredItems, amountToCraft, xpGain, xpType)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    if not Player then return end
    local canGive = true
    for _, requiredItem in ipairs(requiredItems) do
        if not exports['wickx-inventory']:RemoveItem(src, requiredItem.item, requiredItem.amount, false, 'wickx-crafting:server:receiveItem') then
            canGive = false
            return
        end
        TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[requiredItem.item], 'remove')
    end
    if canGive then
        if not exports['wickx-inventory']:AddItem(src, craftedItem, amountToCraft, false, false, 'wickx-crafting:server:receiveItem') then return end
        TriggerClientEvent('wickx-inventory:client:ItemBox', src, WKXCore.Shared.Items[craftedItem], 'add')
        TriggerClientEvent('WKXCore:Notify', src, string.format(Lang:t('notifications.craftMessage'), WKXCore.Shared.Items[craftedItem].label), 'success')
        IncreasePlayerXP(src, xpGain, xpType)
    end
end)

-- Items

for benchType, _ in pairs(Config) do
    WKXCore.Functions.CreateUseableItem(benchType, function(source)
        TriggerClientEvent('wickx-crafting:client:useCraftingTable', source, benchType)
    end)
end
