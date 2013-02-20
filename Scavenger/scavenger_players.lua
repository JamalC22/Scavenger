addEvent("onZombieWasted", false)
addEvent("onPlayerHandshake", true)
addEvent("onAttemptRegister", true)
addEvent("onAttemptLogin", true)

PlayerSkins = 
{
	0,
	7,
	9,
	10,
	11,
	12,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
	21,
	23,
	24,
	25,
	26,
	27,
	28,
	29,
	30,
	31,
	32,
	33,
	34,
	35,
	36,
	37,
	38,
	39,
	40,
	41,
	43,
	44,
	45,
	46,
	47,
	38,
	49,
	50,
	51,
	52,
	53,
	54,
	55,
	57,
	58,
	59,
	60,
	61,
	62,
	63,
	64,
	66,
	68,
	69,
	71,
	72,
	73,
	75,
	76,
	77,
	78,
	79,
	80,
	81,
	82,
	83,
	84,
	85,
	86,
	87,
	88,
	89,
	90,
	91,
	93,
	94,
	95,
	96,
	98,
	99,
	100,
	283,
}

CameraSpawns =
{
	{
		sx = -425.1396484375,
		sy = 1227.748046875,
		sz = 30.504163742065, 
		tx = -545.6201171875,
		ty = 1201.0107421875,
		tz = 27.65991973877,
	},
	{
		sx = 2713.6640625,
		sy = 2489.2666015625,
		sz = 139.341064453125, 
		tx = -2398.6474609375,
		ty = 2215.0458984375,
		tz = 5.1165962219238,
	},
	{
		sx = 2148.0234375,
		sy = -948.2109375,
		sz = 92.0234375, 
		tx = 2129.79296875,
		ty = -855.2177734375,
		tz = 72.171875,
	},
	{
		sx = 2009.9389648438,
		sy = 389.84201049805,
		sz = 35.790599822998, 
		tx = -2009.9564208984,
		ty = 390.84060668945,
		tz = 35.740619659424,
	},
	---,,,,,
	{
		sx = 1921.2277832031,
		sy = 332.35418701172,
		sz = 34.307399749756, 
		tx = -1920.5026855469,
		ty = 332.85440063477,
		tz = 33.834156036377,
	},
}

LVSpawns = 
{
	{
		x = 1041.9091796875,
		y = 1027.4619140625,
		z = 11,
	},
	{
		x = 1704.466796875,
		y = 702.98046875,
		z = 10.8203125,
	},
	{
		x = 1715.2705078125,
		y = 2320.55859375,
		z = 10.8203125,
	},
}

LSSpawns = 
{
	{
		x = 596.681640625,
		y =  - 1243.056640625,
		z = 18.132949829102,
	},
	{
		x = 974.7734375,
		y =  - 1481.87890625,
		z = 13.573222160339,
	},
	{
		x = 651.80859375,
		y =  - 1652.49609375,
		z = 14.761287689209,
	},
}

SFSpawns = 
{
	{
		x =  - 2720.5791015625,
		y =  - 127.533203125,
		z = 4.3359375,
	},
	{
		x =  - 1916.65625,
		y = 279.349609375,
		z = 41.046875,
	},
	{
		x =  - 2027.4462890625,
		y =  - 100.87890625,
		z = 35.1640625,
	},
}

function player_Handshake(playerName)
	--Disable HUD
	showPlayerHudComponent(source, "clock", false)
	showPlayerHudComponent(source, "vehicle_name", false)
	showPlayerHudComponent(source, "radar", false)
	showPlayerHudComponent(source, "area_name", false)
	--Set Cameras
	local camera = CameraSpawns[math.random(table.getn(CameraSpawns))]
	fadeCamera(source, true, 5)
	setCameraMatrix(source, camera.sx, camera.sy, camera.sz, camera.tx, camera.ty, camera.tz)
	--Show register/login GUI
	if getAccount(playerName) then
		triggerClientEvent(source, "showLoginGUI", getRootElement(), true)
	else
		triggerClientEvent(source, "showLoginGUI", getRootElement(), false)
	end
end
addEventHandler("onPlayerHandshake", getRootElement(), player_Handshake)

function zombieKilled(killer, weapon, bodypart)	
	if bodypart == 9 then
		givePlayerMoney(killer, (math.random(5) * math.random(5) + 5) * 9)
	else
		givePlayerMoney(killer, math.random(5) * math.random(5) + 5)
	end
end
addEventHandler("onZombieWasted", getRootElement(), zombieKilled)

function onAttemptRegister(name, password)
	if not getAccount(name) then
		if addAccount(name, password) then
			triggerClientEvent(source, "showLoginGUI", getRootElement(), true)
		end
	end
end
addEventHandler("onAttemptRegister", getRootElement(), onAttemptRegister)

function onAttemptLogin(name, password)
	local accountRegistered = getAccount(name)
	if not accountRegistered then
		triggerClientEvent(source, "showLoginGUI", getRootElement(), false)
	else
		local account = getAccount(name, password)
		if account then
			logIn(source, account, password)
			loadPlayer(account)
			triggerClientEvent(source, "hideLoginGUI", getRootElement())
		else
			outputChatBox("Invalid password")
		end
	end
end
addEventHandler("onAttemptLogin", getRootElement(), onAttemptLogin)

function playerKilled(totalAmmo, killer, killerWeapon, bodypart)
	local x, y, z = getElementPosition(source)
	for index = 0, 12, 1 do	
		local weaponID = getPedWeapon(source, index)
		local weaponAmmo = getPedTotalAmmo(source, index)
		if weaponID and weaponAmmo then
			createPickup ( x + math.random(1.0, 3.0), y + math.random(1.0, 3.0), z, 2, weaponID, 100000, weaponAmmo)
		end
	end
	local playerMoney = getPlayerMoney(source)
	if playerMoney and playerMoney > 100 then
                local moneyTaken = playerMoney / 2
                if bodypart == 9 then
                    moneyTaken = moneyTaken * 2
                end
		takePlayerMoney(source, moneyTaken)
		if (killer) then	
			if getElementType(killer) == "player" then	
				givePlayerMoney(killer, moneyTaken)
			end
		end
	end
	setElementData(source, "model", PlayerSkins[math.random(table.getn(PlayerSkins))])
	finaliseSpawn(source)
end
addEventHandler("onPlayerWasted", getRootElement(), playerKilled)

function finaliseSpawn(x, y, z)	
	if x and y and z then	
		spawnPlayer(source, x, y, z)
	else
		local city = math.random(0, 2)
                local spawn = nil
		if city == 0 then	
			spawn = LVSpawns[math.random(table.getn(LVSpawns))]
		elseif city == 1 then	
			spawn = LSSpawns[math.random(table.getn(LSSpawns))]
		elseif city == 2 then	
			spawn = SFSpawns[math.random(table.getn(SFSpawns))]
		end
                spawnPlayer(source, spawn.x, spawn.y, spawn.z)
	end
	setElementModel(source, getElementData(source, "model"))
	fadeCamera(source, true)
	setCameraTarget(source, source)
end

function savePlayer()	
	local playeraccount = getPlayerAccount(source)
	if playeraccount and not
	isGuestAccount(playeraccount) then	
		local x,
		y,
		z = getElementPosition(source)
		setAccountData(playeraccount, "zombies.pX", x)
		setAccountData(playeraccount, "zombies.pY", y)
		setAccountData(playeraccount, "zombies.pZ", z)
		for index = 0, 12, 1 do	
			local weaponID = getPedWeapon(source, index)
			local weaponAmmo = getPedTotalAmmo(source, index)
			setAccountData(playeraccount, "zombies.weaponid" .. index, weaponID)
			setAccountData(playeraccount, "zombies.weaponammo" .. index, weaponAmmo)
		end
		local playerHealth = getElementHealth(source)
		if playerHealth then	
			setAccountData(playeraccount, "zombies.playerhealth", playerHealth)
		else
			setAccountData(playeraccount, "zombies.playerhealth", 1)
		end
		local playerMoney = getPlayerMoney(source)
		if (playerMoney) then	
			setAccountData(playeraccount, "zombies.playermoney", playerMoney)
		else
			setAccountData(playeraccount, "zombies.playermoney", 0)
		end
		local playerKillCount = getElementData(source, "Zombie kills")
		if playerKillCount then	
			setAccountData(playeraccount, "zombies.killcount", playerKillCount)
		else
			setAccountData(playeraccount, "zombies.killcount", 0)
		end
		local playerModel = getElementData(source, "model")
		if playerModel then	
			setAccountData(playeraccount, "zombies.playermodel", playerModel)
		else
			setAccountData(playeraccount, "zombies.playermodel", 7)
		end
	end
	logOut(source)
end
addEventHandler("onPlayerQuit", getRootElement(), savePlayer)

function loadPlayer(account)	
	if account then	
		local player = getAccountPlayer(account)
		if player then	
			local playerKillCount = getAccountData(account, "zombies.killcount")
			local playerModel = getAccountData(account, "zombies.playermodel")
			if (playerModel) then	
				setElementData(player, "model", playerModel)
			else
				setElementData(player, "model", PlayerSkins[math.random(table.getn(PlayerSkins))])
			end
			local x = getAccountData(account, "zombies.pX")
			local y = getAccountData(account, "zombies.pY")
			local z = getAccountData(account, "zombies.pZ")
			if x and y and z then	
				finaliseSpawn(x, y, z + 2)
			else
				finaliseSpawn()
			end
			for index = 0, 12, 1 do	
				local weaponID = getAccountData(account, "zombies.weaponid" .. index)
				local weaponAmmo = getAccountData(account, "zombies.weaponammo" .. index)
				if weaponAmmo and weaponAmmo > 0 then	
					giveWeapon(player, weaponID, weaponAmmo)
				end
			end
			local playerHealth = getAccountData(account, "zombies.playerhealth")
			if (playerHealth) then	
				setElementHealth(player, playerHealth)
			end
			local playerMoney = getAccountData(account, "zombies.playermoney")
			if (playerMoney) then	
				setPlayerMoney(player, playerMoney)
			end
		end
	end
end