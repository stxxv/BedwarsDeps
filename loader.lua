local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))
local gitCommit, bwdeps = HttpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/BedwarsDependencies/commits/main')).sha, {}

local function fetchFile(name, codeext)
    local time = os.clock()
    print('[COMPILER] Fetching file: '..name)

    local file = game:HttpGet(string.format('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/%s/%s.%s', gitCommit, name, codeext))
    print(('[COMPILER]: Fetched in %.3fs'):format(os.clock() - time))

    return file
end

function bwdeps:GetController(name)
    return loadstring(fetchFile('controllers/'..name, 'lua'))()
end

function bwdeps:GetMeta(name)
    if name == 'ProdAnimation' or name == 'GameSound' then
        return loadstring(fetchFile('definitions/'..name, 'lua'))()
    end

    return HttpService:JSONDecode(fetchFile('definitions/'..name, 'json'))
end

function bwdeps:GetMain(name)
    return loadstring(fetchFile('main/'..name, 'lua'))()
end

return bwdeps