-- Пример использования Obsidian UI
-- Этот скрипт можно заинжектить в Roblox

-- Загрузка библиотеки и дополнений
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- Создание основного окна
local Window = Library:CreateWindow({
    Title = "Obsidian Example",
    Footer = "by Crysstall",
    Icon = 95816097006870, -- ID иконки
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- Создание вкладок
local Tabs = {
    Main = Window:AddTab("Главная", "home"),
    Player = Window:AddTab("Игрок", "user"),
    Visuals = Window:AddTab("Визуалы", "eye"),
    Settings = Window:AddTab("Настройки", "settings"),
}

-- Создание групп на вкладке "Главная"
local MainLeftGroupBox = Tabs.Main:AddLeftGroupbox("Основные функции")
local MainRightGroupBox = Tabs.Main:AddRightGroupbox("Дополнительно")

-- Добавление элементов в левую группу
MainLeftGroupBox:AddToggle("AutoFarm", {
    Text = "Авто-фарм",
    Default = false,
    Tooltip = "Автоматический сбор ресурсов",
    Callback = function(Value)
        print("Авто-фарм:", Value)
        -- Здесь ваш код для авто-фарма
    end
})

MainLeftGroupBox:AddSlider("WalkSpeed", {
    Text = "Скорость передвижения",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

MainLeftGroupBox:AddDropdown("TeleportLocation", {
    Values = {"Спавн", "Магазин", "Арена", "Секретная локация"},
    Default = 1,
    Multi = false,
    Text = "Телепорт",
    Tooltip = "Выберите локацию для телепорта",
    Callback = function(Value)
        print("Телепорт в:", Value)
        -- Здесь ваш код для телепорта
    end
})

-- Добавление элементов в правую группу
MainRightGroupBox:AddButton({
    Text = "Собрать все ресурсы",
    Func = function()
        print("Собираем все ресурсы...")
        -- Здесь ваш код для сбора ресурсов
    end,
    DoubleClick = false,
    Tooltip = "Нажмите, чтобы собрать все ресурсы на карте"
})

MainRightGroupBox:AddInput("PlayerName", {
    Default = "",
    Numeric = false,
    Finished = true,
    Text = "Имя игрока",
    Placeholder = "Введите имя игрока",
    Callback = function(Value)
        print("Поиск игрока:", Value)
        -- Здесь ваш код для поиска игрока
    end
})

-- Создание групп на вкладке "Игрок"
local PlayerLeftGroupBox = Tabs.Player:AddLeftGroupbox("Характеристики")

PlayerLeftGroupBox:AddSlider("JumpPower", {
    Text = "Сила прыжка",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

PlayerLeftGroupBox:AddToggle("InfiniteJump", {
    Text = "Бесконечные прыжки",
    Default = false,
    Callback = function(Value)
        getgenv().InfiniteJump = Value
        
        -- Обработчик бесконечных прыжков
        if not getgenv().InfiniteJumpConnection then
            getgenv().InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if getgenv().InfiniteJump then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end
})

-- Добавление цветового пикера
PlayerLeftGroupBox:AddLabel("Цвет персонажа"):AddColorPicker("CharacterColor", {
    Default = Color3.new(1, 1, 1),
    Title = "Цвет персонажа",
    Transparency = 0,
    Callback = function(Value)
        -- Изменение цвета персонажа
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Value
            end
        end
    end
})

-- Создание групп на вкладке "Визуалы"
local VisualsGroupBox = Tabs.Visuals:AddLeftGroupbox("Настройки ESP")

VisualsGroupBox:AddToggle("PlayerESP", {
    Text = "ESP игроков",
    Default = false,
    Callback = function(Value)
        print("ESP игроков:", Value)
        -- Здесь ваш код для ESP игроков
    end
})

VisualsGroupBox:AddToggle("ChestESP", {
    Text = "ESP сундуков",
    Default = false,
    Callback = function(Value)
        print("ESP сундуков:", Value)
        -- Здесь ваш код для ESP сундуков
    end
})

-- Добавление привязки клавиш
VisualsGroupBox:AddLabel("Клавиша ESP"):AddKeyPicker("ESPKey", {
    Default = "F",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "ESP",
    Callback = function(Value)
        print("ESP переключен клавишей")
    end
})

-- Настройки UI в последней вкладке
local SettingsGroupBox = Tabs.Settings:AddLeftGroupbox("Настройки интерфейса")

-- Интеграция с ThemeManager и SaveManager
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Установка папки для сохранения настроек
SaveManager:SetFolder("ObsidianExample")

-- Построение элементов настроек
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- Уведомление о загрузке
Library:Notify("Скрипт успешно загружен!", 3)

-- Обработка закрытия
Library:OnUnload(function()
    print("Скрипт выгружен")
    Library.Unloaded = true
end)

-- Возвращаем библиотеку для возможного использования в других скриптах
return Library