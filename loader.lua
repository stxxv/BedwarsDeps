local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))
local bwdeps = {}

local function fetchFile(name, codeext)
    local time = os.clock()
    print('[COMPILER]: Fetching file: '..name)

    local file = game:HttpGet(string.format('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/%s.%s', name, codeext))
    print(('[COMPILER]: Fetched file in %.3fs'):format(os.clock() - time))

    return file
end

function bwdeps:GetController(name)
    return loadstring(fetchFile('controllers/'..name, 'lua'))()
end

function bwdeps:GetMeta(name)
    if name == 'ProdAnimations' or name == 'GameSound' then
        return loadstring(fetchFile('definitions/'..name, 'lua'))()
    end

    return HttpService:JSONDecode(fetchFile('definitions/'..name, 'json'))
end

function bwdeps:GetMain(name)
    return loadstring(fetchFile('main/'..name, 'lua'))()
end

return bwdeps