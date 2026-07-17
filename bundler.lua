--[[

    Used to compile files with a good executor that has proper debug and require capabilities.

]]

assert(isfolder, 'no folder functions :(')
assert(delfolder, 'no folder functions :(')
assert(makefolder, 'no folder functions :(')

assert(writefile, 'no file functions :(')
assert(require, 'no require functions :(')
assert(getscriptbytecode, 'no bytecode function (needed for decompiler to work)')

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
    ProdAnimations = ReplicatedStorage.TS.animation.definitions["prod-animations"],
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

local time = os.time()

local function makefolder(folder)
    print('[BUNDLER]: Making folder: '..folder)
    getgenv().makefolder(folder)
end

local function delfolder(folder)
    print('[BUNDLER]: Deleting folder: '..folder)
    getgenv().delfolder(folder)
end

local function writefile(name, file)
    print('[BUNDLER]: Writing file: '..name..' to compiler')
    getgenv().writefile(name, file)
end

for _, v in {'compiler', 'compiler/definitions', 'compiler/controllers'} do
    if not isfolder(v) then
        makefolder(v)
    else
        delfolder(v)
        makefolder(v)
    end
end

print('[BUNDLER]: Fetching definitions.. (requires a good executor to require stuff, will error if bad!!)')
for i,v in Definitions do
    if i == 'ProdAnimations' then
        writefile('compiler/definitions/'..i..'.lua', decompile(v))
        continue
    end
    
    writefile('compiler/definitions/'..i..'.json', HttpService:JSONEncode(v))
end

print('[BUNDLER]: Fetching controllers..')
for i,v in Controllers do
    writefile('compiler/controllers/'..i..'.lua', decompile(v))
end

print('[BUNDLER]: Completed in: '..(os.time() - time)..' seconds, feel free to star if you\'re using the BedwarsDependencies bundler for your script!')