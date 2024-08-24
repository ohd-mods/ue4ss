print("[BLUSCREAM] START\n")

local Utils = require("utils")
Utils.Init("ohd", "Bluscream", "1.0.0")

local ServerHooks = require("hooks/server")
ServerHooks.Init()
local PlayerHooks = require("hooks/player")
PlayerHooks.Init(nil)

require("bluscream")
require("location")
Utils.LogDebug("END")