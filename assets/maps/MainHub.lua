--!strict
local CollectionService = game:GetService("CollectionService")

local MainHub = {}

function MainHub.Build()
	local mapFolder = Instance.new("Folder")
	mapFolder.Name = "MainHub"
	mapFolder.Parent = workspace

	-- Baseplate
	local baseplate = Instance.new("Part")
	baseplate.Name = "Baseplate"
	baseplate.Size = Vector3.new(200, 10, 200)
	baseplate.Position = Vector3.new(0, -5, 0)
	baseplate.Anchored = true
	baseplate.BrickColor = BrickColor.new("Dark stone grey")
	baseplate.Parent = mapFolder

	-- SpawnLocation
	local spawnLoc = Instance.new("SpawnLocation")
	spawnLoc.Name = "SpawnLocation"
	spawnLoc.Size = Vector3.new(12, 1, 12)
	spawnLoc.Position = Vector3.new(0, 0.5, 0)
	spawnLoc.Anchored = true
	spawnLoc.BrickColor = BrickColor.new("Bright yellow")
	spawnLoc.Parent = mapFolder

	-- Gym Area (Treadmills)
	for i = 1, 3 do
		local treadmill = Instance.new("Part")
		treadmill.Name = "Treadmill_" .. i
		treadmill.Size = Vector3.new(4, 2, 8)
		treadmill.Position = Vector3.new(-20 + (i * 10), 1, 20)
		treadmill.Anchored = true
		treadmill.BrickColor = BrickColor.new("Really black")
		treadmill.Parent = mapFolder
		CollectionService:AddTag(treadmill, "Treadmill")
	end

	-- Shop Area
	local shopVendor = Instance.new("Part")
	shopVendor.Name = "ShopVendorBooth"
	shopVendor.Size = Vector3.new(10, 5, 10)
	shopVendor.Position = Vector3.new(30, 2.5, 0)
	shopVendor.Anchored = true
	shopVendor.BrickColor = BrickColor.new("Bright blue")
	shopVendor.Parent = mapFolder
	CollectionService:AddTag(shopVendor, "ShopVendor")

	-- Gacha Area
	local gachaBooth = Instance.new("Part")
	gachaBooth.Name = "GachaBooth"
	gachaBooth.Size = Vector3.new(8, 6, 8)
	gachaBooth.Position = Vector3.new(30, 3, -20)
	gachaBooth.Anchored = true
	gachaBooth.BrickColor = BrickColor.new("Bright red")
	gachaBooth.Parent = mapFolder

	-- Travel Terminal
	local travelTerminal = Instance.new("Part")
	travelTerminal.Name = "TravelTerminal"
	travelTerminal.Size = Vector3.new(6, 8, 6)
	travelTerminal.Position = Vector3.new(0, 4, -40)
	travelTerminal.Anchored = true
	travelTerminal.BrickColor = BrickColor.new("Neon orange")
	travelTerminal.Parent = mapFolder
	
	print("[MapBuilder] MainHub GBK Senayan blockout generated.")
end

return MainHub
