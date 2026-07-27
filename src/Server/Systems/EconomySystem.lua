--!strict
local Constants = require(game:GetService("ReplicatedStorage").Shared.Constants)
local RemoteContracts = require(game:GetService("ReplicatedStorage").Shared.RemoteContracts)
local Players = game:GetService("Players")

local EconomySystem = {}

local function SyncEconomy(profile: any)
	local player = Players:GetPlayerByUserId(profile.Data.UserId)
	if player then
		local remote = RemoteContracts.GetEconomyUpdatedEvent()
		remote:FireClient(player, {
			Cash = profile.Data.Stats.Cash,
			Rubies = profile.Data.Stats.Rubies,
			Trophies = profile.Data.Stats.Trophies
		})
	end
end

function EconomySystem.Grant(profile: any, currency: string, amount: number, reason: string): boolean
	if typeof(amount) ~= "number" or amount <= 0 then return false end
	if typeof(reason) ~= "string" or reason == "" then error("Reason wajib diisi") end
	if currency ~= "Cash" and currency ~= "Rubies" and currency ~= "Trophies" then return false end

	profile.Data.Stats[currency] += amount
	print(string.format("[Economy] %d %s granted to %d for: %s", amount, currency, profile.Data.UserId, reason))
	
	SyncEconomy(profile)
	return true
end

function EconomySystem.Deduct(profile: any, currency: string, amount: number, reason: string): boolean
	if typeof(amount) ~= "number" or amount <= 0 then return false end
	if typeof(reason) ~= "string" or reason == "" then error("Reason wajib diisi") end
	if currency ~= "Cash" and currency ~= "Rubies" and currency ~= "Trophies" then return false end

	if profile.Data.Stats[currency] < amount then return false end

	profile.Data.Stats[currency] -= amount
	print(string.format("[Economy] %d %s deducted from %d for: %s", amount, currency, profile.Data.UserId, reason))
	
	SyncEconomy(profile)
	return true
end

return EconomySystem
