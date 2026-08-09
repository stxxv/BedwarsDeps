--[[

    aids code but it gets the job done

]]

local cloneref = cloneref or function(obj)
    return obj
end

local TweenService = cloneref(game:GetService('TweenService'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))()
do
    local fovController = Loader:GetController('FovController')
end

local function isAlive()
	return (lplr.Character:FindFirstChildOfClass('Humanoid').Health > 0 and true) or false
end

local modifiers = {}
local SprintController, Connections = {
    getMovementStatusModifier = function(self)
        local speedboost, speedboostpie = lplr.Character and lplr.Character:GetAttribute('SpeedBoost'), lplr.Character and lplr.Character:GetAttribute('SpeedPieBuff')
        if speedboost then
            modifiers[{
                moveSpeedMultiplier = speedboost
            }] = true
        elseif speedboostpie then
            modifiers[{
                moveSpeedMultiplier = speedboostpie
            }] = true
        else
            modifiers = {}
        end

        return {
            modifiers = modifiers
        }
    end,
    getModifiers = function(self)
        return modifiers
    end,
    sprinting = false
}, {}

lplr:GetAttributeChangedSignal('Sprinting'):Connect(function()
    local val = lplr:GetAttribute('Sprinting')
    if not isAlive() then return end

    do
        SprintController.sprinting = val
        if Connections.SpeedHook then
            Connections.SpeedHook:Disconnect()
            Connections.SpeedHook = nil
        end
    end

    if val then
        lplr.Character.Humanoid.WalkSpeed = 20

        Connections.SpeedHook = lplr.Character.Humanoid:GetPropertyChangedSignal('WalkSpeed'):Connect(function()
            if lplr.Character.Humanoid.WalkSpeed ~= 20 then
                lplr.Character.Humanoid.WalkSpeed = 20
            end
        end)

        TweenService:Create(Workspace.CurrentCamera, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
            FieldOfView = (fovController:getFOV() <= 100 and fovController:getFOV() * 1.1) or fovController:getFOV()
        }):Play()
    else
        Connections.SpeedHook = lplr.Character.Humanoid:GetPropertyChangedSignal('WalkSpeed'):Connect(function()
            if lplr.Character.Humanoid.WalkSpeed ~= 14 then
                lplr.Character.Humanoid.WalkSpeed = 14
            end
        end)

        TweenService:Create(Workspace.CurrentCamera, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
            FieldOfView = fovController:getFOV()
        }):Play()
    end
end)

function SprintController:isSprinting()
    return self.sprinting
end

function SprintController:startSprinting()
    lplr:SetAttribute('Sprinting', true)
end

function SprintController:stopSprinting()
    lplr:SetAttribute('Sprinting', false)
end

return SprintController