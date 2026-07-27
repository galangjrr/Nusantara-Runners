--!strict
local Constants = require(game:GetService("ReplicatedStorage").Shared.Constants)

local CoachSystem = {}

function CoachSystem.GetEfficiencyMultiplier(profile: any): number
	return profile.Data.Coach.Efficiency or 1.0
end

function CoachSystem.AddXP(profile: any, amount: number): boolean
	local currentTime = os.time()
	
	-- Check reset
	if currentTime >= profile.Data.Coach.DailyResetAt then
		profile.Data.Coach.DailyXPEarned = 0
		profile.Data.Coach.DailyResetAt = currentTime + 86400
	end
	
	local cap = Constants.DAILY_XP_CAP or 500
	if profile.Data.Coach.DailyXPEarned >= cap then
		return false -- Cap reached
	end
	
	local xpToGain = amount
	if profile.Data.Coach.DailyXPEarned + amount > cap then
		xpToGain = cap - profile.Data.Coach.DailyXPEarned
	end
	
	profile.Data.Coach.DailyXPEarned += xpToGain
	return true
end

return CoachSystem
