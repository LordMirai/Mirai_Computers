MCom = MCom or {}

hook.Add("ShouldCollide", "", function(device, otherEnt)
	if device.MComEntity then
        if device.noCollideList[otherEnt:GetClass()] then
            return false
        end
    end
end)

print("sv_mcom.lua reloaded")