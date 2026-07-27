--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteContracts = require(ReplicatedStorage.Shared.RemoteContracts)
local UIConstants = require(ReplicatedStorage.Shared.UIConstants)
local Constants = require(ReplicatedStorage.Shared.Constants)

local PetCatchFrame = {}

function PetCatchFrame.Init()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PetCatchUI"
	screenGui.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Name = "PetCatchFrame"
	frame.Size = UDim2.new(0, 300, 0, 200)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = UIConstants.Colors.BackgroundDark
	frame.Visible = false
	frame.Parent = screenGui
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 16)
	uiCorner.Parent = frame
	
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 40)
	header.Text = "TANGKAP PET"
	header.Font = Enum.Font.GothamBold
	header.TextSize = 24
	header.TextColor3 = UIConstants.Colors.TextPrimary
	header.BackgroundTransparency = 1
	header.Parent = frame
	
	local oddsLabel = Instance.new("TextLabel")
	oddsLabel.Name = "OddsLabel"
	oddsLabel.Size = UDim2.new(1, 0, 0, 40)
	oddsLabel.Position = UDim2.new(0, 0, 0, 50)
	oddsLabel.Text = "Base Catch Rate: 0%"
	oddsLabel.Font = Enum.Font.GothamMedium
	oddsLabel.TextSize = 18
	oddsLabel.TextColor3 = UIConstants.Colors.Gold
	oddsLabel.BackgroundTransparency = 1
	oddsLabel.Parent = frame
	
	local catchBtn = Instance.new("TextButton")
	catchBtn.Size = UDim2.new(0, 200, 0, 50)
	catchBtn.Position = UDim2.new(0.5, -100, 1, -70)
	catchBtn.Text = "LEMPAR LASSO"
	catchBtn.BackgroundColor3 = UIConstants.Colors.Primary
	catchBtn.TextColor3 = UIConstants.Colors.TextPrimary
	catchBtn.Parent = frame
	
	local uiCornerBtn = Instance.new("UICorner")
	uiCornerBtn.CornerRadius = UDim.new(0, 8)
	uiCornerBtn.Parent = catchBtn
	
	local catchEvent = RemoteContracts.GetCatchPetEvent()
	
	local currentPetId = ""
	local active = false
	
	function PetCatchFrame.Show(petId: string)
		currentPetId = petId
		local rate = Constants.PET_CATCH_RATES[petId] or 0
		oddsLabel.Text = "Peluang Tangkap: " .. tostring(rate * 100) .. "%"
		catchBtn.Text = "LEMPAR LASSO"
		catchBtn.BackgroundColor3 = UIConstants.Colors.Primary
		frame.Visible = true
		active = true
	end
	
	catchBtn.MouseButton1Click:Connect(function()
		if not active then return end
		active = false
		catchBtn.Text = "Menangkap..."
		catchBtn.BackgroundColor3 = UIConstants.Colors.TextSecondary
		
		-- Dummy minigame input timing
		local timingScore = 0.5 + (math.random() * 0.5)
		catchEvent:FireServer({ PetId = currentPetId, TimingScore = timingScore })
	end)
	
	catchEvent.OnClientEvent:Connect(function(response)
		if type(response) == "table" then
			if response.Success then
				catchBtn.Text = "TERTANGKAP!"
				catchBtn.BackgroundColor3 = UIConstants.Colors.Success
			else
				catchBtn.Text = "LEPAS!"
				catchBtn.BackgroundColor3 = UIConstants.Colors.Danger
			end
			task.delay(2, function()
				frame.Visible = false
			end)
		end
	end)
	
	screenGui.Parent = playerGui
end

return PetCatchFrame
