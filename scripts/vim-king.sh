#!/bin/bash
# 👑 Vim King & Dev Suite — Buscador Interativo de Comandos e Atalhos
# Permite encontrar instantaneamente qualquer atalho digitando em linguagem natural.

CHEATSHEET="$HOME/dotfiles/docs/GUIA_ATALHOS_E_KEYBINDS_MESTRE.md"

# Cores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

show_full() {
    if command -v bat &>/dev/null; then
        bat --paging=always --style=plain "$CHEATSHEET"
    else
        less "$CHEATSHEET"
    fi
}

if [[ "$1" == "--all" || "$1" == "-a" || "$1" == "view" ]]; then
    show_full
    exit 0
fi

if ! command -v fzf &>/dev/null; then
    echo -e "${YELLOW}[INFO] fzf não encontrado. Exibindo guia completo:${NC}"
    show_full
    exit 0
fi

# Base de Dados Curada de Atalhos com Busca Semântica
DATABASE=(
    "⚡ [Flash Jump]        | s + 2 letras         | Pular cursor instantaneamente para qualquer palavra na tela"
    "⚡ [Flash Reverso]     | S                    | Pular cursor em modo reverso ou árvore de sintaxe"
    "🎯 [Harpoon Alternar]  | <leader>1 a 4        | Alternar instantaneamente entre os 4 arquivos fixados"
    "🎯 [Harpoon Adicionar] | <leader>ha           | Fixar arquivo atual no Harpoon"
    "🎯 [Harpoon Menu]      | <leader>hh           | Abrir lista visual de arquivos do Harpoon"
    "🔍 [Buscar Arquivos]   | <leader>ff           | Buscar arquivo por nome no projeto (Telescope)"
    "🔍 [Buscar Texto Grep] | <leader>sg           | Buscar texto em todos os arquivos do projeto (Live Grep)"
    "🔍 [Buscar Atalhos]    | <leader>? ou <leader>sk | Buscar qualquer atalho do Neovim interativamente"
    "🔲 [Surround Aspas]    | ysiw\"               | Envolver palavra com aspas duplas: \"palavra\""
    "🔲 [Surround Parêntese]| ysiw)                | Envolver palavra com parênteses: (palavra)"
    "🔲 [Trocar Aspas]      | cs\"'                | Trocar aspas duplas por simples: 'palavra'"
    "🔲 [Deletar Aspas]     | ds\"                 | Remover aspas ao redor da palavra"
    "🔲 [Surround Tag HTML] | ysit<div>            | Envolver bloco de código com tag <div>...</div>"
    "🔀 [Split/Join Array]  | gS                   | Alternar array/objeto entre 1 linha e múltiplas linhas"
    "📏 [Alinhar Código]    | ga=                  | Alinhar linhas selecionadas pelo sinal de igual ="
    "🛠️ [Extrair Função]    | <leader>re (Visual)  | Refactoring: Extrair seleção para uma nova função"
    "🛠️ [Extrair Variável]  | <leader>rv (Visual)  | Refactoring: Extrair seleção para uma variável"
    "🛠️ [Inline Variável]   | <leader>ri           | Refactoring: Substituir variável pelo seu valor"
    "🗄️ [Banco de Dados SQL]| <leader>D            | Abrir Dadbod UI (substituto do DBeaver/DataGrip)"
    "🗄️ [Adicionar Conexão] | <leader>Da           | Adicionar conexão Postgres, MySQL ou SQLite"
    "🌐 [Testar API REST]   | <leader>Rr           | Executar requisição HTTP do arquivo .http (Kulala)"
    "🌐 [Alternar Headers]  | <leader>Rt           | Alternar visualização entre Body e Headers HTTP"
    "🌐 [Copiar cURL]       | <leader>Rc           | Copiar requisição HTTP como comando curl"
    "🌿 [LazyGit]           | <leader>gg           | Abrir interface visual do LazyGit"
    "🌿 [Diffview Conflitos]| <leader>gd           | Resolução visual de conflitos e diff do projeto 3-Way"
    "🌿 [Histórico Arquivo] | <leader>gh           | Ver histórico de commits do arquivo atual"
    "🌿 [Git Blame Linha]   | Automático (300ms)   | Mostra autor e commit inline no final da linha"
    "☕ [Java Code Actions] | <leader>ca           | Gerar Getters, Setters, Construtores, toString()"
    "☕ [Java Imports]      | <leader>co           | Limpar e organizar imports do Java"
    "🐞 [DAP Breakpoint]    | <leader>db           | Alternar ponto de interrupção (Breakpoint) de depuração"
    "🐞 [DAP Iniciar Debug] | <leader>dc           | Iniciar sessão de depuração interativa"
    "🐞 [DAP UI Painel]     | <leader>du           | Abrir painel de variáveis locais e call stack"
    "🐍 [Python Venv]       | <leader>cv           | Selecionar ambiente virtual Python (.venv, conda, mise)"
    "📱 [Flutter Reload]    | <leader>Fr           | Disparar Hot Reload no Flutter"
    "📱 [Flutter Restart]   | <leader>FR           | Disparar Hot Restart no Flutter"
    "📱 [Mobile scrcpy]     | scrcpy-dev (Shell)   | Espelhar celular físico no Hyprland (sem emulador)"
    "🤖 [Antigravity AI]    | <leader>ai           | Abrir agente agy em terminal flutuante no Neovim"
    "💾 [Salvar Arquivo]    | <C-s>                | Salvar arquivo e formatar código automaticamente"
    "🚪 [Sair de Tudo]      | <leader>qq           | Fechar todas as abas e sair do Neovim"
    "📑 [Buffer Anterior]   | <S-h>                | Pular para o buffer anterior aberto"
    "📑 [Próximo Buffer]    | <S-l>                | Pular para o próximo buffer aberto"
    "📑 [Fechar Buffer]     | <leader>bd           | Fechar arquivo/buffer atual"
    "🪟 [Foco Split]        | <C-h/j/k/l>          | Mover cursor entre divisões de tela (Splits)"
    "🪟 [Redimensionar]     | <C-Setas>            | Aumentar ou diminuir tamanho dos splits"
    "⬆️ [Mover Linha Baixo] | <A-j>                | Mover linha ou seleção atual para baixo"
    "⬇️ [Mover Linha Cima]  | <A-k>                | Mover linha ou seleção atual para cima"
    "📝 [Buscar TODOs]      | <leader>st           | Listar todos os TODO, FIXME e BUG do projeto"
    "💾 [Restaurar Sessão]  | <leader>qs           | Restaurar estado anterior do projeto (Persistence)"
    "🎮 [Treinar Vim]       | <leader>vg           | Jogar Vim-Be-Good para treinar memória muscular"
    "🪟 [Zellij Navegar]    | Alt + h/j/k/l        | Mover foco entre painéis no multiplexador Zellij"
    "🪟 [Zellij Vibe Layout]| vibe (Shell)         | Iniciar LazyVim (70%) + Antigravity CLI (30%)"
    "🌌 [Hyprland Fechar]   | Super + Q            | Fechar janela ativa no Hyprland"
    "🌌 [Hyprland Terminal] | Super + Return       | Abrir terminal no Hyprland"
    "🌌 [Hyprland Launcher] | Super + Space        | Abrir menu de aplicativos (Rofi)"
    "🌌 [Hyprland Yazi]     | Super + E            | Abrir gerenciador de arquivos Yazi"
    "🌌 [Hyprland Print]    | Super + Shift + S    | Captura de tela com seleção de área"
)

HEADER="👑 VIM KING & DEV SUITE | Digite para buscar qualquer atalho (ESC para sair, TAB/Enter para selecionar)"

SELECTED=$(printf "%s\n" "${DATABASE[@]}" | fzf \
    --header="$HEADER" \
    --prompt="🔍 Buscar comando > " \
    --height=60% \
    --layout=reverse \
    --border=rounded \
    --color="header:blue,prompt:green,pointer:cyan,hl:yellow,hl+:yellow" \
    --info=inline)

if [ -n "$SELECTED" ]; then
    echo -e "\n${GREEN}✔ Comando Selecionado:${NC}"
    echo -e "${CYAN}$SELECTED${NC}\n"
    echo -e "Dica: Pressione ${YELLOW}<leader>?${NC} dentro do Neovim para buscar atalhos sem sair do editor."
fi
