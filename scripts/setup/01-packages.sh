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
    local aur_flags=(--needed --noconfirm)
    if [ "$AUR_HELPER" = "yay" ]; then
        aur_flags+=(--answerdiff None --answerclean None)
    elif [ "$AUR_HELPER" = "paru" ]; then
        aur_flags+=(--skipreview)
    fi
    for pkg in "${pkgs[@]}"; do
        [ -z "$pkg" ] && continue
        if [ "$manager" = "pacman" ]; then
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || warn "Pacote nativo não encontrado/falhou: $pkg"
        else
            "$AUR_HELPER" -S "${aur_flags[@]}" "$pkg" 2>/dev/null || warn "Pacote AUR não encontrado/falhou: $pkg"
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

if { [ "${PROFILE:-full}" = "full" ] || [ "${PROFILE:-full}" = "work" ]; } && { [ "${IS_WSL:-false}" = false ] || [ "${WITH_DESKTOP:-false}" = true ]; }; then
    if [ "${PROFILE:-full}" = "work" ]; then
        NATIVE_LIST="$DOTFILES_DIR/packages/pacman-work.txt"
        AUR_LIST="$DOTFILES_DIR/packages/pacman-work-aur.txt"
    else
        NATIVE_LIST="$DOTFILES_DIR/packages/pacman-native.txt"
        AUR_LIST="$DOTFILES_DIR/packages/pacman-aur.txt"
    fi

    # Em VM Hyper-V, remove pacotes exclusivos de hardware físico / CachyOS / NVIDIA / ISOs 6GB / gaming pesado / nested VM
    HYPERV_SKIP_REGEX='^(cachyos-|linux-cachyos|nvidia|lib32-nvidia|intel-ucode|amd-ucode|tlp|throttled|gpu-screen-recorder|ananicy-rules-cachyos|limine|ttf-ms-win1[01]-auto|elyprismlauncher|heroic-games-launcher-bin|hydra-launcher-bin|ludusavi-bin|protonup-qt|realesrgan-ncnn-vulkan-bin|quickemu|quickgui-bin|android-studio|flutter-bin)'
    # Pacotes exclusivos dos repositórios CachyOS (ausentes no Arch puro)
    CACHYOS_REPO_ONLY_REGEX='^(ab-download-manager|chwd|octopi|paru|shelly|ventoy-bin|yay)$'

    is_cachyos=false
    if grep -qi "cachyos" /etc/os-release 2>/dev/null || grep -qi "\[cachyos" /etc/pacman.conf 2>/dev/null; then
        is_cachyos=true
    fi

    if [ -f "$NATIVE_LIST" ]; then
        info "Instalando pacotes nativos de $NATIVE_LIST..."
        mapfile -t native_pkgs < <(grep -vE '^\s*(#|$)' "$NATIVE_LIST" | {
            if [ "${IS_HYPERV:-false}" = true ]; then grep -vE "$HYPERV_SKIP_REGEX"; else cat; fi
        } | {
            if [ "$is_cachyos" = false ]; then grep -vE "$CACHYOS_REPO_ONLY_REGEX"; else cat; fi
        })
        sudo pacman -S --needed --noconfirm "${native_pkgs[@]}" 2>/dev/null || install_pkg_list pacman "${native_pkgs[@]}"

        # No Arch puro, wlogout está no AUR e não no repo extra
        if grep -qx "wlogout" "$NATIVE_LIST" && ! pacman -Si wlogout >/dev/null 2>&1; then
            "$AUR_HELPER" -S --needed --noconfirm --answerdiff None --answerclean None wlogout 2>/dev/null || \
                "$AUR_HELPER" -S --needed --noconfirm --answerdiff None --answerclean None --mflags "--skippgpcheck" wlogout 2>/dev/null || \
                warn "Pacote AUR wlogout não encontrado/falhou."
        fi
    fi

    if [ -f "$AUR_LIST" ]; then
        info "Instalando pacotes AUR de $AUR_LIST..."
        mapfile -t aur_pkgs < <(grep -vE '^\s*(#|$)' "$AUR_LIST" | {
            if [ "${IS_HYPERV:-false}" = true ]; then grep -vE "$HYPERV_SKIP_REGEX"; else cat; fi
        } | {
            if has_cmd yay; then grep -vx "yay-bin"; else cat; fi
        } | {
            if has_cmd mise; then grep -vx "mise-bin"; else cat; fi
        })
        aur_flags=(--needed --noconfirm)
        if [ "$AUR_HELPER" = "yay" ]; then
            aur_flags+=(--answerdiff None --answerclean None)
        elif [ "$AUR_HELPER" = "paru" ]; then
            aur_flags+=(--skipreview)
        fi
        # Evita esgotar tmpfs de /tmp durante compilações LTO/AUR em VMs
        aur_tmpdir="$HOME/.cache/makepkg-tmp"
        mkdir -p "$aur_tmpdir"
        TMPDIR="$aur_tmpdir" "$AUR_HELPER" -S "${aur_flags[@]}" "${aur_pkgs[@]}" 2>/dev/null || \
            TMPDIR="$aur_tmpdir" install_pkg_list aur "${aur_pkgs[@]}"
        rm -rf "$aur_tmpdir" 2>/dev/null || true
    fi

    if [ "${IS_HYPERV:-false}" = true ] && [ "${IS_WSL:-false}" = false ]; then
        info "Instalando pacotes de guest Hyper-V (hyperv, mesa, vulkan-swrast, fontes livres)..."
        sudo pacman -S --needed --noconfirm hyperv mesa vulkan-swrast ttf-liberation noto-fonts 2>/dev/null || warn "Algum pacote Hyper-V opcional falhou."
    fi
else
    info "Perfil dev/WSL ativo: pulando pacotes exclusivos de desktop/hardware nativo."
fi

ok "Módulo de pacotes concluído."
