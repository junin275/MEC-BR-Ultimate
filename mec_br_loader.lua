--[[
    🔑 MEC BR ULTIMATE v3.8 — LOADER + KEY SYSTEM + SCRIPT COMPLETO
    by Chora_Argumento & Petrix
    Baseado em OYB Key System (PlatoBoost + LootLabs)
    
    COMO USAR (loadstring):
    loadstring(game:HttpGet('https://raw.githubusercontent.com/junin275/MEC-BR-Ultimate/v3.8/mec_br_loader.lua'))()
]]

-- =============================================================================
-- 🛠️ CONFIGURAÇÃO
-- =============================================================================
local Config = {
    ServiceId       = 28226,
    PlatoSecret     = "e27fdc82-cb92-4e77-9019-4c96ab19994b",
    Secret          = "MEC_BR_SECRET_2026",
    HubName         = "MEC BR ULTIMATE",
    HubDescription  = "by Chora_Argumento & Petrix",
    KeyFileName     = "MEC_Key.txt",
    MainGuiName     = "",
    OldGuiName      = "",
    ShowDiscord     = false,
    DiscordURL      = "https://discord.gg/7dkp6uhYNb",
    ShowInstagram   = false,
    InstagramURL    = "",
    ShowYoutube     = false,
    YoutubeURL      = "",
}

-- =============================================================================
-- 📦 BIBLIOTECAS (SHA256 + JSON) — OYB
-- =============================================================================
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;

-- =============================================================================
-- 🌐 FUNÇÕES CENTRAIS
-- =============================================================================
local useNonce = true

local function safeRequest(options)
    local req = request or http_request or syn_request or (http and http.request)
    if not req then return nil, "HTTP requests not supported" end
    local success, response = pcall(function() return req(options) end)
    if success and response then return response else return nil, "Connection Error" end
end

local fSetClipboard = setclipboard or toclipboard or function() end
local fStringChar, fToString, fOsTime, fMathRandom, fMathFloor = string.char, tostring, os.time, math.random, math.floor
local TweenService = game:GetService("TweenService")
local fGetHwid = gethwid or function() return game:GetService("RbxAnalyticsService"):GetClientId() end
local cachedLink, cachedTime, host = "", 0, "https://api.platoboost.com"

local function checkConnectivity()
    local response = safeRequest({Url = host .. "/public/connectivity", Method = "GET"})
    if not response or (response.StatusCode ~= 200 and response.StatusCode ~= 429) then host = "https://api.platoboost.net" end
end
checkConnectivity()

local function generateNonce()
    local str = ""
    for _ = 1, 16 do str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97) end
    return str
end

local function cacheLink()
    if cachedTime + (10*60) < fOsTime() then
        local response, err = safeRequest({Url = host .. "/public/start", Method = "POST", Body = lEncode({service = Config.ServiceId, identifier = lDigest(fGetHwid())}), Headers = {["Content-Type"] = "application/json"}})
        if response and response.StatusCode == 200 then local decoded = lDecode(response.Body); if decoded.success then cachedLink = decoded.data.url; cachedTime = fOsTime(); return true, cachedLink end end
        return false, err or "Server Unreachable"
    end
    return true, cachedLink
end

local function redeemKey(key)
    local nonce = generateNonce()
    local body = {identifier = lDigest(fGetHwid()), key = key}
    if useNonce then body.nonce = nonce end
    local response, err = safeRequest({Url = host .. "/public/redeem/" .. fToString(Config.ServiceId), Method = "POST", Body = lEncode(body), Headers = {["Content-Type"] = "application/json"}})
    if response and response.StatusCode == 200 then
        local decoded = lDecode(response.Body)
        if decoded.success and decoded.data.valid then
            if useNonce then
                if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. Config.PlatoSecret) then
                    if writefile then writefile(Config.KeyFileName, key) end; return true, "Success"
                end; return false, "Integrity Check Failed"
            end
            if writefile then writefile(Config.KeyFileName, key) end; return true, "Success"
        end; return false, decoded.message or "Invalid Key"
    end; return false, err or "Server Error"
end

-- =============================================================================
-- 🖥️ INTERFACE GRÁFICA LIMPA
-- =============================================================================
local function CreateGUI()
    local coreGui = game:GetService("CoreGui")
    local player = game:GetService("Players").LocalPlayer
    local targetParent = pcall(function() return coreGui end) and coreGui or player:WaitForChild("PlayerGui")
    if targetParent:FindFirstChild("MEC_KeySystem") then targetParent.MEC_KeySystem:Destroy() end

    local sg = Instance.new("ScreenGui", targetParent)
    sg.Name = "MEC_KeySystem"; sg.ResetOnSpawn = false; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Overlay escuro
    local overlay = Instance.new("Frame", sg)
    overlay.Size = UDim2.new(1, 0, 1, 0); overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.5; overlay.BorderSizePixel = 0; overlay.Active = true

    -- MAIN FRAME
    local mf = Instance.new("Frame", sg)
    mf.Size = UDim2.new(0, 380, 0, 300); mf.Position = UDim2.new(0.5, -190, 0.5, -150)
    mf.BackgroundColor3 = Color3.fromRGB(14, 14, 18); mf.Active = true; mf.Draggable = true
    mf.BorderSizePixel = 0; mf.ClipsDescendants = true
    local mfCorners = Instance.new("UICorner", mf); mfCorners.CornerRadius = UDim.new(0, 14)

    -- Borda neon
    local border = Instance.new("UIStroke", mf)
    border.Thickness = 2; border.Color = Color3.fromRGB(0, 180, 255)
    task.spawn(function()
        while task.wait(0.08) do
            border.Color = Color3.fromHSV(tick() % 5 / 5, 0.9, 1)
        end
    end)

    -- TOPO
    local topBar = Instance.new("Frame", mf)
    topBar.Size = UDim2.new(1, 0, 0, 4); topBar.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    topBar.BorderSizePixel = 0
    local topCorners = Instance.new("UICorner", topBar); topCorners.CornerRadius = UDim.new(0, 14)

    task.spawn(function()
        while task.wait(0.08) do
            topBar.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.9, 1)
        end
    end)

    -- TÍTULO
    local title = Instance.new("TextLabel", mf)
    title.Size = UDim2.new(1, 0, 0, 30); title.Position = UDim2.new(0, 0, 0, 18)
    title.BackgroundTransparency = 1; title.Text = "MEC BR ULTIMATE"
    title.TextColor3 = Color3.new(1, 1, 1); title.Font = Enum.Font.GothamBlack; title.TextSize = 20

    -- SUBTÍTULO
    local sub = Instance.new("TextLabel", mf)
    sub.Size = UDim2.new(1, 0, 0, 16); sub.Position = UDim2.new(0, 0, 0, 48)
    sub.BackgroundTransparency = 1; sub.Text = "by Chora_Argumento & Petrix"
    sub.TextColor3 = Color3.fromRGB(100, 160, 230); sub.Font = Enum.Font.Gotham; sub.TextSize = 11

    -- LINHA
    local line = Instance.new("Frame", mf)
    line.Size = UDim2.new(0.8, 0, 0, 1); line.Position = UDim2.new(0.1, 0, 0, 72)
    line.BackgroundColor3 = Color3.fromRGB(35, 35, 50); line.BorderSizePixel = 0

    -- INPUT TEXTBOX
    local input = Instance.new("TextBox", mf)
    input.Size = UDim2.new(0.8, 0, 0, 40); input.Position = UDim2.new(0.1, 0, 0, 88)
    input.PlaceholderText = "Cole sua key aqui..."; input.Text = ""
    input.Font = Enum.Font.GothamSemibold; input.TextSize = 14; input.TextColor3 = Color3.new(1, 1, 1)
    input.BackgroundColor3 = Color3.fromRGB(22, 22, 30); input.ClearTextOnFocus = false
    local inputCorners = Instance.new("UICorner", input); inputCorners.CornerRadius = UDim.new(0, 8)
    local inputStroke = Instance.new("UIStroke", input); inputStroke.Thickness = 1; inputStroke.Color = Color3.fromRGB(35, 35, 50)

    -- BOTÃO VERIFY
    local verifyBtn = Instance.new("TextButton", mf)
    verifyBtn.Size = UDim2.new(0.38, 0, 0, 40); verifyBtn.Position = UDim2.new(0.1, 0, 0, 145)
    verifyBtn.Text = "VERIFY"; verifyBtn.Font = Enum.Font.GothamBold; verifyBtn.TextSize = 13
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 70); verifyBtn.TextColor3 = Color3.new(1, 1, 1)
    local vCorners = Instance.new("UICorner", verifyBtn); vCorners.CornerRadius = UDim.new(0, 8)
    -- Hover
    verifyBtn.MouseEnter:Connect(function()
        TweenService:Create(verifyBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 200, 85)}):Play()
    end)
    verifyBtn.MouseLeave:Connect(function()
        TweenService:Create(verifyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 170, 70)}):Play()
    end)

    -- BOTÃO GET KEY
    local getKeyBtn = Instance.new("TextButton", mf)
    getKeyBtn.Size = UDim2.new(0.38, 0, 0, 40); getKeyBtn.Position = UDim2.new(0.52, 0, 0, 145)
    getKeyBtn.Text = "GET KEY"; getKeyBtn.Font = Enum.Font.GothamBold; getKeyBtn.TextSize = 13
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 40); getKeyBtn.TextColor3 = Color3.new(1, 1, 1)
    local gCorners = Instance.new("UICorner", getKeyBtn); gCorners.CornerRadius = UDim.new(0, 8)
    local gStroke = Instance.new("UIStroke", getKeyBtn); gStroke.Thickness = 1; gStroke.Color = Color3.fromRGB(40, 40, 55)
    getKeyBtn.MouseEnter:Connect(function()
        TweenService:Create(getKeyBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(38, 38, 52)}):Play()
    end)
    getKeyBtn.MouseLeave:Connect(function()
        TweenService:Create(getKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 40)}):Play()
    end)

    -- STATUS
    local status = Instance.new("TextLabel", mf)
    status.Name = "StatusLabel"
    status.Size = UDim2.new(0.9, 0, 0, 24); status.Position = UDim2.new(0.05, 0, 0, 200)
    status.BackgroundTransparency = 1; status.Text = "🔑 Aguardando chave..."
    status.TextColor3 = Color3.fromRGB(130, 130, 150); status.Font = Enum.Font.Gotham; status.TextSize = 12

    -- LOADING BAR
    local barBg = Instance.new("Frame", mf)
    barBg.Size = UDim2.new(0.8, 0, 0, 3); barBg.Position = UDim2.new(0.1, 0, 0, 232)
    barBg.BackgroundColor3 = Color3.fromRGB(22, 22, 30); barBg.BorderSizePixel = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 4)

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(0, 0, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    bar.BorderSizePixel = 0; bar.BackgroundTransparency = 1
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)
    task.spawn(function()
        while task.wait(0.08) do
            if bar.BackgroundTransparency < 1 then
                bar.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.9, 1)
            end
        end
    end)

    -- FOOTER
    local footer = Instance.new("TextLabel", mf)
    footer.Size = UDim2.new(1, 0, 0, 16); footer.Position = UDim2.new(0, 0, 0, 275)
    footer.BackgroundTransparency = 1; footer.Text = "Chora_Argumento & Petrix © 2026"
    footer.TextColor3 = Color3.fromRGB(55, 55, 70); footer.Font = Enum.Font.Gotham; footer.TextSize = 9

    -- BOTÃO FECHAR
    local closeBtn = Instance.new("TextButton", mf)
    closeBtn.Size = UDim2.new(0, 28, 0, 28); closeBtn.Position = UDim2.new(1, -36, 0, 8)
    closeBtn.BackgroundTransparency = 1; closeBtn.Text = "✕"; closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 16; closeBtn.ZIndex = 5
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 70, 70)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

    -- ===================== LÓGICA =====================
    local function animarBarra(p)
        bar.BackgroundTransparency = 0
        TweenService:Create(bar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(p, 0, 1, 0)}):Play()
        if p >= 1 then
            task.wait(0.4)
            TweenService:Create(bar, TweenInfo.new(0.25), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0)}):Play()
        end
    end

    local function setStatus(msg, cor)
        status.Text = msg
        if cor then status.TextColor3 = cor end
    end

    verifyBtn.MouseButton1Click:Connect(function()
        local key = input.Text
        if key == "" then setStatus("❌ Digite uma key!", Color3.fromRGB(255, 60, 60)); return end
        setStatus("⏳ Verificando...", Color3.fromRGB(255, 200, 0)); animarBarra(0.3)
        local success, msg = redeemKey(key)
        if success then
            animarBarra(1); setStatus("✅ Key válida! Carregando...", Color3.fromRGB(0, 255, 80))
            task.wait(0.6); sg:Destroy()
            _G[Config.Secret] = true; StartMECBR()
        else
            animarBarra(0); setStatus("❌ " .. msg, Color3.fromRGB(255, 50, 50))
        end
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        setStatus("⏳ Gerando link...", Color3.fromRGB(255, 200, 0)); animarBarra(0.3)
        local success, link = cacheLink()
        if success then
            pcall(function() setclipboard(link) end); animarBarra(1)
            setStatus("✅ Link copiado! Abra no navegador.", Color3.fromRGB(0, 200, 80))
        else
            animarBarra(0); setStatus("❌ Erro: " .. tostring(link), Color3.fromRGB(255, 50, 50))
        end
    end)

    if isfile and isfile(Config.KeyFileName) then
        local savedKey = readfile(Config.KeyFileName)
        if savedKey ~= "" then
            setStatus("⏳ Verificando key salva...", Color3.fromRGB(255, 200, 0))
            task.spawn(function()
                local success, msg = redeemKey(savedKey)
                if success then
                    animarBarra(1); setStatus("✅ Auto-login!", Color3.fromRGB(0, 255, 80))
                    task.wait(0.5); sg:Destroy()
                    _G[Config.Secret] = true; StartMECBR()
                else
                    setStatus("⌛ Key expirada. Gere uma nova.", Color3.fromRGB(255, 150, 0))
                end
            end)
        end
    end
end

-- =============================================================================
-- 🚀 INICIAR
-- =============================================================================
local player = game:GetService("Players").LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
if pGui:FindFirstChild(Config.MainGuiName) then _G[Config.Secret] = true; StartMECBR(); return end
CreateGUI()

-- =============================================================================
-- ⬇️ MEC BR ULTIMATE v3.8 — CÓDIGO COMPLETO EMBUTIDO ⬇️
-- =============================================================================
function StartMECBR()
    local Players = game:GetService("Players"); local RunService = game:GetService("RunService"); local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer; local TweenService = game:GetService("TweenService"); local Debris = game:GetService("Debris")
    local SoundService = game:GetService("SoundService")
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local ultimaPosicao, localSelecionado, entregando, puxando = nil, nil, false, false
    local grabbedParts, welds, isWelded = {}, {}, false
    local StatusLabel, PosLabel, UltimaPosLabel, PecasLabel, AutoStatusLabel

    local coordenadas = {{nome="Auto Peças",posicao=Vector3.new(-3335.28,65.69,-3400.30)},{nome="Posto de Gasolina",posicao=Vector3.new(-3232.68,66.07,-3704.04)},{nome="Ferro Velho",posicao=Vector3.new(-3131.48,65.67,-4247.97)},{nome="Drag",posicao=Vector3.new(-3900.53,64.81,-4890.13)},{nome="Concessionária",posicao=Vector3.new(-3041.93,65.49,-3694.85)},{nome="Construção",posicao=Vector3.new(-3649.34,65.17,-2504.47)},{nome="Entregas",posicao=Vector3.new(-25688.55,32.99,-5885.05)}}
    local settings = {raioPuxar=50,alturaPilha=2.5,posicaoX=0,posicaoZ=3}
    local SONS = {teleporte="rbxassetid://9120386890",pegar="rbxassetid://18376010604",soltar="rbxassetid://18376843770",sucesso="rbxassetid://15860705703",erro="rbxassetid://2760943325",scan="rbxassetid://13818331629",retorno="rbxassetid://9120386890"}

    local function tocarSom(id,vol,parent) pcall(function() local s=Instance.new("Sound"); s.SoundId=id; s.Volume=vol or 0.5; s.Pitch=1+math.random(-10,10)/100; s.RollOffMode=Enum.RollOffMode.Linear; s.MaxDistance=100; s.Parent=parent or SoundService; s:Play(); Debris:AddItem(s,5) end) end
    local function criarParticulas(cf,cor,qtd,duracao) pcall(function() local p=Instance.new("Part"); p.Size=Vector3.new(0.5,0.5,0.5); p.Transparency=1; p.CanCollide=false; p.Anchored=true; p.CFrame=cf; p.Parent=Workspace; Debris:AddItem(p,duracao or 3); local pe=Instance.new("ParticleEmitter"); pe.Texture="rbxassetid://4583316015"; pe.Color=ColorSequence.new(cor); pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.5),NumberSequenceKeypoint.new(1,0)}); pe.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}); pe.Lifetime=NumberRange.new(0.5,1.5); pe.Rate=qtd or 50; pe.SpreadAngle=Vector2.new(-45,45); pe.VelocityInheritance=0; pe.Speed=NumberRange.new(2,6); pe.Acceleration=Vector3.new(0,-5,0); pe.Rotation=NumberRange.new(0,360); pe.RotSpeed=NumberRange.new(-180,180); pe.Drag=2; pe.LockedToPart=false; pe.Enabled=true; pe.Parent=p; Debris:AddItem(pe,duracao or 3) end) end
    local function criarExplosaoVisual(cf,cor,tam) pcall(function() local a=Instance.new("Attachment"); a.WorldCFrame=cf; a.Parent=Workspace.Terrain; Debris:AddItem(a,3); local e=Instance.new("Explosion"); e.BlastRadius=tam or 8; e.BlastPressure=0; e.DestroyJointRadiusPercent=0; e.Visible=true; e.Position=cf.Position; e.Parent=Workspace; Debris:AddItem(e,3) end) end
    local function criarEfeitoTeletransporte(personagem,destino) pcall(function() if not personagem then return end; local root=personagem:FindFirstChild("HumanoidRootPart"); if not root then return end; criarParticulas(root.CFrame,Color3.new(1,1,1),80,2); criarExplosaoVisual(root.CFrame,Color3.new(1,1,1),4); local bO=root.Position; local bT=destino; local dist=(bT-bO).Magnitude; if dist>0 and dist<10000 then local bp=Instance.new("Part"); bp.Size=Vector3.new(0.3,0.3,dist); bp.CFrame=CFrame.new(bO,bT)*CFrame.new(0,0,-dist/2); bp.Transparency=0.4; bp.Color=Color3.fromRGB(0,200,255); bp.Material=Enum.Material.Neon; bp.CanCollide=false; bp.Anchored=true; bp.Parent=Workspace; Debris:AddItem(bp,0.5); TweenService:Create(bp,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Transparency=1}):Play() end; criarParticulas(CFrame.new(destino),Color3.fromRGB(0,200,255),60,2); criarExplosaoVisual(CFrame.new(destino),Color3.fromRGB(0,150,255),6) end) end

    local function isTranspBox(part) if not part or not part.Parent then return false end; if part.Name~="TranspBox" then return false end; if part.Anchored then return false end; if part:IsDescendantOf(LocalPlayer.Character) then return false end; local p=part.Parent; while p do if p.Name=="GrabStuff" and p.Parent==Workspace then return true end; p=p.Parent end; return false end
    local function isAlreadyGrabbed(part) for _,p in ipairs(grabbedParts) do if p==part then return true end end; return false end
    local function limparPecasFantasma() local t={}; for i,p in ipairs(grabbedParts) do if not p or not p.Parent then table.insert(t,i) end end; if #t>0 then for i=#t,1,-1 do local idx=t[i]; local p2=grabbedParts[idx]; if welds[p2] then welds[p2]:Destroy(); welds[p2]=nil end; table.remove(grabbedParts,idx) end end end
    local function weldGrabPart(part) if not part then return false end; if not isTranspBox(part) then return false end; if isAlreadyGrabbed(part) then return false end; local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return false end; part.CanCollide=false; part.Anchored=false; part.Massless=true; part.CustomPhysicalProperties=PhysicalProperties.new(0,0,0,0,0); part.Transparency=part.Transparency+0.15; local idx=#grabbedParts; local alt=idx*settings.alturaPilha+1.5; local w=Instance.new("Weld"); w.Part0=root; w.Part1=part; w.C0=CFrame.new(settings.posicaoX or 0,alt,settings.posicaoZ or 3); w.Parent=root; table.insert(grabbedParts,part); welds[part]=w; pcall(function() criarParticulas(CFrame.new(part.Position),Color3.fromRGB(0,255,200),20,0.8); local sp=Instance.new("Sparkles"); sp.SparkleColor=Color3.fromRGB(0,255,200); sp.Parent=part; Debris:AddItem(sp,1.5) end); return true end
    local function atualizarPilha() if #grabbedParts==0 then return end; local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return end; limparPecasFantasma(); for idx,p in ipairs(grabbedParts) do if p and p.Parent and welds[p] then local alt=(idx-1)*settings.alturaPilha+1.5; welds[p].C0=CFrame.new(settings.posicaoX or 0,alt,settings.posicaoZ or 3) end end end
    local function puxarPecas() if puxando then tocarSom(SONS.erro,0.4); return Rayfield:Notify({Title="⏳ Ocupado",Content="Aguarde...",Duration=2}) end; local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then puxando=false; tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Erro",Content="HumanoidRootPart não encontrado.",Duration=3}) end; puxando=true; local count=0; local radius=settings.raioPuxar or 50; tocarSom(SONS.scan,0.3); Rayfield:Notify({Title="🧲 Scanner",Content="Raio: "..radius.." studs",Duration=2}); pcall(function() local pulse=Instance.new("Part"); pulse.Size=Vector3.new(0.2,0.2,0.2); pulse.Shape=Enum.PartType.Ball; pulse.Transparency=0.7; pulse.Color=Color3.fromRGB(0,255,200); pulse.Material=Enum.Material.Neon; pulse.CanCollide=false; pulse.Anchored=true; pulse.CFrame=root.CFrame; pulse.Parent=Workspace; Debris:AddItem(pulse,1.5); local pe=Instance.new("ParticleEmitter"); pe.Texture="rbxassetid://4583316015"; pe.Color=ColorSequence.new(Color3.fromRGB(0,255,200)); pe.Size=NumberSequence.new(0.5); pe.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3),NumberSequenceKeypoint.new(1,1)}); pe.Lifetime=NumberRange.new(0.3,0.8); pe.Rate=200; pe.SpreadAngle=Vector2.new(-180,180); pe.Speed=NumberRange.new(radius*0.3,radius*0.8); pe.VelocityInheritance=0; pe.LockedToPart=true; pe.Enabled=true; pe.Parent=pulse; Debris:AddItem(pe,1.5) end); task.spawn(function() limparPecasFantasma(); local parts={}; local gs=Workspace:FindFirstChild("GrabStuff"); if gs then for _,v in ipairs(gs:GetDescendants()) do if v:IsA("BasePart") and v.Name=="TranspBox" and not v.Anchored and (v.Position-root.Position).Magnitude<radius and not isAlreadyGrabbed(v) then table.insert(parts,v) end end else for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name=="TranspBox" and not v.Anchored and (v.Position-root.Position).Magnitude<radius and not isAlreadyGrabbed(v) then table.insert(parts,v) end end end; for _,p in ipairs(parts) do if p and p.Parent and weldGrabPart(p) then count=count+1; task.wait(0.03) end end; isWelded=true; puxando=false; if count>0 then tocarSom(SONS.pegar,0.4); Rayfield:Notify({Title="✅ Sucesso",Content=count.." TranspBox soldadas!",Duration=3}) else tocarSom(SONS.erro,0.4); Rayfield:Notify({Title="❌ Nada",Content="Nenhuma TranspBox encontrada.",Duration=2}) end end) end
    local function soltarPecas() local count=#grabbedParts; if count==0 then tocarSom(SONS.erro,0.3); Rayfield:Notify({Title="ℹ️ Info",Content="Nada para soltar.",Duration=2}); return end; isWelded=false; for _,p in ipairs(grabbedParts) do if welds[p] then welds[p]:Destroy(); welds[p]=nil end; if p and p.Parent then p.CanCollide=true; p.Massless=false; p.CustomPhysicalProperties=nil; p.Transparency=math.max(0,p.Transparency-0.15); p.Velocity=Vector3.new(0,0,0); pcall(function() criarParticulas(CFrame.new(p.Position),Color3.fromRGB(255,100,0),30,1); criarExplosaoVisual(CFrame.new(p.Position),Color3.fromRGB(255,100,0),3) end) end end; grabbedParts={}; welds={}; tocarSom(SONS.soltar,0.5); Rayfield:Notify({Title="🔄 Resetado",Content=count.." TranspBox soltas!",Duration=2}) end
    local function entregar() if not localSelecionado then tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Erro",Content="Selecione um destino.",Duration=3}) end; if entregando then return end; local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then entregando=false; tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Erro",Content="Personagem indisponível.",Duration=3}) end; entregando=true; ultimaPosicao=root.Position; tocarSom(SONS.teleporte,0.4); Rayfield:Notify({Title="🚚 Roteando",Content="Destino: "..localSelecionado.nome,Duration=2}); criarEfeitoTeletransporte(char,localSelecionado.posicao+Vector3.new(0,5,0)); task.wait(0.2); root.CFrame=CFrame.new(localSelecionado.posicao+Vector3.new(0,5,0)); root.Velocity=Vector3.new(0,0,0); root.AssemblyLinearVelocity=Vector3.new(0,0,0); task.wait(0.1); tocarSom(SONS.sucesso,0.5); Rayfield:Notify({Title="✅ Concluído",Content="Posicionado em: "..localSelecionado.nome,Duration=3}); entregando=false; if StatusLabel then StatusLabel:Set("✅ Última entrega: "..localSelecionado.nome) end end
    local function voltar() if not ultimaPosicao then tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Erro",Content="Nenhum registro anterior.",Duration=3}) end; if entregando then return end; local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then entregando=false; tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Erro",Content="Personagem indisponível.",Duration=2}) end; local destino=ultimaPosicao; tocarSom(SONS.retorno,0.4); Rayfield:Notify({Title="↩️ Retornando",Content="à origem.",Duration=2}); criarEfeitoTeletransporte(char,destino+Vector3.new(0,5,0)); task.wait(0.2); root.CFrame=CFrame.new(destino+Vector3.new(0,5,0)); root.Velocity=Vector3.new(0,0,0); root.AssemblyLinearVelocity=Vector3.new(0,0,0); task.wait(0.1); tocarSom(SONS.sucesso,0.5); Rayfield:Notify({Title="✅ Concluído",Content="Retorno executado.",Duration=3}); if StatusLabel then StatusLabel:Set("✅ Voltou à posição anterior") end end
    local function entregarAutomatico() if entregando then return Rayfield:Notify({Title="⏳ Ocupado",Content="Aguarde.",Duration=2}) end; local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return Rayfield:Notify({Title="❌ Erro",Content="Personagem indisponível.",Duration=2}) end; local tj=Workspace:FindFirstChild("TransportJobWorkings"); if not tj then tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Erro",Content="TransportJobWorkings não encontrado.",Duration=3}) end; local dests=tj:FindFirstChild("Destinations"); if not dests then tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Erro",Content="Destinations ausente.",Duration=3}) end; local validas, inativas={},{}; for _,df in ipairs(dests:GetChildren()) do if df:IsA("Folder") or df:IsA("Model") then local da=df:FindFirstChild("DropArea"); local det=df:FindFirstChild("Details"); local dec,sp=nil,nil; if det then dec=det:FindFirstChild("Decal"); sp=det:FindFirstChild("Spin") else dec=df:FindFirstChild("Decal"); sp=df:FindFirstChild("Spin") end; if da and da:IsA("BasePart") and dec and sp then table.insert(validas,{nome=df.Name,posicao=da.Position}) end end end; if #validas==0 then tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Nenhum destino ativo",Content="Aguarde ativação.",Duration=4}) end; local escolhido,menor=nil,math.huge; for _,area in ipairs(validas) do local dist=(area.posicao-root.Position).Magnitude; if dist<menor then menor=dist; escolhido=area end end; if not escolhido then tocarSom(SONS.erro,0.5); return Rayfield:Notify({Title="❌ Erro",Content="Seleção falhou.",Duration=2}) end; entregando=true; ultimaPosicao=root.Position; tocarSom(SONS.teleporte,0.4); Rayfield:Notify({Title="🚀 Auto Entrega",Content="Indo para "..escolhido.nome,Duration=2}); criarEfeitoTeletransporte(char,escolhido.posicao+Vector3.new(0,3,0)); task.wait(0.2); root.CFrame=CFrame.new(escolhido.posicao+Vector3.new(0,3,0)); root.Velocity=Vector3.new(0,0,0); root.AssemblyLinearVelocity=Vector3.new(0,0,0); tocarSom(SONS.sucesso,0.5); Rayfield:Notify({Title="✅ Chegou",Content=escolhido.nome,Duration=4}); entregando=false; if StatusLabel then StatusLabel:Set("✅ Entregue em: "..escolhido.nome) end end

    local Window=Rayfield:CreateWindow({Name="🚚 MEC BR ULTIMATE | v3.8",Icon=0,LoadingTitle="Inicializando...",LoadingSubtitle="by Chora_Argumento & Petrix",Theme="Ocean",ToggleUIKeybind="K",ConfigurationSaving={Enabled=true,FileName="MEC_Config"},Discord={Enabled=false},KeySystem=false})
    local MagnetTab=Window:CreateTab("🧲 Magnético",0); local EntregaTab=Window:CreateTab("🚚 Entrega",0); local CoordTab=Window:CreateTab("📍 Coordenadas",0); local InfoTab=Window:CreateTab("ℹ️ Info",0)
    MagnetTab:CreateSection("🧲 Controle"); MagnetTab:CreateButton({Name="🧲 PEGAR TRANSPBOX",Callback=puxarPecas}); MagnetTab:CreateButton({Name="❌ SOLTAR TRANSPBOX",Callback=soltarPecas})
    MagnetTab:CreateSection("⚙️ Ajustes"); MagnetTab:CreateSlider({Name="📡 Raio",Range={10,100},Increment=5,Suffix=" studs",CurrentValue=settings.raioPuxar,Flag="Raio",Callback=function(v)settings.raioPuxar=v end}); MagnetTab:CreateSlider({Name="📏 Altura",Range={1,6},Increment=0.5,Suffix=" studs",CurrentValue=settings.alturaPilha,Flag="Altura",Callback=function(v)settings.alturaPilha=v;atualizarPilha()end}); MagnetTab:CreateSlider({Name="📏 Distância",Range={1,10},Increment=0.5,Suffix=" studs",CurrentValue=3,Flag="Dist",Callback=function(v)settings.posicaoZ=v;atualizarPilha()end})
    MagnetTab:CreateSection("📊 Status"); PecasLabel=MagnetTab:CreateLabel("📦 TranspBox: 0"); task.spawn(function() while true do task.wait(0.5); if PecasLabel then PecasLabel:Set("📦 TranspBox: "..#grabbedParts..(isWelded and " ✅" or " ⏸")) end end end)
    EntregaTab:CreateSection("📍 Destino"); local opcoes={}; for i,d in ipairs(coordenadas) do table.insert(opcoes,i..". "..d.nome) end; EntregaTab:CreateDropdown({Name="Selecione",Options=opcoes,CurrentOption={},MultipleOptions=false,Flag="Dest",Callback=function(o)if #o>0 then local idx=tonumber(string.match(o[1],"^(%d+)")); if idx then localSelecionado=coordenadas[idx] end end end})
    EntregaTab:CreateSection("⚡ Ações"); EntregaTab:CreateButton({Name="🚚 INICIAR TRANSPORTE",Callback=entregar}); EntregaTab:CreateButton({Name="↩️ RETORNAR",Callback=voltar})
    EntregaTab:CreateSection("🧪 Experimental"); EntregaTab:CreateButton({Name="🚀 ENTREGA AUTO",Callback=entregarAutomatico}); AutoStatusLabel=EntregaTab:CreateLabel("🤖 Status: Aguardando...")
    EntregaTab:CreateSection("📊 Telemetria"); StatusLabel=EntregaTab:CreateLabel("✅ Aguardando..."); PosLabel=EntregaTab:CreateLabel("📍 Carregando..."); UltimaPosLabel=EntregaTab:CreateLabel("📌 Nenhuma.")
    CoordTab:CreateSection("📋 Coordenadas"); for i,d in ipairs(coordenadas) do CoordTab:CreateLabel(string.format("%d. %s\n   [X: %.2f | Y: %.2f | Z: %.2f]",i,d.nome,d.posicao.X,d.posicao.Y,d.posicao.Z)) end
    CoordTab:CreateButton({Name="📋 EXPORTAR",Callback=function() local t=""; for i,d in ipairs(coordenadas) do t=t..string.format("%d. %s -> Vector3.new(%.2f, %.2f, %.2f)\n",i,d.nome,d.posicao.X,d.posicao.Y,d.posicao.Z) end; local ok=pcall(function()setclipboard(t)end); Rayfield:Notify({Title=ok and "📋 Ok" or "❌ Falha",Content=ok and "Copiado!" or "Sem permissão.",Duration=3}) end})
    InfoTab:CreateSection("⚙️ Sistema"); InfoTab:CreateLabel("• v3.8.0-pro"); InfoTab:CreateLabel("• Rayfield UI"); InfoTab:CreateLabel("• Weld (TranspBox)"); InfoTab:CreateLabel("• CFrame Teleport"); InfoTab:CreateLabel("• Som + Partículas"); InfoTab:CreateLabel("• PlatoBoost Key System"); InfoTab:CreateSection("👨‍💻 Desenvolvedores"); InfoTab:CreateLabel("• Chora_Argumento"); InfoTab:CreateLabel("• Petrix"); InfoTab:CreateLabel("• discord.gg/7dkp6uhYNb"); InfoTab:CreateSection("📦 Alvo"); InfoTab:CreateLabel("• TranspBox"); InfoTab:CreateLabel("• Workspace.GrabStuff"); InfoTab:CreateLabel("• -25705, 31, -5854")
    local CreditsTab=Window:CreateTab("👨‍💻 Créditos",0); CreditsTab:CreateSection("🎮 Devs"); CreditsTab:CreateLabel("👨‍💻 Chora_Argumento"); CreditsTab:CreateLabel("👨‍💻 Petrix"); CreditsTab:CreateSection("📚 Libs"); CreditsTab:CreateLabel("• Rayfield"); CreditsTab:CreateLabel("• OYB Key System"); CreditsTab:CreateButton({Name="📋 COPIAR DISCORD",Callback=function()pcall(function()setclipboard("https://discord.gg/7dkp6uhYNb")end); Rayfield:Notify({Title="📋 Copiado!",Duration=2})end}); CreditsTab:CreateSection("⚠️ Aviso"); CreditsTab:CreateLabel("Use com responsabilidade!"); CreditsTab:CreateLabel("Respeite os jogadores!"); CreditsTab:CreateLabel("💀 2026 - Todos os direitos reservados")

    RunService.Heartbeat:Connect(function() pcall(function() local char=LocalPlayer.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if root and PosLabel then local p=root.Position; PosLabel:Set(string.format("📍 Pos: %.1f, %.1f, %.1f",p.X,p.Y,p.Z)) end; if UltimaPosLabel then UltimaPosLabel:Set(ultimaPosicao and string.format("📌 Última: %.1f, %.1f, %.1f",ultimaPosicao.X,ultimaPosicao.Y,ultimaPosicao.Z) or "📌 Nenhuma") end; if #grabbedParts>0 then limparPecasFantasma() end end) end)
    task.spawn(function() while true do task.wait(2); if isWelded and #grabbedParts>0 then pcall(atualizarPilha) end end end)
    LocalPlayer.CharacterAdded:Connect(function() isWelded=false;puxando=false;entregando=false; for _,p in ipairs(grabbedParts) do if welds[p] then welds[p]:Destroy();welds[p]=nil end; if p and p.Parent then p.CanCollide=true;p.Massless=false;p.CustomPhysicalProperties=nil;p.Transparency=math.max(0,(p.Transparency or 0)-0.15) end end; grabbedParts={};welds={} end)
    local function onCleanup() isWelded=false;puxando=false;entregando=false; for _,p in ipairs(grabbedParts) do if welds[p] then pcall(function()welds[p]:Destroy()end);welds[p]=nil end end; grabbedParts={};welds={} end; pcall(function()if LocalPlayer.OnCleanup then LocalPlayer.OnCleanup:Connect(onCleanup)end end)

    print("========================================"); print("🚀 MEC BR ULTIMATE - v3.8"); print("👨‍💻 Chora_Argumento & Petrix"); print("========================================"); print("[Key System: PlatoBoost]"); print("[Alvo: TranspBox]"); print("========================================")
    Rayfield:Notify({Title="🚀 MEC BR ULTIMATE v3.8",Content="📦 Carregado com sucesso!",Duration=5}); Rayfield:Notify({Title="⚠️ AVISO",Content="Use com responsabilidade!",Duration=5})
end
