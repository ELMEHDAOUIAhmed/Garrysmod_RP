# Health Cycle Script Documentation

**Author:** ELMEHDAOUI Ahmed  
**GitHub:** https://github.com/ELMEHDAOUIAhmed  
**Script File:** `lua/autorun/server/sv_health_cycle.lua`

## 📋 Overview

A server-side script that automatically cycles player health by reducing it every second and resetting to 100 when it reaches 1. Perfect for learning timer management and player manipulation in GMod Lua.

## 🎯 Learning Objectives

This script teaches:
- ✅ **Timer Management** - Creating, managing, and cleaning up timers
- ✅ **Player Manipulation** - Modifying player health and properties
- ✅ **Hook System** - Using PlayerSpawn, PlayerDeath, PlayerDisconnected hooks
- ✅ **Memory Management** - Proper cleanup to prevent memory leaks
- ✅ **Console Commands** - Creating admin commands with `concommand.Add`
- ✅ **Error Handling** - Validating players and preventing crashes

## 🔧 Core Functions

### **CyclePlayerHealth(ply)**
- Reduces player health by 1
- Resets to 100 when health ≤ 1
- Includes validation checks

### **StartHealthCycle(ply)**
- Creates unique timer for each player
- Handles timer cleanup for existing timers
- Uses player SteamID64 for unique naming

### **StopHealthCycle(ply)**
- Safely removes player's timer
- Cleans up memory references
- Prevents orphaned timers

## 🎮 Features

### **Automatic Management**
```lua
-- Starts automatically when player spawns
hook.Add("PlayerSpawn", "StartHealthCycling", function(ply)
    -- Auto-start with small delay
end)

-- Stops when player dies
hook.Add("PlayerDeath", "StopHealthCycling", function(ply)
    StopHealthCycle(ply)
end)
```

### **Admin Commands**
```lua
health_cycle_start [player]  # Start cycling
health_cycle_stop [player]   # Stop cycling
```

### **Console Support**
- Works from server console
- Targets all players when run from console
- Proper validation for admin permissions

## 📊 Technical Details

### **Timer Implementation**
```lua
-- Unique timer per player
local timerName = "HealthCycle_" .. ply:SteamID64()

-- Repeating timer (0 = infinite repeats)
timer.Create(timerName, 1, 0, function()
    -- Health cycling logic
end)
```

### **Memory Management**
```lua
-- Track timers in table
local playerTimers = {}

-- Clean up on disconnect
hook.Add("PlayerDisconnected", "CleanupHealthCycle", function(ply)
    StopHealthCycle(ply)
end)
```

## 🚀 Usage Examples

### **Basic Usage**
1. Script auto-starts when players spawn
2. Health decreases: 100 → 99 → 98 → ... → 1 → 100
3. Cycle continues until player dies or disconnects

### **Manual Control**
```lua
-- In console (as admin):
health_cycle_start          # Start for yourself
health_cycle_start Player   # Start for specific player
health_cycle_stop           # Stop for yourself
```

### **Server Console**
```lua
health_cycle_start          # Starts for all players
lua_openscript sv_health_cycle.lua  # Reload script
```

## 🐛 Debugging

### **Console Output**
```
[Health Cycle] Script loaded successfully!
[Health Cycle] PlayerSpawn detected for Player
[Health Cycle] Started health cycling for Player
[Health Cycle] Player's health: 99
[Health Cycle] Player's health: 98
...
[Health Cycle] Player's health reset to 100
```

### **Common Issues**
- **No health decrease:** Player not spawned or script not auto-started
- **Timer conflicts:** Multiple timers with same name (handled by cleanup)
- **Memory leaks:** Timers not cleaned up (handled by hooks)

## ⚙️ Customization

### **Change Health Decrease Rate**
```lua
-- Change from 1 second to 2 seconds
timer.Create(timerName, 2, 0, function()

-- Change health decrease amount
ply:SetHealth(currentHealth - 5)  -- Decrease by 5 instead of 1
```

### **Change Reset Health**
```lua
-- Reset to 50 instead of 100
if currentHealth <= 1 then
    ply:SetHealth(50)
```

### **Change Minimum Health**
```lua
-- Reset when health reaches 10
if currentHealth <= 10 then
    ply:SetHealth(100)
```

## 🎓 Key Concepts Learned

1. **Timer Management:** Safe creation, cleanup, and unique naming
2. **Hook System:** Automatic event handling for game events
3. **Player Validation:** Using `IsValid()` and `ply:Alive()`
4. **Memory Safety:** Proper cleanup prevents server issues
5. **Admin Systems:** Permission checking and console commands
6. **Network Efficiency:** Server-side only, no client overhead

## 🔗 Related Learning

- **Next Steps:** Study the Custom Tab Menu for client-side scripting
- **Advanced:** Combine with networking for client notifications
- **Extensions:** Add sound effects, visual indicators, or custom health ranges

## 📝 Code Structure

```
sv_health_cycle.lua
├── Variables & Setup
├── Core Functions
│   ├── CyclePlayerHealth()
│   ├── StartHealthCycle()
│   └── StopHealthCycle()
├── Event Hooks
│   ├── PlayerSpawn
│   ├── PlayerDeath
│   ├── PlayerDisconnected
│   └── Initialize (auto-start)
└── Console Commands
    ├── health_cycle_start
    └── health_cycle_stop
```

---

**Perfect for:** Beginners learning GMod Lua timer and player systems  
**Difficulty:** ⭐⭐☆☆☆ (Beginner-Intermediate)  
**Concepts:** Timers, Hooks, Player Manipulation, Memory Management
