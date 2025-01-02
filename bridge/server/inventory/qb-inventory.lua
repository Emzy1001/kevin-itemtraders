if GetResourceState('qb-inventory') ~= 'started' then return end

local qbInventory = exports['qb-inventory']

function removeItem(source, item, amount, metadata)
    return qbInventory:RemoveItem(source, item, amount, metadata)
end