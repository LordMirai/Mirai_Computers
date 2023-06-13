AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:init()
	self:SetModel("models/props_phx/construct/metal_tubex2.mdl") -- set model here

	self.isPeripheral = true
	self.isInUse = false
	self.peripheralType = "TBD"

	self:generateSerial()
	self:generateMAC()
end