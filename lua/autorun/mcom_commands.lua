MCom = MCom or {}
MCom.Commands = MCom.Commands or {}
MCom.Systems = MCom.Systems or {}

-- ! Todo: We need a way to link commands to caller, maybe through entity. Think about wrappers.

--[[command structure:
-- ^ builtin

MCom.Commands["command"] = {
    name = "Command", -- pretty name.
    alias = {"alias1", "alias2"},
    desc = "description",
    action = function(ply, origin, arg1, arg2, arg3) -- callback
        --do stuff. leave command unpacking to the interpreter
        return execResult -- whatever you want to return
    end,
    preconditions = function(ply, origin, arg1, arg2, arg3) -- called before action, if returns false, action is not called. Both pre and post conditions are optional
        --return true/false
    end,
    postconditions = function(ply, origin, execResult arg1, arg2, arg3) -- called after action, to check if action was successful
        --return true/false
    end,
    admin = false,
    hidden = false,
    ignoreCase = true, -- true by default cuz it's used the most
    help = "help text",
    example = "example text",
    group = "none", -- Think about os and sys. if empty or nil, they're considered root. I got no clue how i'll do this tho
    category = "general" -- things like 'general', 'management', 'misc' etc
}


-- ^ custom commands with this command
MCom.registerCommand("command", cmdTable)

]]

MCom.Commands.builtinCommands = {-- commands that are builtin and are 'secure'. DO NOT ADD COMMANDS TO THIS LIST
    ["help"] = true, -- add the rest
}


function MCom.registerCommand(name, tbl) -- call these at the first possible moment. Do not create dynamically.
    if not name then return end
    name = string.Trim(string.lower(name))
    if name == "" then return end

    if not tbl then return end
    if not tbl.action then return end -- callback inexistent

    tbl.name = name
    tbl.alias = tbl.alias or {}
    tbl.desc = tbl.desc or ""
    tbl.admin = tbl.admin or false
    tbl.hidden = tbl.hidden or false
    tbl.help = tbl.help or ""
    tbl.example = tbl.example or ""
    tbl.ignoreCase = tbl.ignoreCase or true
    tbl.group = tbl.group or "none"
    tbl.category = tbl.category or "general"

    MCom.Commands[name] = tbl -- register to base cmds
end


MCom.Commands["reg"] = {
    name = "Register view",
    alias = {"register", "reg"},
    desc = "Lists all registers with their values",
    action = MCom.Callbacks["register"]
}

-- the way to set up group actions is to just assign MCom.Groups["groupname"].action to the command data table.

for grpName,cmds in pairs(MCom.Systems) do
    if cmds.groupAction then
        MCom.Commands[grpName] = {
            name = grpName,
            alias = cmds.alias,
            desc = cmds.desc,
            action = cmds.groupAction,
            admin = cmds.admin,
            hidden = cmds.hidden,
            help = cmds.help,
            example = cmds.example,
            ignoreCase = cmds.ignoreCase,
            group = "none",
            category = cmds.category
        }
    end

    for key, cmd in pairs(cmds.commands) do
        cmd.group = grpName
        MCom.registerCommand(key, cmd)
    end
end