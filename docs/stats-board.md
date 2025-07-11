# Stats Board Documentation

**Author:** ELMEHDAOUI Ahmed  
**GitHub:** https://github.com/ELMEHDAOUIAhmed  
**Script File:** `lua/autorun/client/cl_stats_board.lua`

## 📋 Overview

A real-time statistics board that displays comprehensive server and player information on the left side of the screen. Shows player details, server stats, and live updates every second.

## 🎯 Learning Objectives

This script teaches:
- ✅ **Advanced VGUI** - Complex UI layouts with scroll panels
- ✅ **Real-time Updates** - Timer-based content refreshing
- ✅ **Data Processing** - Collecting and formatting player statistics
- ✅ **Dynamic Content** - Creating and removing UI elements on the fly
- ✅ **Performance Optimization** - Efficient UI updates and memory management
- ✅ **Visual Design** - Color coding and information hierarchy

## 🎨 UI Components

### **Main Frame Structure**
```
DFrame (statsBoard)
├── Header Section
├── DScrollPanel (scroll)
    └── DPanel (content)
        ├── Server Information
        ├── Player Statistics Header
        └── Dynamic Player Panels
```

### **Color Scheme**
```lua
local colors = {
    background = Color(20, 20, 25, 230),      -- Very dark background
    header = Color(15, 15, 20, 255),          -- Darker header
    playerRow = Color(30, 30, 35, 200),       -- Dark player rows
    playerRowAlt = Color(25, 25, 30, 200),    -- Alternating rows
    text = Color(255, 255, 255, 255),         -- White text
    admin = Color(255, 100, 100, 255),        -- Red for admins
    alive = Color(100, 255, 100, 255),        -- Green for alive
    dead = Color(255, 100, 100, 255)          -- Red for dead
}
```

## 📊 Features

### **Server Information Section**
- 📍 **Current Map** - Shows active map name
- ⏰ **Server Time** - Real-time clock display
- 🎮 **Game Mode** - Current gamemode
- 🌐 **Server Name** - Hostname
- ⚡ **Tickrate** - Server performance metric

### **Player Statistics**
- 👥 **Player Count** - Current/Maximum players
- 🤖 **Bot Count** - Number of AI players
- 👑 **Admin Count** - Number of administrators
- ❤️ **Alive Players** - Currently living players

### **Individual Player Info**
- **Name Display** with status icons
- **Admin Status** (👑 Crown icon)
- **Bot Identification** (🤖 Robot icon)
- **Health Display** (for alive players)
- **Ping Display** (color-coded by latency)
- **Alive/Dead Status** (✅/💀 indicators)

## 🔧 Core Functions

### **CreateStatsBoard()**
- Creates the main UI framework
- Sets up scroll panel and content area
- Initializes update timer
- Positions board on left side of screen

### **UpdatePlayerList()**
- Refreshes player data every second
- Counts bots, admins, and alive players
- Updates player panels dynamically
- Handles player join/leave events

### **FormatTime(seconds)**
- Converts seconds to HH:MM:SS format
- Used for connection time display
- Handles hours, minutes, seconds properly

### **GetPingColor(ping)**
- Color-codes ping based on latency
- Green: < 50ms (Good)
- Yellow: 50-100ms (Fair)
- Red: > 100ms (Poor)

## 🎮 Usage

### **Opening the Stats Board**
1. Press **TAB** to open custom menu
2. Click **"📊 Toggle Stats Board"**
3. Board appears on left side of screen

### **Console Command**
```
toggle_stats_board
```

### **Automatic Features**
- **Real-time Updates** - Refreshes every second
- **Auto-close on Death** - Closes when player dies
- **Draggable Interface** - Can be moved around screen
- **Scrollable Content** - Handles many players

## 📈 Display Information

### **Server Section**
```
🖥️ Server Information
📍 Map: gm_flatgrass
⏰ Server Time: 15:30:45
🎮 Game Mode: sandbox
🌐 Server Name: My GMod Server
⚡ Tickrate: 66 Hz
```

### **Players Section**
```
👥 Players (8/16) | 🤖 Bots: 2 | 👑 Admins: 1 | ❤️ Alive: 6

👑 Admin Player        ✅ Alive    ❤️ 100hp    25ms
🤖 Bot_01             ✅ Alive    ❤️ 80hp
Regular Player        💀 Dead                   45ms
Another Player        ✅ Alive    ❤️ 65hp     120ms
```

## 🔄 Real-time Updates

### **Update Timer**
```lua
updateTimer = timer.Create("StatsBoard_Update", 1, 0, function()
    if IsValid(statsBoard) then
        UpdatePlayerList()
        -- Update server time
        -- Refresh player data
    end
end)
```

### **Dynamic Content Management**
- **Player Join**: New panel automatically added
- **Player Leave**: Panel automatically removed
- **Status Changes**: Health, alive/dead status updated
- **Admin Changes**: Crown icon appears/disappears

## 🎨 Visual Features

### **Status Icons**
- 👑 **Admin Status** - Red crown for administrators
- 🤖 **Bot Indicator** - Robot emoji for AI players
- ✅ **Alive Status** - Green checkmark
- 💀 **Dead Status** - Red skull
- ❤️ **Health Display** - Heart with HP value

### **Color Coding**
- **Names**: White (normal), Red (admin)
- **Status**: Green (alive), Red (dead)
- **Ping**: Green (good), Yellow (fair), Red (poor)
- **Rows**: Alternating dark colors for readability

### **Layout Design**
- **Left-aligned** for easy scanning
- **Consistent spacing** between elements
- **Scrollable** for large player counts
- **Draggable** for user preference

## ⚙️ Customization

### **Change Update Frequency**
```lua
-- Update every 2 seconds instead of 1
timer.Create("StatsBoard_Update", 2, 0, function()
```

### **Modify Position**
```lua
-- Right side instead of left
statsBoard:SetPos(ScrW() - 470, 50)
```

### **Add Custom Information**
```lua
-- Add FPS display
"🎮 Client FPS: " .. math.Round(1 / RealFrameTime())

-- Add player count from specific team
"👮 Police: " .. team.NumPlayers(TEAM_POLICE)
```

### **Change Colors**
```lua
-- Blue theme
local colors = {
    background = Color(20, 25, 40, 230),
    playerRow = Color(30, 35, 50, 200),
    accent = Color(100, 150, 255, 255)
}
```

## 🎓 Key Concepts Learned

### **Advanced VGUI**
1. **Scroll Panels** - Handling overflow content
2. **Dynamic Updates** - Adding/removing elements
3. **Custom Paint Functions** - Complex visual effects
4. **Panel Hierarchy** - Proper parent-child relationships

### **Data Management**
1. **Real-time Processing** - Continuous data updates
2. **State Tracking** - Monitoring player changes
3. **Performance** - Efficient update cycles
4. **Memory Management** - Proper cleanup

### **User Experience**
1. **Information Design** - Clear data presentation
2. **Visual Hierarchy** - Importance through color/size
3. **Responsive Interface** - Adapts to player count
4. **Accessibility** - Easy to read and understand

## 🔗 Integration

### **Custom Tab Menu Integration**
The stats board is accessible through the custom tab menu:
- Press **TAB** → Click **"📊 Toggle Stats Board"**
- Seamless integration with existing menu system
- Consistent styling with menu theme

### **Combines Well With**
- **Admin Systems** - Enhanced admin identification
- **Team Systems** - Team-based statistics
- **Economy Systems** - Player wealth display
- **Roleplay Mods** - Character information

---

**Perfect for:** Advanced developers learning complex VGUI and data visualization  
**Difficulty:** ⭐⭐⭐⭐☆ (Advanced)  
**Concepts:** Advanced VGUI, Real-time Updates, Data Processing, Performance Optimization
