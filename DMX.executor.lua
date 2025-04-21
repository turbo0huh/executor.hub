wait("0.2")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- تعريف مسار ملف JSON للحفظ
local SAVE_FOLDER = "DMX_Executor"
local SAVE_FILE = SAVE_FOLDER.."/scripts_data.json"
local SETTINGS_FILE = SAVE_FOLDER.."/settings.json"

-- إنشاء مجلد الحفظ إذا لم يكن موجوداً
pcall(function()
    if not isfolder(SAVE_FOLDER) then
        makefolder(SAVE_FOLDER)
    end
end)

-- تهيئة البيانات الافتراضية
local defaultData = {
    settings = {
        version = "1.0",
        theme = "dark",
        last_selected = "DMX Executor"
    },
    scripts = {
        ["Arceus X"] = {
            code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3"))()]],
            description = "Official Arceus X V3 Loader"
        },
        ["Delta V1"] = {
            code = [[loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Delta-Executor-J-O-K-E-7664"))()]],
            description = "Delta Executor Official Script",
            locked = true
        },
        ["tiger hub"] = {
            code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/balintTheDevX/Tiger-X-V3/main/Tiger%20X%20V3.5%20Fixed"))()]],
            description = "more executor or exploits"
        },
        ["Fly GUI V3"] = {
            code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-v3-13879"))()]],
            description = "Fly GUI V3 Script"
        },
        ["DMX Executor"] = {
            code = [[-- by hack_hub3]],
            description = "DMX Utility Script" 
        },
        ["lua.1"] = {
            code = [[-- سكربت جديد 1
-- أكتب الكود هنا]],
            description = "سكربت مخصص 1"
        }
    }
}

-- تهيئة الإعدادات الافتراضية
local defaultSettings = {
    uiColor = Color3.fromRGB(25, 25, 25),
    buttonColor = Color3.fromRGB(45, 45, 45),
    selectedButtonColor = Color3.fromRGB(0, 191, 255),
    textColor = Color3.fromRGB(230, 230, 230),
    moveSpeed = 16,
    jumpPower = 50,
    uiSize = 1.0
}

-- وظيفة لحفظ البيانات في ملف JSON
local function saveData(data)
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
        print("تم حفظ البيانات بنجاح")
    end)
end

-- وظيفة لحفظ الإعدادات في ملف JSON
local function saveSettings(settings)
    pcall(function()
        local settingsToSave = {}
        for k, v in pairs(settings) do
            if typeof(v) == "Color3" then
                settingsToSave[k] = {r = v.R, g = v.G, b = v.B}
            else
                settingsToSave[k] = v
            end
        end
        writefile(SETTINGS_FILE, HttpService:JSONEncode(settingsToSave))
        print("تم حفظ الإعدادات بنجاح")
    end)
end

-- وظيفة لقراءة البيانات من ملف JSON
local function loadData()
    local data = defaultData
    pcall(function()
        if isfile(SAVE_FILE) then
            local success, loadedData = pcall(function()
                return HttpService:JSONDecode(readfile(SAVE_FILE))
            end)
            
            if success and loadedData then
                -- دمج البيانات المحملة مع البيانات الافتراضية للتأكد من وجود جميع السكربتات الأساسية
                data = loadedData
                
                -- التأكد من وجود السكربتات الافتراضية
                for name, scriptData in pairs(defaultData.scripts) do
                    if not data.scripts[name] and not string.match(name, "^lua%.%d+$") then
                        data.scripts[name] = scriptData
                    end
                end
            else
                warn("فشل تحميل البيانات، استخدام البيانات الافتراضية")
                saveData(defaultData) -- إعادة إنشاء ملف البيانات
            end
        else
            print("ملف البيانات غير موجود، إنشاء ملف جديد")
            saveData(defaultData)
        end
    end)
    return data
end

-- وظيفة لقراءة الإعدادات من ملف JSON
local function loadSettings()
    local settings = defaultSettings
    pcall(function()
        if isfile(SETTINGS_FILE) then
            local success, loadedSettings = pcall(function()
                return HttpService:JSONDecode(readfile(SETTINGS_FILE))
            end)
            
            if success and loadedSettings then
                for k, v in pairs(loadedSettings) do
                    if typeof(defaultSettings[k]) == "Color3" and type(v) == "table" and v.r and v.g and v.b then
                        settings[k] = Color3.new(v.r, v.g, v.b)
                    else
                        settings[k] = v
                    end
                end
            else
                warn("فشل تحميل الإعدادات، استخدام الإعدادات الافتراضية")
                saveSettings(defaultSettings) -- إعادة إنشاء ملف الإعدادات
            end
        else
            print("ملف الإعدادات غير موجود، إنشاء ملف جديد")
            saveSettings(defaultSettings)
        end
    end)
    return settings
end

-- وظيفة لحفظ البيانات عند إغلاق اللعبة
local function setupAutoSave()
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
        saveData(savedData)
        saveSettings(settings)
    end)
    
    game.Close:Connect(function()
        saveData(savedData)
        saveSettings(settings)
    end)
end

-- تحميل البيانات المحفوظة أو استخدام البيانات الافتراضية
local savedData = loadData()
local settings = loadSettings()

local ArceusGUI = Instance.new("ScreenGui")
local ControlGUI = Instance.new("ScreenGui")
local OpenButton = Instance.new("TextButton")

ControlGUI.Name = "ControlPanel"
ControlGUI.Parent = CoreGui
ControlGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ControlGUI.ResetOnSpawn = false

OpenButton.Name = "ControlButton"
OpenButton.Size = UDim2.new(0.07, 0, 0.08, 0)
OpenButton.Position = UDim2.new(0.92, 0, 0.02, 0)
OpenButton.Text = "OPEN"
OpenButton.TextSize = 28
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenButton.TextColor3 = Color3.fromRGB(0, 255, 0)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.Parent = ControlGUI

local dragging, dragInput, dragStart, startPos

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = OpenButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

OpenButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        OpenButton.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

ArceusGUI.Name = "ArceusX_NEO_V2"
ArceusGUI.Parent = CoreGui
ArceusGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ArceusGUI.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.35 * settings.uiSize, 0, 0.5 * settings.uiSize, 0)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = settings.uiColor
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Watermark = Instance.new("TextLabel")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0.3, 0, 0.05, 0)
Watermark.Position = UDim2.new(0.02, 0, 0.02, 0)
Watermark.Text = "DMX executor -- by hack_hub3 v1"
Watermark.TextColor3 = settings.textColor
Watermark.BackgroundTransparency = 1
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextSize = 14
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseBtn"
CloseButton.Size = UDim2.new(0.06, 0, 0.07, 0)
CloseButton.Position = UDim2.new(0.94, 0, 0.01, 0)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.new(1, 0.3, 0.3)
CloseButton.TextSize = 24
CloseButton.BackgroundTransparency = 1

local ResizeButton = Instance.new("TextButton")
ResizeButton.Name = "ResizeBtn"
ResizeButton.Size = UDim2.new(0.06, 0, 0.07, 0)
ResizeButton.Position = UDim2.new(0.88, 0, 0.01, 0)
ResizeButton.Text = "o"
ResizeButton.TextColor3 = Color3.new(1, 1, 1)
ResizeButton.TextSize = 24
ResizeButton.BackgroundTransparency = 1
ResizeButton.Parent = MainFrame

-- زر الإعدادات
local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsBtn"
SettingsButton.Size = UDim2.new(0.06, 0, 0.07, 0)
SettingsButton.Position = UDim2.new(0.82, 0, 0.01, 0)
SettingsButton.Text = "⚙️"
SettingsButton.TextColor3 = Color3.new(1, 1, 1)
SettingsButton.TextSize = 18
SettingsButton.BackgroundTransparency = 1
SettingsButton.Parent = MainFrame

local ScriptBox = Instance.new("TextBox")
ScriptBox.Name = "ScriptEditor"
ScriptBox.Size = UDim2.new(0.72, 0, 0.75, 0)
ScriptBox.Position = UDim2.new(0.26, 0, 0.15, 0)
ScriptBox.Text = "-- roblox(hack_hub3/tiktok/dddd3m) --"
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.TextWrapped = true
ScriptBox.ClearTextOnFocus = false
ScriptBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ScriptBox.TextColor3 = settings.textColor
ScriptBox.Font = Enum.Font.Code
ScriptBox.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
ScriptBox.MultiLine = true

-- إنشاء قائمة السكربتات الرئيسية
local MainScriptList = Instance.new("ScrollingFrame")
MainScriptList.Name = "MainScriptList"
MainScriptList.Size = UDim2.new(0.22, 0, 0.75, 0)
MainScriptList.Position = UDim2.new(0.02, 0, 0.15, 0)
MainScriptList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainScriptList.ScrollBarThickness = 5
MainScriptList.CanvasSize = UDim2.new(0, 0, 2, 0)
MainScriptList.Parent = MainFrame

-- زر البحث عن السكربتات
local SearchScriptsButton = Instance.new("TextButton")
SearchScriptsButton.Name = "SearchScriptsButton"
SearchScriptsButton.Size = UDim2.new(0.22, 0, 0.05, 0)
SearchScriptsButton.Position = UDim2.new(0.02, 0, 0.09, 0)
SearchScriptsButton.Text = "🔍 البحث عن السكربتات"
SearchScriptsButton.TextColor3 = Color3.new(1, 1, 1)
SearchScriptsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SearchScriptsButton.Font = Enum.Font.GothamBold
SearchScriptsButton.TextSize = 12
SearchScriptsButton.Parent = MainFrame

-- إنشاء قائمة سكربتات lua (ستكون مخفية بشكل افتراضي)
local LuaScriptPanel = Instance.new("Frame")
LuaScriptPanel.Name = "LuaScriptPanel"
LuaScriptPanel.Size = UDim2.new(0.22, 0, 0.75, 0)
LuaScriptPanel.Position = UDim2.new(0.02, 0, 0.15, 0)
LuaScriptPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LuaScriptPanel.Visible = false
LuaScriptPanel.Parent = MainFrame

-- زر الرجوع للقائمة الرئيسية
local BackButton = Instance.new("TextButton")
BackButton.Name = "BackButton"
BackButton.Size = UDim2.new(0.2, 0, 0.06, 0)
BackButton.Position = UDim2.new(0.05, 0, 0.02, 0)
BackButton.Text = "⬅️ رجوع"
BackButton.TextColor3 = Color3.new(1, 1, 1)
BackButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BackButton.Font = Enum.Font.GothamBold
BackButton.TextSize = 12
BackButton.Parent = LuaScriptPanel

-- إنشاء زر إضافة سكربت جديد
local NewScriptButton = Instance.new("TextButton")
NewScriptButton.Name = "NewScriptButton"
NewScriptButton.Size = UDim2.new(0.7, 0, 0.06, 0)
NewScriptButton.Position = UDim2.new(0.25, 0, 0.02, 0)
NewScriptButton.Text = "new script"
NewScriptButton.TextColor3 = Color3.new(1, 1, 1)
NewScriptButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
NewScriptButton.Font = Enum.Font.GothamBold
NewScriptButton.TextSize = 12
NewScriptButton.Parent = LuaScriptPanel

-- إنشاء قائمة سكربتات lua
local LuaScriptList = Instance.new("ScrollingFrame")
LuaScriptList.Name = "LuaScriptList"
LuaScriptList.Size = UDim2.new(0.9, 0, 0.88, 0)
LuaScriptList.Position = UDim2.new(0.05, 0, 0.11, 0)
LuaScriptList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LuaScriptList.BackgroundTransparency = 1
LuaScriptList.ScrollBarThickness = 5
LuaScriptList.CanvasSize = UDim2.new(0, 0, 2, 0)
LuaScriptList.Parent = LuaScriptPanel

-- إنشاء قائمة الإعدادات (ستكون مخفية بشكل افتراضي)
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(0.5, 0, 0.7, 0)
SettingsPanel.Position = UDim2.new(0.25, 0, 0.15, 0)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 10
SettingsPanel.Parent = MainFrame

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Name = "SettingsTitle"
SettingsTitle.Size = UDim2.new(0.9, 0, 0.08, 0)
SettingsTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
SettingsTitle.Text = "الإعدادات"
SettingsTitle.TextColor3 = Color3.new(1, 1, 1)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 18
SettingsTitle.ZIndex = 11
SettingsTitle.Parent = SettingsPanel

local SettingsCloseButton = Instance.new("TextButton")
SettingsCloseButton.Name = "SettingsCloseBtn"
SettingsCloseButton.Size = UDim2.new(0.08, 0, 0.08, 0)
SettingsCloseButton.Position = UDim2.new(0.9, 0, 0.02, 0)
SettingsCloseButton.Text = "×"
SettingsCloseButton.TextColor3 = Color3.new(1, 0.3, 0.3)
SettingsCloseButton.TextSize = 24
SettingsCloseButton.BackgroundTransparency = 1
SettingsCloseButton.ZIndex = 11
SettingsCloseButton.Parent = SettingsPanel

-- وظيفة لإنشاء شريط تمرير للإعدادات
local function createSlider(title, min, max, default, yPos, callback)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = title.."Container"
    sliderContainer.Size = UDim2.new(0.9, 0, 0.08, 0)
    sliderContainer.Position = UDim2.new(0.05, 0, yPos, 0)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.ZIndex = 11
    sliderContainer.Parent = SettingsPanel
    
    local sliderTitle = Instance.new("TextLabel")
    sliderTitle.Name = title.."Title"
    sliderTitle.Size = UDim2.new(0.3, 0, 1, 0)
    sliderTitle.Position = UDim2.new(0, 0, 0, 0)
    sliderTitle.Text = title
    sliderTitle.TextColor3 = Color3.new(1, 1, 1)
    sliderTitle.BackgroundTransparency = 1
    sliderTitle.Font = Enum.Font.GothamMedium
    sliderTitle.TextSize = 14
    sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    sliderTitle.ZIndex = 11
    sliderTitle.Parent = sliderContainer
    
    local sliderValue = Instance.new("TextLabel")
    sliderValue.Name = title.."Value"
    sliderValue.Size = UDim2.new(0.1, 0, 1, 0)
    sliderValue.Position = UDim2.new(0.9, 0, 0, 0)
    sliderValue.Text = tostring(default)
    sliderValue.TextColor3 = Color3.new(1, 1, 1)
    sliderValue.BackgroundTransparency = 1
    sliderValue.Font = Enum.Font.GothamMedium
    sliderValue.TextSize = 14
    sliderValue.TextXAlignment = Enum.TextXAlignment.Right
    sliderValue.ZIndex = 11
    sliderValue.Parent = sliderContainer
    
    local sliderBG = Instance.new("Frame")
    sliderBG.Name = title.."BG"
    sliderBG.Size = UDim2.new(0.5, 0, 0.2, 0)
    sliderBG.Position = UDim2.new(0.3, 0, 0.4, 0)
    sliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBG.BorderSizePixel = 0
    sliderBG.ZIndex = 11
    sliderBG.Parent = sliderContainer
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = title.."Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 11
    sliderFill.Parent = sliderBG
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = title.."Button"
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.Position = UDim2.new(0, 0, 0, 0)
    sliderButton.Text = ""
    sliderButton.BackgroundTransparency = 1
    sliderButton.ZIndex = 12
    sliderButton.Parent = sliderBG
    
    local dragging = false
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBG.AbsolutePosition
            local sliderSize = sliderBG.AbsoluteSize
            
            local relX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            sliderFill.Size = UDim2.new(relX, 0, 1, 0)
            
            local value = min + (max - min) * relX
            value = math.floor(value * 10) / 10 -- تقريب إلى أقرب 0.1
            sliderValue.Text = tostring(value)
            
            callback(value)
        end
    end)
    
    return sliderContainer
end

-- وظيفة لإنشاء زر اختيار اللون
local function createColorPicker(title, default, yPos, callback)
    local colorContainer = Instance.new("Frame")
    colorContainer.Name = title.."Container"
    colorContainer.Size = UDim2.new(0.9, 0, 0.08, 0)
    colorContainer.Position = UDim2.new(0.05, 0, yPos, 0)
    colorContainer.BackgroundTransparency = 1
    colorContainer.ZIndex = 11
    colorContainer.Parent = SettingsPanel
    
    local colorTitle = Instance.new("TextLabel")
    colorTitle.Name = title.."Title"
    colorTitle.Size = UDim2.new(0.5, 0, 1, 0)
    colorTitle.Position = UDim2.new(0, 0, 0, 0)
    colorTitle.Text = title
    colorTitle.TextColor3 = Color3.new(1, 1, 1)
    colorTitle.BackgroundTransparency = 1
    colorTitle.Font = Enum.Font.GothamMedium
    colorTitle.TextSize = 14
    colorTitle.TextXAlignment = Enum.TextXAlignment.Left
    colorTitle.ZIndex = 11
    colorTitle.Parent = colorContainer
    
    local colorPreview = Instance.new("Frame")
    colorPreview.Name = title.."Preview"
    colorPreview.Size = UDim2.new(0.2, 0, 0.8, 0)
    colorPreview.Position = UDim2.new(0.75, 0, 0.1, 0)
    colorPreview.BackgroundColor3 = default
    colorPreview.BorderSizePixel = 1
    colorPreview.BorderColor3 = Color3.new(1, 1, 1)
    colorPreview.ZIndex = 11
    colorPreview.Parent = colorContainer
    
    local colorButton = Instance.new("TextButton")
    colorButton.Name = title.."Button"
    colorButton.Size = UDim2.new(1, 0, 1, 0)
    colorButton.Position = UDim2.new(0, 0, 0, 0)
    colorButton.Text = ""
    colorButton.BackgroundTransparency = 1
    colorButton.ZIndex = 12
    colorButton.Parent = colorPreview
    
    -- إنشاء لوحة اختيار الألوان (ستكون مخفية بشكل افتراضي)
    local colorPicker = Instance.new("Frame")
    colorPicker.Name = title.."Picker"
    colorPicker.Size = UDim2.new(0.8, 0, 0.5, 0)
    colorPicker.Position = UDim2.new(0.1, 0, 0.25, 0)
    colorPicker.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    colorPicker.BorderSizePixel = 1
    colorPicker.Visible = false
    colorPicker.ZIndex = 15
    colorPicker.Parent = SettingsPanel
    
    local colorPickerTitle = Instance.new("TextLabel")
    colorPickerTitle.Name = "PickerTitle"
    colorPickerTitle.Size = UDim2.new(0.9, 0, 0.1, 0)
    colorPickerTitle.Position = UDim2.new(0.05, 0, 0.05, 0)
    colorPickerTitle.Text = "اختر لوناً"
    colorPickerTitle.TextColor3 = Color3.new(1, 1, 1)
    colorPickerTitle.BackgroundTransparency = 1
    colorPickerTitle.Font = Enum.Font.GothamBold
    colorPickerTitle.TextSize = 16
    colorPickerTitle.ZIndex = 16
    colorPickerTitle.Parent = colorPicker
    
    local colorPickerClose = Instance.new("TextButton")
    colorPickerClose.Name = "PickerClose"
    colorPickerClose.Size = UDim2.new(0.1, 0, 0.1, 0)
    colorPickerClose.Position = UDim2.new(0.85, 0, 0.05, 0)
    colorPickerClose.Text = "×"
    colorPickerClose.TextColor3 = Color3.new(1, 0.3, 0.3)
    colorPickerClose.TextSize = 20
    colorPickerClose.BackgroundTransparency = 1
    colorPickerClose.ZIndex = 16
    colorPickerClose.Parent = colorPicker
    
    -- إنشاء أزرار الألوان المختلفة
    local colors = {
        {Color3.fromRGB(255, 0, 0), "أحمر"},
        {Color3.fromRGB(0, 255, 0), "أخضر"},
        {Color3.fromRGB(0, 0, 255), "أزرق"},
        {Color3.fromRGB(255, 255, 0), "أصفر"},
        {Color3.fromRGB(255, 0, 255), "وردي"},
        {Color3.fromRGB(0, 255, 255), "سماوي"},
        {Color3.fromRGB(255, 165, 0), "برتقالي"},
        {Color3.fromRGB(128, 0, 128), "بنفسجي"},
        {Color3.fromRGB(25, 25, 25), "أسود"},
        {Color3.fromRGB(128, 128, 128), "رمادي"},
        {Color3.fromRGB(255, 255, 255), "أبيض"},
        {Color3.fromRGB(0, 128, 0), "أخضر داكن"}
    }
    
    for i, colorInfo in ipairs(colors) do
        local row = math.floor((i-1) / 4)
        local col = (i-1) % 4
        
        local colorBtn = Instance.new("Frame")
        colorBtn.Name = "Color"..i
        colorBtn.Size = UDim2.new(0.2, 0, 0.15, 0)
        colorBtn.Position = UDim2.new(0.05 + col * 0.23, 0, 0.2 + row * 0.18, 0)
        colorBtn.BackgroundColor3 = colorInfo[1]
        colorBtn.BorderSizePixel = 1
        colorBtn.ZIndex = 16
        colorBtn.Parent = colorPicker
        
        local colorBtnText = Instance.new("TextLabel")
        colorBtnText.Name = "ColorText"
        colorBtnText.Size = UDim2.new(1, 0, 0.4, 0)
        colorBtnText.Position = UDim2.new(0, 0, 1, 0)
        colorBtnText.Text = colorInfo[2]
        colorBtnText.TextColor3 = Color3.new(1, 1, 1)
        colorBtnText.BackgroundTransparency = 1
        colorBtnText.Font = Enum.Font.GothamMedium
        colorBtnText.TextSize = 10
        colorBtnText.ZIndex = 16
        colorBtnText.Parent = colorBtn
        
        local colorBtnButton = Instance.new("TextButton")
        colorBtnButton.Name = "ColorButton"
        colorBtnButton.Size = UDim2.new(1, 0, 1, 0)
        colorBtnButton.Position = UDim2.new(0, 0, 0, 0)
        colorBtnButton.Text = ""
        colorBtnButton.BackgroundTransparency = 1
        colorBtnButton.ZIndex = 17
        colorBtnButton.Parent = colorBtn
        
        colorBtnButton.MouseButton1Click:Connect(function()
            colorPreview.BackgroundColor3 = colorInfo[1]
            callback(colorInfo[1])
            colorPicker.Visible = false
        end)
    end
    
    colorPickerClose.MouseButton1Click:Connect(function()
        colorPicker.Visible = false
    end)
    
    colorButton.MouseButton1Click:Connect(function()
        colorPicker.Visible = true
    end)
    
    return colorContainer
end

-- إنشاء عناصر الإعدادات
local uiColorPicker = createColorPicker("لون الواجهة", settings.uiColor, 0.12, function(color)
    settings.uiColor = color
    MainFrame.BackgroundColor3 = color
    saveSettings(settings)
end)

local buttonColorPicker = createColorPicker("لون الأزرار", settings.buttonColor, 0.22, function(color)
    settings.buttonColor = color
    
    -- تحديث لون جميع الأزرار
    for _, child in pairs(MainScriptList:GetChildren()) do
        if child:IsA("TextButton") and child.BackgroundColor3 ~= settings.selectedButtonColor then
            child.BackgroundColor3 = color
        end
    end
    
    for _, child in pairs(LuaScriptList:GetChildren()) do
        if child:IsA("TextButton") and child.BackgroundColor3 ~= settings.selectedButtonColor then
            child.BackgroundColor3 = color
        end
    end
    
    saveSettings(settings)
end)

local textColorPicker = createColorPicker("لون النص", settings.textColor, 0.32, function(color)
    settings.textColor = color
    Watermark.TextColor3 = color
    ScriptBox.TextColor3 = color
    
    -- تحديث لون النص في جميع العناصر
    for _, child in pairs(MainScriptList:GetChildren()) do
        if child:IsA("TextButton") then
            child.TextColor3 = color
        end
    end
    
    for _, child in pairs(LuaScriptList:GetChildren()) do
        if child:IsA("TextButton") then
            child.TextColor3 = color
        end
    end
    
    saveSettings(settings)
end)

local speedSlider = createSlider("سرعة الحركة", 16, 100, settings.moveSpeed, 0.42, function(value)
    settings.moveSpeed = value
    
    -- تطبيق سرعة الحركة على اللاعب
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
    
    saveSettings(settings)
end)

local jumpSlider = createSlider("قوة القفز", 50, 200, settings.jumpPower, 0.52, function(value)
    settings.jumpPower = value
    
    -- تطبيق قوة القفز على اللاعب
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.JumpPower = value
    end
    
    saveSettings(settings)
end)

local sizeSlider = createSlider("حجم الواجهة", 0.5, 1.5, settings.uiSize, 0.62, function(value)
    settings.uiSize = value
    MainFrame.Size = UDim2.new(0.35 * value, 0, 0.5 * value, 0)
    saveSettings(settings)
end)

-- زر تطبيق الإعدادات
local applySettingsButton = Instance.new("TextButton")
applySettingsButton.Name = "ApplySettingsButton"
applySettingsButton.Size = UDim2.new(0.4, 0, 0.08, 0)
applySettingsButton.Position = UDim2.new(0.3, 0, 0.85, 0)
applySettingsButton.Text = "تطبيق الإعدادات"
applySettingsButton.TextColor3 = Color3.new(1, 1, 1)
applySettingsButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
applySettingsButton.Font = Enum.Font.GothamBold
applySettingsButton.TextSize = 14
applySettingsButton.ZIndex = 11
applySettingsButton.Parent = SettingsPanel

applySettingsButton.MouseButton1Click:Connect(function()
    -- تطبيق الإعدادات على اللاعب
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = settings.moveSpeed
        character.Humanoid.JumpPower = settings.jumpPower
    end
    
    -- حفظ الإعدادات
    saveSettings(settings)
    
    -- إخفاء لوحة الإعدادات
    SettingsPanel.Visible = false
end)

-- إنشاء قائمة البحث عن السكربتات (ستكون مخفية بشكل افتراضي)
local ScriptSearchPanel = Instance.new("Frame")
ScriptSearchPanel.Name = "ScriptSearchPanel"
ScriptSearchPanel.Size = UDim2.new(0.7, 0, 0.8, 0)
ScriptSearchPanel.Position = UDim2.new(0.15, 0, 0.1, 0)
ScriptSearchPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScriptSearchPanel.BorderSizePixel = 0
ScriptSearchPanel.Visible = false
ScriptSearchPanel.ZIndex = 10
ScriptSearchPanel.Parent = MainFrame

local SearchTitle = Instance.new("TextLabel")
SearchTitle.Name = "SearchTitle"
SearchTitle.Size = UDim2.new(0.9, 0, 0.08, 0)
SearchTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
SearchTitle.Text = "البحث عن السكربتات"
SearchTitle.TextColor3 = Color3.new(1, 1, 1)
SearchTitle.BackgroundTransparency = 1
SearchTitle.Font = Enum.Font.GothamBold
SearchTitle.TextSize = 18
SearchTitle.ZIndex = 11
SearchTitle.Parent = ScriptSearchPanel

local SearchCloseButton = Instance.new("TextButton")
SearchCloseButton.Name = "SearchCloseBtn"
SearchCloseButton.Size = UDim2.new(0.08, 0, 0.08, 0)
SearchCloseButton.Position = UDim2.new(0.9, 0, 0.02, 0)
SearchCloseButton.Text = "×"
SearchCloseButton.TextColor3 = Color3.new(1, 0.3, 0.3)
SearchCloseButton.TextSize = 24
SearchCloseButton.BackgroundTransparency = 1
SearchCloseButton.ZIndex = 11
SearchCloseButton.Parent = ScriptSearchPanel

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(0.7, 0, 0.06, 0)
SearchBox.Position = UDim2.new(0.05, 0, 0.12, 0)
SearchBox.Text = ""
SearchBox.PlaceholderText = "أدخل كلمات البحث..."
SearchBox.TextColor3 = Color3.new(1, 1, 1)
SearchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 14
SearchBox.ZIndex = 11
SearchBox.Parent = ScriptSearchPanel

local SearchButton = Instance.new("TextButton")
SearchButton.Name = "SearchButton"
SearchButton.Size = UDim2.new(0.2, 0, 0.06, 0)
SearchButton.Position = UDim2.new(0.75, 0, 0.12, 0)
SearchButton.Text = "بحث"
SearchButton.TextColor3 = Color3.new(1, 1, 1)
SearchButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SearchButton.Font = Enum.Font.GothamBold
SearchButton.TextSize = 14
SearchButton.ZIndex = 11
SearchButton.Parent = ScriptSearchPanel

local SearchResults = Instance.new("ScrollingFrame")
SearchResults.Name = "SearchResults"
SearchResults.Size = UDim2.new(0.9, 0, 0.7, 0)
SearchResults.Position = UDim2.new(0.05, 0, 0.2, 0)
SearchResults.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SearchResults.ScrollBarThickness = 5
SearchResults.CanvasSize = UDim2.new(0, 0, 2, 0)
SearchResults.ZIndex = 11
SearchResults.Parent = ScriptSearchPanel

-- وظيفة لإنشاء نتيجة بحث
local function createSearchResult(title, description, script, yPos)
    local resultContainer = Instance.new("Frame")
    resultContainer.Name = "Result_"..title
    resultContainer.Size = UDim2.new(0.95, 0, 0.15, 0)
    resultContainer.Position = UDim2.new(0.025, 0, yPos, 0)
    resultContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    resultContainer.BorderSizePixel = 0
    resultContainer.ZIndex = 12
    resultContainer.Parent = SearchResults
    
    local resultTitle = Instance.new("TextLabel")
    resultTitle.Name = "Title"
    resultTitle.Size = UDim2.new(0.9, 0, 0.3, 0)
    resultTitle.Position = UDim2.new(0.05, 0, 0.05, 0)
    resultTitle.Text = title
    resultTitle.TextColor3 = Color3.new(1, 1, 1)
    resultTitle.BackgroundTransparency = 1
    resultTitle.Font = Enum.Font.GothamBold
    resultTitle.TextSize = 14
    resultTitle.TextXAlignment = Enum.TextXAlignment.Left
    resultTitle.ZIndex = 13
    resultTitle.Parent = resultContainer
    
    local resultDesc = Instance.new("TextLabel")
    resultDesc.Name = "Description"
    resultDesc.Size = UDim2.new(0.9, 0, 0.3, 0)
    resultDesc.Position = UDim2.new(0.05, 0, 0.35, 0)
    resultDesc.Text = description
    resultDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    resultDesc.BackgroundTransparency = 1
    resultDesc.Font = Enum.Font.GothamMedium
    resultDesc.TextSize = 12
    resultDesc.TextXAlignment = Enum.TextXAlignment.Left
    resultDesc.ZIndex = 13
    resultDesc.Parent = resultContainer
    
    local resultButton = Instance.new("TextButton")
    resultButton.Name = "UseButton"
    resultButton.Size = UDim2.new(0.3, 0, 0.25, 0)
    resultButton.Position = UDim2.new(0.65, 0, 0.7, 0)
    resultButton.Text = "استخدام"
    resultButton.TextColor3 = Color3.new(1, 1, 1)
    resultButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    resultButton.Font = Enum.Font.GothamBold
    resultButton.TextSize = 12
    resultButton.ZIndex = 13
    resultButton.Parent = resultContainer
    
    resultButton.MouseButton1Click:Connect(function()
        ScriptBox.Text = script
        ScriptSearchPanel.Visible = false
    end)
    
    return resultContainer
end

-- قائمة السكربتات المشهورة للبحث
local popularScripts = {
    {
        title = "Infinite Yield",
        description = "أداة إدارة متقدمة مع العديد من الأوامر المفيدة",
        script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()]]
    },
    {
        title = "Owl Hub",
        description = "هاك متعدد الألعاب مع ميزات ESP وAimbot",
        script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"))()]]
    },
    {
        title = "CMD-X",
        description = "سكربت أوامر متقدم مع أكثر من 600 أمر",
        script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true))()]]
    },
    {
        title = "Dark Hub",
        description = "هاك متعدد الألعاب مع دعم للعديد من الألعاب الشهيرة",
        script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/RandomAdamYT/DarkHub/master/Init", true))()]]
    },
    {
        title = "Domain X",
        description = "سكربت هاب مع واجهة مستخدم جميلة وميزات متعددة",
        script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/DomainX/main/source',true))()]]
    },
    {
        title = "Hydroxide",
        description = "أداة تصحيح أخطاء متقدمة للمطورين",
        script = [[local owner = "Upbolt"
local branch = "revision"

local function webImport(file)
    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
end

webImport("init")
webImport("ui/main")]]
    },
    {
        title = "Universal ESP",
        description = "ESP عام يعمل في معظم الألعاب",
        script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua", true))()]]
    },
    {
        title = "Aimbot Universal",
        description = "Aimbot عام يعمل في معظم ألعاب إطلاق النار",
        script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-Script/main/Aimbot.lua"))()]]
    }
}

-- وظيفة للبحث عن السكربتات
local function searchScripts(query)
    -- مسح نتائج البحث السابقة
    for _, child in pairs(SearchResults:GetChildren()) do
        child:Destroy()
    end
    
    local yPos = 0
    local resultCount = 0
    
    -- البحث في السكربتات المشهورة
    for _, script in ipairs(popularScripts) do
        if string.find(string.lower(script.title), string.lower(query)) or 
           string.find(string.lower(script.description), string.lower(query)) then
            createSearchResult(script.title, script.description, script.script, yPos)
            yPos = yPos + 0.17
            resultCount = resultCount + 1
        end
    end
    
    -- إذا لم يتم العثور على نتائج، أظهر رسالة
    if resultCount == 0 then
        local noResults = Instance.new("TextLabel")
        noResults.Name = "NoResults"
        noResults.Size = UDim2.new(0.9, 0, 0.1, 0)
        noResults.Position = UDim2.new(0.05, 0, 0.4, 0)
        noResults.Text = "لم يتم العثور على نتائج للبحث: "..query
        noResults.TextColor3 = Color3.new(1, 1, 1)
        noResults.BackgroundTransparency = 1
        noResults.Font = Enum.Font.GothamMedium
        noResults.TextSize = 14
        noResults.ZIndex = 12
        noResults.Parent = SearchResults
    end
    
    -- تحديث حجم القماش
    SearchResults.CanvasSize = UDim2.new(0, 0, math.max(1, yPos + 0.1), 0)
end

-- تفعيل البحث عند النقر على زر البحث
SearchButton.MouseButton1Click:Connect(function()
    searchScripts(SearchBox.Text)
end)

-- تفعيل البحث عند الضغط على Enter في حقل البحث
SearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        searchScripts(SearchBox.Text)
    end
end)

-- إغلاق قائمة البحث
SearchCloseButton.MouseButton1Click:Connect(function()
    ScriptSearchPanel.Visible = false
end)

-- فتح قائمة البحث عند النقر على زر البحث عن السكربتات
SearchScriptsButton.MouseButton1Click:Connect(function()
    ScriptSearchPanel.Visible = true
    SearchBox.Text = ""
    
    -- عرض السكربتات المشهورة افتراضياً
    for _, child in pairs(SearchResults:GetChildren()) do
        child:Destroy()
    end
    
    local yPos = 0
    for _, script in ipairs(popularScripts) do
        createSearchResult(script.title, script.description, script.script, yPos)
        yPos = yPos + 0.17
    end
    
    SearchResults.CanvasSize = UDim2.new(0, 0, math.max(1, yPos + 0.1), 0)
end)

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Name = "ExecuteButton"
ExecuteBtn.Size = UDim2.new(0.25, 0, 0.08, 0)
ExecuteBtn.Position = UDim2.new(0.5, -50, 0.92, 0)
ExecuteBtn.Text = "▶ تشغيل"
ExecuteBtn.TextSize = 14
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)

-- زر المسح الجديد
local ClearBtn = Instance.new("TextButton")
ClearBtn.Name = "ClearButton"
ClearBtn.Size = UDim2.new(0.25, 0, 0.08, 0)
ClearBtn.Position = UDim2.new(0.25, -50, 0.92, 0)
ClearBtn.Text = "🗑️ مسح"
ClearBtn.TextSize = 14
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.BackgroundColor3 = Color3.fromRGB(215, 60, 0)
ClearBtn.TextColor3 = Color3.new(1, 1, 1)

-- زر حفظ السكربت
local SaveBtn = Instance.new("TextButton")
SaveBtn.Name = "SaveButton"
SaveBtn.Size = UDim2.new(0.25, 0, 0.08, 0)
SaveBtn.Position = UDim2.new(0.75, -50, 0.92, 0)
SaveBtn.Text = "💾 حفظ"
SaveBtn.TextSize = 14
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
SaveBtn.TextColor3 = Color3.new(1, 1, 1)
SaveBtn.Parent = MainFrame

ClearBtn.MouseButton1Click:Connect(function()
    ScriptBox.Text = ""
end)

local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0.3, 0, 0.15, 0)
ConfirmFrame.Position = UDim2.new(0.35, 0, 0.05, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ConfirmFrame.BorderSizePixel = 0
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 10

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(0.8, 0, 0.5, 0)
ConfirmText.Position = UDim2.new(0.1, 0, 0.1, 0)
ConfirmText.Text = "هل أنت متأكد من تشغيل السكربت؟"
ConfirmText.TextColor3 = Color3.new(1, 1, 1)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Font = Enum.Font.GothamMedium
ConfirmText.TextSize = 16
ConfirmText.ZIndex = 11

local ConfirmYes = Instance.new("TextButton")
ConfirmYes.Size = UDim2.new(0.3, 0, 0.3, 0)
ConfirmYes.Position = UDim2.new(0.1, 0, 0.6, 0)
ConfirmYes.Text = "تأكيد"
ConfirmYes.TextColor3 = Color3.new(1, 1, 1)
ConfirmYes.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ConfirmYes.Font = Enum.Font.GothamBold
ConfirmYes.TextSize = 14
ConfirmYes.ZIndex = 11

local ConfirmNo = Instance.new("TextButton")
ConfirmNo.Size = UDim2.new(0.3, 0, 0.3, 0)
ConfirmNo.Position = UDim2.new(0.6, 0, 0.6, 0)
ConfirmNo.Text = "إلغاء"
ConfirmNo.TextColor3 = Color3.new(1, 1, 1)
ConfirmNo.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ConfirmNo.Font = Enum.Font.GothamBold
ConfirmNo.TextSize = 14
ConfirmNo.ZIndex = 11

ConfirmYes.Parent = ConfirmFrame
ConfirmNo.Parent = ConfirmFrame
ConfirmText.Parent = ConfirmFrame
ConfirmFrame.Parent = ArceusGUI

local function toggleInterface()
    ArceusGUI.Enabled = not ArceusGUI.Enabled
    OpenButton.Text = ArceusGUI.Enabled and "✕" or "⚡"
    OpenButton.BackgroundColor3 = ArceusGUI.Enabled and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(30, 30, 30)
    
    -- حفظ البيانات عند إغلاق الواجهة
    if not ArceusGUI.Enabled then
        saveCurrentScript()
        saveData(savedData)
    end
end

OpenButton.MouseButton1Click:Connect(toggleInterface)
CloseButton.MouseButton1Click:Connect(toggleInterface)

-- متغير لتخزين الزر المحدد حالياً
local selectedButton = nil
local selectedScriptName = nil
local showingLuaPanel = false

-- وظيفة لحفظ محتوى السكربت الحالي قبل التبديل
local function saveCurrentScript()
    if selectedScriptName then
        savedData.scripts[selectedScriptName].code = ScriptBox.Text
        return true
    end
    return false
end

-- وظيفة لإنشاء زر سكربت في القائمة الرئيسية
local function createMainScriptButton(name, data, yOffset)
    local buttonHeight = 0.08
    
    local scriptButton = Instance.new("TextButton")
    scriptButton.Name = name
    scriptButton.Size = UDim2.new(0.9, 0, buttonHeight, 0)
    scriptButton.Position = UDim2.new(0.05, 0, yOffset, 0)
    scriptButton.Text = name
    scriptButton.TextColor3 = settings.textColor
    scriptButton.BackgroundColor3 = settings.buttonColor
    scriptButton.Font = Enum.Font.GothamMedium
    scriptButton.TextSize = 12
    scriptButton.Parent = MainScriptList
    
    -- إذا كان هذا هو السكربت المحدد سابقاً، قم بتحديده تلقائياً
    if savedData.settings.last_selected == name then
        scriptButton.BackgroundColor3 = settings.selectedButtonColor
        selectedButton = scriptButton
        selectedScriptName = name
        ScriptBox.Text = data.code
    end
    
    scriptButton.MouseButton1Click:Connect(function()
        -- حفظ محتوى السكربت الحالي قبل التبديل
        saveCurrentScript()
        
        -- تحديث الزر المحدد
        if selectedButton then
            selectedButton.BackgroundColor3 = settings.buttonColor
        end
        selectedButton = scriptButton
        selectedScriptName = name
        scriptButton.BackgroundColor3 = settings.selectedButtonColor
        
        -- تحميل محتوى السكربت المحدد
        ScriptBox.Text = savedData.scripts[name].code
        
        -- تحديث آخر سكربت محدد في الإعدادات
        savedData.settings.last_selected = name
        saveData(savedData)
        
        -- إذا كان هذا هو زر DMX Executor، أظهر قائمة lua
        if name == "DMX Executor" then
            showingLuaPanel = true
            MainScriptList.Visible = false
            LuaScriptPanel.Visible = true
            SearchScriptsButton.Visible = false
        else
            showingLuaPanel = false
            MainScriptList.Visible = true
            LuaScriptPanel.Visible = false
            SearchScriptsButton.Visible = true
        end
    end)
    
    return scriptButton
end

-- وظيفة لإنشاء زر سكربت lua
local function createLuaScriptButton(name, data, yOffset)
    local buttonHeight = 0.08
    
    local scriptButton = Instance.new("TextButton")
    scriptButton.Name = name
    scriptButton.Size = UDim2.new(1, 0, buttonHeight, 0)
    scriptButton.Position = UDim2.new(0, 0, yOffset, 0)
    scriptButton.Text = name
    scriptButton.TextColor3 = settings.textColor
    scriptButton.BackgroundColor3 = settings.buttonColor
    scriptButton.Font = Enum.Font.GothamMedium
    scriptButton.TextSize = 12
    scriptButton.Parent = LuaScriptList
    
    -- إضافة زر حذف
    local deleteBtn = Instance.new("TextButton")
    deleteBtn.Name = "DeleteButton"
    deleteBtn.Size = UDim2.new(0.2, 0, 0.8, 0)
    deleteBtn.Position = UDim2.new(0.8, 0, 0.1, 0)
    deleteBtn.Text = "×"
    deleteBtn.TextColor3 = Color3.new(1, 0.3, 0.3)
    deleteBtn.BackgroundTransparency = 1
    deleteBtn.Font = Enum.Font.GothamBold
    deleteBtn.TextSize = 14
    deleteBtn.ZIndex = 2
    deleteBtn.Parent = scriptButton
    
    deleteBtn.MouseButton1Click:Connect(function()
        -- حذف السكربت من البيانات المحفوظة
        if selectedScriptName == name then
            selectedScriptName = nil
            selectedButton = nil
            ScriptBox.Text = ""
        end
        
        savedData.scripts[name] = nil
        saveData(savedData)
        
        -- حذف الزر مباشرة من الواجهة
        scriptButton:Destroy()
        
        -- إعادة ترتيب الأزرار المتبقية
        local children = LuaScriptList:GetChildren()
        local newYOffset = 0
        for _, child in pairs(children) do
            if child:IsA("TextButton") then
                child.Position = UDim2.new(0, 0, newYOffset, 0)
                newYOffset = newYOffset + buttonHeight + 0.01
            end
        end
        
        -- تحديث حجم القماش
        LuaScriptList.CanvasSize = UDim2.new(0, 0, math.max(1, newYOffset), 0)
    end)
    
    -- إذا كان هذا هو السكربت المحدد سابقاً، قم بتحديده تلقائياً
    if savedData.settings.last_selected == name then
        scriptButton.BackgroundColor3 = settings.selectedButtonColor
        selectedButton = scriptButton
        selectedScriptName = name
        ScriptBox.Text = data.code
    end
    
    scriptButton.MouseButton1Click:Connect(function()
        -- حفظ محتوى السكربت الحالي قبل التبديل
        saveCurrentScript()
        
        -- تحديث الزر المحدد
        if selectedButton then
            selectedButton.BackgroundColor3 = settings.buttonColor
        end
        selectedButton = scriptButton
        selectedScriptName = name
        scriptButton.BackgroundColor3 = settings.selectedButtonColor
        
        -- تحميل محتوى السكربت المحدد
        ScriptBox.Text = savedData.scripts[name].code
        
        -- تحديث آخر سكربت محدد في الإعدادات
        savedData.settings.last_selected = name
        saveData(savedData)
    end)
    
    return scriptButton
end

-- وظيفة لتحميل قائمة السكربتات الرئيسية
local function populateMainScriptList()
    -- مسح جميع الأزرار الحالية
    for _, child in pairs(MainScriptList:GetChildren()) do
        child:Destroy()
    end
    
    local yOffset = 0
    local buttonHeight = 0.08
    local buttonSpacing = 0.01
    
    -- فصل السكربتات الافتراضية
    local defaultScripts = {}
    
    for name, data in pairs(savedData.scripts) do
        if not string.match(name, "^lua%.%d+$") then
            table.insert(defaultScripts, {name = name, data = data})
        end
    end
    
    -- إضافة السكربتات الافتراضية إلى القائمة الرئيسية
    for _, script in ipairs(defaultScripts) do
        createMainScriptButton(script.name, script.data, yOffset)
        yOffset = yOffset + buttonHeight + buttonSpacing
    end
    
    -- تحديث حجم القماش للتمرير في القائمة الرئيسية
    MainScriptList.CanvasSize = UDim2.new(0, 0, math.max(1, yOffset), 0)
end

-- وظيفة لتحميل قائمة سكربتات lua
local function populateLuaScriptList()
    -- مسح جميع الأزرار الحالية
    for _, child in pairs(LuaScriptList:GetChildren()) do
        child:Destroy()
    end
    
    local yOffset = 0
    local buttonHeight = 0.08
    local buttonSpacing = 0.01
    
    -- فصل السكربتات المخصصة
    local customScripts = {}
    
    for name, data in pairs(savedData.scripts) do
        if string.match(name, "^lua%.%d+$") then
            table.insert(customScripts, {name = name, data = data})
        end
    end
    
    -- ترتيب السكربتات المخصصة حسب الرقم
    table.sort(customScripts, function(a, b)
        local numA = tonumber(string.match(a.name, "%d+"))
        local numB = tonumber(string.match(b.name, "%d+"))
        return numA < numB
    end)
    
    -- إضافة السكربتات المخصصة إلى قائمة lua
    for _, script in ipairs(customScripts) do
        createLuaScriptButton(script.name, script.data, yOffset)
        yOffset = yOffset + buttonHeight + buttonSpacing
    end
    
    -- تحديث حجم القماش للتمرير في قائمة lua
    LuaScriptList.CanvasSize = UDim2.new(0, 0, math.max(1, yOffset), 0)
end

-- وظيفة للرجوع إلى القائمة الرئيسية
BackButton.MouseButton1Click:Connect(function()
    showingLuaPanel = false
    MainScriptList.Visible = true
    LuaScriptPanel.Visible = false
    SearchScriptsButton.Visible = true
    
    -- تحديد آخر سكربت محدد في القائمة الرئيسية
    for _, child in pairs(MainScriptList:GetChildren()) do
        if child.Name ~= "DMX Executor" then
            child.BackgroundColor3 = settings.buttonColor
        end
    end
    
    -- تحديد DMX Executor كغير محدد
    for _, child in pairs(MainScriptList:GetChildren()) do
        if child.Name == "DMX Executor" then
            child.BackgroundColor3 = settings.buttonColor
            break
        end
    end
    
    -- إذا كان هناك سكربت محدد في قائمة lua، احتفظ به
    if selectedScriptName and string.match(selectedScriptName, "^lua%.%d+$") then
        -- لا تغير شيئاً
    else
        -- حدد أول سكربت في القائمة الرئيسية
        for _, child in pairs(MainScriptList:GetChildren()) do
            if child.Name ~= "DMX Executor" then
                child.BackgroundColor3 = settings.selectedButtonColor
                selectedButton = child
                selectedScriptName = child.Name
                ScriptBox.Text = savedData.scripts[child.Name].code
                savedData.settings.last_selected = child.Name
                saveData(savedData)
                break
            end
        end
    end
})

-- وظيفة لإضافة سكربت lua جديد
NewScriptButton.MouseButton1Click:Connect(function()
    -- حفظ محتوى السكربت الحالي قبل إنشاء سكربت جديد
    saveCurrentScript()
    
    -- إيجاد الرقم التالي للسكربت الجديد
    local nextNumber = 1
    while savedData.scripts["lua."..nextNumber] do
        nextNumber = nextNumber + 1
    end
    
    local newScriptName = "lua."..nextNumber
    
    -- إضافة السكربت الجديد إلى البيانات المحفوظة
    savedData.scripts[newScriptName] = {
        code = "-- سكربت جديد "..nextNumber.."\n-- أكتب الكود هنا",
        description = "سكربت مخصص "..nextNumber
    }
    
    -- حفظ البيانات
    saveData(savedData)
    
    -- إضافة الزر الجديد مباشرة إلى الواجهة
    local yOffset = 0
    local buttonHeight = 0.08
    local buttonSpacing = 0.01
    
    -- حساب الموضع الجديد
    local children = LuaScriptList:GetChildren()
    for _, child in pairs(children) do
        if child:IsA("TextButton") then
            yOffset = yOffset + buttonHeight + buttonSpacing
        end
    end
    
    -- إنشاء الزر الجديد
    local newButton = createLuaScriptButton(newScriptName, savedData.scripts[newScriptName], yOffset)
    
    -- تحديث حجم القماش
    LuaScriptList.CanvasSize = UDim2.new(0, 0, math.max(1, yOffset + buttonHeight + buttonSpacing), 0)
    
    -- تحديد السكربت الجديد تلقائياً
    if selectedButton then
        selectedButton.BackgroundColor3 = settings.buttonColor
    end
    selectedButton = newButton
    selectedScriptName = newScriptName
    newButton.BackgroundColor3 = settings.selectedButtonColor
    ScriptBox.Text = savedData.scripts[newScriptName].code
    savedData.settings.last_selected = newScriptName
    saveData(savedData)
end)

local function safeExecute(code)
    local fn, err = loadstring(code)
    if fn then
        local success, result = pcall(fn)
        if not success then
            warn("خطأ في تنفيذ السكربت: " .. tostring(result))
        end
    else
        warn("خطأ في تحميل السكربت: " .. tostring(err))
    end
end

ExecuteBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
    MainFrame.Active = false
end)

ConfirmYes.MouseButton1Click:Connect(function()
    local code = ScriptBox.Text
    if code:match("%S") then
        safeExecute(code)
    end
    ConfirmFrame.Visible = false
    MainFrame.Active = true
end)

ConfirmNo.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
    MainFrame.Active = true
end)

-- وظيفة حفظ السكربت الحالي
SaveBtn.MouseButton1Click:Connect(function()
    if saveCurrentScript() then
        saveData(savedData)
        
        -- إظهار رسالة تأكيد الحفظ
        local saveConfirm = Instance.new("TextLabel")
        saveConfirm.Size = UDim2.new(0.3, 0, 0.05, 0)
        saveConfirm.Position = UDim2.new(0.35, 0, 0.8, 0)
        saveConfirm.Text = "✓ تم الحفظ بنجاح"
        saveConfirm.TextColor3 = Color3.new(0, 1, 0)
        saveConfirm.BackgroundTransparency = 0.5
        saveConfirm.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        saveConfirm.Font = Enum.Font.GothamBold
        saveConfirm.TextSize = 14
        saveConfirm.ZIndex = 20
        saveConfirm.Parent = ArceusGUI
        
        -- إخفاء الرسالة بعد ثانيتين
        spawn(function()
            wait(2)
            saveConfirm:Destroy()
        end)
        
        -- تحديث مؤشر الحالة
        StatusLabel.Text = "✓ تم الحفظ"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        changesMade = false
        
        -- إعادة النص بعد ثانيتين
        spawn(function()
            wait(2)
            if not changesMade then
                StatusLabel.Text = "✓ جاهز"
            end
        end)
    end
end)

-- فتح قائمة الإعدادات
SettingsButton.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = true
end)

-- إغلاق قائمة الإعدادات
SettingsCloseButton.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = false
end)

local resizing = false
local resizeStart = Vector2.new(0, 0)
local startSize = UDim2.new(0, 0, 0, 0)

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local framePos = MainFrame.AbsolutePosition
        local frameSize = MainFrame.AbsoluteSize
        
        if mousePos.X > framePos.X + frameSize.X - 10 and mousePos.Y > framePos.Y + frameSize.Y - 10 then
            resizing = true
            resizeStart = mousePos
            startSize = MainFrame.Size
        end
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if resizing then
            local mousePos = UserInputService:GetMouseLocation()
            local delta = mousePos - resizeStart
            MainFrame.Size = UDim2.new(startSize.X.Scale, startSize.X.Offset + delta.X, startSize.Y.Scale, startSize.Y.Offset + delta.Y)
        end
    end
end)

ResizeButton.MouseButton1Click:Connect(function()
    if MainFrame.Size == UDim2.new(0.35 * settings.uiSize, 0, 0.5 * settings.uiSize, 0) then
        MainFrame.Size = UDim2.new(0.5 * settings.uiSize, 0, 0.7 * settings.uiSize, 0)
    else
        MainFrame.Size = UDim2.new(0.35 * settings.uiSize, 0, 0.5 * settings.uiSize, 0)
    end
end)

-- إضافة مؤشر حالة الحفظ
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.2, 0, 0.03, 0)
StatusLabel.Position = UDim2.new(0.02, 0, 0.11, 0)
StatusLabel.Text = "✓ جاهز"
StatusLabel.TextColor3 = Color3.new(0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- تحديث مؤشر الحالة عند تغيير النص
local lastSaveTime = tick()
local changesMade = false

ScriptBox.Changed:Connect(function(property)
    if property == "Text" and selectedScriptName then
        changesMade = true
        StatusLabel.Text = "● تغييرات غير محفوظة"
        StatusLabel.TextColor3 = Color3.new(1, 0.7, 0)
        
        -- حفظ تلقائي بعد 30 ثانية من آخر تغيير
        spawn(function()
            local currentTime = tick()
            lastSaveTime = currentTime
            wait(30)
            if lastSaveTime == currentTime and changesMade then
                saveCurrentScript()
                saveData(savedData)
                StatusLabel.Text = "✓ تم الحفظ تلقائياً"
                StatusLabel.TextColor3 = Color3.new(0, 1, 0)
                changesMade = false
                
                -- إعادة النص بعد ثانيتين
                wait(2)
                if not changesMade then
                    StatusLabel.Text = "✓ جاهز"
                end
            end
        end)
    end
end)

-- تطبيق إعدادات اللاعب
RunService.Heartbeat:Connect(function()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = settings.moveSpeed
        character.Humanoid.JumpPower = settings.jumpPower
    end
end)

-- إعداد الحفظ التلقائي عند إغلاق اللعبة
pcall(setupAutoSave)

-- تحميل قائمة السكربتات
populateMainScriptList()
populateLuaScriptList()

-- إذا لم يتم تحديد أي سكربت، حدد الأول افتراضياً
if not selectedButton then
    -- محاولة تحديد سكربت من القائمة الرئيسية أولاً
    for _, child in pairs(MainScriptList:GetChildren()) do
        child.BackgroundColor3 = settings.selectedButtonColor
        selectedButton = child
        selectedScriptName = child.Name
        ScriptBox.Text = savedData.scripts[child.Name].code
        savedData.settings.last_selected = child.Name
        break
    end
end

-- التحقق مما إذا كان يجب عرض قائمة lua
if selectedScriptName == "DMX Executor" then
    showingLuaPanel = true
    MainScriptList.Visible = false
    LuaScriptPanel.Visible = true
    SearchScriptsButton.Visible = false
else
    showingLuaPanel = false
    MainScriptList.Visible = true
    LuaScriptPanel.Visible = false
    SearchScriptsButton.Visible = true
end

MainFrame.Parent = ArceusGUI
CloseButton.Parent = MainFrame
ScriptBox.Parent = MainFrame
ExecuteBtn.Parent = MainFrame
ClearBtn.Parent = MainFrame

ArceusGUI.Enabled = false
ControlGUI.Enabled = true
toggleInterface()

-- إظهار رسالة ترحيبية عند بدء التشغيل
local welcomeFrame = Instance.new("Frame")
welcomeFrame.Size = UDim2.new(0.3, 0, 0.2, 0)
welcomeFrame.Position = UDim2.new(0.35, 0, 0.4, 0)
welcomeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
welcomeFrame.BorderSizePixel = 0
welcomeFrame.ZIndex = 25
welcomeFrame.Parent = ArceusGUI

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(0.8, 0, 0.2, 0)
welcomeTitle.Position = UDim2.new(0.1, 0, 0.1, 0)
welcomeTitle.Text = "DMX Executor - النسخة المحسنة"
welcomeTitle.TextColor3 = Color3.new(1, 1, 1)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Font = Enum.Font.GothamBold
welcomeTitle.TextSize = 16
welcomeTitle.ZIndex = 26
welcomeTitle.Parent = welcomeFrame

local welcomeText = Instance.new("TextLabel")
welcomeText.Size = UDim2.new(0.8, 0, 0.4, 0)
welcomeText.Position = UDim2.new(0.1, 0, 0.3, 0)
welcomeText.Text = "تم تحميل السكربتات المحفوظة بنجاح!\nانقر على زر DMX Executor لإظهار قائمة السكربتات المخصصة\nاضغط على ⚙️ للوصول إلى الإعدادات"
welcomeText.TextColor3 = Color3.new(0.9, 0.9, 0.9)
welcomeText.BackgroundTransparency = 1
welcomeText.Font = Enum.Font.GothamMedium
welcomeText.TextSize = 14
welcomeText.ZIndex = 26
welcomeText.Parent = welcomeFrame

local welcomeClose = Instance.new("TextButton")
welcomeClose.Size = UDim2.new(0.3, 0, 0.15, 0)
welcomeClose.Position = UDim2.new(0.35, 0, 0.75, 0)
welcomeClose.Text = "موافق"
welcomeClose.TextColor3 = Color3.new(1, 1, 1)
welcomeClose.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
welcomeClose.Font = Enum.Font.GothamBold
welcomeClose.TextSize = 14
welcomeClose.ZIndex = 26
welcomeClose.Parent = welcomeFrame

welcomeClose.MouseButton1Click:Connect(function()
    welcomeFrame:Destroy()
end)

-- إخفاء الرسالة الترحيبية تلقائياً بعد 5 ثوان
spawn(function()
    wait(5)
    if welcomeFrame and welcomeFrame.Parent then
        welcomeFrame:Destroy()
    end
end)
