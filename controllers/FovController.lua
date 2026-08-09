local FOV = {
    fov = workspace.CurrentCamera.FieldOfView
}

local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))()
local Store
do
    Store = Loader:GetMain('Store')
end

function FOV:getFOV()
    return self.fov
end

function FOV:setFOV(fov)
    self.fov = fov
    workspace.CurrentCamera.FieldOfView = fov

    Store:getState().Settings.fov = math.min(360, self.fov * 3)
end

return FOV