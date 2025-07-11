--[[
    Script Name: Custom Tab Menu
    Author: ELMEHDAOUI Ahmed
    GitHub: https://github.com/ELMEHDAOUIAhmed
    Description: Custom tab menu with kill button and think action
    Date: July 11, 2025
--]]

-- Client-side GUI script
if CLIENT then
    local tabMenu = nil
    local isMenuOpen = false
    
    -- Colors for the UI (improved visibility)
    local colors = {
        background = Color(45, 45, 55, 240),      -- Darker blue-gray with more opacity
        button = Color(70, 85, 100, 255),         -- Blue-gray buttons for better contrast
        buttonHover = Color(90, 115, 140, 255),   -- Brighter blue on hover
        buttonText = Color(255, 255, 255, 255),   -- Pure white text
        title = Color(120, 180, 255, 255),        -- Bright blue title
        titleBar = Color(25, 30, 40, 255),        -- Dark title bar background
        border = Color(120, 140, 160, 150)       -- Subtle border color
    }
    
    -- Function to create the tab menu
    local function CreateTabMenu()
        if IsValid(tabMenu) then
            tabMenu:Remove()
        end
        
        -- Main frame
        tabMenu = vgui.Create("DFrame")
        tabMenu:SetSize(300, 250)
        tabMenu:Center()
        tabMenu:SetTitle("")
        tabMenu:SetDraggable(false)
        tabMenu:ShowCloseButton(false)
        tabMenu:SetDeleteOnClose(false)
        tabMenu:MakePopup()
        
        -- Custom paint function for the frame
        tabMenu.Paint = function(self, w, h)
            -- Background with subtle border
            draw.RoundedBox(8, 0, 0, w, h, colors.background)
            draw.RoundedBox(8, 1, 1, w-2, h-2, Color(0, 0, 0, 0)) -- Inner border effect
            
            -- Title bar with gradient effect
            draw.RoundedBoxEx(8, 0, 0, w, 35, colors.titleBar, true, true, false, false)
            draw.RoundedBoxEx(0, 0, 30, w, 5, Color(colors.titleBar.r + 15, colors.titleBar.g + 15, colors.titleBar.b + 15, 100), false, false, false, false)
            
            -- Title text with shadow effect
            draw.SimpleText("Custom Menu", "DermaDefaultBold", w/2 + 1, 18, Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Shadow
            draw.SimpleText("Custom Menu", "DermaDefaultBold", w/2, 17, colors.title, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Main text
        end
        
        -- Kill button
        local killButton = vgui.Create("DButton", tabMenu)
        killButton:SetText("💀 Kill Yourself")
        killButton:SetPos(25, 60)
        killButton:SetSize(250, 40)
        killButton:SetFont("DermaDefaultBold")
        
        killButton.Paint = function(self, w, h)
            local bgColor = self:IsHovered() and colors.buttonHover or colors.button
            
            -- Button background with subtle gradient
            draw.RoundedBox(6, 0, 0, w, h, bgColor)
            draw.RoundedBox(6, 1, 1, w-2, h/2, Color(bgColor.r + 20, bgColor.g + 20, bgColor.b + 20, 80)) -- Top highlight
            
            -- Border with improved visibility
            surface.SetDrawColor(colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        killButton.DoClick = function()
            -- Send kill command to server
            RunConsoleCommand("kill")
            CloseTabMenu()
            chat.AddText(Color(255, 100, 100), "[Custom Menu] ", Color(255, 255, 255), "You killed yourself!")
        end
        
        -- Think button
        local thinkButton = vgui.Create("DButton", tabMenu)
        thinkButton:SetText("🤔 Think")
        thinkButton:SetPos(25, 110)
        thinkButton:SetSize(250, 40)
        thinkButton:SetFont("DermaDefaultBold")
        
        thinkButton.Paint = function(self, w, h)
            local bgColor = self:IsHovered() and colors.buttonHover or colors.button
            
            -- Button background with subtle gradient
            draw.RoundedBox(6, 0, 0, w, h, bgColor)
            draw.RoundedBox(6, 1, 1, w-2, h/2, Color(bgColor.r + 20, bgColor.g + 20, bgColor.b + 20, 80)) -- Top highlight
            
            -- Border with improved visibility
            surface.SetDrawColor(colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        thinkButton.DoClick = function()
            -- Random thinking messages
            local thinkMessages = {
                "🤔 Hmm, what should I do next?",
                "💭 Thinking about life...",
                "🧠 Processing thoughts...",
                "💡 Maybe I should explore more...",
                "🤯 So many possibilities...",
                "🎯 Planning my next move...",
                "🌟 Dreaming of adventures...",
                "⚡ Ideas are flowing..."
            }
            
            local randomMessage = thinkMessages[math.random(#thinkMessages)]
            chat.AddText(Color(100, 200, 255), "[Think] ", Color(255, 255, 255), randomMessage)
            CloseTabMenu()
        end
        
        -- Dance button (extra fun feature)
        local danceButton = vgui.Create("DButton", tabMenu)
        danceButton:SetText("💃 Dance")
        danceButton:SetPos(25, 160)
        danceButton:SetSize(250, 40)
        danceButton:SetFont("DermaDefaultBold")
        
        danceButton.Paint = function(self, w, h)
            local bgColor = self:IsHovered() and colors.buttonHover or colors.button
            
            -- Button background with subtle gradient
            draw.RoundedBox(6, 0, 0, w, h, bgColor)
            draw.RoundedBox(6, 1, 1, w-2, h/2, Color(bgColor.r + 20, bgColor.g + 20, bgColor.b + 20, 80)) -- Top highlight
            
            -- Border with improved visibility
            surface.SetDrawColor(colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        danceButton.DoClick = function()
            -- Send dance command to server
            net.Start("CustomMenu_Dance")
            net.SendToServer()
            CloseTabMenu()
            chat.AddText(Color(255, 200, 100), "[Dance] ", Color(255, 255, 255), "You're dancing! 💃🕺")
        end
        
        -- Close button
        local closeButton = vgui.Create("DButton", tabMenu)
        closeButton:SetText("❌ Close")
        closeButton:SetPos(25, 210)
        closeButton:SetSize(250, 25)
        closeButton:SetFont("DermaDefault")
        
        closeButton.Paint = function(self, w, h)
            local bgColor = self:IsHovered() and Color(180, 70, 70, 255) or Color(120, 50, 50, 255)
            
            -- Close button with red theme and gradient
            draw.RoundedBox(4, 0, 0, w, h, bgColor)
            draw.RoundedBox(4, 1, 1, w-2, h/2, Color(bgColor.r + 30, bgColor.g + 15, bgColor.b + 15, 60)) -- Top highlight
            
            -- Border
            surface.SetDrawColor(Color(bgColor.r + 40, bgColor.g + 20, bgColor.b + 20, 150))
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        closeButton.DoClick = function()
            CloseTabMenu()
        end
        
        isMenuOpen = true
    end
    
    -- Function to close the tab menu
    function CloseTabMenu()
        if IsValid(tabMenu) then
            tabMenu:Remove()
            tabMenu = nil
        end
        isMenuOpen = false
        gui.EnableScreenClicker(false)
    end
    
    -- Function to toggle the tab menu
    local function ToggleTabMenu()
        if isMenuOpen then
            CloseTabMenu()
        else
            CreateTabMenu()
        end
    end
    
    -- Hook for tab key press
    hook.Add("PlayerBindPress", "CustomTabMenu", function(ply, bind, pressed)
        if bind == "+showscores" and pressed then -- Tab key
            ToggleTabMenu()
            return true -- Prevent default scoreboard
        end
    end)
    
    -- Close menu when player dies or disconnects
    hook.Add("PlayerDeath", "CloseTabMenuOnDeath", function(victim, inflictor, attacker)
        if victim == LocalPlayer() then
            CloseTabMenu()
        end
    end)
    
    -- Network message for dance
    if not net.Receivers["CustomMenu_Dance"] then
        net.Receive("CustomMenu_Dance", function()
            -- This will be handled by the server
        end)
    end
    
    print("[Custom Tab Menu] Client script loaded successfully!")
end
