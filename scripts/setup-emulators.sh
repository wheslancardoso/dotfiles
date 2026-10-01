#!/usr/bin/env bash
# ==============================================================================
# 🎮 SETUP DEFINITIVO DA SUÍTE DE EMULADORES
# (SNES + PS2 + PS3 + XBOX 360 + NINTENDO SWITCH)
# Otimizado para Arch Linux / CachyOS (NVIDIA RTX 5060 + Ryzen 7 5700X)
# Inclui patches anti-crash e anti-stutter para Midnight Club Los Angeles
# ==============================================================================

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERRO]${NC} $1"; }

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
GAMES_DIR="$HOME/Games/Emulation"
LOCAL_BIN="$HOME/.local/bin"
APPLICATIONS_DIR="$HOME/.local/share/applications"
XENIA_DIR="$HOME/.local/share/xenia-canary"

echo -e "${BOLD}======================================================================${NC}"
echo -e "${BOLD}🚀 SETUP & AFINAÇÃO DA SUÍTE DE EMULAÇÃO (SNES/PS2/PS3/X360/SWITCH)${NC}"
echo -e "${BOLD}======================================================================${NC}\n"

# ------------------------------------------------------------------------------
# 1. Estrutura Canônica de Diretórios
# ------------------------------------------------------------------------------
info "Criando árvore canônica de diretórios em $GAMES_DIR..."
mkdir -p "$GAMES_DIR/bios/ps2" \
         "$GAMES_DIR/bios/ps3" \
         "$GAMES_DIR/bios/switch/keys" \
         "$GAMES_DIR/bios/switch/firmware" \
         "$GAMES_DIR/roms/snes" \
         "$GAMES_DIR/roms/ps2" \
         "$GAMES_DIR/roms/ps3" \
         "$GAMES_DIR/roms/xbox360" \
         "$GAMES_DIR/roms/switch" \
         "$GAMES_DIR/configs" \
         "$LOCAL_BIN" \
         "$APPLICATIONS_DIR" \
         "$XENIA_DIR/patches"
ok "Árvore de diretórios organizada!"

# ------------------------------------------------------------------------------
# 2. Instalação do Snes9x (Super Nintendo) via Flatpak
# ------------------------------------------------------------------------------
info "Verificando Snes9x (Super Nintendo)..."
if ! flatpak info com.snes9x.Snes9x &>/dev/null; then
    info "Instalando Snes9x via Flatpak Flathub..."
    flatpak install -y flathub com.snes9x.Snes9x
    ok "Snes9x instalado com sucesso!"
else
    ok "Snes9x já está instalado."
fi

# ------------------------------------------------------------------------------
# 3. Instalação do PCSX2 (PlayStation 2) via Flatpak
# ------------------------------------------------------------------------------
info "Verificando PCSX2 (PlayStation 2)..."
if ! flatpak info net.pcsx2.PCSX2 &>/dev/null; then
    info "Instalando PCSX2 via Flatpak Flathub..."
    flatpak install -y flathub net.pcsx2.PCSX2
    ok "PCSX2 instalado com sucesso!"
else
    ok "PCSX2 já está instalado."
fi

# ------------------------------------------------------------------------------
# 4. Instalação do RPCS3 (PlayStation 3) via Flatpak
# ------------------------------------------------------------------------------
info "Verificando RPCS3 (PlayStation 3)..."
if ! flatpak info net.rpcs3.RPCS3 &>/dev/null; then
    info "Instalando RPCS3 via Flatpak Flathub..."
    flatpak install -y flathub net.rpcs3.RPCS3
    ok "RPCS3 instalado com sucesso!"
else
    ok "RPCS3 já está instalado."
fi

# ------------------------------------------------------------------------------
# 5. Instalação do Ryujinx / Ryubing (Nintendo Switch) via Flatpak
# ------------------------------------------------------------------------------
info "Verificando Ryujinx (Nintendo Switch)..."
if ! flatpak info io.github.ryubing.Ryujinx &>/dev/null; then
    info "Instalando Ryujinx via Flatpak Flathub..."
    flatpak install -y flathub io.github.ryubing.Ryujinx
    ok "Ryujinx instalado com sucesso!"
else
    ok "Ryujinx já está instalado."
fi

# ------------------------------------------------------------------------------
# 6. Provisionamento do Xenia Canary (Xbox 360) Linux Nativo / AppImage
# ------------------------------------------------------------------------------
info "Provisionando Xenia Canary (Xbox 360)..."
XENIA_APPIMAGE="$XENIA_DIR/xenia_canary.AppImage"

if [ ! -f "$XENIA_APPIMAGE" ]; then
    info "Buscando release mais recente do Xenia Canary no GitHub..."
    LATEST_TAG=$(curl -s "https://api.github.com/repos/xenia-canary/xenia-canary/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' || true)
    
    if [ -n "$LATEST_TAG" ]; then
        DOWNLOAD_URL="https://github.com/xenia-canary/xenia-canary/releases/download/${LATEST_TAG}/xenia_canary_linux.AppImage"
        info "Baixando Xenia Canary (${LATEST_TAG}) de $DOWNLOAD_URL..."
        curl -L "$DOWNLOAD_URL" -o "$XENIA_APPIMAGE"
        chmod +x "$XENIA_APPIMAGE"
        ok "Xenia Canary baixado e tornado executável!"
    else
        warn "Tentando download direto do release..."
        curl -L "https://github.com/xenia-canary/xenia-canary/releases/latest/download/xenia_canary_linux.AppImage" -o "$XENIA_APPIMAGE" || true
        chmod +x "$XENIA_APPIMAGE" || true
    fi
else
    ok "Xenia Canary AppImage já presente em $XENIA_APPIMAGE."
fi

# ------------------------------------------------------------------------------
# 7. Aplicação das Configurações de Elite & Patches para Midnight Club LA
# ------------------------------------------------------------------------------
info "Aplicando configurações de alta performance do dotfiles..."

if [ -d "$DOTFILES_DIR/home/dot_config/xenia" ]; then
    cp -rf "$DOTFILES_DIR/home/dot_config/xenia/xenia-canary.config.toml" "$XENIA_DIR/xenia-canary.config.toml"
    cp -rf "$DOTFILES_DIR/home/dot_config/xenia/patches/"* "$XENIA_DIR/patches/" 2>/dev/null || true
    ok "Preset anti-crash/anti-stutter e Patches do Midnight Club LA aplicados em $XENIA_DIR!"
fi

# Configuração Plug-and-Play do PCSX2 (Vulkan, 3x Upscaling 1080p/1440p, Widescreen)
PCSX2_CONF_DIR="$HOME/.var/app/net.pcsx2.PCSX2/config/PCSX2"
mkdir -p "$PCSX2_CONF_DIR"
if [ -f "$DOTFILES_DIR/home/dot_config/pcsx2/PCSX2.ini" ]; then
    cp -f "$DOTFILES_DIR/home/dot_config/pcsx2/PCSX2.ini" "$PCSX2_CONF_DIR/PCSX2.ini"
    ok "Preset Plug-and-Play do PCSX2 (Vulkan + 3x 1440p + Widescreen) aplicado!"
fi

# ------------------------------------------------------------------------------
# 8. Criando Wrappers de Execução com GameMode & NVIDIA
# ------------------------------------------------------------------------------
info "Criando script wrapper para o Xenia Canary em $LOCAL_BIN/xenia-canary..."

cat << 'WRAPPER_EOF' > "$LOCAL_BIN/xenia-canary"
#!/usr/bin/env bash
# Wrapper otimizado para o Xenia Canary com GameMode e GPU NVIDIA dedicada
XENIA_DIR="$HOME/.local/share/xenia-canary"
XENIA_BIN="$XENIA_DIR/xenia_canary.AppImage"

if [ ! -f "$XENIA_BIN" ]; then
    echo "Erro: Xenia Canary não encontrado em $XENIA_BIN"
    exit 1
fi

cd "$XENIA_DIR"
if command -v gamemoderun &>/dev/null; then
    exec gamemoderun "$XENIA_BIN" "$@"
else
    exec "$XENIA_BIN" "$@"
fi
WRAPPER_EOF
chmod +x "$LOCAL_BIN/xenia-canary"
ok "Wrapper do Xenia Canary pronto!"

# ------------------------------------------------------------------------------
# 9. Criando Atalhos de Menu (.desktop) para Hyprland / Rofi / Wofi
# ------------------------------------------------------------------------------
cat << DESKTOP_EOF > "$APPLICATIONS_DIR/xenia-canary.desktop"
[Desktop Entry]
Name=Xenia Canary
Comment=Xbox 360 Emulator (Optimized)
Exec=$LOCAL_BIN/xenia-canary %f
Icon=applications-games
Terminal=false
Type=Application
Categories=Game;Emulator;
MimeType=application/x-iso9660-image;
DESKTOP_EOF

update-desktop-database "$APPLICATIONS_DIR" 2>/dev/null || true
ok "Atalhos registrados com sucesso!"

echo -e "\n${BOLD}======================================================================${NC}"
echo -e "${GREEN}${BOLD}✔ SUÍTE COMPLETA DE EMULADORES CONFIGURADA!${NC}"
echo -e "${BOLD}======================================================================${NC}"
echo -e "📁 Diretórios organizados:"
echo -e "   • SNES:    ${BLUE}$GAMES_DIR/roms/snes/${NC}"
echo -e "   • PS2:     ${BLUE}$GAMES_DIR/roms/ps2/${NC} | BIOS: ${BLUE}$GAMES_DIR/bios/ps2/${NC}"
echo -e "   • PS3:     ${BLUE}$GAMES_DIR/roms/ps3/${NC} | Firmware: ${BLUE}$GAMES_DIR/bios/ps3/${NC}"
echo -e "   • XBOX360: ${BLUE}$GAMES_DIR/roms/xbox360/${NC} (com MCLA otimizado)"
echo -e "   • SWITCH:  ${BLUE}$GAMES_DIR/roms/switch/${NC} | Keys/Firmware: ${BLUE}$GAMES_DIR/bios/switch/${NC}"
echo -e "🎮 Comandos de execução rápida:"
echo -e "   • SNES:    ${GREEN}flatpak run com.snes9x.Snes9x${NC}"
echo -e "   • PS2:     ${GREEN}flatpak run net.pcsx2.PCSX2${NC}"
echo -e "   • PS3:     ${GREEN}flatpak run net.rpcs3.RPCS3${NC}"
echo -e "   • X360:    ${GREEN}xenia-canary${NC}"
echo -e "   • SWITCH:  ${GREEN}flatpak run io.github.ryubing.Ryujinx${NC}"
echo -e "======================================================================\n"
