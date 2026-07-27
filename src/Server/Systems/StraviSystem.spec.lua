--!strict
return function()
	local StraviSystem = require(script.Parent.StraviSystem)

	describe("StraviSystem.GiveKudos", function()
		it("should allow giving kudos and respect daily cap", function()
			local giver = { Data = { Stravi = { KudosGivenToday = 0, KudosGivenResetAt = os.time() + 86400 } } }
			local receiver = { Data = { Stravi = { KudosReceivedTotal = 0 } } }
			
			local success1 = StraviSystem.GiveKudos(giver, receiver)
			expect(success1).to.equal(true)
			expect(giver.Data.Stravi.KudosGivenToday).to.equal(1)
			expect(receiver.Data.Stravi.KudosReceivedTotal).to.equal(1)
			
			-- force cap
			giver.Data.Stravi.KudosGivenToday = 20
			local success2 = StraviSystem.GiveKudos(giver, receiver)
			expect(success2).to.equal(false)
			expect(giver.Data.Stravi.KudosGivenToday).to.equal(20)
		end)
		
		it("should reset cap after reset time", function()
			local giver = { Data = { Stravi = { KudosGivenToday = 20, KudosGivenResetAt = os.time() - 10 } } }
			local receiver = { Data = { Stravi = { KudosReceivedTotal = 0 } } }
			
			local success = StraviSystem.GiveKudos(giver, receiver)
			expect(success).to.equal(true)
			expect(giver.Data.Stravi.KudosGivenToday).to.equal(1)
			expect(giver.Data.Stravi.KudosGivenResetAt > os.time()).to.equal(true)
		end)
	end)
end
