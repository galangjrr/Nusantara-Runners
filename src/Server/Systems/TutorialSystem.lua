--!strict
local RemoteContracts = require(game:GetService("ReplicatedStorage").Shared.RemoteContracts)
local ProfileManager = require(script.Parent.Parent.Data.ProfileManager)
local AnalyticsSystem = require(script.Parent.AnalyticsSystem)

local TutorialSystem = {}

function TutorialSystem.Init()
	local tutorialEvent = RemoteContracts.GetTutorialEvent()
	
	tutorialEvent.OnServerEvent:Connect(function(player: Player)
		local profile = ProfileManager.GetProfile(player)
		if profile then
			if not profile.Data.Meta.HasCompletedTutorial then
				profile.Data.Meta.HasCompletedTutorial = true
				AnalyticsSystem.LogEvent(player, "Tutorial_Completed", {})
				print(player.Name .. " has completed the tutorial.")
			end
		end
	end)
	
	game:GetService("Players").PlayerAdded:Connect(function(player)
		task.delay(1, function() -- Wait for profile to load
			local profile = ProfileManager.GetProfile(player)
			if profile and not profile.Data.Meta.HasCompletedTutorial then
				tutorialEvent:FireClient(player)
			end
		end)
	end)
end

return TutorialSystem
