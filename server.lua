local effectStates = {}

-- Permission Check Event
RegisterNetEvent("stage:checkPermission", function()
    local source = source
    local hasPermission = HasPermission(source)
    TriggerClientEvent("stage:permissionResult", source, hasPermission)
end)

-- Original Toggle Event
RegisterNetEvent("stage:toggle", function(catIndex, itemIndex)
    local key = catIndex .. "-" .. itemIndex
    if effectStates[key] == nil then effectStates[key] = false end
    
    effectStates[key] = not effectStates[key]
    
    TriggerClientEvent("stage:sync", -1, catIndex, itemIndex, effectStates[key])
end)

-- New Explicit Set State Event (for Hold interaction)
RegisterNetEvent("stage:setState", function(catIndex, itemIndex, state)
    local key = catIndex .. "-" .. itemIndex
    
    -- Only sync if state actually changes to reduce bandwidth
    if effectStates[key] ~= state then
        effectStates[key] = state
        TriggerClientEvent("stage:sync", -1, catIndex, itemIndex, state)
    end
end)

-- New Stop Category Event
RegisterNetEvent("stage:stopCategory", function(catIndex)
    -- Iterate all keys, find ones belonging to this category
    for key, active in pairs(effectStates) do
        -- key is "catIndex-itemIndex"
        local split = string.find(key, "-")
        if split then
            local cIndex = tonumber(string.sub(key, 1, split - 1))
            local iIndex = tonumber(string.sub(key, split + 1))
            
            if cIndex == catIndex and active then
                effectStates[key] = false
                TriggerClientEvent("stage:sync", -1, cIndex, iIndex, false)
            end
        end
    end
end)
