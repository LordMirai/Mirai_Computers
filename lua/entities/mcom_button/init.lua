AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:peripheralInit()
	local mdl = "" -- model here, some cube
	self:setup(mdl, "Button", false, "BTN")
	self.activateCount = 0
end

function ENT:behavior() -- attach this to onTick or other such thing to implement behavior. You can even put it in peripheralInit() to work independently

end

function ENT:onUse(ply)
	local ac = not self:GetActive()
	self:SetActive(ac) -- toggle active state
	MCom.Message(ply, "Button "..(ac and "activated" or "deactivated").."!")
	if ac then
		self.activateCount = self.activateCount + 1
	end
end

function ENT:setupPorts()
	-- set up the listen ports
	self:addPort({
		name = "Write out",
		read = false,
		port = 4,
		registers = {"M"}, -- write press count to M
		callback = function(self, portValue, regM)
			regM = self.activateCount
			self:writeRegister("M", regM)
		end,
	})
end

function ENT:onConnected(parent)
	print(self.serial,"Connected to parent: " .. tostring(parent.serial))
	self:SetColor(MCom.Colors.Orange) -- set the color to orange when connected
end

--[[ 
	behavior should function like this:
	input tester spawns black color
	input tester is connected to terminal and should turn orange
	terminal runs command "clock 2 1" which should switch input 2 between 0 and 1 every second
	this should make the input tester switch between red and green (or whatever regs K and L have) every second


]]