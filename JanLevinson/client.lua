exports("ServerRoles",function()
	return {config.CommunityGuides, config.RoleplayLeaders, config.Legends}
end)


local enteredCars = {}
local kickWarnMsg = ""


-- Anti Heli Crash

RegisterNetEvent('mvtwantirdm:helicrash')
AddEventHandler('mvtwantirdm:helicrash', function()
 	
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, true)
    local vehicle_type = GetVehicleClass(vehicle)

	if vehicle_type == 15 then
		 TriggerServerEvent('mvtwantirdm:kickplayer', GetPlayerServerId(PlayerId()) , config.heliCrashKickMessage)
	end

end)


-- Anti RDM

local badKillCount = 0

local lkY, lkM, lkD, lkH, lkMo, lkS = GetPosixTime()
local lastKillTime = lkMo + lkS
local thisKillTime = lkMo + lkS

print (thisKillTime - lastKillTime)

RegisterNetEvent('mvtwantirdm:logkill')
AddEventHandler('mvtwantirdm:logkill', function(time)

	local prevKillTime = lastKillTime
	
	local lktY, lktM, lktD, lktH, lktMo, lktS = GetPosixTime()
	local thisKillTime = lktMo + lktS
	lastKillTime = thisKillTime

	print(badKillCount .. "Kill Alert")

	if thisKillTime - prevKillTime < 30  then
		badKillCount += 1
		print(badKillCount .. "Kill Alert")
	else
		badKillCount = 0
	end

	if badKillCount > 3 then
		TriggerServerEvent('mvtwantirdm:kickplayer', GetPlayerServerId(PlayerId()), config.kickMessageRDM)
	end


end)

CreateThread(function()
	local DeathReason, Killer, DeathCauseHash, Weapon
	while true do
		Wait(0)
		if IsEntityDead(PlayerPedId()) then
			Wait(0)
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			local killername = GetPlayerName(PedKiller)
			
			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end

			TriggerServerEvent('mvtwantirdm:playerDied',  GetPlayerServerId(Killer) )

			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
			Weapon = nil
		end
		while IsEntityDead(PlayerPedId()) do
			Wait(0)
		end
	end
end)


local shotsFired = 0
local scY, scM, scD, scH, scMo, scS = GetPosixTime()

 --Gunshot detection
Citizen.CreateThread( function()
    while true do
        Wait(1000)

      local ped = PlayerPedId()
	  local weaponUsed = GetSelectedPedWeapon(ped)
	  
	  if IsPedShooting(ped) and weaponUsed ~= GetHashKey("weapon_petrolcan") and weaponUsed ~= GetHashKey("weapon_fireextinguisher") and weaponUsed ~= GetHashKey("weapon_unarmed") then
		shotsFired += 1
		scY, scM, scD, scH, scM, scS = GetPosixTime()
      end     

		local sctY, sctM, sctD, sctH, sctMo, sctS = GetPosixTime()

		if sctMo - scMo >= 3 then
			shotsFired = 0
			kickWarnMsg = ""
		end

		if shotsFired > 5 then
			kickWarnMsg = "KICK ALERT"
		end

	 if shotsFired > 20 then
		TriggerServerEvent('mvtwantirdm:kickplayer', GetPlayerServerId(PlayerId()) , config.rateLimitShooting )
	 end
	 
	end
end)


RegisterNetEvent('mvtwantirdm:resetGunCount')
AddEventHandler('mvtwantirdm:resetGunCount', function(source)
	shotsFired = 0
	ShowNotification("Your shooting rate limiter has been reset.")
end)




function ShowNotification( text )
	SetNotificationTextEntry( "STRING" )
	AddTextComponentString( text )
	DrawNotification( false, false )
end


Citizen.CreateThread(function()
    local _string = "STRING"
    local _scale = 0.42
    local _font = 4 
    
    while true do
            SetTextScale(_scale, _scale)
            SetTextColour(255, 0, 0,255)
            SetTextFont(_font)
            SetTextOutline()
            BeginTextCommandDisplayText(_string)
            AddTextComponentSubstringPlayerName(kickWarnMsg)
            EndTextCommandDisplayText(config.textPosX, config.textPosY)
        Wait(0)
    end
end)