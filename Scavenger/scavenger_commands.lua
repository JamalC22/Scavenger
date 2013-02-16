function saveSpawn(playerSource, command, kind, description)
	outputConsole("ytest")
	if playerSource then
		if kind and description then
			local ourFile = fileOpen("pos.txt", false)
			if not ourFile then	
				ourFile = fileCreate("pos.txt")
			end
			fileSetPos(ourFile, fileGetSize(ourFile))
			local x,
			y,
			z = getElementPosition(playerSource)
			local xRot,
			yRot,
			zRot = getElementRotation(playerSource)
			if x and y and z and xRot and yRot and zRot then
				if kind == "pickup" then
					fileWrite(ourFile, "pickup " .. description .. ":" .. x .. "," .. y .. "," .. z .. "\n")
					outputChatBox("Saved pickup " .. description .. ":" .. x .. "," .. y .. "," .. z, playerSource)
				elseif kind == "car" then
					fileWrite(ourFile, "car " .. description .. ":" .. x .. "," .. y .. "," .. z .. "," .. xRot .. "," .. yRot .. "," .. zRot .. "\n")
					outputChatBox("Saved car " .. description .. ":" .. x .. "," .. y .. "," .. z .. "," .. xRot .. "," .. yRot .. "," .. zRot, playerSource)
				end	
			end
			fileClose(ourFile)
		else
			outputChatBox("Syntax: /savespawn [car/pickup] [description]", playerSource)
		end
	end
end
addCommandHandler("savespawn", saveSpawn)

function teleportPlayer(playerSource, command, playerName)	
	if playerSource and playerName then	
		local targetPlayer = getPlayerFromName(playerName)
		if (targetPlayer) then	
			local x, y, z = getElementPosition(targetPlayer)
                        setElementPosition ( playerSource, x, y, z + 3, true )
			outputChatBox("Teleported", playerSource)
		else
			outputChatBox("Could not find player", playerSource)
		end
	end
end

addCommandHandler("teleplayer", teleportPlayer, false, false)

function spawnWeapon(playerSource, command, weaponID, weaponAmmo)	
	if playerSource and weaponID and weaponAmmo then	
            giveWeapon(playerSource, weaponID, weaponAmmo)
	else
            outputChatBox("Syntax: /spawnwep [ID] [AMMO]", playerSource)
        end
end

addCommandHandler("spawnwep", spawnWeapon, false, false)

function spawnCar(playerSource, command, vehID)	
	if playerSource and vehID then	
            local x, y, z = getElementPosition(playerSource)	
            createVehicle(vehID, x + 5, y, z)
	else
            outputChatBox("Syntax: /spawncar [ID]", playerSource)
        end
end

addCommandHandler("spawncar", spawnCar, false, false)