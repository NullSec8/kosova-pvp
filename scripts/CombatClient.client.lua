-- Kosova PvP - Weapon Animations + Combat Client
-- Place in StarterPlayerScripts
-- Handles: animations, combat input, crosshair, damage flash

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

local combatEvent = ReplicatedStorage:WaitForChild("CombatEvent")

local animIds = {
    SwordSlash = "rbxassetid://129967390",
    SwordLunge = "rbxassetid://129967478",
    KnifeStab = "rbxassetid://129967390",
    KnifeSlash = "rbxassetid://129967478",
    GunFire = "rbxassetid://129967390"
}

local loadedAnims = {}
local debounce = false
local lastAttack = 0
local currentWeapon = nil
local ammo = 30
local maxAmmo = 30
local reloading = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local crosshairFrame = Instance.new("Frame")
crosshairFrame.Name = "Crosshair"
crosshairFrame.Size = UDim2.new(0, 40, 0, 40)
crosshairFrame.Position = UDim2.new(0.5, -20, 0.5, -20)
crosshairFrame.BackgroundTransparency = 1
crosshairFrame.Parent = screenGui

local dot = Instance.new("Frame")
dot.Name = "Dot"
dot.Size = UDim2.new(0, 4, 0, 4)
dot.Position = UDim2.new(0.5, -2, 0.5, -2)
dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dot.BorderSizePixel = 0
dot.Parent = crosshairFrame

local lineTop = Instance.new("Frame")
lineTop.Name = "LineTop"
lineTop.Size = UDim2.new(0, 2, 0, 8)
lineTop.Position = UDim2.new(0.5, -1, 0, 0)
lineTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lineTop.BorderSizePixel = 0
lineTop.Parent = crosshairFrame

local lineBottom = Instance.new("Frame")
lineBottom.Name = "LineBottom"
lineBottom.Size = UDim2.new(0, 2, 0, 8)
lineBottom.Position = UDim2.new(0.5, -1, 1, -8)
lineBottom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lineBottom.BorderSizePixel = 0
lineBottom.Parent = crosshairFrame

local lineLeft = Instance.new("Frame")
lineLeft.Name = "LineLeft"
lineLeft.Size = UDim2.new(0, 8, 0, 2)
lineLeft.Position = UDim2.new(0, 0, 0.5, -1)
lineLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lineLeft.BorderSizePixel = 0
lineLeft.Parent = crosshairFrame

local lineRight = Instance.new("Frame")
lineRight.Name = "LineRight"
lineRight.Size = UDim2.new(0, 8, 0, 2)
lineRight.Position = UDim2.new(1, -8, 0.5, -1)
lineRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lineRight.BorderSizePixel = 0
lineRight.Parent = crosshairFrame

local damageFlash = Instance.new("Frame")
damageFlash.Name = "DamageFlash"
damageFlash.Size = UDim2.new(1, 0, 1, 0)
damageFlash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
damageFlash.BackgroundTransparency = 1
damageFlash.BorderSizePixel = 0
damageFlash.ZIndex = 10
damageFlash.Parent = screenGui

local ammoLabel = Instance.new("TextLabel")
ammoLabel.Name = "AmmoLabel"
ammoLabel.Size = UDim2.new(0, 120, 0, 40)
ammoLabel.Position = UDim2.new(1, -140, 1, -60)
ammoLabel.BackgroundTransparency = 0.5
ammoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ammoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ammoLabel.TextScaled = true
ammoLabel.Font = Enum.Font.GothamBold
ammoLabel.Text = "30 / 30"
ammoLabel.Visible = false
ammoLabel.Parent = screenGui

local reloadLabel = Instance.new("TextLabel")
reloadLabel.Name = "ReloadLabel"
reloadLabel.Size = UDim2.new(0, 200, 0, 30)
reloadLabel.Position = UDim2.new(0.5, -100, 0.6, 0)
reloadLabel.BackgroundTransparency = 1
reloadLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
reloadLabel.TextScaled = true
reloadLabel.Font = Enum.Font.GothamBold
reloadLabel.Text = "RELOADING..."
reloadLabel.Visible = false
reloadLabel.Parent = screenGui

local function ensureHumanoid()
    if not character or not character.Parent then
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        loadedAnims = {}
    end
    return humanoid
end

local function getTrack(name)
    if loadedAnims[name] then
        return loadedAnims[name]
    end
    local h = ensureHumanoid()
    if not h then return nil end
    local anim = Instance.new("Animation")
    anim.AnimationId = animIds[name]
    local track = h:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    loadedAnims[name] = track
    return track
end

local function playSound(tool, soundName)
    if not tool then return end
    local handle = tool:FindFirstChild("Handle")
    if handle then
        local sound = handle:FindFirstChild(soundName)
        if sound then
            sound:Play()
        end
    end
end

local function updateAmmoDisplay()
    if currentWeapon and currentWeapon.Name == "AK47" then
        ammoLabel.Visible = true
        ammoLabel.Text = ammo .. " / " .. maxAmmo
    else
        ammoLabel.Visible = false
    end
end

local function showDamageFlash()
    damageFlash.BackgroundTransparency = 0.5
    local tween = game:GetService("TweenService"):Create(damageFlash, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    tween:Play()
end

local function reload()
    if reloading or ammo == maxAmmo then return end
    if not currentWeapon or currentWeapon.Name ~= "AK47" then return end
    reloading = true
    reloadLabel.Visible = true
    task.wait(2)
    ammo = maxAmmo
    reloading = false
    reloadLabel.Visible = false
    updateAmmoDisplay()
end

local function findTarget()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return nil end

    local range = 8
    if tool.Name == "AK47" then
        range = 100
    end

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherChar = otherPlayer.Character
            if otherChar then
                local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                local otherHumanoid = otherChar:FindFirstChild("Humanoid")
                if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
                    local distance = (rootPart.Position - otherRoot.Position).Magnitude
                    if distance <= range then
                        if player.Team and otherPlayer.Team and player.Team ~= otherPlayer.Team then
                            return otherChar
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function onToolActivated()
    if debounce then return end

    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end

    local now = tick()
    local cooldown = 0.8
    if tool.Name == "AK47" then
        cooldown = 0.15
        if ammo <= 0 then
            reload()
            return
        end
        if reloading then return end
        ammo = ammo - 1
        updateAmmoDisplay()
    elseif tool.Name == "Knife" then
        cooldown = 0.6
    end

    if now - lastAttack < cooldown then return end
    debounce = true
    lastAttack = now

    if tool.Name == "Sword" then
        local track = getTrack("SwordSlash")
        if track then track:Play(0.1, 1, 1) end
        playSound(tool, "Slash")
    elseif tool.Name == "Knife" then
        local track = getTrack("KnifeStab")
        if track then track:Play(0.1, 1, 1) end
        playSound(tool, "Slash")
    elseif tool.Name == "AK47" then
        local track = getTrack("GunFire")
        if track then track:Play(0.1, 1, 1) end
        playSound(tool, "Fire")
    end

    local target = findTarget()
    if target then
        combatEvent:FireServer("Attack", target)
    end

    task.wait(cooldown)
    debounce = false
end

local function onToolEquipped(tool)
    currentWeapon = tool
    crosshairFrame.Visible = true
    ammo = maxAmmo
    reloading = false
    reloadLabel.Visible = false
    updateAmmoDisplay()
end

local function onToolUnequipped()
    currentWeapon = nil
    crosshairFrame.Visible = false
    ammoLabel.Visible = false
    reloading = false
    reloadLabel.Visible = false
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    loadedAnims = {}
    currentWeapon = nil
    ammo = maxAmmo
    reloading = false
end

player.CharacterAdded:Connect(onCharacterAdded)

local function connectTool(tool)
    tool.Activated:Connect(onToolActivated)
    tool.Equipped:Connect(function() onToolEquipped(tool) end)
    tool.Unequipped:Connect(onToolUnequipped)
end

for _, child in pairs(character:GetChildren()) do
    if child:IsA("Tool") then
        connectTool(child)
    end
end

character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        connectTool(child)
    end
end)

player.Backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        child.Equipped:Connect(function()
            connectTool(child)
        end)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        reload()
    end
end)

print("Kosova PvP - Combat Client Loaded!")
