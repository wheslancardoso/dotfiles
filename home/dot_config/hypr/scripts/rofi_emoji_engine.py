#!/usr/bin/env python3
"""
⚡ APEX EMOJI ENGINE v3.5 (Vim Sovereign Edition)
- Navegação 100% estilo Vim (Ctrl+j / Ctrl+k / Ctrl+d / Ctrl+u / Esc)
- Atalho Yank (Ctrl+y) para apenas copiar pro Clipboard
- Enter para Digitação Direta no App em foco (wtype) + Cópia (wl-copy)
- Busca Semântica em Português do Brasil com mais de 3.960 emojis
- Gírias BR (joinha, foguinho, kkk, pix, sextou, etc.)
- Filtro Instantâneo por Categorias via hashtags (#comidas, #rostos, #pessoas, #animais, #lugares, #esportes, #objetos, #simbolos, #bandeiras, #recentes)
- Zero loops, zero flicker, execução atômica em 1 única sessão
"""

import html
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path

ROFI_CONFIG = Path.home() / ".config/rofi/config-emoji.rasi"
DATABASE_FILE = Path("/home/lan/dotfiles/home/dot_config/rofi/emoji_pt_br.json")
if not DATABASE_FILE.exists():
    DATABASE_FILE = Path.home() / ".config/rofi/emoji_pt_br.json"

HISTORY_FILE = Path.home() / ".local/share/rofi-emoji-history.json"

GROUP_TO_TAG = {
    "😀 Rostos & Emoções": "rostos",
    "👋 Pessoas & Gestos": "pessoas",
    "🐶 Animais & Natureza": "animais",
    "🍕 Comidas & Bebidas": "comidas",
    "✈️ Viagens & Lugares": "lugares",
    "⚽ Atividades & Esportes": "esportes",
    "💡 Objetos": "objetos",
    "🔣 Símbolos": "simbolos",
    "🇧🇷 Bandeiras": "bandeiras",
}

def load_database():
    if not DATABASE_FILE.exists():
        return []
    try:
        with open(DATABASE_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return []

def load_history():
    if not HISTORY_FILE.exists():
        return {}
    try:
        with open(HISTORY_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return {}

def save_history(char):
    HISTORY_FILE.parent.mkdir(parents=True, exist_ok=True)
    hist = load_history()
    entry = hist.get(char, {"count": 0, "last": 0})
    entry["count"] += 1
    entry["last"] = int(time.time())
    hist[char] = entry
    try:
        with open(HISTORY_FILE, "w", encoding="utf-8") as f:
            json.dump(hist, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

def format_emoji_line(item, is_recent=False):
    char = item["char"]
    name = html.escape(item["name"])
    
    # Extrai sinônimos limpos
    kws = [k for k in item.get("keywords", []) if k.lower() not in name.lower()]
    synonyms = ", ".join(kws[:4]) if kws else ""
    syn_markup = f'<span color="#a6adc8">· {html.escape(synonyms)}</span>' if synonyms else ""
    
    group_name = item.get("group", "")
    tag = GROUP_TO_TAG.get(group_name, "objetos")
    
    if is_recent:
        badge = '<span color="#f9e2af">⭐ [Recente]</span> '
        tag_markup = '<span color="#f9e2af"><i>#recentes</i></span>'
        search_tag = "recentes recente fav favorito "
    else:
        badge = ''
        tag_markup = f'<span color="#cba6f7"><i>#{tag}</i></span>'
        search_tag = f"#{tag} {tag} "
    
    search_terms = html.escape(search_tag + item.get("search_text", ""))
    
    return (
        f'<span size="155%">{char}</span>   '
        f'{badge}<b>{name}</b>   '
        f'{syn_markup}   '
        f'{tag_markup}  '
        f'<span size="0" alpha="0%">{search_terms}</span>'
    )

def main():
    database = load_database()
    if not database:
        print("Erro: Base de dados de emojis não encontrada.", file=sys.stderr)
        sys.exit(1)

    char_to_item = {item["char"]: item for item in database}
    history = load_history()

    # Ordena recentes por mais frequente e recente
    sorted_recent_chars = sorted(
        history.keys(),
        key=lambda c: (history[c].get("count", 0), history[c].get("last", 0)),
        reverse=True
    )

    lines = []

    # 1. Emojis Mais Usados e Frequentes no topo absoluto
    for char in sorted_recent_chars[:12]:
        if char in char_to_item:
            lines.append(format_emoji_line(char_to_item[char], is_recent=True))

    # 2. Toda a base de 3.962 emojis com busca semântica instantânea
    for item in database:
        lines.append(format_emoji_line(item, is_recent=False))

    # Executa o Rofi com navegação Vim nativa
    rofi_cmd = [
        "rofi",
        "-dmenu",
        "-i",
        "-markup-rows",
        "-normalize-match",
        "-matching", "normal",
        "-tokenize",
        "-config", str(ROFI_CONFIG),
    ]

    proc = subprocess.Popen(
        rofi_cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True
    )
    stdout, _ = proc.communicate(input="\n".join(lines))
    return_code = proc.returncode

    # Se o usuário cancelou (ESC ou Ctrl+[)
    if return_code not in (0, 10):
        sys.exit(0)

    selected = stdout.strip()
    if not selected:
        sys.exit(0)

    # Extrai o emoji do span formatado
    m = re.search(r'<span size="155%">([^<]+)</span>', selected)
    if m:
        emoji = m.group(1).strip()
    else:
        emoji = selected.split()[0].strip()

    if not emoji:
        sys.exit(0)

    # Salva no histórico de favoritos
    save_history(emoji)

    # Copia sempre para o Clipboard do Wayland
    try:
        subprocess.run(["wl-copy", emoji], check=True)
    except Exception:
        pass

    # Se apertou ENTER (return_code 0): Auto-Type direto no app ativo
    # Se apertou Ctrl+y (return_code 10): Apenas Yank (copiou pro clipboard)
    if return_code == 0:
        time.sleep(0.12)
        try:
            subprocess.run(["wtype", emoji], check=True)
        except Exception:
            pass

    sys.exit(0)

if __name__ == "__main__":
    main()
