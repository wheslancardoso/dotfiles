import re
from collections import Counter

doc_path = "/home/lan/dotfiles/templates-lab/docs/01-fundamentos-web-e-javascript-vanilla.md"
with open(doc_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

blocks = []
current_lang = None
current_content = []
for idx, line in enumerate(lines, 1):
    if line.startswith("```"):
        if current_lang is None:
            current_lang = line.strip()[3:].strip()
            current_content = []
        else:
            blocks.append((current_lang, idx, len(current_content), "".join(current_content)))
            current_lang = None
            current_content = []
    elif current_lang is not None:
        current_content.append(line)

counts = Counter(b[0] for b in blocks)
print("Code blocks distribution:")
for lang, count in counts.items():
    print(f"  {lang if lang else '<unspecified>'}: {count} blocks")
print(f"Total blocks: {len(blocks)}")
