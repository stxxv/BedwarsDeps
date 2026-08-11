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

    Store:getState().Settings.fov = math.min(130, workspace.CurrentCamera.FieldOfView + 10)
end

workspace.CurrentCamera:GetPropertyChangedSignal('FieldOfView'):Connect(function()
    if FOV.fov ~= workspace.CurrentCamera.FieldOfView then
        FOV:setFOV(FOV.fov)
    end
end)

return FOV