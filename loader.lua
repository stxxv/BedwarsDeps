local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))
local function wipeFolders()
    for _, v in {'compiler/cache/controllers', 'compiler/cache/definitions', 'compiler/cache/main'} do
        if isfolder(v) then
            print('[COMPILER]: Wiping '..v)
            for x, d in listfiles(v) do
                if not isfolder(d) then
                    delfile(d)
                end
            end
            print('[COMPILER]: Wiped '..v..'!')
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

return loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/main.lua'))()