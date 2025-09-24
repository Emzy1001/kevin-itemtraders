if GetResourceState('qb-inventory') ~= 'started' then return end

local qbInventory = exports['qb-inventory']

function removeItem(source, item, amount, metadata)
    return qbInventory:RemoveItem(source, item, amount, metadata)
end

function addItem(source, item, amount, metadata)
    return qbInventory:AddItem(source, item, amount, metadata)
end

function getItemCount(source, item)
    return qbInventory:GetItemCount(source, item)
end

lib.callback.register('kevin-itemtraders:server:getItemCount', function(source, item)
    return getItemCount(source, item)
end)