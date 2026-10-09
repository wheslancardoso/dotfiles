#!/usr/bin/env bash
# ==============================================================================
# playwright-chrome-wsl.sh
# ------------------------------------------------------------------------------
# Abre navegador Chromium/Chrome visível no Windows via WSLg usando Playwright/Patchright.
# Mantém perfis persistentes, cookies e sessão salvos para automação e MCPs.
# ==============================================================================

set -eo pipefail

# 1. Garantir variáveis de ambiente do WSLg para exibição gráfica
export DISPLAY="${DISPLAY:-:0}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/mnt/wslg/runtime-dir}"
export PULSE_SERVER="${PULSE_SERVER:-/mnt/wslg/PulseServer}"

# 2. Configurar NODE_PATH para encontrar pacotes globais do npm/mise
NPM_GLOBAL_ROOT="$(npm root -g 2>/dev/null || true)"
if [ -n "$NPM_GLOBAL_ROOT" ]; then
    export NODE_PATH="${NPM_GLOBAL_ROOT}:${NODE_PATH:-}"
fi

# Diretórios padrão
DEFAULT_DATA_DIR="$HOME/.local/share/playwright-wsl"
DEFAULT_PROFILE="$DEFAULT_DATA_DIR/profiles/default"
NOTEBOOKLM_PROFILE="$HOME/.local/share/notebooklm-mcp/chrome_profile"
NOTEBOOKLM_STATE="$HOME/.local/share/notebooklm-mcp/browser_state/state.json"

show_help() {
    cat << 'EOF'
🚀 Playwright Chrome WSLg Runner

Uso:
  playwright-chrome [URL] [OPÇÕES]
  chrome-wsl [URL] [OPÇÕES]

Exemplos:
  playwright-chrome https://google.com
  playwright-chrome https://github.com --profile github
  playwright-chrome --auth-notebooklm
  playwright-chrome https://site.com --export-state cookies.json

Opções:
  -u, --url <URL>           URL inicial (padrão: https://google.com)
  -p, --profile <DIR|NOME>  Diretório ou nome do perfil persistente
  -e, --export-state <ARQ>  Exporta cookies/localStorage ao fechar para arquivo JSON
  --auth-notebooklm         Abre direto o perfil do MCP NotebookLM e sincroniza cookies
  --headless                Executa sem interface gráfica (modo headless)
  -h, --help                Exibe esta ajuda

EOF
}

# Defaults
TARGET_URL="https://google.com"
PROFILE_PATH="$DEFAULT_PROFILE"
EXPORT_STATE=""
HEADLESS="false"
IS_NOTEBOOKLM="false"

# Parsing de argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        --auth-notebooklm)
            IS_NOTEBOOKLM="true"
            TARGET_URL="https://notebooklm.google.com"
            PROFILE_PATH="$NOTEBOOKLM_PROFILE"
            EXPORT_STATE="$NOTEBOOKLM_STATE"
            shift
            ;;
        -u|--url)
            TARGET_URL="$2"
            shift 2
            ;;
        -p|--profile)
            if [[ "$2" = /* ]]; then
                PROFILE_PATH="$2"
            else
                PROFILE_PATH="$DEFAULT_DATA_DIR/profiles/$2"
            fi
            shift 2
            ;;
        -e|--export-state)
            EXPORT_STATE="$2"
            shift 2
            ;;
        --headless)
            HEADLESS="true"
            shift
            ;;
        http*://*)
            TARGET_URL="$1"
            shift
            ;;
        *)
            echo "⚠️  Argumento desconhecido: $1"
            show_help
            exit 1
            ;;
    esac
done

mkdir -p "$PROFILE_PATH"
if [ -n "$EXPORT_STATE" ]; then
    mkdir -p "$(dirname "$EXPORT_STATE")"
fi

echo "=========================================================="
echo "🌐 Playwright Chrome WSLg"
echo "  URL:     $TARGET_URL"
echo "  Perfil:  $PROFILE_PATH"
echo "  Display: $DISPLAY ($WAYLAND_DISPLAY)"
echo "  Modo:    $([ "$HEADLESS" = "true" ] && echo "Headless" || echo "Janela Gráfica (WSLg)")"
if [ -n "$EXPORT_STATE" ]; then
echo "  Export:  $EXPORT_STATE"
fi
echo "=========================================================="
echo "💡 Feche a janela do navegador ou pressione Ctrl+C para encerrar e salvar a sessão."

node - << NODE_SCRIPT
const fs = require('fs');
const path = require('path');

let pw;
try {
    pw = require('patchright');
} catch (e1) {
    try {
        pw = require('playwright');
    } catch (e2) {
        console.error('❌ Nem patchright nem playwright foram encontrados no Node.');
        console.error('   Execute: npm install -g patchright');
        process.exit(1);
    }
}

const { chromium } = pw;

(async () => {
    const profilePath = '$PROFILE_PATH';
    const targetUrl = '$TARGET_URL';
    const headless = $HEADLESS;
    const exportState = '$EXPORT_STATE';
    const isNotebooklm = $IS_NOTEBOOKLM;

    const launchArgs = [
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--disable-blink-features=AutomationControlled',
        '--no-first-run',
        '--no-default-browser-check'
    ];

    const context = await chromium.launchPersistentContext(profilePath, {
        headless: headless,
        viewport: null, // Tamanho nativo da janela
        args: launchArgs
    });

    const page = context.pages().length > 0 ? context.pages()[0] : await context.newPage();

    try {
        await page.goto(targetUrl, { waitUntil: 'domcontentloaded', timeout: 45000 });
    } catch (err) {
        console.log('⚠️  Aviso no carregamento inicial:', err.message);
    }

    console.log('✅ Janela aberta com sucesso! Navegue livremente.');

    // Função de encerramento seguro e salvamento
    let isCleanedUp = false;
    async function cleanup() {
        if (isCleanedUp) return;
        isCleanedUp = true;
        console.log('\n💾 Salvando sessão e cookies...');

        if (exportState) {
            try {
                await context.storageState({ path: exportState });
                console.log('✅ Estado salvo com sucesso em:', exportState);
                // Atualizar mtime para evitar expiração prematura no MCP
                const now = new Date();
                fs.utimesSync(exportState, now, now);
            } catch (err) {
                console.error('⚠️  Falha ao salvar storageState:', err.message);
            }
        }

        try {
            await context.close();
        } catch (_) {}

        console.log('👋 Navegador encerrado com segurança.');
        process.exit(0);
    }

    // Monitorar fechamento da página pelo usuário
    page.on('close', async () => {
        await cleanup();
    });

    // Monitorar sinais do terminal (Ctrl+C)
    process.on('SIGINT', async () => {
        await cleanup();
    });
    process.on('SIGTERM', async () => {
        await cleanup();
    });

    // Manter processo ativo enquanto houver páginas abertas
    await new Promise(() => {});
})().catch(err => {
    console.error('❌ Erro fatal:', err);
    process.exit(1);
});
NODE_SCRIPT
