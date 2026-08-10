local cloneref = cloneref or function(obj)
    return obj
end

local HttpService = cloneref(game:GetService('HttpService'))

local Loader = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))()
local ItemMeta
do
    ItemMeta = Loader:getFile('ItemMeta', 'json')

    local suc, res = pcall(function()
        return HttpService:JSONDecode(ItemMeta)
    end)

    if suc then
        ItemMeta = res
    else
        error('Unable to parse JSON: report to .__stav on Discord')
    end
end

function ItemMeta.getItemMeta(item)
    return ItemMeta.items.item
end

return ItemMeta