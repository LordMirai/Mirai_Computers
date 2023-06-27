AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:init()
	self:SetModel("models/props/cs_office/computer_case.mdl") -- change to tower instead of monitor
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

	self.wrappedPeripherals = {} -- peripherals bound by name

end

local function fpin(pin)
	return tostring(math.Clamp(math.floor(tonumber(pin) or 0), 1, 10))
end

local function fport(port) -- individual functions in case I want to change the format or count later
	return tostring(math.Clamp(math.floor(tonumber(port) or 0), 1, 10))
end

local function fportstr(pin) -- "format port as string"
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

function ENT:write(register, value, allowTC) -- allowTC is for the tick counter, which should not be written to by peripherals
	allowTC = allowTC or true
	register = string.upper(register)
	if not self.Architecture.Registers[register] then return false end
	if register == "TC" and not allowTC then return false end
	if value == nil then return false end -- ! NEVER EVER set a register to nil, it will remove it and make it unrecoverable
	self.Architecture.Registers[register] = value or 0
	return true -- returns true if successful, false if not
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
	for i = 1,self.portCount do
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
	-- make a physical connection, through a wire or something
	-- also make a sound for it
	perip:onConnected(self)
end

function ENT:connectPeripheral(perip, port)
	if not perip or not perip:IsValid() then return end
	if not port then port = self:selectPort() end
	if tostring(tonumber(port)) == port then -- if port is a number, convert it to a string
		port = fportstr(port)
	end
	print("Connecting peripheral to port ",port)
	
	self.Ports[port] = perip
	perip.parent = self
	perip:SetPort(port)
	self:peripheralConnected(perip)
end

function ENT:poll() -- check all connected peripherals and disconnect if invalid
	for i = 1,self.portCount do
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
	PrintTable(self.Ports)
	for i = 1,self.portCount do
		local port = fportstr(i)
		if self.Ports[port] == ent then
			print("yes is connected")
			return true
		end
	end
	print("no is not connected")
	return false
end

function ENT:clearRegisters()
	for k,v in pairs(self.Architecture.Registers) do
		self:write(k, 0)
	end
end

function ENT:shutdown()
	self:output("System shut down.")
	self:clearRegisters()
end

function ENT:startup()
	self:output("System started up.")
end

function ENT:getPeripheral(criteria)
	-- ? criteria can be: perip name, serial, MAC or origin register letter. Returns the entity or nil if not found
	if not criteria then return end
	if isstring(criteria) then
		-- if criteria from A-Z
		if string.match(criteria, "[A-Z]") then
			local entry = self:read(criteria)
			if entry and isentity(entry) and entry:IsValid() and entry.isPeripheral then
				return entry
			end
		end

		if self.wrappedPeripherals[string.lower(criteria)] then
			return self.wrappedPeripherals[string.lower(criteria)]
		end

		for i = 1,self.portCount do
			local enry = self.Ports[fportstr(i)]
			if entry and entry:IsValid() then
				if entry:getName() == criteria or entry:getSerial() == criteria or entry:getMAC() == criteria then
					return entry
				end
			end
		end
	elseif isentity(criteria) then
		if criteria.isPeripheral then
			for i = 1,self.portCount do
				local entry = self.Ports[fportstr(i)]
				if entry and entry:IsValid() then
					if entry == criteria then
						return entry
					end
				end
			end
		end
	end
end

function ENT:getPeripherals()
	local periphs = {}
	for i = 1,self.portCount do
		local port = fportstr(i)
		local entry = self.Ports[port]
		if entry and entry:IsValid() then
			table.insert(periphs, entry)
		end
	end
	return periphs
end

function ENT:wrap(peripheral,name)
	name = string.Trim(string.lower(name))
	if name == "" then return end
	self.wrappedPeripherals[name] = peripheral
	return true
end
