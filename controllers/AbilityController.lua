local cloneref = cloneref or function(obj)
    return obj
end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
return {
    canUseAbility = function(self)
        return true
    end,
    useAbility = function(self, name, ...)
        return ReplicatedStorage["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].useAbility:FireServer(name, ...)
    end
}