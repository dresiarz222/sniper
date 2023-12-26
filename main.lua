--[[ 
getgenv().configuration = {
    blacklistedIds = {
        4525682048,
        4576426766,
        4576921176,
        4531914489,
        4576425139,
        4576430043,
    },
    hopTime = 300,
}
--]]
task.wait()
game.RunService:Set3dRenderingEnabled(false)
task.wait(30)
timestart = tick()

if table.find(configuration.blacklistedIds,game.Players.LocalPlayer.UserId) then
    table.remove(configuration.blacklistedIds,table.find(configuration.blacklistedIds,game.Players.LocalPlayer.UserId))
end

local Players = game:GetService("Players") 
local LocalPlayer = Players.LocalPlayer 
local Character = LocalPlayer.Character 
local Humanoid = Character:WaitForChild("Humanoid", 1000) 
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 1000) 
local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local HttpService = game:GetService("HttpService") 
local TeleportService = game:GetService("TeleportService") 
local Library = require(ReplicatedStorage:WaitForChild("Library", 2000)) 
if not Library.Loaded then repeat task.wait() until Library.Loaded ~= false end 
local RandomEventCmds = Library.RandomEventCmds 

getgenv().config = {
    placeId = 15502339080,
    servers = {
        count = 10, 
        sort = "Desc", 
        pageDeep = math.random(2, 6),
    },
}

function jumpToPlaza() 
    local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true" 
    local req = request({ Url = string.format(sfUrl, config.placeId, config.servers.sort, config.servers.count) }) 
    local body = HttpService:JSONDecode(req.Body) 
    if config.servers.pageDeep > 1 then 
        for i = 1, config.servers.pageDeep, 1 do 
            req = request({ Url = string.format( sfUrl .. "&cursor=" .. body.nextPageCursor, config.placeId, config.servers.sort, config.servers.count ), }) 
            body = HttpService:JSONDecode(req.Body) 
            task.wait(0.2) 
        end 
    end 
            local servers = {} 
            if body and body.data then 
                for i, v in next, body.data do 
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing > 40 and v.playing < v.maxPlayers and v.id ~= game.JobId then 
                        table.insert(servers, 1, v.id) 
                    end 
                end 
            end 
            local randomCount = #servers 
            if not randomCount then 
                randomCount = 2 
            end 
            TeleportService:TeleportToPlaceInstance(config.placeId, servers[math.random(1, randomCount)], Players.LocalPlayer) 
end 

function checklisting(uid, gems, item, version, shiny, amount, username, playerid)
    -- version 2 is rainbow
    -- version 1 is golden
    -- shiny is nil if not shiny
    gems = tonumber(gems)
    typeofpet = {}
    pcall(function()
        typeofpet = Library.Directory.Pets[item]
    end)
    if item == "Banana" or
    string.find(string.lower(item), "seed") or
    string.find(string.lower(item), "boot") or 
    string.find(item, "Potion") then
        return
    end
    if typeofpet.huge and gems <= 2000000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif typeofpet.titanic then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif typeofpet.exclusiveLevel and gems <= 25000 and item ~= "Banana" and item ~= "Coin Plant Seed" then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif typeofpet.exclusiveLevel and version == 2 and gems <= 250000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif typeofpet.exclusiveLevel and shiny and gems <= 50000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(item, "Egg") and string.find(item, "Exclusive") and gems <= 50000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(item, "Titanic") and string.find(item, "Present") and gems <= 300000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(string.lower(item), "strength charm") and gems <= 100000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(string.lower(item), "royalty charm") and gems <= 1000000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(item,)
    elseif gems <= 10 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    end
end

function listing_listener()
    local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
    Booths_Broadcast.OnClientEvent:Connect(function(username, message)
        if not message then
            return
        end
        local playerID = message['PlayerID']
        if type(message) == "table" then
            local listing = message["Listings"]
            for key, value in pairs(listing) do
                if type(value) == "table" then
                    local uid = key
                    local gems = value["DiamondCost"]
                    local itemdata = value["ItemData"]

                    if itemdata then
                        local data = itemdata["data"]

                        if data then
                            local item = data["id"]
                            local version = data["pt"]
                            local shiny = data["sh"]
                            local amount = data["_am"]
                            checklisting(uid, gems, item, version, shiny, amount, username , playerID)
                        end
                    end
                end
            end
        end
    end)
print("initiated")
end

function checkIfSnipersIngame()
    for i,v in ipairs(game:GetService("Players"):GetChildren()) do
        if table.find(configuration.blacklistedIds,v.UserId) then
            return true
        end
    end
    return false
end

task.spawn(function() 
    while task.wait(60) do
        print("checking")
        if #game.Players:GetPlayers() < 35 then
            jumpToPlaza()
        end
        print("continuing, there are this many players: "..#game.Players:GetPlayers().." or with getchildren: "..#game.Players:GetChildren())
    end
end)

if game.PlaceId == 15502339080 and checkIfSnipersIngame() == false then
    listing_listener()
elseif game.PlaceId ~= 15502339080 or checkIfSnipersIngame() == true then
    print("hopping cuz "..tostring(checkIfSnipersIngame()).." is true or place is: "..game.PlaceId)
    task.wait(20)
    jumpToPlaza()
end

