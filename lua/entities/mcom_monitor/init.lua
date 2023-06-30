AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:peripheralInit() -- ovr peripheral_base
	-- override. Should use :setup() here
	self.isMonitor = true
	self:SetText("") -- actual text on monitor. must and will be changed to fit anything.
	
	local mdl = "" -- model here
	self:setup(mdl, "Monitor", false, "TTP")

	self.actions = {
		["info"] = function(ply, origin)
			origin:output("Monitor - " .. self.serial)
		end,
		["clear"] = function(ply, origin)
			origin:clear()
		end,
		["write"] = function(ply, origin, ...)
			local msg = table.concat({...}, " ")
			self:write(msg)
		end,
		["color"] = function(ply, origin, colStr)
			colStr = string.trim(string.lower(colStr))
			local col = MCom.ColorStrings[colStr]

			if not col then -- predefined color not found
				if string.find(colStr, ",") then -- ? try RGB
					local colTbl = string.Explode(",", colStr)
					col = Color(tonumber(colTbl[1]) or 0, tonumber(colTbl[2]) or 0, tonumber(colTbl[3]) or 0)
				else
					origin:output("Invalid color string. For example, for a red color use 'red' or '240,10,10'")
					return
				end
			end

			self:setBackground(col)
		end,
	}
end

function ENT:behavior() -- attach this to onTick or other such thing to implement behavior. You can even put it in peripheralInit() to work independently

end

function ENT:onConnected(parent)
	-- ovr
end

function ENT:setupPorts() end -- no ports for now