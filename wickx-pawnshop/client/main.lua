local WKXCore = exports['wickx-core']:GetCoreObject()

local isMelting = false
local canTake = false
local meltTime
local meltedItem = {}

CreateThread(function()
    for _, value in pairs(Config.PawnLocation) do
        local blip = AddBlipForCoord(value.coords.x, value.coords.y, value.coords.z)
        SetBlipSprite(blip, 431)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 5)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Lang:t('info.title'))
        EndTextCommandSetBlipName(blip)
    end
end)

CreateThread(function()
    if Config.UseTarget then
        for key, value in pairs(Config.PawnLocation) do
            exports['wickx-target']:AddBoxZone('PawnShop'..key, value.coords, value.length, value.width, {
                name = 'PawnShop'..key,
                heading = value.heading,
                minZ = value.minZ,
                maxZ = value.maxZ,
                debugPoly = value.debugPoly,
            }, {
                options = {
                    {
                        type = 'client',
                        event = 'wickx-pawnshop:client:openMenu',
                        icon = 'fas fa-ring',
                        label = 'Pawn Shop',
                    },
                },
                distance = value.distance
            })
        end
    else
        local zone = {}
        for key, value in pairs(Config.PawnLocation) do
            zone[#zone+1] = BoxZone:Create(value.coords, value.length, value.width, {
                name = 'PawnShop'..key,
                heading = value.heading,
                minZ = value.minZ,
                maxZ = value.maxZ,
            })
        end
        local pawnShopCombo = ComboZone:Create( zone, { name = 'NewPawnShopCombo', debugPoly = false })
        pawnShopCombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                exports['wickx-menu']:showHeader({
                    {
                        header = Lang:t('info.title'),
                        txt = Lang:t('info.open_pawn'),
                        params = {
                            event = 'wickx-pawnshop:client:openMenu'
                        }
                    }
                })
            else
                exports['wickx-menu']:closeMenu()
            end
        end)
    end
end)

RegisterNetEvent('wickx-pawnshop:client:openMenu', function()
    if Config.UseTimes then
        if GetClockHours() >= Config.TimeOpen and GetClockHours() <= Config.TimeClosed then
            local pawnShop = {
                {
                    header = Lang:t('info.title'),
                    isMenuHeader = true,
                },
                {
                    header = Lang:t('info.sell'),
                    txt = Lang:t('info.sell_pawn'),
                    params = {
                        event = 'wickx-pawnshop:client:openPawn',
                        args = {
                            items = Config.PawnItems
                        }
                    }
                }
            }
            if not isMelting then
                pawnShop[#pawnShop + 1] = {
                    header = Lang:t('info.melt'),
                    txt = Lang:t('info.melt_pawn'),
                    params = {
                        event = 'wickx-pawnshop:client:openMelt',
                        args = {
                            items = Config.MeltingItems
                        }
                    }
                }
            end
            if canTake then
                pawnShop[#pawnShop + 1] = {
                    header = Lang:t('info.melt_pickup'),
                    txt = '',
                    params = {
                        isServer = true,
                        event = 'wickx-pawnshop:server:pickupMelted',
                        args = {
                            items = meltedItem
                        }
                    }
                }
            end
            exports['wickx-menu']:openMenu(pawnShop)
        else
            WKXCore.Functions.Notify(Lang:t('info.pawn_closed', { value = Config.TimeOpen, value2 = Config.TimeClosed }))
        end
    else
        local pawnShop = {
            {
                header = Lang:t('info.title'),
                isMenuHeader = true,
            },
            {
                header = Lang:t('info.sell'),
                txt = Lang:t('info.sell_pawn'),
                params = {
                    event = 'wickx-pawnshop:client:openPawn',
                    args = {
                        items = Config.PawnItems
                    }
                }
            }
        }
        if not isMelting then
            pawnShop[#pawnShop + 1] = {
                header = Lang:t('info.melt'),
                txt = Lang:t('info.melt_pawn'),
                params = {
                    event = 'wickx-pawnshop:client:openMelt',
                    args = {
                        items = Config.MeltingItems
                    }
                }
            }
        end
        if canTake then
            pawnShop[#pawnShop + 1] = {
                header = Lang:t('info.melt_pickup'),
                txt = '',
                params = {
                    isServer = true,
                    event = 'wickx-pawnshop:server:pickupMelted',
                    args = {
                        items = meltedItem
                    }
                }
            }
        end
        exports['wickx-menu']:openMenu(pawnShop)
    end
end)

RegisterNetEvent('wickx-pawnshop:client:openPawn', function(data)
    WKXCore.Functions.TriggerCallback('wickx-pawnshop:server:getInv', function(inventory)
        local PlyInv = inventory
        local pawnMenu = {
            {
                header = Lang:t('info.title'),
                isMenuHeader = true,
            }
        }
        for _, v in pairs(PlyInv) do
            for i = 1, #data.items do
                if v.name == data.items[i].item then
                    pawnMenu[#pawnMenu + 1] = {
                        header = WKXCore.Shared.Items[v.name].label,
                        txt = Lang:t('info.sell_items', { value = data.items[i].price }),
                        params = {
                            event = 'wickx-pawnshop:client:pawnitems',
                            args = {
                                label = WKXCore.Shared.Items[v.name].label,
                                price = data.items[i].price,
                                name = v.name,
                                amount = v.amount
                            }
                        }
                    }
                end
            end
        end
        pawnMenu[#pawnMenu + 1] = {
            header = Lang:t('info.back'),
            params = {
                event = 'wickx-pawnshop:client:openMenu'
            }
        }
        exports['wickx-menu']:openMenu(pawnMenu)
    end)
end)

RegisterNetEvent('wickx-pawnshop:client:openMelt', function(data)
    WKXCore.Functions.TriggerCallback('wickx-pawnshop:server:getInv', function(inventory)
        local PlyInv = inventory
        local meltMenu = {
            {
                header = Lang:t('info.melt'),
                isMenuHeader = true,
            }
        }
        for _, v in pairs(PlyInv) do
            for i = 1, #data.items do
                if v.name == data.items[i].item then
                    meltMenu[#meltMenu + 1] = {
                        header = WKXCore.Shared.Items[v.name].label,
                        txt = Lang:t('info.melt_item', { value = WKXCore.Shared.Items[v.name].label }),
                        params = {
                            event = 'wickx-pawnshop:client:meltItems',
                            args = {
                                label = WKXCore.Shared.Items[v.name].label,
                                reward = data.items[i].rewards,
                                name = v.name,
                                amount = v.amount,
                                time = data.items[i].meltTime
                            }
                        }
                    }
                end
            end
        end
        meltMenu[#meltMenu + 1] = {
            header = Lang:t('info.back'),
            params = {
                event = 'wickx-pawnshop:client:openMenu'
            }
        }
        exports['wickx-menu']:openMenu(meltMenu)
    end)
end)

RegisterNetEvent('wickx-pawnshop:client:pawnitems', function(item)
    local sellingItem = exports['wickx-input']:ShowInput({
        header = Lang:t('info.title'),
        submitText = Lang:t('info.sell'),
        inputs = {
            {
                type = 'number',
                isRequired = false,
                name = 'amount',
                text = Lang:t('info.max', { value = item.amount })
            }
        }
    })
    if sellingItem then
        if not sellingItem.amount then
            return
        end

        if tonumber(sellingItem.amount) > 0 then
            if tonumber(sellingItem.amount) <= item.amount then
                TriggerServerEvent('wickx-pawnshop:server:sellPawnItems', item.name, sellingItem.amount, item.price)
            else
                WKXCore.Functions.Notify(Lang:t('error.no_items'), 'error')
            end
        else
            WKXCore.Functions.Notify(Lang:t('error.negative'), 'error')
        end
    end
end)


RegisterNetEvent('wickx-pawnshop:client:meltItems', function(item)
    local meltingItem = exports['wickx-input']:ShowInput({
        header = Lang:t('info.melt'),
        submitText = Lang:t('info.submit'),
        inputs = {
            {
                type = 'number',
                isRequired = false,
                name = 'amount',
                text = Lang:t('info.max', { value = item.amount })
            }
        }
    })
    if meltingItem then
        if not meltingItem.amount then
            return
        end
        if meltingItem.amount ~= nil then
            if tonumber(meltingItem.amount) > 0 then
                TriggerServerEvent('wickx-pawnshop:server:meltItemRemove', item.name, meltingItem.amount, item)

            else
                WKXCore.Functions.Notify(Lang:t('error.no_melt'), 'error')
            end
        else
            WKXCore.Functions.Notify(Lang:t('error.no_melt'), 'error')
        end
    end
end)

RegisterNetEvent('wickx-pawnshop:client:startMelting', function(item, meltingAmount, meltTimees)
    if not isMelting then
        isMelting = true
        meltTime = meltTimees
        meltedItem = {}
        CreateThread(function()
            while isMelting do
                if LocalPlayer.state.isLoggedIn then
                    meltTime = meltTime - 1
                    if meltTime <= 0 then
                        canTake = true
                        isMelting = false
                        meltedItem[#meltedItem+1] = { item = item, amount = meltingAmount }
                        if Config.SendMeltingEmail then
                            TriggerServerEvent('wickx-phone:server:sendNewMail', {
                                sender = Lang:t('info.title'),
                                subject = Lang:t('info.subject'),
                                message = Lang:t('info.message'),
                                button = {}
                            })
                        else
                            WKXCore.Functions.Notify(Lang:t('info.message'), 'success')
                        end
                    end
                else
                    break
                end
                Wait(1000)
            end
        end)
    end
end)

RegisterNetEvent('wickx-pawnshop:client:resetPickup', function()
    canTake = false
end)
