local Client
do
    Client = loadstring(game:HttpGet('https://codeberg.org/stav/BedwarsDeps/raw/branch/main/main.lua'))():GetMain('Client')
end

return {
    joinQueue = function(self, queue)
        Client:Get('joinQueue'):SendToServer({
            ['queueType'] = queue
        })
    end
}