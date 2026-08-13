--[[

    aids code but it gets the job done

]]

local cloneref = cloneref or function(obj)
    return obj
end

local ContextActionService = cloneref(game:GetService('ContextActionService'))
local InputService = cloneref(game:GetService('UserInputService'))
local TweenService = cloneref(game:GetService('TweenService'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/main.lua'))()
local fovController
do
    fovController = Loader:GetController('FovController')
end

local function isAlive()
	return (lplr.Character:FindFirstChildOfClass('Humanoid').Health > 0 and true) or false
end

local modifiers = {}
local SprintController, Connections = {
    getMovementStatusModifier = function(self)
        local speedboost, speedboostpie = (lplr.Character and lplr.Character:GetAttribute('SpeedBoost')), (lplr.Character and lplr.Character:GetAttribute('SpeedPieBuff'))
        if speedboost then
            modifiers = {
                moveSpeedMultiplier = speedboost
            }
        elseif speedboostpie then
            modifiers = {
                moveSpeedMultiplier = speedboostpie
            }
        else
            modifiers = {
                moveSpeedMultiplier = 1
            }
        end

        return {
            modifiers = modifiers
        }
    end,
    getModifiers = function(self)
        return modifiers
    end,
    blockSprint = false,
    sprinting = false
}, {}

lplr:GetAttributeChangedSignal('Sprinting'):Connect(function()
    local val = lplr:GetAttribute('Sprinting')
    if not isAlive() then return end

    do
        SprintController.sprinting = val
        for i,v in Connections do
            v:Disconnect()
            v = nil
        end
    end

    if val then
        lplr.Character.Humanoid.WalkSpeed = 20

        Connections.isAliveHook = lplr.CharacterAdded:Connect(function(char)
            repeat task.wait() until char ~= nil and char:FindFirstChildOfClass('Humanoid') ~= nil

            for i,v in Connections do
                if i == 'SpeedHook' then
                    v:Disconnect()
                    v = nil
                end
            end

            Connections.SpeedHook = lplr.Character.Humanoid:GetPropertyChangedSignal('WalkSpeed'):Connect(function()
                if lplr.Character.Humanoid.WalkSpeed ~= (20 * SprintController:getModifiers().moveSpeedMultiplier) then
                    lplr.Character.Humanoid.WalkSpeed = (20 * SprintController:getModifiers().moveSpeedMultiplier)
                end
            end)
        end)

        TweenService:Create(Workspace.CurrentCamera, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
            FieldOfView = (fovController:getFOV() <= 100 and fovController:getFOV() * 1.1) or fovController:getFOV()
        }):Play()
    else
        Connections.isAliveHook = lplr.CharacterAdded:Connect(function(char)
            repeat task.wait() until char ~= nil and char:FindFirstChildOfClass('Humanoid') ~= nil

            for i,v in Connections do
                if i == 'SpeedHook' then
                    v:Disconnect()
                    v = nil
                end
            end

            Connections.SpeedHook = lplr.Character.Humanoid:GetPropertyChangedSignal('WalkSpeed'):Connect(function()
                if lplr.Character.Humanoid.WalkSpeed ~= (14 * SprintController:getModifiers().moveSpeedMultiplier) then
                    lplr.Character.Humanoid.WalkSpeed = (14 * SprintController:getModifiers().moveSpeedMultiplier)
                end
            end)
        end)

        TweenService:Create(Workspace.CurrentCamera, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
            FieldOfView = fovController:getFOV()
        }):Play()
    end
end)

function SprintController:setBlocked(bool)
    self.blockSprint = bool

    if self.sprinting and self.blockSprint then
        self:stopSprinting()
    end
end

function SprintController:isSprinting()
    return self.sprinting
end

function SprintController:startSprinting()
    lplr:SetAttribute('Sprinting', true)
end

function SprintController:stopSprinting()
    lplr:SetAttribute('Sprinting', false)
end

if InputService.KeyboardEnabled then
    ContextActionService:BindActionAtPriority('Sprint', function(_, inputState, inputAction)
        if inputState == Enum.UserInputState.Begin then
            SprintController:startSprinting()
        elseif inputState == Enum.UserInputState.End then
            SprintController:stopSprinting()
        end

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.LeftShift)
end

return SprintController