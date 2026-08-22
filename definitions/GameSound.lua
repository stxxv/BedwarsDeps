-- https://lua.expert/

local Loader = loadstring(game:HttpGet('https://raw.githubusercontent.com/stxxv/BedwarsDeps/main/main.lua'))()
local t, GameSoundMeta, AudioManager
do
	t = Loader:GetJson('definitions/GameSound')
	GameSoundMeta = Loader:GetMeta('GameSoundMeta')
	SoundManager = Loader:GetController('SoundManager')
end

GameSoundMeta.registerGameSounds(t)
SoundManager:preload()

return {
	GameSound = t
}