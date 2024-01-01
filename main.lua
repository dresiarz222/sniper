getgenv().webhook = "" -- webhook link for successful snipes
getgenv().webhookFail = "" -- webhook link for successful snipes
getgenv().userid = "" -- pings your discord id if it snipes a huge or titanic 
getgenv().alts = {
    "Nesafris",
    "52kPCGaming",
    "HugeSpaceCat19",
    "Gnatsare",
    "SpaceGrey203",
    "IndianTechSupport551"
} 
getgenv().normalwebhook = ""
getgenv().snipeNormalPets = false -- snipes other items that are priced at 1
repeat wait() until game:IsLoaded()
if game.PlaceId == 15502339080 then
    print("alrighty")
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Root1527/personal/main/silly.lua"))()
    return
end

local osclock = os.clock()
repeat task.wait() until game:IsLoaded()
setfpscap(10)
game:GetService("RunService"):Set3dRenderingEnabled(false)
local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
local Players = game:GetService('Players')
local getPlayers = Players:GetPlayers()
local PlayerInServer = #getPlayers
local http = game:GetService("HttpService")
local ts = game:GetService("TeleportService")
local rs = game:GetService("ReplicatedStorage")
local playerID, snipeNormal

local vu = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

for i = 1, PlayerInServer do
   for ii = 1,#alts do
        if getPlayers[i].Name == alts[ii] and alts[ii] ~= Players.LocalPlayer.Name then
            jumpToServer()
        end
    end
end

local function checklisting(uid, gems, item, version, shiny, amount, username, playerid)
    local Library = require(rs:WaitForChild('Library'))
    local purchase = rs.Network.Booths_RequestPurchase
    gems = tonumber(gems)
    local ping = false
    snipeNormal = false
    local type = {}
    pcall(function()
        type = Library.Directory.Pets[item]
    end)

    if amount == nil then
        amount = 1
    end

    local price = gems / amount
    if item == "Banana" or item == "Coin" then return end

    if type.huge and price <= 1500000 then
        purchase:InvokeServer(playerid, uid)
    elseif type.exclusiveLevel and price <= 30000 then
        purchase:InvokeServer(playerid, uid)
    elseif type.exclusiveLevel and version == 2 and price <= 100000 then
        purchase:InvokeServer(playerid, uid)
    elseif type.exclusiveLevel and shiny and price <= 50000 then
        purchase:InvokeServer(playerid, uid)
    elseif type.titanic then
        purchase:InvokeServer(playerid, uid)
    elseif string.find(item, "Egg") and string.find(item, "Exclusive") and price <= 100000 then
        purchase:InvokeServer(playerid, uid)
    elseif item == "Royalty Charm" and price <= 500000 then
        purchase:InvokeServer(playerid, uid)
    end
end

function optimize()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart",1000)
    for i,v in ipairs(game.Players:GetPlayers()) do
        if v.UserId ~= LocalPlayer.UserId then
            v.Character:ClearAllChildren()
        end
    end
    HumanoidRootPart.Anchored = true
    task.wait(10)
    HumanoidRootPart.CFrame = CFrame.new(10000+math.random(1,2),10000+math.random(1,2),10000+math.random(1,2))
end

Booths_Broadcast.OnClientEvent:Connect(function(username, message)
    local playerIDSuccess, playerError = pcall(function()
	playerID = message['PlayerID']
    end)
    if playerIDSuccess then
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
                            checklisting(uid, gems, item, version, shiny, amount, username, playerID)
                        end
                    end
                end
            end
	end
    end
end)

ts.TeleportInitFailed:Connect(function(player, resultEnum, msg) 
    task.wait(10)
    jumpToServer()
end)

local function jumpToServer() 
    local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true" 
    local req = request({ Url = string.format(sfUrl, 15502339080, "Desc", 100) }) 
    local body = http:JSONDecode(req.Body) 
    local deep = math.random(1, 3)
    if deep > 1 then 
        for i = 1, deep, 1 do 
             req = request({ Url = string.format(sfUrl .. "&cursor=" .. body.nextPageCursor, 15502339080, "Desc", 100) }) 
             body = http:JSONDecode(req.Body) 
             task.wait(0.1)
        end 
    end 
    local servers = {} 
    if body and body.data then 
        for i, v in next, body.data do 
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end
    end
    local randomCount = #servers
    if not randomCount then
       randomCount = 2
    end
    ts:TeleportToPlaceInstance(15502339080, servers[math.random(1, randomCount)], game:GetService("Players").LocalPlayer) 
end

Players.PlayerRemoving:Connect(function(player)
    PlayerInServer = #getPlayers
    if PlayerInServer < 35 then
        jumpToServer()
    end
end) 

Players.PlayerAdded:Connect(function(player)
    for i = 1,#alts do
        if player.Name == alts[i] and alts[i] ~= Players.LocalPlayer.Name then
            jumpToServer()
        end
    end
end) 


task.spawn(optimize)

while task.wait(1) do
    if math.floor(os.clock() - osclock) >= math.random(900, 1200) then
        jumpToServer()
    end
end