#!/bin/bash
# Orquestrador único de setup para Arch Linux e Ubuntu/Debian (Nativo e WSL)

set -euo pipefail

export DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
SETUP_MODULES_DIR="$DOTFILES_DIR/scripts/setup"
source "$SETUP_MODULES_DIR/common.sh"

export NON_INTERACTIVE=false
export PROFILE="full"
export WITH_DESKTOP=false
export IS_HYPERV="auto"
export WITH_AGR=false
export AGR_CLONE_PORTAIS=false

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
        --hyperv)
            IS_HYPERV=true
            ;;
        --no-hyperv)
            IS_HYPERV=false
            ;;
        --agr)
            WITH_AGR=true
            ;;
        --clone-portais)
            WITH_AGR=true
            AGR_CLONE_PORTAIS=true
            ;;
        --help|-h)
            cat << 'EOF'
Uso: ./setup.sh [opções]
  --non-interactive, -y   Executa sem prompts interativos
  --profile=dev|full      Define o perfil (padrão: full no Arch nativo, dev no Arch WSL)
  --dev                   Atalho para --profile=dev
  --full                  Atalho para --profile=full
  --with-desktop          Habilita pacotes/módulo de desktop mesmo no WSL (WSLg)
  --hyperv                Força modo VM Hyper-V (daemons Hyper-V, llvmpipe, sem NVIDIA)
  --no-hyperv             Desativa detecção automática de Hyper-V
  --agr                   Executa também o módulo 05 (AGR Dev + Antigravity + agr-docs)
  --clone-portais         Implica --agr e clona todos os repositórios dos Portais AGR
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

# Detecção de Hyper-V (quando não forçado por flag)
if [ "$IS_HYPERV" = "auto" ]; then
    IS_HYPERV=false
    if [ "$IS_WSL" = false ]; then
        if has_cmd systemd-detect-virt && [ "$(systemd-detect-virt 2>/dev/null || true)" = "microsoft" ]; then
            IS_HYPERV=true
        elif [ -r /sys/class/dmi/id/sys_vendor ] && grep -qi "Microsoft" /sys/class/dmi/id/sys_vendor 2>/dev/null; then
            if [ -r /sys/class/dmi/id/product_name ] && grep -qi "Virtual Machine" /sys/class/dmi/id/product_name 2>/dev/null; then
                IS_HYPERV=true
            fi
        fi
    fi
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

info "Ambiente detectado: distro=$DISTRO_ID | IS_WSL=$IS_WSL | IS_HYPERV=$IS_HYPERV | PROFILE=$PROFILE | WITH_DESKTOP=$WITH_DESKTOP | WITH_AGR=$WITH_AGR"

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

if [ "$WITH_AGR" = true ] && [ -f "$SETUP_MODULES_DIR/05-agr-antigravity.sh" ]; then
    bash "$SETUP_MODULES_DIR/05-agr-antigravity.sh"
fi

ok "Setup completo finalizado com sucesso!"
