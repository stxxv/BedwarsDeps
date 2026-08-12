local bundler = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))()
local AnimationUtil, SoundManager, AnimationType, GameSound, AudioCategory
do
    AnimationUtil = bundler:GetController('AnimationUtil')
    GameSound = bundler:GetMeta('GameSound').GameSound
    AudioManager = bundler:GetController('AudioManager')
    AnimationType = bundler:GetMeta('AnimationType')
    AudioCategory = bundler:GetMeta('AudioCategory')
end

return {
    playOpenChestAnimation = function(self, chest)
        local track = AnimationUtil:PlayAnimation(chest:WaitForChild('Model'):WaitForChild('AnimationController'):WaitForChild('Animator'), AnimationUtil:getAssetId(AnimationType.CHEST_OPEN))

        if not track then
            AudioManager:playSound(GameSound.TREASURE_CHEST_UNLOCK, {
                category = AudioCategory.UI
            })

            return
        end

        track:GetMarkerReachedSignal('open'):Connect(function()
            track:AdjustSpeed(0)
        end)

        AudioManager:playSound(GameSound.TREASURE_CHEST_UNLOCK, {
            category = AudioCategory.UI
        })

        return track
    end
}