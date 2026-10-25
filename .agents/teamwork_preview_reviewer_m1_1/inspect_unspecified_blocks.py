import re

doc_path = "/home/lan/dotfiles/templates-lab/docs/01-fundamentos-web-e-javascript-vanilla.md"
with open(doc_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

in_block = False
current_lang = ""
block_start = 0
for idx, line in enumerate(lines, 1):
    if line.startswith("```"):
        if not in_block:
            in_block = True
            current_lang = line.strip()[3:].strip()
            block_start = idx
            content = []
        else:
            in_block = False
            if not current_lang:
                print(f"Unspecified block at line {block_start} to {idx}:")
                print("".join(content[:6]))
                print("---")
    elif in_block:
        content.append(line)
