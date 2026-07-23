-- Kosova PvP - Main Game Setup
-- Place in ServerScriptService

local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

local gameEvent = Instance.new("RemoteEvent")
gameEvent.Name = "GameEvent"
gameEvent.Parent = ReplicatedStorage

local function createSpawn(name, position, team)
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = name
    spawn.Position = position
    spawn.Size = Vector3.new(6, 1, 6)
    spawn.Anchored = true
    spawn.CanCollide = true
    spawn.TeamColor = team.TeamColor
    spawn.Neutral = false
    spawn.Material = Enum.Material.Neon
    spawn.Transparency = 0.5
    spawn.Parent = workspace

    local light = Instance.new("PointLight")
    light.Brightness = 1
    light.Range = 15
    light.Color = team.TeamColor == BrickColor.new("Bright red") and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 100, 255)
    light.Parent = spawn

    return spawn
end

createSpawn("KosovaSpawn1", Vector3.new(-60, 1.5, -15), teamKosova)
createSpawn("KosovaSpawn2", Vector3.new(-60, 1.5, 15), teamKosova)
createSpawn("KosovaSpawn3", Vector3.new(-50, 1.5, 0), teamKosova)

createSpawn("RivalSpawn1", Vector3.new(60, 1.5, -15), teamRival)
createSpawn("RivalSpawn2", Vector3.new(60, 1.5, 15), teamRival)
createSpawn("RivalSpawn3", Vector3.new(50, 1.5, 0), teamRival)

local function onPlayerAdded(player)
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

local roundActive = false
local roundTime = 180
local scoreLimit = 20
local kosovaWins = 0
local rivalWins = 0

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

local function fireAll(action, data)
    for _, player in pairs(Players:GetPlayers()) do
        gameEvent:FireClient(player, action, data)
    end
end

local function announceWinner(winningTeamName)
    fireAll("RoundEnd", winningTeamName)
    if winningTeamName == "Kosova" then
        kosovaWins = kosovaWins + 1
    elseif winningTeamName == "Rival" then
        rivalWins = rivalWins + 1
    end
end

task.spawn(function()
    while true do
        task.wait(2)
        if #Players:GetPlayers() >= 2 then
            resetScores()

            fireAll("Intermission", 5)
            task.wait(5)

            roundActive = true
            fireAll("RoundStart")

            for i = roundTime, 0, -1 do
                if not roundActive then break end
                fireAll("Timer", i)
                task.wait(1)

                if getTeamKills(teamKosova) >= scoreLimit then
                    announceWinner("Kosova")
                    roundActive = false
                    break
                elseif getTeamKills(teamRival) >= scoreLimit then
                    announceWinner("Rival")
                    roundActive = false
                    break
                end
            end

            if roundActive then
                if getTeamKills(teamKosova) > getTeamKills(teamRival) then
                    announceWinner("Kosova")
                elseif getTeamKills(teamRival) > getTeamKills(teamKosova) then
                    announceWinner("Rival")
                else
                    announceWinner("DRAW")
                end
                roundActive = false
            end

            fireAll("Intermission", 10)
            task.wait(10)
        else
            fireAll("Intermission", 5)
            task.wait(5)
        end
    end
end)

print("Kosova PvP - Game Setup Loaded!")
