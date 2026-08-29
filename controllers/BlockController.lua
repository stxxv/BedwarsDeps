local BlockController = {
    isBlockBreakable = function()
        return true
    end
}

local cloneref = cloneref or function(obj)
    return obj
end
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Loader = loadstring(game:HttpGet('https://raw.githubusercontent.com/stxxv/BedwarsDeps/main/main.lua'))()
local BlockEngine, Client, Images
do
    BlockEngine = Loader:GetMain('BlockEngine')
    Client = Loader:GetMain('Client')
    Images = Loader:GetMeta('Images')
end

BlockController.getBlockPosition = BlockEngine.getBlockPosition
function BlockController:getStore()
    return {
        getBlockAt = function(self, pos)
            return BlockEngine.Store:getBlockAt(pos)
        end
    }
end

local function clientBlockPlace(itemType, pos)
    local Part = Instance.new('Part')
    Part.Size = Vector3.new(2.99, 2.99, 2.99)
    Part.Transparency = 0
    Part.CanCollide = true
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Anchored = true
    Part.CFrame = CFrame.new(pos)
    Part.Parent = workspace

    for _, v in Enum.NormalId:GetEnumItems() do
        local Texture = Instance.new('Decal')
        Texture.Parent = Part
        Texture.ZIndex = 2
        Texture.Texture = Images.block[itemType]
        Texture.Face = v
    end

    task.delay(0.5, function()
        Part:Destroy()
    end)
end

local function correctClientPosition(pos)
    local X = math.floor(pos.X / 3 + 0.5) * 3
    local Y = math.floor(pos.Y / 3) * 3
    local Z = math.floor(pos.Z / 3 + 0.5) * 3

    return Vector3.new(X, Y, Z)
end

function BlockController.correctBlockPosition(pos)
    local X = math.round(pos.X) / 3
    local Y = math.round(pos) / 3
    local Z = math.round(pos.Z) / 3

    return Vector3.new(X, Y, Z)
end

function BlockController:placeBlock(data)
    clientBlockPlace(data.itemType)
    data.position = self.correctBlockPosition(data.position)

    return Client:Get('PlaceBlock'):CallServerAsync({
        position = data.position,
        blockTytpe = data.itemType,
        blockdata = 0,
        mouseBlockInfo = {
            placementPosition = data.position
        }
    }).returned
end

return BlockController