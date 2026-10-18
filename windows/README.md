# 🪟 Windows Setup & GlazeWM Suite (Dual-Boot / Workstation)

> **Suíte completa de automação para Windows 10/11:**  
> Instalação em lote via Winget, Debloat oficial, ativação permanente (MAS), particionamento de SSD, backup pré-formatação e Tiling Window Manager (**GlazeWM**) estilo Hyprland.

---

## 📁 Estrutura da Pasta `windows/`

```text
~/dotfiles/windows/
├── CLIQUE_AQUI_APOS_INSTALAR_WINDOWS.bat # Atalho mestre (executar direto do pendrive ou repo)
├── README.md                             # Este guia
├── GUIA_POS_INSTALACAO_WINDOWS_E_SKYRIM.md # Roteiro de configuração de mods, dual boot e áudio
├── glazewm/
│   └── config.yaml                       # Configuração do GlazeWM estilo Hyprland (Super + H/J/K/L)
└── scripts/
    ├── Instalar-Programas-PC.bat / .ps1  # Central mestre interativa (15 opções em 3 fases lógicas)
    ├── Instalar-Pacote-Essencial.bat / .ps1 # Instala os 15 programas essenciais via Winget
    ├── Mover-Pastas-Usuario-Para-D.bat / .ps1 # Redireciona pastas para o SSD BTRFS/Dados
    ├── Nomear-Discos.bat / .ps1          # Nomeia Windows_OS (C:), Dados (F:) e CachyOS_Linux (G:)
    ├── Configurar-DualBoot-Fixes.bat / .ps1 # Relógio UTC, Fast Startup OFF e proteção do Limine
    ├── Instalar-DevStack-WSL.bat / .ps1  # Git, Token PAT, Clone Dotfiles, SSH e WSL 2
    ├── Configurar-GlazeWM.bat / .ps1     # Instala e aplica a config do GlazeWM + Zebar
    ├── Backup-Pre-Formatacao.bat / .ps1  # Coleta chaves SSH, perfis e saves com Ludusavi
    ├── Calculadora-Particoes.bat / .ps1  # Assistente de particionamento C: e D:
    ├── Organizar-PC.ps1                  # Wrapper do organizador de arquivos no Windows
    └── *.bat                             # Executáveis rápidos com 2 cliques (CRLF nativo)
```

---

## ⚡ Como Usar no Windows

### 1. Setup Automatizado Pós-Formatação (Com 2 Cliques)
1. Dê dois cliques em **`CLIQUE_AQUI_APOS_INSTALAR_WINDOWS.bat`** (na raiz do pendrive ou na pasta `windows/`).
2. Ele abrirá o menu mestre interativo em **3 fases cronológicas**:
   - **FASE 1 (Reconhecimento do SSD & Pastas):** Instala o driver WinBtrfs, aplica correções de Dual Boot (UTC / Fast Startup) e redireciona suas pastas (Downloads, Documentos, Desktop) direto para o disco de dados BTRFS.
   - **FASE 2 (Programas & Dev):** Instala o pacote essencial de 15 programas (Brave, NVIDIA App, AB Download, Anki, Spotify, etc.), runtimes de jogos para Skyrim e o Dev Stack (Git + WSL 2).
   - **FASE 3 (Ativação & Otimização):** Ativação permanente oficial (MAS) e ultra tuning de performance para latência zero.

---

### 2. Configurar o GlazeWM (Hyprland no Windows)
1. Execute **`windows/scripts/Configurar-GlazeWM.bat`**.
2. O script instalará o GlazeWM e copiará a configuração `glazewm/config.yaml` para `%USERPROFILE%\.glzr\glazewm\config.yaml`.
3. Você poderá navegar entre janelas no Windows com os mesmos atalhos do Hyprland:
   - `Alt + H / J / K / L`: Mover foco
   - `Alt + Shift + H / J / K / L`: Mover janela
   - `Alt + Q`: Fechar janela ativa
   - `Alt + Return`: Abrir Windows Terminal

---

### 3. Backup Pré-Formatação no Windows
1. Execute **`windows/scripts/Backup-Pre-Formatacao.bat`**.
2. O assistente salvará suas chaves SSH (`~/.ssh`), configurações e abrirá o **Ludusavi** para backup automático de saves de jogos da Steam, Epic e Xbox.
