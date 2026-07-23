-- Kosova PvP - Weapon System
-- Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local combatEvent = Instance.new("RemoteEvent")
combatEvent.Name = "CombatEvent"
combatEvent.Parent = ReplicatedStorage

local lastAttackTime = {}

local weapons = {
    Sword = {
        Damage = 25,
        Range = 8,
        Cooldown = 0.8,
        AttackType = "Melee"
    },
    AK47 = {
        Damage = 15,
        Range = 100,
        Cooldown = 0.15,
        AttackType = "Ranged",
        FireRate = 6.67
    },
    Knife = {
        Damage = 40,
        Range = 5,
        Cooldown = 0.6,
        AttackType = "Melee"
    }
}

local function createSword()
    local sword = Instance.new("Tool")
    sword.Name = "Sword"
    sword.CanBeDropped = true
    sword.ToolTip = "Classic Sword - 25 DMG"

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 4)
    handle.BrickColor = BrickColor.new("Dark stone grey")
    handle.Material = Enum.Material.Metal
    handle.Parent = sword

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://12221720"
    mesh.TextureId = "rbxassetid://12224218"
    mesh.Scale = Vector3.new(1.5, 1.5, 1.5)
    mesh.Parent = handle

    local bladePart = Instance.new("Part")
    bladePart.Name = "Blade"
    bladePart.Size = Vector3.new(0.3, 0.1, 3)
    bladePart.BrickColor = BrickColor.new("Bright silver")
    bladePart.Material = Enum.Material.Metal
    bladePart.CanCollide = false
    bladePart.Parent = sword

    local bladeWeld = Instance.new("Weld")
    bladeWeld.Part0 = handle
    bladeWeld.Part1 = bladePart
    bladeWeld.C0 = CFrame.new(0, 0, -1.5)
    bladeWeld.Parent = handle

    local equipSound = Instance.new("Sound")
    equipSound.Name = "Equip"
    equipSound.SoundId = "rbxassetid://535687386"
    equipSound.Volume = 0.3
    equipSound.Parent = handle

    local slashSound = Instance.new("Sound")
    slashSound.Name = "Slash"
    slashSound.SoundId = "rbxassetid://535687386"
    slashSound.Volume = 0.6
    slashSound.Parent = handle

    return sword
end

local function createAK47()
    local gun = Instance.new("Tool")
    gun.Name = "AK47"
    gun.CanBeDropped = true
    gun.ToolTip = "AK-47 Assault Rifle - 15 DMG"

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.4, 0.4, 3)
    handle.BrickColor = BrickColor.new("Black")
    handle.Material = Enum.Material.Metal
    handle.Parent = gun

    local stock = Instance.new("Part")
    stock.Name = "Stock"
    stock.Size = Vector3.new(0.3, 0.8, 1.5)
    stock.BrickColor = BrickColor.new("Reddish brown")
    stock.Material = Enum.Material.Wood
    stock.CanCollide = false
    stock.Parent = gun

    local stockWeld = Instance.new("Weld")
    stockWeld.Part0 = handle
    stockWeld.Part1 = stock
    stockWeld.C0 = CFrame.new(0, -0.1, 1.8)
    stockWeld.Parent = handle

    local barrel = Instance.new("Part")
    barrel.Name = "Barrel"
    barrel.Size = Vector3.new(0.15, 0.15, 2)
    barrel.BrickColor = BrickColor.new("Dark stone grey")
    barrel.Material = Enum.Material.Metal
    barrel.CanCollide = false
    barrel.Parent = gun

    local barrelWeld = Instance.new("Weld")
    barrelWeld.Part0 = handle
    barrelWeld.Part1 = barrel
    barrelWeld.C0 = CFrame.new(0, 0.15, -2.2)
    barrelWeld.Parent = handle

    local magazine = Instance.new("Part")
    magazine.Name = "Magazine"
    magazine.Size = Vector3.new(0.25, 0.8, 0.3)
    magazine.BrickColor = BrickColor.new("Dark stone grey")
    magazine.Material = Enum.Material.Metal
    magazine.CanCollide = false
    magazine.Parent = gun

    local magWeld = Instance.new("Weld")
    magWeld.Part0 = handle
    magWeld.Part1 = magazine
    magWeld.C0 = CFrame.new(0, -0.5, -0.3)
    magWeld.C1 = CFrame.Angles(0.2, 0, 0)
    magWeld.Parent = handle

    local grip = Instance.new("Part")
    grip.Name = "Grip"
    grip.Size = Vector3.new(0.2, 0.6, 0.2)
    grip.BrickColor = BrickColor.new("Black")
    grip.Material = Enum.Material.Plastic
    grip.CanCollide = false
    grip.Parent = gun

    local gripWeld = Instance.new("Weld")
    gripWeld.Part0 = handle
    gripWeld.Part1 = grip
    gripWeld.C0 = CFrame.new(0, -0.4, 0.5)
    gripWeld.C1 = CFrame.Angles(0.4, 0, 0)
    gripWeld.Parent = handle

    local tip = Instance.new("Part")
    tip.Name = "Tip"
    tip.Size = Vector3.new(0.08, 0.08, 0.3)
    tip.BrickColor = BrickColor.new("Bright yellow")
    tip.Material = Enum.Material.Neon
    tip.CanCollide = false
    tip.Parent = gun

    local tipWeld = Instance.new("Weld")
    tipWeld.Part0 = handle
    tipWeld.Part1 = tip
    tipWeld.C0 = CFrame.new(0, 0.15, -3.2)
    tipWeld.Parent = handle

    local equipSound = Instance.new("Sound")
    equipSound.Name = "Equip"
    equipSound.SoundId = "rbxassetid://138244068"
    equipSound.Volume = 0.3
    equipSound.Parent = handle

    local fireSound = Instance.new("Sound")
    fireSound.Name = "Fire"
    fireSound.SoundId = "rbxassetid://150544849"
    fireSound.Volume = 0.8
    fireSound.Parent = handle

    return gun
end

local function createKnife()
    local knife = Instance.new("Tool")
    knife.Name = "Knife"
    knife.CanBeDropped = true
    knife.ToolTip = "Combat Knife - 40 DMG"

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.3, 0.3, 1.5)
    handle.BrickColor = BrickColor.new("Black")
    handle.Material = Enum.Material.Plastic
    handle.Parent = knife

    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Size = Vector3.new(0.05, 0.3, 1.2)
    blade.BrickColor = BrickColor.new("Bright silver")
    blade.Material = Enum.Material.Metal
    blade.CanCollide = false
    blade.Parent = knife

    local bladeWeld = Instance.new("Weld")
    bladeWeld.Part0 = handle
    bladeWeld.Part1 = blade
    bladeWeld.C0 = CFrame.new(0, 0, -1.2)
    bladeWeld.Parent = handle

    local guard = Instance.new("Part")
    guard.Name = "Guard"
    guard.Size = Vector3.new(0.5, 0.1, 0.1)
    guard.BrickColor = BrickColor.new("Dark stone grey")
    guard.Material = Enum.Material.Metal
    guard.CanCollide = false
    guard.Parent = knife

    local guardWeld = Instance.new("Weld")
    guardWeld.Part0 = handle
    guardWeld.Part1 = guard
    guardWeld.C0 = CFrame.new(0, 0, -0.6)
    guardWeld.Parent = handle

    local pommel = Instance.new("Part")
    pommel.Name = "Pommel"
    pommel.Size = Vector3.new(0.2, 0.2, 0.2)
    pommel.BrickColor = BrickColor.new("Dark stone grey")
    pommel.Material = Enum.Material.Metal
    pommel.CanCollide = false
    pommel.Parent = knife

    local pommelWeld = Instance.new("Weld")
    pommelWeld.Part0 = handle
    pommelWeld.Part1 = pommel
    pommelWeld.C0 = CFrame.new(0, 0, 0.8)
    pommelWeld.Parent = handle

    local equipSound = Instance.new("Sound")
    equipSound.Name = "Equip"
    equipSound.SoundId = "rbxassetid://535687386"
    equipSound.Volume = 0.2
    equipSound.Parent = handle

    local slashSound = Instance.new("Sound")
    slashSound.Name = "Slash"
    slashSound.SoundId = "rbxassetid://535687386"
    slashSound.Volume = 0.5
    slashSound.Parent = handle

    return knife
end

local function giveWeapons(player)
    local character = player.Character
    if not character then return end

    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end

    for _, child in pairs(backpack:GetChildren()) do
        if child:IsA("Tool") then
            child:Destroy()
        end
    end

    local sword = createSword()
    sword.Parent = backpack

    local ak47 = createAK47()
    ak47.Parent = backpack

    local knife = createKnife()
    knife.Parent = backpack
end

combatEvent.OnServerEvent:Connect(function(player, action, target)
    if action == "Attack" then
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        local weapon = character:FindFirstChildOfClass("Tool")
        if not weapon then return end

        local weaponData = weapons[weapon.Name]
        if not weaponData then return end

        local now = tick()
        local lastTime = lastAttackTime[player.UserId] or 0
        if now - lastTime < weaponData.Cooldown then return end
        lastAttackTime[player.UserId] = now

        if target and target:FindFirstChild("Humanoid") and target:FindFirstChild("HumanoidRootPart") then
            local targetHumanoid = target:FindFirstChild("Humanoid")
            if targetHumanoid.Health <= 0 then return end

            local targetRootPart = target:FindFirstChild("HumanoidRootPart")
            local distance = (humanoidRootPart.Position - targetRootPart.Position).Magnitude
            if distance <= weaponData.Range then
                local targetPlayer = Players:GetPlayerFromCharacter(target)
                if targetPlayer and player.Team ~= targetPlayer.Team then
                    targetHumanoid:TakeDamage(weaponData.Damage)
                end
            end
        end
    end
end)

local function setupPlayer(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        giveWeapons(player)
    end)
    if player.Character then
        task.spawn(function()
            task.wait(1)
            giveWeapons(player)
        end)
    end
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

task.spawn(function()
    while true do
        task.wait(1)
        for _, player in pairs(Players:GetPlayers()) do
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                if rootPart and humanoid and humanoid.Health > 0 then
                    if rootPart.Position.Y < -50 then
                        humanoid.Health = 0
                    end
                end
            end
        end
    end
end)

print("Kosova PvP - Weapon System Loaded!")
