local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))
local bwdeps = {}

local function wipeFolders()
    for _, v in {'compiler/cache/controllers', 'compiler/cache/definitions', 'compiler/cache/main'} do
        if isfolder(v) then
            for x, d in listfiles(v) do
                if string.find(d, 'commit.txt') then continue end

                if not isfolder(d) then
                    delfile(d)
                end
            end
        end
    end
end

for _, v in {'compiler', 'compiler/cache', 'compiler/cache/controllers', 'compiler/cache/definitions', 'compiler/cache/main'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local commit = HttpService:JSONDecode(game:HttpGet('https://codeberg.org/api/v1/repos/stav/BedwarsDeps/commits?limit=1'))[1].sha
if not isfile('compiler/commit.txt') then
    writefile('compiler/commit.txt', commit)
elseif readfile('compiler/commit.txt') ~= commit then
    wipeFolders()
    writefile('compiler/commit.txt', commit)
end

local function fetchFile(name, codeext)
    local time = os.clock()
    print('[COMPILER]: Fetching file: '..name)
    
	url = name:gsub('compiler/cache/', '')
	if not isfile(name) then
	    writefile(name, game:HttpGet(string.format('https://codeberg.org/stav/BedwarsDeps/raw/commit/%s/%s.%s', readfile('compiler/commit.txt'), url, codeext)))
	end
	
	repeat task.wait() until isfile(name)
    
    print(('[COMPILER]: Fetched file in %.3fs'):format(os.clock() - time))
	return readfile(name)
end

function bwdeps:GetJson(name)
    return HttpService:JSONDecode(fetchFile('compiler/cache/'..name, 'json'))
end

function bwdeps:GetController(name)
    return loadstring(fetchFile('compiler/cache/controllers/'..name, 'lua'))()
end

function bwdeps:GetMeta(name)
    if name == 'ProdAnimations' or name == 'GameSound' or name == 'ItemMeta' or name == 'GameSoundMeta' then
        return loadstring(fetchFile('compiler/cache/definitions/'..name, 'lua'))()
    end

    return HttpService:JSONDecode(fetchFile('compiler/cache/definitions/'..name, 'json'))
end

function bwdeps:GetMain(name)
    return loadstring(fetchFile('compiler/cache/main/'..name, 'lua'))()
end

return bwdeps