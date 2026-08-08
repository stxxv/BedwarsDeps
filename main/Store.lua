local cloneref = cloneref or function(obj)
    return obj
end

local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local matchController
do
    matchController = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))():GetController('MatchController')
end

return {
    getState = function(self)
        return {
            Game = {
                matchState = matchController.matchState,
                queueType = workspace:GetAttribute('QueueType'),
                customMatch = {},
                myTeam = {
                    id = lplr:GetAttribute('Team')
                }
            }
        }
    end
}