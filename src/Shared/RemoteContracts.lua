--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteContracts = {}

function RemoteContracts.GetEconomyUpdatedEvent(): RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("EconomyUpdated")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "EconomyUpdated"
		event.Parent = ReplicatedStorage
	end
	return event :: RemoteEvent
end

function RemoteContracts.GetRaceSyncEvent(): RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("RaceSyncEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "RaceSyncEvent"
		event.Parent = ReplicatedStorage
	end
	return event :: RemoteEvent
end

function RemoteContracts.GetStraviSyncEvent(): RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("StraviSyncEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "StraviSyncEvent"
		event.Parent = ReplicatedStorage
	end
	return event :: RemoteEvent
end

function RemoteContracts.GetCoachSyncEvent(): RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("CoachSyncEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "CoachSyncEvent"
		event.Parent = ReplicatedStorage
	end
	return event :: RemoteEvent
end

function RemoteContracts.GetBuyGearEvent(): RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("BuyGearEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "BuyGearEvent"
		event.Parent = ReplicatedStorage
	end
	return event :: RemoteEvent
end

function RemoteContracts.GetEconomyUpdatedEvent(): RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("EconomyUpdated")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "EconomyUpdated"
		event.Parent = ReplicatedStorage
	end
	return event :: RemoteEvent
end

function RemoteContracts.GetCatchPetEvent(): RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("CatchPetEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "CatchPetEvent"
		event.Parent = ReplicatedStorage
	end
	return event :: RemoteEvent
end

function RemoteContracts.GetTutorialEvent(): RemoteEvent
	local event = ReplicatedStorage:FindFirstChild("TutorialEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "TutorialEvent"
		event.Parent = ReplicatedStorage
	end
	return event :: RemoteEvent
end

function RemoteContracts.GetLeaderboardDataFunction(): RemoteFunction
	local func = ReplicatedStorage:FindFirstChild("GetLeaderboardData")
	if not func then
		func = Instance.new("RemoteFunction")
		func.Name = "GetLeaderboardData"
		func.Parent = ReplicatedStorage
	end
	return func :: RemoteFunction
end

return RemoteContracts
