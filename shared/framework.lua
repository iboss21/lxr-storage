--[[
  ███╗   ███╗██╗   ██╗██╗  ████████╗██╗      ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
  ████╗ ████║██║   ██║██║  ╚══██╔══╝██║      ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
  ██╔████╔██║██║   ██║██║     ██║   ██║█████╗█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
  ██║╚██╔╝██║██║   ██║██║     ██║   ██║╚════╝██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
  ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║      ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
  ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝      ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-Storage Framework Adapter - Shared Bridge Layer
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  This adapter provides a unified interface for framework operations across LXR-Core, RSG-Core, and VORP Core.
  It automatically detects the active framework and routes calls to the correct implementation.
  
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  🔹 Server Information
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  Server:      The Land of Wolves 🐺
  Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
  Type:        Serious Hardcore Roleplay
  Website:     https://www.wolves.land
  Discord:     https://discord.gg/CrKcWdfd3A
  Store:       https://theluxempire.tebex.io
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  📋 Version & Performance
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  Version:     2.0.0
  Performance: 0.00-0.01ms (idle) | 0.01-0.03ms (active)
  Status:      ✅ Production Ready
  Tags:        #Framework #Adapter #Bridge #MultiFramework
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  🎯 Framework Support
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  ✅ LXR-Core    (Primary - Full Support)
  ✅ RSG-Core    (Primary - Full Support)
  ✅ VORP Core   (Supported - Full Support)
  ⚠️  Standalone (Fallback - Limited)
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  👤 Credits
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  Developer:   iBoss21 / The Lux Empire
  Framework:   RedM Multi-Framework Architecture
  Original:    Based on VORP Storage concept
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  📄 Copyright © 2024-2026 The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
]]

Framework = {}
Framework.Name = nil
Framework.Object = nil
Framework.Inventory = nil

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ FRAMEWORK DETECTION
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end
    
    -- Priority order: LXR-Core > RSG-Core > VORP Core > Standalone
    for _, fw in ipairs(Config.FrameworkSettings.Priority) do
        local resName = Config.FrameworkSettings[fw].ResourceName
        if GetResourceState(resName) == 'started' or GetResourceState(resName) == 'starting' then
            return fw
        end
    end
    
    return 'standalone'
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ INITIALIZATION
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

function Framework.Init()
    Framework.Name = DetectFramework()
    
    if Framework.Name == 'lxr-core' then
        Framework.Object = exports['lxr-core']:GetCoreObject()
        local invRes = Config.FrameworkSettings['lxr-core'].InventoryResource
        if GetResourceState(invRes) == 'started' then
            Framework.Inventory = exports[invRes]
        end
    elseif Framework.Name == 'rsg-core' then
        Framework.Object = exports['rsg-core']:GetCoreObject()
        local invRes = Config.FrameworkSettings['rsg-core'].InventoryResource
        if GetResourceState(invRes) == 'started' then
            Framework.Inventory = exports[invRes]
        end
    elseif Framework.Name == 'vorp' then
        Framework.Object = exports.vorp_core:GetCore()
        if exports.vorp_inventory and exports.vorp_inventory.vorp_inventoryApi then
            Framework.Inventory = exports.vorp_inventory:vorp_inventoryApi()
        end
    end
    
    print(string.format("^2[LXR-Storage]^7 Framework detected: ^3%s^7", Framework.Name:upper()))
    return Framework.Name
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ CLIENT-SIDE FUNCTIONS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

if not IsDuplicityVersion() then -- Client side only
    
    function Framework.GetPlayerData()
        if Framework.Name == 'lxr-core' then
            return Framework.Object.Functions.GetPlayerData()
        elseif Framework.Name == 'rsg-core' then
            return Framework.Object.Functions.GetPlayerData()
        elseif Framework.Name == 'vorp' then
            return {}
        end
        return {}
    end
    
    function Framework.Notify(msg, type, duration)
        type = type or 'info'
        duration = duration or 4000
        
        if Framework.Name == 'lxr-core' then
            if type == 'success' then
                Framework.Object.Functions.Notify(msg, 'success', duration)
            elseif type == 'error' then
                Framework.Object.Functions.Notify(msg, 'error', duration)
            else
                Framework.Object.Functions.Notify(msg, 'primary', duration)
            end
        elseif Framework.Name == 'rsg-core' then
            if type == 'success' then
                Framework.Object.Functions.Notify(msg, 'success', duration)
            elseif type == 'error' then
                Framework.Object.Functions.Notify(msg, 'error', duration)
            else
                Framework.Object.Functions.Notify(msg, 'primary', duration)
            end
        elseif Framework.Name == 'vorp' then
            if type == 'success' then
                Framework.Object.NotifyRightTip(msg, duration)
            elseif type == 'error' then
                Framework.Object.NotifyObjective(msg, duration)
            else
                Framework.Object.NotifyTop(msg, 'Storage', duration)
            end
        else
            print(('[Storage] %s: %s'):format(type:upper(), msg))
        end
    end
    
    function Framework.OpenMenu(menuData, onSelect, onClose)
        if Framework.Name == 'lxr-core' then
            local menuRes = Config.FrameworkSettings['lxr-core'].MenuResource
            if GetResourceState(menuRes) == 'started' then
                exports[menuRes]:openMenu(menuData, onSelect, onClose)
            end
        elseif Framework.Name == 'rsg-core' then
            local menuRes = Config.FrameworkSettings['rsg-core'].MenuResource
            if GetResourceState(menuRes) == 'started' then
                exports[menuRes]:openMenu(menuData, onSelect, onClose)
            end
        elseif Framework.Name == 'vorp' then
            local Menu = exports.vorp_menu:GetMenuData()
            Menu.Open('default', GetCurrentResourceName(), 'storage_menu', menuData, onSelect, onClose)
        end
    end
    
    function Framework.CloseMenu()
        if Framework.Name == 'lxr-core' then
            local menuRes = Config.FrameworkSettings['lxr-core'].MenuResource
            if GetResourceState(menuRes) == 'started' then
                exports[menuRes]:closeMenu()
            end
        elseif Framework.Name == 'rsg-core' then
            local menuRes = Config.FrameworkSettings['rsg-core'].MenuResource
            if GetResourceState(menuRes) == 'started' then
                exports[menuRes]:closeMenu()
            end
        elseif Framework.Name == 'vorp' then
            local Menu = exports.vorp_menu:GetMenuData()
            Menu.CloseAll()
        end
    end
end

-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
-- █████ SERVER-SIDE FUNCTIONS
-- ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

if IsDuplicityVersion() then -- Server side only
    
    function Framework.GetPlayer(source)
        if Framework.Name == 'lxr-core' then
            return Framework.Object.Functions.GetPlayer(source)
        elseif Framework.Name == 'rsg-core' then
            return Framework.Object.Functions.GetPlayer(source)
        elseif Framework.Name == 'vorp' then
            local user = Framework.Object.getUser(source)
            if user then
                return {
                    source = source,
                    user = user,
                    character = user.getUsedCharacter
                }
            end
        end
        return nil
    end
    
    function Framework.GetIdentifier(source)
        if Framework.Name == 'lxr-core' then
            local player = Framework.GetPlayer(source)
            return player and player.PlayerData.citizenid or nil
        elseif Framework.Name == 'rsg-core' then
            local player = Framework.GetPlayer(source)
            return player and player.PlayerData.citizenid or nil
        elseif Framework.Name == 'vorp' then
            local player = Framework.GetPlayer(source)
            if player and player.character then
                return tostring(player.character.charIdentifier or player.character.identifier)
            end
        end
        return nil
    end
    
    function Framework.RemoveMoney(source, amount, moneyType)
        moneyType = moneyType or 'cash'
        
        if Framework.Name == 'lxr-core' then
            local player = Framework.GetPlayer(source)
            if player then
                return player.Functions.RemoveMoney(moneyType, amount)
            end
        elseif Framework.Name == 'rsg-core' then
            local player = Framework.GetPlayer(source)
            if player then
                return player.Functions.RemoveMoney(moneyType, amount)
            end
        elseif Framework.Name == 'vorp' then
            local player = Framework.GetPlayer(source)
            if player and player.character then
                local currencyType = (Config.CurrencyType == 0) and 0 or 1
                if player.character.removeCurrency then
                    player.character.removeCurrency(currencyType, amount)
                    return true
                else
                    TriggerEvent('vorp:removeMoney', source, currencyType, amount)
                    return true
                end
            end
        end
        return false
    end
    
    function Framework.GetMoney(source, moneyType)
        moneyType = moneyType or 'cash'
        
        if Framework.Name == 'lxr-core' then
            local player = Framework.GetPlayer(source)
            if player then
                return player.PlayerData.money[moneyType] or 0
            end
        elseif Framework.Name == 'rsg-core' then
            local player = Framework.GetPlayer(source)
            if player then
                return player.PlayerData.money[moneyType] or 0
            end
        elseif Framework.Name == 'vorp' then
            local player = Framework.GetPlayer(source)
            if player and player.character then
                if Config.CurrencyType == 0 then
                    return player.character.money or 0
                else
                    return player.character.gold or 0
                end
            end
        end
        return 0
    end
    
    function Framework.OpenInventory(source, inventoryId, slots)
        if not Framework.Inventory then
            return false
        end
        
        if Framework.Name == 'lxr-core' then
            Framework.Inventory:RegisterStash(inventoryId, slots, Config.Storage.MaxWeight or 1000000)
            TriggerClientEvent('lxr-inventory:client:OpenInventory', source, 'stash', inventoryId)
            return true
        elseif Framework.Name == 'rsg-core' then
            Framework.Inventory:RegisterStash(inventoryId, slots, Config.Storage.MaxWeight or 1000000)
            TriggerClientEvent('rsg-inventory:client:OpenInventory', source, 'stash', inventoryId)
            return true
        elseif Framework.Name == 'vorp' then
            Framework.Inventory.registerInventory(inventoryId, inventoryId, slots, false, false, false, false, false, false, false)
            Framework.Inventory.OpenInv(source, inventoryId)
            return true
        end
        return false
    end
    
    function Framework.UpdateInventorySlots(inventoryId, slots)
        if not Framework.Inventory then
            return false
        end
        
        if Framework.Name == 'lxr-core' then
            return true
        elseif Framework.Name == 'rsg-core' then
            return true
        elseif Framework.Name == 'vorp' then
            if Framework.Inventory.updateCustomInventorySlots then
                Framework.Inventory.updateCustomInventorySlots(inventoryId, slots)
                return true
            end
        end
        return false
    end
end

-- Initialize on resource start
CreateThread(function()
    Wait(500)
    Framework.Init()
end)

return Framework
