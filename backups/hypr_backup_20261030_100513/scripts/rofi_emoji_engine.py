#!/usr/bin/env python3
"""
⚡ APEX EMOJI ENGINE v4.0 (Vim & Category Sovereign Edition)
- Navegação 100% estilo Vim (Ctrl+j / Ctrl+k / Ctrl+d / Ctrl+u / Esc)
- Abas de Categorias Instantâneas com [Alt+1 .. Alt+0] (WhatsApp/Windows Style)
  * Alt+1: ⭐ Recentes
  * Alt+2: 😀 Rostos & Emoções
  * Alt+3: 👋 Pessoas & Gestos
  * Alt+4: 🐶 Animais & Natureza
  * Alt+5: 🍕 Comidas & Bebidas
  * Alt+6: ✈️ Viagens & Lugares
  * Alt+7: ⚽ Atividades & Esportes
  * Alt+8: 💡 Objetos
  * Alt+9: 🔣 Símbolos
  * Alt+0: 🇧🇷 Bandeiras
  * Alt+BackSpace: Limpar categoria (Ver todos)
- Atalho Yank (Ctrl+y): Copia direto pro Clipboard com notificação limpa
- Enter: Digitação Direta no App em foco (wtype) + Cópia (wl-copy)
- Busca Semântica em Português do Brasil com mais de 3.960 emojis
- Gírias BR completas (joinha, foguinho, kkk, pix, sextou, etc.)
- Zero DDD: formatação Pango 100% validada e ultra-rápida em RAM
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

CATEGORY_ACTIONS = {
    10: "#recentes ",
    11: "#rostos ",
    12: "#pessoas ",
    13: "#animais ",
    14: "#comidas ",
    15: "#lugares ",
    16: "#esportes ",
    17: "#objetos ",
    18: "#simbolos ",
    19: "#bandeiras ",
    21: "",  # Alt+BackSpace -> Limpar filtro
}

CATEGORY_HEADER = (
    '<span size="small">'
    '<b>[Alt+1]</b> ⭐Recentes '
    '<b>[Alt+2]</b> 😀Rostos '
    '<b>[Alt+3]</b> 👋Pessoas '
    '<b>[Alt+4]</b> 🐶Animais '
    '<b>[Alt+5]</b> 🍕Comidas '
    '<b>[Alt+6]</b> ✈️Lugares '
    '<b>[Alt+7]</b> ⚽Esportes '
    '<b>[Alt+8]</b> 💡Objetos '
    '<b>[Alt+9]</b> 🔣Símbolos '
    '<b>[Alt+0]</b> 🇧🇷Bandeiras'
    '</span>'
)

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
    synonyms = ", ".join(kws[:3]) if kws else ""
    syn_markup = f'<span alpha="70%">· {html.escape(synonyms)}</span>' if synonyms else ""
    
    group_name = item.get("group", "")
    tag = GROUP_TO_TAG.get(group_name, "objetos")
    
    if is_recent:
        badge = '<span color="#f9e2af">⭐ </span>'
        tag_markup = '<span alpha="85%"><i>#recentes</i></span>'
        search_tag = "recentes recente fav favorito "
    else:
        badge = ''
        tag_markup = f'<span alpha="85%"><i>#{tag}</i></span>'
        search_tag = f"#{tag} {tag} "
    
    search_terms = html.escape(search_tag + item.get("search_text", ""))
    
    # size="1" alpha="1%" mantém as palavras-chave 100% pesquisáveis sem Pango error e sem DDD
    return (
        f'<span size="150%">{char}</span>   '
        f'{badge}<b>{name}</b>   '
        f'{syn_markup}   '
        f'{tag_markup} '
        f'<span size="1" alpha="1%">{search_terms}</span>'
    )

def extract_emoji(selected_text):
    if not selected_text:
        return ""
    m = re.search(r'<span size="150%">([^<]+)</span>', selected_text)
    if m:
        return m.group(1).strip()
    return selected_text.split()[0].strip()

def notify(msg):
    try:
        subprocess.run(["notify-send", "-a", "Apex Emoji", "-i", "accessories-character-map", "Apex Emoji", msg], check=False)
    except Exception:
        pass

def main():
    database = load_database()
    if not database:
        print("Erro: Base de dados de emojis não encontrada.", file=sys.stderr)
        sys.exit(1)

    char_to_item = {item["char"]: item for item in database}
    history = load_history()

    sorted_recent_chars = sorted(
        history.keys(),
        key=lambda c: (history[c].get("count", 0), history[c].get("last", 0)),
        reverse=True
    )

    lines = []
    # 1. Recentes no topo
    for char in sorted_recent_chars[:15]:
        if char in char_to_item:
            lines.append(format_emoji_line(char_to_item[char], is_recent=True))

    # 2. Base completa de emojis
    for item in database:
        lines.append(format_emoji_line(item, is_recent=False))

    input_payload = "\n".join(lines)
    current_filter = ""

    # Captura a janela ativa ANTES de abrir o Rofi para restaurar o foco com precisão cirúrgica
    previous_window_address = None
    previous_window_class = ""
    try:
        active_info = json.loads(subprocess.check_output(["hyprctl", "activewindow", "-j"]))
        previous_window_address = active_info.get("address")
        previous_window_class = str(active_info.get("class", "")).lower()
    except Exception:
        pass

    while True:
        rofi_cmd = [
            "rofi",
            "-dmenu",
            "-i",
            "-markup-rows",
            "-normalize-match",
            "-matching", "normal",
            "-tokenize",
            "-mesg", CATEGORY_HEADER,
            "-config", str(ROFI_CONFIG),
        ]
        if current_filter:
            rofi_cmd.extend(["-filter", current_filter])

        result = subprocess.run(
            rofi_cmd,
            input=input_payload,
            text=True,
            capture_output=True,
        )

        # Trata troca de categoria via [Alt+1 .. Alt+0] ou [Alt+BackSpace]
        if result.returncode in CATEGORY_ACTIONS:
            target_filter = CATEGORY_ACTIONS[result.returncode]
            if current_filter == target_filter:
                current_filter = ""  # Toggle de volta pra todos
            else:
                current_filter = target_filter
            continue

        selected = result.stdout.strip()

        # Cancelado (Esc / Ctrl+[)
        if result.returncode == 1 or not selected:
            break

        emoji = extract_emoji(selected)
        if not emoji:
            break

        save_history(emoji)

        # Ctrl+y / custom-11: Apenas Yank (copia pro clipboard com notificação)
        if result.returncode == 20:
            subprocess.run(["wl-copy", emoji], check=True)
            notify(f"📋 Copiado para a área de transferência: {emoji}")
            break

        # Enter / returncode 0: Copia + Digita diretamente no aplicativo em foco
        if result.returncode == 0:
            # 1. Copia imediatamente para o clipboard
            subprocess.run(["wl-copy", emoji], check=True)

            # 2. Devolve o foco explicitamente para a janela anterior no Hyprland
            if previous_window_address:
                try:
                    subprocess.run(
                        ["hyprctl", "dispatch", "focuswindow", f"address:{previous_window_address}"],
                        check=False,
                        capture_output=True
                    )
                except Exception:
                    pass

            # 3. Dá tempo para o Rofi fechar e a janela de destino retomar o foco no Wayland
            time.sleep(0.12)

            # 4. Injeta o emoji via Paste Direto (evita o bug de truncamento de 16-bit do wtype em emojis U+1F000+)
            # Terminais recebem Ctrl+Shift+V; navegadores e apps GUI recebem Ctrl+V
            is_terminal = any(term in previous_window_class for term in ["kitty", "ghostty", "alacritty", "foot", "wezterm", "terminal"])
            
            try:
                if is_terminal:
                    # Em terminal: Ctrl + Shift + V
                    subprocess.run(["wtype", "-M", "ctrl", "-M", "shift", "-k", "v", "-m", "shift", "-m", "ctrl"], check=False)
                else:
                    # Em apps normais (Browsers, IDEs, Discord, etc.): Ctrl + V
                    subprocess.run(["wtype", "-M", "ctrl", "-k", "v", "-m", "ctrl"], check=False)
            except Exception:
                pass
            break

        break

if __name__ == "__main__":
    main()
