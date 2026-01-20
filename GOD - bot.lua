 
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Global toggle for flying (now jump-based teleport)
local flyingEnabled = false

-- Create ScreenGui if not already present (or just use an existing one)
local screenGui = script.Parent -- Assuming this script is inside ScreenGui

-- Toggle Button (Hamburger Icon)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = ""
toggleBtn.Parent = screenGui

-- Hamburger Lines (using Frames for simplicity)
local line1 = Instance.new("Frame")
line1.Size = UDim2.new(1, -10, 0, 4)
line1.Position = UDim2.new(0, 5, 0, 10)
line1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
line1.BorderSizePixel = 0
line1.Parent = toggleBtn

local line2 = Instance.new("Frame")
line2.Size = UDim2.new(1, -10, 0, 4)
line2.Position = UDim2.new(0, 5, 0, 23)
line2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
line2.BorderSizePixel = 0
line2.Parent = toggleBtn

local line3 = Instance.new("Frame")
line3.Size = UDim2.new(1, -10, 0, 4)
line3.Position = UDim2.new(0, 5, 0, 36)
line3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
line3.BorderSizePixel = 0
line3.Parent = toggleBtn

-- Menu Frame
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 200, 0, 0) -- Starts collapsed
menu.Position = UDim2.new(0, 20, 0, 80)
menu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menu.BorderSizePixel = 0
menu.ClipsDescendants = true
menu.Parent = screenGui

-- Menu Items (using TextButtons)
local homeBtn = Instance.new("TextButton")
homeBtn.Size = UDim2.new(1, 0, 0, 40)
homeBtn.Position = UDim2.new(0, 0, 0, 0)
homeBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
homeBtn.Text = "Home"
homeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
homeBtn.Parent = menu

local aboutBtn = Instance.new("TextButton")
aboutBtn.Size = UDim2.new(1, 0, 0, 40)
aboutBtn.Position = UDim2.new(0, 0, 0, 40)
aboutBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
aboutBtn.Text = "About"
aboutBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
aboutBtn.Parent = menu

-- Select Target Section
local selectTargetBtn = Instance.new("TextButton")
selectTargetBtn.Size = UDim2.new(1, 0, 0, 40)
selectTargetBtn.Position = UDim2.new(0, 0, 0, 80)
selectTargetBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
selectTargetBtn.Text = "Select Target ▼"
selectTargetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
selectTargetBtn.Parent = menu

-- Enable Flying Toggle Button (now for jump-based teleport)
local enableFlyingBtn = Instance.new("TextButton")
enableFlyingBtn.Size = UDim2.new(1, 0, 0, 40)
enableFlyingBtn.Position = UDim2.new(0, 0, 0, 160) -- Positioned below Select Target
enableFlyingBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
enableFlyingBtn.Text = "Enable Flying: OFF"
enableFlyingBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
enableFlyingBtn.Parent = menu

-- Dropdown Frame for Targets (hidden initially)
local dropdown = Instance.new("Frame")
dropdown.Size = UDim2.new(1, 0, 0, 0) -- Starts collapsed
dropdown.Position = UDim2.new(0, 0, 0, 120)
dropdown.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
dropdown.BorderSizePixel = 0
dropdown.ClipsDescendants = true
dropdown.Parent = menu

-- Example Targets (customize as needed, e.g., player names)
local targets = {"Player1", "Player2", "Enemy1", "Ally1"} -- Replace with dynamic list if needed
for i, target in ipairs(targets) do
    local targetBtn = Instance.new("TextButton")
    targetBtn.Size = UDim2.new(1, 0, 0, 30)
    targetBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
    targetBtn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    targetBtn.Text = target
    targetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    targetBtn.Parent = dropdown
    
    -- Handle target selection: Jump-teleport to the selected player if enabled
    targetBtn.MouseButton1Click:Connect(function()
        local targetPlayer = Players:FindFirstChild(target) -- Assumes target is a player name
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local localCharacter = localPlayer.Character
            if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and localCharacter:FindFirstChild("Humanoid") then
                if flyingEnabled then
                    -- Jump-based teleport logic (inspired by infinite jump script)
                    local humanoid = localCharacter.Humanoid
                    local rootPart = localCharacter.HumanoidRootPart
                    local targetRootPart = targetPlayer.Character.HumanoidRootPart
                    
                    -- Disable controls during teleport
                    humanoid.PlatformStand = true
                    
                    -- Save original walk speed
                    local originalWalkSpeed = humanoid.WalkSpeed
                    
                    -- Set high speed for fast teleport
                    humanoid.WalkSpeed = 100
                    
                    -- Enable infinite jump (from the provided script logic)
                    local infiniteJumpEnabled = true
                    local jumpConnection = UserInputService.JumpRequest:Connect(function()
                        if infiniteJumpEnabled then
                            humanoid:ChangeState("Jumping")
                        end
                    end)
                    
                    -- Target position (11 studs above)
                    local targetPos = targetRootPart.Position + Vector3.new(0, 11, 0)
                    
                    -- Move towards target with jumping
                    while (rootPart.Position - targetPos).Magnitude > 5 do
                        humanoid:MoveTo(targetPos)
                        wait(0.1) -- Small delay to allow movement
                    end
                    
                    -- Arrived: Disable jump, reset speed, re-enable controls
                    infiniteJumpEnabled = false
                    jumpConnection:Disconnect()
                    humanoid.WalkSpeed = originalWalkSpeed
                    humanoid.PlatformStand = false
                    
                    print("Jump-teleported to target: " .. target .. " (positioned 11 studs above)")
                else
                    print("Flying disabled. Selected target: " .. target)
                end
            else
                warn("Local character not found or invalid.")
            end
        else
            warn("Target player not found or invalid.")
        end
    end)
end

-- Toggle Enable Flying (now for jump-teleport)
enableFlyingBtn.MouseButton1Click:Connect(function()
    flyingEnabled = not flyingEnabled
    enableFlyingBtn.Text = flyingEnabled and "Enable Flying: ON" or "Enable Flying: OFF"
    print("Jump-teleport " .. (flyingEnabled and "enabled" or "disabled"))
end)

-- Toggle Logic
local isOpen = false
local menuTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local dropdownTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        -- Animate hamburger to X
        TweenService:Create(line1, TweenInfo.new(0.3), {Rotation = 45, Position = UDim2.new(0, 5, 0, 23)}):Play()
        TweenService:Create(line2, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 4)}):Play()
        TweenService:Create(line3, TweenInfo.new(0.3), {Rotation = -45, Position = UDim2.new(0, 5, 0, 23)}):Play()
        
        -- Open menu
        TweenService:Create(menu, menuTweenInfo, {Size = UDim2.new(0, 200, 0, 240)}):Play() -- Increased height for new button
    else
        -- Animate X back to hamburger
        TweenService:Create(line1, TweenInfo.new(0.3), {Rotation = 0, Position = UDim2.new(0, 5, 0, 10)}):Play()
        TweenService:Create(line2, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 4)}):Play()
        TweenService:Create(line3, TweenInfo.new(0.3), {Rotation = 0, Position = UDim2.new(0, 5, 0, 36)}):Play()
        
        -- Close menu
        TweenService:Create(menu, menuTweenInfo, {Size = UDim2.new(0, 200, 0, 0)}):Play()
    end
end)

-- Toggle Dropdown
local dropdownOpen = false
selectTargetBtn.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    if dropdownOpen then
        TweenService:Create(dropdown, dropdownTweenInfo, {Size = UDim2.new(1, 0, 0, #targets * 30)}):Play()
        selectTargetBtn.Text = "Select Target ▲"
    else
        TweenService:Create(dropdown, dropdownTweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
        selectTargetBtn.Text = "Select Target ▼"
    end
end)
