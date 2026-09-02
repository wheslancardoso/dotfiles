#!/usr/bin/env python3
"""
Ponto de entrada principal para a execução do Organizador Master.
Uso direto: python main.py --help
"""

import sys
from pathlib import Path

# Adiciona o diretório atual ao sys.path para imports limpos
current_dir = Path(__file__).resolve().parent
if str(current_dir) not in sys.path:
    sys.path.insert(0, str(current_dir))

from src.cli import run_cli

if __name__ == "__main__":
    run_cli()
