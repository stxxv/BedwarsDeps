local Client
do
    Client = loadstring(game:HttpGet('https://raw.githubusercontent.com/stxxv/BedwarsDeps/main/main.lua'))():GetMain('Client')
end

return {
    joinQueue = function(self, queue)
        Client:Get('joinQueue'):SendToServer({
            ['queueType'] = queue
        })
    end
}