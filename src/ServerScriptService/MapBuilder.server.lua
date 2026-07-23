-- Kosova PvP - Pro Arena Map Builder
-- Creates a detailed gun arena with multiple levels, cover, and team bases

local mapFolder = Instance.new("Folder")
mapFolder.Name = "PvP_Arena"
mapFolder.Parent = workspace

local function p(name, size, pos, color, trans, mat)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.Position = pos
    part.BrickColor = BrickColor.new(color)
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = trans or 0
    part.Material = mat or Enum.Material.SmoothPlastic
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = mapFolder
    return part
end

-- ============ GROUND ============
p("Ground", Vector3.new(200, 2, 200), Vector3.new(0, -1, 0), "Dark stone grey")
p("Grass", Vector3.new(198, 0.2, 198), Vector3.new(0, 0.1, 0), "Bright green", 0, Enum.Material.Grass)

-- Team base floors
p("Kosova_Floor", Vector3.new(50, 1, 50), Vector3.new(-60, 0.5, 0), "Bright red", 0, Enum.Material.SmoothPlastic)
p("Rival_Floor", Vector3.new(50, 1, 50), Vector3.new(60, 0.5, 0), "Bright blue", 0, Enum.Material.SmoothPlastic)

-- Center arena
p("Center_Arena", Vector3.new(30, 0.5, 30), Vector3.new(0, 0.25, 0), "Bright yellow", 0.3, Enum.Material.Neon)

-- ============ TEAM BUILDINGS - KOSOVA ============
-- Main building
p("KV_Build1", Vector3.new(18, 14, 14), Vector3.new(-65, 8, -15), "Bright red")
p("KV_Roof1", Vector3.new(22, 2, 18), Vector3.new(-65, 16, -15), "Dark stone grey")
-- Windows
for i = -1, 1, 2 do
    p("KV_Win1_" .. i, Vector3.new(3, 3, 1), Vector3.new(-65 + i * 5, 8, -8), "Bright yellow", 0.4, Enum.Material.Neon)
    p("KV_Win2_" .. i, Vector3.new(3, 3, 1), Vector3.new(-65 + i * 5, 8, -22), "Bright yellow", 0.4, Enum.Material.Neon)
end

-- Sniper tower
p("KV_Tower", Vector3.new(8, 28, 8), Vector3.new(-80, 15, 0), "Bright red")
p("KV_TowerTop", Vector3.new(12, 2, 12), Vector3.new(-80, 30, 0), "Dark stone grey")
p("KV_TowerRail1", Vector3.new(12, 3, 1), Vector3.new(-80, 32, -5.5), "Bright red", 0.5)
p("KV_TowerRail2", Vector3.new(12, 3, 1), Vector3.new(-80, 32, 5.5), "Bright red", 0.5)
p("KV_TowerRail3", Vector3.new(1, 3, 12), Vector3.new(-85.5, 32, 0), "Bright red", 0.5)
p("KV_TowerRail4", Vector3.new(1, 3, 12), Vector3.new(-74.5, 32, 0), "Bright red", 0.5)

-- Tower stairs
for i = 0, 11 do
    p("KV_Stair_" .. i, Vector3.new(3, 1.5, 2), Vector3.new(-80, 1 + i * 2.5, -9 + i * 0.8), "Dark stone grey")
end

-- Second building
p("KV_Build2", Vector3.new(12, 10, 10), Vector3.new(-55, 6, 20), "Bright red")
p("KV_Roof2", Vector3.new(16, 2, 14), Vector3.new(-55, 12, 20), "Dark stone grey")

-- ============ TEAM BUILDINGS - RIVAL ============
p("RV_Build1", Vector3.new(18, 14, 14), Vector3.new(65, 8, -15), "Bright blue")
p("RV_Roof1", Vector3.new(22, 2, 18), Vector3.new(65, 16, -15), "Dark stone grey")
for i = -1, 1, 2 do
    p("RV_Win1_" .. i, Vector3.new(3, 3, 1), Vector3.new(65 + i * 5, 8, -8), "Bright yellow", 0.4, Enum.Material.Neon)
    p("RV_Win2_" .. i, Vector3.new(3, 3, 1), Vector3.new(65 + i * 5, 8, -22), "Bright yellow", 0.4, Enum.Material.Neon)
end

p("RV_Tower", Vector3.new(8, 28, 8), Vector3.new(80, 15, 0), "Bright blue")
p("RV_TowerTop", Vector3.new(12, 2, 12), Vector3.new(80, 30, 0), "Dark stone grey")
p("RV_TowerRail1", Vector3.new(12, 3, 1), Vector3.new(80, 32, -5.5), "Bright blue", 0.5)
p("RV_TowerRail2", Vector3.new(12, 3, 1), Vector3.new(80, 32, 5.5), "Bright blue", 0.5)
p("RV_TowerRail3", Vector3.new(1, 3, 12), Vector3.new(74.5, 32, 0), "Bright blue", 0.5)
p("RV_TowerRail4", Vector3.new(1, 3, 12), Vector3.new(85.5, 32, 0), "Bright blue", 0.5)

for i = 0, 11 do
    p("RV_Stair_" .. i, Vector3.new(3, 1.5, 2), Vector3.new(80, 1 + i * 2.5, -9 + i * 0.8), "Dark stone grey")
end

p("RV_Build2", Vector3.new(12, 10, 10), Vector3.new(55, 6, 20), "Bright blue")
p("RV_Roof2", Vector3.new(16, 2, 14), Vector3.new(55, 12, 20), "Dark stone grey")

-- ============ CENTER COVER ============
p("C_Cover1", Vector3.new(6, 6, 6), Vector3.new(-8, 4, -8), "Dark stone grey")
p("C_Cover2", Vector3.new(6, 6, 6), Vector3.new(8, 4, 8), "Dark stone grey")
p("C_Cover3", Vector3.new(6, 6, 6), Vector3.new(-8, 4, 8), "Dark stone grey")
p("C_Cover4", Vector3.new(6, 6, 6), Vector3.new(8, 4, -8), "Dark stone grey")

-- Center pillars
p("C_Pillar1", Vector3.new(3, 10, 3), Vector3.new(0, 6, -12), "Dark stone grey")
p("C_Pillar2", Vector3.new(3, 10, 3), Vector3.new(0, 6, 12), "Dark stone grey")
p("C_Pillar3", Vector3.new(3, 10, 3), Vector3.new(-12, 6, 0), "Dark stone grey")
p("C_Pillar4", Vector3.new(3, 10, 3), Vector3.new(12, 6, 0), "Dark stone grey")

-- ============ SIDE WALLS ============
for i = -3, 3 do
    p("KV_Wall_" .. i, Vector3.new(3, 8, 6), Vector3.new(-38, 5, i * 10), "Bright red", 0.15)
    p("RV_Wall_" .. i, Vector3.new(3, 8, 6), Vector3.new(38, 5, i * 10), "Bright blue", 0.15)
end

-- ============ PERIMETER WALLS ============
p("Wall_N", Vector3.new(200, 12, 2), Vector3.new(0, 7, -100), "Dark stone grey", 0.7)
p("Wall_S", Vector3.new(200, 12, 2), Vector3.new(0, 7, 100), "Dark stone grey", 0.7)
p("Wall_W", Vector3.new(2, 12, 200), Vector3.new(-100, 7, 0), "Bright red", 0.5)
p("Wall_E", Vector3.new(2, 12, 200), Vector3.new(100, 7, 0), "Bright blue", 0.5)

-- ============ RAMPS ============
local function createRamp(name, pos, length, height, width, color)
    local steps = 8
    local stepH = height / steps
    local stepD = length / steps
    for i = 0, steps - 1 do
        p(name .. "_" .. i, Vector3.new(width, stepH + 0.3, stepD + 0.3),
            Vector3.new(pos.X, pos.Y + (i + 0.5) * stepH, pos.Z + (i - steps / 2) * stepD),
            color)
    end
end

createRamp("Ramp_KV", Vector3.new(-25, 1, 0), 20, 5, 12, "Bright red")
createRamp("Ramp_RV", Vector3.new(25, 1, 0), 20, 5, 12, "Bright blue")

-- ============ RAMP PLATFORMS ============
p("Platform_KV", Vector3.new(14, 2, 14), Vector3.new(-25, 5.5, 0), "Dark stone grey")
p("Platform_RV", Vector3.new(14, 2, 14), Vector3.new(25, 5.5, 0), "Dark stone grey")

-- ============ TUNNEL ============
p("Tunnel_Top", Vector3.new(8, 2, 20), Vector3.new(0, 8, 0), "Dark stone grey")
p("Tunnel_Left", Vector3.new(2, 8, 20), Vector3.new(-4, 4, 0), "Dark stone grey")
p("Tunnel_Right", Vector3.new(2, 8, 20), Vector3.new(4, 4, 0), "Dark stone grey")

-- ============ CRATES / SMALL COVER ============
local cratePositions = {
    Vector3.new(-45, 2, -35), Vector3.new(-45, 2, 35),
    Vector3.new(45, 2, -35), Vector3.new(45, 2, 35),
    Vector3.new(-15, 2, -30), Vector3.new(-15, 2, 30),
    Vector3.new(15, 2, -30), Vector3.new(15, 2, 30),
    Vector3.new(-5, 2, -20), Vector3.new(5, 2, 20),
    Vector3.new(-5, 2, 20), Vector3.new(5, 2, -20),
    Vector3.new(0, 2, -35), Vector3.new(0, 2, 35),
}
for i, pos in ipairs(cratePositions) do
    p("Crate_" .. i, Vector3.new(4, 4, 4), pos, "Reddish brown", 0, Enum.Material.Wood)
end

-- ============ FLAGS ============
local function createFlag(name, pos, color, text)
    p(name .. "_Pole", Vector3.new(1, 18, 1), pos, "Dark stone grey")
    local gui = Instance.new("SurfaceGui")
    gui.Face = Enum.NormalId.Right
    gui.Parent = mapFolder:FindFirstChild(name .. "_Pole") or mapFolder
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color == "Bright red" and Color3.fromRGB(204, 0, 0) or color == "Bright blue" and Color3.fromRGB(0, 102, 204) or Color3.fromRGB(255, 200, 0)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Position = UDim2.new(0, 0, 0.25, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
end

createFlag("Flag_KV1", Vector3.new(-60, 12, -40), "Bright red", "KOSOVA")
createFlag("Flag_KV2", Vector3.new(-60, 12, 40), "Bright red", "KOSOVA")
createFlag("Flag_RV1", Vector3.new(60, 12, -40), "Bright blue", "RIVAL")
createFlag("Flag_RV2", Vector3.new(60, 12, 40), "Bright blue", "RIVAL")
createFlag("Flag_Center", Vector3.new(0, 12, 0), "Bright yellow", "ARENA")

-- ============ LIGHTING ============
local centerLight = Instance.new("PointLight")
centerLight.Brightness = 2
centerLight.Range = 100
centerLight.Color = Color3.fromRGB(255, 255, 255)
centerLight.Parent = mapFolder:FindFirstChild("Center_Arena")

local kvLight = Instance.new("PointLight")
kvLight.Brightness = 1.5
kvLight.Range = 60
kvLight.Color = Color3.fromRGB(255, 100, 100)
kvLight.Parent = mapFolder:FindFirstChild("KV_Tower")

local rvLight = Instance.new("PointLight")
rvLight.Brightness = 1.5
rvLight.Range = 60
rvLight.Color = Color3.fromRGB(100, 150, 255)
rvLight.Parent = mapFolder:FindFirstChild("RV_Tower")

print("Kosova PvP - Pro Arena Built!")
print("Features: 2 team bases, 2 sniper towers, ramps, tunnel, center cover, crates")
