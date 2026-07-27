--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIConstants = require(game:GetService("ReplicatedStorage").Shared.UIConstants)
local UIStateController = require(script.Parent.Parent.Controllers.UIStateController)
local RemoteContracts = require(game:GetService("ReplicatedStorage").Shared.RemoteContracts)

local OnboardingOverlay = {}
local tutorialSteps = {
	"Cara berlari: Gunakan layar / tombol WASD. Kecepatanmu akan meningkat seiring stat Pace.",
	"Latihan Gym: Datangi treadmill di sebelah sana untuk melatih stat.",
	"Ikut Race: Cari garis start di peta untuk memulai lari marathon!"
}

function OnboardingOverlay.Create()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "OnboardingOverlay"
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 100 -- Always on top
	
	local background = Instance.new("Frame")
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = UIConstants.Colors.BackgroundDark
	background.BackgroundTransparency = 0.3
	background.Parent = screenGui
	
	local dialogBox = Instance.new("Frame")
	dialogBox.Size = UDim2.new(0, 400, 0, 150)
	dialogBox.AnchorPoint = Vector2.new(0.5, 0.5)
	dialogBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	dialogBox.BackgroundColor3 = UIConstants.Colors.BackgroundLight
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 20)
	corner.Parent = dialogBox
	dialogBox.Parent = background
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -40, 1, -60)
	textLabel.Position = UDim2.new(0, 20, 0, 10)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextSize = 20
	textLabel.TextColor3 = UIConstants.Colors.TextPrimary
	textLabel.TextWrapped = true
	textLabel.Text = tutorialSteps[1]
	textLabel.Parent = dialogBox
	
	local nextBtn = Instance.new("TextButton")
	nextBtn.Size = UDim2.new(0, 100, 0, 40)
	nextBtn.Position = UDim2.new(1, -110, 1, -50)
	nextBtn.BackgroundColor3 = UIConstants.Colors.Primary
	nextBtn.Text = "Lanjut"
	nextBtn.TextColor3 = Color3.new(1, 1, 1)
	nextBtn.Font = Enum.Font.GothamBold
	nextBtn.TextSize = 16
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = nextBtn
	nextBtn.Parent = dialogBox
	
	local skipBtn = Instance.new("TextButton")
	skipBtn.Size = UDim2.new(0, 100, 0, 40)
	skipBtn.Position = UDim2.new(0, 10, 1, -50)
	skipBtn.BackgroundColor3 = UIConstants.Colors.Secondary
	skipBtn.Text = "Lewati"
	skipBtn.TextColor3 = Color3.new(1, 1, 1)
	skipBtn.Font = Enum.Font.GothamBold
	skipBtn.TextSize = 16
	local skipCorner = btnCorner:Clone()
	skipCorner.Parent = skipBtn
	skipBtn.Parent = dialogBox
	
	local currentStep = 1
	
	local function closeTutorial()
		screenGui:Destroy()
		UIStateController.SetState("None")
		local tutorialEvent = RemoteContracts.GetTutorialEvent()
		tutorialEvent:FireServer()
	end
	
	nextBtn.MouseButton1Click:Connect(function()
		currentStep += 1
		if currentStep > #tutorialSteps then
			closeTutorial()
		else
			textLabel.Text = tutorialSteps[currentStep]
		end
	end)
	
	skipBtn.MouseButton1Click:Connect(closeTutorial)
	
	UIStateController.Subscribe(function(state)
		screenGui.Enabled = (state == "Onboarding")
	end)
	
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	screenGui.Parent = playerGui
end

return OnboardingOverlay
