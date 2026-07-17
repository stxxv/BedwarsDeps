local Client
do
    Client = loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/BedwarsDependencies/refs/heads/main/loader.lua'))():GetMain('Client')
end

return {
    joinQueue = function(self, queue)
        Client:Get('joinQueue'):SendToServer({
            ['queueType'] = queue
        })
    end
}