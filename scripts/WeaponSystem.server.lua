-- Kosova PvP - Weapon System
-- Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent for combat
local combatEvent = Instance.new("RemoteEvent")
combatEvent.Name = "CombatEvent"
combatEvent.Parent = ReplicatedStorage

-- Weapon definitions
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

-- Give weapons to players
local function giveWeapons(player)
    local character = player.Character
    if not character then return end

    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end

    -- Create Sword
    local sword = Instance.new("Tool")
    sword.Name = "Sword"
    sword.CanBeDropped = true

    local swordHandle = Instance.new("Part")
    swordHandle.Name = "Handle"
    swordHandle.Size = Vector3.new(1, 4, 1)
    swordHandle.BrickColor = BrickColor.new("Dark stone grey")
    swordHandle.Parent = sword

    local swordMesh = Instance.new("SpecialMesh")
    swordMesh.MeshType = Enum.MeshType.FileMesh
    swordMesh.MeshId = "rbxassetid://4770583"
    swordMesh.TextureId = "rbxassetid://4770568"
    swordMesh.Scale = Vector3.new(1.2, 1.2, 1.2)
    swordMesh.Parent = swordHandle

    sword.Parent = backpack

    -- Create Knife
    local knife = Instance.new("Tool")
    knife.Name = "Knife"
    knife.CanBeDropped = true

    local knifeHandle = Instance.new("Part")
    knifeHandle.Name = "Handle"
    knifeHandle.Size = Vector3.new(0.5, 2, 0.5)
    knifeHandle.BrickColor = BrickColor.new("Black")
    knifeHandle.Parent = knife

    knife.Parent = backpack
end

-- Handle combat
combatEvent.OnServerEvent:Connect(function(player, action, target)
    if action == "Attack" then
        local character = player.Character
        if not character then return end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        local weapon = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if not weapon then return end

        local weaponData = weapons[weapon.Name]
        if not weaponData then return end

        -- Find target
        if target and target:FindFirstChild("Humanoid") then
            local targetCharacter = target
            local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
            local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")

            if targetRootPart then
                local distance = (humanoidRootPart.Position - targetRootPart.Position).Magnitude
                if distance <= weaponData.Range then
                    -- Check if same team
                    if player.Team ~= targetCharacter:FindFirstChild("Team") then
                        targetHumanoid:TakeDamage(weaponData.Damage)
                    end
                end
            end
        end
    end
end)

-- Handle player respawning and weapon giving
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)
        giveWeapons(player)
    end)
end)

-- For existing players
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        giveWeapons(player)
    end
    player.CharacterAdded:Connect(function()
        wait(1)
        giveWeapons(player)
    end)
end

print("Kosova PvP - Weapon System Loaded!")
