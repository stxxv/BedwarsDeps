local bwdeps = {}

local function fetchFile(name, type)
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/'..name..'.'..type))()
end

function bwdeps:GetController(name)
    return fetchFile('controllers/'..name..'/', 'lua')
end

function bwdeps:GetMeta(name)
    return fetchFile('definitions/'..name..'/', 'json')
end

function bwdeps:GetMain(name)
    return fetchFile('main/'..name..'/', 'lua')
end

return bwdeps