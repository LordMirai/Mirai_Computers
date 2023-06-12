AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/metal_tubex2.mdl") -- set model here
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	self.isComputer = true
	self.canUse = true
	self.isInUse = false

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end

	self:generateSerial()
	self:generateMAC()
end

function ENT:Use(ply)
	if not self.canUse then return end

	
end


-- function ENT:OnTakeDamage(dmgInfo)

-- end


-- hook.Add("ShouldCollide", "", function(scp, ent)
	
-- end)

function ENT:StartTouch(otherEnt)

end

function ENT:OnRemove()
	-- remove connections
end