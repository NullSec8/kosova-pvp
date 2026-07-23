-- Kosova PvP - Sound Effects
-- Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local function createSound(name, soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.Name = name
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound.PlaybackSpeed = pitch or 1
    sound.Parent = SoundService
    return sound
end

local sounds = {
    Hit = createSound("HitSound", "rbxassetid://535689717", 0.7, 1),
    Kill = createSound("KillSound", "rbxassetid://535690488", 0.8, 1),
    SwordSwing = createSound("SwordSwing", "rbxassetid://535687386", 0.6, 1),
    KnifeSwing = createSound("KnifeSwing", "rbxassetid://535687386", 0.5, 1.3),
    GunShot = createSound("GunShot", "rbxassetid://150544849", 0.9, 1),
    Respawn = createSound("RespawnSound", "rbxassetid://535689722", 0.6, 1),
    RoundStart = createSound("RoundStart", "rbxassetid://535689733", 0.7, 1),
    RoundEnd = createSound("RoundEnd", "rbxassetid://535689744", 0.7, 1),
    GunCock = createSound("GunCock", "rbxassetid://138244068", 0.4, 1),
    HitMarker = createSound("HitMarker", "rbxassetid://535689717", 0.3, 1.5),
}

local soundEvent = Instance.new("RemoteEvent")
soundEvent.Name = "SoundEvent"
soundEvent.Parent = ReplicatedStorage

local function playSoundForAll(soundName)
    for _, player in pairs(Players:GetPlayers()) do
        soundEvent:FireClient(player, soundName)
    end
end

local function playSoundForPlayer(player, soundName)
    soundEvent:FireClient(player, soundName)
end

local combatEvent = ReplicatedStorage:WaitForChild("CombatEvent")

combatEvent.OnServerEvent:Connect(function(player, action, target)
    if action == "Attack" then
        local character = player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                if tool.Name == "Sword" then
                    playSoundForPlayer(player, "SwordSwing")
                elseif tool.Name == "Knife" then
                    playSoundForPlayer(player, "KnifeSwing")
                elseif tool.Name == "AK47" then
                    playSoundForAll("GunShot")
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        playSoundForPlayer(player, "Respawn")
    end)
end)

print("Kosova PvP - Sound System Loaded!")
