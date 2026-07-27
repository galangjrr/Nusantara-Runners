--!strict
return function()
	local RaceSystem = require(script.Parent.RaceSystem)

	describe("RaceSystem.CheckDistance", function()
		it("should return true if within 15 studs", function()
			local ok = RaceSystem.CheckDistance(Vector3.new(0,0,0), Vector3.new(10,0,0))
			expect(ok).to.equal(true)
		end)

		it("should return false if further than 15 studs", function()
			local ok = RaceSystem.CheckDistance(Vector3.new(0,0,0), Vector3.new(20,0,0))
			expect(ok).to.equal(false)
		end)
	end)
end
