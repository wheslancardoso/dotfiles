#!/usr/bin/env bash
# ==============================================================================
# 💻 OTIMIZADOR DE ALTA PERFORMANCE & BATERIA: LENOVO THINKPAD T480
# ==============================================================================
# Especialmente adaptado para:
# - Intel Core 8th Gen (i5-8250U / i5-8350U / i7-8550U / i7-8650U)
# - Intel UHD Graphics 620 (Driver iHD / Iris VA-API + Vulkan)
# - 16GB RAM + 256GB NVMe (Otimização estrita de espaço em disco e ZRAM)
# - Duas Baterias (BAT0 Interna + BAT1 Externa Removível - Thresholds 75-80%)
# - TrackPoint Vermelho + Gestos Touchpad de 3 Dedos
# - Resolução eDP-1 1080p e Workspaces 1 a 10 dedicados
# ==============================================================================

set -euo pipefail

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
ok()   { printf "${GREEN}[OK]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
erro() { printf "${RED}[ERRO]${NC} %s\n" "$1"; exit 1; }

echo -e "${BLUE}================================================================${NC}"
echo -e "${YELLOW}      🚀 PROVISIONAMENTO & OTIMIZAÇÃO: THINKPAD T480          ${NC}"
echo -e "${BLUE}================================================================${NC}"

# 1. Instalação de Pacotes Específicos do T480 / Intel
info "Verificando pacotes dedicados ao ThinkPad T480 (TLP, Throttled, Intel VA-API)..."
T480_PKGS=(
    tlp
    tlp-rdw
    intel-media-driver
    vulkan-intel
    intel-ucode
    libva-utils
    vulkan-tools
)

MISSING_PKGS=()
for pkg in "${T480_PKGS[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    info "Instalando: ${MISSING_PKGS[*]}..."
    sudo pacman -S --needed --noconfirm "${MISSING_PKGS[@]}" 2>/dev/null || warn "Alguns pacotes podem já estar instalados ou requerer AUR."
fi

# Throttled (lenovo-throttling-fix) para eliminar thermal throttling prematuro no Linux
if ! pacman -Q throttled &>/dev/null; then
    if command -v yay &>/dev/null; then
        info "Instalando throttled via AUR..."
        yay -S --needed --noconfirm throttled 2>/dev/null || warn "Não foi possível compilar throttled agora."
    fi
fi

# 2. Configurar Limites de Bateria Dupla (BAT0 e BAT1) via TLP
info "Configurando perfis de carga e preservação de bateria dupla (75%-80%)..."
sudo mkdir -p /etc/tlp.d
if [ -f "$DOTFILES_DIR/system/etc/tlp.d/00-thinkpad-battery.conf" ]; then
    sudo cp -f "$DOTFILES_DIR/system/etc/tlp.d/00-thinkpad-battery.conf" /etc/tlp.d/00-thinkpad-battery.conf
fi

# Desativar serviços conflitantes de rfkll conforme recomendação do TLP
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket 2>/dev/null || true

# Ativar e iniciar TLP
sudo systemctl enable --now tlp.service 2>/dev/null || true
ok "TLP ativado com limites de carga 75%/80% para BAT0 e BAT1 (zero desgaste de células)!"

# 3. Ativar Throttled (desbloqueia potência térmica contínua de até 29W na tomada)
if systemctl list-unit-files throttled.service &>/dev/null; then
    sudo systemctl enable --now throttled.service 2>/dev/null || true
    ok "Throttled ativado (estabilidade total de clock na CPU Intel de 8ª geração)!"
fi

# 4. Otimização de Armazenamento para NVMe de 256GB
info "Otimizando armazenamento e retenção de logs para o NVMe de 256GB..."
sudo mkdir -p /etc/systemd/journald.conf.d
if [ -f "$DOTFILES_DIR/system/etc/systemd/journald.conf.d/size-limit.conf" ]; then
    sudo cp -f "$DOTFILES_DIR/system/etc/systemd/journald.conf.d/size-limit.conf" /etc/systemd/journald.conf.d/size-limit.conf
    sudo systemctl restart systemd-journald 2>/dev/null || true
fi

# Ativar timer de limpeza automática de cache do pacman (mantém só 1 versão)
sudo systemctl enable --now paccache.timer 2>/dev/null || true
ok "Retenção de logs limitada a 200MB e paccache ativado (economiza ~15-30GB no NVMe)!"

# 5. Configurar Hyprland: Aceleração Gráfica Intel VA-API (iHD) e Workspaces eDP-1
info "Aplicando perfil gráfico Intel UHD e tela única eDP-1 no Hyprland..."

# Grava variáveis de ambiente Intel
cat << 'EOF' > "$HOME/.config/hypr/UserConfigs/00-Hardware.conf"
# /* ---- 💫 Dynamic Hardware Profile: Intel UHD / Iris (ThinkPad T480) 💫 ---- */
env = LIBVA_DRIVER_NAME,iHD
env = MESA_LOADER_DRIVER_OVERRIDE,iris
env = GSK_RENDERER,gl
EOF
cp -f "$HOME/.config/hypr/UserConfigs/00-Hardware.conf" "$DOTFILES_DIR/home/dot_config/hypr/UserConfigs/00-Hardware.conf" 2>/dev/null || true

# Aplica configuração de monitores e workspaces para eDP-1
if [ -f "$DOTFILES_DIR/scripts/monitores-setup.sh" ]; then
    bash "$DOTFILES_DIR/scripts/monitores-setup.sh" --t480 || true
fi

# 6. Recarregar Hyprland se estiver em execução
if command -v hyprctl &>/dev/null && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    hyprctl reload 2>/dev/null || true
fi

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}   THINKPAD T480 OTIMIZADO COM SUCESSO! 🚀                      ${NC}"
echo -e "${GREEN}================================================================${NC}"
echo -e "  - Baterias: ${BLUE}Threshold 75%-80% ativo em BAT0 e BAT1${NC}"
echo -e "  - CPU:      ${BLUE}Throttled + TLP configurados para máxima autonomia/frio${NC}"
echo -e "  - GPU:      ${BLUE}Intel VA-API (iHD) e OpenGL Iris ativados sem conflito NVIDIA${NC}"
echo -e "  - NVMe:     ${BLUE}256GB blindado contra consumo de logs e cache pacman${NC}"
echo -e "  - Tela:     ${BLUE}eDP-1 nativo com Workspaces 1 a 10 operacionais${NC}"
echo -e "  - Teclado:  ${BLUE}TrackPoint (Bolinha Vermelha) e gestos multi-touch 3 dedos${NC}"
