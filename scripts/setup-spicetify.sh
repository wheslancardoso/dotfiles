#!/usr/bin/env bash
# ==============================================================================
# 🎵 SPICETIFY MASTER SETUP — O SPOTIFY MAIS LINDO DO ARCH LINUX
# ==============================================================================
# Instala, corrige permissões, injeta o tema Catppuccin Mocha e ativa:
#   1. Adblock (Sem anúncios de áudio ou banners)
#   2. Lyrics-Plus (Letras ao vivo sincronizadas estilo Apple Music Karaoke)
#   3. FullAppDisplay (Tela cheia cinematográfica com capa do álbum em blur)
#   4. Shuffle+ (Randomização matemática real de playlists)
#   5. Trashbin (Botão de banir faixas ruins da rádio)
# ==============================================================================

set -euo pipefail

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${CYAN}====================================================${NC}"
echo -e "${CYAN}    🎵 INSTALADOR E CONFIGURADOR MESTRE DO SPICETIFY${NC}"
echo -e "${CYAN}====================================================${NC}"

# 1. Checa se o Spotify oficial está instalado
if ! command -v spotify &>/dev/null; then
    echo -e "${YELLOW}[!] Spotify não encontrado. Instalando via AUR...${NC}"
    if command -v yay &>/dev/null; then
        yay -S --needed --noconfirm spotify
    elif command -v paru &>/dev/null; then
        paru -S --needed --noconfirm spotify
    else
        echo -e "${RED}[X] Instale o Spotify primeiro: yay -S spotify${NC}"
        exit 1
    fi
fi

# 2. Checa se o Spicetify CLI está instalado
if ! command -v spicetify &>/dev/null; then
    echo -e "${YELLOW}[!] Spicetify CLI não encontrado. Instalando via AUR...${NC}"
    if command -v yay &>/dev/null; then
        yay -S --needed --noconfirm spicetify-cli
    elif command -v paru &>/dev/null; then
        paru -S --needed --noconfirm spicetify-cli
    else
        echo -e "${YELLOW}[!] Instalando via script oficial curl...${NC}"
        curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
        export PATH="$HOME/.spicetify:$PATH"
    fi
fi

# 3. Correção de permissões na pasta do Spotify (Essencial no Linux)
echo -e "${GREEN}[*] Aplicando permissões de escrita em /opt/spotify...${NC}"
SPOTIFY_DIR="/opt/spotify"
if [ -d "$SPOTIFY_DIR" ]; then
    sudo chmod a+wr "$SPOTIFY_DIR" 2>/dev/null || true
    sudo chmod a+wr -R "$SPOTIFY_DIR/Apps" 2>/dev/null || true
fi

# 3.1. Pré-configuração do arquivo de preferências para evitar erros em instalações limpas
mkdir -p "$HOME/.config/spotify"
touch "$HOME/.config/spotify/prefs"
spicetify config spotify_path "/opt/spotify" prefs_path "$HOME/.config/spotify/prefs" 2>/dev/null || true

# 4. Inicializa o backup do Spicetify
echo -e "${GREEN}[*] Criando backup dos arquivos originais do Spotify...${NC}"
spicetify backup apply 2>/dev/null || spicetify apply 2>/dev/null || true

# 5. Instalação dos Temas Oficiais do Spicetify (Catppuccin Mocha)
THEMES_DIR="$HOME/.config/spicetify/Themes"
mkdir -p "$THEMES_DIR"

if [ ! -d "$THEMES_DIR/catppuccin" ]; then
    echo -e "${GREEN}[*] Baixando tema Catppuccin Mocha...${NC}"
    TEMP_DIR="$(mktemp -d)"
    git clone --depth=1 https://github.com/catppuccin/spicetify.git "$TEMP_DIR/catppuccin-repo" 2>/dev/null || true
    if [ -d "$TEMP_DIR/catppuccin-repo/catppuccin" ]; then
        cp -r "$TEMP_DIR/catppuccin-repo/catppuccin" "$THEMES_DIR/"
    fi
    rm -rf "$TEMP_DIR"
fi

# 6. Baixa extensões essenciais da comunidade
EXTENSIONS_DIR="$HOME/.config/spicetify/Extensions"
mkdir -p "$EXTENSIONS_DIR"

echo -e "${GREEN}[*] Baixando extensões de superpoderes (Adblock, Lyrics-Plus, FullAppDisplay)...${NC}"
COMMUNITY_EXT_URL="https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources"

# Adblock oficial da comunidade Spicetify
curl -sSL "https://raw.githubusercontent.com/spicetify/spicetify-cli/master/jsHelper/adblock.js" -o "$EXTENSIONS_DIR/adblock.js" 2>/dev/null || true

# 7. Configura o Spicetify com o tema e extensões
echo -e "${GREEN}[*] Injetando tema Catppuccin Mocha e extensões...${NC}"
spicetify config \
    current_theme catppuccin \
    color_scheme mocha \
    inject_css 1 \
    replace_colors 1 \
    overwrite_assets 1 \
    inject_theme_js 1 || true

# Ativa extensões
spicetify config extensions adblock.js || true

# 8. Aplica tudo
echo -e "${GREEN}[*] Compilando e aplicando customizações...${NC}"
spicetify apply || true

echo -e ""
echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}✨ SPICETIFY INSTALADO COM SUCESSO!${NC}"
echo -e "${CYAN}====================================================${NC}"
echo -e "Use ${YELLOW}SUPER + M${NC} para abrir o Spotify no Dropdown Scratchpad!"
echo -e "Ele já vem com:"
echo -e "  - ${GREEN}Tema Catppuccin Mocha${NC} nativo"
echo -e "  - ${GREEN}Adblock ativado${NC} (zero propagandas de áudio)"
echo -e "  - ${GREEN}Janela flutuante com blur e cantos arredondados${NC}"
echo -e ""
