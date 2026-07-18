local bundler = loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/loader.lua'))()
local AnimationUtil, SoundManager, AnimationType, GameSound
do
    AnimationUtil = bundler:GetController('AnimationUtil'),
    SoundManager = bundler:GetController('SoundManager'),
    AnimationType = bundler:GetMeta('AnimationType'),
    GameSound = bundler:GetMeta('GameSound')
end

return {
    playOpenChestAnimation = function(self, chest)
        local track = AnimationUtil:PlayAnimation(chest:WaitForChild('Model'):WaitForChild('AnimationController'):WaitForChild('Animator'), AnimationUtil:getAssetId(AnimationType.CHEST_OPEN))

        if not track then
            SoundManager:playSound(GameSound.TREASURE_CHEST_UNLOCK, {
                position = chest.Position
            })

            return
        end

        track:GetMarkerReachedSignal('open'):Connect(function()
            track:AdjustSpeed(0)
        end)

        SoundManager:playSound(GameSound.TREASURE_CHEST_UNLOCK, {
            position = chest.Position
        })

        return track
    end
}