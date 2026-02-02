--[[
  ██╗     ██╗  ██╗██████╗       ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗
  ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝
  ██║      ╚███╔╝ ██████╔╝█████╗███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗  
  ██║      ██╔██╗ ██╔══██╗╚════╝╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝  
  ███████╗██╔╝ ██╗██║  ██║      ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
  ═══════════════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-Storage - Server Script
  ═══════════════════════════════════════════════════════════════════════════════════════════
  
  Server-side logic for storage system:
  - Database operations (character storage tracking)
  - Slot upgrade handling with validation
  - Economy integration (charge players for upgrades)
  - Inventory management
  - Security and anti-cheat measures
  
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
  Performance: 0.00-0.01ms (idle) | 0.01-0.02ms (database operations)
  Status:      ✅ Production Ready
  ═══════════════════════════════════════════════════════════════════════════════════════════
  📄 Copyright © 2024-2026 The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════════════
]]

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ LOCAL VARIABLES
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local PlayerDataCache = {}
local UpgradeCooldowns = {}

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ UTILITY FUNCTIONS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local function DebugPrint(...)
    if Config.Debug.Enable then
        print('^3[LXR-Storage Server]^7', ...)
    end
end

local function LogSecurity(source, message)
    if Config.Security.LogSuspiciousActivity then
        local identifier = Framework.GetIdentifier(source)
        print(('^1[SECURITY] Player %s (ID: %d) - %s^7'):format(identifier or 'unknown', source, message))
    end
end

local function IsOnCooldown(source)
    local cooldown = UpgradeCooldowns[source]
    if not cooldown then
        return false
    end
    
    local current = GetGameTimer()
    if current - cooldown < Config.Cooldowns.UpgradeCooldown then
        return true
    end
    
    return false
end

local function SetCooldown(source)
    UpgradeCooldowns[source] = GetGameTimer()
end

local function ValidatePlayerDistance(source, townKey)
    if not Config.Security.ValidateDistance then
        return true
    end
    
    local playerPed = GetPlayerPed(source)
    if not playerPed or playerPed == 0 then
        return false
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    
    for _, town in ipairs(Config.Towns) do
        if town.key == townKey then
            local distance = #(playerCoords - town.coords)
            if distance <= Config.Security.MaxValidationDistance then
                return true
            end
            
            LogSecurity(source, ('Distance validation failed for town %s (distance: %.2f)'):format(townKey, distance))
            return false
        end
    end
    
    return false
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ DATABASE FUNCTIONS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

MySQL.ready(function()
    if Config.Database.AutoCreate then
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `]]..Config.Database.TableName..[[` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `charidentifier` VARCHAR(60) NOT NULL,
                `town_key` VARCHAR(64) NOT NULL,
                `slots` INT NOT NULL DEFAULT ]]..Config.Storage.BaseSlots..[[,
                `last_upgrade` TIMESTAMP NULL DEFAULT NULL,
                `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE KEY `uniq_char_town` (`charidentifier`, `town_key`),
                INDEX `idx_charidentifier` (`charidentifier`),
                INDEX `idx_town_key` (`town_key`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        ]])
        
        DebugPrint('Database table initialized:', Config.Database.TableName)
    end
end)

local function getOrCreateStorage(source, townKey)
    local identifier = Framework.GetIdentifier(source)
    if not identifier then 
        return nil 
    end
    
    local cacheKey = identifier .. ':' .. townKey
    
    if Config.Performance.CachePlayerData and PlayerDataCache[cacheKey] then
        local cached = PlayerDataCache[cacheKey]
        if os.time() - cached.timestamp < Config.Performance.CacheDuration then
            return cached.slots
        end
    end
    
    local rows = MySQL.query.await(
        'SELECT slots FROM '..Config.Database.TableName..' WHERE charidentifier = ? AND town_key = ?',
        {identifier, townKey}
    )
    
    local slots = Config.Storage.BaseSlots
    
    if rows and rows[1] then
        slots = rows[1].slots
    else
        MySQL.insert.await(
            'INSERT INTO '..Config.Database.TableName..' (charidentifier, town_key, slots) VALUES (?, ?, ?)',
            {identifier, townKey, slots}
        )
    end
    
    if Config.Performance.CachePlayerData then
        PlayerDataCache[cacheKey] = {
            slots = slots,
            timestamp = os.time()
        }
    end
    
    return slots
end

local function setSlots(source, townKey, slots)
    local identifier = Framework.GetIdentifier(source)
    if not identifier then 
        return false 
    end
    
    MySQL.update.await(
        'UPDATE '..Config.Database.TableName..' SET slots = ?, last_upgrade = NOW() WHERE charidentifier = ? AND town_key = ?',
        {slots, identifier, townKey}
    )
    
    local cacheKey = identifier .. ':' .. townKey
    if Config.Performance.CachePlayerData then
        PlayerDataCache[cacheKey] = {
            slots = slots,
            timestamp = os.time()
        }
    end
    
    return true
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ INVENTORY FUNCTIONS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local function openTownInventory(source, townKey, slots)
    local identifier = Framework.GetIdentifier(source)
    if not identifier then 
        return false 
    end
    
    local invId = ('storage:%s:%s'):format(townKey, identifier)
    
    if not Framework.Inventory then
        TriggerClientEvent('lxr-storage:client:notify', source, Lang.InventoryError, 'error')
        return false
    end
    
    local success = Framework.OpenInventory(source, invId, slots)
    
    if success then
        if Config.Debug.Enable and Config.Debug.PrintEvents then
            DebugPrint(('Opened inventory %s for player %d with %d slots'):format(invId, source, slots))
        end
    else
        TriggerClientEvent('lxr-storage:client:notify', source, Lang.InventoryError, 'error')
    end
    
    return success
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ EVENT HANDLERS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

RegisterNetEvent('lxr-storage:server:openStorage', function(townKey)
    local src = source
    
    if not ValidatePlayerDistance(src, townKey) then
        TriggerClientEvent('lxr-storage:client:notify', src, Lang.TooFarAway, 'error')
        return
    end
    
    local slots = getOrCreateStorage(src, townKey)
    if not slots then
        TriggerClientEvent('lxr-storage:client:notify', src, Lang.ErrorOccurred, 'error')
        return
    end
    
    openTownInventory(src, townKey, slots)
end)

RegisterNetEvent('lxr-storage:server:requestSlots', function(townKey)
    local src = source
    
    if not ValidatePlayerDistance(src, townKey) then
        TriggerClientEvent('lxr-storage:client:notify', src, Lang.TooFarAway, 'error')
        return
    end
    
    local current = getOrCreateStorage(src, townKey) or Config.Storage.BaseSlots
    TriggerClientEvent('lxr-storage:client:openUpgradeInput', src, townKey, current, Config.Storage.MaxSlots)
end)

RegisterNetEvent('lxr-storage:server:upgradeSlots', function(townKey, amount)
    local src = source
    
    if Config.Security.EnableAntiCheat then
        if IsOnCooldown(src) then
            LogSecurity(src, 'Upgrade spam detected')
            return
        end
        
        if not ValidatePlayerDistance(src, townKey) then
            LogSecurity(src, 'Distance validation failed during upgrade')
            TriggerClientEvent('lxr-storage:client:notify', src, Lang.TooFarAway, 'error')
            return
        end
        
        amount = tonumber(amount) or 0
        if amount <= 0 or amount > Config.Security.MaxUpgradePerRequest then
            LogSecurity(src, ('Invalid upgrade amount: %s'):format(tostring(amount)))
            return
        end
    else
        amount = tonumber(amount) or 0
        if amount <= 0 then 
            return 
        end
    end
    
    SetCooldown(src)
    
    local current = getOrCreateStorage(src, townKey)
    if not current then
        TriggerClientEvent('lxr-storage:client:notify', src, Lang.ErrorOccurred, 'error')
        return
    end
    
    if current >= Config.Storage.MaxSlots then
        TriggerClientEvent('lxr-storage:client:notify', src, Lang.AlreadyMax, 'error')
        return
    end
    
    local maxAdd = Config.Storage.MaxSlots - current
    if amount > maxAdd then 
        amount = maxAdd 
    end
    
    -- Calculate cost based on currency system
    local cost, costInCents
    if Config.ItemCurrency and Config.ItemCurrency.Enabled and (Framework.Name == 'lxr-core' or Framework.Name == 'rsg-core') then
        -- Item-based currency: calculate in cents
        local costInDollars = amount * Config.Storage.PricePerSlot
        costInCents = math.floor(costInDollars * Config.ItemCurrency.CentsPerDollar + 0.5)
        cost = costInDollars -- For display purposes
    else
        -- Traditional currency (VORP)
        cost = math.floor((amount * Config.Storage.PricePerSlot) * 100 + 0.5) / 100.0
        costInCents = cost
    end
    
    -- Check if player has enough money
    local playerMoney = Framework.GetTotalMoneyValue(src)
    if playerMoney < costInCents then
        TriggerClientEvent('lxr-storage:client:notify', src, Lang.NotEnoughFunds, 'error')
        return
    end
    
    -- Remove money from player
    local removed = Framework.RemoveMoneyAsItems(src, costInCents)
    if not removed then
        TriggerClientEvent('lxr-storage:client:notify', src, Lang.NotEnoughFunds, 'error')
        return
    end
    
    local newSlots = current + amount
    if newSlots > Config.Storage.MaxSlots then 
        newSlots = Config.Storage.MaxSlots 
    end
    
    setSlots(src, townKey, newSlots)
    
    local identifier = Framework.GetIdentifier(src)
    if identifier then
        local invId = ('storage:%s:%s'):format(townKey, identifier)
        Framework.UpdateInventorySlots(invId, newSlots)
    end
    
    TriggerClientEvent('lxr-storage:client:notify', src, Lang.Upgraded:format(amount, cost), 'success')
    
    if Config.Debug.Enable and Config.Debug.PrintEvents then
        DebugPrint(('Player %d upgraded %s storage: +%d slots for $%.2f (total: %d)'):format(
            src, townKey, amount, cost, newSlots
        ))
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ CACHE CLEANUP
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

if Config.Performance.CachePlayerData then
    CreateThread(function()
        while true do
            Wait(60000)
            
            local currentTime = os.time()
            local cleaned = 0
            
            for key, data in pairs(PlayerDataCache) do
                if currentTime - data.timestamp > Config.Performance.CacheDuration then
                    PlayerDataCache[key] = nil
                    cleaned = cleaned + 1
                end
            end
            
            if cleaned > 0 and Config.Debug.Enable then
                DebugPrint(('Cleaned %d expired cache entries'):format(cleaned))
            end
        end
    end)
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ STARTUP MESSAGE
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

CreateThread(function()
    Wait(2000)
    
    print([[

    ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                                                                                                                   ║
    ║   🐺 LXR-STORAGE SUCCESSFULLY STARTED                                                                             ║
    ║                                                                                                                   ║
    ║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
    ║   │  Server:        The Land of Wolves 🐺                                                                    │   ║
    ║   │  Version:       2.0.0                                                                                    │   ║
    ║   │  Framework:     ]]..Framework.Name:upper()..string.rep(' ', 84-#Framework.Name)..[[│   ║
    ║   │  Storage Towns: ]]..#Config.Towns..[[ locations                                                                      │   ║
    ║   │  Base Slots:    ]]..Config.Storage.BaseSlots..[[ per town                                                                    │   ║
    ║   │  Max Slots:     ]]..Config.Storage.MaxSlots..[[ maximum                                                                     │   ║
    ║   │  Developer:     iBoss21 / The Lux Empire                                                                │   ║
    ║   └─────────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
    ║                                                                                                                   ║
    ║   🌐 Website:        https://www.wolves.land                                                                      ║
    ║   💬 Discord:        https://discord.gg/CrKcWdfd3A                                                                ║
    ║   🛒 Store:          https://theluxempire.tebex.io                                                                ║
    ║                                                                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

    ]])
end)
