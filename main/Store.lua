local cloneref = cloneref or function(obj)
    return obj
end

local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local matchController
do
    matchController = loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/loader.lua'))():GetControllers('MatchController')
end

return {
    getState = function(self)
        return {
            Game = {
                matchState = matchController.matchState,
                queueType = workspace:GetAttribute('QueueType')
                customMatch = {},
                myTeam = {
                    id = lplr:GetAttribute('Team')
                }
            }
        }
    end
}