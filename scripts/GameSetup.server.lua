-- Kosova PvP - Main Game Setup
-- Place in ServerScriptService

local Teams = game:GetService("Teams")
local Players = game:GetService("Players")

-- Create Teams
local teamKosova = Instance.new("Team")
teamKosova.Name = "Kosova"
teamKosova.TeamColor = BrickColor.new("Bright red")
teamKosova.AutoAssignable = true
teamKosova.Parent = Teams

local teamRival = Instance.new("Team")
teamRival.Name = "Rival"
teamRival.TeamColor = BrickColor.new("Bright blue")
teamRival.AutoAssignable = true
teamRival.Parent = Teams

-- Create Spawn Points
local function createSpawn(name, position, team)
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = name
    spawn.Position = position
    spawn.Size = Vector3.new(6, 1, 6)
    spawn.Anchored = true
    spawn.CanCollide = true
    spawn.TeamColor = team.TeamColor
    spawn.Neutral = false
    spawn.Parent = workspace
    return spawn
end

-- Kosovo spawns (red side)
createSpawn("KosovaSpawn1", Vector3.new(-50, 5, -50), teamKosova)
createSpawn("KosovaSpawn2", Vector3.new(-50, 5, 50), teamKosova)
createSpawn("KosovaSpawn3", Vector3.new(-30, 5, 0), teamKosova)

-- Rival spawns (blue side)
createSpawn("RivalSpawn1", Vector3.new(50, 5, -50), teamRival)
createSpawn("RivalSpawn2", Vector3.new(50, 5, 50), teamRival)
createSpawn("RivalSpawn3", Vector3.new(30, 5, 0), teamRival)

-- Player Stats Setup
local function onPlayerAdded(player)
    -- Create leaderstats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local kills = Instance.new("IntValue")
    kills.Name = "Kills"
    kills.Value = 0
    kills.Parent = leaderstats

    local deaths = Instance.new("IntValue")
    deaths.Name = "Deaths"
    deaths.Value = 0
    deaths.Parent = leaderstats

    local wins = Instance.new("IntValue")
    wins.Name = "Wins"
    wins.Value = 0
    wins.Parent = leaderstats

    -- Health setup
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end

    player.CharacterAdded:Connect(onCharacterAdded)

    if player.Character then
        onCharacterAdded(player.Character)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Round System
local roundActive = false
local roundTime = 180 -- 3 minutes
local scoreLimit = 20 -- first to 20 kills wins

local function getTeamKills(team)
    local total = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team == team and player:FindFirstChild("leaderstats") then
            total = total + player.leaderstats.Kills.Value
        end
    end
    return total
end

local function resetScores()
    for _, player in pairs(Players:GetPlayers()) do
        if player:FindFirstChild("leaderstats") then
            player.leaderstats.Kills.Value = 0
            player.leaderstats.Deaths.Value = 0
        end
    end
end

local function announceWinner(winningTeam)
    for _, player in pairs(Players:GetPlayers()) do
        -- Could fire a RemoteEvent to show UI
    end
end

-- Main round loop
spawn(function()
    while true do
        wait(5) -- Wait for players
        if #Players:GetPlayers() >= 2 then
            resetScores()
            roundActive = true

            -- Round timer
            for i = roundTime, 0, -1 do
                if not roundActive then break end
                wait(1)

                -- Check score limit
                if getTeamKills(teamKosova) >= scoreLimit then
                    announceWinner(teamKosova)
                    roundActive = false
                    break
                elseif getTeamKills(teamRival) >= scoreLimit then
                    announceWinner(teamRival)
                    roundActive = false
                    break
                end
            end

            roundActive = false
            wait(10) -- Wait between rounds
        end
    end
end)

print("Kosova PvP - Game Setup Loaded!")
