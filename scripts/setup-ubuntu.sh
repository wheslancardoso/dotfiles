#!/usr/bin/env bash
# ==============================================================================
# Instalador Completo para Ubuntu 26.04 (Nativo e WSL2) / Debian-based
# Mantém paridade com os módulos Arch Linux (scripts/setup/*.sh)
# ==============================================================================

set -euo pipefail

export DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$DOTFILES_DIR/scripts/setup/common.sh"

export NON_INTERACTIVE=false
export PROFILE="full"
export WITH_DESKTOP=false
STEP="all"

for arg in "$@"; do
    case "$arg" in
        --non-interactive|-y|--yes)
            NON_INTERACTIVE=true
            ;;
        --profile=*)
            PROFILE="${arg#*=}"
            ;;
        --dev)
            PROFILE="dev"
            ;;
        --full)
            PROFILE="full"
            ;;
        --with-desktop)
            WITH_DESKTOP=true
            ;;
        --system|--cli|--dev-stack|--dotfiles|--zsh|--desktop)
            STEP="${arg#--}"
            ;;
        --help|-h)
            cat << 'EOF'
Uso: ./scripts/setup-ubuntu.sh [opções]
  --non-interactive, -y   Executa sem prompts interativos
  --profile=dev|full      Define o perfil (padrão: full no Ubuntu nativo, dev no WSL)
  --dev                   Atalho para --profile=dev
  --full                  Atalho para --profile=full
  --with-desktop          Habilita pacotes Wayland/desktop mesmo no WSL (ou força no nativo)
  --system                Executa apenas atualização APT e pacotes base
  --cli                   Executa apenas instalação de ferramentas CLI/TUI modernas
  --dev-stack             Executa apenas stack dev (mise, uv, rustup, docker)
  --dotfiles              Executa apenas chezmoi + pastas lowercase
  --zsh                   Executa apenas Zsh, Oh My Zsh, yazi padrão e LazyVim sync
  --desktop               Executa apenas módulo desktop Wayland (Ubuntu nativo)
  --help, -h              Mostra esta ajuda
EOF
            exit 0
            ;;
        *)
            warn "Argumento desconhecido ignorado: $arg"
            ;;
    esac
done

[ ! -t 0 ] && NON_INTERACTIVE=true

export IS_WSL=false
if [ -n "${WSL_DISTRO_NAME:-}" ] || grep -qiE "microsoft|wsl" /proc/version 2>/dev/null; then
    IS_WSL=true
fi

if [ "$IS_WSL" = true ] && [ "$WITH_DESKTOP" = false ] && [ "$PROFILE" = "full" ]; then
    PROFILE="dev"
fi

DISTRO_ID="ubuntu"
VERSION_ID="unknown"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID="${ID:-ubuntu}"
    VERSION_ID="${VERSION_ID:-unknown}"
fi

ARCH_UNAME="$(uname -m)"
case "$ARCH_UNAME" in
    x86_64|amd64)
        ARCH_RUST="x86_64"
        ARCH_DEB="amd64"
        ARCH_NVIM="x86_64"
        ;;
    aarch64|arm64)
        ARCH_RUST="aarch64"
        ARCH_DEB="arm64"
        ARCH_NVIM="arm64"
        ;;
    *)
        erro "Arquitetura não suportada: $ARCH_UNAME"
        ;;
esac

BIN_DIR="$HOME/.local/bin"
SHARE_DIR="$HOME/.local/share"
mkdir -p "$BIN_DIR" "$SHARE_DIR"
export PATH="$BIN_DIR:$HOME/.cargo/bin:$PATH"

info "Ambiente Ubuntu/Debian: distro=$DISTRO_ID ($VERSION_ID) | arch=$ARCH_UNAME | IS_WSL=$IS_WSL | PROFILE=$PROFILE | WITH_DESKTOP=$WITH_DESKTOP"

# Sudo keep-alive
if sudo -n true 2>/dev/null || [ "$NON_INTERACTIVE" = false ]; then
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
else
    warn "Sudo sem senha não está ativo em modo não-interativo; etapas que exigem root podem falhar."
fi

# Instala pacotes APT apenas se existirem nos repositórios configurados
apt_install_available() {
    local available=()
    local pkg
    for pkg in "$@"; do
        if apt-cache show "$pkg" >/dev/null 2>&1; then
            available+=("$pkg")
        else
            warn "Pacote APT indisponível nesta versão do repositório: $pkg"
        fi
    done
    if [ "${#available[@]}" -gt 0 ]; then
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${available[@]}"
    fi
}

# Resolve tag mais recente de um repositório GitHub (com fallback)
github_latest_tag() {
    local repo="$1"
    local fallback="$2"
    local tag
    tag=$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" 2>/dev/null | jq -r '.tag_name // empty' 2>/dev/null || true)
    if [ -n "$tag" ]; then
        printf '%s\n' "$tag"
    else
        printf '%s\n' "$fallback"
    fi
}

# --- 1. Atualização APT e Dependências Base ---
setup_apt_base() {
    info "Atualizando índices APT e instalando dependências base..."
    sudo apt-get update -y
    if [ "$NON_INTERACTIVE" = true ]; then
        sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y || warn "apt-get upgrade retornou aviso."
    fi

    apt_install_available \
        git \
        curl \
        wget \
        build-essential \
        cmake \
        pkg-config \
        unzip \
        zip \
        tar \
        gzip \
        xz-utils \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common \
        jq \
        sqlite3 \
        libsqlite3-dev \
        libssl-dev \
        libffi-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        zsh \
        fish \
        procps \
        net-tools \
        python3-pip \
        pipx \
        aria2 \
        xdg-utils \
        file \
        ffmpeg \
        poppler-utils \
        imagemagick \
        7zip \
        p7zip-full

    # Ferramentas CLI modernas disponíveis no APT do Ubuntu 26.04
    apt_install_available \
        ripgrep \
        fd-find \
        bat \
        fzf \
        eza \
        zoxide \
        git-delta \
        fastfetch

    ok "Dependências base e pacotes APT instalados."
}

# --- 2. Ferramentas CLI/TUI Modernas ---
setup_modern_cli() {
    info "Configurando ferramentas CLI/TUI modernas em $BIN_DIR..."

    # Symlinks de compatibilidade Ubuntu/Debian (fdfind -> fd, batcat -> bat)
    if has_cmd fdfind && ! has_cmd fd; then
        ln -sfn "$(command -v fdfind)" "$BIN_DIR/fd"
        ok "Symlink criado: fd -> fdfind"
    fi
    if has_cmd batcat && ! has_cmd bat; then
        ln -sfn "$(command -v batcat)" "$BIN_DIR/bat"
        ok "Symlink criado: bat -> batcat"
    fi

    # Chezmoi
    if ! has_cmd chezmoi; then
        info "Instalando chezmoi..."
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$BIN_DIR"
        ok "chezmoi instalado."
    else
        ok "chezmoi já instalado."
    fi

    # Neovim 0.10+ (Release oficial para garantir compatibilidade com LazyVim)
    local need_nvim=false
    if ! has_cmd nvim; then
        need_nvim=true
    else
        local nvim_ver
        nvim_ver="$(nvim --version | head -n 1 || true)"
        if [[ "$nvim_ver" =~ v0\.[0-9]\. ]]; then
            need_nvim=true
        fi
    fi

    if [ "$need_nvim" = true ]; then
        info "Instalando Neovim (release oficial Linux $ARCH_NVIM)..."
        local nvim_tmp
        nvim_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH_NVIM}.tar.gz" -o "${nvim_tmp}/nvim.tar.gz"
        rm -rf "${SHARE_DIR}/nvim-linux-${ARCH_NVIM}"
        tar -xzf "${nvim_tmp}/nvim.tar.gz" -C "$SHARE_DIR"
        ln -sfn "${SHARE_DIR}/nvim-linux-${ARCH_NVIM}/bin/nvim" "$BIN_DIR/nvim"
        rm -rf "$nvim_tmp"
        ok "Neovim instalado: $(nvim --version | head -n 1)"
    else
        ok "Neovim já adequado: $(nvim --version | head -n 1)"
    fi

    # Starship
    if ! has_cmd starship; then
        info "Instalando starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$BIN_DIR"
        ok "starship instalado."
    else
        ok "starship já instalado."
    fi

    # Zoxide (fallback caso não tenha vindo pelo APT)
    if ! has_cmd zoxide; then
        info "Instalando zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | BIN_DIR="$BIN_DIR" bash
        ok "zoxide instalado."
    fi

    # Eza (fallback caso não tenha vindo pelo APT)
    if ! has_cmd eza; then
        info "Instalando eza (release oficial)..."
        local eza_tag eza_tmp
        eza_tag=$(github_latest_tag "eza-community/eza" "v0.20.19")
        eza_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/eza-community/eza/releases/download/${eza_tag}/eza_${ARCH_RUST}-unknown-linux-gnu.tar.gz" -o "${eza_tmp}/eza.tar.gz" \
            || curl -fsSL "https://github.com/eza-community/eza/releases/download/${eza_tag}/eza_${ARCH_RUST}-unknown-linux-musl.tar.gz" -o "${eza_tmp}/eza.tar.gz"
        tar -xzf "${eza_tmp}/eza.tar.gz" -C "$eza_tmp"
        cp "${eza_tmp}/eza" "$BIN_DIR/eza"
        chmod +x "$BIN_DIR/eza"
        rm -rf "$eza_tmp"
        ok "eza instalado."
    fi

    # Bat (fallback caso não tenha vindo pelo APT)
    if ! has_cmd bat; then
        info "Instalando bat (release oficial)..."
        local bat_tag bat_tmp
        bat_tag=$(github_latest_tag "sharkdp/bat" "v0.25.0")
        bat_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/sharkdp/bat/releases/download/${bat_tag}/bat-${bat_tag}-${ARCH_RUST}-unknown-linux-musl.tar.gz" -o "${bat_tmp}/bat.tar.gz"
        tar -xzf "${bat_tmp}/bat.tar.gz" -C "$bat_tmp"
        cp "${bat_tmp}/bat-${bat_tag}-${ARCH_RUST}-unknown-linux-musl/bat" "$BIN_DIR/bat"
        chmod +x "$BIN_DIR/bat"
        rm -rf "$bat_tmp"
        ok "bat instalado."
    fi

    # Tema Catppuccin Mocha para bat
    if has_cmd bat; then
        local bat_themes_dir
        bat_themes_dir="$(bat --config-dir)/themes"
        if [ ! -f "${bat_themes_dir}/Catppuccin Mocha.tmTheme" ]; then
            mkdir -p "$bat_themes_dir"
            curl -fsSL "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme" -o "${bat_themes_dir}/Catppuccin Mocha.tmTheme" 2>/dev/null || true
            bat cache --build 2>/dev/null || true
        fi
    fi

    # Fd (fallback)
    if ! has_cmd fd; then
        info "Instalando fd (release oficial)..."
        local fd_tag fd_tmp
        fd_tag=$(github_latest_tag "sharkdp/fd" "v10.2.0")
        fd_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/sharkdp/fd/releases/download/${fd_tag}/fd-${fd_tag}-${ARCH_RUST}-unknown-linux-musl.tar.gz" -o "${fd_tmp}/fd.tar.gz"
        tar -xzf "${fd_tmp}/fd.tar.gz" -C "$fd_tmp"
        cp "${fd_tmp}/fd-${fd_tag}-${ARCH_RUST}-unknown-linux-musl/fd" "$BIN_DIR/fd"
        chmod +x "$BIN_DIR/fd"
        rm -rf "$fd_tmp"
        ok "fd instalado."
    fi

    # Ripgrep (fallback)
    if ! has_cmd rg; then
        info "Instalando ripgrep (release oficial)..."
        local rg_tag rg_tmp
        rg_tag=$(github_latest_tag "BurntSushi/ripgrep" "14.1.1")
        rg_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/BurntSushi/ripgrep/releases/download/${rg_tag}/ripgrep-${rg_tag}-${ARCH_RUST}-unknown-linux-musl.tar.gz" -o "${rg_tmp}/rg.tar.gz"
        tar -xzf "${rg_tmp}/rg.tar.gz" -C "$rg_tmp"
        cp "${rg_tmp}/ripgrep-${rg_tag}-${ARCH_RUST}-unknown-linux-musl/rg" "$BIN_DIR/rg"
        chmod +x "$BIN_DIR/rg"
        rm -rf "$rg_tmp"
        ok "ripgrep instalado."
    fi

    # FZF (fallback)
    if ! has_cmd fzf; then
        info "Instalando fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --bin --no-update-rc
        ln -sfn "$HOME/.fzf/bin/fzf" "$BIN_DIR/fzf"
        ok "fzf instalado."
    fi

    # Zellij (release oficial)
    if ! has_cmd zellij; then
        info "Instalando zellij (release oficial)..."
        local zj_tag zj_tmp
        zj_tag=$(github_latest_tag "zellij-org/zellij" "v0.41.2")
        zj_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/zellij-org/zellij/releases/download/${zj_tag}/zellij-${ARCH_RUST}-unknown-linux-musl.tar.gz" -o "${zj_tmp}/zellij.tar.gz"
        tar -xzf "${zj_tmp}/zellij.tar.gz" -C "$zj_tmp"
        cp "${zj_tmp}/zellij" "$BIN_DIR/zellij"
        chmod +x "$BIN_DIR/zellij"
        rm -rf "$zj_tmp"
        ok "zellij instalado."
    else
        ok "zellij já instalado."
    fi

    # Yazi (release oficial; fallback via cargo se necessário)
    if ! has_cmd yazi; then
        info "Instalando yazi (release oficial)..."
        local yz_tag yz_tmp
        yz_tag=$(github_latest_tag "sxyazi/yazi" "v25.4.8")
        yz_tmp=$(mktemp -d)
        if curl -fsSL "https://github.com/sxyazi/yazi/releases/download/${yz_tag}/yazi-${ARCH_RUST}-unknown-linux-musl.zip" -o "${yz_tmp}/yazi.zip" \
            || curl -fsSL "https://github.com/sxyazi/yazi/releases/download/${yz_tag}/yazi-${ARCH_RUST}-unknown-linux-gnu.zip" -o "${yz_tmp}/yazi.zip"; then
            unzip -q "${yz_tmp}/yazi.zip" -d "$yz_tmp"
            local yz_dir
            yz_dir=$(find "$yz_tmp" -maxdepth 1 -type d -name "yazi-*" | head -n 1)
            cp "${yz_dir}/yazi" "$BIN_DIR/yazi"
            [ -f "${yz_dir}/ya" ] && cp "${yz_dir}/ya" "$BIN_DIR/ya"
            chmod +x "$BIN_DIR/yazi"
            [ -f "$BIN_DIR/ya" ] && chmod +x "$BIN_DIR/ya"
            ok "yazi instalado via release oficial."
        else
            warn "Download de release do yazi falhou; será tentado via cargo após rustup se disponível."
        fi
        rm -rf "$yz_tmp"
    else
        ok "yazi já instalado."
    fi

    # Lazygit
    if ! has_cmd lazygit; then
        info "Instalando lazygit..."
        local lg_tag lg_ver lg_arch lg_tmp
        lg_tag=$(github_latest_tag "jesseduffield/lazygit" "v0.44.1")
        lg_ver="${lg_tag#v}"
        lg_arch="x86_64"
        [ "$ARCH_DEB" = "arm64" ] && lg_arch="arm64"
        lg_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/${lg_tag}/lazygit_${lg_ver}_Linux_${lg_arch}.tar.gz" -o "${lg_tmp}/lazygit.tar.gz"
        tar -xzf "${lg_tmp}/lazygit.tar.gz" -C "$lg_tmp"
        cp "${lg_tmp}/lazygit" "$BIN_DIR/lazygit"
        chmod +x "$BIN_DIR/lazygit"
        rm -rf "$lg_tmp"
        ok "lazygit instalado."
    fi

    # Lazydocker
    if ! has_cmd lazydocker; then
        info "Instalando lazydocker..."
        local ld_tag ld_ver ld_arch ld_tmp
        ld_tag=$(github_latest_tag "jesseduffield/lazydocker" "v0.24.1")
        ld_ver="${ld_tag#v}"
        ld_arch="x86_64"
        [ "$ARCH_DEB" = "arm64" ] && ld_arch="arm64"
        ld_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/jesseduffield/lazydocker/releases/download/${ld_tag}/lazydocker_${ld_ver}_Linux_${ld_arch}.tar.gz" -o "${ld_tmp}/lazydocker.tar.gz"
        tar -xzf "${ld_tmp}/lazydocker.tar.gz" -C "$ld_tmp"
        cp "${ld_tmp}/lazydocker" "$BIN_DIR/lazydocker"
        chmod +x "$BIN_DIR/lazydocker"
        rm -rf "$ld_tmp"
        ok "lazydocker instalado."
    fi

    ok "Ferramentas CLI/TUI modernas configuradas."
}

# --- 3. Stack Dev: rustup, uv, mise, docker ---
setup_dev_stack() {
    info "Configurando stack de desenvolvimento (rustup, uv, mise, docker)..."

    # Rustup
    if ! has_cmd rustup; then
        info "Instalando rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        export PATH="$HOME/.cargo/bin:$PATH"
        ok "rustup instalado."
    fi
    if has_cmd rustup && ! rustup show active-toolchain >/dev/null 2>&1; then
        info "Inicializando toolchain Rust (stable)..."
        rustup default stable 2>/dev/null || warn "Falha ao inicializar rustup."
    fi

    # Fallback de yazi via cargo caso o download de release tenha falhado
    if ! has_cmd yazi && has_cmd cargo; then
        info "Instalando yazi via cargo..."
        cargo install --locked yazi-fm yazi-cli || warn "Falha ao compilar yazi via cargo."
    fi

    # uv (Astral Python package/project manager)
    if ! has_cmd uv; then
        info "Instalando uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        ok "uv instalado."
    else
        ok "uv já instalado."
    fi

    # mise (node, python, go, bun, java, pnpm)
    if ! has_cmd mise; then
        info "Instalando mise..."
        curl -fsSL https://mise.run | sh
        ok "mise instalado."
    else
        ok "mise já instalado."
    fi

    if has_cmd mise; then
        mkdir -p "$HOME/.config/mise"
        if [ -f "$DOTFILES_DIR/home/dot_config/mise/config.toml" ] && [ ! -e "$HOME/.config/mise/config.toml" ]; then
            ln -sf "$DOTFILES_DIR/home/dot_config/mise/config.toml" "$HOME/.config/mise/config.toml"
        fi
        info "Instalando runtimes via mise (node, python, go, bun, java, pnpm)..."
        mise use --global node@lts python@3.12 go@latest bun@latest java@openjdk-17 pnpm@latest 2>/dev/null \
            || mise install -y 2>/dev/null \
            || warn "Algum runtime do mise falhou; verifique posteriormente com 'mise install'."
        ok "Runtimes mise configurados."
    fi

    # Docker: nativo instala docker.io + systemd; no WSL orienta Docker Desktop ou systemd
    if [ "$IS_WSL" = false ]; then
        if ! has_cmd docker; then
            info "Instalando Docker Engine (docker.io + docker-compose-v2) no Ubuntu nativo..."
            apt_install_available docker.io docker-compose-v2
        fi
        if has_cmd docker; then
            sudo usermod -aG docker "$USER" 2>/dev/null || true
            if has_systemd; then
                sudo systemctl enable --now docker.service 2>/dev/null || true
                sudo systemctl enable --now docker.socket 2>/dev/null || true
            fi
            ok "Docker configurado para o usuário $USER."
        fi
    else
        if has_cmd docker; then
            ok "Docker já acessível no WSL (provavelmente via Docker Desktop Integration)."
        else
            warn "WSL detectado sem Docker ativo. Recomendado: habilite 'WSL 2 Integration' no Docker Desktop do Windows."
            warn "Alternativamente, se usar systemd no WSL, execute: sudo apt-get install -y docker.io docker-compose-v2 && sudo usermod -aG docker \$USER"
        fi
    fi
}

# --- 4. Dotfiles via Chezmoi + Pastas da Home em Minúsculo ---
setup_dotfiles_and_dirs() {
    if ! has_cmd chezmoi; then
        erro "chezmoi não encontrado. Instale-o antes de aplicar os dotfiles."
    fi

    info "Aplicando dotfiles via chezmoi (source: $DOTFILES_DIR)..."
    mkdir -p "$HOME/.config/chezmoi"
    chezmoi init --apply --force --source "$DOTFILES_DIR"
    ok "Dotfiles aplicados com sucesso."

    info "Configurando diretórios da home em minúsculo..."
    local dirs=(
        "desktop"
        "downloads"
        "documentos"
        "imagens"
        "videos"
        "musica"
        "modelos"
        "publico"
        "projetos"
    )
    local d
    for d in "${dirs[@]}"; do
        mkdir -p "$HOME/$d"
    done

    mkdir -p "$HOME/.config"
    printf "enabled=False\n" > "$HOME/.config/user-dirs.conf"

    if [ ! -f "$HOME/.config/user-dirs.dirs" ]; then
        cat > "$HOME/.config/user-dirs.dirs" << 'EOF'
XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_TEMPLATES_DIR="$HOME/modelos"
XDG_PUBLICSHARE_DIR="$HOME/publico"
XDG_DOCUMENTS_DIR="$HOME/documentos"
XDG_MUSIC_DIR="$HOME/musica"
XDG_PICTURES_DIR="$HOME/imagens"
XDG_VIDEOS_DIR="$HOME/videos"
EOF
    fi
    ok "Diretórios lowercase e user-dirs.conf (enabled=False) configurados."
}

# --- 5. ZSH, Yazi Padrão, LazyVim Sync ---
setup_shell_and_tools() {
    # Oh My Zsh + plugins (caso os dotfiles do zsh referenciem ~/.oh-my-zsh)
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "Instalando Oh My Zsh..."
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    fi
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    [ -d "${zsh_custom}/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "${zsh_custom}/plugins/zsh-autosuggestions"
    [ -d "${zsh_custom}/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${zsh_custom}/plugins/zsh-syntax-highlighting"
    [ -d "${zsh_custom}/plugins/fzf-tab" ] || git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git "${zsh_custom}/plugins/fzf-tab"

    if has_cmd zsh; then
        local zsh_path
        zsh_path=$(command -v zsh)
        if [ "${SHELL:-}" != "$zsh_path" ]; then
            info "Definindo zsh ($zsh_path) como shell padrão..."
            sudo chsh -s "$zsh_path" "$USER" 2>/dev/null || chsh -s "$zsh_path" 2>/dev/null || warn "Não foi possível alterar shell via chsh."
        fi
        ok "Shell ZSH configurado."
    fi

    # yazi.desktop como file manager padrão (quando aplicável)
    local yazi_desktop=""
    if [ -f /usr/share/applications/yazi.desktop ]; then
        yazi_desktop="/usr/share/applications/yazi.desktop"
    elif has_cmd yazi; then
        mkdir -p "$HOME/.local/share/applications"
        cat > "$HOME/.local/share/applications/yazi.desktop" << EOF
[Desktop Entry]
Name=Yazi
Comment=Blazing fast terminal file manager
Exec=kitty -e $BIN_DIR/yazi %u
Terminal=false
Type=Application
MimeType=inode/directory;
Categories=System;FileManager;
EOF
        yazi_desktop="$HOME/.local/share/applications/yazi.desktop"
    fi

    if has_cmd xdg-mime && [ -n "$yazi_desktop" ]; then
        info "Definindo yazi.desktop como gerenciador de arquivos padrão..."
        xdg-mime default yazi.desktop inode/directory 2>/dev/null || true
        ok "yazi.desktop configurado como padrão para inode/directory."
    fi

    # LazyVim sync headless
    if has_cmd nvim && [ -f "$HOME/.config/nvim/init.lua" ]; then
        info "Sincronizando plugins do Neovim (LazyVim) em modo headless..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "Lazy sync headless retornou aviso."
        ok "Neovim sincronizado."
    fi
}

# --- 6. Desktop Wayland / Hyprland (Opcional no Ubuntu 26.04 Nativo) ---
setup_desktop_ubuntu() {
    if [ "$IS_WSL" = true ] && [ "$WITH_DESKTOP" = false ]; then
        info "Módulo desktop pulado no WSL (perfil: $PROFILE)."
        return 0
    fi

    if [ "$PROFILE" != "full" ] && [ "$WITH_DESKTOP" = false ]; then
        info "Módulo desktop pulado no perfil $PROFILE."
        return 0
    fi

    info "Verificando suporte opcional a Wayland/Hyprland no Ubuntu 26.04 nativo..."
    warn "Nota de paridade Arch vs Ubuntu: no Arch/CachyOS toda a stack Hyprland + AUR (hyprlock, hypridle, wallust, walker, temas SDDM) é nativa."
    warn "No Ubuntu 26.04, serão instalados apenas os pacotes Wayland disponíveis nos repositórios APT oficiais:"

    apt_install_available \
        hyprland \
        waybar \
        wofi \
        rofi \
        swaync \
        dunst \
        swaybg \
        wl-clipboard \
        grim \
        slurp \
        kitty \
        alacritty \
        playerctl \
        brightnessctl \
        pavucontrol \
        network-manager-gnome \
        xdg-desktop-portal-hyprland \
        xdg-desktop-portal-wlr \
        fonts-jetbrains-mono \
        fonts-firacode

    warn "Ferramentas exclusivas do ecossistema Arch/AUR (ex: wallust, walker, sddm-astronaut-theme) não estão no APT padrão do Ubuntu e precisam de build manual/Cargo caso desejadas."
    ok "Etapa desktop Ubuntu concluída."
}

main() {
    case "$STEP" in
        system)
            setup_apt_base
            ;;
        cli)
            setup_modern_cli
            ;;
        dev-stack)
            setup_dev_stack
            ;;
        dotfiles)
            setup_dotfiles_and_dirs
            ;;
        zsh)
            setup_shell_and_tools
            ;;
        desktop)
            setup_desktop_ubuntu
            ;;
        all|*)
            setup_apt_base
            setup_modern_cli
            setup_dev_stack
            setup_dotfiles_and_dirs
            setup_shell_and_tools
            setup_desktop_ubuntu
            ;;
    esac

    ok "Setup Ubuntu 26.04 finalizado com sucesso!"
}

main "$@"
