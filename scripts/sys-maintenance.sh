#!/usr/bin/env bash
# ==============================================================================
# 🧹 ARCH LINUX COMFORT SUITE — Manutenção e Limpeza Zero-Fricção
# ==============================================================================
# Comandos rápidos:
#   cleanup  -> Limpa cache pacman, pacotes órfãos, logs do journal e lixeira
#   sys-update -> Atualiza pacman + AUR de forma rápida, limpa e segura
# ==============================================================================

set -euo pipefail

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

ACTION="${1:-help}"

notify() {
    if command -v notify-send &>/dev/null; then
        notify-send -a "Sistema" -i "system-software-update" "$1" "$2" 2>/dev/null || true
    fi
}

do_cleanup() {
    echo -e "${CYAN}====================================================${NC}"
    echo -e "${CYAN}   🧹 FAXINA GERAL DO SISTEMA (Arch Linux Clean)   ${NC}"
    echo -e "${CYAN}====================================================${NC}"

    # 1. Limpeza de pacotes órfãos
    echo -e "\n${GREEN}[1/5] Verificando pacotes órfãos sem uso...${NC}"
    if command -v pacman &>/dev/null; then
        orphans=$(pacman -Qtdq 2>/dev/null || true)
        if [ -n "$orphans" ]; then
            echo -e "${YELLOW}Removendo órfãos:${NC} $orphans"
            sudo pacman -Rns --noconfirm $orphans
        else
            echo "Nenhum pacote órfão encontrado. Sistema limpo!"
        fi
    fi

    # 2. Limpeza de cache do Pacman
    echo -e "\n${GREEN}[2/5] Limpando cache de pacotes antigos...${NC}"
    if command -v paccache &>/dev/null; then
        sudo paccache -r -k 2 2>/dev/null || true
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sc --noconfirm 2>/dev/null || true
    fi

    # 3. Limpeza de logs do Journald
    echo -e "\n${GREEN}[3/5] Reduzindo logs do sistema para os últimos 7 dias...${NC}"
    if command -v journalctl &>/dev/null; then
        sudo journalctl --vacuum-time=7d 2>/dev/null || true
    fi

    # 4. Limpeza de miniaturas e cache temporário
    echo -e "\n${GREEN}[4/5] Limpando miniaturas antigas e cache de usuário...${NC}"
    rm -rf "$HOME/.cache/thumbnails/"* 2>/dev/null || true
    rm -rf "$HOME/.local/share/Trash/"* 2>/dev/null || true

    # 5. Verificação de integridade dos serviços
    echo -e "\n${GREEN}[5/5] Verificando se há serviços com falha no systemd...${NC}"
    if command -v systemctl &>/dev/null; then
        failed_services=$(systemctl --failed --plain --no-legend 2>/dev/null || true)
        if [ -n "$failed_services" ]; then
            echo -e "${RED}[!] Serviços com erro detectados:${NC}"
            echo "$failed_services"
        else
            echo "Todos os serviços do sistema estão operando normalmente (100% OK)."
        fi
    fi

    echo -e "\n${GREEN}✨ Faxina concluída com sucesso! Espaço em disco recuperado.${NC}"
    notify "Faxina Concluída" "Cache de pacotes, órfãos e logs antigos foram limpos com sucesso."
}

do_update() {
    echo -e "${CYAN}====================================================${NC}"
    echo -e "${CYAN}   🚀 ATUALIZAÇÃO SEGURA DO SISTEMA (Full Update)  ${NC}"
    echo -e "${CYAN}====================================================${NC}"

    notify "Atualização Iniciada" "Sincronizando repositórios oficiais e AUR..."

    if command -v yay &>/dev/null; then
        yay -Syu --noconfirm
    elif command -v paru &>/dev/null; then
        paru -Syu --noconfirm
    elif command -v pacman &>/dev/null; then
        sudo pacman -Syu --noconfirm
    fi

    # Atualiza Flatpaks se houver
    if command -v flatpak &>/dev/null; then
        echo -e "\n${GREEN}[*] Atualizando pacotes Flatpak...${NC}"
        flatpak update -y 2>/dev/null || true
    fi

    # Diagnóstico da taxonomia
    if [ -f "$HOME/dotfiles/scripts/organizador/main.py" ]; then
        echo -e "\n${GREEN}[*] Verificando integridade da taxonomia de pastas...${NC}"
        python3 "$HOME/dotfiles/scripts/organizador/main.py" --doctor || true
    fi

    notify "Atualização Concluída" "Sistema Arch Linux e pacotes AUR estão 100% atualizados!"
}

do_mirrors() {
    echo -e "${CYAN}====================================================${NC}"
    echo -e "${CYAN}   ⚡ OTIMIZAÇÃO DE ESPELHOS PACMAN (Reflector)    ${NC}"
    echo -e "${CYAN}====================================================${NC}"

    if ! command -v reflector &>/dev/null; then
        echo -e "${RED}[!] Reflector não está instalado.${NC}"
        echo "Instale com: sudo pacman -S --needed reflector"
        return 1
    fi

    echo -e "${GREEN}[*] Testando e ranqueando os servidores mais rápidos no Brasil e América do Sul...${NC}"
    notify "Otimizando Espelhos" "Testando mirrors do Pacman mais rápidos no Brasil..."

    local threads
    threads=$(nproc 2>/dev/null || echo 4)
    sudo reflector --country Brazil,Chile,Argentina --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --threads "$threads"

    echo -e "${GREEN}✓ Mirrorlist atualizada com os servidores mais rápidos!${NC}"
    notify "Espelhos Otimizados" "Mirrorlist atualizada. Downloads do pacman agora na velocidade máxima!"
}

do_turbo() {
    echo -e "${CYAN}====================================================${NC}"
    echo -e "${CYAN}   🚀 PACMAN & MAKEPKG TURBO ATIVADOR              ${NC}"
    echo -e "${CYAN}====================================================${NC}"

    local cores
    cores=$(nproc 2>/dev/null || echo 4)

    if [ -f /etc/pacman.conf ]; then
        echo -e "${GREEN}[1/2] Ativando 10 downloads paralelos e cores no pacman.conf...${NC}"
        sudo sed -i 's/^#Color/Color/' /etc/pacman.conf 2>/dev/null || true
        sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf 2>/dev/null || true
        sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf 2>/dev/null || true
        sudo sed -i 's/^ParallelDownloads = .*/ParallelDownloads = 10/' /etc/pacman.conf 2>/dev/null || true
        if ! grep -q "ILoveCandy" /etc/pacman.conf 2>/dev/null; then
            sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf 2>/dev/null || true
        fi
        echo -e "${GREEN}✓ Pacman configurado com 10 downloads paralelos e ILoveCandy!${NC}"
    fi

    if [ -f /etc/makepkg.conf ]; then
        echo -e "${GREEN}[2/2] Ativando compilação multi-core (${cores} threads) no makepkg.conf...${NC}"
        if grep -q "^#MAKEFLAGS=" /etc/makepkg.conf; then
            sudo sed -i "s/^#MAKEFLAGS=.*/MAKEFLAGS=\"-j${cores}\"/" /etc/makepkg.conf
        elif grep -q "^MAKEFLAGS=" /etc/makepkg.conf; then
            sudo sed -i "s/^MAKEFLAGS=.*/MAKEFLAGS=\"-j${cores}\"/" /etc/makepkg.conf
        else
            echo "MAKEFLAGS=\"-j${cores}\"" | sudo tee -a /etc/makepkg.conf >/dev/null
        fi
        sudo sed -i "s/^COMPRESSZST=.*/COMPRESSZST=(zstd -c -z -q --threads=0 -)/" /etc/makepkg.conf 2>/dev/null || true
        sudo sed -i "s/^COMPRESSXZ=.*/COMPRESSXZ=(xz -c -z - --threads=0)/" /etc/makepkg.conf 2>/dev/null || true
        echo -e "${GREEN}✓ Makepkg configurado com ${cores} núcleos (AUR compilará a velocidade máxima)!${NC}"
    fi

    notify "Turbo Ativado" "Pacman (10 downloads) e Makepkg (${cores} núcleos) otimizados com sucesso."
}

case "$ACTION" in
    cleanup|limpar)
        do_cleanup
        ;;
    update|atualizar)
        do_update
        ;;
    mirrors|espelhos)
        do_mirrors
        ;;
    turbo)
        do_turbo
        ;;
    *)
        echo "Uso: $0 {cleanup|update|mirrors|turbo}"
        echo "  cleanup : Remove pacotes órfãos, limpa cache do pacman e trunca logs antigos"
        echo "  update  : Atualiza pacman, AUR, flatpaks e roda diagnóstico de integridade"
        echo "  mirrors : Rankea os mirrors mais rápidos do Brasil/América do Sul com Reflector"
        echo "  turbo   : Configura pacman (10 downloads paralelos) e makepkg (-j núcleos) no talo"
        exit 1
        ;;
esac
