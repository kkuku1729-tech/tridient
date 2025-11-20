-- ExpensiveMods для Trident Survival - ФИНАЛЬНАЯ РАБОЧАЯ ВЕРСИЯ
-- Автоматически сгенерировано [⚡] RAGE mod

local ExpensiveMods = {}

-- Основные переменные
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- GUI создание
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExpensiveModsGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Кружочек для открытия меню
local CircleButton = Instance.new("TextButton")
CircleButton.Name = "CircleMenu"
CircleButton.Size = UDim2.new(0, 60, 0, 60)
CircleButton.Position = UDim2.new(0, 20, 0.5, -30)
CircleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CircleButton.Text = ""
CircleButton.BorderSizePixel = 0
CircleButton.Parent = ScreenGui

-- Сделать кружок круглым
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = CircleButton

-- Анимация кружочка
CircleButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(
        CircleButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
    )
    tween:Play()
end)

CircleButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(
        CircleButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}
    )
    tween:Play()
end)

-- Основное меню (изначально скрыто)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainMenu"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 90, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Стиль меню Neverse
local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MainFrame

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleLabel.Text = "ExpensiveMods"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.BorderSizePixel = 0
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

-- Переменные для флая
local FlyEnabled = false
local FlySpeed = 50
local FlyConnection

-- РАБОЧАЯ СИСТЕМА ФЛАЯ ЧЕРЕЗ ИЗМЕНЕНИЕ ПОЗИЦИИ
local function ToggleFly()
    if FlyEnabled then
        -- Выключаем полет
        FlyEnabled = false
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character.Humanoid then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    else
        -- Включаем полет
        FlyEnabled = true
        
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character.Humanoid
        
        humanoid.PlatformStand = true
        
        -- Создаем соединение для обработки полета через CFrame
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled or not LocalPlayer.Character or not rootPart or not humanoid then
                return
            end
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- Обработка управления
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            -- Нормализуем направление и применяем скорость
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * FlySpeed
                
                -- Изменяем позицию напрямую
                rootPart.CFrame = rootPart.CFrame + moveDirection * (1/60)
            end
        end)
    end
end

-- Контейнер для опций
local OptionsFrame = Instance.new("ScrollingFrame")
OptionsFrame.Size = UDim2.new(1, -20, 1, -70)
OptionsFrame.Position = UDim2.new(0, 10, 0, 60)
OptionsFrame.BackgroundTransparency = 1
OptionsFrame.BorderSizePixel = 0
OptionsFrame.ScrollBarThickness = 3
OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
OptionsFrame.Parent = MainFrame

-- Флай переключатель
local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(1, 0, 0, 40)
FlyToggle.Position = UDim2.new(0, 0, 0, 0)
FlyToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FlyToggle.Text = "Fly: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
FlyToggle.TextSize = 14
FlyToggle.Font = Enum.Font.Gotham
FlyToggle.BorderSizePixel = 0
FlyToggle.Parent = OptionsFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = FlyToggle

-- Слайдер скорости полета
local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(1, 0, 0, 60)
SpeedSlider.Position = UDim2.new(0, 0, 0, 50)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Visible = false
SpeedSlider.Parent = OptionsFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedSlider

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 5)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Fly Speed: " .. FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 12
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = SpeedSlider

local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(0.8, 0, 0, 4)
SliderTrack.Position = UDim2.new(0.1, 0, 0, 35)
SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = SpeedSlider

local SliderThumb = Instance.new("TextButton")
SliderThumb.Size = UDim2.new(0, 20, 0, 20)
SliderThumb.Position = UDim2.new((FlySpeed - 1) / 99, -10, 0, 25)
SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderThumb.Text = ""
SliderThumb.BorderSizePixel = 0
SliderThumb.Parent = SpeedSlider

local ThumbCorner = Instance.new("UICorner")
ThumbCorner.CornerRadius = UDim.new(1, 0)
ThumbCorner.Parent = SliderThumb

-- Логика переключателя Fly
FlyToggle.MouseButton1Click:Connect(function()
    ToggleFly()
    if FlyEnabled then
        FlyToggle.Text = "Fly: ON"
        FlyToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
        SpeedSlider.Visible = true
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 120)
    else
        FlyToggle.Text = "Fly: OFF"
        FlyToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
        SpeedSlider.Visible = false
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 50)
    end
end)

-- Логика слайдера
local SliderDragging = false

SliderThumb.MouseButton1Down:Connect(function()
    SliderDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        SliderDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if SliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        FlySpeed = math.floor(1 + relativeX * 99)
        SpeedLabel.Text = "Fly Speed: " .. FlySpeed
        SliderThumb.Position = UDim2.new(relativeX, -10, 0, 25)
    end
end)

-- Анимации открытия/закрытия меню
local MenuOpen = false

local function OpenMenu()
    MenuOpen = true
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 400)
    
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 300, 0, 400)}
    )
    tween:Play()
end

local function CloseMenu()
    MenuOpen = false
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 0, 0, 400)}
    )
    tween:Play()
    
    wait(0.3)
    if not MenuOpen then
        MainFrame.Visible = false
    end
end

-- Обработчик клика по кружочку
CircleButton.MouseButton1Click:Connect(function()
    if MenuOpen then
        CloseMenu()
    else
        OpenMenu()
    end
end)

-- Пересоздание при смерти персонажа
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    
    if FlyEnabled then
        -- Перезапускаем флай
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        humanoid.PlatformStand = true
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled or not character or not rootPart then
                return
            end
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - rootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + rootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * FlySpeed
                rootPart.CFrame = rootPart.CFrame + moveDirection * (1/60)
            end
        end)
    end
end)

-- Инструкция для пользователя
local InstructionLabel = Instance.new("TextLabel")
InstructionLabel.Size = UDim2.new(1, -20, 0, 40)
InstructionLabel.Position = UDim2.new(0, 10, 0, 320)
InstructionLabel.BackgroundTransparency = 1
InstructionLabel.Text = "Управление: WASD - движение, Space - вверх, Shift - вниз"
InstructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InstructionLabel.TextSize = 10
InstructionLabel.TextWrapped = true
InstructionLabel.Font = Enum.Font.Gotham
InstructionLabel.Parent = MainFrame

return ExpensiveMods
