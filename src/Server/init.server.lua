--!strict
print("Server initialized")
local ShopSystem = require(script.Systems.ShopSystem)
ShopSystem.Init()
local PetSystem = require(script.Systems.PetSystem)
PetSystem.Init()
local AnalyticsSystem = require(script.Systems.AnalyticsSystem)
AnalyticsSystem.Init()
local ProfileManager = require(script.Data.ProfileManager)
ProfileManager.Init()

-- Generate Map Blockout
local ServerStorage = game:GetService("ServerStorage")
local MainHub = require(ServerStorage.Maps.MainHub)
MainHub.Build()
local Monas5K = require(ServerStorage.Maps.Monas5K)
Monas5K.Build()
local BorobudurPrambanan = require(ServerStorage.Maps.BorobudurPrambanan)
BorobudurPrambanan.Build()
local BromoRinjani = require(ServerStorage.Maps.BromoRinjani)
BromoRinjani.Build()

-- Start Race Loop
local RaceSystem = require(script.Systems.RaceSystem)
game:GetService("RunService").Heartbeat:Connect(RaceSystem.UpdateRaces)
