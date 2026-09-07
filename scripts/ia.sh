#!/usr/bin/env bash
# ==============================================================================
# 🤖 IA AUTÔNOMA LOCAL — Agente Inteligente de Sistema e Dotfiles (Ollama + Aider)
# ==============================================================================
# Executa tarefas autônomas no terminal com edição de arquivos, testes,
# commits estruturados no Git e push automático para o repositório remoto.
# ==============================================================================

set -eo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

DEFAULT_MODEL="ollama/qwen2.5-coder:32b"
R1_MODEL="ollama/deepseek-r1:14b"
R1_32B_MODEL="ollama/deepseek-r1:32b"

CMD_NAME=$(basename "$0")

show_help() {
    echo -e "${PURPLE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  🤖  IA AUTÔNOMA LOCAL — AGENTE DE TERMINAL & DOTFILES       ║"
    echo "║      Ollama + Aider + Qwen 2.5 Coder 32B (RTX 5060 + RAM)    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${BOLD}Uso:${NC}"
    echo -e "  ${GREEN}ia${NC}                                 Abre sessão interativa de chat/agente"
    echo -e "  ${GREEN}ia \"sua instrução\"${NC}                Executa em modo 100% autônomo (auto-commit + push)"
    echo -e "  ${GREEN}ia --r1 \"sua instrução\"${NC}           Executa usando DeepSeek-R1 (raciocínio profundo)"
    echo -e "  ${GREEN}ia stop | ia-stop${NC}                  Descarrega o modelo da VRAM (libera memória)"
    echo -e "  ${GREEN}ia status | ia-status${NC}              Exibe uso da GPU, VRAM e modelos em execução"
    echo -e "  ${GREEN}ia models | ia list${NC}                Lista todos os modelos locais disponíveis"
    echo ""
    echo -e "${BOLD}Exemplos práticos:${NC}"
    echo -e "  ia \"adicione um atalho no hyprland.conf para abrir o btop com Super+B\""
    echo -e "  ia \"crie um script em scripts/meu-script.sh que limpe a lixeira e avise no swaync\""
    echo -e "  ia \"analise o style.css da waybar e ajuste o espaçamento entre os módulos\""
    echo ""
}

show_status() {
    echo -e "${BLUE}${BOLD}=== 📊 Status da IA Local & GPU ===${NC}\n"
    if command -v nvidia-smi &>/dev/null; then
        echo -e "${CYAN}${BOLD}Uso de GPU & VRAM (NVIDIA RTX 5060):${NC}"
        nvidia-smi --query-gpu=name,memory.used,memory.free,memory.total,temperature.gpu,utilization.gpu --format=csv,noheader \
            | awk -F', ' '{printf "  Placa: %s\n  VRAM em uso: %s / %s (Livre: %s)\n  Temperatura: %s°C | Carga GPU: %s\n", $1, $2, $4, $3, $5, $6}'
        echo ""
    fi
    echo -e "${CYAN}${BOLD}Modelos ativos no Ollama:${NC}"
    local active
    active=$(ollama ps 2>/dev/null || true)
    if echo "$active" | grep -q "NAME"; then
        echo "$active"
    else
        echo -e "  ${YELLOW}Nenhum modelo carregado na VRAM no momento (modo ocioso / recursos livres).${NC}"
    fi
    echo ""
}

stop_models() {
    echo -e "${YELLOW}${BOLD}⏸️  Liberando memória VRAM e descarregando modelos do Ollama...${NC}"
    local models
    models=$(ollama ps 2>/dev/null | awk 'NR>1 {print $1}')
    if [ -n "$models" ]; then
        for m in $models; do
            echo -e "  Parando modelo: ${BOLD}$m${NC}..."
            ollama stop "$m" >/dev/null 2>&1 || true
        done
        echo -e "${GREEN}✔ VRAM liberada com sucesso!${NC}\n"
    else
        ollama stop qwen2.5-coder:32b >/dev/null 2>&1 || true
        ollama stop deepseek-r1:14b >/dev/null 2>&1 || true
        ollama stop deepseek-r1:32b >/dev/null 2>&1 || true
        echo -e "${GREEN}✔ Todos os modelos estão descarregados. VRAM 100% livre!${NC}\n"
    fi
    show_status
}

# Subcomandos diretos ou chamadas via links (ia-stop / ia-status)
if [[ "$CMD_NAME" == "ia-stop" || "${1:-}" == "stop" || "${1:-}" == "free" || "${1:-}" == "--stop" || "${1:-}" == "--free" ]]; then
    stop_models
    exit 0
fi

if [[ "$CMD_NAME" == "ia-status" || "${1:-}" == "status" || "${1:-}" == "--status" ]]; then
    show_status
    exit 0
fi

case "${1:-}" in
    -h|--help|help)
        show_help
        exit 0
        ;;
    models|list|--models|--list)
        echo -e "${BLUE}${BOLD}=== 🧠 Modelos Locais Instalados ===${NC}\n"
        ollama list
        exit 0
        ;;
esac


# Seleção de modelo
MODEL="$DEFAULT_MODEL"
if [[ "${1:-}" == "--r1" ]]; then
    MODEL="$R1_MODEL"
    shift
elif [[ "${1:-}" == "--r1-32b" ]]; then
    MODEL="$R1_32B_MODEL"
    shift
elif [[ "${1:-}" == "--qwen" ]]; then
    MODEL="$DEFAULT_MODEL"
    shift
fi

# Modo interativo (sem argumentos)
if [ $# -eq 0 ]; then
    echo -e "${GREEN}${BOLD}🤖 Iniciando sessão interativa do Agente IA (Modelo: $MODEL)...${NC}"
    echo -e "${CYAN}Dica: Digite /add <arquivo> para adicionar arquivos de contexto, ou digite o que deseja fazer.${NC}\n"
    exec aider --model "$MODEL"
fi

# Modo autônomo (com instrução passada como argumento)
INSTRUCTION="$*"

echo -e "${PURPLE}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  🤖 AGENTE AUTÔNOMO EXECUTANDO TAREFA                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${CYAN}${BOLD}Modelo:${NC} $MODEL"
echo -e "${CYAN}${BOLD}Instrução:${NC} $INSTRUCTION"
echo -e "${CYAN}${BOLD}Diretório:${NC} $PWD"
echo "──────────────────────────────────────────────────────────────"

PREV_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "none")

# Executa o Aider com auto-aprovação de alterações
aider --model "$MODEL" --yes-always --message "$INSTRUCTION"

CURRENT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "none")

echo "──────────────────────────────────────────────────────────────"

if [ "$PREV_COMMIT" != "none" ] && [ "$PREV_COMMIT" != "$CURRENT_COMMIT" ]; then
    echo -e "${GREEN}${BOLD}✔ Alterações aplicadas e commitadas com sucesso!${NC}"
    git log -1 --oneline
    echo ""
    
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    if git remote get-url origin >/dev/null 2>&1; then
        echo -e "${BLUE}🚀 Enviando automaticamente alterações para o GitHub ($BRANCH)...${NC}"
        if git push origin "$BRANCH"; then
            echo -e "${GREEN}✔ Push concluído com sucesso!${NC}"
        else
            echo -e "${YELLOW}⚠️ Falha ao dar push (verifique sua conexão ou credenciais).${NC}"
        fi
    fi

    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Agente IA" -i "dialog-information" -u normal \
            "🤖 Tarefa Concluída pelo Agente IA" \
            "Modificações aplicadas, testadas e commitadas no Git."
    fi
else
    echo -e "${BLUE}ℹ Nenhuma alteração de commit necessária ou aplicada.${NC}"
fi

echo ""
echo -e "${GREEN}${BOLD}🏁 Processo finalizado!${NC} (Para liberar VRAM imediatamente, use: ${BOLD}ia-stop${NC})\n"
