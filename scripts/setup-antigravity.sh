#!/usr/bin/env bash
# ==============================================================================
# Setup Antigravity AI MCP Servers & Efficiency Rules
# Compatível com Arch Linux e Ubuntu/WSL
# ==============================================================================
set -euo pipefail

DEST_DIR="$HOME/.gemini/config"
RULES_DIR="$DEST_DIR/rules"

echo "==> Configurando Antigravity AI (MCP + Regras Globais + Templates de Eficiência)..."

mkdir -p "$RULES_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

SOURCE_MCP="$DOTFILES_DIR/home/dot_gemini/config/mcp_config.json"
SOURCE_RULE="$DOTFILES_DIR/home/dot_gemini/config/rules/mcp_policy.md"
SOURCE_REPOMIX="$DOTFILES_DIR/home/dot_gemini/config/repomix.config.json"
SOURCE_IGNORE="$DOTFILES_DIR/home/dot_gemini/config/.antigravityignore"

# Obtém token do ambiente ou mantém o já configurado se existir
GITHUB_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-${GITHUB_TOKEN:-}}"

# Detecta interpretador/shim nativo do npx no Linux (evita npx do Windows em /mnt/c/)
NPX_BIN="npx"
if [ -x "$HOME/.local/share/mise/shims/npx" ]; then
    NPX_BIN="$HOME/.local/share/mise/shims/npx"
elif command -v npx &>/dev/null && [[ "$(command -v npx)" != /mnt/* ]]; then
    NPX_BIN="$(command -v npx)"
elif [ -x "/usr/bin/npx" ]; then
    NPX_BIN="/usr/bin/npx"
fi

if [ -f "$SOURCE_MCP" ]; then
    TMP_MCP=$(mktemp)
    if [ -n "$GITHUB_TOKEN" ]; then
        sed "s|\${GITHUB_PERSONAL_ACCESS_TOKEN}|$GITHUB_TOKEN|g" "$SOURCE_MCP" > "$TMP_MCP"
        echo "  [OK] $DEST_DIR/mcp_config.json configurado com seu GITHUB_TOKEN."
    else
        # Se já existe um token real configurado localmente no destino, preserva-o
        if [ -f "$DEST_DIR/mcp_config.json" ] && grep -q "ghp_" "$DEST_DIR/mcp_config.json"; then
            CURRENT_TOKEN=$(grep -o 'ghp_[A-Za-z0-9_]*' "$DEST_DIR/mcp_config.json" | head -n 1)
            sed "s|\${GITHUB_PERSONAL_ACCESS_TOKEN}|$CURRENT_TOKEN|g" "$SOURCE_MCP" > "$TMP_MCP"
            echo "  [OK] $DEST_DIR/mcp_config.json atualizado mantendo o token local existente."
        else
            cp "$SOURCE_MCP" "$TMP_MCP"
            echo "  [OK] $DEST_DIR/mcp_config.json copiado (lembre de definir GITHUB_PERSONAL_ACCESS_TOKEN ou editar o arquivo)."
        fi
    fi
    # Ajusta o comando para o caminho real do npx no Linux
    sed -i "s|\"command\": \"npx\"|\"command\": \"$NPX_BIN\"|g" "$TMP_MCP"
    mv "$TMP_MCP" "$DEST_DIR/mcp_config.json"
else
    echo "  [!] Arquivo fonte mcp_config.json não encontrado em $SOURCE_MCP"
fi

if [ -f "$SOURCE_RULE" ]; then
    cp "$SOURCE_RULE" "$RULES_DIR/mcp_policy.md"
    echo "  [OK] $RULES_DIR/mcp_policy.md atualizado."
else
    echo "  [!] Arquivo fonte mcp_policy.md não encontrado em $SOURCE_RULE"
fi

# Copia templates globais de repomix e .antigravityignore
if [ -f "$SOURCE_REPOMIX" ]; then
    cp "$SOURCE_REPOMIX" "$DEST_DIR/repomix.config.json"
    echo "  [OK] $DEST_DIR/repomix.config.json atualizado."
fi

if [ -f "$SOURCE_IGNORE" ]; then
    cp "$SOURCE_IGNORE" "$DEST_DIR/.antigravityignore"
    echo "  [OK] $DEST_DIR/.antigravityignore atualizado."
fi

# Copia configurações globais de permissões e comportamento do usuário
SOURCE_CONFIG="$DOTFILES_DIR/home/dot_gemini/config/config.json"
if [ -f "$SOURCE_CONFIG" ]; then
    if [ ! -f "$DEST_DIR/config.json" ]; then
        cp "$SOURCE_CONFIG" "$DEST_DIR/config.json"
        echo "  [OK] $DEST_DIR/config.json instalado."
    fi
fi

echo "==> Verificando dependências necessárias (Node.js e npx)..."
if [ "$NPX_BIN" = "npx" ] && ! command -v npx &>/dev/null; then
    echo "  [AVISO] 'npx' não foi detectado no PATH."
    echo "  No Arch Linux, instale executando: sudo pacman -S nodejs npm"
elif [[ "$NPX_BIN" == /mnt/* ]]; then
    echo "  [AVISO] 'npx' detectado é do Windows ($NPX_BIN), o que causa erros no Linux."
    echo "  Instale o Node.js no Linux via Mise ('mise use -g node@lts') ou pelo gerenciador de pacotes."
else
    NODE_BIN="$(dirname "$NPX_BIN")/node"
    [ ! -x "$NODE_BIN" ] && NODE_BIN="node"
    echo "  [OK] Node/npx prontos: $($NODE_BIN -v 2>/dev/null || node -v) / npx $($NPX_BIN -v)"
fi

echo "==> Tudo pronto! O Antigravity já carregará os MCPs, Repomix e as regras de máxima economia de tokens."
