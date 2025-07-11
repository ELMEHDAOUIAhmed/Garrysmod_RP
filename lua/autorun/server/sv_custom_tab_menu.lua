--[[
    Script Name: Custom Tab Menu Server
    Author: ELMEHDAOUI Ahmed
    GitHub: https://github.com/ELMEHDAOUIAhmed
    Description: Server-side handler for custom tab menu actions
    Date: July 11, 2025
--]]

-- Server-side script
if SERVER then
    -- Add network string for dance action
    util.AddNetworkString("CustomMenu_Dance")
    
    -- Dance sequences (common GMod gestures)
    local danceSequences = {
        "gesture_becon",
        "gesture_bow", 
        "gesture_wave",
        "taunt_dance",
        "taunt_laugh",
        "taunt_zombie"
    }
    
    -- Handle dance network message
    net.Receive("CustomMenu_Dance", function(len, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        
        -- Pick a random dance sequence
        local danceSeq = danceSequences[math.random(#danceSequences)]
        local seqID = ply:LookupSequence(danceSeq)
        
        local danced = false
        
        -- Try to play the selected dance sequence
        if seqID and seqID > 0 then
            ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, seqID, 0, true)
            danced = true
            print("[Dance Debug] Playing sequence: " .. danceSeq .. " (ID: " .. seqID .. ")")
        end
        
        -- If gesture failed, try the physical dance
        if not danced then
            print("[Dance Debug] Gesture failed, using physical dance")
            -- Make them spin and jump
            local vel = ply:GetVelocity()
            ply:SetVelocity(Vector(0, 0, 250) + vel)
            
            -- Spin effect
            timer.Create("dance_spin_" .. ply:SteamID(), 0.1, 15, function()
                if IsValid(ply) and ply:Alive() then
                    local ang = ply:GetAngles()
                    ply:SetAngles(Angle(ang.p, ang.y + 24, ang.r))
                end
            end)
            
            danced = true
        end
        
        -- Broadcast to all players that someone is dancing
        for _, p in pairs(player.GetAll()) do
            if IsValid(p) then
                if danced then
                    p:ChatPrint("[Dance] " .. ply:Name() .. " is dancing!")
                else
                    p:ChatPrint("[Dance] " .. ply:Name() .. " tried to dance but failed!")
                end
            end
        end
        
        -- Debug information
        print("[Custom Tab Menu] " .. ply:Name() .. " triggered dance action - Success: " .. tostring(danced))
    end)
    
    -- Console command to test dance functionality
    concommand.Add("test_dance", function(ply, cmd, args)
        if not IsValid(ply) then return end
        
        -- Trigger the same dance logic
        local danceSequences = {
            "gesture_becon",
            "gesture_bow", 
            "gesture_wave",
            "taunt_dance",
            "taunt_laugh",
            "taunt_zombie"
        }
        
        ply:ChatPrint("[Test Dance] Testing dance sequences...")
        
        for i, seq in pairs(danceSequences) do
            local seqID = ply:LookupSequence(seq)
            ply:ChatPrint(seq .. " = " .. (seqID or "nil"))
        end
        
        -- Force the fallback dance
        local vel = ply:GetVelocity()
        ply:SetVelocity(Vector(0, 0, 250) + vel)
        
        timer.Create("test_dance_spin_" .. ply:SteamID(), 0.1, 15, function()
            if IsValid(ply) and ply:Alive() then
                local ang = ply:GetAngles()
                ply:SetAngles(Angle(ang.p, ang.y + 24, ang.r))
            end
        end)
        
        ply:ChatPrint("[Test Dance] Fallback dance executed!")
    end)
    
    -- Console command to trigger actual dance with gesture
    concommand.Add("dance_gesture", function(ply, cmd, args)
        if not IsValid(ply) then return end
        
        local sequences = {"gesture_becon", "gesture_bow", "gesture_wave", "taunt_dance", "taunt_laugh", "taunt_zombie"}
        local chosen = args[1] or sequences[math.random(#sequences)]
        
        local seqID = ply:LookupSequence(chosen)
        if seqID and seqID > 0 then
            ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, seqID, 0, true)
            ply:ChatPrint("[Dance Gesture] Playing: " .. chosen .. " (ID: " .. seqID .. ")")
            
            -- Also broadcast to others
            for _, p in pairs(player.GetAll()) do
                if IsValid(p) and p ~= ply then
                    p:ChatPrint("[Dance] " .. ply:Name() .. " is doing " .. chosen .. "!")
                end
            end
        else
            ply:ChatPrint("[Dance Gesture] Failed to find sequence: " .. chosen)
        end
    end)
    
    -- Optional: Add admin command to open menu for specific player
    concommand.Add("custom_menu_open", function(ply, cmd, args)
        if not ply:IsAdmin() then
            ply:ChatPrint("You need to be an admin to use this command!")
            return
        end
        
        local target = ply
        if args[1] then
            target = player.GetBySteamID(args[1]) or player.GetByName(args[1])
        end
        
        if IsValid(target) then
            -- Send a net message to force open menu (optional feature)
            ply:ChatPrint("Menu opened for " .. target:Name())
        else
            ply:ChatPrint("Player not found!")
        end
    end)
    
    -- Log when script loads
    print("[Custom Tab Menu] Server script loaded successfully!")
end
