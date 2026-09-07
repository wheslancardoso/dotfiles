#!/usr/bin/env python3
"""
Cockpit Dev - Anki Deck & Package Builder
Gera o pacote nativo .apkg com árvore hierárquica automática de sub-baralhos
e atualiza o arquivo mestre ECOSSISTEMA_COMPLETO_MESTRE.txt com mapeamento de colunas.
"""

import os
import sys

try:
    import genanki
except ImportError:
    print("genanki não encontrado. Instale com: pip install genanki")
    sys.exit(1)

ANKI_DIR = os.path.dirname(os.path.abspath(__file__))

DECKS_INFO = [
    ("01_LazyVim_Zero_to_Hero.txt", "Cockpit Dev::01 - LazyVim", 2026090601),
    ("02_Hyprland_Mastery.txt", "Cockpit Dev::02 - Hyprland", 2026090602),
    ("03_Yazi_FileManager_Mastery.txt", "Cockpit Dev::03 - Yazi File Manager", 2026090603),
    ("04_Zellij_Multiplexer_Mastery.txt", "Cockpit Dev::04 - Zellij Multiplexer", 2026090604),
    ("05_Terminal_ModernCLI_Mastery.txt", "Cockpit Dev::05 - Terminal & Modern CLI", 2026090605),
    ("06_LazyGit_Git_Mastery.txt", "Cockpit Dev::06 - Git & LazyGit", 2026090606),
    ("07_Audio_Media_Workflow_Mastery.txt", "Cockpit Dev::07 - Audio & Media Workflow", 2026090607),
    ("08_Antigravity_AI_Mastery.txt", "Cockpit Dev::08 - Antigravity AI (agy)", 2026090608),
]

CSS = """
.card {
  font-family: 'JetBrainsMono Nerd Font', 'Fira Code', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: 16px;
  text-align: left;
  color: #cdd6f4;
  background-color: #1e1e2e;
  line-height: 1.6;
  padding: 24px;
  border-radius: 12px;
}
code {
  font-family: 'JetBrainsMono Nerd Font', 'Fira Code', monospace;
  background-color: #313244;
  color: #f38ba8;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 600;
}
b { color: #89b4fa; }
i { color: #a6adc8; }
hr {
  border: 0;
  height: 1px;
  background: #45475a;
  margin: 18px 0;
}
.deck-tag {
  font-size: 12px;
  color: #fab387;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-bottom: 12px;
}
"""

cockpit_model = genanki.Model(
    1847291038,
    'Cockpit Dev Card Model',
    fields=[
        {'name': 'Question'},
        {'name': 'Answer'},
        {'name': 'DeckTitle'},
    ],
    templates=[
        {
            'name': 'Cockpit Dev Card',
            'qfmt': '<div class="deck-tag">{{DeckTitle}}</div><div class="question">{{Question}}</div>',
            'afmt': '{{FrontSide}}<hr id="answer"><div class="answer">{{Answer}}</div>',
        },
    ],
    css=CSS
)

def build():
    genanki_decks = []
    master_txt_lines = [
        "#separator:tab",
        "#html:true",
        "#deck column:3",
        "#tags column:4",
        ""
    ]
    total_notes = 0

    for fname, deck_name, deck_id in DECKS_INFO:
        fpath = os.path.join(ANKI_DIR, fname)
        deck = genanki.Deck(deck_id, deck_name)
        genanki_decks.append(deck)

        with open(fpath, "r", encoding="utf-8") as f:
            lines = f.readlines()

        deck_notes = 0
        short_title = deck_name.replace("Cockpit Dev::", "")
        for line in lines:
            stripped = line.strip()
            if not stripped or stripped.startswith("#"):
                continue
            parts = stripped.split("\t")
            if len(parts) >= 2:
                q = parts[0]
                a = parts[1]
                tag = parts[2] if len(parts) > 2 else ""
                tags_list = [t.strip() for t in tag.split() if t.strip()] if tag else []

                note = genanki.Note(
                    model=cockpit_model,
                    fields=[q, a, short_title],
                    tags=tags_list
                )
                deck.add_note(note)
                deck_notes += 1
                master_txt_lines.append(f"{q}\t{a}\t{deck_name}\t{tag}")

        total_notes += deck_notes
        print(f"✔ {deck_name}: {deck_notes} flashcards")

    # Write Master APKG
    apkg_path = os.path.join(ANKI_DIR, "Cockpit_Dev_Ecossistema_Mestre.apkg")
    pkg = genanki.Package(genanki_decks)
    pkg.write_to_file(apkg_path)
    print(f"\n📦 Pacote APKG gerado com sucesso: {apkg_path}")

    # Write Master TXT
    master_txt_path = os.path.join(ANKI_DIR, "ECOSSISTEMA_COMPLETO_MESTRE.txt")
    with open(master_txt_path, "w", encoding="utf-8") as f:
        f.write("\n".join(master_txt_lines) + "\n")
    print(f"📄 Arquivo mestre TXT sincronizado: {master_txt_path}")
    print(f"🚀 Total: {total_notes} flashcards no ecossistema.")

if __name__ == "__main__":
    build()
