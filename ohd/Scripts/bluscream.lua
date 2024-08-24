local Utils = require("utils")
local UEHelpers = require("UEHelpers")
local CommandHelper = require("commands")
require("extensions")

function bluscream(FullCommand, Parameters, Ar)
    -- If we have no parameters then just let someone else handle this command
    -- if #Parameters > 1 then return false end
    -- for _, parameter in pairs(Parameters) do
    --     Utils.LogDebug(parameter)
    -- end
    local str = "Hello world <1"
    Utils.LogDebug(str)

    -- ExecuteInGameThread(function()
    -- Utils.Exec("kick blu")
    -- end)
    Utils.SayChat(str)
    
    Utils.Exec(str)
    
    return true
end

RegisterProcessConsoleExecPreHook(function(self, Cmd, CommandParts, Ar, Executor)
    local ctx = self:get()
    local CommandParts = CommandParts or Cmd:split(" ")
    local src = Executor:get()
    local cacheKey = "ProcessConsoleExecPre"
    local cacheItem = {ctx, Cmd, CommandParts, Ar, src}
    if Utils.Cache[cacheKey] then return end
    Utils.Cache[cacheKey] = cacheItem
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPre] self: \"%s\"", ctx))
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPre] self: \"%s\"", ctx:GetFullName()))
    Utils.Log("[ProcessConsoleExecPre]: Cmd: \"%s\"", Cmd)
    Utils.Log("[ProcessConsoleExecPre]: CommandParts: %s", dumpTable(CommandParts))
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPre]: Executor: \"%s\"", src))
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPre]: type(Executor) \"%s\"", type(src)))
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPre]: Executor:type() \"%s\"", src:type()))
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPre]: Executor:GetFullName() \"%s\"", src:GetFullName()))
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPre]: Executor:GetAddress() \"%s\"", src:GetAddress()))
    -- for i, part in ipairs(src:Reflection()) do
    --     Utils.LogDebug(string.format("[ProcessConsoleExecPre]: Executor:Reflection[%i]: \"%s\"", i, part))
    -- end
    return CommandHelper.Process(Cmd, nil, nil, parts)
end)

Utils.RegisterHookOnce("/Script/Engine.PlayerController:ClientRestart", function (self) 
    Utils.Log("ClientRestart")
    Utils.Log("[Cache] GameInstance: \"%s\"", Utils.Cache.GameInstance)
    Utils.Log("[Cache] World: \"%s\"", Utils.Cache.World)
end)
Utils.RegisterHookOnce("/Script/Engine.PlayerController:ServerAcknowledgePossession", function(self)
    Utils.LogDebug("ServerAcknowledgePossession")
end)

Utils.RegisterHookOnce("/Script/DonkehFrameworkComms.DFTextCommsChatMsgReceivedDelegateMulti__DelegateSignature", function (self) 
    Utils.Log("DFTextCommsChatMsgReceivedDelegateMulti__DelegateSignature")
end)
Utils.RegisterHookOnce("/Script/HDMain.HDTextChatWidgetBase:DisplayChatMessage", function (self) 
    Utils.Log("DisplayChatMessage")
end)
-- Utils.RegisterHookOnce("/HDCore/UI/HUD/TextChat/WBP_HUDElement_TextChat_OutputListing.WBP_HUDElement_TextChat_OutputListing_C:ExecuteUbergraph_WBP_HUDElement_TextChat_OutputListing", function (self) 
--     Utils.Log("WBP_HUDElement_TextChat_OutputListing_C")
-- end)
Utils.RegisterHookOnce("/HDCore/UI/HUD/TextChat/WBP_HUDElement_TextChat.WBP_HUDElement_TextChat_C:DisplayChatMessage", function (self) 
    Utils.Log("DisplayChatMessage2")
end)


-- Utils.RegisterHookOnce("/HDCore/Rulesets/BP_HDRuleset_TeamComms.BP_HDRuleset_TeamComms_C:HandlePlayerJoinedTeam", function (self) 
--     local ctx = self:get()
--     Utils.LogDebug(string.format("HandlePlayerJoinedTeam: %s", ctx))
--     -- Utils.LogDebug(ctx.Player:get())
--     Utils.LogDebug(Utils.GetPlayerName(ctx:get("Player")))
-- end)

-- Utils.RegisterHookOnce("/HDCore/UI/HUD/TextChat/WBP_HUDElement_TextChat.WBP_HUDElement_TextChat_C:BndEvt__ChatMsgUtils.LogSBox_K2Node_ComponentBoundEvent_0_OnUserScrolledEvent__DelegateSignature", function (self) 
--     Utils.LogDebug("BndEvt__ChatMsgUtils.LogSBox_K2Node_ComponentBoundEvent_0_OnUserScrolledEvent__DelegateSignature")
-- end)

Utils.RegisterHookOnce("/Script/HDMain.HDTextChatInputWidgetBase:OnChatMessageSubmitted", function (self) 
    Utils.Log("OnChatMessageSubmitted")
end)
Utils.RegisterHookOnce("/Script/HDMain.HDTextChatInputWidgetBase:SubmitChatMessage", function (self) 
    Utils.Log("SubmitChatMessage")
end)


-- RegisterLoadMapPreHook(function(Engine, World)
--     Utils.LogDebug("LoadMapPre")
--     -- GlobalWorld = World
-- end)


RegisterLoadMapPostHook(function(Engine, World)
    Utils.Log("LoadMapPost")
end)
NotifyOnNewObject("/Script/Engine.World", function(CreatedObject)
    Utils.LogDebug(string.format("World \"%s\" was created", CreatedObject))
end)

NotifyOnNewObject("/Script/Engine.PlayerController", function(CreatedObject)
    Utils.LogDebug(string.format("PlayerController \"%s\" was created", CreatedObject))
end)

RegisterInitGameStatePreHook(function(selfParam)
    local self = selfParam:get()
    Utils.Log("InitGameStatePre")
end)
RegisterInitGameStatePostHook(function(selfParam)
    local self = selfParam:get()
    Utils.Log("InitGameStatePost")
end)
-- RegisterBeginPlayPreHook(function(selfParam)
--     local self = selfParam:get()
--     Utils.LogDebug(string.format("BeginPlayPre: \"%s\"", self:GetClass():GetFName()))
-- end)
-- RegisterBeginPlayPostHook(function(selfParam)
--     local self = selfParam:get()
--     Utils.LogDebug(string.format("BeginPlayPost: \"%s\"", self:GetClass():GetFName()))
-- end)

Utils.RegisterHookOnce("/Script/Engine.KismetSystemLibrary:ExecuteConsoleCommand", function (self) 
    Utils.Log("ExecuteConsoleCommand")
end)
-- RegisterProcessConsoleExecPostHook(function(self, Cmd, CommandParts, Ar, Executor)
    -- local ctx = self:get()
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPost] self: \"%s\"", ctx))
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPost]: Cmd: \"%s\"", Cmd))
    -- -- if CommandParts ~= nil then
    -- for i, part in ipairs(CommandParts) do
    --     Utils.LogDebug(string.format("[ProcessConsoleExecPost]: Part[%i]: \"%s\"", i, part))
    -- end
    -- -- end
    -- local src = Executor:get()
    -- Utils.LogDebug(string.format("[ProcessConsoleExecPost]: Executor: \"%s\"", src))
-- end)

RegisterULocalPlayerExecPreHook(function(selfParam)
    local self = selfParam:get()
    Utils.Log("ULocalPlayerExecPre")
end)
RegisterULocalPlayerExecPostHook(function(selfParam)
    local self = selfParam:get()
    Utils.Log("ULocalPlayerExecPost")
end)

RegisterCustomEvent("bluscream", bluscream)
-- Utils.RegisterCommand("bluscream", bluscream)
-- RegisterConsoleCommandGlobalHandler("bluscream", bluscream)
-- Utils.RegisterCommand("blu", bluscream)
-- RegisterConsoleCommandGlobalHandler("blu", bluscream)
-- RegisterKeyBind(Key.F3, bluscream)