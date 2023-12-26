game.RunService:Set3dRenderingEnabled(false)
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

function checklisting(uid, gems, item, version, shiny, amount, username, playerid, method)
    gems = tonumber(gems)
    typeofpet = {}
    pcall(function()
        typeofpet = Library.Directory.Pets[item]
    end)
    if item == "Banana" or
    item = "Coin" then
        return
    end
    if typeofpet.exclusiveLevel and gems <= 25000  then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, "exclusive under 25k")
    elseif typeofpet.exclusiveLevel and version == 2 and gems <= 250000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, "rb exclusive udner 250k")
    elseif typeofpet.huge and gems <= 2000000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, "huge under 2m")
    elseif typeofpet.exclusiveLevel and shiny and gems <= 50000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, "shiny exclusive under 50k")
    elseif string.find(item, "Egg") and string.find(item, "Exclusive") and gems <= 50000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, "exclusive egg with string find under 50k")
    elseif string.find(item, "Titanic") and string.find(item, "Present") and gems <= 300000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username,"string find titanic present under 300k")
    elseif string.find(string.lower(item), "strength charm") and gems <= 100000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, "strength charm under 100k")
    elseif string.find(string.lower(item), "royalty charm") and gems <= 1000000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, "royalty charm under 1m")
    elseif gems <= 10 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    end
end

function processListingInfo(uid, gems, item, version, shiny, amount, boughtFrom)
    print(uid, gems, item, version, shiny, amount, boughtFrom)
    print("BOUGHT FROM:", boughtFrom)
    print("UID:", uid)
    print("GEMS:", gems)
    print("ITEM:", item)
    local snipeMessage = game.Players.LocalPlayer.Name .. " just sniped a "
    if version then
        if version == 2 then
            version = "Rainbow"
        elseif version == 1 then
            version = "Golden"
        end
    else
       version = "Normal"
    end
    
    snipeMessage = snipeMessage .. version
    
    if shiny then
        snipeMessage = snipeMessage .. " Shiny"
    end
    
    snipeMessage = snipeMessage .. " " .. (item)
    
    print(snipeMessage)
    
    if amount then
        print("AMOUNT:", amount)
    else
        amount = 1
        print("AMOUNT:", amount)
    end

    local fields = {
        {
            name = "PRICE:",
            value = tostring(gems) .. " GEMS",
            inline = true,
        },
        {
            name = "BOUGHT FROM:",
            value = tostring(boughtFrom),
            inline = true,
        },
        {
            name = "AMOUNT:",
            value = tostring(amount),
            inline = true,
        },
        {
            name = "PETID:",
            value = tostring(uid),
            inline = true,
        },
        {
            name = "BUYMETHOD:",
            value = tostring(method),
            inline = true,
        }
    }

    local message = {
        content = "@everyone",
        embeds = {
            {
                title = snipeMessage,
                fields = fields,
                author = {name = "New Pet Sniped!"}
            }
        },
        username = "piratesniper",
        attachments = {}
    }

    local http = game:GetService("HttpService")
    local jsonMessage = http:JSONEncode(message)

    http:PostAsync(
        "https://discord.com/api/webhooks/1187980213234188358/D0HQv_O7rm8Zf8ac1sAFNUYszh-TKu3FLkAaOdQmbJiEt1AKhCrq0qXybxMPmN1fuF7G",
        jsonMessage,
        Enum.HttpContentType.ApplicationJson,
        false
    )
end

function listing_listener()

    local virtualuser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        virtualuser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(5)
        virtualuser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)

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
        if #game.Players:GetPlayers() < 35 and tick() - timestart < 1000 then
            jumpToPlaza()
        end
        print("continuing, there are this many players: "..#game.Players:GetPlayers().." or with getchildren: "..#game.Players:GetChildren())
    end
end)

if game.PlaceId == 15502339080 and checkIfSnipersIngame() == false then
    listing_listener()
    task.wait(configuration.hopTime)
    jumpToPlaza()
elseif game.PlaceId ~= 15502339080 or checkIfSnipersIngame() == true then
    print("hopping cuz "..tostring(checkIfSnipersIngame()).." is true or place is: "..game.PlaceId)
    task.wait(20)
    jumpToPlaza()
end
