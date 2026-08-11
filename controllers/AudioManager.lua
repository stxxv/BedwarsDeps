local cloneref = cloneref or function(obj)
    return obj
end

local SoundService = cloneref(game:GetService('SoundService'))

local AudioManager = {
	audioAssetConfigs = {},
	busesById = {},
	categoryBuses = {},
	audioPlayers = {}
}
AudioManager.__index = AudioManager

local Master = {
    bus = {
        id = 'GameAudio',
        category = nil
    },
    parent = nil
}

AudioManager.master = Master
AudioManager.busesById[Master.bus.id] = Master

local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))()
local AudioCategory
do
	AudioCategory = Loader:GetMeta('AudioCategory')
end

local Category = {
	AudioCategory.GAMEPLAY,
	AudioCategory.EFFECTS,
	AudioCategory.UI,
	AudioCategory.COSMETICS,
	AudioCategory.AMBIENCE,
	AudioCategory.MUSIC
}

for _, v in Category do
    local state = {
        bus = {
            id = 'Category.'..v,
            category = v
        },
        parent = Master
    }

    AudioManager.categoryBuses[v] = state
    AudioManager.busesById[state.bus.id] = state
end

function AudioManager:getCategoryBus(category)
    return self.categoryBuses[category] and self.categoryBuses[category].bus
end

function AudioManager:getBusById(id)
    return self.busesById[id] and self.busesById[id].bus
end

function AudioManager:registerAudioAsset(assetId, config)
    self.audioAssetConfigs[assetId] = config or {}
end

function AudioManager:createChildBus(id, parent)
    local parentState
    if type(parent) == 'string' then
        local pBus = self:getCategoryBus(parent)

        parentState = pBus and self.busesById[pBus.id]
    else
        parentState = parent and self.busesById[parent]
    end

    parentState = parentState or self.master
    
    local existing = self.busesById[id]
    if existing then
        if existing.parent ~= parentState then
            error('Audio bus '..id..' was registered beneath two different parents')
        end

        return existing.bus
    end

    local bus, state = {
        id = id,
        category = parentState.bus.category
    }
    state = {
        bus = bus,
        parent = parentState
    }

    self.busesById[id] = state
    return bus
end

function AudioManager:playAudio(assetId, options)
	options = options or {}

	local config = self.audioAssetConfigs[assetId] or {}
	local player = Instance.new('AudioPlayer')

	player.Asset = assetId
	player.Volume = options.volume or config.volume or 0.5
	player.PlaybackSpeed = options.playbackSpeed or config.playbackSpeed or 1

	player.Looping = options.looping or config.looping or false
    player:SetAttribute('AudioRollOffMaxDistance', (options.rollOffMaxDistance or config.rollOffMaxDistance) or 1)
    player:SetAttribute('AudioRollOffMinDistance', (options.rollOffMinDistance or config.rollOffMinDistance) or 1)

	local category, bus = options.category or config.category or AudioCategory.GAMEPLAY

	if type(options.bus) == 'string' then
		bus = self:getBusById(options.bus)
	elseif options.bus then
		bus = options.bus
	else
		bus = self:getCategoryBus(category)
	end

	if bus then
		player:SetAttribute('AudioBus', bus.id)
	end

	local parent = options.parent or SoundService
	player.Parent = parent

	self.audioPlayers[player] = true
	player.Ended:Once(function()
		self.audioPlayers[player] = nil

		if player.Parent then
			player:Destroy()
		end
	end)

	player:Play()
	return player
end

AudioManager.playSound = AudioManager.playAudio
function AudioManager:preload() end

return AudioManager