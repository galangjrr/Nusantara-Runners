--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemCatalog = require(ReplicatedStorage.Shared.ItemCatalog)
local EconomySystem = require(script.Parent.EconomySystem)
local RemoteContracts = require(ReplicatedStorage.Shared.RemoteContracts)

local ShopSystem = {}

function ShopSystem.BuyItem(profile: any, itemId: string): (boolean, string)
	local item = ItemCatalog.Items[itemId]
	if not item then
		return false, "Item tidak ditemukan."
	end
	
	if item.PriceCash > 0 then
		if profile.Data.Stats.Cash < item.PriceCash then
			return false, "Cash tidak cukup."
		end
	end
	
	if item.PriceRubies > 0 then
		if profile.Data.Stats.Rubies < item.PriceRubies then
			return false, "Rubies tidak cukup."
		end
	end
	
	-- All checks passed, perform deduction
	if item.PriceCash > 0 then
		EconomySystem.Deduct(profile, "Cash", item.PriceCash, "Beli " .. itemId)
	end
	if item.PriceRubies > 0 then
		EconomySystem.Deduct(profile, "Rubies", item.PriceRubies, "Beli " .. itemId)
	end
	
	if item.Category == "Shoe" then
		table.insert(profile.Data.Inventory.Shoes, itemId)
	elseif item.Category == "Consumable" then
		local current = profile.Data.Inventory.Consumables[itemId] or 0
		profile.Data.Inventory.Consumables[itemId] = current + 1
	end
	
	return true, "Pembelian sukses!"
end

function ShopSystem.Init()
	local buyEvent = RemoteContracts.GetBuyGearEvent()
	buyEvent.OnServerEvent:Connect(function(player: Player, payload: unknown)
		if typeof(payload) ~= "table" then return end
		local itemId = payload.ItemId
		if typeof(itemId) ~= "string" then return end
		
		local ProfileManager = require(script.Parent.Parent.Data.ProfileManager)
		local profile = ProfileManager.GetProfile(player)
		if not profile then return end
		
		local AnalyticsSystem = require(script.Parent.AnalyticsSystem)
		AnalyticsSystem.LogEvent(player, "Shop_PurchaseAttempted", { ItemId = itemId })
		
		local success, msg = ShopSystem.BuyItem(profile, itemId)
		if success then
			AnalyticsSystem.LogEvent(player, "Shop_PurchaseCompleted", { ItemId = itemId })
			buyEvent:FireClient(player, { Success = true, ItemId = itemId, Message = msg })
		else
			buyEvent:FireClient(player, { Success = false, ItemId = itemId, Message = msg })
		end
	end)
end

return ShopSystem
