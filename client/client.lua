clConfig = require 'configs.client'
local svConfig = require 'configs.server'
local zones = {}

local function isNightTime()
    local time = GetClockHours()
    return time >= svConfig.nightTime.start and time <= svConfig.nightTime.ends
end

local function getAvailableItems(items)
    local cacheItems = {}

    for itemName, price in pairs(items) do
        local itemInfo = getItemInfo(itemName)
        if not itemInfo then return end

        cacheItems[#cacheItems+1] = {
            name = itemName,
            label = itemInfo.label,
            amount = itemInfo.amount,
            price = price,
        }
    end

    return cacheItems
end
-- missheistdockssetup1leadinoutig_1 : lsdh_ig_1_argue_wade
local function attemptTradingItems(id, loc, item)
    if not DoesEntityExist(zones[id].ped) and not item then return end

    if loc.reputation.use then
        local playerReputation = lib.callback.await('kevin-itemtrader:server:getPlayerReputation', false, loc.reputation.name)
        if playerReputation < loc.reputation.threshold then
            showNotify({
                title = 'Item Trader',
                description = 'You do not have the reputation to trade with this trader',
                type = 'error',
            })
            return
        end
    end

    TaskTurnPedToFaceEntity(cache.ped, zones[id].ped, 1000)
    Wait(1000)
    progressBar({
        label = 'Trading Items..',
        duration = math.random(5000, 10000),
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
        anim = {
            dict = 'missheistdockssetup1leadinoutig_1',
            clip = 'lsdh_ig_1_argue_wade',
        },
        onSuccess = function ()
            local traded, response = lib.callback.await('kevin-itemtrader:server:tradeItems', false, loc, item)
            if not traded then
                showNotify({
                    title = 'Item Trader',
                    description = response,
                    type = 'error',
                })
                return
            end
            showNotify({
                title = 'Item Trader',
                description = 'You have successfully traded ' .. item.label,
                type = 'success',
            })
        end,
        onCancel = function ()
            showNotify({
                title = 'Item Trader',
                description = 'You have canceled the trade',
                type = 'error',
            })
        end,
    })
end

local function getMenuOptions(id, loc)
    local cacheOptions = {}
    local playerReputation = lib.callback.await('kevin-itemtrader:server:getPlayerReputation', false, loc.reputation.name)
    local availableItems = getAvailableItems(loc.items)
    if not availableItems then return end
    cacheOptions[#cacheOptions+1] = {
        readOnly = true,
        iconColor = '#ff0000',
        icon = 'fa-solid fa-chart-simple',
        title = 'Reptation: ' .. playerReputation,
        description = 'You need ' .. loc.reputation.threshold .. ' reputation to trade',
    }

    for k, v in pairs(availableItems) do
        if v.amount == 0 then
            cacheOptions[#cacheOptions+1] = {
                iconColor = '#ff0000',
                icon = 'fa-solid fa-tag',
                iconAnimation = 'beat',
                title = v.label,
                description = 'You have none available',
                readOnly = true,
            }
        else
            cacheOptions[#cacheOptions+1] = {
                iconColor = '#00ff00',
                icon = 'fa-solid fa-tag',
                iconAnimation = 'beat',
                title = v.label,
                description = 'Price: $' .. v.price,
                onSelect = function ()
                    attemptTradingItems(id, loc, v)
                end,
            }
        end
    end

    return cacheOptions
end

local function openTraderMenu(id, loc)
    if not DoesEntityExist(zones[id].ped) then return end
    local menuOptions = getMenuOptions(id, loc)
    if not menuOptions then return end
    lib.registerContext({
        id = 'item_trader_menu',
        title = 'What I\'m Buying',
        options = menuOptions,
    })
    lib.showContext('item_trader_menu')
end

local function createLocationPed(id, loc)
    if zones[id].ped then return end
    if loc.nightOnly and not isNightTime() then return end
    local model = loc.ped.model
    local coords = loc.ped.coords

    lib.requestModel(model, 1000)
    zones[id].ped = CreatePed(4, model, coords.x, coords.y, coords.z -1, coords.w, false, false)
    SetEntityAsMissionEntity(zones[id].ped, true, true)
    SetBlockingOfNonTemporaryEvents(zones[id].ped, true)
    SetEntityInvincible(zones[id].ped, true)
    FreezeEntityPosition(zones[id].ped, true)

    addTargetToEntity({
        entity = zones[id].ped,
        options = {
            {
                icon = loc.ped.target.icon,
                label = loc.ped.target.label,
                onSelect = function ()
                    openTraderMenu(id, loc)
                end,
            },
        }
    })
end

CreateThread(function ()
    for id, loc in pairs(svConfig.locations) do
        zones[id] = lib.zones.sphere({
            coords = loc.ped.coords,
            radius = 30.0,
            debug = false,
            onEnter = function ()
                createLocationPed(id, loc)
            end,
            onExit = function ()
                if zones[id].ped then
                    DeleteEntity(zones[id].ped)
                    zones[id].ped = nil
                end
            end
        })

        if loc.blip.use then
            zones[id].blip = AddBlipForCoord(loc.ped.coords.x, loc.ped.coords.y, loc.ped.coords.z)
            SetBlipSprite(zones[id].blip, loc.blip.sprite)
            SetBlipScale(zones[id].blip, loc.blip.scale)
            SetBlipColour(zones[id].blip, loc.blip.color)
            SetBlipAsShortRange(zones[id].blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(loc.blip.label)
            EndTextCommandSetBlipName(zones[id].blip)
        end
    end
end)

AddEventHandler('onResourceStop', function (resource)
    if resource == GetCurrentResourceName() then
        for id, zone in pairs(zones) do
            if zone.ped then
                DeleteEntity(zone.ped)
            end
        end
    end
end)