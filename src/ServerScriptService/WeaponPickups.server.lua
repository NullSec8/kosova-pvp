-- Kosova PvP - Weapon Pickup System
-- Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pickupEvent = Instance.new("RemoteEvent")
pickupEvent.Name = "WeaponPickupEvent"
pickupEvent.Parent = ReplicatedStorage

local weaponSpawns = {
    {Weapon = "AK47", Position = Vector3.new(0, 2, 0), Team = "Any"},
    {Weapon = "AK47", Position = Vector3.new(-20, 2, -20), Team = "Any"},
    {Weapon = "AK47", Position = Vector3.new(20, 2, 20), Team = "Any"},
    {Weapon = "Sword", Position = Vector3.new(-10, 2, 10), Team = "Any"},
    {Weapon = "Sword", Position = Vector3.new(10, 2, -10), Team = "Any"},
    {Weapon = "Sword", Position = Vector3.new(0, 2, -20), Team = "Any"},
    {Weapon = "Knife", Position = Vector3.new(-15, 2, 0), Team = "Any"},
    {Weapon = "Knife", Position = Vector3.new(15, 2, 0), Team = "Any"},
    {Weapon = "Knife", Position = Vector3.new(0, 2, 15), Team = "Any"},
    {Weapon = "Sword", Position = Vector3.new(-25, 2, -10), Team = "Kosova"},
    {Weapon = "Knife", Position = Vector3.new(-25, 2, 10), Team = "Kosova"},
    {Weapon = "Sword", Position = Vector3.new(25, 2, -10), Team = "Rival"},
    {Weapon = "Knife", Position = Vector3.new(25, 2, 10), Team = "Rival"},
}

local pickupColors = {
    Sword = BrickColor.new("Bright silver"),
    Knife = BrickColor.new("Bright red"),
    AK47 = BrickColor.new("Black"),
}

local function createFullWeapon(weaponName)
    if weaponName == "Sword" then
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

        local slashSound = Instance.new("Sound")
        slashSound.Name = "Slash"
        slashSound.SoundId = "rbxassetid://535687386"
        slashSound.Volume = 0.6
        slashSound.Parent = handle

        return sword

    elseif weaponName == "AK47" then
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

        local fireSound = Instance.new("Sound")
        fireSound.Name = "Fire"
        fireSound.SoundId = "rbxassetid://150544849"
        fireSound.Volume = 0.8
        fireSound.Parent = handle

        return gun

    elseif weaponName == "Knife" then
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

        local slashSound = Instance.new("Sound")
        slashSound.Name = "Slash"
        slashSound.SoundId = "rbxassetid://535687386"
        slashSound.Volume = 0.5
        slashSound.Parent = handle

        return knife
    end

    return nil
end

local function createWeaponPickup(weaponData)
    local pickup = Instance.new("Part")
    pickup.Name = weaponData.Weapon .. "_Pickup"
    pickup.Size = Vector3.new(3, 1, 3)
    pickup.Position = weaponData.Position
    pickup.Anchored = true
    pickup.CanCollide = false
    pickup.BrickColor = pickupColors[weaponData.Weapon] or BrickColor.new("Bright yellow")
    pickup.Transparency = 0.3
    pickup.Parent = workspace

    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 2
    pointLight.Range = 10
    pointLight.Color = Color3.fromRGB(255, 255, 100)
    pointLight.Parent = pickup

    local gui = Instance.new("SurfaceGui")
    gui.Face = Enum.NormalId.Top
    gui.Parent = pickup

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = weaponData.Weapon
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = gui

    local debounce = false

    task.spawn(function()
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
                task.wait(0.05)
            end
        end
    end)

    pickup.Touched:Connect(function(hit)
        if debounce then return end
        local character = hit.Parent
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                if weaponData.Team ~= "Any" then
                    if not player.Team or player.Team.Name ~= weaponData.Team then
                        return
                    end
                end

                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    local toolCount = 0
                    for _, child in pairs(backpack:GetChildren()) do
                        if child:IsA("Tool") then
                            toolCount = toolCount + 1
                        end
                    end
                    for _, child in pairs(character:GetChildren()) do
                        if child:IsA("Tool") then
                            toolCount = toolCount + 1
                        end
                    end
                    if toolCount >= 3 then return end

                    debounce = true
                    local tool = createFullWeapon(weaponData.Weapon)
                    if tool then
                        tool.Parent = backpack
                    end
                    pickup:Destroy()
                end
            end
        end
    end)

    return pickup
end

for _, weaponData in pairs(weaponSpawns) do
    createWeaponPickup(weaponData)
end

task.spawn(function()
    while true do
        task.wait(30)
        for _, weaponData in pairs(weaponSpawns) do
            if not workspace:FindFirstChild(weaponData.Weapon .. "_Pickup") then
                createWeaponPickup(weaponData)
            end
        end
    end
end)

print("Kosova PvP - Weapon Pickups Loaded!")
