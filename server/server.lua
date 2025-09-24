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

local function tradeItems(source, location, tradeOption, quantity)
    if not location then
        return false, 'Location not found'
    end

    if not tradeOption or not quantity then
        return false, 'Invalid trade parameters'
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
    local itemCount = getItemCount(source, tradeOption.requiredItem)
    if itemCount < quantity then
        return false, 'You do not have enough ' .. tradeOption.requiredItem
    end

    -- Remove the required items
    local removed = removeItem(source, tradeOption.requiredItem, quantity)
    if not removed then
        return false, 'Failed to remove ' .. tradeOption.requiredItem
    end

    local rewardText = ''
    
    -- Handle reward based on type
    if tradeOption.reward.type == 'cash' then
        local totalPrice = tradeOption.reward.amount * quantity
        addMoney(player, 'cash', totalPrice, 'Sold ' .. tradeOption.requiredItem)
        rewardText = 'You sold x' .. quantity .. ' ' .. tradeOption.requiredItem .. ' for $' .. totalPrice
    elseif tradeOption.reward.type == 'item' then
        local rewardAmount = tradeOption.reward.amount * quantity
        local added = addItem(source, tradeOption.reward.item, rewardAmount)
        if not added then
            -- Rollback: give back the removed items
            addItem(source, tradeOption.requiredItem, quantity)
            return false, 'Failed to give reward item'
        end
        rewardText = 'You exchanged x' .. quantity .. ' ' .. tradeOption.requiredItem .. ' for x' .. rewardAmount .. ' ' .. tradeOption.reward.item
    else
        -- Rollback: give back the removed items
        addItem(source, tradeOption.requiredItem, quantity)
        return false, 'Invalid reward type'
    end

    if location.reputation.use then
        local currentReputation = getPlayerReputation(player, location.reputation.name)
        local reputationPayment = currentReputation + location.reputation.reputationPayment
        setPlayerReputation(player, location.reputation.name, reputationPayment)
    end

    local citizenId = getPlayerCitizenId(player)
    local logData = {
        trader = location.type,
        citizenId = citizenId,
        tradeOption = tradeOption.id,
        requiredItem = tradeOption.requiredItem,
        quantity = quantity,
        rewardType = tradeOption.reward.type,
        distance = distance,
    }
    handleLog(logData)
    return true, rewardText
end

lib.callback.register('kevin-itemtrader:server:getPlayerReputation', function(source, reputation)
    local player = getPlayer(source)
    return getPlayerReputation(player, reputation)
end)

lib.callback.register('kevin-itemtrader:server:tradeItems', function(source, location, tradeOption, quantity)
    return tradeItems(source, location, tradeOption, quantity)
end)