MCom = MCom or {}
MCom.net = MCom.net or {}

hook.Add("ShouldCollide", "", function(device, otherEnt)
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

print("sv_mcom.lua reloaded")