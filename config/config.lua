Config = {}

-- Currency: 0 = cash, 1 = gold (change if you want gold)
Config.CurrencyType = 0

-- Base and Max
Config.BaseSlots = 200
Config.MaxSlots = 10000
-- Price per slot (e.g., $0.30)
Config.PricePerSlot = 0.30

-- Interaction key (G by default)
Config.InteractControl = 0x760A9C6F -- INPUT_OPEN_SATCHEL (G) on keyboard

-- Distance to interact
Config.InteractDistance = 2.0
Config.PromptHint = 'Press ~o~G~q~ to talk to the Storage Clerk'

-- Blip and NPC
Config.BlipSprite = 1664425300 -- Generic marker (change to your liking)
Config.BlipScale = 0.2
Config.NPCModel = 'u_m_m_vhtstationclerk_01' -- change per town in table below if desired

-- Town storage locations (fill/adjust coords to taste)
-- Key must be unique string (used in DB key), label is shown in menu and blip
Config.Towns = {
    { key = 'valentine',   label = 'Valentine Storage',   coords = vector3(-242.66, 752.26, 117.68),  heading = 99.19,  npc = 'u_m_m_vhtstationclerk_01' },
    { key = 'stdenis',     label = 'Saint Denis Storage', coords = vector3(2648.75, -1503.11, 45.97), heading = 269.91, npc = 'u_m_m_vhtstationclerk_01' },
    { key = 'blackwater',  label = 'Blackwater Storage',  coords = vector3(-877.14, -1341.74, 43.29), heading = 176.47, npc = 'u_m_m_vhtstationclerk_01' },
    { key = 'rhodes',      label = 'Rhodes Storage',      coords = vector3(1428.73, -1320.87, 78.4), heading = 23.43, npc = 'u_m_m_vhtstationclerk_01' },
    { key = 'strawberry',  label = 'Strawberry Storage',  coords = vector3(-1760.47, -386.16, 157.69), heading = 225.21, npc = 'u_m_m_vhtstationclerk_01' },
    { key = 'annesburg',   label = 'Annesburg Storage',   coords = vector3(2952.21, 1355.93, 44.87), heading = 82.19,  npc = 'u_m_m_vhtstationclerk_01' },
    { key = 'vanhorn',     label = 'Van Horn Storage',    coords = vector3(3009.36, 559.49, 44.66),   heading = 84.29,  npc = 'u_m_m_vhtstationclerk_01' },
    { key = 'tumbleweed',  label = 'Tumbleweed Storage',  coords = vector3(-5506.15, -2915.04, -2.41),heading = 198.81,  npc = 'u_m_m_vhtstationclerk_01' },
    { key = 'armadillo',   label = 'Armadillo Storage',   coords = vector3(-3701.5, -2570.69, -13.72),heading = 267.61, npc = 'u_m_m_vhtstationclerk_01' }
}
