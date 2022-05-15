![PS FUEL](https://user-images.githubusercontent.com/91661118/139381416-32ce9dd7-a77d-4690-bf35-e0b3fd336039.png)


# PS-Fuel used with QBCore Framework
Join my Discord laboratory for updates, support, and special early testing!
<br>
https://discord.gg/ljlabs (without-vanity url: https://discord.gg/HH6uTcBfew)

ps-fuel is a modified version of LegacyFuel and uses logic from lj-fuel using PolyZones like NoPixel 3.0
<br>
Runs at ~ 0.00 to 0.01 ms if you have more optimization suggestions feel free to reach out

# Dependencies
* [qb-target](https://github.com/BerkieBb/qb-target)
* [qb-menu](https://github.com/qbcore-framework/qb-menu)
* [polyzone](https://github.com/qbcore-framework/PolyZone)

# Installation
* **IMPORTANT: Must rename ANY existing LegacyFuel exports to ps-fuel**
* **IMPORTANT: Must rename ANY existing lj-fuel exports to ps-fuel**

## qb-smallresources:
* Remove this logic in **qb-smallresources/client/ignore.lua**
* Replace the thread the way I did, so fire extinguisher have infinte ammo but not petrol can
```lua
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
		if weapon ~= GetHashKey("WEAPON_UNARMED") then
			if IsPedArmed(ped, 6) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end

			if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER")then
				if IsPedShooting(ped) then
					SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
				end
			end
		else
			Citizen.Wait(500)
		end
        Citizen.Wait(7)
    end
end)
```
## inventory
* Replace the following from your client side inventory lua file.

* Before 
```lua
if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher"  then
	ammo = 4000
end
```

* After
```lua
if weaponName == "weapon_fireextinguisher" then
	ammo = 4000
end
```
(removes jerry can refull when pulled from inventory)

## Weapons

* Before
```lua
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if (IsPedArmed(ped, 7) == 1 and (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24))) then
            local weapon = GetSelectedPedWeapon(ped)
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
            if MultiplierAmount > 0 then
                TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, MultiplierAmount)
                MultiplierAmount = 0
            end
        end
        Wait(1)
    end
end)
```

*After

```lua
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local idle = 1
        if (IsPedArmed(ped, 7) == 1 and (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24))) or IsPedShooting(PlayerPedId()) then
            local weapon = GetSelectedPedWeapon(ped)
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            if weapon == GetHashKey("WEAPON_PETROLCAN")  then
                idle = 1000
            end
            TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
            if MultiplierAmount > 0 then
                TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, MultiplierAmount)
                MultiplierAmount = 0
            end
        end
        Wait(idle)
    end
end)
```
# Key Features
* NoPixel style animation for refueling
* Gas station polyzone areas targeted with qb-target
* Fuel price is fully calulated before purchase including taxes
* Progressbar is synced with refueling amount left for vehicle
* Buy jerry can from pump
* Refuel jerry can from pump
* Engine chance to blow up
* Engine always running unless turned off

#
# Previews
### resource ms
![resource ms](https://user-images.githubusercontent.com/91661118/139408600-4ce062a2-c302-46a9-a1f1-210a1cee402a.png)
### refueling animation
https://user-images.githubusercontent.com/91661118/139377251-82a357e4-8ebc-43e4-bf1b-47210cb6a971.mp4
### refueling vehicle jerry can
![refueling vehicle jerry can](https://user-images.githubusercontent.com/91661118/139378188-be90c869-73d8-4034-a0c6-70d987eb037b.png)
### polyzones around map
![polyzones](https://user-images.githubusercontent.com/91661118/139377336-53a84080-3178-4511-9030-0306e4999fda.png)
### refuel interact
![qb-target interact](https://user-images.githubusercontent.com/91661118/139377384-0ab4a5f7-c760-4111-8512-bf8760e8d61a.png)
### menu price calculation
![qb-target interact](https://user-images.githubusercontent.com/91661118/139625411-38fde643-74ac-4be5-a26d-c1744406afb0.png)

### pump interaction
![qb-target pump interaction](https://user-images.githubusercontent.com/91661118/139377494-de7de1b5-b8e7-4c72-9b63-493ee34279bd.png)
#

# My CSS Edits to Dependencies
* [qb-target](https://github.com/loljoshie/qb-target)
* [progressbar](https://github.com/loljoshie/progressbar)
* [qb-menu](https://github.com/loljoshie/qb-menu)

# Change Logs

### 1.2
* optimize & refactor & change table & add new export - evanillaa
* Change exports back to qb-target
* Fixed qb-menu for new update

### 1.1
* Added option to have a chance of engine explosion while vehicle is left running
* Added option to have blips only show when close enough
* Added option to leave engine running

### 1.0
* Initial release

# Credit
* ImpulseFPS for PolyZone and global tax idea [original version](https://github.com/ImpulseFPS/irp-fuel)

# Issues and Suggestions
Please use the GitHub issues system to report issues or make suggestions, when making suggestion, please keep [Suggestion] in the title to make it clear that it is a suggestion.


# TODO

* Fix Locales
* Add option for fuel tick so if person stops the progress, it will fill the fuel rather than not fueling at all
* Not necessary but incorporate IlleniumStudios status hud with the fuel tick