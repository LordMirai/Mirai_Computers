AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:init()
	self:SetModel("models/props_office/computer_monitor04.mdl") -- change to tower instead of monitor
	self.isComputer = true
	self.isTerminal = true -- alias for isComputer
	self.isInUse = false

	self.prefix = "COMP"

	self:generateSerial()
	self:generateMAC()

	self:SetState(MCom.ComputerState.OFF)

	self.targetEnts = {
		-- ["player"] = true
	}

	self:scanSetup(1, 200, self.targetEnts, false) -- tick for everything


	self.Architecture = { -- to hold Registers and Memory
		Registers = { -- initialize 26 general registers and a tick counter. This will very likely not be used too much tho
			["TC"] = 0, -- tick counter, technically "for how long was this computer active"
			["A"] = 0, -- general purpose registers, 0 init but can be anything
			["B"] = 0,
			["C"] = 0,
			["D"] = 0,
			["E"] = 0,
			["F"] = 0,
			["G"] = 0,
			["H"] = 0,
			["I"] = 0,
			["J"] = 0,
			["K"] = 0,
			["L"] = 0,
			["M"] = 0,
			["N"] = 0,
			["O"] = 0,
			["P"] = 0,
			["Q"] = 0,
			["R"] = 0,
			["S"] = 0,
			["T"] = 0,
			["U"] = 0,
			["V"] = 0,
			["W"] = 0,
			["X"] = 0, -- last error
			["Y"] = 0, -- error message
			["Z"] = 0 -- err categ
		},
		Memory = {
			["RAM"] = {},
			["ROM"] = {}
		},
		IO = { -- for API or peripherals to use
			Input = {
				["Pin1"] = nil,
				["Pin2"] = nil,
				["Pin3"] = nil,
				["Pin4"] = nil,
				["Pin5"] = nil,
				["Pin6"] = nil,
				["Pin7"] = nil,
				["Pin8"] = nil,
				["Pin9"] = nil,
				["Pin10"] = nil
			},
			Output = {
				["Pin1"] = false,
				["Pin2"] = false,
				["Pin3"] = false,
				["Pin4"] = false,
				["Pin5"] = false,
				["Pin6"] = false,
				["Pin7"] = false,
				["Pin8"] = false,
				["Pin9"] = false,
				["Pin10"] = false
			}
		}
	}

	self.Ports = { -- 10 ports for peripherals to use
		["Port1"] = nil,
		["Port2"] = nil,
		["Port3"] = nil,
		["Port4"] = nil,
		["Port5"] = nil,
		["Port6"] = nil,
		["Port7"] = nil,
		["Port8"] = nil,
		["Port9"] = nil,
		["Port10"] = nil
	}
	self.portCount = 10

end

local function fpin(pin)
	return tostring(math.Clamp(math.floor(toumber(pin) or 0), 1, 10))
end

local function fport(port) -- individual functions in case I want to change the format or count later
	return tostring(math.Clamp(math.floor(toumber(port) or 0), 1, 10))
end

local fportstr(pin) -- "format port as string"
	return "Port"..fport(pin)
end

function ENT:getInput(pin) -- we check pin validity in the API or before this is called
	return self.Architecture.IO.Input["Pin"..fpin(pin)]
end

function ENT:setInput(pin, value) -- shouldn't be used by the computer itself
	value = value or false
	self.Architecture.IO.Input["Pin"..fpin(pin)] = value
end

function ENT:getOutput(pin)
	return self.Architecture.IO.Output["Pin"..fpin(pin)]
end

function ENT:setOutput(pin, value)
	self.Architecture.IO.Output["Pin"..fpin(pin)] = value or false
	hook.Run("ComputerPortChange", self, pin, value) -- hook for peripherals to use
end

function ENT:toggleOutput(pin)
	self:setOutput(pin, not self:getOutput(pin))
end

function ENT:write(register, value)
	register = string.upper(register)
	if not self.Architecture.Registers[register] then return end
	self.Architecture.Registers[register] = value or false
end

function ENT:read(register)
	return self.Architecture.Registers[string.upper(register)] or 0
end

function ENT:incTC()
	self:write("TC", self:read("TC") + 1)
end



function ENT:onUse(ply)
	-- for now:
	MCom.Message(ply, self:info())
	if not self:GetUser():IsValid() then
		self:endUse() -- if the user is not valid, then the computer is not in use
	end
	if self.isInUse and ply != self:GetUser() then
		MCom.Message(ply, "This computer is already in use by "..self:GetUser():Nick())
		return
	end
	self.isInUse = true
	self:SetUser(ply)

	MCom.net.computerMenu(ply, self)
end

function ENT:endUse()
	if self:GetUser():IsValid() then
		MCom.Message(self:GetUser(), "You have stopped using the computer")
	end
	self.isInUse = false
	self:SetUser(nil)
end

function ENT:StartTouch(otherEnt)
	-- peripheral connection
end

function ENT:OnRemove()
	-- remove connections
end

function ENT:info()
	return string.format("Computer serial: %s; MAC: %s", self.serial, self.mac)
end

function ENT:executeCommand(user, cmd)
	print(user,"Executed command",cmd)
	MCom.Interpreter.executeCommand(user, self, cmd)
	local lastErr = MCom.getLastError()
	self:write("X", lastErr.errorCode)
	self:write("Y", lastErr.errorMessage or "")
	self:write("Z", lastErr.category)

	hook.Run("OnCommandExecuted", user, self, cmd)
end

function ENT:output(msg)
	-- for now, we'll print this to user's chat. We will later add a screen entity or other monitor/display system

	if self:GetUser():IsValid() then
		MCom.Message(self:GetUser(), string.format("Computer output: %s", msg))
	end
end

function ENT:scanCallback(ply)
	MCom.Message(ply, self.serial .. " Tick")
end

function ENT:tick()
	self:incTC() -- increment tick counter
end

function ENT:selectPort()
	for i in 1,self.portCount do
		if not self.Ports[fportstr(i)] then
			return fportstr(i) -- return the first available port
		end
	end
	return nil -- no ports available
end

function ENT:wait(ticks, callback, ...)
	local args = {...}
	ticks = math.Clamp(math.floor(ticks),0,300)
	local timeTowait = self.scanTime * ticks
	
	timer.Simple(timeTowait, function()
		if not self:IsValid() then return end -- if the computer is removed, don't execute the callback
		callback(unpack(args))
	end)
end

function ENT:peripheralConnected(perip)

end

function ENT:connectPeripheral(perip, port)
	if not perip or not perip:IsValid() then return end
	if not port then port = self:selectPort() end
	if tostring(tonumber(port)) == port then -- if port is a number, convert it to a string
		port = fportstr(port)
	end
	if not self.Ports[port] then return end
	if self.Ports[port]:IsValid() then return end

	self.Ports[port] = perip
	perip:SetParent(self)
	perip:SetPort(port)
	self:peripheralConnected(perip)
end

function ENT:poll() -- check all connected peripherals and disconnect if invalid
	for i in 1,self.portCount do
		local port = fportstr(i)
		if not self.Ports[port] or not self.Ports[port]:IsValid() then
			self.Ports[port] = nil
		end
	end
end

function ENT:tick() -- ovr computer tick
	hook.Run("ComputerTick", self)
end

function ENT:isConnected(ent)
	for i in 1,self.portCount do
		local port = fportstr(i)
		if self.Ports[port] == ent then
			return true
		end
	end
	return false
end