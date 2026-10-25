#!/usr/bin/env bash
# ==============================================================================
# 📥 APEX TELEGRAM DOWNLOADER (apex-tg) — ULTRA FAST & ORGANIZED
# ==============================================================================
# Motor: tdl (Telegram MTProto Downloader multithread) + fzf
# Padrão: Ecossistema APEX (Organização canônica para Whisper / IA)
# ==============================================================================

set -eo pipefail

TDL_BIN="$HOME/.local/bin/tdl"
if ! command -v "$TDL_BIN" &>/dev/null; then
    echo "❌ [APEX-TG] tdl não encontrado em $TDL_BIN"
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "  ⚡ ========================================================== ⚡"
    echo "         📥 APEX TELEGRAM DOWNLOADER — ULTRA FAST SUITE           "
    echo "  ⚡ ========================================================== ⚡"
    echo -e "${NC}"
}

# 1. Modo direto via argumentos CLI
if [[ "$1" == "-u" || "$1" == "--url" ]]; then
    DEST="${3:-$HOME/Downloads/Telegram}"
    mkdir -p "$DEST"
    echo -e "${GREEN}🚀 Baixando link direto com 16 threads...${NC}"
    "$TDL_BIN" dl -u "$2" -d "$DEST" --template "{{ .MessageID }}_{{ filenamify .FileName }}" -t 16 -l 4 --skip-same
    exit 0
fi

banner

# 2. Verificar se o banco de dados do tdl está livre
if pgrep -f "tdl dl" &>/dev/null; then
    echo -e "${YELLOW}⚠️ Há um download em segundo plano rodando atualmente no tdl.${NC}"
    echo -e "Progresso atual em ~/Downloads/AlgaWorks: $(ls ~/Downloads/AlgaWorks/*.mp4 2>/dev/null | wc -l) vídeos concluídos."
    echo ""
    read -rp "Deseja ver o status ou pausar? [s/N]: " RESP
    if [[ "$RESP" =~ ^[sS]$ ]]; then
        pkill -f "tdl dl" && echo -e "${RED}Processo anterior pausado.${NC}" || echo "Nada pausado."
    fi
fi

# 3. Menu de Seleção de Ação
echo -e "${BOLD}O que você deseja fazer?${NC}"
ACAO=$(cat <<EOF | fzf --prompt="⚡ Selecione a Ação > " --height=35% --reverse --border
1. 📂 Escolher Canal / Chat da minha conta (Interativo FZF)
2. 🔗 Baixar por Link de Mensagem / Canal (URL)
3. 🔁 Retomar último download interrompido
4. 🔐 Fazer Login / Trocar de Conta (QR Code)
EOF
)

[[ -z "$ACAO" ]] && { echo "Operação cancelada."; exit 0; }

case "$ACAO" in
    *"Login"*)
        banner
        echo -e "${BLUE}Iniciando login via QR Code...${NC}"
        "$TDL_BIN" login -T qr
        exit 0
        ;;
    *"Retomar"*)
        banner
        echo -e "${GREEN}Retomando download...${NC}"
        "$TDL_BIN" dl --continue -t 16 -l 4
        exit 0
        ;;
    *"Link"*)
        banner
        echo -e "${YELLOW}Cole o link da mensagem ou faixa do Telegram:${NC}"
        echo -e "${CYAN}Exemplo: https://t.me/canal/100 ou https://t.me/c/123456789/100${NC}"
        read -rp "URL: " TARGET_URL
        [[ -z "$TARGET_URL" ]] && exit 1

        read -rp "Nome da pasta de destino em ~/Downloads/ [Padrao: Telegram]: " FOLDER_NAME
        FOLDER_NAME="${FOLDER_NAME:-Telegram}"
        DEST_DIR="$HOME/Downloads/$FOLDER_NAME"
        mkdir -p "$DEST_DIR"

        echo -e "${GREEN}Iniciando download...${NC}"
        "$TDL_BIN" dl -u "$TARGET_URL" -d "$DEST_DIR" --template "{{ .MessageID }}_{{ filenamify .FileName }}" -t 16 -l 4 --skip-same
        exit 0
        ;;
    *"Escolher Canal"*)
        banner
        echo -e "${BLUE}Carregando lista de chats da sua conta...${NC}"
        CHAT_LINE=$("$TDL_BIN" chat ls 2>/dev/null | grep -E "channel|chat|supergroup" | fzf --prompt="🔍 Selecione o Canal/Grupo > " --height=60% --reverse --border)
        
        [[ -z "$CHAT_LINE" ]] && { echo "Nenhum chat selecionado."; exit 0; }

        CHAT_ID=$(echo "$CHAT_LINE" | awk '{print $1}')
        CHAT_NAME=$(echo "$CHAT_LINE" | awk '{print $3}')
        
        banner
        echo -e "${GREEN}Canal Selecionado:${NC} ${BOLD}$CHAT_NAME${NC} (ID: $CHAT_ID)"
        echo ""

        # Destino
        read -rp "Nome da pasta em ~/Downloads/ [Padrão: $CHAT_NAME]: " TARGET_DIR_NAME
        TARGET_DIR_NAME="${TARGET_DIR_NAME:-$CHAT_NAME}"
        TARGET_DIR_NAME=$(echo "$TARGET_DIR_NAME" | tr -cd 'A-Za-z0-9_-')
        DEST_DIR="$HOME/Downloads/$TARGET_DIR_NAME"
        mkdir -p "$DEST_DIR"

        INDEX_FILE="$DEST_DIR/indice_canal.json"

        # Exportar mensagens
        echo -e "\n${BLUE}📥 Indexando canal para mapeamento ordenado do Whisper...${NC}"
        "$TDL_BIN" chat export -c "$CHAT_ID" -T last -i 99999 -o "$INDEX_FILE"

        TOTAL_ITEMS=$(grep -o '"type":"message"' "$INDEX_FILE" | wc -l || echo "0")
        echo -e "${GREEN}✅ Indexado com sucesso! Total de itens detectados: ${BOLD}$TOTAL_ITEMS${NC}"
        echo -e "${CYAN}📁 Destino: $DEST_DIR${NC}"
        echo -e "${YELLOW}🚀 Iniciando download multithread (16 threads / 4 jobs simultâneos)...${NC}\n"

        "$TDL_BIN" dl -f "$INDEX_FILE" -d "$DEST_DIR" --template "{{ .MessageID }}_{{ filenamify .FileName }}" -t 16 -l 4 --skip-same
        ;;
esac
