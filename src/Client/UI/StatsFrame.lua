--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteContracts = require(ReplicatedStorage.Shared.RemoteContracts)
local UIConstants = require(ReplicatedStorage.Shared.UIConstants)

local StatsFrame = {}

function StatsFrame.Init()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "HUD"
	screenGui.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Name = "StatsFrame"
	frame.Size = UDim2.new(0, 220, 0, 90)
	frame.Position = UDim2.new(0, 16, 0, 16)
	frame.BackgroundColor3 = UIConstants.Colors.BackgroundDark
	frame.Parent = screenGui
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 12)
	uiCorner.Parent = frame
	
	local cashLabel = Instance.new("TextLabel")
	cashLabel.Name = "CashLabel"
	cashLabel.Size = UDim2.new(0.5, -4, 0.33, 0)
	cashLabel.Text = "Cash: 0"
	cashLabel.TextColor3 = UIConstants.Colors.Success
	cashLabel.BackgroundTransparency = 1
	cashLabel.Font = Enum.Font.GothamMedium
	cashLabel.TextSize = 18
	cashLabel.Parent = frame
	
	local rubiesLabel = Instance.new("TextLabel")
	rubiesLabel.Name = "RubiesLabel"
	rubiesLabel.Size = UDim2.new(0.5, -4, 0.33, 0)
	rubiesLabel.Position = UDim2.new(0.5, 4, 0, 0)
	rubiesLabel.Text = "Rubies: 0"
	rubiesLabel.TextColor3 = UIConstants.Colors.Secondary
	rubiesLabel.BackgroundTransparency = 1
	rubiesLabel.Font = Enum.Font.GothamMedium
	rubiesLabel.TextSize = 18
	rubiesLabel.Parent = frame
	
	local ecoEvent = RemoteContracts.GetEconomyUpdatedEvent()
	ecoEvent.OnClientEvent:Connect(function(data)
		if type(data) == "table" then
			cashLabel.Text = "Cash: " .. tostring(data.Cash or 0)
			rubiesLabel.Text = "Rubies: " .. tostring(data.Rubies or 0)
		end
	end)
	
	screenGui.Parent = playerGui
end

return StatsFrame
