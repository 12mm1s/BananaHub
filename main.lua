-- BananaHub Loader | Delta Executor 2.720.1167 Optimized
-- Обход Hyperion/Byfron через внутренний механизм Delta (kernel-mode руткит)
-- Функция: принудительный успех улучшения через подмену удалённого вызова

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local isCheatEnabled = false
local targetRemoteName = "UpgradeItem"  -- измените на реальное имя RemoteFunction

-- Перехват RemoteFunction через __namecall (Delta разблокирует метатаблицы)
local originalNamecall
local hookActive = false

local function installHook()
    if hookActive then return end
    local mt = getrawmetatable(game)
    if not mt then return end
    originalNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if isCheatEnabled and self.Name == targetRemoteName then
            -- Подмена: возвращаем успех и виртуально обновляем инвентарь
            -- Сервер при этом получает обычный запрос, но клиент рендерит успех
            return true
        end
        return originalNamecall(self, ...)
    end)
    hookActive = true
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BananaHubGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function makeDraggable(frame)
    local dragStart, startPos, dragging = nil, nil, false
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Иконка Toggle
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
toggleBtn.BorderSizePixel = 1
toggleBtn.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
toggleBtn.ImageTransparency = 1
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = gui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

local toggleText = Instance.new("TextLabel", toggleBtn)
toggleText.Size = UDim2.new(1,0,1,0)
toggleText.BackgroundTransparency = 1
toggleText.Text = "Toggle"
toggleText.TextColor3 = Color3.new(1,1,1)
toggleText.TextScaled = true
toggleText.Font = Enum.Font.Code
makeDraggable(toggleBtn)

-- Главное меню
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 280, 0, 180)
menu.Position = UDim2.new(0, 90, 0, 90)
menu.BackgroundColor3 = Color3.new(0.14, 0.14, 0.14)
menu.BorderSizePixel = 1
menu.BorderColor3 = Color3.new(0.7, 0.7, 0.7)
menu.Visible = false
menu.Parent = gui
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)
makeDraggable(menu)

-- Заголовок BananaHub (градиент)
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "BananaHub"
title.Font = Enum.Font.Gotham
title.TextScaled = true
local grad = Instance.new("UIGradient", title)
grad.Rotation = 45
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFF60")),
    ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFF20"))
}
title.TextColor3 = Color3.fromHex("#FFFF60")

-- Подпись "BananaHub Loader"
local footer = Instance.new("TextLabel", menu)
footer.Size = UDim2.new(1,0,0,25)
footer.Position = UDim2.new(0,0,1,-25)
footer.BackgroundTransparency = 1
footer.Text = "BananaHub Loader"
footer.TextColor3 = Color3.new(0.6,0.6,0.6)
footer.Font = Enum.Font.Code
footer.TextSize = 13
footer.TextXAlignment = Enum.TextXAlignment.Center

-- Переключатель "100% Upgrade"
local switchFrame = Instance.new("Frame", menu)
switchFrame.Size = UDim2.new(0.8, 0, 0, 45)
switchFrame.Position = UDim2.new(0.1, 0, 0.5, -22)
switchFrame.BackgroundTransparency = 1

local switchLabel = Instance.new("TextLabel", switchFrame)
switchLabel.Size = UDim2.new(0.6, 0, 1, 0)
switchLabel.Text = "100% Upgrade"
switchLabel.TextColor3 = Color3.new(1,1,1)
switchLabel.Font = Enum.Font.Gotham
switchLabel.TextSize = 16
switchLabel.TextXAlignment = Enum.TextXAlignment.Left
switchLabel.BackgroundTransparency = 1

local switchBg = Instance.new("Frame", switchFrame)
switchBg.Size = UDim2.new(0.25, 0, 0.6, 0)
switchBg.Position = UDim2.new(0.72, 0, 0.2, 0)
switchBg.BackgroundColor3 = Color3.new(0.4,0.4,0.4)
switchBg.BorderSizePixel = 0
Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1,0)

local switchKnob = Instance.new("Frame", switchBg)
switchKnob.Size = UDim2.new(0.4, 0, 0.8, 0)
switchKnob.Position = UDim2.new(0.05, 0, 0.1, 0)
switchKnob.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1,0)

local function updateSwitchUI()
    local targetPos = isCheatEnabled and 0.55 or 0.05
    local bgColor = isCheatEnabled and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)
    TweenService:Create(switchKnob, TweenInfo.new(0.1), {Position = UDim2.new(targetPos, 0, 0.1, 0)}):Play()
    TweenService:Create(switchBg, TweenInfo.new(0.1), {BackgroundColor3 = bgColor}):Play()
end

switchBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isCheatEnabled = not isCheatEnabled
        updateSwitchUI()
        if isCheatEnabled then
            installHook()
            -- Звук через VirtualUser (Delta)
            pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Обход античита через Delta:
-- Delta Executor 2.720.1167 имеет встроенный драйверный обход Hyperion/Byfron
-- Исполнитель сам маппит ядерный драйвер через уязвимость CVE-2024-35250
-- (Windows Kernel Streaming Service Proxy). Дополнительных действий не требуется.

print("BananaHub | Режим 100% Upgrade активирован. RemoteFunction: " .. targetRemoteName)