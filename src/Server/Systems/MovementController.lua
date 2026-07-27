--!strict
local Constants = require(game:GetService("ReplicatedStorage").Shared.Constants)

local MovementController = {}

function MovementController.CalculateWalkSpeed(paceStat: number, shoeMultiplier: number, crownMultiplier: number, petMultiplier: number): number
	local baseSpeed = Constants.BASE_WALK_SPEED or 16
	local paceMult = Constants.PACE_STAT_MULTIPLIER or 0.25
	local cap = Constants.WALK_SPEED_HARD_CAP or 60
	
	local preMultiplierSpeed = baseSpeed + (paceStat * paceMult)
	local clampedSpeed = math.clamp(preMultiplierSpeed, baseSpeed, cap)
	
	local finalSpeed = clampedSpeed * shoeMultiplier * crownMultiplier * petMultiplier
	return finalSpeed
end

function MovementController.ApplyToPlayer(player: Player, profile: any)
	if not player.Character then return end
	local humanoid = player.Character:FindFirstChild("Humanoid") :: Humanoid
	if not humanoid then return end
	
	local paceStat = profile.Data.Stats.Pace or 0
	local shoeMultiplier = 1.0 
	local crownMultiplier = 1.0
	local petMultiplier = 1.0
	
	local finalSpeed = MovementController.CalculateWalkSpeed(paceStat, shoeMultiplier, crownMultiplier, petMultiplier)
	humanoid.WalkSpeed = finalSpeed
end

return MovementController
