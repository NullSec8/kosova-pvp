-- Kosova PvP - Kill Feed UI
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local killEvent = ReplicatedStorage:WaitForChild("KillEvent")

-- Wait for player to load
player.CharacterAdded:Wait()
wait(1)

-- Create Kill Feed GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KosovaPvP_KillFeed"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Kill Feed Container
local killFeedFrame = Instance.new("Frame")
killFeedFrame.Name = "KillFeedFrame"
killFeedFrame.Size = UDim2.new(0, 350, 0, 250)
killFeedFrame.Position = UDim2.new(1, -370, 0, 20)
killFeedFrame.BackgroundTransparency = 1
killFeedFrame.Parent = screenGui

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
listLayout.Parent = killFeedFrame

-- Kill feed entries
local killEntries = {}

local function createKillEntry(killerName, victimName, weapon)
    local entry = Instance.new("Frame")
    entry.Name = "KillEntry"
    entry.Size = UDim2.new(1, 0, 0, 35)
    entry.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    entry.BackgroundTransparency = 0.3
    entry.BorderSizePixel = 0
    entry.Parent = killFeedFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = entry

    -- Killer name (red)
    local killerLabel = Instance.new("TextLabel")
    killerLabel.Size = UDim2.new(0.4, 0, 1, 0)
    killerLabel.Position = UDim2.new(0, 5, 0, 0)
    killerLabel.BackgroundTransparency = 1
    killerLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    killerLabel.TextScaled = true
    killerLabel.Font = Enum.Font.GothamBold
    killerLabel.TextXAlignment = Enum.TextXAlignment.Left
    killerLabel.Text = killerName
    killerLabel.Parent = entry

    -- Weapon icon/text
    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Size = UDim2.new(0.2, 0, 1, 0)
    weaponLabel.Position = UDim2.new(0.4, 0, 0, 0)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponLabel.TextScaled = true
    weaponLabel.Font = Enum.Font.Gotham
    weaponLabel.Text = "[ " .. weapon .. " ]"
    weaponLabel.Parent = entry

    -- Victim name (blue)
    local victimLabel = Instance.new("TextLabel")
    victimLabel.Size = UDim2.new(0.35, 0, 1, 0)
    victimLabel.Position = UDim2.new(0.6, 0, 0, 0)
    victimLabel.BackgroundTransparency = 1
    victimLabel.TextColor3 = Color3.fromRGB(80, 80, 255)
    victimLabel.TextScaled = true
    victimLabel.Font = Enum.Font.GothamBold
    victimLabel.TextXAlignment = Enum.TextXAlignment.Right
    victimLabel.Text = victimName
    victimLabel.Parent = entry

    -- Fade out and remove
    spawn(function()
        wait(5)
        for i = 1, 0, -0.1 do
            entry.BackgroundTransparency = 0.3 + (0.7 * (1 - i))
            entry.Size = UDim2.new(1, 0, 35 * i, 0)
            wait(0.05)
        end
        entry:Destroy()
    end)

    return entry
end

-- Handle kill events
killEvent.OnClientEvent:Connect(function(killerName, victimName, weapon)
    createKillEntry(killerName, victimName, weapon)
end)

-- Custom kill feed for testing
local function addCustomKill(killer, victim, weapon)
    createKillEntry(killer, victim, weapon)
end

-- Example kills (remove in production)
-- Uncomment to test:
-- wait(3)
-- addCustomKill("Player1", "Player2", "Sword")
-- wait(2)
-- addCustomKill("Player3", "Player4", "AK47")

print("Kosova PvP - Kill Feed Loaded!")
