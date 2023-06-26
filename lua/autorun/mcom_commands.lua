MCom = MCom or {}
MCom.Commands = MCom.Commands or {}
MCom.Systems = MCom.Systems or {}

-- ! Module fully moved to computer_systems, lib MCom.Systems
-- ! "Comands" module now deprecated. Migrate and remove.
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
    category = "general", -- things like 'general', 'management', 'misc' etc
    arguments = { -- ^ optional, but recommended for validation and help
        {
            name = "arg1",
            type = "string", -- string, number, bool, color, any
            optional = false,
            desc = "description"
            -- if arg is required, no default.
        },
        {
            name = "arg2",
            type = "number",
            optional = true,
            default = 0,
            desc = "description"
        },
        {
            name = "arg3",
            type = "player",
            optional = true,
            default = nil,
            desc = "description"
        },
    }
}


-- ^ custom commands with this command
MCom.registerCommand("command", cmdTable)

]]

MCom.Commands.builtinCommands = {-- commands that are builtin and are 'secure'. DO NOT ADD COMMANDS TO THIS LIST
    ["help"] = true, -- add the rest
}


function MCom.registerCommand(name, tbl) -- call these at the first possible moment. Do not create dynamically. -- ! Callback must exist beforehand
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

    MCom.Systems[group] = tbl -- register to sys
end