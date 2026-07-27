--!strict
local Players = game:GetService("Players")

local StraviWidget = {}

function StraviWidget.Init()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "StraviUI"
	screenGui.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Name = "StraviFrame"
	frame.Size = UDim2.new(0, 200, 0, 100)
	frame.Position = UDim2.new(1, -220, 0, 20)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Parent = screenGui
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0.5, 0)
	label.Text = "KOM: None"
	label.TextColor3 = Color3.fromRGB(255, 215, 0)
	label.BackgroundTransparency = 1
	label.Parent = frame
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0.5, -10)
	btn.Position = UDim2.new(0, 10, 0.5, 5)
	btn.Text = "Give Kudos"
	btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = frame
	
	screenGui.Parent = playerGui
	
	btn.MouseButton1Click:Connect(function()
		print("Attempting to give kudos...")
	end)
end

return StraviWidget
