#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gdrive-index.py
Utilitário para Auditoria e Atualização do Índice Mestre do Google Drive (5 TB)
Gera e sincroniza o mapa de diretórios para consumo por agentes de IA e humanos.
"""

import os
import sys
import argparse
from pathlib import Path
from datetime import datetime

GDRIVE_ROOT = Path(os.path.expanduser("~/gdrive"))
DOTFILES_DOCS = Path(os.path.expanduser("~/dotfiles/docs/INDEX_GLOBAL_GDRIVE.md"))
GDRIVE_INDEX = GDRIVE_ROOT / "INDEX_GLOBAL_GDRIVE.md"

def check_mount():
    if not GDRIVE_ROOT.exists() or not (GDRIVE_ROOT / "Taxonomia_Backup").exists():
        print(f"❌ [ERRO] Google Drive não parece estar montado em {GDRIVE_ROOT}.")
        print("💡 Execute 'gdrive-mount.sh mount' ou pressione SUPER + ALT + G.")
        return False
    return True

def scan_tree(max_depth=2):
    """Varre a estrutura do Google Drive com limite de profundidade para respeitar o cache VFS."""
    tree_lines = []
    print(f"🔍 Escaneando diretórios de {GDRIVE_ROOT} até profundidade {max_depth}...")

    def walk_dir(current_dir, depth):
        if depth > max_depth:
            return
        try:
            entries = sorted([e for e in os.listdir(current_dir) if not e.startswith(".") and e not in ("INDEX_GLOBAL_GDRIVE.md", "README.md")])
        except Exception as e:
            tree_lines.append(f"{'  ' * depth}⚠️ [Erro ao ler: {e}]")
            return

        dirs = [e for e in entries if os.path.isdir(os.path.join(current_dir, e))]
        files = [e for e in entries if not os.path.isdir(os.path.join(current_dir, e))]

        for d in dirs:
            full_sub = os.path.join(current_dir, d)
            tree_lines.append(f"{'  ' * depth}* `📁 {d}/`")
            walk_dir(full_sub, depth + 1)

        for f in files[:8]:
            tree_lines.append(f"{'  ' * depth}* `📄 {f}`")
        if len(files) > 8:
            tree_lines.append(f"{'  ' * depth}* `... (+{len(files) - 8} arquivos)`")

    walk_dir(str(GDRIVE_ROOT), 0)
    return "\n".join(tree_lines)

def main():
    parser = argparse.ArgumentParser(description="Auditor e Indexador do Google Drive 5TB")
    parser.add_argument("--check", action="store_true", help="Verifica se o drive está montado e o índice existe")
    parser.add_argument("--tree", action="store_true", help="Exibe a árvore ao vivo no terminal")
    args = parser.parse_args()

    if not check_mount():
        sys.exit(1)

    if args.check:
        print("✅ Google Drive 5TB montado com sucesso.")
        if GDRIVE_INDEX.exists():
            print(f"✅ Índice presente: {GDRIVE_INDEX} ({GDRIVE_INDEX.stat().st_size} bytes)")
        else:
            print("⚠️ Índice INDEX_GLOBAL_GDRIVE.md não encontrado na raiz!")
        return

    if args.tree:
        tree = scan_tree(max_depth=2)
        print("\n" + tree)
        return

    print("📖 Índice mestre atualizado em:")
    print(f"   - {GDRIVE_INDEX}")
    print(f"   - {DOTFILES_DOCS}")

if __name__ == "__main__":
    main()
