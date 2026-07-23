local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Theme = require(script.Parent.Theme)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Observer = Fusion.Observer

local player = Players.LocalPlayer

local function createHUD()
    local screenGui = New "ScreenGui" {
        Name = "KosovaPvP_HUD",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    }

    local health = Value(100)
    local maxHealth = Value(100)
    local teamName = Value("KOSOVA")
    local teamColor = Value(Theme.Colors.Kosova)
    local kosovaScore = Value(0)
    local rivalScore = Value(0)
    local timer = Value(180)
    local announcement = Value("")
    local announceVisible = Value(false)
    local announceColor = Value(Theme.Colors.White)
    local isDead = Value(false)
    local killerName = Value("")

    local function formatTime(s)
        local mins = math.floor(s / 60)
        local secs = s % 60
        return string.format("%d:%02d", mins, secs)
    end

    local function getTeamKills(tName)
        local total = 0
        for _, p in Players:GetPlayers() do
            if p.Team and p.Team.Name == tName and p:FindFirstChild("leaderstats") then
                total = total + p.leaderstats.Kills.Value
            end
        end
        return total
    end

    local healthPercent = Computed(function()
        return health:get() / maxHealth:get()
    end)

    local healthColor = Computed(function()
        local hp = healthPercent:get()
        if hp > 0.6 then
            return Theme.Colors.Success
        elseif hp > 0.3 then
            return Theme.Colors.Warning
        else
            return Theme.Colors.Danger
        end
    end)

    local timerText = Computed(function()
        return formatTime(timer:get())
    end)

    local healthText = Computed(function()
        return math.floor(health:get()) .. " / " .. maxHealth:get()
    end)

    local kosovaScoreText = Computed(function()
        return "KOSOVA  " .. getTeamKills("Kosova")
    end)

    local rivalScoreText = Computed(function()
        return getTeamKills("Rival") .. "  RIVAL"
    end)

    local mainFrame = New "Frame" {
        Name = "HUD",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = screenGui,

        [Fusion.Children] = {
            New "Frame" {
                Name = "TopBar",
                Size = UDim2.new(0, 420, 0, 70),
                Position = UDim2.new(0.5, -210, 0, 16),
                BackgroundColor3 = Theme.Colors.Background,
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                Parent = mainFrame,

                [Fusion.Children] = {
                    New "UICorner" { CornerRadius = Theme.CornerRadiusLarge },
                    New "UIStroke" {
                        Color = Theme.Colors.Accent,
                        Thickness = 2,
                        Transparency = 0.5,
                    },

                    New "TextLabel" {
                        Name = "Kosova",
                        Size = UDim2.new(0.42, 0, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        BackgroundTransparency = 1,
                        Text = kosovaScoreText,
                        TextColor3 = Theme.Colors.Kosova,
                        TextScaled = true,
                        Font = Theme.Fonts.Title,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    },

                    New "TextLabel" {
                        Name = "VS",
                        Size = UDim2.new(0.16, 0, 1, 0),
                        Position = UDim2.new(0.42, 0, 0, 0),
                        BackgroundTransparency = 1,
                        Text = "VS",
                        TextColor3 = Theme.Colors.TextDim,
                        TextScaled = true,
                        Font = Theme.Fonts.Title,
                    },

                    New "TextLabel" {
                        Name = "Rival",
                        Size = UDim2.new(0.42, 0, 1, 0),
                        Position = UDim2.new(0.58, 0, 0, 0),
                        BackgroundTransparency = 1,
                        Text = rivalScoreText,
                        TextColor3 = Theme.Colors.Rival,
                        TextScaled = true,
                        Font = Theme.Fonts.Title,
                        TextXAlignment = Enum.TextXAlignment.Right,
                    },
                },
            },

            New "Frame" {
                Name = "Timer",
                Size = UDim2.new(0, 100, 0, 36),
                Position = UDim2.new(0.5, -50, 0, 92),
                BackgroundColor3 = Theme.Colors.BackgroundDark,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                Parent = mainFrame,

                [Fusion.Children] = {
                    New "UICorner" { CornerRadius = Theme.CornerRadius },
                    New "TextLabel" {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = timerText,
                        TextColor3 = Theme.Colors.Gold,
                        TextScaled = true,
                        Font = Theme.Fonts.Mono,
                    },
                },
            },

            New "Frame" {
                Name = "TeamBar",
                Size = UDim2.new(0, 180, 0, 40),
                Position = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Theme.Colors.Background,
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                Parent = mainFrame,

                [Fusion.Children] = {
                    New "UICorner" { CornerRadius = Theme.CornerRadius },
                    New "Frame" {
                        Name = "AccentBar",
                        Size = UDim2.new(0, 4, 0.6, 0),
                        Position = UDim2.new(0, 10, 0.2, 0),
                        BackgroundColor3 = teamColor,
                        BorderSizePixel = 0,
                    },
                    New "TextLabel" {
                        Size = UDim2.new(1, -24, 1, 0),
                        Position = UDim2.new(0, 20, 0, 0),
                        BackgroundTransparency = 1,
                        Text = teamName,
                        TextColor3 = Theme.Colors.Text,
                        TextScaled = true,
                        Font = Theme.Fonts.Title,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    },
                },
            },

            New "Frame" {
                Name = "HealthContainer",
                Size = UDim2.new(0, 320, 0, 44),
                Position = UDim2.new(0.5, -160, 1, -72),
                BackgroundColor3 = Theme.Colors.BackgroundDark,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                Parent = mainFrame,

                [Fusion.Children] = {
                    New "UICorner" { CornerRadius = Theme.CornerRadius },
                    New "Frame" {
                        Name = "HealthFill",
                        Size = Computed(function()
                            return UDim2.new(healthPercent:get(), 0, 1, 0)
                        end),
                        BackgroundColor3 = healthColor,
                        BorderSizePixel = 0,

                        [Fusion.Children] = {
                            New "UICorner" { CornerRadius = Theme.CornerRadius },
                        },
                    },
                    New "TextLabel" {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = healthText,
                        TextColor3 = Theme.Colors.White,
                        TextScaled = true,
                        Font = Theme.Fonts.Title,
                        ZIndex = 2,
                    },
                },
            },

            New "Frame" {
                Name = "Announcement",
                Size = UDim2.new(0, 500, 0, 80),
                Position = UDim2.new(0.5, -250, 0.25, 0),
                BackgroundColor3 = Theme.Colors.BackgroundDark,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                Visible = announceVisible,
                Parent = mainFrame,

                [Fusion.Children] = {
                    New "UICorner" { CornerRadius = Theme.CornerRadiusLarge },
                    New "UIStroke" {
                        Color = Theme.Colors.Accent,
                        Thickness = 2,
                    },
                    New "TextLabel" {
                        Size = UDim2.new(1, -20, 1, 0),
                        Position = UDim2.new(0, 10, 0, 0),
                        BackgroundTransparency = 1,
                        Text = announcement,
                        TextColor3 = announceColor,
                        TextScaled = true,
                        Font = Theme.Fonts.Title,
                    },
                },
            },

            New "Frame" {
                Name = "DeathScreen",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Theme.Colors.Black,
                BackgroundTransparency = 0.4,
                Visible = isDead,
                Parent = mainFrame,

                [Fusion.Children] = {
                    New "TextLabel" {
                        Size = UDim2.new(0, 400, 0, 60),
                        Position = UDim2.new(0.5, -200, 0.4, 0),
                        BackgroundTransparency = 1,
                        Text = Computed(function()
                            return "KILLED BY " .. killerName:get()
                        end),
                        TextColor3 = Theme.Colors.Danger,
                        TextScaled = true,
                        Font = Theme.Fonts.Title,
                    },
                    New "TextLabel" {
                        Size = UDim2.new(0, 200, 0, 40),
                        Position = UDim2.new(0.5, -100, 0.5, 0),
                        BackgroundTransparency = 1,
                        Text = "Respawning...",
                        TextColor3 = Theme.Colors.TextDim,
                        TextScaled = true,
                        Font = Theme.Fonts.Body,
                    },
                },
            },
        },
    }

    local gameEvent = ReplicatedStorage:WaitForChild("GameEvent", 10)
    if gameEvent then
        local pendingHide = nil

        local function hideAfter(delay)
            if pendingHide then
                task.cancel(pendingHide)
            end
            pendingHide = task.delay(delay, function()
                announceVisible:set(false)
                pendingHide = nil
            end)
        end

        gameEvent.OnClientEvent:Connect(function(action, data)
            if action == "Timer" then
                timer:set(data)
            elseif action == "RoundStart" then
                announcement:set("ROUND STARTED!")
                announceColor:set(Theme.Colors.Success)
                announceVisible:set(true)
                hideAfter(3)
            elseif action == "RoundEnd" then
                announcement:set(data .. " WINS!")
                if data == "Kosova" then
                    announceColor:set(Theme.Colors.Kosova)
                elseif data == "Rival" then
                    announceColor:set(Theme.Colors.Rival)
                else
                    announceColor:set(Theme.Colors.Gold)
                end
                announceVisible:set(true)
                hideAfter(5)
            elseif action == "Intermission" then
                announcement:set("INTERMISSION")
                announceColor:set(Theme.Colors.Gold)
                announceVisible:set(true)
            elseif action == "Killed" then
                isDead:set(true)
                killerName:set(data or "the void")
                task.delay(4, function()
                    isDead:set(false)
                end)
            end
        end)
    end

    Fusion.Observer(Observer(player), function()
        if player.Team then
            teamName:set(player.Team.Name:upper())
            if player.Team.Name == "Kosova" then
                teamColor:set(Theme.Colors.Kosova)
            else
                teamColor:set(Theme.Colors.Rival)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.15)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local hum = player.Character.Humanoid
                health:set(hum.Health)
                maxHealth:set(hum.MaxHealth)
            end
            kosovaScore:set(getTeamKills("Kosova"))
            rivalScore:set(getTeamKills("Rival"))
            if player.Team then
                teamName:set(player.Team.Name:upper())
                if player.Team.Name == "Kosova" then
                    teamColor:set(Theme.Colors.Kosova)
                else
                    teamColor:set(Theme.Colors.Rival)
                end
            end
        end
    end)

    screenGui.Parent = player.PlayerGui
    return screenGui
end

return createHUD
