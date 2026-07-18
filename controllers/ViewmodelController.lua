local ViewmodelController = {
    tracks = {}
}

do
    AnimationUtil = loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/loader.lua'))():GetController('AnimationUtil')
end

function ViewmodelController:GetViewModel()
    return workspace.CurrentCamera.Viewmodel
end

function ViewmodelController:GetAnimator()
    if not self:GetViewModel() then return nil end
    if not self:GetViewModel():FindFirstChildOfClass('Humanoid') then return nil end
    if not self:GetViewModel():FindFirstChildOfClass('Humanoid'):FindFirstChildOfClass('Animator') then return nil end

    return self:GetViewModel():FindFirstChildOfClass('Humanoid'):FindFirstChildOfClass('Animator')
end

function ViewmodelController:PlayAnimation(animationType, config)
    if not self:GetAnimator() then return nil
    config = config or {}

    local animation = Instance.new('Animation')
    animation.AnimationId = 'rbxassetid://'..AnimationUtil:getAssetId(animationType)

    local track = self:GetAnimator():LoadAnimation(animation)
    track.Looped = config.looped or false
    track.Priority = config.priority or Enum.AnimationPriority.Action

    track:Play(config.fadeTime or 0)
    table.insert(self.tracks, track)

    return track
end

function ViewmodelController:StopAnimation(track, fadeTime)
    if track then
        table.remove(self.tracks, track)
        
        track:Stop(fadeTime or 0)
        track:Destroy()
    end
end

return ViewmodelController