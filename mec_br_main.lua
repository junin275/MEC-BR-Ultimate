-- =============================================================================
-- MEC BR ULTIMATE | ENTERPRISE EDITION v3.8
-- =============================================================================
-- Portado para: Orion Library
-- Desenvolvido por: Chora_Argumento & Petrix
-- =============================================================================

-- =============================================================================
-- SEGURANCA: ANTI-BYPASS
-- =============================================================================
local SECRET_KEY = "MEC_BR_SECRET_2026"
if not _G[SECRET_KEY] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("🛡️ Execucao nao autorizada!\n\nUse o Key System oficial para executar o MEC BR ULTIMATE.\nby Chora_Argumento & Petrix")
    end
    return
end
_G[SECRET_KEY] = nil
-- =============================================================================

-- [1] SERVICOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "🚚 MEC BR ULTIMATE | v3.8",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MEC_Ultimate_Config",
    IntroEnabled = true,
    IntroText = "MEC BR ULTIMATE"
})

-- [2] VARIAVEIS DE ESTADO
local ultimaPosicao = nil
local localSelecionado = nil
local entregando = false
local puxando = false
local grabbedParts = {}
local welds = {}
local isWelded = false
local StatusLabel, PosLabel, UltimaPosLabel, PecasLabel, AutoStatusLabel

-- [3] COORDENADAS
local coordenadas = {
    {nome = "Auto Pecas", posicao = Vector3.new(-3335.28, 65.69, -3400.30)},
    {nome = "Posto de Gasolina", posicao = Vector3.new(-3232.68, 66.07, -3704.04)},
    {nome = "Ferro Velho", posicao = Vector3.new(-3131.48, 65.67, -4247.97)},
    {nome = "Drag", posicao = Vector3.new(-3900.53, 64.81, -4890.13)},
    {nome = "Concessionaria", posicao = Vector3.new(-3041.93, 65.49, -3694.85)},
    {nome = "Construcao", posicao = Vector3.new(-3649.34, 65.17, -2504.47)},
    {nome = "Entregas", posicao = Vector3.new(-25688.55, 32.99, -5885.05)},
}

-- [4] CONFIGURACOES
local settings = {
    raioPuxar = 50,
    alturaPilha = 2.5,
    posicaoX = 0,
    posicaoZ = 3,
}

-- =============================================================================
-- [5] SOM E EFEITOS VISUAIS
-- =============================================================================

local SONS = {
    teleporte  = "rbxassetid://9120386890",
    pegar      = "rbxassetid://18376010604",
    soltar     = "rbxassetid://18376843770",
    sucesso    = "rbxassetid://15860705703",
    erro       = "rbxassetid://2760943325",
    scan       = "rbxassetid://13818331629",
    retorno    = "rbxassetid://9120386890",
}

local function tocarSom(id, volume, parent)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = volume or 0.5
        s.Pitch = 1 + math.random(-10, 10)/100
        s.RollOffMode = Enum.RollOffMode.Linear
        s.MaxDistance = 100
        s.Parent = parent or SoundService
        s:Play()
        Debris:AddItem(s, 5)
    end)
end

local function criarParticulas(cframe, cor, quantidade, duracao)
    pcall(function()
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.5, 0.5, 0.5)
        p.Transparency = 1
        p.CanCollide = false
        p.Anchored = true
        p.CFrame = cframe
        p.Parent = Workspace
        Debris:AddItem(p, duracao or 3)
        local pe = Instance.new("ParticleEmitter")
        pe.Texture = "rbxassetid://4583316015"
        pe.Color = ColorSequence.new(cor)
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
        pe.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        pe.Lifetime = NumberRange.new(0.5, 1.5)
        pe.Rate = quantidade or 50
        pe.SpreadAngle = Vector2.new(-45, 45)
        pe.VelocityInheritance = 0
        pe.Speed = NumberRange.new(2, 6)
        pe.Acceleration = Vector3.new(0, -5, 0)
        pe.Rotation = NumberRange.new(0, 360)
        pe.RotSpeed = NumberRange.new(-180, 180)
        pe.Drag = 2
        pe.LockedToPart = false
        pe.Enabled = true
        pe.Parent = p
        Debris:AddItem(pe, duracao or 3)
    end)
end

local function criarExplosaoVisual(cframe, cor, tamanho)
    pcall(function()
        local a = Instance.new("Attachment")
        a.WorldCFrame = cframe
        a.Parent = Workspace.Terrain
        Debris:AddItem(a, 3)
        local e = Instance.new("Explosion")
        e.BlastRadius = tamanho or 8
        e.BlastPressure = 0
        e.DestroyJointRadiusPercent = 0
        e.Visible = true
        e.Position = cframe.Position
        e.Parent = Workspace
        Debris:AddItem(e, 3)
    end)
end

local function criarEfeitoTeletransporte(personagem, destino)
    pcall(function()
        if not personagem then return end
        local root = personagem:FindFirstChild("HumanoidRootPart")
        if not root then return end
        criarParticulas(root.CFrame, Color3.new(1, 1, 1), 80, 2)
        criarExplosaoVisual(root.CFrame, Color3.new(1, 1, 1), 4)
        local beamOrigin = root.Position
        local beamTarget = destino
        local dist = (beamTarget - beamOrigin).Magnitude
        if dist > 0 and dist < 10000 then
            local bPart = Instance.new("Part")
            bPart.Size = Vector3.new(0.3, 0.3, dist)
            bPart.CFrame = CFrame.new(beamOrigin, beamTarget) * CFrame.new(0, 0, -dist / 2)
            bPart.Transparency = 0.4
            bPart.Color = Color3.fromRGB(0, 200, 255)
            bPart.Material = Enum.Material.Neon
            bPart.CanCollide = false
            bPart.Anchored = true
            bPart.Parent = Workspace
            Debris:AddItem(bPart, 0.5)
            local tween = TweenService:Create(bPart, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
            tween:Play()
        end
        criarParticulas(CFrame.new(destino), Color3.fromRGB(0, 200, 255), 60, 2)
        criarExplosaoVisual(CFrame.new(destino), Color3.fromRGB(0, 150, 255), 6)
    end)
end

-- =============================================================================
-- [6] SISTEMA DE SOLDA
-- =============================================================================

local function isTranspBox(part)
    if not part or not part.Parent then return false end
    if part.Name ~= "TranspBox" then return false end
    if part.Anchored then return false end
    if part:IsDescendantOf(LocalPlayer.Character) then return false end
    local parent = part.Parent
    while parent do
        if parent.Name == "GrabStuff" and parent.Parent == Workspace then return true end
        parent = parent.Parent
    end
    return false
end

local function isAlreadyGrabbed(part)
    for _, p in ipairs(grabbedParts) do
        if p == part then return true end
    end
    return false
end

local function limparPecasFantasma()
    local toRemove = {}
    for i, part in ipairs(grabbedParts) do
        if not part or not part.Parent then table.insert(toRemove, i) end
    end
    if #toRemove > 0 then
        for i = #toRemove, 1, -1 do
            local idx = toRemove[i]
            local part = grabbedParts[idx]
            if welds[part] then welds[part]:Destroy(); welds[part] = nil end
            table.remove(grabbedParts, idx)
        end
    end
end

local function weldGrabPart(part)
    if not part then return false end
    if not isTranspBox(part) then return false end
    if isAlreadyGrabbed(part) then return false end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    part.CanCollide = false
    part.Anchored = false
    part.Massless = true
    part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
    part.Transparency = part.Transparency + 0.15
    local index = #grabbedParts
    local altura = index * settings.alturaPilha + 1.5
    local weld = Instance.new("Weld")
    weld.Part0 = rootPart
    weld.Part1 = part
    weld.C0 = CFrame.new(settings.posicaoX or 0, altura, settings.posicaoZ or 3)
    weld.Parent = rootPart
    table.insert(grabbedParts, part)
    welds[part] = weld
    pcall(function()
        local pos = part.Position
        criarParticulas(CFrame.new(pos), Color3.fromRGB(0, 255, 200), 20, 0.8)
        local sp = Instance.new("Sparkles")
        sp.SparkleColor = Color3.fromRGB(0, 255, 200)
        sp.Parent = part
        Debris:AddItem(sp, 1.5)
    end)
    return true
end

local function atualizarPilha()
    if #grabbedParts == 0 then return end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    limparPecasFantasma()
    for index, part in ipairs(grabbedParts) do
        if part and part.Parent and welds[part] then
            local altura = (index - 1) * settings.alturaPilha + 1.5
            welds[part].C0 = CFrame.new(settings.posicaoX or 0, altura, settings.posicaoZ or 3)
        end
    end
end

local function puxarPecas()
    if puxando then
        tocarSom(SONS.erro, 0.4)
        OrionLib:MakeNotification({Name = "⏳ Sistema Ocupado", Content = "Aguarde a conclusao do ciclo atual.", Image = "rbxassetid://4483345998", Time = 2})
        return
    end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        puxando = false
        tocarSom(SONS.erro, 0.5)
        OrionLib:MakeNotification({Name = "Falha Critica", Content = "Componente HumanoidRootPart nao mapeado.", Image = "rbxassetid://4483345998", Time = 3})
        return
    end
    puxando = true
    local count = 0
    local radius = settings.raioPuxar or 50
    tocarSom(SONS.scan, 0.3)
    OrionLib:MakeNotification({Name = "Scanner Ativo", Content = "Procurando TranspBox num raio de " .. radius .. " studs", Image = "rbxassetid://4483345998", Time = 2})
    pcall(function()
        local pulse = Instance.new("Part")
        pulse.Size = Vector3.new(0.2, 0.2, 0.2)
        pulse.Shape = Enum.PartType.Ball
        pulse.Transparency = 0.7
        pulse.Color = Color3.fromRGB(0, 255, 200)
        pulse.Material = Enum.Material.Neon
        pulse.CanCollide = false
        pulse.Anchored = true
        pulse.CFrame = rootPart.CFrame
        pulse.Parent = Workspace
        Debris:AddItem(pulse, 1.5)
        local pe = Instance.new("ParticleEmitter")
        pe.Texture = "rbxassetid://4583316015"
        pe.Color = ColorSequence.new(Color3.fromRGB(0, 255, 200))
        pe.Size = NumberSequence.new(0.5)
        pe.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1)})
        pe.Lifetime = NumberRange.new(0.3, 0.8)
        pe.Rate = 200
        pe.SpreadAngle = Vector2.new(-180, 180)
        pe.Speed = NumberRange.new(radius * 0.3, radius * 0.8)
        pe.VelocityInheritance = 0
        pe.LockedToPart = true
        pe.Enabled = true
        pe.Parent = pulse
        Debris:AddItem(pe, 1.5)
    end)
    task.spawn(function()
        limparPecasFantasma()
        local partsToProcess = {}
        local grabStuff = Workspace:FindFirstChild("GrabStuff")
        if grabStuff then
            for _, v in ipairs(grabStuff:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "TranspBox" and not v.Anchored then
                    local dist = (v.Position - rootPart.Position).Magnitude
                    if dist < radius and not isAlreadyGrabbed(v) then table.insert(partsToProcess, v) end
                end
            end
        else
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "TranspBox" and not v.Anchored then
                    local dist = (v.Position - rootPart.Position).Magnitude
                    if dist < radius and not isAlreadyGrabbed(v) then table.insert(partsToProcess, v) end
                end
            end
        end
        for _, part in ipairs(partsToProcess) do
            if part and part.Parent then
                local success = weldGrabPart(part)
                if success then count = count + 1; task.wait(0.03) end
            end
        end
        isWelded = true
        puxando = false
        if count > 0 then
            tocarSom(SONS.pegar, 0.4)
            OrionLib:MakeNotification({Name = "Sucesso", Content = count .. " TranspBox soldadas e seguindo voce!", Image = "rbxassetid://4483345998", Time = 3})
        else
            tocarSom(SONS.erro, 0.4)
            OrionLib:MakeNotification({Name = "Nada Encontrado", Content = "Nenhuma TranspBox proxima encontrada!", Image = "rbxassetid://4483345998", Time = 2})
        end
    end)
end

local function soltarPecas()
    local count = #grabbedParts
    if count == 0 then
        tocarSom(SONS.erro, 0.3)
        OrionLib:MakeNotification({Name = "Info", Content = "Nenhuma TranspBox acoplada para soltar.", Image = "rbxassetid://4483345998", Time = 2})
        return
    end
    isWelded = false
    for _, part in ipairs(grabbedParts) do
        if welds[part] then welds[part]:Destroy(); welds[part] = nil end
        if part and part.Parent then
            part.CanCollide = true
            part.Massless = false
            part.CustomPhysicalProperties = nil
            part.Transparency = math.max(0, part.Transparency - 0.15)
            part.Velocity = Vector3.new(0, 0, 0)
            pcall(function()
                local pos = part.Position
                criarParticulas(CFrame.new(pos), Color3.fromRGB(255, 100, 0), 30, 1)
                criarExplosaoVisual(CFrame.new(pos), Color3.fromRGB(255, 100, 0), 3)
            end)
        end
    end
    grabbedParts = {}
    welds = {}
    tocarSom(SONS.soltar, 0.5)
    OrionLib:MakeNotification({Name = "Modulo Resetado", Content = count .. " TranspBox soltas com sucesso!", Image = "rbxassetid://4483345998", Time = 2})
end

-- =============================================================================
-- [7] SISTEMA DE LOGISTICA
-- =============================================================================

local function entregar()
    if not localSelecionado then
        tocarSom(SONS.erro, 0.5)
        OrionLib:MakeNotification({Name = "Erro de Rota", Content = "Destino nao selecionado no painel.", Image = "rbxassetid://4483345998", Time = 3})
        return
    end
    if entregando then return end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        entregando = false
        tocarSom(SONS.erro, 0.5)
        OrionLib:MakeNotification({Name = "Erro Causal", Content = "Entidade fisica indisponivel.", Image = "rbxassetid://4483345998", Time = 3})
        return
    end
    entregando = true
    ultimaPosicao = rootPart.Position
    tocarSom(SONS.teleporte, 0.4)
    OrionLib:MakeNotification({Name = "Roteamento Iniciado", Content = "Destino: " .. localSelecionado.nome, Image = "rbxassetid://4483345998", Time = 2})
    criarEfeitoTeletransporte(character, localSelecionado.posicao + Vector3.new(0, 5, 0))
    task.wait(0.2)
    rootPart.CFrame = CFrame.new(localSelecionado.posicao + Vector3.new(0, 5, 0))
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    task.wait(0.1)
    tocarSom(SONS.sucesso, 0.5)
    OrionLib:MakeNotification({Name = "Vetor Concluido", Content = "Posicionado em: " .. localSelecionado.nome, Image = "rbxassetid://4483345998", Time = 3})
    entregando = false
    if StatusLabel then StatusLabel:Set("Ultima entrega: " .. localSelecionado.nome) end
end

local function voltar()
    if not ultimaPosicao then
        tocarSom(SONS.erro, 0.5)
        OrionLib:MakeNotification({Name = "Registro Ausente", Content = "Nenhum vetor anterior armazenado.", Image = "rbxassetid://4483345998", Time = 3})
        return
    end
    if entregando then return end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        entregando = false
        tocarSom(SONS.erro, 0.5)
        OrionLib:MakeNotification({Name = "Erro", Content = "Personagem nao disponivel.", Image = "rbxassetid://4483345998", Time = 2})
        return
    end
    local destino = ultimaPosicao
    tocarSom(SONS.retorno, 0.4)
    OrionLib:MakeNotification({Name = "Retorno Vetorial", Content = "Retornando a coordenada de origem.", Image = "rbxassetid://4483345998", Time = 2})
    criarEfeitoTeletransporte(character, destino + Vector3.new(0, 5, 0))
    task.wait(0.2)
    rootPart.CFrame = CFrame.new(destino + Vector3.new(0, 5, 0))
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    task.wait(0.1)
    tocarSom(SONS.sucesso, 0.5)
    OrionLib:MakeNotification({Name = "Concluido", Content = "Retorno executado com sucesso.", Image = "rbxassetid://4483345998", Time = 3})
    if StatusLabel then StatusLabel:Set("Voltou para posicao anterior") end
end

-- =============================================================================
-- [8] SISTEMA DE ENTREGA AUTOMATICA
-- =============================================================================

local function isPartVisible(part)
    if not part or not part.Parent then return false end
    if part:IsA("BasePart") then
        if part.Transparency < 0.9 then
            if part.Size.Magnitude > 0.5 then return true end
        end
    end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("BillboardGui") or child:IsA("SelectionBox") or child:IsA("SelectionLasso") then
            if child.Enabled == true then return true end
        end
        local nome = child.Name:lower()
        if nome:find("arrow") or nome:find("pointer") or nome:find("indicator") or nome:find("marker") then return true end
        if child:IsA("BoolValue") then
            local n = child.Name:lower()
            if (n == "active" or n == "enabled" or n == "visible") and child.Value == true then return true end
        end
    end
    pcall(function()
        if part:GetAttribute("Active") == true then return true end
        if part:GetAttribute("Enabled") == true then return true end
        if part:GetAttribute("Visible") == true then return true end
        if part:GetAttribute("State") == "Active" then return true end
    end)
    return false
end

local function isDestinoAtivo(destinoFolder)
    if not destinoFolder then return false end
    local dropArea = destinoFolder:FindFirstChild("DropArea")
    if dropArea and dropArea:IsA("BasePart") then
        if isPartVisible(dropArea) then return true end
    end
    local details = destinoFolder:FindFirstChild("Details")
    if details then
        local spin = details:FindFirstChild("Spin")
        if spin and spin:IsA("BasePart") then if isPartVisible(spin) then return true end end
        local decal = details:FindFirstChild("Decal")
        if decal and decal:IsA("BasePart") then if isPartVisible(decal) then return true end end
    end
    for _, child in ipairs(destinoFolder:GetDescendants()) do
        if child:IsA("BillboardGui") or child:IsA("SelectionBox") or child:IsA("SelectionLasso") then
            if child.Enabled == true then return true end
        end
        local nome = child.Name:lower()
        if nome:find("arrow") or nome:find("pointer") or nome:find("indicator") or nome:find("marker") then
            if child:IsA("BasePart") or child:IsA("Model") then
                local visible = true
                if child:IsA("BasePart") and child.Transparency >= 0.9 then visible = false end
                if visible then return true end
            end
        end
        if child:IsA("BoolValue") then
            local n = child.Name:lower()
            if (n == "active" or n == "enabled" or n == "visible") and child.Value == true then return true end
        end
    end
    pcall(function()
        if destinoFolder:GetAttribute("Active") == true then return true end
        if destinoFolder:GetAttribute("State") == "Active" then return true end
    end)
    return false
end

local function entregarAutomatico()
    if entregando then
        OrionLib:MakeNotification({Name = "Ocupado", Content = "Aguarde a conclusao da entrega atual.", Image = "rbxassetid://4483345998", Time = 2})
        return
    end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        OrionLib:MakeNotification({Name = "Erro", Content = "Personagem nao disponivel.", Image = "rbxassetid://4483345998", Time = 2})
        return
    end
    local transportJob = Workspace:FindFirstChild("TransportJobWorkings")
    if not transportJob then
        tocarSom(SONS.erro, 0.5)
        OrionLib:MakeNotification({Name = "Estrutura nao encontrada", Content = "TransportJobWorkings nao existe neste servidor.", Image = "rbxassetid://4483345998", Time = 3})
        return
    end
    local destinations = transportJob:FindFirstChild("Destinations")
    if not destinations then
        tocarSom(SONS.erro, 0.5)
        OrionLib:MakeNotification({Name = "Destinations nao encontrada", Content = "A pasta Destinations esta ausente em TransportJobWorkings.", Image = "rbxassetid://4483345998", Time = 3})
        return
    end
    local dropAreasValidas = {}
    local dropAreasInativas = {}
    for _, destinoFolder in ipairs(destinations:GetChildren()) do
        if destinoFolder:IsA("Folder") or destinoFolder:IsA("Model") then
            local dropArea = destinoFolder:FindFirstChild("DropArea")
            local details = destinoFolder:FindFirstChild("Details")
            local decal, spin
            if details then
                decal = details:FindFirstChild("Decal")
                spin = details:FindFirstChild("Spin")
            else
                decal = destinoFolder:FindFirstChild("Decal")
                spin = destinoFolder:FindFirstChild("Spin")
            end
            if dropArea and dropArea:IsA("BasePart") and decal and spin then
                local ativo = isDestinoAtivo(destinoFolder)
                local info = {
                    nome = destinoFolder.Name,
                    posicao = dropArea.Position,
                    dropArea = dropArea,
                    decal = decal,
                    spin = spin,
                    details = details or destinoFolder,
                    pasta = destinoFolder,
                    ativo = ativo
                }
                if ativo then table.insert(dropAreasValidas, info)
                else table.insert(dropAreasInativas, info) end
            end
        end
    end
    if #dropAreasValidas == 0 then
        tocarSom(SONS.erro, 0.5)
        if #dropAreasInativas > 0 then
            local nomes = {}
            for _, area in ipairs(dropAreasInativas) do table.insert(nomes, area.nome) end
            OrionLib:MakeNotification({Name = "Nenhum destino ativo", Content = "Destinos encontrados mas INATIVOS: " .. table.concat(nomes, ", ") .. " | Aguarde a entrega ser ativada!", Image = "rbxassetid://4483345998", Time = 5})
        else
            OrionLib:MakeNotification({Name = "Nenhum destino valido", Content = "Nenhuma area de entrega com DropArea + Decal + Spin disponivel.", Image = "rbxassetid://4483345998", Time = 4})
        end
        return
    end
    local escolhido = nil
    local menorDist = math.huge
    for _, area in ipairs(dropAreasValidas) do
        local dist = (area.posicao - rootPart.Position).Magnitude
        if dist < menorDist then menorDist = dist; escolhido = area end
    end
    if not escolhido then
        tocarSom(SONS.erro, 0.5)
        OrionLib:MakeNotification({Name = "Erro", Content = "Nao foi possivel selecionar um destino valido.", Image = "rbxassetid://4483345998", Time = 2})
        return
    end
    entregando = true
    ultimaPosicao = rootPart.Position
    tocarSom(SONS.teleporte, 0.4)
    OrionLib:MakeNotification({Name = "Entrega Automatica (Experimental)", Content = "Indo para " .. escolhido.nome .. " (ativo | dist: " .. math.floor(menorDist) .. "s)", Image = "rbxassetid://4483345998", Time = 2})
    if AutoStatusLabel then AutoStatusLabel:Set("🤖 Auto: " .. escolhido.nome .. " ATIVO (DropArea + Decal + Spin)") end
    criarEfeitoTeletransporte(character, escolhido.posicao + Vector3.new(0, 3, 0))
    task.wait(0.2)
    local destino = escolhido.posicao + Vector3.new(0, 3, 0)
    rootPart.CFrame = CFrame.new(destino)
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    tocarSom(SONS.sucesso, 0.5)
    OrionLib:MakeNotification({Name = "Chegou em " .. escolhido.nome, Content = "Destino ATIVO confirmado! Area de entrega pronta!", Image = "rbxassetid://4483345998", Time = 4})
    entregando = false
    if StatusLabel then StatusLabel:Set("Entregue em: " .. escolhido.nome .. " (Automatico - ATIVO)") end
end

-- =============================================================================
-- [9] INTERFACE GRAFICA (ORION LIBRARY)
-- =============================================================================

-- Abas
local MagnetTab = Window:MakeTab({Name = "Magnetico", PremiumOnly = false})
local EntregaTab = Window:MakeTab({Name = "Entrega", PremiumOnly = false})
local CoordTab = Window:MakeTab({Name = "Coordenadas", PremiumOnly = false})
local InfoTab = Window:MakeTab({Name = "Painel Informativo", PremiumOnly = false})
local CreditsTab = Window:MakeTab({Name = "Creditos", PremiumOnly = false})

-- ===== ABA MAGNETICO =====
MagnetTab:AddSection({Name = "Controle Operacional"})
MagnetTab:AddButton({Name = "PEGAR TRANSPBOX", Description = "Solda TranspBox proximas ao personagem", Callback = puxarPecas})
MagnetTab:AddButton({Name = "SOLTAR TRANSPBOX", Description = "Libera todas as TranspBox soldadas", Callback = soltarPecas})

MagnetTab:AddSection({Name = "Parametros de Redimensionamento"})
MagnetTab:AddSlider({
    Name = "Raio do Campo Magnetico",
    Min = 10, Max = 100, Default = settings.raioPuxar, Color = Color3.fromRGB(0, 200, 255),
    Increment = 5, ValueName = "studs",
    Callback = function(Value) settings.raioPuxar = Value end
})
MagnetTab:AddSlider({
    Name = "Altura do Agrupamento (Pilha)",
    Min = 1, Max = 6, Default = settings.alturaPilha, Color = Color3.fromRGB(0, 200, 255),
    Increment = 0.5, ValueName = "studs",
    Callback = function(Value) settings.alturaPilha = Value; atualizarPilha() end
})
MagnetTab:AddSlider({
    Name = "Distancia a Frente",
    Min = 1, Max = 10, Default = 3, Color = Color3.fromRGB(0, 200, 255),
    Increment = 0.5, ValueName = "studs",
    Callback = function(Value) settings.posicaoZ = Value; atualizarPilha() end
})

MagnetTab:AddSection({Name = "Status do Sistema"})
PecasLabel = MagnetTab:AddLabel("📦 TranspBox acopladas: 0")

task.spawn(function()
    while true do
        task.wait(0.5)
        if PecasLabel then
            PecasLabel:Set("📦 TranspBox acopladas: " .. #grabbedParts .. (isWelded and " Soldadas" or " Parado"))
        end
    end
end)

-- ===== ABA ENTREGA =====
EntregaTab:AddSection({Name = "Seletor de Rota Espacial"})
local opcoes = {}
for i, dado in ipairs(coordenadas) do table.insert(opcoes, i .. ". " .. dado.nome) end

EntregaTab:AddDropdown({
    Name = "Selecione o destino",
    Default = "",
    Options = opcoes,
    Callback = function(opt)
        local index = tonumber(string.match(opt, "^(%d+)"))
        if index then localSelecionado = coordenadas[index] end
    end
})

EntregaTab:AddSection({Name = "Executaveis Logisticos"})
EntregaTab:AddButton({Name = "INICIAR TRANSPORTE VETORIAL", Description = "Teleporta para o destino selecionado", Callback = entregar})
EntregaTab:AddButton({Name = "RETORNAR A ORIGEM", Description = "Volta para ultima posicao registrada", Callback = voltar})

EntregaTab:AddSection({Name = "Experimental"})
EntregaTab:AddButton({Name = "ENTREGA AUTOMATICA (EXPERIMENTAL)", Description = "Detecta e teleporta para destinos ativos", Callback = entregarAutomatico})
AutoStatusLabel = EntregaTab:AddLabel("🤖 Status Auto: Aguardando...")

EntregaTab:AddSection({Name = "Telemetria Operacional"})
StatusLabel = EntregaTab:AddLabel("Modulo System: Aguardando Acoes.")
PosLabel = EntregaTab:AddLabel("Posicao atual: Carregando dados vetoriais...")
UltimaPosLabel = EntregaTab:AddLabel("Ultima posicao: Nenhuma armazenada.")

-- ===== ABA COORDENADAS =====
CoordTab:AddSection({Name = "Banco de Dados Estrutural"})
for i, dado in ipairs(coordenadas) do
    CoordTab:AddLabel(i .. ". " .. dado.nome .. " | X: " .. string.format("%.2f", dado.posicao.X) .. " Y: " .. string.format("%.2f", dado.posicao.Y) .. " Z: " .. string.format("%.2f", dado.posicao.Z))
end

CoordTab:AddButton({
    Name = "EXPORTAR BANCO PARA AREA DE TRANSFERENCIA",
    Description = "Copia todas as coordenadas para o clipboard",
    Callback = function()
        local texto = "========================================\n📍 DATA EXPORT: MEC BR ULTIMATE\n========================================\n"
        for i, dado in ipairs(coordenadas) do
            texto = texto .. string.format("%d. %s -> Vector3.new(%.2f, %.2f, %.2f)\n", i, dado.nome, dado.posicao.X, dado.posicao.Y, dado.posicao.Z)
        end
        local sucesso = pcall(function() setclipboard(texto) end)
        OrionLib:MakeNotification({Name = sucesso and "Exportado" or "Falha", Content = sucesso and "Dados copiados com sucesso." or "Restricao de permissao do exploit.", Image = "rbxassetid://4483345998", Time = 3})
    end
})

-- ===== ABA INFORMATIVO =====
InfoTab:AddSection({Name = "System Specifications"})
InfoTab:AddLabel("build_version: 3.8.0-pro")
InfoTab:AddLabel("core_framework: Orion Library")
InfoTab:AddLabel("magnet_system: Weld (Solda) - TranspBox Only")
InfoTab:AddLabel("teleport_system: Vector3 CFrame")
InfoTab:AddLabel("sound_engine: RbxSoundID")
InfoTab:AddLabel("particle_fx: ParticleEmitter + Explosion")
InfoTab:AddSection({Name = "Desenvolvido Por"})
InfoTab:AddLabel("Chora_Argumento & Petrix")
InfoTab:AddLabel("Discord: https://discord.gg/7dkp6uhYNb")
InfoTab:AddSection({Name = "Alvo"})
InfoTab:AddLabel("Nome: TranspBox")
InfoTab:AddLabel("Local: Workspace.GrabStuff")
InfoTab:AddLabel("Posicao: -25705.14, 31.83, -5854.22")

-- ===== ABA CREDITOS =====
CreditsTab:AddSection({Name = "Desenvolvedores"})
CreditsTab:AddLabel("Chora_Argumento")
CreditsTab:AddLabel("Petrix")
CreditsTab:AddLabel("")
CreditsTab:AddSection({Name = "Bibliotecas"})
CreditsTab:AddLabel("Orion Library - Menu UI (substituiu Rayfield)")
CreditsTab:AddLabel("")
CreditsTab:AddSection({Name = "Links"})
CreditsTab:AddLabel("Discord: https://discord.gg/7dkp6uhYNb")
CreditsTab:AddLabel("YouTube: https://www.youtube.com/@ChoraArgumento")

CreditsTab:AddButton({
    Name = "COPIAR LINK DO DISCORD",
    Description = "Copia o link do servidor Discord",
    Callback = function()
        pcall(function() setclipboard("https://discord.gg/7dkp6uhYNb") end)
        OrionLib:MakeNotification({Name = "Copiado!", Content = "Link do Discord copiado!", Image = "rbxassetid://4483345998", Time = 2})
    end
})

CreditsTab:AddSection({Name = "Aviso Importante"})
CreditsTab:AddLabel("ESTE PROGRAMA FOI DESENVOLVIDO EXCLUSIVAMENTE")
CreditsTab:AddLabel("PARA FINS DE ENTRETENIMENTO E APRENDIZADO.")
CreditsTab:AddLabel("")
CreditsTab:AddLabel("NAO UTILIZE ESTE SCRIPT PARA:")
CreditsTab:AddLabel("Prejudicar a experiencia de outros jogadores")
CreditsTab:AddLabel("Obter vantagem competitiva desleal")
CreditsTab:AddLabel("Praticar qualquer forma de assedio ou toxidade")
CreditsTab:AddLabel("Violar os termos de servico da plataforma")
CreditsTab:AddLabel("")
CreditsTab:AddLabel("USE COM RESPONSABILIDADE")
CreditsTab:AddLabel("RESPEITE OS DEMAIS JOGADORES")
CreditsTab:AddLabel("DIVIRTA-SE DE FORMA SAUDAVEL")
CreditsTab:AddLabel("")
CreditsTab:AddLabel("Chora_Argumento & Petrix")
CreditsTab:AddLabel("Obrigado por usar nosso script!")
CreditsTab:AddLabel("2026 - Todos os direitos reservados")

-- =============================================================================
-- [10] KEYBIND PRA OCULTAR/MOSTRAR UI
-- =============================================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        Window:Toggle()
    end
end)

-- =============================================================================
-- [11] DAEMONS
-- =============================================================================

RunService.Heartbeat:Connect(function()
    local success, err = pcall(function()
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart and PosLabel then
            local pos = rootPart.Position
            PosLabel:Set(string.format("Posicao atual: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z))
        end
        if UltimaPosLabel then
            if ultimaPosicao then
                UltimaPosLabel:Set(string.format("Ultima posicao: %.1f, %.1f, %.1f", ultimaPosicao.X, ultimaPosicao.Y, ultimaPosicao.Z))
            else
                UltimaPosLabel:Set("Ultima posicao: Nenhuma armazenada.")
            end
        end
        if #grabbedParts > 0 then limparPecasFantasma() end
    end)
    if not success and err then warn("[MEC BR] Heartbeat error: " .. tostring(err)) end
end)

task.spawn(function()
    while true do
        task.wait(2)
        if isWelded and #grabbedParts > 0 then pcall(atualizarPilha) end
    end
end)

-- =============================================================================
-- [12] LIMPEZA
-- =============================================================================
LocalPlayer.CharacterAdded:Connect(function()
    isWelded = false
    puxando = false
    entregando = false
    for _, part in ipairs(grabbedParts) do
        if welds[part] then welds[part]:Destroy(); welds[part] = nil end
        if part and part.Parent then
            part.CanCollide = true
            part.Massless = false
            part.CustomPhysicalProperties = nil
            part.Transparency = math.max(0, (part.Transparency or 0) - 0.15)
        end
    end
    grabbedParts = {}
    welds = {}
end)

-- =============================================================================
-- [13] INICIALIZACAO
-- =============================================================================
print("========================================")
print("🚀 MEC BR ULTIMATE - v3.8 (Orion Edition)")
print("👨‍💻 Desenvolvido por: Chora_Argumento & Petrix")
print("========================================")
print("[SYSTEM] UI Framework: Orion Library")
print("[SYSTEM] Magnet System: Weld (Solda) - TranspBox Only")
print("[SYSTEM] Teleport System: Vector3 CFrame")
print("[SYSTEM] Sound Engine: RbxSoundID")
print("[SYSTEM] Particle FX: ParticleEmitter + Explosion")
print("[SYSTEM] Coordenadas carregadas: " .. #coordenadas)
print("========================================")
print("Pressione K para ocultar/exibir a UI")
print("========================================")

OrionLib:MakeNotification({Name = "🚀 MEC BR ULTIMATE v3.8", Content = "Portado para Orion Library por Chora_Argumento & Petrix", Image = "rbxassetid://4483345998", Time = 5})
OrionLib:MakeNotification({Name = "AVISO IMPORTANTE", Content = "Use com responsabilidade! Respeite os jogadores!", Image = "rbxassetid://4483345998", Time = 5})
OrionLib:Init()
