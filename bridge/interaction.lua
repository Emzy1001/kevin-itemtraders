
local function addTargetOptions(options)
    local targetOptions = {}
    if clConfig.target.resource == 'ox' then
        for i = 1, #options do
            targetOptions[i] = {
                label = options[i].label,
                icon = options[i].icon,
                onSelect = function ()
                    options[i].onSelect()
                end,
                canInteract = options[i].canInteract,
                distance = clConfig.target.distance,
            }
        end
    elseif clConfig.target.resource == 'qb' then
        for i = 1, #options do
            targetOptions[i] = {
                icon = options[i].icon,
                label = options[i].label,
                action = function(entity)
                    options[i].onSelect()
                end,
                canInteract = options[i].canInteract,
            }
        end
    elseif clConfig.target.resource == 'interact' then
        for i = 1, #options do
            targetOptions[i] = {
                label = options[i].label,
                action = function(entity, coords, args)
                    options[i].onSelect()
                end,
                canInteract = options[i].canInteract,
            }
        end
    end
    return targetOptions
end

function addTargetToEntity(options) -- feel free to implement your own target system here
    -- options = options.entity, options.label, optins.distance, options.icon, options.onSelect, options.canInteract (if you want to add your own target/interaction)
    if clConfig.target.resource == 'ox' then
        exports.ox_target:addLocalEntity(options.entity, addTargetOptions(options.options))
    elseif clConfig.target.resource == 'qb' then
        exports['qb-target']:AddTargetEntity(options.entity, {
            options = addTargetOptions(options.options),
            distance = clConfig.target.distance,
        })
    elseif clConfig.target.resource == 'interact' then
        exports.interact:AddLocalEntityInteraction({
            entity = options.entity,
            label = options.label,
            ignoreLos = false,
            offset = vec3(0.0, 0.0, 0.5),
            distance = 8.0,
            interactDst = 3.5,
            options = addTargetOptions(options.options),
        })
    end
end