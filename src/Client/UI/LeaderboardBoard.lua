--!strict
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local UIConstants = require(game:GetService("ReplicatedStorage").Shared.UIConstants)
local RemoteContracts = require(game:GetService("ReplicatedStorage").Shared.RemoteContracts)

local LeaderboardBoard = {}

function LeaderboardBoard.CreateBoard(part: BasePart)
	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Name = "LeaderboardGui"
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surfaceGui.PixelsPerStud = 50
	
	local background = Instance.new("Frame")
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = UIConstants.Colors.BackgroundDark
	background.Parent = surfaceGui
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 80)
	title.BackgroundTransparency = 1
	title.Text = "🏆 ALL-TIME TROPHIES 🏆"
	title.TextColor3 = UIConstants.Colors.Gold
	title.Font = Enum.Font.GothamBold
	title.TextSize = 48
	title.Parent = background
	
	local listFrame = Instance.new("ScrollingFrame")
	listFrame.Size = UDim2.new(1, -40, 1, -100)
	listFrame.Position = UDim2.new(0, 20, 0, 90)
	listFrame.BackgroundTransparency = 1
	listFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	layout.Parent = listFrame
	listFrame.Parent = background
	
	surfaceGui.Parent = part
	
	task.spawn(function()
		local remoteFunc = RemoteContracts.GetLeaderboardDataFunction()
		while true do
			local success, data = pcall(function()
				return remoteFunc:InvokeServer()
			end)
			
			if success and data and data.AllTime then
				for _, child in ipairs(listFrame:GetChildren()) do
					if child:IsA("Frame") then child:Destroy() end
				end
				
				for i, entry in ipairs(data.AllTime) do
					local row = Instance.new("Frame")
					row.Size = UDim2.new(1, 0, 0, 50)
					row.BackgroundColor3 = UIConstants.Colors.BackgroundLight
					row.LayoutOrder = entry.Rank
					
					local corner = Instance.new("UICorner")
					corner.CornerRadius = UDim.new(0, 8)
					corner.Parent = row
					
					local rankLabel = Instance.new("TextLabel")
					rankLabel.Size = UDim2.new(0, 60, 1, 0)
					rankLabel.BackgroundTransparency = 1
					rankLabel.Text = "#" .. entry.Rank
					rankLabel.Font = Enum.Font.GothamBold
					rankLabel.TextSize = 24
					rankLabel.TextColor3 = UIConstants.Colors.TextPrimary
					rankLabel.Parent = row
					
					local nameLabel = Instance.new("TextLabel")
					nameLabel.Size = UDim2.new(1, -200, 1, 0)
					nameLabel.Position = UDim2.new(0, 70, 0, 0)
					nameLabel.BackgroundTransparency = 1
					nameLabel.Text = "Player_" .. entry.UserId
					nameLabel.Font = Enum.Font.SourceSansBold
					nameLabel.TextSize = 24
					nameLabel.TextXAlignment = Enum.TextXAlignment.Left
					nameLabel.TextColor3 = UIConstants.Colors.TextPrimary
					nameLabel.Parent = row
					
					local scoreLabel = Instance.new("TextLabel")
					scoreLabel.Size = UDim2.new(0, 100, 1, 0)
					scoreLabel.Position = UDim2.new(1, -110, 0, 0)
					scoreLabel.BackgroundTransparency = 1
					scoreLabel.Text = tostring(entry.Score) .. " 🏆"
					scoreLabel.Font = Enum.Font.GothamMedium
					scoreLabel.TextSize = 24
					scoreLabel.TextColor3 = UIConstants.Colors.Gold
					scoreLabel.TextXAlignment = Enum.TextXAlignment.Right
					scoreLabel.Parent = row
					
					row.Parent = listFrame
					
					-- Resolve username asynchronously
					task.spawn(function()
						local success, name = pcall(function()
							return Players:GetNameFromUserIdAsync(entry.UserId)
						end)
						if success then
							nameLabel.Text = name
						end
					end)
				end
			end
			
			task.wait(60) -- Refresh every 60 seconds
		end
	end)
end

function LeaderboardBoard.Init()
	for _, part in ipairs(CollectionService:GetTagged("LeaderboardBoard")) do
		if part:IsA("BasePart") then
			LeaderboardBoard.CreateBoard(part)
		end
	end
end

return LeaderboardBoard
