MCom = MCom or {}
MCom.net = MCom.net or {}

hook.Add("ShouldCollide", "MCom_deviceCollision", function(device, otherEnt)
	if device.MComEntity then
        if device.noCollideList[otherEnt:GetClass()] then
            return false
        end
    end
end)

function MCom.openMenu(ply)
    if not ply:IsAdmin() then
        MCom.Warning(ply, "This command is admin only.")
        return
    end

    MCom.net.openMenu(ply)
end

function MCom.deregisterUse(ply)
    for k,v in pairs(MCom.getComputers()) do
        if v:GetUser() == ply then
            v:endUse() -- set unused on all terminals
            -- break -- if we want players to only use one entity, use this
        end
    end

    -- if viable, remove player entities as well
end

hook.Add("PlayerDeath","MCom_unuseDeath", function(ply)
    MCom.deregisterUse(ply)
end)

hook.Add("PlayerDisconnected", "MCom_unuseDisconnect", function(ply)
    MCom.deregisterUse(ply)
end)




print("sv_mcom.lua reloaded")