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
echo "Para onde deseja transferir?"
echo "  [ENTER] Pasta atual ($PWD)"

# Listar unidades removíveis montadas (/run/media/$USER/*) dinamicamente
idx=1
declare -A SUGGESTIONS
VENTOY_DIR=""
for d in /run/media/"$USER"/*; do
    if [ -d "$d" ]; then
        label=$(basename "$d")
        if [[ "$label" =~ ^Ventoy || -d "$d/ventoy" || -d "$d/ISOs" ]]; then
            VENTOY_DIR="$d"
            echo "  [v] 💿 Pen-drive Ventoy: $d"
        fi
        echo "  [$idx] Dispositivo USB: $d"
        SUGGESTIONS[$idx]="$d"
        idx=$((idx+1))
    fi
done

echo "  [d] /mnt/dados/00_Inbox_Triagem (Downloads)"
echo "  [b] /mnt/dados/06_Backups_ISOs_e_Sistemas (Backups)"
echo "  [ou digite/cole qualquer caminho personalizado]"
echo "----------------------------------------------------------"

read -rp "Destino [Padrão: pasta atual]: " DEST_INPUT

DEST="${DEST_INPUT:-$PWD}"

if [[ -n "${SUGGESTIONS[$DEST_INPUT]:-}" ]]; then
    DEST="${SUGGESTIONS[$DEST_INPUT]}"
elif [[ ("$DEST_INPUT" == "v" || "$DEST_INPUT" == "V") && -n "$VENTOY_DIR" ]]; then
    DEST="$VENTOY_DIR"
    [ -d "$VENTOY_DIR/ISOs" ] && DEST="$VENTOY_DIR/ISOs"
elif [[ "$DEST_INPUT" == "1" && -z "${SUGGESTIONS[1]:-}" ]]; then
    DEST="/run/media/$USER"
elif [[ "$DEST_INPUT" == "d" || "$DEST_INPUT" == "D" ]]; then
    DEST="/mnt/dados/00_Inbox_Triagem"
elif [[ "$DEST_INPUT" == "b" || "$DEST_INPUT" == "B" ]]; then
    DEST="/mnt/dados/06_Backups_ISOs_e_Sistemas"
fi

mkdir -p "$DEST"

echo ""
echo "Operação:"
echo "  [c] Copiar (mantém origens, grava com recuperação contínua)"
echo "  [m] Mover (remove origem com segurança APÓS gravação no destino)"
read -rp "Escolha (c/m) [Padrão: c]: " OP_CHOICE

OP="${OP_CHOICE:-c}"

echo ""
echo "🚀 Iniciando transferência via Rsync Turbo para: $DEST"
echo "Flags: -ahP --inplace --info=progress2"
echo "=========================================================="

if [[ "$OP" == "m" || "$OP" == "M" ]]; then
    rsync -ahP --inplace --remove-source-files --info=progress2 "${FILES[@]}" "$DEST/"
    echo ""
    echo "✔ Mover concluído com integridade verificada!"
else
    rsync -ahP --inplace --info=progress2 "${FILES[@]}" "$DEST/"
    echo ""
    echo "✔ Cópia concluída com integridade verificada!"
fi

echo "=========================================================="
read -rp "Pressione ENTER para voltar ao Yazi..."
