local cloneref = cloneref or function(obj)
    return obj
end

local CollectionService = cloneref(game:GetService('CollectionService'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Engine, Cache = {}, CollectionService:GetTagged('block')
local Positions = {}

do
    for i,v in Cache do
        table.insert(Positions, v.Position)
    end

    CollectionService:GetInstanceAddedSignal('block'):Connect(function(block)
        table.insert(Positions, block.Position)
    end)

    CollectionService:GetInstanceRemovedSignal('block'):Connect(function(block)
        if table.find(Positions, block.Position) then
            table.remove(Positions, table.find(Positions, block.Position))
        end
    end)
end

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
        return Positions
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