-- =============================================================================
-- 🚀 MEC BR ULTIMATE | ENTERPRISE EDITION v3.8
-- =============================================================================
-- ██████╗ ███████╗████████╗██████╗ ██╗██╗  ██╗
-- ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██║╚██╗██╔╝
-- ██████╔╝█████╗     ██║   ██████╔╝██║ ╚███╔╝ 
-- ██╔══██╗██╔══╝     ██║   ██╔══██╗██║ ██╔██╗ 
-- ██║  ██║███████╗   ██║   ██║  ██║██║██╔╝ ██╗
-- ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
-- =============================================================================
-- Desenvolvido por: Chora_Argumento & Petrix
-- Framework UI: Rayfield
-- =============================================================================

-- =============================================================================
-- 🔒 SECURITY: ANTI-BYPASS (SecretCode) — NÃO REMOVA
-- =============================================================================
-- Este script só funciona se carregado pelo mec_br_loader.lua (Key System).
-- Se tentar executar direto sem passar pelo key system, será bloqueado.
-- =============================================================================
local SECRET_KEY = "MEC_BR_SECRET_2026"
if not _G[SECRET_KEY] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("🛡️ Execução não autorizada!\n\nUse o Key System oficial para executar o MEC BR ULTIMATE.\nby Chora_Argumento & Petrix")
    end
    return
end
-- Remove o segredo da memória após verificar (segurança extra)
_G[SECRET_KEY] = nil
-- =============================================================================

-- [1] INICIALIZAÇÃO DE SERVIÇOS & DEPENDÊNCIAS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [2] VARIÁVEIS DE ESTADO
local ultimaPosicao = nil
local localSelecionado = nil
local entregando = false
local puxando = false

-- Variáveis do sistema de solda
local grabbedParts = {}
local welds = {}
local isWelded = false

-- Referências de Elementos UI
local StatusLabel, PosLabel, UltimaPosLabel, PecasLabel, AutoStatusLabel

-- [3] BANCO DE DADOS DE COORDENADAS
local coordenadas = {
    {nome = "Auto Peças", posicao = Vector3.new(-3335.28, 65.69, -3400.30)},
    {nome = "Posto de Gasolina", posicao = Vector3.new(-3232.68, 66.07, -3704.04)},
    {nome = "Ferro Velho", posicao = Vector3.new(-3131.48, 65.67, -4247.97)},
    {nome = "Drag", posicao = Vector3.new(-3900.53, 64.81, -4890.13)},
    {nome = "Concessionária", posicao = Vector3.new(-3041.93, 65.49, -3694.85)},
    {nome = "Construção", posicao = Vector3.new(-3649.34, 65.17, -2504.47)},
    {nome = "Entregas", posicao = Vector3.new(-25688.55, 32.99, -5885.05)},
}

-- [4] CONFIGURAÇÕES
local settings = {
    raioPuxar = 50,
    alturaPilha = 2.5,
    posicaoX = 0,
    posicaoZ = 3,
}

-- =============================================================================
-- [5] SISTEMA DE SOM E EFEITOS VISUAIS
-- =============================================================================

-- Banco de sons (IDs públicos do Roblox)
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

        -- Flash branco no local de origem
        criarParticulas(root.CFrame, Color3.new(1, 1, 1), 80, 2)
        criarExplosaoVisual(root.CFrame, Color3.new(1, 1, 1), 4)

        -- Traço de luz
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

        -- Flash no destino
        criarParticulas(CFrame.new(destino), Color3.fromRGB(0, 200, 255), 60, 2)
        criarExplosaoVisual(CFrame.new(destino), Color3.fromRGB(0, 150, 255), 6)
    end)
end

-- =============================================================================
-- [6] SISTEMA DE SOLDA (WELD) - SÓ PEGA TRANSPBOX
-- =============================================================================

local function isTranspBox(part)
    if not part or not part.Parent then return false end
    if part.Name ~= "TranspBox" then return false end
    if part.Anchored then return false end
    if part:IsDescendantOf(LocalPlayer.Character) then return false end

    local parent = part.Parent
    while parent do
        if parent.Name == "GrabStuff" and parent.Parent == Workspace then
            return true
        end
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
        if not part or not part.Parent then
            table.insert(toRemove, i)
        end
    end
    if #toRemove > 0 then
        for i = #toRemove, 1, -1 do
            local idx = toRemove[i]
            local part = grabbedParts[idx]
            if welds[part] then
                welds[part]:Destroy()
                welds[part] = nil
            end
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

    -- Efeito visual na peça
    pcall(function()
        local pos = part.Position
        criarParticulas(CFrame.new(pos), Color3.fromRGB(0, 255, 200), 20, 0.8)
        -- Sparkles na peça
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
        return Rayfield:Notify({Title = "⏳ Sistema Ocupado", Content = "Aguarde a conclusão do ciclo atual.", Duration = 2})
    end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        puxando = false
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Falha Crítica", Content = "Componente HumanoidRootPart não mapeado.", Duration = 3})
    end

    puxando = true
    local count = 0
    local radius = settings.raioPuxar or 50

    tocarSom(SONS.scan, 0.3)
    Rayfield:Notify({Title = "🧲 Scanner Ativo", Content = "Procurando TranspBox num raio de " .. radius .. " studs", Duration = 2})

    -- Visual pulse do jogador
    pcall(function()
        -- Anel de pulso
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
                    if dist < radius and not isAlreadyGrabbed(v) then
                        table.insert(partsToProcess, v)
                    end
                end
            end
        else
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "TranspBox" and not v.Anchored then
                    local dist = (v.Position - rootPart.Position).Magnitude
                    if dist < radius and not isAlreadyGrabbed(v) then
                        table.insert(partsToProcess, v)
                    end
                end
            end
        end

        for _, part in ipairs(partsToProcess) do
            if part and part.Parent then
                local success = weldGrabPart(part)
                if success then
                    count = count + 1
                    task.wait(0.03)
                end
            end
        end

        isWelded = true
        puxando = false

        if count > 0 then
            tocarSom(SONS.pegar, 0.4)
            Rayfield:Notify({Title = "✅ Sucesso", Content = count .. " TranspBox soldadas e seguindo você!", Duration = 3})
        else
            tocarSom(SONS.erro, 0.4)
            Rayfield:Notify({Title = "❌ Nada Encontrado", Content = "Nenhuma TranspBox próxima encontrada!", Duration = 2})
        end
    end)
end

local function soltarPecas()
    local count = #grabbedParts

    if count == 0 then
        tocarSom(SONS.erro, 0.3)
        Rayfield:Notify({Title = "ℹ️ Info", Content = "Nenhuma TranspBox acoplada para soltar.", Duration = 2})
        return
    end

    isWelded = false

    for _, part in ipairs(grabbedParts) do
        if welds[part] then
            welds[part]:Destroy()
            welds[part] = nil
        end
        if part and part.Parent then
            part.CanCollide = true
            part.Massless = false
            part.CustomPhysicalProperties = nil
            part.Transparency = math.max(0, part.Transparency - 0.15)
            part.Velocity = Vector3.new(0, 0, 0)

            -- Efeito visual ao soltar
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
    Rayfield:Notify({Title = "🔄 Módulo Resetado", Content = count .. " TranspBox soltas com sucesso!", Duration = 2})
end

-- =============================================================================
-- [7] NÚCLEO DO SISTEMA DE LOGÍSTICA (TELETRANSPORTE)
-- =============================================================================

local function entregar()
    if not localSelecionado then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Erro de Rota", Content = "Destino não selecionado no painel.", Duration = 3})
    end

    if entregando then return end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        entregando = false
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Erro Causal", Content = "Entidade física indisponível.", Duration = 3})
    end

    entregando = true
    ultimaPosicao = rootPart.Position

    tocarSom(SONS.teleporte, 0.4)
    Rayfield:Notify({Title = "🚚 Roteamento Iniciado", Content = "Destino: " .. localSelecionado.nome, Duration = 2})

    -- Efeitos visuais
    criarEfeitoTeletransporte(character, localSelecionado.posicao + Vector3.new(0, 5, 0))

    task.wait(0.2)
    rootPart.CFrame = CFrame.new(localSelecionado.posicao + Vector3.new(0, 5, 0))
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    task.wait(0.1)
    tocarSom(SONS.sucesso, 0.5)
    Rayfield:Notify({Title = "✅ Vetor Concluído", Content = "Posicionado em: " .. localSelecionado.nome, Duration = 3})

    entregando = false

    if StatusLabel then StatusLabel:Set("✅ Última entrega: " .. localSelecionado.nome) end
end

local function voltar()
    if not ultimaPosicao then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Registro Ausente", Content = "Nenhum vetor anterior armazenado.", Duration = 3})
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
    Rayfield:Notify({Title = "↩️ Retorno Vetorial", Content = "Retornando à coordenada de origem.", Duration = 2})

    criarEfeitoTeletransporte(character, destino + Vector3.new(0, 5, 0))

    task.wait(0.2)
    rootPart.CFrame = CFrame.new(destino + Vector3.new(0, 5, 0))
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    task.wait(0.1)
    tocarSom(SONS.sucesso, 0.5)
    Rayfield:Notify({Title = "✅ Concluído", Content = "Retorno executado com sucesso.", Duration = 3})

    -- NÃO limpa ultimaPosicao — mantém histórico

    if StatusLabel then StatusLabel:Set("✅ Voltou para posição anterior") end
end

-- =============================================================================
-- [8] SISTEMA DE ENTREGA AUTOMÁTICA (EXPERIMENTAL) - VERSÃO MELHORADA
-- =============================================================================

local function isPartVisible(part)
    if not part or not part.Parent then return false end
    if part:IsA("BasePart") then
        if part.Transparency < 0.9 then
            local cf = part.CFrame
            local size = part.Size
            -- Se o tamanho for razoável (> 0.1 em cada eixo), provavelmente é real
            if size.Magnitude > 0.5 then
                return true
            end
        end
    end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("BillboardGui") or child:IsA("SelectionBox") or child:IsA("SelectionLasso") then
            if child.Enabled == true then
                return true
            end
        end
        local nome = child.Name:lower()
        if nome:find("arrow") or nome:find("pointer") or nome:find("indicator") or nome:find("marker") then
            return true
        end
        -- Procura por atributo "Active" ou "Enabled"
        if child:IsA("BoolValue") then
            local n = child.Name:lower()
            if (n == "active" or n == "enabled" or n == "visible") and child.Value == true then
                return true
            end
        end
    end
    -- Verifica atributo na pasta
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
        if isPartVisible(dropArea) then
            return true
        end
    end

    local details = destinoFolder:FindFirstChild("Details")
    if details then
        local spin = details:FindFirstChild("Spin")
        if spin and spin:IsA("BasePart") then
            if isPartVisible(spin) then return true end
        end
        local decal = details:FindFirstChild("Decal")
        if decal and decal:IsA("BasePart") then
            if isPartVisible(decal) then return true end
        end
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
            if (n == "active" or n == "enabled" or n == "visible") and child.Value == true then
                return true
            end
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
        return Rayfield:Notify({Title = "⏳ Ocupado", Content = "Aguarde a conclusão da entrega atual.", Duration = 2})
    end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return Rayfield:Notify({Title = "❌ Erro", Content = "Personagem não disponível.", Duration = 2})
    end

    local transportJob = Workspace:FindFirstChild("TransportJobWorkings")
    if not transportJob then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Estrutura não encontrada", Content = "TransportJobWorkings não existe neste servidor.", Duration = 3})
    end

    local destinations = transportJob:FindFirstChild("Destinations")
    if not destinations then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Destinations não encontrada", Content = "A pasta Destinations está ausente em TransportJobWorkings.", Duration = 3})
    end

    local dropAreasValidas = {}
    local dropAreasInativas = {}

    for _, destinoFolder in ipairs(destinations:GetChildren()) do
        if destinoFolder:IsA("Folder") or destinoFolder:IsA("Model") then
            local dropArea = destinoFolder:FindFirstChild("DropArea")
            local details = destinoFolder:FindFirstChild("Details")
            local decal = nil
            local spin = nil

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
                if ativo then
                    table.insert(dropAreasValidas, info)
                else
                    table.insert(dropAreasInativas, info)
                end
            end
        end
    end

    if #dropAreasValidas == 0 then
        tocarSom(SONS.erro, 0.5)
        if #dropAreasInativas > 0 then
            local nomes = {}
            for _, area in ipairs(dropAreasInativas) do
                table.insert(nomes, area.nome)
            end
            return Rayfield:Notify({Title = "❌ Nenhum destino ativo", Content = "Destinos encontrados mas INATIVOS: " .. table.concat(nomes, ", ") .. "\nAguarde a entrega ser ativada!", Duration = 5})
        else
            return Rayfield:Notify({Title = "❌ Nenhum destino válido encontrado", Content = "Nenhuma área de entrega com DropArea + Decal + Spin disponível.", Duration = 4})
        end
    end

    local escolhido = nil
    local menorDist = math.huge

    for _, area in ipairs(dropAreasValidas) do
        local dist = (area.posicao - rootPart.Position).Magnitude
        if dist < menorDist then
            menorDist = dist
            escolhido = area
        end
    end

    if not escolhido then
        tocarSom(SONS.erro, 0.5)
        return Rayfield:Notify({Title = "❌ Erro", Content = "Não foi possível selecionar um destino válido.", Duration = 2})
    end

    entregando = true
    ultimaPosicao = rootPart.Position

    tocarSom(SONS.teleporte, 0.4)
    Rayfield:Notify({Title = "🚀 Entrega Automática (Experimental)", Content = "Indo para " .. escolhido.nome .. " (ativo ✅ | dist: " .. math.floor(menorDist) .. "s)", Duration = 2})

    if AutoStatusLabel then
        AutoStatusLabel:Set("🤖 Auto: " .. escolhido.nome .. " ✅ ATIVO (✓ DropArea ✓ Decal ✓ Spin)")
    end

    criarEfeitoTeletransporte(character, escolhido.posicao + Vector3.new(0, 3, 0))

    task.wait(0.2)

    local destino = escolhido.posicao + Vector3.new(0, 3, 0)
    rootPart.CFrame = CFrame.new(destino)
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    tocarSom(SONS.sucesso, 0.5)
    Rayfield:Notify({Title = "✅ Chegou em " .. escolhido.nome, Content = "🔍 Destino ATIVO confirmado!\n📦 Área de entrega pronta!", Duration = 4})

    entregando = false

    if StatusLabel then
        StatusLabel:Set("✅ Entregue em: " .. escolhido.nome .. " (Automático - ATIVO)")
    end
end

-- =============================================================================
-- [9] ARQUITETURA DA INTERFACE GRÁFICA (RAYFIELD UI)
-- =============================================================================

local Window = Rayfield:CreateWindow({
    Name = "🚚 MEC BR ULTIMATE | v3.8",
    Icon = 0,
    LoadingTitle = "Inicializando Painel da Maldade...",
    LoadingSubtitle = "by Chora_Argumento & Petrix",
    Theme = "Ocean",
    ToggleUIKeybind = "K",
    ConfigurationSaving = { Enabled = true, FileName = "MEC_Ultimate_Config" },
    Discord = { Enabled = false },
    KeySystem = false,
})

local MagnetTab   = Window:CreateTab("🧲 Magnético", 0)
local EntregaTab  = Window:CreateTab("🚚 Entrega", 0)
local CoordTab    = Window:CreateTab("📍 Coordenadas", 0)
local InfoTab     = Window:CreateTab("ℹ️ Painel Informativo", 0)

-- [ABA: MAGNÉTICO]
MagnetTab:CreateSection("🧲 Controle Operacional")
MagnetTab:CreateButton({ Name = "🧲 PEGAR TRANSPBOX", Callback = puxarPecas })
MagnetTab:CreateButton({ Name = "❌ SOLTAR TRANSPBOX", Callback = soltarPecas })

MagnetTab:CreateSection("⚙️ Parâmetros de Redimensionamento")
MagnetTab:CreateSlider({
    Name = "📡 Raio do Campo Magnético",
    Range = {10, 100},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = settings.raioPuxar,
    Flag = "RaioPuxar",
    Callback = function(Value) settings.raioPuxar = Value end,
})

MagnetTab:CreateSlider({
    Name = "📏 Altura do Agrupamento (Pilha)",
    Range = {1, 6},
    Increment = 0.5,
    Suffix = " studs",
    CurrentValue = settings.alturaPilha,
    Flag = "AlturaPilha",
    Callback = function(Value)
        settings.alturaPilha = Value
        atualizarPilha()
    end,
})

MagnetTab:CreateSlider({
    Name = "📏 Distância à Frente",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = " studs",
    CurrentValue = 3,
    Flag = "DistanciaFrente",
    Callback = function(Value)
        settings.posicaoZ = Value
        atualizarPilha()
    end,
})

MagnetTab:CreateSection("📊 Status do Sistema")
PecasLabel = MagnetTab:CreateLabel("📦 TranspBox acopladas: 0")

task.spawn(function()
    while true do
        task.wait(0.5)
        if PecasLabel then
            PecasLabel:Set("📦 TranspBox acopladas: " .. #grabbedParts .. (isWelded and " ✅ Soldadas" or " ⏸ Parado"))
        end
    end
end)

-- [ABA: ENTREGA]
EntregaTab:CreateSection("📍 Seletor de Rota Espacial")
local opcoes = {}
for i, dado in ipairs(coordenadas) do table.insert(opcoes, i .. ". " .. dado.nome) end

EntregaTab:CreateDropdown({
    Name = "Selecione o destino",
    Options = opcoes,
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "LocalDropdown",
    Callback = function(Options)
        if #Options > 0 then
            local index = tonumber(string.match(Options[1], "^(%d+)"))
            if index then localSelecionado = coordenadas[index] end
        end
    end,
})

EntregaTab:CreateSection("⚡ Executáveis Logísticos")
EntregaTab:CreateButton({ Name = "🚚 INICIAR TRANSPORTE VETORIAL", Callback = entregar })
EntregaTab:CreateButton({ Name = "↩️ RETORNAR À ORIGEM", Callback = voltar })

EntregaTab:CreateSection("🧪 Experimental")
EntregaTab:CreateButton({
    Name = "🚀 ENTREGA AUTOMÁTICA (EXPERIMENTAL)",
    Callback = entregarAutomatico
})
AutoStatusLabel = EntregaTab:CreateLabel("🤖 Status Auto: Aguardando...")

EntregaTab:CreateSection("📊 Telemetria Operacional")
StatusLabel = EntregaTab:CreateLabel("✅ Módulo System: Aguardando Ações.")
PosLabel = EntregaTab:CreateLabel("📍 Posição atual: Carregando dados vetoriais...")
UltimaPosLabel = EntregaTab:CreateLabel("📌 Última posição: Nenhuma armazenada.")

-- [ABA: COORDENADAS]
CoordTab:CreateSection("📋 Banco de Dados Estrutural")
for i, dado in ipairs(coordenadas) do
    CoordTab:CreateLabel(string.format("%d. %s\n   [X: %.2f | Y: %.2f | Z: %.2f]", i, dado.nome, dado.posicao.X, dado.posicao.Y, dado.posicao.Z))
end

CoordTab:CreateButton({
    Name = "📋 EXPORTAR BANCO PARA ÁREA DE TRANSFERÊNCIA",
    Callback = function()
        local texto = "========================================\n📍 DATA EXPORT: MEC BR ULTIMATE\n========================================\n"
        for i, dado in ipairs(coordenadas) do
            texto = texto .. string.format("%d. %s -> Vector3.new(%.2f, %.2f, %.2f)\n", i, dado.nome, dado.posicao.X, dado.posicao.Y, dado.posicao.Z)
        end
        local sucesso = pcall(function() setclipboard(texto) end)
        Rayfield:Notify({
            Title = sucesso and "📋 Exportado" or "❌ Falha",
            Content = sucesso and "Dados copiados com sucesso." or "Restrição de permissão do exploit.",
            Duration = 3
        })
    end
})

-- [ABA: INFORMÁTICO]
InfoTab:CreateSection("⚙️ System Specifications")
InfoTab:CreateLabel("• build_version: 3.8.0-pro")
InfoTab:CreateLabel("• core_framework: Rayfield UI Engine")
InfoTab:CreateLabel("• magnet_system: Weld (Solda) - TranspBox Only")
InfoTab:CreateLabel("• teleport_system: Vector3 CFrame")
InfoTab:CreateLabel("• sound_engine: RbxSoundID")
InfoTab:CreateLabel("• particle_fx: ParticleEmitter + Explosion")
InfoTab:CreateSection("👨‍💻 Desenvolvido Por")
InfoTab:CreateLabel("• Chora_Argumento & Petrix")
InfoTab:CreateLabel("• https://discord.gg/7dkp6uhYNb")
InfoTab:CreateSection("📦 Alvo")
InfoTab:CreateLabel("• Nome: TranspBox")
InfoTab:CreateLabel("• Local: Workspace.GrabStuff")
InfoTab:CreateLabel("• Posição: -25705.14, 31.83, -5854.22")

-- [ABA: CRÉDITOS]
local CreditsTab = Window:CreateTab("👨‍💻 Créditos", 0)

CreditsTab:CreateSection("🎮 Desenvolvedores")
CreditsTab:CreateLabel("👨‍💻 Chora_Argumento")
CreditsTab:CreateLabel("👨‍💻 Petrix")
CreditsTab:CreateLabel("")
CreditsTab:CreateSection("📚 Bibliotecas")
CreditsTab:CreateLabel("• Rayfield - Menu UI")
CreditsTab:CreateLabel("")
CreditsTab:CreateSection("🔗 Links")
CreditsTab:CreateLabel("📱 Discord: https://discord.gg/7dkp6uhYNb")
CreditsTab:CreateLabel("📺 YouTube: https://www.youtube.com/@ChoraArgumento")

CreditsTab:CreateButton({
    Name = "📋 COPIAR LINK DO DISCORD",
    Callback = function()
        local link = "https://discord.gg/7dkp6uhYNb"
        pcall(function()
            setclipboard(link)
        end)
        Rayfield:Notify({
            Title = "📋 Copiado!",
            Content = "Link do Discord copiado!",
            Duration = 2
        })
    end,
})

CreditsTab:CreateButton({
    Name = "⭐ AVALIAR SCRIPT",
    Callback = function()
        Rayfield:Notify({
            Title = "⭐ Obrigado!",
            Content = "Avalie o script no ScriptBlox!",
            Duration = 3
        })
    end,
})

CreditsTab:CreateSection("⚠️ Aviso Importante")
CreditsTab:CreateLabel("📢 ESTE PROGRAMA FOI DESENVOLVIDO EXCLUSIVAMENTE")
CreditsTab:CreateLabel("📢 PARA FINS DE ENTRETENIMENTO E APRENDIZADO.")
CreditsTab:CreateLabel("")
CreditsTab:CreateLabel("🚫 NÃO UTILIZE ESTE SCRIPT PARA:")
CreditsTab:CreateLabel("• Prejudicar a experiência de outros jogadores")
CreditsTab:CreateLabel("• Obter vantagem competitiva desleal")
CreditsTab:CreateLabel("• Praticar qualquer forma de assédio ou toxidade")
CreditsTab:CreateLabel("• Violar os termos de serviço da plataforma")
CreditsTab:CreateLabel("")
CreditsTab:CreateLabel("✅ USE COM RESPONSABILIDADE")
CreditsTab:CreateLabel("✅ RESPEITE OS DEMAIS JOGADORES")
CreditsTab:CreateLabel("✅ DIVIRTA-SE DE FORMA SAUDÁVEL")

CreditsTab:CreateLabel("")
CreditsTab:CreateLabel("💀 Chora_Argumento & Petrix")
CreditsTab:CreateLabel("💀 Obrigado por usar nosso script!")
CreditsTab:CreateLabel("💀 2026 - Todos os direitos reservados")

-- =============================================================================
-- [10] DAEMONS E THREADS ASSÍNCRONAS
-- =============================================================================

RunService.Heartbeat:Connect(function()
    local success, err = pcall(function()
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart and PosLabel then
            local pos = rootPart.Position
            PosLabel:Set(string.format("📍 Posição atual: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z))
        end

        if UltimaPosLabel then
            if ultimaPosicao then
                UltimaPosLabel:Set(string.format("📌 Última posição: %.1f, %.1f, %.1f", ultimaPosicao.X, ultimaPosicao.Y, ultimaPosicao.Z))
            else
                UltimaPosLabel:Set("📌 Última posição: Nenhuma armazenada.")
            end
        end

        if #grabbedParts > 0 then
            limparPecasFantasma()
        end
    end)
    if not success and err then
        warn("[MEC BR] Heartbeat error: " .. tostring(err))
    end
end)

-- Atualização periódica da pilha pra manter sincronia
task.spawn(function()
    while true do
        task.wait(2)
        if isWelded and #grabbedParts > 0 then
            pcall(atualizarPilha)
        end
    end
end)

-- =============================================================================
-- [11] LIMPEZA AO RENASCER
-- =============================================================================
LocalPlayer.CharacterAdded:Connect(function()
    isWelded = false
    puxando = false
    entregando = false

    for _, part in ipairs(grabbedParts) do
        if welds[part] then
            welds[part]:Destroy()
            welds[part] = nil
        end
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

-- Cleanup global (se o script for interrompido)
local function onCleanup()
    isWelded = false
    puxando = false
    entregando = false

    for _, part in ipairs(grabbedParts) do
        if welds[part] then
            pcall(function() welds[part]:Destroy() end)
            welds[part] = nil
        end
    end
    grabbedParts = {}
    welds = {}
end

pcall(function()
    if LocalPlayer.OnCleanup then
        LocalPlayer.OnCleanup:Connect(onCleanup)
    end
end)

-- =============================================================================
-- [12] INICIALIZAÇÃO
-- =============================================================================
print("========================================")
print("🚀 MEC BR ULTIMATE - v3.8")
print("👨‍💻 Desenvolvido por: Chora_Argumento & Petrix")
print("========================================")
print("[SYSTEM] Magnet System: Weld (Solda) - TranspBox Only")
print("[SYSTEM] Teleport System: Vector3 CFrame")
print("[SYSTEM] Sound Engine: RbxSoundID")
print("[SYSTEM] Particle FX: ParticleEmitter + Explosion")
print("[SYSTEM] Coordenadas carregadas: " .. #coordenadas)
print("[SYSTEM] Alvo: TranspBox em Workspace.GrabStuff")
print("========================================")
print("⚠️ AVISO: Este script é para fins de entretenimento")
print("⚠️ Não utilize para prejudicar outros jogadores")
print("========================================")
print("💀 Obrigado por usar nosso script!")
print("========================================")

Rayfield:Notify({
    Title = "🚀 MEC BR ULTIMATE v3.8",
    Content = "📦 Desenvolvido por Chora_Argumento & Petrix",
    Duration = 5
})

Rayfield:Notify({
    Title = "⚠️ AVISO IMPORTANTE",
    Content = "Use com responsabilidade! Respeite os jogadores!",
    Duration = 5
})
