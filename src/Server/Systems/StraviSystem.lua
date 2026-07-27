--!strict
local Constants = require(game:GetService("ReplicatedStorage").Shared.Constants)
local RemoteContracts = require(game:GetService("ReplicatedStorage").Shared.RemoteContracts)
local Players = game:GetService("Players")

local StraviSystem = {}

-- Scoped KOM per server session
-- { [SegmentId] = { PlayerId = number, Time = number } }
StraviSystem.KOMHolders = {}

function StraviSystem.RecordSegmentTime(player: Player, segmentId: string, timeInSeconds: number): boolean
	local currentKOM = StraviSystem.KOMHolders[segmentId]
	if not currentKOM or timeInSeconds < currentKOM.Time then
		StraviSystem.KOMHolders[segmentId] = {
			PlayerId = player.UserId,
			Time = timeInSeconds
		}
		-- Update Crown Buff
		local MovementController = require(script.Parent.MovementController)
		MovementController.ApplyCrownBuff(player, true)
		
		local AnalyticsSystem = require(script.Parent.AnalyticsSystem)
		AnalyticsSystem.LogEvent(player, "Stravi_KOMClaimed", { SegmentId = segmentId, TimeSeconds = timeInSeconds })
		
		print(string.format("[Stravi] %s takes KOM for %s with %.2fs", player.Name, segmentId, timeInSeconds))
		return true
	end
	return false
end

function StraviSystem.GiveKudos(giverProfile: any, receiverProfile: any): boolean
	local currentTime = os.time()
	
	-- Check reset
	if currentTime >= giverProfile.Data.Stravi.KudosGivenResetAt then
		giverProfile.Data.Stravi.KudosGivenToday = 0
		giverProfile.Data.Stravi.KudosGivenResetAt = currentTime + 86400
	end
	
	local maxKudos = Constants.MAX_KUDOS_PER_DAY or 20
	if giverProfile.Data.Stravi.KudosGivenToday >= maxKudos then
		return false -- Limit reached
	end
	
	giverProfile.Data.Stravi.KudosGivenToday += 1
	receiverProfile.Data.Stravi.KudosReceivedTotal += 1
	return true
end

-- Secure Remote Event Listener
local straviEvent = RemoteContracts.GetStraviSyncEvent()
straviEvent.OnServerEvent:Connect(function(player: Player, payload: unknown)
	if typeof(payload) ~= "table" then return end
	
	if payload.Action == "GiveKudos" then
		local targetUserId = payload.TargetUserId
		if typeof(targetUserId) ~= "number" then return end
		
		local targetPlayer = Players:GetPlayerByUserId(targetUserId)
		if not targetPlayer then return end
		
		-- Deferred require to avoid circular dependency if needed, or normal require
		local ProfileManager = require(script.Parent.Parent.Data.ProfileManager)
		local giverProfile = ProfileManager.GetProfile(player)
		local receiverProfile = ProfileManager.GetProfile(targetPlayer)
		
		if giverProfile and receiverProfile then
			local success = StraviSystem.GiveKudos(giverProfile, receiverProfile)
			if success then
				straviEvent:FireClient(player, "KudosSuccess")
			end
		end
	end
end)

return StraviSystem
