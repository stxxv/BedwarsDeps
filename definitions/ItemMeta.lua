local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))

local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))()
local ItemMeta
do
    ItemMeta = Loader:GetJson('definitions/ItemMeta')
end

function ItemMeta.getItemMeta(item)
    return ItemMeta[item]
end

return ItemMeta