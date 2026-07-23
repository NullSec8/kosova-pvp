-- Kosova PvP - Map Builder
-- Place in ServerScriptService
-- Creates the PvP arena map

local mapFolder = Instance.new("Folder")
mapFolder.Name = "PvP_Arena"
mapFolder.Parent = workspace

-- Helper function to create parts
local function createPart(name, size, position, color, anchored, transparency)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.Position = position
    part.BrickColor = BrickColor.new(color)
    part.Anchored = anchored or true
    part.CanCollide = true
    part.Transparency = transparency or 0
    part.Parent = mapFolder
    return part
end

-- Create floor
local floor = createPart(
    "Floor",
    Vector3.new(200, 2, 200),
    Vector3.new(0, -1, 0),
    "Dark stone grey",
    true
)

-- Add grass texture to floor
local grassTexture = Instance.new("Texture")
grassTexture.Texture = "rbxassetid://287840095"
grassTexture.StudsPerTileU = 20
grassTexture.StudsPerTileV = 20
grassTexture.Face = Enum.NormalId.Top
grassTexture.Parent = floor

-- Kosovo flag colors on floor (red with black eagle silhouette)
local flagDecal = Instance.new("Decal")
flagDecal.Texture = "rbxassetid://1234567890" -- Replace with actual flag texture
flagDecal.Face = Enum.NormalId.Top
flagDecal.Parent = floor

-- Center Platform (bigger, for intense fights)
local centerPlatform = createPart(
    "CenterPlatform",
    Vector3.new(40, 3, 40),
    Vector3.new(0, 1.5, 0),
    "Bright red",
    true
)

-- Add flag symbol on center
local centerDecal = Instance.new("Decal")
centerDecal.Texture = "rbxassetid://1234567890"
centerDecal.Face = Enum.NormalId.Top
centerDecal.Parent = centerPlatform

-- Kosovo Side Buildings (Red)
local function createBuilding(name, position, size, color)
    local building = createPart(name, size, position, color, true)

    -- Add roof
    local roof = createPart(
        name .. "_Roof",
        Vector3.new(size.X + 4, 2, size.Z + 4),
        Vector3.new(position.X, position.Y + size.Y/2 + 1, position.Z),
        "Dark stone grey",
        true
    )

    -- Add window holes (simple)
    for i = -1, 1, 2 do
        local window = createPart(
            name .. "_Window",
            Vector3.new(4, 4, 1),
            Vector3.new(position.X + i * 5, position.Y, position.Z + size.Z/2 + 0.5),
            "Bright yellow",
            true,
            0.3
        )
    end

    return building
end

-- Kosovo base buildings
createBuilding("Kosova_Building1", Vector3.new(-60, 10, -40), Vector3.new(20, 20, 15), "Bright red")
createBuilding("Kosova_Building2", Vector3.new(-60, 8, 40), Vector3.new(15, 16, 12), "Bright red")
createBuilding("Kosova_Tower", Vector3.new(-80, 15, 0), Vector3.new(10, 30, 10), "Bright red")

-- Rival base buildings (Blue)
createBuilding("Rival_Building1", Vector3.new(60, 10, -40), Vector3.new(20, 20, 15), "Bright blue")
createBuilding("Rival_Building2", Vector3.new(60, 8, 40), Vector3.new(15, 16, 12), "Bright blue")
createBuilding("Rival_Tower", Vector3.new(80, 15, 0), Vector3.new(10, 30, 10), "Bright blue")

-- Cover objects (crates, barriers)
local function createCover(name, position, size, color)
    local cover = createPart(name, size, position, color, true)

    -- Make it slightly transparent for better visibility
    cover.Transparency = 0.1

    return cover
end

-- Center area covers
createCover("Cover_Center1", Vector3.new(-10, 3, -10), Vector3.new(6, 6, 6), "Dark stone grey")
createCover("Cover_Center2", Vector3.new(10, 3, 10), Vector3.new(6, 6, 6), "Dark stone grey")
createCover("Cover_Center3", Vector3.new(-10, 3, 10), Vector3.new(6, 6, 6), "Dark stone grey")
createCover("Cover_Center4", Vector3.new(10, 3, -10), Vector3.new(6, 6, 6), "Dark stone grey")

-- Side covers
for i = -3, 3 do
    createCover("Cover_Kosova_" .. i, Vector3.new(-35, 2, i * 12), Vector3.new(4, 4, 8), "Bright red")
    createCover("Cover_Rival_" .. i, Vector3.new(35, 2, i * 12), Vector3.new(4, 4, 8), "Bright blue")
end

-- Walls / barriers
createPart("Wall_Kosova", Vector3.new(2, 15, 60), Vector3.new(-90, 7.5, 0), "Bright red", true, 0.5)
createPart("Wall_Rival", Vector3.new(2, 15, 60), Vector3.new(90, 7.5, 0), "Bright blue", true, 0.5)

-- Side walls
createPart("Wall_Side1", Vector3.new(180, 10, 2), Vector3.new(0, 5, -95), "Dark stone grey", true, 0.7)
createPart("Wall_Side2", Vector3.new(180, 10, 2), Vector3.new(0, 5, 95), "Dark stone grey", true, 0.7)

-- Sniper towers
local function createSniperTower(name, position, teamColor)
    local tower = createPart(name, Vector3.new(8, 25, 8), position, teamColor, true)

    -- Platform at top
    local platform = createPart(
        name .. "_Platform",
        Vector3.new(12, 2, 12),
        Vector3.new(position.X, position.Y + 13.5, position.Z),
        "Dark stone grey",
        true
    )

    -- Railing
    createPart(name .. "_Rail1", Vector3.new(12, 3, 1), Vector3.new(position.X, position.Y + 16, position.Z - 5.5), teamColor, true, 0.5)
    createPart(name .. "_Rail2", Vector3.new(12, 3, 1), Vector3.new(position.X, position.Y + 16, position.Z + 5.5), teamColor, true, 0.5)
    createPart(name .. "_Rail3", Vector3.new(1, 3, 12), Vector3.new(position.X - 5.5, position.Y + 16, position.Z), teamColor, true, 0.5)
    createPart(name .. "_Rail4", Vector3.new(1, 3, 12), Vector3.new(position.X + 5.5, position.Y + 16, position.Z), teamColor, true, 0.5)

    return tower
end

createSniperTower("Sniper_Kosova", Vector3.new(-70, 12.5, 0), "Bright red")
createSniperTower("Sniper_Rival", Vector3.new(70, 12.5, 0), "Bright blue")

-- Ramp to center
createPart("Ramp_Kosova", Vector3.new(15, 1, 30), Vector3.new(-25, 1, 0), "Dark stone grey", true)
createPart("Ramp_Rival", Vector3.new(15, 1, 30), Vector3.new(25, 1, 0), "Dark stone grey", true)

-- Lighting
local ambientLight = Instance.new("PointLight")
ambientLight.Brightness = 2
ambientLight.Range = 100
ambientLight.Color = Color3.fromRGB(255, 255, 255)
ambientLight.Parent = centerPlatform

-- Add Kosovo flag decorations
local function createFlag(name, position, flagColor)
    local pole = createPart(name .. "_Pole", Vector3.new(1, 20, 1), position, "Dark stone grey", true)
    local flag = createPart(
        name .. "_Flag",
        Vector3.new(8, 5, 0.5),
        Vector3.new(position.X + 5, position.Y + 7, position.Z),
        flagColor,
        true,
        0.2
    )
    return pole, flag
end

-- Kosovo flags
createFlag("Flag_Kosova1", Vector3.new(-50, 10, -50), "Bright red")
createFlag("Flag_Kosova2", Vector3.new(-50, 10, 50), "Bright red")

-- Rival flags
createFlag("Flag_Rival1", Vector3.new(50, 10, -50), "Bright blue")
createFlag("Flag_Rival2", Vector3.new(50, 10, 50), "Bright blue")

-- Center flag (contest point)
createFlag("Flag_Center", Vector3.new(0, 10, 0), "Bright yellow")

print("Kosova PvP - Map Built!")
print("Arena size: 200x200 studs")
print("Features: Buildings, sniper towers, cover objects, flags")
