local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local createHUD = require(script.Parent.HUD)
local createKillFeed = require(script.Parent.KillFeed)
local createCombatUI = require(script.Parent.CombatUI)

local combatEvent = ReplicatedStorage:WaitForChild("CombatEvent")

local hud = createHUD()
local killFeed = createKillFeed()
local combatUI = createCombatUI()

local loadedAnims = {}
local debounce = false
local lastAttack = 0
local currentWeapon = nil
local ammo = 30
local maxAmmo = 30
local reloading = false
local connectedTools = {}
local childAddedConnections = {}

local animIds = {
    SwordSlash = "rbxassetid://129967390",
    KnifeStab = "rbxassetid://129967390",
    GunFire = "rbxassetid://129967390",
}

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

local function findTarget()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return nil end

    local range = 8
    if tool.Name == "AK47" then
        range = 100
    end

    for _, otherPlayer in Players:GetPlayers() do
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

local function reload()
    if reloading or ammo == maxAmmo then return end
    if not currentWeapon or currentWeapon.Name ~= "AK47" then return end
    reloading = true
    combatUI.SetReloading(true)
    task.wait(2)
    ammo = maxAmmo
    reloading = false
    combatUI.SetReloading(false)
    combatUI.SetAmmo(ammo)
end

local function onToolActivated()
    if debounce then return end

    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end

    local now = tick()
    local cooldown = 0.8
    if tool.Name == "AK47" then
        cooldown = 0.15
    elseif tool.Name == "Knife" then
        cooldown = 0.6
    end

    if now - lastAttack < cooldown then return end
    debounce = true
    lastAttack = now

    if tool.Name == "AK47" then
        if ammo <= 0 then
            debounce = false
            reload()
            return
        end
        if reloading then debounce = false return end
        ammo = ammo - 1
        combatUI.SetAmmo(ammo)
    end

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
    combatUI.ShowCrosshair(true)
    if tool.Name == "AK47" then
        ammo = 30
        maxAmmo = 30
        reloading = false
        combatUI.SetIsGun(true)
        combatUI.SetMaxAmmo(maxAmmo)
        combatUI.SetAmmo(ammo)
        combatUI.SetReloading(false)
    else
        combatUI.SetIsGun(false)
    end
end

local function onToolUnequipped()
    currentWeapon = nil
    combatUI.ShowCrosshair(false)
    combatUI.SetIsGun(false)
    reloading = false
    combatUI.SetReloading(false)
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    loadedAnims = {}
    currentWeapon = nil
    ammo = 30
    reloading = false
    connectedTools = {}

    for _, conn in pairs(childAddedConnections) do
        conn:Disconnect()
    end
    childAddedConnections = {}

    table.insert(childAddedConnections, character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            connectTool(child)
        end
    end))
end

player.CharacterAdded:Connect(onCharacterAdded)

local function connectTool(tool)
    if connectedTools[tool] then return end
    connectedTools[tool] = true
    tool.Activated:Connect(onToolActivated)
    tool.Equipped:Connect(function() onToolEquipped(tool) end)
    tool.Unequipped:Connect(onToolUnequipped)
end

for _, child in character:GetChildren() do
    if child:IsA("Tool") then
        connectTool(child)
    end
end

table.insert(childAddedConnections, character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        connectTool(child)
    end
end))

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        reload()
    end
end)

print("Kosova PvP - Fusion UI Loaded!")
