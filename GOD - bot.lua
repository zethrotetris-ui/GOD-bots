local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/sirius-menu/rayfield/main/rayfield.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Homeless Life Hub",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "HomelessLifeHub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Main Tab for basic features
local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Main Features")

-- Infinite Jump Button
local InfiniteJumpEnabled = false
local Button = MainTab:CreateButton({
   Name = "Toggle Infinite Jump",
   Callback = function()
      InfiniteJumpEnabled = not InfiniteJumpEnabled
      if InfiniteJumpEnabled then
         game:GetService("UserInputService").JumpRequest:Connect(function()
            if InfiniteJumpEnabled then
               game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
         end)
         Rayfield:Notify({
            Title = "Infinite Jump",
            Content = "Enabled!",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Infinite Jump",
            Content = "Disabled!",
            Duration = 3
         })
      end
   end,
})

-- Noclip Toggle
local NoclipToggle = MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      local noclipLoop = nil
      if Value then
         local function enableNoclip(character)
            if character then
               for _, part in ipairs(character:GetDescendants()) do
                  if part:IsA("BasePart") and part.CanCollide then
                     part.CanCollide = false
                  end
               end
            end
         end
         if player.Character then
            enableNoclip(player.Character)
         end
         player.CharacterAdded:Connect(enableNoclip)
         noclipLoop = task.spawn(function()
            while Value do
               wait(1)
               if player.Character then
                  enableNoclip(player.Character)
               end
            end
         end)
         Rayfield:Notify({
            Title = "Noclip",
            Content = "Enabled!",
            Duration = 3
         })
      else
         if noclipLoop then
            task.cancel(noclipLoop)
            noclipLoop = nil
         end
         local function disableNoclip(character)
            if character then
               for _, part in ipairs(character:GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = true
                  end
               end
            end
         end
         if player.Character then
            disableNoclip(player.Character)
         end
         Rayfield:Notify({
            Title = "Noclip",
            Content = "Disabled!",
            Duration = 3
         })
      end
   end,
})

-- Farm Tab for auto-farming
local FarmTab = Window:CreateTab("Farm", 4483362458)
local FarmSection = FarmTab:CreateSection("Auto Farm Features")

-- Auto Farm Toggle (e.g., auto-work jobs like Pizza Place)
local AutoFarmEnabled = false
local AutoFarmToggle = FarmTab:CreateToggle({
   Name = "Auto Farm Jobs",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      AutoFarmEnabled = Value
      if Value then
         task.spawn(function()
            while AutoFarmEnabled do
               wait(1)  -- Adjust delay as needed
               local player = game.Players.LocalPlayer
               if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  -- Example: Teleport to Pizza Place and simulate work (adjust based on game)
                  local pizzaPlace = workspace:FindFirstChild("PizzaPlace")  -- Replace with actual path if different
                  if pizzaPlace then
                     player.Character.HumanoidRootPart.CFrame = pizzaPlace.CFrame + Vector3.new(0, 5, 0)
                     -- Simulate clicking or interacting (this is a placeholder; real auto-farm might need more logic)
                     wait(2)
                     -- Add job interaction code here if possible (e.g., fire events)
                  end
               end
            end
         end)
         Rayfield:Notify({
            Title = "Auto Farm",
            Content = "Enabled! Farming jobs...",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Auto Farm",
            Content = "Disabled!",
            Duration = 3
         })
      end
   end,
})

-- Teleports Tab
local TPTab = Window:CreateTab("🏝 Teleports", nil)
local TPSection = TPTab:CreateSection("Teleport to Locations")

-- Teleport to Spawn
local Button1 = TPTab:CreateButton({
   Name = "Teleport to Spawn",
   Callback = function()
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)  -- Adjust to actual spawn coords in Homeless Life
         Rayfield:Notify({
            Title = "Teleport",
            Content = "Teleported to Spawn!",
            Duration = 3
         })
      end
   end,
})

-- Teleport to Pizza Place (Job)
local Button2 = TPTab:CreateButton({
   Name = "Teleport to Pizza Place",
   Callback = function()
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         local pizzaPlace = workspace:FindFirstChild("PizzaPlace")  -- Adjust path
         if pizzaPlace then
            player.Character.HumanoidRootPart.CFrame = pizzaPlace.CFrame + Vector3.new(0, 5, 0)
         else
            player.Character.HumanoidRootPart.CFrame = CFrame.new(100, 10, 100)  -- Fallback coords
         end
         Rayfield:Notify({
            Title = "Teleport",
            Content = "Teleported to Pizza Place!",
            Duration = 3
         })
      end
   end,
})

-- Teleport to Another Spot (e.g., Bank or House Area)
local Button3 = TPTab:CreateButton({
   Name = "Teleport to Bank",
   Callback = function()
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         player.Character.HumanoidRootPart.CFrame = CFrame.new(200, 10, 200)  -- Adjust to actual bank coords
         Rayfield:Notify({
            Title = "Teleport",
            Content = "Teleported to Bank!",
            Duration = 3
         })
      end
   end,
})
