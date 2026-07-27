--!strict
return function()
	local EconomySystem = require(script.Parent.EconomySystem)

	describe("EconomySystem.Grant", function()
		it("should increase currency by exact amount", function()
			local mockProfile = { Data = { Stats = { Cash = 100 }, UserId = 1 } }
			EconomySystem.Grant(mockProfile, "Cash", 50, "TestReward")
			expect(mockProfile.Data.Stats.Cash).to.equal(150)
		end)

		it("should reject negative grant amount", function()
			local mockProfile = { Data = { Stats = { Cash = 100 }, UserId = 1 } }
			local ok = EconomySystem.Grant(mockProfile, "Cash", -50, "TestReward")
			expect(ok).to.equal(false)
			expect(mockProfile.Data.Stats.Cash).to.equal(100)
		end)

		it("should always require a reason string", function()
			local mockProfile = { Data = { Stats = { Cash = 100 }, UserId = 1 } }
			expect(function()
				EconomySystem.Grant(mockProfile, "Cash", 50, "")
			end).to.throw()
		end)
	end)

	describe("EconomySystem.Deduct", function()
		it("should decrease currency by exact amount", function()
			local mockProfile = { Data = { Stats = { Cash = 100 }, UserId = 1 } }
			EconomySystem.Deduct(mockProfile, "Cash", 50, "TestDeduct")
			expect(mockProfile.Data.Stats.Cash).to.equal(50)
		end)

		it("should reject if balance insufficient", function()
			local mockProfile = { Data = { Stats = { Cash = 100 }, UserId = 1 } }
			local ok = EconomySystem.Deduct(mockProfile, "Cash", 150, "TestDeduct")
			expect(ok).to.equal(false)
			expect(mockProfile.Data.Stats.Cash).to.equal(100)
		end)

		it("should reject negative deduct amount", function()
			local mockProfile = { Data = { Stats = { Cash = 100 }, UserId = 1 } }
			local ok = EconomySystem.Deduct(mockProfile, "Cash", -50, "TestDeduct")
			expect(ok).to.equal(false)
			expect(mockProfile.Data.Stats.Cash).to.equal(100)
		end)
	end)
end
