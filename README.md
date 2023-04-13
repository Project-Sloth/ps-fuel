![Project Sloth GitHub Project PS-FUEL Banner](https://user-images.githubusercontent.com/91661118/169398756-5c1a49b8-e21c-4a06-baa6-7fcc793c34e3.png)

### ps-fuel
A NoPixel inspired functionality fuel system that uses PolyZones that target specific areas that allow you to have the abilitity to refuel your vehicles.

![Project Sloth Buttons](https://user-images.githubusercontent.com/91661118/169454003-488c8994-eec9-4b92-9b0c-f3a675be7d1b.png)

### Dependencies:
* [qb-target](https://github.com/BerkieBb/qb-target)
* [qb-menu](https://github.com/qbcore-framework/qb-menu)
* [qb-input](https://github.com/qbcore-framework/qb-input)
* [polyzone](https://github.com/qbcore-framework/PolyZone)
* [interact-sound](https://github.com/qbcore-framework/interact-sound)

<br>
<br>

![Project Sloth GitHub Sub Install Banner](https://user-images.githubusercontent.com/91661118/169409382-9c2c1478-2c48-45a9-a3c6-e9167f741efc.png)


### Start installing now
We will now provide you with a step-by-step guide for the installation process. Shouldn't take too long and it shouldn't be too confusing either! 

### Step 1:
Go ahead and start by dragging and dropping ps-fuel into your designated resources folder.

If you are still lost, Slothy has created a few GIF's to help guide you through all the installation steps.

![explorer_rKiz0tBzmo](https://user-images.githubusercontent.com/91661118/169417369-59282006-7284-477d-853f-c29b108baa5d.gif)

### Step 2:
Open your entire resources folder with Visual Studio Code (or whichever program you use) and replace all exsiting exports titled "LegacyFuel" with "ps-fuel" instead. 

**If you have the previous resource "lj-fuel" do the same thing and replace that with "ps-fuel" or just get this newer version to avoid any conflictions or confusion.**

![explorer_vpSwery89h](https://user-images.githubusercontent.com/91661118/169423238-99659010-718d-4d95-a73e-8aa2b232ebb4.gif)

### Step 3: 
First copy the snippet below and then navigate to your **qb-smallresources/client/ignore.lua**

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

then paste this snippet over the existing lines shown in the GIF below.

![Code_rCl4lhFAY5](https://user-images.githubusercontent.com/91661118/169423678-9b55f693-de65-4e9d-b595-3a61ee31ca17.gif)

### Step 3:
```if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher"```

Copy this line and then navigate to your **qb-inventory/client/main.lua** paste this in your Visual Studio Code search bar.

```lua
if weaponName == "weapon_fireextinguisher" then
	ammo = 4000
end
```
after it takes you to spot we need, copy this snippet and paste it over the few lines shown in the GIF below.

![Code_YbMuUyZnUS](https://user-images.githubusercontent.com/91661118/169424450-5220ea12-24a4-4bcc-a7d2-c68950cb4d27.gif)

### Step 4:
```TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))```

Copy this line and then navigate to your **qb-weapons/client/main.lua** paste this in your Visual Studio Code search bar.

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

After it takes you to spot we need, copy this snippet and paste it over the few lines shown in the GIF below.

![Code_yecDDjuRVG](https://user-images.githubusercontent.com/91661118/169425085-6eaeead9-9398-4ac0-8e0f-b6d116326e97.gif)

### Step 5:
Copy the sounds inside the sounds folder and paste/drag it into your interact-sounds folder located at resources/[standalone]/interact-sound/client/html/sounds

<br>
<br>

![Project Sloth GitHub Sub Features Banner](https://user-images.githubusercontent.com/91661118/169454782-7891d081-63b7-4e40-b26a-d995bd7c99bb.png)

#### Some features to mention within this ps-fuel:
* Show all gas station blips (found in shared/config.lua)
* Vehicle blowing up chance percent (found in shared/config.lua)
* Global tax and fuel prices (found in shared/config.lua)
* Close resembled NoPixel animation while refueling vehicles
* Target eye for all actions
* Menu estimating cost for vehicle being refueled (tax included)
* Buy and refuel jerry cans
* Jerry cans save amount of fuel left while not equipped

<br>
<br>

![Project Sloth GitHub Sub Showcase Banner](https://user-images.githubusercontent.com/91661118/169444909-e642a02d-5f74-4016-9044-f380150307ca.png)

### Time to show you what it looks like!
Here's a few showcased examples while using ps-fuel.

#### Jerry can saving correct amount left:
https://user-images.githubusercontent.com/91661118/169445831-babf91d3-86f1-47cc-ad12-4402dce977f9.mp4

#### Buying and refueling jerry can:
https://user-images.githubusercontent.com/91661118/169447776-815aae46-53e0-40cd-a9e5-347115dc1748.mp4

#### Refueling vehicle:
https://user-images.githubusercontent.com/91661118/169447249-b20abaca-fd1b-49ef-88c2-b6683b266f41.mp4


### Credits:
Huge thanks to [Snipe (pushkart2)](https://github.com/pushkart2) and [MonkeyWhisper](https://github.com/MonkeyWhisper) for figuring out the long-awaited issue of jerry cans not saving the proper amount of fuel each time you equip it. This release wouldn't be possible without them.

##### Copyright © 2022 Project Sloth. All rights reserved.
