--  Yoinked
local isServer = IsDuplicityVersion()
if not isServer then
    lib.print.error('cannot use the logger on the client')
    return
end

local logQueue, isProcessingQueue, logCount = {}, false, 0
local lastRequestTime, requestDelay = 0, 0

local colors = { -- https://www.spycolor.com/
    default = 448160,
    error = 16723038,
}

local function applyRequestDelay()
    local currentTime = GetGameTimer()
    local timeDiff = currentTime - lastRequestTime

    if timeDiff < requestDelay then
        local remainingDelay = requestDelay - timeDiff
        Wait(remainingDelay)
    end

    lastRequestTime = GetGameTimer()
end

local allowedErr = {
    [200] = true,
    [201] = true,
    [204] = true,
    [304] = true
}

local function logPayload(payload)
    local tags = nil
    local userName = 'Item Trader Logs'
    if payload.tags then
        for i = 1, #payload.tags do
            if not tags then tags = '' end
            tags = tags .. payload.tags[i]
        end
    end

    local jsonPayload = json.encode({
        content = tags or "",
        username = userName,
        embeds = { payload.embed },
    })

    PerformHttpRequest(payload.webhook, function(err, _, headers)
        if err and not allowedErr[err] then
            lib.print.error("can't send log to Discord", err)
            return
        end

        local remainingRequests = tonumber(headers['X-RateLimit-Remaining'])
        local resetTime = tonumber(headers['X-RateLimit-Reset'])

        if remainingRequests and resetTime and remainingRequests == 0 then
            local currentTime = os.time()
            local resetDelay = resetTime - currentTime

            if resetDelay > 0 then
                requestDelay = resetDelay * 1000 / 10
            end
        end
    end, 'POST', jsonPayload, { ['Content-Type'] = 'application/json' })
end

local function processLogQueue()
    if #logQueue > 0 then
        local payload = table.remove(logQueue, 1)

        logPayload(payload)

        logCount = logCount + 1

        if logCount % 5 == 0 then
            Wait(60000)
        else
            applyRequestDelay()
        end

        processLogQueue()
    else
        isProcessingQueue = false
    end
end

function handleLog(data)
    if svConfig.webhook == '' then
        lib.print.error('webhook not set')
        return
    end

    local embed = {
        title = 'Item Trader',
        fields = {
            { name = 'Trader', value = data.trader, inline = true },
            { name = 'Seller', value = GetPlayerName(source), inline = true },
            { name = 'Citizen ID', value = data.citizenId, inline = true },
            { name = 'Distance from Trader', value = tostring(data.distance), inline = false },
            { name = 'Item', value = data.item, inline = false },

            { name = 'Price', value = tostring(data.price), inline = true },
            { name = 'Amount', value = tostring(data.amount), inline = true },
        },
        color = colors.default,
    }

    logQueue[#logQueue + 1] = {
        webhook = svConfig.webhook,
        embed = embed
    }

    if not isProcessingQueue then
        isProcessingQueue = true
        CreateThread(processLogQueue)
    end
end