UserSettings().GameSettings.MasterVolume = 0
game.RunService:Set3dRenderingEnabled(false)

pcall(function()
setfps(10)
setfpscap(10)
end)

if not waittime then
    waittime = 25
end

task.wait(waittime)

getgenv().configuration = {
    blacklistedIds = {
        4525682048,
        4576426766,
        4576921176,
        4531914489,
        4576425139,
        4576430043,
    },
    hopTime = 600,
}


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

getgenv().config = {
    placeId = 15502339080,
    servers = {
        count = 100, 
        sort = "Desc",
        pageDeep = 1,
    },
}

function jumpToPlaza()
    local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true" 
    local reqUrl = string.format(sfUrl, config.placeId, config.servers.sort, config.servers.count)
    local req = request({ Url = reqUrl })
    local body = HttpService:JSONDecode(req.Body) 
    local servers = {} 
    if body and body.data then 
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing >= 40 and v.playing < 47 and v.id ~= game.JobId then 
                table.insert(servers, 1, v.id) 
            end 
        end 
    end
    print("printing server found count")
    print(#servers)
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(config.placeId, servers[math.random(1, #servers)], Players.LocalPlayer) 
    else
        task.wait(waittime)
        jumpToPlaza()
        return
    end      
end 

function checklisting(uid, gems, item, version, shiny, amount, username, playerid, method)
    gems = tonumber(gems)
    typeofpet = {}
    pcall(function() 
        typeofpet = Library.Directory.Pets[item]
    end)
    if item == "Banana" or item == "Coin" then
        return
    end
    if typeofpet.huge and gems <= 2000000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif typeofpet.exclusiveLevel and gems <= 25000  then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif typeofpet.exclusiveLevel and version == 2 and gems <= 300000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif typeofpet.exclusiveLevel and shiny and gems <= 50000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif item == "Crystal Key" and gems <= 10000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif item == "Chest Mimic" and gems <= 1500000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif item == "Diamond Chest Mimic" and gems <= 1500000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif item == "Lucky Block" and gems <= 500000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif item == "Spinny Wheel Ticket" and gems <= 2500 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(item, "Titanic") and string.find(item, "Present") and gems <= 50000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(string.lower(item), "strength charm") and gems <= 100000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(string.lower(item), "royalty charm") and gems <= 1000000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    elseif string.find(item, "Egg") and string.find(item, "Exclusive") and gems <= 200000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
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
    for i,v in ipairs(game:GetService("Players"):GetPlayers()) do
        if table.find(configuration.blacklistedIds,v.UserId) then
            return true
        end
    end
    return false
end

function optimize()
    for i,v in ipairs(game.Players:GetPlayers()) do
        if v.UserId ~= LocalPlayer.UserId then
            v.Character:ClearAllChildren()
        end
    end
    HumanoidRootPart.Anchored = true
    task.wait(waittime)
    HumanoidRootPart.CFrame = CFrame.new(10000+math.random(1,2),10000+math.random(1,2),10000+math.random(1,2))
end

TeleportService.TeleportInitFailed:Connect(function(player, resultEnum, msg) 
    task.wait(waittime)
    jumpToPlaza()
end)

function antiafk()
    local vu = game:GetService("VirtualUser")
    Players.LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

if game.PlaceId == 15502339080 and checkIfSnipersIngame() == false then
    task.wait(waittime)
    task.spawn(optimize)
    antiafk()
    if not ReplicatedStorage:FindFirstChild("Library") then
        print("library bugged, hopping")
        jumpToPlaza()
        return
    end
    Library = require(ReplicatedStorage.Library)
    task.wait(5)
    listing_listener()
    task.spawn(function()
        while task.wait(10) do
            if #game.Players:GetPlayers() < 30 and tick() - timestart < configuration.hopTime then
                jumpToPlaza()
                return
            end
        end
    end)
    task.wait(configuration.hopTime)
    jumpToPlaza()
elseif game.PlaceId == 15502339080 and checkIfSnipersIngame() == true then
    print("alt in plaza soooo... bye !")
    print("waiting this much")
    print(table.find(configuration.blacklistedIds,LocalPlayer.UserId)*5)
    task.wait((table.find(configuration.blacklistedIds,LocalPlayer.UserId)*5))
    jumpToPlaza()
elseif game.PlaceId ~= 15502339080 then
    print("hopping cuz place is: "..game.PlaceId)
    jumpToPlaza()
end
