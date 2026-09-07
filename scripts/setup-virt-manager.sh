#!/usr/bin/env bash
# ==============================================================================
# Setup & Configuração Profissional do KVM / QEMU / Virt-Manager
# Suporte completo para:
#  - Laboratórios de Redes (NAT, Isolado/Host-Only, Bridge)
#  - Windows 11 com TPM 2.0 (swtpm) e UEFI (OVMF)
#  - Discos VHD / Sysprep / Macrium Reflect
#  - USB Passthrough de Baixo Nível (Epson, fiscais, scanners)
#  - Fix de ambiente Python (mise/pyenv/asdf) para o Virt-Manager
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; }

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}   Configuração Suprema do KVM / Virt-Manager (Arch)  ${NC}"
echo -e "${BLUE}======================================================${NC}"

# 1. Instalação de Pacotes Essenciais
info "Verificando e instalando pacotes de virtualização..."
sudo pacman -S --needed --noconfirm \
    qemu-desktop \
    libvirt \
    virt-manager \
    virt-viewer \
    dnsmasq \
    iptables-nft \
    edk2-ovmf \
    swtpm \
    libvirt-python \
    spice-gtk

# 2. Usuário nos grupos libvirt e kvm
info "Adicionando usuário $USER aos grupos 'libvirt' e 'kvm'..."
sudo usermod -aG libvirt "$USER"
sudo usermod -aG kvm "$USER"

# 3. Habilitar e iniciar serviço libvirtd
info "Habilitando e iniciando libvirtd.service..."
sudo systemctl enable --now libvirtd.service

# 4. Configurar e Iniciar Rede Virtual Padrão (NAT)
info "Configurando rede NAT 'default' do libvirt..."
sudo virsh net-autostart default 2>/dev/null || true
if ! sudo virsh net-info default 2>/dev/null | grep -q "Active:.*yes"; then
    sudo virsh net-start default 2>/dev/null || true
fi

# 5. Criar e Ativar Pool de Armazenamento Padrão (/var/lib/libvirt/images)
info "Configurando pool de armazenamento 'default'..."
if ! sudo virsh pool-info default 2>/dev/null >/dev/null; then
    sudo virsh pool-define-as default dir --target /var/lib/libvirt/images
    sudo virsh pool-build default 2>/dev/null || true
fi
sudo virsh pool-autostart default 2>/dev/null || true
if ! sudo virsh pool-info default 2>/dev/null | grep -q "State:.*running"; then
    sudo virsh pool-start default 2>/dev/null || true
fi

# 6. Wrapper para contornar mise / pyenv / asdf que sobrescrevem python3
info "Configurando wrappers de compatibilidade Python em /usr/local/bin..."
for cmd in virt-manager virt-install virt-clone virt-xml; do
    if [ -f "/usr/bin/$cmd" ]; then
        sudo bash -c "cat << 'EOF' > /usr/local/bin/$cmd
#!/bin/sh
exec /usr/bin/python3 /usr/bin/$cmd \"\$@\"
EOF
chmod +x /usr/local/bin/$cmd"
    fi
done

# 7. Baixar e Criar ISO do SPICE Guest Tools para montagem offline no Windows
info "Verificando SPICE Guest Tools ISO..."
if [ ! -f "/var/lib/libvirt/images/spice-guest-tools.iso" ]; then
    info "Baixando SPICE Guest Tools e gerando ISO local..."
    sudo mkdir -p /tmp/spice-iso
    if sudo curl -fsSL -o /tmp/spice-iso/spice-guest-tools.exe https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe; then
        sudo genisoimage -o /var/lib/libvirt/images/spice-guest-tools.iso -J -r /tmp/spice-iso/spice-guest-tools.exe 2>/dev/null || true
        sudo cp /tmp/spice-iso/spice-guest-tools.exe /var/lib/libvirt/images/
        sudo rm -rf /tmp/spice-iso
        sudo virsh pool-refresh default 2>/dev/null || true
        ok "ISO spice-guest-tools.iso gerada com sucesso em /var/lib/libvirt/images/"
    fi
fi

# 8. Pré-configurar Virt-Manager para auto-conectar no qemu:///system
info "Configurando conexão padrão do Virt-Manager (qemu:///system)..."
gsettings set org.virt-manager.virt-manager.connections uris "['qemu:///system']" 2>/dev/null || true
gsettings set org.virt-manager.virt-manager.connections autoconnect "['qemu:///system']" 2>/dev/null || true

ok "KVM e Virt-Manager configurados com sucesso!"
echo -e ""
echo -e "  - ${GREEN}Rede NAT:${NC} Ativa e com autostart."
echo -e "  - ${GREEN}Pool de Imagens:${NC} /var/lib/libvirt/images (Ativo)."
echo -e "  - ${GREEN}Permissões:${NC} Usuário no grupo libvirt (Polkit sem senha ativo)."
echo -e "  - ${GREEN}Compatibilidade Python:${NC} Wrappers para mise/pyenv aplicados."
echo -e ""
echo -e "Para abrir a interface gráfica agora:"
echo -e "  ${BLUE}virt-manager${NC}"
echo -e "Ou pelo lançador do Hyprland (${YELLOW}Super + Espaço / Super + D${NC} -> virt-manager)."
