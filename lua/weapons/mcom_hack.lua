SWEP.Base = "weapon_base"
SWEP.Category = "Mirai Computer System"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.PrintName = "Interference Unit"
SWEP.Author = "Lord Mirai (未来)"
SWEP.Instructions = "Click on a device to use"
SWEP.Contact = "lordmiraithegod@gmail.com | Lord Mirai(未来)#0039"

SWEP.Slot = 0
SWEP.SlotPos = 20
SWEP.DrawCrosshair = true
SWEP.Weight = 501

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.ViewModel = "" -- some fancy thingy
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
end

function SWEP:Reload()
	if self.CanReload then
		if SERVER then
			-- do things
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
		-- do things
	end
	self.CanFire1 = false
	timer.Simple(self.Cooldown, function() self.CanFire1 = true end)
end

function SWEP:SecondaryAttack()
	if self.CanFire2 then
		-- do things
	end
	self.CanFire2 = false
	timer.Simple(self.Cooldown, function() self.CanFire2 = true end)
end
