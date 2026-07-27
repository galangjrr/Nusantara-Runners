--!strict
-- Minimal Mock of ProfileService to prevent server crash
local DataStoreService = game:GetService("DataStoreService")

local ProfileService = {}

local Profile = {}
Profile.__index = Profile

function Profile.new(data)
	local self = setmetatable({}, Profile)
	self.Data = data
	self._releaseListeners = {}
	return self
end

function Profile:AddUserId(userId)
end

function Profile:Reconcile()
end

function Profile:ListenToRelease(listener)
	table.insert(self._releaseListeners, listener)
end

function Profile:Release()
	for _, cb in ipairs(self._releaseListeners) do
		cb()
	end
end

local ProfileStore = {}
ProfileStore.__index = ProfileStore

function ProfileService.GetProfileStore(name, template)
	local self = setmetatable({}, ProfileStore)
	self.Template = template
	self.Name = name
	return self
end

function ProfileStore:LoadProfileAsync(profileKey)
	local data = {}
	for k, v in pairs(self.Template) do
		if type(v) == "table" then
			data[k] = {}
			for k2, v2 in pairs(v) do
				data[k][k2] = v2
			end
		else
			data[k] = v
		end
	end
	return Profile.new(data)
end

return ProfileService
