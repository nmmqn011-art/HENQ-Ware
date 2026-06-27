-- HENQ Ware [Standalone - No external libs]
local R = game:GetService("RunService"); local UIS = game:GetService("UserInputService"); local P = game:GetService("Players"); local L = game:GetService("Lighting"); local RS = game:GetService("ReplicatedStorage"); local D = game:GetService("Debris")
local plr = P.LocalPlayer; local pg = plr:WaitForChild("PlayerGui"); local cam = workspace.CurrentCamera
local function gC() return plr.Character end; local function gH() local c = gC(); return c and c:FindFirstChild("HumanoidRootPart") end; local function gU() local c = gC(); return c and c:FindFirstChildOfClass("Humanoid") end
local function fm(s,p) s=s:lower();p=p:lower();if s:find(p,1,true) then return true end;local si=1;for i=1,#p do local ch=p:sub(i,i);local f=false;while si<=#s do if s:sub(si,si)==ch then f=true;si=si+1;break end;si=si+1 end;if not f then return false end end;return true end
local svc = Instance.new("ScreenGui"); svc.Name = "HENQWare"; svc.ResetOnSpawn = false; svc.Parent = pg
local conns = {}; local function dc(n) if conns[n] then conns[n]:Disconnect(); conns[n] = nil end end
local toggles = {}; local opts = {}; local tabBtns = {}; local tabFrames = {}; local currentTab = nil
local UIScale = Instance.new("UIScale", svc); UIScale.Scale = 1
local main = Instance.new("Frame", svc); main.Size = UDim2.new(0,620,0,400); main.Position = UDim2.new(0.5,-310,0.5,-200); main.BackgroundColor3 = Color3.fromRGB(25,25,30); main.BorderSizePixel = 0; main.Active = true; main.Draggable = true; main.Visible = true
local titleBar = Instance.new("Frame", main); titleBar.Size = UDim2.new(1,0,0,30); titleBar.BackgroundColor3 = Color3.fromRGB(35,35,45); titleBar.BorderSizePixel = 0
local titleText = Instance.new("TextLabel", titleBar); titleText.Size = UDim2.new(1,0,1,0); titleText.BackgroundTransparent = true; titleText.Text = "HENQ Ware"; titleText.TextColor3 = Color3.fromRGB(200,170,255); titleText.Font = Enum.Font.GothamBold; titleText.TextSize = 16
local tabBar = Instance.new("Frame", main); tabBar.Size = UDim2.new(1,0,0,30); tabBar.Position = UDim2.new(0,0,0,30); tabBar.BackgroundColor3 = Color3.fromRGB(30,30,38); tabBar.BorderSizePixel = 0
local tabList = Instance.new("UIListLayout", tabBar); tabList.FillDirection = Enum.FillDirection.Horizontal; tabList.Padding = UDim.new(0,4); tabList.VerticalAlignment = Enum.VerticalAlignment.Center; tabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
local content = Instance.new("Frame", main); content.Size = UDim2.new(1,0,1,-64); content.Position = UDim2.new(0,0,0,64); content.BackgroundTransparent = true; content.BorderSizePixel = 0
local conLayout = Instance.new("UIListLayout", content); conLayout.FillDirection = Enum.FillDirection.Horizontal; conLayout.Padding = UDim.new(0,10); conLayout.VerticalAlignment = Enum.VerticalAlignment.Top
local leftCol = Instance.new("Frame", content); leftCol.Size = UDim2.new(0.5,-5,1,0); leftCol.BackgroundTransparent = true; leftCol.BorderSizePixel = 0
local rightCol = Instance.new("Frame", content); rightCol.Size = UDim2.new(0.5,-5,1,0); rightCol.BackgroundTransparent = true; rightCol.BorderSizePixel = 0
local leftLayout = Instance.new("UIListLayout", leftCol); leftLayout.Padding = UDim.new(0,8); leftLayout.VerticalAlignment = Enum.VerticalAlignment.Top
local rightLayout = Instance.new("UIListLayout", rightCol); rightLayout.Padding = UDim.new(0,8); rightLayout.VerticalAlignment = Enum.VerticalAlignment.Top

function notify(msg,t)
    local n = Instance.new("Frame", svc); n.Size = UDim2.new(0,280,0,35); n.Position = UDim2.new(0.5,-140,0,5); n.BackgroundColor3 = Color3.fromRGB(35,35,50); n.BorderSizePixel = 0; n.BorderColor3 = Color3.fromRGB(200,170,255)
    local nb = Instance.new("UIStroke", n); nb.Color = Color3.fromRGB(200,170,255); nb.Thickness = 1
    local nt = Instance.new("TextLabel", n); nt.Size = UDim2.new(1,-10,1,0); nt.Position = UDim2.new(0,5,0,0); nt.BackgroundTransparent = true; nt.Text = msg; nt.TextColor3 = Color3.fromRGB(255,255,255); nt.Font = Enum.Font.Gotham; nt.TextSize = 13; nt.TextXAlignment = Enum.TextXAlignment.Left
    local ti = t or 3; spawn(function() task.wait(ti); for i=1,10 do n.BackgroundTransparency = i/10; nt.TextTransparency = i/10; n.Position = n.Position + UDim2.new(0,0,0,-3); task.wait(0.03) end; n:Destroy() end)
end

local function createTab(name)
    local b = Instance.new("TextButton", tabBar); b.Size = UDim2.new(0,0,0,22); b.AutomaticSize = Enum.AutomaticSize.X; b.BackgroundColor3 = Color3.fromRGB(45,45,58); b.BorderSizePixel = 0; b.Text = "  "..name.."  "; b.TextColor3 = Color3.fromRGB(180,180,200); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Padding = UDim.new(0,8)
    local f = Instance.new("Frame", svc); f.Size = UDim2.new(1,0,1,0); f.Visible = false; f.BackgroundTransparent = true; f.BorderSizePixel = 0; f.Position = UDim2.new(0,0,0,0)
    local ft = Instance.new("Frame", f); ft.Size = UDim2.new(0,620,0,400); ft.Position = UDim2.new(0.5,-310,0.5,-200); ft.BackgroundTransparent = true; ft.BorderSizePixel = 0
    local fl = Instance.new("UIListLayout", ft); fl.FillDirection = Enum.FillDirection.Horizontal; fl.Padding = UDim.new(0,10); fl.VerticalAlignment = Enum.VerticalAlignment.Top
    local ll = Instance.new("Frame", ft); ll.Size = UDim2.new(0.5,-5,1,0); ll.BackgroundTransparent = true; ll.BorderSizePixel = 0
    local rl = Instance.new("Frame", ft); rl.Size = UDim2.new(0.5,-5,1,0); rl.BackgroundTransparent = true; rl.BorderSizePixel = 0
    local llayout = Instance.new("UIListLayout", ll); llayout.Padding = UDim.new(0,8); llayout.VerticalAlignment = Enum.VerticalAlignment.Top
    local rlayout = Instance.new("UIListLayout", rl); rlayout.Padding = UDim.new(0,8); rlayout.VerticalAlignment = Enum.VerticalAlignment.Top
    tabBtns[name] = b; tabFrames[name] = {f,ft,ll,rl,llayout,rlayout}
    b.MouseButton1Click:Connect(function()
        for _,tb in pairs(tabBtns) do tb.BackgroundColor3 = Color3.fromRGB(45,45,58); tb.TextColor3 = Color3.fromRGB(180,180,200) end
        b.BackgroundColor3 = Color3.fromRGB(200,170,255); b.TextColor3 = Color3.fromRGB(255,255,255)
        for _,tf in pairs(tabFrames) do tf[1].Visible = false end
        f.Visible = true; main.Visible = true; currentTab = name
    end)
    return ft, ll, rl
end

local function createGroupbox(parent, name, side)
    local g = Instance.new("Frame", parent); g.Size = UDim2.new(1,-10,0,0); g.AutomaticSize = Enum.AutomaticSize.Y; g.BackgroundColor3 = Color3.fromRGB(30,30,40); g.BorderSizePixel = 0; g.BorderColor3 = Color3.fromRGB(50,50,65)
    local gs = Instance.new("UIStroke", g); gs.Color = Color3.fromRGB(50,50,65); gs.Thickness = 1
    local gl = Instance.new("TextLabel", g); gl.Size = UDim2.new(1,-10,0,22); gl.Position = UDim2.new(0,8,0,4); gl.BackgroundTransparent = true; gl.Text = name; gl.TextColor3 = Color3.fromRGB(200,170,255); gl.Font = Enum.Font.GothamBold; gl.TextSize = 13; gl.TextXAlignment = Enum.TextXAlignment.Left
    local gc = Instance.new("Frame", g); gc.Size = UDim2.new(1,-10,0,0); gc.Position = UDim2.new(0,8,0,28); gc.AutomaticSize = Enum.AutomaticSize.Y; gc.BackgroundTransparent = true; gc.BorderSizePixel = 0
    local gcl = Instance.new("UIListLayout", gc); gcl.Padding = UDim.new(0,4); gcl.VerticalAlignment = Enum.VerticalAlignment.Top
    return gc
end

local function addToggle(parent, id, title, desc)
    local t = Instance.new("Frame", parent); t.Size = UDim2.new(1,0,0,26); t.BackgroundTransparent = true; t.BorderSizePixel = 0
    local tb = Instance.new("TextButton", t); tb.Size = UDim2.new(1,0,1,0); tb.BackgroundTransparent = true; tb.Text = ""; tb.BorderSizePixel = 0
    local ti = Instance.new("Frame", t); ti.Size = UDim2.new(0,14,0,14); ti.Position = UDim2.new(0,0,0.5,-7); ti.BackgroundColor3 = Color3.fromRGB(60,60,75); ti.BorderSizePixel = 0
    local tif = Instance.new("Frame", ti); tif.Size = UDim2.new(1,-3,1,-3); tif.Position = UDim2.new(0,1.5,0,1.5); tif.BackgroundColor3 = Color3.fromRGB(200,170,255); tif.BorderSizePixel = 0; tif.Visible = false
    local tl = Instance.new("TextLabel", t); tl.Size = UDim2.new(1,-20,1,0); tl.Position = UDim2.new(0,20,0,0); tl.BackgroundTransparent = true; tl.Text = title; tl.TextColor3 = Color3.fromRGB(200,200,220); tl.Font = Enum.Font.Gotham; tl.TextSize = 13; tl.TextXAlignment = Enum.TextXAlignment.Left
    local val = false
    toggles[id] = {get = function() return val end, set = function(v) val=v;tif.Visible=v;if v then ti.BackgroundColor3=Color3.fromRGB(200,170,255) else ti.BackgroundColor3=Color3.fromRGB(60,60,75) end end}
    tb.MouseButton1Click:Connect(function() toggles[id].set(not val); if toggles[id].cb then toggles[id].cb(val) end end)
    return toggles[id]
end

local function addSlider(parent, id, text, def, minv, maxv)
    local s = Instance.new("Frame", parent); s.Size = UDim2.new(1,0,0,30); s.BackgroundTransparent = true; s.BorderSizePixel = 0
    local sl = Instance.new("TextLabel", s); sl.Size = UDim2.new(0.5,0,0,16); sl.BackgroundTransparent = true; sl.Text = text..": "..def; sl.TextColor3 = Color3.fromRGB(200,200,220); sl.Font = Enum.Font.Gotham; sl.TextSize = 12; sl.TextXAlignment = Enum.TextXAlignment.Left
    local barBg = Instance.new("Frame", s); barBg.Size = UDim2.new(1,0,0,6); barBg.Position = UDim2.new(0,0,1,-10); barBg.BackgroundColor3 = Color3.fromRGB(50,50,65); barBg.BorderSizePixel = 0
    local barFill = Instance.new("Frame", barBg); barFill.Size = UDim2.new((def-minv)/(maxv-minv),0,1,0); barFill.BackgroundColor3 = Color3.fromRGB(200,170,255); barFill.BorderSizePixel = 0
    local val = def
    opts[id] = {get = function() return val end, set = function(v) val=math.clamp(v,minv,maxv); barFill.Size = UDim2.new((val-minv)/(maxv-minv),0,1,0); sl.Text = text..": "..tostring(math.floor(val*10)/10) end}
    local dragging = false
    tb = Instance.new("TextButton", s); tb.Size = UDim2.new(1,0,1,0); tb.BackgroundTransparent = true; tb.Text = ""; tb.BorderSizePixel = 0
    tb.MouseButton1Down:Connect(function() dragging = true end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    R.RenderStepped:Connect(function() if dragging then local mp = UIS:GetMouseLocation(); local abp = barBg.AbsolutePosition; local abs = barBg.AbsoluteSize.X; local pct = (mp.X-abp.X)/abs; opts[id].set(minv + pct*(maxv-minv)); if opts[id].cb then opts[id].cb(val) end end end)
    return opts[id]
end

local function addButton(parent, title, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1,0,0,26); b.BackgroundColor3 = Color3.fromRGB(45,45,58); b.BorderSizePixel = 0; b.Text = title; b.TextColor3 = Color3.fromRGB(200,200,220); b.Font = Enum.Font.Gotham; b.TextSize = 13
    local bs = Instance.new("UIStroke", b); bs.Color = Color3.fromRGB(60,60,75); bs.Thickness = 1
    b.MouseButton1Click:Connect(cb)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(55,55,70) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(45,45,58) end)
    return b
end

local function addInput(parent, id, text, numeric)
    local i = Instance.new("Frame", parent); i.Size = UDim2.new(1,0,0,30); i.BackgroundTransparent = true; i.BorderSizePixel = 0
    local il = Instance.new("TextLabel", i); il.Size = UDim2.new(0,100,0,16); il.BackgroundTransparent = true; il.Text = text; il.TextColor3 = Color3.fromRGB(200,200,220); il.Font = Enum.Font.Gotham; il.TextSize = 12; il.TextXAlignment = Enum.TextXAlignment.Left
    local ibg = Instance.new("Frame", i); ibg.Size = UDim2.new(0,150,0,22); ibg.Position = UDim2.new(1,-155,0.5,-11); ibg.BackgroundColor3 = Color3.fromRGB(40,40,52); ibg.BorderSizePixel = 0
    local ib = Instance.new("TextBox", ibg); ib.Size = UDim2.new(1,-6,1,0); ib.Position = UDim2.new(0,3,0,0); ib.BackgroundTransparent = true; ib.Text = ""; ib.PlaceholderText = text; ib.TextColor3 = Color3.fromRGB(220,220,240); ib.Font = Enum.Font.Gotham; ib.TextSize = 12; ib.ClearTextOnFocus = false
    if numeric then ib.Text = "0" end
    opts[id] = {get = function() return ib.Text end, set = function(v) ib.Text = v end}
    ib.FocusLost:Connect(function(enter) if enter and opts[id].cb then opts[id].cb(ib.Text) end end)
    return opts[id]
end

-- Edge detection
local function isAtEdge(hrp)
    local rp = RaycastParams.new(); rp.FilterDescendantsInstances = { gC() }; rp.FilterType = Enum.RaycastFilterType.Exclude
    local offs = { Vector3.new(2.5,0,0), Vector3.new(-2.5,0,0), Vector3.new(0,0,2.5), Vector3.new(0,0,-2.5), Vector3.new(2,0,2), Vector3.new(-2,0,2), Vector3.new(2,0,-2), Vector3.new(-2,0,-2), Vector3.new(1.5,0,0), Vector3.new(-1.5,0,0), Vector3.new(0,0,1.5), Vector3.new(0,0,-1.5) }
    local hit, miss = 0, 0
    for _, o in ipairs(offs) do local r = workspace:Raycast(hrp.Position + o, Vector3.new(0,-5,0), rp); if r then hit = hit + 1 else miss = miss + 1 end end
    return miss > 0 and hit > 0
end

-- Build Tabs
local function buildUI()
    -- Tab: Main
    local ft, ll, rl = createTab("Main")
    local mm = createGroupbox(ll, "Movement", "l")
    local mc = createGroupbox(rl, "Custom", "r")
    local mo = createGroupbox(ll, "Other", "l")

    -- Air Strafe
    local strafeMult = 120
    addToggle(mm, "AirStrafe", "Air Strafe"):set(false)
    toggles.AirStrafe.cb = function(v)
        dc("AirStrafe")
        if v then
            local last = cam.CFrame.LookVector
            conns.AirStrafe = R.Heartbeat:Connect(function(dt)
                local hrp, hum = gH(), gU(); if not hrp or not hum then return end
                local cur = cam.CFrame.LookVector; local f = Vector3.new(cur.X,0,cur.Z).Unit; local dx,dz = cur.X-last.X,cur.Z-last.Z; local d = math.abs(dx)+math.abs(dz)
                if hum.FloorMaterial == Enum.Material.Air and d > 0.0005 then
                    local vel = hrp.AssemblyLinearVelocity; local hspd = Vector3.new(vel.X,0,vel.Z).Magnitude
                    local boost = f * (hspd + ((strafeMult*d)/dt)*0.01)
                    hrp.AssemblyLinearVelocity = Vector3.new(vel.X+(boost.X*d*8), vel.Y, vel.Z+(boost.Z*d*8))
                end; last = cur
            end)
        end
    end
    addSlider(mm, "StrafeMult", "Multiplier", 120, 10, 300).cb = function(v) strafeMult = v end

    -- Easy Bounce (Edge)
    local bouncePow = 100
    addToggle(mm, "EasyBounce", "Easy Bounce (Edge)").cb = function(v)
        dc("EasyBounce")
        if v then conns.EasyBounce = R.Heartbeat:Connect(function() local hrp,hum=gH(),gU(); if hrp and hum and hum.FloorMaterial~=Enum.Material.Air and isAtEdge(hrp) then hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,bouncePow,hrp.AssemblyLinearVelocity.Z) end end) end
    end
    addSlider(mm, "BouncePow", "Bounce Power", 100, 10, 500).cb = function(v) bouncePow = v end

    -- Virtual Strafe
    local vsMult = 120
    addToggle(mm, "VirtualStrafe", "Virtual Strafe").cb = function(v)
        dc("VirtualStrafe")
        if v then conns.VirtualStrafe = cam:GetPropertyChangedSignal("CFrame"):Connect(function() local hrp=gH(); if hrp then local lk=cam.CFrame.LookVector; hrp.AssemblyLinearVelocity=Vector3.new(lk.X*vsMult, hrp.AssemblyLinearVelocity.Y, lk.Z*vsMult) end end) end
    end
    addSlider(mm, "VSMult", "Strafe Speed", 120, 10, 2000).cb = function(v) vsMult = v end

    -- Auto Trimp
    local trimpP = 80; local minTrimp = 0
    addToggle(mm, "AutoTrimp", "Auto Trimp").cb = function(v)
        dc("AutoTrimp")
        if v then conns.AutoTrimp = R.Heartbeat:Connect(function() local hrp,hum=gH(),gU(); if hrp and hum then local vel=hrp.AssemblyLinearVelocity; local hspd=math.sqrt(vel.X^2+vel.Z^2); if hum.FloorMaterial==Enum.Material.Air and hspd>=minTrimp then hrp.AssemblyLinearVelocity=Vector3.new(vel.X,trimpP,vel.Z) end end end) end
    end
    addSlider(mm, "TrimpP", "Trimp Power", 80, 10, 200).cb = function(v) trimpP = v end
    addSlider(mm, "MinTrimp", "Min Speed", 0, 0, 100).cb = function(v) minTrimp = v end

    -- Non-Moveable Emotes
    addToggle(mm, "EmoteMove", "Non-Moveable Emotes").cb = function(v)
        dc("EmoteMove")
        if v then conns.EmoteMove = R.Heartbeat:Connect(function() local hum=gU(); if hum then local md=hum.MoveDirection; if md.Magnitude>0 then local hrp=gH(); if hrp then hrp.AssemblyLinearVelocity=Vector3.new(md.X*hum.WalkSpeed,hrp.AssemblyLinearVelocity.Y,md.Z*hum.WalkSpeed) end end end end) end
    end

    -- Downed Dash
    local SLIDE_O = { Crouch = true, Slide = true, SlideAir = true, EmotingSlide = true, EmotingSlideAir = true, CarryingSlide = true }; local IGNORE = { Default = true, None = true }
    local function getLV(root) local att = root:FindFirstChild("SlideAttachment") or Instance.new("Attachment", root); att.Name = "SlideAttachment"; local lv = root:FindFirstChild("SlideLinearVelocity") or Instance.new("LinearVelocity", root); lv.Name = "SlideLinearVelocity"; lv.Attachment0 = att; lv.RelativeTo = Enum.ActuatorRelativeTo.World; lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector; lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis; lv.MaxAxesForce = Vector3.new(100000,0,100000); return lv end
    addToggle(mm, "DownedDash", "Downed Dash").cb = function(v)
        dc("DownedDash")
        if v then
            local grp = RaycastParams.new(); grp.FilterType = Enum.RaycastFilterType.Exclude; local sh = {"None","None","None","None","None"}; local wasSliding, slidAct, curSpd = false, false, 0; local dTime, boostDone = 0, false; local lYaw, mDir = 0, Vector3.new(0,0,0)
            conns.DownedDash = R.Heartbeat:Connect(function(dt)
                local char, root, hum = gC(), gH(), gU(); if not char or not root or not hum then return end; local lv = getLV(root); grp.FilterDescendantsInstances = { char }
                local st = char:GetAttribute("State") or "None"
                if sh[1] ~= st then table.insert(sh, 1, st); if #sh > 6 then table.remove(sh) end; if st == "Downed" then local f = false; for i = 2, #sh do local hs = sh[i]; if SLIDE_O[hs] then f = true; break elseif not IGNORE[hs] then break end end; if f then slidAct = true end elseif not SLIDE_O[st] then slidAct = false end end
                if st == "Downed" and slidAct then
                    lv.Enabled = true
                    if not wasSliding then curSpd = Vector3.new(root.AssemblyLinearVelocity.X,0,root.AssemblyLinearVelocity.Z).Magnitude; dTime = os.clock(); boostDone = false; wasSliding = true end
                    if not boostDone and os.clock()-dTime >= 0.1 then curSpd = math.max(curSpd, 50); boostDone = true end
                    local onGround = hum.FloorMaterial ~= Enum.Material.Air; local gRay = workspace:Raycast(root.Position, Vector3.new(0,-5,0), grp)
                    local cf = cam.CFrame.LookVector; local camF = Vector3.new(cf.X,0,cf.Z).Unit; local _, yaw, _ = cam.CFrame:ToEulerAnglesYXZ(); local yd = yaw - lYaw
                    if yd > math.pi then yd = yd - math.pi*2 end; if yd < -math.pi then yd = yd + math.pi*2 end; lYaw = yaw; local canStr = false; local inp = hum.MoveDirection
                    if inp.Magnitude > 0.1 then local rel = cam.CFrame:VectorToObjectSpace(inp); if (rel.X < -0.1 and yd > 0.001) or (rel.X > 0.1 and yd < -0.001) then mDir = camF; canStr = true end end
                    if mDir.Magnitude < 0.1 then mDir = camF end
                    if canStr then curSpd = curSpd + dt elseif onGround then local slope = false; if gRay and gRay.Instance and gRay.Normal.Y < 0.98 and mDir.Unit:Dot(gRay.Normal) < -0.05 then slope = true; if curSpd < 55.5 then curSpd = math.min(curSpd+10*dt, 55.5) end end; if not slope and curSpd <= 55.5 then curSpd = math.max(20, curSpd-3*dt) end end
                    if onGround and curSpd > 55.5 then curSpd = math.max(55.5, curSpd-20*dt) end
                    if curSpd > 0.5 then lv.VectorVelocity = (mDir.Unit*curSpd) else curSpd = 0; lv.VectorVelocity = Vector3.new(0,0,0) end
                    char:SetAttribute("RelativeSpeed", curSpd)
                else lv.Enabled = false; lv.VectorVelocity = Vector3.new(0,0,0); curSpd = 0; wasSliding = false; boostDone = false; mDir = Vector3.new(0,0,0); local _, yaw, _ = cam.CFrame:ToEulerAnglesYXZ(); lYaw = yaw end
            end)
        else local root = gH(); if root then local lv = root:FindFirstChild("SlideLinearVelocity"); if lv then lv.Enabled = false; lv.VectorVelocity = Vector3.new(0,0,0) end end
        end
    end

    -- Easy Hop
    local hbX,hbY,hbZ = 6,3,6; local FOLDER = "AABB_Wireframe_Folder"; local hitboxFolder = nil
    local function getHighest(obj) local h, my = nil, -math.huge; local function ck(p) if p:IsA("BasePart") then local t = p.Position.Y + p.Size.Y/2; if t > my then my = t; h = p end end end; ck(obj); for _, d in pairs(obj:GetDescendants()) do ck(d) end; return h end
    local function calcAABB(tgt)
        local mix, miy, miz = math.huge, math.huge, math.huge; local mxx, mxy, mxz = -math.huge, -math.huge, -math.huge; local parts = {}; if tgt:IsA("BasePart") then table.insert(parts, tgt) end; for _, d in pairs(tgt:GetDescendants()) do if d:IsA("BasePart") then table.insert(parts, d) end end; if #parts == 0 then return nil end
        for _, p in ipairs(parts) do local cf, s = p.CFrame, p.Size/2; for _, c in ipairs({cf*Vector3.new(s.X,s.Y,s.Z),cf*Vector3.new(-s.X,s.Y,s.Z),cf*Vector3.new(s.X,-s.Y,s.Z),cf*Vector3.new(-s.X,-s.Y,s.Z),cf*Vector3.new(s.X,s.Y,-s.Z),cf*Vector3.new(-s.X,s.Y,-s.Z),cf*Vector3.new(s.X,-s.Y,-s.Z),cf*Vector3.new(-s.X,-s.Y,-s.Z)}) do mix=math.min(mix,c.X);miy=math.min(miy,c.Y);miz=math.min(miz,c.Z);mxx=math.max(mxx,c.X);mxy=math.max(mxy,c.Y);mxz=math.max(mxz,c.Z) end end
        return Vector3.new((mxx+mix)/2,(mxy+miy)/2,(mxz+miz)/2), Vector3.new(mxx-mix, mxy-miy, mxz-miz)
    end
    addToggle(mc, "EasyHop", "Easy Hop").cb = function(v)
        if hitboxFolder then hitboxFolder:Destroy(); hitboxFolder = nil end
        if v then
            hitboxFolder = Instance.new("Folder"); hitboxFolder.Name = FOLDER; hitboxFolder.Parent = workspace; local cnt = 0
            pcall(function() local gf = workspace:FindFirstChild("Game"); if gf then local m = gf:FindFirstChild("Map"); local p = m and m:FindFirstChild("Parts"); local pr = p and p:FindFirstChild("ImmovableProps"); if pr then for _, o in pairs(pr:GetChildren()) do if o.Name:find("Cactus") or o.Name:find("Fence") or o.Name:find("Wall") then local t = getHighest(o); if t then local c, s = calcAABB(t); if c and s then local bx = Instance.new("Part"); bx.Size = s + Vector3.new(hbX, hbY, hbZ); bx.Position = c; bx.Anchored = true; bx.CanCollide = true; bx.Transparency = 1; bx.Parent = hitboxFolder; cnt = cnt + 1 end end end end end end end)
            notify("Easy Hop: "..cnt.." objects expanded", 3)
        end
    end
    addSlider(mc, "HbX", "Expand X", 6, 0, 15).cb = function(v) hbX = v end
    addSlider(mc, "HbY", "Expand Y", 3, 0, 15).cb = function(v) hbY = v end
    addSlider(mc, "HbZ", "Expand Z", 6, 0, 15).cb = function(v) hbZ = v end

    -- Edge Boost
    _G.EdgeBoostLoaded = false; _G.EdgeBoostConnection = nil; _G.EdgeBoostInput = nil; _G.EdgeBoostEnabled = true
    addButton(mc, "Easy Edge Boost (U toggle)", function()
        if _G.EdgeBoostLoaded then if _G.EdgeBoostConnection then _G.EdgeBoostConnection:Disconnect() end; if _G.EdgeBoostInput then _G.EdgeBoostInput:Disconnect() end; _G.EdgeBoostLoaded = false; notify("Edge Boost disabled", 2); return end
        _G.EdgeBoostLoaded = true; _G.EdgeBoostEnabled = true; local BP = 100; local function gch() local c = plr.Character or plr.CharacterAdded:Wait(); local hrp = c:WaitForChild("HumanoidRootPart"); local h = c:WaitForChild("Humanoid"); return c, hrp, h end; local ch, hrp, hum = gch()
        local function isBP(p) local kws = {"bounce","boost","launch","jump","pad","ramp","platform"}; local n = string.lower(p.Name); for _, kw in pairs(kws) do if n:find(kw) then return true end end; if p.Parent and (p.Parent:IsA("Model") or p.Parent:IsA("Folder")) then local pn = string.lower(p.Parent.Name); for _, kw in pairs(kws) do if pn:find(kw) then return true end end end; return false end
        _G.EdgeBoostConnection = R.Stepped:Connect(function() if not _G.EdgeBoostEnabled or not hrp or not hum or hum.Health <= 0 then return end; if hrp.AssemblyLinearVelocity.Y < -1 then local pts = hrp:GetTouchingParts(); local edge, bnc = false, false; if #pts > 0 then for _, p in pairs(pts) do if isBP(p) then bnc = true; break end end; if not bnc then edge = true end end; if edge then hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z) + Vector3.new(0,BP,0) end end end)
        _G.EdgeBoostInput = UIS.InputBegan:Connect(function(inp, gp) if gp then return end; if inp.KeyCode == Enum.KeyCode.U then _G.EdgeBoostEnabled = not _G.EdgeBoostEnabled; if _G.EdgeBoostEnabled then ch, hrp, hum = gch(); notify("Edge Boost enabled", 3) else notify("Edge Boost disabled", 3) end end end)
        notify("Edge Boost enabled! (U toggle)", 3)
    end)

    -- Remove Walls
    local disabledWalls = {}
    addButton(mo, "Remove Invisible Walls", function()
        local r = 0; local ch = gC()
        for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Transparency == 1 and o.CanCollide then if not (ch and o:IsDescendantOf(ch)) then o.CanCollide = false; table.insert(disabledWalls, o); r = r + 1 end end end
        notify("Removed "..r.." wall(s)", 4)
    end)
    addButton(mo, "Restore Walls", function()
        local r = 0; for _, p in ipairs(disabledWalls) do if p and p.Parent then p.CanCollide = true; r = r + 1 end end; disabledWalls = {}; notify("Restored "..r.." wall(s)", 4)
    end)

    -- Evade Speed
    local evSpd = 1500
    addSlider(mo, "EvadeSpd", "Evade Speed Override", 1500, 100, 5000).cb = function(v) evSpd = v end
    addButton(mo, "Apply Evade Speed", function() _G.RealSpeedOverride = evSpd; notify("Speed set to "..evSpd, 3) end)

    -- Tab: Player
    local ft2, ll2, rl2 = createTab("Player")
    local pm = createGroupbox(ll2, "Movement", "l")
    local pc = createGroupbox(rl2, "Camera", "r")
    local pl = createGroupbox(ll2, "Lag Switch", "l")

    local walkSpd = 16
    addToggle(pm, "WalkSpeed", "Walk Speed").cb = function(v)
        dc("WalkSpeed")
        if v then conns.WalkSpeed = R.Heartbeat:Connect(function() local h=gU(); if h then h.WalkSpeed=walkSpd end end) else local h=gU(); if h then h.WalkSpeed=16 end end
    end
    addSlider(pm, "WalkSpd", "Speed", 16, 16, 150).cb = function(v) walkSpd = v end

    local jumpPow = 50
    addToggle(pm, "JumpPower", "Jump Power").cb = function(v)
        dc("JumpPower")
        if v then conns.JumpPower = R.Heartbeat:Connect(function() local h=gU(); if h then h.JumpPower=jumpPow end end) else local h=gU(); if h then h.JumpPower=50 end end
    end
    addSlider(pm, "JumpPow", "Power", 50, 10, 300).cb = function(v) jumpPow = v end

    local sprintSpd = 32
    addToggle(pm, "Sprint", "Sprint (Shift)").cb = function(v)
        dc("Sprint")
        if v then conns.Sprint = R.Heartbeat:Connect(function() local h=gU(); if h then if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then h.WalkSpeed=sprintSpd elseif not toggles.WalkSpeed.get() then h.WalkSpeed=16 end end end) end
    end
    addSlider(pm, "SprintSpd", "Sprint Speed", 32, 20, 200).cb = function(v) sprintSpd = v end

    addToggle(pc, "NoShake", "Disable Cam Shake").cb = function(v)
        dc("NoShake")
        if v then conns.NoShake = R.RenderStepped:Connect(function() local c=workspace.CurrentCamera; c.CFrame=CFrame.lookAt(c.CFrame.Position,c.CFrame.Position+c.CFrame.LookVector,Vector3.new(0,1,0)) end) end
    end

    addToggle(pc, "FullBright", "Full Bright").cb = function(v)
        if v then L.Brightness=3; L.Ambient=Color3.fromRGB(255,255,255); L.OutdoorAmbient=Color3.fromRGB(255,255,255); L.GlobalShadows=false else L.Brightness=1; L.Ambient=Color3.fromRGB(200,200,200); L.OutdoorAmbient=Color3.fromRGB(200,200,200); L.GlobalShadows=true end
    end

    local ofe, ofs = nil, nil
    addToggle(pc, "NoFog", "Remove Fog").cb = function(v)
        if v then ofe=L.FogEnd; ofs=L.FogStart; L.FogEnd=100000; L.FogStart=99999 else L.FogEnd=ofe or 100000; L.FogStart=ofs or 0 end
    end

    local curFOV = 70
    addSlider(pc, "FOV", "FOV Lock", 70, 40, 120).cb = function(v) curFOV = v; dc("FOV"); conns.FOV = R.RenderStepped:Connect(function() local c=workspace.CurrentCamera; if c.FieldOfView~=curFOV then c.FieldOfView=curFOV end end) end

    -- Lag Switch
    local lagDur = 0.9; local lagCD = 0
    addButton(pl, "LAG SWITCH", function()
        if lagCD > 0 then notify("Cooldown!", 2); return end; lagCD = 2; local s = tick(); notify("Lagging for "..lagDur.."s", 1)
        local c; c = R.Heartbeat:Connect(function() if tick()-s >= lagDur then c:Disconnect(); notify("Released!", 2) end end)
    end)
    addSlider(pl, "LagDur", "Duration (sec)", 0.9, 0.1, 3).cb = function(v) lagDur = v end
    R.Heartbeat:Connect(function(dt) if lagCD > 0 then lagCD = lagCD - dt end end)

    -- Tab: Visuals
    local ft3, ll3, rl3 = createTab("Visuals")
    local vw = createGroupbox(ll3, "World", "l")
    local vc = createGroupbox(rl3, "Cosmetics", "r")

    addToggle(vw, "PlayerESP", "Player ESP").cb = function(v)
        if _G.espFolder then _G.espFolder:Destroy(); _G.espFolder = nil end
        if v then
            _G.espFolder = Instance.new("Folder"); _G.espFolder.Name = "PlayerESP"; _G.espFolder.Parent = workspace
            for _, p in pairs(P:GetPlayers()) do if p ~= plr and p.Character then local h = Instance.new("Highlight"); h.FillColor = Color3.fromRGB(0,255,0); h.OutlineColor = Color3.fromRGB(0,255,0); h.FillTransparency = 0.3; h.OutlineTransparency = 0; h.Adornee = p.Character; h.Parent = _G.espFolder end end
        end
    end

    addToggle(vw, "RGB", "RGB Mode").cb = function(v)
        dc("RGB")
        if v then
            local rg = Instance.new("ScreenGui"); rg.Name = "RGBMode"; rg.ResetOnSpawn = false; rg.Parent = pg
            local rf = Instance.new("Frame", rg); rf.Size = UDim2.new(1,0,1,0); rf.BackgroundTransparency = 0.92; rf.BorderSizePixel = 0; local t = 0
            conns.RGB = R.RenderStepped:Connect(function(dt) t = t + dt*0.5; rf.BackgroundColor3 = Color3.fromHSV(t%1,1,1) end); _G.RGBGui = rg
        else if _G.RGBGui then _G.RGBGui:Destroy(); _G.RGBGui = nil end end
    end

    -- Emote Swap
    local e1,e2,oe1,oe2,eSwapped = "","","","",false
    local function norm(s) return s:gsub("%s+",""):lower() end
    local function lev(s,t) local m,n=#s,#t;local d={};for i=0,m do d[i]={[0]=i} end;for j=0,n do d[0][j]=j end;for i=1,m do for j=1,n do local c=(s:sub(i,i)==t:sub(j,j)) and 0 or 1;d[i][j]=math.min(d[i-1][j]+1,d[i][j-1]+1,d[i-1][j-1]+c) end end;return d[m][n] end
    local function sim(s,t) local nS,nT=norm(s),norm(t);return 1-(lev(nS,nT)/math.max(#nS,#nT)) end
    local function findBest(name) local em=RS:FindFirstChild("Items"); if not em then return name end; em=em:FindFirstChild("Emotes"); if not em then return name end; local b,bs=name,0.5; for _,c in ipairs(em:GetChildren()) do local s=sim(name,c.Name); if s>bs then bs=s;b=c.Name end end; return b end
    local function findBestU(name) local it=RS:FindFirstChild("Items"); if not it then return name end; local un=it:FindFirstChild("Unusual"); if not un then return name end; local b,bs=name,0.5; for _,c in ipairs(un:GetChildren()) do local s=sim(name,c.Name); if s>bs then bs=s;b=c.Name end end; return b end
    local function findBestC(name) local it=RS:FindFirstChild("Items"); if not it then return name end; local co=it:FindFirstChild("Cosmetics"); if not co then return name end; local b,bs=name,0.5; for _,c in ipairs(co:GetChildren()) do local s=sim(name,c.Name); if s>bs then bs=s;b=c.Name end end; return b end

    addInput(vc, "Emote1", "Current Emote", false).cb = function(v) e1 = v; if not eSwapped then oe1 = v end end
    addInput(vc, "Emote2", "Target Emote", false).cb = function(v) e2 = v; if not eSwapped then oe2 = v end end
    addButton(vc, "Apply Emote Swap", function()
        pcall(function() if e1=="" or e2=="" or e1==e2 then notify("Enter two different emotes!",3); return end; local em=RS:WaitForChild("Items"):WaitForChild("Emotes"); local aN=findBest(e1); local bN=findBest(e2); local a,b=em:FindFirstChild(aN),em:FindFirstChild(bN); if not a or not b then notify("Emotes not found!",3); return end; if not eSwapped then oe1=aN;oe2=bN end; local tr=Instance.new("Folder",em); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy(); eSwapped=true; notify("Swapped '"..aN.."' with '"..bN.."'",3) end)
    end)
    addButton(vc, "Reset Emote Swap", function()
        pcall(function() if not eSwapped then notify("No emotes swapped!",3); return end; local em=RS:WaitForChild("Items"):WaitForChild("Emotes"); local a,b=em:FindFirstChild(e1),em:FindFirstChild(e2); if a and b then local tr=Instance.new("Folder",em); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy() end; eSwapped=false; notify("Reset to original",3) end)
    end)

    -- Unusual Swap
    addInput(vc, "Unusual1", "Current Unusual", false).cb = function(v) if not uSwapped then uo1=v end; u1=v end
    addInput(vc, "Unusual2", "Target Unusual", false).cb = function(v) if not uSwapped then uo2=v end; u2=v end
    local u1,u2,uo1,uo2,uSwapped = "","","","",false
    addButton(vc, "Apply Unusual Swap", function()
        pcall(function() if u1=="" or u2=="" or u1==u2 then notify("Enter two different items!",3); return end; local un=RS:WaitForChild("Items"):WaitForChild("Unusual"); local aN,bN=findBestU(u1),findBestU(u2); local a,b=un:FindFirstChild(aN),un:FindFirstChild(bN); if not a or not b then notify("Items not found!",3); return end; if not uSwapped then uo1=aN;uo2=bN end; local tr=Instance.new("Folder",un); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy(); uSwapped=true; notify("Swapped '"..aN.."' with '"..bN.."'",3) end)
    end)
    addButton(vc, "Reset Unusual Swap", function()
        pcall(function() if not uSwapped then notify("No items swapped!",3); return end; local un=RS:WaitForChild("Items"):WaitForChild("Unusual"); local a,b=un:FindFirstChild(u1),un:FindFirstChild(u2); if a and b then local tr=Instance.new("Folder",un); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy() end; uSwapped=false; notify("Reset to original",3) end)
    end)

    -- Cosmetic Swap
    local co1,co2,coo1,coo2,coSwapped = "","","","",false
    addInput(vc, "Cosmetic1", "Current Cosmetic", false).cb = function(v) co1=v; if not coSwapped then coo1=v end end
    addInput(vc, "Cosmetic2", "Target Cosmetic", false).cb = function(v) co2=v; if not coSwapped then coo2=v end end
    addButton(vc, "Apply Cosmetic Swap", function()
        pcall(function() if co1=="" or co2=="" or co1==co2 then notify("Enter two different cosmetics!",3); return end; local co=RS:WaitForChild("Items"):WaitForChild("Cosmetics"); local aN,bN=findBestC(co1),findBestC(co2); local a,b=co:FindFirstChild(aN),co:FindFirstChild(bN); if not a or not b then notify("Cosmetics not found!",3); return end; if not coSwapped then coo1=aN;coo2=bN end; local tr=Instance.new("Folder",co); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy(); coSwapped=true; notify("Swapped '"..aN.."' with '"..bN.."'",3) end)
    end)
    addButton(vc, "Reset Cosmetic Swap", function()
        pcall(function() if not coSwapped then notify("No cosmetics swapped!",3); return end; local co=RS:WaitForChild("Items"):WaitForChild("Cosmetics"); local a,b=co:FindFirstChild(co1),co:FindFirstChild(co2); if a and b then local tr=Instance.new("Folder",co); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy() end; coSwapped=false; notify("Reset to original",3) end)
    end)

    -- Headless / Korblox
    addButton(vc, "Headless (Local)", function() pcall(function() local ch=gC(); if not ch then return end; local h=ch:FindFirstChild("Head"); if h then h.Transparency=1 end; local f=h and h:FindFirstChild("face"); if f then f.Transparency=1 end; for _,o in pairs(ch:GetDescendants()) do if (o.Name:lower():find("hair") or o.Name:lower():find("hat")) and o:IsA("BasePart") then o.Transparency=1 end end; notify("Headless applied",3) end) end)
    addButton(vc, "Toggle Korblox Leg", function()
        pcall(function() if _G.KorbloxEnabled == nil then _G.KorbloxEnabled = false end; _G.KorbloxConnections = _G.KorbloxConnections or {}; _G.KorbloxEnabled = not _G.KorbloxEnabled; for _, c in ipairs(_G.KorbloxConnections) do if c.Connected then c:Disconnect() end end; table.clear(_G.KorbloxConnections); if not _G.KorbloxEnabled then notify("Korblox disabled",3); return end; notify("Korblox enabled",3)
            local KM = "rbxassetid://101851696"; local KT = "rbxassetid://101851254"; local KC = Color3.fromRGB(38,65,68)
            local function apply(ch) if not ch or not _G.KorbloxEnabled then return end; local rL = ch:WaitForChild("Right Leg",5); if rL and _G.KorbloxEnabled then for _,v in ipairs(ch:GetChildren()) do if v:IsA("CharacterMesh") and v.BodyPart == Enum.BodyPart.RightLeg then v:Destroy() end end; local ms = rL:FindFirstChildOfClass("SpecialMesh"); if not ms then ms = Instance.new("SpecialMesh",rL); ms.Name = "KorbloxMesh" end; ms.MeshId = KM; ms.TextureId = KT; ms.Scale = Vector3.new(1,1,1); rL.Color = KC; rL.Transparency = 0; rL.Material = Enum.Material.Plastic; spawn(function() while ch and ch.Parent and _G.KorbloxEnabled do if rL.Color ~= KC then rL.Color = KC end; task.wait(1) end end) end end
            local function setup(p) if p.Character then spawn(apply,p.Character) end; table.insert(_G.KorbloxConnections, p.CharacterAdded:Connect(function(c) task.wait(0.5); apply(c) end)) end; for _,p in pairs(P:GetPlayers()) do setup(p) end; table.insert(_G.KorbloxConnections, P.PlayerAdded:Connect(setup))
        end) end)

    -- Tab: Fun
    local ft4, ll4, rl4 = createTab("Fun")
    local fs = createGroupbox(ll4, "Legacy Speed", "l")
    local fj = createGroupbox(rl4, "Legacy Jump", "r")
    local fa = createGroupbox(ll4, "Animations & Physics", "l")

    local legSpd = 50
    addToggle(fs, "LegacySpeed", "Old Speed System").cb = function(v)
        dc("LegacySpeed")
        if v then conns.LegacySpeed = R.Heartbeat:Connect(function() local hrp=gH(); if hrp then local bv=hrp:FindFirstChild("LegacyBV"); if not bv then bv=Instance.new("BodyVelocity"); bv.Name="LegacyBV"; bv.MaxForce=Vector3.new(100000,0,100000); bv.Parent=hrp end; local lk=cam.CFrame.LookVector; local d=Vector3.new(lk.X,0,lk.Z).Unit; if UIS:IsKeyDown(Enum.KeyCode.W) then bv.Velocity=d*legSpd elseif UIS:IsKeyDown(Enum.KeyCode.S) then bv.Velocity=-d*legSpd else bv.Velocity=Vector3.new(0,0,0) end end end) else local hrp=gH(); if hrp then local bv=hrp:FindFirstChild("LegacyBV"); if bv then bv:Destroy() end end end
    end
    addSlider(fs, "LegSpd", "Speed", 50, 10, 500).cb = function(v) legSpd = v end

    local legJP = 80
    addToggle(fj, "LegacyJump", "Old Jump System").cb = function(v)
        dc("LegacyJump")
        if v then conns.LegacyJump = UIS.InputBegan:Connect(function(inp,gp) if gp then return end; if inp.KeyCode==Enum.KeyCode.Space then local hrp=gH(); if hrp then local bf=Instance.new("BodyVelocity"); bf.Velocity=Vector3.new(hrp.AssemblyLinearVelocity.X,legJP,hrp.AssemblyLinearVelocity.Z); bf.MaxForce=Vector3.new(0,1000000,0); bf.Parent=hrp; D:AddItem(bf,0.1) end end end) end
    end
    addSlider(fj, "LegJP", "Power", 80, 20, 500).cb = function(v) legJP = v end

    addButton(fa, "Play Old Run Animation", function() pcall(function() local h=gU(); if h then local a=Instance.new("Animation"); a.AnimationId="rbxassetid://180426354"; h:LoadAnimation(a):Play() end end) end)
    addButton(fa, "Play Old Idle Animation", function() pcall(function() local h=gU(); if h then local a=Instance.new("Animation"); a.AnimationId="rbxassetid://180435571"; h:LoadAnimation(a):Play() end end) end)

    addToggle(fa, "LegacyNoClip", "Legacy No-Clip").cb = function(v)
        dc("LegacyNoClip")
        if v then conns.LegacyNoClip = R.Stepped:Connect(function() local ch=gC(); if ch then for _,p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end) else local ch=gC(); if ch then for _,p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end
    end

    -- Tab: Misc
    local ft5, ll5, rl5 = createTab("Misc")
    local mcf = createGroupbox(ll5, "Config", "l")
    local minf = createGroupbox(rl5, "Info", "r")
    local mch = createGroupbox(ll5, "Character", "l")

    local CONFIG_PATH = "HENQWare/config.json"; local _cfg = {}
    addButton(mcf, "Save Config", function() pcall(function() if not isfolder("HENQWare") then makefolder("HENQWare") end; writefile(CONFIG_PATH, game:GetService("HttpService"):JSONEncode(_cfg)); notify("Saved!",2) end) end)
    addButton(mcf, "Load Config", function() pcall(function() if isfile(CONFIG_PATH) then _cfg=game:GetService("HttpService"):JSONDecode(readfile(CONFIG_PATH)); notify("Loaded!",2) else notify("No config found!",2) end end) end)
    addButton(mcf, "Clear Config", function() _cfg={}; pcall(function() if isfile(CONFIG_PATH) then delfile(CONFIG_PATH) end end); notify("Cleared!",2) end)

    addButton(minf, "Game Info", function() notify("Game: "..game.Name.." | ID: "..game.PlaceId.." | Players: "..#P:GetPlayers(),5) end)
    addButton(minf, "Player Stats", function() local h,hrp=gU(),gH(); if not h or not hrp then notify("No character!",2); return end; local v=hrp.AssemblyLinearVelocity; local spd=math.floor(math.sqrt(v.X^2+v.Z^2)); notify("HP: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth).." | SPD: "..spd,5) end)
    addButton(minf, "Player Count", function() notify("Players: "..#P:GetPlayers(),3) end)

    addButton(mch, "Remove Walls", function() local r=0;local ch=gC();for _,o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Transparency==1 and o.CanCollide then if not(ch and o:IsDescendantOf(ch)) then o.CanCollide=false;table.insert(disabledWalls,o);r=r+1 end end end;notify("Removed "..r.." wall(s)",4) end)
    addButton(mch, "Restore Walls", function() local r=0;for _,p in ipairs(disabledWalls) do if p and p.Parent then p.CanCollide=true;r=r+1 end end;notify("Restored "..r.." wall(s)",4) end)
    addButton(mch, "Reset Character", function() local h=gU(); if h then h.Health=0 end end)
    addButton(mch, "Rejoin Server", function() notify("Rejoining...",2); task.delay(1,function() game:GetService("TeleportService"):Teleport(game.PlaceId,plr) end) end)

    -- Tab: Utility
    local ft6, ll6, rl6 = createTab("Utility")
    local ub = createGroupbox(ll6, "Boosts", "l")
    local ut = createGroupbox(rl6, "Teleport", "r")
    local uo = createGroupbox(ll6, "Objectives", "l")

    addToggle(ub, "Cola", "Unlimited Cola").cb = function(v)
        dc("Cola")
        if v then conns.Cola = R.Heartbeat:Connect(function() local hrp=gH(); if hrp then for _,o in pairs(workspace:GetDescendants()) do local n=o.Name:lower(); if (n:find("cola") or n:find("drink") or n:find("soda")) and o:IsA("BasePart") and (o.Position-hrp.Position).Magnitude<20 then pcall(function() local t=o.Touched; if t then t:Fire(hrp) end end); pcall(function() local cd=o:FindFirstChildOfClass("ClickDetector"); if cd then fireclickdetector(cd) end end) end end end) end
    end

    local sbVal = 60
    addToggle(ub, "SpeedBoost", "Speed Booster").cb = function(v)
        dc("SpeedBoost")
        if v then conns.SpeedBoost = R.Heartbeat:Connect(function() local h=gU(); if h then h.WalkSpeed=sbVal end end) else local h=gU(); if h then h.WalkSpeed=16 end end
    end
    addSlider(ub, "SBVal", "Boost Speed", 60, 16, 300).cb = function(v) sbVal = v end

    addButton(ut, "Teleport Spawn", function() local hrp=gH(); if hrp then hrp.CFrame=CFrame.new(0,10,0) end end)
    local tx,ty,tz,tpName = 0,10,0,""
    addInput(ut, "TPX", "X", true).cb = function(v) tx=tonumber(v) or 0 end
    addInput(ut, "TPY", "Y", true).cb = function(v) ty=tonumber(v) or 10 end
    addInput(ut, "TPZ", "Z", true).cb = function(v) tz=tonumber(v) or 0 end
    addButton(ut, "TP to Coords", function() local hrp=gH(); if hrp then hrp.CFrame=CFrame.new(tx,ty,tz); notify("Teleported!",2) end end)
    addInput(ut, "TPPlayer", "Player Name", false).cb = function(v) tpName = v end
    addButton(ut, "TP to Player", function() local hrp=gH(); if not hrp then return end; for _,p in pairs(P:GetPlayers()) do if fm(p.Name,tpName) or fm(p.DisplayName,tpName) then if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then hrp.CFrame=p.Character.HumanoidRootPart.CFrame*CFrame.new(3,0,3); notify("TP to "..p.Name,2); return end end end; notify("Not found!",2) end)
    addButton(ut, "TP to Downed", function() local hrp=gH(); if not hrp then return end; for _,p in pairs(P:GetPlayers()) do if p~=plr and p.Character then local h,phrp=p.Character:FindFirstChildOfClass("Humanoid"),p.Character:FindFirstChild("HumanoidRootPart"); if h and phrp and h.Health>0 and h.Health<h.MaxHealth*0.25 then hrp.CFrame=phrp.CFrame*CFrame.new(3,0,3); notify("TP to "..p.Name,3); return end end end; notify("No downed players!",2) end)
    addButton(ut, "TP to Nearest Ticket", function() local hrp=gH(); if not hrp then return end; local c,cd=nil,math.huge; local kws={"ticket","coin","gem","star","badge","token","collectible","pickup","reward"}; for _,o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") or o:IsA("Model") then local n=o.Name:lower(); for _,kw in ipairs(kws) do if n:find(kw) then local pos=(o:IsA("Model") and o:GetBoundingBox()) or o.Position; if pos then local d=(pos-hrp.Position).Magnitude; if d<cd then cd=d;c=o end end; break end end end end; if c then local pos=(c:IsA("Model") and (c:GetBoundingBox()+Vector3.new(0,3,0))) or (c.Position+Vector3.new(0,3,0)); hrp.CFrame=CFrame.new(pos); notify("TP to "..c.Name,3) else notify("None found!",2) end end)
    addButton(ut, "TP to Nearest Nextbot", function() local hrp=gH(); if not hrp then return end; local c,cd=nil,math.huge; local kws={"nextbot","npc","bot","enemy","zombie","monster","chaser","entity"}; for _,o in pairs(workspace:GetDescendants()) do local n=o.Name:lower(); for _,kw in ipairs(kws) do if n:find(kw) then local p=(o:IsA("BasePart") and o) or (o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildOfClass("BasePart"))); if p then local d=(p.Position-hrp.Position).Magnitude; if d<cd then cd=d;c=p end end; break end end end; if c then hrp.CFrame=CFrame.new(c.Position+Vector3.new(5,3,0)); notify("TP to "..c.Name,3) else notify("None found!",2) end end)

    addButton(uo, "Find Objectives", function() local hrp=gH(); if not hrp then return end; local kws={"objective","goal","target","mission","task","checkpoint","flag","waypoint","marker"}; local f={}; for _,o in pairs(workspace:GetDescendants()) do local n=o.Name:lower(); for _,kw in ipairs(kws) do if n:find(kw) then local pos=(o:IsA("BasePart") and o.Position) or (o:IsA("Model") and o:FindFirstChildOfClass("BasePart") and o:FindFirstChildOfClass("BasePart").Position); if pos then table.insert(f,o.Name.." @"..math.floor((pos-hrp.Position).Magnitude).."m") end; break end end end; if #f>0 then notify(#f.." found (see F9)",5); print("[HENQ] Objectives:"); for _,s in ipairs(f) do print("  "..s) end else notify("None found!",3) end end)
    addButton(uo, "TP to Nearest Objective", function() local hrp=gH(); if not hrp then return end; local kws={"objective","goal","target","mission","task","checkpoint","flag","waypoint","marker"}; local c,cd,cp=nil,math.huge,nil; for _,o in pairs(workspace:GetDescendants()) do local n=o.Name:lower(); for _,kw in ipairs(kws) do if n:find(kw) then local pos=(o:IsA("BasePart") and o.Position) or (o:IsA("Model") and o:FindFirstChildOfClass("BasePart") and o:FindFirstChildOfClass("BasePart").Position); if pos then local d=(pos-hrp.Position).Magnitude; if d<cd then cd=d;c=o;cp=pos end end; break end end end; if c and cp then hrp.CFrame=CFrame.new(cp+Vector3.new(0,5,0)); notify("TP to "..c.Name,3) else notify("None found!",2) end end)

    -- Tab: UI
    local ft7, ll7, rl7 = createTab("UI")
    local ui = createGroupbox(ll7, "UI Settings", "l")

    addButton(ui, "Toggle UI (X / R-Shift)", function() main.Visible = not main.Visible end)

    -- Click first tab
    for k,b in pairs(tabBtns) do b:Fire(); break end
end

pcall(buildUI)

UIS.InputBegan:Connect(function(inp,gp) if gp then return end; if inp.KeyCode==Enum.KeyCode.X or inp.KeyCode==Enum.KeyCode.RightShift then main.Visible=not main.Visible end end)

plr.CharacterAdded:Connect(function() task.wait(1); if toggles.WalkSpeed and toggles.WalkSpeed.get() then local h=gU(); if h then h.WalkSpeed=walkSpd end end; if toggles.JumpPower and toggles.JumpPower.get() then local h=gU(); if h then h.JumpPower=jumpPow end end end)

notify("HENQ Ware loaded! X / R-Shift to toggle", 5)
