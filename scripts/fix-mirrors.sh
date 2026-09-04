#!/usr/bin/env bash
# ==============================================================================
# 🚀 Fix Mirrors - Otimizador de Espelhos / Mirrors de Download do Arch
# Testa e seleciona os mirrors mais rápidos e atualizados do Brasil e América do Sul.
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== 🚀 Otimizador de Mirrors do Arch Linux ===${NC}\n"

# Backup do mirrorlist atual
if [ -f /etc/pacman.d/mirrorlist ]; then
    echo -e "${BLUE}[INFO] Fazendo backup de /etc/pacman.d/mirrorlist...${NC}"
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak_$(date +%s)
fi

echo -e "${BLUE}[INFO] Testando velocidade e sincronia dos mirrors...${NC}"
if command -v cachyos-rate-mirrors >/dev/null 2>&1; then
    sudo cachyos-rate-mirrors
elif command -v rate-mirrors >/dev/null 2>&1; then
    rate-mirrors --allow-root --protocol https arch | sudo tee /etc/pacman.d/mirrorlist >/dev/null
elif command -v reflector >/dev/null 2>&1; then
    sudo reflector --country Brazil,Chile,Argentina,United\ States --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
else
    echo -e "${YELLOW}[AVISO] Instalando reflector para ranquear mirrors...${NC}"
    sudo pacman -S --needed --noconfirm reflector
    sudo reflector --country Brazil,Chile,Argentina,United\ States --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
fi

echo -e "\n${BLUE}[INFO] Atualizando cache com os novos mirrors...${NC}"
sudo pacman -Syy

echo -e "\n${GREEN}${BOLD}✔ Mirrors mais rápidos selecionados com sucesso!${NC}"
