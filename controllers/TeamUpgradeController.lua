local Client
do
    Client = loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/loader.lua'))():GetMain('Client')
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