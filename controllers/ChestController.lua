local bundler = loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/loader.lua'))()
local AnimationUtil, SoundManager, AnimationType
do
    AnimationUtil = bundler:LoadController('AnimationUtil'),
    SoundEngine = bundler:LoadController('SoundEngine'),
    AnimationType = bundler:LoadMeta('AnimationType')
end

return {
    playOpenChestAnimation = function(self, chest)
        local track = AnimationUtil:PlayAnimation(chest:WaitForChild('Model'):WaitForChild('AnimationController'):WaitForChild('Animator'), AnimationUtil:getAssetId(AnimationType.CHEST_OPEN))
    end
}