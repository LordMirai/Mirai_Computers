AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:init()
	self:SetModel("models/props_office/computer_monitor04.mdl")
	self.isComputer = true
	self.isInUse = false

	self:generateSerial()
	self:generateMAC()

	self.targetEnts = {
		["player"] = true
	}

	self:scanSetup(3, 200, self.targetEnts, true) -- only tick for players, once per 3 seconds, 200 range


	self.Architecture = { -- to hold Registers and Memory
		Registers = { -- initialize 26 general registers and a tick counter. This will very likely not be used too much tho
			["TC"] = 0, -- tick counter
			["A"] = {},
			["B"] = {},
			["C"] = {},
			["D"] = {},
			["E"] = {},
			["F"] = {},
			["G"] = {},
			["H"] = {},
			["I"] = {},
			["J"] = {},
			["K"] = {},
			["L"] = {},
			["M"] = {},
			["N"] = {},
			["O"] = {},
			["P"] = {},
			["Q"] = {},
			["R"] = {},
			["S"] = {},
			["T"] = {},
			["U"] = {},
			["V"] = {},
			["W"] = {},
			["X"] = {}, -- last error
			["Y"] = {}, -- error message
			["Z"] = {}
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

function ENT:getInput(pin) -- we check pin validity in the API or before this is called
	return self.Architecture.IO.Input["Pin"..pin]
end

function ENT:setInput(pin, value)
	self.Architecture.IO.Input["Pin"..pin] = value
end

function ENT:getOutput(pin)
	return self.Architecture.IO.Output["Pin"..pin]
end

function ENT:setOutput(pin, value)
	self.Architecture.IO.Output["Pin"..pin] = value
end



function ENT:onUse(ply)
	-- for now:
	MCom.Message(ply, self:info())
	if not self:GetUser():IsValid() then
		self:endUse() -- if the user is not valid, then the computer is not in use
	end
	if self.isInUse then
		MCom.Message(ply, "This computer is already in use by "..self:GetUser():Nick())
		return
	end
	self.isInUse = true
	self:SetUser(ply)
end

function ENT:endUse()
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
	return string.format("Computer serial: %s; MAC: %s",self.serial,self.mac)
end

function ENT:executeCommand(user, cmd)
	print(user,"Executed command",cmd)
	MCom.Interpreter.executeCommand(user, self, cmd)

	hook.Run("OnCommandExecuted", user, self, cmd)
end

function ENT:output(msg)
	-- for now, we'll print this to user's chat. We will later add a screen entity or other monitor/display system

	if self:GetUser():IsValid() then
		MCom.Message(self:GetUser(), string.format("Computer output: %s", self.serial, msg))
	end
end

function ENT:scanCallback(ply)
	MCom.Message(ply, self.serial .. " Tick")
end