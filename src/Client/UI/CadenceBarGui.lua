--!strict
local Players = game:GetService("Players")

local CadenceBarGui = {}

function CadenceBarGui.Init()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CadenceUI"
	screenGui.ResetOnSpawn = false
	
	local barBackground = Instance.new("Frame")
	barBackground.Size = UDim2.new(0, 200, 0, 20)
	barBackground.Position = UDim2.new(0.5, -100, 0.9, -20)
	barBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	barBackground.Parent = screenGui
	
	local barFill = Instance.new("Frame")
	barFill.Name = "Fill"
	barFill.Size = UDim2.new(0.5, 0, 1, 0)
	barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green zone default
	barFill.Parent = barBackground
	
	-- Aksesibilitas non-warna
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "StatusText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "Cadence: OPTIMAL"
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Parent = barBackground
	
	screenGui.Parent = playerGui
end

return CadenceBarGui
