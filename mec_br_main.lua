-- =============================================================================
-- 🚀 MEC BR ULTIMATE | ENTERPRISE EDITION v4.0
-- =============================================================================
-- ███╗   ███╗███████╗ ██████╗    ██████╗ ██████╗ 
-- ████╗ ████║██╔════╝██╔════╝    ██╔══██╗██╔══██╗
-- ██╔████╔██║█████╗  ██║         ██████╔╝██████╔╝
-- ██║╚██╔╝██║██╔══╝  ██║         ██╔══██╗██╔══██╗
-- ██║ ╚═╝ ██║███████╗╚██████╗    ██████╔╝██║  ██║
-- ╚═╝     ╚═╝╚══════╝ ╚═════╝    ╚═════╝ ╚═╝  ╚═╝
-- =============================================================================
-- Framework: Rayfield UI (https://sirius.menu/rayfield)
-- Desenvolvido por: Chora_Argumento & Petrix
-- =============================================================================

-- =============================================================================
-- 🔒 SECURITY: ANTI-BYPASS (SecretCode) — NÃO REMOVA
-- =============================================================================
local SECRET_KEY = "MEC_BR_SECRET_2026"
if not _G[SECRET_KEY] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("🛡️ Execução não autorizada!\n\nUse o Key System oficial para executar o MEC BR ULTIMATE v4.0.\nby Chora_Argumento & Petrix")
    end
    return
end
_G[SECRET_KEY] = nil
-- =============================================================================

-- =============================================================================
-- [1] SERVICES
-- =============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- =============================================================================
-- [2] RAYFIELD UI
-- =============================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- =============================================================================
-- [3] STATE VARIABLES
-- =============================================================================
local ultimaPosicao = nil
local localSelecionado = nil
local entregando = false
local puxando = false

local grabbedParts = {}
local isWelded = false

local autoCollectRunning = false
local autoDeliverRunning = false
local autoCollectThread = nil
local autoDeliverThread = nil
local autoReturnEnabled = false

local currentSpeed = 16
local currentJumpPower = 50
local noclipEnabled = false
local noclipConn = nil
local antiAfkEnabled = false
local antiAfkConn = nil

local espEnabled = false
local espHighlights = {}
local espConn = nil

local stats = {
    deliveries = 0,
    partsCollected = 0,
    totalPartsGrabbed = 0,
    sessionsCount = 0,
    startTime = tick(),
}

local customPositions = {}
local rangeBeacon = nil
local showRangeVisual = false
local soundEnabled = true
local autoReleaseEnabled = true
local autoReleaseDaemon = nil

local settings = {
    raioPuxar = 50,
    alturaPilha = 2.5,
    posicaoX = 0,
    posicaoZ = 3,
    collectInterval = 10,
    deliverInterval = 15,
    speed = 16,
    jumpPower = 50,
}

-- =============================================================================
-- [4] COORDENATES DATABASE
-- =============================================================================
local coordenadas = {
    {nome = "Auto Peças", posicao = Vector3.new(-3335.28, 65.69, -3400.30)},
    {nome = "Posto de Gasolina", posicao = Vector3.new(-3232.68, 66.07, -3704.04)},
    {nome = "Ferro Velho", posicao = Vector3.new(-3131.48, 65.67, -4247.97)},
    {nome = "Drag", posicao = Vector3.new(-3900.53, 64.81, -4890.13)},
    {nome = "Concessionária", posicao = Vector3.new(-3041.93, 65.49, -3694.85)},
    {nome = "Construção", posicao = Vector3.new(-3649.34, 65.17, -2504.47)},
    {nome = "Entregas", posicao = Vector3.new(-25688.55, 32.99, -5885.05)},
}

-- =============================================================================
-- [5] SOUND SYSTEM
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
    if not soundEnabled then return end
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

-- =============================================================================
-- [6] EFFECTS SYSTEM
-- =============================================================================
-- [6] EFFECTS SYSTEM
-- =============================================================================
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

-- =============================================================================
-- [6B] PROXIMITY MONITOR — Auto-release when entering drop circle
-- =============================================================================
local RAIO_CIRCULO = 12

local function getActiveDestinations()
    local transportJob = Workspace:FindFirstChild("TransportJobWorkings")
    if not transportJob then return {} end
    local destinations = transportJob:FindFirstChild("Destinations")
    if not destinations then return {} end

    local ativos = {}
    for _, destinoFolder in ipairs(destinations:GetChildren()) do
        if destinoFolder:IsA("Folder") or destinoFolder:IsA("Model") then
            local dropArea = destinoFolder:FindFirstChild("DropArea")
            if dropArea and dropArea:IsA("BasePart") then
                table.insert(ativos, {
                    nome = destinoFolder.Name,
                    posicao = dropArea.Position,
                })
            end
        end
    end
    return ativos
end

local function iniciarMonitorProximidade(posicaoAlvo, nomeLocal)
    if not autoReleaseEnabled then return end
    if #grabbedParts == 0 then return end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local dist = (rootPart.Position - posicaoAlvo).Magnitude
    if dist <= RAIO_CIRCULO then
        Rayfield:Notify({Title = "📍 Entrou no círculo!", Content = "Destino: " .. nomeLocal .. " | Soltando peças...", Duration = 2})
        soltarPecas()
        return
    end

    if autoReleaseDaemon then
        autoReleaseDaemon:Disconnect()
        autoReleaseDaemon = nil
    end

    autoReleaseDaemon = RunService.Heartbeat:Connect(function()
        if not autoReleaseEnabled or #grabbedParts == 0 then
            if autoReleaseDaemon then autoReleaseDaemon:Disconnect() autoReleaseDaemon = nil end
            return
        end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local d = (root.Position - posicaoAlvo).Magnitude
        if d <= RAIO_CIRCULO then
            if autoReleaseDaemon then autoReleaseDaemon:Disconnect() autoReleaseDaemon = nil end
            Rayfield:Notify({Title = "📍 No círculo de entrega!", Content = nomeLocal .. " | Soltando peças...", Duration = 2})
            pcall(soltarPecas)
        end
    end)
end

local function iniciarDaemonProximidadeGlobal()
    if autoReleaseDaemon then
        autoReleaseDaemon:Disconnect()
        autoReleaseDaemon = nil
    end
    if not autoReleaseEnabled or #grabbedParts == 0 then return end

    autoReleaseDaemon = RunService.Heartbeat:Connect(function()
        if not autoReleaseEnabled or #grabbedParts == 0 then
            if autoReleaseDaemon then autoReleaseDaemon:Disconnect() autoReleaseDaemon = nil end
            return
        end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local alvos = getActiveDestinations()
        if #alvos == 0 then return end

        local playerPos = root.Position
        for _, alvo in ipairs(alvos) do
            local d = (playerPos - alvo.posicao).Magnitude
            if d <= RAIO_CIRCULO then
                if autoReleaseDaemon then autoReleaseDaemon:Disconnect() autoReleaseDaemon = nil end
                Rayfield:Notify({Title = "📍 No círculo de entrega!", Content = alvo.nome .. " | Soltando peças...", Duration = 2})
                pcall(soltarPecas)
                stats.deliveries = stats.deliveries + 1
                return
            end
        end
    end)
end

local function pararMonitorProximidade()
    if autoReleaseDaemon then
        autoReleaseDaemon:Disconnect()
        autoReleaseDaemon = nil
    end
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
-- [7] WELD SYSTEM
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

local function findMECWeld(part)
    local w = part:FindFirstChild("MEC_Weld")
    if w then return w end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        for _, child in ipairs(root:GetChildren()) do
            if child:IsA("Weld") and child.Name == "MEC_Weld" and child.Part1 == part then
                return child
            end
        end
    end
    return nil
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
            pcall(function()
                local w = findMECWeld(part)
                if w then w:Destroy() end
            end)
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

    part.Anchored = false
    part.CanCollide = false
    part.Massless = true
    part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)

    local index = #grabbedParts
    local altura = index * settings.alturaPilha + 1.5

    local weld = Instance.new("Weld")
    weld.Name = "MEC_Weld"
    weld.Part0 = rootPart
    weld.Part1 = part
    weld.C0 = CFrame.new(settings.posicaoX or 0, altura, settings.posicaoZ or 3)
    weld.Parent = part

    table.insert(grabbedParts, part)
    stats.totalPartsGrabbed = stats.totalPartsGrabbed + 1
    stats.partsCollected = stats.partsCollected + 1

    pcall(function()
        criarParticulas(CFrame.new(part.Position), Color3.fromRGB(0, 255, 200), 20, 0.8)
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
    for index, part in ipairs(grabbedParts) do
        if part and part.Parent then
            local w = findMECWeld(part)
            if w then
                local altura = (index - 1) * settings.alturaPilha + 1.5
                w.C0 = CFrame.new(settings.posicaoX or 0, altura, settings.posicaoZ or 3)
            end
        end
    end
end

local function puxarPecas()
    if puxando then
        tocarSom(SONS.erro, 0.4)
        return Rayfield:Notify({Title = "⏳ Ocupado", Content = "Aguarde o ciclo atual.", Duration = 2})
    end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        puxando = false
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Falha", Content = "HumanoidRootPart não encontrado.", Duration = 3})
    end
    puxando = true
    local count = 0
    local radius = settings.raioPuxar or 50
    tocarSom(SONS.scan, 0.3)
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
        local source = grabStuff or Workspace
        for _, v in ipairs(source:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "TranspBox" and not v.Anchored then
                local dist = (v.Position - rootPart.Position).Magnitude
                if dist < radius and not isAlreadyGrabbed(v) then table.insert(partsToProcess, v) end
            end
        end
        for _, part in ipairs(partsToProcess) do
            if part and part.Parent then
                if weldGrabPart(part) then count = count + 1 task.wait(0.03) end
            end
        end
        isWelded = true
        puxando = false
        if count > 0 then
            tocarSom(SONS.pegar, 0.4)
            Rayfield:Notify({Title = "✅ Sucesso", Content = count .. " TranspBox soldadas!", Duration = 3})
            if autoReleaseEnabled then iniciarDaemonProximidadeGlobal() end
        else
            tocarSom(SONS.erro, 0.4)
            Rayfield:Notify({Title = "❌ Nada", Content = "Nenhuma TranspBox próxima.", Duration = 2})
        end
    end)
end

local function soltarPecas()
    local count = #grabbedParts
    if count == 0 then
        tocarSom(SONS.erro, 0.3)
        return Rayfield:Notify({Title = "ℹ️ Info", Content = "Nenhuma TranspBox para soltar.", Duration = 2})
    end
    isWelded = false
    local partsCopy = {}
    for _, p in ipairs(grabbedParts) do partsCopy[#partsCopy + 1] = p end

    for _, part in ipairs(partsCopy) do
        pcall(function()
            local w = findMECWeld(part)
            if w then w:Destroy() end
            if part and part.Parent then
                part.CanCollide = true
                part.Massless = false
                part.CustomPhysicalProperties = nil
                part.Velocity = Vector3.new(0, 0, 0)
                criarParticulas(CFrame.new(part.Position), Color3.fromRGB(255, 100, 0), 30, 1)
                criarExplosaoVisual(CFrame.new(part.Position), Color3.fromRGB(255, 100, 0), 3)
            end
        end)
    end
    grabbedParts = {}
    tocarSom(SONS.soltar, 0.5)
    Rayfield:Notify({Title = "🔄 Reset", Content = count .. " TranspBox soltas!", Duration = 2})
end

-- =============================================================================
-- [8] TELEPORT SYSTEM
-- =============================================================================
local function entregar()
    if not localSelecionado then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Erro", Content = "Destino não selecionado.", Duration = 3})
    end
    if entregando then return end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        entregando = false
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Erro", Content = "Personagem indisponível.", Duration = 3})
    end
    entregando = true
    ultimaPosicao = rootPart.Position
    tocarSom(SONS.teleporte, 0.4)
    Rayfield:Notify({Title = "🚚 Roteando", Content = "Destino: " .. localSelecionado.nome, Duration = 2})
    criarEfeitoTeletransporte(character, localSelecionado.posicao + Vector3.new(0, 5, 0))
    task.wait(0.2)
    rootPart.CFrame = CFrame.new(localSelecionado.posicao + Vector3.new(0, 5, 0))
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    task.wait(0.1)
    stats.deliveries = stats.deliveries + 1
    tocarSom(SONS.sucesso, 0.5)
    Rayfield:Notify({Title = "✅ Concluído", Content = "Posicionado em: " .. localSelecionado.nome .. " | Aproxime-se para soltar", Duration = 3})
    entregando = false

    iniciarMonitorProximidade(localSelecionado.posicao, localSelecionado.nome)
end

local function voltar()
    if not ultimaPosicao then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Ausente", Content = "Nenhum vetor anterior.", Duration = 3})
    end
    if entregando then return end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        entregando = false
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Erro", Content = "Personagem não disponível.", Duration = 2})
    end
    local destino = ultimaPosicao
    tocarSom(SONS.retorno, 0.4)
    Rayfield:Notify({Title = "↩️ Retornando", Content = "à coordenada de origem.", Duration = 2})
    criarEfeitoTeletransporte(character, destino + Vector3.new(0, 5, 0))
    task.wait(0.2)
    rootPart.CFrame = CFrame.new(destino + Vector3.new(0, 5, 0))
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    task.wait(0.1)
    tocarSom(SONS.sucesso, 0.5)
    Rayfield:Notify({Title = "✅ Concluído", Content = "Retorno executado.", Duration = 3})
end

-- =============================================================================
-- [9] AUTO DELIVERY
-- =============================================================================
local function isPartVisible(part)
    if not part or not part.Parent then return false end
    if part:IsA("BasePart") and part.Transparency < 0.9 and part.Size.Magnitude > 0.5 then return true end
    for _, child in ipairs(part:GetDescendants()) do
        if (child:IsA("BillboardGui") or child:IsA("SelectionBox") or child:IsA("SelectionLasso")) and child.Enabled == true then return true end
        local nome = child.Name:lower()
        if nome:find("arrow") or nome:find("pointer") or nome:find("indicator") or nome:find("marker") then return true end
        if child:IsA("BoolValue") then
            local n = child.Name:lower()
            if (n == "active" or n == "enabled" or n == "visible") and child.Value == true then return true end
        end
    end
    pcall(function()
        if part:GetAttribute("Active") == true then return true end
        if part:GetAttribute("State") == "Active" then return true end
    end)
    return false
end

local function isDestinoAtivo(destinoFolder)
    if not destinoFolder then return false end
    local dropArea = destinoFolder:FindFirstChild("DropArea")
    if dropArea and dropArea:IsA("BasePart") and isPartVisible(dropArea) then return true end
    local details = destinoFolder:FindFirstChild("Details")
    if details then
        local spin = details:FindFirstChild("Spin")
        if spin and spin:IsA("BasePart") and isPartVisible(spin) then return true end
        local decal = details:FindFirstChild("Decal")
        if decal and decal:IsA("BasePart") and isPartVisible(decal) then return true end
    end
    for _, child in ipairs(destinoFolder:GetDescendants()) do
        if (child:IsA("BillboardGui") or child:IsA("SelectionBox") or child:IsA("SelectionLasso")) and child.Enabled == true then return true end
        local nome = child.Name:lower()
        if (nome:find("arrow") or nome:find("pointer") or nome:find("indicator") or nome:find("marker")) and child:IsA("BasePart") and child.Transparency < 0.9 then return true end
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
    if entregando then return Rayfield:Notify({Title = "⏳ Ocupado", Content = "Aguarde a entrega atual.", Duration = 2}) end
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return Rayfield:Notify({Title = "❌ Erro", Content = "Personagem não disponível.", Duration = 2}) end
    local transportJob = Workspace:FindFirstChild("TransportJobWorkings")
    if not transportJob then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Ausente", Content = "TransportJobWorkings não encontrado.", Duration = 3})
    end
    local destinations = transportJob:FindFirstChild("Destinations")
    if not destinations then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Ausente", Content = "Destinations não encontrada.", Duration = 3})
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
                local info = {nome = destinoFolder.Name, posicao = dropArea.Position, ativo = ativo}
                if ativo then table.insert(dropAreasValidas, info) else table.insert(dropAreasInativas, info) end
            end
        end
    end
    if #dropAreasValidas == 0 then
        tocarSom(SONS.erro, 0.5)
        if #dropAreasInativas > 0 then
            local nomes = {}
            for _, area in ipairs(dropAreasInativas) do table.insert(nomes, area.nome) end
            return Rayfield:Notify({Title = "❌ Inativos", Content = "Destinos: " .. table.concat(nomes, ", "), Duration = 5})
        else
            return Rayfield:Notify({Title = "❌ Vazio", Content = "Nenhuma área de entrega válida.", Duration = 4})
        end
    end
    local escolhido = nil
    local menorDist = math.huge
    for _, area in ipairs(dropAreasValidas) do
        local dist = (area.posicao - rootPart.Position).Magnitude
        if dist < menorDist then menorDist = dist escolhido = area end
    end
    if not escolhido then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Erro", Content = "Seleção de destino falhou.", Duration = 2})
    end
    entregando = true
    if autoReturnEnabled and ultimaPosicao == nil then ultimaPosicao = rootPart.Position elseif not autoReturnEnabled then ultimaPosicao = rootPart.Position end
    tocarSom(SONS.teleporte, 0.4)
    Rayfield:Notify({Title = "🚀 Entrega Automática", Content = "Indo para " .. escolhido.nome, Duration = 2})
    criarEfeitoTeletransporte(character, escolhido.posicao + Vector3.new(0, 3, 0))
    task.wait(0.2)
    rootPart.CFrame = CFrame.new(escolhido.posicao + Vector3.new(0, 3, 0))
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    stats.deliveries = stats.deliveries + 1
    tocarSom(SONS.sucesso, 0.5)
    Rayfield:Notify({Title = "✅ Chegou!", Content = "Destino: " .. escolhido.nome .. " | Aproxime-se do círculo para soltar", Duration = 4})
    entregando = false

    iniciarMonitorProximidade(escolhido.posicao, escolhido.nome)

    if autoReturnEnabled and ultimaPosicao then
        task.wait(0.5)
        local retorno = ultimaPosicao
        ultimaPosicao = nil
        pcall(function()
            criarEfeitoTeletransporte(character, retorno + Vector3.new(0, 5, 0))
            task.wait(0.2)
            rootPart.CFrame = CFrame.new(retorno + Vector3.new(0, 5, 0))
            Rayfield:Notify({Title = "↩️ Auto-Retorno", Content = "Voltou à posição anterior.", Duration = 2})
        end)
    end
end

-- =============================================================================
-- [10] AUTO COLLECT
-- =============================================================================
local function autoCollectCycle()
    if autoCollectRunning then
        autoCollectRunning = false
        if autoCollectThread then coroutine.close(autoCollectThread) autoCollectThread = nil end
        return Rayfield:Notify({Title = "⏹️ Auto Coleta", Content = "Desativado.", Duration = 2})
    end
    autoCollectRunning = true
    Rayfield:Notify({Title = "▶️ Auto Coleta", Content = "Intervalo: " .. settings.collectInterval .. "s", Duration = 2})
    autoCollectThread = coroutine.create(function()
        while autoCollectRunning do
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local radius = settings.raioPuxar or 50
                local grabStuff = Workspace:FindFirstChild("GrabStuff")
                local source = grabStuff or Workspace
                for _, v in ipairs(source:GetDescendants()) do
                    if autoCollectRunning and v:IsA("BasePart") and v.Name == "TranspBox" and not v.Anchored then
                        local dist = (v.Position - rootPart.Position).Magnitude
                        if dist < radius and not isAlreadyGrabbed(v) then weldGrabPart(v) task.wait(0.03) end
                    end
                    if #grabbedParts >= 50 then break end
                end
                isWelded = #grabbedParts > 0
            end
            task.wait(settings.collectInterval)
        end
    end)
    coroutine.resume(autoCollectThread)
end

-- =============================================================================
-- [11] AUTO DELIVERY LOOP
-- =============================================================================
local function autoDeliveryCycle()
    if autoDeliverRunning then
        autoDeliverRunning = false
        if autoDeliverThread then coroutine.close(autoDeliverThread) autoDeliverThread = nil end
        return Rayfield:Notify({Title = "⏹️ Auto Entrega", Content = "Loop desativado.", Duration = 2})
    end
    autoDeliverRunning = true
    Rayfield:Notify({Title = "▶️ Auto Entrega", Content = "Loop ativado!", Duration = 2})
    autoDeliverThread = coroutine.create(function()
        while autoDeliverRunning do
            if not entregando then entregarAutomatico() end
            task.wait(settings.deliverInterval)
        end
    end)
    coroutine.resume(autoDeliverThread)
end

-- =============================================================================
-- [12] ESP
-- =============================================================================
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        Rayfield:Notify({Title = "👁️ ESP", Content = "Ativado!", Duration = 2})
        espConn = RunService.Heartbeat:Connect(function()
            if not espEnabled then if espConn then espConn:Disconnect() espConn = nil end return end
            for _, obj in ipairs(espHighlights) do pcall(function() obj:Destroy() end) end
            espHighlights = {}
            local count = 0
            local grabStuff = Workspace:FindFirstChild("GrabStuff")
            local source = grabStuff or Workspace
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            for _, v in ipairs(source:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "TranspBox" and not v.Anchored and rootPart and (v.Position - rootPart.Position).Magnitude < 200 then
                    local hl = Instance.new("Highlight")
                    hl.Name = "MEC_ESP"
                    hl.Adornee = v
                    hl.FillColor = Color3.fromRGB(0, 255, 100)
                    hl.OutlineColor = Color3.fromRGB(0, 200, 255)
                    hl.FillTransparency = 0.6
                    hl.OutlineTransparency = 0.2
                    hl.Parent = CoreGui
                    table.insert(espHighlights, hl)
                    count = count + 1
                end
            end
        end)
    else
        Rayfield:Notify({Title = "👁️ ESP", Content = "Desativado.", Duration = 2})
        for _, obj in ipairs(espHighlights) do pcall(function() obj:Destroy() end) end
        espHighlights = {}
        if espConn then espConn:Disconnect() espConn = nil end
    end
end

-- =============================================================================
-- [13] PLAYER MODS
-- =============================================================================
local function applySpeed(val)
    currentSpeed = val
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = val end
    end
end

local function applyJumpPower(val)
    currentJumpPower = val
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = val end
    end
end

local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        Rayfield:Notify({Title = "👻 NoClip", Content = "Ativado!", Duration = 2})
        noclipConn = RunService.Stepped:Connect(function()
            if not noclipEnabled then if noclipConn then noclipConn:Disconnect() noclipConn = nil end return end
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        Rayfield:Notify({Title = "👻 NoClip", Content = "Desativado.", Duration = 2})
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end

local function toggleAntiAfk()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        Rayfield:Notify({Title = "💤 Anti-AFK", Content = "Ativado!", Duration = 2})
        antiAfkConn = RunService.Heartbeat:Connect(function()
            if not antiAfkEnabled then if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end return end
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                LocalPlayer.Idled:Connect(function()
                    task.wait(0.5)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end)
        end)
    else
        Rayfield:Notify({Title = "💤 Anti-AFK", Content = "Desativado.", Duration = 2})
        if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
    end
end

local function resetCharacter()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = 0 Rayfield:Notify({Title = "🔄 Reset", Content = "Personagem resetado.", Duration = 2}) end
    end
end

-- =============================================================================
-- [14] RANGE VISUALIZER
-- =============================================================================
local function toggleRangeVisual()
    showRangeVisual = not showRangeVisual
    if showRangeVisual then
        Rayfield:Notify({Title = "📡 Alcance", Content = "Visualizador ativado.", Duration = 2})
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        rangeBeacon = Instance.new("Part")
        rangeBeacon.Name = "MEC_RangeBeacon"
        rangeBeacon.Size = Vector3.new(settings.raioPuxar * 2, 0.2, settings.raioPuxar * 2)
        rangeBeacon.Shape = Enum.PartType.Cylinder
        rangeBeacon.Transparency = 0.75
        rangeBeacon.Color = Color3.fromRGB(0, 255, 200)
        rangeBeacon.Material = Enum.Material.Neon
        rangeBeacon.CanCollide = false
        rangeBeacon.Anchored = true
        rangeBeacon.Parent = Workspace
        RunService.Heartbeat:Connect(function()
            if rangeBeacon and rangeBeacon.Parent and showRangeVisual and rootPart then
                rangeBeacon.CFrame = CFrame.new(rootPart.Position.X, rootPart.Position.Y - 1, rootPart.Position.Z)
            elseif rangeBeacon then
                rangeBeacon:Destroy() rangeBeacon = nil
            end
        end)
    else
        Rayfield:Notify({Title = "📡 Alcance", Content = "Visualizador desativado.", Duration = 2})
        if rangeBeacon then rangeBeacon:Destroy() rangeBeacon = nil end
    end
end

-- =============================================================================
-- [15] PLAYER TELEPORT
-- =============================================================================
local function teleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if not target or target == LocalPlayer then return Rayfield:Notify({Title = "❌ Erro", Content = "Jogador inválido.", Duration = 2}) end
    local character = target.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return Rayfield:Notify({Title = "❌ Erro", Content = "Jogador sem personagem.", Duration = 2}) end
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    ultimaPosicao = myRoot.Position
    criarEfeitoTeletransporte(myChar, rootPart.Position + Vector3.new(0, 5, 0))
    task.wait(0.2)
    myRoot.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, 5, 0))
    myRoot.Velocity = Vector3.new(0, 0, 0)
    Rayfield:Notify({Title = "🚀 Teleportado", Content = "Para " .. target.Name, Duration = 3})
end

-- =============================================================================
-- [16] CUSTOM POSITIONS
-- =============================================================================
local function saveCustomPosition(name, pos)
    if not name or name == "" then return Rayfield:Notify({Title = "❌ Erro", Content = "Nome inválido.", Duration = 2}) end
    customPositions[name] = pos
    Rayfield:Notify({Title = "💾 Salvo", Content = name .. " salvo!", Duration = 2})
end

-- =============================================================================
-- [17] UI CONSTRUCTION
-- =============================================================================
local Window = Rayfield:CreateWindow({
    Name = "🚚 MEC BR ULTIMATE v4.0",
    Icon = 0,
    LoadingTitle = "🚀 MEC BR ULTIMATE v4.0",
    LoadingSubtitle = "by Chora_Argumento & Petrix",
    Theme = "Ocean",
    ToggleUIKeybind = "K",
    ConfigurationSaving = { Enabled = true, FileName = "MEC_Ultimate_v4_Config" },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- ========================
-- TAB 1: MAGNÉTICO
-- ========================
local MagnetTab = Window:CreateTab("🧲 Magnético", 0)

MagnetTab:CreateSection("🧲 Controle Operacional")
MagnetTab:CreateButton({ Name = "🧲 PEGAR TRANSPBOX", Callback = puxarPecas })
MagnetTab:CreateButton({ Name = "❌ SOLTAR TRANSPBOX", Callback = soltarPecas })

MagnetTab:CreateSection("⚙️ Parâmetros")
MagnetTab:CreateSlider({
    Name = "📡 Raio do Campo", Range = {10, 100}, Increment = 5, Suffix = " studs",
    CurrentValue = settings.raioPuxar, Flag = "RaioPuxar",
    Callback = function(v) settings.raioPuxar = v end
})
MagnetTab:CreateSlider({
    Name = "📏 Altura da Pilha", Range = {1, 6}, Increment = 0.5, Suffix = " studs",
    CurrentValue = settings.alturaPilha, Flag = "AlturaPilha",
    Callback = function(v) settings.alturaPilha = v atualizarPilha() end
})
MagnetTab:CreateSlider({
    Name = "📏 Distância à Frente", Range = {1, 10}, Increment = 0.5, Suffix = " studs",
    CurrentValue = 3, Flag = "DistanciaFrente",
    Callback = function(v) settings.posicaoZ = v atualizarPilha() end
})

MagnetTab:CreateSection("📊 Status")
PecasLabel = MagnetTab:CreateLabel("📦 TranspBox acopladas: 0")

task.spawn(function()
    while true do
        task.wait(0.5)
        if PecasLabel then
            PecasLabel:Set("📦 TranspBox acopladas: " .. #grabbedParts .. (isWelded and " ✅" or ""))
        end
    end
end)

-- ========================
-- TAB 2: ENTREGA
-- ========================
local EntregaTab = Window:CreateTab("🚚 Entrega", 0)

EntregaTab:CreateSection("📍 Seletor de Rota")
local opcoes = {}
for i, dado in ipairs(coordenadas) do table.insert(opcoes, i .. ". " .. dado.nome) end

EntregaTab:CreateDropdown({
    Name = "Destino", Options = opcoes, CurrentOption = opcoes[1], MultipleOptions = false, Flag = "LocalDropdown",
    Callback = function(opt)
        if #opt > 0 then
            local index = tonumber(string.match(opt[1], "^(%d+)"))
            if index then localSelecionado = coordenadas[index] end
        end
    end
})

EntregaTab:CreateSection("⚡ Executáveis")
EntregaTab:CreateButton({ Name = "🚚 INICIAR TRANSPORTE", Callback = entregar })
EntregaTab:CreateButton({ Name = "↩️ RETORNAR À ORIGEM", Callback = voltar })

EntregaTab:CreateSection("🧪 Experimental")
EntregaTab:CreateButton({ Name = "🚀 ENTREGA AUTOMÁTICA", Callback = entregarAutomatico })
AutoStatusLabel = EntregaTab:CreateLabel("🤖 Auto-Entrega: Aguardando...")
EntregaTab:CreateToggle({
    Name = "↩️ Auto-Retorno após entrega", CurrentValue = false, Flag = "AutoReturn",
    Callback = function(v) autoReturnEnabled = v end
})
EntregaTab:CreateToggle({
    Name = "📍 Auto-Soltar ao entrar no círculo", CurrentValue = true, Flag = "AutoRelease",
    Callback = function(v)
        autoReleaseEnabled = v
        if v then
            if #grabbedParts > 0 then iniciarDaemonProximidadeGlobal() end
        else
            pararMonitorProximidade()
        end
    end
})

EntregaTab:CreateSection("📊 Telemetria")
StatusLabel = EntregaTab:CreateLabel("✅ Sistema: Aguardando ações.")
PosLabel = EntregaTab:CreateLabel("📍 Posição: Carregando...")
UltimaPosLabel = EntregaTab:CreateLabel("📌 Última posição: Nenhuma.")

-- ========================
-- TAB 3: AUTOMAÇÃO
-- ========================
local AutoTab = Window:CreateTab("🤖 Automação", 0)

AutoTab:CreateSection("📦 Coleta Automática")
AutoTab:CreateButton({ Name = "▶️ INICIAR / ⏹️ PARAR", Callback = autoCollectCycle })
AutoTab:CreateSlider({
    Name = "Intervalo de Coleta", Range = {3, 60}, Increment = 1, Suffix = "s",
    CurrentValue = settings.collectInterval, Flag = "CollectInterval",
    Callback = function(v) settings.collectInterval = v end
})
local AutoCollectStatus = AutoTab:CreateLabel("Status: ⏹ Parado")

AutoTab:CreateSection("🚚 Entrega Automática (Loop)")
AutoTab:CreateButton({ Name = "▶️ INICIAR / ⏹️ PARAR", Callback = autoDeliveryCycle })
AutoTab:CreateSlider({
    Name = "Intervalo de Entrega", Range = {5, 120}, Increment = 5, Suffix = "s",
    CurrentValue = settings.deliverInterval, Flag = "DeliverInterval",
    Callback = function(v) settings.deliverInterval = v end
})
local AutoDeliverStatus = AutoTab:CreateLabel("Status: ⏹ Parado")

task.spawn(function()
    while true do
        task.wait(2)
        if AutoCollectStatus then AutoCollectStatus:Set("Status: " .. (autoCollectRunning and "▶️ Ativo" or "⏹ Parado")) end
        if AutoDeliverStatus then AutoDeliverStatus:Set("Status: " .. (autoDeliverRunning and "▶️ Ativo" or "⏹ Parado")) end
    end
end)

-- ========================
-- TAB 4: VISUAL
-- ========================
local VisualTab = Window:CreateTab("👁️ Visual", 0)

VisualTab:CreateSection("👁️ ESP System")
VisualTab:CreateButton({ Name = "👁️ ATIVAR / DESATIVAR ESP", Callback = toggleESP })
local EspCountLabel = VisualTab:CreateLabel("👁️ ESP: Desativado")

VisualTab:CreateSection("📡 Visualizador de Alcance")
VisualTab:CreateButton({ Name = "📡 MOSTRAR / OCULTAR", Callback = toggleRangeVisual })

VisualTab:CreateSection("✨ Efeitos")
VisualTab:CreateToggle({
    Name = "🔊 Efeitos Sonoros", CurrentValue = true, Flag = "SoundEnabled",
    Callback = function(v) soundEnabled = v end
})

-- ========================
-- TAB 5: PLAYER
-- ========================
local PlayerTab = Window:CreateTab("⚡ Player", 0)

PlayerTab:CreateSection("🏃 Controle de Movimento")
PlayerTab:CreateSlider({
    Name = "WalkSpeed", Range = {1, 120}, Increment = 1, Suffix = "",
    CurrentValue = 16, Flag = "WalkSpeed",
    Callback = function(v) currentSpeed = v settings.speed = v applySpeed(v) end
})
PlayerTab:CreateSlider({
    Name = "JumpPower", Range = {10, 200}, Increment = 1, Suffix = "",
    CurrentValue = 50, Flag = "JumpPower",
    Callback = function(v) currentJumpPower = v settings.jumpPower = v applyJumpPower(v) end
})

PlayerTab:CreateSection("🛡️ Modificadores")
PlayerTab:CreateButton({ Name = "👻 ATIVAR / DESATIVAR NOCLIP", Callback = toggleNoClip })
PlayerTab:CreateButton({ Name = "💤 ATIVAR / DESATIVAR ANTI-AFK", Callback = toggleAntiAfk })
PlayerTab:CreateButton({ Name = "🔄 RESETAR PERSONAGEM", Callback = resetCharacter })

-- ========================
-- TAB 6: WAYPOINTS
-- ========================
local WaypointTab = Window:CreateTab("📍 Waypoints", 0)

WaypointTab:CreateSection("👥 Teleporte para Jogador")
local function refreshPlayerList()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end
local playerNames = refreshPlayerList()
WaypointTab:CreateDropdown({
    Name = "Jogador", Options = playerNames, CurrentOption = playerNames[1] or "", MultipleOptions = false, Flag = "PlayerTP",
    Callback = function(opt) if #opt > 0 then teleportToPlayer(opt[1]) end end
})
WaypointTab:CreateButton({ Name = "🔄 ATUALIZAR LISTA", Callback = function()
    local names = refreshPlayerList()
    Rayfield:Notify({Title = "✅ Atualizado", Content = #names .. " jogadores online.", Duration = 2})
end})

WaypointTab:CreateSection("💾 Posições Personalizadas")
WaypointTab:CreateTextbox({
    Name = "Nome da posição", PlaceholderText = "Ex: Minha Base", CurrentValue = "", Flag = "PosInput",
    Callback = function(text)
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root and text and text ~= "" then saveCustomPosition(text, root.Position) end
    end
})
WaypointTab:CreateButton({ Name = "💾 SALVAR POSIÇÃO ATUAL", Callback = function()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then saveCustomPosition("Posição " .. #customPositions + 1, root.Position) end
end})

WaypointTab:CreateSection("📋 Banco de Coordenadas")
for i, dado in ipairs(coordenadas) do
    WaypointTab:CreateLabel(string.format("%d. %s [%.1f, %.1f, %.1f]", i, dado.nome, dado.posicao.X, dado.posicao.Y, dado.posicao.Z))
end
WaypointTab:CreateButton({ Name = "📋 EXPORTAR COORDENADAS", Callback = function()
    local texto = "=== MEC BR v4.0 - Coordenadas ===\n"
    for i, dado in ipairs(coordenadas) do
        texto = texto .. string.format("%d. %s -> Vector3.new(%.2f, %.2f, %.2f)\n", i, dado.nome, dado.posicao.X, dado.posicao.Y, dado.posicao.Z)
    end
    pcall(function() setclipboard(texto) end)
    Rayfield:Notify({Title = "📋 Exportado", Content = "Coordenadas copiadas!", Duration = 3})
end})

-- ========================
-- TAB 7: ESTATÍSTICAS
-- ========================
local StatsTab = Window:CreateTab("📊 Estatísticas", 0)

StatsTab:CreateSection("📈 Painel de Estatísticas")
local function getStatsText()
    local elapsed = math.floor(tick() - stats.startTime)
    local mins = math.floor(elapsed / 60)
    local secs = elapsed % 60
    return string.format(
        "🚚 Entregas: %d\n📦 Coletadas: %d\n📋 Total já coletado: %d\n⏱ Tempo: %dm %ds\n🧲 Peças atuais: %d\n📡 Raio: %d",
        stats.deliveries, stats.partsCollected, stats.totalPartsGrabbed, mins, secs, #grabbedParts, settings.raioPuxar
    )
end
local StatsLabel = StatsTab:CreateLabel(getStatsText())

StatsTab:CreateButton({ Name = "🔄 ATUALIZAR", Callback = function() if StatsLabel then StatsLabel:Set(getStatsText()) end end })
StatsTab:CreateButton({ Name = "🗑️ ZERAR ESTATÍSTICAS", Callback = function()
    stats = {deliveries = 0, partsCollected = 0, totalPartsGrabbed = 0, sessionsCount = 0, startTime = tick()}
    if StatsLabel then StatsLabel:Set(getStatsText()) end
    Rayfield:Notify({Title = "🗑️ Zerado", Content = "Estatísticas resetadas.", Duration = 2})
end})

task.spawn(function()
    while true do
        task.wait(5)
        if StatsLabel then StatsLabel:Set(getStatsText()) end
    end
end)

-- ========================
-- TAB 8: CONFIG & INFO
-- ========================
local ConfigTab = Window:CreateTab("⚙️ Config", 0)

ConfigTab:CreateSection("⌨️ Atalhos")
ConfigTab:CreateKeybind({
    Name = "Abrir/Fechar UI", CurrentKeybind = "K", Flag = "UIKeybind",
    Callback = function() end
})
ConfigTab:CreateKeybind({
    Name = "❌ SOLTAR PEÇAS (manual)", CurrentKeybind = "G", Flag = "SoltarKey",
    Callback = function()
        if #grabbedParts > 0 then
            pcall(soltarPecas)
        end
    end
})

ConfigTab:CreateSection("💾 Config Manager")
ConfigTab:CreateButton({ Name = "💾 SALVAR CONFIG", Callback = function()
    local cfg = {
        raioPuxar = settings.raioPuxar, alturaPilha = settings.alturaPilha,
        posicaoZ = settings.posicaoZ, collectInterval = settings.collectInterval,
        deliverInterval = settings.deliverInterval, speed = settings.speed,
        jumpPower = settings.jumpPower, autoReturn = autoReturnEnabled, soundEnabled = soundEnabled,
    }
    local ok, err = pcall(function() writefile("MEC_BR_v4_config.json", HttpService:JSONEncode(cfg)) end)
    Rayfield:Notify({Title = ok and "💾 Salvo" or "❌ Erro", Content = ok and "Configuração salva!" or tostring(err), Duration = 3})
end})
ConfigTab:CreateButton({ Name = "📂 CARREGAR CONFIG", Callback = function()
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile("MEC_BR_v4_config.json")) end)
    if ok and data then
        settings.raioPuxar = data.raioPuxar or settings.raioPuxar
        settings.alturaPilha = data.alturaPilha or settings.alturaPilha
        settings.posicaoZ = data.posicaoZ or settings.posicaoZ
        settings.collectInterval = data.collectInterval or settings.collectInterval
        settings.deliverInterval = data.deliverInterval or settings.deliverInterval
        settings.speed = data.speed or settings.speed
        settings.jumpPower = data.jumpPower or settings.jumpPower
        autoReturnEnabled = data.autoReturn or false
        soundEnabled = (data.soundEnabled ~= false)
        applySpeed(settings.speed)
        applyJumpPower(settings.jumpPower)
        Rayfield:Notify({Title = "📂 Carregado", Content = "Configuração carregada!", Duration = 2})
    else
        Rayfield:Notify({Title = "❌ Erro", Content = "Nenhuma config salva.", Duration = 3})
    end
end})

ConfigTab:CreateSection("ℹ️ Sistema")
ConfigTab:CreateLabel("• build: v4.0.0-enterprise")
ConfigTab:CreateLabel("• framework: Rayfield UI")
ConfigTab:CreateLabel("• magnet: Weld (TranspBox)")
ConfigTab:CreateLabel("• teleport: Vector3 CFrame")
ConfigTab:CreateLabel("• Desenvolvido por: Chora_Argumento & Petrix")

ConfigTab:CreateSection("⚠️ Aviso")
ConfigTab:CreateLabel("Use com responsabilidade! Respeite os jogadores!")
ConfigTab:CreateButton({ Name = "📋 COPIAR LINK DISCORD", Callback = function()
    pcall(function() setclipboard("https://discord.gg/7dkp6uhYNb") end)
    Rayfield:Notify({Title = "📋 Copiado!", Content = "Link do Discord copiado!", Duration = 2})
end})

-- =============================================================================
-- [18] DAEMONS
-- =============================================================================
RunService.Heartbeat:Connect(function()
    pcall(function()
        if #grabbedParts > 0 then
            atualizarPilha()
            limparPecasFantasma()
        end
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            if PosLabel then
                local p = rootPart.Position
                PosLabel:Set(string.format("📍 Posição: %.1f, %.1f, %.1f", p.X, p.Y, p.Z))
            end
            if UltimaPosLabel then
                if ultimaPosicao then
                    UltimaPosLabel:Set(string.format("📌 Última: %.1f, %.1f, %.1f", ultimaPosicao.X, ultimaPosicao.Y, ultimaPosicao.Z))
                else
                    UltimaPosLabel:Set("📌 Última posição: Nenhuma")
                end
            end
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(2)
        if isWelded and #grabbedParts > 0 then
            pcall(atualizarPilha)
            if autoReleaseEnabled and not autoReleaseDaemon then
                pcall(iniciarDaemonProximidadeGlobal)
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    isWelded = false
    puxando = false
    entregando = false
    for _, part in ipairs(grabbedParts) do
        pcall(function()
            local w = findMECWeld(part)
            if w then w:Destroy() end
            if part and part.Parent then
                part.CanCollide = true
                part.Massless = false
                part.CustomPhysicalProperties = nil
                part.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
    grabbedParts = {}
    task.wait(1)
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = currentSpeed hum.JumpPower = currentJumpPower end
        end
    end)
end)

local function onCleanup()
    isWelded = false; puxando = false; entregando = false
    autoCollectRunning = false; autoDeliverRunning = false; noclipEnabled = false; antiAfkEnabled = false
    if autoCollectThread then coroutine.close(autoCollectThread) autoCollectThread = nil end
    if autoDeliverThread then coroutine.close(autoDeliverThread) autoDeliverThread = nil end
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
    if espConn then espConn:Disconnect() espConn = nil end
    pararMonitorProximidade()
    for _, part in ipairs(grabbedParts) do
        pcall(function()
            local w = findMECWeld(part)
            if w then w:Destroy() end
        end)
    end
    grabbedParts = {}
    for _, obj in ipairs(espHighlights) do pcall(function() obj:Destroy() end) end
    espHighlights = {}
    if rangeBeacon then pcall(function() rangeBeacon:Destroy() end) end
end

pcall(function()
    if LocalPlayer.OnCleanup then LocalPlayer.OnCleanup:Connect(onCleanup) end
end)

-- =============================================================================
-- [19] INIT
-- =============================================================================
print("========================================")
print("🚀 MEC BR ULTIMATE - v4.0 ENTERPRISE")
print("👨‍💻 Desenvolvido por: Chora_Argumento & Petrix")
print("📦 Framework: Rayfield UI")
print("========================================")
print("🆕 NOVIDADES v4.0:")
print("  • ESP por Highlight")
print("  • Auto Coleta em loop")
print("  • Auto Entrega em loop")
print("  • Auto-Retorno após entrega")
print("  • NoClip / Anti-AFK")
print("  • Sliders de Speed e Jump")
print("  • Visualizador de Alcance")
print("  • Stats Dashboard")
print("  • Auto-Soltar ao entrar no círculo")
print("  • Config persistente (JSON)")
print("  • Teleporte para jogadores")
print("  • Posições personalizadas")
print("========================================")

Rayfield:Notify({
    Title = "🚀 MEC BR ULTIMATE v4.0",
    Content = "by Chora_Argumento & Petrix | Rayfield UI",
    Duration = 5
})
