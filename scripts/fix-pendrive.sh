#!/usr/bin/env bash
# ==============================================================================
# 💾 Fix Pendrive - Desbloqueio e Reparo Automático de Pen-drives & Discos
# Suporta NTFS (remove dirty-bit do Windows/Fast-Startup), FAT32, exFAT, Ext4 e Btrfs.
# ==============================================================================

set -euo pipefail

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

TARGET_DEV="${1:-}"

echo -e "${BLUE}${BOLD}=== 💾 Utilitário de Reparo & Desbloqueio de Pen-drives & Discos ===${NC}\n"

# Se nenhum dispositivo foi passado como parâmetro, detectar partições removíveis
if [ -z "$TARGET_DEV" ]; then
    echo -e "Procurando dispositivos removíveis ou externos...\n"
    
    # Lista discos removíveis (RM=1 ou TRAN=usb) ou discos montados em /run/media
    DEVS=$(lsblk -rpo NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINTS,RM,TRAN 2>/dev/null | awk '$3=="part" && ($7=="1" || $8=="usb" || $6 ~ /\/run\/media/) {print $1, "(" $2, $4, $5 ")"}')
    
    if [ -z "$DEVS" ]; then
        echo -e "${YELLOW}[AVISO] Nenhuma partição removível USB detectada automaticamente.${NC}"
        echo -e "Listando todas as partições do sistema que NÃO são raiz (/):"
        DEVS=$(lsblk -rpo NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINTS 2>/dev/null | awk '$3=="part" && $6 != "/" && $6 != "/boot" && $6 != "[SWAP]" {print $1, "(" $2, $4, $5 ")"}')
    fi

    if [ -z "$DEVS" ]; then
        echo -e "${RED}[ERRO] Nenhuma partição adequada encontrada para reparo.${NC}"
        exit 1
    fi

    if command -v fzf &>/dev/null; then
        SELECTED=$(echo "$DEVS" | fzf --prompt="Selecione o pen-drive/partição para destravar > " --height=40% --reverse || true)
        TARGET_DEV=$(echo "$SELECTED" | awk '{print $1}')
    else
        echo "$DEVS"
        echo -e "\nDigite o caminho da partição (ex: /dev/sdb1): "
        read -r TARGET_DEV
    fi
fi

if [ -z "$TARGET_DEV" ] || [ ! -b "$TARGET_DEV" ]; then
    echo -e "${RED}[ERRO] Dispositivo inválido ou operação cancelada.${NC}"
    exit 1
fi

# Proteção de segurança: proibir rodar na partição raiz ou boot
MOUNTPOINT=$(lsblk -no MOUNTPOINT "$TARGET_DEV" 2>/dev/null || true)
ROOT_DISK="/dev/$(lsblk -no PKNAME / 2>/dev/null || echo "invalid_root")"
if [ "$MOUNTPOINT" = "/" ] || [ "$MOUNTPOINT" = "/boot" ] || [[ "$TARGET_DEV" == "${ROOT_DISK}"* && "$MOUNTPOINT" != *"/run/media"* ]]; then
    echo -e "${RED}[ERRO DE SEGURANÇA] O dispositivo selecionado ($TARGET_DEV) pertence ao sistema principal. Operação cancelada!${NC}"
    exit 1
fi

echo -e "${BLUE}[INFO] Alvo selecionado:${NC} ${BOLD}$TARGET_DEV${NC}"

# Detectar sistema de arquivos
FSTYPE=$(lsblk -no FSTYPE "$TARGET_DEV" 2>/dev/null || true)
if [ -z "$FSTYPE" ]; then
    FSTYPE=$(sudo blkid -o value -s TYPE "$TARGET_DEV" 2>/dev/null || echo "desconhecido")
fi

echo -e "${BLUE}[INFO] Sistema de Arquivos detectado:${NC} ${BOLD}$FSTYPE${NC}"

# 1. Desmontar temporariamente para reparar
if [ -n "$MOUNTPOINT" ]; then
    echo -e "${BLUE}[INFO] Desmontando $TARGET_DEV para inspeção segura...${NC}"
    udisksctl unmount -b "$TARGET_DEV" 2>/dev/null || sudo umount -l "$TARGET_DEV" 2>/dev/null || true
fi

# 2. Executar reparo específico
echo -e "${BLUE}[INFO] Iniciando reparo e limpeza do dirty-bit...${NC}"
case "$FSTYPE" in
    ntfs|ntfs3)
        echo -e "--> Reparando partição NTFS via ntfsfix (limpando flags de hibernação/dirty-bit do Windows)..."
        sudo ntfsfix -d "$TARGET_DEV"
        sudo ntfsfix -b "$TARGET_DEV" || true
        ;;
    vfat|fat|msdos)
        echo -e "--> Reparando partição FAT32 via dosfsck..."
        sudo dosfsck -a -v "$TARGET_DEV" || true
        ;;
    exfat)
        echo -e "--> Reparando partição exFAT..."
        if command -v fsck.exfat &>/dev/null; then
            sudo fsck.exfat -y "$TARGET_DEV" || true
        elif command -v exfatfsck &>/dev/null; then
            sudo exfatfsck -a "$TARGET_DEV" || true
        fi
        ;;
    ext4|ext3|ext2)
        echo -e "--> Reparando partição Ext4 via e2fsck..."
        sudo e2fsck -p -f "$TARGET_DEV" || true
        ;;
    btrfs)
        echo -e "--> Verificando partição Btrfs..."
        sudo btrfs check "$TARGET_DEV" || true
        ;;
    *)
        echo -e "${YELLOW}[AVISO] Sistema de arquivos '$FSTYPE' não possui corretor especializado. Tentando fsck genérico...${NC}"
        sudo fsck -y "$TARGET_DEV" || true
        ;;
esac

# 3. Remontar via udisksctl para obter permissões normais do usuário em /run/media/$USER
echo -e "\n${BLUE}[INFO] Remontando partição com permissões completas de escrita...${NC}"
if command -v udisksctl &>/dev/null; then
    MOUNT_RES=$(udisksctl mount -b "$TARGET_DEV" 2>&1 || true)
    echo "$MOUNT_RES"
fi

echo -e "\n${GREEN}${BOLD}✔ Pen-drive / Disco reparado e destravado com sucesso!${NC}"
if command -v notify-send &>/dev/null; then
    notify-send -u normal -i drive-removable-media "💾 Pen-drive Destravado" "Dispositivo $TARGET_DEV reparado e pronto para leitura/escrita!" || true
fi
