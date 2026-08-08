local SwordController = {
    lastSwing = 0
}

local cloneref = cloneref or function(obj)
	return obj
end

local VirtualUser = cloneref(game:GetService('VirtualUser'))
local HttpService = cloneref(game:GetService('HttpService'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local ItemMeta = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))():GetMeta('ItemMeta')
local function getItemMeta(item)
	return ItemMeta.items[item]
end

local function isAlive()
	return (lplr.Character:FindFirstChildOfClass('Humanoid').Health > 0 and true) or false
end

do
	VirtualUser:CaptureController()
end

function SwordController:getHandItem()
	if not isAlive() then return end

    return lplr.Character:FindFirstChild('HandInvItem').Value
end

function SwordController:isClickingTooFast()
	if tick() - self.lastSwing < 0.1111111111111111 then -- this is bedwars logic man :pensive:
        return true
    end

    self.lastSwing = tick()
    return false
end

function SwordController:swingSwordAtMouse()
    if self:isClickingTooFast() then
    	return
    end

    if not isAlive() then
    	return
    end

    local item = self:getHandItem()
    if not item then
    	return
    end

    VirtualUser:ClickButton1(Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2))
end

return SwordController