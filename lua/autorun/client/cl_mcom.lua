MCom = MCom or {}

function MCom.requestInputs(ent)
    if ent.isPeripheral then
        MCom.net.lazy(ent, false)
    end
end

function MCom.requestOutputs(ent)
    if ent.isComputer then
        MCom.net.lazy(ent, true)
    end
end

print("cl_mcom.lua reloaded")