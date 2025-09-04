local Menu = exports.vorp_menu:GetMenuData()
local Core = exports.vorp_core:GetCore()

local blips = {}
local peds = {}

-- Load model safely
local function ensureModel(modelHash)
    if not IsModelValid(modelHash) then return false end
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(0)
        end
    end
    return true
end

-- Apply a random outfit so NPCs aren’t invisible
local function applyOutfit(ped)
    Citizen.InvokeNative(0x283978A15512B2FE, ped, true) -- _SET_RANDOM_OUTFIT_VARIATION
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false) -- UPDATE_PED_VARIATION
end

-- Spawn town clerk NPC
local function createTownNPC(town)
    if peds[town.key] and DoesEntityExist(peds[town.key]) then
        DeletePed(peds[town.key])
        peds[town.key] = nil
    end

    local modelName = town.npc or (Config.NPCModel or 'u_m_m_vhtstationclerk_01')
    local model = GetHashKey(modelName)
    if not ensureModel(model) then
        print(('[biggies_storage] Invalid NPC model for %s: %s'):format(town.key, tostring(modelName)))
        return nil
    end

    local x, y, z = town.coords.x + 0.0, town.coords.y + 0.0, town.coords.z + 0.0
    local ped = CreatePed(model, x, y, z, town.heading or 0.0, false, true, true, true)
    if not ped or ped == 0 then
        print(('[biggies_storage] Failed to create NPC for %s at %.2f, %.2f, %.2f'):format(town.key, x, y, z))
        return nil
    end

    applyOutfit(ped)
    SetEntityAsMissionEntity(ped, true, false)
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
    SetEntityHeading(ped, town.heading or 0.0)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStandStill(ped, -1)

    peds[town.key] = ped
    return ped
end

-- Create blip for storage
local function createBlip(town)
    if blips[town.key] then
        RemoveBlip(blips[town.key])
        blips[town.key] = nil
    end
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, town.coords) -- _MAP_CREATE_BLIP
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, town.label)                    -- _SET_BLIP_NAME
    if Config.BlipSprite then
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, Config.BlipSprite)
    end
    if Config.BlipScale then
        Citizen.InvokeNative(0xD38744167B2FA257, blip, Config.BlipScale)
    end
    blips[town.key] = blip
    return blip
end

-- Close all menus
local function closeAllMenus()
    Menu.CloseAll()
    DisplayRadar(true)
end

-- Onscreen keyboard input for slots
local function OpenNumberKeyboard(prompt, defaultText)
    AddTextEntry('BS_NUM_PROMPT', prompt or 'Enter amount')
    DisplayOnscreenKeyboard(1, 'BS_NUM_PROMPT', '', tostring(defaultText or ''), '', '', '', 8)
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
    local maxAdd = (maxSlots or Config.MaxSlots) - (current or 0)
    if maxAdd <= 0 then
        TriggerEvent('biggies_storage:notify', 'error', 'Already at maximum capacity.')
        return
    end
    local amt = OpenNumberKeyboard(('How many slots? (max %d)'):format(maxAdd), '')
    if amt and amt > 0 then
        if amt > maxAdd then amt = maxAdd end
        TriggerServerEvent('biggies_storage:upgradeWithAmount', townKey, amt)
    else
        TriggerEvent('biggies_storage:notify', 'error', 'Enter a valid number.')
    end
end

-- Open main storage menu
local function openMainMenu(townKey, townLabel)
    closeAllMenus()
    local elements = {
        { label = Lang.OpenStorage, value = 'open',    desc = Lang.Choose },
        { label = Lang.UpgradeStorage, value = 'upgrade', desc = Lang.Choose },
        { label = 'Close', value = 'close', desc = '' }
    }
    Menu.Open('default', GetCurrentResourceName(), 'biggies_storage_main_'..townKey, {
        title = townLabel or Lang.StorageTitle,
        subtext = Lang.Choose,
        align = 'top-left',
        elements = elements,
        maxVisibleItems = 6,
        hideRadar = true,
        soundOpen = true
    }, function(data, menu)
        local v = data.current.value
        if v == 'open' then
            TriggerServerEvent('biggies_storage:openStorage', townKey)
            closeAllMenus()
        elseif v == 'upgrade' then
            TriggerServerEvent('biggies_storage:requestCurrentSlots', townKey)
            closeAllMenus()
        else
            closeAllMenus()
        end
    end, function(data, menu)
        closeAllMenus()
    end)
end

-- ========= Prompt UI (no group native) =========
local StoragePrompt = nil
local promptArmed = false
local promptShownTown = nil
local promptShowTime = 0
local INTERACT_CONTROL = nil

local function CreateStoragePrompt()
    if StoragePrompt then return true end
    INTERACT_CONTROL = Config.InteractControl or 0x760A9C6F -- G by default
    local label = CreateVarString(10, "LITERAL_STRING", "Speak to the attendant")
    local prompt = Citizen.InvokeNative(0x04F97DE45A519419) -- PromptRegisterBegin
    Citizen.InvokeNative(0xB5352B7494A08258, prompt, INTERACT_CONTROL) -- SetControlAction
    Citizen.InvokeNative(0x5DD02A8318420DD7, prompt, label)           -- SetText
    Citizen.InvokeNative(0x8A0FB4D03A630D21, prompt, false)           -- Disabled to start
    Citizen.InvokeNative(0x71215ACCFDE075EE, prompt, false)           -- Invisible to start
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, prompt, true)            -- Standard mode (press)
    Citizen.InvokeNative(0xF7AA2696A22AD8B9, prompt)                  -- RegisterEnd
    StoragePrompt = prompt
    return true
end

local function SetPromptEnabledVisible(enabled, visible, mainText)
    if not StoragePrompt then return end
    Citizen.InvokeNative(0x8A0FB4D03A630D21, StoragePrompt, enabled) -- SetEnabled
    Citizen.InvokeNative(0x71215ACCFDE075EE, StoragePrompt, visible) -- SetVisible
    if mainText then
        local vs = CreateVarString(10, "LITERAL_STRING", mainText)
        Citizen.InvokeNative(0x5DD02A8318420DD7, StoragePrompt, vs)   -- SetText
        Citizen.InvokeNative(0xD649FD7D0E57E6ED, vs)                  -- DeleteVarString
    end
end

local function PromptPressed()
    if not StoragePrompt then return false end
    -- require both the prompt completion AND an actual control press gate for safety
    local completed = Citizen.InvokeNative(0x1A17B9ECFF617562, StoragePrompt, Citizen.ResultAsInteger())
    local keyPressed = IsControlJustPressed(0, INTERACT_CONTROL)
    return completed and keyPressed and promptArmed
end

-- ========= Main Thread =========
CreateThread(function()
    -- spawn all NPCs & blips
    for _, town in ipairs(Config.Towns) do
        if town.coords and town.coords.x and town.coords.y and town.coords.z then
            createTownNPC(town)
            createBlip(town)
        else
            print(("[biggies_storage] Skipping town %s: invalid coords"):format(tostring(town.key)))
        end
    end

    CreateStoragePrompt()

    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        local shownThisFrame = false

        for _, town in ipairs(Config.Towns) do
            local c = town.coords
            if c and c.x and c.y and c.z then
                local dist = #(pcoords - vector3(c.x, c.y, c.z))
                if dist <= 5.0 then
                    sleep = 0
                    shownThisFrame = true

                    local text = ("Speak to the attendant — Welcome to %s"):format(town.label or "Storage")

                    -- If we're switching towns or just showed prompt, disarm for a brief moment
                    if promptShownTown ~= town.key then
                        promptShownTown = town.key
                        promptArmed = false
                        promptShowTime = GetGameTimer()
                        SetPromptEnabledVisible(true, true, text)
                    else
                        -- keep text fresh while staying in range
                        SetPromptEnabledVisible(true, true, text)
                        -- arm after 250ms visible to avoid instant-fire on first frame
                        if not promptArmed and (GetGameTimer() - promptShowTime) > 250 then
                            promptArmed = true
                        end
                    end

                    if dist <= (Config.InteractDistance or 2.0) and PromptPressed() then
                        openMainMenu(town.key, town.label)
                        -- cooldown to prevent double triggers
                        promptArmed = false
                        promptShowTime = GetGameTimer()
                        Wait(200)
                    end

                    break -- only one town prompt at a time
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

-- ========= Event Handlers =========
RegisterNetEvent('biggies_storage:notify')
AddEventHandler('biggies_storage:notify', function(kind, msg)
    if kind == 'success' then
        Core.NotifyRightTip(msg, 4000)
    elseif kind == 'error' then
        Core.NotifyFail('Storage', msg, 4000)
    else
        Core.NotifyTop(msg, 'Storage', 4000)
    end
end)

RegisterNetEvent('biggies_storage:openUpgradeInput')
AddEventHandler('biggies_storage:openUpgradeInput', function(townKey, current, max)
    askUpgradeAmount(townKey, current, max)
end)
