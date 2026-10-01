#!/usr/bin/env bash
# ==============================================================================
# Sincroniza configurações do Antigravity (MCP + Regras + Templates)
# do WSL para o ambiente nativo do Windows (C:\Users\wheslan.quintanilha\.gemini)
# ==============================================================================
set -euo pipefail

WIN_USER="wheslan.quintanilha"
WIN_GEMINI_DIR="/mnt/c/Users/$WIN_USER/.gemini"
WIN_CONFIG_DIR="$WIN_GEMINI_DIR/config"
WIN_RULES_DIR="$WIN_CONFIG_DIR/rules"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

SOURCE_MCP="$DOTFILES_DIR/home/dot_gemini/config/mcp_config.json"
SOURCE_RULE="$DOTFILES_DIR/home/dot_gemini/config/rules/mcp_policy.md"
SOURCE_REPOMIX="$DOTFILES_DIR/home/dot_gemini/config/repomix.config.json"
SOURCE_IGNORE="$DOTFILES_DIR/home/dot_gemini/config/.antigravityignore"
WSL_MCP_CONFIG="$HOME/.gemini/config/mcp_config.json"

echo "==> Sincronizando Antigravity do WSL para o Windows ($WIN_CONFIG_DIR)..."

if [ ! -d "$WIN_CONFIG_DIR" ]; then
    echo "  [ERRO] Diretório do Windows não encontrado: $WIN_CONFIG_DIR"
    exit 1
fi

mkdir -p "$WIN_RULES_DIR"

# 1. Copia regras e templates
cp "$SOURCE_RULE" "$WIN_RULES_DIR/mcp_policy.md"
echo "  [OK] Regras globais atualizadas em: $WIN_RULES_DIR/mcp_policy.md"

if [ -f "$SOURCE_REPOMIX" ]; then
    cp "$SOURCE_REPOMIX" "$WIN_CONFIG_DIR/repomix.config.json"
    echo "  [OK] repomix.config.json sincronizado com o Windows."
fi

if [ -f "$SOURCE_IGNORE" ]; then
    cp "$SOURCE_IGNORE" "$WIN_CONFIG_DIR/.antigravityignore"
    echo "  [OK] .antigravityignore sincronizado com o Windows."
fi

# 2. Mescla mcp_config.json preservando servidores existentes do Windows (ex: datacloud/notebooks)
python3 - <<EOF
import json
import os

win_mcp_file = "$WIN_CONFIG_DIR/mcp_config.json"
wsl_mcp_file = "$WSL_MCP_CONFIG"
source_mcp_file = "$SOURCE_MCP"

win_data = {"mcpServers": {}}
if os.path.exists(win_mcp_file):
    try:
        with open(win_mcp_file, "r", encoding="utf-8") as f:
            win_data = json.load(f)
    except Exception as e:
        print(f"  [AVISO] Erro ao ler mcp_config do Windows: {e}")

# Base dos nossos servidores do WSL
wsl_data = {}
try:
    with open(wsl_mcp_file, "r", encoding="utf-8") as f:
        wsl_data = json.load(f)
except Exception:
    with open(source_mcp_file, "r", encoding="utf-8") as f:
        wsl_data = json.load(f)

# Mescla: Mantém os do Windows e adiciona/atualiza os nossos
merged_servers = win_data.get("mcpServers", {})
for server_name, server_cfg in wsl_data.get("mcpServers", {}).items():
    # No Windows, npx roda nativamente via npx.cmd
    cfg_copy = json.loads(json.dumps(server_cfg))
    if cfg_copy.get("command") == "npx":
        cfg_copy["command"] = "npx.cmd"
    merged_servers[server_name] = cfg_copy

win_data["mcpServers"] = merged_servers

with open(win_mcp_file, "w", encoding="utf-8") as f:
    json.dump(win_data, f, indent=2, ensure_ascii=False)

print("  [OK] mcp_config.json do Windows mesclado com sucesso!")
EOF

echo "==> Concluído! O Antigravity IDE e o Antigravity App 2.0 no Windows já estão sincronizados."
