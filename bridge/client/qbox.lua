if GetResourceState('qbx_core') ~= 'started' then return end

function showNotify(data)
    lib.notify({
        title = data.title,
        description = data.description,
        type = data.type,
    })
end

function progressBar(data)
    if lib.progressCircle({
        duration = data.duration,
        position = 'bottom',
        label = data.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = data.disable.move,
            car = data.disable.car,
            combat = data.disable.combat,
            mouse = data.disable.mouse,
        },
        anim = {
            dict = data.anim.dict,
            clip = data.anim.clip,
        },
    })
    then
        data.onSuccess()
    else
        data.onCancel()
    end
end