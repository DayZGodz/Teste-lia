local activeEffects = {}
local spawnedProps = {}
local isUiOpen = false

local function IsPlayerInAllowedZone()
    if not Config.AllowedZones or #Config.AllowedZones == 0 then return false end
    local p = GetEntityCoords(PlayerPedId())
    for _, zone in ipairs(Config.AllowedZones) do
        if #(p - zone.Coords) <= zone.Radius then return true end
    end
    return false
end

local function ShowNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

function GetLocationConfig()
    if Config.Categories then return Config end
    if not Config or not Config.Locations then return nil end
    return Config.Locations[Config.CurrentLocation]
end

-- Função para aplicar valores padrão de Interaction e ShowStop baseado no Label
local function ApplyCategoryDefaults(categories)
    if not categories then return categories end
    
    local processed = {}
    for _, cat in ipairs(categories) do
        local processedCat = {}
        for k, v in pairs(cat) do
            processedCat[k] = v
        end
        
        -- Define Interaction e ShowStop automaticamente baseado no Label
        if cat.Label == "PARTICULAS" then
            processedCat.Interaction = "hold"
            processedCat.ShowStop = false
        elseif cat.Label == "FIREWORKS" then
            processedCat.Interaction = "toggle"
            processedCat.ShowStop = true
        else
            -- Se não for uma categoria conhecida, usa padrão
            processedCat.Interaction = processedCat.Interaction or "hold"
            processedCat.ShowStop = processedCat.ShowStop or false
        end
        
        table.insert(processed, processedCat)
    end
    
    return processed
end

-- Tabela de efeitos pré-configurados (valores padrão)
local DefaultEffects = {
-- PARTICULAS
    ["Fire"] = {
        library = "core",
        effect = "exp_sht_flame",
        EffectType = "continuous",
        RepeatDelay = 50,
        Scale = 2.0
    },
    ["Smoke"] = {
        Dict = "core",
        Name = "ent_amb_steam",
        EffectType = "continuous",
        Scale = 1.0
    },
    ["Spark"] = {
        Dict = "core",
        Name = "sp_foundry_sparks",
        EffectType = "burst",
        RepeatDelay = 120,
        Scale = 1.0
    },
    ["Confetti"] = {
        Dict = "scr_xs_celebration",
        Name = "scr_xs_confetti_burst",
        EffectType = "burst",
        RepeatDelay = 500,
        Scale = 1.0
    },
    -- FIREWORKS
    ["Color 1"] = {
        Dict = "proj_indep_firework_v2",
        Name = "scr_firework_indep_ring_burst_rwb",
        EffectType = "burst",
        RepeatDelay = 1000,
        Scale = 1.2
    },
    ["Color 2"] = {
        Dict = "proj_xmas_firework",
        Name = "scr_firework_xmas_repeat_burst_rgw",
        EffectType = "burst",
        RepeatDelay = 1000,
        Scale = 1.2
    },
    ["White"] = {
        Dict = "scr_indep_fireworks",
        Name = "scr_indep_firework_trailburst",
        EffectType = "burst",
        RepeatDelay = 800,
        Scale = 1.25
    },
    ["Stars"] = {
        Dict = "scr_indep_fireworks",
        Name = "scr_indep_firework_fountain",
        EffectType = "burst",
        RepeatDelay = 600,
        Scale = 1.0
    }
}

-- Função para expandir item simplificado com valores padrão
local function ExpandItem(item, categoryLabel)
    -- Se já tem Dict/Name ou library/effect, não precisa expandir
    if (item.Dict and item.Name) or (item.library and item.effect) then
        return item
    end
    
    -- Se tem Effect, busca nas configurações padrão
    if item.Effect then
        local default = DefaultEffects[item.Effect]
        if default then
            local expanded = {}
            -- Copia valores padrão
            for k, v in pairs(default) do
                expanded[k] = v
            end
            -- Sobrescreve com valores do item (se especificados)
            for k, v in pairs(item) do
                if k ~= "Effect" then -- Não copia Effect
                    expanded[k] = v
                end
            end
            -- Garante Type
            expanded.Type = expanded.Type or "particle"
            -- Garante Rotation
            expanded.Rotation = expanded.Rotation or 0.0
            return expanded
        end
    end
    
    -- Se não encontrou, retorna item original
    return item
end

local function DeleteSpawnedProps()
    for _, prop in ipairs(spawnedProps) do
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
    end
    spawnedProps = {}
end

local function SpawnStaticProps()
    DeleteSpawnedProps()
    
    local loc = GetLocationConfig()
    if not loc or not loc.Categories then return end

    local modelName = "prop_cs_pour_tube"
    local modelHash = GetHashKey(modelName)
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(10) end

    for _, cat in ipairs(loc.Categories) do
        if cat.Items then
            for _, item in ipairs(cat.Items) do
                -- Expande item simplificado
                item = ExpandItem(item, cat.Label)
                
                -- Skip props for FIREWORKS category except for "Stars"
                if cat.Label == "FIREWORKS" and item.Label ~= "Stars" then
                    goto continue_item
                end
                
                if item.Type == "particle" and item.Coords then
                    -- Handle both single coordinate and array of coordinates
                    local coordsList = item.Coords
                    if type(coordsList) ~= "table" or (coordsList.x and coordsList.y) then
                        -- Single coordinate
                        coordsList = { coordsList }
                    end
                    
                    -- Spawn prop at each coordinate
                    for _, coord in ipairs(coordsList) do
                        local obj = CreateObject(modelHash, coord.x, coord.y, coord.z, false, false, false)
                        SetEntityHeading(obj, item.Rotation or 0.0)
                        FreezeEntityPosition(obj, true)
                        table.insert(spawnedProps, obj)
                    end
                end
                ::continue_item::
            end
        end
    end
end

RegisterCommand("efeitos", function()
    if not IsPlayerInAllowedZone() then
        ShowNotification("~r~Não há stage cadastrado nesta área.")
        return
    end

    -- Verifica permissão no servidor
    TriggerServerEvent("stage:checkPermission")
end)

-- Evento recebido do servidor após verificação de permissão
RegisterNetEvent("stage:permissionResult", function(hasPermission)
    if not hasPermission then
        ShowNotification("~r~Você não tem permissão para usar este comando.")
        return
    end

    local loc = GetLocationConfig()
    if not loc or not loc.Categories then 
        return 
    end
    
    -- Aplica valores padrão de Interaction e ShowStop
    local processedCategories = ApplyCategoryDefaults(loc.Categories)
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        config = processedCategories
    })
    isUiOpen = true
end)

RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false)
    isUiOpen = false
    if cb then cb("ok") end
end)

RegisterNUICallback("trigger", function(data, cb)
    -- data.category (0-based from JS), data.item (0-based from JS)
    -- Convert to 1-based for Lua
    TriggerServerEvent("stage:toggle", data.category + 1, data.item + 1)
    if cb then cb("ok") end
end)

RegisterNUICallback("setState", function(data, cb)
    -- data.category, data.item, data.state
    TriggerServerEvent("stage:setState", data.category + 1, data.item + 1, data.state)
    if cb then cb("ok") end
end)

RegisterNUICallback("stopCategory", function(data, cb)
    -- data.category
    TriggerServerEvent("stage:stopCategory", data.category + 1)
    if cb then cb("ok") end
end)

RegisterNetEvent("stage:sync", function(catIndex, itemIndex, active)
    local loc = GetLocationConfig()
    if not loc then return end

    local category = loc.Categories[catIndex]
    if not category then return end

    local item = category.Items[itemIndex]
    if not item then return end
    
    -- Expande item simplificado com valores padrão
    item = ExpandItem(item, category.Label)

    -- Update UI if open
    -- Convert back to 0-based for JS key
    local jsKey = (catIndex - 1) .. "-" .. (itemIndex - 1)
    
    if isUiOpen then
        SendNUIMessage({
            action = "updateState",
            key = jsKey,
            state = active
        })
    end

    -- Handle Effect/Prop (Use Lua 1-based index for internal storage key)
    local key = catIndex .. "-" .. itemIndex

    if active then
        -- START
        if activeEffects[key] and activeEffects[key].active then 
            return 
        end

        activeEffects[key] = { active = true, type = "particle" }

        CreateThread(function()
            -- Support both old format (Dict/Name) and new format (library/effect)
            local effectDict = item.library or item.Dict
            local effectName = item.effect or item.Name
            
            -- Request particle asset
            RequestNamedPtfxAsset(effectDict)
            local timeout = 0
            while not HasNamedPtfxAssetLoaded(effectDict) and timeout < 100 do
                Wait(10)
                timeout = timeout + 1
            end
            
            -- Small delay to ensure asset is ready
            Wait(50)

            -- Default behavior if not specified
            local effectType = item.EffectType or "continuous"
            local delay = item.RepeatDelay or 1000

            while activeEffects[key] and activeEffects[key].active do
                
                local coordsList = item.Coords
                if type(coordsList) ~= "table" or (coordsList.x and coordsList.y) then
                    coordsList = { coordsList }
                end

                if effectType == "continuous" then
                    -- Continuous Loop
                    if not activeEffects[key].handles then
                        activeEffects[key].handles = {}
                        for _, coord in ipairs(coordsList) do
                            UseParticleFxAssetNextCall(effectDict)
                            local handle = StartParticleFxLoopedAtCoord(
                                effectName,
                                coord.x, coord.y, coord.z + 0.15,
                                0.0, 0.0, item.Rotation or 0.0,
                                item.Scale or 1.0,
                                false, false, false, false
                            )
                            if handle ~= 0 then
                                table.insert(activeEffects[key].handles, handle)
                            end
                        end
                    end
                    
                    -- Wait until stopped or handle invalid
                    while activeEffects[key] and activeEffects[key].active do
                         Wait(100)
                    end
                    
                    if activeEffects[key].handles then
                        for _, h in ipairs(activeEffects[key].handles) do
                            StopParticleFxLooped(h, 0)
                        end
                        activeEffects[key].handles = nil
                    end
                    
                elseif effectType == "burst" then
                    -- Repeated Burst
                    for _, coord in ipairs(coordsList) do
                        -- Ensure asset is set before each call
                        UseParticleFxAssetNextCall(effectDict)
                        StartParticleFxNonLoopedAtCoord(
                            effectName,
                            coord.x, coord.y, coord.z + 0.15,
                            0.0, 0.0, item.Rotation or 0.0,
                            item.Scale or 1.0,
                            false, false, false
                        )
                    end
                    Wait(delay)
                end
                
                Wait(0)
            end
        end)

    else
        -- STOP
        if activeEffects[key] then
            -- Set active to false, the thread will handle cleanup
            activeEffects[key].active = false
            
            -- If it has handles (continuous), stop immediately for responsiveness
            if activeEffects[key].handles then
                for _, h in ipairs(activeEffects[key].handles) do
                    StopParticleFxLooped(h, 0)
                end
                activeEffects[key].handles = nil
            end
            
            SetTimeout(100, function()
                 if activeEffects[key] and not activeEffects[key].active then
                     activeEffects[key] = nil
                 end
            end)
        end
    end
end)

CreateThread(function()
    SpawnStaticProps()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    DeleteSpawnedProps()
    
    for key, effect in pairs(activeEffects) do
        if effect.type == "particle" then
            StopParticleFxLooped(effect.handle, 0)
        elseif effect.type == "prop" then
            if DoesEntityExist(effect.handle) then
                DeleteObject(effect.handle)
            end
        end
    end
end)
