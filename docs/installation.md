```
  ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗   ██╗███████╗███████╗
  ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║   ██║██╔════╝██╔════╝
  ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║   ██║█████╗  ███████╗
  ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝   ██║██╔══╝  ╚════██║
  ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝    ╚██╗███████╗███████║
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝      ╚═╝╚══════╝╚══════╝
```

# ⚙️ LXR-Storage Installation Guide

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
## 📋 PRE-INSTALLATION REQUIREMENTS
## ████████████████████████████████████████████████████████████████████████████████████████

### System Requirements

| Requirement | Minimum | Recommended |
|------------|---------|-------------|
| **Server OS** | Windows Server 2016+ / Linux | Linux (Ubuntu 20.04+) |
| **RedM Server** | Build 1355+ | Latest build |
| **MySQL** | 5.7+ | 8.0+ |
| **RAM** | 512MB available | 1GB+ available |
| **Storage** | 10MB | 50MB |

### Required Resources

✅ **oxmysql** - Database connector
```bash
# Latest version from GitHub
https://github.com/overextended/oxmysql
```

✅ **Framework** - One of the following:
- **LXR-Core** (Primary) - Full support
- **RSG-Core** (Primary) - Full support
- **VORP Core** (Supported) - Full support

### Framework-Specific Requirements

**For LXR-Core:**
- `lxr-core` (Core framework)
- `lxr-inventory` (Inventory system)
- `lxr-menu` (Menu system) - Optional but recommended

**For RSG-Core:**
- `rsg-core` (Core framework)
- `rsg-inventory` (Inventory system)
- `rsg-menu` (Menu system) - Optional but recommended

**For VORP Core:**
- `vorp_core` (Core framework)
- `vorp_inventory` (Inventory system)
- `vorp_menu` (Menu system) - Optional but recommended

### Database Access

You'll need:
- ✅ MySQL username and password
- ✅ Database name
- ✅ Host and port (usually localhost:3306)
- ✅ Permission to CREATE and ALTER tables

## ████████████████████████████████████████████████████████████████████████████████████████
## 📥 STEP 1: DOWNLOAD & EXTRACT
## ████████████████████████████████████████████████████████████████████████████████████████

### Method 1: GitHub Release (Recommended)

```bash
# Download latest release
cd /path/to/your/resources
wget https://github.com/iBoss21/lxr-storage/archive/refs/heads/main.zip

# Extract the archive
unzip main.zip

# Rename folder to lxr-storage (CRITICAL - Do not skip!)
mv lxr-storage-main lxr-storage
```

### Method 2: Git Clone

```bash
# Clone repository directly
cd /path/to/your/resources
git clone https://github.com/iBoss21/lxr-storage.git lxr-storage
```

### Method 3: Manual Download

1. Visit: https://github.com/iBoss21/lxr-storage
2. Click "Code" → "Download ZIP"
3. Extract to your resources folder
4. **IMPORTANT**: Rename folder to exactly `lxr-storage`

### ⚠️ CRITICAL: Resource Name

```
╔═══════════════════════════════════════════════════════════════════╗
║  ⚠️  THE FOLDER MUST BE NAMED EXACTLY: lxr-storage                ║
║                                                                   ║
║  ❌ WRONG: lxr-storage-main, lxr-storage-v2, LXR-Storage         ║
║  ✅ RIGHT: lxr-storage                                           ║
║                                                                   ║
║  The resource will NOT start with any other name!                 ║
╚═══════════════════════════════════════════════════════════════════╝
```

### Verify File Structure

After extraction, your structure should look like this:

```
resources/
└── lxr-storage/
    ├── client/
    │   └── client.lua
    ├── server/
    │   └── server.lua
    ├── shared/
    │   └── framework.lua
    ├── config/
    │   └── config.lua
    ├── locales/
    │   └── en.lua
    ├── sql/
    │   └── storage.sql
    ├── docs/
    ├── fxmanifest.lua
    ├── LICENSE
    └── README.md
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🗄️ STEP 2: DATABASE SETUP
## ████████████████████████████████████████████████████████████████████████████████████████

### Option A: Using MySQL Command Line

```bash
# Connect to MySQL
mysql -u your_username -p

# Select your database
USE your_database_name;

# Import the SQL file
source /path/to/lxr-storage/sql/storage.sql;

# Verify table was created
SHOW TABLES LIKE 'lxr_storage_slots';
DESCRIBE lxr_storage_slots;

# Exit MySQL
exit;
```

### Option B: Using phpMyAdmin

1. Open phpMyAdmin in your browser
2. Select your RedM database from the left panel
3. Click the "Import" tab
4. Click "Choose File" and select `sql/storage.sql`
5. Scroll down and click "Go"
6. Verify success message appears
7. Check that `lxr_storage_slots` table exists

### Option C: Using HeidiSQL (Windows)

1. Open HeidiSQL
2. Connect to your MySQL server
3. Select your RedM database
4. Go to File → Load SQL file
5. Browse to `lxr-storage/sql/storage.sql`
6. Click "Execute" (F9)
7. Verify "Query executed successfully" message

### Option D: Direct SQL Execution

Copy and execute this SQL directly:

```sql
-- Create storage slots table
CREATE TABLE IF NOT EXISTS `lxr_storage_slots` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `town_key` VARCHAR(50) NOT NULL,
    `slots` INT NOT NULL DEFAULT 200,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_player_town` (`identifier`, `town_key`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_town_key` (`town_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Verify Database Installation

Run this query to test:

```sql
-- Should return empty result (no errors)
SELECT * FROM lxr_storage_slots LIMIT 1;

-- Check table structure
SHOW CREATE TABLE lxr_storage_slots;
```

**Expected output structure:**
```
+----+------------+----------+-------+---------------------+---------------------+
| id | identifier | town_key | slots | created_at          | updated_at          |
+----+------------+----------+-------+---------------------+---------------------+
```

## ████████████████████████████████████████████████████████████████████████████████████████
## ⚙️ STEP 3: CONFIGURE OXMYSQL
## ████████████████████████████████████████████████████████████████████████████████████████

### Verify oxmysql Configuration

Check your `server.cfg` has oxmysql connection string:

```cfg
# MySQL Connection String
set mysql_connection_string "mysql://username:password@localhost/database_name?charset=utf8mb4"
```

**Connection String Format:**
```
mysql://[username]:[password]@[host]/[database]?charset=utf8mb4
```

**Example:**
```cfg
set mysql_connection_string "mysql://redm:MyPassword123@localhost/redm_server?charset=utf8mb4"
```

### Test oxmysql Connection

```bash
# Start only oxmysql to test
ensure oxmysql

# Check console for:
# [oxmysql] [CORE] Connected to MySQL database 'database_name'
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🔧 STEP 4: BASIC CONFIGURATION
## ████████████████████████████████████████████████████████████████████████████████████████

### Edit Configuration File

Open `lxr-storage/config/config.lua` and configure:

### 1. Framework Selection (Optional)

```lua
-- Automatic detection (recommended)
Config.Framework = 'auto'

-- Or force specific framework:
-- Config.Framework = 'lxr-core'
-- Config.Framework = 'rsg-core'
-- Config.Framework = 'vorp'
```

**Recommendation:** Leave as `'auto'` - the system will detect automatically.

### 2. Storage Settings

```lua
Config.Storage = {
    BaseSlots       = 200,      -- Starting slots (free)
    MaxSlots        = 10000,    -- Maximum upgradeable slots
    MaxWeight       = 1000000,  -- Max weight (for weight-based inventories)
    PricePerSlot    = 0.30,     -- Cost per slot upgrade
    IndependentTowns = true,    -- Keep true for per-town storage
}
```

### 3. Currency Configuration

**For Cash Currency:**
```lua
Config.CurrencyType = 0           -- VORP: 0 = cash
Config.CurrencyName = 'cash'      -- LXR/RSG: 'cash'
```

**For Gold Currency:**
```lua
Config.CurrencyType = 1           -- VORP: 1 = gold
Config.CurrencyName = 'gold'      -- LXR/RSG: 'gold'
```

### 4. General Settings

```lua
Config.General = {
    EnableBlips       = true,  -- Show storage locations on map
    EnableNPCs        = true,  -- Spawn storage clerk NPCs
    InteractDistance  = 2.0,   -- Distance to interact (meters)
    PromptDistance    = 5.0,   -- Distance to show prompt (meters)
}
```

### 5. Language (Optional)

```lua
Config.Lang = 'en'  -- Default: English
-- To add more languages, create files in locales/ folder
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 📝 STEP 5: SERVER.CFG CONFIGURATION
## ████████████████████████████████████████████████████████████████████████████████████████

### Add to server.cfg

Open your `server.cfg` and add in this order:

```cfg
# ═══════════════════════════════════════════════════════════
# DATABASE
# ═══════════════════════════════════════════════════════════
ensure oxmysql

# ═══════════════════════════════════════════════════════════
# FRAMEWORK (Ensure your framework is loaded)
# ═══════════════════════════════════════════════════════════
# Choose ONE of these based on your framework:

# For LXR-Core:
ensure lxr-core
ensure lxr-inventory
ensure lxr-menu

# For RSG-Core:
# ensure rsg-core
# ensure rsg-inventory
# ensure rsg-menu

# For VORP Core:
# ensure vorp_core
# ensure vorp_inventory
# ensure vorp_menu

# ═══════════════════════════════════════════════════════════
# LXR-STORAGE
# ═══════════════════════════════════════════════════════════
ensure lxr-storage
```

### ⚠️ Load Order is Critical!

```
1. oxmysql (database)
   ↓
2. Framework (lxr-core/rsg-core/vorp_core)
   ↓
3. Inventory system (lxr-inventory/rsg-inventory/vorp_inventory)
   ↓
4. Menu system (optional but recommended)
   ↓
5. lxr-storage
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🚀 STEP 6: START THE RESOURCE
## ████████████████████████████████████████████████████████████████████████████████████████

### First-Time Startup

```bash
# Stop server if running
stop

# Start server
start

# Or restart just lxr-storage
restart lxr-storage
```

### Verify Successful Startup

Check your console for these messages:

```
✅ Expected Console Output:
════════════════════════════════════════════════════════════════
^2[LXR-Storage]^7 Framework detected: ^3LXR-CORE^7
^2[LXR-Storage]^7 Resource loaded successfully
^2[LXR-Storage]^7 9 storage locations configured
════════════════════════════════════════════════════════════════
```

### Framework Detection Messages

**LXR-Core Detected:**
```
[LXR-Storage] Framework detected: LXR-CORE
[LXR-Storage] Inventory: lxr-inventory
[LXR-Storage] Menu: lxr-menu
```

**RSG-Core Detected:**
```
[LXR-Storage] Framework detected: RSG-CORE
[LXR-Storage] Inventory: rsg-inventory
[LXR-Storage] Menu: rsg-menu
```

**VORP Core Detected:**
```
[LXR-Storage] Framework detected: VORP
[LXR-Storage] Inventory: vorp_inventory
[LXR-Storage] Menu: vorp_menu
```

## ████████████████████████████████████████████████████████████████████████████████████████
## ✅ STEP 7: TESTING & VERIFICATION
## ████████████████████████████████████████████████████████████████████████████████████████

### In-Game Testing Checklist

#### Test 1: Map Blips
```
✅ Open your map (M key)
✅ Look for storage location markers
✅ Verify 9 blips are visible (one per town)
✅ Check blip labels show town names
```

#### Test 2: NPC Spawning
```
✅ Travel to Valentine storage location
   Coords: -242.66, 752.26, 117.68
✅ NPC should spawn as you approach
✅ NPC should be facing correct direction
✅ NPC should be stationary and invincible
```

#### Test 3: Interaction Prompt
```
✅ Walk close to the NPC (within 5 meters)
✅ Prompt should appear: "Press G to speak to Storage Clerk"
✅ Prompt should disappear when walking away
```

#### Test 4: Menu System
```
✅ Press G near the NPC
✅ Menu should open showing:
   - "Open Storage"
   - "Upgrade Storage"
   - "Close"
✅ Menu should display town name in title
```

#### Test 5: Opening Storage
```
✅ Select "Open Storage" from menu
✅ Inventory interface should open
✅ Should show 200 slots (default)
✅ Try storing items
✅ Close and reopen - items should persist
```

#### Test 6: Upgrading Storage
```
✅ Select "Upgrade Storage"
✅ Should show current slots (200)
✅ Should show max slots (10,000)
✅ Enter amount (e.g., 100)
✅ If you have money: upgrade succeeds
✅ If not enough money: error message shown
✅ Check slot count increased
```

#### Test 7: Independent Town Storage
```
✅ Store items in Valentine
✅ Travel to Saint Denis storage
   Coords: 2648.75, -1503.11, 45.97
✅ Open Saint Denis storage
✅ Verify Valentine items are NOT there
✅ Each town has separate inventory ✅
```

#### Test 8: Character Persistence
```
✅ Store items in a town
✅ Upgrade slots
✅ Logout and login
✅ Return to same storage
✅ Items and slot count should persist
```

### Console Testing

Run these in server console:

```bash
# Check resource status
status lxr-storage

# Restart resource
restart lxr-storage

# Check for errors
# Look for any red error messages in console
```

### Database Verification

Check database for player data:

```sql
-- See all storage slot records
SELECT * FROM lxr_storage_slots;

-- Check specific player
SELECT * FROM lxr_storage_slots WHERE identifier = 'your_identifier';

-- Check specific town
SELECT * FROM lxr_storage_slots WHERE town_key = 'valentine';
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🐛 TROUBLESHOOTING INSTALLATION
## ████████████████████████████████████████████████████████████████████████████████████████

### Issue 1: Resource Won't Start

**Error: "Resource name must be lxr-storage"**

```
Solution:
1. Check folder name is EXACTLY 'lxr-storage'
2. No spaces, capital letters, or extra characters
3. Rename folder if needed
4. Restart server
```

**Error: "Could not load resource lxr-storage"**

```
Solution:
1. Verify fxmanifest.lua exists in root folder
2. Check file permissions (Linux: chmod -R 755 lxr-storage)
3. Verify all required files exist
4. Check server console for specific error details
```

### Issue 2: Database Errors

**Error: "Table lxr_storage_slots doesn't exist"**

```
Solution:
1. Re-run database import
2. Check you selected correct database
3. Verify MySQL connection string in server.cfg
4. Manually create table using SQL provided above
```

**Error: "Access denied for user"**

```
Solution:
1. Verify MySQL credentials in connection string
2. Ensure user has permissions on database
3. Test connection with MySQL client
4. Check MySQL server is running
```

### Issue 3: Framework Not Detected

**Console shows: "Framework detected: STANDALONE"**

```
Solution:
1. Verify framework resource is started BEFORE lxr-storage
2. Check framework resource name matches config:
   - lxr-core (not lxr_core)
   - rsg-core (not rsg_core)
   - vorp_core (not vorp-core)
3. Ensure framework is actually running (check with 'status')
4. Try setting Config.Framework manually instead of 'auto'
```

### Issue 4: NPCs Not Spawning

**NPCs don't appear at locations**

```
Solution:
1. Check Config.General.EnableNPCs = true
2. Verify you're close enough to location (<100m)
3. Check console for NPC spawn errors
4. Try different NPC model in config
5. Verify game has loaded NPC models
```

### Issue 5: Inventory Won't Open

**Storage menu works but inventory doesn't open**

```
Solution:
1. Verify inventory resource is running:
   - lxr-inventory for LXR-Core
   - rsg-inventory for RSG-Core
   - vorp_inventory for VORP Core
2. Check console for inventory-related errors
3. Ensure inventory is loaded BEFORE lxr-storage
4. Try restarting inventory resource
```

### Issue 6: Upgrades Not Working

**Can't upgrade slots**

```
Solution:
1. Check player has enough money
2. Verify currency type matches framework:
   - Config.CurrencyName for LXR/RSG
   - Config.CurrencyType for VORP
3. Ensure player isn't already at max slots
4. Check console for server-side errors
5. Verify database connection
```

### Issue 7: Performance Issues

**Resource causes lag or high CPU usage**

```
Solution:
1. Check for conflicting resources
2. Verify latest oxmysql version
3. Ensure database is optimized (indexes exist)
4. Check server specifications meet requirements
5. Monitor with 'resmon' command in console
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🔧 POST-INSTALLATION CONFIGURATION
## ████████████████████████████████████████████████████████████████████████████████████████

### Customizing Locations

Add or modify storage locations in `config/config.lua`:

```lua
Config.Towns = {
    -- Add new location
    {
        key     = 'newtownkey',          -- Unique identifier
        label   = 'New Town Storage',    -- Display name
        coords  = vector3(x, y, z),      -- NPC spawn coordinates
        heading = 90.0,                  -- NPC facing direction (0-360)
        npc     = 'npc_model_hash'       -- NPC model
    }
}
```

### Adjusting Prices

```lua
Config.Storage = {
    BaseSlots       = 200,      -- Change starting amount
    MaxSlots        = 10000,    -- Change maximum limit
    PricePerSlot    = 0.50,     -- Increase/decrease price
}
```

### Disabling Features

```lua
Config.General = {
    EnableBlips       = false,  -- Hide map markers
    EnableNPCs        = false,  -- Remove NPCs (use /storage command instead)
}
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 📊 INSTALLATION VERIFICATION CHECKLIST
## ████████████████████████████████████████████████████████████████████████████████████████

Use this checklist to ensure proper installation:

```
Installation Checklist
══════════════════════════════════════════════════════════════
□ Resource folder named exactly 'lxr-storage'
□ All files present and intact
□ Database table 'lxr_storage_slots' created successfully
□ oxmysql connection string configured
□ Framework resource loaded before lxr-storage
□ Resource added to server.cfg in correct order
□ Server starts without errors
□ Framework detected correctly (check console)
□ Map blips visible (9 locations)
□ NPCs spawn at locations
□ Interaction prompts appear
□ Menu opens successfully
□ Storage inventory opens
□ Upgrades process correctly
□ Data persists after logout/login
□ Each town has independent storage
□ No console errors during operation
```

## ████████████████████████████████████████████████████████████████████████████████████████
## 🆘 GETTING HELP
## ████████████████████████████████████████████████████████████████████████████████████████

If you encounter issues during installation:

### Support Channels

**Discord Community:**
```
Join: https://discord.gg/CrKcWdfd3A
Channel: #support
Response time: Usually within 24 hours
```

**GitHub Issues:**
```
Report: https://github.com/iBoss21/lxr-storage/issues
Include: 
  - Console errors (full output)
  - Server.cfg excerpt
  - Framework and version
  - Steps to reproduce
```

**Documentation:**
```
Read: All documentation in docs/ folder
Check: Troubleshooting sections
Review: Framework-specific guides
```

### Information to Provide When Asking for Help

```
1. Server OS and version
2. RedM server build number
3. Framework and version
4. Full console error output
5. Config.lua (relevant sections)
6. Server.cfg (relevant sections)
7. Steps that reproduce the issue
8. What you've already tried
```

---

```
═══════════════════════════════════════════════════════════════════════════════════════════
📄 Copyright © 2024-2026 The Lux Empire | wolves.land
═══════════════════════════════════════════════════════════════════════════════════════════
```

**Installation should take approximately 5-10 minutes.**

**After installation, visit Valentine (coordinates in config) to test the system!**
