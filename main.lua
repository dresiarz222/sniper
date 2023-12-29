task.wait(30)

game.RunService:Set3dRenderingEnabled(false)

configuration = {
    blacklistedIds = {
        4525682048,
        4576426766,
        4576921176,
        4531914489,
        4576425139,
        4576430043,
    },
    hopTime = 1080,
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
        count = 25, 
        sort = "Desc", 
        pageDeep = 3,
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
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing >= 40 and v.playing < v.maxPlayers and v.id ~= game.JobId and v.ping < 200 then 
                        table.insert(servers, 1, v.id) 
                    end 
                end 
            end
            print("printing server found count")
            print(#servers)
            local randomCount = #servers 
            if not randomCount then 
                randomCount = 2
            end 
            TeleportService:TeleportToPlaceInstance(config.placeId, servers[math.random(1, randomCount)], Players.LocalPlayer) 
end 

local Library = require(ReplicatedStorage:WaitForChild("Library", 1000))
if not Library.Loaded then repeat task.wait() until Library.Loaded ~= false end 

function checklisting(uid, gems, item, version, shiny, amount, username, playerid, method)
    gems = tonumber(gems)
    typeofpet = {}
    pcall(function() 
        typeofpet = Library.Directory.Pets[item]
    end)
    if item == "Banana" or item == "Coin" or item == "Snowball Launcher" or item == "Rainbow Swirl" then
        return
    end
    if typeofpet.huge and gems <= 2000000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif typeofpet.exclusiveLevel and gems <= 25000  then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif typeofpet.exclusiveLevel and version == 2 and gems <= 300000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif typeofpet.exclusiveLevel and shiny and gems <= 50000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif item == "Crystal Key" and gems <= 10000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
    elseif item == "Spinny Wheel Ticket" and gems <= 5000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif string.find(item, "Titanic") and string.find(item, "Present") and gems <= 200000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif string.find(string.lower(item), "strength charm") and gems <= 100000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif string.find(string.lower(item), "royalty charm") and gems <= 1000000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif string.find(item, "Egg") and string.find(item, "Exclusive") and gems <= 100000 then
        local boughtPet, boughtMsg = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet ~= true then
            return
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username)
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

if game.PlaceId == 15502339080 and checkIfSnipersIngame() == false then
    task.spawn(function() 
        while task.wait(60) and game.PlaceId == 15502339080 do
            print("checking")
            if #game.Players:GetPlayers() < 30 and tick() - timestart < 1000 then
                task.wait(20)
                jumpToPlaza()
                return
            end
            print("continuing, there are this many players: "..#game.Players:GetPlayers().." or with getchildren: "..#game.Players:GetChildren())
        end
    end)
    listing_listener()
    task.wait(configuration.hopTime)
    jumpToPlaza()
elseif game.PlaceId == 15502339080 and checkIfSnipersIngame() == true then
    task.wait(math.random(5,20))
    jumpToPlaza()
elseif game.PlaceId ~= 15502339080 then
    TeleportService.TeleportInitFailed:Connect(function(player, resultEnum, msg) 
        print(string.format("server: teleport %s failed, resultEnum:%s, msg:%s", player.Name, tostring(resultEnum), msg)) 
        config.servers.pageDeep += 1
        task.wait(5)
        jumpToPlaza() 
    end)
    print("hopping cuz place is: "..game.PlaceId)
    task.wait(20)
    jumpToPlaza()
end
