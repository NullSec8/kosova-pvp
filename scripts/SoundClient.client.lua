-- Kosova PvP - Sound Client
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local soundEvent = ReplicatedStorage:WaitForChild("SoundEvent")

-- Create local sounds
local function createSound(name, soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.Name = name
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound.PlaybackSpeed = pitch or 1
    sound.Parent = SoundService
    return sound
end

-- Sound effects
local sounds = {
    Hit = createSound("HitSound", "rbxassetid://535689717", 0.5, 1),
    Kill = createSound("KillSound", "rbxassetid://535690488", 0.6, 1),
    SwordSwing = createSound("SwordSwing", "rbxassetid://535687386", 0.4, 1),
    KnifeSwing = createSound("KnifeSwing", "rbxassetid://535687386", 0.3, 1.2),
    GunShot = createSound("GunShot", "rbxassetid://535688794", 0.7, 1),
    Respawn = createSound("RespawnSound", "rbxassetid://535689722", 0.4, 1),
    RoundStart = createSound("RoundStart", "rbxassetid://535689733", 0.5, 1),
    RoundEnd = createSound("RoundEnd", "rbxassetid://535689744", 0.5, 1),
}

-- Play sound when server fires
soundEvent.OnClientEvent:Connect(function(soundName)
    if sounds[soundName] then
        sounds[soundName]:Play()
    end
end)

-- Play hit sound when dealing damage
local combatEvent = ReplicatedStorage:WaitForChild("CombatEvent")
combatEvent.OnServerEvent:Connect(function(action, target)
    if action == "Hit" then
        sounds.Hit:Play()
    end
end)

print("Kosova PvP - Sound Client Loaded!")
