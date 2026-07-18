return {
    getPlayerTeam = function(Player: Player)
        if not Player or not Player:IsA('Player') then
            return nil
        end

        return Player:GetAttribute('Team')
    end
}