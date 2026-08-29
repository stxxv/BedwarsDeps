local bundler = loadstring(game:HttpGet('https://raw.githubusercontent.com/stxxv/BedwarsDeps/main/main.lua'))()
local AnimationUtil, SoundManager, AnimationType, GameSound, AudioCategory
do
    AnimationUtil = bundler:GetController('AnimationUtil')
    GameSound = bundler:GetMeta('GameSound').GameSound
    SoundManager = bundler:GetController('SoundManager')
    AnimationType = bundler:GetMeta('AnimationType')
end

return {
    playChestOpenAnimation = function(self, chest)
        if not chest:FindFirstChild('Model') or not chest:FindFirstChild('Model'):FindFirstChild('AnimationController') or not chest:FindFirstChild('Model'):FindFirstChild('AnimationController'):FindFirstChild('Animator') then
            SoundManager:playSound(GameSound.TREASURE_CHEST_UNLOCK, {
                position = chest.Position
            })

            return
        end
            
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