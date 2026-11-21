-- ==========================================
-- Готовый скрипт для GUI (Исполнитель)
-- ==========================================

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Создаем главный экран (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomGUI"
ScreenGui.ResetOnSpawn = false -- Чтобы окно не пропадало после смерти
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- 2. Создаем главное окно (Main)
local main = Instance.new("Frame")
main.Name = "main"
main.Parent = ScreenGui
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Темно-серый фон
main.Position = UDim2.new(0.5, -300, 0.5, -180) -- По центру экрана
main.Size = UDim2.new(0, 600, 0, 350)
main.BorderSizePixel = 0

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8) -- Закругляем углы окна
mainCorner.Parent = main

-- 3. Создаем верхнюю панель (Title)
local title = Instance.new("Frame")
title.Name = "title"
title.Parent = main
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.Size = UDim2.new(1, 0, 0, 40)
title.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

local titleText = Instance.new("TextLabel")
titleText.Parent = title
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "Мое крутое меню (GUI)"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- 4. Создаем текстовое поле (Source)
local source = Instance.new("TextBox")
source.Name = "source"
source.Parent = main
source.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
source.Position = UDim2.new(0, 10, 0, 50)
source.Size = UDim2.new(1, -20, 0, 240)
source.ClearTextOnFocus = false
source.MultiLine = true
source.Text = ""
source.PlaceholderText = "Введите ваш скрипт сюда..."
source.TextColor3 = Color3.fromRGB(200, 200, 200)
source.Font = Enum.Font.Code
source.TextSize = 14
source.TextXAlignment = Enum.TextXAlignment.Left
source.TextYAlignment = Enum.TextYAlignment.Top

local sourceCorner = Instance.new("UICorner")
sourceCorner.CornerRadius = UDim.new(0, 6)
sourceCorner.Parent = source

-- 5. Создаем кнопку Execute (Запуск)
local execute = Instance.new("TextButton")
execute.Name = "execute"
execute.Parent = main
execute.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Зеленая кнопка
execute.Position = UDim2.new(0, 10, 1, -45)
execute.Size = UDim2.new(0, 150, 0, 35)
execute.Font = Enum.Font.GothamBold
execute.Text = "Запустить"
execute.TextColor3 = Color3.fromRGB(255, 255, 255)
execute.TextSize = 14

local executeCorner = Instance.new("UICorner")
executeCorner.CornerRadius = UDim.new(0, 6)
executeCorner.Parent = execute

-- 6. Создаем кнопку Clear (Очистить)
local clear = Instance.new("TextButton")
clear.Name = "clear"
clear.Parent = main
clear.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Красная кнопка
clear.Position = UDim2.new(0, 170, 1, -45)
clear.Size = UDim2.new(0, 150, 0, 35)
clear.Font = Enum.Font.GothamBold
clear.Text = "Очистить"
clear.TextColor3 = Color3.fromRGB(255, 255, 255)
clear.TextSize = 14

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clear

-- ==========================================
-- ЛОГИКА (Что будет происходить при кликах)
-- ==========================================

-- 1. Делаем окно перетаскиваемым (за верхнюю панель)
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- 2. Работа кнопки Execute (Запуск скрипта)
execute.MouseButton1Click:Connect(function()
	local codeToRun = source.Text
	if codeToRun ~= "" then
		-- loadstring превращает текст в исполняемый код
		local func, err = loadstring(codeToRun)
		if func then
			-- pcall запускает код безопасно (если будет ошибка, игра не вылетит)
			pcall(func) 
		else
			warn("Ошибка в написанном коде: " .. tostring(err))
		end
	end
end)

-- 3. Работа кнопки Clear (Очистка поля)
clear.MouseButton1Click:Connect(function()
	source.Text = ""
end)
