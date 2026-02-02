```
  ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗   ██╗███████╗███████╗
  ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║   ██║██╔════╝██╔════╝
  ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║   ██║█████╗  ███████╗
  ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝   ██║██╔══╝  ╚════██║
  ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝    ╚██╗███████╗███████║
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝      ╚═╝╚══════╝╚══════╝
```

# 📖 LXR-Storage System Overview

```
═══════════════════════════════════════════════════════════════════════════════════════════
🔹 SERVER INFORMATION
═══════════════════════════════════════════════════════════════════════════════════════════
Server:      The Land of Wolves 🐺
Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
Website:     https://www.wolves.land
Discord:     https://discord.gg/CrKcWdfd3A
Developer:   iBoss21 / The Lux Empire
═══════════════════════════════════════════════════════════════════════════════════════════
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🎯 SYSTEM ARCHITECTURE
## ████████████████████████████████████████████████████████████████████████████████████████

LXR-Storage is built on a three-tier architecture designed for maximum flexibility, security, and performance:

### Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                              │
│  • NPC Management & Spawning                                     │
│  • Blip Creation & Display                                       │
│  • Interaction Prompts                                           │
│  • Menu System Integration                                       │
│  • Distance Checks & Optimization                                │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Events & Network Calls
┌──────────────────────▼──────────────────────────────────────────┐
│                       SHARED LAYER                               │
│  • Framework Detection & Initialization                          │
│  • Framework Abstraction Bridge                                  │
│  • Unified API for Multi-Framework Support                       │
│  • Configuration Loading                                         │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Framework API Calls
┌──────────────────────▼──────────────────────────────────────────┐
│                       SERVER LAYER                               │
│  • Storage Slot Management                                       │
│  • Database Operations (oxmysql)                                 │
│  • Security & Validation                                         │
│  • Economy Integration                                           │
│  • Inventory System Integration                                  │
│  • Caching & Performance                                         │
└─────────────────────────────────────────────────────────────────┘
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🏗️ CORE COMPONENTS
## ████████████████████████████████████████████████████████████████████████████████████████

### 1. Framework Bridge System (`shared/framework.lua`)

The framework bridge provides a unified interface across all supported frameworks:

**Features:**
- Automatic framework detection on resource start
- Priority-based framework selection (LXR → RSG → VORP → Standalone)
- Abstracted API for framework-specific operations
- Client and server-side implementations
- Graceful fallback to standalone mode

**Supported Operations:**
```lua
-- Client-Side
Framework.GetPlayerData()     -- Get player data from framework
Framework.Notify()            -- Send notifications
Framework.OpenMenu()          -- Open menu systems
Framework.CloseMenu()         -- Close menu systems

-- Server-Side
Framework.GetPlayer()         -- Get player object
Framework.GetIdentifier()     -- Get character identifier
Framework.RemoveMoney()       -- Remove money from player
Framework.GetMoney()          -- Get player's money
Framework.OpenInventory()     -- Open storage inventory
Framework.UpdateInventorySlots() -- Update inventory slot count
```

### 2. Storage Management System (`server/server.lua`)

Handles all storage-related operations with server-side security:

**Core Functions:**
- **Slot Tracking** - Maintains per-character slot counts for each town
- **Upgrade System** - Processes slot purchase requests with validation
- **Database Integration** - CRUD operations with oxmysql
- **Caching Layer** - In-memory cache for frequently accessed data
- **Security Validation** - Server-side checks for all operations

**Database Schema:**
```sql
CREATE TABLE IF NOT EXISTS `lxr_storage_slots` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `town_key` VARCHAR(50) NOT NULL,
    `slots` INT NOT NULL DEFAULT 200,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_player_town` (`identifier`, `town_key`)
);
```

### 3. Client Interaction System (`client/client.lua`)

Manages all client-side interactions and visual elements:

**Features:**
- **NPC Spawning** - Spawns storage clerks at configured locations
- **Blip Management** - Creates and maintains map markers
- **Interaction Prompts** - RedM native prompts for player interaction
- **Distance Optimization** - Only spawns/renders nearby elements
- **Menu Integration** - Framework-specific menu handling

**User Flow:**
1. Player approaches storage location
2. NPC spawns when within render distance
3. Prompt appears when within interaction distance
4. Player presses interaction key (G)
5. Menu opens with storage options
6. Player selects action (Open/Upgrade)
7. Server processes request
8. Inventory or upgrade confirmation shown

## ████████████████████████████████████████████████████████████████
## 💾 DATA FLOW
## ████████████████████████████████████████████████████████████████

### Opening Storage Workflow

```
[Client] Player presses G near clerk
    ↓
[Client] Request menu open → Server
    ↓
[Server] Get player identifier via Framework
    ↓
[Server] Query database for player's slot count for this town
    ↓
[Server] Cache result (if not already cached)
    ↓
[Server] Return slot count → Client
    ↓
[Client] Display menu with Open/Upgrade options
    ↓
[Client] Player selects "Open Storage"
    ↓
[Client] Notify server to open inventory
    ↓
[Server] Register/update inventory with slot count
    ↓
[Server] Call Framework.OpenInventory()
    ↓
[Framework] Opens inventory UI with specified slots
```

### Upgrading Slots Workflow

```
[Client] Player selects "Upgrade Storage"
    ↓
[Client] Display current/max slots in menu
    ↓
[Client] Prompt player for number of slots to add
    ↓
[Client] Send upgrade request to server with amount
    ↓
[Server] Validate request:
    ├─ Player exists?
    ├─ Valid slot amount?
    ├─ Within max limit?
    ├─ Player has enough money?
    └─ No exploit attempts?
    ↓
[Server] If valid:
    ├─ Calculate cost (slots × price_per_slot)
    ├─ Framework.RemoveMoney() from player
    ├─ Update database with new slot count
    ├─ Update cache
    ├─ Send success notification → Client
    └─ Update inventory slot limit if currently open
    ↓
[Client] Display success message with details
```

## ████████████████████████████████████████████████████████████████
## 🔐 SECURITY ARCHITECTURE
## ████████████████████████████████████████████████████████████████

### Multi-Layer Security Model

**Layer 1: Resource Name Protection**
- Enforced resource name check on load
- Prevents renamed/modified versions
- Error and halt if name doesn't match 'lxr-storage'

**Layer 2: Server-Side Validation**
```lua
-- All critical operations validated server-side
✅ Player existence verification
✅ Character identifier validation
✅ Slot amount boundary checks (min/max)
✅ Money availability verification
✅ Currency type validation
✅ Database transaction integrity
✅ SQL injection prevention (parameterized queries)
```

**Layer 3: Framework Integration Security**
- Uses official framework APIs for money operations
- No direct database manipulation for player data
- Character authentication through framework

**Layer 4: Database Security**
```sql
-- Unique constraints prevent duplicate entries
UNIQUE KEY `unique_player_town` (`identifier`, `town_key`)

-- Timestamp tracking for audit trail
`created_at` and `updated_at` columns

-- Prepared statements prevent SQL injection
MySQL.prepare.await() with parameterized queries
```

## ████████████████████████████████████████████████████████████████
## ⚡ PERFORMANCE OPTIMIZATION
## ████████████████████████████████████████████████████████████████

### Client-Side Optimizations

**Distance-Based Rendering**
```lua
-- NPCs only spawn within render distance
-- Prompts only active within interaction distance
-- Continuous distance checks at efficient intervals
```

**Lazy Loading**
- Blips created once on resource start
- NPCs spawned on-demand when player approaches
- Menu data fetched only when needed

**Thread Efficiency**
```lua
-- Idle: Checks every 1000ms when no players nearby
-- Active: Checks every 500ms when players in range
-- Adaptive polling based on player proximity
```

### Server-Side Optimizations

**Caching Strategy**
```lua
-- In-memory cache for slot data
PlayerSlotCache = {}

-- Cache hit: Returns instantly from memory
-- Cache miss: Queries database, then caches result
-- Cache invalidation: On slot upgrades
```

**Database Efficiency**
```lua
-- Prepared statements reduce parsing overhead
-- Single query per operation (no N+1 problems)
-- Batch operations where possible
-- Indexed unique keys for fast lookups
```

**Memory Management**
- Cache cleared on player logout
- Periodic cleanup of stale cache entries
- Efficient data structures (hash tables for O(1) lookup)

### Performance Metrics

| Operation | Server CPU | Client CPU | Network |
|-----------|------------|------------|---------|
| **Idle (no interaction)** | 0.00ms | 0.00-0.01ms | 0 |
| **NPC proximity check** | 0.00ms | 0.01ms | 0 |
| **Opening menu** | 0.01ms | 0.02ms | ~200 bytes |
| **Opening storage** | 0.02ms | 0.03ms | ~500 bytes |
| **Upgrading slots (cached)** | 0.03ms | 0.02ms | ~300 bytes |
| **Upgrading slots (db query)** | 0.05ms | 0.02ms | ~300 bytes |

## ████████████████████████████████████████████████████████████████
## 🌍 MULTI-FRAMEWORK ABSTRACTION
## ████████████████████████████████████████████████████████████████

### Framework Detection Process

```lua
1. Check Config.Framework setting
   ├─ If 'auto': Proceed to detection
   └─ If specific: Use specified framework

2. Iterate through priority list:
   ├─ Check if lxr-core is started
   ├─ Check if rsg-core is started
   ├─ Check if vorp_core is started
   └─ Fallback to standalone

3. Initialize framework object:
   ├─ Get core object/API
   ├─ Get inventory exports
   └─ Get menu exports

4. Set Framework.Name and Framework.Object

5. Log detected framework to console
```

### Framework-Specific Implementations

**LXR-Core**
```lua
Framework.Object = exports['lxr-core']:GetCoreObject()
PlayerData = Framework.Object.Functions.GetPlayerData()
Identifier = PlayerData.citizenid
Money = PlayerData.money[moneyType]
```

**RSG-Core**
```lua
Framework.Object = exports['rsg-core']:GetCoreObject()
PlayerData = Framework.Object.Functions.GetPlayerData()
Identifier = PlayerData.citizenid
Money = PlayerData.money[moneyType]
```

**VORP Core**
```lua
Framework.Object = exports.vorp_core:GetCore()
Character = User.getUsedCharacter
Identifier = Character.charIdentifier or Character.identifier
Money = Character.money or Character.gold
```

## ████████████████████████████████████████████████████████████████
## 📦 STORAGE INDEPENDENCE MODEL
## ████████████████████████████████████████████████████████████████

### Per-Town Storage Concept

Each town operates as a completely independent storage facility:

```
Player: John_Doe_123
├─ Valentine Storage
│  ├─ Slots: 500
│  └─ Inventory: [items specific to Valentine]
├─ Saint Denis Storage
│  ├─ Slots: 200 (base)
│  └─ Inventory: [items specific to Saint Denis]
├─ Blackwater Storage
│  ├─ Slots: 1000
│  └─ Inventory: [items specific to Blackwater]
└─ ... (7 more towns)
```

**Key Principles:**
- ❌ Items are NOT shared between towns
- ✅ Each town has its own inventory space
- ✅ Slot upgrades are per-character, per-town
- ✅ Player can have different slot counts in each town
- ✅ Provides strategic gameplay value (regional storage)

### Database Structure

```sql
-- Example data showing independence
identifier          | town_key   | slots
--------------------|------------|-------
john_doe_123        | valentine  | 500
john_doe_123        | stdenis    | 200
john_doe_123        | blackwater | 1000
jane_smith_456      | valentine  | 800
jane_smith_456      | rhodes     | 200
```

## ████████████████████████████████████████████████████████████████
## 🔄 UPGRADE ECONOMICS
## ████████████████████████████████████████████████████████████████

### Pricing Model

**Default Configuration:**
- **Base Slots**: 200 (free with any character)
- **Maximum Slots**: 10,000 per town
- **Price Per Slot**: $0.30
- **Upgrade Increments**: Any amount (1 to remaining max)

**Cost Calculation:**
```lua
function CalculateCost(currentSlots, slotsToAdd)
    return slotsToAdd * Config.Storage.PricePerSlot
end

-- Examples:
-- 100 slots = 100 × $0.30 = $30.00
-- 500 slots = 500 × $0.30 = $150.00
-- 1000 slots = 1000 × $0.30 = $300.00
-- 9800 slots (200→10000) = 9800 × $0.30 = $2,940.00
```

### Economic Progression Examples

| Stage | Slots | Cost | Cumulative Cost | Use Case |
|-------|-------|------|----------------|----------|
| **Start** | 200 | $0 | $0 | Basic storage |
| **Early** | 500 | $90 | $90 | Active trading |
| **Mid** | 1,000 | $150 | $240 | Established business |
| **Late** | 2,500 | $450 | $690 | Major merchant |
| **End** | 5,000 | $750 | $1,440 | Storage empire |
| **Max** | 10,000 | $1,500 | $2,940 | Complete upgrade |

### Currency Configuration

**For LXR-Core/RSG-Core:**
```lua
Config.CurrencyName = 'cash'  -- or 'gold'
-- Uses framework's money system directly
```

**For VORP Core:**
```lua
Config.CurrencyType = 0  -- Cash
Config.CurrencyType = 1  -- Gold
-- Maps to VORP's currency system
```

## ████████████████████████████████████████████████████████████████
## 🗺️ LOCATION SYSTEM
## ████████████████████████████████████████████████████████████████

### Town Configuration Structure

```lua
{
    key     = 'valentine',              -- Unique identifier (database key)
    label   = 'Valentine Storage',      -- Display name (UI/blip)
    coords  = vector3(-242.66, 752.26, 117.68),  -- NPC spawn location
    heading = 99.19,                    -- NPC facing direction
    npc     = 'u_m_m_vhtstationclerk_01'  -- NPC model hash
}
```

### All Configured Locations

**1. Valentine** - Train Station District
- Coords: `vector3(-242.66, 752.26, 117.68)`
- Central location, high traffic area

**2. Saint Denis** - Commercial District
- Coords: `vector3(2648.75, -1503.11, 45.97)`
- Major city, business hub

**3. Blackwater** - Town Center
- Coords: `vector3(-877.14, -1341.74, 43.29)`
- Strategic western city

**4. Rhodes** - Main Street
- Coords: `vector3(1428.73, -1320.87, 78.4)`
- Southern trade town

**5. Strawberry** - General Store Area
- Coords: `vector3(-1760.47, -386.16, 157.69)`
- Mountain settlement

**6. Annesburg** - Mining District
- Coords: `vector3(2952.21, 1355.93, 44.87)`
- Industrial mining town

**7. Van Horn** - Trading Post
- Coords: `vector3(3009.36, 559.49, 44.66)`
- Coastal trading port

**8. Tumbleweed** - Desert Outpost
- Coords: `vector3(-5506.15, -2915.04, -2.41)`
- Remote western outpost

**9. Armadillo** - Western Settlement
- Coords: `vector3(-3701.5, -2570.69, -13.72)`
- Desert frontier town

## ████████████████████████████████████████████████████████████████
## 🎮 USER EXPERIENCE DESIGN
## ████████████████████████████████████████████████████████████████

### Interaction Flow

**Visual Indicators:**
1. **Map Blip** - Shows storage location on map from any distance
2. **NPC Appearance** - Clerk spawns when player is within ~50 meters
3. **Interaction Prompt** - "Press G to speak" appears within 5 meters
4. **Menu Display** - Clean menu with clear options

**Menu Structure:**
```
┌─────────────────────────────────┐
│      VALENTINE STORAGE           │
├─────────────────────────────────┤
│ > Open Storage                   │
│   Access your stored items       │
├─────────────────────────────────┤
│ > Upgrade Storage                │
│   Current: 500 | Max: 10,000     │
├─────────────────────────────────┤
│ > Close                          │
└─────────────────────────────────┘
```

### Notification System

**Success Messages:**
- `"Storage opened successfully"`
- `"Storage upgraded! Added 100 slots for $30.00"`

**Error Messages:**
- `"You do not have enough money for this upgrade"`
- `"Your storage is already at maximum capacity"`
- `"Please enter a valid number"`

**Info Messages:**
- `"Current Slots: 500"`
- `"Maximum Slots: 10,000"`

## ████████████████████████████████████████████████████████████████
## 📊 TECHNICAL SPECIFICATIONS
## ████████████████████████████████████████████████████████████████

### Resource Information

| Property | Value |
|----------|-------|
| **Name** | lxr-storage (immutable) |
| **Version** | 2.0.0 |
| **FX Version** | cerulean |
| **Game** | rdr3 |
| **Lua Version** | 5.4 |

### File Structure

```
lxr-storage/
├── client/
│   └── client.lua              (403 lines)
├── server/
│   └── server.lua              (394 lines)
├── shared/
│   └── framework.lua           (331 lines)
├── config/
│   └── config.lua              (Complete configuration)
├── locales/
│   └── en.lua                  (English translations)
├── sql/
│   └── storage.sql             (Database schema)
├── docs/                       (Full documentation)
├── fxmanifest.lua             (Resource manifest)
└── README.md                   (Main documentation)
```

### Event System

**Client → Server Events:**
- `lxr-storage:server:openMenu` - Request menu data
- `lxr-storage:server:openStorage` - Request inventory open
- `lxr-storage:server:upgradeSlots` - Request slot upgrade

**Server → Client Events:**
- `lxr-storage:client:openMenu` - Send menu data
- `lxr-storage:client:notify` - Send notification

## ████████████████████████████████████████████████████████████████
## 🔮 FUTURE EXTENSIBILITY
## ████████████████████████████████████████████████████████████████

The system is designed for easy extension:

**Potential Additions:**
- ✨ Faction/gang shared storage
- ✨ Storage access permissions system
- ✨ Storage rental/fee system
- ✨ Item weight calculations
- ✨ Storage transfer between towns
- ✨ Storage insurance system
- ✨ API for other resources
- ✨ Admin management UI
- ✨ Storage logs/auditing
- ✨ Mobile storage (wagons/horses)

**Framework Support:**
- Easy to add new framework adapters
- Modular bridge system
- Clear API documentation

---

```
═══════════════════════════════════════════════════════════════════════════════════════════
📄 Copyright © 2024-2026 The Lux Empire | wolves.land
═══════════════════════════════════════════════════════════════════════════════════════════
```
