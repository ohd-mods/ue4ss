-- Ted the Seeker's utils.lua 2024-02-16

local UEHelpers = require("UEHelpers")

local Utils = {}

local RegisteredHooks = {}

Utils.ModName = nil
Utils.ModAuthor = nil
Utils.ModVer = nil

Utils.Settings = {
    Debug = false
}

Utils.Cache = {
    World = FindFirstOf("World"),
    GameInstance = nil
}

-- Init values and start
function Utils.Init(Author, Name, Ver)
	Utils.ModAuthor = Author
	Utils.ModName = Name
	Utils.ModVer = Ver

	Utils.Log("Starting %s (%s) by %s", Utils.ModName, Utils.ModVer, Utils.ModAuthor)
	Utils.Log(_VERSION)
end

-- Prints to console in the format of [<author>-<mod>] <message> in a new line.
function Utils.Log(Format, ...)
	print(string.format("[%s-%s] %s\n", Utils.ModAuthor, Utils.ModName, string.format(Format, ...)))
end
function Utils.LogDebug(Format, ...)
    if not Utils.Settings.Debug then return end
	Utils.Log(Format, ...)
end

function Utils.Default(value, default_value)
    if value == nil then return default_value end
    return value
end

-- Wrapper to UE4SS' RegisterHook except it prevents creating any more duplicate hooks according to function name.
function Utils.RegisterHookOnce(FunctionName, Function)
	if not RegisteredHooks[FunctionName] then
		RegisterHook(FunctionName, Function)
		RegisteredHooks[FunctionName] = true
	end
end

-- Sends a message that the hooked function has been called, while showing the arguments.
function Utils.TestFunc(FunctionName)
	Utils.RegisterHookOnce(FunctionName, function(self, ...)
		local Args = ""
		for n, v in ipairs({...}) do
            local got = v:get()
			Args = string.format("%s->%s[%s] ", got:type(), n, got)
		end

		Utils.LogDebug("CALLED: %s %s", FunctionName, Args)
	end)
end

-- Wraps around RegisterConsoleCommandHandler. To provide better context on which command said which log.
-- Code inside the callback function must use Log() for logging, not Utils.Log.
function Utils.RegisterCommand(CommandName, Callback)
	RegisterConsoleCommandHandler("st" .. CommandName, function(FullCommand, Parameters, OutputDevice)
		Utils.LogDebug("> %s", FullCommand)

		local function Log(Format, ...)
			Utils.LogDebug("[%s] %s", FullCommand, string.format(Format, ...))
		end

		local exitVal = Callback(FullCommand, Parameters, Log)

		Log("End Command. Successful? %s", tostring(exitVal))

		return true
	end)
end

function Utils.PrintTable(Table)
	local Str = "{"

	for k, v in pairs(Table) do
		Str = string.format("%s%s: %s; ", Str, k, v)
	end

	Str = Str .. "}"
	Utils.LogDebug(Str)
end

function Utils.Exec(command)
    if command == nil then return end
    Utils.Log("Executing \"%s\"", command)
    local class = UEHelpers:GetKismetSystemLibrary(false)
    if Utils.isValid(class) then
        class:ExecuteConsoleCommand(UEHelpers:GetWorldContextObject(), command, nil) -- UEHelpers:GetPlayerController()
        return
    end
    class = FindFirstOf("DFBasePlayerController")
    if Utils.isValid(class) then
        Utils.LogDebug(string.format("msg type: %s", type(command)))
        DFBasePlayerController:ServerAdmin(command)
    end
end

function Utils.SayChat(message, name)
    if message == nil then return end
    name = name or "SERVER"
    Utils.LogDebug(string.format("Saying \"%s\" as \"%s\"", message, name))
    local DFBasePlayerController = FindFirstOf("DFBasePlayerController")
    if Utils.isValid(DFBasePlayerController) then
        DFBasePlayerController:ServerSay(string.format("\n[%s] %s", name, message))
    --     print(string.format("DFBasePlayerController type: %s\n", type(DFBasePlayerController)))
    --     print(string.format("DFBasePlayerController type2: %s\n", DFBasePlayerController:type()))
    --     local arg = {
    --         MsgContent="message",
    --         MsgTeamId=0,
    --         SenderName="name"
    --     }
    --     print(string.format("msg type: %s\n", type(arg)))
    --     DFBasePlayerController:ReceiveNewChatMsg(arg)
    --     -- FPlayerChatMsg
    --     -- APlayerState
    end
    Utils.Exec(string.format("say [CHAT][%s] %s", name, message))
end

function Utils.isValid(item)
    local is_valid = item ~= nil and item:IsValid()
    Utils.LogDebug(string.format("Item \"%s\" is valid: %s!", item, is_valid))
    -- if item == nil then
    --     Utils.LogDebug(string.format("Item \"%s\" is nil!", item))
    --     return false
    -- end
    -- if ~item:isValid() then
    --     Utils.LogDebug(string.format("Item \"%s\" is not valid!", item))
    --     return false
    -- end
    return is_valid
end

-- function GetGameplayStatics(ForceInvalidateCache)
--     return CacheDefaultObject("/Script/Engine.ExecuteConsoleCommand", "ExecuteConsoleCommand", ForceInvalidateCache)
-- end

function Utils.GetWorld()
    if Utils.isValid(Utils.Cache.World) then return Utils.Cache.World end
    local world = UEHelpers.GetWorld()
    if world ~= nil and Utils.isValid(world) then
        Utils.Cache.World = world
        return world
    end
    -- local ExistingActor = FindFirstOf("Actor")
    -- if isValid(ExistingActor) then
    --     local world = ExistingActor:GetWorld()
    --     if isValid(world) then return world end
    -- end
    local worlds = FindAllOf("World")
    for i, world in pairs(worlds) do
        local instance = world:get("OwningGameInstance")
        if instance == Utils.GetGameInstance() then
            Utils.Cache.World = world
            return world
        end
    end
    return nil
end
function Utils.GetGameInstance()
    if Utils.isValid(Utils.Cache.GameInstance) then return Utils.Cache.GameInstance end
    local gameInstance = FindFirstOf("GameInstance")
    if Utils.isValid(gameInstance) then
        Utils.Cache.GameInstance = gameInstance
        return gameInstance
    end
    local gameInstance = Utils.GetHDGameInstance()
    if Utils.isValid(gameInstance) then
        Utils.Cache.GameInstance = gameInstance
        return gameInstance
    end
    return nil
end
function Utils.Dump(var, name)
    print((name or "Variable") .. ":\n")
    print(string.format("dumpTable(var): %s\n", dumpTable(var)))
    print(string.format("type(var): %s\n", type(var)))
    print(string.format("var:type(): %s\n", var:type()))
    local got = var:get()
    print(string.format("dumpTable(got): %s\n", dumpTable(got)))
    print(string.format("type(got): %s\n", type(got)))
    print(string.format("got:type(): %s\n", got:type()))
    print(string.format("got:GetFullName(): %s\n", got:GetFullName()))
    print(string.format("got:GetFName(): %s\n", got:GetFName()))
    print(string.format("got:GetClass(): %s\n", got:GetClass()))
    return txt
end
function Utils.GetUnrealVersion(withText)
    -- withText = withText or false
    local Major = UnrealVersion.GetMajor()
    local Minor = UnrealVersion.GetMinor()
    local txt = ""
    if withText then txt = txt .. "Unreal Engine " end
    return txt .. string.format("%s.%s", Major, Minor)
end
function Utils.GetHDGameInstance()
    return FindFirstOf('BP_HDGameInstance.BP_HDGameInstance_C')
    -- return UBPFL_HDCore_C:GetHDGameInstance(UEHelpers.GetWorldContextObject(), HDGI)
end
function Utils.GetVectorString(v)
    return string.format("{X%.3f,Y%.3f,Z%.3f}", v.X, v.Y, v.Z)
end
function Utils.GetPlayerString(state)
    local typeStr = state.IsABot and "Bot" or "Player"
    local plStr = state.FromPreviousLevel and "FromPreviousLevel|" or ""
    local sStr = state.IsSpectator and "Spectator|" or ""
    local osStr = state.OnlySpectator and "OnlySpectator|" or ""
    local idleStr = state.IsInactive and "AFK|" or ""
    return string.format("[%s%s%s%s] %s \"%s\" (#%i/%s) with %ims since %u",
        plStr, sStr, osStr, idleStr, typeStr, state.Name, state.PlayerId, state.SteamId64, state.Ping, state.StartTime)
end
function Utils.GetPlayerState(player)
    local state = player.PlayerState
    return {
        Score = state.Score or -1,
        PlayerId = state.PlayerId or -1,
        Ping = state.Ping,
        ShouldUpdateReplicatedPing = state.bShouldUpdateReplicatedPing,
        IsSpectator = state.bIsSpectator,
        OnlySpectator = state.bOnlySpectator,
        IsABot = state.bIsABot,
        IsInactive = state.bIsInactive,
        FromPreviousLevel = state.bFromPreviousLevel,
        StartTime = state.StartTime or -1,
        SteamId64 = state.SavedNetworkAddress:ToString() or "",
        -- UniqueId = state.UniqueId.ReplicationBytes:ToString(),
        Name = state.PlayerNamePrivate:ToString() or ""
    }
end
function Utils.GetTeamName(teamNum)
    if teamNum == 0 then return string.format("OPFOR (%i)", teamNum) end
    if teamNum == 1 then return string.format("BLUFOR (%i)", teamNum) end
    return string.format("Unknown (%i)", teamNum)
end
function Utils.RemoveAllBots()
    local gameMode = FindFirstOf('ADFBaseGameMode')
    gameMode:RemoveAllBots()
end

RegisterLoadMapPostHook(function(Engine, World) Utils.World = World end)
NotifyOnNewObject("/Script/Engine.World", function(World) Utils.World = World end)

ExecuteInGameThread(function()
	Utils.Cache.GameInstance = Utils.GetGameInstance()
	Utils.Cache.World = Utils.GetWorld()
end)

return Utils