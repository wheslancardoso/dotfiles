#!/usr/bin/env bash
# ==============================================================================
# 💿 VENTOY TURBO — Instalação Inteligente de Bootloader Multiboot Universal
# ==============================================================================
# Detecta automaticamente discos USB conectados, lista com tamanho e modelo,
# e instala o Ventoy em MBR+UEFI+SecureBoot com confirmação segura.
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  💿  VENTOY — Instalador Multiboot Universal             ║"
echo "║      MBR + UEFI + Secure Boot — Uma vez, pra sempre      ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar se o ventoy está instalado
if ! command -v ventoy &>/dev/null; then
    echo -e "${RED}[ERRO] Ventoy não está instalado.${NC}"
    echo -e "Instale com: ${BOLD}sudo pacman -S ventoy-bin${NC}"
    exit 1
fi

VENTOY_VERSION=$(ventoy --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1 || echo "desconhecida")
echo -e "${GREEN}✔ Ventoy ${VENTOY_VERSION} detectado${NC}\n"

# Detectar discos USB disponíveis
echo -e "${BOLD}Discos USB disponíveis:${NC}"
echo "──────────────────────────────────────────────────────────"

USB_DISKS=()
idx=1
while IFS= read -r line; do
    DEV=$(echo "$line" | awk '{print $1}')
    SIZE=$(echo "$line" | awk '{print $2}')
    MODEL=$(echo "$line" | awk '{$1=$2=""; print $0}' | xargs)
    echo -e "  ${BOLD}[$idx]${NC} /dev/${DEV}  ${GREEN}${SIZE}${NC}  ${MODEL}"
    USB_DISKS+=("/dev/$DEV")
    idx=$((idx+1))
done < <(lsblk -dno NAME,SIZE,MODEL | awk '$1 ~ /^sd/')

if [ ${#USB_DISKS[@]} -eq 0 ]; then
    echo -e "${RED}[ERRO] Nenhum disco USB detectado. Conecte o pen-drive ou SSD externo.${NC}"
    exit 1
fi

echo "──────────────────────────────────────────────────────────"
echo ""
read -rp "Escolha o número do disco para instalar o Ventoy: " CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "${#USB_DISKS[@]}" ]; then
    echo -e "${RED}[ERRO] Opção inválida.${NC}"
    exit 1
fi

TARGET="${USB_DISKS[$((CHOICE-1))]}"
TARGET_INFO=$(lsblk -dno SIZE,MODEL "$TARGET" | xargs)

echo ""
echo -e "${YELLOW}${BOLD}⚠️  ATENÇÃO: Todos os dados em ${TARGET} (${TARGET_INFO}) serão APAGADOS!${NC}"
echo ""
echo -e "  O que será instalado:"
echo -e "  • Partição 1 (exFAT) → Para suas ISOs e arquivos"
echo -e "  • Partição 2 (FAT 32MB) → Bootloader: MBR + UEFI x64/x32 + Secure Boot"
echo ""
read -rp "Confirmar instalação do Ventoy em ${TARGET}? (sim/não): " CONFIRM

if [[ "$CONFIRM" != "sim" && "$CONFIRM" != "s" && "$CONFIRM" != "y" && "$CONFIRM" != "yes" ]]; then
    echo -e "${YELLOW}Cancelado.${NC}"
    exit 0
fi

# Desmontar partições se estiverem montadas
echo ""
echo -e "${BLUE}Desmontando partições de ${TARGET}...${NC}"
for part in "${TARGET}"?*; do
    umount "$part" 2>/dev/null && echo "  Desmontado: $part" || true
done

echo ""
echo -e "${BLUE}🚀 Instalando Ventoy em ${TARGET}...${NC}"
echo "──────────────────────────────────────────────────────────"

# -I = Install, -s = Secure Boot, sem -g = tabela MBR (funciona em BIOS+UEFI)
sudo ventoy -I -s "$TARGET"

echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║  ✅ Ventoy instalado com sucesso em ${TARGET}!             ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Como usar:${NC}"
echo -e "  • Copie qualquer .iso para a partição Ventoy:"
echo -e "    ${BOLD}rsync windows.iso /run/media/\$USER/Ventoy/${NC}"
echo -e "  • Repita para quantas ISOs quiser — sem limites!"
echo -e "  • Dê boot no PC e escolha a ISO no menu gráfico do Ventoy"
echo ""
echo -e "  ${BOLD}Para atualizar o Ventoy no futuro (sem apagar as ISOs):${NC}"
echo -e "    ${BOLD}sudo ventoy -U ${TARGET}${NC}"
echo ""
