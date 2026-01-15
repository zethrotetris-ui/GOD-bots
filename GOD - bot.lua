-- 🔥 ULTIMATE FLYING BOT SWARM | DIRECT CHASE KILLS TARGET | Delta Mobile FIXED
local Players, RunService = game:GetService("Players"), game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local bots, targetPlayer, gui, status = {}, nil
local hitboxSize = Vector3.new(30,30,30)  -- HUGE for overlap kills
local numBots = 3
local botSpeed = 50  -- Fly speed

-- SPAWN RED FLY BOT (RELIABLE!)
local function spawnFlyBot(pos)
    local model = Instance.new("Model")
    model.Name = "FlyBot"
    model.Parent = workspace
    
    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(5,7,3)
    root.Color = Color3.new(1,0.2,0.2)  -- BRIGHT RED
    root.Transparency = 0.1
    root.CanCollide = false
    root.Anchored = false
    root.Position = pos
    root.Parent = model
    
    local hum = Instance.new("Humanoid")
    hum.Parent = model
    hum.PlatformStand = true  -- No walk, fly only
    
    model.PrimaryPart = root
    
    -- ESP
    local bb = Instance.new("BillboardGui", root)
    bb.Size = UDim2.new(0,140,0,70)
    bb.StudsOffset = Vector3.new(0,4,0)
    bb.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "🤖 FLY BOT\nKILLING"
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    
    -- BODY VELOCITY FOR FLY CHASE
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(4000,4000,4000)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = root
    
    return {model = model, root = root, bv = bv}
end

function spawnBots()
    local char = LocalPlayer.Character
    if not char?.HumanoidRootPart then status.Text = "❌ Load character!" return end
    for i=1,numBots do
        local botData = spawnFlyBot(char.HumanoidRootPart.Position + Vector3.new(math.random(-8,8),10,math.random(-8,8)))
        bots[#bots+1] = botData
        print("🤖 FlyBot #"..i.." SPAWNED & FLYING!")
    end
end

function clearBots()
    for _, botData in bots do if botData.model then botData.model:Destroy() end end
    bots = {}
end

-- GUI
local function createGUI()
    gui = Instance.new("ScreenGui", game.CoreGui) gui.Name = "FlyBots" gui.ResetOnSpawn = false
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,360,0,340) frame.Position = UDim2.new(0.5,-180,0,10)
    frame.BackgroundColor3 = Color3.new(0.1,0.1,0.2) frame.Active = true frame.Draggable = true
    local uc = Instance.new("UICorner", frame) uc.CornerRadius = UDim.new(0,20)
    
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,60) title.BackgroundTransparency = 1 title.Text = "🤖 FLYING BOT SWARM"
    title.TextColor3 = Color3.new(1,1,1) title.TextScaled = true title.Font = Enum.Font.GothamBold
    
    local nameBox = Instance.new("TextBox", frame)
    nameBox.Size = UDim2.new(1,-20,0,50) nameBox.Position = UDim2.new(0,10,0,75)
    nameBox.PlaceholderText = "Target Username" nameBox.TextColor3 = Color3.new(1,1,1) nameBox.TextScaled = true
    local nc = Instance.new("UICorner", nameBox) nc.CornerRadius = UDim.new(0,12)
    
    local spawnBtn = Instance.new("TextButton", frame)
    spawnBtn.Size = UDim2.new(1,-20,0,55) spawnBtn.Position = UDim2.new(0,10,0,135)
    spawnBtn.BackgroundColor3 = Color3.new(0.2,0.8,0.2) spawnBtn.Text = "🚀 SPAWN 3 FLY BOTS"
    spawnBtn.TextColor3 = Color3.new(1,1,1) spawnBtn.TextScaled = true spawnBtn.Font = Enum.Font.GothamBold
    local sc = Instance.new("UICorner", spawnBtn) sc.CornerRadius = UDim.new(0,15)
    
    local clearBtn = Instance.new("TextButton", frame)
    clearBtn.Size = UDim2.new(0.48,-12,0,50) clearBtn.Position = UDim2.new(0,10,0,205)
    clearBtn.BackgroundColor3 = Color3.new(0.8,0.2,0.2) clearBtn.Text = "🗑️ DELETE ALL"
    clearBtn.TextColor3 = Color3.new(1,1,1) clearBtn.TextScaled = true clearBtn.Font = Enum.Font.Gotham
    local cc = Instance.new("UICorner", clearBtn) cc.CornerRadius = UDim.new(0,12)
    
    status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(0.48,-12,0,50) status.Position = UDim2.new(0.5,8,0,205)
    status.BackgroundTransparency = 1 status.Text = "👆 Name → SPAWN → SWARM!" status.TextColor3 = Color3.new(1,1,0)
    status.TextScaled = true status.Font = Enum.Font.Gotham status.TextWrapped = true
    
    spawnBtn.MouseButton1Click:Connect(function()
        local name = nameBox.Text:lower()
        targetPlayer = nil
        for _, p in Players:GetPlayers() do if p ~= LocalPlayer and p.Name:lower() == name then targetPlayer = p break end end
        if not targetPlayer then status.Text = "❌ NOT FOUND" status.TextColor3 = Color3.new(1,0,0) return end
        clearBots()
        spawnBots()
        status.Text = "✅ BOTS FLYING TO "..targetPlayer.Name status.TextColor3 = Color3.new(0,1,0)
    end)
    clearBtn.MouseButton1Click:Connect(function() clearBots() status.Text = "🗑️ DELETED" status.TextColor3 = Color3.new(1,1,0) end)
end

-- SWARM LOOP (FLY + SPAM)
local lastSpam = 0
RunService.Heartbeat:Connect(function()
    if targetPlayer?.Character then
        local tRoot = targetPlayer.Character.HumanoidRootPart
        if tRoot then
            -- MEGA HITBOX
            tRoot.Size = hitboxSize tRoot.Transparency = 0.3 tRoot.CanCollide = false
            
            -- BOTS FLY TO TARGET
            for _, botData in bots do
                if botData.root and botData.bv and tRoot then
                    local dir = (tRoot.Position - botData.root.Position).Unit
                    botData.bv.Velocity = dir * botSpeed
                    -- SNAP ONTO TARGET EVERY 2s (OVERLAP KILL)
                    if tick() % 2 < 0.1 then
                        botData.root.Position = tRoot.Position + Vector3.new(math.random(-3,3),0,math.random(-3,3))
                    end
                end
            end
            
            -- YOUR AUTO PUNCH (WHEN CLOSE)
            local myRoot = LocalPlayer.Character?.HumanoidRootPart
            if myRoot and (myRoot.Position - tRoot.Position).Magnitude < 40 and tick() - lastSpam > 0.1 then
                VirtualUser:ClickButton1(Vector2.new())
                lastSpam = tick()
            end
        end
    end
end)

createGUI()
print("✅ FLYING BOTS LOADED - SPAWN & WATCH SWARM!")
