#!/usr/bin/env bash
# Script para simular a organização completa (Dry-Run) no Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "===================================================="
echo "   ORGANIZADOR MASTER — MODO SIMULACAO (DRY-RUN)"
echo "===================================================="
echo ""

cd "$PROJECT_ROOT" || exit 1
python3 main.py --all --dry-run "$@"
