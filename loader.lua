local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))

local bwdeps = {}

local function fetchFile(name, codeext)
    print('Fetching: '..name..'.'..codeext)
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/'..name..'.'..codeext))()
end

function bwdeps:GetController(name)
    return fetchFile('controllers/'..name..'/', 'lua')
end

function bwdeps:GetMeta(name)
    if name == 'ProdAnimation' or name == 'GameSound' then
        return fetchFile('definitions/'..name..'/', 'lua')
    end

    return HttpService:JSONDecode(fetchFile('definitions/'..name..'/', 'json'))
end

function bwdeps:GetMain(name)
    return fetchFile('main/'..name..'/', 'lua')
end

return bwdeps