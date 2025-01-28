-- Variables
local WKXCore = exports['wickx-core']:GetCoreObject()
local requiredItemsShowed = false
local requiredItems = { [1] = { name = WKXCore.Shared.Items['cryptostick']['name'], image = WKXCore.Shared.Items['cryptostick']['image'] } }

-- Functions

local function DrawText3Ds(coords, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	BeginTextCommandDisplayText('STRING')
	SetTextCentre(true)
	AddTextComponentSubstringPlayerName(text)
	SetDrawOrigin(coords.x, coords.y, coords.z, 0)
	EndTextCommandDisplayText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

local function ExchangeSuccess()
	TriggerServerEvent('wickx-crypto:server:ExchangeSuccess', math.random(1, 10))
end

local function ExchangeFail()
	local Odd = 5
	local RemoveChance = math.random(1, Odd)
	local LosingNumber = math.random(1, Odd)
	if RemoveChance == LosingNumber then
		TriggerServerEvent('wickx-crypto:server:ExchangeFail')
		TriggerServerEvent('wickx-crypto:server:SyncReboot')
	end
end

local function SystemCrashCooldown()
	CreateThread(function()
		while Crypto.Exchange.RebootInfo.state do
			if (Crypto.Exchange.RebootInfo.percentage + 1) <= 100 then
				Crypto.Exchange.RebootInfo.percentage = Crypto.Exchange.RebootInfo.percentage + 1
				TriggerServerEvent('wickx-crypto:server:Rebooting', true, Crypto.Exchange.RebootInfo.percentage)
			else
				Crypto.Exchange.RebootInfo.percentage = 0
				Crypto.Exchange.RebootInfo.state = false
				TriggerServerEvent('wickx-crypto:server:Rebooting', false, 0)
			end
			Wait(1200)
		end
	end)
end

CreateThread(function()
	while true do
		local sleep = 5000
		if LocalPlayer.state.isLoggedIn then
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local dist = #(pos - Crypto.Exchange.coords)
			if dist < 15 then
				sleep = 5
				if dist < 1.5 then
					if not Crypto.Exchange.RebootInfo.state then
						DrawText3Ds(Crypto.Exchange.coords, Lang:t('text.enter_usb'))
						if not requiredItemsShowed then
							requiredItemsShowed = true
							TriggerEvent('wickx-inventory:client:requiredItems', requiredItems, true)
						end

						if IsControlJustPressed(0, 38) then
							WKXCore.Functions.TriggerCallback('wickx-crypto:server:HasSticky', function(HasItem)
								if HasItem then
									local success = exports['wickx-minigames']:Hacking(5, 30) -- code block size & seconds to solve
									if success then
										ExchangeSuccess()
									else
										ExchangeFail()
									end
								else
									WKXCore.Functions.Notify(Lang:t('error.you_dont_have_a_cryptostick'), 'error')
								end
							end)
						end
					else
						DrawText3Ds(Crypto.Exchange.coords, Lang:t('text.system_is_rebooting', { rebootInfoPercentage = Crypto.Exchange.RebootInfo.percentage }))
					end
				else
					if requiredItemsShowed then
						requiredItemsShowed = false
						TriggerEvent('wickx-inventory:client:requiredItems', requiredItems, false)
					end
				end
			end
		end
		Wait(sleep)
	end
end)

-- Events

RegisterNetEvent('wickx-crypto:client:SyncReboot', function()
	Crypto.Exchange.RebootInfo.state = true
	SystemCrashCooldown()
end)

RegisterNetEvent('WKXCore:Client:OnPlayerLoaded', function()
	TriggerServerEvent('wickx-crypto:server:FetchWorth')
	TriggerServerEvent('wickx-crypto:server:GetRebootState')
end)

RegisterNetEvent('wickx-crypto:client:UpdateCryptoWorth', function(crypto, amount, history)
	Crypto.Worth[crypto] = amount
	if history ~= nil then
		Crypto.History[crypto] = history
	end
end)

RegisterNetEvent('wickx-crypto:client:GetRebootState', function(RebootInfo)
	if RebootInfo.state then
		Crypto.Exchange.RebootInfo.state = RebootInfo.state
		Crypto.Exchange.RebootInfo.percentage = RebootInfo.percentage
		SystemCrashCooldown()
	end
end)
