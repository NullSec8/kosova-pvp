-- Kosova PvP - Weapon Pickup System
-- Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remote event for weapon pickup
local pickupEvent = Instance.new("RemoteEvent")
pickupEvent.Name = "WeaponPickupEvent"
pickupEvent.Parent = ReplicatedStorage

-- Weapon spawn locations
local weaponSpawns = {
    -- Center area
    {Weapon = "Sword", Position = Vector3.new(-5, 3, -5), Team = "Any"},
    {Weapon = "Sword", Position = Vector3.new(5, 3, 5), Team = "Any"},
    {Weapon = "Knife", Position = Vector3.new(-5, 3, 5), Team = "Any"},
    {Weapon = "Knife", Position = Vector3.new(5, 3, -5), Team = "Any"},

    -- Kosovo side
    {Weapon = "Sword", Position = Vector3.new(-40, 3, -20), Team = "Kosova"},
    {Weapon = "Knife", Position = Vector3.new(-40, 3, 20), Team = "Kosova"},

    -- Rival side
    {Weapon = "Sword", Position = Vector3.new(40, 3, -20), Team = "Rival"},
    {Weapon = "Knife", Position = Vector3.new(40, 3, 20), Team = "Rival"},
}

-- Create weapon pickups
local function createWeaponPickup(weaponData)
    local pickup = Instance.new("Part")
    pickup.Name = weaponData.Weapon .. "_Pickup"
    pickup.Size = Vector3.new(3, 1, 3)
    pickup.Position = weaponData.Position
    pickup.Anchored = true
    pickup.CanCollide = false
    pickup.BrickColor = BrickColor.new("Bright yellow")
    pickup.Transparency = 0.3
    pickup.Parent = workspace

    -- Add glow effect
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 2
    pointLight.Range = 10
    pointLight.Color = Color3.fromRGB(255, 255, 100)
    pointLight.Parent = pickup

    -- Floating animation
    spawn(function()
        local baseY = weaponData.Position.Y
        while pickup and pickup.Parent do
            for i = 0, math.pi * 2, 0.1 do
                if pickup and pickup.Parent then
                    pickup.Position = Vector3.new(
                        weaponData.Position.X,
                        baseY + math.sin(i) * 0.5,
                        weaponData.Position.Z
                    )
                end
                wait(0.05)
            end
        end
    end)

    -- Touch detection
    pickup.Touched:Connect(function(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                -- Check team restriction
                if weaponData.Team ~= "Any" and player.Team and player.Team.Name ~= weaponData.Team then
                    return
                end

                -- Give weapon
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    -- Create tool
                    local tool = Instance.new("Tool")
                    tool.Name = weaponData.Weapon
                    tool.CanBeDropped = true

                    local handle = Instance.new("Part")
                    handle.Name = "Handle"

                    if weaponData.Weapon == "Sword" then
                        handle.Size = Vector3.new(1, 4, 1)
                        handle.BrickColor = BrickColor.new("Dark stone grey")
                    elseif weaponData.Weapon == "Knife" then
                        handle.Size = Vector3.new(0.5, 2, 0.5)
                        handle.BrickColor = BrickColor.new("Black")
                    end

                    handle.Parent = tool
                    tool.Parent = backpack

                    -- Remove pickup
                    pickup:Destroy()
                end
            end
        end
    end)

    return pickup
end

-- Spawn all weapon pickups
for _, weaponData in pairs(weaponSpawns) do
    createWeaponPickup(weaponData)
end

-- Respawn weapons periodically
spawn(function()
    while true do
        wait(30) -- Respawn every 30 seconds
        for _, weaponData in pairs(weaponSpawns) do
            if not workspace:FindFirstChild(weaponData.Weapon .. "_Pickup") then
                createWeaponPickup(weaponData)
            end
        end
    end
end)

print("Kosova PvP - Weapon Pickups Loaded!")
