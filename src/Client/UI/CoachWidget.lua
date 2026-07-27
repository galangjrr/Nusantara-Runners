--!strict
local Players = game:GetService("Players")

local CoachWidget = {}

function CoachWidget.Init()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CoachUI"
	screenGui.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Name = "CoachFrame"
	frame.Size = UDim2.new(0, 200, 0, 100)
	frame.Position = UDim2.new(1, -220, 0, 130)
	frame.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
	frame.Parent = screenGui
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0.5, 0)
	label.Text = "XP: 0 / 500"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.Parent = frame
	
	local label2 = Instance.new("TextLabel")
	label2.Size = UDim2.new(1, 0, 0.5, 0)
	label2.Position = UDim2.new(0, 0, 0.5, 0)
	label2.Text = "Multiplier: 1.0x"
	label2.TextColor3 = Color3.fromRGB(200, 200, 200)
	label2.BackgroundTransparency = 1
	label2.Parent = frame
	
	screenGui.Parent = playerGui
end

return CoachWidget
