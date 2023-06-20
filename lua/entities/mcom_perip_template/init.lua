AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:peripheralInit() -- ovr peripheral_base
	-- override. Should use :setup() here
	local mdl = "" -- model here
	self:setup(mdl, "the type", false, "TTP")
end

function ENT:behavior() -- attach this to onTick or other such thing to implement behavior. You can even put it in peripheralInit() to work independently

end

function ENT:onConnected(parent)
	-- ovr
end