# 🌌 Arch-Hyprland & Vibe Coding Master Suite

<div align="center">
  <img src="https://raw.githubusercontent.com/JaKooLit/Arch-Hyprland/main/screenshots/v4-hyprland.png" width="800px" />
  <p align="center">
    <strong>Repositório central unificado: Arch Linux + Hyprland + LazyVim + Antigravity CLI + Organizador Master de Arquivos.</strong>
  </p>
</div>

---

## ✨ Destaques do Ecossistema

- 🚀 **Setup One-Shot (`setup.sh`)**: Instalação e replicação completa de todo o sistema operacional, pacotes e configurações com um único comando.
- 🎮 **Gaming & Streaming Elite**: Suporte total a **FitGirl Repacks** e Steam com **Lutris/Heroic (Proton-GE)**, **GameMode**, **MangoHud**, **Vesktop** (Discord com áudio/stream no Wayland), **OBS Studio NVENC** e cancelamento de ruído no mic via IA (**EasyEffects**).
- 💻 **Vibe Coding Suite (`vibe`)**: Integração de **LazyVim** (LSP Java, TypeScript, Python, Go, Rust), **Antigravity CLI (`agy`)** e layout dinâmico no **Zellij**.
- 🧹 **Organizador Master Integrado**: Classificação automática de arquivos em taxonomia mestre ordinal (`00_` a `06_`), histórico com rollback (`--undo`), padronização de datas ISO e calculadora de partições.
- 📦 **GNU Stow Modular**: Gerenciamento limpo e transparente de dotfiles via links simbólicos automáticos.
- 📱 **Mobile & Dev Ready**: Suporte a React Native, Flutter e espelhamento em tempo real com **scrcpy** (zero lag, sem emulador pesado).
- 📚 **Hub Completo de Documentação**: Guias mestres pós-formatação, backups, busca instantânea e organização na nuvem.

---

## 📁 Estrutura do Repositório

```text
~/dotfiles/
├── setup.sh                         # Instalador mestre da máquina
├── README.md                        # Documentação e guia mestre
├── packages/                        # Listas de pacotes para replicação nativa e AUR
│   ├── pacman-native.txt
│   └── pacman-aur.txt
├── docs/                            # 📚 Hub Central de Guias ([Ver Portal INDEX.md](./docs/INDEX.md))
│   ├── INDEX.md                     # 🧭 Portal Mestre de Navegação de toda a Documentação
│   ├── GUIA_GAMING_STREAMING_LINUX.md # 🎮 Gaming, FitGirl Repacks, RTX 5060, Vesktop & Áudio IA
│   ├── GUIA_POWERUSER_DEV.md        # ⚡ Guia Power User (Zero microatritos, Dadbod SQL, Kulala REST, Surround)
│   ├── GUIA_FULLSTACK_WORKFLOWS.md  # 🚀 Workflows Práticos (Java Spring, React/Next, Mobile, Python, Rust, Go)
│   ├── GUIA_ATALHOS_E_KEYBINDS_MESTRE.md # ⌨️ Cheat Sheet Mestre (Hyprland, Zellij, Yazi, Neovim, Shell)
│   ├── GUIA_LAZYVIM_ANTIGRAVITY.md  # 🤖 Workflow de Vibe Coding (Neovim + Antigravity CLI + Zellij)
│   ├── GUIA_SETUP_PC.md             # 💻 Setup automatizado pós-formatação (Linux & Windows)
│   ├── GUIA_BACKUP_PRE_FORMATACAO.md# 🛡️ Salvamento seguro de chaves, saves (Ludusavi) e configs
│   ├── TAXONOMIA_MESTRE.md          # 🏛️ Hierarquia ordinal 00_ a 06_ de arquivos
│   ├── GUIA_BUSCA_INSTANTANEA.md    # 🔍 Busca em menos de 1 segundo (fzf, zoxide, ripgrep)
│   ├── GUIA_NOMENCLATURA.md         # ✍️ Padrão ouro de nomes de arquivos (Datas ISO)
│   ├── GUIA_GOOGLE_DRIVE.md         # ☁️ Estratégia de organização e limpeza na nuvem
│   ├── ARCHITECTURE_ORGANIZADOR.md  # 📐 Arquitetura do motor Python do organizador
│   └── favoritos_organizados.html   # 🌐 Backup curado de favoritos de navegação
├── scripts/                         # ⚡ Automações e utilitários
│   ├── backup.sh                    # Backup e sincronização dos dotfiles
│   ├── dev-setup.sh                 # Provisionamento de linguagens, Docker e SDKs
│   ├── yazi-float.sh / yazi-help.sh # Integração Yazi no terminal
│   ├── zj-help.sh                   # Guia rápido do Zellij
│   └── organizador/                 # 🧹 Motor Python do Organizador Master
│       ├── main.py                  # CLI do organizador (--all, --undo, --calc-disk, etc.)
│       ├── requirements.txt
│       ├── src/                     # Core, classificador, renamer, taxonomia
│       └── config/                  # Regras de extensão e taxonomia
├── nvim/                            # 💻 Configuração do LazyVim (Stow)
│   └── .config/nvim/
├── zellij/                          # 🪟 Configuração e layouts (Vibe Coding)
│   └── .config/zellij/
├── windows/                         # 🪟 Suíte de Automação para Windows 10/11 & GlazeWM
│   ├── README.md                    # Guia de setup pós-formatação no Windows
│   ├── glazewm/config.yaml          # Configuração Tiling Window Manager estilo Hyprland
│   └── scripts/                     # Scripts .bat e .ps1 (Winget, Debloat, Ativação MAS, Backup)
└── [módulos stow]...                # hypr, waybar, yazi, kitty, ghostty, mise, etc.
```

---

## 🚀 Instalação e Inicialização

### 1. Clonar e Instalar o Sistema
```bash
git clone https://github.com/wheslancardoso/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

### 2. Iniciar o Ambiente de Desenvolvimento (LazyVim + IA)
```bash
# Inicia a sessão de Vibe Coding no Zellij
zellij --layout vibe

# Ou abra o Neovim puro
nvim
```

---

## 🧹 Suíte de Organização de Arquivos (`scripts/organizador/`)

O organizador classifica e mantém sua pasta `~/Documents` e nuvens em perfeito estado:

| Pasta | Conteúdo |
|---|---|
| `00_Inbox_Triagem` | Arquivos soltos recém-baixados |
| `01_Pessoal_e_Vida` | Documentos pessoais, RG, CPF, finanças, currículos |
| `02_Estudos_e_Concursos` | TCE-GO, editais, apostilas, cursos, ebooks |
| `03_Profissional_WFIX` | Automações, playbooks, WhatsApp, clientes |
| `04_Desenvolvimento_e_Codigo` | Projetos, scripts Python, Shell, repositórios |
| `05_Design_Midia_e_Criacao` | Artes, áudios, gravações, designs |
| `06_Backups_ISOs_e_Sistemas` | Snapshots, VMs, instaladores, imagens |

### Comandos Rápidos do Organizador:
```bash
# Executar organização completa (Desktop + Downloads)
python3 ~/dotfiles/scripts/organizador/main.py --all

# Simular movimentação sem alterar arquivos
python3 ~/dotfiles/scripts/organizador/main.py --all --dry-run

# Desfazer a última organização (Rollback)
python3 ~/dotfiles/scripts/organizador/main.py --undo

# Padronizar nomes com data ISO (YYYY-MM-DD_)
python3 ~/dotfiles/scripts/organizador/main.py --auto-date ~/Downloads

# Calcular divisão ótima de SSD para dual-boot / partições
python3 ~/dotfiles/scripts/organizador/main.py --calc-disk 480
```

---

## 🔄 Mantendo o Repositório Atualizado

Sempre que modificar configs no seu sistema (`~/.config/` ou `~/`):

```bash
./scripts/backup.sh
```

---

## 🛠️ Tecnologias & Stacks

- **Window Manager**: Hyprland
- **Editor**: Neovim (LazyVim com LSP Java JDTLS, TypeScript, Python, Rust, Go)
- **AI Agent**: Antigravity CLI (`agy`)
- **Multiplexer**: Zellij
- **Shell**: Fish / Zsh (Powerlevel10k)
- **File Manager**: Yazi
- **Git**: LazyGit
- **SDK & Runtime Management**: Mise
- **Tema**: Catppuccin Mocha

---

<div align="center">
  Feito com ❤️ por <a href="https://github.com/wheslancardoso">Wheslan Cardoso</a>
</div>
