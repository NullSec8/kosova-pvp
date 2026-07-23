-- Kosova PvP - Client HUD
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

player.CharacterAdded:Wait()
task.wait(1)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KosovaPvP_HUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local healthFrame = Instance.new("Frame")
healthFrame.Name = "HealthFrame"
healthFrame.Size = UDim2.new(0, 300, 0, 40)
healthFrame.Position = UDim2.new(0.5, -150, 1, -80)
healthFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
healthFrame.BorderSizePixel = 0
healthFrame.Parent = screenGui

local healthCorner = Instance.new("UICorner")
healthCorner.CornerRadius = UDim.new(0, 8)
healthCorner.Parent = healthFrame

local healthFill = Instance.new("Frame")
healthFill.Name = "HealthFill"
healthFill.Size = UDim2.new(1, 0, 1, 0)
healthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
healthFill.BorderSizePixel = 0
healthFill.Parent = healthFrame

local healthFillCorner = Instance.new("UICorner")
healthFillCorner.CornerRadius = UDim.new(0, 8)
healthFillCorner.Parent = healthFill

local healthText = Instance.new("TextLabel")
healthText.Name = "HealthText"
healthText.Size = UDim2.new(1, 0, 1, 0)
healthText.BackgroundTransparency = 1
healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
healthText.TextScaled = true
healthText.Font = Enum.Font.GothamBold
healthText.Text = "100 / 100"
healthText.Parent = healthFrame

local teamFrame = Instance.new("Frame")
teamFrame.Name = "TeamFrame"
teamFrame.Size = UDim2.new(0, 200, 0, 50)
teamFrame.Position = UDim2.new(0, 20, 0, 20)
teamFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
teamFrame.BorderSizePixel = 0
teamFrame.Parent = screenGui

local teamCorner = Instance.new("UICorner")
teamCorner.CornerRadius = UDim.new(0, 8)
teamCorner.Parent = teamFrame

local teamText = Instance.new("TextLabel")
teamText.Name = "TeamText"
teamText.Size = UDim2.new(1, 0, 1, 0)
teamText.BackgroundTransparency = 1
teamText.TextColor3 = Color3.fromRGB(255, 255, 255)
teamText.TextScaled = true
teamText.Font = Enum.Font.GothamBold
teamText.Text = "KOSOVA"
teamText.Parent = teamFrame

local scoreFrame = Instance.new("Frame")
scoreFrame.Name = "ScoreFrame"
scoreFrame.Size = UDim2.new(0, 300, 0, 60)
scoreFrame.Position = UDim2.new(0.5, -150, 0, 20)
scoreFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scoreFrame.BorderSizePixel = 0
scoreFrame.Parent = screenGui

local scoreCorner = Instance.new("UICorner")
scoreCorner.CornerRadius = UDim.new(0, 8)
scoreCorner.Parent = scoreFrame

local kosovaScore = Instance.new("TextLabel")
kosovaScore.Name = "KosovaScore"
kosovaScore.Size = UDim2.new(0.45, 0, 1, 0)
kosovaScore.Position = UDim2.new(0, 5, 0, 0)
kosovaScore.BackgroundTransparency = 1
kosovaScore.TextColor3 = Color3.fromRGB(255, 80, 80)
kosovaScore.TextScaled = true
kosovaScore.Font = Enum.Font.GothamBold
kosovaScore.Text = "KOSOVA: 0"
kosovaScore.Parent = scoreFrame

local vsText = Instance.new("TextLabel")
vsText.Name = "VsText"
vsText.Size = UDim2.new(0.1, 0, 1, 0)
vsText.Position = UDim2.new(0.45, 0, 0, 0)
vsText.BackgroundTransparency = 1
vsText.TextColor3 = Color3.fromRGB(255, 255, 255)
vsText.TextScaled = true
vsText.Font = Enum.Font.GothamBold
vsText.Text = "VS"
vsText.Parent = scoreFrame

local rivalScore = Instance.new("TextLabel")
rivalScore.Name = "RivalScore"
rivalScore.Size = UDim2.new(0.45, 0, 1, 0)
rivalScore.Position = UDim2.new(0.55, 0, 0, 0)
rivalScore.BackgroundTransparency = 1
rivalScore.TextColor3 = Color3.fromRGB(80, 80, 255)
rivalScore.TextScaled = true
rivalScore.Font = Enum.Font.GothamBold
rivalScore.Text = "RIVAL: 0"
rivalScore.Parent = scoreFrame

local timerFrame = Instance.new("Frame")
timerFrame.Name = "TimerFrame"
timerFrame.Size = UDim2.new(0, 120, 0, 40)
timerFrame.Position = UDim2.new(0.5, -60, 0, 85)
timerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
timerFrame.BorderSizePixel = 0
timerFrame.Parent = screenGui

local timerCorner = Instance.new("UICorner")
timerCorner.CornerRadius = UDim.new(0, 8)
timerCorner.Parent = timerFrame

local timerText = Instance.new("TextLabel")
timerText.Name = "TimerText"
timerText.Size = UDim2.new(1, 0, 1, 0)
timerText.BackgroundTransparency = 1
timerText.TextColor3 = Color3.fromRGB(255, 255, 0)
timerText.TextScaled = true
timerText.Font = Enum.Font.GothamBold
timerText.Text = "3:00"
timerText.Parent = timerFrame

local announceFrame = Instance.new("Frame")
announceFrame.Name = "AnnounceFrame"
announceFrame.Size = UDim2.new(0, 500, 0, 80)
announceFrame.Position = UDim2.new(0.5, -250, 0.3, 0)
announceFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
announceFrame.BackgroundTransparency = 0.3
announceFrame.BorderSizePixel = 0
announceFrame.Visible = false
announceFrame.Parent = screenGui

local announceCorner = Instance.new("UICorner")
announceCorner.CornerRadius = UDim.new(0, 12)
announceCorner.Parent = announceFrame

local announceText = Instance.new("TextLabel")
announceText.Name = "AnnounceText"
announceText.Size = UDim2.new(1, 0, 1, 0)
announceText.BackgroundTransparency = 1
announceText.TextColor3 = Color3.fromRGB(255, 255, 255)
announceText.TextScaled = true
announceText.Font = Enum.Font.GothamBold
announceText.Text = ""
announceText.Parent = announceFrame

local function getTeamKills(teamName)
    local total = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p.Team and p.Team.Name == teamName and p:FindFirstChild("leaderstats") then
            total = total + p.leaderstats.Kills.Value
        end
    end
    return total
end

local function formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return mins .. ":" .. string.format("%02d", secs)
end

local gameEvent = ReplicatedStorage:WaitForChild("GameEvent", 10)

task.spawn(function()
    while true do
        task.wait(0.1)

        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            local hp = hum.Health / hum.MaxHealth
            healthFill.Size = UDim2.new(hp, 0, 1, 0)
            healthText.Text = math.floor(hum.Health) .. " / " .. hum.MaxHealth
            if hp > 0.6 then
                healthFill.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            elseif hp > 0.3 then
                healthFill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
            else
                healthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end
        end

        if player.Team then
            teamText.Text = player.Team.Name:upper()
            if player.Team.Name == "Kosova" then
                teamFrame.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
            else
                teamFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 150)
            end
        end

        kosovaScore.Text = "KOSOVA: " .. getTeamKills("Kosova")
        rivalScore.Text = "RIVAL: " .. getTeamKills("Rival")
    end
end)

if gameEvent then
    gameEvent.OnClientEvent:Connect(function(action, data)
        if action == "Timer" then
            timerText.Text = formatTime(data)
        elseif action == "RoundStart" then
            announceFrame.Visible = true
            announceText.Text = "ROUND STARTED!"
            announceText.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(3)
            announceFrame.Visible = false
        elseif action == "RoundEnd" then
            announceFrame.Visible = true
            announceText.Text = data .. " WINS!"
            if data == "Kosova" then
                announceText.TextColor3 = Color3.fromRGB(255, 80, 80)
            else
                announceText.TextColor3 = Color3.fromRGB(80, 80, 255)
            end
            task.wait(5)
            announceFrame.Visible = false
        elseif action == "Intermission" then
            announceFrame.Visible = true
            announceText.Text = "INTERMISSION - " .. formatTime(data)
            announceText.TextColor3 = Color3.fromRGB(255, 255, 0)
        elseif action == "Killed" then
            announceFrame.Visible = true
            announceText.Text = "YOU WERE KILLED BY " .. data
            announceText.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(3)
            announceFrame.Visible = false
        end
    end)
end

print("Kosova PvP - HUD Loaded!")
