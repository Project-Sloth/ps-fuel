-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local fuelSynced = false
local inBlacklisted = false
local inGasStation = false
local isFueling = false
local Stations = {}
local props = {
	'prop_gas_pump_1d',
	'prop_gas_pump_1a',
	'prop_gas_pump_1b',
	'prop_gas_pump_1c',
	'prop_vintage_pump',
	'prop_gas_pump_old2',
	'prop_gas_pump_old3',
}
local CurrentWeaponData = {}
local hasNozzle = false
local gasNozzle = nil
-- Functions

local function isHoldingWeapon(weaponHash)
	return GetSelectedPedWeapon(PlayerPedId()) == weaponHash
end

local function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))
		fuelSynced = true
	end
	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
		SetVehicleEngineOn(veh, true, true, true)
	else
		SetVehicleEngineOn(veh, true, true, true)
	end
end

-- Threads

CreateThread(function()
	local bones = {
		"petroltank",
		"petroltank_l",
		"petroltank_r",
		"wheel_rf",
		"wheel_rr",
		"petrolcap ",
		"seat_dside_r",
		"engine",
	}
	exports['qb-target']:AddTargetBone(bones, {
		options = {
			{
				type = "client",
				event = "ps-fuel:client:RefuelVehicle",
				icon = "fas fa-gas-pump",
				label = Lang:t('info.refuel_vehicle'),
				canInteract = function()
					return inGasStation and hasNozzle or HasPedGotWeapon(PlayerPedId(), 883325847)
				end
			}
		},
		distance = 1.5,
	})
	-- Target Export
	exports['qb-target']:AddTargetModel(props, {
		options = {
			{
				num = 1,
				type = "client",
				event = "ps-fuel:client:takenozzle",
				icon = "fas fa-gas-pump",
				label = Lang:t('info.take_nozzle'),
				canInteract = function(entity)
					return not IsPedInAnyVehicle(PlayerPedId()) and not hasNozzle
				end,
			},
			{
				num = 2,
				type = "client",
				event = "ps-fuel:client:returnnozzle",
				icon = "fas fa-gas-pump",
				label = Lang:t('info.return_nozzle'),
				canInteract = function(entity)
					return hasNozzle and not refueling
				end,
			},
			{
				num = 3,
				type = "client",
				event = "ps-fuel:client:buyCanMenu",
				icon = "fas fa-burn",
				label = Lang:t('info.buy_jerry_can'),
				canInteract = function(entity)
					return not HasPedGotWeapon(PlayerPedId(), 883325847)
				end,
			},
			{
				num = 4,
				type = "client",
				event = "ps-fuel:client:refuelCanMenu",
				icon = "fas fa-gas-pump",
				label = Lang:t('info.refuel_jerry_can'),
				canInteract = function(entity)
					return isHoldingWeapon(GetHashKey("weapon_petrolcan"))
				end,
			},
		},
		distance = 2.0
	})
end)

if Config.LeaveEngineRunning then
	CreateThread(function()
		while true do
			Wait(100)
			local ped = GetPlayerPed(-1)
			if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
				local engineWasRunning = GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, true))
				Wait(1000)
				if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
					local veh = GetVehiclePedIsIn(ped, true)
					if engineWasRunning then
						SetVehicleEngineOn(veh, true, true, true)
					end
				end
			end
		end
	end)
end

if Config.ShowNearestGasStationOnly then
	CreateThread(function()
		local currentGasBlip = 0
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			local closest = 1000
			local closestCoords

			for _, gasStationCoords in pairs(Config.GasStationsBlips) do
				local dstcheck = #(coords - gasStationCoords)
				if dstcheck < closest then
					closest = dstcheck
					closestCoords = gasStationCoords
				end
			end
			if DoesBlipExist(currentGasBlip) then
				RemoveBlip(currentGasBlip)
			end
			currentGasBlip = CreateBlip(closestCoords)
			Wait(10000)
		end
	end)

else
	CreateThread(function()
		for _, gasStationCoords in pairs(Config.GasStationsBlips) do
			CreateBlip(gasStationCoords)
		end
	end)
end

CreateThread(function()
	for k=1, #Config.GasStations do
		Stations[k] = PolyZone:Create(Config.GasStations[k].zones, {
			name="GasStation"..k,
			minZ = 	Config.GasStations[k].minz,
			maxZ = Config.GasStations[k].maxz,
			debugPoly = false
		})
		Stations[k]:onPlayerInOut(function(isPointInside)
			if isPointInside then
				inGasStation = true
			else
				inGasStation = false
			end
		end)
	end
end)

CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)
	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end
	for index = #Config.Blacklist, 1, -1 do
		Config.Blacklist[index] = nil
	end
	while true do
		Wait(1000)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end
			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end
			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

-- Client Events

AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
	if bool ~= false then
		CurrentWeaponData = data
	else
		CurrentWeaponData = {}
	end
	CanShoot = bool
end)

------------------------------------------------------------
-- [[ Jerry Can ]] --
RegisterNetEvent('ps-fuel:client:buyCanMenu', function()
	local dialog = 	exports['qb-input']:ShowInput({
		header = Lang:t('info.gas_station'),
		submitText = "Purchase for: $"..Config.canCost,
		inputs = {
			{
				text = "Payment Methods",
				name = "billtype",
				type = "select",
				options = {
					{ value = "cash", text = "Cash" },
					{ value = "bank", text = "Card" }
				},
			},
		},
	})
	if dialog ~= nil then
		TriggerServerEvent('ps-fuel:server:BuyCan', dialog.billtype)
	end
end)

RegisterNetEvent('ps-fuel:client:refuelCanMenu', function()
	local ped = PlayerPedId()
	local playerMoney = QBCore.Functions.GetPlayerData().money
	if HasPedGotWeapon(ped, 883325847) then
		local currentFuel = GetAmmoInPedWeapon(ped, 883325847)
		local fuelToAdd = (4500-currentFuel)/45 -- x/100
		print(currentFuel, fuelToAdd)
		if currentFuel < 4500 and fuelToAdd >= 0 then
			local gradeDialog = exports['qb-input']:ShowInput({
				header = Lang:t('info.gas_station'),
				inputs = {
					{
						text = "Fuel Grade",
						name = "grade",
						type = "select",
						options = {
							{ value = "Regular", text = "Regular ($"..Config.FuelPrices["Regular"].."/gallon)" },
							{ value = "MidGrade", text = "Mid-Grade ($"..Config.FuelPrices["MidGrade"].."/gallon)" },
							{ value = "Premium", text = "Premium ($"..Config.FuelPrices["Premium"].."/gallon)" },
							{ value = "Diesel", text = "Diesel ($"..Config.FuelPrices["Diesel"].."/gallon)" },
							{ value = "E85", text = "E85 ($"..Config.FuelPrices["E85"].."/gallon)" }
						},
					},
				},
			})
			if gradeDialog ~= nil then
				local cost = math.floor((Config.FuelPrices[gradeDialog.grade]*fuelToAdd)*100)/100
				local dialog = exports['qb-input']:ShowInput({
					header = Lang:t('info.gas_station'),
					submitText = "Purchase for: $"..cost,
					inputs = {
						{
							text = "Payment Methods",
							name = "billtype",
							type = "select",
							options = {
								{ value = "cash", text = "Cash" },
								{ value = "bank", text = "Card" }
							},
						},
					},
				})
				if dialog ~= nil then
					if playerMoney[dialog.billtype] >= (Config.FuelPrices[gradeDialog.grade]*fuelToAdd) then
						RequestAnimDict("weapon@w_sp_jerrycan")
						while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do Wait(100) end
						TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
						QBCore.Functions.Progressbar("refuel-car", "Refueling", (Config.RefuelTime*fuelToAdd*1000), false, true, {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {}, {}, {}, function() -- Done
							TriggerServerEvent('ps-fuel:server:PayForFuel', dialog.billtype, gradeDialog.grade, fuelToAdd)
							TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(4500))
							PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
							StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
						end, function() -- Cancel
							QBCore.Functions.Notify(Lang:t("notify.refuel_cancel"), "error")
							StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
						end)
					else
						QBCore.Functions.Notify(Lang:t("notify.no_money"), "error")
					end
				end
			end
		else
			QBCore.Functions.Notify(Lang:t("notify.jerrycan_full"), "error")
		end
	end
end)

------------------------------------------------------------
-- [[ Refuel Vehicle ]] --
RegisterNetEvent('ps-fuel:client:RefuelVehicle', function()
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local curFuel = GetVehicleFuelLevel(vehicle)
	local fuelToAdd = 100 - curFuel -- x/100
	local ped = PlayerPedId()
	local playerMoney = QBCore.Functions.GetPlayerData().money
	local time = Config.RefuelTime*fuelToAdd*1000

	if not (fuelToAdd > 0) then
		QBCore.Functions.Notify(Lang:t('error.vehicle_already_full'), "error")
		return
	end

	if HasPedGotWeapon(ped, 883325847) then
		if GetAmmoInPedWeapon(ped, 883325847) >= 0 then
			local curCanFuel = GetAmmoInPedWeapon(ped, 883325847)
			if curCanFuel > 0 then
				isFueling = true
				RequestAnimDict("weapon@w_sp_jerrycan")
				while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do
					Wait(100)
				end
				TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
				if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
					local Chance = math.random(1, 100)
					if Chance <= Config.BlowUpChance then
						Wait(1000)
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "fuelstop", 0.3)
						AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
						return
					end
				end
				local totalAmmo = curCanFuel - (fuelToAdd*45)
				if totalAmmo < 0 then
					totalAmmo = 0
					time = Config.RefuelTime*(curCanFuel/45)*1000
					fuelToAdd = curCanFuel/45
				end

				QBCore.Functions.Progressbar("refuel-car", "Refueling", time, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function() -- Done
					SetFuel(vehicle, (curFuel + fuelToAdd))
					TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, totalAmmo)
					PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
					StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
					isFueling = false
				end, function() -- Cancel
					isFueling = false
					QBCore.Functions.Notify(Lang:t("notify.refuel_cancel"), "error")
					StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
				end)
			else
				QBCore.Functions.Notify(Lang:t('error.no_fuel_gas_can'), "error")
				return
			end
		else
			QBCore.Functions.Notify(Lang:t("notify.jerrycan_empty"), "error")
		end
	else
		if inGasStation and hasNozzle then
			local gradeDialog = exports['qb-input']:ShowInput({
				header = Lang:t('info.gas_station'),
				inputs = {
					{
						text = "Fuel Grade",
						name = "grade",
						type = "select",
						options = {
							{ value = "Regular", text = "Regular ($"..Config.FuelPrices["Regular"].."/gallon)" },
							{ value = "MidGrade", text = "Mid-Grade ($"..Config.FuelPrices["MidGrade"].."/gallon)" },
							{ value = "Premium", text = "Premium ($"..Config.FuelPrices["Premium"].."/gallon)" },
							{ value = "Diesel", text = "Diesel ($"..Config.FuelPrices["Diesel"].."/gallon)" },
							{ value = "E85", text = "E85 ($"..Config.FuelPrices["E85"].."/gallon)" }
						},
					},
				},
			})
			if gradeDialog ~= nil then
				local cost = math.floor((Config.FuelPrices[gradeDialog.grade]*fuelToAdd)*100)/100
				local dialog = exports['qb-input']:ShowInput({
					header = Lang:t('info.gas_station'),
					submitText = "Purchase for: $"..cost,
					inputs = {
						{
							text = "Payment Methods",
							name = "billtype",
							type = "select",
							options = {
								{ value = "cash", text = "Cash" },
								{ value = "bank", text = "Card" }
							},
						},
					},
				})
				if dialog ~= nil then
					if playerMoney[dialog.billtype] >= (Config.FuelPrices[gradeDialog.grade]*fuelToAdd) then
						TaskTurnPedToFaceEntity(ped, vehicle, 5000)
						Wait(2000)
						RequestAnimDict("amb@world_human_security_shine_torch@male@base")
						while not HasAnimDictLoaded('amb@world_human_security_shine_torch@male@base') do
							Wait(100)
						end
						TaskPlayAnim(ped, "amb@world_human_security_shine_torch@male@base", "base", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
						isFueling = true
						if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
							local Chance = math.random(1, 100)
							if Chance <= Config.BlowUpChance then
								Wait(1000)
								TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "fuelstop", 0.3)
								AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
								DeleteObject(gasNozzle)
								gasNozzle = nil
								isFueling = false
								hasNozzle = false
								return
							end
						end
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "putbacknozzle", 0.6)
						Wait(1000)
						TriggerServerEvent("InteractSound_SV:PlayOnSource", "fueling-sound", 0.5)
						QBCore.Functions.Progressbar("refuel-car", "Refueling", time, false, true, {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {}, {}, {}, function() -- Done
							isFueling = false
							TriggerServerEvent('ps-fuel:server:PayForFuel', dialog.billtype, gradeDialog.grade, fuelToAdd)
							SetFuel(vehicle, 100)
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "fuelstop", 0.6)
							PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
							Wait(500)
							StopAnimTask(ped, "amb@world_human_security_shine_torch@male@base", 'base', 3.0, 3.0, -1, 2, 0, 0, 0, 0)
						end, function() -- Cancel
							isFueling = false
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "fuelstop", 0.6)
							QBCore.Functions.Notify(Lang:t("notify.refuel_cancel"), "error")
							StopAnimTask(ped, "amb@world_human_security_shine_torch@male@base", 'base', 3.0, 3.0, -1, 2, 0, 0, 0, 0)
						end)
					else
						QBCore.Functions.Notify(Lang:t("notify.no_money"), "error")
						return
					end
				end
			end
		end
	end
end)

RegisterNetEvent('ps-fuel:client:takenozzle', function ()
	if hasNozzle then return end
	local ped = PlayerPedId()
	local nozzleProp = "prop_cs_fuel_nozle"
	RequestAnimDict("anim@am_hold_up@male")
	while not HasAnimDictLoaded('anim@am_hold_up@male') do
		Wait(100)
	end
	TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, 1000, 50, 0, 0, 0, 0)
	TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "pickupnozzle", 0.6)
	QBCore.Functions.LoadModel(nozzleProp)
	gasNozzle = CreateObject(nozzleProp, 1.0, 1.0, 1.0, 1, 1, 0)
	if DoesEntityExist(gasNozzle) then
		hasNozzle = true
		AttachEntityToEntity(gasNozzle, ped, GetPedBoneIndex(ped, 18905), 0.13, 0.04, 0.01, -42.0, -115.0, -63.42, 0, 1, 0, 1, 0, 1)
	end
end)

RegisterNetEvent('ps-fuel:client:returnnozzle', function ()
	if not hasNozzle then return end
	TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "putbacknozzle", 0.6)
	hasNozzle = false
	DeleteObject(gasNozzle)
	gasNozzle = nil
end)