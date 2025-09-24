if GetResourceState('ox_inventory') ~= 'started' then return end

local ox_inventory = exports.ox_inventory
local invItems = ox_inventory:Items()

function removeItem(source, item, amount, metadata)
    return ox_inventory:RemoveItem(source, item, amount, metadata)
end

function addItem(source, item, amount, metadata)
    return ox_inventory:AddItem(source, item, amount, metadata)
end

function getItemCount(source, item)
    local count = ox_inventory:GetItem(source, item, nil, true)
    if count then
        return count
    end

    return 0
end