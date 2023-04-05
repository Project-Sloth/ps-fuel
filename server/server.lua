-- Variables

local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

-- Server Events

QBCore.Functions.CreateCallback('ps-fuel:server:fuelCan', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemByName("weapon_petrolcan")
    cb(itemData)
end)

RegisterNetEvent('ps-fuel:server:BuyCan', function (paymentMethod)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if not paymentMethod then return end
	if Player.PlayerData.money[paymentMethod] >= Config.canCost then
		if Player.Functions.AddItem("weapon_petrolcan", 1, false) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weapon_petrolcan"], "add")
			TriggerClientEvent('QBCore:Notify', src, Lang:t('info.purchased_jerry_can', {value = Config.canCost}), "success")
			Player.Functions.RemoveMoney(paymentMethod, Config.canCost)
		end
	else
		TriggerClientEvent('QBCore:Notify', src, Lang:t("notify.no_money"), "error")
	end
end)

RegisterNetEvent("ps-fuel:server:PayForFuel", function (paymentMethod, grade, amount)
	local Player = QBCore.Functions.GetPlayer(source)
	if not (paymentMethod or grade or amount) then return end
	if (amount*45) > 4500 then
		-- why are you higher than 4500?
		return
	end
	local cost = Config.FuelPrices[grade]*amount
	if Config.FuelPrices[grade] and Player.PlayerData.money[paymentMethod] >= cost then
		Player.Functions.RemoveMoney(paymentMethod, cost)
		TriggerClientEvent('QBCore:Notify', source, Lang:t("notify.filled"), "success")
	end
end)