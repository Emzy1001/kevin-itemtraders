if GetResourceState('qb-core') ~= 'started' or GetResourceState('qbx_core') == 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function showNotify(data)
    QBCore.Functions.Notify(data.description, data.type)
end

function progressBar(data)
    QBCore.Functions.Progressbar(data.label, data.label, data.duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = data.anim.dict,
        anim = data.anim.clip,
    }, {}, {}, function() -- Done
        data.onSuccess()
    end, function() -- Cancel
        data.onCancel()
    end)
end