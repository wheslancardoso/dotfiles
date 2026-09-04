#!/bin/bash
# 🔑 Blindagem Definitiva: Sudo NOPASSWD + GNOME Keyring no Hyprland / Arch
# Resolve permanentemente:
# 1. Elimina a necessidade de digitar senha para comandos sudo
# 2. Desbloqueia o GNOME Keyring automaticamente no login via PAM (SDDM / TTY)
# 3. Salva credenciais de Git, Navegadores, VS Code e Antigravity IDE sem perda de sessão
# 4. Configura o portal XDG (org.freedesktop.impl.portal.Secret)

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error(){ echo -e "${RED}[ERRO]${NC} $1"; }

clear
echo -e "${BOLD}${CYAN}============================================================${NC}"
echo -e "${BOLD}${CYAN}  🔑 BLINDAGEM: SUDO SEM SENHA & GNOME KEYRING HYPRLAND   ${NC}"
echo -e "${BOLD}${CYAN}============================================================${NC}"
echo -e "Este script configura o sistema para nunca mais pedir senha no sudo"
echo -e "e resolve de vez o problema de logins/sessões no Antigravity e navegadores.\n"

# 1. Pede senha de sudo uma única vez (se ainda precisar)
sudo -v || { error "Permissão de sudo necessária."; exit 1; }

# --- PARTE 1: SUDO NOPASSWD ---
info "Configurando sudo sem senha (NOPASSWD) para o usuário '$USER'..."
SUDOERS_FILE="/etc/sudoers.d/99-$USER-nopasswd"
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "$SUDOERS_FILE" > /dev/null
sudo chmod 440 "$SUDOERS_FILE"

if sudo visudo -cf "$SUDOERS_FILE" >/dev/null 2>&1; then
    ok "Sudo sem senha configurado e validado com visudo!"
else
    sudo rm -f "$SUDOERS_FILE"
    error "Falha na sintaxe do arquivo de sudoers. NOPASSWD cancelado por segurança."
fi

# --- PARTE 2: INSTALAÇÃO DE DEPENDÊNCIAS DO KEYRING ---
info "Verificando pacotes do GNOME Keyring, libsecret e seahorse..."
sudo pacman -S --needed --noconfirm gnome-keyring libsecret seahorse
ok "Pacotes do Keyring garantidos no sistema."

# --- PARTE 3: CONFIGURAÇÃO DO PAM (DESBLOQUEIO AUTOMÁTICO) ---
info "Configurando PAM para desbloquear o Keyring automaticamente com sua senha de login..."

# 3.1. SDDM
if [ -f /etc/pam.d/sddm ]; then
    if ! grep -q "pam_gnome_keyring.so" /etc/pam.d/sddm; then
        sudo cp /etc/pam.d/sddm /etc/pam.d/sddm.bak_$(date +%s)
        # Inserir auth, session e password
        sudo sed -i '/auth.*system-login/a auth optional pam_gnome_keyring.so' /etc/pam.d/sddm
        sudo sed -i '/session.*system-login/a session optional pam_gnome_keyring.so auto_start' /etc/pam.d/sddm
        sudo sed -i '/password.*system-login/a password optional pam_gnome_keyring.so' /etc/pam.d/sddm
        ok "PAM do SDDM atualizado com sucesso."
    else
        ok "PAM do SDDM já possui pam_gnome_keyring.so configurado."
    fi
else
    warn "Arquivo /etc/pam.d/sddm não encontrado (talvez use outro DM)."
fi

# 3.2. Login de Terminal (TTY)
if [ -f /etc/pam.d/login ]; then
    if ! grep -q "pam_gnome_keyring.so" /etc/pam.d/login; then
        sudo cp /etc/pam.d/login /etc/pam.d/login.bak_$(date +%s)
        sudo sed -i '/auth.*system-local-login/a auth optional pam_gnome_keyring.so' /etc/pam.d/login
        sudo sed -i '/session.*system-local-login/a session optional pam_gnome_keyring.so auto_start' /etc/pam.d/login
        sudo sed -i '/password.*system-local-login/a password optional pam_gnome_keyring.so' /etc/pam.d/login
        ok "PAM do Login TTY atualizado com sucesso."
    else
        ok "PAM do Login TTY já possui pam_gnome_keyring.so configurado."
    fi
fi

# --- PARTE 4: CONFIGURAÇÃO DO XDG DESKTOP PORTAL (SECRETS) ---
info "Configurando o portal XDG para rotear chamadas de Secret Service ao gnome-keyring..."
PORTAL_DIR="$HOME/.config/xdg-desktop-portal"
mkdir -p "$PORTAL_DIR"

for pfile in "$PORTAL_DIR/portals.conf" "$PORTAL_DIR/hyprland-portals.conf"; do
    if [ ! -f "$pfile" ]; then
        cat <<EOF > "$pfile"
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.FileChooser=termfilechooser
org.freedesktop.impl.portal.Secret=gnome-keyring
EOF
    else
        if ! grep -q "org.freedesktop.impl.portal.Secret" "$pfile"; then
            echo "org.freedesktop.impl.portal.Secret=gnome-keyring" >> "$pfile"
        fi
    fi
done
ok "Portais XDG configurados com sucesso."

# --- PARTE 5: VARIÁVEIS DE AMBIENTE SYSTEMD & HYPRLAND ---
info "Garantindo variáveis de ambiente do GNOME Keyring..."
mkdir -p "$HOME/.config/environment.d"
cat <<EOF > "$HOME/.config/environment.d/10-keyring.conf"
GNOME_KEYRING_CONTROL=\${XDG_RUNTIME_DIR}/keyring
SSH_AUTH_SOCK=\${XDG_RUNTIME_DIR}/keyring/ssh
EOF

# --- PARTE 6: INICIALIZAR CHAVEIRO PADRÃO 'login' ---
info "Inicializando diretório de chaveiros..."
mkdir -p "$HOME/.local/share/keyrings"
chmod 700 "$HOME/.local/share/keyrings"
if [ ! -f "$HOME/.local/share/keyrings/default" ]; then
    echo "login" > "$HOME/.local/share/keyrings/default"
    ok "Chaveiro padrão 'login' configurado."
fi

# --- PARTE 7: FLAGS PARA CHROME, VS CODE E ANTIGRAVITY IDE ---
info "Configurando flags para que IDEs Electron e navegadores usem libsecret..."
mkdir -p "$HOME/.config"
for flag_file in electron-flags.conf chrome-flags.conf chromium-flags.conf code-flags.conf; do
    if [ ! -f "$HOME/.config/$flag_file" ] || ! grep -q "password-store" "$HOME/.config/$flag_file" 2>/dev/null; then
        echo "--password-store=gnome-libsecret" >> "$HOME/.config/$flag_file"
    fi
done
ok "Flags configuradas para aplicativos Electron e navegadores."

echo ""
echo -e "${BOLD}${GREEN}============================================================${NC}"
echo -e "${BOLD}${GREEN}        BLINDAGEM CONCLUÍDA COM SUCESSO! 🚀         ${NC}"
echo -e "${BOLD}${GREEN}============================================================${NC}"
echo -e "O que mudou:"
echo -e "1. ${GREEN}Sudo NOPASSWD:${NC} Comandos 'sudo' nunca mais pedirão senha."
echo -e "2. ${GREEN}Keyring Automático:${NC} Ao logar no SDDM, suas chaves são abertas sem popups."
echo -e "3. ${GREEN}Antigravity & Browsers:${NC} Sessões, contas e histórico salvos permanentemente."
echo -e "4. ${GREEN}Gerenciador Visual:${NC} O utilitário ${CYAN}seahorse${NC} está instalado para você inspecionar suas chaves."
