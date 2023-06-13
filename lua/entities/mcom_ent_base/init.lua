AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/metal_tubex2.mdl") -- set model here
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

    self.MComEntity = true
	self.useCooldown = 0.5

	self:init()

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end
	
end

function ENT:Use(ply)
	if not self.canUse then return end
	if not MCom.canUse(ply,self) then return end
end

function ENT:init()

end


function ENT:OnTakeDamage(dmgInfo)
	self:onDamaged(dmgInfo:GetAttacker(), dmgInfo:GetDamage())
end


-- hook.Add("ShouldCollide", "", function(scp, ent)
	
-- end)

function ENT:StartTouch(otherEnt)

end

function ENT:OnRemove()
	-- remove connections
end

function ENT:makeSound(snd, pitchVar)
	local pitch = math.random(100 - pitchVar, 100 + pitchVar)
	self:EmitSound(snd, 100, pitchVar)
end

function ENT:onDamaged(source, dmg)
	-- override
end
