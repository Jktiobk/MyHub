local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "ZeroTraceHub🔥✅😈", HidePremium = false,IntroText = "ZeroTraceHub🔥✅", SaveConfig = true, ConfigFolder = "OrionTest"})

local Player = Window:MakeTab({
	Name = "Player 👤",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Movement = Window:MakeTab({
	Name = "Movement ⚡",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Visual = Window:MakeTab({
	Name = "Visual 👁️",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Misc = Window:MakeTab({
	Name = "Misc 🧩",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local selectedPlayer = nil
function updatePlayers()
    local list = {}
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(list, v.Name)
        end
    end
    return list
end

local Dropdown = Movement:AddDropdown({
	Name = "Select Player",
	Default = "",
	Options = updatePlayers(),
	Callback = function(Value)
		selectedPlayer = Players:FindFirstChild(Value)
	end    
})

Players.PlayerAdded:Connect(function()
    Dropdown:Refresh(updatePlayers(), true)
end)

Players.PlayerRemoving:Connect(function()
    Dropdown:Refresh(updatePlayers(), true)
end)

Movement:AddButton({
	Name = "Teleport To Player",
	Callback = function()
		if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myChar = LocalPlayer.Character
			if myChar and myChar:FindFirstChild("HumanoidRootPart") then
				myChar.HumanoidRootPart.CFrame =
					selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
			end
		else
			warn("Player not found / no character")
		end
	end    
})


local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local flying = false
local speed = 150
local control = {f=0,b=0,l=0,r=0}
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.W then control.f = 1 end
	if i.KeyCode == Enum.KeyCode.S then control.b = -1 end
	if i.KeyCode == Enum.KeyCode.A then control.l = -1 end
	if i.KeyCode == Enum.KeyCode.D then control.r = 1 end
end)
UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.W then control.f = 0 end
	if i.KeyCode == Enum.KeyCode.S then control.b = 0 end
	if i.KeyCode == Enum.KeyCode.A then control.l = 0 end
	if i.KeyCode == Enum.KeyCode.D then control.r = 0 end
end)
Movement:AddButton({
	Name = "Fly",
	Callback = function()
		flying = not flying
		local plr = game.Players.LocalPlayer
		local char = plr.Character or plr.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		if flying then
			
			if hrp:FindFirstChildOfClass("BodyVelocity") then
				hrp:FindFirstChildOfClass("BodyVelocity"):Destroy()
			end
			local bv = Instance.new("BodyVelocity", hrp)
			bv.MaxForce = Vector3.new(1e6,1e6,1e6)

			RS:BindToRenderStep("fly",0,function()
				if not flying then return end
				
				local cam = workspace.CurrentCamera
				local dir = Vector3.new(control.l+control.r,0,control.f+control.b)
				
				if dir.Magnitude > 0 then
					dir = dir.Unit
					bv.Velocity = (cam.CFrame.RightVector*dir.X + cam.CFrame.LookVector*dir.Z) * speed
				else
					bv.Velocity = Vector3.new(0,0,0) -- ลอยนิ่ง
				end
			end)
			
		else
			RS:UnbindFromRenderStep("fly")
			if hrp:FindFirstChildOfClass("BodyVelocity") then
				hrp:FindFirstChildOfClass("BodyVelocity"):Destroy()
			end
		end
	end
})


local spawnPos = nil
Player:AddButton({
	Name = "Set Spawn",
	Callback = function()
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			spawnPos = char.HumanoidRootPart.CFrame
		end
	end
})
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if spawnPos then
		local hrp = char:WaitForChild("HumanoidRootPart")
		hrp.CFrame = spawnPos
	end
end)


local noclip = false
local RS = game:GetService("RunService")
local player = game.Players.LocalPlayer
Player:AddToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(Value)
		noclip = Value
		
		local char = player.Character or player.CharacterAdded:Wait()
		
		if noclip then
			RS:BindToRenderStep("noclip", 0, function()
				if not noclip then return end
				
				for _, v in pairs(char:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end)
		else
			RS:UnbindFromRenderStep("noclip")
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
		end
	end
})
player.CharacterAdded:Connect(function(char)
	if noclip then
		task.wait(0.5)
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)


local infJump = false
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
Player:AddToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(Value)
		infJump = Value
	end
})
UIS.JumpRequest:Connect(function()
	if infJump then
		local char = player.Character
		if char then
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local selectedPlayer = nil
local spectating = false
local currentTarget = nil

function updatePlayers()
    local list = {}
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(list, v.Name)
        end
    end
    return list
end

local Dropdown = Visual:AddDropdown({
	Name = "Select Player",
	Default = "",
	Options = updatePlayers(),
	Callback = function(Value)
		selectedPlayer = Players:FindFirstChild(Value)
		currentTarget = selectedPlayer -- กันบัคตัวเก่า

		if spectating and selectedPlayer then
			task.spawn(function()
				repeat task.wait()
				until selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid")

				-- เช็คว่าไม่ใช่ตัวเก่า
				if spectating and currentTarget == selectedPlayer then
					Camera.CameraSubject = selectedPlayer.Character.Humanoid
				end
			end)
		end
	end    
})


Players.PlayerAdded:Connect(function()
	Dropdown:Refresh(updatePlayers(), true)
end)

Players.PlayerRemoving:Connect(function()
	Dropdown:Refresh(updatePlayers(), true)
end)

Visual:AddToggle({
	Name = "Spectate 👁️",
	Default = false,
	Callback = function(Value)
		spectating = Value

		if Value and selectedPlayer then
			currentTarget = selectedPlayer

			task.spawn(function()
				repeat task.wait()
				until selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid")

				if spectating and currentTarget == selectedPlayer then
					Camera.CameraSubject = selectedPlayer.Character.Humanoid
				end
			end)

		else
			
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				Camera.CameraSubject = LocalPlayer.Character.Humanoid
			end
		end
	end    
})


local esp = false
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function getTeamColor(p)
	if p.Team and p.Team.TeamColor then
		return p.Team.TeamColor.Color
	end
	return Color3.fromRGB(255,255,255)
end
local function removeESP(player, char)
	if not char then return end
	
	if char:FindFirstChild("ESP") then
		char.ESP:Destroy()
	end
	
	if char:FindFirstChild("Head") and char.Head:FindFirstChild("NameESP") then
		char.Head.NameESP:Destroy()
	end
	
	pcall(function()
		RS:UnbindFromRenderStep(player.Name.."ESP")
	end)
end
local function addESP(player, char)
	if not char then return end
	removeESP(player, char)
	local color = getTeamColor(player)
	local h = Instance.new("Highlight")
	h.Name = "ESP"
	h.FillTransparency = 1
	h.OutlineColor = color
	h.Parent = char
	local head = char:FindFirstChild("Head")
	if head then
		local bill = Instance.new("BillboardGui")
		bill.Name = "NameESP"
		bill.Size = UDim2.new(0,140,0,30)
		bill.StudsOffset = Vector3.new(0,2,0)
		bill.AlwaysOnTop = true
		bill.Parent = head

		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1,0,1,0)
		text.BackgroundTransparency = 1
		text.TextStrokeTransparency = 0
		text.TextScaled = true
		text.Font = Enum.Font.SourceSansBold
		text.Parent = bill
		RS:BindToRenderStep(player.Name.."ESP",0,function()
			if not esp or not char.Parent then return end
			local myChar = LocalPlayer.Character
			if not myChar then return end
			local myHRP = myChar:FindFirstChild("HumanoidRootPart")
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChild("Humanoid")
			
			if myHRP and hrp and hum then
				local dist = (myHRP.Position - hrp.Position).Magnitude
				local hp = math.floor(hum.Health)
				text.Text = player.Name.." | "..hp.." | "..math.floor(dist)
				text.TextColor3 = getTeamColor(player)
				h.OutlineColor = getTeamColor(player)
			end
		end)
	end
end
Visual:AddToggle({
	Name = "ESP",
	Default = false,
	Callback = function(Value)
		esp = Value
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				if esp and p.Character then
					addESP(p, p.Character)
				else
					removeESP(p, p.Character)
				end
			end
		end
	end
})
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(char)
		if esp then
			task.wait(0.5)
			addESP(p, char)
		end
	end)
end)
for _, p in pairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		p.CharacterAdded:Connect(function(char)
			if esp then
				task.wait(0.5)
				addESP(p, char)
			end
		end)
	end
end
LocalPlayer.CharacterAdded:Connect(function()
	if esp then
		task.wait(0.5)
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				addESP(p, p.Character)
			end
		end
	end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local toolEnabled = false
local tool
Movement:AddButton({
	Name = "Click TP Tool",
	Callback = function()
		toolEnabled = not toolEnabled
		if toolEnabled then
			tool = Instance.new("Tool")
			tool.Name = "TP Tool"
			tool.RequiresHandle = false
			tool.Parent = LocalPlayer.Backpack
			tool.Activated:Connect(function()
				local mouse = LocalPlayer:GetMouse()
				local char = LocalPlayer.Character
				if not char then return end
				
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then return end
				
				if mouse.Target then
					local pos = mouse.Hit.Position + Vector3.new(0,3,0)
					hrp.CFrame = CFrame.new(pos)
				end
			end)
			
		else
			if tool then
				tool:Destroy()
				tool = nil
			end
		end
	end
})


local tpMouse = false
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
Movement:AddToggle({
	Name = "TP Mouse",
	Default = false,
	Callback = function(Value)
		tpMouse = Value
	end
})
mouse.Button1Down:Connect(function()
	if not tpMouse then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if mouse.Target then
		local pos = mouse.Hit.Position
		hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
	end
end)


local player = game.Players.LocalPlayer
local speedValue = 16 -- จำค่า
Movement:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 1000,
	Default = 16,
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		speedValue = Value -- 🔥 จำค่าไว้
		
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = Value
		end
	end    
})
player.CharacterAdded:Connect(function(char)
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = speedValue
end)


local player = game.Players.LocalPlayer
local jumpValue = 50
local function applyJump(char)
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if humanoid.UseJumpPower then
			humanoid.JumpPower = jumpValue
		else
			humanoid.JumpHeight = jumpValue / 10
		end
	end
end
local function setJump(value)
	jumpValue = value
	local char = player.Character
	if char then
		applyJump(char)
	end
end
player.CharacterAdded:Connect(function(char)
	local humanoid = char:WaitForChild("Humanoid")
	task.wait(0.1) -- กันบางเกม override ค่า
	applyJump(char)
end)
Movement:AddSlider({
	Name = "Jump Power",
	Min = 50,
	Max = 1000,
	Default = 50,
	Increment = 5,
	ValueName = "Jump",
	Callback = function(Value)
		setJump(Value)
	end    
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hitboxEnabled = false
local hitboxSize = 5
Player:AddSlider({
	Name = "Hitbox Size",
	Min = 2,
	Max = 20,
	Default = 5,
	Increment = 1,
	ValueName = "Size",
	Callback = function(Value)
		hitboxSize = Value
	end
})
Player:AddToggle({
	Name = "Hitbox Expand",
	Default = false,
	Callback = function(Value)
		hitboxEnabled = Value
	end
})
game:GetService("RunService").RenderStepped:Connect(function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				if hitboxEnabled then
					hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
					hrp.Transparency = 0.5
					hrp.BrickColor = BrickColor.new("Really red")
					hrp.Material = Enum.Material.Neon
					hrp.CanCollide = false
				else
					hrp.Size = Vector3.new(2,2,1)
					hrp.Transparency = 1
					hrp.Material = Enum.Material.Plastic
				end
			end
		end
	end
end)


Misc:AddButton({
	Name = "Rejoin",
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end
})

Misc:AddButton({
	Name = "Server Hop",
	Callback = function()
		local ts = game:GetService("TeleportService")
		local players = game:GetService("Players")
		ts:Teleport(game.PlaceId, players.LocalPlayer)
	end
})

local fps = false
local saved = {}

Misc:AddToggle({
	Name = "FPS Boost",
	Default = false,
	Callback = function(Value)
		fps = Value
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				if fps then
					saved[v] = {
						Material = v.Material,
						Reflectance = v.Reflectance
					}
					v.Material = Enum.Material.SmoothPlastic
					v.Reflectance = 0
				else
					if saved[v] then
						v.Material = saved[v].Material
						v.Reflectance = saved[v].Reflectance
					end
				end
			elseif v:IsA("Decal") then
				if fps then
					saved[v] = {Transparency = v.Transparency}
					v.Transparency = 1
				else
					if saved[v] then
						v.Transparency = saved[v].Transparency
					end
				end
			end
		end
	end
})

local low = false
local oldQuality = settings().Rendering.QualityLevel
Misc:AddToggle({
	Name = "Low Graphics",
	Default = false,
	Callback = function(Value)
		low = Value
		if low then
			oldQuality = settings().Rendering.QualityLevel
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		else
			settings().Rendering.QualityLevel = oldQuality
		end
	end
})


local antiAFK = false
local VirtualUser = game:GetService("VirtualUser")
Misc:AddToggle({
	Name = "Anti AFK",
	Default = false,
	Callback = function(Value)
		antiAFK = Value
	end
})
game.Players.LocalPlayer.Idled:Connect(function()
	if antiAFK then
		VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		wait(1)
		VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	end
end)

local xray = false
Visual:AddToggle({
	Name = "XRay",
	Default = false,
	Callback = function(Value)
		xray = Value
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				if xray then
					if v.Name ~= "HumanoidRootPart" then
						v.LocalTransparencyModifier = 0.7 -- 🔥 ปรับความโปร่ง
					end
				else
					v.LocalTransparencyModifier = 0
				end
			end
		end
	end
})


local spin = false
local spinSpeed = 20
Misc:AddSlider({
	Name = "Spin Speed",
	Min = 1,
	Max = 1000,
	Default = 20,
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		spinSpeed = Value
	end
})
Misc:AddToggle({
	Name = "Spin",
	Default = false,
	Callback = function(Value)
		spin = Value
		while spin do
			task.wait()
			
			local char = game.Players.LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(spinSpeed), 0)
			end
		end
	end
})

local Lighting = game:GetService("Lighting")
local fullbright = false
local old = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient
}
Visual:AddToggle({
	Name = "Fullbright",
	Default = false,
	Callback = function(Value)
		fullbright = Value
		if fullbright then
			Lighting.Brightness = 3
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.new(1,1,1)
			Lighting.OutdoorAmbient = Color3.new(1,1,1)
		else
			for i,v in pairs(old) do
				Lighting[i] = v
			end
		end
	end
})
Lighting.Changed:Connect(function()
	if fullbright then
		Lighting.Brightness = 3
		Lighting.ClockTime = 14
	end
end)
