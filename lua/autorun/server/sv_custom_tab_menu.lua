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
    
    -- Dance sequences (if available)
    local danceSequences = {
        "gesture_becon",
        "gesture_bow",
        "gesture_wave",
        "taunt_dance",
        "taunt_laugh"
    }
    
    -- Handle dance network message
    net.Receive("CustomMenu_Dance", function(len, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        
        -- Pick a random dance sequence
        local danceSeq = danceSequences[math.random(#danceSequences)]
        
        -- Try to play the dance sequence
        local seqID = ply:LookupSequence(danceSeq)
        if seqID and seqID > 0 then
            ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, seqID, 0, true)
        else
            -- Fallback: just make them jump
            ply:SetVelocity(Vector(0, 0, 200))
        end
        
        -- Broadcast to all players that someone is dancing
        for _, p in pairs(player.GetAll()) do
            if IsValid(p) then
                p:ChatPrint("[Dance] " .. ply:Name() .. " is dancing! 💃🕺")
            end
        end
        
        print("[Custom Tab Menu] " .. ply:Name() .. " triggered dance action")
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
