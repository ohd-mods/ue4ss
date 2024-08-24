local Utils = require("utils")
local UEHelpers = require("UEHelpers")
require("extensions")

local CommandHelper = {}
CommandHelper.Cache = {}
CommandHelper.Settings = {
    Debug = false
}

function CommandHelper.Init()
end

function CommandHelper.bluscream(FullCommand, Parameters, Ar)
    -- If we have no parameters then just let someone else handle this command
    -- if #Parameters > 1 then return false end
    -- for _, parameter in pairs(Parameters) do
    --     Utils.LogDebug(parameter)
    -- end
    local str = "Hello world <1"
    Utils.Log(str)

    -- ExecuteInGameThread(function()
    -- Utils.Exec("kick blu")
    -- end)
    Utils.SayChat(str)
    
    Utils.Exec(str)
    
    return true
end

function CommandHelper.Process(msg, cmd, arg, args)
    args = args or msg:split(" ")
    cmd = cmd or table.remove(args, 1)
    arg = arg or table.join(args, " ")

    Utils.Log("[CommandHelper.Process] msg: \"%s\"", msg)
    Utils.Log("[CommandHelper.Process] cmd: \"%s\"", cmd)
    Utils.Log("[CommandHelper.Process] arg: \"%s\"", arg)
    Utils.Log("[CommandHelper.Process] args: \"%s\"", dumpTable(args))

    if cmd == "bluscream" then
        bluscream()
        return true
    elseif cmd == "ue4ss" then
        Utils.SayChat(Utils.GetUnrealVersion(true), "CONSOLE")
        return true
    elseif cmd == "sayChat" then
        Utils.SayChat(arg, "CONSOLE")
        return true
    elseif cmd == "renamesrv" then
        local message = string.format("Renaming Server to %s", arg)
        Utils.Log(message)
        Utils.SayChat(message, "CONSOLE")
        Utils.SetServerName(arg)
        return true
    end
end

return CommandHelper