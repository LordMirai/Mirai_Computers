MCom = MCom or {}
MCom.Commands = MCom.Commands or {}
MCom.Callbacks = MCom.Callbacks or {}
MCom.Groups = MCom.Groups or {}
MCom.Systems = MCom.Systems or {} -- temporary, to be used by mcom_commands

local function pair(grp, cmdTable, nameFB)
    if not MCom.Groups[grp] then
        MCom.Groups[grp] = {}
    end
    print("Pairing "..nameFB.." to "..grp)
    MCom.Groups[grp][cmdTable.name or nameFB] = cmdTable
end

hook.Add("InitPostEntity", "MCom_PairCommandsToGroups", function()
    print("Pairing start")
    PrintTable(MCom.Commands)
    for k,v in pairs(MCom.Commands) do
        if IsValid(v.action) then -- we know it's a valid command
            local g = string.lower(v.group or "")
            if g != "none" and g != "" then
                pair(g, v, k)
            end
        end
    end
end)

--[[
    The idea is:

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

MCom.Systems["os"] = {
    groupAction = {
        desc = "Operating System commands",
        action = MCom.Callbacks["os"],
        category = "system"
    },
    commands = {
        ["shutdown"] = {
            name = "Shut down",
            desc = "Powers off the system",
            action = MCom.Callbacks["os_shutdown"],
            example = "os shutdown",
            category = "system",
            postconditions = MCom.Callbacks["os_shutdown_post"]
        },
        ["restart"] = {
            name = "Restart",
            desc = "Powers off then back on",
            action = MCom.Callbacks["os_restart"],
            example = "os restart",
            category = "system",
            postconditions = MCom.Callbacks["os_restart_post"]
        }
    }
}

MCom.Systems["sys"] = {
    groupAction = {
        desc = "System commands",
        action = MCom.Callbacks["sys"],
        category = "system"
    },
    commands = {
        ["info"] = {
            name = "Info",
            desc = "Displays information about the system",
            action = MCom.Callbacks["sys_info"],
            example = "sys info",
            category = "system"
        },
        ["diag"] = {
            name = "Diagnostics",
            desc = "Runs a diagnostic test on the system",
            action = MCom.Callbacks["sys_diag"],
            example = "sys diag",
            category = "system"
        },
        ["lasterror"] = {
            name = "Last Error",
            desc = "Displays the last error that occurred",
            action = MCom.Callbacks["sys_lasterror"],
            example = "sys lasterror",
            category = "system"
        }
    }
}

MCom.Systems["net"] = {
    groupAction = {
        desc = "Networking commands",
        action = MCom.Callbacks["net"],
        category = "network"
    },
    commands = {
        ["ping"] = {
            name = "Ping",
            desc = "Pings a remote system",
            action = MCom.Callbacks["net_ping"],
            example = "net ping 10.230.12.11",
            category = "network"
        },
        ["connect"] = {
            name = "Connect",
            desc = "Connects to a remote system",
            action = MCom.Callbacks["net_connect"],
            example = "net connect (address)"
        },
        ["disconnect"] = {
            name = "Disconnect",
            desc = "Disconnects from a remote system",
            action = MCom.Callbacks["net_disconnect"],
            example = "net disconnect (address)"
        }
    }
}