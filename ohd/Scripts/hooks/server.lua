local Utils = require("utils")
local UEHelpers = require("UEHelpers")
require("extensions")

local ServerHooks = {
    Cache = {},
    Methods = {}
}

ServerHooks.Settings = {
}


ServerHooks.Init = function (Player)
    Utils.Log("Initialized hooks for Server")
end


return ServerHooks