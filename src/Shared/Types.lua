--!strict
-- shared/Types.lua

export type PlayerProfile = {
	Stats: {
		Pace: number,
		StaminaMax: number,
		Cash: number,
		Rubies: number,
		Trophies: number
	},
	Equipment: {
		EquippedShoe: string,
		EquippedOutfit: string,
		EquippedPet: string?
	},
	Inventory: {
		Shoes: {string},
		Pets: {string},
		Consumables: {[string]: number}
	},
	Stravi: {
		KOMs: {string},
		KudosReceivedTotal: number,
		KudosGivenToday: number,
		KudosGivenResetAt: number
	},
	Coach: {
		Level: number,
		Efficiency: number,
		DailyQuestDone: boolean,
		DailyXPEarned: number,
		DailyResetAt: number
	},
	Meta: {
		CreatedAt: number,
		LastLoginAt: number
	}
}

return {}
