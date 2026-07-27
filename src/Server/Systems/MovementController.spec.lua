--!strict
return function()
	local MovementController = require(script.Parent.MovementController)

	describe("MovementController.CalculateWalkSpeed", function()
		it("should calculate correctly with 1.0 multipliers", function()
			local speed = MovementController.CalculateWalkSpeed(0, 1.0, 1.0, 1.0)
			expect(speed).to.equal(16)
		end)

		it("should clamp speed before multipliers", function()
			-- Pace = 1000 => 16 + 250 = 266, should clamp to 60. 60 * 2.0 = 120
			local speed = MovementController.CalculateWalkSpeed(1000, 2.0, 1.0, 1.0)
			expect(speed).to.equal(120)
		end)

		it("should apply multiple multipliers", function()
			-- Pace = 4 => 16 + 1 = 17. 17 * 1.5 * 2.0 = 51
			local speed = MovementController.CalculateWalkSpeed(4, 1.5, 1.0, 2.0)
			expect(speed).to.equal(51)
		end)
	end)
end
