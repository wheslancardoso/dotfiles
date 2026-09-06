#!/usr/bin/env bash
# ==============================================================================
# ☁️ GOOGLE DRIVE 5 TB (RCLONE VFS STREAMING) — ARCH LINUX POWER-SUITE
# ==============================================================================
# Montagem sob demanda com cache VFS adaptativo:
# - Acessa 5 TB como se fosse uma pasta local no SSD
# - Baixa arquivos somente quando você clica para abrir (On-Demand)
# - Vídeos 4K e 1080p rodam via streaming instantâneo sem pré-download
# - Limite rígido de cache local: 50 GB (zero risco de lotar o SSD)
# - Expurgo automático de arquivos em cache após 24h sem uso
#
# Uso:
#   gdrive-mount.sh mount        -> Monta o drive virtual
#   gdrive-mount.sh unmount      -> Desmonta de forma segura
#   gdrive-mount.sh toggle       -> Alterna entre montado e desmontado (Hyprland)
#   gdrive-mount.sh status       -> Diagnóstico completo e uso de cache
#   gdrive-mount.sh clean-cache  -> Limpa o cache local VFS imediatamente
#   gdrive-mount.sh setup        -> Assistente guiado de configuração OAuth
#   gdrive-mount.sh open         -> Abre a pasta no gerenciador de arquivos
# ==============================================================================

set -euo pipefail

# --- Cores Catppuccin ---
ROSEWATER='\033[38;2;245;224;220m'
FLAMINGO='\033[38;2;242;205;205m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
RED='\033[38;2;243;139;168m'
MAROON='\033[38;2;235;160;172m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
SAPPHIRE='\033[38;2;116;199;236m'
BLUE='\033[38;2;137;180;250m'
LAVENDER='\033[38;2;180;190;254m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT='\033[38;2;166;173;200m'
NC='\033[0m'
BOLD='\033[1m'

REMOTE_NAME="gdrive"
MOUNT_DIR="${HOME}/gdrive"
DATA_SYMLINK="/mnt/dados/00_GoogleDrive"
SERVICE_NAME="rclone-gdrive.service"
CACHE_DIR="${HOME}/.cache/rclone/vfs/${REMOTE_NAME}"
CONFIG_FILE="${HOME}/.config/rclone/rclone.conf"

notify() {
    local title="$1"
    local msg="$2"
    local urgency="${3:-normal}"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Google Drive 5TB" -i "cloud-drive" -u "$urgency" "$title" "$msg" 2>/dev/null || true
    fi
}

banner() {
    clear 2>/dev/null || true
    echo -e "${MAUVE}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════════╗"
    echo "  ║      ☁️  GOOGLE DRIVE 5 TB — VFS STREAMING SUITE (RCLONE)        ║"
    echo "  ╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

is_mounted() {
    if mountpoint -q "$MOUNT_DIR" 2>/dev/null; then
        return 0
    fi
    # Verificação secundária via proc/mounts
    if grep -qs " ${MOUNT_DIR} " /proc/mounts 2>/dev/null; then
        return 0
    fi
    return 1
}

ensure_dirs() {
    mkdir -p "$MOUNT_DIR"
    # Se /mnt/dados existir, cria um link simbólico para acesso unificado
    if [ -d "/mnt/dados" ] && [ ! -L "$DATA_SYMLINK" ] && [ ! -e "$DATA_SYMLINK" ]; then
        ln -s "$MOUNT_DIR" "$DATA_SYMLINK" 2>/dev/null || true
    fi
}

check_rclone() {
    if ! command -v rclone >/dev/null 2>&1; then
        echo -e "${RED}[ERRO] Rclone não está instalado no sistema!${NC}"
        echo -e "${YELLOW}Para instalar no Arch Linux: sudo pacman -S --needed rclone fuse3${NC}"
        notify "Google Drive" "Rclone não encontrado. Instale com: sudo pacman -S rclone" "critical"
        exit 1
    fi
}

check_config() {
    if [ ! -f "$CONFIG_FILE" ] || ! grep -q "^\[${REMOTE_NAME}\]" "$CONFIG_FILE" 2>/dev/null; then
        echo -e "${YELLOW}[AVISO] O controle remoto '${REMOTE_NAME}' ainda não foi configurado no Rclone!${NC}"
        echo -e "${TEXT}Inicie a configuração com:${NC} ${GREEN}gdrive-mount.sh setup${NC}"
        notify "Google Drive Desconectado" "Execute 'gdrive-mount.sh setup' para conectar sua conta." "critical"
        return 1
    fi
    return 0
}

do_mount() {
    check_rclone
    if ! check_config; then
        exit 1
    fi

    ensure_dirs

    if is_mounted; then
        echo -e "${GREEN}[OK] Google Drive já está montado e ativo em: ${MOUNT_DIR}${NC}"
        notify "Google Drive 5TB" "Já está montado e pronto para uso em ~/gdrive."
        return 0
    fi

    echo -e "${BLUE}[*] Conectando Google Drive 5TB via Rclone VFS Streaming...${NC}"

    # Se o serviço do systemd de usuário estiver disponível, priorize-o
    if systemctl --user list-unit-files "$SERVICE_NAME" >/dev/null 2>&1; then
        systemctl --user start "$SERVICE_NAME"
    else
        # Fallback para montagem direta em background
        rclone mount "${REMOTE_NAME}:" "$MOUNT_DIR" \
            --vfs-cache-mode full \
            --vfs-cache-max-size 50G \
            --vfs-cache-max-age 24h \
            --vfs-read-chunk-size 32M \
            --vfs-read-chunk-size-limit 2G \
            --buffer-size 64M \
            --dir-cache-time 72h \
            --poll-interval 15s \
            --attr-timeout 1s \
            --drive-pacer-min-sleep 10ms \
            --drive-pacer-burst 200 \
            --umask 022 \
            --rc \
            --rc-no-auth \
            --rc-addr 127.0.0.1:5572 \
            --daemon
    fi

    # Aguardar até 5 segundos para a montagem estar pronta
    local count=0
    while [ $count -lt 10 ]; do
        if is_mounted; then
            break
        fi
        sleep 0.5
        count=$((count + 1))
    done

    if is_mounted; then
        echo -e "${GREEN}${BOLD}✓ Google Drive 5TB montado com sucesso!${NC}"
        echo -e "${SUBTEXT}  Ponto de montagem : ${TEXT}${MOUNT_DIR}${NC}"
        [ -L "$DATA_SYMLINK" ] && echo -e "${SUBTEXT}  Atalho unificado  : ${TEXT}${DATA_SYMLINK}${NC}"
        echo -e "${SUBTEXT}  Modo VFS Streaming: ${GREEN}ATIVO (Cache local máx: 50 GB)${NC}"
        notify "Google Drive 5TB Conectado" "Montado com sucesso em ~/gdrive. 5 TB disponíveis sob demanda!"
    else
        echo -e "${RED}[ERRO] Falha ao montar o Google Drive. Verifique os logs:${NC}"
        journalctl --user -u "$SERVICE_NAME" -n 20 --no-pager 2>/dev/null || true
        notify "Google Drive Falhou" "Não foi possível montar. Verifique sua conexão e credenciais." "critical"
        return 1
    fi
}

do_unmount() {
    if ! is_mounted; then
        echo -e "${YELLOW}[!] O Google Drive já se encontra desmontado.${NC}"
        notify "Google Drive 5TB" "O disco virtual já está desconectado."
        return 0
    fi

    echo -e "${BLUE}[*] Desmontando Google Drive de forma segura...${NC}"

    if systemctl --user is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
        systemctl --user stop "$SERVICE_NAME" 2>/dev/null || true
    fi

    # Se ainda estiver montado, força desmontagem lazy com fusermount
    if is_mounted; then
        if command -v fusermount3 >/dev/null 2>&1; then
            fusermount3 -u -z "$MOUNT_DIR" 2>/dev/null || true
        elif command -v fusermount >/dev/null 2>&1; then
            fusermount -u -z "$MOUNT_DIR" 2>/dev/null || true
        else
            sudo umount -l "$MOUNT_DIR" 2>/dev/null || true
        fi
    fi

    sleep 1

    if ! is_mounted; then
        echo -e "${GREEN}✓ Google Drive desmontado com sucesso.${NC}"
        notify "Google Drive 5TB" "Desconectado com sucesso. Memória liberada."
    else
        echo -e "${RED}[ERRO] Não foi possível desmontar o diretório ${MOUNT_DIR}.${NC}"
        notify "Google Drive" "Erro ao desmontar. Arquivos podem estar em uso." "critical"
        return 1
    fi
}

do_toggle() {
    if is_mounted; then
        do_unmount
    else
        do_mount
    fi
}

do_status() {
    banner
    check_rclone

    echo -e "${BOLD}STATUS DA CONEXÃO:${NC}"
    if is_mounted; then
        echo -e "  Estado          : ${GREEN}${BOLD}● CONECTADO & ATIVO${NC}"
        echo -e "  Ponto Principal : ${TEXT}${MOUNT_DIR}${NC}"
        if [ -L "$DATA_SYMLINK" ]; then
            echo -e "  Link Unificado  : ${TEXT}${DATA_SYMLINK}${NC}"
        fi
    else
        echo -e "  Estado          : ${RED}${BOLD}○ DESCONECTADO${NC}"
        echo -e "  Ponto Principal : ${SUBTEXT}${MOUNT_DIR}${NC}"
    fi

    echo ""
    echo -e "${BOLD}CACHE LOCAL VFS (Proteção do SSD):${NC}"
    if [ -d "$CACHE_DIR" ]; then
        local cache_size
        cache_size=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo "0B")
        echo -e "  Uso Atual       : ${PEACH}${cache_size}${NC} (Limite máximo configurado: ${GREEN}50 GB${NC})"
        echo -e "  Expurgo Automát.: ${SUBTEXT}Itens com mais de 24h sem leitura são liberados${NC}"
        echo -e "  Diretório       : ${SUBTEXT}${CACHE_DIR}${NC}"
    else
        echo -e "  Uso Atual       : ${SUBTEXT}0 B (Cache limpo)${NC}"
    fi

    echo ""
    echo -e "${BOLD}SERVIÇO SYSTEMD:${NC}"
    if systemctl --user is-enabled "$SERVICE_NAME" >/dev/null 2>&1; then
        echo -e "  Inicialização   : ${GREEN}Habilitado no boot (user systemd)${NC}"
    else
        echo -e "  Inicialização   : ${YELLOW}Manual (não habilitado no boot)${NC}"
    fi

    if systemctl --user is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
        echo -e "  Status Systemd  : ${GREEN}active (running)${NC}"
    else
        echo -e "  Status Systemd  : ${SUBTEXT}inactive (dead)${NC}"
    fi

    echo ""
    echo -e "${BOLD}TESTE DE CONEXÃO COM O GOOGLE DRIVE:${NC}"
    if check_config >/dev/null 2>&1; then
        echo -ne "  Verificando quota remota... "
        local quota
        if quota=$(rclone about "${REMOTE_NAME}:" --json 2>/dev/null); then
            local total_gb used_gb
            total_gb=$(echo "$quota" | grep -o '"total":[0-9]*' | cut -d: -f2 | awk '{printf "%.1f GB (ou %.2f TB)", $1/1073741824, $1/1099511627776}')
            used_gb=$(echo "$quota" | grep -o '"used":[0-9]*' | cut -d: -f2 | awk '{printf "%.1f GB (ou %.2f TB)", $1/1073741824, $1/1099511627776}')
            echo -e "${GREEN}OK!${NC}"
            echo -e "  Espaço Total    : ${CYAN}${total_gb}${NC}"
            echo -e "  Espaço Ocupado  : ${PEACH}${used_gb}${NC}"
        else
            echo -e "${YELLOW}Inacessível ou sem internet no momento.${NC}"
        fi
    else
        echo -e "  ${YELLOW}Conta não configurada no rclone.conf.${NC}"
    fi
    echo ""
}

do_clean_cache() {
    banner
    echo -e "${PEACH}[*] Limpando cache local VFS do Google Drive...${NC}"
    if [ -d "$CACHE_DIR" ]; then
        local before_size
        before_size=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo "0B")
        rm -rf "${CACHE_DIR:?}/"* 2>/dev/null || true
        echo -e "${GREEN}✓ Cache limpo com sucesso! Espaço liberado no SSD: ${before_size}${NC}"
        notify "Cache Google Drive Limpo" "Foram liberados ${before_size} do cache temporário do SSD."
    else
        echo -e "${GREEN}✓ O cache já estava vazio (0 B).${NC}"
    fi
}

do_open() {
    if ! is_mounted; then
        do_mount
    fi
    if command -v yazi >/dev/null 2>&1 && [ -t 0 ]; then
        yazi "$MOUNT_DIR"
    elif command -v thunar >/dev/null 2>&1; then
        thunar "$MOUNT_DIR" &
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$MOUNT_DIR" &
    else
        echo "$MOUNT_DIR"
    fi
}

do_setup() {
    banner
    check_rclone

    echo -e "${MAUVE}${BOLD}=== ASSISTENTE DE CONFIGURAÇÃO DO GOOGLE DRIVE 5 TB ===${NC}\n"
    echo -e "${TEXT}Este assistente guiará a conexão entre o Arch Linux e seu Google Drive.${NC}"
    echo -e "${SUBTEXT}O Rclone abrirá o navegador para autorizar com 1 clique (OAuth2 seguro).${NC}\n"

    echo -e "${YELLOW}${BOLD}Instruções Rápidas:${NC}"
    echo -e "  1. Quando o menu do Rclone abrir, digite: ${GREEN}n${NC} (New remote)"
    echo -e "  2. No nome da conexão, digite exatamente: ${GREEN}gdrive${NC}"
    echo -e "  3. No tipo de armazenamento (storage), digite: ${GREEN}drive${NC} (Google Drive)"
    echo -e "  4. client_id e client_secret: aperte ${GREEN}Enter${NC} para deixar em branco (padrão)"
    echo -e "     (Ou cole suas chaves de API caso tenha criado um projeto pessoal no Google Cloud)"
    echo -e "  5. No escopo de acesso (scope), escolha: ${GREEN}1${NC} (Full access)"
    echo -e "  6. service_account_file: aperte ${GREEN}Enter${NC} (deixar em branco)"
    echo -e "  7. Edit advanced config: digite ${GREEN}n${NC}"
    echo -e "  8. Use auto config: digite ${GREEN}y${NC} (abre o navegador automaticamente)"
    echo -e "  9. Faça login na sua conta Google e clique em 'Permitir'"
    echo -e " 10. Configure this as a Shared Drive: digite ${GREEN}n${NC} (ou y se for Team Drive)"
    echo -e " 11. Confirme tudo com ${GREEN}y${NC} e saia com ${GREEN}q${NC}\n"

    read -rp "Pressione [ENTER] para iniciar o 'rclone config' agora..." _

    rclone config

    echo ""
    if check_config >/dev/null 2>&1; then
        echo -e "${GREEN}${BOLD}🎉 Sucesso! Conexão 'gdrive' configurada perfeitamente!${NC}\n"
        read -rp "Deseja habilitar a montagem automática no boot do sistema agora? [S/n]: " resp
        if [[ "$resp" =~ ^[Nn]$ ]]; then
            echo -e "${SUBTEXT}Montagem automática ignorada.${NC}"
        else
            ensure_dirs
            systemctl --user daemon-reload 2>/dev/null || true
            systemctl --user enable --now "$SERVICE_NAME" 2>/dev/null || true
            echo -e "${GREEN}✓ Serviço ${SERVICE_NAME} habilitado e iniciado no Systemd de Usuário!${NC}"
        fi

        echo ""
        read -rp "Deseja montar e testar o acesso agora? [S/n]: " resp2
        if [[ ! "$resp2" =~ ^[Nn]$ ]]; then
            do_mount
        fi
    else
        echo -e "${RED}[AVISO] A conexão 'gdrive' não foi encontrada. Tente rodar o setup novamente.${NC}"
    fi
}

ACTION="${1:-status}"

case "$ACTION" in
    mount|conectar|ligar)
        do_mount
        ;;
    unmount|umount|desconectar|desligar)
        do_unmount
        ;;
    toggle|alternar)
        do_toggle
        ;;
    status|info)
        do_status
        ;;
    clean-cache|limpar-cache)
        do_clean_cache
        ;;
    setup|configurar)
        do_setup
        ;;
    open|abrir|gui)
        do_open
        ;;
    jump|path)
        echo "$MOUNT_DIR"
        ;;
    *)
        echo -e "Uso: $0 {mount|unmount|toggle|status|clean-cache|setup|open}"
        echo "  mount       : Monta o Google Drive 5TB sob demanda via VFS streaming"
        echo "  unmount     : Desmonta o disco virtual de forma segura"
        echo "  toggle      : Conecta se estiver desligado, desconecta se estiver ligado"
        echo "  status      : Exibe status da montagem, espaço VFS e uso de cache"
        echo "  clean-cache : Limpa o cache temporário local do SSD"
        echo "  setup       : Assistente guiado de autorização OAuth do Google Drive"
        echo "  open        : Abre a pasta do Google Drive no Yazi/Thunar"
        exit 1
        ;;
esac
