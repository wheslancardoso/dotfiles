#!/bin/bash
# 🌌 One-Shot Master Installer: Arch-Hyprland + Vibe Coding Suite
# Executa a instalação completa do Arch-Hyprland com drivers NVIDIA, SDDM,
# PipeWire corrigido, pacotes acelerados e integração direta com seus dotfiles.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PRESET="$SCRIPT_DIR/presets/master.conf"

echo "=========================================================="
echo "  🌌 INICIANDO INSTALAÇÃO MESTRE ARCH-HYPRLAND + DOTFILES"
echo "=========================================================="
echo "Arquivo de Preset: $PRESET"
echo ""

chmod +x install.sh
./install.sh --preset "$PRESET" --noconfirm "$@"
