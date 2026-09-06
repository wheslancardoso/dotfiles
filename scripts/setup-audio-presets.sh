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
# Instalar preset de microfone de estúdio (RNNoise + EQ + Compressor + Limiter)
DOTFILES_MIC="$HOME/dotfiles/system/etc/easyeffects/input/Podcast_Studio_Mic.json"
if [ -f "$DOTFILES_MIC" ]; then
    cp -f "$DOTFILES_MIC" "$EE_DIR/input/Podcast_Studio_Mic.json"
    echo -e "  -> Instalando Preset de Microfone: ${GREEN}Podcast_Studio_Mic.json${NC}"
fi

echo -e "\n${GREEN}${BOLD}✔ Presets de Áudio, Graves e Microfone instalados com sucesso em ${EE_DIR}!${NC}\n"

# Ativa imediatamente os presets padrão de saída e microfone
if command -v easyeffects >/dev/null 2>&1; then
    echo -e "${GREEN}[*] Ativando 'Bass Enhancing + Perfect EQ' na saída...${NC}"
    easyeffects -l "Bass Enhancing + Perfect EQ" 2>/dev/null || true
    echo -e "${GREEN}[*] Ativando 'Podcast_Studio_Mic' no microfone...${NC}"
    easyeffects -l "Podcast_Studio_Mic" 2>/dev/null || true
fi

echo -e "${BOLD}Como usar no EasyEffects:${NC}"
echo -e "  - Preset Padrão Ativo: ${GREEN}Bass Enhancing + Perfect EQ${NC} (Hip-Hop & Graves Nítidos)"
echo -e "  - Chavear via Terminal: digite ${BLUE}bass${NC} (Hip-Hop), ${BLUE}bass-max${NC} (808 extremo) ou ${BLUE}dolby${NC}"
echo -e "  - Chavear via Teclado: pressione ${YELLOW}SUPER + ALT + A${NC} para o menu Rofi"

if command -v notify-send >/dev/null 2>&1; then
    notify-send -u low -i audio-volume-high "EasyEffects Presets" "Preset Bass Enhancing (Hip-Hop Mode) ativado como padrão!" || true
fi
