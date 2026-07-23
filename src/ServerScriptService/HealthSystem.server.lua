-- Kosova PvP - Health & Damage System
-- Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local killEvent = Instance.new("RemoteEvent")
killEvent.Name = "KillEvent"
killEvent.Parent = ReplicatedStorage

local gameEvent = ReplicatedStorage:WaitForChild("GameEvent", 10)

local hitEvent = Instance.new("RemoteEvent")
hitEvent.Name = "HitEvent"
hitEvent.Parent = ReplicatedStorage

local soundEvent = ReplicatedStorage:WaitForChild("SoundEvent", 10)

local lastDamageTracker = {}

local function trackDamage(victim, attacker, weapon)
    lastDamageTracker[victim.UserId] = {
        Attacker = attacker,
        Weapon = weapon or "Unknown",
        Time = tick()
    }
end

local combatEvent = ReplicatedStorage:WaitForChild("CombatEvent", 10)
if combatEvent then
    combatEvent.OnServerEvent:Connect(function(player, action, target)
        if action == "Attack" then
            if target and target:FindFirstChild("Humanoid") then
                local targetPlayer = Players:GetPlayerFromCharacter(target)
                if targetPlayer and targetPlayer ~= player then
                    if player.Team and targetPlayer.Team and player.Team ~= targetPlayer.Team then
                        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                        local weaponName = tool and tool.Name or "Unknown"
                        trackDamage(targetPlayer, player, weaponName)
                        hitEvent:FireAllClients(player)
                    end
                end
            end
        end
    end)
end

local function addKillToFeed(killerName, victimName, weapon)
    for _, player in pairs(Players:GetPlayers()) do
        killEvent:FireClient(player, killerName, victimName, weapon)
    end
end

local function onCharacterAdded(player, character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.Died:Connect(function()
        local killer = nil
        local weapon = "Unknown"

        local tracker = lastDamageTracker[player.UserId]
        if tracker and (tick() - tracker.Time) < 10 then
            local candidate = tracker.Attacker
            if candidate and candidate.Parent == Players then
                killer = candidate
            end
            weapon = tracker.Weapon
        end

        if killer and killer:FindFirstChild("leaderstats") then
            killer.leaderstats.Kills.Value = killer.leaderstats.Kills.Value + 1
            addKillToFeed(killer.Name, player.Name, weapon)

            if soundEvent then
                soundEvent:FireAllClients("Kill")
            end

            if gameEvent and killer.Team then
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Team == killer.Team and p ~= killer then
                        gameEvent:FireClient(p, "KillAssist", killer.Name .. " killed " .. player.Name)
                    end
                end
            end
        end

        if player:FindFirstChild("leaderstats") then
            player.leaderstats.Deaths.Value = player.leaderstats.Deaths.Value + 1
        end

        if gameEvent then
            if killer then
                gameEvent:FireClient(player, "Killed", killer.Name)
            else
                gameEvent:FireClient(player, "Killed", "the void")
            end
        end

        lastDamageTracker[player.UserId] = nil

        task.wait(5)
        if player and player.Parent == Players then
            player:LoadCharacter()
        end
    end)
end

local function setupPlayer(player)
    lastDamageTracker[player.UserId] = nil
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
    if player.Character then
        onCharacterAdded(player, player.Character)
    end
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerRemoving:Connect(function(player)
    lastDamageTracker[player.UserId] = nil
end)

print("Kosova PvP - Health System Loaded!")
