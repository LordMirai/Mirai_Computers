AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:peripheralInit()
	local mdl = "models/Combine_Helicopter/helicopter_bomb01.mdl" -- model here, some cube
	self:setup(mdl, "Tester", false, "INTEST")

	self:SetColor(MCom.Colors.Black)
end

function ENT:behavior() -- attach this to onTick or other such thing to implement behavior. You can even put it in peripheralInit() to work independently

end

function ENT:setupPorts()
	-- set up the listen ports
	self:addPort({
		name = "Read input",
		read = true,
		port = 2,
		registers = {"K","L"}, -- read color from K,L
		callback = function(self, portValue, regK, regL)
			print(self.serial,"Read input: " .. tostring(portValue) .. " " .. tostring(regK) .. " " .. tostring(regL))
			local onColor = regK != 0 and regK or MCom.Colors.Green
			local offColor = regL != 0 and regL or MCom.Colors.Red
			self:SetColor(portValue and onColor or offColor) -- set the color by port and registers
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