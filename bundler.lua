--[[

    Used to compile files with a good executor that has proper debug and require capabilities.

]]

local cloneref = cloneref or function(obj)
    return obj
end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local HttpService = cloneref(game:GetService('HttpService'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Definitions = {
    DamageTypes = require(ReplicatedStorage.TS.damage["damage-type"]).DamageType,
    MatchStates = require(ReplicatedStorage.TS.match["match-state"]).MatchState,
    ItemMeta = require(ReplicatedStorage.TS.item["item-meta"]).items,
    AnimationType = require(ReplicatedStorage.TS.animation["animation-type"]).AnimationType,
    ProdAnimations = require(ReplicatedStorage.TS.animation.definitions["prod-animations"]).ProdAnimations,
    ProjectileMeta = require(ReplicatedStorage.TS.projectile["projectile-meta"]).ProjectileMeta,
    TeamUpgradeMeta = debug.getupvalue(require(ReplicatedStorage.TS.games.bedwars["team-upgrade"]["team-upgrade-meta"]).getTeamUpgradeMetaForQueue, 2),
    AppIds = require(lplr.PlayerScripts.TS.ui.types["app-config"]).BedwarsAppIds,
    SummonerKitBalance = require(ReplicatedStorage.TS.games.bedwars.kit.kits.summoner["summoner-kit-balance"]).SummonerKitBalance,
    GameSound = require(game:GetService("ReplicatedStorage").TS.sound["game-sound"]).GameSound
}

local Controllers = {
    Network = lplr.PlayerScripts.TS.lib.network,
    GameQuery = ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["game-core"].out.shared["game-world-query"]["game-query-util"]
}

for _, v in {'compiler', 'compiler/definitions', 'compiler/controllers'} do
    if not isfolder(v) then
        makefolder(v)
    else
        delfolder(v)
        makefolder(v)
    end
end

for i,v in Definitions do
    writefile('compiler/definitions/'..i..'.json', HttpService:JSONEncode(v))
end

for i,v in Controllers do
    writefile('compiler/controllers/'..i..'.lua', decompile(v))
end