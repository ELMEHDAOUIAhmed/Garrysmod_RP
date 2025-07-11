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
    
    -- Colors for the UI (black buttons with white text)
    local colors = {
        background = Color(25, 25, 30, 240),      -- Dark background
        button = Color(15, 15, 20, 255),          -- Black buttons
        buttonText = Color(255, 255, 255, 255),   -- Pure white text
        title = Color(120, 180, 255, 255),        -- Bright blue title
        titleBar = Color(20, 20, 25, 255),        -- Very dark title bar
        border = Color(60, 60, 70, 150),          -- Subtle border
        closeButton = Color(40, 15, 15, 255)      -- Dark red for close
    }
    
    -- Function to create the tab menu
    local function CreateTabMenu()
        if IsValid(tabMenu) then
            tabMenu:Remove()
        end
        
        -- Main frame
        tabMenu = vgui.Create("DFrame")
        tabMenu:SetSize(300, 300)  -- Increased height for new button
        tabMenu:Center()
        tabMenu:SetTitle("")
        tabMenu:SetDraggable(false)
        tabMenu:ShowCloseButton(false)
        tabMenu:SetDeleteOnClose(false)
        tabMenu:MakePopup()
        
        -- Custom paint function for the frame
        tabMenu.Paint = function(self, w, h)
            -- Background
            draw.RoundedBox(8, 0, 0, w, h, colors.background)
            
            -- Title bar
            draw.RoundedBoxEx(8, 0, 0, w, 35, colors.titleBar, true, true, false, false)
            
            -- Title text
            draw.SimpleText("Custom Menu", "DermaDefaultBold", w/2, 17, colors.title, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            
            -- Border
            surface.SetDrawColor(colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        -- Kill button
        local killButton = vgui.Create("DButton", tabMenu)
        killButton:SetText("Kill Yourself")
        killButton:SetPos(25, 60)
        killButton:SetSize(250, 40)
        killButton:SetFont("DermaDefaultBold")
        killButton:SetTextColor(colors.buttonText)
        
        killButton.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, colors.button)
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
        thinkButton:SetText("Think")
        thinkButton:SetPos(25, 110)
        thinkButton:SetSize(250, 40)
        thinkButton:SetFont("DermaDefaultBold")
        thinkButton:SetTextColor(colors.buttonText)
        
        thinkButton.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, colors.button)
            surface.SetDrawColor(colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        thinkButton.DoClick = function()
            -- Random thinking messages
            local thinkMessages = {
                "Hmm, what should I do next?",
                "Thinking about life...",
                "Processing thoughts...",
                "Maybe I should explore more...",
                "So many possibilities...",
                "Planning my next move...",
                "Dreaming of adventures...",
                "Ideas are flowing..."
            }
            
            local randomMessage = thinkMessages[math.random(#thinkMessages)]
            chat.AddText(Color(100, 200, 255), "[Think] ", Color(255, 255, 255), randomMessage)
            CloseTabMenu()
        end
        
        -- Dance button (extra fun feature)
        local danceButton = vgui.Create("DButton", tabMenu)
        danceButton:SetText("Dance")
        danceButton:SetPos(25, 160)
        danceButton:SetSize(250, 40)
        danceButton:SetFont("DermaDefaultBold")
        danceButton:SetTextColor(colors.buttonText)
        
        danceButton.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, colors.button)
            surface.SetDrawColor(colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        danceButton.DoClick = function()
            -- Send dance command to server
            net.Start("CustomMenu_Dance")
            net.SendToServer()
            CloseTabMenu()
            chat.AddText(Color(255, 200, 100), "[Dance] ", Color(255, 255, 255), "You're dancing!")
        end
        
        -- Stats Board button (NEW!)
        local statsButton = vgui.Create("DButton", tabMenu)
        statsButton:SetText("Toggle Stats Board")
        statsButton:SetPos(25, 210)
        statsButton:SetSize(250, 40)
        statsButton:SetFont("DermaDefaultBold")
        statsButton:SetTextColor(colors.buttonText)
        
        statsButton.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, colors.button)
            surface.SetDrawColor(colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        statsButton.DoClick = function()
            ToggleStatsBoard()  -- Function from stats board script
            CloseTabMenu()
            chat.AddText(Color(100, 255, 200), "[Stats Board] ", Color(255, 255, 255), "Stats board toggled!")
        end
        
        -- Close button
        local closeButton = vgui.Create("DButton", tabMenu)
        closeButton:SetText("Close")
        closeButton:SetPos(25, 260)
        closeButton:SetSize(250, 25)
        closeButton:SetFont("DermaDefault")
        closeButton:SetTextColor(colors.buttonText)
        
        closeButton.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, colors.closeButton)
            surface.SetDrawColor(Color(100, 30, 30))
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
    
    print("[Custom Tab Menu] Client script loaded successfully!")
end
