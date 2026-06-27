-- HENQ Ware v3
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local P = game:GetService("Players")
local L = game:GetService("Lighting")
local RepS = game:GetService("ReplicatedStorage")
local plr = P.LocalPlayer
local pg = plr:WaitForChild("PlayerGui")
local cam = workspace.CurrentCamera

local gui = Instance.new("ScreenGui"); gui.Name = "HENQWare"; gui.ResetOnSpawn = false; gui.Parent = pg

local win = Instance.new("Frame"); win.Size = UDim2.new(0,580,0,350); win.Position = UDim2.new(0.5,-290,0.5,-175); win.BackgroundColor3 = Color3.fromRGB(20,20,28); win.BorderSizePixel = 0; win.Active = true; win.Draggable = true; win.Visible = true; win.Parent = gui

local tbar = Instance.new("Frame"); tbar.Size = UDim2.new(1,0,0,28); tbar.BackgroundColor3 = Color3.fromRGB(28,28,38); tbar.BorderSizePixel = 0; tbar.Parent = win
local ttl = Instance.new("TextLabel"); ttl.Size = UDim2.new(1,0,1,0); ttl.BackgroundTransparent = true; ttl.Text = "HENQ Ware"; ttl.TextColor3 = Color3.fromRGB(180,150,255); ttl.Font = Enum.Font.GothamBold; ttl.TextSize = 15; ttl.Parent = tbar

local tabBar = Instance.new("Frame"); tabBar.Size = UDim2.new(1,0,0,28); tabBar.Position = UDim2.new(0,0,0,28); tabBar.BackgroundColor3 = Color3.fromRGB(24,24,34); tabBar.BorderSizePixel = 0; tabBar.Parent = win
local tl = Instance.new("UIListLayout", tabBar); tl.FillDirection = Enum.FillDirection.Horizontal; tl.Padding = UDim.new(0,2); tl.VerticalAlignment = Enum.VerticalAlignment.Center

local tabs = {}; local curTab = nil

local function switchTab(name)
    if curTab == name then return end
    for k, v in pairs(tabs) do
        v.btn.BackgroundColor3 = Color3.fromRGB(24,24,34)
        v.btn.TextColor3 = Color3.fromRGB(160,160,180)
        if v.sf then v.sf.Visible = false end
    end
    if tabs[name] then
        tabs[name].btn.BackgroundColor3 = Color3.fromRGB(180,150,255)
        tabs[name].btn.TextColor3 = Color3.fromRGB(255,255,255)
        tabs[name].sf.Visible = true
        curTab = name
    end
end

local function addTab(name)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0,0,0,22); btn.AutomaticSize = Enum.AutomaticSize.X; btn.BackgroundColor3 = Color3.fromRGB(24,24,34); btn.BorderSizePixel = 0; btn.Text = "  "..name.."  "; btn.TextColor3 = Color3.fromRGB(160,160,180); btn.Font = Enum.Font.Gotham; btn.TextSize = 13; btn.Parent = tabBar
    local sf = Instance.new("ScrollingFrame"); sf.Size = UDim2.new(1,-10,1,-66); sf.Position = UDim2.new(0,5,0,62); sf.BackgroundColor3 = Color3.fromRGB(24,24,34); sf.BorderSizePixel = 0; sf.ScrollBarThickness = 4; sf.ScrollBarImageColor3 = Color3.fromRGB(180,150,255); sf.CanvasSize = UDim2.new(0,0,0,0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y; sf.Visible = false; sf.Parent = win
    local pad = Instance.new("UIPadding", sf); pad.PaddingLeft = UDim.new(0,6); pad.PaddingTop = UDim.new(0,6)
    local lay = Instance.new("UIListLayout", sf); lay.Padding = UDim.new(0,6); lay.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabs[name] = {btn=btn, sf=sf, lay=lay}
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    return sf, lay
end

local function addSec(parent, title)
    local sec = Instance.new("Frame"); sec.Size = UDim2.new(1,-6,0,0); sec.AutomaticSize = Enum.AutomaticSize.Y; sec.BackgroundColor3 = Color3.fromRGB(28,28,38); sec.BorderSizePixel = 0; sec.Parent = parent
    Instance.new("UIStroke", sec).Color = Color3.fromRGB(45,45,58)
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-10,0,22); lbl.Position = UDim2.new(0,8,0,3); lbl.BackgroundTransparent = true; lbl.Text = title; lbl.TextColor3 = Color3.fromRGB(180,150,255); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = sec
    local inner = Instance.new("Frame"); inner.Size = UDim2.new(1,-10,0,0); inner.Position = UDim2.new(0,8,0,26); inner.AutomaticSize = Enum.AutomaticSize.Y; inner.BackgroundTransparent = true; inner.BorderSizePixel = 0; inner.Parent = sec
    local il = Instance.new("UIListLayout", inner); il.Padding = UDim.new(0,3)
    return inner
end

local tv = {}
local function addTog(parent, id, label)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,24); f.BackgroundTransparent = true; f.Parent = parent
    local bx = Instance.new("Frame"); bx.Size = UDim2.new(0,14,0,14); bx.Position = UDim2.new(0,0,0.5,-7); bx.BackgroundColor3 = Color3.fromRGB(55,55,70); bx.BorderSizePixel = 0; bx.Parent = f
    local fl = Instance.new("Frame"); fl.Size = UDim2.new(1,-3,1,-3); fl.Position = UDim2.new(0,1.5,0,1.5); fl.BackgroundColor3 = Color3.fromRGB(180,150,255); fl.BorderSizePixel = 0; fl.Visible = false; fl.Parent = bx
    local tx = Instance.new("TextLabel"); tx.Size = UDim2.new(1,-20,1,0); tx.Position = UDim2.new(0,20,0,0); tx.BackgroundTransparent = true; tx.Text = label; tx.TextColor3 = Color3.fromRGB(200,200,215); tx.Font = Enum.Font.Gotham; tx.TextSize = 13; tx.TextXAlignment = Enum.TextXAlignment.Left; tx.Parent = f
    local b = Instance.new("TextButton"); b.Size = UDim2.new(1,0,1,0); b.BackgroundTransparent = true; b.Text = ""; b.Parent = f
    local val = false; tv[id] = false
    b.MouseButton1Click:Connect(function() val = not val; tv[id] = val; fl.Visible = val; bx.BackgroundColor3 = val and Color3.fromRGB(180,150,255) or Color3.fromRGB(55,55,70); if tv[id.."_cb"] then tv[id.."_cb"](val) end end)
    return {get=function() return val end, set=function(v) val=v;tv[id]=v;fl.Visible=v;bx.BackgroundColor3=v and Color3.fromRGB(180,150,255) or Color3.fromRGB(55,55,70) end}
end

local function addBtn(parent, text, cb)
    local b = Instance.new("TextButton"); b.Size = UDim2.new(1,0,0,26); b.BackgroundColor3 = Color3.fromRGB(40,40,52); b.BorderSizePixel = 0; b.Text = text; b.TextColor3 = Color3.fromRGB(200,200,215); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = parent
    Instance.new("UIStroke", b).Color = Color3.fromRGB(55,55,70)
    b.MouseButton1Click:Connect(cb)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(50,50,65) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(40,40,52) end)
    return b
end

local function notify(msg, t)
    local n = Instance.new("Frame", gui); n.Size = UDim2.new(0,280,0,32); n.Position = UDim2.new(0.5,-140,0,10); n.BackgroundColor3 = Color3.fromRGB(28,28,38); n.BorderSizePixel = 0
    Instance.new("UIStroke", n).Color = Color3.fromRGB(180,150,255)
    local nt = Instance.new("TextLabel"); nt.Size = UDim2.new(1,-10,1,0); nt.Position = UDim2.new(0,5,0,0); nt.BackgroundTransparent = true; nt.Text = msg; nt.TextColor3 = Color3.fromRGB(255,255,255); nt.Font = Enum.Font.Gotham; nt.TextSize = 13; nt.TextXAlignment = Enum.TextXAlignment.Left; nt.Parent = n
    spawn(function() task.wait(t or 3); for i=1,10 do n.BackgroundTransparency=i/10; nt.TextTransparency=i/10; n.Position=n.Position+UDim2.new(0,0,0,-2); task.wait(0.03) end; n:Destroy() end)
end

local function gC() return plr.Character end
local function gH() local c=gC(); return c and c:FindFirstChild("HumanoidRootPart") end
local function gU() local c=gC(); return c and c:FindFirstChildOfClass("Humanoid") end
local function fm(s,p) s=s:lower();p=p:lower();if s:find(p,1,true) then return true end;local si=1;for i=1,#p do local ch=p:sub(i,i);local f=false;while si<=#s do if s:sub(si,si)==ch then f=true;si=si+1;break end;si=si+1 end;if not f then return false end end;return true end

local conns = {}
local function dc(n) if conns[n] then conns[n]:Disconnect(); conns[n]=nil end end

local function isAtEdge(hrp)
    local rp = RaycastParams.new(); rp.FilterDescendantsInstances = {gC()}; rp.FilterType = Enum.RaycastFilterType.Exclude
    local offs = {Vector3.new(2.5,0,0),Vector3.new(-2.5,0,0),Vector3.new(0,0,2.5),Vector3.new(0,0,-2.5),Vector3.new(2,0,2),Vector3.new(-2,0,2),Vector3.new(2,0,-2),Vector3.new(-2,0,-2),Vector3.new(1.5,0,0),Vector3.new(-1.5,0,0),Vector3.new(0,0,1.5),Vector3.new(0,0,-1.5)}
    local hit,miss=0,0
    for _,o in ipairs(offs) do local r=workspace:Raycast(hrp.Position+o,Vector3.new(0,-5,0),rp); if r then hit=hit+1 else miss=miss+1 end end
    return miss>0 and hit>0
end

-- === BUILD UI ===
local sf1, _ = addTab("Main")
local sf2, _ = addTab("Player")
local sf3, _ = addTab("Visuals")
local sf4, _ = addTab("Fun")
local sf5, _ = addTab("Misc")
local sf6, _ = addTab("Utility")

-- Main
local mv = addSec(sf1, "Movement")
local cu = addSec(sf1, "Custom")
local ot = addSec(sf1, "Other")

local strafeMult = 120
addTog(mv,"AirStrafe","Air Strafe"); tv.AirStrafe_cb = function(v)
    dc("AirStrafe")
    if v then
        local last = cam.CFrame.LookVector
        conns.AirStrafe = RS.Heartbeat:Connect(function(dt)
            local hrp,hum=gH(),gU(); if not hrp or not hum then return end
            local cur=cam.CFrame.LookVector; local f=Vector3.new(cur.X,0,cur.Z).Unit; local d=math.abs(cur.X-last.X)+math.abs(cur.Z-last.Z)
            if hum.FloorMaterial==Enum.Material.Air and d>0.0005 then
                local vel=hrp.AssemblyLinearVelocity; local hspd=Vector3.new(vel.X,0,vel.Z).Magnitude
                local boost=f*(hspd+((strafeMult*d)/dt)*0.01)
                hrp.AssemblyLinearVelocity=Vector3.new(vel.X+(boost.X*d*8),vel.Y,vel.Z+(boost.Z*d*8))
            end; last=cur
        end)
    end
end

local bouncePow = 100
addTog(mv,"EasyBounce","Easy Bounce (Edge)"); tv.EasyBounce_cb = function(v)
    dc("EasyBounce")
    if v then conns.EasyBounce=RS.Heartbeat:Connect(function() local hrp,hum=gH(),gU(); if hrp and hum and hum.FloorMaterial~=Enum.Material.Air and isAtEdge(hrp) then hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,bouncePow,hrp.AssemblyLinearVelocity.Z) end end) end
end

local vsMult = 120
addTog(mv,"VirtualStrafe","Virtual Strafe"); tv.VirtualStrafe_cb = function(v)
    dc("VirtualStrafe")
    if v then conns.VirtualStrafe=cam:GetPropertyChangedSignal("CFrame"):Connect(function() local hrp=gH(); if hrp then local lk=cam.CFrame.LookVector; hrp.AssemblyLinearVelocity=Vector3.new(lk.X*vsMult,hrp.AssemblyLinearVelocity.Y,lk.Z*vsMult) end end) end
end

local trimpP = 80
addTog(mv,"AutoTrimp","Auto Trimp"); tv.AutoTrimp_cb = function(v)
    dc("AutoTrimp")
    if v then conns.AutoTrimp=RS.Heartbeat:Connect(function() local hrp,hum=gH(),gU(); if hrp and hum and hum.FloorMaterial==Enum.Material.Air then hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,trimpP,hrp.AssemblyLinearVelocity.Z) end end) end
end

addTog(mv,"EmoteMove","Non-Moveable Emotes"); tv.EmoteMove_cb = function(v)
    dc("EmoteMove")
    if v then conns.EmoteMove=RS.Heartbeat:Connect(function() local hum=gU(); if hum then local md=hum.MoveDirection; if md.Magnitude>0 then local hrp=gH(); if hrp then hrp.AssemblyLinearVelocity=Vector3.new(md.X*hum.WalkSpeed,hrp.AssemblyLinearVelocity.Y,md.Z*hum.WalkSpeed) end end end end) end
end

-- Edge Boost
addBtn(cu,"Easy Edge Boost (U toggle)",function()
    if _G.EB_L then if _G.EB_C then _G.EB_C:Disconnect() end; if _G.EB_I then _G.EB_I:Disconnect() end; _G.EB_L=false; notify("Edge Boost disabled",2); return end
    _G.EB_L=true; _G.EB_E=true; local BP=100
    local function gch() local c=plr.Character or plr.CharacterAdded:Wait(); local hrp=c:WaitForChild("HumanoidRootPart"); local h=c:WaitForChild("Humanoid"); return c,hrp,h end
    local ch,hrp,hum=gch()
    local function isBP(p) local n=p.Name:lower(); for _,kw in pairs({"bounce","boost","launch","jump","pad","ramp","platform"}) do if n:find(kw) then return true end end; if p.Parent then local pn=p.Parent.Name:lower(); for _,kw in pairs({"bounce","boost","launch","jump","pad","ramp","platform"}) do if pn:find(kw) then return true end end end; return false end
    _G.EB_C=RS.Stepped:Connect(function() if not _G.EB_E or not hrp or not hum or hum.Health<=0 then return end; if hrp.AssemblyLinearVelocity.Y<-1 then local pts=hrp:GetTouchingParts(); local edge,bnc=false,false; for _,p in pairs(pts) do if isBP(p) then bnc=true;break end end; if not bnc then edge=true end; if edge then hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z)+Vector3.new(0,BP,0) end end end)
    _G.EB_I=UIS.InputBegan:Connect(function(inp,gp) if gp then return end; if inp.KeyCode==Enum.KeyCode.U then _G.EB_E=not _G.EB_E; if _G.EB_E then ch,hrp,hum=gch(); notify("Edge Boost enabled",3) else notify("Edge Boost disabled",3) end end end)
    notify("Edge Boost enabled! (U toggle)",3)
end)

-- Easy Hop
local hbX,hbY,hbZ=6,3,6; local hbF=nil
local function gHgh(o) local h,my=nil,-math.huge; local function ck(p) if p:IsA("BasePart") then local t=p.Position.Y+p.Size.Y/2; if t>my then my=t;h=p end end end; ck(o); for _,d in pairs(o:GetDescendants()) do ck(d) end; return h end
local function cAABB(t)
    local mix,miy,miz=math.huge,math.huge,math.huge; local mxx,mxy,mxz=-math.huge,-math.huge,-math.huge; local ps={}; if t:IsA("BasePart") then table.insert(ps,t) end; for _,d in pairs(t:GetDescendants()) do if d:IsA("BasePart") then table.insert(ps,d) end end; if #ps==0 then return nil end
    for _,p in ipairs(ps) do local cf,s=p.CFrame,p.Size/2; for _,c in ipairs({cf*Vector3.new(s.X,s.Y,s.Z),cf*Vector3.new(-s.X,s.Y,s.Z),cf*Vector3.new(s.X,-s.Y,s.Z),cf*Vector3.new(-s.X,-s.Y,s.Z),cf*Vector3.new(s.X,s.Y,-s.Z),cf*Vector3.new(-s.X,s.Y,-s.Z),cf*Vector3.new(s.X,-s.Y,-s.Z),cf*Vector3.new(-s.X,-s.Y,-s.Z)}) do mix=math.min(mix,c.X);miy=math.min(miy,c.Y);miz=math.min(miz,c.Z);mxx=math.max(mxx,c.X);mxy=math.max(mxy,c.Y);mxz=math.max(mxz,c.Z) end end
    return Vector3.new((mxx+mix)/2,(mxy+miy)/2,(mxz+miz)/2), Vector3.new(mxx-mix,mxy-miy,mxz-miz)
end
addTog(cu,"EasyHop","Easy Hop"); tv.EasyHop_cb = function(v)
    if hbF then hbF:Destroy(); hbF=nil end
    if v then
        hbF=Instance.new("Folder"); hbF.Name="AABB_Wireframe_Folder"; hbF.Parent=workspace; local cnt=0
        pcall(function() local gf=workspace:FindFirstChild("Game"); if gf then local m=gf:FindFirstChild("Map"); local p=m and m:FindFirstChild("Parts"); local pr=p and p:FindFirstChild("ImmovableProps"); if pr then for _,o in pairs(pr:GetChildren()) do if o.Name:find("Cactus") or o.Name:find("Fence") or o.Name:find("Wall") then local t=gHgh(o); if t then local c,s=cAABB(t); if c and s then local bx=Instance.new("Part"); bx.Size=s+Vector3.new(hbX,hbY,hbZ); bx.Position=c; bx.Anchored=true; bx.CanCollide=true; bx.Transparency=1; bx.Parent=hbF; cnt=cnt+1 end end end end end end end)
        notify("Easy Hop: "..cnt.." objects expanded",3)
    end
end

-- Remove Walls
local dw = {}
addBtn(cu,"Remove Invisible Walls",function() local r=0;local ch=gC();for _,o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") and o.Transparency==1 and o.CanCollide then if not(ch and o:IsDescendantOf(ch)) then o.CanCollide=false;table.insert(dw,o);r=r+1 end end end;notify("Removed "..r.." wall(s)",4) end)
addBtn(cu,"Restore Walls",function() local r=0;for _,p in ipairs(dw) do if p and p.Parent then p.CanCollide=true;r=r+1 end end;dw={};notify("Restored "..r.." wall(s)",4) end)

addBtn(ot,"Apply Evade Speed",function() notify("Placeholder: set speed",3) end)

-- Player
local pm = addSec(sf2, "Movement")
local pc = addSec(sf2, "Camera")

local walkSpd = 16
addTog(pm,"WalkSpeed","Walk Speed"); tv.WalkSpeed_cb = function(v)
    dc("WalkSpeed")
    if v then conns.WalkSpeed=RS.Heartbeat:Connect(function() local h=gU(); if h then h.WalkSpeed=walkSpd end end) else local h=gU(); if h then h.WalkSpeed=16 end end
end

local jumpPow = 50
addTog(pm,"JumpPower","Jump Power"); tv.JumpPower_cb = function(v)
    dc("JumpPower")
    if v then conns.JumpPower=RS.Heartbeat:Connect(function() local h=gU(); if h then h.JumpPower=jumpPow end end) else local h=gU(); if h then h.JumpPower=50 end end
end

local sprintSpd = 32
addTog(pm,"Sprint","Sprint (Hold Shift)"); tv.Sprint_cb = function(v)
    dc("Sprint")
    if v then conns.Sprint=RS.Heartbeat:Connect(function() local h=gU(); if h then if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then h.WalkSpeed=sprintSpd elseif not tv.WalkSpeed then h.WalkSpeed=16 end end end) end
end

addTog(pc,"NoShake","Disable Cam Shake"); tv.NoShake_cb = function(v)
    dc("NoShake")
    if v then conns.NoShake=RS.RenderStepped:Connect(function() local c=workspace.CurrentCamera; c.CFrame=CFrame.lookAt(c.CFrame.Position,c.CFrame.Position+c.CFrame.LookVector,Vector3.new(0,1,0)) end) end
end

addTog(pc,"FullBright","Full Bright"); tv.FullBright_cb = function(v)
    if v then L.Brightness=3;L.Ambient=Color3.fromRGB(255,255,255);L.OutdoorAmbient=Color3.fromRGB(255,255,255);L.GlobalShadows=false else L.Brightness=1;L.Ambient=Color3.fromRGB(200,200,200);L.OutdoorAmbient=Color3.fromRGB(200,200,200);L.GlobalShadows=true end
end

local ofe,ofs=nil,nil
addTog(pc,"NoFog","Remove Fog"); tv.NoFog_cb = function(v)
    if v then ofe=L.FogEnd;ofs=L.FogStart;L.FogEnd=100000;L.FogStart=99999 else L.FogEnd=ofe or 100000;L.FogStart=ofs or 0 end
end

-- Visuals
local vw = addSec(sf3, "World")
local vc = addSec(sf3, "Cosmetics")

addTog(vw,"PlayerESP","Player ESP"); tv.PlayerESP_cb = function(v)
    if _G.espF then _G.espF:Destroy(); _G.espF=nil end
    if v then
        _G.espF=Instance.new("Folder"); _G.espF.Name="PlayerESP"; _G.espF.Parent=workspace
        for _,p in pairs(P:GetPlayers()) do if p~=plr and p.Character then local h=Instance.new("Highlight"); h.FillColor=Color3.fromRGB(0,255,0);h.OutlineColor=Color3.fromRGB(0,255,0);h.FillTransparency=0.3;h.OutlineTransparency=0;h.Adornee=p.Character;h.Parent=_G.espF end end
    end
end

addTog(vw,"RGB","RGB Mode"); tv.RGB_cb = function(v)
    dc("RGB")
    if v then
        local rg=Instance.new("ScreenGui");rg.Name="RGBMode";rg.ResetOnSpawn=false;rg.Parent=pg
        local rf=Instance.new("Frame",rg);rf.Size=UDim2.new(1,0,1,0);rf.BackgroundTransparency=0.92;rf.BorderSizePixel=0;local t=0
        conns.RGB=RS.RenderStepped:Connect(function(dt) t=t+dt*0.5;rf.BackgroundColor3=Color3.fromHSV(t%1,1,1) end)
        _G.RGBGui=rg
    else if _G.RGBGui then _G.RGBGui:Destroy();_G.RGBGui=nil end end
end

-- Emote Swap
local e1,e2,oe1,oe2,eSwapped="","","","",false
local function norm(s) return s:gsub("%s+",""):lower() end
local function lev(s,t) local m,n=#s,#t;local d={};for i=0,m do d[i]={[0]=i} end;for j=0,n do d[0][j]=j end;for i=1,m do for j=1,n do local c=(s:sub(i,i)==t:sub(j,j)) and 0 or 1;d[i][j]=math.min(d[i-1][j]+1,d[i][j-1]+1,d[i-1][j-1]+c) end end;return d[m][n] end
local function sim(s,t) local nS,nT=norm(s),norm(t);return 1-(lev(nS,nT)/math.max(#nS,#nT)) end
local function fB(name) local em=RepS:FindFirstChild("Items");if not em then return name end;em=em:FindFirstChild("Emotes");if not em then return name end;local b,bs=name,0.5;for _,c in ipairs(em:GetChildren()) do local s=sim(name,c.Name);if s>bs then bs=s;b=c.Name end end;return b end
local function fBU(name) local it=RepS:FindFirstChild("Items");if not it then return name end;local un=it:FindFirstChild("Unusual");if not un then return name end;local b,bs=name,0.5;for _,c in ipairs(un:GetChildren()) do local s=sim(name,c.Name);if s>bs then bs=s;b=c.Name end end;return b end
local function fBC(name) local it=RepS:FindFirstChild("Items");if not it then return name end;local co=it:FindFirstChild("Cosmetics");if not co then return name end;local b,bs=name,0.5;for _,c in ipairs(co:GetChildren()) do local s=sim(name,c.Name);if s>bs then bs=s;b=c.Name end end;return b end
addBtn(vc,"Apply Emote Swap",function()
    pcall(function() if e1=="" or e2=="" or e1==e2 then notify("Enter two different emotes!",3);return end;local em=RepS:WaitForChild("Items"):WaitForChild("Emotes");local aN=fB(e1);local bN=fB(e2);local a,b=em:FindFirstChild(aN),em:FindFirstChild(bN);if not a or not b then notify("Emotes not found!",3);return end;if not eSwapped then oe1=aN;oe2=bN end;local tr=Instance.new("Folder",em);tr.Name="__t_"..tostring(tick()):gsub("%.","_");local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr);for _,c in ipairs(a:GetChildren()) do c.Parent=ta end;for _,c in ipairs(b:GetChildren()) do c.Parent=tb end;for _,c in ipairs(ta:GetChildren()) do c.Parent=b end;for _,c in ipairs(tb:GetChildren()) do c.Parent=a end;tr:Destroy();eSwapped=true;notify("Swapped '"..aN.."' with '"..bN.."'",3) end)
end)
addBtn(vc,"Reset Emote Swap",function()
    pcall(function() if not eSwapped then notify("No emotes swapped!",3);return end;local em=RepS:WaitForChild("Items"):WaitForChild("Emotes");local a,b=em:FindFirstChild(e1),em:FindFirstChild(e2);if a and b then local tr=Instance.new("Folder",em);tr.Name="__t_"..tostring(tick()):gsub("%.","_");local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr);for _,c in ipairs(a:GetChildren()) do c.Parent=ta end;for _,c in ipairs(b:GetChildren()) do c.Parent=tb end;for _,c in ipairs(ta:GetChildren()) do c.Parent=b end;for _,c in ipairs(tb:GetChildren()) do c.Parent=a end;tr:Destroy() end;eSwapped=false;notify("Reset to original",3) end)
end)
addBtn(vc,"Apply Unusual Swap",function()
    pcall(function() local un=RepS:WaitForChild("Items"):WaitForChild("Unusual");if not un then notify("Unusual folder not found",3);return end;local aN,bN=fBU(e1 or ""),fBU(e2 or "");local a,b=un:FindFirstChild(aN),un:FindFirstChild(bN);if not a or not b then notify("Items not found!",3);return end;local tr=Instance.new("Folder",un);tr.Name="__t_"..tostring(tick()):gsub("%.","_");local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr);for _,c in ipairs(a:GetChildren()) do c.Parent=ta end;for _,c in ipairs(b:GetChildren()) do c.Parent=tb end;for _,c in ipairs(ta:GetChildren()) do c.Parent=b end;for _,c in ipairs(tb:GetChildren()) do c.Parent=a end;tr:Destroy();notify("Swapped '"..aN.."' with '"..bN.."'",3) end)
end)
addBtn(vc,"Apply Cosmetic Swap",function()
    pcall(function() local co=RepS:WaitForChild("Items"):WaitForChild("Cosmetics");if not co then notify("Cosmetics folder not found",3);return end;local aN,bN=fBC(e1 or ""),fBC(e2 or "");local a,b=co:FindFirstChild(aN),co:FindFirstChild(bN);if not a or not b then notify("Cosmetics not found!",3);return end;local tr=Instance.new("Folder",co);tr.Name="__t_"..tostring(tick()):gsub("%.","_");local ta,tb=Instance.new("Folder",tr),Instance.new("Folder",tr);for _,c in ipairs(a:GetChildren()) do c.Parent=ta end;for _,c in ipairs(b:GetChildren()) do c.Parent=tb end;for _,c in ipairs(ta:GetChildren()) do c.Parent=b end;for _,c in ipairs(tb:GetChildren()) do c.Parent=a end;tr:Destroy();notify("Swapped '"..aN.."' with '"..bN.."'",3) end)
end)
addBtn(vc,"Headless (Local)",function()
    pcall(function() local ch=gC();if not ch then return end;local h=ch:FindFirstChild("Head");if h then h.Transparency=1 end;local f=h and h:FindFirstChild("face");if f then f.Transparency=1 end;for _,o in pairs(ch:GetDescendants()) do if (o.Name:lower():find("hair") or o.Name:lower():find("hat")) and o:IsA("BasePart") then o.Transparency=1 end end;notify("Headless applied",3) end)
end)

-- Fun
local fn = addSec(sf4, "Legacy")
addBtn(fn,"Play Old Run Animation",function() pcall(function() local h=gU();if h then local a=Instance.new("Animation");a.AnimationId="rbxassetid://180426354";h:LoadAnimation(a):Play() end end) end)
addBtn(fn,"Play Old Idle Animation",function() pcall(function() local h=gU();if h then local a=Instance.new("Animation");a.AnimationId="rbxassetid://180435571";h:LoadAnimation(a):Play() end end) end)
addTog(fn,"LegacyNoClip","Legacy No-Clip"); tv.LegacyNoClip_cb = function(v)
    dc("LegacyNoClip")
    if v then conns.LegacyNoClip=RS.Stepped:Connect(function() local ch=gC();if ch then for _,p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end) else local ch=gC();if ch then for _,p in pairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end
end

-- Misc
local mf = addSec(sf5, "Config")
local mi = addSec(sf5, "Info")
local mc = addSec(sf5, "Character")

addBtn(mf,"Save Config",function() pcall(function() if not isfolder("HENQWare") then makefolder("HENQWare") end; writefile("HENQWare/config.json",game:GetService("HttpService"):JSONEncode({})); notify("Saved!",2) end) end)
addBtn(mf,"Load Config",function() pcall(function() notify("Placeholder",2) end) end)
addBtn(mi,"Game Info",function() notify("Game: "..game.Name.." | ID: "..game.PlaceId.." | Players: "..#P:GetPlayers(),5) end)
addBtn(mi,"Player Stats",function() local h,hrp=gU(),gH();if not h or not hrp then notify("No character!",2);return end;local v=hrp.AssemblyLinearVelocity;local spd=math.floor(math.sqrt(v.X^2+v.Z^2));notify("HP: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth).." | SPD: "..spd,5) end)
addBtn(mc,"Reset Character",function() local h=gU();if h then h.Health=0 end end)
addBtn(mc,"Rejoin Server",function() notify("Rejoining...",2);task.delay(1,function() game:GetService("TeleportService"):Teleport(game.PlaceId,plr) end) end)

-- Utility
local ut = addSec(sf6, "Teleport")
addBtn(ut,"Teleport Spawn",function() local hrp=gH();if hrp then hrp.CFrame=CFrame.new(0,10,0) end end)
addBtn(ut,"TP to Downed",function() local hrp=gH();if not hrp then return end;for _,p in pairs(P:GetPlayers()) do if p~=plr and p.Character then local h,ph=p.Character:FindFirstChildOfClass("Humanoid"),p.Character:FindFirstChild("HumanoidRootPart");if h and ph and h.Health>0 and h.Health<h.MaxHealth*0.25 then hrp.CFrame=ph.CFrame*CFrame.new(3,0,3);notify("TP to "..p.Name,3);return end end end;notify("No downed players!",2) end)
addBtn(ut,"TP to Nearest Ticket",function() local hrp=gH();if not hrp then return end;local c,cd=nil,math.huge;local kws={"ticket","coin","gem","star","badge","token","collectible","pickup","reward"};for _,o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") or o:IsA("Model") then local n=o.Name:lower();for _,kw in ipairs(kws) do if n:find(kw) then local pos=(o:IsA("Model") and o:GetBoundingBox()) or o.Position;if pos then local d=(pos-hrp.Position).Magnitude;if d<cd then cd=d;c=o end end;break end end end end;if c then local pos=(c:IsA("Model") and (c:GetBoundingBox()+Vector3.new(0,3,0))) or (c.Position+Vector3.new(0,3,0));hrp.CFrame=CFrame.new(pos);notify("TP to "..c.Name,3) else notify("None found!",2) end end)
addBtn(ut,"TP to Nearest Nextbot",function() local hrp=gH();if not hrp then return end;local c,cd=nil,math.huge;local kws={"nextbot","npc","bot","enemy","zombie","monster","chaser","entity"};for _,o in pairs(workspace:GetDescendants()) do local n=o.Name:lower();for _,kw in ipairs(kws) do if n:find(kw) then local p=(o:IsA("BasePart") and o) or (o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildOfClass("BasePart")));if p then local d=(p.Position-hrp.Position).Magnitude;if d<cd then cd=d;c=p end end;break end end end;if c then hrp.CFrame=CFrame.new(c.Position+Vector3.new(5,3,0));notify("TP to "..c.Name,3) else notify("None found!",2) end end)
addBtn(ut,"TP to Nearest Objective",function() local hrp=gH();if not hrp then return end;local kws={"objective","goal","target","mission","task","checkpoint","flag","waypoint","marker"};local c,cd,cp=nil,math.huge,nil;for _,o in pairs(workspace:GetDescendants()) do local n=o.Name:lower();for _,kw in ipairs(kws) do if n:find(kw) then local pos=(o:IsA("BasePart") and o.Position) or (o:IsA("Model") and o:FindFirstChildOfClass("BasePart") and o:FindFirstChildOfClass("BasePart").Position);if pos then local d=(pos-hrp.Position).Magnitude;if d<cd then cd=d;c=o;cp=pos end end;break end end end;if c and cp then hrp.CFrame=CFrame.new(cp+Vector3.new(0,5,0));notify("TP to "..c.Name,3) else notify("None found!",2) end end)
addBtn(ut,"Find Objectives",function() local hrp=gH();if not hrp then return end;local kws={"objective","goal","target","mission","task","checkpoint","flag","waypoint","marker"};local f={};for _,o in pairs(workspace:GetDescendants()) do local n=o.Name:lower();for _,kw in ipairs(kws) do if n:find(kw) then local pos=(o:IsA("BasePart") and o.Position) or (o:IsA("Model") and o:FindFirstChildOfClass("BasePart") and o:FindFirstChildOfClass("BasePart").Position);if pos then table.insert(f,o.Name.." @"..math.floor((pos-hrp.Position).Magnitude).."m") end;break end end end;if #f>0 then notify(#f.." found (see F9)",5);print("[HENQ] Objectives:");for _,s in ipairs(f) do print("  "..s) end else notify("None found!",3) end end)

-- Final
UIS.InputBegan:Connect(function(inp,gp) if gp then return end; if inp.KeyCode==Enum.KeyCode.X or inp.KeyCode==Enum.KeyCode.RightShift then win.Visible=not win.Visible end end)
switchTab("Main")
notify("HENQ Ware loaded! X / R-Shift to toggle",5)
