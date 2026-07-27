--!strict
local Players = game:GetService("Players")
local ProfileService = require(script.Parent.ProfileService)
local Types = require(game:GetService("ReplicatedStorage").Shared.Types)

local ProfileTemplate = {
	SchemaVersion = 1,
	UserId = 0,
	Stats = {
		Pace = 15.5,
		StaminaMax = 120.0,
		Cash = 2500,
		Rubies = 150,
		Trophies = 12
	},
	Equipment = {
		EquippedShoe = "Shoe_Default",
		EquippedOutfit = "Outfit_Default"
	},
	Inventory = {
		Shoes = {"Shoe_Default"},
		Pets = {},
		Consumables = {}
	},
	Stravi = {
		KOMs = {},
		KudosReceivedTotal = 0,
		KudosGivenToday = 0,
		KudosGivenResetAt = 0
	},
	Coach = {
		Level = 0,
		Efficiency = 1.0,
		DailyQuestDone = false,
		DailyXPEarned = 0,
		DailyResetAt = 0
	},
	Meta = {
		CreatedAt = 0,
		LastLoginAt = 0
	}
}

local GameProfileStore = ProfileService.GetProfileStore(
	"PlayerData_v1",
	ProfileTemplate
)

local ProfileManager = {}
ProfileManager.Profiles = {}

function ProfileManager.PlayerAdded(player: Player)
	local profile = GameProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile:ListenToRelease(function()
			ProfileManager.Profiles[player] = nil
			player:Kick("Profile diakses di server lain.")
		end)
		if player:IsDescendantOf(Players) then
			ProfileManager.Profiles[player] = profile
			profile.Data.UserId = player.UserId
			if profile.Data.Meta.CreatedAt == 0 then
				profile.Data.Meta.CreatedAt = os.time()
			end
			profile.Data.Meta.LastLoginAt = os.time()
		else
			profile:Release()
		end
	else
		player:Kick("Gagal load profil data.")
	end
end

function ProfileManager.PlayerRemoving(player: Player)
	local profile = ProfileManager.Profiles[player]
	if profile ~= nil then
		profile:Release()
	end
end

function ProfileManager.GetProfile(player: Player): any?
	return ProfileManager.Profiles[player]
end

function ProfileManager.Init()
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(ProfileManager.PlayerAdded, player)
	end
	Players.PlayerAdded:Connect(ProfileManager.PlayerAdded)
	Players.PlayerRemoving:Connect(ProfileManager.PlayerRemoving)
end

return ProfileManager
