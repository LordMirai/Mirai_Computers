AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/metal_tubex2.mdl") -- set model here
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

    self.MComEntity = true
	self.useCooldown = 0.5
	self.canUse = true
	
	self.scanTime = 1 -- time between scans (also referred to as tick period). tick rate = 1 / scanTime
	self.shouldScan = false -- set to true to start scanning
	self.scanRange = 300

	self.whitelist = false -- set to true to only scan for ents in the ignoredEnts table
	self.blacklist = true -- make sure these two never coincide
	self.ignoredEnts = { -- ignored entities for scan
		["brush"] = true,
	}

	self.damageLevel = 0
	self.faultTreshold = 5
	self.randomFaultChance = 0.001

	self.noCollideList = {
		[""] = true
	}

	self.serial = "ENT-0000000000" -- only placeholders. use generateSerial() to generate a serial
	self.mac = "XX-XX-XX-XX-XX-XX" -- use generateMAC() to generate a MAC address

	self.name = "MCom_unnamed_device"
	
	self:init()
	self:PhysicsInit(SOLID_VPHYSICS) -- set here to adjust for model change

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end

	self:startScan()
end

function ENT:Use(ply)
	if not self.canUse then return end
	if not MCom.canUse(ply,self) then return end

	self:onUse(ply)

	MCom.entUseCooldown(ply, self)
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
	local serial = (self.prefix or "MCOM") .. "-" -- Computer prefix
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	for i = 1, 10 do
		serial = serial .. string.char(chars:byte(math.random(1, #chars))) -- random char from chars
	end
	self.serial = serial
	self:SetSerial(serial)
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
	self:SetMAC(mac)
end

function ENT:startScan() -- tick
	if not self.shouldScan then return end
	timer.Simple(self.scanTime, function()
		if not self.shouldScan then return end
		if not IsValid(self) then return end
		self:scan()
		self:startScan() -- repeat
	end)
end

function ENT:scan() -- get all valid ents and call scanCallback on them
	self:tick()
	local ents = ents.FindInSphere(self:GetPos(), self.scanRange)
	for k, ent in pairs(ents) do
		if ent.MComEntity and ent ~= self then
			if self.whitelist and not self.ignoredEnts[ent:GetClass()] then continue end
			if self.blacklist and self.ignoredEnts[ent:GetClass()] then continue end
			self:scanCallback(ent)
		end
	end
end

function ENT:tick()
	-- global tick
end

function ENT:scanCallback(ent)
	-- scan action on ent(s)
end

function ENT:enableScan()
	self.shouldScan = true
	self:startScan()
end

function ENT:disableScan()
	self.shouldScan = false
end

function ENT:scanSetup(scanTime, scanRange, ignoredEnts, useWhitelist) -- put this in init()
	useWhitelist = useWhitelist or false
	self.shouldScan = true
	self.scanTime = math.Clamp((scanTime or 1), 0.1, 300)
	self.scanRange = math.Clamp((scanRange or 300), 0, 10000)
	self.whitelist = useWhitelist
	self.blacklist = not useWhitelist
	self.ignoredEnts = ignoredEnts or {}
end

function ENT:getSerial()
	return self.serial
end

function ENT:getMAC()
	return self.mac
end

function ENT:getMac() -- alias
	return self:getMAC()
end

function ENT:setName(name) -- ? "Pretty" name, you'd have my_device_123
	if not isstring(name) then return end
	name = string.Trim(name)
	if name == "" then return end
	self.name = name
end

function ENT:getName()
	return self.name or "MCom_unnamed_device"
end

function ENT:configure(ply)
	MCom.Message(ply,"Entity not configurable.", MCom.Colors.Warning)
end