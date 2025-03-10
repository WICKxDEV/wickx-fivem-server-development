local WKXCore = exports['wickx-core']:GetCoreObject()
local PlayerJob = WKXCore.Functions.GetPlayerData().job
local shownBossMenu = false
local DynamicMenuItems = {}

-- UTIL
local function CloseMenuFull()
    exports['wickx-menu']:closeMenu()
    exports['wickx-core']:HideText()
    shownBossMenu = false
end

local function AddBossMenuItem(data, id)
    local menuID = id or (#DynamicMenuItems + 1)
    DynamicMenuItems[menuID] = deepcopy(data)
    return menuID
end

exports('AddBossMenuItem', AddBossMenuItem)

local function RemoveBossMenuItem(id)
    DynamicMenuItems[id] = nil
end

exports('RemoveBossMenuItem', RemoveBossMenuItem)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = WKXCore.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('WKXCore:Client:OnPlayerLoaded', function()
    PlayerJob = WKXCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('WKXCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('wickx-bossmenu:client:OpenMenu', function()
    if not PlayerJob.name or not PlayerJob.isboss then return end

    local bossMenu = {
        {
            header = Lang:t('headers.bsm') .. string.upper(PlayerJob.label),
            icon = 'fa-solid fa-circle-info',
            isMenuHeader = true,
        },
        {
            header = Lang:t('body.manage'),
            txt = Lang:t('body.managed'),
            icon = 'fa-solid fa-list',
            params = {
                event = 'wickx-bossmenu:client:employeelist',
            }
        },
        {
            header = Lang:t('body.hire'),
            txt = Lang:t('body.hired'),
            icon = 'fa-solid fa-hand-holding',
            params = {
                event = 'wickx-bossmenu:client:HireMenu',
            }
        },
        {
            header = Lang:t('body.storage'),
            txt = Lang:t('body.storaged'),
            icon = 'fa-solid fa-box-open',
            params = {
                isServer = true,
                event = 'wickx-bossmenu:server:stash',
            }
        },
        {
            header = Lang:t('body.outfits'),
            txt = Lang:t('body.outfitsd'),
            icon = 'fa-solid fa-shirt',
            params = {
                event = 'wickx-bossmenu:client:Wardrobe',
            }
        }
    }

    for _, v in pairs(DynamicMenuItems) do
        bossMenu[#bossMenu + 1] = v
    end

    bossMenu[#bossMenu + 1] = {
        header = Lang:t('body.exit'),
        icon = 'fa-solid fa-angle-left',
        params = {
            event = 'wickx-menu:closeMenu',
        }
    }

    exports['wickx-menu']:openMenu(bossMenu)
end)

RegisterNetEvent('wickx-bossmenu:client:employeelist', function()
    local EmployeesMenu = {
        {
            header = Lang:t('body.mempl') .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info',
        },
    }
    WKXCore.Functions.TriggerCallback('wickx-bossmenu:server:GetEmployees', function(cb)
        for _, v in pairs(cb) do
            EmployeesMenu[#EmployeesMenu + 1] = {
                header = v.name,
                txt = v.grade.name,
                icon = 'fa-solid fa-circle-user',
                params = {
                    event = 'wickx-bossmenu:client:ManageEmployee',
                    args = {
                        player = v,
                        work = PlayerJob
                    }
                }
            }
        end
        EmployeesMenu[#EmployeesMenu + 1] = {
            header = Lang:t('body.return'),
            icon = 'fa-solid fa-angle-left',
            params = {
                event = 'wickx-bossmenu:client:OpenMenu',
            }
        }
        exports['wickx-menu']:openMenu(EmployeesMenu)
    end, PlayerJob.name)
end)

RegisterNetEvent('wickx-bossmenu:client:ManageEmployee', function(data)
    local EmployeeMenu = {
        {
            header = Lang:t('body.mngpl') .. data.player.name .. ' - ' .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info'
        },
    }
    for k, v in pairs(WKXCore.Shared.Jobs[data.work.name].grades) do
        EmployeeMenu[#EmployeeMenu + 1] = {
            header = v.name,
            txt = Lang:t('body.grade') .. k,
            params = {
                isServer = true,
                event = 'wickx-bossmenu:server:GradeUpdate',
                icon = 'fa-solid fa-file-pen',
                args = {
                    cid = data.player.empSource,
                    grade = tonumber(k),
                    gradename = v.name
                }
            }
        }
    end
    EmployeeMenu[#EmployeeMenu + 1] = {
        header = Lang:t('body.fireemp'),
        icon = 'fa-solid fa-user-large-slash',
        params = {
            isServer = true,
            event = 'wickx-bossmenu:server:FireEmployee',
            args = data.player.empSource
        }
    }
    EmployeeMenu[#EmployeeMenu + 1] = {
        header = Lang:t('body.return'),
        icon = 'fa-solid fa-angle-left',
        params = {
            event = 'wickx-bossmenu:client:OpenMenu',
        }
    }
    exports['wickx-menu']:openMenu(EmployeeMenu)
end)

RegisterNetEvent('wickx-bossmenu:client:Wardrobe', function()
    TriggerEvent('wickx-clothing:client:openOutfitMenu')
end)

RegisterNetEvent('wickx-bossmenu:client:HireMenu', function()
    local HireMenu = {
        {
            header = Lang:t('body.hireemp') .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info',
        },
    }
    WKXCore.Functions.TriggerCallback('wickx-bossmenu:getplayers', function(players)
        for _, v in pairs(players) do
            if v and v ~= PlayerId() then
                HireMenu[#HireMenu + 1] = {
                    header = v.name,
                    txt = Lang:t('body.cid') .. v.citizenid .. ' - ID: ' .. v.sourceplayer,
                    icon = 'fa-solid fa-user-check',
                    params = {
                        isServer = true,
                        event = 'wickx-bossmenu:server:HireEmployee',
                        args = v.sourceplayer
                    }
                }
            end
        end
        HireMenu[#HireMenu + 1] = {
            header = Lang:t('body.return'),
            icon = 'fa-solid fa-angle-left',
            params = {
                event = 'wickx-bossmenu:client:OpenMenu',
            }
        }
        exports['wickx-menu']:openMenu(HireMenu)
    end)
end)

-- MAIN THREAD
CreateThread(function()
    if Config.UseTarget then
        for job, zones in pairs(Config.BossMenus) do
            for index, coords in ipairs(zones) do
                local zoneName = job .. '_bossmenu_' .. index
                exports['wickx-target']:AddCircleZone(zoneName, coords, 0.5, {
                    name = zoneName,
                    debugPoly = false,
                    useZ = true
                }, {
                    options = {
                        {
                            type = 'client',
                            event = 'wickx-bossmenu:client:OpenMenu',
                            icon = 'fas fa-sign-in-alt',
                            label = Lang:t('target.label'),
                            canInteract = function() return job == PlayerJob.name and PlayerJob.isboss end,
                        },
                    },
                    distance = 2.5
                })
            end
        end
    else
        while true do
            local wait = 2500
            local pos = GetEntityCoords(PlayerPedId())
            local inRangeBoss = false
            local nearBossmenu = false
            if PlayerJob then
                wait = 0
                for k, menus in pairs(Config.BossMenus) do
                    for _, coords in ipairs(menus) do
                        if k == PlayerJob.name and PlayerJob.isboss then
                            if #(pos - coords) < 5.0 then
                                inRangeBoss = true
                                if #(pos - coords) <= 1.5 then
                                    nearBossmenu = true
                                    if not shownBossMenu then
                                        exports['wickx-core']:DrawText(Lang:t('drawtext.label'), 'left')
                                        shownBossMenu = true
                                    end
                                    if IsControlJustReleased(0, 38) then
                                        exports['wickx-core']:HideText()
                                        TriggerEvent('wickx-bossmenu:client:OpenMenu')
                                    end
                                end

                                if not nearBossmenu and shownBossMenu then
                                    CloseMenuFull()
                                    shownBossMenu = false
                                end
                            end
                        end
                    end
                end
                if not inRangeBoss then
                    Wait(1500)
                    if shownBossMenu then
                        CloseMenuFull()
                        shownBossMenu = false
                    end
                end
            end
            Wait(wait)
        end
    end
end)
