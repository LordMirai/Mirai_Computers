AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:init()
	self:SetModel("models/props_office/computer_monitor04.mdl")
	self.isComputer = true
	self.isInUse = false

	self:generateSerial()
	self:generateMAC()
end

function ENT:onUse(ply)
	-- for now:
	MCom.Message(ply, self:info())
end

function ENT:StartTouch(otherEnt)
	-- peripheral connection
end

function ENT:OnRemove()
	-- remove connections
end

function ENT:info()
	return string.format("Computer serial: %s; MAC: %s",self.serial,self.mac)
end