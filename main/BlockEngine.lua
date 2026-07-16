local cloneref = cloneref or function(obj)
    return obj
end

local CollectionService = cloneref(game:GetService('CollectionService'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Store = {}

