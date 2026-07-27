--!strict
return function()
	local ShopSystem = require(script.Parent.ShopSystem)

	describe("ShopSystem.BuyItem", function()
		it("should reject if cash insufficient", function()
			local profile = {
				Data = {
					UserId = 1,
					Stats = { Cash = 100, Rubies = 0, Trophies = 0 },
					Inventory = { Shoes = {}, Consumables = {} }
				}
			}
			local success, msg = ShopSystem.BuyItem(profile, "Shoe_SpeedCarbon01")
			expect(success).to.equal(false)
			expect(profile.Data.Stats.Cash).to.equal(100)
		end)
		
		it("should deduct cash and grant item if successful", function()
			local profile = {
				Data = {
					UserId = 1,
					Stats = { Cash = 6000, Rubies = 0, Trophies = 0 },
					Inventory = { Shoes = {}, Consumables = {} }
				}
			}
			local success, msg = ShopSystem.BuyItem(profile, "Shoe_SpeedCarbon01")
			expect(success).to.equal(true)
			expect(profile.Data.Stats.Cash).to.equal(1000)
			expect(profile.Data.Inventory.Shoes[1]).to.equal("Shoe_SpeedCarbon01")
		end)
	end)
end
