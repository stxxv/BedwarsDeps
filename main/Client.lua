local cloneref = cloneref or function(obj)
    return obj
end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local Client, Cache = {}, {}

task.spawn(function()
    for _, v in ReplicatedStorage:GetDescendants() do
        if v:IsA('RemoteEvent') then
            table.insert(Cache, {
                inst = v,
                SendToServer = function(self, ...)
                    v:FireServer(...)
                end,
                Connect = function(self, func)
                    return v.OnClientEvent:Connect(func)
                end
            })
        elseif v:IsA('RemoteFunction') then
            table.insert(Cache, {
                inst = v,
                CallServerAsync = function(self, ...)
                    local val = v:InvokeServer(...)

                    return {
                        andThen = function(self, func)
                            func(val)
                        end,
                        returned = val,
                    }
                end,
                Connect = function(self, func)
                    v.OnClientInvoke = func
                end
            })
        end
    end
end)

function Client.Get(self, name)
    for _, v in Cache do
        if v.inst.Name == name then
            return v
        end
    end

    return nil
end
Client.WaitFor = Client.Get

function Client:GetNamespace(name)
    return {Get = Client.Get}
end

return Client