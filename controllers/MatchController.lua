local cloneref = cloneref or function(obj)
    return obj
end

local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Client
do
    Client = loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/loader.lua'))():GetMain('Client')
end

local matchController, timer = {
    Name = 'MatchController',
    matchState = 0
}, lplr:WaitForChild('PlayerGui'):WaitForChild('TopBarAppGui'):WaitForChild('TopBarApp'):FindFirstChild('2'):FindFirstChild('5')

local timersecs, lasttimersecs = 0, 0

task.spawn(function()
	repeat task.wait()
		seconds = tonumber(matchTimer.Text:split(':')[2])
	until matchController.matchState == 2
end)

task.spawn(function()
	repeat lastSeconds = seconds task.wait() until seconds > lastSeconds

	matchController.matchState = 1;
end)

do
    Client:Get('MatchEndEvent'):Connect(function(table)
        matchController.matchState = 2
    end)
end

function matchController:getMatchState()
    return self.matchState
end

return matchController