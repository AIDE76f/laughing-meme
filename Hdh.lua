local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- إزالة الواجهة القديمة إذا كانت موجودة
if guiParent:FindFirstChild("PathScannerGUI") then
    guiParent.PathScannerGUI:Destroy()
end

--------------------------------------------------
-- 1. تصميم واجهة مستخدم محسنة لعرض المسارات الطويلة
--------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PathScannerGUI"
screenGui.Parent = guiParent

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350) -- تكبير النافذة لتسع المسارات
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔍 نتائج البحث عن كلمة 'موديل'"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- استخدام ScrollingFrame لعرض المسارات إذا كانت كثيرة
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -100)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 120, 0, 35)
closeBtn.Position = UDim2.new(0.5, -60, 1, -45)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "إغلاق الواجهة"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

--------------------------------------------------
-- 2. منطق البحث عن المسار بالكامل
--------------------------------------------------
local resultCount = 0

-- دالة للبحث داخل أي مجلد رئيسي
local function scanForKeyword(parentToScan)
    for _, obj in pairs(parentToScan:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            
            -- استخدام pcall لتجنب أي أخطاء إذا كان النص غير قابل للقراءة
            pcall(function()
                local text = obj.Text
                if text and string.find(text, "موديل") then
                    resultCount = resultCount + 1
                    
                    -- جلب المسار الكامل للكائن
                    local fullPath = obj:GetFullName()
                    
                    -- إنشاء نص جديد داخل القائمة لعرض المسار
                    local resultLabel = Instance.new("TextLabel")
                    resultLabel.Size = UDim2.new(1, -10, 0, 0)
                    resultLabel.AutomaticSize = Enum.AutomaticSize.Y
                    resultLabel.BackgroundTransparency = 1
                    resultLabel.Text = resultCount .. ". " .. fullPath .. "\n(النص: " .. text .. ")"
                    resultLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
                    resultLabel.Font = Enum.Font.Code
                    resultLabel.TextSize = 12
                    resultLabel.TextXAlignment = Enum.TextXAlignment.Left
                    resultLabel.TextWrapped = true
                    resultLabel.Parent = scrollFrame
                    
                    -- طباعة المسار في الـ Console أيضاً كنسخة احتياطية
                    print("تم العثور في: " .. fullPath)
                end
            end)
        end
    end
end

-- نبحث في عالم اللعبة بالكامل
scanForKeyword(workspace)
-- نبحث في واجهات المستخدم الخاصة باللاعب (أحياناً تكون اللوحات مخفية هنا)
scanForKeyword(guiParent)

--------------------------------------------------
-- 3. في حال عدم العثور على شيء
--------------------------------------------------
if resultCount == 0 then
    local noResult = Instance.new("TextLabel")
    noResult.Size = UDim2.new(1, 0, 0, 30)
    noResult.BackgroundTransparency = 1
    noResult.Text = "❌ لم يتم العثور على كلمة 'موديل' في أي نص."
    noResult.TextColor3 = Color3.fromRGB(255, 100, 100)
    noResult.Font = Enum.Font.Gotham
    noResult.TextSize = 14
    noResult.Parent = scrollFrame
end
