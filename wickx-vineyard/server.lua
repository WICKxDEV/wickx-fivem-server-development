local WKXCore = exports['wickx-core']:GetCoreObject()

RegisterNetEvent('wickx-vineyard:server:getGrapes', function()
    local Player = WKXCore.Functions.GetPlayer(source)
    local amount = math.random(Config.GrapeAmount.min, Config.GrapeAmount.max)
    exports['wickx-inventory']:AddItem(source, 'grape', amount, false, false, 'wickx-vineyard:server:getGrapes')
    TriggerClientEvent('wickx-inventory:client:ItemBox', source, WKXCore.Shared.Items['grape'], 'add')
end)

WKXCore.Functions.CreateCallback('wickx-vineyard:server:loadIngredients', function(source, cb)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    local grape = Player.Functions.GetItemByName('grapejuice')
    if Player.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 23 then
                exports['wickx-inventory']:RemoveItem(src, 'grapejuice', 23, false, 'wickx-vineyard:server:loadIngredients')
                TriggerClientEvent('wickx-inventory:client:ItemBox', source, WKXCore.Shared.Items['grapejuice'], 'remove')
                cb(true)
            else
                TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.invalid_items'), 'error')
                cb(false)
            end
        else
            TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.invalid_items'), 'error')
            cb(false)
        end
    else
        TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.no_items'), 'error')
        cb(false)
    end
end)

WKXCore.Functions.CreateCallback('wickx-vineyard:server:grapeJuice', function(source, cb)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    local grape = Player.Functions.GetItemByName('grape')
    if Player.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 16 then
                exports['wickx-inventory']:RemoveItem(src, 'grape', 16, false, 'wickx-vineyard:server:grapeJuice')
                TriggerClientEvent('wickx-inventory:client:ItemBox', source, WKXCore.Shared.Items['grape'], 'remove')
                cb(true)
            else
                TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.invalid_items'), 'error')
                cb(false)
            end
        else
            TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.invalid_items'), 'error')
            cb(false)
        end
    else
        TriggerClientEvent('WKXCore:Notify', source, Lang:t('error.no_items'), 'error')
        cb(false)
    end
end)

RegisterNetEvent('wickx-vineyard:server:receiveWine', function()
    local Player = WKXCore.Functions.GetPlayer(tonumber(source))
    local amount = math.random(Config.WineAmount.min, Config.WineAmount.max)
    exports['wickx-inventory']:AddItem(source, 'wine', amount, false, false, 'wickx-vineyard:server:receiveWine')
    TriggerClientEvent('wickx-inventory:client:ItemBox', source, WKXCore.Shared.Items['wine'], 'add')
end)

RegisterNetEvent('wickx-vineyard:server:receiveGrapeJuice', function()
    local Player = WKXCore.Functions.GetPlayer(tonumber(source))
    local amount = math.random(Config.GrapeJuiceAmount.min, Config.GrapeJuiceAmount.max)
    exports['wickx-inventory']:AddItem(source, 'grapejuice', amount, false, false, 'wickx-vineyard:server:receiveGrapeJuice')
    TriggerClientEvent('wickx-inventory:client:ItemBox', source, WKXCore.Shared.Items['grapejuice'], 'add')
end)
