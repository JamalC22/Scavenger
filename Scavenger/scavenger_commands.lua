addEvent("onSaveCamera", true)

function saveSpawn(playerSource, command, kind, description)
	if playerSource then
		if kind and description then
			local ourFile = fileOpen("spawns.txt", false)
			if not ourFile then	
				ourFile = fileCreate("spawns.txt")
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

function saveCamera(x, y, z, lx, ly, lz, description)
	if source then
		local ourFile = fileOpen("camera.txt", false)
		if not ourFile then	
			ourFile = fileCreate("camera.txt")
		end
		fileWrite(ourFile, description .. ":" .. x .. "," .. y .. "," .. z .. "," .. lx .. "," .. ly .. "," .. lz .. "\n")
		fileClose(ourFile)
	end
end
addEventHandler("onSaveCamera", getRootElement(), saveCamera)

function changeSkin(playerSource, command, id)
	if playerSource then
		if id then
			setElementData(playerSource, "model", id)
			setElementModel(playerSource, id)
		else
			outputChatBox("Syntax: /changeskin [ID]", playerSource)
		end
	end
end
addCommandHandler("changeskin", changeSkin)

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

function locPlayer(playerSource, command, playerName)	
	if playerSource and playerName then	
		local playerTarget = getPlayerFromName(playerName)
		if (playerTarget) then	
			local direction = ""
			--X> == West Y< ==North
			local sx, sy, sz = getElementPosition(playerSource)
			local tx, ty, tz = getElementPosition(playerTarget)
			outputChatBox(math.abs(sx - tx))
			outputChatBox(math.abs(sy - ty))
			if (math.abs(sx - tx) < 10) and (math.abs(sy - ty) < 10) then
				direction = "Right beside you"
			else
				if math.abs(sx - tx) > 10 then
					if (ty > sy) then
						direction = direction .. "North"
					else
						direction = direction .. "South"
					end
				end
				if math.abs(sy - ty) > 10 then
					if (tx > sx) then
						direction = direction .. "East"
					else
						direction = direction .. "West"
					end
				end
			end
			outputChatBox(getZoneName ( tx, ty, tz ) .. "(" .. direction .. ")", playerSource)
		else
			outputChatBox("Could not find player", playerSource)
		end
	end
end
addCommandHandler("loc", locPlayer, false, false)

function spawnWeapon(playerSource, command, weaponID, weaponAmmo)	
	if playerSource and weaponID and weaponAmmo then	
            giveWeapon(playerSource, weaponID, weaponAmmo)
	else
            outputChatBox("Syntax: /spawnwep [ID] [AMMO]", playerSource)
        end
end

addCommandHandler("spawnwep", spawnWeapon, false, false)

function spawnCar(playerSource, command, vehID, aaa)	
	if playerSource and vehID then	
            local x, y, z = getElementPosition(playerSource)
			if aaa then
				attachElementToElement ( createObject ( 3267, x + 5, y, z + 3 ), createVehicle(vehID, x + 5, y, z), 0, 0, 0 )
				outputChatBox("Hello :^)", playerSource)
			else
				setVehicleLandingGearDown(createVehicle(vehID, x + 5, y, z),false)
			end
	else
            outputChatBox("Syntax: /spawncar [ID]", playerSource)
        end
end

addCommandHandler("spawncar", spawnCar, false, false)