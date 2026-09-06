#!/bin/bash
# 🛠️ Script de Setup de Desenvolvimento Definitivo (Zero-Touch)
# Desenvolvido para Arch Linux + Hyprland + Mise
# Focado em produtividade extrema e automação completa do Docker e PATH.

set -e

# --- Cores e Formatação ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO] $1${NC}"; }
ok() { echo -e "${GREEN}[OK] $1${NC}"; }
warn() { echo -e "${YELLOW}[WARN] $1${NC}"; }
error() { echo -e "${RED}[ERROR] $1${NC}"; }

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# --- 1. Verificação de Ambiente & Sudo NOPASSWD ---
info "Iniciando provisão do ambiente de desenvolvimento..."
if [ ! -f "/etc/sudoers.d/99-$USER-nopasswd" ]; then
    info "Configurando sudo sem senha (NOPASSWD) para $USER..."
    echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/99-$USER-nopasswd" >/dev/null
    sudo chmod 440 "/etc/sudoers.d/99-$USER-nopasswd"
    sudo visudo -cf "/etc/sudoers.d/99-$USER-nopasswd" >/dev/null 2>&1 || sudo rm -f "/etc/sudoers.d/99-$USER-nopasswd"
fi


# --- 2. Ferramentas de Sistema e Compiladores ---
info "Instalando ferramentas base e compiladores..."
sudo pacman -S --needed --noconfirm \
    base-devel git gcc make cmake unzip curl \
    ripgrep fd lazygit btop jq bat eza \
    zoxide tealdeer chezmoi neovim python-pip \
    git-delta dust procs xh tokei hyperfine atuin \
    zellij scrcpy dbeaver sqlite mariadb-clients valkey \
    tree-sitter-cli luarocks wl-clipboard

# --- 3. Docker (Instalação e Permissões Zero-Touch) ---
info "Configurando Docker (sem necessidade de sudo posterior)..."
if ! command -v docker &> /dev/null; then
    sudo pacman -S --needed --noconfirm docker docker-compose
fi

# Habilitar e iniciar serviços
sudo systemctl enable --now docker.service 2>/dev/null || true
sudo systemctl enable --now docker.socket 2>/dev/null || true

# Adicionar usuário ao grupo docker se ainda não estiver
if ! groups $USER | grep &>/dev/null "\bdocker\b"; then
    info "Adicionando $USER ao grupo docker..."
    sudo usermod -aG docker $USER
    warn "PERMISSÃO: Você precisará reiniciar sua sessão (Logout/Login) para usar Docker sem sudo."
else
    ok "Usuário já está no grupo docker."
fi

# --- 4. SDK Management (Mise) ---
info "Sincronizando linguagens e runtimes com o Mise..."
if ! command -v mise &> /dev/null; then
    info "Instalando Mise (asdf replacement em Rust)..."
    curl -fsSL https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

if command -v mise &> /dev/null; then
    mkdir -p "$HOME/.config/mise"
    if [ ! -f "$HOME/.config/mise/config.toml" ] && [ -f "$DOTFILES_DIR/home/dot_config/mise/config.toml" ]; then
        cp "$DOTFILES_DIR/home/dot_config/mise/config.toml" "$HOME/.config/mise/config.toml"
    fi
    if [ -f "$HOME/.config/mise/config.toml" ]; then
        info "Instalando ferramentas configuradas no Mise (Node LTS, Bun, Pnpm, Python, Go, Java)..."
        mise install -y || warn "Algumas runtimes do mise podem requerer conexão ativa para download."
        ok "Runtimes do Mise sincronizadas com sucesso."
    else
        warn "Arquivo config.toml do Mise não encontrado. Pulando instalação automática."
    fi
else
    warn "Não foi possível inicializar o Mise nesta sessão."
fi

# --- 5. Configuração do Git ---
info "Configurando padrões do Git..."
git config --global core.editor "nvim"
git config --global init.defaultBranch main
git config --global color.ui true

# --- 6. Suíte de Organização e Dependências ---
info "Configurando dependências do Organizador Master..."
if [ -f "$DOTFILES_DIR/scripts/organizador/requirements.txt" ]; then
    pip install --user -r "$DOTFILES_DIR/scripts/organizador/requirements.txt" 2>/dev/null || true
    ok "Dependências do organizador configuradas."
fi

# --- 7. Verificação de Caminhos (Android SDK) ---
ANDROID_DIR=""
for p in "$HOME/android/sdk" "$HOME/Android/Sdk"; do
    if [ -d "$p" ]; then
        ANDROID_DIR="$p"
        break
    fi
done

if [ -n "$ANDROID_DIR" ]; then
    ok "Android SDK detectado em $ANDROID_DIR"
else
    warn "Android SDK não encontrado. Se precisar dele, instale em ~/android/sdk para automação do PATH."
fi

# --- Finalização ---
echo -e "\n"
ok "Setup de Desenvolvimento finalizado!"
echo -e "${YELLOW}------------------------------------------------------------${NC}"
echo -e "Próximos passos e atalhos:"
echo -e "1. ${BLUE}nvim${NC}                 : Abre o LazyVim com LSP (Java, TS, Python, etc.)"
echo -e "2. ${BLUE}zellij --layout vibe${NC} : Inicia sessão Vibe Coding (LazyVim + Antigravity CLI)"
echo -e "3. ${BLUE}scrcpy${NC}               : Espelha celular Android como janela leve no Hyprland"
echo -e "4. ${BLUE}python3 ~/dotfiles/scripts/organizador/main.py --all${NC} : Organiza Desktop e Downloads"
echo -e "5. Faça Logout e Login para ativar as permissões do Docker."
echo -e "${YELLOW}------------------------------------------------------------${NC}"
