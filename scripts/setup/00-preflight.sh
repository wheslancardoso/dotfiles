#!/bin/bash
# Módulo 00: Preflight (Sudo, Pacman Turbo, Makepkg Turbo, Multilib, Yay)

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_sudo_nopasswd() {
    info "Configurando sudo sem senha (NOPASSWD) para $USER..."
    echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/99-$USER-nopasswd" >/dev/null
    sudo chmod 440 "/etc/sudoers.d/99-$USER-nopasswd"
    if sudo visudo -cf "/etc/sudoers.d/99-$USER-nopasswd" >/dev/null 2>&1; then
        ok "Sudo sem senha configurado."
    else
        sudo rm -f "/etc/sudoers.d/99-$USER-nopasswd"
        warn "Falha na validação do sudoers. NOPASSWD revertido."
    fi
}

setup_pacman_turbo() {
    info "Configurando Pacman Turbo (10 downloads paralelos, Color, ILoveCandy)..."
    if [ -f /etc/pacman.conf ]; then
        sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
        sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
        sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf
        sudo sed -i 's/^ParallelDownloads = .*/ParallelDownloads = 10/' /etc/pacman.conf
        if ! grep -q "ILoveCandy" /etc/pacman.conf; then
            sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
        fi
        ok "Pacman Turbo configurado."
    fi

    if [ "${IS_WSL:-false}" = false ]; then
        if has_cmd cachyos-rate-mirrors; then
            info "Otimizando espelhos CachyOS..."
            sudo cachyos-rate-mirrors 2>/dev/null || true
        elif has_cmd reflector; then
            info "Otimizando espelhos com Reflector..."
            sudo reflector --country Brazil,Chile,Argentina --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --threads "$(nproc)" 2>/dev/null || warn "Reflector falhou; mantendo mirrorlist atual."
        fi
    fi
}

setup_makepkg_turbo() {
    info "Configurando Makepkg Turbo (multi-core + tmpfs)..."
    local cores
    cores=$(nproc 2>/dev/null || echo 4)
    if [ -f /etc/makepkg.conf ]; then
        if grep -q "^#MAKEFLAGS=" /etc/makepkg.conf; then
            sudo sed -i "s/^#MAKEFLAGS=.*/MAKEFLAGS=\"-j${cores}\"/" /etc/makepkg.conf
        elif grep -q "^MAKEFLAGS=" /etc/makepkg.conf; then
            sudo sed -i "s/^MAKEFLAGS=.*/MAKEFLAGS=\"-j${cores}\"/" /etc/makepkg.conf
        else
            echo "MAKEFLAGS=\"-j${cores}\"" | sudo tee -a /etc/makepkg.conf >/dev/null
        fi

        if grep -q "^#BUILDDIR=/tmp" /etc/makepkg.conf; then
            sudo sed -i 's|^#BUILDDIR=/tmp.*|BUILDDIR=/tmp/makepkg|' /etc/makepkg.conf
        elif ! grep -q "^BUILDDIR=" /etc/makepkg.conf; then
            echo 'BUILDDIR=/tmp/makepkg' | sudo tee -a /etc/makepkg.conf >/dev/null
        fi

        sudo sed -i "s/^COMPRESSZST=.*/COMPRESSZST=(zstd -c -z -q --threads=0 -)/" /etc/makepkg.conf 2>/dev/null || true
        sudo sed -i "s/^COMPRESSXZ=.*/COMPRESSXZ=(xz -c -z - --threads=0)/" /etc/makepkg.conf 2>/dev/null || true
        ok "Makepkg Turbo configurado ($cores cores)."
    fi
}

enable_multilib() {
    if [ -f /etc/pacman.conf ] && ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        info "Ativando repositório multilib..."
        sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
        sudo pacman -Sy --noconfirm
        ok "Multilib ativado."
    fi
}

install_aur_helper() {
    if has_cmd yay || has_cmd paru; then
        ok "AUR helper já instalado."
        return 0
    fi
    info "Instalando yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    if sudo pacman -S --needed --noconfirm yay 2>/dev/null; then
        ok "yay instalado via repositório."
    else
        rm -rf /tmp/yay
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
        ok "yay compilado e instalado."
    fi
}

setup_sudo_nopasswd
setup_pacman_turbo
setup_makepkg_turbo
enable_multilib
info "Atualizando sistema..."
sudo pacman -Syu --noconfirm
install_aur_helper
