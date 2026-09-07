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

EE_DIR="$HOME/.local/share/easyeffects"
mkdir -p "$EE_DIR/output" "$EE_DIR/input" "$EE_DIR/irs" "$HOME/.config/easyeffects/autoload"

# 1. Copiar presets e IRSs empacotados nos dotfiles
DOTFILES_EE="$HOME/dotfiles/system/etc/easyeffects"
if [ -d "$DOTFILES_EE" ]; then
    echo -e "${BLUE}[INFO] Copiando presets e impulsos IRS dos dotfiles...${NC}"
    cp -rf "$DOTFILES_EE"/output/*.json "$EE_DIR/output/" 2>/dev/null || true
    cp -rf "$DOTFILES_EE"/irs/*.irs "$EE_DIR/irs/" 2>/dev/null || true
    cp -rf "$DOTFILES_EE"/input/*.json "$EE_DIR/input/" 2>/dev/null || true
fi

echo -e "${BLUE}[INFO] Garantindo presets de alta fidelidade e graves atualizados (JackHack96)...${NC}"

REPO_URL="https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master"

# Baixar IRS (Impulse Responses para Dolby Atmos e Surround)
for irs in "Dolby ATMOS ((128K MP3)) 1.Default.irs" "Razor surround.irs"; do
    if [ ! -f "$EE_DIR/irs/$irs" ]; then
        echo -e "  -> Baixando IRS: ${YELLOW}$irs${NC}"
        curl -fsSL "$REPO_URL/irs/$irs" -o "$EE_DIR/irs/$irs" 2>/dev/null || true
    fi
done

# Baixar Presets Principais
for preset in \
    "Bass Enhancing + Perfect EQ.json" \
    "Bass Boosted.json" \
    "Dolby Atmos.json" \
    "Advanced Auto Gain.json" \
    "Loudness+Autogain.json"; do
    if [ ! -f "$EE_DIR/output/$preset" ]; then
        echo -e "  -> Baixando Preset: ${GREEN}$preset${NC}"
        curl -fsSL "$REPO_URL/$preset" -o "$EE_DIR/output/$preset" 2>/dev/null || true
    fi
done

# Instalar preset de microfone de estúdio (RNNoise + EQ + Compressor + Limiter)
DOTFILES_MIC="$HOME/dotfiles/system/etc/easyeffects/input/Podcast_Studio_Mic.json"
if [ -f "$DOTFILES_MIC" ]; then
    cp -f "$DOTFILES_MIC" "$EE_DIR/input/Podcast_Studio_Mic.json"
    echo -e "  -> Instalando Preset de Microfone: ${GREEN}Podcast_Studio_Mic.json${NC}"
fi

echo -e "\n${GREEN}${BOLD}✔ Presets de Áudio, Graves e Microfone instalados com sucesso em ${EE_DIR}!${NC}\n"

# Ativa imediatamente os presets padrão de saída e microfone
if command -v easyeffects >/dev/null 2>&1; then
    echo -e "${GREEN}[*] Ativando 'Bass Multiplying + Perfect EQ' (Sub-Bass 808 Extremo) na saída...${NC}"
    timeout 3 easyeffects -l "Bass Multiplying + Perfect EQ" 2>/dev/null || true
    echo -e "${GREEN}[*] Ativando 'Podcast_Studio_Mic' no microfone...${NC}"
    timeout 3 easyeffects -l "Podcast_Studio_Mic" 2>/dev/null || true
fi

echo -e "${BOLD}Como usar no EasyEffects:${NC}"
echo -e "  - Preset Padrão Ativo: ${GREEN}Bass Multiplying + Perfect EQ${NC} (Sub-Bass 808 Pesado / Muito Grave)"
echo -e "  - Chavear via Terminal: digite ${BLUE}bass${NC} (808 extremo), ${BLUE}bass-light${NC} (moderado) ou ${BLUE}dolby${NC}"
echo -e "  - Chavear via Teclado: pressione ${YELLOW}SUPER + ALT + A${NC} para o menu Rofi"

if command -v notify-send >/dev/null 2>&1; then
    notify-send -u low -i audio-volume-high "EasyEffects Presets" "Preset Bass Multiplying (Sub-Bass 808 Pesado) ativado como padrão!" || true
fi
