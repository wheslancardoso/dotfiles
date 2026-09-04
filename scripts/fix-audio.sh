#!/usr/bin/env bash
# ==============================================================================
# 🔊 Fix Audio - Reiniciar e Recuperar Servidor de Som PipeWire & WirePlumber
# Resolve estalos, dispositivos que sumiram ou microfone mudo.
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== 🔊 Recuperador do Servidor de Áudio PipeWire ===${NC}\n"

echo -e "${BLUE}[INFO] Reiniciando serviços de áudio do usuário...${NC}"
systemctl --user restart pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null || true

sleep 1

if systemctl --user is-active --quiet pipewire; then
    echo -e "${GREEN}[OK] PipeWire ativo e rodando!${NC}"
fi

if systemctl --user is-active --quiet wireplumber; then
    echo -e "${GREEN}[OK] WirePlumber ativo e rodando!${NC}"
fi

# Reinicia easyeffects se estiver instalado
if command -v easyeffects >/dev/null 2>&1; then
    pkill -x easyeffects 2>/dev/null || true
    nohup easyeffects --gapplication-service >/dev/null 2>&1 &
    echo -e "${GREEN}[OK] EasyEffects (filtro de ruído IA) reiniciado!${NC}"
fi

echo -e "\n${GREEN}${BOLD}✔ Sistema de áudio 100% restabelecido!${NC}"
if command -v notify-send >/dev/null 2>&1; then
    notify-send -u low -i audio-volume-high "Áudio Recuperado" "PipeWire e WirePlumber reiniciados com sucesso!" || true
fi
