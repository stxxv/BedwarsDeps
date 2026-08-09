local FOV = {
    fov = workspace.CurrentCamera.FieldOfView
}

function FOV:getFOV()
    return self.fov
end

function FOV:setFOV(fov)
    self.fov = fov
    workspace.CurrentCamera.FieldOfView = fov
end

return FOV