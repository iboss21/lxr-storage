local Core = exports.vorp_core:GetCore()
local VorpInv = nil

if exports.vorp_inventory and exports.vorp_inventory.vorp_inventoryApi then
    VorpInv = exports.vorp_inventory:vorp_inventoryApi()
end

if not VorpInv then
    print('^1[biggies_storage]^7 Could not grab vorp_inventoryApi(). Make sure you are using a recent vorp_inventory build.')
end

-- Track chat fallback context per player
local pendingTownForChat = {}

-- Helpers to charge currency
local function chargePlayer(source, amount)
    local user = Core.getUser(source); if not user then return false end
    local char = user.getUsedCharacter; if not char then return false end

    if Config.CurrencyType == 0 then
        if char.money and char.money >= amount then
            if char.removeCurrency then
                char.removeCurrency(0, amount)
            else
                TriggerEvent('vorp:removeMoney', source, 0, amount)
            end
            return true
        else
            return false
        end
    else
        if char.gold and char.gold >= amount then
            if char.removeCurrency then
                char.removeCurrency(1, amount)
            else
                TriggerEvent('vorp:removeMoney', source, 1, amount)
            end
            return true
        else
            return false
        end
    end
end

-- SQL (oxmysql) helpers
MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS hhrp_town_storage (
            id INT AUTO_INCREMENT PRIMARY KEY,
            charidentifier VARCHAR(60) NOT NULL,
            town_key VARCHAR(64) NOT NULL,
            slots INT NOT NULL DEFAULT 200,
            UNIQUE KEY uniq_char_town (charidentifier, town_key)
        )
    ]])
end)

local function getCharId(source)
    local user = Core.getUser(source); if not user then return nil end
    local char = user.getUsedCharacter; if not char then return nil end
    return tostring(char.charIdentifier or char.identifier or '0')
end

local function getOrCreateStorage(source, townKey)
    local charid = getCharId(source); if not charid then return nil end
    local rows = MySQL.query.await('SELECT slots FROM hhrp_town_storage WHERE charidentifier = ? AND town_key = ?', {charid, townKey})
    if rows and rows[1] then
        return rows[1].slots
    end
    local base = Config.BaseSlots
    MySQL.insert.await('INSERT INTO hhrp_town_storage (charidentifier, town_key, slots) VALUES (?, ?, ?)', {charid, townKey, base})
    return base
end

local function setSlots(source, townKey, slots)
    local charid = getCharId(source); if not charid then return end
    MySQL.update.await('UPDATE hhrp_town_storage SET slots = ? WHERE charidentifier = ? AND town_key = ?', {slots, charid, townKey})
end

-- Create/open per-character, per-town inventory using the API
local function openTownInventory(source, townKey, slots)
    local charid = getCharId(source); if not charid then return end
    local invId = ('town:%s:%s'):format(townKey, charid)

    if not VorpInv then
        TriggerClientEvent('biggies_storage:notify', source, 'error', 'vorp_inventoryApi() missing. Please update vorp_inventory.')
        return
    end

    -- Register custom inventory (id, name, limit, acceptWeapons, shared, ignoreItemStackLimit, whitelistItems, UsePermissions, UseBlackList, whitelistWeapons)
    VorpInv.registerInventory(invId, invId, slots, false, false, false, false, false, false, false)
    VorpInv.OpenInv(source, invId)
end

-- Client wants to know current slots to open an input
RegisterNetEvent('biggies_storage:requestCurrentSlots')
AddEventHandler('biggies_storage:requestCurrentSlots', function(townKey)
    local _src = source
    local current = getOrCreateStorage(_src, townKey) or Config.BaseSlots
    TriggerClientEvent('biggies_storage:openUpgradeInput', _src, townKey, current, Config.MaxSlots)
end)

-- Chat fallback: track town context
RegisterNetEvent('biggies_storage:trackUpgradeContext')
AddEventHandler('biggies_storage:trackUpgradeContext', function(townKey)
    pendingTownForChat[source] = townKey
end)

-- Actual upgrade with provided amount
RegisterNetEvent('biggies_storage:upgradeWithAmount')
AddEventHandler('biggies_storage:upgradeWithAmount', function(townKey, amount)
    local _src = source
    amount = tonumber(amount or 0) or 0
    if amount <= 0 then return end

    local current = getOrCreateStorage(_src, townKey)
    if not current then return end

    if current >= Config.MaxSlots then
        TriggerClientEvent('biggies_storage:notify', _src, 'error', Lang.AlreadyMax)
        return
    end

    local maxAdd = Config.MaxSlots - current
    if amount > maxAdd then amount = maxAdd end

    local cost = math.floor((amount * Config.PricePerSlot) * 100 + 0.5) / 100.0
    if not chargePlayer(_src, cost) then
        TriggerClientEvent('biggies_storage:notify', _src, 'error', Lang.NotEnoughFunds)
        return
    end

    local newSlots = current + amount
    if newSlots > Config.MaxSlots then newSlots = Config.MaxSlots end
    setSlots(_src, townKey, newSlots)

    -- Update live capacity if inventory exists
    if VorpInv and VorpInv.updateCustomInventorySlots then
        local charid = getCharId(_src)
        if charid then
            local invId = ('town:%s:%s'):format(townKey, charid)
            VorpInv.updateCustomInventorySlots(invId, newSlots)
        end
    end

    TriggerClientEvent('biggies_storage:notify', _src, 'success', (Lang.Upgraded):format(amount, cost))
end)

RegisterCommand('upgslots', function(source, args)
    local townKey = pendingTownForChat[source]
    if not townKey then
        TriggerClientEvent('biggies_storage:notify', source, 'error', 'No pending upgrade. Talk to a storage clerk first.')
        return
    end
    local amount = tonumber(args[1] or 0) or 0
    if amount <= 0 then
        TriggerClientEvent('biggies_storage:notify', source, 'error', 'Enter a valid number.')
        return
    end
    TriggerEvent('biggies_storage:upgradeWithAmount', townKey, amount)
    pendingTownForChat[source] = nil
end, false)

RegisterNetEvent('biggies_storage:openStorage')
AddEventHandler('biggies_storage:openStorage', function(townKey)
    local _src = source
    local slots = getOrCreateStorage(_src, townKey)
    openTownInventory(_src, townKey, slots)
end)
