return {
    getPlayerTeam = function(Player: Player)
        if not Player:IsA('Instance') then
            return nil
        end

        if not Player:IsA('Player') then
            return nil
        end

        if Player:GetAttribute('Team') then
            return {
                id = Player:GetAttribute('Team')
            }
        end
    end
}