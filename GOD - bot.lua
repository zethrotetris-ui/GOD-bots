local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local bots = {}
local targetPlayer = nil
local hitboxSize = Vector3.new(50, 50, 50)
local numBots = 5
local status, gui, nameBox, toolBox

local function getToolSource(toolName)
    local char = Local
