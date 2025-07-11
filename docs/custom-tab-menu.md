# Custom Tab Menu Documentation

**Author:** ELMEHDAOUI Ahmed  
**GitHub:** https://github.com/ELMEHDAOUIAhmed  
**Script Files:** 
- `lua/autorun/client/cl_custom_tab_menu.lua`
- `lua/autorun/server/sv_custom_tab_menu.lua`

## 📋 Overview

A client-server script system that creates a custom tab menu with interactive buttons. Replaces the default scoreboard and demonstrates VGUI creation, networking, and user interaction in GMod Lua.

## 🎯 Learning Objectives

This script teaches:
- ✅ **VGUI Creation** - Building custom user interfaces
- ✅ **Client-Server Communication** - Network messaging with `net` library
- ✅ **Event Handling** - Key bindings and button interactions
- ✅ **UI Design** - Colors, layouts, and visual effects
- ✅ **Input Management** - Capturing and overriding default bindings
- ✅ **Animation & Effects** - Hover states and visual feedback

## 🎨 UI Components

### **Main Frame (DFrame)**
```lua
tabMenu = vgui.Create("DFrame")
tabMenu:SetSize(300, 250)
tabMenu:Center()
tabMenu:MakePopup()
```

### **Custom Paint Functions**
```lua
tabMenu.Paint = function(self, w, h)
    draw.RoundedBox(8, 0, 0, w, h, colors.background)
    draw.RoundedBoxEx(8, 0, 0, w, 30, Color(20, 20, 20, 255), true, true, false, false)
end
```

### **Interactive Buttons (DButton)**
- **Kill Button:** Executes `kill` command
- **Think Button:** Shows random thinking messages
- **Dance Button:** Triggers server-side dance animation
- **Close Button:** Closes the menu

## 🌐 Network Communication

### **Client to Server**
```lua
-- Client sends dance request
net.Start("CustomMenu_Dance")
net.SendToServer()
```

### **Server Response**
```lua
-- Server handles dance action
net.Receive("CustomMenu_Dance", function(len, ply)
    -- Trigger dance animation
    -- Broadcast to all players
end)
```

## 🔧 Core Functions

### **Client-Side Functions**

#### **CreateTabMenu()**
- Creates the main UI frame
- Sets up all buttons with styling
- Handles paint functions and interactions

#### **CloseTabMenu()**
- Safely removes the menu
- Resets state variables
- Disables screen clicker

#### **ToggleTabMenu()**
- Opens menu if closed, closes if open
- Called when TAB key is pressed

### **Server-Side Functions**

#### **Dance Handler**
```lua
net.Receive("CustomMenu_Dance", function(len, ply)
    -- Play dance sequence
    local seqID = ply:LookupSequence(danceSeq)
    ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, seqID, 0, true)
end)
```

## 🎮 Features

### **Key Binding Override**
```lua
hook.Add("PlayerBindPress", "CustomTabMenu", function(ply, bind, pressed)
    if bind == "+showscores" and pressed then -- Tab key
        ToggleTabMenu()
        return true -- Prevent default scoreboard
    end
end)
```

### **Automatic Cleanup**
```lua
-- Close menu when player dies
hook.Add("PlayerDeath", "CloseTabMenuOnDeath", function(victim, inflictor, attacker)
    if victim == LocalPlayer() then
        CloseTabMenu()
    end
end)
```

### **Visual Effects**
- **Hover States:** Buttons change color on mouse over
- **Rounded Corners:** Modern UI appearance
- **Color Schemes:** Consistent theme throughout
- **Emoji Icons:** Visual button identification

## 📊 Technical Implementation

### **VGUI Hierarchy**
```
DFrame (tabMenu)
├── Custom Paint Function
├── DButton (killButton)
├── DButton (thinkButton)
├── DButton (danceButton)
└── DButton (closeButton)
```

### **Color System**
```lua
local colors = {
    background = Color(30, 30, 30, 200),
    button = Color(60, 60, 60, 255),
    buttonHover = Color(80, 80, 80, 255),
    buttonText = Color(255, 255, 255, 255),
    title = Color(100, 200, 255, 255)
}
```

### **Button Creation Pattern**
```lua
local button = vgui.Create("DButton", tabMenu)
button:SetText("Text")
button:SetPos(x, y)
button:SetSize(w, h)
button.Paint = function(self, w, h)
    -- Custom styling
end
button.DoClick = function()
    -- Button action
end
```

## 🚀 Usage Examples

### **Opening Menu**
1. Press **TAB** key in-game
2. Menu appears in center of screen
3. Mouse cursor becomes active

### **Button Actions**
- **💀 Kill:** Instantly kills your character
- **🤔 Think:** Random thinking message in chat
- **💃 Dance:** Character performs dance animation
- **❌ Close:** Closes the menu

### **Chat Output Examples**
```
[Custom Menu] You killed yourself!
[Think] 🤔 Hmm, what should I do next?
[Dance] Player is dancing! 💃🕺
```

## 🐛 Debugging & Troubleshooting

### **Console Output**
```
[Custom Tab Menu] Client script loaded successfully!
[Custom Tab Menu] Server script loaded successfully!
[Custom Tab Menu] Player triggered dance action
```

### **Common Issues**

#### **Menu Not Opening**
- Check if script loaded on client
- Verify TAB key binding
- Ensure not in vehicle or restricted mode

#### **Buttons Not Working**
- Check server console for errors
- Verify network strings are registered
- Test individual button functions

#### **Visual Issues**
- Check color definitions
- Verify paint functions
- Test different screen resolutions

## ⚙️ Customization

### **Adding New Buttons**
```lua
local newButton = vgui.Create("DButton", tabMenu)
newButton:SetText("🎯 New Action")
newButton:SetPos(25, 200)  -- Adjust Y position
newButton:SetSize(250, 40)

newButton.DoClick = function()
    -- Your custom action here
    CloseTabMenu()
end
```

### **Changing Colors**
```lua
-- Modify color scheme
local colors = {
    background = Color(50, 50, 100, 200),  -- Blue theme
    button = Color(70, 70, 120, 255),
    buttonHover = Color(90, 90, 140, 255),
    -- ...
}
```

### **Resizing Menu**
```lua
-- Make menu larger
tabMenu:SetSize(400, 350)

-- Adjust button positions accordingly
button:SetPos(50, 80)  -- Increase margins
button:SetSize(300, 50)  -- Wider buttons
```

## 🎓 Key Concepts Learned

### **Client-Side Development**
1. **VGUI Creation:** Building custom interfaces
2. **Event Handling:** Key bindings and user interactions
3. **Visual Design:** Colors, layouts, and effects
4. **State Management:** Menu open/close states

### **Server-Side Development**
1. **Network Handling:** Receiving client messages
2. **Player Animation:** Gesture and sequence management
3. **Broadcasting:** Sending messages to all players

### **Communication**
1. **Network Strings:** Registering communication channels
2. **Client-Server Flow:** Request-response patterns
3. **Data Validation:** Checking player validity

## 🔗 Related Learning

### **Prerequisites**
- Basic Lua knowledge
- Understanding of client vs server concept
- GMod hook system basics

### **Next Steps**
- **Advanced VGUI:** DScrollPanel, DPropertySheet, custom derma
- **Networking:** Sending data with net messages
- **Animations:** More complex player animations
- **Persistence:** Saving user preferences

### **Combine With**
- Database systems for persistent menus
- Admin systems for permission-based buttons
- Sound systems for audio feedback

## 📝 File Structure

### **Client (`cl_custom_tab_menu.lua`)**
```
Client Script
├── Variables & Setup
├── UI Creation Functions
│   ├── CreateTabMenu()
│   ├── CloseTabMenu()
│   └── ToggleTabMenu()
├── Button Definitions
│   ├── Kill Button
│   ├── Think Button
│   ├── Dance Button
│   └── Close Button
├── Event Hooks
│   ├── PlayerBindPress (TAB)
│   └── PlayerDeath (cleanup)
└── Network Setup
```

### **Server (`sv_custom_tab_menu.lua`)**
```
Server Script
├── Network Strings
├── Dance Sequences
├── Network Receivers
│   └── CustomMenu_Dance
├── Admin Commands
└── Utility Functions
```

## 🎨 UI Design Principles

1. **Consistency:** Same styling across all elements
2. **Feedback:** Visual response to user interactions
3. **Clarity:** Clear button labels and functions
4. **Accessibility:** Easy to read and navigate
5. **Performance:** Efficient paint functions

---

**Perfect for:** Intermediate developers learning VGUI and networking  
**Difficulty:** ⭐⭐⭐☆☆ (Intermediate)  
**Concepts:** VGUI, Networking, UI Design, Event Handling
