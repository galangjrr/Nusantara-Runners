--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local LeaderboardSystem = {}
local AllTimeTrophiesDS = DataStoreService:GetOrderedDataStore("AllTimeTrophies_v1")
local WeeklyTrophiesDS = DataStoreService:GetOrderedDataStore("WeeklyTrophies_v1")
local MetaDS = DataStoreService:GetDataStore("LeaderboardMeta_v1")

local CACHE_UPDATE_INTERVAL = 60
local lastUpdate = 0
local cachedAllTime = {}
local cachedWeekly = {}

local function getStartOfWeek(): number
	local now = os.time()
	local date = os.date("!*t", now)
	-- Monday is considered the start of the week. os.date wday: 1=Sun, 2=Mon...
	local daysSinceMonday = (date.wday - 2) % 7
	local startOfDay = os.time({year = date.year, month = date.month, day = date.day, hour = 0, min = 0, sec = 0})
	return startOfDay - (daysSinceMonday * 86400)
end

function LeaderboardSystem.UpdatePlayerScore(userId: number, trophies: number)
	pcall(function()
		AllTimeTrophiesDS:SetAsync(tostring(userId), trophies)
		WeeklyTrophiesDS:SetAsync(tostring(userId), trophies)
	end)
end

function LeaderboardSystem.CheckWeeklyReset()
	local currentWeek = getStartOfWeek()
	local success, lastReset = pcall(function()
		return MetaDS:GetAsync("LastWeeklyReset")
	end)
	
	if success and (not lastReset or lastReset < currentWeek) then
		print("[Leaderboard] Executing Weekly Reset!")
		-- In a real production environment, you would iterate and reset the WeeklyTrophiesDS.
		-- Due to OrderedDataStore limits, typically we append the week timestamp to the datastore name.
		WeeklyTrophiesDS = DataStoreService:GetOrderedDataStore("WeeklyTrophies_v1_" .. currentWeek)
		pcall(function()
			MetaDS:SetAsync("LastWeeklyReset", currentWeek)
		end)
		
		-- TODO: Grant Rank 1 Rewards based on the previous week's DS if needed.
	end
end

function LeaderboardSystem.RefreshCache()
	local now = os.clock()
	if now - lastUpdate < CACHE_UPDATE_INTERVAL then return end
	lastUpdate = now
	
	pcall(function()
		local allTimePages = AllTimeTrophiesDS:GetSortedAsync(false, 50)
		local weeklyPages = WeeklyTrophiesDS:GetSortedAsync(false, 50)
		
		local newAllTime = {}
		for rank, data in ipairs(allTimePages:GetCurrentPage()) do
			table.insert(newAllTime, {UserId = tonumber(data.key), Score = data.value, Rank = rank})
		end
		
		local newWeekly = {}
		for rank, data in ipairs(weeklyPages:GetCurrentPage()) do
			table.insert(newWeekly, {UserId = tonumber(data.key), Score = data.value, Rank = rank})
		end
		
		cachedAllTime = newAllTime
		cachedWeekly = newWeekly
	end)
end

function LeaderboardSystem.Init()
	LeaderboardSystem.CheckWeeklyReset()
	
	local remoteFunc = require(game:GetService("ReplicatedStorage").Shared.RemoteContracts).GetLeaderboardDataFunction()
	remoteFunc.OnServerInvoke = function(player)
		return {
			AllTime = cachedAllTime,
			Weekly = cachedWeekly
		}
	end
	
	task.spawn(function()
		while true do
			LeaderboardSystem.RefreshCache()
			task.wait(CACHE_UPDATE_INTERVAL)
		end
	end)
end

return LeaderboardSystem
