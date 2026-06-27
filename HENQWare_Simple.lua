-- HENQ Ware v2
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "HENQWare"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main Window
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 580, 0, 350)
window.Position = UDim2.new(0.5, -290, 0.5, -175)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
window.BorderSizePixel = 0
window.Active = true
window.Draggable = true
window.Visible = true
window.Parent = gui

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
title.BorderSizePixel = 0
title.Text = "HENQ Ware"
title.TextColor3 = Color3.fromRGB(180, 150, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = window

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 28)
tabBar.Position = UDim2.new(0, 0, 0, 28)
tabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
tabBar.BorderSizePixel = 0
tabBar.Parent = window

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 2)
tabList.VerticalAlignment = Enum.VerticalAlignment.Center
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabList.Parent = tabBar

-- Content Area
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -10, 1, -66)
content.Position = UDim2.new(0, 5, 0, 62)
content.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(180, 150, 255)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = window

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
contentLayout.Parent = content

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingLeft = UDim.new(0, 6)
contentPadding.PaddingTop = UDim.new(0, 6)
contentPadding.Parent = content

-- Tabs
local tabs = {}
local currentTab = nil

local function switchTab(name)
    if currentTab == name then return end
    for _, t in pairs(tabs) do
        t.button.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        t.button.TextColor3 = Color3.fromRGB(160, 160, 180)
        if t.container then t.container.Visible = false end
    end
    if tabs[name] then
        tabs[name].button.BackgroundColor3 = Color3.fromRGB(180, 150, 255)
        tabs[name].button.TextColor3 = Color3.fromRGB(255, 255, 255)
        if tabs[name].container then tabs[name].container.Visible = true end
        currentTab = name
    end
end

local function addTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 0, 0, 22)
    btn.AutomaticSize = Enum.AutomaticSize.X
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name .. "  "
    btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = tabBar

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparent = true
    container.BorderSizePixel = 0
    container.Visible = false
    container.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.Parent = container

    tabs[name] = { button = btn, container = container, layout = layout }

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)

    return container, layout
end

local function addSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -6, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    section.BorderSizePixel = 0
    section.Parent = parent

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 58)
    stroke.Thickness = 1
    stroke.Parent = section

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 22)
    titleLabel.Position = UDim2.new(0, 8, 0, 3)
    titleLabel.BackgroundTransparent = true
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(180, 150, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section

    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, -10, 0, 0)
    inner.Position = UDim2.new(0, 8, 0, 26)
    inner.AutomaticSize = Enum.AutomaticSize.Y
    inner.BackgroundTransparent = true
    inner.BorderSizePixel = 0
    inner.Parent = section

    local innerLayout = Instance.new("UIListLayout")
    innerLayout.Padding = UDim.new(0, 3)
    innerLayout.FillDirection = Enum.FillDirection.Vertical
    innerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    innerLayout.Parent = inner

    return inner
end

local toggleValues = {}
local function addToggle(parent, id, label)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundTransparent = true
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 14, 0, 14)
    box.Position = UDim2.new(0, 0, 0.5, -7)
    box.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    box.BorderSizePixel = 0
    box.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, -3, 1, -3)
    fill.Position = UDim2.new(0, 1.5, 0, 1.5)
    fill.BackgroundColor3 = Color3.fromRGB(180, 150, 255)
    fill.BorderSizePixel = 0
    fill.Visible = false
    fill.Parent = box

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Position = UDim2.new(0, 20, 0, 0)
    text.BackgroundTransparent = true
    text.Text = label
    text.TextColor3 = Color3.fromRGB(200, 200, 215)
    text.Font = Enum.Font.Gotham
    text.TextSize = 13
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparent = true
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local val = false
    toggleValues[id] = false

    local function setVal(v)
        val = v
        toggleValues[id] = v
        fill.Visible = v
        box.BackgroundColor3 = v and Color3.fromRGB(180, 150, 255) or Color3.fromRGB(55, 55, 70)
    end

    btn.MouseButton1Click:Connect(function()
        setVal(not val)
        if toggleValues[id .. "_cb"] then toggleValues[id .. "_cb"](val) end
    end)

    return { get = function() return val end, set = setVal }
end

local function addButton(parent, text, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 215)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = parent

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 55, 70)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(cb)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 52) end)

    return btn
end

-- Notifications
local function notify(msg, time)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 280, 0, 32)
    n.Position = UDim2.new(0.5, -140, 0, 10)
    n.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    n.BorderSizePixel = 0
    n.Parent = gui

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(180, 150, 255)
    s.Thickness = 1
    s.Parent = n

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -10, 1, 0)
    t.Position = UDim2.new(0, 5, 0, 0)
    t.BackgroundTransparent = true
    t.Text = msg
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = n

    task.spawn(function()
        task.wait(time or 3)
        for i = 1, 10 do
            n.BackgroundTransparency = i / 10
            t.TextTransparency = i / 10
            n.Position = n.Position + UDim2.new(0, 0, 0, -2)
            task.wait(0.03)
        end
        n:Destroy()
    end)
end

-- Helper functions
local function getChar() return player.Character end
local function getHRP() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function fuzzyMatch(str, p)
    str = str:lower(); p = p:lower()
    if str:find(p, 1, true) then return true end
    local si = 1
    for i = 1, #p do
        local ch = p:sub(i, i); local found = false
        while si <= #str do
            if str:sub(si, si) == ch then found = true; si = si + 1; break end
            si = si + 1
        end
        if not found then return false end
    end
    return true
end

local conns = {}
local function dc(name) if conns[name] then conns[name]:Disconnect(); conns[name] = nil end end

-- Edge detection
local function isAtEdge(hrp)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = { getChar() }
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local offs = {
        Vector3.new(2.5,0,0), Vector3.new(-2.5,0,0), Vector3.new(0,0,2.5), Vector3.new(0,0,-2.5),
        Vector3.new(2,0,2), Vector3.new(-2,0,2), Vector3.new(2,0,-2), Vector3.new(-2,0,-2),
        Vector3.new(1.5,0,0), Vector3.new(-1.5,0,0), Vector3.new(0,0,1.5), Vector3.new(0,0,-1.5)
    }
    local hit, miss = 0, 0
    for _, o in ipairs(offs) do
        local r = workspace:Raycast(hrp.Position + o, Vector3.new(0, -5, 0), rayParams)
        if r then hit = hit + 1 else miss = miss + 1 end
    end
    return miss > 0 and hit > 0
end

-- ========== BUILD UI ==========
local mainTab, mainLayout = addTab("Main")
local playerTab, playerLayout = addTab("Player")
local visualTab, visualLayout = addTab("Visuals")
local funTab, funLayout = addTab("Fun")
local miscTab, miscLayout = addTab("Misc")
local utilityTab, utilityLayout = addTab("Utility")

-- === MAIN TAB ===
local moveSec = addSection(mainLayout, "Movement")
local custSec = addSection(mainLayout, "Custom")

-- Air Strafe
local strafeMult = 120
addToggle(moveSec, "AirStrafe", "Air Strafe").set(false)
toggleValues.AirStrafe_cb = function(v)
    dc("AirStrafe")
    if v then
        local last = camera.CFrame.LookVector
        conns.AirStrafe = RunService.Heartbeat:Connect(function(dt)
            local hrp, hum = getHRP(), getHum()
            if not hrp or not hum then return end
            local cur = camera.CFrame.LookVector
            local f = Vector3.new(cur.X, 0, cur.Z).Unit
            local dx, dz = cur.X - last.X, cur.Z - last.Z
            local d = math.abs(dx) + math.abs(dz)
            if hum.FloorMaterial == Enum.Material.Air and d > 0.0005 then
                local vel = hrp.AssemblyLinearVelocity
                local hspd = Vector3.new(vel.X, 0, vel.Z).Magnitude
                local boost = f * (hspd + ((strafeMult * d) / dt) * 0.01)
                hrp.AssemblyLinearVelocity = Vector3.new(vel.X + (boost.X * d * 8), vel.Y, vel.Z + (boost.Z * d * 8))
            end
            last = cur
        end)
    end
end

-- Virtual Strafe
local vsMult = 120
addToggle(moveSec, "VirtualStrafe", "Virtual Strafe").set(false)
toggleValues.VirtualStrafe_cb = function(v)
    dc("VirtualStrafe")
    if v then
        conns.VirtualStrafe = camera:GetPropertyChangedSignal("CFrame"):Connect(function()
            local hrp = getHRP()
            if hrp then
                local lk = camera.CFrame.LookVector
                hrp.AssemblyLinearVelocity = Vector3.new(lk.X * vsMult, hrp.AssemblyLinearVelocity.Y, lk.Z * vsMult)
            end
        end)
    end
end

-- Easy Bounce (Edge Only)
local bouncePow = 100
addToggle(moveSec, "EasyBounce", "Easy Bounce (Edge)").set(false)
toggleValues.EasyBounce_cb = function(v)
    dc("EasyBounce")
    if v then
        conns.EasyBounce = RunService.Heartbeat:Connect(function()
            local hrp, hum = getHRP(), getHum()
            if hrp and hum and hum.FloorMaterial ~= Enum.Material.Air and isAtEdge(hrp) then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, bouncePow, hrp.AssemblyLinearVelocity.Z)
            end
        end)
    end
end

-- Auto Trimp
local trimpP = 80
addToggle(moveSec, "AutoTrimp", "Auto Trimp").set(false)
toggleValues.AutoTrimp_cb = function(v)
    dc("AutoTrimp")
    if v then
        conns.AutoTrimp = RunService.Heartbeat:Connect(function()
            local hrp, hum = getHRP(), getHum()
            if hrp and hum then
                local vel = hrp.AssemblyLinearVelocity
                if hum.FloorMaterial == Enum.Material.Air then
                    hrp.AssemblyLinearVelocity = Vector3.new(vel.X, trimpP, vel.Z)
                end
            end
        end)
    end
end

-- Non-Moveable Emotes
addToggle(moveSec, "EmoteMove", "Non-Moveable Emotes").set(false)
toggleValues.EmoteMove_cb = function(v)
    dc("EmoteMove")
    if v then
        conns.EmoteMove = RunService.Heartbeat:Connect(function()
            local hum = getHum()
            if hum then
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    local hrp = getHRP()
                    if hrp then
                        hrp.AssemblyLinearVelocity = Vector3.new(md.X * hum.WalkSpeed, hrp.AssemblyLinearVelocity.Y, md.Z * hum.WalkSpeed)
                    end
                end
            end
        end)
    end
end

-- Downed Dash
local SLIDE_O = { Crouch = true, Slide = true, SlideAir = true, EmotingSlide = true, EmotingSlideAir = true, CarryingSlide = true }
local IGNORE = { Default = true, None = true }

local function getLV(root)
    local att = root:FindFirstChild("SlideAttachment") or Instance.new("Attachment", root)
    att.Name = "SlideAttachment"
    local lv = root:FindFirstChild("SlideLinearVelocity") or Instance.new("LinearVelocity", root)
    lv.Name = "SlideLinearVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
    lv.MaxAxesForce = Vector3.new(100000, 0, 100000)
    return lv
end

addToggle(moveSec, "DownedDash", "Downed Dash").set(false)
toggleValues.DownedDash_cb = function(v)
    dc("DownedDash")
    if v then
        local grp = RaycastParams.new()
        grp.FilterType = Enum.RaycastFilterType.Exclude
        local sh = { "None", "None", "None", "None", "None" }
        local wasSliding, slidAct, curSpd = false, false, 0
        local dTime, boostDone = 0, false
        local lYaw, mDir = 0, Vector3.new(0, 0, 0)

        conns.DownedDash = RunService.Heartbeat:Connect(function(dt)
            local char, root, hum = getChar(), getHRP(), getHum()
            if not char or not root or not hum then return end
            local lv = getLV(root)
            grp.FilterDescendantsInstances = { char }
            local st = char:GetAttribute("State") or "None"

            if sh[1] ~= st then
                table.insert(sh, 1, st)
                if #sh > 6 then table.remove(sh) end
                if st == "Downed" then
                    local f = false
                    for i = 2, #sh do
                        local hs = sh[i]
                        if SLIDE_O[hs] then f = true; break elseif not IGNORE[hs] then break end
                    end
                    if f then slidAct = true end
                elseif not SLIDE_O[st] then
                    slidAct = false
                end
            end

            if st == "Downed" and slidAct then
                lv.Enabled = true
                if not wasSliding then
                    curSpd = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude
                    dTime = os.clock()
                    boostDone = false
                    wasSliding = true
                end
                if not boostDone and os.clock() - dTime >= 0.1 then
                    curSpd = math.max(curSpd, 50)
                    boostDone = true
                end
                local onGround = hum.FloorMaterial ~= Enum.Material.Air
                local gRay = workspace:Raycast(root.Position, Vector3.new(0, -5, 0), grp)
                local cf = camera.CFrame.LookVector
                local camF = Vector3.new(cf.X, 0, cf.Z).Unit
                local _, yaw, _ = camera.CFrame:ToEulerAnglesYXZ()
                local yd = yaw - lYaw
                if yd > math.pi then yd = yd - math.pi * 2 end
                if yd < -math.pi then yd = yd + math.pi * 2 end
                lYaw = yaw
                local canStr = false
                local inp = hum.MoveDirection
                if inp.Magnitude > 0.1 then
                    local rel = camera.CFrame:VectorToObjectSpace(inp)
                    if (rel.X < -0.1 and yd > 0.001) or (rel.X > 0.1 and yd < -0.001) then
                        mDir = camF
                        canStr = true
                    end
                end
                if mDir.Magnitude < 0.1 then mDir = camF end
                if canStr then
                    curSpd = curSpd + dt
                elseif onGround then
                    local slope = false
                    if gRay and gRay.Instance and gRay.Normal.Y < 0.98 and mDir.Unit:Dot(gRay.Normal) < -0.05 then
                        slope = true
                        if curSpd < 55.5 then curSpd = math.min(curSpd + 10 * dt, 55.5) end
                    end
                    if not slope and curSpd <= 55.5 then curSpd = math.max(20, curSpd - 3 * dt) end
                end
                if onGround and curSpd > 55.5 then curSpd = math.max(55.5, curSpd - 20 * dt) end
                if curSpd > 0.5 then
                    lv.VectorVelocity = mDir.Unit * curSpd
                else
                    curSpd = 0
                    lv.VectorVelocity = Vector3.new(0, 0, 0)
                end
                char:SetAttribute("RelativeSpeed", curSpd)
            else
                lv.Enabled = false
                lv.VectorVelocity = Vector3.new(0, 0, 0)
                curSpd = 0
                wasSliding = false
                boostDone = false
                mDir = Vector3.new(0, 0, 0)
                local _, yaw, _ = camera.CFrame:ToEulerAnglesYXZ()
                lYaw = yaw
            end
        end)
    else
        local root = getHRP()
        if root then
            local lv = root:FindFirstChild("SlideLinearVelocity")
            if lv then lv.Enabled = false; lv.VectorVelocity = Vector3.new(0, 0, 0) end
        end
    end
end

-- Edge Boost
_G.EdgeBoostLoaded = false; _G.EdgeBoostConnection = nil; _G.EdgeBoostInput = nil; _G.EdgeBoostEnabled = true
addButton(custSec, "Easy Edge Boost (U toggle)", function()
    if _G.EdgeBoostLoaded then
        if _G.EdgeBoostConnection then _G.EdgeBoostConnection:Disconnect() end
        if _G.EdgeBoostInput then _G.EdgeBoostInput:Disconnect() end
        _G.EdgeBoostLoaded = false
        notify("Edge Boost disabled", 2)
        return
    end
    _G.EdgeBoostLoaded = true
    _G.EdgeBoostEnabled = true
    local BP = 100
    local function gch()
        local c = player.Character or player.CharacterAdded:Wait()
        local hrp = c:WaitForChild("HumanoidRootPart")
        local h = c:WaitForChild("Humanoid")
        return c, hrp, h
    end
    local ch, hrp, hum = gch()

    local function isBP(p)
        local kws = { "bounce", "boost", "launch", "jump", "pad", "ramp", "platform" }
        local n = string.lower(p.Name)
        for _, kw in pairs(kws) do if n:find(kw) then return true end end
        if p.Parent and (p.Parent:IsA("Model") or p.Parent:IsA("Folder")) then
            local pn = string.lower(p.Parent.Name)
            for _, kw in pairs(kws) do if pn:find(kw) then return true end end
        end
        return false
    end

    _G.EdgeBoostConnection = RunService.Stepped:Connect(function()
        if not _G.EdgeBoostEnabled or not hrp or not hum or hum.Health <= 0 then return end
        if hrp.AssemblyLinearVelocity.Y < -1 then
            local pts = hrp:GetTouchingParts()
            local edge, bnc = false, false
            if #pts > 0 then
                for _, p in pairs(pts) do
                    if isBP(p) then bnc = true; break end
                end
                if not bnc then edge = true end
            end
            if edge then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z) + Vector3.new(0, BP, 0)
            end
        end
    end)

    _G.EdgeBoostInput = UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.U then
            _G.EdgeBoostEnabled = not _G.EdgeBoostEnabled
            if _G.EdgeBoostEnabled then ch, hrp, hum = gch(); notify("Edge Boost enabled", 3)
            else notify("Edge Boost disabled", 3) end
        end
    end)
    notify("Edge Boost enabled! (U toggle)", 3)
end)

-- Easy Hop
local hbX, hbY, hbZ = 6, 3, 6
local FOLDER = "AABB_Wireframe_Folder"
local hitboxFolder = nil

local function getHighest(obj)
    local h, my = nil, -math.huge
    local function ck(p)
        if p:IsA("BasePart") then
            local t = p.Position.Y + p.Size.Y / 2
            if t > my then my = t; h = p end
        end
    end
    ck(obj)
    for _, d in pairs(obj:GetDescendants()) do ck(d) end
    return h
end

local function calcAABB(tgt)
    local mix, miy, miz = math.huge, math.huge, math.huge
    local mxx, mxy, mxz = -math.huge, -math.huge, -math.huge
    local parts = {}
    if tgt:IsA("BasePart") then table.insert(parts, tgt) end
    for _, d in pairs(tgt:GetDescendants()) do if d:IsA("BasePart") then table.insert(parts, d) end end
    if #parts == 0 then return nil end
    for _, p in ipairs(parts) do
        local cf, s = p.CFrame, p.Size / 2
        for _, c in ipairs({
            cf * Vector3.new(s.X, s.Y, s.Z), cf * Vector3.new(-s.X, s.Y, s.Z),
            cf * Vector3.new(s.X, -s.Y, s.Z), cf * Vector3.new(-s.X, -s.Y, s.Z),
            cf * Vector3.new(s.X, s.Y, -s.Z), cf * Vector3.new(-s.X, s.Y, -s.Z),
            cf * Vector3.new(s.X, -s.Y, -s.Z), cf * Vector3.new(-s.X, -s.Y, -s.Z)
        }) do
            mix = math.min(mix, c.X); miy = math.min(miy, c.Y); miz = math.min(miz, c.Z)
            mxx = math.max(mxx, c.X); mxy = math.max(mxy, c.Y); mxz = math.max(mxz, c.Z)
        end
    end
    return Vector3.new((mxx + mix) / 2, (mxy + miy) / 2, (mxz + miz) / 2), Vector3.new(mxx - mix, mxy - miy, mxz - miz)
end

addToggle(custSec, "EasyHop", "Easy Hop").set(false)
toggleValues.EasyHop_cb = function(v)
    if hitboxFolder then hitboxFolder:Destroy(); hitboxFolder = nil end
    if v then
        hitboxFolder = Instance.new("Folder")
        hitboxFolder.Name = FOLDER
        hitboxFolder.Parent = workspace
        local cnt = 0
        pcall(function()
            local gf = workspace:FindFirstChild("Game")
            if gf then
                local m = gf:FindFirstChild("Map")
                local p = m and m:FindFirstChild("Parts")
                local pr = p and p:FindFirstChild("ImmovableProps")
                if pr then
                    for _, o in pairs(pr:GetChildren()) do
                        if o.Name:find("Cactus") or o.Name:find("Fence") or o.Name:find("Wall") then
                            local t = getHighest(o)
                            if t then
                                local c, s = calcAABB(t)
                                if c and s then
                                    local bx = Instance.new("Part")
                                    bx.Size = s + Vector3.new(hbX, hbY, hbZ)
                                    bx.Position = c
                                    bx.Anchored = true
                                    bx.CanCollide = true
                                    bx.Transparency = 1
                                    bx.Parent = hitboxFolder
                                    cnt = cnt + 1
                                end
                            end
                        end
                    end
                end
            end
        end)
        notify("Easy Hop: " .. cnt .. " objects expanded", 3)
    end
end

-- Remove Walls
local disabledWalls = {}
addButton(custSec, "Remove Invisible Walls", function()
    local r = 0; local ch = getChar()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Transparency == 1 and o.CanCollide then
            if not (ch and o:IsDescendantOf(ch)) then
                o.CanCollide = false; table.insert(disabledWalls, o); r = r + 1
            end
        end
    end
    notify("Removed " .. r .. " wall(s)", 4)
end)
addButton(custSec, "Restore Walls", function()
    local r = 0
    for _, p in ipairs(disabledWalls) do
        if p and p.Parent then p.CanCollide = true; r = r + 1 end
    end
    disabledWalls = {}
    notify("Restored " .. r .. " wall(s)", 4)
end)

-- === PLAYER TAB ===
local pMove = addSection(playerLayout, "Movement")
local pCam = addSection(playerLayout, "Camera")

local walkSpd = 16
addToggle(pMove, "WalkSpeed", "Walk Speed").set(false)
toggleValues.WalkSpeed_cb = function(v)
    dc("WalkSpeed")
    if v then
        conns.WalkSpeed = RunService.Heartbeat:Connect(function()
            local h = getHum()
            if h then h.WalkSpeed = walkSpd end
        end)
    else
        local h = getHum()
        if h then h.WalkSpeed = 16 end
    end
end

local jumpPow = 50
addToggle(pMove, "JumpPower", "Jump Power").set(false)
toggleValues.JumpPower_cb = function(v)
    dc("JumpPower")
    if v then
        conns.JumpPower = RunService.Heartbeat:Connect(function()
            local h = getHum()
            if h then h.JumpPower = jumpPow end
        end)
    else
        local h = getHum()
        if h then h.JumpPower = 50 end
    end
end

local sprintSpd = 32
addToggle(pMove, "Sprint", "Sprint (Hold Shift)").set(false)
toggleValues.Sprint_cb = function(v)
    dc("Sprint")
    if v then
        conns.Sprint = RunService.Heartbeat:Connect(function()
            local h = getHum()
            if h then
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    h.WalkSpeed = sprintSpd
                elseif not toggleValues.WalkSpeed then
                    h.WalkSpeed = 16
                end
            end
        end)
    end
end

addToggle(pCam, "NoShake", "Disable Cam Shake").set(false)
toggleValues.NoShake_cb = function(v)
    dc("NoShake")
    if v then
        conns.NoShake = RunService.RenderStepped:Connect(function()
            local c = workspace.CurrentCamera
            c.CFrame = CFrame.lookAt(c.CFrame.Position, c.CFrame.Position + c.CFrame.LookVector, Vector3.new(0, 1, 0))
        end)
    end
end

addToggle(pCam, "FullBright", "Full Bright").set(false)
toggleValues.FullBright_cb = function(v)
    if v then
        Lighting.Brightness = 3; Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255); Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1; Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200); Lighting.GlobalShadows = true
    end
end

local ofe, ofs = nil, nil
addToggle(pCam, "NoFog", "Remove Fog").set(false)
toggleValues.NoFog_cb = function(v)
    if v then
        ofe = Lighting.FogEnd; ofs = Lighting.FogStart
        Lighting.FogEnd = 100000; Lighting.FogStart = 99999
    else
        Lighting.FogEnd = ofe or 100000; Lighting.FogStart = ofs or 0
    end
end

-- === VISUALS TAB ===
local visSec = addSection(visualLayout, "World")
local cosSec = addSection(visualLayout, "Cosmetics")

addToggle(visSec, "PlayerESP", "Player ESP").set(false)
toggleValues.PlayerESP_cb = function(v)
    if _G.espFolder then _G.espFolder:Destroy(); _G.espFolder = nil end
    if v then
        _G.espFolder = Instance.new("Folder")
        _G.espFolder.Name = "PlayerESP"
        _G.espFolder.Parent = workspace
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(0, 255, 0)
                h.OutlineColor = Color3.fromRGB(0, 255, 0)
                h.FillTransparency = 0.3
                h.OutlineTransparency = 0
                h.Adornee = p.Character
                h.Parent = _G.espFolder
            end
        end
    end
end

addToggle(visSec, "RGB", "RGB Mode").set(false)
toggleValues.RGB_cb = function(v)
    dc("RGB")
    if v then
        local rg = Instance.new("ScreenGui"); rg.Name = "RGBMode"; rg.ResetOnSpawn = false; rg.Parent = playerGui
        local rf = Instance.new("Frame", rg)
        rf.Size = UDim2.new(1, 0, 1, 0); rf.BackgroundTransparency = 0.92; rf.BorderSizePixel = 0
        local t = 0
        conns.RGB = RunService.RenderStepped:Connect(function(dt)
            t = t + dt * 0.5; rf.BackgroundColor3 = Color3.fromHSV(t % 1, 1, 1)
        end)
        _G.RGBGui = rg
    else
        if _G.RGBGui then _G.RGBGui:Destroy(); _G.RGBGui = nil end
    end
end

-- Emote Swap
local e1, e2, oe1, oe2, eSwapped = "", "", "", "", false
local function norm(s) return s:gsub("%s+", ""):lower() end
local function lev(s, t)
    local m, n = #s, #t; local d = {}
    for i = 0, m do d[i] = { [0] = i } end
    for j = 0, n do d[0][j] = j end
    for i = 1, m do
        for j = 1, n do
            local c = (s:sub(i, i) == t:sub(j, j)) and 0 or 1
            d[i][j] = math.min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + c)
        end
    end
    return d[m][n]
end
local function sim(s, t)
    local nS, nT = norm(s), norm(t)
    return 1 - (lev(nS, nT) / math.max(#nS, #nT))
end
local function findBest(name)
    local em = ReplicatedStorage:FindFirstChild("Items")
    if not em then return name end
    em = em:FindFirstChild("Emotes")
    if not em then return name end
    local b, bs = name, 0.5
    for _, c in ipairs(em:GetChildren()) do
        local s = sim(name, c.Name)
        if s > bs then bs = s; b = c.Name end
    end
    return b
end

addButton(cosSec, "Apply Emote Swap", function()
    pcall(function()
        if e1 == "" or e2 == "" or e1 == e2 then notify("Enter two different emotes!", 3); return end
        local em = ReplicatedStorage:WaitForChild("Items"):WaitForChild("Emotes")
        local aN = findBest(e1); local bN = findBest(e2)
        local a, b = em:FindFirstChild(aN), em:FindFirstChild(bN)
        if not a or not b then notify("Emotes not found!", 3); return end
        if not eSwapped then oe1 = aN; oe2 = bN end
        local tr = Instance.new("Folder", em); tr.Name = "__t_" .. tostring(tick()):gsub("%.", "_")
        local ta, tb = Instance.new("Folder", tr), Instance.new("Folder", tr)
        for _, c in ipairs(a:GetChildren()) do c.Parent = ta end
        for _, c in ipairs(b:GetChildren()) do c.Parent = tb end
        for _, c in ipairs(ta:GetChildren()) do c.Parent = b end
        for _, c in ipairs(tb:GetChildren()) do c.Parent = a end
        tr:Destroy(); eSwapped = true
        notify("Swapped '" .. aN .. "' with '" .. bN .. "'", 3)
    end)
end)
addButton(cosSec, "Reset Emote Swap", function()
    pcall(function()
        if not eSwapped then notify("No emotes swapped!", 3); return end
        local em = ReplicatedStorage:WaitForChild("Items"):WaitForChild("Emotes")
        local a, b = em:FindFirstChild(e1), em:FindFirstChild(e2)
        if a and b then
            local tr = Instance.new("Folder", em); tr.Name = "__t_" .. tostring(tick()):gsub("%.", "_")
            local ta, tb = Instance.new("Folder", tr), Instance.new("Folder", tr)
            for _, c in ipairs(a:GetChildren()) do c.Parent = ta end
            for _, c in ipairs(b:GetChildren()) do c.Parent = tb end
            for _, c in ipairs(ta:GetChildren()) do c.Parent = b end
            for _, c in ipairs(tb:GetChildren()) do c.Parent = a end
            tr:Destroy()
        end
        eSwapped = false; notify("Reset to original", 3)
    end)
end)

-- Headless
addButton(cosSec, "Headless (Local)", function()
    pcall(function()
        local ch = getChar()
        if not ch then return end
        local h = ch:FindFirstChild("Head")
        if h then h.Transparency = 1 end
        local f = h and h:FindFirstChild("face")
        if f then f.Transparency = 1 end
        for _, o in pairs(ch:GetDescendants()) do
            if (o.Name:lower():find("hair") or o.Name:lower():find("hat")) and o:IsA("BasePart") then
                o.Transparency = 1
            end
        end
        notify("Headless applied", 3)
    end)
end)

-- === FUN TAB ===
local funSec = addSection(funLayout, "Legacy")
addButton(funSec, "Play Old Run Animation", function()
    pcall(function() local h = getHum(); if h then local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://180426354"; h:LoadAnimation(a):Play() end end)
end)
addButton(funSec, "Play Old Idle Animation", function()
    pcall(function() local h = getHum(); if h then local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://180435571"; h:LoadAnimation(a):Play() end end)
end)

addToggle(funSec, "LegacyNoClip", "Legacy No-Clip").set(false)
toggleValues.LegacyNoClip_cb = function(v)
    dc("LegacyNoClip")
    if v then
        conns.LegacyNoClip = RunService.Stepped:Connect(function()
            local ch = getChar()
            if ch then
                for _, p in pairs(ch:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        local ch = getChar()
        if ch then
            for _, p in pairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end

-- === MISC TAB ===
local confSec = addSection(miscLayout, "Config")
local infoSec = addSection(miscLayout, "Info")
local charSec = addSection(miscLayout, "Character")

local CONFIG_PATH = "HENQWare/config.json"; local _cfg = {}
addButton(confSec, "Save Config", function()
    pcall(function()
        if not isfolder("HENQWare") then makefolder("HENQWare") end
        writefile(CONFIG_PATH, game:GetService("HttpService"):JSONEncode(_cfg))
        notify("Saved!", 2)
    end)
end)
addButton(confSec, "Load Config", function()
    pcall(function()
        if isfile(CONFIG_PATH) then
            _cfg = game:GetService("HttpService"):JSONDecode(readfile(CONFIG_PATH))
            notify("Loaded!", 2)
        else notify("No config found!", 2) end
    end)
end)

addButton(infoSec, "Game Info", function()
    notify("Game: " .. game.Name .. " | ID: " .. game.PlaceId .. " | Players: " .. #Players:GetPlayers(), 5)
end)
addButton(infoSec, "Player Stats", function()
    local h, hrp = getHum(), getHRP()
    if not h or not hrp then notify("No character!", 2); return end
    local v = hrp.AssemblyLinearVelocity
    local spd = math.floor(math.sqrt(v.X ^ 2 + v.Z ^ 2))
    notify("HP: " .. math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth) .. " | SPD: " .. spd, 5)
end)

addButton(charSec, "Reset Character", function()
    local h = getHum()
    if h then h.Health = 0 end
end)
addButton(charSec, "Rejoin Server", function()
    notify("Rejoining...", 2)
    task.delay(1, function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end)
end)

-- === UTILITY TAB ===
local utilSec = addSection(utilityLayout, "Teleport")

addButton(utilSec, "Teleport Spawn", function()
    local hrp = getHRP()
    if hrp then hrp.CFrame = CFrame.new(0, 10, 0) end
end)

addButton(utilSec, "TP to Downed", function()
    local hrp = getHRP()
    if not hrp then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h, phrp = p.Character:FindFirstChildOfClass("Humanoid"), p.Character:FindFirstChild("HumanoidRootPart")
            if h and phrp and h.Health > 0 and h.Health < h.MaxHealth * 0.25 then
                hrp.CFrame = phrp.CFrame * CFrame.new(3, 0, 3)
                notify("TP to " .. p.Name, 3)
                return
            end
        end
    end
    notify("No downed players!", 2)
end)

addButton(utilSec, "TP to Nearest Ticket", function()
    local hrp = getHRP()
    if not hrp then return end
    local c, cd = nil, math.huge
    local kws = { "ticket", "coin", "gem", "star", "badge", "token", "collectible", "pickup", "reward" }
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") or o:IsA("Model") then
            local n = o.Name:lower()
            for _, kw in ipairs(kws) do
                if n:find(kw) then
                    local pos = (o:IsA("Model") and o:GetBoundingBox()) or o.Position
                    if pos then
                        local d = (pos - hrp.Position).Magnitude
                        if d < cd then cd = d; c = o end
                    end
                    break
                end
            end
        end
    end
    if c then
        local pos = (c:IsA("Model") and (c:GetBoundingBox() + Vector3.new(0, 3, 0))) or (c.Position + Vector3.new(0, 3, 0))
        hrp.CFrame = CFrame.new(pos)
        notify("TP to " .. c.Name, 3)
    else notify("None found!", 2) end
end)

-- Toggle keybind
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.X or inp.KeyCode == Enum.KeyCode.RightShift then
        window.Visible = not window.Visible
    end
end)

-- Show first tab
for _, t in pairs(tabs) do
    switchTab(t.button.Text:match("^%s*(.-)%s*$"))
    break
end

notify("HENQ Ware loaded! X / R-Shift to toggle", 5)
