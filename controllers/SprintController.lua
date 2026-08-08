--[[

    to-do: add proper Sprint on attribute change (Sprinting)

]]

local cloneref = cloneref or function(obj)
    return obj
end

local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local modifiers = {}

return {
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
    end
}