local Loader = loadstring(game:HttpGet('https://raw.githubusercontent.com/stxxv/BedwarsDeps/main/main.lua'))()
local Client

do
    Client = Loader:GetMain('Client')
end

return {
    canUseAbility = function(self)
        return true
    end,
    useAbility = function(self, name, ...)
        return Client:Get('useAbility'):SendToServer(name, ...)
    end
}