-- Kosova PvP - Client Combat & Crosshair
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local combatEvent = ReplicatedStorage:WaitForChild("CombatEvent")

-- Wait for player to load
player.CharacterAdded:Wait()
wait(1)

-- Create crosshair
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KosovaPvP_Crosshair"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Crosshair center dot
local crosshairDot = Instance.new("Frame")
crosshairDot.Name = "CrosshairDot"
crosshairDot.Size = UDim2.new(0, 4, 0, 4)
crosshairDot.Position = UDim2.new(0.5, -2, 0.5, -2)
crosshairDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
crosshairDot.BorderSizePixel = 0
crosshairDot.Parent = screenGui

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = crosshairDot

-- Crosshair lines
local function createCrosshairLine(name, position, size)
    local line = Instance.new("Frame")
    line.Name = name
    line.Size = size
    line.Position = position
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
    line.Parent = screenGui
    return line
end

-- Top line
createCrosshairLine("TopLine", UDim2.new(0.5, -1, 0.5, -15), UDim2.new(0, 2, 0, 8))
-- Bottom line
createCrosshairLine("BottomLine", UDim2.new(0.5, -1, 0.5, 7), UDim2.new(0, 2, 0, 8))
-- Left line
createCrosshairLine("LeftLine", UDim2.new(0.5, -15, 0.5, -1), UDim2.new(0, 8, 0, 2))
-- Right line
createCrosshairLine("RightLine", UDim2.new(0.5, 7, 0.5, -1), UDim2.new(0, 8, 0, 2))

-- Combat system
local canAttack = true
local cooldown = 0.8

-- Attack function
local function attack()
    if not canAttack then return end
    if not player.Character then return end

    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Get mouse target
    local mouse = player:GetMouse()
    local target = mouse.Target

    if target then
        -- Find the character model
        local targetCharacter = target.Parent
        if targetCharacter and targetCharacter:FindFirstChild("Humanoid") then
            combatEvent:FireServer("Attack", targetCharacter)
        end
    end

    -- Cooldown
    canAttack = false
    wait(cooldown)
    canAttack = true
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Left click to attack
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        attack()
    end
end)

-- Weapon equip detection
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.Equipped:Connect(function(tool)
        if tool then
            -- Update cooldown based on weapon
            if tool.Name == "Sword" then
                cooldown = 0.8
            elseif tool.Name == "Knife" then
                cooldown = 0.6
            elseif tool.Name == "AK47" then
                cooldown = 0.15
            end

            -- Show crosshair for ranged weapons
            if tool.Name == "AK47" then
                crosshairDot.Visible = true
            end
        end
    end)

    humanoid.Unequipped:Connect(function()
        crosshairDot.Visible = true
    end)
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

-- Damage flash effect
local damageFlash = Instance.new("Frame")
damageFlash.Name = "DamageFlash"
damageFlash.Size = UDim2.new(1, 0, 1, 0)
damageFlash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
damageFlash.BackgroundTransparency = 1
damageFlash.BorderSizePixel = 0
damageFlash.Parent = screenGui

local function showDamageFlash()
    damageFlash.BackgroundTransparency = 0.5
    for i = 0.5, 1, 0.05 do
        damageFlash.BackgroundTransparency = i
        wait(0.02)
    end
end

-- Listen for damage
local healthEvent = ReplicatedStorage:WaitForChild("DamageEvent", 5)
if healthEvent then
    healthEvent.OnClientEvent:Connect(function(damage)
        showDamageFlash()
    end)
end

print("Kosova PvP - Combat System Loaded!")
