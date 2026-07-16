local cloneref = cloneref or function(obj)
    return obj
end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Store = {}

function Store:getState()
    return {
        Game = {
            matchState = 0,
            queueType = workspace:GetAttribute('QueueType')
            customMatch = {},
            myTeam = {
                id = lplr:GetAttribute('Team')
            }
        }
    }
end