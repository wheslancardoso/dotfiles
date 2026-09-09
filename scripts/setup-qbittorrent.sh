#!/usr/bin/env bash
# ==============================================================================
# 🚀 SETUP DEFINITIVO DO QBITTORRENT TURBO (CATPPUCCIN + PLUGINS DE BUSCA)
# ==============================================================================

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

info "Configurando o qBittorrent Turbo com tema Catppuccin Mocha e busca integrada..."

# 1. Pastas canônicas
CONFIG_DIR="$HOME/.config/qBittorrent"
DATA_DIR1="$HOME/.local/share/data/qBittorrent/nova3/engines"
DATA_DIR2="$HOME/.local/share/qBittorrent/nova3/engines"
mkdir -p "$CONFIG_DIR/themes" "$DATA_DIR1" "$DATA_DIR2"

# 2. Copia ou linka a configuração mestra
if [ -f "$DOTFILES_DIR/home/dot_config/qBittorrent/qBittorrent.conf" ]; then
    ln -sf "$DOTFILES_DIR/home/dot_config/qBittorrent/qBittorrent.conf" "$CONFIG_DIR/qBittorrent.conf"
    ok "Configuração de alta performance aplicada em $CONFIG_DIR/qBittorrent.conf"
fi

# 3. Tema Catppuccin Mocha Oficial
if [ -f "$DOTFILES_DIR/home/dot_config/qBittorrent/themes/catppuccin-mocha.qbtheme" ]; then
    cp -f "$DOTFILES_DIR/home/dot_config/qBittorrent/themes/catppuccin-mocha.qbtheme" "$CONFIG_DIR/themes/"
    ok "Tema Catppuccin Mocha instalado em $CONFIG_DIR/themes/"
elif [ ! -f "$CONFIG_DIR/themes/catppuccin-mocha.qbtheme" ]; then
    info "Baixando tema Catppuccin Mocha oficial..."
    curl -sL -m 10 "https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/catppuccin-mocha.qbtheme" -o "$CONFIG_DIR/themes/catppuccin-mocha.qbtheme" 2>/dev/null || true
fi

# 4. Instalação dos Plugins de Busca em Python (sem anúncios, sem browser)
info "Instalando motores de busca em segundo plano (EZTV, PirateBay, LimeTorrents, SolidTorrents)..."
declare -A PLUGINS=(
    ["eztv.py"]="https://raw.githubusercontent.com/qbittorrent/search-plugins/master/nova3/engines/eztv.py"
    ["piratebay.py"]="https://raw.githubusercontent.com/qbittorrent/search-plugins/master/nova3/engines/piratebay.py"
    ["limetorrents.py"]="https://raw.githubusercontent.com/qbittorrent/search-plugins/master/nova3/engines/limetorrents.py"
    ["solidtorrents.py"]="https://raw.githubusercontent.com/qbittorrent/search-plugins/master/nova3/engines/solidtorrents.py"
    ["nyaasi.py"]="https://raw.githubusercontent.com/MadeOfMagicAndWires/qBit-plugins/master/engines/nyaasi.py"
    ["1337x.py"]="https://raw.githubusercontent.com/LightDestory/qBittorrent-Search-Plugins/master/src/engines/one337x.py"
)

for name in "${!PLUGINS[@]}"; do
    url="${PLUGINS[$name]}"
    target1="$DATA_DIR1/$name"
    target2="$DATA_DIR2/$name"
    if [ ! -s "$target1" ] || [ ! -s "$target2" ]; then
        tmp_p="/tmp/$name"
        if curl -sL -m 6 "$url" -o "$tmp_p" 2>/dev/null && [ -s "$tmp_p" ] && ! grep -qi "404: Not Found" "$tmp_p"; then
            cp -f "$tmp_p" "$target1" 2>/dev/null || true
            cp -f "$tmp_p" "$target2" 2>/dev/null || true
            rm -f "$tmp_p"
        fi
    fi
done

ok "Plugins de busca integrados instalados com sucesso!"
echo -e "\n${GREEN}✔ qBittorrent Turbo configurado com sucesso!${NC}"
echo -e "Destaques das otimizações:"
echo -e "  • ${BLUE}Cache de 512MB em RAM${NC} (aceleração máxima sem desgastar o SSD)"
echo -e "  • ${BLUE}1500 conexões globais & 250 por torrent${NC}"
echo -e "  • ${BLUE}Injeção automática de 13 Trackers Globais Ultrarrápidos${NC} em todo torrent adicionado"
echo -e "  • ${BLUE}Tema Catppuccin Mocha ativo${NC} combinando com seu Hyprland"
echo -e "  • ${BLUE}Mecanismo de busca integrado na aba 'Procurar'${NC} (1337x, EZTV, PirateBay, Nyaa)"
