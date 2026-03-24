-- Admins list (Discord ID or Steam Hex)
if not Config then Config = {} end
if not Config.Admins then
    Config.Admins = {
        "discord:454076027027718155"
    }
end

-- Function to check if a player has permission
function HasPermission(source)
    -- Check ACE permission first (optional fallback)
    if IsPlayerAceAllowed(source, "command") then 
        return true 
    end

    -- Check if Config.Admins exists and has entries
    if not Config.Admins or #Config.Admins == 0 then
        return false
    end

    -- Get player identifiers
    local identifiers = GetPlayerIdentifiers(source)
    if not identifiers then
        return false
    end

    -- Check each identifier against admin list
    for _, id in ipairs(identifiers) do
        for _, admin in ipairs(Config.Admins) do
            if id == admin then
                return true
            end
        end
    end
    
    return false
end
