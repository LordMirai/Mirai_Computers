AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:init()
	self:SetModel("models/props_office/computer_monitor04.mdl")
	self.isComputer = true
	self.isInUse = false

	self:generateSerial()
	self:generateMAC()

	self:SetState(MCom.ComputerState.OFF)

	self.targetEnts = {
		["player"] = true
	}

	self:scanSetup(1, 200, self.targetEnts, true) -- only tick for players, once per second, 200 range


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

end

local function fpin(pin)
	return tostring(math.Clamp(math.floor(pin or 0), 1, 10))
end

function ENT:getInput(pin) -- we check pin validity in the API or before this is called
	return self.Architecture.IO.Input["Pin"..fpin(pin)]
end

function ENT:setInput(pin, value)
	value = value or false
	self.Architecture.IO.Input["Pin"..fpin(pin)] = value
end

function ENT:getOutput(pin)
	return self.Architecture.IO.Output["Pin"..fpin(pin)]
end

function ENT:setOutput(pin, value)
	self.Architecture.IO.Output["Pin"..fpin(pin)] = value or false
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
	self:write("Y", lastErr.errorMessage)
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

function ENT:wait(ticks, callback, ...)
	local args = {...}
	ticks = math.Clamp(math.floor(ticks),0,300)
	local timeTowait = self.scanTime * ticks
	
	timer.Simple(timeTowait, function()
		callback(unpack(args))
	end)
end