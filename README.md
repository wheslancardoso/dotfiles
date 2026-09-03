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
- 📦 **Chezmoi Standard + Symlinks**: Gerenciamento de dotfiles de última geração com suporte nativo a segredos (Bitwarden CLI), templates e modo symlink para hot-reload instantâneo no Hyprland e LazyVim.
- 📱 **Mobile & Dev Ready**: Suporte a React Native, Flutter e espelhamento em tempo real com **scrcpy** (zero lag, sem emulador pesado).
- 📚 **Hub Completo de Documentação**: Guias mestres pós-formatação, backups, busca instantânea e organização na nuvem.

---

## 📁 Estrutura do Repositório

```text
~/dotfiles/
├── .chezmoiroot                     # 🧭 Aponta o Chezmoi para a pasta home/
├── .chezmoi.toml.tmpl               # ⚙️ Configuração mestre do Chezmoi (symlinks + Bitwarden)
├── .chezmoiignore                   # 🛡️ Proteção de arquivos fora do escopo de dotfiles
├── setup.sh                         # Instalador mestre da máquina (Chezmoi + Pacotes)
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
│   ├── backup.sh                    # Backup e sincronização dos dotfiles via Chezmoi
│   ├── dev-setup.sh                 # Provisionamento de linguagens, Docker e SDKs
│   ├── yazi-float.sh / yazi-help.sh # Integração Yazi no terminal
│   ├── zj-help.sh                   # Guia rápido do Zellij
│   └── organizador/                 # 🧹 Motor Python do Organizador Master
│       ├── main.py                  # CLI do organizador (--all, --undo, --calc-disk, etc.)
│       ├── requirements.txt
│       ├── src/                     # Core, classificador, renamer, taxonomia
│       └── config/                  # Regras de extensão e taxonomia
├── home/                            # 🏠 Raiz gerenciada pelo Chezmoi
│   ├── dot_config/                  # ⚙️ Mapeia para ~/.config (nvim, hypr, waybar, yazi, zellij, etc.)
│   ├── dot_zshrc                    # 🐚 Configuração do Zsh
│   ├── dot_gitconfig                # 🐙 Git com helper store e dados de autor
│   ├── dot_bashrc                   # 🐚 Fallback Bash
│   ├── dot_ideavimrc                # ⌨️ Atalhos Vim para IDEs JetBrains
│   ├── pictures/wallpapers/         # 🖼️ Coleção de wallpapers integrada
│   └── run_once_after_10-setup-git-credentials.sh.tmpl # 🔐 Hook de automação de credenciais Git + Bitwarden
├── Arch-Hyprland-main/              # 🚀 Instalador mestre autônomo do Arch Linux
└── windows/                         # 🪟 Suíte de Automação para Windows 10/11 & GlazeWM
```

---

## 🚀 Instalação e Inicialização

### 1. Clonar e Instalar o Sistema

#### 🌟 Opção A: Máquina Recém-Formatada (Arch Base -> Hyprland + NVIDIA + Dotfiles)
Instala o ecossistema completo sem prompts manuais:
```bash
git clone https://github.com/wheslancardoso/dotfiles.git ~/dotfiles
cd ~/dotfiles/Arch-Hyprland-main
chmod +x install-master.sh
./install-master.sh
```

#### ⚡ Opção B: Sistema com Arch já Instalado (Sincronização de Dotfiles & Pacotes)
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

### 3. Gestão Diária com Chezmoi (Power User)
```bash
# Aplicar ou recarregar todos os dotfiles
chezmoi apply

# Ver divergências entre seus arquivos e o repositório
chezmoi diff

# Puxar novidades do Git e reaplicar tudo de uma vez
chezmoi update

# Entrar rapidamente na pasta dos dotfiles
chezmoi cd

# Adicionar uma nova pasta ou arquivo ao repositório
chezmoi add ~/.config/novo-app
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
