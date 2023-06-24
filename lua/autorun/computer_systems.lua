MCom = MCom or {}
MCom.Commands = MCom.Commands or {}
MCom.Callbacks = MCom.Callbacks or {}
MCom.Groups = MCom.Groups or {}
MCom.Systems = MCom.Systems or {} -- temporary, to be used by mcom_commands

--[[local function pair(grp, cmdTable, nameFB) -- ^ I don't think this is needed anymore.
    if not MCom.Groups[grp] then
        MCom.Groups[grp] = {}
    end
    print("Pairing "..nameFB.." to "..grp)
    MCom.Groups[grp][cmdTable.name or nameFB] = cmdTable
end]]

function MCom.refreshCommands()
    for k,v in pairs(MCom.Systems) do -- check command actions
        if v.groupAction then
            v.groupAction.action = MCom.Callbacks[k]
        end

        for _, cmd in pairs(v.commands or {}) do
            cmd.action = MCom.Callbacks[cmd.fallback] -- try to use the fallback. it *MIGHT* error if missing, but that's fixable
        end
    end
end

hook.Add("InitPostEntity", "MCom_PairCommandsToGroups", function()
    --[[print("Pairing start")
    PrintTable(MCom.Commands)
    for k,v in pairs(MCom.Commands) do
        if IsValid(v.action) then -- we know it's a valid command
            local g = string.lower(v.group or "")
            if g != "none" and g != "" then
                pair(g, v, k)
            end
        end
    end]]

    timer.Simple(1, function() -- we wait a bit, for any other command initialization to finish
        MCom.refreshCommands()
        MCom.hotReload = true
    end)
end)

--[[
    * The idea is:

    The group, or system, is a collection of commands that are related to each other.
    We would have things like:
    os - Operating System (shutdown, restart)
    sys - System (info, diag, lasterror)
    net - Networking (ping, traceroute, send)
    dev - Development (debug, log, error)
    api - API (api, request, send, check)
    ext - External (send, request, set, reset)
    misc - Miscellaneous (random, roll, flip, etc)
    perip - Peripheral (perip, peripinfo, refresh)
    file - Filesystem (read, write, delete, etc)
    none - No group (help, ping, etc)

    The idea is to first specify the group, then the command.
    "os shutdown" would be a valid command, but "shutdown os" would not, nor would simply shutdown
    "os" would be a valid command, and would list all commands in the os group

    All commands should have access to the following:
    - The player who ran the command, or nil if it was run from the console (or a script [PC])
    - The origin entity -> The computer or peripheral that the command was run from
    - The arguments -> The arguments passed to the command

    All of these are defined in the command table, and are passed to the command when it is run.
    Normally, the origin should NEVER be nil, as commands should only matter to it.
]]

-- ! current group-command action system is non functional, replacing with global Systems table

-- ! make sure the systems are written *AFTER* the callbacks are defined, or else it will not work.

MCom.Systems["os"] = {
    groupAction = {
        desc = "Operating System commands",
        action = MCom.Callbacks["os"],
        category = "system",
        fallback = "os" -- ? in case it can't be loaded, retry with this
    },
    commands = {
        ["shutdown"] = {
            name = "Shut down",
            desc = "Powers off the system",
            action = MCom.Callbacks["os_shutdown"],
            example = "os shutdown",
            category = "system",
            postconditions = MCom.Callbacks["os_shutdown_post"],
            fallback = "os_shutdown"
        },
        ["restart"] = {
            name = "Restart",
            desc = "Powers off then back on",
            action = MCom.Callbacks["os_restart"],
            example = "os restart",
            category = "system",
            postconditions = MCom.Callbacks["os_restart_post"],
            fallback = "os_restart"
        }
    }
}

MCom.Systems["sys"] = {
    groupAction = {
        desc = "System commands",
        action = MCom.Callbacks["sys"],
        category = "system",
        fallback = "sys"
    },
    commands = {
        ["info"] = {
            name = "Info",
            desc = "Displays information about the system",
            action = MCom.Callbacks["sys_info"],
            example = "sys info",
            category = "system",
            fallback = "sys_info"
        },
        ["diag"] = {
            name = "Diagnostics",
            desc = "Runs a diagnostic test on the system",
            action = MCom.Callbacks["sys_diag"],
            example = "sys diag",
            category = "system",
            fallback = "sys_diag"
        },
        ["lasterror"] = {
            name = "Last Error",
            desc = "Displays the last error that occurred",
            action = MCom.Callbacks["sys_lasterror"],
            example = "sys lasterror",
            category = "system",
            fallback = "sys_lasterror"
        }
    }
}

MCom.Systems["net"] = {
    groupAction = {
        desc = "Networking commands",
        action = MCom.Callbacks["net"],
        category = "network",
        fallback = "net"
    },
    commands = {
        ["ping"] = {
            name = "Ping",
            desc = "Pings a remote system",
            action = MCom.Callbacks["net_ping"],
            example = "net ping 10.230.12.11",
            category = "network",
            fallback = "net_ping"
        },
        ["connect"] = {
            name = "Connect",
            desc = "Connects to a remote system",
            action = MCom.Callbacks["net_connect"],
            example = "net connect (address)",
            category = "network",
        },
        ["disconnect"] = {
            name = "Disconnect",
            desc = "Disconnects from a remote system",
            action = MCom.Callbacks["net_disconnect"],
            example = "net disconnect (address)",
            category = "network",
        }
    }
}

MCom.Systems["io"] = {
    groupAction = {
        desc = "Input/Output commands, for pin control",
        action = MCom.Callbacks["io"],
        category = "io",
        fallback = "io"
    },
    commands = {
        ["read"] = {
            name = "Read input",
            desc = "Reads the value of an input pin",
            action = MCom.Callbacks["io_read"],
            help = "io read (pin)",
            example = "io read 1",
            category = "io",
            fallback = "io_read"
        },
        ["write"] = {
            name = "Write output",
            desc = "Writes a value to an output pin. only 0/1",
            action = MCom.Callbacks["io_write"],
            help = "io write (pin) (value)",
            example = "io write 1 1",
            category = "io",
            fallback = "io_write"
        },
        ["getall"] = {
            name = "Get all",
            desc = "Gets the value of all input pins",
            action = MCom.Callbacks["io_getall"],
            help = "io getall",
            example = "io getall",
            category = "io",
            fallback = "io_getall"
        },
        ["setall"] = {
            name = "Set all",
            desc = "Sets the value of all write pins",
            action = MCom.Callbacks["io_setall"],
            help = "io setall (value)",
            example = "io setall 1",
            category = "io",
            fallback = "io_setall"
        }
    }
}

MCom.Systems["none"] = { -- * will need a fallback implementation to recognize
    -- no group action
    commands = {
        ["reg"] = {
            name = "Register view",
            alias = {"register", "reg"},
            desc = "Lists all registers with their values",
            action = MCom.Callbacks["register"],
            example = "reg",
            fallback = "register"
        },
        ["tick"] = {
            name = "Ticker test",
            action = MCom.Callbacks["tick"],
            example = "tick",
            fallback = "tick",
            arguments = {
                {
                    name = "tickCount",
                    type = "number",
                    optional = true,
                    default = 3
                }
            }
        },
        ["clock"] = {
            name = "Clock output",
            action = MCom.Callbacks["clock"],
            help = "clock (pin) (interval)",
            example = "clock 2 1.3 - toggles pin 2 every 1.3 seconds",
            fallback = "clock",
            arguments = {
                {
                    name = "pin",
                    type = "number",
                    optional = false
                },
                {
                    name = "interval",
                    type = "number",
                    optional = true,
                    default = 1
                }
            }
        }
    }
}

