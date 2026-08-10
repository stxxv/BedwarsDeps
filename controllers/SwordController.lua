local SwordController = {
    lastSwing = 0
}

local cloneref = cloneref or function(obj)
	return obj
end

local VirtualUser = cloneref(game:GetService('VirtualUser'))
local HttpService = cloneref(game:GetService('HttpService'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local ItemMeta = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/loader.lua'))():GetMeta('ItemMeta')
local function getItemMeta(item)
	return ItemMeta.items[item]
end

local function isAlive()
	return (lplr.Character:FindFirstChildOfClass('Humanoid').Health > 0 and true) or false
end

local PlayerGui = lplr.PlayerGui
lplr.CharacterAdded:Connect(function()
    PlayerGui = lplr.PlayerGui
end)

local function getBlockingUI(pos)
    local suc, res = pcall(function()
        return PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
    end)

    if suc then
        for _, v in res do
            if v.Visible and (v:IsA('TextButton') or obj:IsA('ImageButton') or obj:IsA('TextBox') or obj:IsA('Frame')) then
                return true
            end
        end
    end

    local sucCore, resCore = pcall(function()
        return CoreGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
    end)

    if sucCore then
        for _, v in resCore do
            if v.Visible and (v:IsA('TextButton') or obj:IsA('ImageButton') or obj:IsA('TextBox') or obj:IsA('Frame')) then
                return true
            end
        end
    end

    return false
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

    if getBlockingUI(Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)) then
        return
    end

    VirtualUser:ClickButton1(Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2))
end

function SwordController:playSwordEffect()
end

return SwordController