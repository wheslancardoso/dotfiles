#!/bin/bash
# Utilitários compartilhados para os módulos de setup

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
ok()   { printf "${GREEN}[OK]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
erro() { printf "${RED}[ERRO]${NC} %s\n" "$1"; exit 1; }

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

has_systemd() {
    [ -d /run/systemd/system ] && has_cmd systemctl
}
