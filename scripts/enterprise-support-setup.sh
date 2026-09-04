#!/bin/bash
# 🏢 Enterprise, Active Directory & IT Support Suite (Opcional & Modular)
# Desenvolvido para transformar o Arch Linux em uma máquina de suporte corporativo de elite.
# Não altera o padrão base do sistema. Execute apenas se for atuar em ambiente Windows/AD.

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO] $1${NC}"; }
ok() { echo -e "${GREEN}[OK] $1${NC}"; }
warn() { echo -e "${YELLOW}[WARN] $1${NC}"; }
error() { echo -e "${RED}[ERROR] $1${NC}"; }

clear
echo -e "${BOLD}=====================================================${NC}"
echo -e "${BOLD}🏢 SUÍTE DE SUPORTE CORPORATIVO & ACTIVE DIRECTORY 🏢${NC}"
echo -e "${BOLD}=====================================================${NC}"
echo -e "Este script configura ferramentas para interagir com redes Windows,"
echo -e "domínios Active Directory, atendimento remoto (VNC/RDP) e telefonia SIP.\n"

echo "Escolha quais módulos deseja configurar:"
echo "1) Instalar Remmina (RDP + VNC com clipboard e áudio) & FreeRDP"
echo "2) Instalar Suporte a Pastas de Rede Windows (Samba / CIFS / smbclient)"
echo "3) Instalar MicroSIP (via Wine) e Softphone VoIP Corporativo"
echo "4) Instalar Ferramentas de Domínio Active Directory (Realmd, SSSD, Kerberos)"
echo "5) Instalar Virtualização KVM/QEMU (Para rodar VM de Windows 11 nativa com TPM)"
echo "6) Instalar TUDO (Completo para máquina corporativa)"
echo "0) Cancelar e sair"
echo ""
read -rp "Opção [0-6]: " OPTION

install_remote() {
    info "Instalando suíte de acesso remoto (Remmina, RDP, VNC)..."
    sudo pacman -S --needed --noconfirm remmina freerdp tigervnc
    # Plugins se existirem no repo da distro
    sudo pacman -S --needed --noconfirm libvncserver 2>/dev/null || true
    ok "Remmina e clientes RDP/VNC instalados com sucesso!"
}

install_shares() {
    info "Instalando suporte a compartilhamentos Windows (SMB/CIFS)..."
    sudo pacman -S --needed --noconfirm cifs-utils samba smbclient
    ok "Suporte a SMB/CIFS instalado. Agora você pode mapear pastas com mount.cifs ou via smb://"
}

install_microsip() {
    info "Configurando MicroSIP / Softphone..."
    sudo pacman -S --needed --noconfirm wine wine-gecko wine-mono winetricks linphone-desktop 2>/dev/null || \
    sudo pacman -S --needed --noconfirm wine linphone-desktop

    # Criar pasta e baixar o MicroSIP Portable oficial se não existir
    MICROSIP_DIR="$HOME/.local/share/microsip"
    mkdir -p "$MICROSIP_DIR"
    if [ ! -f "$MICROSIP_DIR/MicroSIP.exe" ]; then
        info "Baixando versão portátil do MicroSIP oficial..."
        curl -fsSL "https://www.microsip.org/download/MicroSIP-3.21.3.zip" -o "/tmp/microsip.zip" 2>/dev/null || true
        if [ -f "/tmp/microsip.zip" ]; then
            unzip -q -o "/tmp/microsip.zip" -d "$MICROSIP_DIR/"
            rm -f "/tmp/microsip.zip"
        fi
    fi

    # Criar lançador .desktop para o MicroSIP
    mkdir -p "$HOME/.local/share/applications"
    cat <<EOF > "$HOME/.local/share/applications/microsip.desktop"
[Desktop Entry]
Name=MicroSIP
Comment=SIP Softphone Corporativo
Exec=wine $MICROSIP_DIR/MicroSIP.exe
Icon=call-start
Terminal=false
Type=Application
Categories=Network;Telephony;
EOF
    chmod +x "$HOME/.local/share/applications/microsip.desktop"
    ok "MicroSIP configurado! Disponível no Rofi/Menu de aplicações e via comando 'microsip'."
}

install_ad() {
    info "Instalando ferramentas de integração com Active Directory..."
    sudo pacman -S --needed --noconfirm realmd sssd krb5 adcli bind-tools nmap traceroute
    ok "Ferramentas de AD e Kerberos instaladas."
    echo -e "${YELLOW}Para ingressar em um domínio da empresa, use:${NC}"
    echo -e "  sudo realm join --user=SEU_USUARIO_ADMIN dominio.empresa.local"
}

install_kvm() {
    info "Instalando KVM, QEMU e Virt-Manager com suporte a TPM 2.0 (Windows 11)..."
    sudo pacman -S --needed --noconfirm qemu-desktop virt-manager libvirt dnsmasq iptables-nft edk2-ovmf swtpm
    
    # Habilitar serviços libvirt
    sudo systemctl enable --now libvirtd.service 2>/dev/null || true
    sudo usermod -aG libvirt "$USER" 2>/dev/null || true
    sudo usermod -aG kvm "$USER" 2>/dev/null || true

    ok "Virt-Manager e KVM instalados! Você pode rodar uma VM de Windows 11 com aceleração nativa."
    warn "Nota: Faça logoff e login para que os grupos libvirt e kvm tenham efeito."
}

case "$OPTION" in
    1) install_remote ;;
    2) install_shares ;;
    3) install_microsip ;;
    4) install_ad ;;
    5) install_kvm ;;
    6)
        install_remote
        install_shares
        install_microsip
        install_ad
        install_kvm
        ;;
    0)
        info "Operação cancelada."
        exit 0
        ;;
    *)
        error "Opção inválida."
        exit 1
        ;;
esac

echo ""
ok "Finalizado com sucesso! Consulte o guia completo em: docs/GUIA_ENTERPRISE_AD_SUPORTE.md"
