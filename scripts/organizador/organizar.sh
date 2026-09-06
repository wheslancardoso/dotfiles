#!/usr/bin/env bash
# Script para executar a organização completa no Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

echo "===================================================="
echo "   ORGANIZADOR MASTER — EXECUTANDO ORGANIZACAO"
echo "===================================================="
echo ""

cd "$PROJECT_ROOT" || exit 1
python3 main.py --all "$@"
