--!strict
type CatalogItem = {
	ItemId: string,
	Name: string,
	Category: string,
	PriceCash: number,
	PriceRubies: number
}

local ItemCatalog = {
	Items = {
		Shoe_SpeedCarbon01 = {
			ItemId = "Shoe_SpeedCarbon01",
			Name = "Garuda Sprint Carbon",
			Category = "Shoe",
			PriceCash = 5000,
			PriceRubies = 0,
		} :: CatalogItem,
		Consumable_ElectrolyteBoost = {
			ItemId = "Consumable_ElectrolyteBoost",
			Name = "Elektro Splash",
			Category = "Consumable",
			PriceCash = 250,
			PriceRubies = 0,
		} :: CatalogItem,
	}
}

return ItemCatalog
