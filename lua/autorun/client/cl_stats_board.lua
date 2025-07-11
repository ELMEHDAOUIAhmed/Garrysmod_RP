--[[
    Script Name: Stats Board
    Author: ELMEHDAOUI Ahmed
    GitHub: https://github.com/ELMEHDAOUIAhmed
    Description: Real-time player statistics board showing player info, server stats, and more
    Date: July 11, 2025
--]]

if CLIENT then
    local statsBoard = nil
    local isStatsBoardOpen = false
    local updateTimer = nil
    
    -- User customizable keybind (default: CapsLock)
    local statsKeybind = CreateClientConVar("stats_board_key", "KEY_CAPSLOCK", true, false, "Key to toggle stats board")
    
    -- Colors for the stats board
    local colors = {
        background = Color(20, 20, 25, 230),      -- Very dark background
        header = Color(15, 15, 20, 255),          -- Darker header
        playerRow = Color(30, 30, 35, 200),       -- Dark player rows
        playerRowAlt = Color(25, 25, 30, 200),    -- Alternating row color
        text = Color(255, 255, 255, 255),         -- White text
        textSecondary = Color(200, 200, 200, 255), -- Light gray text
        accent = Color(100, 150, 255, 255),       -- Blue accent
        border = Color(50, 50, 60, 150),          -- Subtle border
        admin = Color(255, 100, 100, 255),        -- Red for admins
        alive = Color(100, 255, 100, 255),        -- Green for alive
        dead = Color(255, 100, 100, 255)          -- Red for dead
    }
    
    -- Function to format time
    local function FormatTime(seconds)
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        
        if hours > 0 then
            return string.format("%02d:%02d:%02d", hours, minutes, secs)
        else
            return string.format("%02d:%02d", minutes, secs)
        end
    end
    
    -- Function to get ping color
    local function GetPingColor(ping)
        if ping < 50 then return Color(100, 255, 100) -- Green
        elseif ping < 100 then return Color(255, 255, 100) -- Yellow
        else return Color(255, 100, 100) end -- Red
    end
    
    -- Function to create the stats board
    local function CreateStatsBoard()
        if IsValid(statsBoard) then
            statsBoard:Remove()
        end
        
        -- Main frame
        statsBoard = vgui.Create("DFrame")
        statsBoard:SetSize(450, ScrH() - 100)
        statsBoard:SetPos(20, 50)
        statsBoard:SetTitle("")
        statsBoard:SetDraggable(true)
        statsBoard:ShowCloseButton(false)
        statsBoard:SetDeleteOnClose(false)
        statsBoard:MakePopup()
        statsBoard:SetKeyboardInputEnabled(false)
        statsBoard:SetMouseInputEnabled(true)
        
        -- Prevent mouse capture so movement isn't locked
        statsBoard.OnFocusChanged = function(self, gained)
            if gained then
                gui.EnableScreenClicker(false)
            end
        end
        
        -- Custom paint for main frame
        statsBoard.Paint = function(self, w, h)
            -- Background
            draw.RoundedBox(8, 0, 0, w, h, colors.background)
            
            -- Header
            draw.RoundedBoxEx(8, 0, 0, w, 40, colors.header, true, true, false, false)
            
            -- Title
            draw.SimpleText("Server Statistics", "DermaDefaultBold", w/2, 20, colors.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            
            -- Border
            surface.SetDrawColor(colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        
        -- Close button
        local closeBtn = vgui.Create("DButton", statsBoard)
        closeBtn:SetText("X")
        closeBtn:SetPos(statsBoard:GetWide() - 30, 5)
        closeBtn:SetSize(25, 30)
        closeBtn:SetFont("DermaDefaultBold")
        closeBtn.Paint = function(self, w, h)
            local bgColor = self:IsHovered() and Color(200, 50, 50) or Color(150, 50, 50)
            draw.RoundedBox(4, 0, 0, w, h, bgColor)
        end
        closeBtn.DoClick = function()
            CloseStatsBoard()
        end
        
        -- Scroll panel for content
        local scroll = vgui.Create("DScrollPanel", statsBoard)
        scroll:SetPos(10, 50)
        scroll:SetSize(statsBoard:GetWide() - 20, statsBoard:GetTall() - 60)
        
        -- Custom scrollbar
        local sbar = scroll:GetVBar()
        sbar:SetHideButtons(true)
        sbar.Paint = function() end
        sbar.btnGrip.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(60, 60, 70))
        end
        
        -- Content panel
        local content = vgui.Create("DPanel", scroll)
        content:SetSize(scroll:GetWide() - 15, 1000)
        content.Paint = function() end
        
        local yPos = 10
        
        -- Server info section
        local serverInfo = vgui.Create("DLabel", content)
        serverInfo:SetPos(10, yPos)
        serverInfo:SetSize(content:GetWide() - 20, 25)
        serverInfo:SetFont("DermaDefaultBold")
        serverInfo:SetTextColor(colors.accent)
        serverInfo:SetText("Server Information")
        yPos = yPos + 30
        
        -- Server details
        local serverDetails = {
            "Map: " .. game.GetMap(),
            "Server Time: " .. os.date("%H:%M:%S", os.time()),
            "Game Mode: " .. engine.ActiveGamemode(),
            "Server Name: " .. GetHostName(),
            "Tickrate: " .. math.Round(1 / engine.TickInterval()) .. " Hz",
            "",
            "Keybind: " .. statsKeybind:GetString() .. " (change with: stats_board_bind <key>)"
        }
        
        for _, detail in ipairs(serverDetails) do
            local label = vgui.Create("DLabel", content)
            label:SetPos(20, yPos)
            label:SetSize(content:GetWide() - 40, 20)
            label:SetFont("DermaDefault")
            label:SetTextColor(colors.text)
            label:SetText(detail)
            yPos = yPos + 22
        end
        
        yPos = yPos + 20
        
        -- Players section header
        local playersHeader = vgui.Create("DLabel", content)
        playersHeader:SetPos(10, yPos)
        playersHeader:SetSize(content:GetWide() - 20, 25)
        playersHeader:SetFont("DermaDefaultBold")
        playersHeader:SetTextColor(colors.accent)
        yPos = yPos + 30
        
        -- Function to update player list
        local function UpdatePlayerList()
            if not IsValid(statsBoard) then return end
            
            local players = player.GetAll()
            local bots = 0
            local admins = 0
            local alivePlayers = 0
            
            -- Count stats
            for _, ply in ipairs(players) do
                if ply:IsBot() then bots = bots + 1 end
                if ply:IsAdmin() then admins = admins + 1 end
                if ply:Alive() then alivePlayers = alivePlayers + 1 end
            end
            
            -- Update header text
            playersHeader:SetText(string.format("Players (%d/%d) | Bots: %d | Admins: %d | Alive: %d", 
                #players, game.MaxPlayers(), bots, admins, alivePlayers))
            
            -- Clear existing player panels
            for _, child in ipairs(content:GetChildren()) do
                if child.IsPlayerPanel then
                    child:Remove()
                end
            end
            
            local playerYPos = yPos
            
            -- Add player entries
            for i, ply in ipairs(players) do
                local playerPanel = vgui.Create("DPanel", content)
                playerPanel:SetPos(10, playerYPos)
                playerPanel:SetSize(content:GetWide() - 20, 35)
                playerPanel.IsPlayerPanel = true
                
                playerPanel.Paint = function(self, w, h)
                    local bgColor = (i % 2 == 0) and colors.playerRowAlt or colors.playerRow
                    draw.RoundedBox(4, 0, 0, w, h, bgColor)
                    
                    -- Player name with status icons
                    local nameText = ply:Name()
                    if ply:IsBot() then nameText = "[BOT] " .. nameText end
                    if ply:IsAdmin() then nameText = "[ADMIN] " .. nameText end
                    
                    local nameColor = ply:IsAdmin() and colors.admin or colors.text
                    draw.SimpleText(nameText, "DermaDefault", 10, h/2, nameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    
                    -- Status (Alive/Dead)
                    local statusText = ply:Alive() and "Alive" or "Dead"
                    local statusColor = ply:Alive() and colors.alive or colors.dead
                    draw.SimpleText(statusText, "DermaDefault", w - 250, h/2, statusColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    
                    -- Health (if alive)
                    if ply:Alive() then
                        local healthText = ply:Health() .. " HP"
                        draw.SimpleText(healthText, "DermaDefault", w - 150, h/2, colors.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    
                    -- Ping
                    if not ply:IsBot() then
                        local ping = ply:Ping()
                        local pingColor = GetPingColor(ping)
                        draw.SimpleText(ping .. "ms", "DermaDefault", w - 50, h/2, pingColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                end
                
                playerYPos = playerYPos + 37
            end
            
            -- Update content height
            content:SetTall(playerYPos + 50)
        end
        
        -- Initial update
        UpdatePlayerList()
        
        -- Set up update timer
        updateTimer = timer.Create("StatsBoard_Update", 1, 0, function()
            if IsValid(statsBoard) then
                UpdatePlayerList()
                
                -- Update server time
                for _, child in ipairs(content:GetChildren()) do
                    if child:GetText() and string.find(child:GetText(), "Server Time") then
                        local newText = string.gsub(child:GetText(), "%d%d:%d%d:%d%d", os.date("%H:%M:%S", os.time()))
                        child:SetText(newText)
                        break
                    end
                end
            else
                timer.Remove("StatsBoard_Update")
            end
        end)
        
        isStatsBoardOpen = true
    end
    
    -- Function to close stats board
    function CloseStatsBoard()
        if IsValid(statsBoard) then
            statsBoard:Remove()
            statsBoard = nil
        end
        if timer.Exists("StatsBoard_Update") then
            timer.Remove("StatsBoard_Update")
        end
        -- Ensure mouse input is restored
        gui.EnableScreenClicker(false)
        isStatsBoardOpen = false
    end
    
    -- Function to toggle stats board
    function ToggleStatsBoard()
        if isStatsBoardOpen then
            CloseStatsBoard()
        else
            CreateStatsBoard()
        end
    end
    
    -- Console command for toggling
    concommand.Add("toggle_stats_board", function()
        ToggleStatsBoard()
    end)
    
    -- Console command for changing keybind
    concommand.Add("stats_board_bind", function(ply, cmd, args)
        if args[1] then
            local newKey = string.upper(args[1])
            -- Add KEY_ prefix if not present
            if not string.find(newKey, "KEY_") then
                newKey = "KEY_" .. newKey
            end
            
            RunConsoleCommand("stats_board_key", newKey)
            chat.AddText(Color(100, 255, 200), "[Stats Board] ", Color(255, 255, 255), "Keybind changed to: " .. newKey)
        else
            chat.AddText(Color(255, 100, 100), "[Stats Board] ", Color(255, 255, 255), "Usage: stats_board_bind <key>")
            chat.AddText(Color(200, 200, 200), "Examples: stats_board_bind F1, stats_board_bind CAPSLOCK, stats_board_bind TAB")
        end
    end)
    
    -- Key press detection
    hook.Add("PlayerButtonDown", "StatsBoard_KeyPress", function(ply, button)
        if ply ~= LocalPlayer() then return end
        
        local keyName = "KEY_" .. string.upper(input.GetKeyName(button) or "")
        local bindKey = statsKeybind:GetString()
        
        -- Handle different key name formats
        if keyName == bindKey or 
           ("KEY_" .. keyName) == bindKey or
           keyName == ("KEY_" .. bindKey) then
            ToggleStatsBoard()
        end
    end)
    
    -- Help command
    concommand.Add("stats_board_help", function()
        chat.AddText(Color(100, 150, 255), "=== Stats Board Help ===")
        chat.AddText(Color(255, 255, 255), "Commands:")
        chat.AddText(Color(200, 200, 200), "  toggle_stats_board - Toggle the stats board")
        chat.AddText(Color(200, 200, 200), "  stats_board_bind <key> - Change keybind")
        chat.AddText(Color(200, 200, 200), "  stats_board_help - Show this help")
        chat.AddText(Color(255, 255, 255), "Current keybind: " .. statsKeybind:GetString())
        chat.AddText(Color(255, 255, 255), "Example: stats_board_bind F1")
    end)
    
    -- Close stats board on death
    hook.Add("PlayerDeath", "CloseStatsBoardOnDeath", function(victim)
        if victim == LocalPlayer() and isStatsBoardOpen then
            CloseStatsBoard()
        end
    end)
    
    print("[Stats Board] Client script loaded successfully!")
    print("[Stats Board] Default keybind: " .. statsKeybind:GetString())
    print("[Stats Board] Type 'stats_board_help' for commands")
end
