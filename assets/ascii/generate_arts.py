import numpy as np
from PIL import Image, ImageFilter

# -------------------------------------------------------------
# 1. GERAR MICHELANGELO "THE CREATION OF ADAM" (NOKIA PIXEL ART)
# -------------------------------------------------------------
src = Image.open('/tmp/adam/adam_hands_focus.png')
w = 76
h = int(w * (src.height / src.width))
if h % 2 != 0: h += 1
gray = src.convert('L').resize((w, h), Image.LANCZOS)
arr = np.array(gray).astype(float)

bg_thresh = 208
cleaned = np.where(arr >= bg_thresh, 255.0, arr)
mask = cleaned < 255.0
cleaned[mask] = (cleaned[mask] / bg_thresh) ** 1.35 * 255.0
cleaned = np.clip(cleaned, 0, 255).astype(np.uint8)

img = Image.fromarray(cleaned).filter(ImageFilter.UnsharpMask(radius=1.2, percent=220, threshold=2))
dithered = img.convert('1', dither=Image.Dither.FLOYDSTEINBERG)
binary = np.array(dithered) == 0

filtered = np.copy(binary)
for y in range(h):
    for x in range(w):
        if binary[y, x]:
            y0, y1 = max(0, y-1), min(h, y+2)
            x0, x1 = max(0, x-1), min(w, x+2)
            if np.sum(binary[y0:y1, x0:x1]) - 1 < 2:
                filtered[y, x] = False

non_empty = [y for y in range(h) if np.any(filtered[y])]
min_y = max(0, min(non_empty) - 1)
max_y = min(h, max(non_empty) + 1)
if (max_y - min_y) % 2 != 0: max_y = min(h, max_y + 1)

# Paleta Nokia LCD
C_NOKIA = "\033[38;2;155;188;15m"   # #9bbc0f
C_MINT = "\033[38;2;166;227;161m"    # #a6e3a1 Catppuccin
C_DIM = "\033[38;2;88;110;45m"      # Dim green
C_RESET = "\033[0m"

# Arquivo 1: Michelangelo Nokia Style (Clean terminal background)
lines_adam = []
for y in range(min_y, max_y, 2):
    line = ["  "]
    for x in range(w):
        p1 = filtered[y, x]
        p2 = filtered[y+1, x] if y+1 < h else False
        if p1 and p2: line.append(f"{C_NOKIA}█{C_RESET}")
        elif p1 and not p2: line.append(f"{C_NOKIA}▀{C_RESET}")
        elif not p1 and p2: line.append(f"{C_NOKIA}▄{C_RESET}")
        else: line.append(" ")
    lines_adam.append(''.join(line))

# Adicionar sutil rodapé retro Nokia
pad = " " * ((w - 28) // 2)
lines_adam.append(f"{pad}{C_DIM}· · {C_NOKIA}THE CREATION OF ADAM{C_DIM} · ·{C_RESET}")

with open('/home/lanwsl/dotfiles/assets/ascii/creation-of-adam.txt', 'w') as f:
    f.write('\n'.join(lines_adam) + '\n')

# -------------------------------------------------------------
# 2. GERAR NOKIA 3310 CONNECTING PEOPLE (SPLASH ORIGINAL)
# -------------------------------------------------------------
lh = Image.open('/tmp/adam/nokia-left-hand.png')
rh = Image.open('/tmp/adam/nokia-right-hand.png')
combined = Image.new('RGBA', (84, 48), (0, 0, 0, 0))
combined.paste(lh, (0, 0), lh)
combined.paste(rh, (0, 0), rh)

lines_nokia = []
# Pegar as 18 primeiras linhas (36 pixels verticais) onde as mãos estão
for y in range(0, 36, 2):
    line = ["  "]
    for x in range(84):
        p1 = combined.getpixel((x, y))[3] > 128
        p2 = combined.getpixel((x, y+1))[3] > 128 if y+1 < 48 else False
        if p1 and p2: line.append(f"{C_NOKIA}█{C_RESET}")
        elif p1 and not p2: line.append(f"{C_NOKIA}▀{C_RESET}")
        elif not p1 and p2: line.append(f"{C_NOKIA}▄{C_RESET}")
        else: line.append(" ")
    lines_nokia.append(''.join(line))

pad_nokia = " " * ((84 - 24) // 2)
lines_nokia.append(f"{pad_nokia}{C_DIM}· · {C_NOKIA}CONNECTING PEOPLE{C_DIM} · ·{C_RESET}")

with open('/home/lanwsl/dotfiles/assets/ascii/nokia-connecting.txt', 'w') as f:
    f.write('\n'.join(lines_nokia) + '\n')

# -------------------------------------------------------------
# 3. GERAR VERSÃO COM TELA LCD RETRÔ (MOLDURA VERDE COMPLETA)
# -------------------------------------------------------------
# Fundo verde LCD #9BBC0F, pixels #0F380F
BG = "\033[48;2;155;188;15m"
FG = "\033[38;2;15;56;15m"
FG_BG = f"{FG}{BG}"
RESET = "\033[0m"

lines_lcd = []
border_top = f"  {BG}{FG}┌{'─' * (w + 2)}┐{RESET}"
border_bot = f"  {BG}{FG}└{'─' * (w + 2)}┘{RESET}"

lines_lcd.append(border_top)
for y in range(min_y, max_y, 2):
    line = [f"  {BG}{FG}│ "]
    for x in range(w):
        p1 = filtered[y, x]
        p2 = filtered[y+1, x] if y+1 < h else False
        if p1 and p2: line.append(f"{FG_BG}█{RESET}")
        elif p1 and not p2: line.append(f"{FG_BG}▀{RESET}")
        elif not p1 and p2: line.append(f"{FG_BG}▄{RESET}")
        else: line.append(f"{BG} {RESET}")
    line.append(f"{BG}{FG} │{RESET}")
    lines_lcd.append(''.join(line))

footer_text = " NOKIA 3310 · CREATION OF ADAM "
pad_left = (w + 2 - len(footer_text)) // 2
pad_right = (w + 2 - len(footer_text) - pad_left)
lines_lcd.append(f"  {BG}{FG}│{' ' * pad_left}{footer_text}{' ' * pad_right}│{RESET}")
lines_lcd.append(border_bot)

with open('/home/lanwsl/dotfiles/assets/ascii/creation-of-adam-lcd.txt', 'w') as f:
    f.write('\n'.join(lines_lcd) + '\n')

print("Arts generated successfully in /home/lanwsl/dotfiles/assets/ascii/!")
