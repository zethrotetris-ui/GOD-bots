local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local bots = {}
local targetPlayer
local hitboxSize = Vector3.new(30, 30, 30)
local numBots = 3

local function spawnFlyBot(pos)
    local model = Instance.new("Model")
    model.Name = "FlyBot"
    model.Parent = workspace
    
    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(5, 7, 3)
    root.Color = Color3.new(1, .2, .2)
    root.Transparency = .1
    root.CanCollide = false
    root.Anchored = true  -- Start anchored
    root.Position = pos + Vector3.new(0, 15, 0)  -- Higher spawn
    root.Parent = model
    
    task.wait(0.05)       -- Tiny wait for physics to settle
    root.Anchored = false -- Then release (prevents most void falls)
    
    local hum = Instance.new("Humanoid")
    hum.Parent = model
    hum.PlatformStand = true
    
    model.PrimaryPart = root
    
    local bb = Instance.new("BillboardGui", root)
    bb.Size = UDim2.new(0, 100, 0, 50)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "BOT"
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextScaled = true
    
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(15000, 80000, 15000)  -- Stronger Y force
    bp.D = 1500
    bp.P = 10000
    bp.Parent = root
    
    return {model = model, root = root, bp = bp}
end

local function spawnBots()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    for i = 1, numBots do
        local offset = Vector3.new(math.random(-8,8), 5, math.random(-8,8))
        local botData = spawnFlyBot(char.HumanoidRootPart.Position + offset)
        bots[#bots+1] = botData
    end
end

local function clearBots()
    for _, b in bots do if b.model then b.model:Destroy() end end
    bots = {}
end

-- Simple GUI (you can expand this)
local sg = Instance.new("ScreenGui", game.CoreGui)
local f = Instance.new("Frame", sg); f.Size = UDim2.new(0,220,0,180); f.Position = UDim2.new(0.5,-110,0.1,0); f.BackgroundColor3 = Color3.new(0.1,0.1,0.15); f.Active = true; f.Draggable = true
local tb = Instance.new("TextBox", f); tb.Size = UDim2.new(0.9,0,0,30); tb.Position = UDim2.new(0.05,0,0.1,0); tb.PlaceholderText = "Target username"
local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.9,0,0,40); btn.Position = UDim2.new(0.05,0,0.35,0); btn.Text = "Spawn Bots"; btn.BackgroundColor3 = Color3.new(0,0.6,0)
local clr = Instance.new("TextButton", f); clr.Size = UDim2.new(0.9,0,0,40); clr.Position = UDim2.new(0.05,0,0.6,0); clr.Text = "Clear Bots"; clr.BackgroundColor3 = Color3.new(0.6,0,0)

btn.MouseButton1Click:Connect(function()
    local name = tb.Text:lower()
    targetPlayer = nil
    for _, p in Players:GetPlayers() do
        if p.Name:lower():find(name) then targetPlayer = p; break end
    end
    if targetPlayer then clearBots(); spawnBots() end
end)

clr.MouseButton1Click:Connect(clearBots)

local last = 0
RunService.Heartbeat:Connect(function()
    if not targetPlayer or not targetPlayer.Character then return end
    local tr = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not tr then return end
    
    tr.Size = hitboxSize
    tr.Transparency = 0.4
    tr.CanCollide = false
    
    for _, b in bots do
        if b.root and b.bp then
            local tp = tr.Position + Vector3.new(math.random(-5,5), 4, math.random(-5,5))
            b.bp.Position = tp
        end
    end
    
    local mr = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if mr and (mr.Position - tr.Position).Magnitude < 45 and tick() - last > 0.08 then
        VirtualUser:ClickButton1(Vector2.new())
        last = tick()
    end
end)

print("Fixed GOD bots loaded (anti-fall + stronger hover)")
