svConfig = require 'configs.server'

local function isNearLocation(source, location)
    local player = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(player)
    local distance = #(playerCoords - vector3(location.x, location.y, location.z))
    if distance > 5.0 then
        return false
    end
    return true
end

local function getPlayerDistance(source, location)
    local player = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(player)
    local distance = #(playerCoords - vector3(location.x, location.y, location.z))
    return math.round(distance, 2) .. 'm'
end

local function hasReputationToTrade(player, reputation)
    local playerReputation = getPlayerReputation(player, reputation.name)
    if playerReputation < reputation.threshold then
        return false
    end
    return true
end

local function tradeItems(source, location, item)
    if not location then
        return false, 'Location not found'
    end

    local isNear = isNearLocation(source, location.ped.coords)
    if not isNear then
        return false, 'You are not near the trader'
    end

    local player = getPlayer(source)
    if not player then
        return false, 'Player not found'
    end

    if location.reputation.use then
        local hasReputation = hasReputationToTrade(player, location.reputation)
        if not hasReputation then
            return false, 'You do not have the reputation to trade with this trader'
        end
    end

    local distance = getPlayerDistance(source, location.ped.coords)
    local itemCount = getItemCount(source, item.name)
    if itemCount <= 0 then
        return false, 'You do not have any ' .. item.label
    end

    local removed = removeItem(source, item.name, itemCount)
    if not removed then
        return false, 'Failed to remove ' .. item.label
    end

    local price = item.price * itemCount
    addMoney(player, 'cash', price, 'Sold ' .. item.label)

    if location.reputation.use then
        local currentReputation = getPlayerReputation(player, location.reputation.name)
        local reputationPayment = currentReputation + location.reputation.reputationPayment
        setPlayerReputation(player, location.reputation.name, reputationPayment)
    end

    local citizenId = getPlayerCitizenId(player)
    local logData = {
        trader = location.type,
        citizenId = citizenId,
        item = item.label,
        price = price,
        distance = distance,
        amount = itemCount,
    }
    handleLog(logData)
    return true, 'You sold x' .. itemCount .. ' ' .. item.label .. ' for $' .. price
end

lib.callback.register('kevin-itemtrader:server:getPlayerReputation', function(source, reputation)
    local player = getPlayer(source)
    return getPlayerReputation(player, reputation)
end)

lib.callback.register('kevin-itemtrader:server:tradeItems', function(source, location, item)
    return tradeItems(source, location, item)
end)