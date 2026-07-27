--!strict
-- shared/Constants.lua
-- Kategori: Movement, Economy, Stamina, Coach, Stravi, Pet

return {
	-- Movement
	BASE_WALK_SPEED = 16,
	PACE_STAT_MULTIPLIER = 0.25,
	WALK_SPEED_HARD_CAP = 60,

	-- Stamina
	BASE_STAMINA_DRAIN = 5.0,
	BASE_STAMINA_REGEN = 2.0,

	-- Economy
	MAX_CASH = 1000000,

	-- Coach
	DAILY_XP_CAP = 500,

	-- Race
	RACE_VALIDATION_RADIUS = 15.0,

	-- Stravi
	MAX_KUDOS_PER_DAY = 20,
	
	-- Pet Hunting
	PET_CATCH_RATES = {
		Pet_Bromo_MonyetEmas = 0.75,
		Pet_GedePangrango_ElangJawa = 0.40,
		Pet_Toba_HarimauSumatra = 0.15,
		Pet_LabuanBajo_Komodo = 0.05,
		Pet_Rinjani_GarudaEmas = 0.01,
	},

	-- Pet
}
