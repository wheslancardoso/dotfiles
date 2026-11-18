#!/usr/bin/env bash
# ==============================================================================
# Helper Parametrizado de Integração Windows AD / SMB / Rede (Arch Linux)
# Sem segredos hardcoded: lê ~/.config/agr/ad-smb.env (ou --env-file) e
# armazena credenciais SMB em ~/.smbcredentials (chmod 600).
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
COMMON_SH="$DOTFILES_DIR/scripts/setup/common.sh"

if [ -f "$COMMON_SH" ]; then
    # shellcheck source=/dev/null
    source "$COMMON_SH"
else
    info() { printf "[INFO] %s\n" "$1"; }
    ok()   { printf "[OK] %s\n" "$1"; }
    warn() { printf "[WARN] %s\n" "$1"; }
    erro() { printf "[ERRO] %s\n" "$1"; exit 1; }
    has_cmd() { command -v "$1" >/dev/null 2>&1; }
fi

ENV_FILE="${AD_SMB_ENV_FILE:-$HOME/.config/agr/ad-smb.env}"
NON_INTERACTIVE="${NON_INTERACTIVE:-false}"
DO_JOIN_AD=false
DO_MOUNT_SMB=false

for arg in "$@"; do
    case "$arg" in
        --env-file=*) ENV_FILE="${arg#*=}" ;;
        --join-ad) DO_JOIN_AD=true ;;
        --mount-smb) DO_MOUNT_SMB=true ;;
        --non-interactive|-y|--yes) NON_INTERACTIVE=true ;;
        --help|-h)
            cat << 'EOF'
Uso: ./scripts/setup-ad-smb.sh [opções]
  --env-file=<path>   Arquivo de variáveis AD/SMB (padrão: ~/.config/agr/ad-smb.env)
  --join-ad           Configura DNS/NTP e executa join no Active Directory
  --mount-smb         Configura montagem SMB/CIFS via ~/.smbcredentials e /etc/fstab
  --non-interactive   Executa sem prompts interativos
  --help, -h          Mostra esta ajuda
EOF
            exit 0
            ;;
        *) warn "Argumento desconhecido ignorado: $arg" ;;
    esac
done

if [ -f "$ENV_FILE" ]; then
    info "Carregando parâmetros de $ENV_FILE..."
    # shellcheck source=/dev/null
    source "$ENV_FILE"
else
    info "Arquivo $ENV_FILE não encontrado (copie de scripts/setup/ad-smb.env.example se desejar parametrizar)."
fi

install_ad_smb_packages() {
    if ! has_cmd pacman; then
        warn "pacman não disponível; pulando instalação de pacotes AD/SMB."
        return 0
    fi
    local pkgs=(cifs-utils smbclient realmd sssd krb5 adcli bind-tools remmina freerdp)
    info "Instalando pacotes AD/SMB/RDP no Arch Linux..."
    sudo pacman -S --needed --noconfirm "${pkgs[@]}" || warn "Alguns pacotes AD/SMB falharam."
    ok "Pacotes AD/SMB instalados."
}

configure_dns_for_ad() {
    local domain="${AD_DOMAIN:-}"
    local dc_ip="${AD_DC_IP:-}"
    if [ -z "$domain" ] || [[ "$domain" == \<*\> ]] || [ -z "$dc_ip" ] || [[ "$dc_ip" == \<*\> ]]; then
        return 0
    fi
    if has_cmd nmcli; then
        local active_con
        active_con=$(nmcli -t -f NAME,DEVICE connection show --active | head -n1 | cut -d: -f1 || true)
        if [ -n "$active_con" ]; then
            info "Configurando DNS $dc_ip e search $domain na conexão '$active_con'..."
            sudo nmcli connection modify "$active_con" ipv4.dns "$dc_ip"
            sudo nmcli connection modify "$active_con" ipv4.dns-search "$domain"
            sudo nmcli connection up "$active_con" >/dev/null 2>&1 || true
            ok "DNS configurado via NetworkManager."
        fi
    fi
}

setup_ad_join() {
    if [ "$DO_JOIN_AD" = false ]; then
        return 0
    fi
    local domain="${AD_DOMAIN:-}"
    local admin_user="${AD_JOIN_USER:-Administrator}"

    if [ -z "$domain" ] || [[ "$domain" == \<*\> ]]; then
        if [ "$NON_INTERACTIVE" = true ]; then
            warn "AD_DOMAIN não definido em $ENV_FILE; pulando realm join em modo não-interativo."
            return 0
        fi
        if [ -f "$DOTFILES_DIR/scripts/join-domain.sh" ]; then
            bash "$DOTFILES_DIR/scripts/join-domain.sh"
            return 0
        fi
        erro "AD_DOMAIN não configurado."
    fi

    configure_dns_for_ad
    sudo timedatectl set-ntp true 2>/dev/null || true

    if realm list 2>/dev/null | grep -qi "$domain"; then
        ok "Máquina já ingressada no domínio $domain."
        return 0
    fi

    info "Testando descoberta do domínio $domain..."
    if ! realm discover "$domain"; then
        warn "Não foi possível descobrir o domínio $domain; verifique DNS/VPN."
        return 1
    fi

    if [ -n "${AD_JOIN_PASSWORD:-}" ]; then
        printf '%s\n' "$AD_JOIN_PASSWORD" | sudo realm join --user="$admin_user" "$domain"
    elif [ "$NON_INTERACTIVE" = true ]; then
        warn "AD_JOIN_PASSWORD não fornecida em modo não-interativo; execute 'sudo realm join --user=$admin_user $domain' manualmente."
        return 0
    else
        sudo realm join --user="$admin_user" "$domain"
    fi

    if [ -f /etc/sssd/sssd.conf ]; then
        sudo cp /etc/sssd/sssd.conf "/etc/sssd/sssd.conf.bak_$(date +%s)"
        sudo sed -i 's/use_fully_qualified_names.*/use_fully_qualified_names = False/' /etc/sssd/sssd.conf
        sudo sed -i 's|fallback_homedir.*|fallback_homedir = /home/%u|' /etc/sssd/sssd.conf
        sudo chmod 600 /etc/sssd/sssd.conf
        sudo systemctl enable --now sssd 2>/dev/null || sudo systemctl restart sssd 2>/dev/null || true
    fi
    ok "Integração AD configurada para $domain."
}

setup_smb_mount() {
    if [ "$DO_MOUNT_SMB" = false ]; then
        return 0
    fi
    local share="${SMB_SHARE:-}"
    local mount_point="${SMB_MOUNT_POINT:-$HOME/mnt/sistemas_ti}"
    local cred_file="${SMB_CREDENTIALS_FILE:-$HOME/.smbcredentials}"
    local smb_domain="${SMB_DOMAIN:-}"
    local smb_vers="${SMB_VERSION:-3.0}"

    if [ -z "$share" ] || [[ "$share" == \<*\> ]]; then
        warn "SMB_SHARE não configurado (ou ainda com placeholder). Pulando montagem SMB."
        return 0
    fi

    mkdir -p "$mount_point"

    if [ -n "${SMB_USERNAME:-}" ] && [ -n "${SMB_PASSWORD:-}" ]; then
        info "Gravando credenciais SMB em $cred_file (chmod 600)..."
        umask 077
        {
            printf 'username=%s\n' "$SMB_USERNAME"
            printf 'password=%s\n' "$SMB_PASSWORD"
            if [ -n "$smb_domain" ] && [[ "$smb_domain" != \<*\> ]]; then
                printf 'domain=%s\n' "$smb_domain"
            fi
        } > "$cred_file"
        chmod 600 "$cred_file"
    fi

    if [ ! -f "$cred_file" ]; then
        warn "Arquivo de credenciais $cred_file não encontrado; crie-o com username/password/domain (chmod 600) antes de montar."
        return 0
    fi

    local uid gid fstab_line
    uid=$(id -u)
    gid=$(id -g)
    fstab_line="$share $mount_point cifs credentials=$cred_file,uid=$uid,gid=$gid,vers=$smb_vers,nofail,_netdev,x-systemd.automount 0 0"

    if ! grep -Fq "$mount_point" /etc/fstab 2>/dev/null; then
        info "Registrando ponto de montagem SMB em /etc/fstab..."
        printf '%s\n' "$fstab_line" | sudo tee -a /etc/fstab >/dev/null
    else
        ok "Entrada SMB para $mount_point já existe em /etc/fstab."
    fi

    sudo systemctl daemon-reload 2>/dev/null || true
    sudo mount "$mount_point" 2>/dev/null || warn "Montagem imediata falhou (rede/VPN offline?); automount configurado."
    ok "Helper SMB configurado para $share -> $mount_point."
}

install_ad_smb_packages
setup_ad_join
setup_smb_mount
ok "Integração Windows AD / SMB finalizada."
