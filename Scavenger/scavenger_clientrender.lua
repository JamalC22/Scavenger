screenWidth, screenHeight = guiGetScreenSize()
guiStartPos = (screenHeight / 3) + 30
fuelStartPos = 30
fuelWidth = 10
fuelHeight = 100
fuelBorderThickness = 2

playerAmmo = 100
playerThirst = 100
playerHunger = 100
playerTemperature = 0
playerVehicleFuel = 0

addEvent("updateAmmo", true)
addEvent("updateThirst", true)
addEvent("updateHunger", true)
addEvent("updateTemperature", true)
addEvent("updateVehicleFuel", true)

function onCustomRender()
	if not getGUIVisible() then
		local playerHealth = getElementHealth(getLocalPlayer())
		if isPlayerDead(getLocalPlayer()) then
			playerThirst = 0
			playerHunger = 0
			playerHealth = 0
			playerTemperature = 100
		end
		local flashAlpha = (((getTickCount() / 2.5) % 512))
		if flashAlpha >= 256 then
			--Up
			flashAlpha = 256 - flashAlpha
		else
			--Down
			flashAlpha = 0 + flashAlpha
		end
		--Ammo weight
		if playerAmmo then
			if playerAmmo <= 25 then
				dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 1), 64, 64, "edf/ammo.png", 0, 0, 0, tocolor(255 - (playerAmmo  * (255 / 100)), (playerAmmo  * (255 / 100)), 0, flashAlpha))
			else
				dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 1), 64, 64, "edf/ammo.png", 0, 0, 0, tocolor(255 - (playerAmmo  * (255 / 100)), (playerAmmo  * (255 / 100)), 0))
			end
		end
		--Health
		if playerHealth <= 25 then
			dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 2), 64, 64, "edf/health.png", 0, 0, 0, tocolor(255 - (playerHealth * (255 / 100)), (playerHealth * (255 / 100)), 0, flashAlpha))
		else
			dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 2), 64, 64, "edf/health.png", 0, 0, 0, tocolor(255 - (playerHealth * (255 / 100)), (playerHealth * (255 / 100)), 0))
		end
		--Hunger
		if playerHunger <= 25 then
			dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 3), 64, 64, "edf/hunger.png", 0, 0, 0, tocolor(255 - (playerHunger  * (255 / 100)), (playerHunger  * (255 / 100)), 0, flashAlpha))
		else
			dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 3), 64, 64, "edf/hunger.png", 0, 0, 0, tocolor(255 - (playerHunger  * (255 / 100)), (playerHunger  * (255 / 100)), 0))
		end
		--Thirst
		if playerThirst <= 25 then
			dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 4), 64, 64, "edf/thirst.png", 0, 0, 0, tocolor(255 - (playerThirst  * (255 / 100)), (playerThirst  * (255 / 100)), 0, flashAlpha))
		else
			dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 4), 64, 64, "edf/thirst.png", 0, 0, 0, tocolor(255 - (playerThirst  * (255 / 100)), (playerThirst  * (255 / 100)), 0))
		end
		--Tenperature
		if playerTemperature > 50 then 
			if playerTemperature >= 90 then
				dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 5), 64, 64, "edf/thermo.png", 0, 0, 0, tocolor((playerTemperature * (255 / 100)), 255 - (playerTemperature * (255 / 100)), 0, flashAlpha))
			else
				dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 5), 64, 64, "edf/thermo.png", 0, 0, 0, tocolor((playerTemperature * (255 / 100)), 255 - (playerTemperature * (255 / 100)), 0))
			end
		elseif playerTemperature < 50 then
			if playerTemperature <= 10 then
				dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 5), 64, 64, "edf/thermo.png", 0, 0, 0, tocolor(0, (playerTemperature * (255 / 100)), 255 - (playerTemperature * (255 / 100)), flashAlpha))
			else
				dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 5), 64, 64, "edf/thermo.png", 0, 0, 0, tocolor(0, (playerTemperature * (255 / 100)), 255 - (playerTemperature * (255 / 100))))
			end
		else
			dxDrawImage ( screenWidth - 74, guiStartPos + (74 * 5), 64, 64, "edf/thermo.png", 0, 0, 0, tocolor(0, 255, 0))
		end
		--Vehicle Fuel
		--OutLine
		dxDrawRectangle( fuelStartPos - fuelBorderThickness, fuelStartPos - fuelBorderThickness, fuelBorderThickness, fuelHeight + (fuelBorderThickness * 2), tocolor(0, 0, 0))
		dxDrawRectangle( fuelStartPos + fuelWidth, fuelStartPos - fuelBorderThickness, fuelBorderThickness, fuelHeight + (fuelBorderThickness * 2), tocolor(0, 0, 0))
		dxDrawRectangle( fuelStartPos - fuelBorderThickness, fuelStartPos - fuelBorderThickness, fuelWidth + (fuelBorderThickness * 2), fuelBorderThickness, tocolor(0, 0, 0))
		dxDrawRectangle( fuelStartPos - fuelBorderThickness, fuelStartPos + fuelHeight, fuelWidth + (fuelBorderThickness * 2), fuelBorderThickness, tocolor(0, 0, 0))
		--Fuel Gauge
		local fuelLevel = (playerVehicleFuel * (fuelHeight / 100))
		dxDrawRectangle( fuelStartPos, ((fuelStartPos + fuelHeight) - fuelLevel), fuelWidth, fuelLevel, tocolor(0, 255, 0, 120))
	end
end
addEventHandler("onClientRender", getRootElement(), onCustomRender)


function update_Ammo(newplayerAmmo)
	if newplayerAmmo then
		playerAmmo = newplayerAmmo
	else
		playerAmmo = false
	end
end
addEventHandler("updateAmmo", getRootElement(), update_Ammo)

function update_Thirst(newplayerThirst)
	if newplayerThirst then
		playerThirst = newplayerThirst
	else
		playerThirst = 0
	end
end
addEventHandler("updateThirst", getRootElement(), update_Thirst)

function update_Hunger(newplayerHunger)
	if newplayerHunger then
		playerHunger = newplayerHunger
	else
		playerHunger = 0
	end
end
addEventHandler("updateHunger", getRootElement(), update_Hunger)

function update_Temperature(newplayerTemperature)
	if newplayerTemperature then
		playerTemperature = newplayerTemperature
	else
		playerTemperature = 0
	end
end
addEventHandler("updateTemperature", getRootElement(), update_Temperature)

function update_VehicleFuel(newplayerVehicleFuel)
	if newplayerVehicleFuel then
		playerVehicleFuel = newplayerVehicleFuel
	else
		playerVehicleFuel = 0
	end
end
addEventHandler("updateVehicleFuel", getRootElement(), update_VehicleFuel)