--!strict
local AnalyticsService = game:GetService("AnalyticsService")

local AnalyticsSystem = {}

function AnalyticsSystem.LogEvent(player: Player, eventName: string, customData: any?)
	if not player then return end
	
	local data = customData or {}
	data.UserId = player.UserId
	data.Timestamp = os.time()
	
	pcall(function()
		AnalyticsService:LogCustomEvent(
			player,
			eventName,
			data
		)
		print(string.format("[Analytics] Logged: %s for %s", eventName, player.Name))
	end)
end

function AnalyticsSystem.Init()
	print("[AnalyticsSystem] Initialized.")
end

return AnalyticsSystem
