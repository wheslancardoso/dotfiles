#!/usr/bin/env bash
# Script para desfazer a última organização no Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "===================================================="
echo "   ORGANIZADOR MASTER — DESFAZER (UNDO)"
echo "===================================================="
echo ""

cd "$PROJECT_ROOT" || exit 1
python3 main.py --undo "$@"
