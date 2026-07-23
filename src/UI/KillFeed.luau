local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Theme = require(script.Parent.Theme)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local ForValues = Fusion.ForValues

local player = Players.LocalPlayer

local nextEntryId = 0

local function createKillFeed()
    local screenGui = New "ScreenGui" {
        Name = "KosovaPvP_KillFeed",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    }

    local container = New "Frame" {
        Name = "Container",
        Size = UDim2.new(0, 350, 0, 300),
        Position = UDim2.new(1, -370, 0, 80),
        BackgroundTransparency = 1,
        Parent = screenGui,

        [Fusion.Children] = {
            New "UIListLayout" {
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Padding = UDim.new(0, 6),
            },
        },
    }

    local entries = Value({})

    local function addKillEntry(killerName, victimName, weapon)
        local current = entries:get()
        nextEntryId = nextEntryId + 1
        local newEntry = {
            Id = nextEntryId,
            Killer = killerName,
            Victim = victimName,
            Weapon = weapon,
            Time = tick(),
        }

        local updated = {}
        for i, e in current do
            if i > 8 then
                continue
            end
            table.insert(updated, e)
        end
        table.insert(updated, 1, newEntry)
        entries:set(updated)

        task.delay(6, function()
            local now = entries:get()
            local filtered = {}
            for _, e in now do
                if e.Id ~= newEntry.Id then
                    table.insert(filtered, e)
                end
            end
            entries:set(filtered)
        end)
    end

    Fusion.ForValues(entries, function(entry, scope)
        local frame = New "Frame" {
            Name = "Kill_" .. entry.Id,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.Colors.BackgroundDark,
            BackgroundTransparency = 0.15,
            BorderSizePixel = 0,

            [Fusion.Children] = {
                New "UICorner" { CornerRadius = UDim.new(0, 6) },
                New "UIStroke" {
                    Color = Theme.Colors.BackgroundLight,
                    Thickness = 1,
                    Transparency = 0.7,
                },
                New "TextLabel" {
                    Name = "Killer",
                    Size = UDim2.new(0.35, 0, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = entry.Killer,
                    TextColor3 = Theme.Colors.Kosova,
                    TextScaled = true,
                    Font = Theme.Fonts.Title,
                    TextXAlignment = Enum.TextXAlignment.Left,
                },
                New "TextLabel" {
                    Name = "Weapon",
                    Size = UDim2.new(0.25, 0, 1, 0),
                    Position = UDim2.new(0.37, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "[ " .. entry.Weapon .. " ]",
                    TextColor3 = Theme.Colors.TextDim,
                    TextScaled = true,
                    Font = Theme.Fonts.Mono,
                },
                New "TextLabel" {
                    Name = "Victim",
                    Size = UDim2.new(0.35, 0, 1, 0),
                    Position = UDim2.new(0.63, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = entry.Victim,
                    TextColor3 = Theme.Colors.Rival,
                    TextScaled = true,
                    Font = Theme.Fonts.Title,
                    TextXAlignment = Enum.TextXAlignment.Right,
                },
            },
        }

        return frame
    end, {
        parent = container,
    })

    local killEvent = ReplicatedStorage:WaitForChild("KillEvent", 10)
    if killEvent then
        killEvent.OnClientEvent:Connect(function(killerName, victimName, weapon)
            addKillEntry(killerName, victimName, weapon or "Unknown")
        end)
    end

    screenGui.Parent = player.PlayerGui
    return screenGui
end

return createKillFeed
