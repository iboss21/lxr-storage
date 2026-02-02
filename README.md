```
  ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗   ██╗███████╗███████╗
  ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║   ██║██╔════╝██╔════╝
  ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║   ██║█████╗  ███████╗
  ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝   ██║██╔══╝  ╚════██║
  ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝    ╚██╗███████╗███████║
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝      ╚═╝╚══════╝╚══════╝
```

```
  ██╗     ██╗  ██╗██████╗       ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗
  ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝
  ██║      ╚███╔╝ ██████╔╝█████╗███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗  
  ██║      ██╔██╗ ██╔══██╗╚════╝╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝  
  ███████╗██╔╝ ██╗██║  ██║      ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
```

<div align="center">

# 🐺 LXR-Storage
### Multi-Framework Storage System for RedM

**Advanced per-town storage solution with upgradeable slots**  
*Supporting LXR-Core, RSG-Core, and VORP Core*

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/iBoss21/lxr-storage)
[![Framework](https://img.shields.io/badge/framework-Multi--Framework-green.svg)](#framework-support)
[![License](https://img.shields.io/badge/license-Custom-red.svg)](LICENSE)
[![RedM](https://img.shields.io/badge/RedM-Ready-orange.svg)](https://redm.gg)

</div>

```
═══════════════════════════════════════════════════════════════════════════════════════════
🔹 SERVER INFORMATION
═══════════════════════════════════════════════════════════════════════════════════════════
Server:      The Land of Wolves 🐺
Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
Type:        Serious Hardcore Roleplay
Access:      Discord & Whitelisted
Website:     https://www.wolves.land
Discord:     https://discord.gg/CrKcWdfd3A
Store:       https://theluxempire.tebex.io
Listing:     https://servers.redm.net/servers/detail/8gj7eb
Developer:   iBoss21 / The Lux Empire
═══════════════════════════════════════════════════════════════════════════════════════════
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 📋 OVERVIEW
## ████████████████████████████████████████████████████████████████████████████████████████

LXR-Storage is a sophisticated multi-framework storage system designed for RedM servers. It provides independent storage facilities in multiple towns across the map, each with its own upgradeable slot capacity. Built with performance, security, and flexibility in mind.

### 🎯 Key Features

- **🏙️ Multi-Town Independent Storage** - 9 configured town locations with separate inventories
- **📦 Upgradeable Slots** - Base 200 slots, expandable up to 10,000 slots per town
- **💰 Economy Integration** - $0.30 per slot upgrade with configurable pricing
- **🔄 Multi-Framework Support** - LXR-Core, RSG-Core, VORP Core with auto-detection
- **🔒 Server-Side Security** - All validation and slot management on server
- **⚡ Performance Optimized** - 0.00-0.01ms idle, 0.02-0.05ms active
- **👤 Character-Specific** - Each character has individual slot upgrades per town
- **🗺️ Map Integration** - Blips and NPCs at all storage locations
- **🌍 Fully Localized** - Multi-language support system

### 📊 Technical Specifications

| Specification | Value |
|--------------|-------|
| **Base Slots** | 200 per town |
| **Max Slots** | 10,000 per town |
| **Price Per Slot** | $0.30 (configurable) |
| **Town Locations** | 9 configured |
| **Performance** | <0.01ms idle |
| **Framework** | Multi-framework compatible |
| **Database** | MySQL (oxmysql) |
| **Resource Name** | `lxr-storage` (must not be renamed) |

## ████████████████████████████████████████████████████████████████████████████████████████
## 🏗️ FRAMEWORK SUPPORT
## ████████████████████████████████████████████████████████████████████████████████████████

LXR-Storage automatically detects and adapts to your server's framework:

| Framework | Status | Inventory | Menu System |
|-----------|--------|-----------|-------------|
| **LXR-Core** | ✅ Full Support | lxr-inventory | lxr-menu |
| **RSG-Core** | ✅ Full Support | rsg-inventory | rsg-menu |
| **VORP Core** | ✅ Full Support | vorp_inventory | vorp_menu |
| **Standalone** | ⚠️ Fallback | Limited | Limited |

### Automatic Detection Priority
1. LXR-Core (Primary)
2. RSG-Core (Primary)
3. VORP Core (Supported)
4. Standalone (Fallback)

## ████████████████████████████████████████████████████████████████████████████████████████
## 🗺️ CONFIGURED LOCATIONS
## ████████████████████████████████████████████████████████████████████████████████████████

All storage locations come pre-configured with NPCs and map blips:

| # | Town | Location | NPC | Blip |
|---|------|----------|-----|------|
| 1 | **Valentine** | Train Station Area | ✅ | ✅ |
| 2 | **Saint Denis** | Commercial District | ✅ | ✅ |
| 3 | **Blackwater** | Town Center | ✅ | ✅ |
| 4 | **Rhodes** | Main Street | ✅ | ✅ |
| 5 | **Strawberry** | General Store Area | ✅ | ✅ |
| 6 | **Annesburg** | Mining District | ✅ | ✅ |
| 7 | **Van Horn** | Trading Post | ✅ | ✅ |
| 8 | **Tumbleweed** | Desert Outpost | ✅ | ✅ |
| 9 | **Armadillo** | Western Settlement | ✅ | ✅ |

Each location operates independently with its own storage inventory.

## ████████████████████████████████████████████████████████████████████████████████████████
## 🚀 QUICK START
## ████████████████████████████████████████████████████████████████████████████████████████

### Installation (5 Minutes)

1. **Download & Extract**
   ```bash
   # Extract to your resources folder as 'lxr-storage'
   # DO NOT RENAME - Resource name must be exactly 'lxr-storage'
   ```

2. **Database Setup**
   ```bash
   # Import SQL file
   mysql -u username -p database_name < sql/storage.sql
   ```

3. **Server Configuration**
   ```lua
   -- Add to server.cfg
   ensure oxmysql
   ensure lxr-storage
   ```

4. **Verify Installation**
   - Start server
   - Check console for: `[LXR-Storage] Framework detected: [FRAMEWORK]`
   - Visit any town storage location
   - Test opening storage and upgrading slots

### Basic Configuration

```lua
-- config/config.lua

Config.Storage = {
    BaseSlots       = 200,      -- Starting slots
    MaxSlots        = 10000,    -- Maximum slots
    PricePerSlot    = 0.30,     -- Price per slot
}

Config.CurrencyName = 'cash'    -- 'cash' or 'gold'
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 📚 DOCUMENTATION
## ████████████████████████████████████████████████████████████████████████████████████████

Comprehensive documentation is available in the `docs/` folder:

| Document | Description |
|----------|-------------|
| [📖 Overview](docs/overview.md) | System architecture and features |
| [⚙️ Installation](docs/installation.md) | Step-by-step installation guide |
| [🔧 Configuration](docs/configuration.md) | Complete configuration reference |
| [🎮 Frameworks](docs/frameworks.md) | Framework integration details |
| [📡 Events](docs/events.md) | Event system and triggers |
| [🔒 Security](docs/security.md) | Security features and validation |
| [⚡ Performance](docs/performance.md) | Optimization and benchmarks |
| [📸 Screenshots](docs/screenshots.md) | Visual showcase |

### Component Documentation

- [Client Side](client/README.md) - Client-side implementation
- [Server Side](server/README.md) - Server-side logic
- [Shared Code](shared/README.md) - Framework bridge

## ████████████████████████████████████████████████████████████████████████████████████████
## 💼 USAGE
## ████████████████████████████████████████████████████████████████████████████████████████

### For Players

1. **Access Storage**
   - Visit any storage location (marked on map)
   - Press `G` near the storage clerk
   - Select "Open Storage" from menu

2. **Upgrade Storage**
   - Access storage menu
   - Select "Upgrade Storage"
   - Enter desired number of slots
   - Confirm purchase

3. **Storage Per Town**
   - Each town has independent storage
   - Upgrades apply to current character only
   - Storage is not shared between towns

### For Administrators

```lua
-- Check player's storage slots for a specific town
exports['lxr-storage']:GetPlayerSlots(source, townKey)

-- Set player's storage slots (admin command)
exports['lxr-storage']:SetPlayerSlots(source, townKey, slots)

-- Get all towns data
exports['lxr-storage']:GetAllTowns()
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🔧 CUSTOMIZATION
## ████████████████████████████████████████████████████████████████████████████████████████

### Add New Locations

```lua
-- config/config.lua
Config.Towns = {
    -- ... existing towns ...
    {
        key     = 'newtown',
        label   = 'New Town Storage',
        coords  = vector3(100.0, 200.0, 300.0),
        heading = 90.0,
        npc     = 'u_m_m_vhtstationclerk_01'
    }
}
```

### Modify Pricing

```lua
Config.Storage = {
    BaseSlots       = 200,      -- Change starting slots
    MaxSlots        = 10000,    -- Change maximum slots
    PricePerSlot    = 0.50,     -- Change price per slot
}
```

### Change Currency

```lua
Config.CurrencyType = 1           -- Gold instead of cash
Config.CurrencyName = 'gold'      -- For LXR/RSG frameworks
```

### Localization

Create new language files in `locales/` folder:

```lua
-- locales/es.lua
Lang.StorageTitle = 'Almacenamiento Municipal'
Lang.OpenStorage = 'Abrir Almacenamiento'
-- ... more translations ...
```

## ████████████████████████████████████████████████████████████████████████████████████████
## ⚡ PERFORMANCE
## ████████████████████████████████████████████████████████████████████████████████████████

### Resource Impact

| State | CPU Usage | Memory |
|-------|-----------|--------|
| **Idle** | 0.00-0.01ms | ~2MB |
| **Active** | 0.02-0.05ms | ~3MB |
| **Peak** | <0.10ms | ~4MB |

### Optimization Features

- ✅ Server-side caching for slot data
- ✅ Efficient database queries with prepared statements
- ✅ Client-side distance checks for NPC spawning
- ✅ Lazy loading of storage inventories
- ✅ Optimized blip and prompt management

## ████████████████████████████████████████████████████████████████████████████████████████
## 🔒 SECURITY FEATURES
## ████████████████████████████████████████████████████████████████████████████████████████

### Built-In Protection

- ✅ **Server-Side Validation** - All transactions validated on server
- ✅ **SQL Injection Protection** - Parameterized queries with oxmysql
- ✅ **Money Validation** - Checks player funds before upgrades
- ✅ **Slot Limit Enforcement** - Maximum slot limits enforced server-side
- ✅ **Character Verification** - Player identity confirmed for all operations
- ✅ **Resource Name Protection** - Must be named 'lxr-storage' to function
- ✅ **Anti-Duplication** - Prevents inventory duplication exploits

## ████████████████████████████████████████████████████████████████████████████████████████
## 📦 DEPENDENCIES
## ████████████████████████████████████████████████████████████████████████████████████████

### Required
- **oxmysql** - Database operations
- **Framework** - One of: lxr-core, rsg-core, or vorp_core

### Optional (Framework-Dependent)
- **lxr-inventory** / **rsg-inventory** / **vorp_inventory** - Inventory system
- **lxr-menu** / **rsg-menu** / **vorp_menu** - Menu system

## ████████████████████████████████████████████████████████████████████████████████████████
## 🐛 TROUBLESHOOTING
## ████████████████████████████████████████████████████████████████████████████████████████

### Common Issues

**❌ Resource fails to start**
- ✅ Ensure resource name is exactly `lxr-storage`
- ✅ Check oxmysql is started before lxr-storage
- ✅ Verify database tables are created

**❌ Storage doesn't open**
- ✅ Check framework is properly detected (see console)
- ✅ Verify inventory resource is running
- ✅ Ensure player is close enough to NPC

**❌ Upgrades not working**
- ✅ Check player has enough money
- ✅ Verify currency type configuration matches framework
- ✅ Check database connection

**❌ NPCs not spawning**
- ✅ Verify `Config.General.EnableNPCs = true`
- ✅ Check model hashes are valid
- ✅ Ensure player is within spawn range

## ████████████████████████████████████████████████████████████████████████████████████████
## 🔄 VERSION HISTORY
## ████████████████████████████████████████████████████████████████████████████████████████

### Version 2.0.0 (Current)
- ✅ Multi-framework architecture
- ✅ Automatic framework detection
- ✅ Per-town independent storage
- ✅ Upgradeable slot system
- ✅ Complete security overhaul
- ✅ Performance optimization
- ✅ 9 pre-configured locations
- ✅ Full documentation

## ████████████████████████████████████████████████████████████████████████████████████████
## 🤝 SUPPORT
## ████████████████████████████████████████████████████████████████████████████████████████

### Get Help

- **Discord**: [Join our Discord](https://discord.gg/CrKcWdfd3A)
- **GitHub**: [Report Issues](https://github.com/iBoss21/lxr-storage/issues)
- **Website**: [wolves.land](https://www.wolves.land)
- **Store**: [The Lux Empire Store](https://theluxempire.tebex.io)

### Server Information

Visit **The Land of Wolves** - A serious hardcore roleplay experience:
- 🇬🇪 Georgian RP server with English support
- 🎭 Serious roleplay with immersive economy
- 🔐 Discord and whitelist required
- 🌟 Active development and custom scripts

## ████████████████████████████████████████████████████████████████████████████████████████
## 📜 LICENSE & CREDITS
## ████████████████████████████████████████████████████████████████████████████████████████

```
Copyright © 2024-2026 The Lux Empire | wolves.land

Developer:   iBoss21 / The Lux Empire
Concept:     Multi-town storage with upgrade mechanics
Framework:   RedM Multi-Framework Architecture
Inspired by: VORP Storage system
```

### 👨‍💻 Developer
**iBoss21 / The Lux Empire**
- GitHub: [@iBoss21](https://github.com/iBoss21)
- Store: [theluxempire.tebex.io](https://theluxempire.tebex.io)

### 🎮 Server
**The Land of Wolves 🐺**
- Type: Serious Hardcore Roleplay
- Language: Georgian RP 🇬🇪 with English support
- Tagline: მგლების მიწა - რჩეულთა ადგილი!
- Motto: ისტორია ცოცხლდება აქ! (History Lives Here!)

## ████████████████████████████████████████████████████████████████████████████████████████
## 🌟 FEATURES AT A GLANCE
## ████████████████████████████████████████████████████████████████████████████████████████

```
✅ Multi-Framework Support      ✅ 9 Town Locations          ✅ Upgradeable Slots
✅ Auto Framework Detection     ✅ Independent Storage       ✅ Economy Integration
✅ Server-Side Security         ✅ NPC Interactions          ✅ Map Blips
✅ Performance Optimized        ✅ Character-Specific        ✅ Fully Documented
✅ Database Caching             ✅ Localization System       ✅ Easy Configuration
✅ SQL Injection Protection     ✅ Admin Commands            ✅ Export Functions
```

---

<div align="center">

**Made with ❤️ by The Lux Empire**

[Website](https://www.wolves.land) • [Discord](https://discord.gg/CrKcWdfd3A) • [Store](https://theluxempire.tebex.io) • [GitHub](https://github.com/iBoss21)

**🐺 The Land of Wolves - Where History Lives! 🐺**

</div>
