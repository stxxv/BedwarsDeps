local SwordController = {
    lastSwing = 0,
    lastAttack = 0,
    swingCounter = 0,
    thirdPersonAnimPlaying = false
}

local cloneref = cloneref or function(obj)
	return obj
end

local VirtualUser = cloneref(game:GetService('VirtualUser'))
local HttpService = cloneref(game:GetService('HttpService'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))()
local RandomUtil, AnimationUtil, ViewmodelController, SoundManager, AnimationType, GameSound
do
    ViewmodelController = Loader:GetController('ViewmodelController')
    AnimationUtil = Loader:GetController('AnimationUtil')
    SoundManager = Loader:GetController('SoundManager')
    AnimationType = Loader:GetMeta('AnimationType')
    RandomUtil = Loader:GetController('RandomUtil')
    GameSound = Loader:GetMeta('GameSound')
end

local function isAlive()
	return (lplr.Character:FindFirstChildOfClass('Humanoid').Health > 0 and true) or false
end

local PlayerGui = lplr.PlayerGui
lplr.CharacterAdded:Connect(function()
    PlayerGui = lplr.PlayerGui
end)

local function getBlockingUI(pos)
    local suc, res = pcall(function()
        return PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
    end)

    if suc then
        for _, v in res do
            if v.Visible and (v:IsA('TextButton') or obj:IsA('ImageButton') or obj:IsA('TextBox') or obj:IsA('Frame')) then
                return true
            end
        end
    end

    local sucCore, resCore = pcall(function()
        return CoreGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
    end)

    if sucCore then
        for _, v in resCore do
            if v.Visible and (v:IsA('TextButton') or obj:IsA('ImageButton') or obj:IsA('TextBox') or obj:IsA('Frame')) then
                return true
            end
        end
    end

    return false
end

do
	VirtualUser:CaptureController()
end

function SwordController:getHandItem()
	if not isAlive() then return end

    return lplr.Character:FindFirstChild('HandInvItem').Value
end

function SwordController:isClickingTooFast()
	if tick() - self.lastSwing < 0.1111111111111111 then -- this is bedwars logic man :pensive:
        return true
    end

    self.lastSwing = tick()
    return false
end

function SwordController:swingSwordAtMouse()
    if self:isClickingTooFast() then
    	return
    end

    if not isAlive() then
    	return
    end

    local item = self:getHandItem()
    if not item then
    	return
    end

    --[[if getBlockingUI(Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)) then
        return
    end]]

    VirtualUser:ClickButton1(Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2))
end

function SwordController:playSwordEffect(swordObj, chargedAttack)
    local sword, sword2, sword3 = {AnimationType.SWORD_SWING}, {AnimationType.FP_SWING_SWORD}, {GameSound.SWORD_SWING_1, GameSound.SWORD_SWING_2}
    chargedAttack = chargedAttack or false

    local randomize, animation = swordObj.sword and swordObj.sword.randomizeSwingAnimations
    animation = (randomize and RandomUtil.fromList(unpack(sword))) or sword[math.min(self.swingCounter, #sword - 1) + 1]

    if not self.thirdPersonAnimPlaying then
        self.thirdPersonAnimPlaying = true

        local track = AnimationUtil:playAnimation(lplr, animation, {fadeSamePriorityTracks = false})
        if track then
            track.Stopped:Connect(function()
                self.thirdPersonAnimPlaying = false
            end)
        else
            self.thirdPersonAnimPlaying = false
        end
    end

    if ViewmodelController:isVisible() then
        local fpAnim = (randomize and RandomUtil.fromList(unpack(sword2))) or sword2[math.min(self.swingCounter, #sword2 - 1) + 1]

        ViewmodelController:playAnimation(fpAnim)
    end

    if self.swingCounter + 1 < #sword then
        self.swingCounter += 1
    else
        self.swingCounter = 0
    end

    if #sword3 > 0 then
        SoundManager:playSound(RandomUtil.fromList(unpack(sword3)))
    end
end

return SwordController