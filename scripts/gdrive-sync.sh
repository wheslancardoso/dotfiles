#!/usr/bin/env bash
# ==============================================================================
# 🚀 GDRIVE-SYNC — SINCRONIZAÇÃO SELETIVA INTELIGENTE (5 TB GOOGLE DRIVE)
# ==============================================================================
# Sincroniza apenas o que é insubstituível (Documentos, Concursos, WFIX, Código)
# Mantém mídias pesadas (05) e ISOs/Games (06) locais no NVMe.
#
# Uso:
#   gdrive-sync.sh               -> Exibe status e opções interativas
#   gdrive-sync.sh --dry-run     -> Simulação de sincronização sem alterar nada
#   gdrive-sync.sh --sync        -> Executa sincronização seletiva em segundo plano
#   gdrive-sync.sh --status      -> Verifica divergências entre local e nuvem
# ==============================================================================

set -euo pipefail

# Cores Catppuccin
MAUVE='\033[38;2;203;166;247m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'
BLUE='\033[38;2;137;180;250m'
RED='\033[38;2;243;139;168m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT='\033[38;2;166;173;200m'
NC='\033[0m'
BOLD='\033[1m'

REMOTE="gdrive"
DEST_PREFIX="Taxonomia_Backup"
CONFIG_FILE="${HOME}/.config/rclone/rclone.conf"

# Diretório base local (prioriza /mnt/dados se montado)
if [ -d "/mnt/dados" ] && [ -d "/mnt/dados/01_Pessoal_e_Vida" ]; then
    BASE_DIR="/mnt/dados"
else
    BASE_DIR="${HOME}/documents"
fi

# Pilares prioritários para backup contínuo na nuvem
PILLARS=(
    "01_Pessoal_e_Vida"
    "02_Estudos_e_Concursos"
    "03_Profissional_WFIX"
    "04_Desenvolvimento_e_Codigo"
)

# Filtros de exclusão (evita desperdiçar banda e espaço com lixo e temporários)
EXCLUDES=(
    "--exclude=.git/**"
    "--exclude=node_modules/**"
    "--exclude=__pycache__/**"
    "--exclude=.venv/**"
    "--exclude=.pytest_cache/**"
    "--exclude=target/**"
    "--exclude=build/**"
    "--exclude=dist/**"
    "--exclude=*.iso"
    "--exclude=*.crdownload"
    "--exclude=*.part"
    "--exclude=*.tmp"
    "--exclude=*.aria2"
    "--exclude=Thumbs.db"
    "--exclude=desktop.ini"
    "--exclude=*:Zone.Identifier"
    "--exclude=.DS_Store"
)

notify() {
    local title="$1"
    local msg="$2"
    local urgency="${3:-normal}"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Google Drive Sync" -i "cloud-upload" -u "$urgency" "$title" "$msg" 2>/dev/null || true
    fi
}

check_prereqs() {
    if ! command -v rclone >/dev/null 2>&1; then
        echo -e "${RED}[ERRO] Rclone não está instalado!${NC}"
        notify "Google Drive Sync" "Rclone não encontrado. Instale com: sudo pacman -S rclone" "critical"
        exit 1
    fi

    if [ ! -f "$CONFIG_FILE" ] || ! grep -q "^\[${REMOTE}\]" "$CONFIG_FILE" 2>/dev/null; then
        echo -e "${YELLOW}[AVISO] O remote '${REMOTE}' não está configurado no Rclone!${NC}"
        echo -e "${TEXT}Execute: ${GREEN}gdrive-mount.sh setup${NC} para autenticar.${NC}"
        exit 1
    fi
}

run_sync() {
    local dry_run_flag="${1:-}"
    local is_dry=false
    if [ "$dry_run_flag" == "--dry-run" ]; then
        is_dry=true
    fi

    echo -e "${MAUVE}${BOLD}======================================================================${NC}"
    if [ "$is_dry" = true ]; then
        echo -e "${YELLOW}${BOLD} ☁️  GDRIVE SYNC — SIMULAÇÃO (DRY-RUN) SELETIVA DE PILARES${NC}"
    else
        echo -e "${GREEN}${BOLD} ☁️  GDRIVE SYNC — SINCRONIZAÇÃO SELETIVA DE PILARES NA NUVEM${NC}"
        notify "Google Drive Sync" "Iniciando sincronização seletiva dos pilares 01..04..." "normal"
    fi
    echo -e "${MAUVE}${BOLD}======================================================================${NC}"
    echo -e "${TEXT}Origem Local : ${BLUE}${BASE_DIR}${NC}"
    echo -e "${TEXT}Destino Nuvem: ${BLUE}${REMOTE}:${DEST_PREFIX}/${NC}"
    echo -e "${SUBTEXT}Filtros      : Ignorando .git, node_modules, .venv, *.iso e temporários.${NC}"
    echo ""

    for pillar in "${PILLARS[@]}"; do
        local src_path="${BASE_DIR}/${pillar}"
        local dest_path="${REMOTE}:${DEST_PREFIX}/${pillar}"

        if [ ! -d "$src_path" ]; then
            echo -e "${YELLOW}⏩ Pilar local não encontrado: ${pillar} (pulando)${NC}"
            continue
        fi

        echo -e "${MAUVE}▶ Sincronizando: ${BOLD}${pillar}${NC}..."
        
        local dry_opt=()
        if [ "$is_dry" = true ]; then
            dry_opt=("--dry-run")
        fi

        rclone sync "$src_path" "$dest_path" \
            "${EXCLUDES[@]}" \
            "${dry_opt[@]}" \
            --transfers=4 \
            --checkers=8 \
            --fast-list \
            --stats=3s \
            --stats-one-line \
            --progress || {
                echo -e "${RED}✖ Falha ao sincronizar: ${pillar}${NC}"
                notify "Google Drive Sync" "Erro ao sincronizar ${pillar}" "critical"
            }

        echo -e "${GREEN}✔ Concluído: ${pillar}${NC}\n"
    done

    echo -e "${MAUVE}${BOLD}======================================================================${NC}"
    if [ "$is_dry" = true ]; then
        echo -e "${YELLOW}${BOLD}✔ Simulação concluída! Nenhum dado foi modificado na nuvem.${NC}"
    else
        echo -e "${GREEN}${BOLD}✔ Sincronização seletiva concluída com sucesso no Google Drive!${NC}"
        notify "Google Drive Sync" "Sincronização seletiva dos pilares 01..04 concluída com sucesso!" "normal"
    fi
    echo -e "${MAUVE}${BOLD}======================================================================${NC}\n"
}

check_status() {
    echo -e "${MAUVE}${BOLD}======================================================================${NC}"
    echo -e "${BLUE}${BOLD} ☁️  GDRIVE SYNC — DIAGNÓSTICO DE DIVERGÊNCIAS (CHECK)${NC}"
    echo -e "${MAUVE}${BOLD}======================================================================${NC}\n"

    for pillar in "${PILLARS[@]}"; do
        local src_path="${BASE_DIR}/${pillar}"
        local dest_path="${REMOTE}:${DEST_PREFIX}/${pillar}"

        if [ ! -d "$src_path" ]; then
            continue
        fi

        echo -e "${TEXT}Comparando pilar: ${BOLD}${pillar}${NC}..."
        rclone check "$src_path" "$dest_path" \
            "${EXCLUDES[@]}" \
            --fast-list \
            --one-way 2>&1 | grep -E "(differences|matching|error)" || true
        echo ""
    done
}

show_menu() {
    echo -e "${MAUVE}${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAUVE}${BOLD}║      ☁️  GOOGLE DRIVE 5 TB — SINCRONIZADOR SELETIVO RCLONE       ║${NC}"
    echo -e "${MAUVE}${BOLD}╚═══════════════════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${TEXT}1) Executar Sincronização Agora (--sync)${NC}"
    echo -e "${TEXT}2) Simular Sincronização (--dry-run)${NC}"
    echo -e "${TEXT}3) Verificar Diferenças Nuvem vs Local (--status)${NC}"
    echo -e "${TEXT}4) Abrir Google Drive montado localmente${NC}"
    echo -e "${TEXT}0) Sair${NC}\n"
    read -rp "Selecione uma opção [0-4]: " opt
    case "$opt" in
        1) run_sync ;;
        2) run_sync --dry-run ;;
        3) check_status ;;
        4)
            if [ -x "${HOME}/dotfiles/scripts/gdrive-mount.sh" ]; then
                "${HOME}/dotfiles/scripts/gdrive-mount.sh" open
            fi
            ;;
        *) exit 0 ;;
    esac
}

# --- Main Entrypoint ---
check_prereqs

case "${1:-}" in
    --dry-run)
        run_sync --dry-run
        ;;
    --sync|--run)
        run_sync
        ;;
    --status|--check)
        check_status
        ;;
    --help|-h)
        echo "Uso: $(basename "$0") [--dry-run | --sync | --status]"
        ;;
    *)
        show_menu
        ;;
esac
