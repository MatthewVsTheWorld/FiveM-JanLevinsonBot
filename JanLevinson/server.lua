
AddEventHandler('explosionEvent', function(source, ev)
    TriggerClientEvent("mvtwantirdm:helicrash",source)
end)

RegisterServerEvent('mvtwantirdm:playerDied')
AddEventHandler('mvtwantirdm:playerDied',function(killer)
	TriggerClientEvent("mvtwantirdm:logkill", killer, os.time())
end)



RegisterServerEvent('mvtwantirdm:kickplayer')
AddEventHandler('mvtwantirdm:kickplayer', function(target, message)

    DropPlayer(target,message)

end)

exports("ServerRoles",function()
	return {config.CommunityGuides, config.RoleplayLeaders, config.Legends}
end)

RegisterCommand('resetgc', function(source,args)

    local player = GetPlayerIdentifiers(source)[1]

    if has_value(config.RoleplayLeaders, player) or has_value(config.CommunityGuides, player) then
	    TriggerClientEvent("mvtwantirdm:resetGunCount",source, args[1])
    end

end)


function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end