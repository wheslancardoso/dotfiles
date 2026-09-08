#!/usr/bin/env bash
# ==============================================================================
# 💿 YAZI ➔ VENTOY TURBO — ENVIO RÁPIDO DE ISOs PARA O PEN-DRIVE MULTIBOOT
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${RED}[ERRO] Nenhum arquivo selecionado no Yazi.${NC}"
    exit 1
fi

FILES=("$@")

echo -e "${BLUE}${BOLD}==========================================================${NC}"
echo -e "   💿 ${BOLD}YAZI ➔ ENVIAR ISOs PARA O VENTOY MULTIBOOT${NC}       "
echo -e "${BLUE}${BOLD}==========================================================${NC}\n"

echo -e "Arquivos selecionados (${#FILES[@]}):"
for f in "${FILES[@]}"; do
    sz=$(ls -lh "$f" | awk '{print $5}')
    echo -e "  ➔ ${GREEN}$(basename "$f")${NC}  [$sz]"
done
echo ""

# Encontrar ponto de montagem do Ventoy
VTOY_MOUNT=""
for m in /run/media/"$USER"/*; do
    if [ -d "$m" ]; then
        label=$(basename "$m")
        if [[ "$label" == "Ventoy" || -d "$m/ventoy" || -d "$m/ISOs" ]]; then
            VTOY_MOUNT="$m"
            break
        fi
    fi
done

# Se não achou montado, procurar partição com label Ventoy e montar
if [ -z "$VTOY_MOUNT" ]; then
    VTOY_PART=$(lsblk -rpo NAME,LABEL,FSTYPE 2>/dev/null | awk '$2 ~ /Ventoy/i || $2 ~ /VTOYEFI/i {print $1}' | head -1 || true)
    if [ -n "$VTOY_PART" ]; then
        echo -e "${BLUE}Montando partição do Ventoy ($VTOY_PART)...${NC}"
        # Se achou VTOYEFI, tenta a partição 1 que é a de dados
        DATA_PART=$(echo "$VTOY_PART" | sed 's/[0-9]$/1/')
        VTOY_MOUNT=$(udisksctl mount -b "$DATA_PART" 2>/dev/null | grep -oP 'at \K.*' || echo "")
    fi
fi

if [ -z "$VTOY_MOUNT" ] || [ ! -d "$VTOY_MOUNT" ]; then
    echo -e "${YELLOW}[AVISO] Pen-drive do Ventoy não está conectado ou montado.${NC}"
    echo -e "Por favor, conecte seu dispositivo USB e monte-o primeiro."
    read -rp "Pressione [ENTER] para sair..." _
    exit 1
fi

TARGET_DIR="$VTOY_MOUNT"
[ -d "$VTOY_MOUNT/ISOs" ] && TARGET_DIR="$VTOY_MOUNT/ISOs"

FREE_SPACE=$(df -h "$TARGET_DIR" | awk 'NR==2 {print $4}')
echo -e "${GREEN}✔ Ventoy detectado:${NC} ${BOLD}$TARGET_DIR${NC} (${CYAN}${FREE_SPACE} livres${NC})\n"

read -rp "Deseja transferir agora com Rsync Turbo? (S/n): " ans
if [[ "$ans" =~ ^[nN] ]]; then
    echo -e "${YELLOW}Transferência cancelada.${NC}"
    exit 0
fi

echo -e "\n${GREEN}🚀 Iniciando cópia turbo para o Ventoy...${NC}\n"

for f in "${FILES[@]}"; do
    rsync -ahP --inplace --info=progress2 "$f" "$TARGET_DIR/"
done

echo -e "\n${GREEN}${BOLD}✔ Todas as ISOs foram transferidas com 100% de integridade!${NC}\n"

if command -v notify-send &>/dev/null; then
    notify-send -a "Ventoy" -i "drive-removable-media" \
        "💿 ISOs Gravadas no Ventoy!" \
        "${#FILES[@]} arquivo(s) copiado(s) para o pen-drive com sucesso."
fi

read -rp "Pressione [ENTER] para fechar..." _
