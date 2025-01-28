local WKXCore = exports['wickx-core']:GetCoreObject()

-- Functions

local function ResetHouseStateTimer(house)
    CreateThread(function()
        Wait(Config.TimeToCloseDoors * 60000)
        Config.Houses[house]['opened'] = false
        for _, v in pairs(Config.Houses[house]['furniture']) do
            v['searched'] = false
        end
        TriggerClientEvent('wickx-houserobbery:client:ResetHouseState', -1, house)
    end)
end

-- Callbacks

WKXCore.Functions.CreateCallback('wickx-houserobbery:server:GetHouseConfig', function(_, cb)
    cb(Config.Houses)
end)

-- Events

RegisterNetEvent('wickx-houserobbery:server:SetBusyState', function(cabin, house, bool)
    Config.Houses[house]['furniture'][cabin]['isBusy'] = bool
    TriggerClientEvent('wickx-houserobbery:client:SetBusyState', -1, cabin, house, bool)
end)

RegisterNetEvent('wickx-houserobbery:server:enterHouse', function(house)
    local src = source
    if not Config.Houses[house]['opened'] then
        ResetHouseStateTimer(house)
        TriggerClientEvent('wickx-houserobbery:client:setHouseState', -1, house, true)
    end
    TriggerClientEvent('wickx-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]['opened'] = true
end)

RegisterNetEvent('wickx-houserobbery:server:searchFurniture', function(cabin, house)
    local src = source
    local player = WKXCore.Functions.GetPlayer(src)
    local tier = Config.Houses[house].tier
    local availableItems = Config.Rewards[tier][Config.Houses[house].furniture[cabin].type]
    local itemCount = math.random(0, 3)
    if itemCount > 0 then
        for _ = 1, itemCount do
            local selectedItem = availableItems[math.random(1, #availableItems)]
            local itemInfo = WKXCore.Shared.Items[selectedItem.item]

            if not itemInfo.unique then
                local amount = math.random(selectedItem.min, selectedItem.max)
                exports['wickx-inventory']:AddItem(src, selectedItem.item, amount, false, false, 'wickx-houserobbery:server:searchFurniture')
            else
                exports['wickx-inventory']:AddItem(src, selectedItem.item, 1, false, false, 'wickx-houserobbery:server:searchFurniture')
            end
            TriggerClientEvent('wickx-inventory:client:ItemBox', src, itemInfo, 'add')
            Wait(500)
        end
    else
        TriggerClientEvent('WKXCore:Notify', src, Lang:t('error.emty_box'), 'error')
    end
    Config.Houses[house]['furniture'][cabin]['searched'] = true
    TriggerClientEvent('wickx-houserobbery:client:setCabinState', -1, house, cabin, true)
end)

RegisterNetEvent('wickx-houserobbery:server:removeAdvancedLockpick', function()
    local Player = WKXCore.Functions.GetPlayer(source)
    if not Player then return end
    exports['wickx-inventory']:RemoveItem(source, 'advancedlockpick', 1, false, 'wickx-houserobbery:server:removeAdvancedLockpick')
end)

RegisterNetEvent('wickx-houserobbery:server:removeLockpick', function()
    local Player = WKXCore.Functions.GetPlayer(source)
    if not Player then return end
    exports['wickx-inventory']:RemoveItem(source, 'lockpick', 1, false, 'wickx-houserobbery:server:removeLockpick')
end)
