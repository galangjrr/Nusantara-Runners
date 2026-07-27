--!strict
local Constants = require(game:GetService("ReplicatedStorage").Shared.Constants)
local RemoteContracts = require(game:GetService("ReplicatedStorage").Shared.RemoteContracts)
local Players = game:GetService("Players")

local PetSystem = {}

function PetSystem.CatchPet(profile: any, petId: string, timingScore: number): (boolean, string)
	local baseRate = Constants.PET_CATCH_RATES[petId]
	if not baseRate then return false, "Pet tidak valid." end
	
	-- Anti-cheat: TimingScore maximum 1.0 (100%)
	-- The bonus max is 20% flat (0.2) if timingScore is perfect (1.0).
	local score = math.clamp(timingScore, 0, 1)
	local bonus = score * 0.2
	
	local finalRate = baseRate + bonus
	local roll = math.random()
	
	if roll <= finalRate then
		table.insert(profile.Data.Inventory.Pets, petId)
		return true, "Berhasil menangkap " .. petId .. "!"
	else
		return false, "Gagal menangkap."
	end
end

function PetSystem.Init()
	local catchEvent = RemoteContracts.GetCatchPetEvent()
	catchEvent.OnServerEvent:Connect(function(player: Player, payload: unknown)
		if typeof(payload) ~= "table" then return end
		local petId = payload.PetId
		local timingScore = payload.TimingScore
		if typeof(petId) ~= "string" or typeof(timingScore) ~= "number" then return end
		
		local ProfileManager = require(script.Parent.Parent.Data.ProfileManager)
		local profile = ProfileManager.GetProfile(player)
		if not profile then return end
		
		local AnalyticsSystem = require(script.Parent.AnalyticsSystem)
		AnalyticsSystem.LogEvent(player, "Pet_CatchAttempted", { PetId = petId, TimingScore = timingScore })
		
		local success, msg = PetSystem.CatchPet(profile, petId, timingScore)
		if success then
			AnalyticsSystem.LogEvent(player, "Pet_CatchSucceeded", { PetId = petId })
		end
		
		catchEvent:FireClient(player, { Success = success, Message = msg, PetId = petId })
	end)
end

return PetSystem
