--1 to constantly stream zombies, 0 to only allow zombies to spawn via createZombie function, 2 to only allow spawning at set spawnpoints
ZombieStreaming = get("zombies.StreamMethod")
--Maximum zombies
ZombieLimit = get("zombies.MaxZombies")
--Zombie speed
ZombieSpeed = get("zombies.Speed")
--Skin IDs
ZombiePedSkins = {13,22,56,67,68,69,70,92,97,105,107,108,126,127,128,152,162,167,188,195,206,209,212,229,230,258,264,277,280,287 }

function wastedHandler ( totalAmmo, killer, killerWeapon, bodypart )
	local playerMoney = getPlayerMoney(source)
	if playerMoney and playerMoney > 100 then
		takePlayerMoney(source, playerMoney / 4)
		if(killer) then
			if getElementType ( killer ) == "player" then
				givePlayerMoney(killer, playerMoney / 4)
			end
		end
	end
	local playerKillCount = getElementData ( source, "Zombie kills")
	if playerKillCount and playerKillCount > 0 then
		setElementData ( source, "Zombie kills", 0  )
		triggerClientEvent("onZombieWasted", getRootElement(), 0 )
	end
	spawnHandler ( source )
end

function spawnHandler ( x, y, z )
	if x and y and z then
		spawnPlayer(source, x, y, z)
	else
		spawnPlayer(source, 1959.55, -1714.46, 18)
	end
	fadeCamera(source, true)
	setCameraTarget(source, source)		
end

function quitHandler ()
	local playeraccount = getPlayerAccount ( source )
	if playeraccount and not isGuestAccount ( playeraccount ) then
		local x, y, z = getElementPosition( source )
		setAccountData ( playeraccount, "zombies.pX", x )
		setAccountData ( playeraccount, "zombies.pY", y )
		setAccountData ( playeraccount, "zombies.pZ", z )
		for index = 0, 12, 1 do
			local weaponID = getPedWeapon	( source, index)
			local weaponAmmo = getPedTotalAmmo ( source, index )
			setAccountData ( playeraccount, "zombies.weaponid" .. index, weaponID )
			setAccountData ( playeraccount, "zombies.weaponammo" .. index, weaponAmmo )
		end
		local playerHealth = getElementHealth(source)
		if playerHealth then
			setAccountData ( playeraccount, "zombies.playerhealth", playerHealth )
		else
			setAccountData ( playeraccount, "zombies.playerhealth", 1.0 )
		end
		local playerMoney = getPlayerMoney(source)
		if(playerMoney) then
			setAccountData ( playeraccount, "zombies.playermoney", playerMoney )
		else
			setAccountData ( playeraccount, "zombies.playermoney", 0 )
		end
		local playerKillCount = getElementData ( source, "Zombie kills")
		if playerKillCount then
			setAccountData ( playeraccount, "zombies.killcount", playerKillCount )
		else
			setAccountData ( playeraccount, "zombies.killcount", 0 )
		end
	end
	logOut(source)
end

function attemptLogin ( username, password )
	if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
		local account = getAccount( username, password )
		if not account then
			triggerClientEvent ( "onUnsuccessfulLogin", getRootElement(), "Account not found" )
		else
			triggerClientEvent ( "onSuccessfulLogin", getRootElement())
			logIn (source, account, password)
			loadAccountData( account )
		end
	end
end

function  attemptRegister ( username, password )
	if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
		local account = getAccount( username, password )
		if account then
			triggerClientEvent ( "onSuccessfulLogin", getRootElement())
			logIn (source, account, password)
			loadAccountData( account )
		else
			if addAccount(username, password) ~= false then
				triggerClientEvent ( "onSuccessfulLogin", getRootElement())
				spawnHandler()
			else
				triggerClientEvent ( "onUnsuccessfulLogin", getRootElement(), "Failed to create account" )
			end
		end
	else
		triggerClientEvent ( "onUnsuccessfulLogin", getRootElement(), "Invalid login data" )
	end
end

function loadAccountData ( account )
	if account then
		local x = getAccountData(account, "zombies.pX")
		local y = getAccountData(account, "zombies.pY")
		local z = getAccountData(account, "zombies.pZ")
		if x and y and z then
			spawnHandler(x, y, z + 2)
		else
			spawnHandler()
		end
		local player = getAccountPlayer(account)
		if player then
			for index = 0, 12, 1 do
				local weaponID = getAccountData(account, "zombies.weaponid" .. index)
				local weaponAmmo = getAccountData(account, "zombies.weaponammo" .. index)
				if weaponAmmo and weaponAmmo > 0 then
					giveWeapon(player, weaponID, weaponAmmo)
				end
			end
			local playerHealth = getAccountData(account, "zombies.playerhealth")
			if(playerHealth) then
				setElementHealth(player, playerHealth)
			end
			local playerMoney = getAccountData(account, "zombies.playermoney")
			if(playerMoney) then
				setPlayerMoney (player, playerMoney)
			end
			local playerKillCount = getAccountData(account, "zombies.killcount")
			if(playerKillCount) then
				setElementData ( player, "Zombie kills", playerKillCount  )
				triggerClientEvent("onZombieWasted", getRootElement(), playerKillCount)
			end
		end
	end
end

function gibwep ( playerSource, command, weaponID, weaponAmmo )
	if playerSource then
		if weaponID and weaponAmmo then
			giveWeapon(playerSource, weaponID, weaponAmmo )
		else
			giveWeapon(playerSource, 38, 5000 )
		end
	end
end
addCommandHandler("gibwep", gibwep, false, false)

function zombieWastedHandler ( attacker, weapon, bodypart )
	local killCount = getElementData ( attacker, "Zombie kills" )
	if killCount then
		triggerClientEvent("onZombieWasted", getRootElement(), killCount)
	end
	givePlayerMoney ( attacker, 5 + math.random(5) )
end

addEvent("onAttemptLogin", true)
addEvent("onAttemptRegister", true)
addEvent("onZombieWasted", false)
addEventHandler ( "onZombieWasted", getRootElement(), zombieWastedHandler)
addEventHandler ( "onAttemptRegister", getRootElement(), attemptRegister)
addEventHandler ( "onAttemptLogin", getRootElement(), attemptLogin)
addEventHandler ( "onPlayerWasted", getRootElement(), wastedHandler)
addEventHandler ( "onPlayerQuit", getRootElement(), quitHandler )

if ZombieSpeed == 0 then --super slow zombies (goofy looking)
	chaseanim = "WALK_drunk"
	checkspeed = 2000
elseif ZombieSpeed == 1 then -- normal speed
	chaseanim = "run_old"
	checkspeed = 1000
elseif ZombieSpeed == 2 then -- rocket zombies (possibly stressful on server)
	chaseanim = "Run_Wuzi"
	checkspeed = 680
else -- defaults back to normal
	chaseanim = "run_old"
	checkspeed = 1000
end
resourceRoot = getResourceRootElement()
moancount =0
moanlimit = 10
everyZombie = { }

--IDLE BEHAVIOUR OF A ZOMBIE
function Zomb_Idle (ped)
	if isElement(ped) then
		if ( getElementData ( ped, "status" ) == "idle" ) and ( isPedDead ( ped ) == false ) and (getElementData (ped, "zombie") == true) then
			local action = math.random( 1, 6 )
			if action < 4 then -- walk a random direction
				local rdmangle = math.random( 1, 359 )
				setPedRotation( ped, rdmangle )
				setPedAnimation ( ped, "PED", "Player_Sneak", -1, true, true, true)
				setTimer ( Zomb_Idle, 7000, 1, ped )
			elseif action == 4 then -- get on the ground
				setPedAnimation ( ped, "MEDIC", "cpr", -1, false, true, true)
				setTimer ( Zomb_Idle, 4000, 1, ped )
			elseif action == 5 then -- stand still doing nothing
				setPedAnimation ( ped )
				setTimer ( Zomb_Idle, 4000, 1, ped )
			end
		end
	end
end

--BEHAVIOUR WHILE CHASING PLAYERS
function Zomb_chase (ped, Zx, Zy, Zz )
	if isElement(ped) then
		if (getElementData ( ped, "status" ) == "chasing") and (getElementData (ped, "zombie") == true) then
			local x, y, z = getElementPosition( ped )
			if (getElementData ( ped, "target" ) == nil) and getElementData ( ped, "Tx" ) ~= false then			
				local Px = getElementData ( ped, "Tx" )
				local Py = getElementData ( ped, "Ty" )
				local Pz = getElementData ( ped, "Tz" )
				local Pdistance = (getDistanceBetweenPoints3D( Px, Py, Pz, x, y, z ))
				if (Pdistance < 1.5 ) then
					setTimer ( function (ped) if ( isElement ( ped ) ) then setElementData ( ped, "status", "idle" ) end end, 2000, 1, ped )
				end
			end
			local distance = (getDistanceBetweenPoints3D( x, y, z, Zx, Zy, Zz ))			
			if (distance < 1 ) then -- IF THE PED HASNT MOVED
				if (getElementData ( ped, "target" ) == nil) then
					local giveup = math.random( 1, 15 )
					if giveup == 1 then
						setElementData ( ped, "status", "idle" )
					else
						local action = math.random( 1, 2 )
						if action == 1 then
							setPedAnimation ( ped )
							triggerClientEvent ( "Zomb_Punch", getRootElement(), ped )
							setTimer ( function (ped) if ( isElement ( ped ) ) then setPedAnimation ( ped, "ped", chaseanim, -1, true, true, true ) end end, 800, 1, ped )
							setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
						elseif action == 2 then
							setPedAnimation ( ped )
							triggerClientEvent ( "Zomb_Jump", getRootElement(), ped )
							setTimer ( Zomb_chase, 3500, 1, ped, x, y, z )
						end
					end
				else 
					local Ptarget = (getElementData ( ped, "target" ))
					if isElement(Ptarget) then
						local Px, Py, Pz = getElementPosition( Ptarget )
						local Pdistance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
						if (Pdistance < 1.2 ) then -- ATTACK A PLAYER IF THEY ARE CLOSE
							if ( isPedDead ( Ptarget ) ) then --EAT A DEAD PLAYER
								setPedAnimation ( ped )
								setPedAnimation ( ped, "MEDIC", "cpr", -1, false, true, false)
								setTimer ( function (ped) if ( isElement ( ped ) ) then setElementData ( ped, "status", "idle" ) end end, 10000, 1, ped )
								setTimer ( function (ped) if ( isElement ( ped ) ) then setPedRotation ( ped, getPedRotation(ped)-180) end end, 10000, 1, ped )
								zmoan(ped)
							else
								local action = math.random( 1, 6 )
								if action == 1 then
									setPedAnimation ( ped)
									triggerClientEvent ( "Zomb_Jump", getRootElement(), ped )
									setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
								else
									setPedAnimation ( ped)
									triggerClientEvent ( "Zomb_Punch", getRootElement(), ped )
									setTimer ( function (ped) if ( isElement ( ped ) ) then setPedAnimation ( ped, "ped", chaseanim, -1, true, true, true ) end end, 800, 1, ped )
									setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
								end
							end
						else
							if ( isPedDead (Ptarget) ) then
							setTimer ( function (ped) if ( isElement ( ped ) ) then setElementData ( ped, "status", "idle" ) end end, 2000, 1, ped )
							setTimer ( function (ped) if ( isElement ( ped ) ) then setPedRotation ( ped, getPedRotation(ped)-180) end end, 1800, 1, ped )
							else
								local action = math.random( 1, 2 )
								if action == 1 then
									setPedAnimation ( ped)
									triggerClientEvent ( "Zomb_Punch", getRootElement(), ped )
									setTimer ( function (ped) if ( isElement ( ped ) ) then setPedAnimation ( ped, "ped", chaseanim, -1, true, true, true ) end end, 800, 1, ped )
									setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
								elseif action == 2 then
									setPedAnimation ( ped)
									triggerClientEvent ( "Zomb_Jump", getRootElement(), ped )
									setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
								end
							end
						end
					else
						setElementData ( ped, "status", "idle" )
					end
				end
			else
				setPedAnimation ( ped, "ped", chaseanim, -1, true, true, true) --KEEP WALKING
				setTimer ( Zomb_chase, checkspeed, 1, ped, x, y, z ) --CHECK AGAIN
			end
		end
	end
end

--SET THE DIRECTION OF THE ZOMBIE
function setangle ()
	for theKey,ped in ipairs(everyZombie) do
		if isElement(ped) then
			if ( getElementData ( ped, "status" ) == "chasing" ) then
				local x
				local y
				local z
				local px
				local py
				local pz
				if ( getElementData ( ped, "target" ) ~= nil ) then
					local ptarget = getElementData ( ped, "target" )
					if isElement(ptarget) then
						x, y, z = getElementPosition( ptarget )
						px, py, pz = getElementPosition( ped )
					else
						setElementData ( ped, "status", "idle" )
						x, y, z = getElementPosition( ped )
						px, py, pz = getElementPosition( ped )
					end
					zombangle = ( 360 - math.deg ( math.atan2 ( ( x - px ), ( y - py ) ) ) ) % 360 --MAGIC SPELL TO MAKE PEDS LOOK AT YOU
					setPedRotation( ped, zombangle )
				elseif ( getElementData ( ped, "target" ) == nil ) and (getElementData ( ped, "Tx" ) ~= false) then --IF THE PED IS AFTER THE PLAYERS LAST KNOWN WHEREABOUTS
					x = getElementData ( ped, "Tx" )
					y = getElementData ( ped, "Ty" )
					z = getElementData ( ped, "Tz" )
					px, py, pz = getElementPosition( ped )
					zombangle = ( 360 - math.deg ( math.atan2 ( ( x - px ), ( y - py ) ) ) ) % 360 --MAGIC SPELL TO MAKE PEDS LOOK AT YOU
					setPedRotation( ped, zombangle )
				end
			end
		end
	end
end

--SETS THE ZOMBIE ACTIVITY WHEN STATUS CHANGES
addEventHandler ( "onElementDataChange", getRootElement(),
function ( dataName )
	if getElementType ( source ) == "ped" and dataName == "status" then
		if (getElementData (source, "zombie") == true) then
			if ( isPedDead ( source ) == false ) then
				if (getElementData ( source, "status" ) ==  "chasing" ) then
					local Zx, Zy, Zz = getElementPosition( source )
					setTimer ( Zomb_chase, 1000, 1, source, Zx, Zy, Zz )
					local newtarget = (getElementData ( source, "target" ))
					if isElement (newtarget) then
						if getElementType ( newtarget ) == "player" then
							setElementSyncer ( source, newtarget )
						end
					end
					zmoan(source)
				elseif (getElementData ( source, "status" ) ==  "idle" ) then
					setTimer ( Zomb_Idle, 1000, 1, source)
				elseif (getElementData ( source, "status" ) ==  "throatslashing" ) then
					local tx,ty,tz = getElementPosition( source )
					local ptarget = getElementData ( source, "target" )
					if isElement(ptarget) then
						local vx,vy,vz = getElementPosition( ptarget )
						local zombdistance = (getDistanceBetweenPoints3D (tx, ty, tz, vx, vy, vz))
						if (zombdistance < .8) then
							zmoan(source)
							setPedAnimation ( source, "knife", "KILL_Knife_Player", -1, false, false, true)
							setPedAnimation ( ptarget, "knife", "KILL_Knife_Ped_Damage", -1, false, false, true)
							setTimer ( Playerthroatbitten, 2300, 1, ptarget, source) 
							setTimer ( function (source) if ( isElement ( source ) ) then setElementData ( source, "status", "idle" ) end end, 5000, 1, source )
						else
							setElementData ( source, "status", "idle" )
						end
					else
						setElementData ( source, "status", "idle" )
					end
				end
			elseif (getElementData ( source, "status" ) ==  "dead" ) then
				setTimer ( Zomb_delete, 10000, 1, source)
			end
		end
	end
end)

--RESOURCE START/INITIAL SETUP
function outbreak(startedResource)
	newZombieLimit = get("" .. getResourceName(startedResource) .. ".Zlimit")
	if newZombieLimit ~= false then
		if newZombieLimit > ZombieLimit then 
			newZombieLimit = ZombieLimit
		end
	else
		newZombieLimit = ZombieLimit
	end
	WoodTimer = setTimer ( WoodSetup, 2000, 1) -- CHECKS FOR BARRIERS
	if startedResource == getThisResource() then
--		call(getResourceFromName("scoreboard"), "scoreboardAddColumn", "Zombie kills") --ADDS TO SCOREBOARD
		local allplayers = getElementsByType ( "player" )
		for pKey,thep in ipairs(allplayers) do
			setElementData ( thep, "dangercount", 0 )
		end	
		local alivePlayers = getAlivePlayers ()
		for playerKey, playerValue in ipairs(alivePlayers) do
			setElementData ( playerValue, "alreadyspawned", true  )
		end
		if ZombieSpeed == 2 then
			MainTimer1 = setTimer ( setangle, 200, 0) -- KEEPS ZOMBIES FACING THE RIGHT DIRECTION (fast)
		else
			MainTimer1 = setTimer ( setangle, 400, 0) -- KEEPS ZOMBIES FACING THE RIGHT DIRECTION
		end
		MainTimer3 = setTimer ( clearFarZombies, 3000, 0) --KEEPS ALL THE ZOMBIES CLOSE TO PLAYERS	
		if ZombieStreaming == 1 then
			MainTimer2 = setTimer ( SpawnZombie, 2500, 0 ) --Spawns zombies in random locations
		elseif ZombieStreaming == 2 then
			MainTimer2 = setTimer ( SpawnpointZombie, 2500, 0 ) --spawns zombies in zombie spawnpoints
		end
	end
end
addEventHandler("onResourceStart", getRootElement(), outbreak)

function player_Connect()
	setElementData ( source, "dangercount", 0 )
end
addEventHandler ( "onPlayerConnect", getRootElement(), player_Connect )

function WoodSetup()
	local allcols = getElementsByType ( "colshape" ) --clears off old wood cols
	for colKey, colValue in ipairs(allcols) do
		if ( getElementData ( colValue, "purpose" ) =="zombiewood" ) then
			destroyElement(colValue)
		end
	end	
	local allobjects = getElementsByType ( "object" ) --SETS UP ALL THE WOOD BARRIERS
	for objectKey, objectValue in ipairs(allobjects) do
		if ( getElementData ( objectValue, "purpose" ) =="zombiewood" ) then
			setElementDimension ( objectValue, 26 )
			local x,y,z = getElementPosition( objectValue )
			local thecol = createColSphere ( x, y, z, 1.6 )
			setElementData ( thecol, "purpose", "zombiewood" )
			setElementParent ( thecol, objectValue )
		end
	end	
end

function ReduceMoancount()
	moancount = moancount-1
end

function zmoan(zombie)
	if moancount < moanlimit then
		moancount = moancount+1
		local randnum = math.random( 1, 10 )
		triggerClientEvent ( "Zomb_Moan", getRootElement(), zombie, randnum )
		setTimer ( ReduceMoancount, 800, 1 )
	end
end

--CLEARS A DEAD ZOMBIE
function Zomb_delete (ped)
	if isElement(ped) then
		if (getElementData (ped, "zombie") == true) then
			for theKey,thePed in ipairs(everyZombie) do
				if ped == thePed then
					table.remove( everyZombie, theKey )
					break
				end
			end
			destroyElement ( ped )
		end
	end
end

--HEADSHOTS
addEvent( "headboom", true )
function Zheadhit ( ped,attacker, weapon, bodypart)
	if (getElementData (ped, "zombie") == true) then
		killPed ( ped, attacker, weapon, bodypart )
		setPedHeadless  ( ped, true )
	end
end
addEventHandler( "headboom", getRootElement(), Zheadhit )

--KILL FROM ZOMBIE ATTACK
addEvent( "playereaten", true )
function Playerinfected ( player, attacker, weapon, bodypart)
    killPed ( player, attacker, weapon, bodypart )
end
addEventHandler( "playereaten", getRootElement(), Playerinfected )

--CHECKS FOR ZOMBIE GRABBING FROM BEHIND
function Playerthroatbitten ( player, attacker)
	local Zx, Zy, Zz = getElementPosition( attacker )
	local Px, Py, Pz = getElementPosition( player )
	local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
	if (distance < 1) then
		killPed ( player, attacker, weapon, bodypart )
	else
		setPedAnimation (player)
	end
end

--ADJUSTS PLAYERS ZOMBIE KILL SCORE
function deanimated( ammo, attacker, weapon, bodypart )
	if (attacker) then
		if (getElementType ( attacker ) == "player") and (getElementType ( source ) == "ped") then
			if (getElementData (source, "zombie") == true) then
				local oldZcount = getElementData ( attacker, "Zombie kills" )
				if oldZcount ~= false then
					setElementData ( attacker, "Zombie kills", oldZcount+1  )
					triggerEvent ( "onZombieWasted", source, attacker, weapon, bodypart )
				else
					setElementData ( attacker, "Zombie kills", 1  )
					triggerEvent ( "onZombieWasted", source, attacker, weapon, bodypart )				
				end
			end
		end
	end
end
addEventHandler("onPedWasted", resourceRoot, deanimated)

--STUFF TO ALLOW PLAYERS TO PLACE BOARDS
function boarditup( player, key, keyState )
	local rightspot = 0
	local allcols = getElementsByType ( "colshape" )
	for ColKey,theCol in ipairs(allcols) do
		if (getElementData ( theCol, "purpose" ) == "zombiewood" ) then
			if (isElementWithinColShape ( player, theCol )) then
				local rightcol = theCol
				local Cx, Cy, Cz = getElementPosition( rightcol )
				local Bx, By, Bz = getElementPosition( player )
				woodangle = ( 360 - math.deg ( math.atan2 ( ( Cx - Bx ), ( Cy - By ) ) ) ) % 360
				setPedRotation( player, woodangle )
				setPedAnimation(player, "riot", "RIOT_PUNCHES", 3000, true, true, true )
				local wx, wy, wz = getElementPosition( player )
				setTimer( doneboarding, 2000, 1, player, rightcol, wx, wy, wz )
			end
		end
	end
end
addCommandHandler ( "construct", boarditup )
	
function doneboarding(player, rightcol, wx, wy, wz)
	setPedAnimation(player)
	local newx, newy, newz = getElementPosition( player )
	local distance = (getDistanceBetweenPoints3D( wx, wy, wz, newx, newy, newz ))			
	if (distance < .7 ) then
		newwood = getElementParent ( rightcol )
		setElementDimension ( newwood, 25 )
		setTimer( setElementDimension, 50, 1, newwood, 0)
	end
end


--SPAWN ZOMBIE (now can be cancelled!)

addEvent( "onZombieSpawn", true )
function RanSpawn_Z ( gx, gy, gz, rot)
	local safezone = 0
	local allradars = getElementsByType("radararea")
	for theKey,theradar in ipairs(allradars) do
		if getElementData(theradar, "zombieProof") == true then
			if isInsideRadarArea ( theradar, gx, gy ) then
				safezone = 1
			end
		end
	end
	if safezone == 0 then
		if table.getn ( everyZombie ) < newZombieLimit then
			if not rot then
				rot = math.random (1,359)
			end
			randomZskin = math.random ( 1, table.getn ( ZombiePedSkins ) )			
			local zomb = createPed( tonumber( ZombiePedSkins[randomZskin] ), gx, gy, gz )
			if zomb ~= false then
				setElementData ( zomb, "zombie", true  )
				table.insert( everyZombie, zomb )	
				setTimer ( function (zomb, rot) if ( isElement ( zomb ) ) then setPedRotation ( zomb, rot ) end end, 500, 1, zomb, rot )
				setTimer ( function (zomb) if ( isElement ( zomb ) ) then setPedAnimation ( zomb, "ped", chaseanim, -1, true, true, true ) end end, 1000, 1, zomb )
				setTimer ( function (zomb) if ( isElement ( zomb ) ) then setElementData ( zomb, "status", "idle" ) end end, 2000, 1, zomb )
				triggerClientEvent ( "Zomb_STFU", getRootElement(), zomb )
			end
		end
	end
end
addEventHandler( "onZombieSpawn", getRootElement(), RanSpawn_Z )


--SPAWNS ZOMBIES RANDOMLY NEAR PLAYERS
function SpawnZombie ()
	local pacecount = 0
	while pacecount < 5 do	--4 ZOMBIES AT A TIME TO PREVENT FPS DROP
		if (table.getn( everyZombie )+pacecount < newZombieLimit ) and (ZombieStreaming == 1) then	
			local xcoord = 0
			local ycoord = 0
			local xdirection = math.random(1,2)
			if xdirection == 1 then
				xcoord = math.random(15,40)
			else
				xcoord = math.random(-40,-15)
			end
			local ydirection = math.random(1,2)
			if ydirection == 1 then
				ycoord = math.random(15,40)
			else
				ycoord = math.random(-40,-15)
			end
			local liveplayers = getAlivePlayers ()
			if (table.getn( liveplayers ) > 0 ) then
				local lowestcount = 99999
				local lowestguy = nil
				for PKey,thePlayer in ipairs(liveplayers) do
					if isElement(thePlayer) then
						if (getElementData (thePlayer, "dangercount")) and (getElementData(thePlayer, "zombieProof") ~= true) and (getElementData(thePlayer, "alreadyspawned" ) == true) then
							if (getElementData (thePlayer, "dangercount") < lowestcount) then
								local safezone = 0
								local gx, gy, gz = getElementPosition( thePlayer )
								local allradars = getElementsByType("radararea")
								for theKey,theradar in ipairs(allradars) do
									if getElementData(theradar, "zombieProof") == true then
										if isInsideRadarArea ( theradar, gx, gy ) then
											safezone = 1
										end
									end
								end
								if safezone == 0 then
									lowestguy = thePlayer
									lowestcount = getElementData (thePlayer, "dangercount")
								end
							end
						end
					end
				end
				pacecount = pacecount+1
				if isElement(lowestguy) then
					triggerClientEvent ( "Spawn_Placement", lowestguy, ycoord, xcoord )
				else
					pacecount = pacecount+1
				end
			else
				pacecount = pacecount+1
			end
		else
			pacecount = pacecount+1
		end
	end
end

--SPAWNS ZOMBIES IN SPAWNPOINTS NEAR PLAYERS
function SpawnpointZombie ()
	local pacecount = 0
	while pacecount < 6 do	--5 ZOMBIES AT A TIME TO PREVENT FPS DROP
		if (table.getn( everyZombie )+pacecount < newZombieLimit ) and (ZombieStreaming == 2) then	
			local liveplayers = getAlivePlayers ()
			if (table.getn( liveplayers ) > 0 ) then
				local lowestcount = 99999
				local lowestguy = nil
				for PKey,thePlayer in ipairs(liveplayers) do --THIS PART GETS THE PLAYER WITH THE LEAST ZOMBIES ATTACKING
					if (getElementData (thePlayer, "dangercount")) and (getElementData(thePlayer, "zombieProof") ~= true) then
						if (getElementData (thePlayer, "dangercount") < lowestcount) then
							lowestguy = thePlayer
							lowestcount = getElementData (thePlayer, "dangercount")
						end
					end
				end
				if isElement(lowestguy) then
					local zombiespawns = { }
					local possiblezombies = getElementsByType ( "Zombie_spawn" )
					local Px, Py, Pz = getElementPosition( lowestguy )
					for ZombKey,theZomb in ipairs(possiblezombies) do
						local Zx, Zy, Zz = getElementPosition( theZomb )
						local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
						if (distance < 8) then
							table.remove( possiblezombies, ZombKey) --IF SPAWN IS TOO CLOSE TO ANY PLAYER
						end
					end
					local Px, Py, Pz = getElementPosition( lowestguy )
					for ZombKey2,theZomb2 in ipairs(possiblezombies) do
						local Zx, Zy, Zz = getElementPosition( theZomb2 )
						local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
						if (distance < 60) then --AS LONG AS THE SPAWN IS CLOSE ENOUGH TO A PLAYER
							table.insert( zombiespawns, theZomb2 )
						end
					end
					if (table.getn( zombiespawns ) >0 ) then--IF THE LOWEST PLAYER HAS ANY CLOSE SPAWNS,USE ONE
						local random = math.random ( 1, table.getn ( zombiespawns ) )
						local posX = getElementData(zombiespawns[random], "posX") 
						local posY = getElementData(zombiespawns[random], "posY") 
						local posZ = getElementData(zombiespawns[random], "posZ")
						local rot = getElementData(zombiespawns[random], "rotZ")
						pacecount = pacecount+1
						triggerEvent ( "onZombieSpawn",zombiespawns[random], posX, posY, posZ, rot )			
					else--IF THE LOWEST PLAYERS DOESNT HAVE ANY SPAWNS, THEN SEE IF ANYONE HAS ANY
						local zombiespawns = { }
						local possiblezombies = getElementsByType ( "Zombie_spawn" )
						local allplayers = getAlivePlayers ()
						for theKey,thePlayer in ipairs(allplayers) do
							local Px, Py, Pz = getElementPosition( thePlayer )
							for ZombKey,theZomb in ipairs(possiblezombies) do
								local Zx, Zy, Zz = getElementPosition( theZomb )
								local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
								if (distance < 8) then
									table.remove( possiblezombies, ZombKey) --IF SPAWN IS TOO CLOSE TO ANY PLAYER
								end
							end
						end
						for theKey,thePlayer in ipairs(allplayers) do
							local Px, Py, Pz = getElementPosition( thePlayer )
							for ZombKey2,theZomb2 in ipairs(possiblezombies) do
								local Zx, Zy, Zz = getElementPosition( theZomb2 )
								local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
								if (distance < 60) then --AS LONG AS THE SPAWN IS CLOSE ENOUGH TO A PLAYER
									table.insert( zombiespawns, theZomb2 )
								end
							end
						end
						if (table.getn( zombiespawns ) >1 ) then
							local random = math.random ( 1, table.getn ( zombiespawns ) )
							local posX = getElementData(zombiespawns[random], "posX") 
							local posY = getElementData(zombiespawns[random], "posY") 
							local posZ = getElementData(zombiespawns[random], "posZ")
							local rot = getElementData(zombiespawns[random], "rotZ")
							pacecount = pacecount+1
							triggerEvent ( "onZombieSpawn",zombiespawns[random], posX, posY, posZ, rot )			
						else
							pacecount = pacecount+1
						end
					end
				else
					pacecount = pacecount+1
				end
			else
				pacecount = pacecount+1
			end
		else
			pacecount = pacecount+1
		end
	end
end

--DELETES ZOMBIES THAT ARE TOO FAR FROM ANY PLAYERS TO KEEP THEM MORE CONCENTRATED WHILE STREAMING ZOMBIES
function clearFarZombies ()
	if newZombieLimit ~= false then
		local toofarzombies = { }
		local allplayers = getElementsByType ( "player" )
		for ZombKey,theZomb in ipairs(everyZombie) do
			if isElement(theZomb) then
				if (getElementData (theZomb, "zombie") == true) then
					far = 1
					local Zx, Zy, Zz = getElementPosition( theZomb )
					for theKey,thePlayer in ipairs(allplayers) do
						local Px, Py, Pz = getElementPosition( thePlayer )
						local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
						if (distance < 75) then
							far = 0
						end
					end
					if far == 1 then
						table.insert( toofarzombies, theZomb )
					end
				end
			else
				table.remove( everyZombie, ZombKey )
			end
		end
		if (table.getn( toofarzombies ) >1 ) then
			for ZombKey,theZomb in ipairs(toofarzombies) do
				if (getElementData (theZomb, "zombie") == true) and  ( getElementData ( theZomb, "forcedtoexist" ) ~= true) then
					Zomb_delete (theZomb)
				end
			end
		end
	end
end

-- DESTROYS UP TO 13 ZOMBIES THAT ARE IDLE WHEN A PLAYER SPAWNS (TO FORCE NEW ZOMBIES TO SPAWN NEAR THE NEW GUY)
function player_Spawn ()
	if ZombieStreaming == 1 or ZombieStreaming == 2 then
		local relocatecount = 0
		for ZombKey,theZomb in ipairs(everyZombie) do
			if relocatecount < 14 then
				if ( getElementData ( theZomb, "forcedtoexist" ) ~= true) then
					if ( getElementData ( theZomb, "status" ) == "idle" ) and ( isPedDead ( theZomb ) == false ) and (getElementData (theZomb, "zombie") == true) then
						relocatecount = relocatecount+1
						Zomb_delete (theZomb)
					end
				end
			end
		end
	end
	if ( getElementData ( source, "alreadyspawned" ) ~= true) then
		setElementData ( source, "alreadyspawned", true  )
	end
end
addEventHandler ( "onPlayerSpawn", getRootElement(), player_Spawn )

--EXPORTED FUNCTIONS!!!!!!!!!!!!!!
function createZombie ( x, y, z, rot, skin, interior, dimension )
	if (table.getn( everyZombie ) < newZombieLimit ) then
	--this part handles the args
		if not x then return false end
		if not y then return false end
		if not z then return false end
		if not rot then
			rot = math.random (1,359)
		end
		if not skin then
			randomZskin = math.random ( 1, table.getn ( ZombiePedSkins ) )			
			skin = ZombiePedSkins[randomZskin]
		end
		if not interior then interior = 0 end
		if not dimension then dimension = 0 end
	--this part spawns the ped
		local zomb = createPed (tonumber(skin),tonumber(x),tonumber(y),tonumber(z))--spawns the ped
	--if successful, this part applies the zombie settings/args
		if (zomb ~= false) then
			setTimer ( setElementInterior, 100, 1, zomb, tonumber(interior)) --sets interior
			setTimer ( setElementDimension, 100, 1, zomb, tonumber(dimension)) --sets dimension
			setElementData ( zomb, "zombie", true  )
			setElementData ( zomb, "forcedtoexist", true  )
			setTimer ( function (zomb, rot) if ( isElement ( zomb ) ) then setPedRotation ( zomb, rot ) end end, 500, 1, zomb, rot )
			setTimer ( function (zomb) if ( isElement ( zomb ) ) then setElementData ( zomb, "status", "idle" ) end end, 2000, 1, zomb )
			setTimer ( function (zomb) if ( isElement ( zomb ) ) then setElementData ( zomb, "forcedtoexist", true ) end end, 1000, 1, zomb )
			setTimer ( function (zomb) if ( isElement ( zomb ) ) then table.insert( everyZombie, zomb ) end end, 1000, 1, zomb )
			triggerClientEvent ( "Zomb_STFU", getRootElement(), zomb )
			return zomb --returns the zombie element
		else
			return false --returns false if there was a problem
		end
	else
		return false --returns false if there was a problem
	end
end

--check if a ped is a zombie or not
function isPedZombie(ped)
	if (isElement(ped)) then
		if (getElementData (ped, "zombie") == true) then
			return true
		else
			return false
		end
	else
		return false
	end
end

addEvent( "onZombieLostPlayer", true )
function ZombieTargetCoords ( x,y,z )
	setElementData ( source, "Tx", x, false )
	setElementData ( source, "Ty", y, false )
	setElementData ( source, "Tz", z, false )
end
addEventHandler( "onZombieLostPlayer", getRootElement(), ZombieTargetCoords )

function kickPlayerHandler( sourcePlayer, commandname, kickedname, reason )
	local kicked = getPlayerFromName( kickedname )
	
	if( hasObjectPermissionTo( sourceplayer, "function.kickPlayer" ) ) then
		kickPlayer( kicked, sourcePlayer, reason)
	end
end

addCommandHandler( "kick", kickPlayerHandler )