#!/bin/bash
# Orquestrador único de setup para Arch Linux e Ubuntu/Debian (Nativo e WSL)

set -euo pipefail

export DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
SETUP_MODULES_DIR="$DOTFILES_DIR/scripts/setup"
source "$SETUP_MODULES_DIR/common.sh"

export NON_INTERACTIVE=false
export PROFILE="full"
export WITH_DESKTOP=false

for arg in "$@"; do
    case "$arg" in
        --non-interactive|-y|--yes)
            NON_INTERACTIVE=true
            ;;
        --profile=*)
            PROFILE="${arg#*=}"
            ;;
        --dev)
            PROFILE="dev"
            ;;
        --full)
            PROFILE="full"
            ;;
        --with-desktop)
            WITH_DESKTOP=true
            ;;
        --help|-h)
            cat << 'EOF'
Uso: ./setup.sh [opções]
  --non-interactive, -y   Executa sem prompts interativos
  --profile=dev|full      Define o perfil (padrão: full no Arch nativo, dev no Arch WSL)
  --dev                   Atalho para --profile=dev
  --full                  Atalho para --profile=full
  --with-desktop          Habilita pacotes/módulo de desktop mesmo no WSL (WSLg)
  --help, -h              Mostra esta ajuda
EOF
            exit 0
            ;;
        *)
            warn "Argumento desconhecido ignorado: $arg"
            ;;
    esac
done

[ ! -t 0 ] && NON_INTERACTIVE=true

# Detecção de WSL
export IS_WSL=false
if [ -n "${WSL_DISTRO_NAME:-}" ] || grep -qiE "microsoft|wsl" /proc/version 2>/dev/null; then
    IS_WSL=true
fi

# Detecção de distro
DISTRO_ID="unknown"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID="${ID:-unknown}"
fi

# Redireciona apenas se for Ubuntu/Debian (no WSL ou nativo); Arch no WSL segue o fluxo Arch!
if [ "$DISTRO_ID" = "ubuntu" ] || [ "$DISTRO_ID" = "debian" ]; then
    info "Distro $DISTRO_ID detectada (IS_WSL=$IS_WSL). Executando setup dedicado Ubuntu/Debian..."
    exec "$DOTFILES_DIR/scripts/setup-ubuntu.sh" "$@"
fi

if [ "$IS_WSL" = true ] && [ "$WITH_DESKTOP" = false ] && [ "$PROFILE" = "full" ]; then
    PROFILE="dev"
fi

info "Ambiente detectado: distro=$DISTRO_ID | IS_WSL=$IS_WSL | PROFILE=$PROFILE | WITH_DESKTOP=$WITH_DESKTOP"

# Sudo keep-alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bash "$SETUP_MODULES_DIR/00-preflight.sh"
bash "$SETUP_MODULES_DIR/01-packages.sh"
bash "$SETUP_MODULES_DIR/02-dotfiles.sh"
bash "$SETUP_MODULES_DIR/03-shell-dev.sh"

if [ "$PROFILE" = "full" ] && { [ "$IS_WSL" = false ] || [ "$WITH_DESKTOP" = true ]; }; then
    bash "$SETUP_MODULES_DIR/04-desktop-hyprland.sh"
else
    info "Módulo 04 (desktop/hyprland) pulado no perfil $PROFILE."
fi

ok "Setup completo finalizado com sucesso!"
