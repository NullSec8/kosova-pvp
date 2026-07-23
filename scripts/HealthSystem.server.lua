-- Kosova PvP - Health & Damage System
-- Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remote events
local damageEvent = Instance.new("RemoteEvent")
damageEvent.Name = "DamageEvent"
damageEvent.Parent = ReplicatedStorage

local killEvent = Instance.new("RemoteEvent")
killEvent.Name = "KillEvent"
killEvent.Parent = ReplicatedStorage

local respawnEvent = Instance.new("RemoteEvent")
respawnEvent.Name = "RespawnEvent"
respawnEvent.Parent = ReplicatedStorage

-- Kill tracking
local killFeed = {}

local function addKillToFeed(killerName, victimName, weapon)
    table.insert(killFeed, {
        Killer = killerName,
        Victim = victimName,
        Weapon = weapon,
        Time = tick()
    })

    -- Keep only last 10 kills
    if #killFeed > 10 then
        table.remove(killFeed, 1)
    end

    -- Fire to all clients
    for _, player in pairs(Players:GetPlayers()) do
        killEvent:FireClient(player, killerName, victimName, weapon)
    end
end

-- Handle death
local function onCharacterAdded(player, character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.Died:Connect(function()
        local killer = nil
        local weapon = "Unknown"

        -- Try to find killer from last damage
        -- This is simplified - in production you'd track last attacker
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                if otherHumanoid and otherHumanoid.Health > 0 then
                    local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local myRoot = character:FindFirstChild("HumanoidRootPart")
                    if rootPart and myRoot then
                        local dist = (rootPart.Position - myRoot.Position).Magnitude
                        if dist < 15 then
                            killer = otherPlayer
                            break
                        end
                    end
                end
            end
        end

        -- Update stats
        if killer and killer:FindFirstChild("leaderstats") then
            killer.leaderstats.Kills.Value = killer.leaderstats.Kills.Value + 1
            addKillToFeed(killer.Name, player.Name, weapon)
        end

        if player:FindFirstChild("leaderstats") then
            player.leaderstats.Deaths.Value = player.leaderstats.Deaths.Value + 1
        end

        -- Respawn after delay
        wait(5)
        player:LoadCharacter()
    end)
end

-- Connect to all players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
end)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        onCharacterAdded(player, player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
end

-- Respawn event
respawnEvent.OnServerEvent:Connect(function(player)
    player:LoadCharacter()
end)

print("Kosova PvP - Health System Loaded!")
