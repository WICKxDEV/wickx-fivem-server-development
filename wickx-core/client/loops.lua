CreateThread(function()
    while true do
        local sleep = 0
        if LocalPlayer.state.isLoggedIn then
            sleep = (1000 * 60) * WKXCore.Config.UpdateInterval
            TriggerServerEvent('WKXCore:UpdatePlayer')
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if (WKXCore.PlayerData.metadata['hunger'] <= 0 or WKXCore.PlayerData.metadata['thirst'] <= 0) and not (WKXCore.PlayerData.metadata['isdead'] or WKXCore.PlayerData.metadata['inlaststand']) then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                local decreaseThreshold = math.random(5, 10)
                SetEntityHealth(ped, currentHealth - decreaseThreshold)
            end
        end
        Wait(WKXCore.Config.StatusInterval)
    end
end)
