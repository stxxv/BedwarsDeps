local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))
local function wipeFiles(old, new)
    local changes = HttpService:JSONDecode(game:HttpGet('https://api.github.com/repos/stxxv/BedwarsDeps/compare/'..old..'...'..new)).files

    for _, d in changes do
        for _, v in {d.filename, d.previous_filename} do
            if v then
                local time = os.clock()
                if isfile('compiler/cache/'..v) then
                    print('[COMPILER]: Deleting compiler/cache/'..v)
                    delfile('compiler/cache/'..v)
                    print(('[COMPILER]: Deleted file in %.3fs'):format(os.clock() - time))
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

local commit = HttpService:JSONDecode(game:HttpGet('https://api.github.com/repos/stxxv/BedwarsDeps/commits?per_page=1'))[1].sha
if not isfile('compiler/gitcommit.txt') then
    writefile('compiler/gitcommit.txt', commit)
elseif readfile('compiler/gitcommit.txt') ~= commit then
    wipeFiles(readfile('compiler/gitcommit.txt'), commit)
    writefile('compiler/gitcommit.txt', commit)
end

return loadstring(game:HttpGet('https://raw.githubusercontent.com/stxxv/BedwarsDeps/main/main.lua'))()