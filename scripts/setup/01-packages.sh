#!/bin/bash
# Módulo 01: Instalação de Pacotes (Core Dev/CLI + Desktop/AUR condicional)

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

AUR_HELPER="yay"
has_cmd paru && ! has_cmd yay && AUR_HELPER="paru"

install_pkg_list() {
    local manager="$1"
    shift
    local pkgs=("$@")
    for pkg in "${pkgs[@]}"; do
        [ -z "$pkg" ] && continue
        if [ "$manager" = "pacman" ]; then
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || warn "Pacote nativo não encontrado/falhou: $pkg"
        else
            "$AUR_HELPER" -S --needed --noconfirm "$pkg" 2>/dev/null || warn "Pacote AUR não encontrado/falhou: $pkg"
        fi
    done
}

CORE_DEV_PKGS=(
    base-devel git git-delta github-cli curl wget unzip zip
    zsh fish starship atuin zellij neovim yazi
    bat eza fd fzf ripgrep zoxide jq lazygit
    cmake gcc make sqlite tealdeer tree-sitter-cli
    docker docker-compose chezmoi
    xdg-utils xdg-user-dirs
    ffmpeg 7zip poppler imagemagick resvg
)

info "Instalando stack core de desenvolvimento e CLI..."
sudo pacman -S --needed --noconfirm "${CORE_DEV_PKGS[@]}" || install_pkg_list pacman "${CORE_DEV_PKGS[@]}"

# Ferramentas dev modernas (mise, uv, rustup)
for dev_pkg in mise uv rustup; do
    if ! sudo pacman -S --needed --noconfirm "$dev_pkg" 2>/dev/null; then
        if [ "$dev_pkg" = "mise" ]; then
            "$AUR_HELPER" -S --needed --noconfirm mise-bin 2>/dev/null || "$AUR_HELPER" -S --needed --noconfirm mise 2>/dev/null || warn "Não foi possível instalar mise via pacman/AUR"
        else
            "$AUR_HELPER" -S --needed --noconfirm "$dev_pkg" 2>/dev/null || warn "Não foi possível instalar $dev_pkg via pacman/AUR"
        fi
    fi
done

if [ "${PROFILE:-full}" = "full" ] && { [ "${IS_WSL:-false}" = false ] || [ "${WITH_DESKTOP:-false}" = true ]; }; then
    NATIVE_LIST="$DOTFILES_DIR/packages/pacman-native.txt"
    AUR_LIST="$DOTFILES_DIR/packages/pacman-aur.txt"

    # Em VM Hyper-V, remove pacotes exclusivos de hardware físico / CachyOS / NVIDIA
    HYPERV_SKIP_REGEX='^(cachyos-|linux-cachyos|nvidia|lib32-nvidia|intel-ucode|amd-ucode|tlp|throttled|gpu-screen-recorder|ananicy-rules-cachyos|limine)'

    if [ -f "$NATIVE_LIST" ]; then
        info "Instalando pacotes nativos de $NATIVE_LIST..."
        if [ "${IS_HYPERV:-false}" = true ]; then
            mapfile -t native_pkgs < <(grep -vE '^\s*(#|$)' "$NATIVE_LIST" | grep -vE "$HYPERV_SKIP_REGEX")
        else
            mapfile -t native_pkgs < <(grep -vE '^\s*(#|$)' "$NATIVE_LIST")
        fi
        sudo pacman -S --needed --noconfirm "${native_pkgs[@]}" 2>/dev/null || install_pkg_list pacman "${native_pkgs[@]}"
    fi

    if [ -f "$AUR_LIST" ]; then
        info "Instalando pacotes AUR de $AUR_LIST..."
        if [ "${IS_HYPERV:-false}" = true ]; then
            mapfile -t aur_pkgs < <(grep -vE '^\s*(#|$)' "$AUR_LIST" | grep -vE "$HYPERV_SKIP_REGEX")
        else
            mapfile -t aur_pkgs < <(grep -vE '^\s*(#|$)' "$AUR_LIST")
        fi
        "$AUR_HELPER" -S --needed --noconfirm "${aur_pkgs[@]}" 2>/dev/null || install_pkg_list aur "${aur_pkgs[@]}"
    fi

    if [ "${IS_HYPERV:-false}" = true ] && [ "${IS_WSL:-false}" = false ]; then
        info "Instalando pacotes de guest Hyper-V (hyperv, mesa, vulkan-swrast)..."
        sudo pacman -S --needed --noconfirm hyperv mesa vulkan-swrast 2>/dev/null || warn "Algum pacote Hyper-V opcional falhou."
    fi
else
    info "Perfil dev/WSL ativo: pulando pacotes exclusivos de desktop/hardware nativo."
fi

ok "Módulo de pacotes concluído."
