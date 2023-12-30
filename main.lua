UserSettings().GameSettings.MasterVolume = 0
game.RunService:Set3dRenderingEnabled(false)

task.wait(10)

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
        count = 10, 
        sort = "Desc", 
        pageDeep = 2,
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
            task.wait(0.1)
        end
    end
            local servers = {} 
            if body and body.data then 
                for i, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing >= 40 and v.playing < v.maxPlayers and v.id ~= game.JobId then 
                        table.insert(servers, 1, v.id) 
                    end 
                end 
            end
            print("printing server found count")
            print(#servers)
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(config.placeId, servers[math.random(1, #servers)], Players.LocalPlayer) 
            else
                task.wait(120)
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
    local headers = {["Content-Type"] = "application/json"}

    request({
        Url = "https://discord.com/api/webhooks/1187980213234188358/D0HQv_O7rm8Zf8ac1sAFNUYszh-TKu3FLkAaOdQmbJiEt1AKhCrq0qXybxMPmN1fuF7G",
        Body = jsonMessage,
        Method = "POST",
        Headers = headers,
    })

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
    task.wait(20)
    if not ReplicatedStorage:FindFirstChild("Library") then
        print("library bugged, hopping")
        jumpToPlaza()
        return
    end
    Library = require(ReplicatedStorage.Library)
    task.wait(10)
    listing_listener()
    task.spawn(function()
        while task.wait(10) do
            print("checking")
            if #game.Players:GetPlayers() < 30 and tick() - timestart < configuration.hopTime then
                jumpToPlaza()
                return
            end
            print("continuing cuz "..#game.Players:GetPlayers().." players")
        end
    end)
    task.wait(configuration.hopTime)
    jumpToPlaza()
elseif game.PlaceId == 15502339080 and checkIfSnipersIngame() == true then
    print("alt in plaza soooo... bye !")
    config.servers.pageDeep += 1
    task.wait(10)
    jumpToPlaza()
elseif game.PlaceId ~= 15502339080 then
    print("hopping cuz place is: "..game.PlaceId)
    task.wait(10)
    jumpToPlaza()
end
