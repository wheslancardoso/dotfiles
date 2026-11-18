#!/usr/bin/env bash
# ==============================================================================
# Hyper-V Guest Support for Arch Linux + Hyprland
# Idempotent setup for hv_kvp_daemon, hv_vss_daemon, hv_fcopy_daemon,
# software/cursor Wayland env vars, and Virtual-1 display fallback.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
COMMON_SH="$DOTFILES_DIR/scripts/setup/common.sh"

if [ -f "$COMMON_SH" ]; then
    # shellcheck source=/dev/null
    source "$COMMON_SH"
else
    info() { printf "[INFO] %s\n" "$1"; }
    ok()   { printf "[OK] %s\n" "$1"; }
    warn() { printf "[WARN] %s\n" "$1"; }
    erro() { printf "[ERRO] %s\n" "$1"; exit 1; }
    has_cmd() { command -v "$1" >/dev/null 2>&1; }
    has_systemd() { [ -d /run/systemd/system ] && has_cmd systemctl; }
fi

FORCE_HYPERV="${HYPERV_FORCE:-false}"
NON_INTERACTIVE="${NON_INTERACTIVE:-false}"
HYPERV_GPU_P="${HYPERV_GPU_P:-false}"

for arg in "$@"; do
    case "$arg" in
        --force) FORCE_HYPERV=true ;;
        --gpu-p) HYPERV_GPU_P=true ;;
        --non-interactive|-y|--yes) NON_INTERACTIVE=true ;;
        --help|-h)
            cat << 'EOF'
Uso: ./scripts/setup-hyperv.sh [opções]
  --force             Força configuração mesmo se Hyper-V não for detectado
  --gpu-p             Mantém aceleração GPU (GPU-P / DDA) em vez de llvmpipe
  --non-interactive   Executa sem prompts
  --help, -h          Mostra esta ajuda
EOF
            exit 0
            ;;
        *) warn "Argumento desconhecido ignorado: $arg" ;;
    esac
done

detect_hyperv() {
    if [ "$FORCE_HYPERV" = true ] || [ "${IS_HYPERV:-false}" = true ]; then
        return 0
    fi
    if has_cmd systemd-detect-virt && [ "$(systemd-detect-virt 2>/dev/null || true)" = "microsoft" ]; then
        return 0
    fi
    if [ -r /sys/class/dmi/id/sys_vendor ] && grep -qi "Microsoft" /sys/class/dmi/id/sys_vendor 2>/dev/null; then
        if [ -r /sys/class/dmi/id/product_name ] && grep -qi "Virtual Machine" /sys/class/dmi/id/product_name 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

if ! detect_hyperv; then
    info "Ambiente Hyper-V não detectado (use --force para aplicar manualmente). Pulando."
    exit 0
fi

info "Ambiente Hyper-V detectado. Configurando integração de guest Arch + Hyprland..."

if has_cmd pacman; then
    HYPERV_PKGS=(hyperv mesa vulkan-swrast xf86-video-fbdev)
    info "Instalando pacotes Hyper-V e renderização software/Mesa..."
    sudo pacman -S --needed --noconfirm "${HYPERV_PKGS[@]}" || warn "Algum pacote Hyper-V opcional falhou; verifique manualmente."
else
    warn "pacman não encontrado; pulando instalação de pacotes Hyper-V."
fi

if has_systemd; then
    info "Habilitando daemons Hyper-V (hv_kvp_daemon, hv_vss_daemon, hv_fcopy_daemon)..."
    for svc in hv_kvp_daemon.service hv_vss_daemon.service hv_fcopy_daemon.service; do
        if systemctl list-unit-files "$svc" >/dev/null 2>&1; then
            sudo systemctl enable --now "$svc" 2>/dev/null || warn "Não foi possível iniciar $svc agora (pode exigir reboot)."
        else
            warn "Unit $svc não encontrada."
        fi
    done
    ok "Daemons Hyper-V habilitados."
else
    warn "Systemd não ativo; habilite hv_kvp_daemon, hv_vss_daemon e hv_fcopy_daemon após o boot."
fi

configure_hyprland_hyperv() {
    local hypr_user_dir="$HOME/.config/hypr/UserConfigs"
    local hyperv_conf="$hypr_user_dir/99-HyperV.conf"
    local env_d_dir="$HOME/.config/environment.d"
    local env_d_conf="$env_d_dir/99-hyperv.conf"

    mkdir -p "$hypr_user_dir" "$env_d_dir"

    info "Gerando overrides Hyprland para Hyper-V em $hyperv_conf (HYPERV_GPU_P=$HYPERV_GPU_P)..."
    if [ "$HYPERV_GPU_P" = true ]; then
        cat > "$hyperv_conf" << 'EOF'
# Hyper-V VM overrides (GPU-P / DDA enabled)
env = WLR_NO_HARDWARE_CURSORS,1
env = LIBVA_DRIVER_NAME,
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = GBM_BACKEND,
env = NVD_BACKEND,

cursor {
    no_hardware_cursors = true
}

monitor = Virtual-1, preferred, auto, 1
monitor = , preferred, auto, 1
EOF
        cat > "$env_d_conf" << 'EOF'
WLR_NO_HARDWARE_CURSORS=1
EOF
    else
        cat > "$hyperv_conf" << 'EOF'
# Hyper-V VM overrides (Software rendering / llvmpipe fallback)
env = WLR_RENDERER_ALLOW_SOFTWARE,1
env = WLR_NO_HARDWARE_CURSORS,1
env = LIBGL_ALWAYS_SOFTWARE,1
env = MESA_LOADER_DRIVER_OVERRIDE,llvmpipe
env = LIBVA_DRIVER_NAME,
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = GBM_BACKEND,
env = NVD_BACKEND,
env = GSK_RENDERER,cairo

cursor {
    no_hardware_cursors = true
}

monitor = Virtual-1, preferred, auto, 1
monitor = , preferred, auto, 1
EOF
        cat > "$env_d_conf" << 'EOF'
WLR_RENDERER_ALLOW_SOFTWARE=1
WLR_NO_HARDWARE_CURSORS=1
LIBGL_ALWAYS_SOFTWARE=1
MESA_LOADER_DRIVER_OVERRIDE=llvmpipe
GSK_RENDERER=cairo
EOF
    fi

    ok "Overrides Hyprland/Hyper-V gravados em $hyperv_conf e $env_d_conf."
}

configure_hyprland_hyperv
ok "Integração Hyper-V finalizada."
