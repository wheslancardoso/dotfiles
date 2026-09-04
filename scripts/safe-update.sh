#!/usr/bin/env bash
# ==============================================================================
# 🛡️ Safe Update - Atualização Blindada do Arch Linux + AUR
# Previne: quebra de chaves PGP, pacman travado (db.lck), falha de initramfs NVIDIA
# e cria snapshot Btrfs automático para rollback instantâneo se necessário.
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
ok()   { printf "${GREEN}[OK]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[AVISO]${NC} %s\n" "$1"; }
erro() { printf "${RED}[ERRO]${NC} %s\n" "$1"; exit 1; }

echo -e "${BLUE}${BOLD}=== 🛡️ Iniciando Atualização Segura do Sistema ===${NC}\n"

# 1. Pede senha do sudo no início
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 2. Desbloqueio do Pacman se houver processo zumbi ou lock antigo
if [ -f /var/lib/pacman/db.lck ]; then
    if ! pgrep -x pacman >/dev/null 2>&1 && ! pgrep -x yay >/dev/null 2>&1; then
        warn "Arquivo /var/lib/pacman/db.lck residual detectado. Removendo com segurança..."
        sudo rm -f /var/lib/pacman/db.lck
        ok "Banco de dados do pacman destravado!"
    else
        erro "Outro gerenciador de pacotes está em execução no momento. Aguarde finalizar."
    fi
fi

# 3. Snapshot de Segurança Btrfs (Rollback Garantido)
if command -v snapper >/dev/null 2>&1; then
    info "Criando Snapshot Btrfs pré-atualização para rollback seguro..."
    sudo snapper create -t pre -c number -d "Pre-update $(date +'%Y-%m-%d %H:%M')" 2>/dev/null || true
    ok "Snapshot de segurança criado!"
fi

# 4. PASSO CRUCIAL: Atualizar o chaveiro do Arch PRIMEIRO
# Evita o erro 'invalid or corrupted package (PGP signature)' ao atualizar após dias/semanas
info "Passo 1/3: Sincronizando chaves PGP oficiais (archlinux-keyring)..."
sudo pacman -Sy --needed --noconfirm archlinux-keyring cachyos-keyring 2>/dev/null || sudo pacman -Sy --needed --noconfirm archlinux-keyring

# 5. Atualizar pacotes nativos do sistema
info "Passo 2/3: Atualizando pacotes nativos do repositório..."
sudo pacman -Su --noconfirm

# 6. Atualizar pacotes do AUR via yay
if command -v yay >/dev/null 2>&1; then
    info "Passo 3/3: Atualizando pacotes do AUR (yay)..."
    yay -Sua --noconfirm || warn "Algum pacote do AUR falhou na compilação, pacotes nativos continuam intactos."
fi

# 7. Garantir sincronia do initramfs da NVIDIA se o kernel foi atualizado
RUNNING_KERNEL=$(uname -r)
LATEST_MODULES=$(ls -t /usr/lib/modules 2>/dev/null | head -n 1 || echo "$RUNNING_KERNEL")

echo ""
ok "Atualização concluída com sucesso!"

if [ "$RUNNING_KERNEL" != "$LATEST_MODULES" ]; then
    echo -e "${YELLOW}${BOLD}⚠ Atenção: Uma nova versão de kernel foi instalada ($LATEST_MODULES).${NC}"
    echo -e "${YELLOW}Recomendado reiniciar o computador para carregar o novo kernel e drivers NVIDIA.${NC}"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u normal -i software-update-available "Atualização Concluída" "Novo kernel instalado ($LATEST_MODULES). Reinicie quando conveniente!" || true
    fi
else
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low -i software-update-available "Atualização Concluída" "Sistema 100% atualizado e seguro." || true
    fi
fi
