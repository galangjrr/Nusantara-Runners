--!strict
return function()
	local StaminaSystem = require(script.Parent.StaminaSystem)

	describe("StaminaSystem.CalculateDrainRate", function()
		it("should calculate correct drain for perfect cadence", function()
			local drain = StaminaSystem.CalculateDrainRate(0, 1.0)
			expect(drain).to.equal(5.0)
		end)

		it("should prevent divide by zero", function()
			local drain = StaminaSystem.CalculateDrainRate(0, 0)
			expect(drain).to.equal(50.0)
		end)

		it("should enforce minimum drain of 0.5", function()
			local drain = StaminaSystem.CalculateDrainRate(10, 1.0)
			expect(drain).to.equal(0.5)
		end)
	end)

	describe("StaminaSystem.CalculateRegenRate", function()
		it("should return base regen without cushion", function()
			local regen = StaminaSystem.CalculateRegenRate(0)
			expect(regen).to.equal(2.0)
		end)

		it("should include cushion bonus", function()
			local regen = StaminaSystem.CalculateRegenRate(10)
			expect(regen).to.equal(3.0)
		end)
	end)
end
