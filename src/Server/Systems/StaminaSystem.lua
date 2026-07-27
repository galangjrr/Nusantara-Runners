--!strict
local Constants = require(game:GetService("ReplicatedStorage").Shared.Constants)

local StaminaSystem = {}

function StaminaSystem.CalculateDrainRate(cushionSaver: number, cadenceQuality: number): number
	local baseDrain = Constants.BASE_STAMINA_DRAIN or 5.0
	
	local safeCadence = math.max(0.1, cadenceQuality)
	local drain = (baseDrain - cushionSaver) / safeCadence
	
	return math.max(0.5, drain)
end

function StaminaSystem.CalculateRegenRate(cushionSaver: number): number
	local baseRegen = Constants.BASE_STAMINA_REGEN or 2.0
	-- Regen is base + a small bonus from cushionSaver if any
	return baseRegen + (cushionSaver * 0.1)
end

return StaminaSystem
