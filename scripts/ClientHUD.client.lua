-- Kosova PvP - Client HUD
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Wait for player to load
player.CharacterAdded:Wait()
wait(1)

-- Create HUD
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KosovaPvP_HUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Health Bar Frame
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

-- Health Bar Fill
local healthFill = Instance.new("Frame")
healthFill.Name = "HealthFill"
healthFill.Size = UDim2.new(1, 0, 1, 0)
healthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
healthFill.BorderSizePixel = 0
healthFill.Parent = healthFrame

local healthFillCorner = Instance.new("UICorner")
healthFillCorner.CornerRadius = UDim.new(0, 8)
healthFillCorner.Parent = healthFill

-- Health Text
local healthText = Instance.new("TextLabel")
healthText.Name = "HealthText"
healthText.Size = UDim2.new(1, 0, 1, 0)
healthText.BackgroundTransparency = 1
healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
healthText.TextScaled = true
healthText.Font = Enum.Font.GothamBold
healthText.Text = "100 / 100"
healthText.Parent = healthFrame

-- Team Display
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

-- Score Display
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

-- Kosovo Score
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

-- VS Text
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

-- Rival Score
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

-- Update HUD loop
spawn(function()
    while true do
        wait(0.1)

        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local healthPercent = humanoid.Health / humanoid.MaxHealth

            -- Update health bar
            healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
            healthText.Text = math.floor(humanoid.Health) .. " / " .. humanoid.MaxHealth

            -- Color based on health
            if healthPercent > 0.6 then
                healthFill.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            elseif healthPercent > 0.3 then
                healthFill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
            else
                healthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end
        end

        -- Update team
        if player.Team then
            teamText.Text = player.Team.Name:upper()
            if player.Team.Name == "Kosova" then
                teamFrame.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
            else
                teamFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 150)
            end
        end
    end
end)

print("Kosova PvP - HUD Loaded!")
