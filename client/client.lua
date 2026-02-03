--[[
  ██╗     ██╗  ██╗██████╗       ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗
  ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝
  ██║      ╚███╔╝ ██████╔╝█████╗███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗  
  ██║      ██╔██╗ ██╔══██╗╚════╝╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝  
  ███████╗██╔╝ ██╗██║  ██║      ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
  ═══════════════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-Storage - Client Script
  ═══════════════════════════════════════════════════════════════════════════════════════════
  
  Client-side logic for storage system:
  - NPC spawning and management
  - Blip creation on map
  - Player interaction prompts
  - Menu handling
  - Distance checking and optimization
  
  ═══════════════════════════════════════════════════════════════════════════════════════════
  🔹 Server Information
  ═══════════════════════════════════════════════════════════════════════════════════════════
  Server:      The Land of Wolves 🐺
  Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
  Website:     https://www.wolves.land
  Discord:     https://discord.gg/CrKcWdfd3A
  Developer:   iBoss21 / The Lux Empire
  ═══════════════════════════════════════════════════════════════════════════════════════════
  📋 Version & Performance
  ═══════════════════════════════════════════════════════════════════════════════════════════
  Version:     2.0.0
  Performance: 0.00-0.01ms (idle) | 0.02-0.05ms (active)
  Status:      ✅ Production Ready
  ═══════════════════════════════════════════════════════════════════════════════════════════
  📄 Copyright © 2024-2026 The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════════════
]]

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ LOCAL VARIABLES
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local blips = {}
local npcs = {}
local StoragePrompt = nil
local promptArmed = false
local promptShownTown = nil
local promptShowTime = 0
local INTERACT_CONTROL = nil

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ UTILITY FUNCTIONS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local function DebugPrint(...)
    if Config.Debug.Enable then
        print('^3[LXR-Storage Client]^7', ...)
    end
end

local function ensureModel(modelHash)
    if not IsModelValid(modelHash) then 
        return false 
    end
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        local timeout = 0
        while not HasModelLoaded(modelHash) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
    end
    return HasModelLoaded(modelHash)
end

local function applyOutfit(ped)
    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false)
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ NPC MANAGEMENT
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local function createTownNPC(town)
    if not Config.General.EnableNPCs then
        return nil
    end
    
    if npcs[town.key] and DoesEntityExist(npcs[town.key]) then
        DeletePed(npcs[town.key])
        npcs[town.key] = nil
    end

    local modelName = town.npc or Config.NPC.DefaultModel
    local model = GetHashKey(modelName)
    
    if not ensureModel(model) then
        DebugPrint(('Invalid NPC model for %s: %s'):format(town.key, tostring(modelName)))
        return nil
    end

    local x, y, z = town.coords.x, town.coords.y, town.coords.z
    local ped = CreatePed(model, x, y, z, town.heading or 0.0, false, true, true, true)
    
    if not ped or ped == 0 then
        DebugPrint(('Failed to create NPC for %s'):format(town.key))
        return nil
    end

    applyOutfit(ped)
    SetEntityAsMissionEntity(ped, true, false)
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
    SetEntityHeading(ped, town.heading or 0.0)
    
    if Config.NPC.Invincible then
        SetEntityInvincible(ped, true)
    end
    
    if Config.NPC.Freeze then
        FreezeEntityPosition(ped, true)
    end
    
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStandStill(ped, -1)

    npcs[town.key] = ped
    
    if Config.Debug.Enable and Config.Debug.PrintNPCSpawns then
        DebugPrint(('NPC spawned for %s at %.2f, %.2f, %.2f'):format(town.key, x, y, z))
    end
    
    return ped
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ BLIP MANAGEMENT
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local function createBlip(town)
    if not Config.General.EnableBlips then
        return nil
    end
    
    if blips[town.key] then
        RemoveBlip(blips[town.key])
        blips[town.key] = nil
    end
    
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, town.coords)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, town.label)
    
    if Config.Blip.Sprite then
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, Config.Blip.Sprite)
    end
    
    if Config.Blip.Scale then
        Citizen.InvokeNative(0xD38744167B2FA257, blip, Config.Blip.Scale)
    end
    
    blips[town.key] = blip
    return blip
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ MENU FUNCTIONS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local function closeAllMenus()
    Framework.CloseMenu()
    DisplayRadar(true)
end

local function OpenNumberKeyboard(prompt, defaultText)
    AddTextEntry('LXR_STORAGE_INPUT', prompt or Lang.EnterAmount)
    DisplayOnscreenKeyboard(1, 'LXR_STORAGE_INPUT', '', tostring(defaultText or ''), '', '', '', 8)
    
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end
    
    if GetOnscreenKeyboardResult() then
        local v = tonumber(GetOnscreenKeyboardResult())
        return v or 0
    end
    
    return 0
end

local function askUpgradeAmount(townKey, current, maxSlots)
    local maxAdd = (maxSlots or Config.Storage.MaxSlots) - (current or 0)
    
    if maxAdd <= 0 then
        Framework.Notify(Lang.AlreadyMax, 'error')
        return
    end
    
    local amt = OpenNumberKeyboard(Lang.EnterSlots:format(maxAdd), '')
    
    if amt and amt > 0 then
        if amt > maxAdd then 
            amt = maxAdd 
        end
        TriggerServerEvent('lxr-storage:server:upgradeSlots', townKey, amt)
    else
        Framework.Notify(Lang.InvalidAmount, 'error')
    end
end

local function openMainMenu(townKey, townLabel)
    closeAllMenus()
    
    local elements = {
        { label = Lang.OpenStorage, value = 'open', desc = Lang.Choose },
        { label = Lang.UpgradeStorage, value = 'upgrade', desc = Lang.Choose },
        { label = Lang.Close, value = 'close', desc = '' }
    }
    
    local menuData = {
        title = townLabel or Lang.StorageTitle,
        subtext = Lang.Choose,
        align = 'top-left',
        elements = elements,
        maxVisibleItems = 6,
        hideRadar = true,
        soundOpen = true
    }
    
    Framework.OpenMenu(menuData, function(data, menu)
        local v = data.current.value
        
        if v == 'open' then
            TriggerServerEvent('lxr-storage:server:openStorage', townKey)
            closeAllMenus()
        elseif v == 'upgrade' then
            TriggerServerEvent('lxr-storage:server:requestSlots', townKey)
            closeAllMenus()
        else
            closeAllMenus()
        end
    end, function(data, menu)
        closeAllMenus()
    end)
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ PROMPT SYSTEM
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local function CreateStoragePrompt()
    if StoragePrompt then 
        return true 
    end
    
    INTERACT_CONTROL = Config.Keys.Interact or 0x760A9C6F
    local label = CreateVarString(10, "LITERAL_STRING", Lang.PromptLabel)
    local prompt = Citizen.InvokeNative(0x04F97DE45A519419)
    
    Citizen.InvokeNative(0xB5352B7494A08258, prompt, INTERACT_CONTROL)
    Citizen.InvokeNative(0x5DD02A8318420DD7, prompt, label)
    Citizen.InvokeNative(0x8A0FB4D03A630D21, prompt, false)
    Citizen.InvokeNative(0x71215ACCFDE075EE, prompt, false)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, prompt, true)
    Citizen.InvokeNative(0xF7AA2696A22AD8B9, prompt)
    
    StoragePrompt = prompt
    return true
end

local function SetPromptEnabledVisible(enabled, visible, mainText)
    if not StoragePrompt then 
        return 
    end
    
    Citizen.InvokeNative(0x8A0FB4D03A630D21, StoragePrompt, enabled)
    Citizen.InvokeNative(0x71215ACCFDE075EE, StoragePrompt, visible)
    
    if mainText then
        local vs = CreateVarString(10, "LITERAL_STRING", mainText)
        Citizen.InvokeNative(0x5DD02A8318420DD7, StoragePrompt, vs)
        Citizen.InvokeNative(0xD649FD7D0E57E6ED, vs)
    end
end

local function PromptPressed()
    if not StoragePrompt then 
        return false 
    end
    
    local completed = Citizen.InvokeNative(0x1A17B9ECFF617562, StoragePrompt, Citizen.ResultAsInteger())
    local keyPressed = IsControlJustPressed(0, INTERACT_CONTROL)
    
    return completed and keyPressed and promptArmed
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ MAIN THREAD
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

CreateThread(function()
    Wait(1000)
    
    for _, town in ipairs(Config.Towns) do
        if town.coords and town.coords.x and town.coords.y and town.coords.z then
            createTownNPC(town)
            createBlip(town)
        else
            DebugPrint(('Skipping town %s: invalid coords'):format(tostring(town.key)))
        end
    end

    CreateStoragePrompt()
    DebugPrint('Storage system initialized')

    while true do
        local sleep = Config.Performance.TickRate.Idle
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        local shownThisFrame = false

        for _, town in ipairs(Config.Towns) do
            local c = town.coords
            if c and c.x and c.y and c.z then
                local dist = #(pcoords - vector3(c.x, c.y, c.z))
                
                if dist <= Config.General.PromptDistance then
                    sleep = Config.Performance.TickRate.Active
                    shownThisFrame = true

                    local text = Lang.PromptText:format(town.label or Lang.StorageTitle)

                    if promptShownTown ~= town.key then
                        promptShownTown = town.key
                        promptArmed = false
                        promptShowTime = GetGameTimer()
                        SetPromptEnabledVisible(true, true, text)
                    else
                        SetPromptEnabledVisible(true, true, text)
                        
                        if not promptArmed and (GetGameTimer() - promptShowTime) > Config.Cooldowns.InteractionDelay then
                            promptArmed = true
                        end
                    end

                    if dist <= Config.General.InteractDistance and PromptPressed() then
                        openMainMenu(town.key, town.label)
                        promptArmed = false
                        promptShowTime = GetGameTimer()
                        Wait(200)
                    end

                    break
                end
            end
        end

        if not shownThisFrame then
            if promptShownTown ~= nil then
                SetPromptEnabledVisible(false, false)
                promptShownTown = nil
                promptArmed = false
                promptShowTime = 0
            end
        end

        Wait(sleep)
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ KEYBIND SYSTEM
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local keybindCooldown = 0
local KEYBIND_COOLDOWN_MS = 1000 -- 1 second cooldown to prevent spam

local function findNearestStorage()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local nearestTown = nil
    local nearestDist = Config.Keybind.MaxDistance
    
    for _, town in ipairs(Config.Towns) do
        local c = town.coords
        if c and c.x and c.y and c.z then
            local dist = #(pcoords - vector3(c.x, c.y, c.z))
            if dist <= nearestDist then
                nearestDist = dist
                nearestTown = town
            end
        end
    end
    
    return nearestTown, nearestDist
end

RegisterCommand(Config.Keybind.Command, function()
    if not Config.Keybind.Enabled then
        return
    end
    
    -- Check cooldown
    local currentTime = GetGameTimer()
    if currentTime - keybindCooldown < KEYBIND_COOLDOWN_MS then
        return
    end
    keybindCooldown = currentTime
    
    local nearestTown, distance = findNearestStorage()
    
    if nearestTown then
        DebugPrint(('Opening storage for %s via keybind (distance: %.2fm)'):format(nearestTown.key, distance))
        openMainMenu(nearestTown.key, nearestTown.label)
    else
        Framework.Notify(Lang.NoNearbyStorage, 'error')
        if Config.Debug.Enable then
            DebugPrint('No storage location within keybind range')
        end
    end
end, false)

-- Register the keybind mapping (player can rebind this in their settings)
if Config.Keybind.Enabled then
    RegisterKeyMapping(
        Config.Keybind.Command,
        Config.Keybind.Description,
        'keyboard',
        Config.Keybind.DefaultKey
    )
    
    if Config.Debug.Enable then
        CreateThread(function()
            Wait(2000)
            DebugPrint(('Keybind registered: Press %s to open nearby storage'):format(Config.Keybind.DefaultKey))
        end)
    end
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ EVENT HANDLERS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

RegisterNetEvent('lxr-storage:client:notify', function(msg, type, duration)
    Framework.Notify(msg, type, duration)
end)

RegisterNetEvent('lxr-storage:client:openUpgradeInput', function(townKey, current, max)
    askUpgradeAmount(townKey, current, max)
end)

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ RESOURCE CLEANUP
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    
    for _, ped in pairs(npcs) do
        if DoesEntityExist(ped) then
            DeletePed(ped)
        end
    end
    
    for _, blip in pairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    
    DebugPrint('Storage system cleaned up')
end)
