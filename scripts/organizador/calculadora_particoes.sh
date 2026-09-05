#!/usr/bin/env bash
# Calculadora de Partição para Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=================================================="
echo "   📐 CALCULADORA DE PARTICAO DE DISCO"
echo "=================================================="
echo ""
read -rp "Digite o tamanho do SSD/HD em GB (ex: 256, 480, 512, 1000, 2000): " TAMANHO

if [ -z "$TAMANHO" ]; then
    TAMANHO=480
fi

cd "$PROJECT_ROOT" || exit 1
python3 main.py --calc-disk "$TAMANHO"
