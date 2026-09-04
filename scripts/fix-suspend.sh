#!/usr/bin/env bash
# ==============================================================================
# 💤 Fix Suspend - Diagnóstico & Blindagem da Suspensão no Arch + Hyprland
# Evita que o computador acorde sozinho ou apresente telas pretas no wake.
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== 💤 Diagnóstico & Proteção de Suspensão (Zero Wakeup Espúrio) ===${NC}\n"

# 1. Verificar Dispositivos em /proc/acpi/wakeup
if [ -f /proc/acpi/wakeup ]; then
    echo -e "${BOLD}1. Gatilhos de Wakeup ACPI (/proc/acpi/wakeup):${NC}"
    printf "%-12s %-12s %-10s %s\n" "Dispositivo" "Status" "Sysfs Node" "Recomendação"
    echo "----------------------------------------------------------------------"
    
    while read -r line; do
        dev=$(echo "$line" | awk '{print $1}')
        status=$(echo "$line" | grep -o "*enabled\|*disabled" | tr -d '*' || echo "unknown")
        node=$(echo "$line" | awk '{print $4}' 2>/dev/null || echo "-")
        
        recom="OK"
        color="$GREEN"
        if [ "$status" = "enabled" ]; then
            if [[ "$dev" =~ GLAN|XHC|XHC0|GPP0|PEG0 ]]; then
                recom="⚠️ Fonte comum de wake espúrio!"
                color="$RED"
            else
                recom="Pode acordar o PC"
                color="$YELLOW"
            fi
        fi
        
        printf "%-12s ${color}%-12s${NC} %-10s %s\n" "$dev" "$status" "$node" "$recom"
    done < <(grep -v "^Device" /proc/acpi/wakeup 2>/dev/null || true)
    echo ""
fi

# 2. Verificar Configuração NVIDIA
echo -e "${BOLD}2. Blindagem de Memória de Vídeo NVIDIA (RTX / Wayland):${NC}"
if lspci 2>/dev/null | grep -i "nvidia" >/dev/null 2>&1; then
    if [ -f /etc/modprobe.d/nvidia-power-management.conf ] && grep -q "PreserveVideoMemoryAllocations=1" /etc/modprobe.d/nvidia-power-management.conf 2>/dev/null; then
        echo -e "  [${GREEN}OK${NC}] NVreg_PreserveVideoMemoryAllocations=1 configurado!"
    else
        echo -e "  [${YELLOW}AVISO${NC}] NVreg_PreserveVideoMemoryAllocations=1 não detectado em /etc/modprobe.d/."
    fi

    # Checa serviços systemd da NVIDIA
    for s in nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service; do
        if systemctl is-enabled "$s" >/dev/null 2>&1; then
            echo -e "  [${GREEN}OK${NC}] Serviço $s ativo."
        else
            echo -e "  [${YELLOW}AVISO${NC}] Serviço $s desativado."
        fi
    done
else
    echo -e "  [${GREEN}INFO${NC}] Nenhuma GPU NVIDIA dedicada encontrada ou executando em container."
fi
echo ""

# 3. Último Motivo de Wakeup Registrado pelo Kernel
echo -e "${BOLD}3. Último Log de Suspensão / Acordar do Sistema:${NC}"
if command -v journalctl &>/dev/null; then
    LAST_SLEEP=$(journalctl -u systemd-suspend.service -n 10 --no-pager 2>/dev/null || true)
    if [ -n "$LAST_SLEEP" ]; then
        echo "$LAST_SLEEP"
    else
        echo -e "  (Nenhum registro recente de systemd-suspend)"
    fi
fi
echo ""

# 4. Ações Rápidas
echo -e "${BOLD}Opções:${NC}"
echo "  1) Desativar gatilhos problemáticos de ACPI agora (GLAN, GPP0, XHC0)"
echo "  2) Testar suspensão limpa do computador (systemctl suspend)"
echo "  3) Sair"
printf "\nEscolha uma opção [1-3]: "
read -r opt || opt="3"

case "$opt" in
    1)
        echo -e "\n${BLUE}[INFO] Desativando gatilhos espúrios...${NC}"
        sudo /usr/local/bin/disable-spurious-acpi-wakeup.sh 2>/dev/null || sudo "$HOME/dotfiles/scripts/disable-spurious-acpi-wakeup.sh" 2>/dev/null || true
        echo -e "${GREEN}✔ Gatilhos desativados com sucesso!${NC}"
        ;;
    2)
        echo -e "\n${YELLOW}Suspendendo sistema em 2 segundos... Pressione teclado para acordar.${NC}"
        sleep 2
        systemctl suspend
        ;;
    *)
        echo -e "\nSaindo."
        ;;
esac
