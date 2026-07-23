local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Theme = require(script.Parent.Theme)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed

local player = Players.LocalPlayer

local function createCombatUI()
    local screenGui = New "ScreenGui" {
        Name = "KosovaPvP_Combat",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    }

    local ammo = Value(30)
    local maxAmmo = Value(30)
    local isGun = Value(false)
    local reloading = Value(false)
    local showCrosshair = Value(false)

    local ammoText = Computed(function()
        return ammo:get() .. " / " .. maxAmmo:get()
    end)

    local ammoColor = Computed(function()
        if ammo:get() <= 5 then
            return Theme.Colors.Danger
        elseif ammo:get() <= 15 then
            return Theme.Colors.Warning
        else
            return Theme.Colors.Text
        end
    end)

    local crosshairSize = 40
    local gap = 6
    local lineLen = 8
    local lineThick = 2

    local crosshairFrame = New "Frame" {
        Name = "Crosshair",
        Size = UDim2.new(0, crosshairSize, 0, crosshairSize),
        Position = UDim2.new(0.5, -crosshairSize / 2, 0.5, -crosshairSize / 2),
        BackgroundTransparency = 1,
        Visible = showCrosshair,
        Parent = screenGui,

        [Fusion.Children] = {
            New "Frame" {
                Name = "Dot",
                Size = UDim2.new(0, 4, 0, 4),
                Position = UDim2.new(0.5, -2, 0.5, -2),
                BackgroundColor3 = Theme.Colors.White,
                BorderSizePixel = 0,
                ZIndex = 2,
            },
            New "Frame" {
                Name = "Top",
                Size = UDim2.new(0, lineThick, 0, lineLen),
                Position = UDim2.new(0.5, -lineThick / 2, 0, gap),
                BackgroundColor3 = Theme.Colors.White,
                BorderSizePixel = 0,
            },
            New "Frame" {
                Name = "Bottom",
                Size = UDim2.new(0, lineThick, 0, lineLen),
                Position = UDim2.new(0.5, -lineThick / 2, 1, -gap - lineLen),
                BackgroundColor3 = Theme.Colors.White,
                BorderSizePixel = 0,
            },
            New "Frame" {
                Name = "Left",
                Size = UDim2.new(0, lineLen, 0, lineThick),
                Position = UDim2.new(0, gap, 0.5, -lineThick / 2),
                BackgroundColor3 = Theme.Colors.White,
                BorderSizePixel = 0,
            },
            New "Frame" {
                Name = "Right",
                Size = UDim2.new(0, lineLen, 0, lineThick),
                Position = UDim2.new(1, -gap - lineLen, 0.5, -lineThick / 2),
                BackgroundColor3 = Theme.Colors.White,
                BorderSizePixel = 0,
            },
        },
    }

    local ammoFrame = New "Frame" {
        Name = "AmmoFrame",
        Size = UDim2.new(0, 140, 0, 48),
        Position = UDim2.new(1, -160, 1, -68),
        BackgroundColor3 = Theme.Colors.BackgroundDark,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = isGun,
        Parent = screenGui,

        [Fusion.Children] = {
            New "UICorner" { CornerRadius = Theme.CornerRadius },
            New "UIStroke" {
                Color = Theme.Colors.BackgroundLight,
                Thickness = 1,
                Transparency = 0.5,
            },
            New "TextLabel" {
                Name = "AmmoText",
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = ammoText,
                TextColor3 = ammoColor,
                TextScaled = true,
                Font = Theme.Fonts.Mono,
                TextXAlignment = Enum.TextXAlignment.Right,
            },
        },
    }

    local reloadFrame = New "Frame" {
        Name = "ReloadFrame",
        Size = UDim2.new(0, 220, 0, 36),
        Position = UDim2.new(0.5, -110, 0.6, 0),
        BackgroundColor3 = Theme.Colors.BackgroundDark,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Visible = reloading,
        Parent = screenGui,

        [Fusion.Children] = {
            New "UICorner" { CornerRadius = Theme.CornerRadius },
            New "TextLabel" {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "RELOADING...",
                TextColor3 = Theme.Colors.Warning,
                TextScaled = true,
                Font = Theme.Fonts.Title,
            },
        },
    }

    local damageFlash = New "Frame" {
        Name = "DamageFlash",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Colors.Danger,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = screenGui,
    }

    screenGui.Parent = player.PlayerGui

    return {
        Gui = screenGui,
        SetAmmo = function(a) ammo:set(a) end,
        SetMaxAmmo = function(m) maxAmmo:set(m) end,
        SetIsGun = function(g) isGun:set(g) end,
        SetReloading = function(r) reloading:set(r) end,
        ShowCrosshair = function(s) showCrosshair:set(s) end,
        FlashDamage = function()
            damageFlash.BackgroundTransparency = 0.4
            task.delay(0.4, function()
                damageFlash.BackgroundTransparency = 1
            end)
        end,
    }
end

return createCombatUI
