--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemCatalog = require(ReplicatedStorage.Shared.ItemCatalog)
local RemoteContracts = require(ReplicatedStorage.Shared.RemoteContracts)
local UIConstants = require(ReplicatedStorage.Shared.UIConstants)
local UIStateController = require(script.Parent.Parent.Controllers.UIStateController)

local ShopFrame = {}

function ShopFrame.Init()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Menus"
	screenGui.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Name = "ShopFrame"
	frame.Size = UDim2.new(0.5, 0, 0.7, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = UIConstants.Colors.BackgroundDark
	frame.Visible = false
	frame.Parent = screenGui
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 20)
	uiCorner.Parent = frame
	
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 50)
	header.Text = "TOKO GEAR"
	header.Font = Enum.Font.GothamBold
	header.TextSize = 28
	header.TextColor3 = UIConstants.Colors.TextPrimary
	header.BackgroundTransparency = 1
	header.Parent = frame
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 40, 0, 40)
	closeBtn.Position = UDim2.new(1, -50, 0, 5)
	closeBtn.Text = "X"
	closeBtn.BackgroundColor3 = UIConstants.Colors.Danger
	closeBtn.TextColor3 = UIConstants.Colors.TextPrimary
	closeBtn.Parent = frame
	
	local uiCornerClose = Instance.new("UICorner")
	uiCornerClose.CornerRadius = UDim.new(0, 8)
	uiCornerClose.Parent = closeBtn
	
	closeBtn.MouseButton1Click:Connect(function()
		UIStateController.SetState("None")
	end)
	
	UIStateController.Subscribe(function(state)
		frame.Visible = (state == "Shop")
	end)
	
	local buyBtn = Instance.new("TextButton")
	buyBtn.Size = UDim2.new(0, 200, 0, 50)
	buyBtn.Position = UDim2.new(0.5, -100, 0.5, -25)
	buyBtn.Text = "Beli " .. ItemCatalog.Items["Shoe_SpeedCarbon01"].Name
	buyBtn.BackgroundColor3 = UIConstants.Colors.Primary
	buyBtn.TextColor3 = UIConstants.Colors.TextPrimary
	buyBtn.Parent = frame
	
	local uiCornerBuy = Instance.new("UICorner")
	uiCornerBuy.CornerRadius = UDim.new(0, 12)
	uiCornerBuy.Parent = buyBtn
	
	local buyEvent = RemoteContracts.GetBuyGearEvent()
	local buying = false
	
	buyBtn.MouseButton1Click:Connect(function()
		if buying then return end
		buying = true
		buyBtn.Text = "Loading..."
		buyBtn.BackgroundColor3 = UIConstants.Colors.TextSecondary
		
		buyEvent:FireServer({ ItemId = "Shoe_SpeedCarbon01" })
	end)
	
	buyEvent.OnClientEvent:Connect(function(response)
		if type(response) == "table" and response.ItemId == "Shoe_SpeedCarbon01" then
			buying = false
			if response.Success then
				buyBtn.Text = "Dimiliki"
				buyBtn.BackgroundColor3 = UIConstants.Colors.Success
			else
				buyBtn.Text = response.Message or "Gagal"
				buyBtn.BackgroundColor3 = UIConstants.Colors.Danger
				task.delay(2, function()
					buyBtn.Text = "Beli " .. ItemCatalog.Items["Shoe_SpeedCarbon01"].Name
					buyBtn.BackgroundColor3 = UIConstants.Colors.Primary
				end)
			end
		end
	end)
	
	screenGui.Parent = playerGui
end

return ShopFrame
