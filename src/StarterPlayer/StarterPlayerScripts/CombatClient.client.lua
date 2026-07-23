-- Kosova PvP - Weapon Animations + Combat Client
-- Place in StarterPlayerScripts
-- Handles: animations, combat input, auto-fire, camera aiming
-- UI driven via Fusion CombatUI module

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

local combatEvent = ReplicatedStorage:WaitForChild("CombatEvent")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local createCombatUI = require(script.Parent.UILib.CombatUI)
local combatUI = createCombatUI()

local animIds = {
    SwordSlash = "rbxassetid://129967390",
    KnifeStab = "rbxassetid://129967390",
    GunFire = "rbxassetid://129967390"
}

local loadedAnims = {}
local lastAttack = 0
local currentWeapon = nil
local ammoData = {}
local reloading = false
local mouseDown = false
local firing = false
local connectedTools = {}
local childAddedConnections = {}

local function getAmmo(tool)
    if not ammoData[tool] then
        ammoData[tool] = {ammo = 30, maxAmmo = 30}
    end
    return ammoData[tool]
end

-- ============ CAMERA AIM ============
local aimGyro = nil

local function enableAim()
    if aimGyro then aimGyro:Destroy() end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    aimGyro = Instance.new("BodyGyro")
    aimGyro.MaxTorque = Vector3.new(0, math.huge, 0)
    aimGyro.P = 10000
    aimGyro.D = 500
    aimGyro.Parent = rootPart
end

local function disableAim()
    if aimGyro then
        aimGyro:Destroy()
        aimGyro = nil
    end
end

local function updateAim()
    if not aimGyro then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local camCF = camera.CFrame
    aimGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z))
end

-- ============ FUNCTIONS ============
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
        local data = getAmmo(currentWeapon)
        combatUI.SetIsGun(true)
        combatUI.SetMaxAmmo(data.maxAmmo)
        combatUI.SetAmmo(data.ammo)
    else
        combatUI.SetIsGun(false)
    end
end

local function reload()
    if reloading then return end
    if not currentWeapon or currentWeapon.Name ~= "AK47" then return end
    local data = getAmmo(currentWeapon)
    if data.ammo == data.maxAmmo then return end
    reloading = true
    combatUI.SetReloading(true)
    task.wait(2)
    data.ammo = data.maxAmmo
    reloading = false
    combatUI.SetReloading(false)
    updateAmmoDisplay()
end

-- Camera-based raycast hit detection
local function findTargetByRay()
    local camCF = camera.CFrame
    local rayOrigin = camCF.Position
    local rayDir = camCF.LookVector * 200

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character}
    params.RespectCanCollide = false

    local result = workspace:Raycast(rayOrigin, rayDir, params)
    if result and result.Instance then
        local hitPart = result.Instance
        local hitModel = hitPart:FindFirstAncestorOfClass("Model")
        if hitModel then
            local hitHumanoid = hitModel:FindFirstChildOfClass("Humanoid")
            if hitHumanoid and hitHumanoid.Health > 0 then
                local hitPlayer = Players:GetPlayerFromCharacter(hitModel)
                if hitPlayer and hitPlayer ~= player then
                    if player.Team and hitPlayer.Team and player.Team ~= hitPlayer.Team then
                        return hitModel
                    end
                end
            end
        end
    end
    return nil
end

-- ============ ATTACK ============
local function doAttack()
    if not character or not character.Parent then return end
    local hum = character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local tool = currentWeapon
    if not tool then return end
    if reloading then return end

    local now = tick()
    local cooldown = 0.8
    if tool.Name == "AK47" then
        cooldown = 0.15
    elseif tool.Name == "Knife" then
        cooldown = 0.6
    end

    if now - lastAttack < cooldown then return end
    lastAttack = now

    if tool.Name == "AK47" then
        local data = getAmmo(tool)
        if data.ammo <= 0 then
            reload()
            return
        end
        data.ammo = data.ammo - 1
        updateAmmoDisplay()
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

    local target = findTargetByRay()
    if target then
        combatEvent:FireServer("Attack", target)
    end
end

-- ============ AUTO-FIRE LOOP ============
local function autoFireLoop()
    while true do
        if mouseDown and currentWeapon and currentWeapon.Name == "AK47" and not reloading then
            firing = true
            doAttack()
        else
            firing = false
        end
        task.wait(0.08)
    end
end

task.spawn(autoFireLoop)

-- ============ TOOL EVENTS ============
local function onToolEquipped(tool)
    currentWeapon = tool
    combatUI.ShowCrosshair(true)
    reloading = false
    combatUI.SetReloading(false)
    updateAmmoDisplay()
    if tool.Name == "AK47" then
        enableAim()
    end
end

local function onToolUnequipped()
    currentWeapon = nil
    combatUI.ShowCrosshair(false)
    combatUI.SetIsGun(false)
    reloading = false
    combatUI.SetReloading(false)
    disableAim()
end

local function onToolActivated()
    local tool = currentWeapon
    if not tool then return end
    if tool.Name ~= "AK47" then
        doAttack()
    end
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    loadedAnims = {}
    ammoData = {}
    currentWeapon = nil
    reloading = false
    mouseDown = false
    disableAim()
    combatUI.ShowCrosshair(false)
    combatUI.SetIsGun(false)
    combatUI.SetReloading(false)
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

for _, child in pairs(character:GetChildren()) do
    if child:IsA("Tool") then
        connectTool(child)
    end
end

table.insert(childAddedConnections, character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        connectTool(child)
    end
end))

-- ============ INPUT ============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = true
        if currentWeapon and currentWeapon.Name ~= "AK47" then
            doAttack()
        end
    end
    if input.KeyCode == Enum.KeyCode.R then
        reload()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = false
    end
end)

-- ============ DAMAGE FLASH ============
local hitEvent = ReplicatedStorage:WaitForChild("HitEvent", 10)
if hitEvent then
    hitEvent.OnClientEvent:Connect(function()
        combatUI.FlashDamage()
    end)
end

-- ============ AIM UPDATE ============
RunService.RenderStepped:Connect(function()
    if currentWeapon and currentWeapon.Name == "AK47" then
        updateAim()
    end
end)

print("Kosova PvP - Combat Client Loaded!")
