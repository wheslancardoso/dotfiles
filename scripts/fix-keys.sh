#!/usr/bin/env bash
# ==============================================================================
# 🔑 Fix Keys - Reparar e Atualizar Chaves PGP do Arch Linux
# Resolve o erro: 'invalid or corrupted package (PGP signature)'
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== 🔑 Reparador de Chaves de Segurança PGP do Pacman ===${NC}\n"

echo -e "${BLUE}[INFO] Re-inicializando o chaveiro GnuPG do Pacman...${NC}"
sudo pacman-key --init

echo -e "${BLUE}[INFO] Populando chaves oficiais do Arch Linux e CachyOS...${NC}"
sudo pacman-key --populate archlinux || true
if [ -d /usr/share/pacman/keyrings/cachyos ]; then
    sudo pacman-key --populate cachyos || true
fi

echo -e "${BLUE}[INFO] Atualizando pacote archlinux-keyring...${NC}"
sudo pacman -Sy --needed --noconfirm archlinux-keyring

echo -e "\n${GREEN}${BOLD}✔ Chaves PGP reparadas e atualizadas com sucesso!${NC}"
