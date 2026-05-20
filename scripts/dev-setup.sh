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

# --- 1. Verificação de Ambiente ---
info "Iniciando provisão do ambiente de desenvolvimento..."

# --- 2. Ferramentas de Sistema e Compiladores ---
info "Instalando ferramentas base e compiladores..."
sudo pacman -S --needed --noconfirm \
    base-devel git gcc make cmake unzip curl \
    ripgrep fd lazygit btop jq bat \
    zoxide tealdeer stow

# --- 3. Docker (Instalação e Permissões Zero-Touch) ---
info "Configurando Docker (sem necessidade de sudo posterior)..."
if ! command -v docker &> /dev/null; then
    sudo pacman -S --needed --noconfirm docker docker-compose
fi

# Habilitar e iniciar serviços
sudo systemctl enable --now docker.service
sudo systemctl enable --now docker.socket

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
if command -v mise &> /dev/null; then
    # Garante que o diretório de config existe no backup
    mkdir -p ~/.config/mise
    # Tenta instalar tudo o que estiver no arquivo de config
    if [ -f "$HOME/.config/mise/config.toml" ]; then
        mise install -y
        ok "Runtimes do Mise instaladas com sucesso."
    else
        warn "Arquivo config.toml do Mise não encontrado. Pulando instalação automática."
    fi
else
    warn "Mise não instalado. Por favor, instale o Mise para gerenciar SDKs."
fi

# --- 5. Configuração do Git ---
info "Configurando padrões do Git..."
git config --global core.editor "nvim"
git config --global init.defaultBranch main
git config --global color.ui true

# --- 6. Verificação de Caminhos (Android SDK) ---
if [ -d "$HOME/Android/Sdk" ]; then
    ok "Android SDK detectado em ~/Android/Sdk"
else
    warn "Android SDK não encontrado. Se precisar dele, instale em ~/Android/Sdk para automação do PATH."
fi

# --- Finalização ---
echo -e "\n"
ok "Setup de Desenvolvimento finalizado!"
echo -e "${YELLOW}------------------------------------------------------------${NC}"
echo -e "Próximos passos sugeridos:"
echo -e "1. Faça Logout e Login para ativar as permissões do Docker."
echo -e "2. Use 'lg' para abrir o Lazygit em qualquer repositório."
echo -e "3. Use 'z [pasta]' para navegar rapidamente entre projetos."
echo -e "${YELLOW}------------------------------------------------------------${NC}"
