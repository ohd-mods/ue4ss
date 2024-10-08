local Utils = require("utils")
local UEHelpers = require("UEHelpers")
local CommandHelper = require("commands")
require("extensions")

local PlayerHooks = {
    Cache = {},
    Methods = {}
}

PlayerHooks.Settings = {
}


PlayerHooks.Init = function (Player)
    -- Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerJoined", PlayerHooks.Methods.onPlayerJoined)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerPostLogin", PlayerHooks.Methods.onPlayerJoined)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerJoinedTeam", PlayerHooks.Methods.onPlayerJoinedTeam)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerSpawn", PlayerHooks.Methods.onPlayerSpawn)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerKilled", PlayerHooks.Methods.onPlayerKilled)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerWounded", PlayerHooks.Methods.onPlayerWounded)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerSuicide", PlayerHooks.Methods.onPlayerSuicide)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerDied", PlayerHooks.Methods.onPlayerDied)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFGameRulesetBase:PlayerPostLogout", PlayerHooks.Methods.onPlayerPostLogout)

    Utils.RegisterHookOnce("/Script/DonkehFramework.DFBasePlayerController:ReceiveNewChatMsg", PlayerHooks.Methods.onReceiveNewChatMsg)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFBasePlayerController:Say", PlayerHooks.Methods.onSay)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFBasePlayerController:ServerSay", PlayerHooks.Methods.onServerSay)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFBasePlayerController:ServerTeamSay", PlayerHooks.Methods.onServerTeamSay)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFBasePlayerController:TeamSay", PlayerHooks.Methods.onTeamSay)
    Utils.RegisterHookOnce("/Script/DonkehFramework.DFBasePlayerController:ServerAdmin", PlayerHooks.Methods.onServerAdmin)
    Utils.Log("Initialized hooks for Player: %s", Player)
end

PlayerHooks.Methods.onReceiveNewChatMsg = function (self)
    local ctx = self:get()
    local cacheKey = "ReceiveNewChatMsg"
    local cacheItem = { ctx }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    Utils.Log("ReceiveNewChatMsg")
end

PlayerHooks.Methods.onSay = function (self)
    local ctx = self:get()
    local cacheKey = "Say"
    local cacheItem = { ctx }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    Utils.Log("Say")
end
PlayerHooks.Methods.onServerSay = function (self)
    local ctx = self:get()
    local cacheKey = "ServerSay"
    local cacheItem = { ctx }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    Utils.Log("ServerSay")
end
PlayerHooks.Methods.onServerTeamSay = function (self)
    local ctx = self:get()
    local cacheKey = "ServerTeamSay"
    local cacheItem = { ctx }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    Utils.Log("ServerTeamSay")
end
PlayerHooks.Methods.onTeamSay = function (self)
    local ctx = self:get()
    local cacheKey = "TeamSay"
    local cacheItem = { ctx }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    Utils.Log("TeamSay")
end
PlayerHooks.Methods.onServerAdmin = function (self, Cmd, Player)
    local ctx = self:get()
    local Cmd = Cmd:get():ToString()
    local CommandParts = Cmd:split(" ")
    local cacheKey = "ServerAdmin"
    local cacheItem = { ctx, Cmd, CommandParts }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    Utils.Log("ServerAdmin Cmd: %s", dumpTable(Cmd))
    Utils.Log("ServerAdmin CommandParts: %s", dumpTable(CommandParts))
    -- Utils.Dump(self, "ServerAdmin.self")
    CommandHelper.Process(Cmd, nil, nil, CommandParts)
end


PlayerHooks.Methods.onPlayerJoined = function (self, NewPlayer) -- PlayerPostLogin 
    local ctx = self:get()
    local player = NewPlayer:get()
    local cacheKey = "PlayerJoined"
    local cacheItem = { ctx, player }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    local state = Utils.GetPlayerState(player)
    Utils.Log("%s joined the server", Utils.GetPlayerString(state))
    Utils.SayChat(string.format("%s joined [%ims]", Utils.GetPlayerStr(state), state.Ping))
end

PlayerHooks.Methods.onPlayerJoinedTeam = function (self, JoiningPlayer, TeamNum)
    local ctx = self:get()
    local player = JoiningPlayer:get()
    local teamNum = TeamNum:get()
    local cacheKey = "PlayerJoinedTeam"
    local cacheItem = {ctx, player, teamNum}
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    local state = Utils.GetPlayerState(player)
    Utils.Log("%s joined team %s", Utils.GetPlayerString(state), Utils.GetTeamName(teamNum))
end

PlayerHooks.Methods.onPlayerSpawn = function (self, Player, NewPlayerPawn)
    local ctx = self:get()
    local player = Player:get()
    local pawn = NewPlayerPawn:get()
    local cacheKey = "PlayerSpawn"
    local cacheItem = {ctx, player, pawn}
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    local state = Utils.GetPlayerState(player)
    Utils.Log("%s spawned at %s", Utils.GetPlayerString(state), Utils.GetVectorString(pawn:K2_GetActorLocation()))
end

PlayerHooks.Methods.onPlayerKilled = function (self, Killer, Player) 
    local ctx = self:get()
    local player = Player:get()
    local killer = Killer:get()
    local cacheKey = "PlayerKilled"
    local cacheItem = {ctx, player, killer}
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    local playerState = Utils.GetPlayerState(player)
    local killerState = Utils.GetPlayerState(killer)
    Utils.Log("%s killed by %s", Utils.GetPlayerString(playerState), Utils.GetPlayerString(killerState))
    Utils.SayChat(string.format("%s killed %s", Utils.GetPlayerStr(killerState), Utils.GetPlayerStr(playerState)))
end

PlayerHooks.Methods.onPlayerWounded = function (self, Player, DamageAmount, DamageType, InstigatedBy, DamageCauser)
    local ctx = self:get()
    local player = Player:get()
    local damageAmount = DamageAmount:get()
    local damageType = DamageType:get()
    local instigatedBy = InstigatedBy:get()
    local damageCauser = DamageCauser:get()
    local cacheKey = "PlayerWounded"
    local cacheItem = {ctx, player, damageAmount, damageType, instigatedBy, damageCauser}
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    local playerState = Utils.GetPlayerState(player)
    local instigatorState = Utils.GetPlayerState(instigatedBy)
    local damageTypeStr = splitString(damageType:GetFullName()," ")[1]
    local damageCauserStr = splitString(damageCauser:GetFullName()," ")[1]
    Utils.Log("%s was wounded by %.1fHP (%s) from %s using %s",
        Utils.GetPlayerString(playerState), damageAmount, damageTypeStr, Utils.GetPlayerString(instigatorState), damageCauserStr
    )
end

PlayerHooks.Methods.onPlayerSuicide = function (self, Player)
    local ctx = self:get()
    local player = Player:get()
    local cacheKey = "PlayerSuicide"
    local cacheItem = { ctx, player }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    local state = Utils.GetPlayerState(player)
    Utils.Log("%s suicided", Utils.GetPlayerString(state))
    Utils.SayChat(string.format("%s suicided", Utils.GetPlayerStr(state)))
end
PlayerHooks.Methods.onPlayerDied = function (self, Player)
    local ctx = self:get()
    local player = Player:get()
    local cacheKey = "PlayerDied"
    local cacheItem = { ctx, player}
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    local state = Utils.GetPlayerState(player)
    Utils.Log("%s died", Utils.GetPlayerString(state))
end

PlayerHooks.Methods.onPlayerPostLogout = function (self, ExitingPlayer)
    local ctx = self:get()
    local player = ExitingPlayer:get()
    local cacheKey = "PlayerPostLogout"
    local cacheItem = { ctx, player }
    if PlayerHooks.Cache[cacheKey] then return end
    PlayerHooks.Cache[cacheKey] = cacheItem
    local state = Utils.GetPlayerState(player)
    Utils.Log("%s left the server", Utils.GetPlayerString(state))
    Utils.SayChat(string.format("%s left [%ims]", Utils.GetPlayerStr(state), state.Ping))
end


return PlayerHooks