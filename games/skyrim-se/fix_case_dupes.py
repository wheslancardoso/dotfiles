#!/usr/bin/env python3
"""Mescla diretórios/arquivos duplicados por caixa (ex: Scripts/ vs scripts/).

No Linux, extrair mods com caixas diferentes cria pastas paralelas; o Wine
resolve só uma delas e o resto vira invisível para o jogo.
Uso: fix_case_dupes.py <dir> [--apply]
"""
import os
import shutil
import sys

APPLY = "--apply" in sys.argv
stats = {"dirs_merged": 0, "files_moved": 0, "conflicts": 0}


def pick_canonical(names, parent):
    # Prefere a variante com mais entradas; empate -> a que começa maiúscula.
    def score(n):
        p = os.path.join(parent, n)
        cnt = sum(len(f) + len(d) for _, d, f in os.walk(p)) if os.path.isdir(p) else 0
        return (cnt, n[:1].isupper())
    return max(names, key=score)


def merge_into(src, dst):
    """Move conteúdo de src para dst (ambos dirs), resolvendo caixa no destino."""
    dst_index = {n.lower(): n for n in os.listdir(dst)}
    for name in os.listdir(src):
        s = os.path.join(src, name)
        existing = dst_index.get(name.lower())
        if existing is None:
            stats["files_moved"] += 1
            if APPLY:
                shutil.move(s, os.path.join(dst, name))
            dst_index[name.lower()] = name
            continue
        d = os.path.join(dst, existing)
        if os.path.isdir(s) and os.path.isdir(d):
            merge_into(s, d)
        elif os.path.isfile(s) and os.path.isfile(d):
            stats["conflicts"] += 1
            # Mantém o mais novo (último mod instalado vence).
            if os.path.getmtime(s) > os.path.getmtime(d):
                print(f"  [conflito] {d} <- {s} (mais novo)")
                if APPLY:
                    os.replace(s, d)
            elif APPLY:
                os.remove(s)
        else:
            print(f"  [!] tipo divergente, ignorado: {s} vs {d}")
    if APPLY:
        try:
            os.rmdir(src)
        except OSError:
            print(f"  [!] não esvaziou: {src}")


def walk(path):
    entries = [e for e in os.listdir(path) if os.path.isdir(os.path.join(path, e))]
    groups = {}
    for e in entries:
        groups.setdefault(e.lower(), []).append(e)
    for names in groups.values():
        if len(names) > 1:
            canon = pick_canonical(names, path)
            for other in names:
                if other != canon:
                    stats["dirs_merged"] += 1
                    print(f"[merge] {os.path.join(path, other)} -> {canon}")
                    merge_into(os.path.join(path, other), os.path.join(path, canon))
    for e in os.listdir(path):
        p = os.path.join(path, e)
        if os.path.isdir(p) and not os.path.islink(p):
            walk(p)


if __name__ == "__main__":
    root = sys.argv[1]
    walk(root)
    if APPLY:
        walk(root)  # segunda passada pega duplicatas expostas pelo merge
    print(("APLICADO" if APPLY else "DRY-RUN"), stats)
