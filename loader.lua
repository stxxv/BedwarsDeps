local bwdeps = {}

local function fetchFile(name, type)
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies'))()
end

function bwdeps:GetController(name)
end