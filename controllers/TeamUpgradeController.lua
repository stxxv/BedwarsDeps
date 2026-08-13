local Client
do
    Client = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/main.lua'))():GetMain('Client')
end

local Upgrades = {}

Client:Get('BulkUpdateTeamUpgrades'):Connect(function(upgrade)
    Upgrades = upgrade
end)

Client:Get('TeamUpgradePurchased'):Connect(function(teamId, upgrade)
    Upgrades = upgrade
end)

return {
    currentUpgrades = Upgrades,
    requestPurchaseTeamUpgrade = function(self, data)
        return Client:Get('RequestPurchaseTeamUpgrade'):CallServer(data)
    end
}