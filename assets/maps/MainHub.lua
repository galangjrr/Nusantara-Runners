--!strict
local CollectionService = game:GetService("CollectionService")

local MainHub = {}

function MainHub.Build()
	local mapFolder = Instance.new("Folder")
	mapFolder.Name = "MainHub"
	mapFolder.Parent = workspace

	-- Terrain Generation
	local Terrain = workspace.Terrain
	Terrain:Clear() -- Clear old terrain if any
	
	-- Massive Grass Field
	Terrain:FillBlock(
		CFrame.new(0, -5, 0),
		Vector3.new(1000, 10, 1000),
		Enum.Material.Grass
	)
	
	-- Concrete Plaza at Center
	Terrain:FillBlock(
		CFrame.new(0, -4, 0),
		Vector3.new(200, 12, 200),
		Enum.Material.Concrete
	)

	-- Stadium Oval (Siluet GBK)
	local stadium = Instance.new("Part")
	stadium.Name = "StadiumOval"
	stadium.Shape = Enum.PartType.Cylinder
	stadium.Size = Vector3.new(60, 300, 220)
	stadium.Position = Vector3.new(0, 30, -150)
	stadium.Orientation = Vector3.new(0, 0, 90)
	stadium.Anchored = true
	stadium.BrickColor = BrickColor.new("Institutional white")
	stadium.Material = Enum.Material.Concrete
	stadium.Parent = mapFolder

	-- SpawnLocation
	local spawnLoc = Instance.new("SpawnLocation")
	spawnLoc.Name = "SpawnLocation"
	spawnLoc.Size = Vector3.new(24, 1, 24)
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
	
	local function fixAnchoring(model)
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = true
			end
		end
	end
	
	-- Gym Area (Treadmills)
	for i = 1, 10 do
		local treadmill
		if mapAssets and mapAssets:FindFirstChild("Treadmill") then
			treadmill = mapAssets.Treadmill:Clone()
			fixAnchoring(treadmill)
			treadmill:PivotTo(CFrame.new(-60 + (i * 12), 0, 40) * CFrame.Angles(0, math.rad(180), 0))
		else
			treadmill = Instance.new("Part")
			treadmill.Size = Vector3.new(4, 2, 8)
			treadmill.Position = Vector3.new(-60 + (i * 12), 1, 40)
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
			for i = 1, 30 do
				local t = treeRef:Clone()
				fixAnchoring(t)
				-- Randomize positions around the plaza
				local rx = math.random(-300, 300)
				local rz = math.random(-50, 300)
				t:PivotTo(CFrame.new(rx, 0, rz) * CFrame.Angles(0, math.random(0, 360), 0))
				t.Parent = mapFolder
			end
		end
		
		local benchRef = mapAssets:FindFirstChild("Bench")
		if benchRef then
			for i = 1, 15 do
				local b = benchRef:Clone()
				fixAnchoring(b)
				local rx = math.random(-250, 250)
				local rz = math.random(10, 100)
				b:PivotTo(CFrame.new(rx, 0, rz) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0))
				b.Parent = mapFolder
			end
		end
	end

	-- Shop Area
	local shopVendor = Instance.new("Part")
	shopVendor.Name = "ShopVendorBooth"
	shopVendor.Size = Vector3.new(20, 15, 20)
	shopVendor.Position = Vector3.new(100, 7.5, 0)
	shopVendor.Anchored = true
	shopVendor.BrickColor = BrickColor.new("Bright blue")
	shopVendor.Parent = mapFolder
	CollectionService:AddTag(shopVendor, "ShopVendor")

	-- Gacha Area
	local gachaBooth = Instance.new("Part")
	gachaBooth.Name = "GachaBooth"
	gachaBooth.Size = Vector3.new(16, 12, 16)
	gachaBooth.Position = Vector3.new(150, 6, -40)
	gachaBooth.Anchored = true
	gachaBooth.BrickColor = BrickColor.new("Bright red")
	gachaBooth.Parent = mapFolder

	-- Travel Terminal
	local travelTerminal = Instance.new("Part")
	travelTerminal.Name = "TravelTerminal"
	travelTerminal.Size = Vector3.new(20, 25, 20)
	travelTerminal.Position = Vector3.new(-150, 12.5, 0)
	travelTerminal.Anchored = true
	travelTerminal.BrickColor = BrickColor.new("Neon orange")
	travelTerminal.Parent = mapFolder
	
	print("[MapBuilder] MainHub GBK Senayan generated with massive 3D Assets.")
end

return MainHub
