#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="${DIR}/.ultimo_lote"

if [[ ! -f "$STATE_FILE" ]]; then
    echo "4" > "$STATE_FILE"
fi

CURRENT=$(cat "$STATE_FILE")
TOTAL=16

if (( CURRENT > TOTAL )); then
    echo "Todos os 16 lotes já foram abertos! Se quiser reiniciar, altere ${STATE_FILE}."
    exit 0
fi

SCRIPT_NAME=$(printf "baixar_lote_%02d.sh" "$CURRENT")
SCRIPT_PATH="${DIR}/${SCRIPT_NAME}"

if [[ -f "$SCRIPT_PATH" ]]; then
    echo "=========================================================="
    echo " Abrindo no Brave: Lote ${CURRENT} de ${TOTAL} (${SCRIPT_NAME})"
    echo "=========================================================="
    bash "$SCRIPT_PATH"
    NEXT=$(( CURRENT + 1 ))
    echo "$NEXT" > "$STATE_FILE"
    echo "Próxima vez que você rodar este comando, abrirá o Lote $(printf "%02d" "$NEXT")."
else
    echo "Script ${SCRIPT_NAME} não encontrado!"
fi
