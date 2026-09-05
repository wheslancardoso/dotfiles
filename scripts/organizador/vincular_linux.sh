#!/usr/bin/env bash
# ==============================================================================
# 🔗 VINCULAR LINUX — Integração da Taxonomia Mestre com o Sistema Operacional
# ==============================================================================
# Este script vincula a sua partição de dados / pasta do Google Drive diretamente
# à sua $HOME no Linux através de symlinks transparentes.
# Resultado: Você formata a raiz (/) quantas vezes quiser e NUNCA perde arquivos.
# ==============================================================================

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[92m"
CYAN="\033[96m"
YELLOW="\033[93m"
RED="\033[91m"
RESET="\033[0m"

echo -e "\n${BOLD}${CYAN}======================================================${RESET}"
echo -e "${BOLD}${CYAN}   ORGANIZADOR MASTER — VINCULAÇÃO TRANSPARENTE LINUX  ${RESET}"
echo -e "${BOLD}${CYAN}======================================================${RESET}\n"

# 1. Detectar ou solicitar o caminho da Taxonomia Mestre
DEFAULT_DATA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "Onde está localizada a raiz da Taxonomia Mestre (00_ a 06_)?"
echo -e "Diretório sugerido detectado: ${BOLD}${GREEN}${DEFAULT_DATA_DIR}${RESET}"
read -rp "Pressione ENTER para confirmar ou digite o caminho personalizado: " USER_INPUT

DATA_DIR="${USER_INPUT:-$DEFAULT_DATA_DIR}"

if [[ ! -d "$DATA_DIR/01_Pessoal_e_Vida" ]]; then
    echo -e "${RED}[ERRO] O diretório informado não contém as pastas da Taxonomia Mestre (01_Pessoal_e_Vida, etc.).${RESET}"
    echo -e "Caminho testado: $DATA_DIR"
    exit 1
fi

echo -e "\n${GREEN}[OK] Raiz de dados válida confirmada: ${DATA_DIR}${RESET}\n"

# 2. Mapeamento de Symlinks para $HOME
# (Cria links simbólicos limpos para acesso imediato pelos apps e gerenciadores de arquivo)

declare -A LINKS=(
    ["$HOME/Downloads"]="$DATA_DIR/00_Inbox_Triagem"
    ["$HOME/Documentos"]="$DATA_DIR/01_Pessoal_e_Vida"
    ["$HOME/Estudos"]="$DATA_DIR/02_Estudos_e_Concursos"
    ["$HOME/WFIX"]="$DATA_DIR/03_Profissional_WFIX"
    ["$HOME/Projetos"]="$DATA_DIR/04_Desenvolvimento_e_Codigo"
    ["$HOME/Imagens"]="$DATA_DIR/05_Design_Midia_e_Criacao"
    ["$HOME/Backups"]="$DATA_DIR/06_Backups_ISOs_e_Sistemas"
)

echo -e "${BOLD}Vinculando pastas na sua \$HOME ($HOME)...${RESET}"

for LINK_PATH in "${!LINKS[@]}"; do
    TARGET_DIR="${LINKS[$LINK_PATH]}"

    # Se já existir como link simbólico
    if [[ -L "$LINK_PATH" ]]; then
        rm "$LINK_PATH"
    # Se existir como pasta normal, verifica se tem arquivos
    elif [[ -d "$LINK_PATH" ]]; then
        if [[ -z "$(ls -A "$LINK_PATH")" ]]; then
            rmdir "$LINK_PATH"
        else
            BACKUP_NAME="${LINK_PATH}_backup_$(date +%Y%m%d%H%M%S)"
            echo -e "${YELLOW}[AVISO] Pasta $LINK_PATH continha arquivos. Movida para $BACKUP_NAME${RESET}"
            mv "$LINK_PATH" "$BACKUP_NAME"
        fi
    fi

    ln -s "$TARGET_DIR" "$LINK_PATH"
    echo -e "  ${GREEN}✔${RESET} $(basename "$LINK_PATH") ➔ ${TARGET_DIR}"
done

# 3. Atualizar XDG User Dirs se o utilitário estiver disponível
if command -v xdg-user-dirs-update &>/dev/null; then
    xdg-user-dirs-update --set DOWNLOAD "$DATA_DIR/00_Inbox_Triagem" 2>/dev/null || true
    xdg-user-dirs-update --set DOCUMENTS "$DATA_DIR/01_Pessoal_e_Vida" 2>/dev/null || true
    xdg-user-dirs-update --set PICTURES "$DATA_DIR/05_Design_Midia_e_Criacao" 2>/dev/null || true
    echo -e "\n${GREEN}[SUCESSO] XDG User Dirs atualizados para apontar nativamente para a Taxonomia Mestre!${RESET}"
fi

echo -e "\n${BOLD}${GREEN}======================================================${RESET}"
echo -e "${BOLD}${GREEN}   SISTEMA VINCULADO COM SUCESSO!                     ${RESET}"
echo -e "${BOLD}${GREEN}======================================================${RESET}"
echo -e "Agora, qualquer download do navegador cai em: ${CYAN}00_Inbox_Triagem${RESET}"
echo -e "Seus documentos pessoais abrem direto em:     ${CYAN}01_Pessoal_e_Vida${RESET}"
echo -e "Seus projetos de código abrem em:            ${CYAN}04_Desenvolvimento_e_Codigo${RESET}\n"
