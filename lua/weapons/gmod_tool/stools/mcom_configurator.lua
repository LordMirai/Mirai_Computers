TOOL.Category = "Mirai Util"

TOOL.PrintName = "Configurator"
TOOL.Author = "Lord Mirai (未来)"
TOOL.Instructions = "Click on Mirai Computer ents to set up."
TOOL.Contact = "Discord: lordmirai"

TOOL.Name = "#tool.mcom_configurator.name"

if CLIENT then
	language.Add( "Tool.mcom_configurator.name", "MCom configurator tool" )
	language.Add( "Tool.mcom_configurator.desc", "Configures things." )
	language.Add( "Tool.mcom_configurator.0", "Primary: Select entity to config")
	language.Add( "Tool.mcom_configurator.1", "Secondary: Save entity")
end


MCom = MCom or {}

function TOOL:LeftClick(trace)
	local own = self:GetOwner()
	if not own then return false end
	if not own:IsAdmin() then
		if CLIENT then -- send cl msg
			MCom.Message("You need administrator privilleges to use this tool.")
		end
		return false -- don't do anything
	end
	if SERVER then
		local hit = trace.HitPos
		local hEnt = trace.Entity
		if IsValid(hEnt) and hEnt.MComEntity then
			hEnt:configure(own)
		end
	end
	return true
end

function TOOL:RightClick(trace)
	local own = self:GetOwner()
	if not own then return false end
	if not own:IsAdmin() then
		if CLIENT then -- send cl msg
			MCom.Message("You need administrator privilleges to use this tool.")
		end
		return false -- don't do anything
	end
	if SERVER then
		local hit = trace.HitPos
		local hEnt = trace.Entity
		if IsValid(hEnt) and hEnt.MComEntity then
			self.savedEnt = hEnt -- not sure what to do with this yet, but it's here for brevity
			MCom.Message(own, "Entity saved.")
		end
	end
	return true
end

function TOOL:Reload(trace)
	local own = self:GetOwner()
	if not own then return false end
	if not own:IsAdmin() then
		if CLIENT then -- send cl msg
			MCom.Message("You need administrator privilleges to use this tool.")
		end
		return false -- don't do anything
	end
	if SERVER then
		if self.savedEnt then
			self.savedEnt = nil
			MCom.Message(own, "Saved entity cleared.")
		end
	end
end

function TOOL:Deploy()
	local own = self:GetOwner()
	if not own then return false end
end

function TOOL:Holster()
	local own = self:GetOwner()
	if not own then return false end
end