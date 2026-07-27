--!strict
return function()
	local PetSystem = require(script.Parent.PetSystem)

	describe("PetSystem.CatchPet", function()
		it("should bound timingScore manipulation to prevent 100% cheat on rare pets", function()
			local profile = { Data = { Inventory = { Pets = {} } } }
			-- Use GarudaEmas (1% rate). Even with hacked timingScore 9999, math.clamp limits it to +20% flat.
			local totalSuccess = 0
			-- Run it 1000 times with hacked timingScore = 9999
			for i = 1, 1000 do
				local success = PetSystem.CatchPet(profile, "Pet_Rinjani_GarudaEmas", 9999)
				if success then totalSuccess += 1 end
			end
			-- It should not be close to 1000
			expect(totalSuccess < 300).to.equal(true)
		end)
	end)
end
