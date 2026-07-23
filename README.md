# Kosova PvP - Roblox Game

A team-based PvP game where Kosovo fights against rivals!

## Features

- **Team System**: Kosovo (Red) vs Rival (Blue)
- **Weapons**: Sword, Knife, AK47
- **Health System**: 100 HP with damage tracking
- **Kill Feed**: Real-time kill notifications
- **HUD**: Health bar, team display, score tracking
- **Map Arena**: Buildings, sniper towers, cover objects, flags
- **Weapon Pickups**: Scattered around the map
- **Sound Effects**: Combat and ambient sounds
- **Round System**: 3-minute rounds, first to 20 kills wins

## Setup Instructions

### Step 1: Get Roblox Studio
1. Go to https://create.roblox.com
2. Sign in with your Roblox account
3. Download and install Roblox Studio

### Step 2: Create New Game
1. Open Roblox Studio
2. Click "Baseplate" template
3. Save your game

### Step 3: Add Scripts
Copy each script to the correct location:

#### Server Scripts (ServerScriptService)
1. `GameSetup.server.lua` - Teams, spawns, leaderboards
2. `WeaponSystem.server.lua` - Weapon creation and combat
3. `HealthSystem.server.lua` - Health and damage tracking
4. `MapBuilder.server.lua` - Arena map creation
5. `WeaponPickups.server.lua` - Weapon pickup system
6. `SoundSystem.server.lua` - Sound effects

#### Client Scripts (StarterPlayerScripts)
1. `ClientHUD.client.lua` - Health bar and score UI
2. `KillFeedUI.client.lua` - Kill notifications
3. `CombatClient.client.lua` - Crosshair and input
4. `SoundClient.client.lua` - Sound playback

### Step 4: Configure Game Settings
1. In Roblox Studio, go to Game Settings
2. Set "Team" to enabled
3. Set "Allow Team Change on Touch" to false
4. Set "AutoAssignable" to true for teams

### Step 5: Test Your Game
1. Press F5 or click Play
2. Test movement, combat, and weapons
3. Check for errors in Output window

## Controls

- **WASD** - Move
- **Mouse** - Look around
- **Left Click** - Attack
- **Space** - Jump
- **1-3** - Switch weapons

## Customization

### Change Team Names
In `GameSetup.server.lua`, modify:
```lua
teamKosova.Name = "Kosova"
teamRival.Name = "Rival"
```

### Change Colors
Modify `BrickColor.new()` values:
- Kosovo: "Bright red"
- Rival: "Bright blue"

### Adjust Weapons
In `WeaponSystem.server.lua`, modify damage values:
```lua
Sword = {Damage = 25, Range = 8, Cooldown = 0.8}
```

### Map Size
In `MapBuilder.server.lua`, adjust:
```lua
local floor = createPart("Floor", Vector3.new(200, 2, 200), ...)
```

## Troubleshooting

### Scripts not working?
- Make sure scripts are in correct folders
- Check Output window for errors
- Verify RemoteEvents are created

### No damage?
- Check if teams are set up correctly
- Verify weapon tools are equipped
- Test distance - weapons have range limits

### Map not loading?
- Ensure MapBuilder script is in ServerScriptService
- Check if workspace is clear before running

## File Structure

```
ServerScriptService/
├── GameSetup.server.lua
├── WeaponSystem.server.lua
├── HealthSystem.server.lua
├── MapBuilder.server.lua
├── WeaponPickups.server.lua
└── SoundSystem.server.lua

StarterPlayerScripts/
├── ClientHUD.client.lua
├── KillFeedUI.client.lua
├── CombatClient.client.lua
└── SoundClient.client.lua
```

## Credits

Built for Kosovo PvP fans!

---

**Note**: Some asset IDs may need to be replaced with actual Roblox asset IDs. Search the Roblox library for appropriate sounds and textures.
