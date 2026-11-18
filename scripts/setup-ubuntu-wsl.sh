#!/usr/bin/env bash
# ==============================================================================
# Wrapper de compatibilidade -> redireciona para scripts/setup-ubuntu.sh
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

args=()
for arg in "$@"; do
    case "$arg" in
        --mise)
            args+=("--dev-stack")
            ;;
        all)
            ;;
        *)
            args+=("$arg")
            ;;
    esac
done

echo "[INFO] scripts/setup-ubuntu-wsl.sh agora é um wrapper para scripts/setup-ubuntu.sh."
exec "$SCRIPT_DIR/setup-ubuntu.sh" "${args[@]}"
