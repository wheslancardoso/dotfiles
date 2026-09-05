#!/usr/bin/env bash
# Script para auto-nomenclatura e datas ISO no Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "===================================================="
echo "   ORGANIZADOR MASTER — AUTO-NOMENCLATURA (ISO)"
echo "===================================================="
echo ""

read -rp "Digite o caminho da pasta para padronizar (ENTER para ~/Downloads): " PASTA_ALVO

if [ -z "$PASTA_ALVO" ]; then
    PASTA_ALVO="$HOME/Downloads"
fi

cd "$PROJECT_ROOT" || exit 1
python3 main.py --auto-date "$PASTA_ALVO" "$@"
