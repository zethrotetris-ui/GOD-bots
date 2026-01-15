local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local bots = {}
local targetPlayer
local hitboxSize = Vector3.new(40, 40, 40)
local numBots = 4

local function spawnFlyBot(pos)
    local model = Instance.new("Model")
    model.Name = "GODBot"
    model.Parent = workspace

    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(4, 6, 2)
    root.Color = Color3.fromRGB(255, 50, 50)
    root.Transparency = 0.2
    root.CanCollide = false
    root.Anchored = true
    root.Position = pos + Vector3.new(0, 12, 0)
    root.Parent = model

    task.delay(0.06, function() root.Anchored = false end)

    local hum = Instance.new("Humanoid")
    hum.Parent = model
    hum.PlatformStand = true

    model.PrimaryPart = root

    local bb = Instance.new("BillboardGui", root)
    bb.Size = UDim2.new(0, 80, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "BOT"
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextScaled = true

    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(20000, 120000, 20000)
    bp.D = 1200
    bp.P = 12500
    bp.Parent = root

    print("Spawned bot at " .. tostring(pos))
    return {model = model, root = root, bp = bp}
end

local function spawnBotsAroundChar()
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then 
        print("Cannot spawn: No character / HRP")
        return 
    end
    clearBots()
    for i = 1, numBots do
        local offset = Vector3.new(math.random(-10,10), 0, math.random(-10,10))
        local bot = spawnFlyBot(char.PrimaryPart.Position + offset)
        table.insert(bots, bot)
    end
    print("Spawned " .. numBots .. " bots around you")
end

local function clearBots()
    for _, bot in ipairs(bots) do
        if bot.model then bot.model:Destroy() end
    end
    bots = {}
    print("Bots cleared")
end

-- GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "GOD_Bots"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 220)
frame.Position = UDim2.new(0.5, -140, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "GOD Bot Swarm - Debug"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,0.8,0.8)
title.TextSize = 20

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.9,0,0,35)
input.Position = UDim2.new(0.05,0,0.18,0)
input.PlaceholderText = "Target name (partial)"
input.TextScaled = true

local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Size = UDim2.new(0.9,0,0,40)
spawnBtn.Position = UDim2.new(0.05,0,0.38,0)
spawnBtn.Text = "Spawn & Target Player"
spawnBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)

local testBtn = Instance.new("TextButton", frame)
testBtn.Size = UDim2.new(0.9,0,0,40)
testBtn.Position = UDim2.new(0.05,0,0.58,0)
testBtn.Text = "Test Spawn Around Me"
testBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 220)

local clearBtn = Instance.new("TextButton", frame)
clearBtn.Size = UDim2.new(0.9,0,0,40)
clearBtn.Position = UDim2.new(0.05,0,0.78,0)
clearBtn.Text = "Clear Bots"
clearBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)

spawnBtn.MouseButton1Click:Connect(function()
    local search = input.Text:lower()
    if search == "" then print("Enter a name") return end
    targetPlayer = nil
    for _, plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and plr.Name:lower():find(search, 1, true) then
            targetPlayer = plr
            break
        end
    end
    if targetPlayer then
        print("Target locked: " .. targetPlayer.Name)
        spawnBotsAroundChar()
    else
        print("No player matching: " .. search)
    end
end)

testBtn.MouseButton1Click:Connect(spawnBotsAroundChar)
clearBtn.MouseButton1Click:Connect(clearBots)

local lastClick = 0
RunService.Heartbeat:Connect(function()
    if not targetPlayer or not targetPlayer.Character then return end
    local hrp = targetPlayer.Character:FindFirstChildWhichIsA("BasePart", true) -- more forgiving
    if not hrp then return end

    hrp.Size = hitboxSize
    hrp.Transparency = 0.6
    hrp.CanCollide = false

    for _, bot in ipairs(bots) do
        if bot.root and bot.bp then
            local offset = Vector3.new(math.random(-6,6), 5 + math.random(-2,4), math.random(-6,6))
            bot.bp.Position = hrp.Position + offset
        end
    end

    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHrp and (myHrp.Position - hrp.Position).Magnitude <= 50 then
        if tick() - lastClick > 0.07 then
            VirtualUser:ClickButton1(Vector2.new())
            lastClick = tick()
        end
    end
end)

print("GOD Bots loaded - use 'Test Spawn Around Me' to check spawning")
