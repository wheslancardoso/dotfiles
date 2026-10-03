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

SOURCE_SKILLS="$DOTFILES_DIR/home/dot_gemini/config/skills.json"

if [ -f "$SOURCE_MCP" ]; then
    python3 - <<EOF
import json
import os

dest_file = "$DEST_DIR/mcp_config.json"
source_file = "$SOURCE_MCP"
npx_bin = "$NPX_BIN"
github_token = "$GITHUB_TOKEN"

dest_data = {"mcpServers": {}}
if os.path.exists(dest_file):
    try:
        with open(dest_file, "r", encoding="utf-8") as f:
            dest_data = json.load(f)
    except Exception as e:
        print(f"  [AVISO] Erro ao ler mcp_config existente: {e}")

try:
    with open(source_file, "r", encoding="utf-8") as f:
        source_data = json.load(f)
except Exception as e:
    print(f"  [ERRO] Falha ao ler fonte mcp_config: {e}")
    source_data = {"mcpServers": {}}

# Token do GitHub
if not github_token:
    existing_github = dest_data.get("mcpServers", {}).get("github", {})
    existing_token = existing_github.get("env", {}).get("GITHUB_PERSONAL_ACCESS_TOKEN", "")
    if existing_token and not existing_token.startswith("\${"):
        github_token = existing_token

merged_servers = dest_data.get("mcpServers", {})
for name, cfg in source_data.get("mcpServers", {}).items():
    cfg_copy = json.loads(json.dumps(cfg))
    if cfg_copy.get("command") == "npx":
        cfg_copy["command"] = npx_bin
    if name == "github":
        if github_token:
            cfg_copy.setdefault("env", {})["GITHUB_PERSONAL_ACCESS_TOKEN"] = github_token
        elif "\${GITHUB_PERSONAL_ACCESS_TOKEN}" in cfg_copy.get("env", {}).get("GITHUB_PERSONAL_ACCESS_TOKEN", ""):
            pass
    merged_servers[name] = cfg_copy

dest_data["mcpServers"] = merged_servers

with open(dest_file, "w", encoding="utf-8") as f:
    json.dump(dest_data, f, indent=2, ensure_ascii=False)
    f.write("\n")

print("  [OK] $DEST_DIR/mcp_config.json mesclado com sucesso (MCPs configurados).")
EOF
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

# Copia skills.json se existir
if [ -f "$SOURCE_SKILLS" ]; then
    cp "$SOURCE_SKILLS" "$DEST_DIR/skills.json"
    echo "  [OK] $DEST_DIR/skills.json sincronizado."
fi

# Sincroniza catálogo de skills para o diretório global
if [ -d "$DOTFILES_DIR/skills" ]; then
    mkdir -p "$DEST_DIR/skills"
    for skill_dir in "$DOTFILES_DIR/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name="$(basename "$skill_dir")"
            mkdir -p "$DEST_DIR/skills/$skill_name"
            cp -r "$skill_dir"/* "$DEST_DIR/skills/$skill_name/"
        fi
    done
    echo "  [OK] Skills sincronizadas para $DEST_DIR/skills."
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
