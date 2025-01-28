local WKXCore = exports['wickx-core']:GetCoreObject()

RegisterNetEvent('KickForAFK', function()
	DropPlayer(source, Lang:t("afk.kick_message"))
end)

WKXCore.Functions.CreateCallback('wickx-afkkick:server:GetPermissions', function(source, cb)
    cb(WKXCore.Functions.GetPermission(source))
end)
