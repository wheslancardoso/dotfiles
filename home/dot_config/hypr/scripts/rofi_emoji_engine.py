#!/usr/bin/env python3
"""
🚀 APEX EMOJI ENGINE v3.0 (PT-BR + Estilo WhatsApp + Digitação Direta)
- Mais de 3.900 emojis oficiais com nomes e palavras-chave em Português do Brasil (CLDR)
- Gírias brasileiras (joinha, kkk, foguinho, sextou, pix, etc.)
- Busca semântica insensível a acentos (coracao == coração, cafe == café)
- Agrupamento por categorias com ícones estilo WhatsApp
- Memória local de Recentes / Mais Usados
- Digitação instantânea no app focado via wtype + cópia automática no clipboard
- Navegação por atalhos: Alt+1..9 para pular direto entre categorias
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

CATEGORIES = [
    ("TODOS", "🌐", "Todos os Emojis (Alt+1)", "Exibe a biblioteca completa com busca global"),
    ("RECENTES", "⭐", "Mais Usados / Recentes (Alt+2)", "Seus emojis favoritos e frequentes"),
    ("😀 Rostos & Emoções", "😀", "Rostos & Emoções (Alt+3)", "Sorrisos, sentimentos, palhaço, zumbis"),
    ("👋 Pessoas & Gestos", "👋", "Pessoas & Gestos (Alt+4)", "Mãos, joinha, palmas, profissões, famílias"),
    ("🐶 Animais & Natureza", "🐶", "Animais & Natureza (Alt+5)", "Bichos, plantas, flores, clima"),
    ("🍕 Comidas & Bebidas", "🍕", "Comidas & Bebidas (Alt+6)", "Pizza, café, cerveja, frutas, lanches"),
    ("✈️ Viagens & Lugares", "✈️", "Viagens & Lugares (Alt+7)", "Fogo, carros, aviões, prédios, mapa"),
    ("⚽ Atividades & Esportes", "⚽", "Atividades & Esportes (Alt+8)", "Futebol, jogos, academia, medalhas"),
    ("💡 Objetos", "💡", "Objetos (Alt+9)", "Celular, computador, ferramentas, dinheiro"),
    ("🔣 Símbolos", "🔣", "Símbolos (Alt+0)", "Corações, setas, signos, números"),
    ("🇧🇷 Bandeiras", "🇧🇷", "Bandeiras (Alt+-)", "Bandeira do Brasil e do mundo inteiro"),
]

HOTKEY_TO_CAT = {
    10: "TODOS",
    11: "RECENTES",
    12: "😀 Rostos & Emoções",
    13: "👋 Pessoas & Gestos",
    14: "🐶 Animais & Natureza",
    15: "🍕 Comidas & Bebidas",
    16: "✈️ Viagens & Lugares",
    17: "⚽ Atividades & Esportes",
    18: "💡 Objetos",
    19: "🔣 Símbolos",
    20: "🇧🇷 Bandeiras",
}

def load_database():
    if not DATABASE_FILE.exists():
        return []
    with open(DATABASE_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

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
    
    # Extrai 3 a 4 sinônimos principais legíveis (sem repetir o nome)
    kws = [k for k in item.get("keywords", []) if k.lower() not in name.lower()]
    synonyms = ", ".join(kws[:4]) if kws else ""
    syn_markup = f'<span color="#a6adc8">· {html.escape(synonyms)}</span>' if synonyms else ""
    
    group_name = item.get("group", "")
    recent_badge = '<span color="#f9e2af">⭐</span> ' if is_recent else ''
    
    # Termos de busca completos embutidos em span de tamanho zero para matching perfeito no Rofi
    search_terms = html.escape(item.get("search_text", ""))
    
    return (
        f'<span size="145%">{char}</span>   '
        f'{recent_badge}<b>{name}</b>   '
        f'{syn_markup}   '
        f'<span color="#6c7086"><i>({html.escape(group_name)})</i></span>  '
        f'<span size="0" alpha="0%">{search_terms}</span>'
    )

def main():
    database = load_database()
    if not database:
        print("Erro: Base de dados de emojis não encontrada.", file=sys.stderr)
        sys.exit(1)

    char_to_item = {item["char"]: item for item in database}
    current_category = "TODOS"

    # Argumento opcional de linha de comando
    if len(sys.argv) > 1:
        req_cat = sys.argv[1]
        for cat_id, _, _, _ in CATEGORIES:
            if req_cat.lower() in cat_id.lower():
                current_category = cat_id
                break

    while True:
        history = load_history()
        # Ordena recentes por mais frequente e recente
        sorted_recent_chars = sorted(
            history.keys(),
            key=lambda c: (history[c].get("count", 0), history[c].get("last", 0)),
            reverse=True
        )

        lines = []

        # Se estiver em uma categoria específica (não TODOS)
        if current_category != "TODOS":
            lines.append("⬅️   <b>[VOLTAR]  Mostrar Todas as Categorias (Busca Geral)</b>")
            
            if current_category == "RECENTES":
                for char in sorted_recent_chars:
                    if char in char_to_item:
                        lines.append(format_emoji_line(char_to_item[char], is_recent=True))
                if not sorted_recent_chars:
                    lines.append("<i>Nenhum emoji recente ainda. Use alguns emojis para aparecerem aqui!</i>")
            else:
                for item in database:
                    if item.get("group") == current_category:
                        lines.append(format_emoji_line(item))
        else:
            # Modo Global: Primeiro adiciona o menu de categorias estilo WhatsApp
            for cat_id, icon, label, desc in CATEGORIES:
                esc_label = html.escape(label.upper())
                esc_desc = html.escape(desc)
                lines.append(f"{icon}   <b>[{esc_label}]</b>   <span color=\"#a6adc8\">· {esc_desc}</span>")

            lines.append("──────────────────────────────────────────────────────────────────────────")

            # Em seguida, adiciona os Recentes no topo se houver
            recent_count = 0
            for char in sorted_recent_chars[:12]:
                if char in char_to_item:
                    lines.append(format_emoji_line(char_to_item[char], is_recent=True))
                    recent_count += 1

            if recent_count > 0:
                lines.append("──────────────────────────────────────────────────────────────────────────")

            # E então a base completa com todas as palavras-chave
            for item in database:
                lines.append(format_emoji_line(item))

        # Configura mensagem explicativa
        msg = "💡 <b>Dica:</b> Digite em português (ex: <i>joinha, fogo, cafe, coracao</i>)  |  <b>Alt+1..0</b> Categorias"
        if current_category != "TODOS":
            msg = f"📂 Categoria ativa: <b>{html.escape(current_category)}</b>  |  Selecione [VOLTAR] para busca geral"

        prompt = "󰞅 Emojis" if current_category == "TODOS" else f"󰞅 {current_category.split()[0]}"

        # Monta comando do Rofi
        rofi_cmd = [
            "rofi",
            "-dmenu",
            "-i",
            "-markup-rows",
            "-normalize-match",
            "-matching", "normal",
            "-tokenize",
            "-p", prompt,
            "-mesg", msg,
            "-kb-custom-11", "Alt+minus",
        ]

        if ROFI_CONFIG.exists():
            rofi_cmd.extend(["-config", str(ROFI_CONFIG)])

        input_data = "\n".join(lines)
        proc = subprocess.Popen(
            rofi_cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            text=True
        )
        stdout, _ = proc.communicate(input=input_data)
        return_code = proc.returncode

        # Usuário fechou o Rofi (ESC)
        if return_code == 1:
            sys.exit(0)

        # Tecla de atalho de categoria (Alt+1 .. Alt+0)
        if return_code in HOTKEY_TO_CAT:
            current_category = HOTKEY_TO_CAT[return_code]
            continue

        selected = stdout.strip()
        if not selected:
            sys.exit(0)

        # Se clicou em voltar
        if "[VOLTAR]" in selected:
            current_category = "TODOS"
            continue

        # Se clicou em uma linha de categoria
        is_cat_click = False
        for cat_id, icon, label, _ in CATEGORIES:
            if f"[{label.upper()}]" in selected:
                current_category = cat_id
                is_cat_click = True
                break
        if is_cat_click:
            continue

        # Linha decorativa ignorada
        if "───" in selected or "Nenhum emoji recente" in selected:
            continue

        # Extrai o emoji do span de tamanho 145%
        m = re.search(r'<span size="145%">([^<]+)</span>', selected)
        if m:
            emoji = m.group(1).strip()
        else:
            # Fallback: primeiro caractere/token
            emoji = selected.split()[0].strip()

        if not emoji:
            sys.exit(0)

        # Salva no histórico
        save_history(emoji)

        # Copia para a área de transferência do Wayland (wl-copy)
        try:
            subprocess.run(["wl-copy", emoji], check=True)
        except Exception as e:
            print(f"Aviso wl-copy: {e}", file=sys.stderr)

        # Digita diretamente no aplicativo em foco via wtype
        # Pequeno delay para garantir que o Rofi fechou e o foco voltou à janela ativa
        time.sleep(0.12)
        try:
            subprocess.run(["wtype", emoji], check=True)
        except Exception:
            pass

        sys.exit(0)

if __name__ == "__main__":
    main()
