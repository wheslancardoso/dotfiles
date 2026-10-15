#!/usr/bin/env bash
# ==============================================================================
# REA WRAPPER - REVERSE ENGINEER ANYTHING (DOTFILES TOOLKIT)
# Repositório clonado e compilado localmente em: /home/lanwsl/projetos/rea
# ==============================================================================
set -euo pipefail

REA_LOCAL_DIR="/home/lanwsl/projetos/rea"
REA_BIN="${REA_LOCAL_DIR}/scripts/rea.mjs"

if [[ ! -f "$REA_BIN" ]]; then
    echo "⚠️ Runtime local do REA não encontrado em $REA_BIN. Usando npx..." >&2
    exec npx --yes rea-agents@latest "$@"
fi

# Executa diretamente o binário local compilado sem overhead de rede
case "${1:-}" in
    sqlite)
        shift
        exec node "$REA_BIN" inspect-sqlite-database "$@"
        ;;
    electron|asar)
        shift
        exec node "$REA_BIN" inspect-electron-package "$@"
        ;;
    apk|android)
        shift
        exec node "$REA_BIN" inspect-android-package "$@"
        ;;
    elf|bin)
        shift
        exec node "$REA_BIN" inspect-elf-binary "$@"
        ;;
    mcp)
        exec node "$REA_BIN" --mcp
        ;;
    help|--help|-h|"")
        echo "🔬 REA - Reverse Engineer Anything (Local Repo Build: ${REA_LOCAL_DIR})"
        echo ""
        echo "Uso rápido:"
        echo "  rea sqlite <arquivo.db>       - Inspecionar banco SQLite"
        echo "  rea electron <app.asar>      - Desmontar app Electron"
        echo "  rea apk <app.apk>            - Inspecionar APK Android"
        echo "  rea elf <binario>            - Dissecar binário ELF Linux"
        echo "  rea mcp                      - Iniciar como servidor MCP stdio"
        echo "  rea <qualquer-comando-rea>   - Executar comando nativo do REA"
        echo ""
        exec node "$REA_BIN" --help
        ;;
    *)
        exec node "$REA_BIN" "$@"
        ;;
esac
