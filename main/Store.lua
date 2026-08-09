local cloneref = cloneref or function(obj)
    return obj
end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))()
local Client, matchController
do
    Client = Loader:GetMain('Client')
    matchController = Loader:GetController('MatchController')
end

local Settings = setmetatable({
    enable_auto_deposit = true,
    clan_invites = false,
    mobile_auto_bridge_button = true,
    show_tips = false,
    global_chat_system_messages = false,
    lock_camaera = false,
    friendNotifications = true,
    backgroundMusicVolumeGame = 1,
    enable_on_screen_effects = false,
    ambient_lighting_brightness = 0,
    friendSpectating = false,
    show_resources_in_hud = true,
    show_recommended_shop = true,
    mobile_block_break_button = true,
    emote_volume = 1,
    mobileShiftLock = false,
    profile_visibility = 'public',
    pc_shift_lock = true,
    backgroundMusicVolume = 0.5,
    mobile_sword_hold = true,
    streamer_mode = false,
    fov = workspace.CurrentCamera.FieldOfView * 3,
    mobile_interact_button = true,
    mobile_projectile_button = true,
    pictureMode = false,
    exposure_compensation = 0
}, {
    __newindex = function(tbl, key, value)
        rawset(tbl, key, value)

        ReplicatedStorage.rbxts_include.node_modules['@rbxts'].net.out._NetManaged.SetSettings:FireServer(tbl)
    end
})

local Game, Bedwars = {
    matchState = matchController.matchState,
    queueType = workspace:GetAttribute('QueueType'),
    customMatch = {},
    myTeam = {
        id = lplr:GetAttribute('Team')
    }
}, {
    kit = lplr:GetAttribute('PlayingAsKits')
}

local Kits = {
    angelProgress = 0
}

do
    Client:OnEvent('AngelProgress', function(prog)
        Kits.angelProgress = prog.newProgress
    end)
end

local Store = {
    Game = Game,
    Settings = Settings,
    Bedwars = Bedwars,
    Kits = Kits
}

return {
    getState = function(self)
        return Store
    end
}