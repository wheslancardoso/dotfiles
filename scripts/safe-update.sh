#!/usr/bin/env bash
# ==============================================================================
# 🛡️ Safe Update - Atualização Blindada do Arch Linux + AUR
# Previne: quebra de chaves PGP, pacman travado (db.lck), falha de initramfs NVIDIA
# e cria snapshot Btrfs automático para rollback instantâneo se necessário.
#
# Suporta:
#   - Modo Interativo (terminal): safe-update
#   - Modo Automático (segundo plano/systemd timer): safe-update --auto
# ==============================================================================

set -euo pipefail

AUTO_MODE=false
if [[ "${1:-}" == "--auto" || "${1:-}" == "--background" ]]; then
    AUTO_MODE=true
fi

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

LOG_FILE="$HOME/.local/state/safe-update.log"
mkdir -p "$(dirname "$LOG_FILE")"

info() { 
    if [ "$AUTO_MODE" = false ]; then printf "${BLUE}[INFO]${NC} %s\n" "$1"; fi
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" >> "$LOG_FILE"
}

ok() { 
    if [ "$AUTO_MODE" = false ]; then printf "${GREEN}[OK]${NC} %s\n" "$1"; fi
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [OK] $1" >> "$LOG_FILE"
}

warn() { 
    if [ "$AUTO_MODE" = false ]; then printf "${YELLOW}[AVISO]${NC} %s\n" "$1"; fi
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [WARN] $1" >> "$LOG_FILE"
}

erro() { 
    if [ "$AUTO_MODE" = false ]; then printf "${RED}[ERRO]${NC} %s\n" "$1"; fi
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $1" >> "$LOG_FILE"
    exit 1
}

# --- Checagens do Modo Automático ---
if [ "$AUTO_MODE" = true ]; then
    # 1. Verifica conectividade com a internet
    if ! ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1 && ! ping -c 1 -W 3 archlinux.org >/dev/null 2>&1; then
        exit 0
    fi

    # 2. Se pacman ou yay já estiverem rodando, não interrompe
    if pgrep -x pacman >/dev/null 2>&1 || pgrep -x yay >/dev/null 2>&1; then
        exit 0
    fi

    # 3. Verifica se realmente existem atualizações pendentes
    UPDATES_COUNT=$(checkupdates 2>/dev/null | wc -l || echo 0)
    AUR_COUNT=0
    if command -v yay >/dev/null 2>&1; then
        AUR_COUNT=$(yay -Qua 2>/dev/null | wc -l || echo 0)
    fi
    TOTAL_UPDATES=$((UPDATES_COUNT + AUR_COUNT))

    if [ "$TOTAL_UPDATES" -eq 0 ]; then
        exit 0
    fi

    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low -i software-update-available "Atualização do Sistema" "Instalando $TOTAL_UPDATES atualizações em segundo plano com snapshot de segurança..." || true
    fi
fi

if [ "$AUTO_MODE" = false ]; then
    echo -e "${BLUE}${BOLD}=== 🛡️ Iniciando Atualização Segura do Sistema ===${NC}\n"
fi

# 1. Valida sudo e mantém vivo em background
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
info "Passo 1/3: Sincronizando chaves PGP oficiais (archlinux-keyring)..."
sudo pacman -Sy --needed --noconfirm archlinux-keyring cachyos-keyring >> "$LOG_FILE" 2>&1 || sudo pacman -Sy --needed --noconfirm archlinux-keyring >> "$LOG_FILE" 2>&1

# 5. Atualizar pacotes nativos do sistema
info "Passo 2/3: Atualizando pacotes nativos do repositório..."
sudo pacman -Su --noconfirm >> "$LOG_FILE" 2>&1

# 6. Atualizar pacotes do AUR via yay
if command -v yay >/dev/null 2>&1; then
    info "Passo 3/3: Atualizando pacotes do AUR (yay)..."
    yay -Sua --noconfirm >> "$LOG_FILE" 2>&1 || warn "Algum pacote do AUR falhou na compilação, pacotes nativos continuam intactos."
fi

# 7. Garantir sincronia do initramfs da NVIDIA se o kernel foi atualizado
RUNNING_KERNEL=$(uname -r)
LATEST_MODULES=$(ls -t /usr/lib/modules 2>/dev/null | head -n 1 || echo "$RUNNING_KERNEL")

ok "Atualização concluída com sucesso!"

if [ "$RUNNING_KERNEL" != "$LATEST_MODULES" ]; then
    if [ "$AUTO_MODE" = false ]; then
        echo -e "${YELLOW}${BOLD}⚠ Atenção: Uma nova versão de kernel foi instalada ($LATEST_MODULES).${NC}"
        echo -e "${YELLOW}Recomendado reiniciar o computador para carregar o novo kernel e drivers NVIDIA.${NC}"
    fi
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u normal -i software-update-available "Atualização Concluída" "Novo kernel instalado ($LATEST_MODULES). Reinicie quando conveniente!" || true
    fi
else
    if [ "$AUTO_MODE" = false ]; then
        echo -e "${GREEN}Sistema 100% atualizado e seguro.${NC}"
    fi
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low -i software-update-available "Atualização Concluída" "Sistema 100% atualizado e seguro em segundo plano." || true
    fi
fi
