--!strict
local CollectionService = game:GetService("CollectionService")

local BromoRinjani = {}

function BromoRinjani.Build()
	local mapFolder = Instance.new("Folder")
	mapFolder.Name = "SubPlace05_BromoRinjani"
	mapFolder.Parent = game.Workspace.Map
	
	local landmarks = Instance.new("Folder")
	landmarks.Name = "Landmarks"
	landmarks.Parent = mapFolder
	
	-- Bromo (Kawah, Lautan Pasir)
	local bromoSand = Instance.new("Part")
	bromoSand.Name = "Bromo_SandSea"
	bromoSand.Size = Vector3.new(500, 2, 500)
	bromoSand.Position = Vector3.new(-500, 0, -500)
	bromoSand.Anchored = true
	bromoSand.Material = Enum.Material.Sand
	bromoSand.BrickColor = BrickColor.new("Brick yellow")
	bromoSand.Parent = landmarks
	
	local bromoCone = Instance.new("Part")
	bromoCone.Name = "Bromo_VolcanoCone"
	bromoCone.Size = Vector3.new(150, 150, 150)
	bromoCone.Position = Vector3.new(-500, 75, -500)
	bromoCone.Anchored = true
	bromoCone.Material = Enum.Material.Rock
	bromoCone.BrickColor = BrickColor.new("Dark stone grey")
	bromoCone.Parent = landmarks
	
	-- Rinjani (Summit Tinggi)
	local rinjaniBody = Instance.new("Part")
	rinjaniBody.Name = "Rinjani_MountainBody"
	rinjaniBody.Size = Vector3.new(250, 250, 250)
	rinjaniBody.Position = Vector3.new(-1000, 125, -500)
	rinjaniBody.Anchored = true
	rinjaniBody.Material = Enum.Material.Rock
	rinjaniBody.BrickColor = BrickColor.new("Dark stone grey")
	rinjaniBody.Parent = landmarks
	
	-- Pet Spawn Zones
	local bromoPetZone = Instance.new("Part")
	bromoPetZone.Name = "PetSpawnZone_Bromo"
	bromoPetZone.Size = Vector3.new(100, 20, 100)
	bromoPetZone.Position = Vector3.new(-400, 10, -400)
	bromoPetZone.Anchored = true
	bromoPetZone.CanCollide = false
	bromoPetZone.Transparency = 0.8
	bromoPetZone.BrickColor = BrickColor.new("Bright yellow")
	bromoPetZone.Parent = mapFolder
	CollectionService:AddTag(bromoPetZone, "PetSpawnZone")
	
	local rinjaniPetZone = Instance.new("Part")
	rinjaniPetZone.Name = "PetSpawnZone_RinjaniSummit"
	rinjaniPetZone.Size = Vector3.new(50, 50, 50)
	rinjaniPetZone.Position = Vector3.new(-1000, 260, -500)
	rinjaniPetZone.Anchored = true
	rinjaniPetZone.CanCollide = false
	rinjaniPetZone.Transparency = 0.8
	rinjaniPetZone.BrickColor = BrickColor.new("New Yeller")
	rinjaniPetZone.Parent = mapFolder
	CollectionService:AddTag(rinjaniPetZone, "PetSpawnZone")

	print("[MapBuilder] SubPlace05_BromoRinjani blockout & Pet Zones generated.")
end

return BromoRinjani
