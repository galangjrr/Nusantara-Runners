--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RaceHUD = {}

function RaceHUD.Init()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "RaceUI"
	screenGui.ResetOnSpawn = false
	
	local tracker = Instance.new("TextLabel")
	tracker.Name = "CheckpointTracker"
	tracker.Size = UDim2.new(0, 200, 0, 50)
	tracker.Position = UDim2.new(0.5, -100, 0, 20)
	tracker.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	tracker.TextColor3 = Color3.fromRGB(255, 255, 255)
	tracker.Text = "Not in race"
	tracker.Parent = screenGui
	
	screenGui.Parent = playerGui
	
	local RemoteContracts = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RemoteContracts"))
	local syncEvent = RemoteContracts.GetRaceSyncEvent()
	
	syncEvent.OnClientEvent:Connect(function(action: string, data: any)
		if action == "Start" or action == "Update" then
			tracker.Text = string.format("Checkpoint: %d / %d", data.Current, data.Total)
		elseif action == "Finish" then
			tracker.Text = "RACE FINISHED!"
			task.delay(3, function()
				tracker.Text = "Not in race"
			end)
		end
	end)
end

return RaceHUD
