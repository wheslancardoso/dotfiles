#!/bin/bash
# 🧹 Script de Faxina & Otimização do Sistema (Arch Linux)
# Remove pacotes órfãos, limpa caches velhos do pacman, enxuga logs do systemd e miniaturas.

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

clear
echo -e "${BOLD}${CYAN}============================================================${NC}"
echo -e "${BOLD}${CYAN}      🧹 FAXINA GERAL & OTIMIZAÇÃO DO SISTEMA ARCH 🚀      ${NC}"
echo -e "${BOLD}${CYAN}============================================================${NC}\n"

SPACE_BEFORE=$(df -h / | awk 'NR==2 {print $4}')
info "Espaço livre atual no disco raiz (/): ${BOLD}${SPACE_BEFORE}${NC}\n"

# 1. Remover pacotes órfãos (sem dependências)
info "1. Verificando pacotes órfãos no sistema..."
ORPHANS=$(pacman -Qtdq 2>/dev/null || true)
if [ -n "$ORPHANS" ]; then
    warn "Pacotes órfãos encontrados: $ORPHANS"
    sudo pacman -Rns --noconfirm $ORPHANS
    ok "Pacotes órfãos removidos."
else
    ok "Nenhum pacote órfão encontrado."
fi

# 2. Limpar cache do Pacman com paccache (mantém apenas as 2 versões mais recentes)
info "2. Limpando versões antigas de pacotes baixados (/var/cache/pacman/pkg)..."
if command -v paccache &>/dev/null; then
    sudo paccache -rk2 || true
    sudo paccache -ruk0 || true
    ok "Cache do pacman otimizado (mantidas 2 versões de segurança para rollback)."
else
    sudo pacman -Sc --noconfirm || true
    ok "Cache limpo via pacman -Sc."
fi

# 3. Limpar logs antigos do Systemd (mantém os últimos 7 dias)
info "3. Reduzindo logs do systemd para os últimos 7 dias..."
sudo journalctl --vacuum-time=7d || true
ok "Logs do journalctl enxugados."

# 4. Limpar cache de miniaturas (thumbnails) do usuário
info "4. Limpando cache de miniaturas (~/.cache/thumbnails)..."
rm -rf "$HOME/.cache/thumbnails"/* 2>/dev/null || true
ok "Cache de miniaturas limpo."

# 5. Limpar cache do Yay / Paru se existir
if [ -d "$HOME/.cache/yay" ]; then
    info "5. Limpando pacotes construídos antigos do Yay..."
    rm -rf "$HOME/.cache/yay"/* 2>/dev/null || true
    ok "Cache do yay limpo."
fi

SPACE_AFTER=$(df -h / | awk 'NR==2 {print $4}')
echo ""
echo -e "${BOLD}${GREEN}============================================================${NC}"
echo -e "${BOLD}${GREEN}          ✨ SISTEMA LIMPO, RÁPIDO E OTIMIZADO! ✨          ${NC}"
echo -e "${BOLD}${GREEN}============================================================${NC}"
echo -e "Espaço livre antes: ${YELLOW}$SPACE_BEFORE${NC} ➔ Espaço livre agora: ${GREEN}${BOLD}$SPACE_AFTER${NC}"
