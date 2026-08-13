local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/main.lua'))()
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