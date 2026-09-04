#!/bin/bash
# 🧙‍♂️ Wizard Interativo: Ingressar Arch Linux no Active Directory (Windows Domain)
# Automatiza DNS, descoberta, realm join, ajuste do SSSD, criação automática de /home e sudo.

set -e

# --- Cores e Estilo ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

clear
echo -e "${BOLD}${CYAN}============================================================${NC}"
echo -e "${BOLD}${CYAN}   🏢 WIZARD DE INGRESSO NO DOMÍNIO ACTIVE DIRECTORY 🏢   ${NC}"
echo -e "${BOLD}${CYAN}============================================================${NC}"
echo -e "Este assistente vai conectar seu Arch Linux ao domínio Windows da empresa"
echo -e "e configurar login direto com seu usuário corporativo no SDDM e TTY.\n"

# 1. Verificar privilégios de sudo
if [ "$EUID" -eq 0 ]; then
    error "Não execute este script diretamente como root. Execute com seu usuário normal (o script pedirá sudo quando necessário)."
    exit 1
fi

sudo -v || { error "Permissão de sudo necessária para continuar."; exit 1; }

# 2. Verificar e instalar ferramentas necessárias
info "Verificando dependências de Active Directory..."
MISSING_PKGS=()
for pkg in realmd sssd krb5 adcli bind-tools; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    warn "Pacotes ausentes: ${MISSING_PKGS[*]}"
    info "Instalando dependências via pacman..."
    sudo pacman -S --needed --noconfirm "${MISSING_PKGS[@]}"
    ok "Dependências instaladas!"
fi

# 3. Perguntar o nome do Domínio
echo ""
echo -e "${BOLD}--- PASSO 1: Informações do Domínio ---${NC}"
read -rp "Digite o FQDN do Domínio (ex: empresa.local ou corp.suaempresa.com.br): " DOMAIN_NAME
if [ -z "$DOMAIN_NAME" ]; then
    error "O nome do domínio não pode ser vazio."
    exit 1
fi

# 4. Perguntar se precisa apontar o DNS para o DC
echo ""
echo -e "${BOLD}--- PASSO 2: Configuração de DNS ---${NC}"
echo "O Active Directory requer que o DNS da máquina resolva o controlador de domínio (DC)."
read -rp "Deseja configurar o IP do Servidor DNS / Domain Controller agora? (s/N): " CONFIG_DNS

if [[ "$CONFIG_DNS" =~ ^[sSyY]$ ]]; then
    read -rp "Digite o IP do Domain Controller / DNS (ex: 192.168.1.10): " DC_IP
    if [ -n "$DC_IP" ]; then
        if command -v nmcli &>/dev/null; then
            ACTIVE_CON=$(nmcli -t -f NAME,DEVICE connection show --active | head -n1 | cut -d: -f1)
            if [ -n "$ACTIVE_CON" ]; then
                info "Configurando DNS $DC_IP na conexão ativa '$ACTIVE_CON'..."
                sudo nmcli connection modify "$ACTIVE_CON" ipv4.dns "$DC_IP"
                sudo nmcli connection modify "$ACTIVE_CON" ipv4.dns-search "$DOMAIN_NAME"
                sudo nmcli connection up "$ACTIVE_CON"
                ok "DNS configurado via NetworkManager!"
            else
                warn "Nenhuma conexão ativa encontrada pelo nmcli. Adicionando ao /etc/resolv.conf..."
                echo -e "search $DOMAIN_NAME\nnameserver $DC_IP" | sudo tee /etc/resolv.conf > /dev/null
            fi
        else
            echo -e "search $DOMAIN_NAME\nnameserver $DC_IP" | sudo tee /etc/resolv.conf > /dev/null
        fi
    fi
fi

# 5. Teste de Descoberta do Domínio
echo ""
info "Testando comunicação com o domínio '$DOMAIN_NAME' via realm discover..."
if ! realm discover "$DOMAIN_NAME"; then
    echo ""
    error "Não foi possível localizar o domínio '$DOMAIN_NAME' na rede."
    echo -e "${YELLOW}Dicas de Solução de Problemas:${NC}"
    echo "1. Verifique se o IP do DNS aponta para o Windows Server."
    echo "2. Verifique se você está conectado na VPN da empresa ou na rede local/cabo."
    echo "3. Teste se 'ping $DOMAIN_NAME' responde com o IP do servidor."
    exit 1
fi

ok "Domínio localizado com sucesso!"

# 6. Sincronizar Relógio (Essencial para Kerberos)
info "Sincronizando relógio do sistema com NTP..."
sudo timedatectl set-ntp true || true

# 7. Ingressar no Domínio (realm join)
echo ""
echo -e "${BOLD}--- PASSO 3: Ingressar no Domínio (Join) ---${NC}"
read -rp "Digite o usuário com permissão de Join (Padrão: Administrator): " ADMIN_USER
ADMIN_USER=${ADMIN_USER:-Administrator}

info "Ingressando a máquina no domínio '$DOMAIN_NAME' usando '$ADMIN_USER'..."
echo -e "${CYAN}Digite a senha do usuário de rede quando solicitado pelo realm:${NC}"
if sudo realm join --user="$ADMIN_USER" "$DOMAIN_NAME"; then
    ok "Máquina ingressada no domínio com sucesso!"
else
    error "Falha ao ingressar no domínio. Verifique o usuário e a senha."
    exit 1
fi

# 8. Otimização do SSSD (/etc/sssd/sssd.conf)
echo ""
info "Otimizando /etc/sssd/sssd.conf para logins simplificados..."
if [ -f /etc/sssd/sssd.conf ]; then
    sudo cp /etc/sssd/sssd.conf /etc/sssd/sssd.conf.bak_$(date +%s)
    
    # use_fully_qualified_names = False (permite logar como 'joao' em vez de 'joao@dominio')
    if sudo grep -q "use_fully_qualified_names" /etc/sssd/sssd.conf; then
        sudo sed -i 's/use_fully_qualified_names.*/use_fully_qualified_names = False/' /etc/sssd/sssd.conf
    else
        sudo sed -i '/\[domain\/.*\]/a use_fully_qualified_names = False' /etc/sssd/sssd.conf
    fi

    # fallback_homedir = /home/%u (cria /home/joao limpo)
    if sudo grep -q "fallback_homedir" /etc/sssd/sssd.conf; then
        sudo sed -i 's|fallback_homedir.*|fallback_homedir = /home/%u|' /etc/sssd/sssd.conf
    else
        sudo sed -i '/\[domain\/.*\]/a fallback_homedir = /home/%u' /etc/sssd/sssd.conf
    fi

    sudo chmod 600 /etc/sssd/sssd.conf
    sudo systemctl restart sssd
    ok "SSSD configurado e reiniciado!"
fi

# 9. Configurar PAM para criação automática do /home (pam_mkhomedir)
echo ""
info "Configurando criação automática de pasta /home no primeiro login..."
if [ -f /etc/pam.d/system-auth ]; then
    if ! grep -q "pam_mkhomedir.so" /etc/pam.d/system-auth; then
        sudo cp /etc/pam.d/system-auth /etc/pam.d/system-auth.bak_$(date +%s)
        echo "session optional pam_mkhomedir.so skel=/etc/skel umask=077" | sudo tee -a /etc/pam.d/system-auth > /dev/null
        ok "Módulo pam_mkhomedir adicionado ao /etc/pam.d/system-auth!"
    else
        ok "Módulo pam_mkhomedir já configurado no PAM."
    fi
fi

# 10. Permissões de Sudo para Administradores do Domínio
echo ""
echo -e "${BOLD}--- PASSO 4: Permissões de Sudo Corporativo ---${NC}"
read -rp "Deseja conceder permissão de sudo para o grupo 'Domain Admins'? (S/n): " GRANT_SUDO

if [[ ! "$GRANT_SUDO" =~ ^[nN]$ ]]; then
    read -rp "Nome do grupo de administradores no AD (Padrão: Domain Admins): " AD_ADMIN_GROUP
    AD_ADMIN_GROUP=${AD_ADMIN_GROUP:-Domain Admins}
    
    sudo mkdir -p /etc/sudoers.d
    echo "%${AD_ADMIN_GROUP} ALL=(ALL:ALL) ALL" | sudo tee "/etc/sudoers.d/99-domain-admins" > /dev/null
    sudo chmod 440 "/etc/sudoers.d/99-domain-admins"
    ok "Permissão de sudo concedida para o grupo '%$AD_ADMIN_GROUP'!"
fi

# 11. Validação Final com Usuário do AD
echo ""
echo -e "${BOLD}--- PASSO 5: Teste de Validação ---${NC}"
read -rp "Digite o seu login do AD para testar a busca (ex: joao.silva): " TEST_USER

if [ -n "$TEST_USER" ]; then
    info "Consultando usuário '$TEST_USER' no Active Directory..."
    sleep 1
    if id "$TEST_USER" &>/dev/null; then
        echo ""
        ok "🎉 SUCESSO ABSOLUTO! Usuário encontrado no domínio:"
        id "$TEST_USER"
        echo ""
        echo -e "${GREEN}Você já pode fazer login na tela do SDDM ou no terminal com este usuário!${NC}"
    else
        warn "Usuário '$TEST_USER' não retornou no teste rápido com nome curto."
        info "Tentando com nome completo '${TEST_USER}@${DOMAIN_NAME}'..."
        if id "${TEST_USER}@${DOMAIN_NAME}" &>/dev/null; then
            ok "Usuário encontrado com FQDN: id ${TEST_USER}@${DOMAIN_NAME}"
        else
            warn "O SSSD pode levar alguns segundos para carregar o cache do AD, ou o nome digitado não existe."
            echo "Para forçar atualização de cache: sudo sssd -i &>/dev/null &"
        fi
    fi
fi

echo ""
echo -e "${BOLD}${GREEN}============================================================${NC}"
echo -e "${BOLD}${GREEN}       CONFIGURAÇÃO CONCLUÍDA COM SUCESSO! 🚀       ${NC}"
echo -e "${BOLD}${GREEN}============================================================${NC}"
echo -e "Agora você pode:"
echo -e "1. Bloquear a tela ou fazer logout e logar no SDDM com suas credenciais do AD."
echo -e "2. Testar troca rápida no terminal: ${CYAN}su - ${TEST_USER:-seu_usuario}${NC}"
echo -e "3. Gerenciar o domínio com: ${CYAN}realm list${NC}"
echo -e "4. Para sair do domínio no futuro: ${CYAN}sudo realm leave $DOMAIN_NAME${NC}"
