if GetResourceState('qb-inventory') ~= 'started' then return end
local QBCore = exports['qb-core']:GetCoreObject()

function getItemInfo(item)
    local cacheItem = QBCore.Shared.Items[item]
    if not cacheItem then
        lib.print.error(item .. ' not found')
        return
    end

    local count = lib.callback.await('kevin-itemtraders:server:getItemCount', false, item)
    return {
        name = cacheItem.label,
        label = cacheItem.label,
        amount = count,
    }
end