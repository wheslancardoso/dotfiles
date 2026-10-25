import re
from pathlib import Path

content = Path('/home/lan/dotfiles/templates-lab/docs/01-fundamentos-web-e-javascript-vanilla.md').read_text(encoding='utf-8')
js_blocks = re.findall(r'```(?:javascript|js)\n(.*?)```', content, re.DOTALL)

# Patterns for facade functions:
# e.g., function ... { return true; } with no other lines
# or method() { return 1; }
# or NotImplementedError / Error("TODO")

facade_candidates = []
for b_idx, block in enumerate(js_blocks):
    lines = block.splitlines()
    for l_idx, line in enumerate(lines):
        if 'NotImplemented' in line or 'implementar depois' in line:
            facade_candidates.append((b_idx, l_idx, line))

print('Facade candidates count:', len(facade_candidates))
for c in facade_candidates:
    print(c)
