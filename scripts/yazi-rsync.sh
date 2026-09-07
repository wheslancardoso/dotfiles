#!/usr/bin/env bash
# ==============================================================================
# 🚀 YAZI RSYNC TURBO — Cópia e Movimentação Segura para HDs Externos e Drives
# ==============================================================================
# Usa rsync com aceleração, barra de progresso granular (--info=progress2),
# preservação de permissões e timestamps, e recuperação de transferências interrompidas.
# ==============================================================================

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Nenhum arquivo informado."
    exit 1
fi

FILES=("$@")

echo "=========================================================="
echo "   🚀 YAZI RSYNC TURBO — TRANSFERÊNCIA ULTRA-SEGURA       "
echo "=========================================================="
echo "Arquivos selecionados (${#FILES[@]}):"
for f in "${FILES[@]}"; do
    echo "  ➔ $(basename "$f")"
done
echo "----------------------------------------------------------"
echo "Onde deseja salvar? (Cole o caminho ou aperte ENTER para usar pasta atual)"
echo "Sugestões rápidas:"
echo "  1) /run/media/$USER/ (Dispositivos USB / HDs Externos)"
echo "  2) /mnt/dados/00_Inbox_Triagem"
echo "  3) /mnt/dados/06_Backups_ISOs_e_Sistemas"
echo "----------------------------------------------------------"

read -rp "Destino: " DEST_INPUT

DEST="${DEST_INPUT:-$PWD}"

if [[ "$DEST_INPUT" == "1" ]]; then
    # Lista pen-drives / hds externos
    USB_DRIVES=(/run/media/"$USER"/*)
    if [ -d "${USB_DRIVES[0]:-}" ]; then
        DEST="${USB_DRIVES[0]}"
    else
        DEST="/run/media/$USER"
    fi
elif [[ "$DEST_INPUT" == "2" ]]; then
    DEST="/mnt/dados/00_Inbox_Triagem"
elif [[ "$DEST_INPUT" == "3" ]]; then
    DEST="/mnt/dados/06_Backups_ISOs_e_Sistemas"
fi

mkdir -p "$DEST"

echo ""
echo "Operação:"
echo "  [c] Copiar (mantém arquivos de origem)"
echo "  [m] Mover (remove arquivos de origem após confirmação de integridade)"
read -rp "Escolha (c/m) [Padrão: c]: " OP_CHOICE

OP="${OP_CHOICE:-c}"

echo ""
echo "🚀 Iniciando transferência via Rsync para: $DEST"
echo "=========================================================="

if [[ "$OP" == "m" || "$OP" == "M" ]]; then
    rsync -ahP --remove-source-files --info=progress2 "${FILES[@]}" "$DEST/"
    echo ""
    echo "✔ Mover concluído com integridade verificada!"
else
    rsync -ahP --info=progress2 "${FILES[@]}" "$DEST/"
    echo ""
    echo "✔ Cópia concluída com integridade verificada!"
fi

echo "=========================================================="
read -rp "Pressione ENTER para voltar ao Yazi..."
