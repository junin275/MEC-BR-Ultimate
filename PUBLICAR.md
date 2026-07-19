# 🚀 MEC BR ULTIMATE v3.8 — Guia de Publicação

## 📋 Arquivos

| Arquivo | Onde subir | Visibilidade |
|---------|-----------|-------------|
| `mec_br_main.lua` | **Gist PÚBLICO** | Público (qualquer um vê) |
| `credenciais.json` | **Gist PRIVADO** | Privado (só você vê) |
| `mec_br_loader.lua` | **GitHub Release** | Público (é o que os users injetam) |

## 🧩 PASSO A PASSO

### 1️⃣ Crie os Gists no GitHub

Acesse: https://gist.github.com

**Gist #1 — PÚBLICO** (script principal)
- Nome do arquivo: `mec_br_main.lua`
- Cole o conteúdo de `my-project/mec_br_main.lua`
- Crie como **PUBLIC**
- Copie a URL raw: `https://gist.githubusercontent.com/SEU_USER/.../raw/mec_br_main.lua`

**Gist #2 — PRIVADO** (credenciais)
- Nome do arquivo: `credenciais.json`
- Cole o conteúdo de `my-project/credenciais.json`
- Crie como **SECRET** (privado)
- Copie a URL raw: `https://gist.githubusercontent.com/SEU_USER/.../raw/credenciais.json`

### 2️⃣ Configure o Loader

Edite `mec_br_loader.lua` e troque as URLs no começo:

```lua
CredenciaisURL  = "https://gist.githubusercontent.com/SEU_USER/HASH/raw/credenciais.json"
MainScriptURL   = "https://gist.githubusercontent.com/SEU_USER/HASH/raw/mec_br_main.lua"
```

### 3️⃣ Publique no GitHub

Crie um repositório público e suba:

```
📁 meu-repo/
├── mec_br_loader.lua    ← O que os usuários vão baixar
├── PUBLICA.md           ← Instruções (opcional)
└── (NÃO suba credenciais.json aqui!)
```

### 4️⃣ Crie uma Release

Vá em **Releases** → **Create new release**:
- Tag: `v3.8`
- Anexe `mec_br_loader.lua` como binário
- Publique

## 🛡️ SEGURANÇA

```
Usuário                     GitHub                       Seu Gist Privado
   │                          │                              │
   ├── baixa loader ──────►   │                              │
   │                          │                              │
   ├── injeta no executor     │                              │
   │                          │                              │
   ├── loader busca ─────────► credenciais.json ───────────► │ (só você vê)
   │    ◄── ServiceId + Secret                              │
   │                          │                              │
   ├── mostra Key System      │                              │
   │                          │                              │
   ├── GET KEY ───────────────► PlatoBoost ──► link LootLabs │
   │    ◄── link copiado      │                              │
   │                          │                              │
   ├── VERIFY ───────────────► PlatoBoost ──► valida key     │
   │    ◄── ✅               │                              │
   │                          │                              │
   └── carrega main ─────────► mec_br_main.lua (Gist público)│
        ◄── script executa   │                              │
```

**NUNCA** suba `credenciais.json` no repositório público.
**SEMPRE** use Gist PRIVADO para as credenciais.

## 🎯 Ofuscação (opcional, mas recomendada)

Para dificultar que alterem seu loader:

1. Vá em https://luaguard.com
2. Cole `mec_br_loader.lua`
3. Ofusque e baixe o resultado
4. Publique a versão ofuscada na Release

Isso esconde as URLs dos Gists e dificulta engenharia reversa.
