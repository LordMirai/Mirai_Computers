SWEP.Base = "weapon_base"
SWEP.Category = "Mirai Computer System"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.PrintName = "Mirai Computers connect tool"
SWEP.Author = "Lord Mirai (未来)"
SWEP.Instructions = "Click to use"
SWEP.Contact = "lordmiraithegod@gmail.com | Lord Mirai(未来)#0039"

SWEP.Slot = 0
SWEP.SlotPos = 20
SWEP.DrawCrosshair = true
SWEP.Weight = 501

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.ViewModel = "" -- some wrench, must be a viewmodel
SWEP.WorldModel = ""

SWEP.Cooldown = 0.6 -- cooldown for clicking

SWEP.Primary.Sound = "buttons/blip1.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize  = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

MCom = MCom or {}

function SWEP:Initialize()
	self:SetHoldType("pistol")

	self.CanReload = true
	self.CanFire1 = true
	self.CanFire2 = true

	self.hasFirst = false
	self.firstEnt = nil

	self.messageGiven = false
end

function SWEP:Deploy()
	if SERVER then
		if not self.messageGiven then
			self.messageGiven = true
			MCom.Message(self:GetOwner(), "This tool is used to connect computers to peripherals. Left click to select a computer or peripheral, then right click to select a port. Reload to reset")
		end				
	end

	return true
end

function SWEP:Reload()
	if self.CanReload then
		if SERVER then
			self:reset(true)
		end
		self.CanReload = false
		timer.Simple(self.Cooldown, function() self.CanReload = true end)
	end
end

function SWEP:CanPrimaryAttack()
    return self.CanFire1 or false
end
function SWEP:CanSecondaryAttack()
	return self.CanFire2 or false
end

function SWEP:PrimaryAttack()
	if self.CanFire1 then
		self:primary()
	end
	self.CanFire1 = false
	timer.Simple(self.Cooldown, function() self.CanFire1 = true end)
end

function SWEP:SecondaryAttack()
	if self.CanFire2 then
		self:secondary()
	end
	self.CanFire2 = false
	timer.Simple(self.Cooldown, function() self.CanFire2 = true end)
end

function SWEP:primary() -- for now, we'll only handle connecting peripheral to computer
	if SERVER then
		local ply = self:GetOwner()

		local ent = ply:GetEyeTrace().Entity
		if not IsValid(ent) then
			MCom.Message(ply, "You must be looking at a valid entity!")
			return
		end

		if not ent.MComEntity then
			MCom.Message(ply, "This entity is not a Mirai Computers Entity!")
			return
		end

		if self.hasFirst then -- try to make the connection
			if self.firstEnt == ent then
				MCom.Message(ply, "You cannot connect an entity to itself!")
				return
			end

			local comp = self.firstEnt.isComputer and self.firstEnt or ent.isComputer and ent or nil
			if not comp then
				MCom.Message(ply, "You must connect a computer to a peripheral!")
				self:reset()
				return
			end

			local periph = self.firstEnt.isPeripheral and self.firstEnt or ent.isPeripheral and ent or nil

			if not periph then
				MCom.Message(ply, "You must connect a computer to a peripheral!")
				self:reset()
				return
			end

			if comp:isConnected(periph) then
				MCom.Message(ply, "These entities are already connected!")
				self:reset()
				return
			end

			comp:connectPeripheral(periph) -- later, we'll make a GUI for selecting which port for each entry
			
			MCom.Message(ply, "Successfully connected entities!")
			self:reset()
		else
			if ent.isComputer then
				self.firstEnt = ent
				self.hasFirst = true
				MCom.Message(ply, "Successfully selected computer! Right click to select port.")
				return
			end

			if ent.isPeripheral then
				self.firstEnt = ent
				self.hasFirst = true
				MCom.Message(ply, "Successfully selected peripheral! Right click to select port.")
				return
			end

			MCom.Message(ply, "You must select a computer or peripheral!")
		end
	end
end

function SWEP:secondary()
	if SERVER then
		local ply = self:GetOwner()

		-- menu to select port
		-- MCom.portMenu(ply, self.firstEnt)
	end
end

function ENT:reset(manual)
	if SERVER then
		manual = manual or false
		self.hasFirst = false
		self.firstEnt = nil
		print("tool reset")
		if manual then
			MCom.Message(self:GetOwner(), "Tool successfully reset!")
		end
	end
end