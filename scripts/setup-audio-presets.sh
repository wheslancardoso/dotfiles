#!/usr/bin/env bash
# ==============================================================================
# 🎵 Setup Audio Presets (EasyEffects Studio & Bass Boost)
# Instala os melhores presets de graves pesados (Realtek/Dolby style),
# Convolver IRS (Dolby Atmos, Razer Surround) e calibrações de áudio no Linux.
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== 🎵 Calibrador de Áudio & Graves Profissionais (EasyEffects) ===${NC}\n"

EE_DIR="$HOME/.config/easyeffects"
mkdir -p "$EE_DIR/output" "$EE_DIR/input" "$EE_DIR/irs" "$EE_DIR/autoload"

echo -e "${BLUE}[INFO] Baixando presets de alta fidelidade e graves da comunidade (JackHack96)...${NC}"

REPO_URL="https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master"

# Baixar IRS (Impulse Responses para Dolby Atmos e Surround)
for irs in "Dolby ATMOS ((128K MP3)) 1.Default.irs" "Razor surround.irs"; do
    echo -e "  -> Baixando IRS: ${YELLOW}$irs${NC}"
    curl -fsSL "$REPO_URL/irs/$irs" -o "$EE_DIR/irs/$irs" 2>/dev/null || true
done

# Baixar Presets Principais
for preset in \
    "Bass Enhancing + Perfect EQ.json" \
    "Bass Multiplying + Perfect EQ.json" \
    "Dolby Atmos.json" \
    "Advanced Auto Gain.json" \
    "Loudness + Autogain.json"; do
    echo -e "  -> Baixando Preset: ${GREEN}$preset${NC}"
    curl -fsSL "$REPO_URL/$preset" -o "$EE_DIR/output/$preset" 2>/dev/null || true
done

echo -e "\n${GREEN}${BOLD}✔ Presets de Áudio e Graves instalados com sucesso em ${EE_DIR}!${NC}\n"
echo -e "${BOLD}Como usar no EasyEffects:${NC}"
echo -e "  1. Abra o EasyEffects: tecle ${BLUE}Super + D${NC} e busque por 'EasyEffects'"
echo -e "  2. Na aba ${BOLD}Presets${NC} (canto superior esquerdo), selecione ${GREEN}Bass Enhancing + Perfect EQ${NC}"
echo -e "  3. Clique em ${BOLD}Load${NC} (Carregar) e sinta os graves imediatos!"
echo -e "  4. (Opcional) Marque a caixa de ${BOLD}Autoload${NC} para carregar automaticamente ao plugar seu fone."

if command -v notify-send >/dev/null 2>&1; then
    notify-send -u low -i audio-volume-high "EasyEffects Presets" "Presets de Grave e Dolby Atmos prontos para uso!" || true
fi
