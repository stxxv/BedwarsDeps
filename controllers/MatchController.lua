
local cloneref = cloneref or function(obj)
    return obj
end

local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Client
do
    Client = loadstring(game:HttpGet('https://raw.githubusercontent.com/stxxv/BedwarsDeps/main/main.lua'))():GetMain('Client')
end

local timer
local function getTimerTxt(text)
    return text:match('^%d%d:%d%d$') ~= nil
end

for _, v in lplr:WaitForChild('PlayerGui'):FindFirstChild('TopBarAppGui'):FindFirstChild('TopBarApp'):GetDescendants() do
    if v:IsA('TextLabel') and getTimerTxt(v.Text) then
        if not timer or (timer and (v.AbsolutePosition.X > timer.AbsolutePosition.X)) then
            timer = v
        end
    end
end

if not timer then
    return {
        matchState = 0,
        getMatchState = function(self)
            return self.matchState
        end
    }
end

local matchController = {
    Name = 'MatchController',
    matchState = 0
}

local timersecs, lasttimersecs = 0, 0

task.spawn(function()
	repeat task.wait()
		timersecs = tonumber(timer.Text:split(':')[2])
	until matchController.matchState == 2
end)

task.spawn(function()
	repeat
        lasttimersecs = timersecs
        task.wait()
    until timersecs > lasttimersecs

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