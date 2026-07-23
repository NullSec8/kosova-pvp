local Theme = {}

Theme.Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    BackgroundLight = Color3.fromRGB(35, 35, 42),
    BackgroundDark = Color3.fromRGB(12, 12, 15),
    Accent = Color3.fromRGB(220, 50, 50),
    AccentBlue = Color3.fromRGB(50, 120, 220),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(160, 160, 170),
    Success = Color3.fromRGB(50, 200, 80),
    Warning = Color3.fromRGB(240, 180, 40),
    Danger = Color3.fromRGB(220, 50, 50),
    Kosova = Color3.fromRGB(200, 40, 40),
    Rival = Color3.fromRGB(40, 100, 200),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Gold = Color3.fromRGB(255, 200, 50),
    Silver = Color3.fromRGB(180, 180, 190),
}

Theme.Fonts = {
    Title = Enum.Font.GothamBold,
    Body = Enum.Font.Gotham,
    Mono = Enum.Font.Code,
}

Theme.CornerRadius = UDim.new(0, 8)
Theme.CornerRadiusLarge = UDim.new(0, 12)

Theme.Padding = function(px)
    return UDim.new(0, px)
end

return Theme
