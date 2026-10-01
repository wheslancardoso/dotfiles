#!/usr/bin/env bash
# ==============================================================================
# Setup Antigravity AI MCP Servers & Efficiency Rules
# Compatível com Arch Linux e Ubuntu/WSL
# ==============================================================================
set -euo pipefail

DEST_DIR="$HOME/.gemini/config"
RULES_DIR="$DEST_DIR/rules"

echo "==> Configurando Antigravity AI (MCP + Regras Globais)..."

mkdir -p "$RULES_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

SOURCE_MCP="$DOTFILES_DIR/home/dot_gemini/config/mcp_config.json"
SOURCE_RULE="$DOTFILES_DIR/home/dot_gemini/config/rules/mcp_policy.md"

# Obtém token do ambiente ou mantém o já configurado se existir
GITHUB_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-${GITHUB_TOKEN:-}}"

if [ -f "$SOURCE_MCP" ]; then
    if [ -n "$GITHUB_TOKEN" ]; then
        sed "s|\${GITHUB_PERSONAL_ACCESS_TOKEN}|$GITHUB_TOKEN|g" "$SOURCE_MCP" > "$DEST_DIR/mcp_config.json"
        echo "  [OK] $DEST_DIR/mcp_config.json configurado com seu GITHUB_TOKEN."
    else
        # Se já existe um token real configurado localmente no destino, preserva-o
        if [ -f "$DEST_DIR/mcp_config.json" ] && grep -q "ghp_" "$DEST_DIR/mcp_config.json"; then
            CURRENT_TOKEN=$(grep -o 'ghp_[A-Za-z0-9_]*' "$DEST_DIR/mcp_config.json" | head -n 1)
            sed "s|\${GITHUB_PERSONAL_ACCESS_TOKEN}|$CURRENT_TOKEN|g" "$SOURCE_MCP" > "$DEST_DIR/mcp_config.json"
            echo "  [OK] $DEST_DIR/mcp_config.json atualizado mantendo o token local existente."
        else
            cp "$SOURCE_MCP" "$DEST_DIR/mcp_config.json"
            echo "  [OK] $DEST_DIR/mcp_config.json copiado (lembre de definir GITHUB_PERSONAL_ACCESS_TOKEN ou editar o arquivo)."
        fi
    fi
else
    echo "  [!] Arquivo fonte mcp_config.json não encontrado em $SOURCE_MCP"
fi

if [ -f "$SOURCE_RULE" ]; then
    cp "$SOURCE_RULE" "$RULES_DIR/mcp_policy.md"
    echo "  [OK] $RULES_DIR/mcp_policy.md atualizado."
else
    echo "  [!] Arquivo fonte mcp_policy.md não encontrado em $SOURCE_RULE"
fi

echo "==> Verificando dependências necessárias (Node.js e npx)..."
if ! command -v npx &>/dev/null; then
    echo "  [AVISO] 'npx' não foi detectado no PATH."
    echo "  No Arch Linux, instale executando: sudo pacman -S nodejs npm"
else
    echo "  [OK] Node/npx prontos: $(node -v) / npx $(npx -v)"
fi

echo "==> Tudo pronto! O Antigravity já carregará os MCPs e as regras globais."
