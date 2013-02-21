playerAmmo = 100
playerThirst = 100
playerHunger = 100

addEvent("updateAmmo", true)
addEvent("updateThirst", true)
addEvent("updateHunger", true)

flashSpeed = 2048

screenWidth, screenHeight = guiGetScreenSize()
function onCustomRender()
	if not getGUIVisible() then
		local playerHealth = getElementHealth(getLocalPlayer())
		if isPlayerDead(getLocalPlayer()) then
			playerThirst = 0
			playerHunger = 0
			playerHealth = 0
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
				dxDrawImage ( screenWidth - (screenWidth / 10), (screenHeight / 2) + ((screenHeight / 15) * 1.5) , 64, 64, "edf/ammo.png", 0, 0, 0, tocolor(255 - (playerAmmo  * (255 / 100)), (playerAmmo  * (255 / 100)), 0, flashAlpha))
			else
				dxDrawImage ( screenWidth - (screenWidth / 10), (screenHeight / 2) + ((screenHeight / 15) * 1.5), 64, 64, "edf/ammo.png", 0, 0, 0, tocolor(255 - (playerAmmo  * (255 / 100)), (playerAmmo  * (255 / 100)), 0))
			end
		end
		--Health
		if playerHealth <= 25 then
			dxDrawImage ( screenWidth - (screenWidth / 10), (screenHeight / 2) + ((screenHeight / 15) * 2.7), 64, 64, "edf/health.png", 0, 0, 0, tocolor(255 - (playerHealth * (255 / 100)), (playerHealth * (255 / 100)), 0, flashAlpha))
		else
			dxDrawImage ( screenWidth - (screenWidth / 10), (screenHeight / 2) + ((screenHeight / 15) * 2.7), 64, 64, "edf/health.png", 0, 0, 0, tocolor(255 - (playerHealth * (255 / 100)), (playerHealth * (255 / 100)), 0))
		end
		--Hunger
		if playerHunger <= 25 then
			dxDrawImage ( screenWidth - (screenWidth / 10), (screenHeight / 2) + ((screenHeight / 15) * 3.9), 64, 64, "edf/hunger.png", 0, 0, 0, tocolor(255 - (playerHunger  * (255 / 100)), (playerHunger  * (255 / 100)), 0, flashAlpha))
		else
			dxDrawImage ( screenWidth - (screenWidth / 10), (screenHeight / 2) + ((screenHeight / 15) * 3.9), 64, 64, "edf/hunger.png", 0, 0, 0, tocolor(255 - (playerHunger  * (255 / 100)), (playerHunger  * (255 / 100)), 0))
		end
		--Thirst
		if playerThirst <= 25 then
			dxDrawImage ( screenWidth - (screenWidth / 10), (screenHeight / 2) + ((screenHeight / 15) * 5.1), 64, 64, "edf/thirst.png", 0, 0, 0, tocolor(255 - (playerThirst  * (255 / 100)), (playerThirst  * (255 / 100)), 0, flashAlpha))
		else
			dxDrawImage ( screenWidth - (screenWidth / 10), (screenHeight / 2) + ((screenHeight / 15) * 5.1), 64, 64, "edf/thirst.png", 0, 0, 0, tocolor(255 - (playerThirst  * (255 / 100)), (playerThirst  * (255 / 100)), 0))
		end
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