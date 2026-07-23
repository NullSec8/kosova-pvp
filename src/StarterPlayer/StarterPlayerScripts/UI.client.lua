-- Kosova PvP - Fusion UI Layer
-- Place in StarterPlayerScripts
-- Only creates HUD and KillFeed - combat is in CombatClient

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local createHUD = require(script.Parent.UILib.HUD)
local createKillFeed = require(script.Parent.UILib.KillFeed)

local hud = createHUD()
local killFeed = createKillFeed()

print("Kosova PvP - Fusion UI Loaded!")
