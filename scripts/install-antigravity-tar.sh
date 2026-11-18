#!/usr/bin/env bash
# ==============================================================================
# Instalador Idempotente do Antigravity (Tarball Oficial Linux x64)
# Instala em /opt/antigravity, cria symlinks em /usr/local/bin e .desktop Wayland.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
COMMON_SH="$DOTFILES_DIR/scripts/setup/common.sh"

if [ -f "$COMMON_SH" ]; then
    # shellcheck source=/dev/null
    source "$COMMON_SH"
else
    info() { printf "[INFO] %s\n" "$1"; }
    ok()   { printf "[OK] %s\n" "$1"; }
    warn() { printf "[WARN] %s\n" "$1"; }
    erro() { printf "[ERRO] %s\n" "$1"; exit 1; }
    has_cmd() { command -v "$1" >/dev/null 2>&1; }
fi

ANTIGRAVITY_URL="${ANTIGRAVITY_TAR_URL:-https://storage.googleapis.com/antigravity-public/antigravity-hub/2.33.0-4731201358004224/linux-x64/Antigravity.tar.gz}"
INSTALL_DIR="/opt/antigravity"
FORCE_INSTALL=false

for arg in "$@"; do
    case "$arg" in
        --force|-f) FORCE_INSTALL=true ;;
        --help|-h)
            cat << 'EOF'
Uso: ./scripts/install-antigravity-tar.sh [opções]
  --force, -f   Reinstala mesmo se /opt/antigravity já existir
  --help, -h    Mostra esta ajuda
EOF
            exit 0
            ;;
        *) warn "Argumento desconhecido ignorado: $arg" ;;
    esac
done

find_antigravity_bin() {
    local candidate
    for candidate in \
        "$INSTALL_DIR/antigravity" \
        "$INSTALL_DIR/Antigravity" \
        "$INSTALL_DIR/bin/antigravity"; do
        if [ -x "$candidate" ]; then
            echo "$candidate"
            return 0
        fi
    done
    return 1
}

if [ "$FORCE_INSTALL" = false ] && find_antigravity_bin >/dev/null 2>&1; then
    ok "Antigravity já instalado em $INSTALL_DIR (use --force para reinstalar)."
else
    if ! has_cmd curl; then
        erro "curl não encontrado para baixar o Antigravity."
    fi

    tmp_dir="$(mktemp -d "${HOME}/.cache/antigravity-tar.XXXXXX" 2>/dev/null || mktemp -d)"
    trap 'rm -rf "$tmp_dir"' EXIT
    tar_path="$tmp_dir/Antigravity.tar.gz"
    extract_dir="$tmp_dir/extract"
    mkdir -p "$extract_dir"

    info "Baixando Antigravity tarball oficial..."
    if ! curl -fL --retry 3 "$ANTIGRAVITY_URL" -o "$tar_path"; then
        warn "Falha ao baixar Antigravity de $ANTIGRAVITY_URL."
        exit 0
    fi

    info "Extraindo Antigravity em $INSTALL_DIR..."
    tar -xzf "$tar_path" -C "$extract_dir"

    # Detecta se o tarball tem subdiretório único (ex: Antigravity/) ou arquivos na raiz
    src_root="$extract_dir"
    mapfile -t top_entries < <(find "$extract_dir" -mindepth 1 -maxdepth 1)
    if [ ${#top_entries[@]} -eq 1 ] && [ -d "${top_entries[0]}" ]; then
        src_root="${top_entries[0]}"
    fi

    sudo rm -rf "$INSTALL_DIR"
    sudo mkdir -p "$INSTALL_DIR"
    sudo cp -a "$src_root"/. "$INSTALL_DIR"/
    ok "Antigravity extraído em $INSTALL_DIR."
fi

AGY_BIN="$(find_antigravity_bin || true)"
if [ -z "$AGY_BIN" ]; then
    warn "Binário executável do Antigravity não encontrado em $INSTALL_DIR."
    exit 0
fi

info "Criando symlinks e atalho .desktop (Wayland/Keyring)..."
sudo ln -sf "$AGY_BIN" /usr/local/bin/antigravity

# Cria /usr/local/bin/agy apenas se agy ainda não existir (não sobrescreve agy CLI standalone)
if ! has_cmd agy && [ ! -e /usr/local/bin/agy ]; then
    sudo ln -sf "$AGY_BIN" /usr/local/bin/agy
fi

icon_path="antigravity"
for icon_cand in \
    "$INSTALL_DIR/resources/app/resources/linux/code.png" \
    "$INSTALL_DIR/resources/app/out/media/code-icon.svg" \
    "$INSTALL_DIR/antigravity.png"; do
    if [ -f "$icon_cand" ]; then
        icon_path="$icon_cand"
        break
    fi
done

mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/antigravity.desktop" << EOF
[Desktop Entry]
Name=Antigravity
Comment=Antigravity AI IDE
GenericName=Text Editor
Exec=/usr/local/bin/antigravity --ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations --password-store=gnome-libsecret %F
Icon=$icon_path
Type=Application
StartupNotify=true
StartupWMClass=Antigravity
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;
Actions=new-empty-window;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=/usr/local/bin/antigravity --ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations --password-store=gnome-libsecret --new-window %F
EOF

ok "Antigravity pronto (/usr/local/bin/antigravity e antigravity.desktop)."
