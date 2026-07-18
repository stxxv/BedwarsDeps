local cloneref = cloneref or function(obj)
    return obj
end

local CollectionService = cloneref(game:GetService('CollectionService'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Engine, Cache = {}, CollectionService:GetTagged('Blocks')

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

Engine.Store = {
    getBlockAt = function(self, pos: Vector3)
        for i,v in Cache do
            if v.Position == pos then
                return v
            end
        end

        return nil
    end
}

function Engine:getBlockPosition(pos: Vector3)
    if not lplr.Character and lplr.Character.PrimaryPart then
        return nil
    end

    rayParams.FilterDescendantsInstances = {lplr.Character}

    local Origin = RootPart.Position
    local Offset = Position - Origin

    local BlockRaycast = workspace:Raycast(Origin, Offset, rayParams)
    if BlockRaycast and BlockRaycast.Instance and BlockRaycast.Instance.CanCollide then
        return BlockRaycast.Position
    end

    return nil
end

function Engine:getStore()
    return Engine.Store
end

return Engine