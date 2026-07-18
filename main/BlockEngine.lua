local cloneref = cloneref or function(obj)
    return obj
end

local CollectionService = cloneref(game:GetService('CollectionService'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Engine, Cache = {}, CollectionService:GetTagged('block')

Engine.Store = {
    getBlockAt = function(self, pos: Vector3)
        for i,v in Cache do
            if v.Position == pos then
                return v
            end
        end

        return nil
    end,
    getAllBlockPositions = function(self)
        local positions = {}

        for i,v in Cache do
            table.insert(positions, v.Position)
        end

        return positions
    end
}

function Engine:getBlockPosition(pos: Vector3)
    local blockPos = pos / 3

    return Vector3.new(math.round(blockPos.X), math.round(blockPos.Y), math.round(blockPos.Z))
end

function Engine:getStore()
    return Engine.Store
end

return Engine