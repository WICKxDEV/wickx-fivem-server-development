local WKXCore = exports['wickx-core']:GetCoreObject()
local hasDonePreloading = {}

-- Functions

local function GiveStarterItems(source)
    local src = source
    local Player = WKXCore.Functions.GetPlayer(src)
    for _, v in pairs(WKXCore.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        exports['wickx-inventory']:AddItem(src, v.item, v.amount, false, info, 'wickx-multicharacter:GiveStarterItems')
    end
end

local function loadHouseData(src)
    local HouseGarages = {}
    local Houses = {}
    local result = MySQL.query.await('SELECT * FROM houselocations', {})
    if result[1] ~= nil then
        for _, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    TriggerClientEvent("wickx-garages:client:houseGarageConfig", src, HouseGarages)
    TriggerClientEvent("wickx-houses:client:setHouseConfig", src, Houses)
end

-- Commands

WKXCore.Commands.Add("logout", Lang:t("commands.logout_description"), {}, false, function(source)
    local src = source
    WKXCore.Player.Logout(src)
    TriggerClientEvent('wickx-multicharacter:client:chooseChar', src)
end, "admin")

WKXCore.Commands.Add("closeNUI", Lang:t("commands.closeNUI_description"), {}, false, function(source)
    local src = source
    TriggerClientEvent('wickx-multicharacter:client:closeNUI', src)
end)

-- Events

AddEventHandler('WKXCore:Server:PlayerLoaded', function(Player)
    Wait(1000) -- 1 second should be enough to do the preloading in other resources
    hasDonePreloading[Player.PlayerData.source] = true
end)

AddEventHandler('WKXCore:Server:OnPlayerUnload', function(src)
    hasDonePreloading[src] = false
end)

RegisterNetEvent('wickx-multicharacter:server:disconnect', function()
    local src = source
    DropPlayer(src, Lang:t("commands.droppedplayer"))
end)

RegisterNetEvent('wickx-multicharacter:server:loadUserData', function(cData)
    local src = source
    if WKXCore.Player.Login(src, cData.citizenid) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        print('^2[wickx-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has successfully loaded!')
        WKXCore.Commands.Refresh(src)
        loadHouseData(src)
        if Config.SkipSelection then
            local coords = json.decode(cData.position)
            TriggerClientEvent('wickx-multicharacter:client:spawnLastLocation', src, coords, cData)
        else
            if GetResourceState('wickx-apartments') == 'started' then
                TriggerClientEvent('apartments:client:setupSpawnUI', src, cData)
            else
                TriggerClientEvent('wickx-spawn:client:setupSpawns', src, cData, false, nil)
                TriggerClientEvent('wickx-spawn:client:openUI', src, true)
            end
        end
        TriggerEvent("wickx-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** (<@"..(WKXCore.Functions.GetIdentifier(src, 'discord'):gsub("discord:", "") or "unknown").."> |  ||"  ..(WKXCore.Functions.GetIdentifier(src, 'ip') or 'undefined') ..  "|| | " ..(WKXCore.Functions.GetIdentifier(src, 'license') or 'undefined') .." | " ..cData.citizenid.." | "..src..") loaded..")
    end
end)

RegisterNetEvent('wickx-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    if WKXCore.Player.Login(src, false, newData) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        if GetResourceState('wickx-apartments') == 'started' and Apartments.Starting then
            local randbucket = (GetPlayerPed(src) .. math.random(1,999))
            SetPlayerRoutingBucket(src, randbucket)
            print('^2[wickx-core]^7 '..GetPlayerName(src)..' has successfully loaded!')
            WKXCore.Commands.Refresh(src)
            loadHouseData(src)
            TriggerClientEvent("wickx-multicharacter:client:closeNUI", src)
            TriggerClientEvent('apartments:client:setupSpawnUI', src, newData)
            GiveStarterItems(src)
        else
            print('^2[wickx-core]^7 '..GetPlayerName(src)..' has successfully loaded!')
            WKXCore.Commands.Refresh(src)
            loadHouseData(src)
            TriggerClientEvent("wickx-multicharacter:client:closeNUIdefault", src)
            GiveStarterItems(src)
            TriggerEvent('apartments:client:SetHomeBlip', nil)
        end
    end
end)

RegisterNetEvent('wickx-multicharacter:server:deleteCharacter', function(citizenid)
    local src = source
    if not Config.EnableDeleteButton then return end
    WKXCore.Player.DeleteCharacter(src, citizenid)
    TriggerClientEvent('WKXCore:Notify', src, Lang:t("notifications.char_deleted") , "success")
end)

-- Callbacks

WKXCore.Functions.CreateCallback("wickx-multicharacter:server:GetUserCharacters", function(source, cb)
    local src = source
    local license = WKXCore.Functions.GetIdentifier(src, 'license')

    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        cb(result)
    end)
end)

WKXCore.Functions.CreateCallback("wickx-multicharacter:server:GetServerLogs", function(_, cb)
    MySQL.query('SELECT * FROM server_logs', {}, function(result)
        cb(result)
    end)
end)

WKXCore.Functions.CreateCallback("wickx-multicharacter:server:GetNumberOfCharacters", function(source, cb)
    local src = source
    local license = WKXCore.Functions.GetIdentifier(src, 'license')
    local numOfChars = 0

    if next(Config.PlayersNumberOfCharacters) then
        for _, v in pairs(Config.PlayersNumberOfCharacters) do
            if v.license == license then
                numOfChars = v.numberOfChars
                break
            else
                numOfChars = Config.DefaultNumberOfCharacters
            end
        end
    else
        numOfChars = Config.DefaultNumberOfCharacters
    end
    cb(numOfChars)
end)

WKXCore.Functions.CreateCallback("wickx-multicharacter:server:setupCharacters", function(source, cb)
    local license = WKXCore.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            plyChars[#plyChars+1] = result[i]
        end
        cb(plyChars)
    end)
end)

WKXCore.Functions.CreateCallback("wickx-multicharacter:server:getSkin", function(_, cb, cid)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1})
    if result[1] ~= nil then
        cb(result[1].model, result[1].skin)
    else
        cb(nil)
    end
end)

WKXCore.Commands.Add("deletechar", Lang:t("commands.deletechar_description"), {{name = Lang:t("commands.citizenid"), help = Lang:t("commands.citizenid_help")}}, false, function(source,args)
    if args and args[1] then
        WKXCore.Player.ForceDeleteCharacter(tostring(args[1]))
        TriggerClientEvent("WKXCore:Notify", source, Lang:t("notifications.deleted_other_char", {citizenid = tostring(args[1])}))
    else
        TriggerClientEvent("WKXCore:Notify", source, Lang:t("notifications.forgot_citizenid"), "error")
    end
end, "god")
