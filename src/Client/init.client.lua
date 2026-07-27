--!strict
print("Client initialized")
local CadenceBarGui = require(script.UI.CadenceBarGui)
CadenceBarGui.Init()
local RaceHUD = require(script.UI.RaceHUD)
RaceHUD.Init()
local StraviWidget = require(script.UI.StraviWidget)
StraviWidget.Init()
local CoachWidget = require(script.UI.CoachWidget)
CoachWidget.Init()
local StatsFrame = require(script.UI.StatsFrame)
StatsFrame.Init()
local ShopFrame = require(script.UI.ShopFrame)
ShopFrame.Init()
local PetCatchFrame = require(script.UI.PetCatchFrame)
PetCatchFrame.Init()

local CollectionService = game:GetService("CollectionService")
for _, zone in ipairs(CollectionService:GetTagged("PetSpawnZone")) do
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Cari Pet"
	prompt.ObjectText = zone.Name
	prompt.Parent = zone
	prompt.Triggered:Connect(function()
		local petId = "Pet_Bromo_MonyetEmas"
		if zone.Name == "PetSpawnZone_RinjaniSummit" then
			petId = "Pet_Rinjani_GarudaEmas"
		end
		PetCatchFrame.Show(petId)
	end)
end
