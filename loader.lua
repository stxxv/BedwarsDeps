local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))
local env = (type(getgenv) == 'function' and getgenv()) or _G

if not env.HTTPCache then
    env.HTTPCache = {}
end

local bwdeps, Cache = {}, env.HTTPCache

local function fetchFile(name, codeext)
    local time = os.clock()
    print('[COMPILER]: Fetching file: '..name)

    if Cache[name] and Cache[name].ext == codeext then
        print(('[COMPILER]: Fetched file in %.3fs'):format(os.clock() - time))
        return Cache[name].file
    end

    local suc, res = pcall(function()
        return game:HttpGet(string.format('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/%s.%s', name, codeext))
    end)

    if suc then
        Cache[name] = {
            file = res,
            ext = codeext
        }

        print(('[COMPILER]: Fetched file in %.3fs'):format(os.clock() - time))
        return Cache[name].file
    end

    return warn('[COMPILER]: Unable to fetch file: '..name)
end

function bwdeps:GetJson(name)
    return HttpService:JSONDecode(fetchFile(name, 'json'))
end

function bwdeps:GetController(name)
    return loadstring(fetchFile('controllers/'..name, 'lua'))()
end

function bwdeps:GetMeta(name)
    if name == 'ProdAnimations' or name == 'GameSound' or name == 'ItemMeta' or name == 'GameSoundMeta' then
        return loadstring(fetchFile('definitions/'..name, 'lua'))()
    end

    return HttpService:JSONDecode(fetchFile('definitions/'..name, 'json'))
end

function bwdeps:GetMain(name)
    return loadstring(fetchFile('main/'..name, 'lua'))()
end

return bwdeps