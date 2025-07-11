# Garry's Mod Lua Learning Repository

**Author:** ELMEHDAOUI Ahmed  
**GitHub:** https://github.com/ELMEHDAOUIAhmed

## 📚 Purpose

This repository is a **learning playground** for Garry's Mod Lua scripting. It contains various individual scripts and examples to help understand the fundamentals of GMod addon development.

## 🎯 Learning Goals

- ✅ Understanding GMod Lua basics
- ✅ Client-side and server-side scripting
- ✅ VGUI (Visual GUI) creation
- ✅ Hook system usage
- ✅ Timer management
- ✅ Network communication
- ✅ Player interaction systems
- ✅ Best practices and code structure

## 📁 Repository Structure

```
Garrysmod_RP/
├── README.md                           # This main README
├── addon.txt                          # Addon information
├── docs/                              # Documentation for each script
│   ├── health-cycle.md               # Health cycling script docs
│   ├── custom-tab-menu.md            # Custom tab menu script docs
│   └── stats-board.md                # Stats board system docs
└── lua/
    └── autorun/
        ├── client/
        │   ├── cl_custom_tab_menu.lua    # Client-side tab menu
        │   └── cl_stats_board.lua        # Real-time statistics board
        └── server/
            ├── sv_health_cycle.lua       # Server-side health cycling
            └── sv_custom_tab_menu.lua    # Server-side tab menu handler
```

## 🔧 Scripts Included

### 1. **Health Cycle System**
- **Files:** `sv_health_cycle.lua`
- **Purpose:** Learn timer management and player health manipulation
- **Features:** Automatic health cycling, admin controls, memory management
- **Documentation:** [docs/health-cycle.md](docs/health-cycle.md)

### 2. **Custom Tab Menu**
- **Files:** `cl_custom_tab_menu.lua`, `sv_custom_tab_menu.lua`
- **Purpose:** Learn VGUI creation and client-server communication
- **Features:** Custom UI, button interactions, network messaging
- **Documentation:** [docs/custom-tab-menu.md](docs/custom-tab-menu.md)

### 3. **Stats Board System**
- **Files:** `cl_stats_board.lua`
- **Purpose:** Learn advanced VGUI and real-time data visualization
- **Features:** Real-time player stats, server info, customizable keybinds, scroll panels
- **Documentation:** [docs/stats-board.md](docs/stats-board.md)

## 🚀 Installation

1. **Clone or download** this repository
2. **Extract** to your `garrysmod/addons/` folder
3. **Restart** your Garry's Mod server
4. **Test** each script individually

## 📖 Learning Path

### **Beginner Level:**
1. Start with the **Health Cycle** script to understand:
   - Server-side scripting
   - Timer management
   - Hook system
   - Player manipulation

### **Intermediate Level:**
2. Move to the **Custom Tab Menu** to learn:
   - Client-side GUI creation
   - VGUI components
   - Network communication
   - Event handling

### **Advanced Level:**
3. Master the [Stats Board documentation](docs/stats-board.md) to learn:
- Complex VGUI layouts and scroll panels
- Real-time data processing and updates
- Performance optimization techniques
- Advanced visual design concepts
- Dynamic content management
- Customizable keybind systems

### **Expert Level:**
4. Combine concepts to create your own scripts!

## 🎮 Console Commands

### Health Cycle System
- `health_cycle_start <player>` - Start health cycle for a player (Admin)
- `health_cycle_stop <player>` - Stop health cycle for a player (Admin)
- `health_cycle_status` - Show current health cycle status

### Stats Board System
- `toggle_stats` - Toggle the stats board on/off
- `stats_keybind <key>` - Change the stats board keybind
- `stats_help` - Show available stats board commands

## 🔗 Useful Resources

- **GMod Wiki:** https://wiki.facepunch.com/gmod/
- **Lua Documentation:** https://www.lua.org/docs.html
- **GMod Lua Reference:** https://wiki.facepunch.com/gmod/Category:Global

## 🤝 Contributing

This is a personal learning repository, but feel free to:
- **Fork** and experiment
- **Suggest improvements** via issues
- **Share** your own learning scripts
- **Ask questions** about the code

## 📝 Notes

- All scripts include **detailed comments** for learning
- **Error handling** and **best practices** are implemented
- Scripts are designed to be **educational** and **modular**
- Each script can be **studied independently**

## 🎮 Testing Environment

**Recommended setup:**
- Garry's Mod Dedicated Server
- Admin privileges for testing commands
- Console access for debugging

## 📧 Contact

**Author:** ELMEHDAOUI Ahmed  
**GitHub:** https://github.com/ELMEHDAOUIAhmed  
**Repository:** https://github.com/ELMEHDAOUIAhmed/Garrysmod_RP

---

*Happy scripting and welcome to the world of Garry's Mod Lua development! 🎉*
