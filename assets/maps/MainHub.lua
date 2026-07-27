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

	local ServerStorage = game:GetService("ServerStorage")
	local InsertService = game:GetService("InsertService")
	
	local mapAssets = ServerStorage:FindFirstChild("MapAssets")
	if not mapAssets then
		mapAssets = Instance.new("Folder")
		mapAssets.Name = "MapAssets"
		mapAssets.Parent = ServerStorage
		
		-- Load assets dynamically
		pcall(function()
			local t = InsertService:LoadAsset(12549617200)
			local tree = t:GetChildren()[1]
			tree.Name = "Tree"
			tree.Parent = mapAssets
			
			local b = InsertService:LoadAsset(741384218)
			local bench = b:GetChildren()[1]
			bench.Name = "Bench"
			for _, desc in ipairs(bench:GetDescendants()) do
				if desc:IsA("LuaSourceContainer") then desc:Destroy() end
			end
			bench.Parent = mapAssets
			
			local tm = InsertService:LoadAsset(85421632611734)
			local treadmill = tm:GetChildren()[1]
			treadmill.Name = "Treadmill"
			for _, desc in ipairs(treadmill:GetDescendants()) do
				if desc:IsA("LuaSourceContainer") then desc:Destroy() end
			end
			treadmill.Parent = mapAssets
		end)
	end
	
	
	-- Gym Area (Treadmills)
	for i = 1, 3 do
		local treadmill
		if mapAssets and mapAssets:FindFirstChild("Treadmill") then
			treadmill = mapAssets.Treadmill:Clone()
			treadmill:PivotTo(CFrame.new(-20 + (i * 10), 0, 20))
		else
			treadmill = Instance.new("Part")
			treadmill.Size = Vector3.new(4, 2, 8)
			treadmill.Position = Vector3.new(-20 + (i * 10), 1, 20)
			treadmill.BrickColor = BrickColor.new("Really black")
		end
		treadmill.Name = "Treadmill_" .. i
		if treadmill:IsA("BasePart") then treadmill.Anchored = true end
		treadmill.Parent = mapFolder
		CollectionService:AddTag(treadmill, "Treadmill")
	end
	
	-- Decoration (Trees & Benches)
	if mapAssets then
		local treeRef = mapAssets:FindFirstChild("Tree")
		if treeRef then
			for i = 1, 5 do
				local t = treeRef:Clone()
				t:PivotTo(CFrame.new(-40 + (i*15), 0, -30))
				t.Parent = mapFolder
			end
		end
		
		local benchRef = mapAssets:FindFirstChild("Bench")
		if benchRef then
			for i = 1, 3 do
				local b = benchRef:Clone()
				b:PivotTo(CFrame.new(20, 0, -20 + (i*10)))
				b.Parent = mapFolder
			end
		end
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
	
	print("[MapBuilder] MainHub GBK Senayan generated with 3D Assets.")
end

return MainHub
