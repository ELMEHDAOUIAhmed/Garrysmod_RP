-- Health Cycle Script for Garry's Mod
-- This script lowers player health every second and resets to 100 when it reaches 1

-- Only run on server
if SERVER then
    -- Table to track each player's health cycle timer
    local playerTimers = {}
    
    -- Function to handle health cycling for a player
    local function CyclePlayerHealth(ply)
        if not IsValid(ply) or not ply:Alive() then
            return
        end
        
        local currentHealth = ply:Health()
        
        -- If health is 1 or below, reset to 100
        if currentHealth <= 1 then
            ply:SetHealth(100)
            print("[Health Cycle] " .. ply:Name() .. "'s health reset to 100")
        else
            -- Lower health by 1
            ply:SetHealth(currentHealth - 1)
            print("[Health Cycle] " .. ply:Name() .. "'s health: " .. (currentHealth - 1))
        end
    end
    
    -- Function to start health cycling for a player
    local function StartHealthCycle(ply)
        if not IsValid(ply) then return end
        
        -- Remove existing timer if it exists
        if playerTimers[ply] then
            timer.Remove(playerTimers[ply])
        end
        
        -- Create unique timer name for this player
        local timerName = "HealthCycle_" .. ply:SteamID64()
        playerTimers[ply] = timerName
        
        -- Create repeating timer that runs every 1 second
        timer.Create(timerName, 1, 0, function()
            if IsValid(ply) and ply:Alive() then
                CyclePlayerHealth(ply)
            else
                -- Clean up timer if player is invalid or dead
                timer.Remove(timerName)
                playerTimers[ply] = nil
            end
        end)
        
        print("[Health Cycle] Started health cycling for " .. ply:Name())
    end
    
    -- Function to stop health cycling for a player
    local function StopHealthCycle(ply)
        if playerTimers[ply] then
            timer.Remove(playerTimers[ply])
            playerTimers[ply] = nil
            print("[Health Cycle] Stopped health cycling for " .. ply:Name())
        end
    end
    
    -- Start health cycling when player spawns
    hook.Add("PlayerSpawn", "StartHealthCycling", function(ply)
        print("[Health Cycle] PlayerSpawn detected for " .. ply:Name())
        -- Small delay to ensure player is fully spawned
        timer.Simple(0.1, function()
            if IsValid(ply) then
                StartHealthCycle(ply)
            end
        end)
    end)
    
    -- Auto-start for all currently connected players when script loads
    hook.Add("Initialize", "AutoStartHealthCycle", function()
        timer.Simple(2, function() -- Wait 2 seconds after server start
            for _, ply in pairs(player.GetAll()) do
                if IsValid(ply) and ply:Alive() then
                    print("[Health Cycle] Auto-starting for existing player: " .. ply:Name())
                    StartHealthCycle(ply)
                end
            end
        end)
    end)
    
    -- Stop health cycling when player dies
    hook.Add("PlayerDeath", "StopHealthCycling", function(ply)
        StopHealthCycle(ply)
    end)
    
    -- Clean up when player disconnects
    hook.Add("PlayerDisconnected", "CleanupHealthCycle", function(ply)
        StopHealthCycle(ply)
    end)
    
    -- Console commands for admins to control the system
    concommand.Add("health_cycle_start", function(ply, cmd, args)
        -- Allow console (server) to run this command too
        if IsValid(ply) and not ply:IsAdmin() then
            ply:ChatPrint("You need to be an admin to use this command!")
            return
        end
        
        local target = ply
        if args[1] then
            target = player.GetBySteamID(args[1]) or player.GetByName(args[1])
        elseif not IsValid(ply) then
            -- If run from server console, target all players
            for _, p in pairs(player.GetAll()) do
                if IsValid(p) and p:Alive() then
                    StartHealthCycle(p)
                    print("[Health Cycle] Started for " .. p:Name() .. " via console")
                end
            end
            return
        end
        
        if IsValid(target) then
            StartHealthCycle(target)
            if IsValid(ply) then
                ply:ChatPrint("Started health cycling for " .. target:Name())
            else
                print("[Health Cycle] Started for " .. target:Name() .. " via console")
            end
        else
            if IsValid(ply) then
                ply:ChatPrint("Player not found!")
            else
                print("[Health Cycle] Player not found!")
            end
        end
    end)
    
    concommand.Add("health_cycle_stop", function(ply, cmd, args)
        if not ply:IsAdmin() then
            ply:ChatPrint("You need to be an admin to use this command!")
            return
        end
        
        local target = ply
        if args[1] then
            target = player.GetBySteamID(args[1]) or player.GetByName(args[1])
        end
        
        if IsValid(target) then
            StopHealthCycle(target)
            ply:ChatPrint("Stopped health cycling for " .. target:Name())
        else
            ply:ChatPrint("Player not found!")
        end
    end)
    
    print("[Health Cycle] Script loaded successfully!")
end
