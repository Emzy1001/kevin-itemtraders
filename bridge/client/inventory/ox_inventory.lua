if GetResourceState('ox_inventory') ~= 'started' then return end

local ox_inventory = exports.ox_inventory
ox_inventory:Items()

function getItemInfo(item)
    local cacheItem = ox_inventory:Items(item)
    if not cacheItem then
        lib.print.error(item .. ' not found')
        return
    end

    return {
        name = cacheItem.name,
        label = cacheItem.label,
        amount = cacheItem.count,
    }
end
