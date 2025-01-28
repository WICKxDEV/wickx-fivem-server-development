-- Commands

WKXCore.Commands.Add('giveitem', 'Give An Item (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'item', help = 'Name of the item (not a label)' }, { name = 'amount', help = 'Amount of items' } }, false, function(source, args)
    local id = tonumber(args[1])
    local player = WKXCore.Functions.GetPlayer(id)
    local amount = tonumber(args[3]) or 1
    local itemData = WKXCore.Shared.Items[tostring(args[2]):lower()]
    if player then
        if itemData then
            -- check iteminfo
            local info = {}
            if itemData['name'] == 'id_card' then
                info.citizenid = player.PlayerData.citizenid
                info.firstname = player.PlayerData.charinfo.firstname
                info.lastname = player.PlayerData.charinfo.lastname
                info.birthdate = player.PlayerData.charinfo.birthdate
                info.gender = player.PlayerData.charinfo.gender
                info.nationality = player.PlayerData.charinfo.nationality
            elseif itemData['name'] == 'driver_license' then
                info.firstname = player.PlayerData.charinfo.firstname
                info.lastname = player.PlayerData.charinfo.lastname
                info.birthdate = player.PlayerData.charinfo.birthdate
                info.type = 'Class C Driver License'
            elseif itemData['type'] == 'weapon' then
                amount = 1
                info.serie = tostring(WKXCore.Shared.RandomInt(2) .. WKXCore.Shared.RandomStr(3) .. WKXCore.Shared.RandomInt(1) .. WKXCore.Shared.RandomStr(2) .. WKXCore.Shared.RandomInt(3) .. WKXCore.Shared.RandomStr(4))
                info.quality = 100
            elseif itemData['name'] == 'harness' then
                info.uses = 20
            elseif itemData['name'] == 'markedbills' then
                info.worth = math.random(5000, 10000)
            elseif itemData['name'] == 'printerdocument' then
                info.url = 'https://cdn.discordapp.com/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png'
            end

            if AddItem(id, itemData['name'], amount, false, info, 'give item command') then
                WKXCore.Functions.Notify(source, Lang:t('notify.yhg') .. GetPlayerName(id) .. ' ' .. amount .. ' ' .. itemData['name'] .. '', 'success')
                TriggerClientEvent('wickx-inventory:client:ItemBox', id, itemData, 'add', amount)
                if Player(id).state.inv_busy then TriggerClientEvent('wickx-inventory:client:updateInventory', id) end
            else
                WKXCore.Functions.Notify(source, Lang:t('notify.cgitem'), 'error')
            end
        else
            WKXCore.Functions.Notify(source, Lang:t('notify.idne'), 'error')
        end
    else
        WKXCore.Functions.Notify(source, Lang:t('notify.pdne'), 'error')
    end
end, 'admin')

WKXCore.Commands.Add('randomitems', 'Receive random items', {}, false, function(source)
    local player = WKXCore.Functions.GetPlayer(source)
    local playerInventory = player.PlayerData.items
    local filteredItems = {}
    for k, v in pairs(WKXCore.Shared.Items) do
        if WKXCore.Shared.Items[k]['type'] ~= 'weapon' then
            filteredItems[#filteredItems + 1] = v
        end
    end
    for _ = 1, 10, 1 do
        local randitem = filteredItems[math.random(1, #filteredItems)]
        local amount = math.random(1, 10)
        if randitem['unique'] then
            amount = 1
        end
        local emptySlot = nil
        for i = 1, Config.MaxSlots do
            if not playerInventory[i] then
                emptySlot = i
                break
            end
        end
        if emptySlot then
            if AddItem(source, randitem.name, amount, emptySlot, false, 'random items command') then
                TriggerClientEvent('wickx-inventory:client:ItemBox', source, WKXCore.Shared.Items[randitem.name], 'add')
                player = WKXCore.Functions.GetPlayer(source)
                playerInventory = player.PlayerData.items
                if Player(source).state.inv_busy then TriggerClientEvent('wickx-inventory:client:updateInventory', source) end
            end
            Wait(1000)
        end
    end
end, 'god')

WKXCore.Commands.Add('clearinv', 'Clear Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local id = tonumber(args[1])
    if not id then
        ClearInventory(source)
        return
    end
    ClearInventory(id)
end, 'admin')

-- Keybindings

RegisterCommand('closeInv', function(source)
    CloseInventory(source)
end, false)

RegisterCommand('hotbar', function(source)
    if Player(source).state.inv_busy then return end
    local WKXPlayer = WKXCore.Functions.GetPlayer(source)
    if not WKXPlayer then return end
    if not WKXPlayer or WKXPlayer.PlayerData.metadata['isdead'] or WKXPlayer.PlayerData.metadata['inlaststand'] or WKXPlayer.PlayerData.metadata['ishandcuffed'] then return end
    local hotbarItems = {
        WKXPlayer.PlayerData.items[1],
        WKXPlayer.PlayerData.items[2],
        WKXPlayer.PlayerData.items[3],
        WKXPlayer.PlayerData.items[4],
        WKXPlayer.PlayerData.items[5],
    }
    TriggerClientEvent('wickx-inventory:client:hotbar', source, hotbarItems)
end, false)

RegisterCommand('inventory', function(source)
    if Player(source).state.inv_busy then return end
    local WKXPlayer = WKXCore.Functions.GetPlayer(source)
    if not WKXPlayer then return end
    if not WKXPlayer or WKXPlayer.PlayerData.metadata['isdead'] or WKXPlayer.PlayerData.metadata['inlaststand'] or WKXPlayer.PlayerData.metadata['ishandcuffed'] then return end
    WKXCore.Functions.TriggerClientCallback('wickx-inventory:client:vehicleCheck', source, function(inventory, class)
        if not inventory then return OpenInventory(source) end
        if inventory:find('trunk-') then
            OpenInventory(source, inventory, {
                slots = VehicleStorage[class] and VehicleStorage[class].trunkSlots or VehicleStorage.default.slots,
                maxweight = VehicleStorage[class] and VehicleStorage[class].trunkWeight or VehicleStorage.default.maxWeight
            })
            return
        elseif inventory:find('glovebox-') then
            OpenInventory(source, inventory, {
                slots = VehicleStorage[class] and VehicleStorage[class].gloveboxSlots or VehicleStorage.default.slots,
                maxweight = VehicleStorage[class] and VehicleStorage[class].gloveboxWeight or VehicleStorage.default.maxWeight
            })
            return
        end
    end)
end, false)
