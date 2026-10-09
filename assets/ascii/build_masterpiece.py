from PIL import Image, ImageEnhance, ImageFilter
import numpy as np

src = Image.open('/home/lanwsl/dotfiles/assets/both_hands_full.png')

# 78 colunas (cabe perfeitamente em 80 colunas sem quebrar linha)
cols = 78
rows = 20
gray = src.convert('L').resize((cols, rows), Image.LANCZOS)
enhancer = ImageEnhance.Contrast(gray)
contrasted = enhancer.enhance(1.45)
sharp = contrasted.filter(ImageFilter.UnsharpMask(radius=1.2, percent=160, threshold=1))

arr = np.array(sharp).astype(float)
bg_thresh = 196
hands_val = np.maximum(0.0, bg_thresh - arr)
p98 = np.percentile(hands_val[hands_val > 0], 98)
norm = np.clip(hands_val / p98, 0.0, 1.0)

RAMP = " .':;~+=-*#%@█"

# 1. PALETA NOKIA 3310 RETRO GREEN
C_NOKIA_DARK = "\033[38;2;48;98;48m"       # Sombra
C_NOKIA_MID = "\033[38;2;139;172;15m"      # Meio tom
C_NOKIA_LIGHT = "\033[38;2;199;244;100m"   # Realce / Luz
C_RESET = "\033[0m"

lines_nokia = []
for y in range(rows):
    line = []
    for x in range(cols):
        v = norm[y, x]
        if v < 0.05:
            line.append(" ")
        else:
            idx = int(v * (len(RAMP) - 1))
            ch = RAMP[idx]
            if v > 0.65:
                line.append(f"{C_NOKIA_LIGHT}{ch}{C_RESET}")
            elif v > 0.35:
                line.append(f"{C_NOKIA_MID}{ch}{C_RESET}")
            else:
                line.append(f"{C_NOKIA_DARK}{ch}{C_RESET}")
    lines_nokia.append(''.join(line))

pad = " " * ((cols - 28) // 2)
lines_nokia.append(f"{pad}{C_NOKIA_DARK}· · {C_NOKIA_MID}THE CREATION OF ADAM{C_NOKIA_DARK} · ·{C_RESET}")

with open('/home/lanwsl/dotfiles/assets/ascii/creation-of-adam.txt', 'w') as f:
    f.write('\n'.join(lines_nokia) + '\n')

# 2. PALETA CATPPUCCIN MINT / CYAN
C_CAT_DARK = "\033[38;2;76;125;110m"
C_CAT_MID = "\033[38;2;148;226;213m"
C_CAT_LIGHT = "\033[38;2;166;227;161m"

lines_mint = []
for y in range(rows):
    line = []
    for x in range(cols):
        v = norm[y, x]
        if v < 0.05:
            line.append(" ")
        else:
            idx = int(v * (len(RAMP) - 1))
            ch = RAMP[idx]
            if v > 0.65:
                line.append(f"{C_CAT_LIGHT}{ch}{C_RESET}")
            elif v > 0.35:
                line.append(f"{C_CAT_MID}{ch}{C_RESET}")
            else:
                line.append(f"{C_CAT_DARK}{ch}{C_RESET}")
    lines_mint.append(''.join(line))
lines_mint.append(f"{pad}{C_CAT_DARK}· · {C_CAT_MID}THE CREATION OF ADAM{C_CAT_DARK} · ·{C_RESET}")

with open('/home/lanwsl/dotfiles/assets/ascii/creation-of-adam-mint.txt', 'w') as f:
    f.write('\n'.join(lines_mint) + '\n')

# 3. PALETA MONOCROMÁTICA CLÁSSICA (WHITE / GRAY ANSI)
C_MONO_DARK = "\033[38;2;100;100;100m"
C_MONO_MID = "\033[38;2;180;180;180m"
C_MONO_LIGHT = "\033[38;2;245;245;245m"

lines_mono = []
for y in range(rows):
    line = []
    for x in range(cols):
        v = norm[y, x]
        if v < 0.05:
            line.append(" ")
        else:
            idx = int(v * (len(RAMP) - 1))
            ch = RAMP[idx]
            if v > 0.65:
                line.append(f"{C_MONO_LIGHT}{ch}{C_RESET}")
            elif v > 0.35:
                line.append(f"{C_MONO_MID}{ch}{C_RESET}")
            else:
                line.append(f"{C_MONO_DARK}{ch}{C_RESET}")
    lines_mono.append(''.join(line))
lines_mono.append(f"{pad}{C_MONO_DARK}· · {C_MONO_MID}THE CREATION OF ADAM{C_MONO_DARK} · ·{C_RESET}")

with open('/home/lanwsl/dotfiles/assets/ascii/creation-of-adam-mono.txt', 'w') as f:
    f.write('\n'.join(lines_mono) + '\n')

print("All master arts generated successfully!")
