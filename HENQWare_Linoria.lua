-- HENQ Ware [Linoria UI]
local LinoriaLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local RunService = game:GetService("RunService"); local UIS = game:GetService("UserInputService"); local Players = game:GetService("Players"); local Lighting = game:GetService("Lighting"); local ReplicatedStorage = game:GetService("ReplicatedStorage"); local Debris = game:GetService("Debris")
local player = Players.LocalPlayer; local playerGui = player:WaitForChild("PlayerGui"); local camera = workspace.CurrentCamera
local function getChar() return player.Character end; local function getHRP() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end; local function getHum() local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function fuzzyMatch(str, p) str = str:lower(); p = p:lower(); if str:find(p, 1, true) then return true end; local si = 1; for i = 1, #p do local ch = p:sub(i, i); local found = false; while si <= #str do if str:sub(si, si) == ch then found = true; si = si + 1; break end; si = si + 1 end; if not found then return false end end; return true end
local Window = LinoriaLib:CreateWindow({ Title = "HENQ Ware", Center = true, AutoShow = true, TabPadding = 8, MenuFadeTime = 0.2 })
local Tabs = {}; local Toggles = {}; local Options = {}

-- TAB MAIN
Tabs.Main = Window:AddTab("Main"); local LeftMain = Tabs.Main:AddLeftGroupbox("Movement"); local RightMain = Tabs.Main:AddRightGroupbox("Custom"); local OtherMain = Tabs.Main:AddLeftGroupbox("Other")
-- TAB PLAYER
Tabs.Player = Window:AddTab("Player"); local LeftPlayer = Tabs.Player:AddLeftGroupbox("Movement"); local RightPlayer = Tabs.Player:AddRightGroupbox("Camera"); local LagBox = Tabs.Player:AddLeftGroupbox("Lag Switch")
-- TAB VISUALS
Tabs.Visuals = Window:AddTab("Visuals"); local VisWorld = Tabs.Visuals:AddLeftGroupbox("World"); local VisCosmetic = Tabs.Visuals:AddRightGroupbox("Cosmetics")
-- TAB FUN
Tabs.Fun = Window:AddTab("Fun"); local FunSpeed = Tabs.Fun:AddLeftGroupbox("Legacy Speed"); local FunJump = Tabs.Fun:AddRightGroupbox("Legacy Jump"); local FunAnim = Tabs.Fun:AddLeftGroupbox("Animations & Physics")
-- TAB MISC
Tabs.Misc = Window:AddTab("Misc"); local MiscConf = Tabs.Misc:AddLeftGroupbox("Config"); local MiscInfo = Tabs.Misc:AddRightGroupbox("Info"); local MiscChar = Tabs.Misc:AddLeftGroupbox("Character")
-- TAB UTILITY
Tabs.Utility = Window:AddTab("Utility"); local UtilBoost = Tabs.Utility:AddLeftGroupbox("Boosts"); local UtilTP = Tabs.Utility:AddRightGroupbox("Teleport"); local UtilObj = Tabs.Utility:AddLeftGroupbox("Objectives")
-- TAB UI
Tabs.UI = Window:AddTab("UI"); local UISet = Tabs.UI:AddLeftGroupbox("UI Settings")

-- Connection storage
local conns = {}
local function dc(name) if conns[name] then conns[name]:Disconnect(); conns[name] = nil end end

-- Edge detection
local function isAtEdge(hrp)
    local rayParams = RaycastParams.new(); rayParams.FilterDescendantsInstances = { getChar() }; rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local offs = { Vector3.new(2.5,0,0), Vector3.new(-2.5,0,0), Vector3.new(0,0,2.5), Vector3.new(0,0,-2.5), Vector3.new(2,0,2), Vector3.new(-2,0,2), Vector3.new(2,0,-2), Vector3.new(-2,0,-2), Vector3.new(1.5,0,0), Vector3.new(-1.5,0,0), Vector3.new(0,0,1.5), Vector3.new(0,0,-1.5) }
    local hit, miss = 0, 0
    for _, o in ipairs(offs) do local r = workspace:Raycast(hrp.Position + o, Vector3.new(0,-5,0), rayParams); if r then hit = hit + 1 else miss = miss + 1 end end
    return miss > 0 and hit > 0
end

-- === MAIN - MOVEMENT ===
local strafeMult = 120
Toggles.AirStrafe = LeftMain:AddToggle("AirStrafe", { Title = "Air Strafe", Description = "Swing camera in air to gain speed", Default = false })
Toggles.AirStrafe:OnChanged(function(v)
    dc("AirStrafe")
    if v then
        local lastLook = camera.CFrame.LookVector
        conns.AirStrafe = RunService.Heartbeat:Connect(function(dt)
            local hrp, hum = getHRP(), getHum(); if not hrp or not hum then return end
            local cur = camera.CFrame.LookVector; local flat = Vector3.new(cur.X,0,cur.Z).Unit; local dx, dz = cur.X - lastLook.X, cur.Z - lastLook.Z; local delta = math.abs(dx)+math.abs(dz)
            if hum.FloorMaterial == Enum.Material.Air and delta > 0.0005 then
                local vel = hrp.AssemblyLinearVelocity; local hspd = Vector3.new(vel.X,0,vel.Z).Magnitude
                local boost = flat * (hspd + ((strafeMult*delta)/dt)*0.01)
                hrp.AssemblyLinearVelocity = Vector3.new(vel.X+(boost.X*delta*8), vel.Y, vel.Z+(boost.Z*delta*8))
            end; lastLook = cur
        end)
    end
end)
Options.StrafeMult = LeftMain:AddSlider("StrafeMult", { Text = "Multiplier", Default = 120, Min = 10, Max = 300, Rounding = 0, Compact = true })
Options.StrafeMult:OnChanged(function(v) strafeMult = v end)

-- Pixel Surf
local SURF_MAX = 150; local WALL_F = 0.85; local SLIDE_G = 35; local SLIDE_T = 0.85; local WALL_P = 60
Toggles.PixelSurf = LeftMain:AddToggle("PixelSurf", { Title = "Pixel Surf", Description = "Auto-slide on walls", Default = false })
Toggles.PixelSurf:OnChanged(function(v)
    dc("PixelSurf"); dc("JumpBlock")
    if v then
        local surfing = false; local jbTime = 0
        conns.JumpBlock = UIS.InputBegan:Connect(function(inp, gp) if inp.KeyCode == Enum.KeyCode.Space and surfing and not gp and jbTime > 0 then local h = getHum(); if h then h.Jump = false end end end)
        conns.PixelSurf = RunService.Heartbeat:Connect(function(dt)
            local hrp, hum = getHRP(), getHum(); if not hrp or not hum then return end; dt = math.min(dt, 0.1)
            local rp = RaycastParams.new(); rp.FilterDescendantsInstances = { getChar() }; rp.FilterType = Enum.RaycastFilterType.Exclude
            local dirs = { Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1), Vector3.new(1,-0.5,0), Vector3.new(-1,-0.5,0), Vector3.new(0,-0.5,1), Vector3.new(0,-0.5,-1), Vector3.new(0.7,0,0.7), Vector3.new(-0.7,0,-0.7), Vector3.new(0.7,0,-0.7), Vector3.new(-0.7,0,0.7) }
            local nrm, cdist, hit = nil, math.huge, false
            for _, d in ipairs(dirs) do local res = workspace:Raycast(hrp.Position, d:Lerp(Vector3.new(0,-1,0),0.2)*5, rp); if res then local dst = (res.Position-hrp.Position).Magnitude; if math.abs(res.Normal.Y) < SLIDE_T and dst < cdist and dst < 4.5 then cdist = dst; nrm = res.Normal; hit = true end end end
            if hit and nrm then
                if not surfing then surfing = true; jbTime = 0.2 end; hum.Jump = false; hum.JumpPower = 0
                local vel = hrp.AssemblyLinearVelocity; local fv = Vector3.new(vel.X,0,vel.Z); local spd = fv.Magnitude; local pj = fv - (nrm * fv:Dot(nrm)); local sd = (pj.Magnitude < 0.1 and Vector3.new(-nrm.Z,0,nrm.X).Unit) or pj.Unit
                local ns = math.max(math.min(spd*WALL_F, SURF_MAX), 20); local yv = math.max(vel.Y - SLIDE_G*dt, -50); local pu = -nrm * WALL_P * dt
                hrp.AssemblyLinearVelocity = (sd*ns) + Vector3.new(pu.X, yv, pu.Z); jbTime = jbTime - dt
            elseif surfing then hum.JumpPower = 50; surfing = false end
        end)
    else local h = getHum(); if h then h.JumpPower = 50 end
    end
end)

-- Virtual Strafe
local vsMult = 120
Toggles.VirtualStrafe = LeftMain:AddToggle("VirtualStrafe", { Title = "Virtual Strafe", Description = "Auto-move with camera", Default = false })
Toggles.VirtualStrafe:OnChanged(function(v)
    dc("VirtualStrafe")
    if v then conns.VirtualStrafe = camera:GetPropertyChangedSignal("CFrame"):Connect(function() local hrp = getHRP(); if hrp then local lk = camera.CFrame.LookVector; hrp.AssemblyLinearVelocity = Vector3.new(lk.X*vsMult, hrp.AssemblyLinearVelocity.Y, lk.Z*vsMult) end end) end
end)
Options.VSMult = LeftMain:AddSlider("VSMult", { Text = "Strafe Speed", Default = 120, Min = 10, Max = 2000, Rounding = 0, Compact = true })
Options.VSMult:OnChanged(function(v) vsMult = v end)

-- Easy Bounce (Edge Only)
local bouncePow = 100
Toggles.EasyBounce = LeftMain:AddToggle("EasyBounce", { Title = "Easy Bounce (Edge)", Description = "Bounce only at edges not flat ground", Default = false })
Toggles.EasyBounce:OnChanged(function(v)
    dc("EasyBounce")
    if v then conns.EasyBounce = RunService.Heartbeat:Connect(function() local hrp, hum = getHRP(), getHum(); if hrp and hum and hum.FloorMaterial ~= Enum.Material.Air and isAtEdge(hrp) then hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, bouncePow, hrp.AssemblyLinearVelocity.Z) end end) end
end)
Options.BouncePow = LeftMain:AddSlider("BouncePow", { Text = "Bounce Power", Default = 100, Min = 10, Max = 500, Rounding = 0, Compact = true })
Options.BouncePow:OnChanged(function(v) bouncePow = v end)

-- Auto Trimp
local trimpP = 80; local minTrimp = 0
Toggles.AutoTrimp = LeftMain:AddToggle("AutoTrimp", { Title = "Auto Trimp", Description = "Auto trimp when falling", Default = false })
Toggles.AutoTrimp:OnChanged(function(v)
    dc("AutoTrimp")
    if v then conns.AutoTrimp = RunService.Heartbeat:Connect(function() local hrp, hum = getHRP(), getHum(); if hrp and hum then local vel = hrp.AssemblyLinearVelocity; local hspd = math.sqrt(vel.X^2+vel.Z^2); if hum.FloorMaterial == Enum.Material.Air and hspd >= minTrimp then hrp.AssemblyLinearVelocity = Vector3.new(vel.X, trimpP, vel.Z) end end end) end
end)
Options.TrimpP = LeftMain:AddSlider("TrimpP", { Text = "Trimp Power", Default = 80, Min = 10, Max = 200, Rounding = 0, Compact = true })
Options.TrimpP:OnChanged(function(v) trimpP = v end)
Options.MinTrimp = LeftMain:AddSlider("MinTrimp", { Text = "Min Speed", Default = 0, Min = 0, Max = 100, Rounding = 0, Compact = true })
Options.MinTrimp:OnChanged(function(v) minTrimp = v end)

-- Non-Moveable Emotes
Toggles.EmoteMove = LeftMain:AddToggle("EmoteMove", { Title = "Non-Moveable Emotes", Description = "Walk while emoting", Default = false })
Toggles.EmoteMove:OnChanged(function(v)
    dc("EmoteMove")
    if v then conns.EmoteMove = RunService.Heartbeat:Connect(function() local hum = getHum(); if hum then local md = hum.MoveDirection; if md.Magnitude > 0 then local hrp = getHRP(); if hrp then hrp.AssemblyLinearVelocity = Vector3.new(md.X*hum.WalkSpeed, hrp.AssemblyLinearVelocity.Y, md.Z*hum.WalkSpeed) end end end end) end
end)

-- Downed Dash
local SLIDE_O = { Crouch = true, Slide = true, SlideAir = true, EmotingSlide = true, EmotingSlideAir = true, CarryingSlide = true }; local IGNORE = { Default = true, None = true }
local function getLV(root) local att = root:FindFirstChild("SlideAttachment") or Instance.new("Attachment", root); att.Name = "SlideAttachment"; local lv = root:FindFirstChild("SlideLinearVelocity") or Instance.new("LinearVelocity", root); lv.Name = "SlideLinearVelocity"; lv.Attachment0 = att; lv.RelativeTo = Enum.ActuatorRelativeTo.World; lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector; lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis; lv.MaxAxesForce = Vector3.new(100000,0,100000); return lv end
Toggles.DownedDash = LeftMain:AddToggle("DownedDash", { Title = "Downed Dash", Description = "Advanced slide when downed", Default = false })
Toggles.DownedDash:OnChanged(function(v)
    dc("DownedDash")
    if v then
        local grp = RaycastParams.new(); grp.FilterType = Enum.RaycastFilterType.Exclude; local sh = {"None","None","None","None","None"}; local wasSliding, slidAct, curSpd = false, false, 0; local dTime, boostDone = 0, false; local lYaw, mDir = 0, Vector3.new(0,0,0)
        conns.DownedDash = RunService.Heartbeat:Connect(function(dt)
            local char, root, hum = getChar(), getHRP(), getHum(); if not char or not root or not hum then return end; local lv = getLV(root); grp.FilterDescendantsInstances = { char }
            local st = char:GetAttribute("State") or "None"
            if sh[1] ~= st then table.insert(sh, 1, st); if #sh > 6 then table.remove(sh) end; if st == "Downed" then local f = false; for i = 2, #sh do local hs = sh[i]; if SLIDE_O[hs] then f = true; break elseif not IGNORE[hs] then break end end; if f then slidAct = true end elseif not SLIDE_O[st] then slidAct = false end end
            if st == "Downed" and slidAct then
                lv.Enabled = true
                if not wasSliding then curSpd = Vector3.new(root.AssemblyLinearVelocity.X,0,root.AssemblyLinearVelocity.Z).Magnitude; dTime = os.clock(); boostDone = false; wasSliding = true end
                if not boostDone and os.clock()-dTime >= 0.1 then curSpd = math.max(curSpd, 50); boostDone = true end
                local onGround = hum.FloorMaterial ~= Enum.Material.Air; local gRay = workspace:Raycast(root.Position, Vector3.new(0,-5,0), grp)
                local cf = camera.CFrame.LookVector; local camF = Vector3.new(cf.X,0,cf.Z).Unit; local _, yaw, _ = camera.CFrame:ToEulerAnglesYXZ(); local yd = yaw - lYaw
                if yd > math.pi then yd = yd - math.pi*2 end; if yd < -math.pi then yd = yd + math.pi*2 end; lYaw = yaw; local canStr = false; local inp = hum.MoveDirection
                if inp.Magnitude > 0.1 then local rel = camera.CFrame:VectorToObjectSpace(inp); if (rel.X < -0.1 and yd > 0.001) or (rel.X > 0.1 and yd < -0.001) then mDir = camF; canStr = true end end
                if mDir.Magnitude < 0.1 then mDir = camF end
                if canStr then curSpd = curSpd + dt elseif onGround then local slope = false; if gRay and gRay.Instance and gRay.Normal.Y < 0.98 and mDir.Unit:Dot(gRay.Normal) < -0.05 then slope = true; if curSpd < 55.5 then curSpd = math.min(curSpd+10*dt, 55.5) end end; if not slope and curSpd <= 55.5 then curSpd = math.max(20, curSpd-3*dt) end end
                if onGround and curSpd > 55.5 then curSpd = math.max(55.5, curSpd-20*dt) end
                if curSpd > 0.5 then lv.VectorVelocity = (mDir.Unit*curSpd) else curSpd = 0; lv.VectorVelocity = Vector3.new(0,0,0) end
                char:SetAttribute("RelativeSpeed", curSpd)
            else lv.Enabled = false; lv.VectorVelocity = Vector3.new(0,0,0); curSpd = 0; wasSliding = false; boostDone = false; mDir = Vector3.new(0,0,0); local _, yaw, _ = camera.CFrame:ToEulerAnglesYXZ(); lYaw = yaw end
        end)
    else local root = getHRP(); if root then local lv = root:FindFirstChild("SlideLinearVelocity"); if lv then lv.Enabled = false; lv.VectorVelocity = Vector3.new(0,0,0) end end
    end
end)

-- === MAIN - CUSTOM ===
local hbX, hbY, hbZ = 6, 3, 6; local FOLDER = "AABB_Wireframe_Folder"
local function getHighest(obj) local h, my = nil, -math.huge; local function ck(p) if p:IsA("BasePart") then local t = p.Position.Y + p.Size.Y/2; if t > my then my = t; h = p end end end; ck(obj); for _, d in pairs(obj:GetDescendants()) do ck(d) end; return h end
local function calcAABB(tgt)
    local mix, miy, miz = math.huge, math.huge, math.huge; local mxx, mxy, mxz = -math.huge, -math.huge, -math.huge; local parts = {}; if tgt:IsA("BasePart") then table.insert(parts, tgt) end; for _, d in pairs(tgt:GetDescendants()) do if d:IsA("BasePart") then table.insert(parts, d) end end; if #parts == 0 then return nil end
    for _, p in ipairs(parts) do local cf, s = p.CFrame, p.Size/2; for _, c in ipairs({cf*Vector3.new(s.X,s.Y,s.Z),cf*Vector3.new(-s.X,s.Y,s.Z),cf*Vector3.new(s.X,-s.Y,s.Z),cf*Vector3.new(-s.X,-s.Y,s.Z),cf*Vector3.new(s.X,s.Y,-s.Z),cf*Vector3.new(-s.X,s.Y,-s.Z),cf*Vector3.new(s.X,-s.Y,-s.Z),cf*Vector3.new(-s.X,-s.Y,-s.Z)}) do mix=math.min(mix,c.X);miy=math.min(miy,c.Y);miz=math.min(miz,c.Z);mxx=math.max(mxx,c.X);mxy=math.max(mxy,c.Y);mxz=math.max(mxz,c.Z) end end
    return Vector3.new((mxx+mix)/2,(mxy+miy)/2,(mxz+miz)/2), Vector3.new(mxx-mix, mxy-miy, mxz-miz)
end
local hitboxFolder = nil
Toggles.EasyHop = RightMain:AddToggle("EasyHop", { Title = "Easy Hop", Description = "Expand fence hitboxes", Default = false })
Toggles.EasyHop:OnChanged(function(v)
    if hitboxFolder then hitboxFolder:Destroy(); hitboxFolder = nil end
    if v then
        hitboxFolder = Instance.new("Folder"); hitboxFolder.Name = FOLDER; hitboxFolder.Parent = workspace; local cnt = 0
        pcall(function() local gf = workspace:FindFirstChild("Game"); if gf then local m = gf:FindFirstChild("Map"); local p = m and m:FindFirstChild("Parts"); local pr = p and p:FindFirstChild("ImmovableProps"); if pr then for _, o in pairs(pr:GetChildren()) do if o.Name:find("Cactus") or o.Name:find("Fence") or o.Name:find("Wall") then local t = getHighest(o); if t then local c, s = calcAABB(t); if c and s then local bx = Instance.new("Part"); bx.Size = s + Vector3.new(hbX, hbY, hbZ); bx.Position = c; bx.Anchored = true; bx.CanCollide = true; bx.Transparency = 1; bx.Parent = hitboxFolder; cnt = cnt + 1 end end end end end end end)
        LinoriaLib:Notify("Easy Hop: "..cnt.." objects expanded", 3)
    end
end)
Options.HbX = RightMain:AddSlider("HbX", { Text = "Expand X", Default = 6, Min = 0, Max = 15, Rounding = 0, Compact = true }); Options.HbX:OnChanged(function(v) hbX = v end)
Options.HbY = RightMain:AddSlider("HbY", { Text = "Expand Y", Default = 3, Min = 0, Max = 15, Rounding = 0, Compact = true }); Options.HbY:OnChanged(function(v) hbY = v end)
Options.HbZ = RightMain:AddSlider("HbZ", { Text = "Expand Z", Default = 6, Min = 0, Max = 15, Rounding = 0, Compact = true }); Options.HbZ:OnChanged(function(v) hbZ = v end)

-- Edge Boost
_G.EdgeBoostLoaded = false; _G.EdgeBoostConnection = nil; _G.EdgeBoostInput = nil; _G.EdgeBoostEnabled = true
RightMain:AddButton({ Title = "Easy Edge Boost (U toggle)", Func = function()
    if _G.EdgeBoostLoaded then if _G.EdgeBoostConnection then _G.EdgeBoostConnection:Disconnect() end; if _G.EdgeBoostInput then _G.EdgeBoostInput:Disconnect() end; _G.EdgeBoostLoaded = false; LinoriaLib:Notify("Edge Boost disabled", 2); return end
    _G.EdgeBoostLoaded = true; _G.EdgeBoostEnabled = true; local BP = 100; local function gch() local c = player.Character or player.CharacterAdded:Wait(); local hrp = c:WaitForChild("HumanoidRootPart"); local h = c:WaitForChild("Humanoid"); return c, hrp, h end; local ch, hrp, hum = gch()
    local function isBP(p) local kws = {"bounce","boost","launch","jump","pad","ramp","platform"}; local n = string.lower(p.Name); for _, kw in pairs(kws) do if n:find(kw) then return true end end; if p.Parent and (p.Parent:IsA("Model") or p.Parent:IsA("Folder")) then local pn = string.lower(p.Parent.Name); for _, kw in pairs(kws) do if pn:find(kw) then return true end end end; return false end
    _G.EdgeBoostConnection = RunService.Stepped:Connect(function() if not _G.EdgeBoostEnabled or not hrp or not hum or hum.Health <= 0 then return end; if hrp.AssemblyLinearVelocity.Y < -1 then local pts = hrp:GetTouchingParts(); local edge, bnc = false, false; if #pts > 0 then for _, p in pairs(pts) do if isBP(p) then bnc = true; break end end; if not bnc then edge = true end end; if edge then hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z) + Vector3.new(0,BP,0) end end end)
    _G.EdgeBoostInput = UIS.InputBegan:Connect(function(inp, gp) if gp then return end; if inp.KeyCode == Enum.KeyCode.U then _G.EdgeBoostEnabled = not _G.EdgeBoostEnabled; if _G.EdgeBoostEnabled then ch, hrp, hum = gch(); LinoriaLib:Notify("Edge Boost enabled", 3) else LinoriaLib:Notify("Edge Boost disabled", 3) end end end)
    LinoriaLib:Notify("Edge Boost enabled! (U toggle)", 3)
end })

local disabledWalls = {}
OtherMain:AddButton({ Title = "Remove Invisible Walls", Func = function()
    local r = 0; local ch = getChar()
    for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Transparency == 1 and o.CanCollide then if not (ch and o:IsDescendantOf(ch)) then o.CanCollide = false; table.insert(disabledWalls, o); r = r + 1 end end end
    LinoriaLib:Notify("Removed "..r.." wall(s)", 4)
end })
OtherMain:AddButton({ Title = "Restore Walls", Func = function()
    local r = 0; for _, p in ipairs(disabledWalls) do if p and p.Parent then p.CanCollide = true; r = r + 1 end end; disabledWalls = {}; LinoriaLib:Notify("Restored "..r.." wall(s)", 4)
end })

-- Evade Speed
local evSpd = 1500
Options.EvadeSpd = OtherMain:AddSlider("EvadeSpd", { Text = "Evade Speed Override", Default = 1500, Min = 100, Max = 5000, Rounding = 0, Compact = true }); Options.EvadeSpd:OnChanged(function(v) evSpd = v end)
OtherMain:AddButton({ Title = "Apply Evade Speed", Func = function() _G.RealSpeedOverride = evSpd; LinoriaLib:Notify("Speed set to "..evSpd, 3) end })

-- === PLAYER ===
local walkSpd = 16
Toggles.WalkSpeed = LeftPlayer:AddToggle("WalkSpeed", { Title = "Walk Speed", Description = "Override walk speed", Default = false })
Toggles.WalkSpeed:OnChanged(function(v) dc("WalkSpeed"); if v then conns.WalkSpeed = RunService.Heartbeat:Connect(function() local h = getHum(); if h then h.WalkSpeed = walkSpd end end) else local h = getHum(); if h then h.WalkSpeed = 16 end end end)
Options.WalkSpd = LeftPlayer:AddSlider("WalkSpd", { Text = "Speed", Default = 16, Min = 16, Max = 150, Rounding = 0, Compact = true }); Options.WalkSpd:OnChanged(function(v) walkSpd = v end)

local jumpPow = 50
Toggles.JumpPower = LeftPlayer:AddToggle("JumpPower", { Title = "Jump Power", Description = "Override jump height", Default = false })
Toggles.JumpPower:OnChanged(function(v) dc("JumpPower"); if v then conns.JumpPower = RunService.Heartbeat:Connect(function() local h = getHum(); if h then h.JumpPower = jumpPow end end) else local h = getHum(); if h then h.JumpPower = 50 end end end)
Options.JumpPow = LeftPlayer:AddSlider("JumpPow", { Text = "Power", Default = 50, Min = 10, Max = 300, Rounding = 0, Compact = true }); Options.JumpPow:OnChanged(function(v) jumpPow = v end)

local sprintSpd = 32
Toggles.Sprint = LeftPlayer:AddToggle("Sprint", { Title = "Sprint (Shift)", Description = "Hold Shift to sprint", Default = false })
Toggles.Sprint:OnChanged(function(v) dc("Sprint"); if v then conns.Sprint = RunService.Heartbeat:Connect(function() local h = getHum(); if h then if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then h.WalkSpeed = sprintSpd elseif not Toggles.WalkSpeed.Value then h.WalkSpeed = 16 end end end) end end)
Options.SprintSpd = LeftPlayer:AddSlider("SprintSpd", { Text = "Sprint Speed", Default = 32, Min = 20, Max = 200, Rounding = 0, Compact = true }); Options.SprintSpd:OnChanged(function(v) sprintSpd = v end)

Toggles.NoShake = RightPlayer:AddToggle("NoShake", { Title = "Disable Cam Shake", Default = false })
Toggles.NoShake:OnChanged(function(v) dc("NoShake"); if v then conns.NoShake = RunService.RenderStepped:Connect(function() local c = workspace.CurrentCamera; c.CFrame = CFrame.lookAt(c.CFrame.Position, c.CFrame.Position+c.CFrame.LookVector, Vector3.new(0,1,0)) end) end end)

Toggles.FullBright = RightPlayer:AddToggle("FullBright", { Title = "Full Bright", Default = false })
Toggles.FullBright:OnChanged(function(v) if v then Lighting.Brightness=3; Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255); Lighting.GlobalShadows=false else Lighting.Brightness=1; Lighting.Ambient=Color3.fromRGB(200,200,200); Lighting.OutdoorAmbient=Color3.fromRGB(200,200,200); Lighting.GlobalShadows=true end end)

local ofe, ofs = nil, nil
Toggles.NoFog = RightPlayer:AddToggle("NoFog", { Title = "Remove Fog", Default = false })
Toggles.NoFog:OnChanged(function(v) if v then ofe=Lighting.FogEnd; ofs=Lighting.FogStart; Lighting.FogEnd=100000; Lighting.FogStart=99999 else Lighting.FogEnd=ofe or 100000; Lighting.FogStart=ofs or 0 end end)

local curFOV = 70
Options.FOV = RightPlayer:AddSlider("FOV", { Text = "FOV Lock", Default = 70, Min = 40, Max = 120, Rounding = 0, Compact = true })
Options.FOV:OnChanged(function(v) curFOV = v; dc("FOV"); conns.FOV = RunService.RenderStepped:Connect(function() local c = workspace.CurrentCamera; if c.FieldOfView ~= curFOV then c.FieldOfView = curFOV end end) end)

-- Lag Switch
local lagDur = 0.9; local lagCD = 0
LagBox:AddButton({ Title = "LAG SWITCH", Func = function()
    if lagCD > 0 then LinoriaLib:Notify("Cooldown!", 2); return end; lagCD = 2; local s = tick(); LinoriaLib:Notify("Lagging for "..lagDur.."s", 1)
    local c; c = RunService.Heartbeat:Connect(function() if tick()-s >= lagDur then c:Disconnect(); LinoriaLib:Notify("Released!", 2) end end)
end })
Options.LagDur = LagBox:AddSlider("LagDur", { Text = "Duration (sec)", Default = 0.9, Min = 0.1, Max = 3, Rounding = 1, Compact = true }); Options.LagDur:OnChanged(function(v) lagDur = v end)
RunService.Heartbeat:Connect(function(dt) if lagCD > 0 then lagCD = lagCD - dt end end)

-- === VISUALS ===
Toggles.PlayerESP = VisWorld:AddToggle("PlayerESP", { Title = "Player ESP", Default = false })
local espFolder = nil
Toggles.PlayerESP:OnChanged(function(v)
    if espFolder then espFolder:Destroy(); espFolder = nil end
    if v then
        espFolder = Instance.new("Folder"); espFolder.Name = "PlayerESP"; espFolder.Parent = workspace
        for _, p in pairs(Players:GetPlayers()) do if p ~= player and p.Character then local h = Instance.new("Highlight"); h.FillColor = Color3.fromRGB(0,255,0); h.OutlineColor = Color3.fromRGB(0,255,0); h.FillTransparency = 0.3; h.OutlineTransparency = 0; h.Adornee = p.Character; h.Parent = espFolder end end
    end
end)

Toggles.RGB = VisWorld:AddToggle("RGB", { Title = "RGB Mode", Default = false })
Toggles.RGB:OnChanged(function(v) dc("RGB")
    if v then
        local rg = Instance.new("ScreenGui"); rg.Name = "RGBMode"; rg.ResetOnSpawn = false; rg.Parent = playerGui
        local rf = Instance.new("Frame"); rf.Size = UDim2.new(1,0,1,0); rf.BackgroundTransparency = 0.92; rf.BorderSizePixel = 0; rf.Parent = rg; local t = 0
        conns.RGB = RunService.RenderStepped:Connect(function(dt) t = t + dt*0.5; rf.BackgroundColor3 = Color3.fromHSV(t%1,1,1) end); _G.RGBGui = rg
    else if _G.RGBGui then _G.RGBGui:Destroy(); _G.RGBGui = nil end end
end)

-- Emote Swap
local e1, e2, oe1, oe2, eSwapped = "", "", "", "", false
local function norm(s) return s:gsub("%s+",""):lower() end; local function lev(s,t) local m,n=#s,#t;local d={};for i=0,m do d[i]={[0]=i} end;for j=0,n do d[0][j]=j end;for i=1,m do for j=1,n do local c=(s:sub(i,i)==t:sub(j,j)) and 0 or 1;d[i][j]=math.min(d[i-1][j]+1,d[i][j-1]+1,d[i-1][j-1]+c) end end;return d[m][n] end; local function sim(s,t) local nS,nT=norm(s),norm(t);return 1-(lev(nS,nT)/math.max(#nS,#nT)) end
local function findBest(name) local em = ReplicatedStorage:FindFirstChild("Items"); if not em then return name end; em = em:FindFirstChild("Emotes"); if not em then return name end; local b, bs = name, 0.5; for _, c in ipairs(em:GetChildren()) do local s = sim(name, c.Name); if s > bs then bs = s; b = c.Name end end; return b end
VisCosmetic:AddInput("Emote1", { Text = "Current Emote", Default = "", Placeholder = "Emote you have", Numeric = false, Finished = false })
Options.Emote1 = LinoriaLib:GetProperty("Emote1"); Options.Emote1:OnChanged(function(v) e1 = v; if not eSwapped then oe1 = v end end)
VisCosmetic:AddInput("Emote2", { Text = "Target Emote", Default = "", Placeholder = "Emote you want", Numeric = false, Finished = false })
Options.Emote2 = LinoriaLib:GetProperty("Emote2"); Options.Emote2:OnChanged(function(v) e2 = v; if not eSwapped then oe2 = v end end)
VisCosmetic:AddButton({ Title = "Apply Emote Swap", Func = function()
    pcall(function() if e1 == "" or e2 == "" or e1 == e2 then LinoriaLib:Notify("Enter two different emotes!", 3); return end; local em = ReplicatedStorage:WaitForChild("Items"):WaitForChild("Emotes"); local aN = findBest(e1); local bN = findBest(e2); local a, b = em:FindFirstChild(aN), em:FindFirstChild(bN); if not a or not b then LinoriaLib:Notify("Emotes not found!", 3); return end; if not eSwapped then oe1 = aN; oe2 = bN end; local tr = Instance.new("Folder", em); tr.Name = "__t_"..tostring(tick()):gsub("%.","_"); local ta, tb = Instance.new("Folder", tr), Instance.new("Folder", tr); for _, c in ipairs(a:GetChildren()) do c.Parent = ta end; for _, c in ipairs(b:GetChildren()) do c.Parent = tb end; for _, c in ipairs(ta:GetChildren()) do c.Parent = b end; for _, c in ipairs(tb:GetChildren()) do c.Parent = a end; tr:Destroy(); eSwapped = true; LinoriaLib:Notify("Swapped '"..aN.."' with '"..bN.."'", 3) end)
end })
VisCosmetic:AddButton({ Title = "Reset Emote Swap", Func = function()
    pcall(function() if not eSwapped then LinoriaLib:Notify("No emotes swapped!", 3); return end; local em = ReplicatedStorage:WaitForChild("Items"):WaitForChild("Emotes"); local a, b = em:FindFirstChild(e1), em:FindFirstChild(e2); if a and b then local tr = Instance.new("Folder", em); tr.Name = "__t_"..tostring(tick()):gsub("%.","_"); local ta, tb = Instance.new("Folder", tr), Instance.new("Folder", tr); for _, c in ipairs(a:GetChildren()) do c.Parent = ta end; for _, c in ipairs(b:GetChildren()) do c.Parent = tb end; for _, c in ipairs(ta:GetChildren()) do c.Parent = b end; for _, c in ipairs(tb:GetChildren()) do c.Parent = a end; tr:Destroy() end; eSwapped = false; LinoriaLib:Notify("Reset to original", 3) end)
end })

-- Unusual Swap
local u1, u2, uo1, uo2, uSwapped = "", "", "", "", false
local function findBestU(name) local it = ReplicatedStorage:FindFirstChild("Items"); if not it then return name end; local un = it:FindFirstChild("Unusual"); if not un then return name end; local b, bs = name, 0.5; for _, c in ipairs(un:GetChildren()) do local s = sim(name, c.Name); if s > bs then bs = s; b = c.Name end end; return b end
VisCosmetic:AddInput("Unusual1", { Text = "Current Unusual", Default = "", Placeholder = "Unusual you have", Numeric = false, Finished = false })
Options.Unusual1 = LinoriaLib:GetProperty("Unusual1"); Options.Unusual1:OnChanged(function(v) u1 = v; if not uSwapped then uo1 = v end end)
VisCosmetic:AddInput("Unusual2", { Text = "Target Unusual", Default = "", Placeholder = "Unusual you want", Numeric = false, Finished = false })
Options.Unusual2 = LinoriaLib:GetProperty("Unusual2"); Options.Unusual2:OnChanged(function(v) u2 = v; if not uSwapped then uo2 = v end end)
VisCosmetic:AddButton({ Title = "Apply Unusual Swap", Func = function()
    pcall(function() if u1=="" or u2=="" or u1==u2 then LinoriaLib:Notify("Enter two different items!",3); return end; local un=ReplicatedStorage:WaitForChild("Items"):WaitForChild("Unusual"); local aN,bN=findBestU(u1),findBestU(u2); local a,b=un:FindFirstChild(aN),un:FindFirstChild(bN); if not a or not b then LinoriaLib:Notify("Items not found!",3); return end; if not uSwapped then uo1=aN;uo2=bN end; local tr=Instance.new("Folder",un); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy(); uSwapped=true; LinoriaLib:Notify("Swapped '"..aN.."' with '"..bN.."'",3) end)
end })
VisCosmetic:AddButton({ Title = "Reset Unusual Swap", Func = function()
    pcall(function() if not uSwapped then LinoriaLib:Notify("No items swapped!",3); return end; local un=ReplicatedStorage:WaitForChild("Items"):WaitForChild("Unusual"); local a,b=un:FindFirstChild(u1),un:FindFirstChild(u2); if a and b then local tr=Instance.new("Folder",un); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy() end; uSwapped=false; LinoriaLib:Notify("Reset to original",3) end)
end })

-- Cosmetic Swap
local co1, co2, coo1, coo2, coSwapped = "", "", "", "", false
local function findBestC(name) local it = ReplicatedStorage:FindFirstChild("Items"); if not it then return name end; local co = it:FindFirstChild("Cosmetics"); if not co then return name end; local b, bs = name, 0.5; for _, c in ipairs(co:GetChildren()) do local s = sim(name, c.Name); if s > bs then bs = s; b = c.Name end end; return b end
VisCosmetic:AddInput("Cosmetic1", { Text = "Current Cosmetic", Default = "", Placeholder = "Cosmetic you have", Numeric = false, Finished = false })
Options.Cosmetic1 = LinoriaLib:GetProperty("Cosmetic1"); Options.Cosmetic1:OnChanged(function(v) co1 = v; if not coSwapped then coo1 = v end end)
VisCosmetic:AddInput("Cosmetic2", { Text = "Target Cosmetic", Default = "", Placeholder = "Cosmetic you want", Numeric = false, Finished = false })
Options.Cosmetic2 = LinoriaLib:GetProperty("Cosmetic2"); Options.Cosmetic2:OnChanged(function(v) co2 = v; if not coSwapped then coo2 = v end end)
VisCosmetic:AddButton({ Title = "Apply Cosmetic Swap", Func = function()
    pcall(function() if co1=="" or co2=="" or co1==co2 then LinoriaLib:Notify("Enter two different cosmetics!",3); return end; local co=ReplicatedStorage:WaitForChild("Items"):WaitForChild("Cosmetics"); local aN,bN=findBestC(co1),findBestC(co2); local a,b=co:FindFirstChild(aN),co:FindFirstChild(bN); if not a or not b then LinoriaLib:Notify("Cosmetics not found!",3); return end; if not coSwapped then coo1=aN;coo2=bN end; local tr=Instance.new("Folder",co); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy(); coSwapped=true; LinoriaLib:Notify("Swapped '"..aN.."' with '"..bN.."'",3) end)
end })
VisCosmetic:AddButton({ Title = "Reset Cosmetic Swap", Func = function()
    pcall(function() if not coSwapped then LinoriaLib:Notify("No cosmetics swapped!",3); return end; local co=ReplicatedStorage:WaitForChild("Items"):WaitForChild("Cosmetics"); local a,b=co:FindFirstChild(co1),co:FindFirstChild(co2); if a and b then local tr=Instance.new("Folder",co); tr.Name="__t_"..tostring(tick()):gsub("%.","_"); local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr); for _,c in ipairs(a:GetChildren()) do c.Parent=ta end; for _,c in ipairs(b:GetChildren()) do c.Parent=tb end; for _,c in ipairs(ta:GetChildren()) do c.Parent=b end; for _,c in ipairs(tb:GetChildren()) do c.Parent=a end; tr:Destroy() end; coSwapped=false; LinoriaLib:Notify("Reset to original",3) end)
end })

-- Headless / Korblox / Guitar
VisCosmetic:AddButton({ Title = "Headless (Local)", Func = function() pcall(function() local ch = getChar(); if not ch then return end; local h = ch:FindFirstChild("Head"); if h then h.Transparency = 1 end; local f = h and h:FindFirstChild("face"); if f then f.Transparency = 1 end; for _, o in pairs(ch:GetDescendants()) do if (o.Name:lower():find("hair") or o.Name:lower():find("hat")) and o:IsA("BasePart") then o.Transparency = 1 end end; LinoriaLib:Notify("Headless applied", 3) end) end })
VisCosmetic:AddButton({ Title = "Toggle Korblox Leg", Func = function()
    pcall(function() if _G.KorbloxEnabled == nil then _G.KorbloxEnabled = false end; _G.KorbloxConnections = _G.KorbloxConnections or {}; _G.KorbloxEnabled = not _G.KorbloxEnabled; for _, c in ipairs(_G.KorbloxConnections) do if c.Connected then c:Disconnect() end end; table.clear(_G.KorbloxConnections); if not _G.KorbloxEnabled then LinoriaLib:Notify("Korblox disabled", 3); return end; LinoriaLib:Notify("Korblox enabled", 3)
        local KM = "rbxassetid://101851696"; local KT = "rbxassetid://101851254"; local KC = Color3.fromRGB(38,65,68)
        local function apply(ch) if not ch or not _G.KorbloxEnabled then return end; local rL = ch:WaitForChild("Right Leg", 5); if rL and _G.KorbloxEnabled then for _, v in ipairs(ch:GetChildren()) do if v:IsA("CharacterMesh") and v.BodyPart == Enum.BodyPart.RightLeg then v:Destroy() end end; local ms = rL:FindFirstChildOfClass("SpecialMesh"); if not ms then ms = Instance.new("SpecialMesh", rL); ms.Name = "KorbloxMesh" end; ms.MeshId = KM; ms.TextureId = KT; ms.Scale = Vector3.new(1,1,1); rL.Color = KC; rL.Transparency = 0; rL.Material = Enum.Material.Plastic; task.spawn(function() while ch and ch.Parent and _G.KorbloxEnabled do if rL.Color ~= KC then rL.Color = KC end; task.wait(1) end end) end end
        local function setup(p) if p.Character then task.spawn(apply, p.Character) end; table.insert(_G.KorbloxConnections, p.CharacterAdded:Connect(function(c) task.wait(0.5); apply(c) end)) end; for _, p in pairs(Players:GetPlayers()) do setup(p) end; table.insert(_G.KorbloxConnections, Players.PlayerAdded:Connect(setup))
    end) end })

-- === FUN ===
local legSpd = 50
Toggles.LegacySpeed = FunSpeed:AddToggle("LegacySpeed", { Title = "Old Speed System", Default = false })
Toggles.LegacySpeed:OnChanged(function(v) dc("LegacySpeed"); if v then conns.LegacySpeed = RunService.Heartbeat:Connect(function() local hrp = getHRP(); if hrp then local bv = hrp:FindFirstChild("LegacyBV"); if not bv then bv = Instance.new("BodyVelocity"); bv.Name = "LegacyBV"; bv.MaxForce = Vector3.new(100000,0,100000); bv.Parent = hrp end; local lk = camera.CFrame.LookVector; local d = Vector3.new(lk.X,0,lk.Z).Unit; if UIS:IsKeyDown(Enum.KeyCode.W) then bv.Velocity = d*legSpd elseif UIS:IsKeyDown(Enum.KeyCode.S) then bv.Velocity = -d*legSpd else bv.Velocity = Vector3.new(0,0,0) end end end) else local hrp = getHRP(); if hrp then local bv = hrp:FindFirstChild("LegacyBV"); if bv then bv:Destroy() end end end end)
Options.LegSpd = FunSpeed:AddSlider("LegSpd", { Text = "Speed", Default = 50, Min = 10, Max = 500, Rounding = 0, Compact = true }); Options.LegSpd:OnChanged(function(v) legSpd = v end)

local legJP = 80
Toggles.LegacyJump = FunJump:AddToggle("LegacyJump", { Title = "Old Jump System", Default = false })
Toggles.LegacyJump:OnChanged(function(v) dc("LegacyJump"); if v then conns.LegacyJump = UIS.InputBegan:Connect(function(inp, gp) if gp then return end; if inp.KeyCode == Enum.KeyCode.Space then local hrp = getHRP(); if hrp then local bf = Instance.new("BodyVelocity"); bf.Velocity = Vector3.new(hrp.AssemblyLinearVelocity.X, legJP, hrp.AssemblyLinearVelocity.Z); bf.MaxForce = Vector3.new(0,1000000,0); bf.Parent = hrp; Debris:AddItem(bf, 0.1) end end end) end end)
Options.LegJP = FunJump:AddSlider("LegJP", { Text = "Power", Default = 80, Min = 20, Max = 500, Rounding = 0, Compact = true }); Options.LegJP:OnChanged(function(v) legJP = v end)

FunAnim:AddButton({ Title = "Play Old Run Animation", Func = function() pcall(function() local h = getHum(); if h then local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://180426354"; h:LoadAnimation(a):Play() end end) end })
FunAnim:AddButton({ Title = "Play Old Idle Animation", Func = function() pcall(function() local h = getHum(); if h then local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://180435571"; h:LoadAnimation(a):Play() end end) end })

Toggles.LegacyNoClip = FunAnim:AddToggle("LegacyNoClip", { Title = "Legacy No-Clip", Default = false })
Toggles.LegacyNoClip:OnChanged(function(v) dc("LegacyNoClip"); if v then conns.LegacyNoClip = RunService.Stepped:Connect(function() local ch = getChar(); if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end) else local ch = getChar(); if ch then for _, p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end end)

-- === MISC ===
local CONFIG_PATH = "HENQWare/config.json"; local _cfg = {}
MiscConf:AddButton({ Title = "Save Config", Func = function() pcall(function() if not isfolder("HENQWare") then makefolder("HENQWare") end; writefile(CONFIG_PATH, game:GetService("HttpService"):JSONEncode(_cfg)); LinoriaLib:Notify("Saved!", 2) end) end })
MiscConf:AddButton({ Title = "Load Config", Func = function() pcall(function() if isfile(CONFIG_PATH) then _cfg = game:GetService("HttpService"):JSONDecode(readfile(CONFIG_PATH)); LinoriaLib:Notify("Loaded!", 2) else LinoriaLib:Notify("No config found!", 2) end end) end })
MiscConf:AddButton({ Title = "Clear Config", Func = function() _cfg = {}; pcall(function() if isfile(CONFIG_PATH) then delfile(CONFIG_PATH) end end); LinoriaLib:Notify("Cleared!", 2) end })

MiscInfo:AddButton({ Title = "Game Info", Func = function() LinoriaLib:Notify("Game: "..game.Name.." | ID: "..game.PlaceId.." | Players: "..#Players:GetPlayers(), 5) end })
MiscInfo:AddButton({ Title = "Player Stats", Func = function() local h, hrp = getHum(), getHRP(); if not h or not hrp then LinoriaLib:Notify("No character!", 2); return end; local v = hrp.AssemblyLinearVelocity; local spd = math.floor(math.sqrt(v.X^2+v.Z^2)); LinoriaLib:Notify("HP: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth).." | SPD: "..spd, 5) end })
MiscInfo:AddButton({ Title = "Player Count", Func = function() LinoriaLib:Notify("Players: "..#Players:GetPlayers(), 3) end })

MiscChar:AddButton({ Title = "Remove Walls 2", Func = function() local r = 0; local ch = getChar(); for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Transparency == 1 and o.CanCollide then if not (ch and o:IsDescendantOf(ch)) then o.CanCollide = false; table.insert(disabledWalls, o); r = r + 1 end end end; LinoriaLib:Notify("Removed "..r.." wall(s)", 4) end })
MiscChar:AddButton({ Title = "Restore Walls 2", Func = function() local r = 0; for _, p in ipairs(disabledWalls) do if p and p.Parent then p.CanCollide = true; r = r + 1 end end; LinoriaLib:Notify("Restored "..r.." wall(s)", 4) end })
MiscChar:AddButton({ Title = "Reset Character", Func = function() local h = getHum(); if h then h.Health = 0 end end })
MiscChar:AddButton({ Title = "Rejoin Server", Func = function() LinoriaLib:Notify("Rejoining...", 2); task.delay(1, function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end) end })

-- === UTILITY ===
Toggles.Cola = UtilBoost:AddToggle("Cola", { Title = "Unlimited Cola", Default = false })
Toggles.Cola:OnChanged(function(v) dc("Cola"); if v then conns.Cola = RunService.Heartbeat:Connect(function() local hrp = getHRP(); if hrp then for _, o in pairs(workspace:GetDescendants()) do local n = o.Name:lower(); if (n:find("cola") or n:find("drink") or n:find("soda")) and o:IsA("BasePart") and (o.Position-hrp.Position).Magnitude < 20 then pcall(function() local t = o.Touched; if t then t:Fire(hrp) end end); pcall(function() local cd = o:FindFirstChildOfClass("ClickDetector"); if cd then fireclickdetector(cd) end end) end end end) end end)

local sbVal = 60
Toggles.SpeedBoost = UtilBoost:AddToggle("SpeedBoost", { Title = "Speed Booster", Default = false })
Toggles.SpeedBoost:OnChanged(function(v) dc("SpeedBoost"); if v then conns.SpeedBoost = RunService.Heartbeat:Connect(function() local h = getHum(); if h then h.WalkSpeed = sbVal end end) else local h = getHum(); if h then h.WalkSpeed = 16 end end end)
Options.SBVal = UtilBoost:AddSlider("SBVal", { Text = "Boost Speed", Default = 60, Min = 16, Max = 300, Rounding = 0, Compact = true }); Options.SBVal:OnChanged(function(v) sbVal = v end)

UtilTP:AddButton({ Title = "Teleport Spawn", Func = function() local hrp = getHRP(); if hrp then hrp.CFrame = CFrame.new(0,10,0) end end })
local tx, ty, tz = 0, 10, 0; local tpName = ""
UtilTP:AddInput("TPX", { Text = "X", Default = "0", Placeholder = "0", Numeric = true, Finished = true }); Options.TPX = LinoriaLib:GetProperty("TPX"); Options.TPX:OnChanged(function(v) tx = tonumber(v) or 0 end)
UtilTP:AddInput("TPY", { Text = "Y", Default = "10", Placeholder = "10", Numeric = true, Finished = true }); Options.TPY = LinoriaLib:GetProperty("TPY"); Options.TPY:OnChanged(function(v) ty = tonumber(v) or 10 end)
UtilTP:AddInput("TPZ", { Text = "Z", Default = "0", Placeholder = "0", Numeric = true, Finished = true }); Options.TPZ = LinoriaLib:GetProperty("TPZ"); Options.TPZ:OnChanged(function(v) tz = tonumber(v) or 0 end)
UtilTP:AddButton({ Title = "TP to Coords", Func = function() local hrp = getHRP(); if hrp then hrp.CFrame = CFrame.new(tx,ty,tz); LinoriaLib:Notify("Teleported!", 2) end end })
UtilTP:AddInput("TPPlayer", { Text = "Player Name", Default = "", Placeholder = "Username", Numeric = false, Finished = true }); Options.TPPlayer = LinoriaLib:GetProperty("TPPlayer"); Options.TPPlayer:OnChanged(function(v) tpName = v end)
UtilTP:AddButton({ Title = "TP to Player", Func = function() local hrp = getHRP(); if not hrp then return end; for _, p in pairs(Players:GetPlayers()) do if fuzzyMatch(p.Name, tpName) or fuzzyMatch(p.DisplayName, tpName) then if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,3); LinoriaLib:Notify("TP to "..p.Name, 2); return end end end; LinoriaLib:Notify("Not found!", 2) end })
UtilTP:AddButton({ Title = "TP to Downed", Func = function() local hrp = getHRP(); if not hrp then return end; for _, p in pairs(Players:GetPlayers()) do if p ~= player and p.Character then local h, phrp = p.Character:FindFirstChildOfClass("Humanoid"), p.Character:FindFirstChild("HumanoidRootPart"); if h and phrp and h.Health > 0 and h.Health < h.MaxHealth*0.25 then hrp.CFrame = phrp.CFrame*CFrame.new(3,0,3); LinoriaLib:Notify("TP to "..p.Name, 3); return end end end; LinoriaLib:Notify("No downed players!", 2) end })
UtilTP:AddButton({ Title = "TP to Nearest Ticket", Func = function() local hrp = getHRP(); if not hrp then return end; local c, cd = nil, math.huge; local kws = {"ticket","coin","gem","star","badge","token","collectible","pickup","reward"}; for _, o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") or o:IsA("Model") then local n = o.Name:lower(); for _, kw in ipairs(kws) do if n:find(kw) then local pos = (o:IsA("Model") and o:GetBoundingBox()) or o.Position; if pos then local d = (pos-hrp.Position).Magnitude; if d < cd then cd = d; c = o end end; break end end end end; if c then local pos = (c:IsA("Model") and (c:GetBoundingBox()+Vector3.new(0,3,0))) or (c.Position+Vector3.new(0,3,0)); hrp.CFrame = CFrame.new(pos); LinoriaLib:Notify("TP to "..c.Name, 3) else LinoriaLib:Notify("None found!", 2) end end })
UtilTP:AddButton({ Title = "TP to Nearest Nextbot", Func = function() local hrp = getHRP(); if not hrp then return end; local c, cd = nil, math.huge; local kws = {"nextbot","npc","bot","enemy","zombie","monster","chaser","entity"}; for _, o in pairs(workspace:GetDescendants()) do local n = o.Name:lower(); for _, kw in ipairs(kws) do if n:find(kw) then local p = (o:IsA("BasePart") and o) or (o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildOfClass("BasePart"))); if p then local d = (p.Position-hrp.Position).Magnitude; if d < cd then cd = d; c = p end end; break end end end; if c then hrp.CFrame = CFrame.new(c.Position+Vector3.new(5,3,0)); LinoriaLib:Notify("TP to "..c.Name, 3) else LinoriaLib:Notify("None found!", 2) end end })

UtilObj:AddButton({ Title = "Find Objectives", Func = function() local hrp = getHRP(); if not hrp then return end; local kws = {"objective","goal","target","mission","task","checkpoint","flag","waypoint","marker"}; local f = {}; for _, o in pairs(workspace:GetDescendants()) do local n = o.Name:lower(); for _, kw in ipairs(kws) do if n:find(kw) then local pos = (o:IsA("BasePart") and o.Position) or (o:IsA("Model") and o:FindFirstChildOfClass("BasePart") and o:FindFirstChildOfClass("BasePart").Position); if pos then table.insert(f, o.Name.." @"..math.floor((pos-hrp.Position).Magnitude).."m") end; break end end end; if #f > 0 then LinoriaLib:Notify(#f.." found (see F9)", 5); print("[HENQ] Objectives:"); for _, s in ipairs(f) do print("  "..s) end else LinoriaLib:Notify("None found!", 3) end end })
UtilObj:AddButton({ Title = "TP to Nearest Objective", Func = function() local hrp = getHRP(); if not hrp then return end; local kws = {"objective","goal","target","mission","task","checkpoint","flag","waypoint","marker"}; local c, cd, cp = nil, math.huge, nil; for _, o in pairs(workspace:GetDescendants()) do local n = o.Name:lower(); for _, kw in ipairs(kws) do if n:find(kw) then local pos = (o:IsA("BasePart") and o.Position) or (o:IsA("Model") and o:FindFirstChildOfClass("BasePart") and o:FindFirstChildOfClass("BasePart").Position); if pos then local d = (pos-hrp.Position).Magnitude; if d < cd then cd = d; c = o; cp = pos end end; break end end end; if c and cp then hrp.CFrame = CFrame.new(cp+Vector3.new(0,5,0)); LinoriaLib:Notify("TP to "..c.Name, 3) else LinoriaLib:Notify("None found!", 2) end end })

-- === UI SETTINGS ===
local themes = {"Dark", "Darker", "Darkest", "Amethyst", "Blood", "Green", "Light"}
UISet:AddDropdown("ThemeSelect", { Text = "Theme", Default = 1, Values = themes, Callback = function(v) LinoriaLib:SetTheme(themes[v]) end })
UISet:AddButton({ Title = "Save UI Config", Func = function() LinoriaLib:SaveConfig() end })
UISet:AddButton({ Title = "Load UI Config", Func = function() LinoriaLib:LoadConfig() end })

-- Keybind to toggle UI (X / RightShift)
local uiToggle = UIS.InputBegan:Connect(function(inp, gp) if gp then return end; if inp.KeyCode == Enum.KeyCode.X or inp.KeyCode == Enum.KeyCode.RightShift then Window:Toggle() end end)

player.CharacterAdded:Connect(function() task.wait(1); if Toggles.WalkSpeed.Value then local h = getHum(); if h then h.WalkSpeed = walkSpd end end; if Toggles.JumpPower.Value then local h = getHum(); if h then h.JumpPower = jumpPow end end end)

LinoriaLib:Notify("HENQ Ware loaded! X / R-Shift to toggle", 5)
