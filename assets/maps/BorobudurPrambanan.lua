--!strict
local CollectionService = game:GetService("CollectionService")

local BorobudurPrambanan = {}

function BorobudurPrambanan.Build()
	local mapFolder = Instance.new("Folder")
	mapFolder.Name = "SubPlace02_BorobudurPrambanan"
	mapFolder.Parent = game.Workspace.Map
	
	local candiFolder = Instance.new("Folder")
	candiFolder.Name = "Landmarks"
	candiFolder.Parent = mapFolder
	
	-- Borobudur (Berundak)
	local boroBase = Instance.new("Part")
	boroBase.Name = "Borobudur_Base"
	boroBase.Size = Vector3.new(60, 10, 60)
	boroBase.Position = Vector3.new(0, 5, 0)
	boroBase.Anchored = true
	boroBase.Material = Enum.Material.Slate
	boroBase.BrickColor = BrickColor.new("Dark stone grey")
	boroBase.Parent = candiFolder
	
	local boroMid = Instance.new("Part")
	boroMid.Name = "Borobudur_Mid"
	boroMid.Size = Vector3.new(40, 10, 40)
	boroMid.Position = Vector3.new(0, 15, 0)
	boroMid.Anchored = true
	boroMid.Material = Enum.Material.Slate
	boroMid.BrickColor = BrickColor.new("Dark stone grey")
	boroMid.Parent = candiFolder
	
	local boroTop = Instance.new("Part")
	boroTop.Name = "Borobudur_Top"
	boroTop.Size = Vector3.new(20, 10, 20)
	boroTop.Position = Vector3.new(0, 25, 0)
	boroTop.Anchored = true
	boroTop.Material = Enum.Material.Slate
	boroTop.BrickColor = BrickColor.new("Dark stone grey")
	boroTop.Parent = candiFolder
	
	-- Prambanan (Ramping Menjulang)
	local pramMain = Instance.new("Part")
	pramMain.Name = "Prambanan_MainTower"
	pramMain.Size = Vector3.new(20, 70, 20)
	pramMain.Position = Vector3.new(200, 35, 0)
	pramMain.Anchored = true
	pramMain.Material = Enum.Material.Slate
	pramMain.BrickColor = BrickColor.new("Dark stone grey")
	pramMain.Parent = candiFolder
	
	-- Checkpoints for 10K Race
	local cpStart = Instance.new("Part")
	cpStart.Name = "Checkpoint_0"
	cpStart.Size = Vector3.new(20, 1, 5)
	cpStart.Position = Vector3.new(0, 0.5, 40)
	cpStart.Anchored = true
	cpStart.CanCollide = false
	cpStart.Transparency = 0.5
	cpStart.BrickColor = BrickColor.new("Bright green")
	cpStart.Parent = mapFolder
	cpStart:SetAttribute("RaceId", "10K_Heritage")
	cpStart:SetAttribute("CheckpointIndex", 0)
	CollectionService:AddTag(cpStart, "RaceCheckpoint")
	
	local cpEnd = Instance.new("Part")
	cpEnd.Name = "Checkpoint_1"
	cpEnd.Size = Vector3.new(20, 1, 5)
	cpEnd.Position = Vector3.new(200, 0.5, 20)
	cpEnd.Anchored = true
	cpEnd.CanCollide = false
	cpEnd.Transparency = 0.5
	cpEnd.BrickColor = BrickColor.new("Bright red")
	cpEnd.Parent = mapFolder
	cpEnd:SetAttribute("RaceId", "10K_Heritage")
	cpEnd:SetAttribute("CheckpointIndex", 1)
	CollectionService:AddTag(cpEnd, "RaceCheckpoint")

	print("[MapBuilder] SubPlace02_BorobudurPrambanan blockout generated.")
end

return BorobudurPrambanan
