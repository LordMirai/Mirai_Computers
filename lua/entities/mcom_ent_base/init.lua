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

	self.damageLevel = 0
	self.faultTreshold = 5
	self.randomFaultChance = 0.001

	self.noCollideList = {
		[""] = true
	}

	self.serial = "COMP-0000000000" -- only placeholders. use generateSerial() to generate a serial
	self.mac = "XX-XX-XX-XX-XX-XX" -- use generateMAC() to generate a MAC address

	self:init()

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end
end

function ENT:Use(ply)
	if not self.canUse then return end
	if not MCom.canUse(ply,self) then return end

	self:onUse(ply)

	MCom.entUseCooldown(ply, ent)
end

function ENT:onUse(ply)

end

function ENT:init()
    -- any inits or overrides
end


function ENT:OnTakeDamage(dmgInfo)
	self:onDamaged(dmgInfo:GetAttacker(), dmgInfo:GetDamage())
end


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

function ENT:generateSerial() -- might be slightly slow, but it's only called once
	local serial = "COMP-" -- Computer prefix
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	for i = 1, 10 do
		serial = serial .. string.char(chars:byte(math.random(1, #chars))) -- random char from chars
	end
	self.serial = serial
end

function ENT:generateMAC(blockSize) -- default block size 2
	blockSize = blockSize or 2
	local mac = ""
	local chars = "ABCDEF0123456789"
	for i = 1, 6 do
		macBlock = ""
		for j = 1, blockSize do
			macBlock = macBlock .. string.char(chars:byte(math.random(1, #chars)))
		end
		mac = mac .. "-" .. macBlock
	end
	mac = string.sub(mac, 2) -- remove first dash
	self.mac = mac -- Will be a 6-block MAC address "XX-XX-XX-XX-XX-XX" by default
end