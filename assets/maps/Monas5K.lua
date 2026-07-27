--!strict
local CollectionService = game:GetService("CollectionService")

local Monas5K = {}

function Monas5K.Build()
	local mapFolder = Instance.new("Folder")
	mapFolder.Name = "Monas5K"
	mapFolder.Parent = workspace

	for i = 1, 5 do
		local cp = Instance.new("Part")
		cp.Name = "Checkpoint_" .. i
		cp.Size = Vector3.new(20, 1, 20)
		cp.Position = Vector3.new(100 + (i * 50), 0.5, 100)
		cp.Anchored = true
		cp.CanCollide = false
		cp.BrickColor = BrickColor.new("Lime green")
		cp.Transparency = 0.5
		cp.Parent = mapFolder
		
		CollectionService:AddTag(cp, "RaceCheckpoint")
	end
	
	-- Add Sprint Segment
	local sprintStart = Instance.new("Part")
	sprintStart.Name = "Sprint_Start"
	sprintStart.Size = Vector3.new(20, 1, 5)
	sprintStart.Position = Vector3.new(125, 0.5, 125)
	sprintStart.Anchored = true
	sprintStart.CanCollide = false
	sprintStart.BrickColor = BrickColor.new("Bright blue")
	sprintStart.Transparency = 0.5
	sprintStart.Parent = mapFolder
	CollectionService:AddTag(sprintStart, "KOMSegmentStart")
	
	local sprintEnd = Instance.new("Part")
	sprintEnd.Name = "Sprint_End"
	sprintEnd.Size = Vector3.new(20, 1, 5)
	sprintEnd.Position = Vector3.new(250, 0.5, 125)
	sprintEnd.Anchored = true
	sprintEnd.CanCollide = false
	sprintEnd.BrickColor = BrickColor.new("Bright red")
	sprintEnd.Transparency = 0.5
	sprintEnd.Parent = mapFolder
	CollectionService:AddTag(sprintEnd, "KOMSegmentEnd")
	
	print("[MapBuilder] Monas5K map blockout & checkpoints generated.")
end

return Monas5K
