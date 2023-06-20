AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:init() -- ovr ent_base

	self.isPeripheral = true
	self.isInUse = false
	self:SetType("TBD")

	self:peripheralInit()
	
	self:generateSerial()
	self:generateMAC()
	self.parent = nil

	--[[
		Peripherals should communicate with the computer via the computer's IO ports and registers
		Therefore, we'll need "IO listen ports". Not to confuse with the port that the peripheral is connected to.
	]]

	self.Ports = {}

	self:setupPorts()

	hook.Add("ComputerTick", self.serial, function(ent)
		if not IsValid(self.parent) then return end
		if ent == self.parent then
			self:onTick()
		end
	end)
end

function ENT:peripheralInit()
	-- override. Should use :setup() here
end

function ENT:setup(model, type, initState, prefix)
	self:SetModel(model or "")
	self:SetType(type or "Peripheral")
	self:SetActive(initState or false)
	self.prefix = prefix or "PERIP"
end

function ENT:connect(ent, port)
	if ent.isComputer then
		self.parent = ent
		self:SetPort(port)
	end

	self:onConnected(ent)
end

function ENT:setupPorts()
	-- set up the listen ports
	local portTemplate = {
		name = "Should Activate",
		read = true, -- false if port is for write
		port = 5, -- parent output port 5
		registers = {"A", "B", "C"}, -- registers to read from. if read is false, registers to write to
		callback = function(self, portValue, regA, regB, regC) -- callback function
			-- portValue is the value of the port
			-- manually write registers here
		end,
	}

	self:addPort(portTemplate)
end

function ENT:addPort(portTable)
	print("Port added")
	PrintTable(portTable)
	table.insert(self.Ports, portTable)
	-- callback on port change
	local id = self.serial..portTable.port

	if portTable.read then
		hook.Add("ComputerPortChange", id, function(ent, port, val)
			if ent == self.parent then
				print(port,portTable.port,port == portTable.port)
				if tonumber(port) == tonumber(portTable.port) then
					print("call on input")
					self:onInput(portTable, val)
				end
			end
		end)
	else
		hook.Add("PeripheralPortChange", id, function(ent, port, val)
			if ent == self.parent then
				if port == portTable.port then
					self:onOutput(portTable, val)
				end
			end
		end)
	end
end

function ENT:onInput(port, val) -- basically an event listener
	if not self.parent then return end
	-- any overrides are acceptable
	local regs = self.parent.Architecture.Registers
	local regValues = {}
	for k, v in pairs(port.registers) do
		regValues[v] = regs[v] or 0
	end
	port.callback(self, val, unpack(regValues))
end

function ENT:onOutput(port,val) -- only write pin value here, regs written in callback
	self.parent:setInput(port.port, val)
end


function ENT:onTick() -- Called every parent tick
	
end

function ENT:setOutputPin(pin, val)
	if not self.parent then return end
	hook.Run("PeripheralPortChange", self.parent, pin, val)
end

function ENT:onConnected(parent)
	-- ovr
end

function ENT:writeRegister(reg, val)
	if not self.parent then return end
	self.parent:write(val)
end