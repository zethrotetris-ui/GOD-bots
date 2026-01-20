local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/sirius-menu/rayfield/main/rayfield.lua'))()  -- Replaced with the actual URL (assuming it's the correct one; if not, find the real Rayfield URL)

local Window = Rayfield:CreateWindow({
   Name = "Infinite Jump Script",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Main", 4483362458) -- Title, Image
local MainSection = MainTab:CreateSection("Main")

local Button = MainTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
  local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:connect(function()
	if InfiniteJumpEnabled then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
local InfiniteJump = CreateButton("Infinite Jump: On", StuffFrame)
InfiniteJump.Position = UDim2.new(0,10,0,130)
InfiniteJump.Size = UDim2.new(0,150,0,30)
InfiniteJump.MouseButton1Click:connect(function()
	local state = InfiniteJump.Text:sub(string.len("Infinite Jump: ") + 1) --too lazy to count lol
	local new = state == "Off" and "On" or state == "On" and "Off"
	InfiniteJumpEnabled = new == "On"
	InfiniteJump.Text = "Infinite Jump: " .. new
end)
   end,
})

local Toggle = MainTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        print("FARMING")
   end,
})

-- Added Noclip Toggle with looping to keep it active
local NoclipToggle = MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle", -- Unique flag
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      local noclipLoop = nil
      if Value then
         -- Enable noclip with loop
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
         -- Loop to keep noclip on
         noclipLoop = task.spawn(function()
            while Value do
               wait(1)
               if player.Character then
                  enableNoclip(player.Character)
               end
            end
         end)
         print("Noclip enabled")
      else
         -- Disable noclip
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
         print("Noclip disabled")
      end
   end,
})

local TPTab = Window:CreateTab("🏝 Teleports", nil) -- Title, Image

local Button1 = TPTab:CreateButton({
   Name = "Starter Island",
   Callback = function()
        --Teleport1
   end,
})

local Button2 = TPTab:CreateButton({
   Name = "Pirate Island",
   Callback = function()
        --Teleport2
   end,
})

local Button3 = TPTab:CreateButton({
   Name = "Pineapple Paradise",
   Callback = function()
        --Teleport3
   end,
})

local TPTab =
