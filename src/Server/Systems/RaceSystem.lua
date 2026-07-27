--!strict
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local RemoteContracts = require(game:GetService("ReplicatedStorage").Shared.RemoteContracts)
local EconomySystem = require(script.Parent.EconomySystem)
local ProfileManager = require(script.Parent.Parent.Data.ProfileManager)
local AnalyticsSystem = require(script.Parent.AnalyticsSystem)
local Constants = require(game:GetService("ReplicatedStorage").Shared.Constants)

local RaceSystem = {}
RaceSystem.ActiveRacers = {}
RaceSystem.ValidationRadius = Constants.RACE_VALIDATION_RADIUS or 15.0

function RaceSystem.CheckDistance(posA: Vector3, posB: Vector3): boolean
	return (posA - posB).Magnitude <= RaceSystem.ValidationRadius
end

function RaceSystem.StartRace(player: Player, raceId: string)
	local allCheckpoints = CollectionService:GetTagged("RaceCheckpoint")
	
	table.sort(allCheckpoints, function(a, b)
		local numA = tonumber(a.Name:match("%d+")) or 0
		local numB = tonumber(b.Name:match("%d+")) or 0
		return numA < numB
	end)
	
	if #allCheckpoints == 0 then return false end
	
	RaceSystem.ActiveRacers[player] = {
		CheckpointIndex = 1,
		Checkpoints = allCheckpoints,
		RaceId = raceId,
		StartTime = os.clock()
	}
	
	AnalyticsSystem.LogEvent(player, "Race_Started", { RaceId = raceId })
	
	local remote = RemoteContracts.GetRaceSyncEvent()
	remote:FireClient(player, "Start", {
		Current = 1,
		Total = #allCheckpoints
	})
	
	return true
end

function RaceSystem.UpdateRaces()
	for player, state in pairs(RaceSystem.ActiveRacers) do
		if not player.Parent or not player.Character then
			AnalyticsSystem.LogEvent(player, "Race_Abandoned", { RaceId = state.RaceId })
			RaceSystem.ActiveRacers[player] = nil
			continue
		end
		
		local hrp = player.Character:FindFirstChild("HumanoidRootPart") :: BasePart
		if not hrp then continue end
		
		local targetCheckpoint = state.Checkpoints[state.CheckpointIndex]
		if not targetCheckpoint then continue end
		
		if RaceSystem.CheckDistance(hrp.Position, targetCheckpoint.Position) then
			state.CheckpointIndex += 1
			
			local remote = RemoteContracts.GetRaceSyncEvent()
			if state.CheckpointIndex > #state.Checkpoints then
				local raceDuration = os.clock() - state.StartTime
				AnalyticsSystem.LogEvent(player, "Race_Finished", { RaceId = state.RaceId, DurationSeconds = raceDuration })
				
				RaceSystem.ActiveRacers[player] = nil
				local profile = ProfileManager.GetProfile(player)
				if profile then
					EconomySystem.Grant(profile, "Cash", 100, "Race Finish 5K")
					EconomySystem.Grant(profile, "Trophies", 1, "Race Finish 5K")
				end
				remote:FireClient(player, "Finish", {})
			else
				remote:FireClient(player, "Update", {
					Current = state.CheckpointIndex,
					Total = #state.Checkpoints
				})
			end
		end
	end
end

return RaceSystem
