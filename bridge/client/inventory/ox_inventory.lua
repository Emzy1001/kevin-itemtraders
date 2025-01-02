if GetResourceState('ox_inventory') ~= 'started' then return end

local ox_inventory = exports.ox_inventory
ox_inventory:Items()

function getItemInfo(item)
    local cacheInfo = {}
    local cacheItem = ox_inventory:Items(item)
    if not cacheItem then
        print(item .. ' not found')
        return
    end
    
    cacheInfo = {
        name = cacheItem.name,
        label = cacheItem.label,
        amount = cacheItem.count,
    }

    return cacheInfo
end
