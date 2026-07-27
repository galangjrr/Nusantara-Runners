--!strict
return function()
	local CoachSystem = require(script.Parent.CoachSystem)

	describe("CoachSystem.AddXP", function()
		it("should cap at DAILY_XP_CAP", function()
			local profile = { Data = { Coach = { DailyXPEarned = 450, DailyResetAt = os.time() + 86400 } } }
			
			local success = CoachSystem.AddXP(profile, 100)
			expect(success).to.equal(true)
			expect(profile.Data.Coach.DailyXPEarned).to.equal(500)
			
			local success2 = CoachSystem.AddXP(profile, 10)
			expect(success2).to.equal(false)
			expect(profile.Data.Coach.DailyXPEarned).to.equal(500)
		end)
		
		it("should reset after time passed", function()
			local profile = { Data = { Coach = { DailyXPEarned = 500, DailyResetAt = os.time() - 10 } } }
			
			local success = CoachSystem.AddXP(profile, 50)
			expect(success).to.equal(true)
			expect(profile.Data.Coach.DailyXPEarned).to.equal(50)
		end)
	end)
end
