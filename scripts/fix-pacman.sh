#!/usr/bin/env bash
# ==============================================================================
# 🔓 Fix Pacman - Destravar e Reparar Banco de Dados do Pacman
# Remove db.lck residual e limpa pacotes corrompidos incompletos (.part).
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== 🔓 Reparador do Banco de Dados do Pacman ===${NC}\n"

# Verifica se o pacman está realmente rodando
if pgrep -x pacman >/dev/null 2>&1 || pgrep -x yay >/dev/null 2>&1; then
    echo -e "${YELLOW}[AVISO] O Pacman ou Yay está em execução agora:${NC}"
    ps -ef | grep -E "pacman|yay" | grep -v grep
    echo -e "\nDeseja forçar o encerramento do processo? [s/N]"
    read -r resp
    if [[ "$resp" =~ ^[Ss]$ ]]; then
        sudo killall -9 pacman yay 2>/dev/null || true
        sleep 1
    else
        echo "Operação cancelada."
        exit 0
    fi
fi

# Remove lock file
if [ -f /var/lib/pacman/db.lck ]; then
    echo -e "${BLUE}[INFO] Removendo /var/lib/pacman/db.lck...${NC}"
    sudo rm -f /var/lib/pacman/db.lck
    echo -e "${GREEN}✔ Lock do banco de dados removido!${NC}"
else
    echo -e "${GREEN}[OK] Nenhum lock db.lck encontrado.${NC}"
fi

# Remove downloads parciais corrompidos (.part)
echo -e "${BLUE}[INFO] Limpando downloads incompletos (.part) no cache...${NC}"
sudo rm -f /var/cache/pacman/pkg/*.part 2>/dev/null || true

# Testa conexão e sincronia
echo -e "${BLUE}[INFO] Testando sincronização de repositórios...${NC}"
sudo pacman -Sy

echo -e "\n${GREEN}${BOLD}✔ Pacman 100% destravado e pronto para uso!${NC}"
