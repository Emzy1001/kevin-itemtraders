if GetResourceState('qb-core') ~= 'started' or GetResourceState('qbx_core') == 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function getPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function getPlayerCitizenId(player)
    return player.PlayerData.citizenid
end

function getPlayerReputation(player, reputation)
    return player.PlayerData.metadata[reputation] or 0
end

function setPlayerReputation(player, reputation, amount)
    player.Functions.SetMetaData(reputation, amount)
end

function addMoney(player, type, amount, reason)
    player.Functions.AddMoney(type, amount, reason)
end